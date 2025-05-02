//
//  MappedCallback.swift
//  clever_ads_solutions
//
//  Copyright © 2024 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions

class MappedCallback: NSObject {
    private weak var handler: MappedMethodHandlerProtocol?
    private let id: String

    init(_ handler: MappedMethodHandlerProtocol, _ id: String) {
        self.handler = handler
        self.id = id
    }

    func invokeMethod(_ methodName: String, _ args: [String: Any?]? = nil) {
        handler?.invokeMethod(id, methodName, args)
    }
}
