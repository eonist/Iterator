import XCTest
import Iterator

final class IteratorTests: XCTestCase {
   /**
    * Async test Expectation
    */
   lazy var asyncDone: XCTestExpectation = { self.expectation(description: "Async function") }() // expectation is in the XCTestCase
   var validItems: [DemoItem] = []
   lazy var arrIterator: DemoIterator = .init(array: [DemoItem(), DemoItem(), DemoItem()]) { [weak self] in
      Swift.print("All done: 🎉 \(String(describing: self?.validItems.count))") // the result varies between a count of 0 and 3
      self?.asyncDone.fulfill() // call this to indicate the test was successful
   }
   /**
    * Tests
    */
   func testExample() {
      beginIterating() // All done: 🎉 2
      wait(for: [asyncDone], timeout: 30) // Add after work has been called, timeout after 30 secs
   }
}
/**
 * Helper
 */
extension IteratorTests {
   /**
    * Begins iterating through the items in the DemoIterator instance and adds valid items to the validItems array.
    * If an item is valid, it is added to the validItems array and the iteration continues.
    * If an item is invalid, the iteration continues without adding the item to the validItems array.
    */
   private func beginIterating() {
      arrIterator.iterate { [weak self] (_ item: DemoItem, _ success: Bool) in
         if success {
            self?.validItems.append(item)
            self?.beginIterating() // Continue iterating through the items
         } else {
            self?.beginIterating() // Continue iterating through the items
         }
      }
   }
}
