//
//  AppErrors.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

public final class AppError: NSError, LocalizedError {
    private var pDescription: String
    public let innerError: NSError?
    public static let errorDomain = "pl.KO.KOMvvmSample"
    
    public var errorDescription: String? {
        return pDescription
    }
    
    init(withCode code: AppErrorCodes, userInfo: [String: Any]? = nil, description: String? = nil, innerError: NSError? = nil) {
        pDescription = description ?? "error_general".localized
        if let innerError = innerError {
            let lastDomainPath = innerError.domain.split(separator: ".").last ?? ""
            pDescription += "\n(\(lastDomainPath) \(innerError.code))"
        } else {
            pDescription += "\n(app \(code.rawValue))"
        }
        
        var userInfoMutable: [String: Any] = userInfo ?? [:]
        userInfoMutable[NSLocalizedDescriptionKey] = pDescription
        
        self.innerError = innerError
        super.init(domain: Self.errorDomain, code: code.rawValue, userInfo: userInfoMutable)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
