//
//  ContentViewController.swift
//  XiaoBoSwift
//
//  Created by 🍋 on 2017/5/24.
//  Copyright © 2017年 🍋. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {
    @IBOutlet var labelHeading: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var labelFooter: UILabel!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var btnDone: UIButton!
    
    var index = 0
    var header = ""
    var imageName = ""
    var footer = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()

        labelHeading.text = header
        imageView.image = UIImage.init(named: imageName)
        labelFooter.text = footer
        pageControl.currentPage = index
        btnDone.isHidden = index != 2
    }
    
    @IBAction func doneAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "GuiderShow")
        
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
