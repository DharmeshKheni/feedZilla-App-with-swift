//
//  WebViewController.swift
//  table
//
//  Created by Anil on 01/01/15.
//  Copyright (c) 2015 Variya Soft Solutions. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    var baseURL : String = String()
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        webView.scrollView.scrollEnabled = true
        let url = NSURL(string: baseURL)
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
    }

}
