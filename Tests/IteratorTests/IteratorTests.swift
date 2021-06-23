import XCTest
import Iterator

final class IteratorTests: XCTestCase {
   lazy var asyncDone = { self.expectation(description: "Async function") }() // expectation is in the XCTestCase
   func testExample() {
      iterate() //All done: 🎉 2
      wait(for: [asyncDone], timeout: 10) // Add after work has been called
   }
   var validItems: [DemoItem] = []
   lazy var arrIterator: DemoIterator = .init(array: [DemoItem(), DemoItem(), DemoItem()]) {
      Swift.print("All done: 🎉 \(self.validItems.count)") // the result varies between a count of 0 and 3
      self.asyncDone.fulfill() // call this to indicate the test was successful
   }
   private func iterate() {
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
