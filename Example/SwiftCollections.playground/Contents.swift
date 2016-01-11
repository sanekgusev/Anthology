//: Playground - noun: a place where people can play

import SwiftCollections

var str = "Hello, playground"

let tupleArray = Array(arrayLiteral: (1, "one"), (2, "two"))

var a : OrderedDictionary = ["one": "one"]
a.insert(("two", "two"), atIndex: 0)
let i = a["one"]!.index
a.updateValue("three", forKey: "two")
