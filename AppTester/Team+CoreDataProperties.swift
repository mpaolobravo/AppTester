//
//  Team+CoreDataProperties.swift
//  AppTester
//
//  Created by Miguel Paolo Bravo on 2/11/18.
//  Copyright © 2018 Miguel Paolo Bravo. All rights reserved.
//
//

import Foundation
import CoreData


extension Team {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Team> {
        return NSFetchRequest<Team>(entityName: "Team")
    }

    @NSManaged public var name: String
    @NSManaged public var shortName: String
    @NSManaged public var urlPlayers: String
    @NSManaged public var urlGames: String
    

}
