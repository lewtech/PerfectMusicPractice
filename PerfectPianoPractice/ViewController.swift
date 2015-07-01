//
//  ViewController.swift
//  PerfectPianoPractice
//
//  Created by lew flauta on 6/3/15.
//  Copyright (c) 2015 lew flauta. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

        var context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,RecordTableViewCellDelegate{

    @IBAction func unwind(segue:UIStoryboardSegue){
        
    }


    func recordChanged(record: Record, action: String) {

        if (action=="delete"){
        var index = 0
        for i in 0..<sounds.count {
            if sounds[i] === record {  // note: === not ==
                index = i
                break
            }
        }

            context.deleteObject(record)
            context.save(nil)

        sounds.removeAtIndex(index)

        
        tableView.beginUpdates()
        let indexPathForRow = NSIndexPath(forRow: index, inSection: 0)
            tableView.deleteRowsAtIndexPaths([indexPathForRow], withRowAnimation: .Fade)}
            
        else { if (record.isCompleted==false) {
            record.isCompleted=true
            performSegueWithIdentifier("recordSegue", sender: nil)}
        else if (record.isCompleted==true){record.isCompleted=false}



        }
        tableView.endUpdates()
        self.tableView.reloadData()
    }

    func recordComplete(record: Record) {
        var index = 0
        for i in 0..<sounds.count {
        if sounds[i] === record {  // note: === not ==
        index = i
        break
        }
        }
        var recordToComplete = sounds[index]
        recordToComplete.isCompleted = true
        self.tableView.reloadData()

    }

    @IBOutlet weak var tableView: UITableView!
    
    var audioPlayer = AVAudioPlayer()
    
    var sounds: [Record] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource=self
        self.tableView.delegate=self
        self.tableView.registerClass(RecordTableViewCell.self, forCellReuseIdentifier: "recordID")
        self.tableView.backgroundColor = UIColor.grayColor()
        
//        var soundPath = NSBundle.mainBundle().pathForResource("testaudio", ofType: "m4a")
//        var soundURL = NSURL.fileURLWithPath(soundPath!)

        //var record1=NSEntityDescription.insertNewObjectForEntityForName("Record", inManagedObjectContext: context) as Record
        //record1.name="My Sound"
        //record1.url = soundURL!.absoluteString! //converts url into a string



        self.tableView.reloadData()
        
        


    }

    func save() {
        var error: NSError?
        if (context.save(&error)){
            println(error?.localizedDescription)
        }
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        var request = NSFetchRequest(entityName: "Record")
        self.sounds = context.executeFetchRequest(request, error: nil) as! [Record]
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sounds.count
    }

    @IBAction func unwindToStudentViewController (segue:UIStoryboardSegue){
        
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var record=self.sounds[indexPath.row]
        //var cell=UITableViewCell()
        let cellIdentifier = "recordID"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
            as! RecordTableViewCell

        cell.textLabel?.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = .None
        let item=sounds[indexPath.row]
        cell.textLabel!.text = record.day + ": " + record.name  
        cell.detailTextLabel?.text = "text"

//        cell.detailTextLabel!.text="text"
        //cell.detail.text = "test"
        cell.record = item
        if (record.isCompleted == true) {
            cell.accessoryType = .Checkmark
        } else {cell.accessoryType = .None}
        cell.delegate = self

        
        
        
        
        return cell
        
    }


    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var record = self.sounds[indexPath.row]

        var baseString : String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as! String
        var pathComponents = [baseString, record.url]
        var audioNSURL = NSURL.fileURLWithPathComponents(pathComponents)

        self.audioPlayer = AVAudioPlayer(contentsOfURL: audioNSURL, error: nil)
        self.audioPlayer.play()


        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

        if(editingStyle == UITableViewCellEditingStyle.Delete) {
            //tableData.removeAtIndex(indexPath.row)
            self.tableView.reloadData()
        }
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var nvc = segue.destinationViewController as! RecordPracticeViewController
        nvc.previousViewController = self //so i have reference from old
    }
   

}

