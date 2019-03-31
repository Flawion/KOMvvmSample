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

final class PlatformsService {
    // MARK: Variables
    static let shared = {
        return PlatformsService()
    }()
    
    /// Creates instance of class for unit tests
    static var test: PlatformsService {
        return PlatformsService()
    }

    private var downloadPlatformsUntilAllSharedObser: Observable<Bool>?

    private var platformsVar: BehaviorRelay<[PlatformModel]> =  BehaviorRelay<[PlatformModel]>(value: [])
    private var allPlatformsCached: Bool = false
    private var refreshPlatformsDisposeBag: DisposeBag!

    private var isDownloadingVar: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)

    var isDownloadingDriver: Driver<Bool> {
        return isDownloadingVar.asDriver()
    }
    
    var isDownloading: Bool {
        return isDownloadingVar.value
    }

    /// Refreshes platforms and returns "true" if they are available
    var refreshPlatformsObser: Observable<Bool> {
        loadFromDataService()

        //if all cached just return
        if allPlatformsCached {
            return Observable<Bool>.just(platformsVar.value.count > 0)
        }
        return redownloadAllPlatfroms()
    }

    /// Always use 'refreshPlatformsObser' or 'refreshPlatforms' before this variable, to fill the data
    var platformsObser: Observable<[PlatformModel]> {
        return platformsVar.asObservable()
    }

    /// Always use 'refreshPlatformsObser' or 'refreshPlatforms' before this variable, to fill the data
    var platforms: [PlatformModel] {
        return platformsVar.value
    }

    func refreshPlatforms() {
        refreshPlatformsDisposeBag = DisposeBag()
        refreshPlatformsObser.subscribe().disposed(by: refreshPlatformsDisposeBag!)
    }

    // MARK: Private functions
    private init() {}

    private func redownloadAllPlatfroms() -> Observable<Bool> {
        guard let sharedObser = downloadPlatformsUntilAllSharedObser else {
            isDownloadingVar.accept(true)
            downloadPlatformsUntilAllSharedObser = downloadPlatformsUntilAll(startOffset: platformsVar.value.count, limit: ApplicationSettings.Platforms.limitPerRequest)
                .doOnce({ [unowned self] _, _  in
                    self.downloadPlatformsUntilAllSharedObser = nil
                    self.isDownloadingVar.accept(false)
                }).share()
            return downloadPlatformsUntilAllSharedObser!
        }
        return sharedObser
    }

    private func downloadPlatformsUntilAll(startOffset: Int, limit: Int) -> Observable<Bool> {
        //gets a part of platforms from one request
        return ApiClientService.giantBomb.platforms(offset: startOffset, limit: limit)
            .flatMapLatest({ [unowned self](result, data)  -> Observable<Bool>  in
                guard let responseData = data else {
                    throw ApiErrorContainer(response: result, data: data, originalError: ApiErrors.validation)
                }

                //gets all results from request
                if let platforms = responseData.results {
                    var cachedPlatforms = self.platformsVar.value
                    cachedPlatforms.append(contentsOf: platforms)
                    self.platformsVar.accept(cachedPlatforms)
                }

                //checks if get all platfroms
                guard self.platformsVar.value.count >= responseData.numberOfTotalResults else {
                    //gets next part
                    return self.downloadPlatformsUntilAll(startOffset: self.platformsVar.value.count, limit: ApplicationSettings.Platforms.limitPerRequest)
                }
                self.downloadAllPlatformsCompleted()
                return Observable<Bool>.just(self.platformsVar.value.count > 0)
            })
    }

    private func loadFromDataService() {
        guard !allPlatformsCached, let savePlatformsDate = DataService.shared.savePlatformsDate, Calendar.current.dateComponents([.minute], from: savePlatformsDate, to: Date()).minute ?? 0 < ApplicationSettings.Platforms.cacheOnDiscForMinutes, let platforms = DataService.shared.platforms, platforms.count > 0 else {
            return
        }
        allPlatformsCached = true
        platformsVar.accept(platforms)
    }

    private func downloadAllPlatformsCompleted() {
        allPlatformsCached = true
        DataService.shared.platforms = platformsVar.value
    }
}
