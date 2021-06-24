import Foundation
import Iterator
/**
 * Demonstrates async iterator
 */
class DemoIterator: ArrayIterator<DemoItem> {
   var complete: Completed
   /**
    * - Parameters:
    *   - array: items
    *   - onComplete: complete callback
    */
   init(array: [DemoItem], onComplete:@escaping Completed) {
      self.complete = onComplete
      super.init(array: array)
   }
}
