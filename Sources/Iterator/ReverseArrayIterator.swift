import Foundation
/**
 * A class that provides an iterator for an array of elements of type `T` in reverse order.
 */
open class ReverseArrayIterator<T>: ArrayIterator<T> {
    /**
     * Returns a Boolean value indicating whether there is a previous element to iterate over.
     * - Returns: `true` if there is a previous element to iterate over; otherwise, `false`.
     */
    func hasPrev() -> Bool {
        return index > 0
    }
    /**
     * Returns the previous element in the collection.
     * - Returns: The previous element in the collection.
     */
    func prev() -> T {
        index -= 1
        let retVal = collection[index]/*cur item*/
        return retVal
    }
}
// Extends the `ReverseArrayIterator` class to conform to the `Reversable` protocol.
extension ReverseArrayIterator: Reversable {}
