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
//    var tableView1: UITableView!
    var cellTitles = ["0x15", "0x2", "0x3", "0x4", "0x5", "0x6", "0x7", "0x8", "0x9", "0xA", "0xB",
                      "0xC", "0xD", "0xE"]


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
//        tableView1 = UITableView(frame: CGRect(x: 10,y: 10,width: 300,height: 300),style: UITableViewStyle.Grouped)
//        tableView1.backgroundColor=UIColor.redColor();
//        self.tableView1.delegate=self;
//        self.tableView1.dataSource=self;
//        self.tableView1.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell");
//  self.view.addSubview(tableView1);
        var realm = try! Realm()
        var alldata = realm.objects(Data)
        //获取数据列表的某一个位置的数据
        print(alldata[3])
        
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
            //获取数据列表
             var realm = try! Realm()
            var alldata = realm.objects(Data)
            //获取数据列表的某一个位置的数据
            print(alldata[3])
     
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }


    func insertNewObject(sender: AnyObject) {
        objects.insert(NSDate(), atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
       
        
        let data = Data()
        data.money=(mytextField?.text)!;
        var realm = try! Realm()
        try! realm.write {
            realm.add(data)
        }

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
        
        var realm = try! Realm()
        var alldata = realm.objects(Data)
        let strVar : String = String(alldata[indexPath.row].money)
       
        cell.textLabel!.text = mytextField?.text
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
       
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    


}



