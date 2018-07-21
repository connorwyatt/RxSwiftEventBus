import Foundation
import RxSwift

public class EventBus: EventDispatcher, EventStream
{
  public lazy var stream: Observable<Event> = {
    Observable.create
    { subscriber in
      let observer = self.notificationCenter.addObserver(
        forName: self.notificationName,
        object: nil,
        queue: nil,
        using: { notification in
          guard let event = notification.userInfo?[self.eventKey] as? Event else
          {
            return
          }

          subscriber.onNext(event)
        }
      )

      return Disposables.create
      {
        self.notificationCenter.removeObserver(observer)
      }
    }
  }()

  private let notificationCenter: NotificationCenter
  private let notificationName =
    NSNotification.Name(rawValue: "EventBusEventDispatched")
  private let eventKey = UUID().uuidString

  private let disposeBag = DisposeBag()

  public init(notificationCenter: NotificationCenter)
  {
    self.notificationCenter = notificationCenter
  }

  public func send(_ event: Event)
  {
    notificationCenter.post(
      name: notificationName,
      object: nil,
      userInfo: [eventKey: event]
    )
  }

  public func select<T: Event>(_ type: T.Type) -> Observable<T>
  {
    return stream
      .filter { $0 is T }
      .map { $0 as! T }
  }
}
