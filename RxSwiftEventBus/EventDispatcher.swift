import Foundation

public protocol EventDispatcher
{
  func send(_ event: Event)
}
