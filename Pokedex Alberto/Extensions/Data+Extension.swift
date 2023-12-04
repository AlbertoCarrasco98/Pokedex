import Foundation

extension Data {
    
    func parseData(removeString string: String) -> Data {
        let dataAsString = String(decoding: self, as: UTF8.self)
        let cleanedString = dataAsString.replacingOccurrences(of: string, with: "")
        guard let cleanedData = cleanedString.data(using: .utf8) else { return self }
        return cleanedData
    }
}
