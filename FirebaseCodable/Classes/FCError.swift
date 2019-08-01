//
//  FCError.swift
//  FirebaseCodable
//
//  Created by hasegawa-yusuke on 2019/08/01.
//

import Foundation

enum FCError: Error {
    case firebaseError(Error)
    case systemError(Error)
}
