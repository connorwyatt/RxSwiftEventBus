import Foundation
import RxSwiftEventBus

class TestEvent: Event
{
  let message: String

  init(message: String)
  {
    self.message = message

    super.init()
  }
}
