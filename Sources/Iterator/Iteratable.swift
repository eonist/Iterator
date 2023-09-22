import Foundation
/**
 * A protocol that defines the requirements for an iterator over a collection of elements of type `T`.
 * - Fixme: ⚠️️ Why are we using a method for the hasNext call?
 */
public protocol Iteratable {
   associatedtype T // The type of element in the collection.
   var index: Int { get set }/*The iteration cursor*/
   var collection: [T] { get set } // The collection of elements to iterate over.
   /**
    * Returns a Boolean value indicating whether there are more elements to iterate over.
    *
    * - Returns: `true` if there are more elements to iterate over; otherwise, `false`.
    */
   func hasNext() -> Bool
   /**
    * Returns the next element in the collection.
    *
    * - Returns: The next element in the collection.
    */
   func next() -> T
   /**
    * Resets the iterator to the beginning of the collection.
    */
   func reset()
}