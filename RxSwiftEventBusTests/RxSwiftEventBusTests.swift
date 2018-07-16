import RxSwift
import RxSwiftEventBus
import XCTest

class RxSwiftEventBusTests: XCTestCase
{
  private var eventBus: EventBus!
  private var disposeBag = DisposeBag()

  override func setUp()
  {
    super.setUp()

    eventBus = EventBus(notificationCenter: NotificationCenter.default)
  }

  func testEventsAreDelivered()
  {
    let eventDeliveredExpectation = XCTestExpectation()

    eventBus.listen()
      .subscribe(onNext: { (event: TestEvent) in
        XCTAssertEqual(event.message, "Hello")

        eventDeliveredExpectation.fulfill()
      })
      .disposed(by: disposeBag)

    eventBus.send(TestEvent(message: "Hello"))

    wait(for: [eventDeliveredExpectation], timeout: 1)
  }

  func testOnlyEventsSpecifiedAreDelivered()
  {
    let eventDeliveredExpectation = XCTestExpectation()
    eventDeliveredExpectation.isInverted = true

    eventBus.listen()
      .subscribe(onNext: { (_: TestEvent) in
        eventDeliveredExpectation.fulfill()
      })
      .disposed(by: disposeBag)

    eventBus.send(AnotherTestEvent(message: "Hello"))

    wait(for: [eventDeliveredExpectation], timeout: 1)
  }
}
