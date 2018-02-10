//
//  CollectionViewController.swift
//  AppTester
//
//  Created by Miguel Paolo Bravo on 1/16/18.
//  Copyright © 2018 Miguel Paolo Bravo. All rights reserved.
//

import UIKit
import SwiftyJSON

// private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {
    
    // create obj arr - then add the URLs
    var arrayOfPixabayObj = [PixabayObj]()
    
   // var jsonList = [[String: String]]()
    
    var selectedValues = Set<String>()
    var selectedValues2 = Set<String>()
    
    var searchStr = "Pixabay"
    // var temp = ""
    
    var clickedRow = -1
    
    @IBOutlet weak var imgViewTemp2: UIImageView!
    var imgViewTemp: UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // .trimmingCharacters(in: .whitespacesAndNewlines\
        // .replacingOccurrences(of: " ", with: "+")
        
       // UINavigationBar.topItem!.title = "Dynamic"
        
       // temp = searchStr.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "+")
        
       // print("temp = \(temp)")
        // &image_type=all&order=popular
// let urlString = "https://pixabay.com/api/?key=7848189-81a1fb73ab7fa17cf0f1c78ac&q=\(searchStr)&image_type=photo&per_page=200"
        // print("url \(urlString)")
        
        
        
        
        fetchResults(searchString: searchStr);

    }
    
    func fetchResults(searchString: String){
        
        print("searchString = \(searchString)")
        
        if searchString != "" {
            let trimmedSearchString = searchString.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "+")
            let urlString = "https://pixabay.com/api/?key=7848189-81a1fb73ab7fa17cf0f1c78ac&q=\(trimmedSearchString)&image_type=photo&per_page=200&order=popular"
            
            
            if let url = URL(string: urlString) {
               // jsonList.removeAll()
                if let data = try? String(contentsOf: url) {
                    let json = JSON(parseJSON: data)
                    print("json = \(json["totalHits"]) ")
                    if json["totalHits"].intValue > 0 {
                        
                        print("OK to parse")
                        
                        DispatchQueue.main.async {
                            self.parse(json: json)
                        }
                        
                    }
                    
                }
            }
            
        }else{
            
            notifyUser("Empty Field", message: "Search again")
            
//            let alert = UIAlertController(title: "Empty Field", message: nil, preferredStyle: UIAlertControllerStyle.alert  )
//            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil);
//            alert.addAction(cancelAction);
//            self.present(alert, animated: true, completion: nil);
            
            
        }
        
        
    }
    
    
    func parse(json: JSON) {
  
        arrayOfPixabayObj.removeAll()
        self.collectionView?.reloadData()
        
        for result in json["hits"].arrayValue {
  
            let previewURL = result["previewURL"].stringValue
            let webformatURL = result["webformatURL"].stringValue
//            let total = result["total"].stringValue
//            let totalHits = result["totalHits"].stringValue
            
 
            
            let obj = PixabayObj(webformatURL: webformatURL, previewURL: previewURL)
            // self.listOfAllPost.append(postObj)
            self.arrayOfPixabayObj.append(obj)
            
        }
        
 
        self.collectionView?.reloadData()
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

 

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return arrayOfPixabayObj.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TestCollectionViewCell
    
       
     //   print("count = \(self.jsonList.count)")
        
        let obj = self.arrayOfPixabayObj[indexPath.row]
        cell.imgView.downloadedFrom(link: obj.previewURL!)
        
//        self.imgViewTemp2?.downloadedFrom(link: jsonList["userImageURL"]!)
        
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        
        return cell
    }
    
    
    
    @objc func tap(_ sender: UITapGestureRecognizer) {
        
        let location = sender.location(in: self.collectionView)
        let indexPath = self.collectionView?.indexPathForItem(at: location)
        
        if let index = indexPath {
            
            print("Got clicked on index: \(index.row)!")
            
            clickedRow = index.row
 
            
            // if imgViewTemp.image != nil {
                performSegue(withIdentifier: "clickToZoom", sender: sender)
                
           // }
            
            
        }
    }
    
 
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // clickToZoom
        if segue.identifier == "clickToZoom" {
            
            if clickedRow != -1 {
                
                let obj = self.arrayOfPixabayObj[clickedRow]
                
                if let zoomVC = segue.destination as? ZoomVC {
                   // cell.imgView.downloadedFrom(link: obj["userImageURL"]!)
                    
                    
                   // if let img.downloadedFrom(link: obj["userImageURL"]!) {
                    
                    zoomVC.urlHolder = obj.webformatURL!
                    
                    
//                    }else{
//                        print("no image")
//                    }
                }
                
                
            }
            
        }
    }
    
    
    
    // MARK: - Ibaction
    
    @IBAction func searchButton(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Search", message: nil, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Search", style: .default) { (_) in
            if let field = alertController.textFields?[0] {
                
                self.fetchResults(searchString: field.text!)
  
                
            } else {
                // user did not fill field
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Email"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    

}

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
