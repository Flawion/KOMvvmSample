//
//  LogService.swift
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
import Alamofire

enum LogDataModes {
    case simplified
    case simplifiedAboveLimit
    case full
    case none
}

final class LogService {
    // MARK: Variables
    private let startRequestSymbol = "🔜"
    private let endRequestSymbol = "🔚"
    private let errorSymbol = "❗️"
    private let validationSuccessSymbol = "✅"
    private let validationFailureSymbol = "⛔️"

    private let isEnabled: Bool
    private let logDataMode: LogDataModes
    private let logDataSimplifiedAboveLimit: Int = 12000

    static let shared = {
        return LogService()
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
        var logStr: [String] = [String(format: "%@Start request", startRequestSymbol)]
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

        //tries to get information from ApiErrorContainer
        let apiError = error as? ApiErrorContainer
        let response = response ?? apiError?.response
        let data = data ?? (apiError?.data as? Data)

        var logStr: [String] = [String(format: "%@End request", endRequestSymbol)]
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
extension LogService {
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

    private func headersToLog(_ headers: [AnyHashable: Any]?) -> String? {
        guard let headers = headers, headers.count > 0 else {
            return nil
        }
        return String(format: "%@Headers: %@", headersSymbol, headers)
    }

    private func dataToLog(_ data: Data?, mappedData: LogDataRecudible? = nil, encoding: String.Encoding = .utf8) -> String? {
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
        return dataStr
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
        return String(format: "%@Error: %@", errorSymbol, error.localizedDescription)
    }

    private func statusCodeToLog(_ statusCode: Int?) -> String? {
        guard let statusCode = statusCode else {
            return nil
        }
        let success = 200 ... 299 ~= statusCode
        return String(format: "%@StatusCode: %d", success ? statusCodeSymbolSuccess : statusCodeSymbolFailure, statusCode)
    }
}
