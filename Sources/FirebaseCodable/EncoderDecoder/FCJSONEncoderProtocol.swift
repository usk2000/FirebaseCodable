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
    
    /// Codableに準拠したオブジェクトをJSONに変化する
    /// - Parameter value: オブジェクト
    func encodeIntoJson<T>(_ value: T) throws -> [String: Any] where T: Codable {
        let data = try self.encode(value)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        //Log.verbose(json)
        return json as? [String: Any] ?? [:]
    }
    
    /// FirebaseオブジェクトをJSONに変換する。idキーは削除する
    /// - Parameter value: オブジェクト
    func encodeToJson<T>(_ value: T) throws -> [String: Any] where T: FirestoreCodable {
        let data = try self.encode(value)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        //Log.verbose(json)
        if var result = json as? [String: Any] {
            result["id"] = nil
            return result
        } else {
            return [:]
        }
    }
    
    /// Codableに準拠したオブジェクト配列をJSONに変化する
    /// - Parameter value: オブジェクト
    func encodeToJsonArray<T>(_ value: T) throws -> [[String: Any]] where T: Codable {
        let data = try self.encode(value)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        //Log.verbose(json)
        return json as? [[String: Any]] ?? [[:]]
    }
    
}

