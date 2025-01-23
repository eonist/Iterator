[![Tests](https://github.com/eonist/Iterator/actions/workflows/Tests.yml/badge.svg)](https://github.com/eonist/Iterator/actions/workflows/Tests.yml)

# Iterator

This iterator class is designed to handle both simple arrays and async local/remote services. It provides powerful iteration capabilities, allowing you to move forward and backward through your data with ease. 

### How it Works
- Supports async iteration
- Allows for forward and backward iteration
- Works with regular arrays and other data types

### Limitations:
- Cannot add new items while iterating (use a queue design for that)
- Does not remove items after they are consumed (use a queue design for that)
- Does not automatically start when new items are added (see the CueKit project for a solution)

## Getting Started
To use the Iterator class in your project, simply install it using SPM:

### Usage
To use the Iterator class, simply create an instance of the class and pass in the data you want to iterate over. You can then use the next() and previous() methods to move forward and backward through the data.

### Design
The Iterator class is designed to be simple and easy to use, while still providing powerful iteration capabilities. It is implemented using a simple state machine that keeps track of the current position in the data, and provides methods for moving forward and backward through the data.

```swift
.package(url: "https://github.com/eonist/Iterator")
``````

### Basic Example:
```swift
import Iterator

let data = [1, 2, 3, 4, 5]
let iterator = Iterator(data: data)

while let item = iterator.next() {
    print(item)
}
```

The Iterator class also supports async iteration, making it easy to handle local and remote services that return data asynchronously.

```swift
import Iterator

let service = MyService()
let iterator = Iterator(async: service.getData())

while let item = await iterator.next() {
    print(item)
}
```

### Async Example:
Here is an example where the iterator is used to iterate a simulated remote service.
```swift
/**
 * Demonstrates async iterator
 */
class DemoIterator: ArrayIterator<DemoItem> {
    var complete: Completed
    init(array: Array<T>, onComplete:@escaping Completed) {
        self.complete = onComplete
        super.init(array: array)
    }
}
/**
 * Extension
 */
extension DemoIterator {
    typealias Completed = () -> Void
    func iterate(callBack:@escaping (_ item: DemoItem, _ success: Bool) -> Void){
        Swift.print("iterate")
        if hasNext() {
            let item: DemoItem = next()
            DispatchQueue.global(qos: .background).async {
                sleep(2)/*Simulates some remote service taking 2.0 sec*/
                let eitherOr: Bool = arc4random_uniform(2) == 0/*heads or tails*/
                Swift.print("Doing some work 💪, success: \(eitherOr ? "✅" : "🚫")")
                callBack(item, eitherOr)
            }
        } else {
            complete()
        }
    }
}
struct DemoItem{}

/**
 * ## Examples:
 * DemoIteratorExample().iterate() //All done: 🎉 2
 */
public class DemoIteratorExample {
   var validItems: [DemoItem] = []
   lazy var arrIterator: DemoIterator = DemoIterator(array: [DemoItem(), DemoItem(), DemoItem()]) {
      print("All done: 🎉 \(self.validItems.count)")// the result varies between a count of 0 and 3
   }
   public init() { /* Do nothing */ }
   public func iterate() {
      arrIterator.iterate { item, success in
         if success {
            self.validItems.append(item)
            self.iterate()
         } else {
            self.iterate()
         }
      }
   }
}
```
**Basic Forward Iteration Example:**
```swift
import Iterator

let data = [1, 2, 3, 4, 5]
let iterator = ArrayIterator(array: data)

while iterator.hasNext() {
    let item = iterator.next()
    print(item)
}
```

**Reverse Iteration Example:**
```swift
import Iterator

let data = [1, 2, 3, 4, 5]
let reverseIterator = ReverseArrayIterator(array: data)

while reverseIterator.hasPrev() {
    let item = reverseIterator.prev()
    print(item)
}
```

**Detail Async Iteration:**

```swift
import Iterator

let service = YourAsyncService()
let iterator = Iterator(asyncSequence: service.fetchData())

Task {
    while let item = await iterator.next() {
        print(item)
    }
}
```

**Custom Iterator Example:**
```swift
import Iterator

class CustomIterator: ArrayIterator<CustomType> {
    // Custom implementation or additional methods
}
```

### Todo:
- Add the new native swift result type
- Ask copilot for improvments
- Conform to Swift's Standard Protocols
Instead of defining your own Iteratable protocol, you can conform your iterator to Swift's built-in Sequence and IteratorProtocol protocols. This allows your iterator to be used seamlessly with Swift's standard library features, like for-in loops.
Updated ArrayIterator:

```swift
 /// An iterator over an array that provides sequential access to its elements.
open class ArrayIterator<T>: IteratorProtocol, Sequence {
    private var index: Int = 0
    public var collection: [T]

    public init(array: [T]) {
        self.collection = array
    }

    public func next() -> T? {
        guard index < collection.count else { return nil }
        defer { index += 1 }
        return collection[index]
    }

    public func reset() {
        index = 0
    }
}
let iterator = ArrayIterator(array: [1, 2, 3, 4, 5])
for element in iterator {
    print(element)
}
```

- Refactor Reversible Iterator
Correct the spelling of Reversable to Reversible and conform it to Sequence. Implement bidirectional iteration by adopting the BidirectionalCollection protocol if appropriate.

```swift
open class ReverseArrayIterator<T>: IteratorProtocol, Sequence {
    private var index: Int
    public var collection: [T]

    public init(array: [T]) {
        self.collection = array
        self.index = array.count - 1
    }

    public func next() -> T? {
        guard index >= 0 else { return nil }
        defer { index -= 1 }
        return collection[index]
    }

    public func reset() {
        index = collection.count - 1
    }
}
```

- Utilize Swift's Result Type for Async Operations
Enhance your asynchronous code by using Swift's Result type for better error handling.

```swift
func iterate(completion: @escaping (Result<DemoItem, Error>) -> Void) {
    if hasNext {
        let item = next()
        DispatchQueue.global(qos: .background).async {
            // Simulate asynchronous work
            sleep(2)
            let success = Bool.random()
            if success {
                completion(.success(item))
            } else {
                completion(.failure(DemoError.operationFailed))
            }
        }
    } else {
        complete()
    }
}

enum DemoError: Error {
    case operationFailed
}
```

- Adopt async/await for Asynchronous Code
Refactor your asynchronous functions to use Swift's async/await syntax for cleaner and more readable code.

```swift
func iterate() async {
    while hasNext {
        let item = next()
        do {
            try await performAsyncWork(with: item)
            print("Processed item successfully.")
        } catch {
            print("Failed to process item: \(error)")
        }
    }
    complete()
}

func performAsyncWork(with item: DemoItem) async throws {
    // Simulate async work
    try await Task.sleep(nanoseconds: 2 * 1_000_000_000)
    let success = Bool.random()
    if !success {
        throw DemoError.operationFailed
    }
}
```

- Improve Naming Conventions
Correct misspellings and improve naming for better code clarity.
Rename Iteratable to Iterable.
Rename Reversable to Reversible.
Use descriptive variable names instead of single letters.

- Update Unit Tests to Cover Edge Cases
Ensure your tests cover various scenarios, including empty collections, single-element collections, and error handling in asynchronous operations.
Example Test Case:

```swift
func testEmptyIterator() {
    let emptyIterator = ArrayIterator<Int>(array: [])
    XCTAssertFalse(emptyIterator.hasNext)
    XCTAssertNil(emptyIterator.next())
}
```

- Refactor DemoIterator for Clarity
Separate concerns by decoupling the iteration logic from the asynchronous operation handling.
Refactored DemoIterator:

```swift
import Iterator

class DemoIterator: ArrayIterator<DemoItem> {
    private let complete: Completed

    init(array: [DemoItem], onComplete: @escaping Completed) {
        self.complete = onComplete
        super.init(array: array)
    }

    func iterate() async {
        while hasNext {
            let item = next()
            do {
                try await process(item)
                print("Processed item successfully.")
            } catch {
                print("Failed to process item: \(error)")
            }
        }
        complete()
    }

    private func process(_ item: DemoItem) async throws {
        try await Task.sleep(nanoseconds: 2 * 1_000_000_000)
        let success = Bool.random()
        if !success {
            throw DemoError.operationFailed
        }
    }
}
```