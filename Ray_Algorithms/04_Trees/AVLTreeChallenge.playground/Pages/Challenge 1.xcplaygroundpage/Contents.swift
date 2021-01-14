/*
 How many leaf nodes are there in a perfectly balanced tree of height 3?
 What about a perfectly balanced tree of height h?
 */

import Foundation

func leafNodes(inTreeOfHeight height: Int) -> Int {
    Int(pow(2.0, Double(height)))
}

leafNodes(inTreeOfHeight: 3)
