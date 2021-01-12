// Copyright (c) 2019 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

import Foundation

public struct Stack<Element> {
    
    private var storage: [Element] = []
    
    public init(_ elements: [Element]) {
        storage = elements
    }
    
    public mutating func push(_ element: Element) {
        storage.append(element)
    }
    
    @discardableResult
    public mutating func pop() -> Element? {
        storage.popLast()
    }
    
    public func peek() -> Element? {
        storage.last
    }
    
    public var isEmpty: Bool {
        peek() == nil
    }
    
}//

extension Stack: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Element...) {
        storage = elements
    }
}//

extension Stack: CustomStringConvertible {
    public var description: String {
        """
        ----top----
        \(storage.map { "\($0)" }.reversed().joined(separator: "\n"))
        -----------
        """
    }
}//

//example(of: "using a stack") {
//    var stack = Stack<Int>()
//    stack.push(1)
//    stack.push(2)
//    stack.push(3)
//    stack.push(4)
//    print(stack)
//    if let poppedElement = stack.pop() {
//        assert(4 == poppedElement)
//        print("Popped: \(poppedElement)")
//    }
//}

//example(of: "initializing a stack from an array") {
//    let array = ["A", "B", "C", "D"]
//    var stack = Stack(array)
//    print(stack)
//    stack.pop()
//}

example(of: "initializing a stack from an array literal") {
    var stack: Stack = [1.0, 2.0, 3.0, 4.0]
    print(stack)
    stack.pop()
}//

//MARK: - Challenge 1. Reverse an Array
//Create a function that prints the contents of an array in reversed order
func printInReverse<T>(_ array: [T]) {
    var stack = Stack<T>()
    for value in array {
        stack.push(value)
    }
    while let value = stack.pop() {
        print(value)
    }
}//

example(of: "Challenge 1") {
    let stack: Stack = [1.0, 2.0, 3.0, 4.0]
    print(stack)
    printInReverse([1.0, 2.0, 3.0, 4.0])
}

//MARK: - Challenge 2. Balance the parentheses
//Check for balanced parentheses. Given a string, check if there are ( and ) characters,
//and return true if the parentheses in the string are balanced. For example:
func checkParentheses(_ string: String) -> Bool {
    var stack = Stack<Character>()
    for character in string {
        if character == "(" {
            stack.push(character)
        } else if character == ")" {
            if stack.isEmpty {
                return false
            } else {
                stack.pop()
            }
        }
    }
    return stack.isEmpty
}

example(of: "Challenge 2") {
    print(checkParentheses("h((e))llo(world)()"))
    print(checkParentheses("(hello world"))
}
