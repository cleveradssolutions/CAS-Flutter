import Foundation

protocol FlutterCaller {
    func setFlutterCaller(caller: @escaping (String, Any?) -> ())
}
