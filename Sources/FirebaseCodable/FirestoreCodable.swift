//
//  FirestoreCodable.swift
//  FirebaseCodable
//
//  Created by hasegawa-yusuke on 2019/08/01.
//

import Foundation

/// Codable protocol for Firestore
public protocol FirestoreCodable: Codable {
    var id: String { get }
}

public extension FirestoreCodable where Self: Equatable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    
}
