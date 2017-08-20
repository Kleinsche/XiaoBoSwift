//
//  ReviewViewController.swift
//  XiaoBoSwift
//
//  Created by 🍋 on 2017/4/24.
//  Copyright © 2017年 🍋. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {
    @IBOutlet var bgImageView: UIImageView!
    @IBOutlet var ratingStackView: UIStackView!
    var rating:String?

    override func viewDidLoad() {
        super.viewDidLoad()

        //添加特效
        let effect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: effect)
        blurEffectView.frame = view.frame
        bgImageView.addSubview(blurEffectView)
        
        //动画 位置 大小
        let startPos = CGAffineTransform(translationX: 0, y: 500)
        let startScale = CGAffineTransform(scaleX: 0, y: 0)
        //动画组合
        ratingStackView.transform = startScale.concatenating(startPos)
    }

    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: [], animations: {
            let endPos = CGAffineTransform(translationX: 0, y: 0)
            let endScale = CGAffineTransform.identity
            self.ratingStackView.transform = endScale.concatenating(endPos)
        }, completion: nil)
        
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

    @IBAction func ratingTap(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            rating = "dislike"
        case 2:
            rating = "good"
        case 3:
            rating = "great"
        default:
            break
        }
        performSegue(withIdentifier: "unwindToDetailView", sender: self)
    }

}
