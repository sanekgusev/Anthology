//: Playground - noun: a place where people can play

import SwiftCollections

var str = "Hello, playground"

let tupleArray = Array(arrayLiteral: (1, "one"), (2, "two"))

var b: OrderedSet = [1,2,3,4]

//b.append(1)
//b.appendContentsOf([1,2,3,4])

b.replaceRange(0..<0, with: [4,5,6])