import Foundation
import Iterator
/**
 * Action
 */
extension DemoIterator {
   /**
    * Asynchronously iterate through the items in the iterator and call the given callback function for each item.
    * The callback function takes a DemoItem and a boolean value as arguments and returns nothing.
    * The boolean value indicates whether the work was successful or not.
    */
   func iterate(callBack: @escaping Callback) {
      Swift.print("iterate")
      if hasNext() { // Check if there is a next item in the iterator
         let item: DemoItem = next() // Get the next item in the iterator
         DispatchQueue.global(qos: .background).async { // Run the following code asynchronously in the background
            sleep((1..<4).randomElement() ?? 1) // Simulate some remote service taking 1 to 3 seconds to complete
            let eitherOr: Bool = !(Bool.random() && Bool.random()) // Generate a random boolean value
            Swift.print("Doing some work 💪, success: \(eitherOr ? "✅" : "🚫")") // Print a message indicating whether the work was successful or not
            callBack(item, eitherOr) // Call the callback function with the item and the success status
         }
      } else {
         complete() // Call the completion handler if there are no more items in the iterator
      }
   }
}
/**
 * Type
 */
extension DemoIterator {
   // Define a type alias for a closure that takes no arguments and returns nothing
   typealias Completed = () -> Void

   // Define a type alias for a closure that takes a DemoItem and a boolean value as arguments and returns nothing
   typealias Callback = (_ item: DemoItem, _ success: Bool) -> Void
}
