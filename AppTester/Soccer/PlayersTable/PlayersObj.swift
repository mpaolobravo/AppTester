//
//  PlayersObj.swift
//  AppTester
//
//  Created by Miguel Paolo Bravo on 2/10/18.
//  Copyright © 2018 Miguel Paolo Bravo. All rights reserved.
//

import UIKit

class PlayersObj: NSObject {
    
    var name: String!
    var position: String!
    var jerseyNumber: String!
    var nationality: String!

    init(name : String, position : String, jerseyNumber : String, nationality : String) {
        
        self.name = name
        self.position = position
        self.jerseyNumber = jerseyNumber
        self.nationality = nationality
        
        super.init()
    }
    
    
    override init() {
        
    }
    
    
}
