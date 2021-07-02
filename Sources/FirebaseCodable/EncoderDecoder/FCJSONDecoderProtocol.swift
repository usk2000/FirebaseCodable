//
//  FCJSONDecoder.swift
//  FirebaseCodable
//
//  Created by hasegawa-yusuke on 2019/08/01.
//

import Foundation
import FirebaseFirestore

public protocol FCJsonDecoderProtocol: AnyObject {
    
    func decode<T>(_ type: T.Type, json: Any) throws -> T where T: Decodable
    func decode<T>(_ type: T.Type, json: [String: Any], id: String) throws -> T where T: FirestoreCodable
    
}

public extension FCJsonDecoderProtocol where Self: JSONDecoder {
    
    /// Decode JSON object to Type which confirms Decodable
    /// - Parameters:
    ///   - type: Type
    ///   - json: JSON object
    func decode<T: Decodable>(_ type: T.Type, json: Any) throws -> T {
        
        var input = json
        
        if var list = input as? [String: Any] {
            convertTimestampToJson(&list)
            input = list
        }
        
        let data = try JSONSerialization.data(withJSONObject: input, options: [])
        return try self.decode(T.self, from: data)
    }
    
    /// Decode JSON object to Type which confirms FirestoreCodable
    /// - Parameters:
    ///   - type: Type
    ///   - json: JSON object
    ///   - id: Document ID
    func decode<T: FirestoreCodable>(_ type: T.Type, json: [String: Any], id: String) throws -> T {
        var input = json
        input["id"] = id
        convertTimestampToJson(&input)
        let data = try JSONSerialization.data(withJSONObject: input, options: [])
        return try self.decode(T.self, from: data)
    }
    
}

private extension FCJsonDecoderProtocol {
    
    /// Convert top-level Timestamp to JSON
    /// - Parameter json: JSON object
    func convertTimestampToJson(_ json: inout [String: Any]) {
        
        json.forEach { key, value in
            if let timestamp = value as? Timestamp {
                json[key] = ["seconds": timestamp.seconds, "nanoseconds": timestamp.nanoseconds]
            }
        }
        
    }
    
}
