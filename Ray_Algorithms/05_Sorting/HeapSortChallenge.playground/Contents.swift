/*
 Add a heapSort() method to Array. This method should sort the array in ascending order.
 */

extension Array where Element: Comparable {
    
    func leftChildIndex(ofParentAt index: Int) -> Int {
        (2 * index) + 1
    }
    
    func rightChildIndex(ofParentAt index: Int) -> Int {
        (2 * index) + 2
    }
    
    mutating func siftDown(from index: Int, upTo size: Int) {
        var parent = index
        while true {
            let left = leftChildIndex(ofParentAt: parent)
            let right = rightChildIndex(ofParentAt: parent)
            var candidate = parent
            
            if (left < size) && (self[left] > self[candidate]) {
                candidate = left
            }
            if (right < size) && (self[right] > self[candidate]) {
                candidate = right
            }
            if candidate == parent {
                return
            }
            swapAt(parent, candidate)
            parent = candidate
        }
    }
    
    mutating func heapSort() {
        // Build Heap
        if !isEmpty {
            for i in stride(from: count / 2 - 1, through: 0, by: -1) {
                siftDown(from: i, upTo: count)
            }
        }
        
        // Perform Heap Sort.
        for index in indices.reversed() {
            swapAt(0, index)
            siftDown(from: 0, upTo: index)
        }
    }
}

var array = [6, 12, 2, 26, 8, 18, 21, 9, 5]
array.heapSort()

/*
 When performing a heap sort in ascending order, which of these starting arrays requires the fewest comparisons?
 */

// [5,4,3,2,1] will yield the fewest number of comparisons, since it’s
// already a max heap and no swaps take place.

/*
 The chapter implementation of heap sort, sorts the elements in ascending order. How would you sort in descending order?
 */

// Simply use a min heap instead of a max heap before sorting:
// let heap = Heap(sort: <, elements: [6, 12, 2, 26, 8, 18, 21, 9, 5])
// print(heap.sorted())
