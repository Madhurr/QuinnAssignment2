//
//  WebviewViewController.swift
//  newsReaderAssignment2
//
//  Created by Madhur on 23/10/19.
//  Copyright © 2019 Madhur. All rights reserved.
//

import UIKit

class WebviewViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var url: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadRequest(URLRequest(url: URL(string: url!)!))
    }
    

}
