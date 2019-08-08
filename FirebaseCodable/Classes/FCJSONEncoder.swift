//
//  FCJSONEncoder.swift
//  FirebaseCodable
//
//  Created by hasegawa-yusuke on 2019/08/01.
//

import Foundation

open class FCJSONEncoder: JSONEncoder {
    
    public convenience init(keyEncoding: KeyEncodingStrategy ,dateEncoding: DateEncodingStrategy) {
        self.init()
        self.keyEncodingStrategy = keyEncoding
        self.dateEncodingStrategy = dateEncoding
    }
    
    public func encodeIntoJson<T>(_ value: T) throws -> [String: Any] where T: Codable {
        let data = try self.encode(value)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        return json as? [String: Any] ?? [:]
    }
    
    public func encodeToJson<T>(_ value: T) throws -> [String: Any] where T: FirebaseCodable {
        let data = try self.encode(value)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        if var result = json as? [String: Any] {
            result["id"] = nil
            return result
        } else {
            return [:]
        }
    }
    
    public func encodeToJsonArray<T>(_ value: T) throws -> [[String: Any]] where T: Codable {
        let data = try self.encode(value)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        return json as? [[String: Any]] ?? [[:]]
    }
    
}
