//: Playground - noun: a place where people can play

import Anthology

var b: OrderedDictionary = [1:"one", 2:"two", 3:"three"]

b.append((1, "two"))
b.appendContentsOf([(3, "three"), (4, "four")])
b.removeForKey(3)
b.updateValue("three", forKey: 3)
b.insert((3, "three"), atIndex: 0)
b.updateValue("zero", forKey: 3)
b.replaceRange(3...3, with: EmptyCollection<(Int, String)>())
b.replaceRange(0..<0, with: CollectionOfOne((0, "zero")))
b.insert((3, "three"), atIndex: 3)
String(b)

var c: OrderedSet = ["one", "two", "three"]