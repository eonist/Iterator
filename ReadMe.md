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
let data = [1, 2, 3, 4, 5]
let iterator = Iterator(data: data)

while let item = iterator.next() {
    print(item)
}
```

The Iterator class also supports async iteration, making it easy to handle local and remote services that return data asynchronously.

```swift
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

### Contributing
If you would like to contribute to the Iterator project, please feel free to submit bug reports, feature requests, and pull requests. We welcome contributions from developers of all skill levels, and are committed to maintaining a welcoming and inclusive community.

### Todo:
- Add the new native swift result type
- Ask copilot for improvments
