//
//  FCJSONDecoder.swift
//  FirebaseCodable
//
//  Created by hasegawa-yusuke on 2019/08/01.
//

import Foundation

open class FCJSONDecoder: JSONDecoder {
    
    convenience init(keyDecoding: KeyDecodingStrategy ,dateDecoding: DateDecodingStrategy) {
        self.init()
        self.keyDecodingStrategy = keyDecoding
        self.dateDecodingStrategy = dateDecoding
    }
    
    func decode<T>(_ type: T.Type, json: Any) throws -> T where T: Decodable {
        let data = try JSONSerialization.data(withJSONObject: json, options: [])
        return try self.decode(T.self, from: data)
    }
    
    func decode<T>(_ type: T.Type, json: [String: Any], id: String) throws -> T where T: FirebaseCodable {
        var input = json
        input["id"] = id
        let data = try JSONSerialization.data(withJSONObject: input, options: [])
        return try self.decode(T.self, from: data)
    }
    
}
