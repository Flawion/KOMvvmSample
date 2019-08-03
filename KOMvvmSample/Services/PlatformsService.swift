//
//  PlatformsService.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
import RxSwift
import RxCocoa

struct PlatformsServiceBuilder: ServiceBuilderProtocol {
    var type: ServiceTypes {
        return .platforms
    }

    func createService(withServiceLocator serviceLocator: ServiceLocator) -> Any {
        guard let giantBombClient: GiantBombClientServiceProtocol = serviceLocator.get(type: .giantBombApiClient), let dataStore: DataStoreServiceProtocol = serviceLocator.get(type: .dataStore) else {
            fatalError("PlatformsServiceBuilder can't get services")
        }
        return PlatformsService(giantBombClient: giantBombClient, dataStore: dataStore)
    }
}

protocol PlatformsServiceProtocol: NSObject {
    var isDownloadingDriver: Driver<Bool> { get }
    var isDownloading: Bool { get }

    /// Refreshes platforms and returns "true" if they are available
    var refreshPlatformsObser: Observable<Bool> { get }

    /// Always use 'refreshPlatformsObser' or 'refreshPlatforms' before this variable, to fill the data
    var platformsObser: Observable<[PlatformModel]> { get }

    /// Always use 'refreshPlatformsObser' or 'refreshPlatforms' before this variable, to fill the data
    var platforms: [PlatformModel] { get }

    func refreshPlatforms()
}

// MARK: - PlatformsService
final class PlatformsService: NSObject {
    // MARK: Variables
    private var giantBombClient: GiantBombClientServiceProtocol!
    private var dataStore: DataStoreServiceProtocol!
    private var downloadPlatformsUntilAllSharedObser: Observable<Bool>?
    private var platformsVar: BehaviorRelay<[PlatformModel]> =  BehaviorRelay<[PlatformModel]>(value: [])
    private var allPlatformsCached: Bool = false
    private var refreshPlatformsDisposeBag: DisposeBag!

    private var isDownloadingVar: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)

    // MARK: Functions
    init(giantBombClient: GiantBombClientServiceProtocol, dataStore: DataStoreServiceProtocol) {
        self.giantBombClient = giantBombClient
        self.dataStore = dataStore
    }

    private func redownloadAllPlatfroms() -> Observable<Bool> {
        guard let sharedObser = downloadPlatformsUntilAllSharedObser else {
            return startDownloadPlatformsUntilAll()
        }
        return sharedObser
    }
    
    private func startDownloadPlatformsUntilAll() -> Observable<Bool> {
        isDownloadingVar.accept(true)
        downloadPlatformsUntilAllSharedObser = downloadPlatformsUntilAll(startOffset: platformsVar.value.count, limit: AppSettings.Platforms.limitPerRequest)
            .doOnce({ [weak self] _, _  in
                guard let self = self else {
                    return
                }
                self.downloadPlatformsUntilAllSharedObser = nil
                self.isDownloadingVar.accept(false)
            }).share()
        return downloadPlatformsUntilAllSharedObser!
    }

    private func downloadPlatformsUntilAll(startOffset: Int, limit: Int) -> Observable<Bool> {
        //gets a part of platforms from one request
        return giantBombClient.platforms(offset: startOffset, limit: limit)
            .flatMapLatest({ [weak self](result, data) -> Observable<Bool>  in
                guard let self = self, let responseData = data else {
                    throw ApiErrorContainer(response: result, data: data, originalError: ApiErrors.validation)
                }

                self.storePlatforms(responseData.results)
                return self.downloadNextPlatformsOrComplete(numberOfTotalResults: responseData.numberOfTotalResults)
            })
    }
    
    private func storePlatforms(_ platforms: [PlatformModel]?) {
        guard let platforms = platforms else {
            return
        }
        var cachedPlatforms = platformsVar.value
        cachedPlatforms.append(contentsOf: platforms)
        platformsVar.accept(cachedPlatforms)
    }
    
    private func downloadNextPlatformsOrComplete(numberOfTotalResults: Int) -> Observable<Bool> {
        guard platformsVar.value.count >= numberOfTotalResults else {
            return self.downloadPlatformsUntilAll(startOffset: self.platformsVar.value.count, limit: AppSettings.Platforms.limitPerRequest)
        }
        self.downloadAllPlatformsCompleted()
        return Observable<Bool>.just(self.platformsVar.value.count > 0)
    }

    private func downloadAllPlatformsCompleted() {
        allPlatformsCached = true
        dataStore.platforms = platformsVar.value
    }
    
    private func loadFromDataService() {
        guard !allPlatformsCached, let savePlatformsDate = dataStore.savePlatformsDate, Calendar.current.dateComponents([.minute], from: savePlatformsDate, to: Date()).minute ?? 0 < AppSettings.Platforms.cacheOnDiscForMinutes, let platforms = dataStore.platforms, platforms.count > 0 else {
            return
        }
        allPlatformsCached = true
        platformsVar.accept(platforms)
    }
}

// MARK: - PlatformsServiceProtocol
extension PlatformsService: PlatformsServiceProtocol {
    var isDownloadingDriver: Driver<Bool> {
        return isDownloadingVar.asDriver()
    }

    var isDownloading: Bool {
        return isDownloadingVar.value
    }

    var refreshPlatformsObser: Observable<Bool> {
        loadFromDataService()

        if allPlatformsCached {
            return Observable<Bool>.just(platformsVar.value.count > 0)
        }
        return redownloadAllPlatfroms()
    }

    var platformsObser: Observable<[PlatformModel]> {
        return platformsVar.asObservable()
    }

    var platforms: [PlatformModel] {
        return platformsVar.value
    }

    func refreshPlatforms() {
        guard !isDownloading else {
            return
        }
        refreshPlatformsDisposeBag = DisposeBag()
        refreshPlatformsObser.subscribe().disposed(by: refreshPlatformsDisposeBag!)
    }
}
