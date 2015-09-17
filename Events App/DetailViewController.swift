//
//  DetailViewController.swift
//  Events App
//
//  Created by Gladwin Dosunmu on 15/09/2015.
//  Copyright © 2015 Gladwin Dosunmu. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var eventWebView: UIWebView!

    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        
        if let detail = self.detailItem {
            if let wv = self.eventWebView {
                
                let url = NSURL(string: detail.valueForKey("eventLink")!.description)
                
                let request = NSURLRequest(URL: url!)
                
                wv.loadRequest(request)
                
            }
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

