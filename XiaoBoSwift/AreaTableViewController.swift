//
//  AreaTableViewController.swift
//  XiaoBoSwift
//
//  Created by 🍋 on 2017/4/15.
//  Copyright © 2017年 🍋. All rights reserved.
//

import UIKit
import CoreData

class AreaTableViewController: UITableViewController,NSFetchedResultsControllerDelegate,UISearchResultsUpdating {
    
    
    var areas : [AreaMO] = []
    var fc : NSFetchedResultsController<AreaMO>!
    var sc : UISearchController!
    var searchResult : [AreaMO] = []

    
//    //无导航栏生效 修改状态条样式
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
 
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text {
            searchFilter(text: text.trimmingCharacters(in: .whitespaces))
            tableView.reloadData()
        }
    }
    
    func searchFilter(text : String) {
        searchResult = areas.filter { (area) -> Bool in
            return area.name!.localizedCaseInsensitiveContains(text)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "GuiderShow") {
            return
        }
        
        if let pageVC = storyboard?.instantiateViewController(withIdentifier: "GuideController") as? GuideViewController {
            present(pageVC, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        🔍
        sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        tableView.tableHeaderView = sc.searchBar
        //背景不变暗
        sc.dimsBackgroundDuringPresentation = false
        //背景不模糊
//        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "请输入地名..."
        sc.searchBar.tintColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
        sc.searchBar.barTintColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
//        sc.searchBar.searchBarStyle = .minimal
        sc.hidesNavigationBarDuringPresentation = false
        
        fetchData()
        self.tableView.tableFooterView = UIView(frame: .zero)

        //设置返回按钮格式
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            print("删除成功")
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
            print("保存成功")
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .left)
            print("更新成功")
        default:
            tableView.reloadData()
        }
        
        if let object =  controller.fetchedObjects {
            areas = object as! [AreaMO]
        }
    }
    
    func fetchData() {
        let request : NSFetchRequest<AreaMO> = AreaMO.fetchRequest()
        //数据顺序
        let sd = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sd]
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        //初始化
        fc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        //指定代理
        fc.delegate = self
        
        do {
            try fc.performFetch()
            if let objects = fc.fetchedObjects {
                areas = objects
            }
        } catch  {
            print(error)
        }
    }

//    func fetchAllData() {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        do {
//            try areas = appDelegate.persistentContainer.viewContext.fetch(AreaMO.fetchRequest())
//
//        } catch {
//            print(error)
//        }
//    }
    
    // MARK: - Table view delegate
    /*
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //取消选中行状态
        tableView.deselectRow(at: indexPath, animated: true)
    }
 */
    
    //左划菜单
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let actionVisited = UITableViewRowAction(style: .normal, title: "去过与否") { (UITableViewRowAction, IndexPath) in
            
            let menu = UIAlertController(title: "同学你好", message: "您点击了第\(indexPath.row)行", preferredStyle: .actionSheet)
            let option2 = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let option3 = UIAlertAction(title: "去过", style: .default) { (_) in
                let cell = tableView.cellForRow(at: indexPath) as! CustomTableViewCell
                //            cell?.accessoryType = .checkmark
                cell.visitedImageView.isHidden = false
                self.areas[indexPath.row].isVisited = true
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.saveContext()
            }
            let option4 = UIAlertAction(title: "没去过", style: .destructive, handler: { (_) in
                
                let cell = tableView.cellForRow(at: indexPath) as! CustomTableViewCell
                cell.visitedImageView.isHidden = true
                self.areas[indexPath.row].isVisited = false
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.saveContext()
            })
            menu.addAction(option2)
            menu.addAction(option3)
            menu.addAction(option4)
            self.present(menu, animated: true, completion: nil)
        }
        actionVisited.backgroundColor = #colorLiteral(red: 0.1881445858, green: 0.6972870283, blue: 0.7101966887, alpha: 1)
        
        let actionDelete = UITableViewRowAction(style: .default, title: "删除") { (_, indexPath) in
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            //删除数据库
            context.delete(self.fc.object(at: indexPath))
            appDelegate.saveContext()
            
//            self.areas.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        
        return [actionVisited,actionDelete]
    }

    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sc.isActive ? searchResult.count : areas.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell

        let area = sc.isActive ? searchResult[indexPath.row] : areas[indexPath.row]
        cell.nameLabel.text = area.name
        cell.provinceLabel.text = area.province
        cell.partLabel.text = area.part
        cell.thumbImageView.image = UIImage(data: area.image! as Data)
        
//        cell.thumbImageView.layer.cornerRadius = cell.thumbImageView.frame.height / 2
//        cell.thumbImageView.clipsToBounds = true
        
        if areas[indexPath.row].isVisited {
//            cell.accessoryType = .checkmark
            cell.visitedImageView.isHidden = false
        }else{
//            cell.accessoryType = .none
            cell.visitedImageView.isHidden = true
        }

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return !sc.isActive
    }
    

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            areas.remove(at: indexPath.row)
            areaImages.remove(at: indexPath.row)
            provinces.remove(at: indexPath.row)
            parts.remove(at: indexPath.row)
            visited.remove(at: indexPath.row)
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
        
        if segue.identifier == "showDetail" {
            let dest = segue.destination as! AreaDetailTableViewController
            dest.hidesBottomBarWhenPushed = true
            dest.area = sc.isActive ? searchResult[tableView.indexPathForSelectedRow!.row] : areas[tableView.indexPathForSelectedRow!.row]
        }
        
    }

    
    @IBAction func addAreaBack(segue:UIStoryboardSegue) {
        
    }


    
}
