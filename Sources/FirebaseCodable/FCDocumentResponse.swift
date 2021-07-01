//
//  FCDocumentResponse.swift
//  FirebaseCodable
//
//  Created by hasegawa-yusuke on 2019/08/01.
//

import Foundation
import FirebaseFirestore

/// DocumentResponse
public struct FCDocumentResponse<T> {
    /// decoded object list
    public let items: [T]
    /// last snapshot
    public let lastSnapshot: DocumentSnapshot?
}
