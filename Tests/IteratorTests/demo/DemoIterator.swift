import Foundation
import Iterator
/**
 * A custom iterator that iterates through an array of DemoItem objects and calls a completion handler when done.
 */
class DemoIterator: ArrayIterator<DemoItem> {
   var complete: Completed

   /**
    * Initializes a new instance of the DemoIterator class.
    *
    * - Parameters:
    *   - array: The array of DemoItem objects to iterate through.
    *   - onComplete: The completion handler to call when the iteration is done.
    */
   init(array: [DemoItem], onComplete:@escaping Completed) {
      // Call the parent class's initializer with the given array
      super.init(array: array)
      // Set the completion handler for the iterator
      self.complete = onComplete
   }
}