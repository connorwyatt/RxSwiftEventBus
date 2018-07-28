import Foundation

public protocol EventDispatcher
{
  func send(_ event: Any)
}
