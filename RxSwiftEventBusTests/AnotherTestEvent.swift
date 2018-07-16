import Foundation
import RxSwiftEventBus

struct AnotherTestEvent: Event
{
  static let type = "AnotherTestEvent"

  let message: String
}
