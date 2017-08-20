//
//  AddAreaController.swift
//  XiaoBoSwift
//
//  Created by 🍋 on 2017/5/10.
//  Copyright © 2017年 🍋. All rights reserved.
//

import UIKit
import  CoreData

class AddAreaController: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet var coverImageView: UIImageView!
    @IBOutlet var tfName: UITextField!
    @IBOutlet var tfProvince: UITextField!
    @IBOutlet var tfPart: UITextField!
    @IBOutlet var labelVisited: UILabel!
    
    var area : AreaMO!
    var isVisited = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }


    // MARK: - Table view data source
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        coverImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.clipsToBounds = true
        
        //设置约束
        let coverWidthCons = NSLayoutConstraint(item: coverImageView, attribute: .width, relatedBy: .equal, toItem: coverImageView.superview, attribute: .width, multiplier: 1, constant: 0)
        let coverHeightCons = NSLayoutConstraint(item: coverImageView, attribute: .height, relatedBy: .equal, toItem: coverImageView.superview, attribute: .height, multiplier: 1, constant: 0)
        coverWidthCons.isActive = true
        coverHeightCons.isActive = true
        
        self.dismiss(animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
                print("相册不可用")
                return
            }
            
            let picker = UIImagePickerController()
            picker.allowsEditing = false
            picker.sourceType = .photoLibrary
            picker.delegate = self
            
            self.present(picker, animated: true, completion: nil)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        if tfName.text == "" || tfProvince.text == "" || tfPart.text == "" {
            let alert = UIAlertController(title: "提示", message: "有信息尚未填写完成", preferredStyle: .alert)
            alert.addAction(.init(title: "确认", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            area = AreaMO(context: appDelegate.persistentContainer.viewContext)
            area.name = tfName.text
            area.province = tfProvince.text
            area.part = tfPart.text
            area.isVisited = isVisited
            if let imageData = UIImageJPEGRepresentation(coverImageView.image!, 0.7) {
                area.image = NSData(data: imageData)
            }
//            print("正在保存...")
            appDelegate.saveContext()
            saveToCloud(area: area)
            
            performSegue(withIdentifier: "unwindToHomeList", sender: self)
        }
    }
    
    @IBAction func isVisitedBtnTap(_ sender: UIButton) {
        if sender.tag == 1 {
            isVisited = true
            labelVisited.text = "我去过"
        }else{
            isVisited = false
            labelVisited.text = "没去过"
        }
    }
    
    func saveToCloud(area: AreaMO!) {
        let cloudObject = AVObject(className: "Area")
        cloudObject["name"] = area.name!
        cloudObject["province"] = area.province!
        cloudObject["part"] = area.part!
        cloudObject["isVisited"] = area.isVisited
        
        let originImg = UIImage(data: area.image! as Data)!
        let scalingFactor = (originImg.size.width > 1024) ? (1024 / originImg.size.width) : 1
        let scaleImg = UIImage(data: area.image! as Data, scale: scalingFactor)
        
        let imgFile = AVFile(name: "\(area.name!).jpg", data: UIImageJPEGRepresentation(scaleImg!, 0.7)!)
        cloudObject["image"] = imgFile
        
        cloudObject.saveInBackground { (succeed, error) in
            if succeed{
                print("云端保存成功")
            }else{
                print(error ?? "云端保存未知错误")
            }
        }
        
    }

}
