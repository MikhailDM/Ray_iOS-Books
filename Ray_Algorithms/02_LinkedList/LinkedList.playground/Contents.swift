import Foundation

example(of: "creating and linking nodes") {
    let node1 = Node(value: 1)
    let node2 = Node(value: 2)
    let node3 = Node(value: 3)
    node1.next = node2
    node2.next = node3
    print(node1)
}

example(of: "push") {
    var list = LinkedList<Int>()
    list.push(3)
    list.push(2)
    list.push(1)
    print(list)
}

example(of: "append") {
    var list = LinkedList<Int>()
    list.append(1)
    list.append(2)
    list.append(3)
    print(list)
}

example(of: "inserting at a particular index") {
    var list = LinkedList<Int>()
    list.push(3)
    list.push(2)
    list.push(1)
    print("Before inserting: \(list)")
    var middleNode = list.node(at: 1)!
    for _ in 1...4 {
        middleNode = list.insert(-1, after: middleNode)
    }
    print("After inserting: \(list)")
}

example(of: "pop") {
    var list = LinkedList<Int>()
    list.push(3)
    list.push(2)
    list.push(1)
    print("Before popping list: \(list)")
    let poppedValue = list.pop()
    print("After popping list: \(list)")
    print("Popped value: " + String(describing: poppedValue))
}

example(of: "removing the last node") {
    var list = LinkedList<Int>()
    list.push(3)
    list.push(2)
    list.push(1)
    print("Before removing last node: \(list)")
    let removedValue = list.removeLast()
    print("After removing last node: \(list)")
    print("Removed value: " + String(describing: removedValue))
}

example(of: "removing a node after a particular node") {
    var list = LinkedList<Int>()
    list.push(3)
    list.push(2)
    list.push(1)
    print("Before removing at particular index: \(list)")
    let index = 1
    let node = list.node(at: index - 1)!
    let removedValue = list.remove(after: node)
    print("After removing at index \(index): \(list)")
    print("Removed value: " + String(describing: removedValue))
}

example(of: "using collection") {
    var list = LinkedList<Int>()
    for i in 0...9 {
        list.append(i)
    }
    
    print("List: \(list)")
    print("First element: \(list[list.startIndex])")
    print("Array containing first 3 elements: \(Array(list.prefix(3)))")
    print("Array containing last 3 elements: \(Array(list.suffix(3)))")
    let sum = list.reduce(0, +)
    print("Sum of all values: \(sum)")
}

example(of: "array cow") {
    let array1 = [1, 2]
    var array2 = array1
    print("array1: \(array1)")
    print("array2: \(array2)")
    print("---After adding 3 to array 2---")
    array2.append(3)
    print("array1: \(array1)")
    print("array2: \(array2)")
}

example(of: "linked list cow") {
    var list1 = LinkedList<Int>()
    list1.append(1)
    list1.append(2)
    
    print("List1 uniquely referenced: \(isKnownUniquelyReferenced(&list1.head))")
    var list2 = list1
    print("List1 uniquely referenced: \(isKnownUniquelyReferenced(&list1.head))")
        
    print("List1: \(list1)")
    print("List2: \(list2)")
    print("After appending 3 to list2")
    list2.append(3)
    print("List1: \(list1)")
    print("List2: \(list2)")
    print("Removing middle node on list2")
    if let node = list2.node(at: 0) {
      list2.remove(after: node)
    }
    print("List2: \(list2)")
}

example(of: "sharing nodes") {
    var list1 = LinkedList<Int>()
    (1...3).forEach { list1.append($0) }
    var list2 = list1
    print("List1: \(list1)")
    print("List2: \(list2)")
    list2.push(0)
    print("List1: \(list1)")
    print("List2: \(list2)")
    list1.push(100)
    print("List1: \(list1)")
    print("List2: \(list2)")
}
    
//MARK: - Challenge 1. Print in reverse
//Create a function that prints the nodes of a linked list in reverse order
private func printInReverse<T>(_ node: Node<T>?) {
    guard let node = node else { return }
    printInReverse(node.next)
    print(node.value)
}

func printInReverse<T>(_ list: LinkedList<T>) {
    printInReverse(list.head)
}

example(of: "printing in reverse") {
    var list = LinkedList<Int>()
    list.push(3)
    list.push(2)
    list.push(1)
    print("Original list: \(list)")
    print("Printing in reverse:")
    printInReverse(list)
}

//MARK: - Challenge 2. Find the middle node
//Create a function that finds the middle node of a linked list
//fast добереться до конца в 2 раза быстрее slow
func getMiddle<T>(_ list: LinkedList<T>) -> Node<T>? {
    var slow = list.head
    var fast = list.head
    while let nextFast = fast?.next {
        fast = nextFast.next
        slow = slow?.next
    }
    return slow
}
example(of: "getting the middle node") {
    var list = LinkedList<Int>()
    list.push(3)
    list.push(2)
    list.push(1)
    print(list)
    if let middleNode = getMiddle(list) {
        print("middle node \(middleNode)")
    }
}

//MARK: - Challenge 3. Reverse a linked list
//Create a function that reverses a linked list.
//You do this by manipulating the nodes so that they’re linked in the other direction
example(of: "reversing a list") {
    var list = LinkedList<Int>()
    list.push(3)
    list.push(2)
    list.push(1)
    print("Original list: \(list)")
    list.reverse()
    print("Reversed list: \(list)")
}

//MARK: - Challenge 4. Merge two lists
//Create a function that takes two sorted linked lists and merges them into a single sorted linked list.
//Your goal is to return a new linked list that contains the nodes from two lists in sorted order.
//You may assume the sort order is ascending.


//MARK: - Challenge 5. Remove all occurrences
//Create a function that removes all occurrences of a specific element from a linked list.
//The implementation is similar to the remove(at:) method that you implemented for the linked list

