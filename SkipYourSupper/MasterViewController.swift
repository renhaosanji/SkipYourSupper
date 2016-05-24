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
    var mytextField_money: UITextField?
    var mytextField_food: UITextField?
    var mytextField_type: UITextField?
    var mytextField_calorie: UITextField?

    @IBOutlet weak var Total_money: UILabel!
    @IBOutlet var tableview: UITableView!
    var total_money2 = 0

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
     Total_money.text = String(getTotal_money())
        
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
        let alert = UIAlertController(title:"Supper Detail Information",message:"Input the information of supper you want to eat",preferredStyle: UIAlertControllerStyle.Alert)
        let realm = try! Realm()
        let alldata = realm.objects(Data).last
        print(alldata)
        alert.addTextFieldWithConfigurationHandler { (textField)  ->Void in
            self.mytextField_money = textField
            self.mytextField_money?.keyboardType = UIKeyboardType.NumberPad
            self.mytextField_money!.placeholder = "enter how much you will to use"
            self.mytextField_money!.text = alldata?.money
            }
        alert.addTextFieldWithConfigurationHandler { (textField)  ->Void in
            self.mytextField_food = textField
            self.mytextField_food!.placeholder = "enter the food name"
            self.mytextField_food!.text = alldata?.food
        }
        alert.addTextFieldWithConfigurationHandler { (textField)  ->Void in
            self.mytextField_type = textField
            self.mytextField_type!.placeholder = "enter the food type"
            self.mytextField_type!.text = alldata?.type
        }
        alert.addTextFieldWithConfigurationHandler { (textField)  ->Void in
            self.mytextField_calorie = textField
            self.mytextField_calorie!.placeholder = "enter the food calorie"
            self.mytextField_calorie!.text = alldata?.calorie
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
        data.money=(mytextField_money?.text)!
        data.calorie=(mytextField_calorie?.text)!
        data.food=(mytextField_food?.text)!
        data.type=(mytextField_type?.text)!
        data.sno = alldata.count+1
        data.date = getTime()
        try! realm.write {
            realm.add(data)
        }
        total_money2=0
        self.Total_money.text = String(getTotal_money())
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

        let realm = try! Realm()
        let alldata = realm.objects(Data)
        let item = alldata[indexPath.row]
        
        
        cell.textLabel!.text = "Save "+item.money+"$ and"+item.calorie+"cal without"+item.type+"will to eat"+item.food
        cell.textLabel?.adjustsFontSizeToFitWidth
        cell.textLabel?.numberOfLines=0
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
            //减去相应的total值：重新导入数据，total_money要清零
            total_money2=0
            self.Total_money.text = String(getTotal_money())
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
    func getTotal_money() -> Int {
    let realm = try! Realm()
    let alldata = realm.objects(Data)
        for data in alldata {
            let myString: String = data.money
            let myInt: Int? = Int(myString)
            total_money2 = total_money2+myInt!
        }
    
    return total_money2
    }

}



