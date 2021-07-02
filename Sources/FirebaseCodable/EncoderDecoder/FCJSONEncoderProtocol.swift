//
//  FCJSONEncoder.swift
//  FirebaseCodable
//
//  Created by hasegawa-yusuke on 2019/08/01.
//

import Foundation

public protocol FCJsonEncoderProtocol: AnyObject {
    
    func encodeIntoJson<T>(_ value: T) throws -> [String: Any] where T: Codable
    func encodeToJson<T>(_ value: T) throws -> [String: Any] where T: FirestoreCodable
    func encodeToJsonArray<T>(_ value: T) throws -> [[String: Any]] where T: Codable
    
}

public extension FCJsonEncoderProtocol where Self: JSONEncoder {
    
    /// Encode  object  which confirms Encodable  to JSON object
    /// - Parameter value: Encodable object
    /// - Throws: encode error
    /// - Returns: JSON object
    func encodeIntoJson<T: Encodable>(_ value: T) throws -> [String: Any] {
        let data = try self.encode(value)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        return json as? [String: Any] ?? [:]
    }
    
    /// Encode  object  which confirms FirestoreCodable  to JSON object
    /// - Parameter value: FirebaseCodable object
    /// - Throws: encode error
    /// - Returns: JSON object
    func encodeToJson<T>(_ value: T) throws -> [String: Any] where T: FirestoreCodable {
        let data = try self.encode(value)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        if var result = json as? [String: Any] {
            result["id"] = nil
            return result
        } else {
            return [:]
        }
    }
    
    /// Encode array  object  which confirms FirestoreCodable  to JSON object
    /// - Parameter value: array of Encodable object
    func encodeToJsonArray<T: Encodable>(_ value: T) throws -> [[String: Any]] {
        let data = try self.encode(value)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        return json as? [[String: Any]] ?? [[:]]
    }
    
}

