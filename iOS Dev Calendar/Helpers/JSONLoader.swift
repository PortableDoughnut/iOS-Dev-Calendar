//
//  JSONLoader.swift
//  iOS Dev Calendar
//
//  Created by Wesley Keetch on 4/22/25.
//

import Foundation

enum JSONLoadError: Error {
    case resourceNotFound(String)
    case unreadableData(URL, underlying: Error)
    case decodingFailed(type: Any.Type, underlying: Error)
    case invalidURL(String)
    case networkError(underlying: Error)
    case unexpectedResponse(URLResponse?)
}

struct JSONLoader {
    /// Load and decode a JSON resource from the app bundle.
    /// - Parameters:
    ///   - resource: The filename without extension.
    ///   - ext: The file extension (default: "json").
    ///   - type: The `Decodable` type to decode.
    /// - Throws: `JSONLoadError` on failure.
    static func load<T: Decodable>(
        _ resource: String,
        ext: String = "json",
        as type: T.Type = T.self
    ) throws -> T {
        // Locate resource in bundle
        guard let url = Bundle.main.url(forResource: resource, withExtension: ext) else {
            print("❌ Failed to locate \(resource).\(ext) in bundle.")
            throw JSONLoadError.resourceNotFound("\(resource).\(ext)")
        }
        print("📁 Found \(resource).\(ext) at \(url)")

        // Read data
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            throw JSONLoadError.unreadableData(url, underlying: error)
        }

        // Configure decoder
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" 
        decoder.dateDecodingStrategy = .formatted(formatter)

        // Decode
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw JSONLoadError.decodingFailed(type: T.self, underlying: error)
        }
    }

    /// Load and decode a JSON resource from a remote URL.
    /// - Parameters:
    ///   - urlString: The string representation of the URL.
    ///   - type: The `Decodable` type to decode.
    /// - Throws: `JSONLoadError` on failure.
    static func load<T: Decodable>(
        fromURLString urlString: String,
        as type: T.Type = T.self
    ) async throws -> T {
        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL: \(urlString)")
            throw JSONLoadError.invalidURL(urlString)
        }
        print("🌍 Attempting to fetch from URL: \(url)")

        // Fetch data
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await URLSession.shared.data(from: url)
        } catch {
            print("❌ Network error fetching from \(url): \(error)")
            throw JSONLoadError.networkError(underlying: error)
        }

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            print("❌ Unexpected HTTP response: \(response)")
            throw JSONLoadError.unexpectedResponse(response)
        }
        
        // Configure decoder
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" 
        decoder.dateDecodingStrategy = .formatted(formatter)

        // Decode
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            print("❌ Decoding failed for data from \(url): \(error)")
            throw JSONLoadError.decodingFailed(type: T.self, underlying: error)
        }
    }
}
