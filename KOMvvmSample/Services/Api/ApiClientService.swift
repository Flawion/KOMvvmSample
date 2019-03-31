//
//  ApiClientService.swift
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

/// Returns right implementation of ApiClient
final class ApiClientService {
    private static var isMockClientUsed: Bool = false

    /// ApiClient that will be used by the application
    private(set) static var giantBomb: (BaseGiantBombClient & GiantBombClientProtocol) = {
        return GiantBombClient()
    }()

    private init() { }

    /// Change ApiClient to mock version
    ///
    /// - Parameter bundle: bundle of unit test that contains mock files
    static func setMockClient(forBundle bundle: Bundle) {
        guard !isMockClientUsed else {
            return
        }
        ApiClientService.giantBomb = GiantBombMockClient()
        ApiClientService.giantBomb.mockDataContainer.loadDataFromBundleIdentifier = bundle.bundleIdentifier
        isMockClientUsed = true
    }
}
