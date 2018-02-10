//
//  PlayersTVC.swift
//  AppTester
//
//  Created by Miguel Paolo Bravo on 2/10/18.
//  Copyright © 2018 Miguel Paolo Bravo. All rights reserved.
//

import UIKit
import SwiftyJSON

class PlayersTVC: UITableViewController {
    
    var arrayOfPlayersObj = [PlayersObj]()
    var urlString = "nil"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        if urlString != "nil" {
            
            if let url = URL(string: urlString) {
                
                if let data = try? String(contentsOf: url) {
                    let json = JSON(parseJSON: data)
                    
                    
                    if json["players"].count > 0 {
                        
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
        
        arrayOfPlayersObj.removeAll()
        
        self.tableView.reloadData()
        
        for result in json["players"].arrayValue {
     
            let name = result["name"].stringValue
            let position = result["position"].stringValue
            let jerseyNumber = result["jerseyNumber"].stringValue
            let nationality = result["nationality"].stringValue
            
            let obj = PlayersObj(name: name, position: position, jerseyNumber: jerseyNumber, nationality: nationality)
            
            self.arrayOfPlayersObj.append(obj)
            
        }
        
       // print("arrayOfPlayersObj = \(arrayOfPlayersObj)")
        self.arrayOfPlayersObj.sort { $0.name < $1.name}
        
        self.tableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayOfPlayersObj.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PlayerCell

        let obj = self.arrayOfPlayersObj[indexPath.row]
        
        cell.name.text = obj.name
        cell.number.text = obj.jerseyNumber
        cell.nation.text = obj.nationality
        cell.postion.text = obj.position

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
