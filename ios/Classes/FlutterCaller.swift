import Foundation

public typealias completion = (String, Any?) -> ()?

protocol FlutterCaller {
    func setFlutterCaller(caller: @escaping(completion))
}
