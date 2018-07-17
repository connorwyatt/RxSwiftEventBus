import Foundation
import RxSwiftEventBus

class AnotherTestEvent: Event
{
  let message: String

  init(message: String)
  {
    self.message = message

    super.init()
  }
}
