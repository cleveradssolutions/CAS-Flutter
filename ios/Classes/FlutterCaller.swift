import Foundation

public typealias completion = (String, [String: Any?]?) -> Void?

protocol FlutterCaller {
    func setFlutterCaller(caller: @escaping completion)
}
