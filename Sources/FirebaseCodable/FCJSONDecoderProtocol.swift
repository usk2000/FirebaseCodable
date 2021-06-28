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
    func decode<T>(_ type: T.Type, json: [String: Any], id: String) throws -> T where T: FirebaseCodable
    
}

extension FCJsonDecoderProtocol where Self: JSONDecoder {
    
    /// JSONオブジェクトをCodableに準拠したオブジェクトに変換する
    /// - Parameters:
    ///   - type: タイプ
    ///   - json: JSON
    func decode<T>(_ type: T.Type, json: Any) throws -> T where T: Decodable {
        
        var input = json
        
        if var list = input as? [String: Any] {
            convertTimestampToJson(&list)
            input = list
        }
        
        let data = try JSONSerialization.data(withJSONObject: input, options: [])
        return try self.decode(T.self, from: data)
    }
    
    /// Firebaseから取得したJSONオブジェクトを変換する
    /// - Parameters:
    ///   - type: タイプ
    ///   - json: JSON
    ///   - id: Document ID
    func decode<T>(_ type: T.Type, json: [String: Any], id: String) throws -> T where T: FirebaseCodable {
        var input = json
        input["id"] = id
        convertTimestampToJson(&input)
        let data = try JSONSerialization.data(withJSONObject: input, options: [])
        //Log.debug(String.init(data: data, encoding: .utf8) ?? "empty")
        return try self.decode(T.self, from: data)
    }
    
}

private extension FCJsonDecoderProtocol {
    
    /// トップレベルのみTimestampを変換
    func convertTimestampToJson(_ json: inout [String: Any]) {
        
        json.forEach { key, value in
            if let timestamp = value as? Timestamp {
                json[key] = ["seconds": timestamp.seconds, "nanoseconds": timestamp.nanoseconds]
            }
        }
        
    }
    
}
