//
//  DataStoreService.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

protocol DataStoreServiceProtocol: NSObject {
    var platforms: [PlatformModel]? {get set}
    var savePlatformsDate: Date? { get }
}

// MARK: - DataStoreService
final class DataStoreService: NSObject {
    
    private enum Keys: String {
        case platforms
        case savePlatformsDate
    }
    
    // MARK: - Variables
    private let fileDirectoryURL: URL
   
    override init() {
        do {
            fileDirectoryURL = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    // MARK: - Private helpers functions
    private func setSavePlatformsDate(_ date: Date?) {
        UserDefaults.standard.set(date, forKey: Keys.savePlatformsDate.rawValue)
    }

    // MARK: Loading / saving from UserDefaults
    private func loadObject<T: Decodable>(forKey key: Keys) -> T? {
        return loadObject(forKey: key.rawValue)
    }
    
    private func loadObject<T: Decodable>(forKey key: String) -> T? {
        guard let data = UserDefaults.standard.object(forKey: key) as? Data else {
            return nil
        }
        return unarchiveObjectFromData(data)
    }

    private func saveObject<T: Encodable>(_ object: T?, forKey key: Keys) -> Bool {
        saveObject(object, forKey: key.rawValue)
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
    private func loadObjectFromFile<T: Decodable>(forKey key: Keys) -> T? {
        return loadObjectFromFile(forKey: key.rawValue)
    }
    
    private func loadObjectFromFile<T: Decodable>(forKey key: String) -> T? {
        let fileURL = self.fileURL(forKey: key)
        guard FileManager.default.fileExists(atPath: fileURL.path), let data = try? Data(contentsOf: fileURL) else {
            return nil
        }
        return unarchiveObjectFromData(data)
    }

    private func saveObjectToFile<T: Encodable>(_ object: T?, forKey key: Keys) -> Bool {
        saveObjectToFile(object, forKey: key.rawValue)
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

    private func fileURL(forKey key: Keys) -> URL {
        return fileURL(forKey: key.rawValue)
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

    private func containsKey(_ key: Keys) -> Bool {
        return containsKey(key.rawValue)
    }
    
    private func containsKey(_ key: String) -> Bool {
        return UserDefaults.standard.dictionaryRepresentation().keys.contains(key)
    }
}

// MARK: - DataStoreServiceProtocol
extension DataStoreService: DataStoreServiceProtocol {
    var platforms: [PlatformModel]? {
        get {
            return loadObjectFromFile(forKey: .platforms)
        }
        set {
            _ = saveObjectToFile(newValue, forKey: .platforms)
            setSavePlatformsDate(newValue != nil ? Date() : nil)
        }
    }

    var savePlatformsDate: Date? {
        return UserDefaults.standard.object(forKey: Keys.savePlatformsDate.rawValue) as? Date
    }
}

// MARK: - For test purpose
final class TestUserDefaultObject: Codable {
    let name: String
    let value: String
    let age: Int
    
    init(name: String, value: String, age: Int) {
        self.name = name
        self.value = value
        self.age = age
    }
}

protocol TestDataStoreServiceProtocol: NSObject {
    var testUserDefaultObject: TestUserDefaultObject? { get set }
    var testUserDefaultBool: Bool? { get set }
}

extension DataStoreService: TestDataStoreServiceProtocol {
    var testUserDefaultObjectKey: String {
        return "testUserDefaultObjectKey"
    }
    
    var testUserDefaultBoolKey: String {
        return "testUserDefaultBoolKey"
    }
    
    var testUserDefaultObject: TestUserDefaultObject? {
        get {
            return loadObject(forKey: testUserDefaultObjectKey)
        }
        set {
            _ = saveObject(newValue, forKey: testUserDefaultObjectKey)
        }
    }
    
    var testUserDefaultBool: Bool? {
        get {
            guard containsKey(testUserDefaultBoolKey) else {
                return nil
            }
            return UserDefaults.standard.bool(forKey: testUserDefaultBoolKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: testUserDefaultBoolKey)
        }
    }
}
