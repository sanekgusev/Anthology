
public struct OrderedDictionary<Key : Hashable, Value> : RangeReplaceableCollectionType, MutableIndexable {
    
    public typealias KeyValuePair = (key: Key, value: Value)
    public typealias IndexValuePair = (index: Index, value: Value)
    
    public typealias Element = KeyValuePair
    public typealias Index = Int
    public typealias SubSequence = ArraySlice<Element>

    private var array = [Element]()
    private var dictionary = [Key: Index]()

    public init() {}
    
    public init<S : SequenceType where S.Generator.Element == Element>(_ s: S) {
        replaceRange(Range(start: 0, end: 0), with: s)
    }
    
    public var startIndex : Index {
        return array.startIndex
    }
    
    public var endIndex : Index {
        return array.endIndex
    }
    
    public subscript (index: Index) -> Element {
        get {
            return array[index]
        }
        set {
            replaceRange(Range(start:index, end:index), with: CollectionOfOne(newValue));
        }
    }
    
    public subscript (subRange: Range<Index>) -> SubSequence {
        return array[subRange]
    }

    public subscript (key: Key) -> IndexValuePair? {
        guard let index = dictionary[key] else {
            return nil
        }
        return (index, array[index].value)
    }
    
    public var keys: LazyMapCollection<OrderedDictionary, Key> {
        return LazyMapCollection(self, transform: { element in
            return element.key
        })
    }
    
    public var values: LazyMapCollection<OrderedDictionary, Value> {
        return LazyMapCollection(self, transform: { element in
            return element.value
        })
    }
    
    public mutating func removeForKey(key: Key) -> IndexValuePair? {
        guard let index = dictionary[key] else {
            return nil
        }
        return (index, removeAtIndex(index).value)
    }
    
    public mutating func updateValue(value: Value, forKey key: Key) -> Value? {
        guard let index = dictionary[key] else {
            return nil
        }
        let oldValue = array[index].value
        array[index] = (key, value)
        dictionary[key] = index
        return oldValue
    }

    public mutating func replaceRange<S : SequenceType where S.Generator.Element == Element>(subRange: Range<Index>, with newElements: S) {
        subRange.forEach { index in
            dictionary.removeValueForKey(array[index].key)
            array.removeAtIndex(index)
        }
        var index = subRange.startIndex;
        newElements.forEach { element in
            if (dictionary[element.key] == nil) {
                dictionary[element.key] = index;
                array.insert(element, atIndex: index)
                index += 1;
            }
        }
    }
}

extension OrderedDictionary : ArrayLiteralConvertible {
    public init(arrayLiteral elements: Element...) {
        self.init(elements)
    }
}

extension OrderedDictionary : DictionaryLiteralConvertible {
    public init(dictionaryLiteral elements: (Key, Value)...) {
        self.init(elements)
    }
}

extension OrderedDictionary : CustomStringConvertible, CustomDebugStringConvertible {
    public var description : String {
        return array.description
    }
    
    public var debugDescription : String {
        return "array: \(String(reflecting: array))\ndictionary: \(String(reflecting:dictionary))"
    }
}