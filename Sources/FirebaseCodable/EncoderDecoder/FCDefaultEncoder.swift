//
//  FCDefaultEncoder.swift
//  
//
//  Created by Yusuke Hasegawa on 2021/06/28.
//

import Foundation

public class FCDefaultEncoder: JSONEncoder, FCJsonEncoderProtocol {
    
    public override init() {
        super.init()
        self.keyEncodingStrategy = .convertToSnakeCase
    }
    
}
