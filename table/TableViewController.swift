//
//  TableViewController.swift
//  table
//
//  Created by Anil on 31/12/14.
//  Copyright (c) 2014 Variya Soft Solutions. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    var i = 0
    var detailid = [Int]()
    var detailCat = [String]()
    var catID :Int = Int()
    var indexID : Int = Int()
    var index : Int = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
         self.tableView.rowHeight = 40
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "v creation trans.png"))
        DataManager.getTopAppsDataFromItunesWithSuccess { (iTunesData) -> Void in
            
            let json = JSON(data: iTunesData)
            
            if let array = json.arrayValue{
                
                for Dict in array{
                    var id : Int = array[self.i]["category_id"].integerValue!
                    var category : String = array[self.i]["english_category_name"].stringValue!
                    self.detailid.append(id)
                    self.detailCat.append(category)
                    self.i++
                }
                self.tableView.reloadData()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                if UIApplication.sharedApplication().networkActivityIndicatorVisible == false{
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView.reloadData()
                    })
                }
            }
        }
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.detailCat.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        cell.textLabel.text = self.detailCat[indexPath.row]
//        cell.detailTextLabel?.text = String(self.detailid[indexPath.row])

        if indexPath.row % 2  == 0{
            cell.backgroundColor = UIColor.clearColor()
        }else{
            cell.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.2)
            cell.textLabel.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
            cell.detailTextLabel?.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
        }
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        

        let entry = detailid[indexPath.row] as Int
        let secondVC = self.storyboard?.instantiateViewControllerWithIdentifier("SecondViewController") as BRTableViewController
        secondVC.subCategoriesID = entry
        self.navigationController?.pushViewController(secondVC, animated: true)
        
    }
}
