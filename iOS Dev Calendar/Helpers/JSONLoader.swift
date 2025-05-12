import Foundation

enum JSONLoader {
    static let baseURLs = ["https://legendary-disco-3jjqqp4.pages.github.io/data/",
                           "https://raw.githubusercontent.com/legendary-disco-3jjqqp4/legendary-disco-3jjqqp4.pages.github.io/main/data/"]

    /// Loads JSON data from a remote URL
    /// - Parameters:
    ///   - filename: The name of the JSON file without extension
    ///   - ext: The file extension (defaults to "json")
    /// - Returns: Decoded data of type T
    static func loadRemote<T: Decodable>(_ filename: String, ext: String = "json") async throws -> T {
        var lastError: Error?
        for baseURL in baseURLs {
            let urlString = baseURL + filename + "." + ext
            print("🌐 Trying URL: \(urlString)")
            guard let url = URL(string: urlString) else {
                print("❌ Invalid URL: \(urlString)")
                continue
            }
            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("❌ Invalid response type for \(urlString)")
                    continue
                }
                if httpResponse.statusCode == 200 {
                    print("📦 Raw data received from \(urlString):")
                    print(String(data: data, encoding: .utf8) ?? "")
                    print("✅ Successfully loaded data from \(urlString)")
                    return try JSONDecoder().decode(T.self, from: data)
                } else {
                    print("❌ HTTP error \(httpResponse.statusCode) for \(urlString)")
                    lastError = NSError(domain: "JSONLoader", code: -2, userInfo: [NSLocalizedDescriptionKey: "HTTP error: \(httpResponse.statusCode)"])
                    continue
                }
            } catch {
                print("❌ Error loading from \(urlString): \(error)")
                lastError = error
                continue
            }
        }
        throw lastError ?? NSError(domain: "JSONLoader", code: -3, userInfo: [NSLocalizedDescriptionKey: "All URLs failed"])
    }
    
    /// Loads JSON data from a local file
    /// - Parameters:
    ///   - filename: The name of the JSON file without extension
    ///   - ext: The file extension (defaults to "json")
    /// - Returns: Decoded data of type T
    static func loadLocal<T: Decodable>(_ filename: String, ext: String = "json") throws -> T {
        guard let url = Bundle.main.url(forResource: filename, withExtension: ext) else {
            throw NSError(domain: "JSONLoader", code: -1, userInfo: [NSLocalizedDescriptionKey: "File not found"])
        }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(T.self, from: data)
    }

    /// Loads JSON data, attempting remote first, falling back to local
    /// - Parameters:
    ///   - filename: The name of the JSON file without extension
    ///   - ext: The file extension (defaults to "json")
    /// - Returns: Decoded data of type T
    static func load<T: Decodable>(_ filename: String, ext: String = "json") async throws -> T {
        do {
            return try await loadRemote(filename, ext: ext)
        } catch {
            return try loadLocal(filename, ext: ext)
        }
    }
}
