//
//  FCDefaultDecoder.swift
//  
//
//  Created by Yusuke Hasegawa on 2021/06/28.
//

import Foundation

public class FCDefaultDecoder: JSONDecoder, FCJsonDecoderProtocol {
    
    public override init() {
        super.init()
        self.keyDecodingStrategy = .convertFromSnakeCase
    }
    
}
