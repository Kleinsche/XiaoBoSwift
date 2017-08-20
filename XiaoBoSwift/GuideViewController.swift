//
//  GuideViewController.swift
//  XiaoBoSwift
//
//  Created by 🍋 on 2017/5/25.
//  Copyright © 2017年 🍋. All rights reserved.
//

import UIKit

class GuideViewController: UIPageViewController,UIPageViewControllerDataSource {
    var headings = ["Swift 3","iOS 10","零基础"]
    var images = ["swift","iOS","beginner"]
    var footers = ["Swift 3语法适配，快人一步","iOS 10版本新特性，马上学习","无需预备知识，新手也能轻松入门"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

        //设置数据源为自身
        dataSource = self
        //创建第一个界面
        if let startVC = vc(atIndex: 0) {
            setViewControllers([startVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! ContentViewController).index
        print(index)
        index -= 1
        
        return vc(atIndex: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! ContentViewController).index
        print(index)
        index += 1
        
        return vc(atIndex: index)
    }
    
    func vc(atIndex : Int) -> ContentViewController? {
        //判断index是否在合理区间
        if case 0..<headings.count = atIndex {
            //初始化
            if let contentVC = storyboard?.instantiateViewController(withIdentifier: "ContentController") as? ContentViewController {
                contentVC.header = headings[atIndex]
                contentVC.imageName = images[atIndex]
                contentVC.footer = footers[atIndex]
                contentVC.index = atIndex
                
                return contentVC
            }
        }
        return nil
    }
    
//    func presentationCount(for pageViewController: UIPageViewController) -> Int {
//        return headings.count
//    }
//    
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        return 0
//    }

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
