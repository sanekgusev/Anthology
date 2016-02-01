
/// A collection of unique `Element` instances with defined ordering.
public struct OrderedSet<Element: Hashable>: RangeReplaceableCollectionType {
    
    public typealias Index = Int
    
    private var orderedDictionary = OrderedDictionary<Element, Void>()
    
    /// Construct an empty ordered set.
    public init() {}
    
    /// Construct an ordered dictionary from the elements of arbitrary sequence
    /// of elements.
    public init<S: SequenceType where S.Generator.Element == Element>(_ s: S) {
        replaceRange(0..<0, with: s)
    }
    
    /// Always zero, which is the index of the first element
    /// when non-empty.
    public var startIndex: Index {
        return orderedDictionary.startIndex
    }
    
    /// A "past-the-end" element index; the successor of the last valid
    /// subscript argument.
    public var endIndex: Index {
        return orderedDictionary.endIndex
    }
    
    /// Return element at `index`.
    /// - Complexity: O(1).
    public subscript (index: Index) -> Element {
        return orderedDictionary[index].key
    }
    
    /// Returns `true` iff `self` is empty.
    ///
    /// - Complexity: O(1)
    public var isEmpty: Bool {
        return orderedDictionary.isEmpty
    }
    
    /// Replace the given `subRange` of elements with `newElements`.
    public mutating func replaceRange<S : SequenceType where S.Generator.Element == Element>(subRange: Range<Index>, with newElements: S) {
        orderedDictionary.replaceRange(subRange, with: newElements.map({ ($0, ()) }))
    }
}

extension OrderedSet: Hashable {
    /// The hash value.
    ///
    /// **Axiom:** `x == y` implies `x.hashValue == y.hashValue`.
    ///
    /// - Note: The hash value is not guaranteed to be stable across
    ///   different invocations of the same program.  Do not persist the
    ///   hash value across program runs.
    public var hashValue: Int {
        return orderedDictionary.reduce(1) { result, element in
            return 31 * result + element.key.hashValue
        }
    }
}

public func ==<T: Hashable>(lhs: OrderedSet<T>, rhs: OrderedSet<T>) -> Bool {
    return lhs.elementsEqual(rhs)
}

extension OrderedSet: ArrayLiteralConvertible {
    /// Create an instance containing `elements`.
    public init(arrayLiteral elements: Element...) {
        self.init(elements)
    }
}

extension OrderedSet: SetAlgebraType {
    /// Returns the set of elements contained in `self`, in `other`, or in
    /// both `self` and `other`.
    @warn_unused_result
    public func union(other: OrderedSet) -> OrderedSet {
        var result = self
        result.unionInPlace(other)
        return result
    }
    
    /// Returns the set of elements contained in both `self` and `other`.
    @warn_unused_result
    public func intersect(other: OrderedSet) -> OrderedSet {
        var result = self
        result.intersectInPlace(other)
        return result
    }
    
    /// Returns the set of elements contained in `self` or in `other`,
    /// but not in both `self` and `other`.
    @warn_unused_result
    public func exclusiveOr(other: OrderedSet) -> OrderedSet {
        var result = self
        result.exclusiveOrInPlace(other)
        return result
    }
    
    /// If `member` is not already contained in `self`, inserts it.
    ///
    /// - Equivalent to `self.unionInPlace([member])`
    /// - Postcondition: `self.contains(member)`
    public mutating func insert(member: OrderedSet.Element) {
        orderedDictionary.append((member, ()))
    }
    
    /// If `member` is contained in `self`, removes and returns it.
    /// Otherwise, removes all elements subsumed by `member` and returns
    /// `nil`.
    ///
    /// - Postcondition: `self.intersect([member]).isEmpty`
    public mutating func remove(member: OrderedSet.Element) -> OrderedSet.Element? {
        return orderedDictionary.removeForKey(member).map({ $0.key })
    }
    
    /// Insert all elements of `other` into `self`.
    ///
    /// - Equivalent to replacing `self` with `self.union(other)`.
    /// - Postcondition: `self.isSupersetOf(other)`
    public mutating func unionInPlace(other: OrderedSet) {
        other.forEach { orderedDictionary.append(($0, ()))}
    }
    
    /// Removes all elements of `self` that are not also present in
    /// `other`.
    ///
    /// - Equivalent to replacing `self` with `self.intersect(other)`
    /// - Postcondition: `self.isSubsetOf(other)`
    public mutating func intersectInPlace(other: OrderedSet) {
        var elementsToRemove = orderedDictionary
            .map({ $0.key })
            .filter({ !other.contains($0) })
        elementsToRemove.appendContentsOf(
            other.filter({ element in
                !orderedDictionary.contains({ $0.key == element })
            })
        )
        elementsToRemove.forEach { remove($0) }
    }
    
    /// Replaces `self` with a set containing all elements contained in
    /// either `self` or `other`, but not both.
    ///
    /// - Equivalent to replacing `self` with `self.exclusiveOr(other)`
    public mutating func exclusiveOrInPlace(other: OrderedSet) {
        var other = other
        let elementsToRemove = orderedDictionary
            .map({ $0.key })
            .filter({ other.contains($0) })
        elementsToRemove.forEach { remove($0); other.remove($0) }
        unionInPlace(other)
    }
}

extension OrderedSet: CustomStringConvertible, CustomDebugStringConvertible {
    /// A textual representation of `self`.
    public var description: String {
        var description = dropLast().reduce("{", combine: { $0 + "\($1), " })
        if let last = last {
            description += "\(last)"
        }
        description += "}"
        return description
    }
    
    /// A textual representation of `self`, suitable for debugging.
    public var debugDescription: String {
        return "orderedDictionary: \(String(reflecting: orderedDictionary))"
    }
}