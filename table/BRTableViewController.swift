//
//  BRTableViewController.swift
//  table
//
//  Created by Anil on 31/12/14.
//  Copyright (c) 2014 Variya Soft Solutions. All rights reserved.
//

import UIKit

class BRTableViewController: UITableViewController {

    var subCategoriesID : Int = Int()
    var url : String = String()
    var i = 0
    var detaiID = [Int]()
    var detailSubcat = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        self.title = "SubCategory"
        self.tableView.rowHeight = 40
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "v creation trans.png"))
        self.getTopAppsDataFromItunesWithSuccess { (url) -> Void in
            
            
            let json = JSON(data: url)
            
            if let array = json.arrayValue{
                
                for Dict in array{
                    var id : Int = array[self.i]["subcategory_id"].integerValue!
                    var category : String = array[self.i]["english_subcategory_name"].stringValue!
                    self.detaiID.append(id)
                    self.detailSubcat.append(category)
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
    
    func getTopAppsDataFromItunesWithSuccess(success: ((url: NSData!) -> Void)) {
        
        url = "http://api.feedzilla.com/v1/categories/\(subCategoriesID)/subcategories.json"
        //1
        self.loadDataFromURL(NSURL(string: url)!, completion:{(data, error) -> Void in
            //2
            if let urlData = data {
                //3
                success(url: urlData)
            }
        })
    }
    
    func loadDataFromURL(url: NSURL, completion:(data: NSData?, error: NSError?) -> Void) {
        var session = NSURLSession.sharedSession()
        
        // Use NSURLSession to get data from an NSURL
        let loadDataTask = session.dataTaskWithURL(url, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
            if let responseError = error {
                completion(data: nil, error: responseError)
            } else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    var statusError = NSError(domain:"com.raywenderlich", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
                    completion(data: nil, error: statusError)
                } else {
                    completion(data: data, error: nil)
                }
            }
        })
        
        loadDataTask.resume()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return detailSubcat.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        cell.textLabel.text = self.detailSubcat[indexPath.row]
        cell.detailTextLabel?.text = String(self.detaiID[indexPath.row])
        
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
        
        
        let articlesubID = detaiID[indexPath.row] as Int
        let articlemainID = subCategoriesID
        let ThirdVC = self.storyboard?.instantiateViewControllerWithIdentifier("ThirdViewController") as articleTableViewController
        ThirdVC.detailID = articlemainID
        ThirdVC.detailSubId = articlesubID
        self.navigationController?.pushViewController(ThirdVC, animated: true)
        
    }

}
