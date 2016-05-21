//
//  MasterViewController.swift
//  SkipYourSupper
//
//  Created by RENHAO on 2016. 5. 8..
//  Copyright © 2016년 RENHAO. All rights reserved.
//

import UIKit
import RealmSwift

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()
    var mytextField: UITextField?
    var cellTitles = ["0x15", "0x2", "0x3", "0x4", "0x5", "0x6", "0x7", "0x8", "0x9", "0xA", "0xB",
                      "0xC", "0xD", "0xE"]
    var alldata:Results<Data>?

    @IBOutlet var tableview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(messageBox(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        self.tableview.delegate = self
//        tableView1 = UITableView(frame: CGRect(x: 10,y: 10,width: 300,height: 300),style: UITableViewStyle.Grouped)
//        tableView1.backgroundColor=UIColor.redColor();
//        self.tableView1.delegate=self;
//        self.tableView1.dataSource=self;
//        self.tableView1.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell");
//  self.view.addSubview(tableView1);

        
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //알리창 열기
    func messageBox(sender: AnyObject) {
        let alert = UIAlertController(title:"title",message:"message",preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler { (textField)  ->Void in
            self.mytextField = textField
            self.mytextField!.placeholder = "enter you login ID"
            
            
        }
        
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: {
            action in self.insertNewObject(self.objects)
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: UIAlertActionStyle.Cancel, handler: {
            action in print("hello")
     
     
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }


    func insertNewObject(sender: AnyObject) {
       
        objects.insert(NSDate(), atIndex: 0)
        let realm = try! Realm()
        let alldata = realm.objects(Data)
        let data = Data()
        data.money=(mytextField?.text)!
        data.sno = alldata.count+1
        data.date = getTime()
        try! realm.write {
            realm.add(data)
        }
        //alldata.count-1 or 0 表示 插入的列表是从哪里开始的
        let indexPath = NSIndexPath(forRow: alldata.count-1, inSection: 0)
        // 下面的两个 tableview方法依次进行 估计其他UI组件也是这种机制
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
       
        }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row] as! NSDate
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         let realm = try! Realm()
         let alldata = realm.objects(Data)
         return alldata.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
   //     let object = objects[indexPath.row] as! NSDate
//         var realm = try! Realm()
//         var alldata = realm.objects(Data)
 //       cell.textLabel!.text = mytextField?.text
        let realm = try! Realm()
        let alldata = realm.objects(Data)
        let item = alldata[indexPath.row]
        
        cell.textLabel!.text = item.money
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
       
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    //删除cell时的
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let realm = try! Realm()
            let alldata = realm.objects(Data)
           //删除制定的DB内容
            try! realm.write {
                realm.delete(alldata[indexPath.row])
            }
         //   objects.removeAtIndex(indexPath.row)
        // 显示点击cell的位置
            print("delele is"+String(indexPath.row))
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    func getTime() -> String {
        let date = NSDate()
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd 'at' HH:mm:ss.SSS"
        let strNowTime = timeFormatter.stringFromDate(date) as String
        return strNowTime
    }

}



