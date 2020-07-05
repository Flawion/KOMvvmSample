//
//  PlatformsUseCase.swift
//  KOMvvmSample
//
//  Created by Kuba Ostrowski on 05/07/2020.
//

import Foundation
import RxSwift
import RxCocoa

final class PlatformsUseCase: BaseDataController {
    // MARK: Variables
    private var giantBombClient: GiantBombClientServiceProtocol!
    private var dataStore: DataStoreServiceProtocol!
    
    private var platformsRelay: BehaviorRelay<[PlatformModel]> =  BehaviorRelay<[PlatformModel]>(value: [])
    private var downloadPlatformsSharedObservable: Observable<Void>?
    private var allPlatformsCached: Bool = false
    private var downloadPlatformsDisposeBag: DisposeBag!
    
    var platformsDriver: Driver<[PlatformModel]> {
        return platformsRelay.asDriver()
    }
    
    var platforms: [PlatformModel] {
        return platformsRelay.value
    }
    
    // MARK: Functions
    init(giantBombClient: GiantBombClientServiceProtocol, dataStore: DataStoreServiceProtocol) {
        self.giantBombClient = giantBombClient
        self.dataStore = dataStore
        super.init()
        loadFromDataService()
    }
    
    private func loadFromDataService() {
        guard !allPlatformsCached, let savePlatformsDate = dataStore.savePlatformsDate, Calendar.current.dateComponents([.minute], from: savePlatformsDate, to: Date()).minute ?? 0 < AppSettings.Platforms.cacheOnDiscForMinutes, let platforms = dataStore.platforms, platforms.count > 0 else {
            return
        }
        allPlatformsCached = true
        platformsRelay.accept(platforms)
    }
    
    var downloadPlatformsIfNeedObservable: Observable<Void> {
        downloadPlatformsIfNeed()
        if allPlatformsCached {
            return Observable<Void>.just(())
        }
        return downloadPlatformsSharedObservable ?? Observable<Void>.error(ApiErrors.validation)
    }
    
    func downloadPlatformsIfNeed() {
        guard !allPlatformsCached, dataActionState != .loading else {
            return
        }
        downloadPlatformsDisposeBag = DisposeBag()
        downloadPlatformsSharedObservable = startDownloadPlatformsUntilAll().share()
        downloadPlatformsSharedObservable?.subscribe().disposed(by: downloadPlatformsDisposeBag!)
    }
    
    private func startDownloadPlatformsUntilAll() -> Observable<Void> {
        dataActionState = .loading
        return downloadPlatformsUntilAll(startOffset: platformsRelay.value.count, limit: AppSettings.Platforms.limitPerRequest)
            .doOnce({ [weak self] (_, error)  in
                guard let self = self else {
                    return
                }
                self.downloadPlatformsSharedObservable = nil
                self.dataActionState = error != nil ? .error : .none
            })
    }
    
    private func downloadPlatformsUntilAll(startOffset: Int, limit: Int) -> Observable<Void> {
        //gets a part of platforms from one request
        return giantBombClient.platforms(offset: startOffset, limit: limit)
            .flatMapLatest({ [weak self](result, data) -> Observable<Void>  in
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
        var cachedPlatforms = platformsRelay.value
        cachedPlatforms.append(contentsOf: platforms)
        platformsRelay.accept(cachedPlatforms)
    }
    
    private func downloadNextPlatformsOrComplete(numberOfTotalResults: Int) -> Observable<Void> {
        guard platformsRelay.value.count >= numberOfTotalResults else {
            return downloadPlatformsUntilAll(startOffset: self.platformsRelay.value.count, limit: AppSettings.Platforms.limitPerRequest)
        }
        downloadAllPlatformsCompleted()
        return Observable<Void>.just(())
    }
    
    private func downloadAllPlatformsCompleted() {
        allPlatformsCached = true
        dataStore.platforms = platformsRelay.value
    }
}
