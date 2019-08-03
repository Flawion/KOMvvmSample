//
//  DataStoreService.swift
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
            fileDirectoryURL = try FileManager.default.url(for: .applicationDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
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
