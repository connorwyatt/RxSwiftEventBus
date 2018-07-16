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

    eventBus
      .select(TestEvent.self)
      .subscribe(onNext: { event in
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

    eventBus
      .select(TestEvent.self)
      .subscribe(onNext: { _ in
        eventDeliveredExpectation.fulfill()
      })
      .disposed(by: disposeBag)

    eventBus.send(AnotherTestEvent(message: "Hello"))

    wait(for: [eventDeliveredExpectation], timeout: 1)
  }
}
