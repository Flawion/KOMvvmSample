//
//  ApiClient.swift
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
import RxSwift
import RxAlamofire

/// Base client that need to be inhertited by targets api
class BaseApiClient {
    // MARK: Variables
    private(set) var urlBuilder: URLBuilder!
    private(set) var sessionManager: SessionManager!
    private(set) var mockDataContainer: ApiMockDataContainer = ApiMockDataContainer()

    // MARK: Variables that will be used for mock data responses
    var mockSimulateFail: Bool = false
    var mockErrorStatusCode: Int = 500
    var mockErrorData: Data = Data()

    init() {
        urlBuilder = URLBuilder(apiAddress: apiAddress, apiVersion: apiVersion)
        sessionManager = createSessionManager()
    }
    
    // MARK: To override by child classes
    var apiAddress: String {
        fatalError("Subclasses need to implement the `apiAddress` method.")
    }
    
    var apiVersion: String? {
        return nil
    }
    
    /// Session manager for all reuqests
    ///
    /// - Returns: session manager
    func createSessionManager() -> SessionManager {
        return SessionManager()
    }
    
    /// Default headers that will be added to all requests, one of them can be an authorization token etc.
    ///
    /// - Returns: headers
    func createDefaultHeaders() -> [String: String]? {
        return nil
    }
    
    /// Default parameters that will be added to all requests,one of them can be an authorization token etc.
    ///
    /// - Returns: parameters
    func createDefaultParameters() -> [String: Any]? {
        return nil
    }
    
    /// Return default encoding for http method
    ///
    /// - Parameter method: http method that will be used in request
    /// - Returns: default encoding
    func defaultEncoding(forMethod method: HTTPMethod) -> ParameterEncoding {
        return method == .get ? URLEncoding.default : JSONEncoding.default
    }

    /// Default way to map the data to the target format (e.g.. from Data to Json)
    ///
    /// - Returns: default mapper
    func defaultDataMapper() -> ApiDataMapperProtocol {
        return ApiDataToJsonMapper.default
    }
    
    // MARK: Validations of request and data
    func validate(response: HTTPURLResponse, data: Any?)throws {
        if !(200 ... 299 ~= response.statusCode) || data == nil {
            LogService.shared.logValidateFailure(response)
            try throwError(forResponse: response, data: data, originalError: ApiErrors.validation)
        } else {
            LogService.shared.logValidateSucccess(response)
        }
    }
    
    func validate<DataType>(responseData: Observable<(HTTPURLResponse, DataType)>, ifNeed needToValidate: Bool) -> Observable<(HTTPURLResponse, DataType)> {
        guard needToValidate else {
            return responseData
        }
        return responseData.do(onNext: { [weak self](response: HTTPURLResponse, data: DataType) in
            guard let self = self else {
                return
            }
            try self.validate(response: response, data: data)
        })
    }
    
    func throwError(forResponse response: HTTPURLResponse, data: Any?, originalError: Error)throws {
        throw ApiErrorContainer(response: response, data: data, originalError: originalError)
    }
    
    // MARK: Api mock requests
    private func requestMockData(parameters: ApiRequestParameters, delay: Double = 0.1) -> Observable<(HTTPURLResponse, Data)> {
        var responseStatusCode = mockErrorStatusCode
        
        //tries to load data
        var data: Data = mockErrorData
        if !mockSimulateFail, let loadedData = mockDataContainer.loadMockData(forRequestParameters: parameters) {
            data = loadedData
            responseStatusCode = 200
        }
        
        //creates response
        let response = HTTPURLResponse(url: parameters.url, statusCode: responseStatusCode, httpVersion: nil, headerFields: nil)!
        return Observable<(HTTPURLResponse, Data)>.just((response, data)).delay(delay, scheduler: MainScheduler.instance)
    }
    
    func responseMockData(parameters: ApiRequestParameters, delay: Double = 0.1, validate validateResponse: Bool = true) -> Observable<(HTTPURLResponse, Data)> {
        let dataResponse = requestMockData(parameters: parameters, delay: delay)
            .doOnce ({ (response, error) in
                LogService.shared.log(response?.0, data: response?.1, error: error)
            })
        return validate(responseData: dataResponse, ifNeed: validateResponse)
    }
    
    func responseMockMapped<MapTo: Codable>(parameters: ApiRequestParameters, mapper: ApiDataMapperProtocol? = nil, delay: Double = 0.1, validate validateResponse: Bool = true) -> Observable<(HTTPURLResponse, MapTo?)> {
        let dataResponse = requestMockData(parameters: parameters, delay: delay)
            .map ({ [weak self] (response: HTTPURLResponse, data: Data) -> (HTTPURLResponse, Data, MapTo?) in
                guard let self = self else {
                    return (response, data, nil)
                }
                
                var mappedData: MapTo?
                do {
                    mappedData = try (mapper ?? self.defaultDataMapper()).mapTo(data: data)
                } catch {
                    try self.throwError(forResponse: response, data: data, originalError: error)
                }
                return (response, data, mappedData)
            })
            .doOnce ({ (response, error) in
                LogService.shared.log(response?.0, data: response?.1, mappedData: response?.2 as? LogDataRecudible, error: error)
            })
            .map({ (response: HTTPURLResponse, _: Data, mappedData: MapTo?) -> (HTTPURLResponse, MapTo?) in
                return (response, mappedData)
            })
        
        return validate(responseData: dataResponse, ifNeed: validateResponse)
    }
    
    // MARK: Api requests in session
    private func requestData(parameters: ApiRequestParameters) -> Observable<DataRequest> {
        var requestHeaders = createDefaultHeaders() ?? [:]
        var requestParameters = createDefaultParameters() ?? [:]

        //adds additionals headers
        if let additionalsHeaders = parameters.headers {
            for header in additionalsHeaders {
                requestHeaders[header.key] = header.value
            }
        }

        //adds additionals parameters
        if let additionalsParameters = parameters.parameters {
            for parameter in additionalsParameters {
                requestParameters[parameter.key] = parameter.value
            }
        }

        //gets properly encoding
        let requestEncoding: ParameterEncoding = parameters.encoding ?? defaultEncoding(forMethod: parameters.method)

        //makes a request
        return sessionManager.rx.request(parameters.method, parameters.url, parameters: requestParameters, encoding: requestEncoding, headers: requestHeaders).do(onNext: { (dataRequest) in
            LogService.shared.log(dataRequest)
        })

    }

    func responseData(parameters: ApiRequestParameters, validate validateResponse: Bool = true) -> Observable<(HTTPURLResponse, Data)> {
        let dataResponse = self.requestData(parameters: parameters)
            .responseData()
            .doOnce ({ (response, error) in
                LogService.shared.log(response?.0, data: response?.1, error: error)
            })
        return validate(responseData: dataResponse, ifNeed: validateResponse)
    }
    
    func responseMapped<MapTo: Codable>(parameters: ApiRequestParameters, mapper: ApiDataMapperProtocol? = nil, validate validateResponse: Bool = true) -> Observable<(HTTPURLResponse, MapTo?)> {
        let dataResponse = self.requestData(parameters: parameters)
            .responseData()
            .map ({ [weak self] (response: HTTPURLResponse, data: Data) -> (HTTPURLResponse, Data, MapTo?) in
                guard let self = self else {
                    return (response, data, nil)
                }
                
                var mappedData: MapTo?
                do {
                    mappedData = try (mapper ?? self.defaultDataMapper()).mapTo(data: data)
                } catch {
                    try self.throwError(forResponse: response, data: data, originalError: error)
                }
                return (response, data, mappedData)
            })
            .doOnce ({ (response, error) in
                LogService.shared.log(response?.0, data: response?.1, mappedData: response?.2 as? LogDataRecudible, error: error)
            })
            .map({ (response: HTTPURLResponse, _: Data, mappedData: MapTo?) -> (HTTPURLResponse, MapTo?) in
                return (response, mappedData)
            })
        
        return validate(responseData: dataResponse, ifNeed: validateResponse)
    }
}
