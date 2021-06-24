//
//  FirebaseCodable.swift
//  FirebaseCodable
//
//  Created by hasegawa-yusuke on 2019/08/01.
//

import Foundation

public protocol FirebaseCodable: Codable {
    var id: String { get }
}