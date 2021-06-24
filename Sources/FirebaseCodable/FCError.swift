//
//  FCError.swift
//  FirebaseCodable
//
//  Created by hasegawa-yusuke on 2019/08/01.
//

import Foundation

public enum FCError: Error {
    case firebaseError(Error)   //error for Firebase
    case systemError(Error)     //error for System(i.e decode error, etc.)
}
