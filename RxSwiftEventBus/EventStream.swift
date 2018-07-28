import Foundation
import RxSwift

public protocol EventStream
{
  var stream: Observable<EventNotification<Any>> { get }

  func select<T>(_ type: T.Type) -> Observable<EventNotification<T>>
}
