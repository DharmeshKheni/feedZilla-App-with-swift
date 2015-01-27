//
//  articleTableViewController.swift
//  table
//
//  Created by Anil on 01/01/15.
//  Copyright (c) 2015 Variya Soft Solutions. All rights reserved.
//

import UIKit

class articleTableViewController: UITableViewController {

    var url : String = String()
    var detailID : Int = Int()
    var detailSubId : Int = Int()
    var titleText : [String] = []
    var summrText : [String] = []
    var urlText : [String] = []
    var i = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Articles"
        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "v creation trans.png"))
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true

        self.getTopAppsDataFromItunesWithSuccess { (url) -> Void in
            
            let json = JSON(data: url)
            if let array = json["articles"].arrayValue{
                for Dict in array{
                    
                    var title : String = array[self.i]["title"].stringValue!
                    var summery : String = array[self.i]["summary"].stringValue!
                    var url : String = array[self.i]["url"].stringValue!
                    self.titleText.append(title)
                    self.summrText.append(summery)
                    self.urlText.append(url)
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
        
        url = "http://api.feedzilla.com/v1/categories/\(detailID)/subcategories/\(detailSubId)/articles.json"
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
        
        return titleText.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as CustomTableViewCell

        // Configure the cell..
    
        cell.nameLabel.text = self.titleText[indexPath.row]
        cell.addressLabel.text = self.summrText[indexPath.row]
        
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
        
        
        let passURL = urlText[indexPath.row]
        let forthVC = self.storyboard?.instantiateViewControllerWithIdentifier("webView") as WebViewController
        forthVC.baseURL = passURL
        self.navigationController?.pushViewController(forthVC, animated: true)
        
    }

}
