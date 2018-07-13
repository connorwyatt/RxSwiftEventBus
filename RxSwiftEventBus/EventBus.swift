import Foundation
import RxSwift

public class EventBus
{
  private let notificationCenter: NotificationCenter
  private let eventKey = UUID().uuidString
  private let operationQueue: OperationQueue = {
    let operationQueue = OperationQueue()

    operationQueue.qualityOfService = .background

    return operationQueue
  }()

  public init(notificationCenter: NotificationCenter)
  {
    self.notificationCenter = notificationCenter
  }

  public func send(_ event: Event)
  {
    let eventType = type(of: event)

    notificationCenter.post(
      name: NSNotification.Name(rawValue: eventType.type),
      object: nil,
      userInfo: [eventKey: event]
    )
  }

  public func listen<T: Event>() -> Observable<T>
  {
    return Observable.create
    { subscriber in
      let observer = self.notificationCenter.addObserver(
        forName: NSNotification.Name(rawValue: T.type),
        object: nil,
        queue: self.operationQueue,
        using: { notification in
          guard let event = notification.userInfo?[self.eventKey] as? T else
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
  }
}
