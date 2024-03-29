//
//  Logger.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation
import Alamofire

enum LogDataModes {
    case simplified
    case simplifiedAboveLimit
    case full
    case none
}

final class Logger {
    // MARK: Variables
    private let startRequestSymbol = "➡️"
    private let endRequestSymbol = "⬅️"
    private let errorSymbol = "❗️"
    private let validationSuccessSymbol = "✅"
    private let validationFailureSymbol = "⛔️"

    private let isEnabled: Bool
    private let logDataMode: LogDataModes
    private let logDataSimplifiedAboveLimit: Int = 12000

    static let shared = {
        return Logger()
    }()

    // MARK: Functions
    private init() {
        logDataMode = .simplifiedAboveLimit
        
        #if DEBUG
        isEnabled = true
        #else
        isEnabled = false
        #endif
    }

    func log(_ request: Request) {
        guard isEnabled else {
            return
        }

        guard let urlRequest = request.request else {
            return
        }
        var logStr: [Any] = [String(format: "%@Start request", startRequestSymbol)]
        logStr.appendIfNotNull([
            urlToLog(urlRequest.url),
            headersToLog(urlRequest.allHTTPHeaderFields),
            dataToLog(urlRequest.httpBody)
            ])
        self.log(logStr)
    }

    func log(_ response: HTTPURLResponse?, data: Data?, mappedData: LogDataRecudible? = nil, error: Error?) {
        guard isEnabled else {
            return
        }

        // tries to get information from ApiErrorContainer
        let appError = error as? AppError
        let response = response ?? appError?.userInfo[AppError.UserInfoKeys.apiResponse.rawValue] as? HTTPURLResponse
        let data = data ?? appError?.userInfo[AppError.UserInfoKeys.apiResponse.rawValue] as? Data

        var logStr: [Any] = [String(format: "%@End request", endRequestSymbol)]
        logStr.appendIfNotNull([
            urlToLog(response?.url),
            headersToLog(response?.allHeaderFields),
            errorToLog(error),
            statusCodeToLog(response?.statusCode),
            dataToLog(data, mappedData: mappedData)
            ])
        self.log(logStr)
    }

    func logValidateSucccess(_ response: HTTPURLResponse?) {
        guard isEnabled else {
            return
        }

        var logStr: [String] = [String(format: "%@Validate request success", validationSuccessSymbol)]
        logStr.appendIfNotNull([
            urlToLog(response?.url)
        ])
        self.log(logStr)
    }

    func logValidateFailure(_ response: HTTPURLResponse?) {
        guard isEnabled else {
            return
        }

        var logStr: [String] = [String(format: "%@Validate request failure", validationFailureSymbol)]
        logStr.appendIfNotNull([
            urlToLog(response?.url)
            ])
        self.log(logStr)
    }

    func log<T>(_ items: T, separator: String = ", ", terminator: String = "\n") {
        guard isEnabled else {
            return
        }

        print(items, separator: separator, terminator: terminator)
    }
}

// MARK: - Data to log string
extension Logger {
    private var statusCodeSymbolSuccess: String {
        return "💚"
    }

    private var statusCodeSymbolFailure: String {
        return "❤️"
    }

    private var urlSymbol: String {
        return "🌐"
    }

    private var dataSymbol: String {
        return "🗂"
    }

    private var headersSymbol: String {
        return "📒"
    }

    private func urlToLog(_ url: URL?) -> String? {
        guard let url = url?.absoluteString else {
            return nil
        }
        return String(format: "%@URL: %@", urlSymbol, url)
    }

    private func headersToLog(_ headers: [AnyHashable: Any]?) -> NSString? {
        guard let headers = headers, headers.count > 0 else {
            return nil
        }
        // NSString remove special chars - so it is need to be used here to create more readable logs
        return NSString(format: "%@Headers: %@", headersSymbol, headers)
    }

    private func dataToLog(_ data: Data?, mappedData: LogDataRecudible? = nil, encoding: String.Encoding = .utf8) -> NSString? {
        guard logDataMode != .none, let data = data else {
            return nil
        }

        var dataStr = String(format: "%@Data: ", dataSymbol)

        switch logDataMode {
        case .simplified:
            dataStr += dataToLogSimplified(mappedData: mappedData)

        case .simplifiedAboveLimit:
           dataStr += dataToLogSimplifiedAboveLimit(data: data, mappedData: mappedData, encoding: encoding)

        case .full:
            dataStr += dataToLogFull(data: data, orginalDataBytes: data.count, encoding: encoding)

        default:
            return nil
        }
        // NSString remove special chars - so it is need to be used here to create more readable logs
        return NSString(string: dataStr)
    }

    private func dataToLogSimplified(mappedData: LogDataRecudible?) -> String {
        return mappedData?.reducedLogData() ?? "not null"
    }

    private func dataToLogSimplifiedAboveLimit(data: Data, mappedData: LogDataRecudible? = nil, encoding: String.Encoding) -> String {
        let orginalDataBytes = data.count
        guard data.count > logDataSimplifiedAboveLimit else {
            return dataToLogFull(data: data, orginalDataBytes: orginalDataBytes, encoding: encoding)
        }
        if let reducedData = mappedData?.reducedLogData() {
            return String(format: "%@%@", reducedData, infoAboutReducedLogData(dataBytes: data.count))
        }
        return dataToLogFull(data: data.subdata(in: data.startIndex ..< data.startIndex.advanced(by: logDataSimplifiedAboveLimit)), orginalDataBytes: orginalDataBytes, encoding: encoding)
    }

    private func dataToLogFull(data: Data, orginalDataBytes: Int, encoding: String.Encoding) -> String {
        guard let dataEncoded = String(data: data, encoding: encoding) else {
            return "not null, \(encoding) encoding error"
        }

        var dataStr: String = dataEncoded
        if orginalDataBytes > data.count {
            dataStr += infoAboutReducedLogData(dataBytes: orginalDataBytes)
        }
        return dataStr
    }

    private func infoAboutReducedLogData(dataBytes: Int) -> String {
        switch logDataMode {
        case .simplified:
            return "... data reduced (bytes: \(dataBytes)"
            
        case .simplifiedAboveLimit:
            return " ...data reduced (bytes above limit: \(dataBytes - logDataSimplifiedAboveLimit))"
            
        default:
            return ""
        }
    }

    private func errorToLog(_ error: Error?) -> String? {
        guard let error = error else {
            return nil
        }
        return String(format: "%@Error: %@", errorSymbol, error as NSError)
    }

    private func statusCodeToLog(_ statusCode: Int?) -> String? {
        guard let statusCode = statusCode else {
            return nil
        }
        let success = 200 ... 299 ~= statusCode
        return String(format: "%@StatusCode: %d", success ? statusCodeSymbolSuccess : statusCodeSymbolFailure, statusCode)
    }
}
