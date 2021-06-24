import Foundation
import Iterator
/**
 * Action
 */
extension DemoIterator {
   /**
    * Async iterate call
    */
   func iterate(callBack:@escaping Callback) {
      Swift.print("iterate")
      if hasNext() {
         let item: DemoItem = next()
         DispatchQueue.global(qos: .background).async {
            sleep((1..<4).randomElement() ?? 1) // Simulates some remote service taking 2.0 sec
            let eitherOr: Bool = !(Bool.random() && Bool.random()) // 1 in 4 is false
            Swift.print("Doing some work 💪, success: \(eitherOr ? "✅" : "🚫")")
            callBack(item, eitherOr)
         }
      } else {
         complete()
      }
   }
}
/**
 * Type
 */
extension DemoIterator {
   typealias Completed = () -> Void
   typealias Callback = (_ item: DemoItem, _ success: Bool) -> Void
}
