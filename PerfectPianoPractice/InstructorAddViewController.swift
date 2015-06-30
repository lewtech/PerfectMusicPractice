//
//  InstructorAddViewController.swift
//  PerfectPianoPractice
//
//  Created by Lew Flauta on 6/6/15.
//  Copyright (c) 2015 lew flauta. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData






class InstructorAddViewController : UIViewController  {

    var awards:[Award] = []
    @IBOutlet weak var toDoTextField: UITextField!
    @IBOutlet weak var badgeTextfield: UITextField!
    var awardViewController = AwardViewController()

    @IBOutlet weak var daySegmentedControl: UISegmentedControl!
    var sounds: [Record] = []
    var daySelectedInt: Int




    @IBOutlet weak var awardTextBox: UITextField!
    @IBOutlet weak var recordAccompaniment: UIButton!

    required init(coder aDecoder: NSCoder) {
        var baseString : String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as! String
        self.audioURL = NSUUID().UUIDString + ".m4a"
        var pathComponents = [baseString, self.audioURL]
        var audioNSURL = NSURL.fileURLWithPathComponents(pathComponents)

        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)

        var recordSettings: [NSObject : AnyObject] = Dictionary()
        recordSettings[AVFormatIDKey] = kAudioFormatMPEG4AAC
        recordSettings[AVSampleRateKey] = 44100.0
        recordSettings[AVNumberOfChannelsKey] = 2

        self.audioRecorder = AVAudioRecorder(URL: audioNSURL, settings: recordSettings, error: nil)
        self.audioRecorder.meteringEnabled = true
        self.audioRecorder.prepareToRecord()
        self.daySelectedInt=0
        // Super init is below
        super.init(coder: aDecoder)
    }

    override func viewWillAppear(animated: Bool) {
 //       saveButton.enabled=false
        badgeTextfield.hidden=false
        addBadgeButton.hidden=false
        recordButton.hidden=false
        addTodoButton.hidden=false
        var request = NSFetchRequest(entityName: "Record")
        self.sounds = context.executeFetchRequest(request, error: nil) as! [Record]


        
    }

    @IBOutlet weak var recordButton: UIButton!

    @IBOutlet weak var titleTextBox: UITextField!
    var previousViewController = InstructorViewController()
    var audioRecorder: AVAudioRecorder
    var audioURL: String
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var addTodoButton: UIButton!
    @IBOutlet weak var badgeTextBox: UITextField!
    @IBOutlet weak var addBadgeButton: UIButton!

    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)

    }


    @IBAction func recordTapped(sender: UIButton) {

        if self.audioRecorder.recording {
            self.audioRecorder.stop()
            self.recordButton.setTitle("Record Lesson", forState: UIControlState.Normal)
            saveButton.enabled=true
            var record=NSEntityDescription.insertNewObjectForEntityForName("Record", inManagedObjectContext: context) as! Record
            record.name = toDoTextField.text
            record.url = self.audioURL
            record.day = "Lesson Recording"
            NSLog(record.day)
            record.time = 2
            record.isCompleted=true
            record.uuid = NSUUID().UUIDString
            context.save(nil)

        } else {
            self.audioRecorder.stop()
            var session = AVAudioSession.sharedInstance()
            session.setActive(true, error: nil)
            self.audioRecorder.record()
            self.recordButton.setTitle("Finish recording", forState: UIControlState.Normal)
            saveButton.enabled=false
        }
    }

    @IBAction func addAwardPressed(sender: AnyObject) {
        var context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
        var award=NSEntityDescription.insertNewObjectForEntityForName("Award", inManagedObjectContext: context) as! Award
        award.name = awardTextBox.text
        self.awards.append(award)
        //self.tableView.reloadData()
        context.save(nil)
    }

    @IBAction func recordAccompanimentPressed(sender: UIButton) {

        if self.audioRecorder.recording {
            self.audioRecorder.stop()
            self.recordAccompaniment.setTitle("Record Accompaniment", forState: UIControlState.Normal)
            saveButton.enabled=true
           // titleTextBox.text = ""
            var record=NSEntityDescription.insertNewObjectForEntityForName("Record", inManagedObjectContext: context) as! Record
            record.name = toDoTextField.text
            record.url = self.audioURL
            record.day = "accompinament recording"
            NSLog(record.day)
            record.time = 2
            record.isCompleted=true
            record.uuid = NSUUID().UUIDString
            context.save(nil)

        } else {
            self.audioRecorder.stop()
            var session = AVAudioSession.sharedInstance()
            session.setActive(true, error: nil)
            self.audioRecorder.record()
            self.recordAccompaniment.setTitle("Finish recording", forState: UIControlState.Normal)
            saveButton.enabled=false
        }
    }

    @IBAction func resetForTheWeekPressed(sender: UIButton) {
        //iterate through awards
        //delets all awards

        //iterate through records
        //delete all records
        //also delete recording
        for i in 0..<sounds.count{
/*            var record = sounds[i]
            var baseString : String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as! String
            var pathComponents = [baseString, record.url]
            var audioNSURL = NSURL.fileURLWithPathComponents(pathComponents)
            NSFileManager.defaultManager().removeItemAtPath(audioNSURL, error: nil) */



            
            context.deleteObject(sounds[i])
            context.save(nil)
        }

        for i in 0..<awards.count{
            context.deleteObject(awards[i])
            context.save(nil)
        }


        //sounds.removeAtIndex(index)
    }



    @IBAction func addToDoPressed(sender: UIButton) {
        var record=NSEntityDescription.insertNewObjectForEntityForName("Record", inManagedObjectContext: context) as! Record
        record.name = toDoTextField.text
        record.url = self.audioURL
        record.day = daySegmentedControl.titleForSegmentAtIndex(daySelectedInt)!
        record.sortPriority = daySelectedInt
        record.time = 0
        record.isCompleted=false
        record.uuid = NSUUID().UUIDString


        context.save(nil)
    }

    @IBAction func daySelected(sender: UISegmentedControl) {
        daySelectedInt = daySegmentedControl.selectedSegmentIndex

    }

    @IBAction func saveButtonPressed(sender: UIBarButtonItem) {

        //creates RecordedAudioobject
        var record=NSEntityDescription.insertNewObjectForEntityForName("Record", inManagedObjectContext: context) as! Record
        record.name = toDoTextField.text
        record.url = self.audioURL
        record.day = daySegmentedControl.titleForSegmentAtIndex(daySelectedInt)!
        NSLog(record.day)
        record.time = 2
        record.isCompleted=false
        record.uuid = NSUUID().UUIDString




        //add sound to ViewController-tableview
        //self.previousViewController.sounds.append(record)

        //save recording to core data
        context.save(nil)

//        var award=Award()
//        award.name = badgeTextfield.text
//        self.awardViewController.awards.append(award)



        //dismiss RecordPracticeViewController
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
}
