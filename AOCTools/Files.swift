import Foundation

public func getRawInputStringForDay(_ day: Int, in bundle: Bundle) -> String {
    let fileURL = bundle.url(forResource: String(format: "Day%02d", day), withExtension: "txt", subdirectory: "Resources")!
    return try! String(contentsOf: fileURL, encoding: .utf8)
}
