//
//  FutbolTVC.swift
//  AppTester
//
//  Created by Miguel Paolo Bravo on 2/10/18.
//  Copyright © 2018 Miguel Paolo Bravo. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData

class FutbolTVC: UITableViewController {
    
    var arrayOfFutbolObj = [FutbolObj]()
    var container: NSPersistentContainer!
    
    var commits = [Team]()
    
    var clickedRow = -1
    
    // la liga = 455
    // http://api.football-data.org/v1/competitions/455/teams
    var searchLeague = "455"
    // list the teams and save the codes for each team

    override func viewDidLoad() {
        super.viewDidLoad()
        
        container = NSPersistentContainer(name: "AppTester")
        
        container.loadPersistentStores { storeDescription, error in
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error {
                print("Unresolved error \(error)")
            }
        }
        loadSavedData()
       // print("commits.count \(commits.count)")
       if !(commits.count > 0) {
            fetchResults(str: searchLeague)
       }else{
    //    print(commits[1].shortName)
        if commits[0].shortName == "Chievo"{
            self.title = "Serie A"
        }
        if commits[0].shortName == "Bournemouth"{
            print("Bournemouth")
            self.title = "Premier League"
        }
        if commits[0].shortName == "Athletic"{
            self.title = "La Liga"
        }
        if commits[0].shortName == "Monaco"{
            self.title = "Ligue 1"
        }
        if commits[1].shortName == "Mainz"{
            print("Mainz?")
        
            self.title = "Bundesliga"
            //self.navigationController?.navigationBar.backItem?.title = "Bundesliga"
            
        }
        
        self.tableView.reloadData()
        }
        
       
        
    }
    
    
    
    func fetchResults(str: String){
        
        print("str = \(str)")
        
        if str != "" {
            let trimmedSearchString = str.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "+")
            let urlString = "http://api.football-data.org/v1/competitions/\(trimmedSearchString)/teams"
            
            
            if let url = URL(string: urlString) {
                 
                if let data = try? String(contentsOf: url) {
                    let json = JSON(parseJSON: data)
     
                    
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
        commits.removeAll()
        deleteData()
        
        self.tableView.reloadData()
        
        let jsonCommitArray = json["teams"].arrayValue
        
//        for result in json["teams"].arrayValue {
//
//            // spit to table
//            // save fixtures link and players link
//            // when table is clicked then get info from link
//            // save to obj then spit
//            let name = result["name"].stringValue
//            let shortName = result["shortName"].stringValue
//            let playersURL = result["_links"]["players"]["href"].stringValue
//
//            let obj = FutbolObj(name: name, shortName: shortName, playersURL: playersURL)
//            // self.listOfAllPost.append(postObj)
//            self.arrayOfFutbolObj.append(obj)
//
//        }
        
        
      //  self.arrayOfFutbolObj.sort { $0.name < $1.name}
        
        
        self.tableView.reloadData()
        DispatchQueue.main.async { [unowned self] in
            for jsonCommit in jsonCommitArray {
                
                let commit = Team(context: self.container.viewContext)
                self.configure(commit: commit, usingJSON: jsonCommit)
                
            }
            
            self.saveContext()
            self.loadSavedData()
        }
        
    }
    
    func configure(commit: Team, usingJSON json: JSON) {
//        commit.sha = json["sha"].stringValue
//        commit.message = json["commit"]["message"].stringValue
//        commit.url = json["html_url"].stringValue
//
//        let formatter = ISO8601DateFormatter()
//        commit.date = formatter.date(from: json["commit"]["committer"]["date"].stringValue) ?? Date()
        
        //for result in json["teams"].arrayValue {
    
            commit.name = json["name"].stringValue
            commit.shortName = json["shortName"].stringValue
            commit.urlPlayers = json["_links"]["players"]["href"].stringValue
            commit.urlGames = "later"
   
//            let obj = FutbolObj(name: name, shortName: shortName, playersURL: playersURL)
//            // self.listOfAllPost.append(postObj)
//            self.arrayOfFutbolObj.append(obj)
            
      //  }
        
        
    }
    
    func saveContext() {
        
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }
    
    func loadSavedData() {
        let request = Team.createFetchRequest()
//        let sort = NSSortDescriptor(key: "name", ascending: false)
//        request.sortDescriptors = [sort]
        
        do {
            commits = try container.viewContext.fetch(request)
            print("Got \(commits.count) commits")
            self.commits.sort { $0.name < $1.name}
            tableView.reloadData()
        } catch {
            print("Fetch failed")
        }
    }

    func deleteData() {
        
      //  let appDel:AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
//        let context:NSManagedObjectContext = appDel.persistentContainer.viewContext
        let context:NSManagedObjectContext = self.container.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Team")
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try context.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                context.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Deleted all my data in myEntity error : \(error) \(error.userInfo)")
        }
    }
    
    @IBAction func leagueChoose(_ sender: Any) {
        
        let ac = UIAlertController(title: "Choose league", message: nil, preferredStyle: .actionSheet)
        
        ac.addAction(UIAlertAction(title: "Premier League", style: .default, handler: { (alert) in
            
            self.title = "Premier League"
            self.fetchResults(str: "445")
            
        }))
        
        ac.addAction(UIAlertAction(title: "La Liga", style: .default, handler: { (alert) in
            
            self.title = "La Liga"
            self.fetchResults(str: "455")
            
        }))
        
        ac.addAction(UIAlertAction(title: "Ligue 1", style: .default, handler: { (alert) in
            
            self.title = "Ligue 1"
            self.fetchResults(str: "450")
            
        }))
        
        ac.addAction(UIAlertAction(title: "Bundesliga", style: .default, handler: { (alert) in
            
            self.title = "Bundesliga"
            self.fetchResults(str: "452")
            
        }))
        
        ac.addAction(UIAlertAction(title: "Serie A", style: .default, handler: { (alert) in
            
            self.title = "Serie A"
            self.fetchResults(str: "456")
            
        }))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
        
    }
    
    

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       // return arrayOfFutbolObj.count
        return commits.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

      //  let obj = self.arrayOfFutbolObj[indexPath.row]
        
        let obj = commits[indexPath.row]
        
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
                
                let obj = self.commits[clickedRow]
                
                controller.urlString = obj.urlPlayers
                
            }
            
            
            
        }
        
        
    }
 

}
