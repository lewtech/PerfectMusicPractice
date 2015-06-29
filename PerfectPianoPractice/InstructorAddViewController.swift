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




class InstructorAddViewController : UIViewController {

    var awards:[Award] = []
    @IBOutlet weak var toDoTextField: UITextField!
    @IBOutlet weak var badgeTextfield: UITextField!
    var awardViewController = AwardViewController()

    var sounds: [Record] = []



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

        } else {
            self.audioRecorder.stop()
            var session = AVAudioSession.sharedInstance()
            session.setActive(true, error: nil)
            self.audioRecorder.record()
            self.recordAccompaniment.setTitle("Finish recording", forState: UIControlState.Normal)
            saveButton.enabled=false
        }
    }

    @IBAction func resetForWeekButtonPressed(sender: UITextField) {


    }


    @IBAction func saveButtonPressed(sender: UIBarButtonItem) {

        //creates RecordedAudioobject
        var record=NSEntityDescription.insertNewObjectForEntityForName("Record", inManagedObjectContext: context) as! Record
        record.name = toDoTextField.text
        record.url = self.audioURL
        record.day = "monday"
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
