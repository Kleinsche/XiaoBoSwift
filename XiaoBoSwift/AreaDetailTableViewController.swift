//
//  AreaDetailTableViewController.swift
//  XiaoBoSwift
//
//  Created by 🍋 on 2017/4/17.
//  Copyright © 2017年 🍋. All rights reserved.
//

import UIKit

class AreaDetailTableViewController: UITableViewController {
    var area:AreaMO!
    @IBOutlet var areaImageView: UIImageView!
    @IBOutlet var ratingBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        areaImageView.image = UIImage.init(data: area.image! as Data)
        self.title = "详情"
        if let rating = area.rating {
            ratingBtn.setImage(UIImage(named: rating), for: .normal)
        }
        
        tableView.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        //去除多余线条
        tableView.tableFooterView = UIView(frame: .zero)
        //分割线颜色
        tableView.separatorColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        //预计行高
        tableView.estimatedRowHeight = 36
        //实际行高
        tableView.rowHeight = UITableViewAutomaticDimension
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! AreaDetailTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.fieldLabel.text = "地名"
            cell.valueLabel.text = area.name
        case 1:
            cell.fieldLabel.text = "省份"
            cell.valueLabel.text = area.province
        case 2:
            cell.fieldLabel.text = "地区"
            cell.valueLabel.text = area.part
        case 3:
            cell.fieldLabel.text = "去否"
            cell.valueLabel.text = area.isVisited ? "去过" : "没去过"
        default: break
            
        }
        

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMap" {
            let map = segue.destination as! MapViewController
            map.area = self.area
        }
    }
    
    
    @IBAction func close(segue:UIStoryboardSegue) {
        let reviewVC = segue.source as! ReviewViewController
        if  let rating = reviewVC.rating {
            self.area.rating = rating
            self.ratingBtn.setImage(UIImage(named: rating), for: .normal)
//            self.reloadInputViews()
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.saveContext()
        
    }

}
