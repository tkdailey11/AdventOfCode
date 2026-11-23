import Foundation

public enum AOCConfig {
    /// When true, `getRawInputStringForDay` loads `DayNNSample.txt` instead of `DayNN.txt`.
    /// Set by the `--sample` CLI flag.
    public static var useSample = false
}

public func getRawInputStringForDay(_ day: Int, in bundle: Bundle) -> String {
    let name = String(format: "Day%02d", day) + (AOCConfig.useSample ? "Sample" : "")

    guard let fileURL = bundle.url(forResource: name, withExtension: "txt", subdirectory: "Input") else {
        fatalError("Missing input file Input/\(name).txt")
    }

    return try! String(contentsOf: fileURL, encoding: .utf8)
}
