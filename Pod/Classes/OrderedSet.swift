//
//  OrderedSet.swift
//  Pods
//
//  Created by Aleksandr Gusev on 1/15/16.
//
//

public struct OrderedSet<Element : Hashable> : RangeReplaceableCollectionType {
    
    public typealias Index = Int
    
    private var orderedDictionary = OrderedDictionary<Element, Void>()
    
    public init() {}
    
    public init<S: SequenceType where S.Generator.Element == Element>(_ s: S) {
        replaceRange(0..<0, with: s)
    }
    
    public var startIndex: Index {
        return orderedDictionary.startIndex
    }
    
    public var endIndex: Index {
        return orderedDictionary.endIndex
    }
    
    public subscript (index: Index) -> Element {
        return orderedDictionary[index].key
    }
    
    public var isEmpty: Bool {
        return orderedDictionary.isEmpty
    }
    
    public mutating func replaceRange<S : SequenceType where S.Generator.Element == Element>(subRange: Range<Index>, with newElements: S) {
        orderedDictionary.replaceRange(subRange, with: newElements.map { ($0, ()) } )
    }
}

extension OrderedSet: Hashable {
    public var hashValue: Int {
        return orderedDictionary.reduce(1) { result, element in
            return 31 * result + element.key.hashValue
        }
    }
}

public func ==<T: Hashable>(lhs: OrderedSet<T>, rhs: OrderedSet<T>) -> Bool {
    return lhs.elementsEqual(rhs)
}

extension OrderedSet : ArrayLiteralConvertible {
    public init(arrayLiteral elements: Element...) {
        self.init(elements)
    }
}

extension OrderedSet : SetAlgebraType {
    @warn_unused_result
    public func union(other: OrderedSet) -> OrderedSet {
        var result = self
        result.unionInPlace(other)
        return result
    }
    
    @warn_unused_result
    public func intersect(other: OrderedSet) -> OrderedSet {
        var result = self
        result.intersectInPlace(other)
        return result
    }
    
    @warn_unused_result
    public func exclusiveOr(other: OrderedSet) -> OrderedSet {
        var result = self
        result.exclusiveOrInPlace(other)
        return result
    }
    
    public mutating func insert(member: OrderedSet.Element) {
        orderedDictionary.append((member, ()))
    }
    
    public mutating func remove(member: OrderedSet.Element) -> OrderedSet.Element? {
        return orderedDictionary.removeForKey(member).map({ $0.key })
    }
    
    public mutating func unionInPlace(other: OrderedSet) {
        other.forEach({ orderedDictionary.append(($0, ())) })
    }
    
    public mutating func intersectInPlace(other: OrderedSet) {
        var elementsToRemove = orderedDictionary
            .map { $0.key }
            .filter { !other.contains($0) }
        elementsToRemove.appendContentsOf(
            other.filter { element in !orderedDictionary.contains { $0.key == element } }
        )
        elementsToRemove.forEach { remove($0) }
    }
    
    public mutating func exclusiveOrInPlace(var other: OrderedSet) {
        let elementsToRemove = orderedDictionary
            .map { $0.key }
            .filter { other.contains($0) }
        elementsToRemove.forEach { remove($0); other.remove($0) }
        unionInPlace(other)
    }
}

extension OrderedSet : CustomStringConvertible, CustomDebugStringConvertible {
    public var description : String {
        var description = dropLast().reduce("{", combine: { $0 + "\($1), " })
        if let last = last {
            description += "\(last)"
        }
        description += "}"
        return description
    }
    
    public var debugDescription : String {
        return "orderedDictionary: \(String(reflecting: orderedDictionary))"
    }
}