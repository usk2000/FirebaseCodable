//
//  FCJSONEncoder.swift
//  FirebaseCodable
//
//  Created by hasegawa-yusuke on 2019/08/01.
//

import Foundation

class FCJSONEncoder: JSONEncoder {
    
    convenience init(keyEncoding: KeyEncodingStrategy ,dateEncoding: DateEncodingStrategy) {
        self.init()
        self.keyEncodingStrategy = keyEncoding
        self.dateEncodingStrategy = dateEncoding
    }
    
    func encodeIntoJson<T>(_ value: T) throws -> [String: Any] where T: Codable {
        let data = try self.encode(value)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        return json as? [String: Any] ?? [:]
    }
    
    func encodeToJson<T>(_ value: T) throws -> [String: Any] where T: FirebaseCodable {
        let data = try self.encode(value)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        if var result = json as? [String: Any] {
            result["id"] = nil
            return result
        } else {
            return [:]
        }
    }
    
    func encodeToJsonArray<T>(_ value: T) throws -> [[String: Any]] where T: Codable {
        let data = try self.encode(value)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        return json as? [[String: Any]] ?? [[:]]
    }
    
}
