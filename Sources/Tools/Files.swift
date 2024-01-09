import Foundation

public func getRawInputStringFor(day: Int, in bundle: Bundle, useSampleInput: Bool = false) -> String {
    let fileURL = bundle.url(forResource: String(format: "Day%02d", day), withExtension: "txt", subdirectory: useSampleInput ? "Sample" : "Input")!

    return try! String(contentsOf: fileURL)
}
