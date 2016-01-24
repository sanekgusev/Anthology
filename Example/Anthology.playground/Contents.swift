//: Playground - noun: a place where people can play

import Anthology

var dict: OrderedDictionary = [1:"one", 2:"two", 3:"three"]

dict.append((1, "two"))
dict.appendContentsOf([(3, "three"), (4, "four")])
dict.removeForKey(3)
dict.updateValue("three", forKey: 3)
dict.insert((3, "three"), atIndex: 0)
dict.updateValue("zero", forKey: 3)
dict.replaceRange(3...3, with: EmptyCollection<(Int, String)>())
dict.replaceRange(0..<0, with: CollectionOfOne((0, "zero")))
dict.insert((3, "three"), atIndex: 3)
String(dict)

var set: OrderedSet = ["one", "two", "three"]
