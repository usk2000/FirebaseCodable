//
//  FCDocumentResponse.swift
//  FirebaseCodable
//
//  Created by hasegawa-yusuke on 2019/08/01.
//

import Foundation
import FirebaseFirestore

public struct FCDocumentResponse<T> {
    let items: [T]  //decoded object list
    let lastSnapshot: DocumentSnapshot? //last snapshot
}
