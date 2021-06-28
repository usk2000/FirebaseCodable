//
//  FCDefaultEncoder.swift
//  
//
//  Created by Yusuke Hasegawa on 2021/06/28.
//

import Foundation

class FCDefaultEncoder: JSONEncoder, FCJsonEncoderProtocol {
    
    override init() {
        super.init()
        self.keyEncodingStrategy = .convertToSnakeCase
    }
    
}
