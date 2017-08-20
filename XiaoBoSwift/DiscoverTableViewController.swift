//
//  discoverTableViewController.swift
//  XiaoBoSwift
//
//  Created by 🍋 on 2017/5/30.
//  Copyright © 2017年 🍋. All rights reserved.
//

import UIKit

class DiscoverTableViewController: UITableViewController {
    var areas: [AVObject] = []
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)

//        self.spinner.center = view.center
//        view.addSubview(self.spinner)
        getDataFromCloud()
    }
    
    func refreshData() {
        getDataFromCloud(needUpdata: true)
    }
    
    func getDataFromCloud(needUpdata: Bool = false) {
        let query = AVQuery(className: "Area")
        //排序
//        let sd = NSSortDescriptor(key: "name", ascending: true)
//        query.order(bySortDescriptors: [sd])
        
        if needUpdata {
            query.cachePolicy = .ignoreCache //不缓存
        } else {
            //从缓存读取数据
            query.cachePolicy = .cacheElseNetwork
            query.maxCacheAge = 60 * 2    //2分钟
            if query.hasCachedResult() {
                print("当前从缓存中查询结果")
            }
        }
       
        query.findObjectsInBackground { (results, error) in
            if let results = results {
                print(results)
                self.areas = results as! [AVObject]
                OperationQueue.main.addOperation {
                    self.refreshControl?.endRefreshing()
                    self.tableView.reloadData()
                }
            }else{
                print(error ?? "获取数据未知错误")
                self.refreshControl?.endRefreshing()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return areas.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let area = areas[indexPath.row]
        cell.textLabel?.text = area["name"] as? String
        cell.imageView?.image = #imageLiteral(resourceName: "photoalbum")
        
        if let imgFile = area["image"] as? AVFile {
            imgFile.getDataInBackground({ (data, error) in
                if let data = data {
                    OperationQueue.main.addOperation {
                        cell.imageView?.image = UIImage(data: data)
                    }
                }else{
                    print(error ?? "获取图片未知错误")
                }
            })
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
