import Foundation

//Эта хеш-функция использует скалярное представление каждого символа в Юникоде и суммирует его
func naiveHash(_ string: String) -> Int {
    let unicodeScalars = string.unicodeScalars.map { Int($0.value) }
    return unicodeScalars.reduce(0, +)
}

naiveHash("abc") // outputs 294
naiveHash("bca") // also outputs 294

func djb2Hash(_ string: String) -> Int {
    let unicodeScalars = string.unicodeScalars.map { $0.value }
    return unicodeScalars.reduce(5381) {
        ($0 << 5) &+ $0 &+ Int($1)
    }
}

djb2Hash("abc") // outputs 193485963
djb2Hash("bca") // outputs 193487083
djb2Hash("firstName") % 2 // outputs 1
djb2Hash("lastName") % 2 // outputs 1


var hashTable = HashTable<String, String>(capacity: 5)
hashTable["firstName"] = "Steve"

if let firstName = hashTable["firstName"] {
    print(firstName)
}

if let lastName = hashTable["lastName"] {
    print(lastName)
} else {
    print("lastName key not in hash table")
}

hashTable["firstName"] = nil

if let firstName = hashTable["firstName"] {
  print(firstName)
} else {
  print("firstName key is not in the hash table")
}
