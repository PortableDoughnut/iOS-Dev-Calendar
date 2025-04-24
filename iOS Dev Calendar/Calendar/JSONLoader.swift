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
            throw JSONLoadError.resourceNotFound("\(resource).\(ext)")
        }

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
}
