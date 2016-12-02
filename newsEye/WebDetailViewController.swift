//
//  WebDetailViewController.swift
//  newsEye
//
//  Created by Patientman on 2016/12/1.
//  Copyright © 2016年 mingSquall. All rights reserved.
//

import UIKit

class WebDetailViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!

    var url: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webView.loadRequest(URLRequest(url: URL(string: url!)!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
