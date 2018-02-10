//
//  FutbolObj.swift
//  AppTester
//
//  Created by Miguel Paolo Bravo on 2/10/18.
//  Copyright © 2018 Miguel Paolo Bravo. All rights reserved.
//

import UIKit

class FutbolObj: NSObject {
    
    // http://api.football-data.org/v1/competitions/455/teams
    // league = teams, fixtures
    // teams = _links (self, fix, players) href
    // - name, code, shortName
    
    // get link from _links
    // http://api.football-data.org/v1/teams/745/players
    // players - name, position, jerseyNumber, nationality
    
    // get link from _links
    // http://api.football-data.org/v1/teams/745/fixtures
    // teams - links (homeTeam, awayTeam) href
    // - date, matchday, homeTeamName, awayTeamName
    // result - goalsHomeTeam, goalsAwayTeam

    
    var name: String!
    var shortName: String!
    var playersURL: String!
    
    init(name : String, shortName : String, playersURL : String) {
        
        self.name = name
        self.shortName = shortName
        self.playersURL = playersURL
        
        super.init()
    }
    
    
    override init() {
        
    }
}
