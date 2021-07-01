//
//  FCError.swift
//  FirebaseCodable
//
//  Created by hasegawa-yusuke on 2019/08/01.
//

import Foundation

/// Error
public enum FCError: Error {
    /// error for Firebase
    case firebaseError(Error)
    ///error for System(i.e decode error, etc.)
    case systemError(Error)
}
