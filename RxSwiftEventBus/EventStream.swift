import Foundation
import RxSwift

public protocol EventStream
{
  var stream: Observable<Event> { get }

  func select<T: Event>(_ type: T.Type) -> Observable<T>
}
