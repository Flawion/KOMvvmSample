//
//  DataStoreService.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

struct DataStoreServiceBuilder: ServiceBuilderProtocol {
    var type: ServiceTypes {
        return .dataStore
    }

    func createService(withServiceLocator serviceLocator: ServiceLocator) -> Any {
        return DataStoreService()
    }
}

protocol DataStoreServiceProtocol: NSObject {
    var platforms: [PlatformModel]? {get set}
    var savePlatformsDate: Date? {get }
}

// MARK: - DataStoreService
final class DataStoreService: NSObject {
    // MARK: - Variables
    private let fileDirectoryURL: URL

    private let platformsKey: String = "platformsKey"
    private let savePlatformsDateKey: String = "savePlatformsDateKey"

    override init() {
        do {
            fileDirectoryURL = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    // MARK: - Private helpers functions
    private func setSavePlatformsDate(_ date: Date?) {
        UserDefaults.standard.set(date, forKey: savePlatformsDateKey)
    }

    // MARK: Loading / saving from UserDefaults
    private func loadObject<T: Decodable>(forKey key: String) -> T? {
        guard let data = UserDefaults.standard.object(forKey: key) as? Data else {
            return nil
        }
        return unarchiveObjectFromData(data)
    }

    private func saveObject<T: Encodable>(_ object: T?, forKey key: String) -> Bool {
        guard let object = object else {
            UserDefaults.standard.removeObject(forKey: key)
            return true
        }
        guard let data = archiveObjectToData(objToArchive: object) else {
            return false
        }
        UserDefaults.standard.set(data, forKey: key)
        return true
    }

    // MARK: Loading / saving from files
    private func loadObjectFromFile<T: Decodable>(forKey key: String) -> T? {
        let fileURL = self.fileURL(forKey: key)
        guard FileManager.default.fileExists(atPath: fileURL.path), let data = try? Data(contentsOf: fileURL) else {
            return nil
        }
        return unarchiveObjectFromData(data)
    }

    private func saveObjectToFile<T: Encodable>(_ object: T?, forKey key: String) -> Bool {
        let fileURL = self.fileURL(forKey: key)
        guard let object = object else {
            if FileManager.default.fileExists(atPath: fileURL.path) {
                try? FileManager.default.removeItem(at: fileURL)
            }
            return true
        }
        guard let data = archiveObjectToData(objToArchive: object) else {
            return false
        }

        do {
            try data.write(to: fileURL)
            return true
        } catch {
            return false
        }
    }

    private func fileURL(forKey key: String) -> URL {
        return URL(fileURLWithPath: String(format: "%@.dat", key), relativeTo: fileDirectoryURL)
    }

    // MARK: Archive/unarchive
    private func archiveObjectToData<T: Encodable>(objToArchive: T) -> Data? {
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(objToArchive)
            return data
        } catch {
        }
        return nil
    }

    private func unarchiveObjectFromData<T: Decodable>(_ dataToUnarchive: Data) -> T? {
        do {
            let decoder = PropertyListDecoder()
            return try decoder.decode(T.self, from: dataToUnarchive)
        } catch {
        }
        return nil
    }

    private func containsKey(_ key: String) -> Bool {
        return UserDefaults.standard.dictionaryRepresentation().keys.contains(key)
    }
}

// MARK: - DataStoreServiceProtocol
extension DataStoreService: DataStoreServiceProtocol {
    var platforms: [PlatformModel]? {
        get {
            return loadObjectFromFile(forKey: platformsKey)
        }
        set {
            _ = saveObjectToFile(newValue, forKey: platformsKey)
            setSavePlatformsDate(newValue != nil ? Date() : nil)
        }
    }

    var savePlatformsDate: Date? {
        return UserDefaults.standard.object(forKey: savePlatformsDateKey) as? Date
    }
}
