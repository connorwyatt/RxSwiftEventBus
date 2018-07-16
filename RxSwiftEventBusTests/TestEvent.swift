import Foundation
import RxSwiftEventBus

struct TestEvent: Event
{
  static let type = "TestEvent"

  let message: String
}
