//
//  BadgeViewController.swift
//  PerfectPianoPractice
//
//  Created by Lew Flauta on 6/7/15.
//  Copyright (c) 2015 lew flauta. All rights reserved.
//

import UIKit
import CoreData

class AwardViewController: UIViewController, UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {

//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }


    @IBOutlet weak var tableView: UITableView!
    var awards:[Award] = []

    @IBOutlet weak var awardTextBox: UITextField!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self

//        var award1 = Award()
//        award1.name = "🏆🎼Good Job!"
//        self.awards.append(award1)
//        self.awardTextBox.delegate = self;

    }

    func textFieldShouldReturn(userText: UITextField) -> Bool {
        userText.resignFirstResponder()
        return true;
    }

    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        var context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
        var request = NSFetchRequest(entityName: "Award")
        self.awards = context.executeFetchRequest(request, error: nil) as! [Award]
        self.tableView.reloadData()
    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.awards.count
    }


    @IBAction func deletePressed(sender: UIBarButtonItem) {
        self.awards.removeLast()
        self.tableView.reloadData()
    }

    @IBAction func addAward(sender: UIBarButtonItem) {
        var context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
        var award=NSEntityDescription.insertNewObjectForEntityForName("Award", inManagedObjectContext: context) as! Award
        award.name = awardTextBox.text
        self.awards.append(award)
        self.tableView.reloadData()
        context.save(nil)
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var award = self.awards[indexPath.row]
        var cell=UITableViewCell()
        cell.textLabel!.text=award.name
        return cell
    }



}
