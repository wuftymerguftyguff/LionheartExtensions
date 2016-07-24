//
//  Functional.swift
//  LionheartExtensions
//
//  Created by Daniel Loewenherz on 3/9/16.
//
//  Copyright 2016 Lionheart Software LLC
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//

import Foundation

public struct TruthTeller<T> {
    public var value: Bool

    public init(_ value: T?) {
        guard let value = value else {
            self.value = false
            return
        }

        if let value = value as? Int {
            self.value = value > 0
        } else if let value = value as? String {
            self.value = value.length > 0 && value != ""
        } else if let value = value as? Bool {
            self.value = value
        } else {
            self.value = false
        }
    }
}

public func truthy<T>(item: T) -> Bool {
    return TruthTeller(item).value
}

public func all(elements: [AnyObject?], test: (AnyObject? -> Bool) = truthy) -> Bool {
    for element in elements {
        if !test(element) {
            return false
        }
    }
    return true
}

public func any(elements: [AnyObject?], test: (AnyObject? -> Bool) = truthy) -> Bool {
    for element in elements {
        if test(element) {
            return true
        }
    }

    return false
}

public func all<T>(elements: [T?], test: (AnyObject? -> Bool)? = nil) -> Bool {
    for element in elements {
        if !truthy(element) {
            return false
        }
    }

    return true
}

public func any<T>(elements: [T?], test: (AnyObject? -> Bool) = truthy) -> Bool {
    for element in elements {
        if let element = element as? AnyObject {
            if test(element) {
                return true
            }
        }
    }

    return false
}

public extension Array {
    func all(@noescape where predicate: Generator.Element throws -> Bool = truthy) rethrows -> Bool {
        for element in self {
            guard try predicate(element) else { return false }
        }
        return true
    }

    func any(@noescape where predicate: Generator.Element throws -> Bool = truthy) rethrows -> Bool {
        for element in self {
            if let result = try? predicate(element) where result {
                return true
            }
        }
        return false
    }
}