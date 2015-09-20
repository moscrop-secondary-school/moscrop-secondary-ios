//
//  NewsDetailViewController.swift
//  MoscropSecondary
//
//  Created by Ivon Liu on 9/20/15.
//  Copyright (c) 2015 Ivon Liu. All rights reserved.
//

import UIKit
import Parse
import Bolts

class NewsDetailViewController: UIViewController {

    @IBOutlet weak var contentWebView: UIWebView!
    var post: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if post != nil {
            if let title = post!["title"] as? String {
                self.navigationItem.title = title
            }
            if let content = post!["content"] as? String {
                contentWebView.loadHTMLString(processHtml(content), baseURL: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func processHtml(bodyHTML: String) -> String {
        let head = "<head><style>img{max-width: 90%; width:auto; height: auto;}</style></head>"
        let content = "<html>" + head + "<body>" + bodyHTML + "</body></html>"
        return content
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
