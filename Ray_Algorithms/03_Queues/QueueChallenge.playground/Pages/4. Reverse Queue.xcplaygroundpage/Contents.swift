/*
 Implement a method to reverse the contents of a queue.
 */

extension QueueArray {
    func reversed() -> QueueArray {
        var queue = self
        var stack = Stack<T>()
        while let element = queue.dequeue() {
            stack.push(element)
        }
        while let element = stack.pop() {
            queue.enqueue(element)
        }
        return queue
    }
}//

var queue = QueueArray<String>()
queue.enqueue("1")
queue.enqueue("21")
queue.enqueue("18")
queue.enqueue("42")

print("before: \(queue)")
print("after: \(queue.reversed())")
