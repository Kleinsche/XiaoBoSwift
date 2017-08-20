//
//  WebViewController.swift
//  XiaoBoSwift
//
//  Created by 🍋 on 2017/5/31.
//  Copyright © 2017年 🍋. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let wkWebView = WKWebView(frame: view.frame)
        view.addSubview(wkWebView)
        //自适应
        wkWebView.autoresizingMask = [.flexibleHeight]
        
        if let url = URL(string: "http://www.baidu.com") {
            let request = URLRequest(url: url)
            wkWebView.load(request)
            
        }
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
