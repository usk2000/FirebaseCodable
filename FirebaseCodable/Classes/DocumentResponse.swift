//
//  DocumentResponse.swift
//  FirebaseCodable
//
//  Created by hasegawa-yusuke on 2019/08/01.
//

import Foundation
import FirebaseFirestore

struct DocumentResponse<T> {
    let items: [T]
    let lastSnapshot: DocumentSnapshot?
}
