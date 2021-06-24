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
    * Add items to a list if they succeed etc
    */
   private func beginIterating() {
      arrIterator.iterate { [weak self] (_ item: DemoItem, _ success: Bool) in
         if success {
            self?.validItems.append(item)
            self?.beginIterating()
         } else {
            self?.beginIterating()
         }
      }
   }
}
