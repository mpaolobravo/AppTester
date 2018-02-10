//
//  FutbolTVC.swift
//  AppTester
//
//  Created by Miguel Paolo Bravo on 2/10/18.
//  Copyright © 2018 Miguel Paolo Bravo. All rights reserved.
//

import UIKit
import SwiftyJSON

class FutbolTVC: UITableViewController {
    
    var arrayOfFutbolObj = [FutbolObj]()
    
    var clickedRow = -1
    
    // la liga = 455
    // http://api.football-data.org/v1/competitions/455/teams
    var searchLeague = "455"
    // list the teams and save the codes for each team

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchResults(str: searchLeague)
        
        
    }
    
    func fetchResults(str: String){
        
        print("str = \(str)")
        
        if str != "" {
            let trimmedSearchString = str.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "+")
            let urlString = "http://api.football-data.org/v1/competitions/\(trimmedSearchString)/teams"
            
            
            if let url = URL(string: urlString) {
                 
                if let data = try? String(contentsOf: url) {
                    let json = JSON(parseJSON: data)
               //     print("json _links = \(json["_links"]["self"]["href"].stringValue) ")
                  //  print("json teams = \(json["teams"]) ")
//                    print("json = \(json["_links"]) ")
//                    print("json = \(json["_links"]) ")
                    
                    if json["teams"].count > 0 {

                        print("OK to parse")

                        DispatchQueue.main.async {
                           self.parse(json: json)
                        }

                    }
                    
                }
            }
            
        }else{
            
            notifyUser("Empty Field", message: "Search again")
 
            
        }
        
        
    }
    
    func parse(json: JSON) {
        
        arrayOfFutbolObj.removeAll()
        
        self.tableView.reloadData()
        
        for result in json["teams"].arrayValue {
            
            // spit to table
            // save fixtures link and players link
            // when table is clicked then get info from link
            // save to obj then spit
            let name = result["name"].stringValue
            let shortName = result["shortName"].stringValue
            let playersURL = result["_links"]["players"]["href"].stringValue
            
            
            
            //            let total = result["total"].stringValue
            //            let totalHits = result["totalHits"].stringValue
            
            
            
            let obj = FutbolObj(name: name, shortName: shortName, playersURL: playersURL)
            // self.listOfAllPost.append(postObj)
            self.arrayOfFutbolObj.append(obj)
            
        }
        
        
        self.arrayOfFutbolObj.sort { $0.name < $1.name}
        
        self.tableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayOfFutbolObj.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let obj = self.arrayOfFutbolObj[indexPath.row]
        
        cell.textLabel?.text = obj.name
        cell.detailTextLabel?.text = obj.shortName

        return cell
    }
 

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        
        print("clicked row == \(indexPath.row)")
        clickedRow = indexPath.row
        
        performSegue(withIdentifier: "segueToPlayers", sender: cell)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
        if segue.identifier == "segueToPlayers" {
            
            let controller = segue.destination as! PlayersTVC
            
            if clickedRow != -1 {
                
                let obj = self.arrayOfFutbolObj[clickedRow]
                
                controller.urlString = obj.playersURL
                
            }
            
            
            
        }
        
        
    }
 

}
