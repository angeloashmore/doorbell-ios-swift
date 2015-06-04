//
//  SettingsAboutViewController.swift
//  Doorbell
//
//  Created by Angelo on 6/3/15.
//  Copyright (c) 2015 Doorbell. All rights reserved.
//

import UIKit
import WebKit

class SettingsAboutViewController: UIViewController {
    // MARK: Class Properties


    // MARK: Instance Properties
    var webView: WKWebView?


    // MARK: Life-Cycle Properties
    override func viewDidLoad() {
        super.viewDidLoad()

        loadWebView()
    }


    // MARK: Methods
    func loadWebView() {
        self.webView = WKWebView(frame: CGRectZero)
        self.view.addSubview(self.webView!)

        self.webView?.setTranslatesAutoresizingMaskIntoConstraints(false)
        let height = NSLayoutConstraint(item: self.webView!, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1, constant: 0)
        let width = NSLayoutConstraint(item: self.webView!, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0)
        view.addConstraints([height, width])

        let url = NSURL(string: "http://doorbell.im")
        let request = NSURLRequest(URL: url!)
        self.webView?.loadRequest(request)
    }
}
