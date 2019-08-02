//
//  Message.swift
//  FirebaseCodable_Example
//
//  Created by hasegawa-yusuke on 2019/08/02.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import FirebaseCodable

struct Message: FirebaseCodable {
    let id: String
    let text: String
    let date: Date
}
