//
//  Clamping.swift
//  Chess
//
//  Created by Eirik Vale Aase on 28/12/2019.
//

@propertyWrapper
struct Clamping<Value: Comparable> {
    var value: Value
    let range: ClosedRange<Value>

    init(wrappedValue value: Value, _ range: ClosedRange<Value>) {
        self.value = value
        self.range = range
    }

    var wrappedValue: Value {
        get {
            value
        }
        set {
            value = min(max(newValue, range.lowerBound), range.upperBound)
        }
    }
}
