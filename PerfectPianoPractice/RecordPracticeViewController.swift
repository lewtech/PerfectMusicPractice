//
//  RecordPracticeViewController.swift
//  PerfectPianoPractice
//
//  Created by lew flauta on 6/4/15.
//  Copyright (c) 2015 lew flauta. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData



class RecordPracticeViewController : UIViewController {

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
                saveButton.enabled=false
    }
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var titleTextBox: UITextField!
    var previousViewController = ViewController()
    var audioRecorder: AVAudioRecorder
    var audioURL: String
    @IBOutlet weak var saveButton: UIBarButtonItem!


    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    

    @IBAction func recordTapped(sender: UIButton) {

        if self.audioRecorder.recording {
            self.audioRecorder.stop()
            self.recordButton.setTitle("RECORD", forState: UIControlState.Normal)
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
    

    @IBAction func saveButtonPressed(sender: UIBarButtonItem) {
        var context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
        //creates RecordedAudioobject
        var record=NSEntityDescription.insertNewObjectForEntityForName("Record", inManagedObjectContext: context) as! Record
        record.name = self.titleTextBox.text
        record.url = self.audioURL
        record.day = "monday"
        record.time = 2
        record.isCompleted=true

        
        //add sound to ViewController-tableview
        //self.previousViewController.sounds.append(record)

        //save recording to core data
        context.save(nil)

        
        
        //dismiss RecordPracticeViewController
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

  
}
