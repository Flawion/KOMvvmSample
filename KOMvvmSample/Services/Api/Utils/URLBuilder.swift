//
//  URLBuilder.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation
 
final class URLBuilder {
    private let defaultApiAddress: String
    private let defaultApiVersion: String?
    
    init(apiAddress: String, apiVersion: String?) {
        self.defaultApiAddress = apiAddress
        self.defaultApiVersion = apiVersion
    }
    
    func build(components: [String], apiAddress: String? = nil, apiVersion: String? = nil) -> URL? {
        guard var url = URL(string: apiAddress ?? defaultApiAddress) else {
            return nil
        }

        if let version = apiVersion ?? defaultApiVersion {
            url.appendPathComponent(version)
        }

        for component in components {
            url.appendPathComponent(component)
        }
        
        return url
    }
 }
