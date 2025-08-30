//
//  IntArrayTransformer.swift
//  HabitApp
//
//  Created by Avinash kumar on 30/08/25.
//

import Foundation
import CoreData

@objc(IntArrayTransformer)
class IntArrayTransformer: ValueTransformer {
    override class func allowsReverseTransformation() -> Bool {
        return true
    }

    override class func transformedValueClass() -> AnyClass {
        return NSArray.self
    }

    override func transformedValue(_ value: Any?) -> Any? {
        guard let array = value as? [Int] else { return nil }
        return try? NSKeyedArchiver.archivedData(withRootObject: array, requiringSecureCoding: true)
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        return try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, NSNumber.self], from: data) as? [Int]
    }
}
