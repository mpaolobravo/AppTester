//
//  PixabayObj.swift
//  AppTester
//
//  Created by Miguel Paolo Bravo on 2/1/18.
//  Copyright © 2018 Miguel Paolo Bravo. All rights reserved.
//

import UIKit

class PixabayObj: NSObject {
    
    // when clicked - show webformatURL
 
    var webformatURL: String!
    var previewURL: String!
    
    init(webformatURL : String, previewURL : String) {
        
        self.webformatURL = webformatURL
        self.previewURL = previewURL
        
        super.init()
    }
    
    
    override init() {
        
    }

}
