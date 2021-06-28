//
//  FCDefaultDecoder.swift
//  
//
//  Created by Yusuke Hasegawa on 2021/06/28.
//

import Foundation

class FCDefaultDecoder: JSONDecoder, FCJsonDecoderProtocol {
    
    override init() {
        super.init()
        self.keyDecodingStrategy = .convertFromSnakeCase
    }
    
}
