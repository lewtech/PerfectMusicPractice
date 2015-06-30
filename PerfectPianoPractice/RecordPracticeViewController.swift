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

    @IBOutlet weak var timerLabel: UILabel!
    var startTime = NSTimeInterval()
    var timer = NSTimer()


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


    func updateTime() {

        var currentTime = NSDate.timeIntervalSinceReferenceDate()

        //Find the difference between current time and start time.

        var elapsedTime: NSTimeInterval = currentTime - startTime

        //calculate the minutes in elapsed time.

        let minutes = UInt8(elapsedTime / 60.0)

        elapsedTime -= (NSTimeInterval(minutes) * 60)

        //calculate the seconds in elapsed time.

        let seconds = UInt8(elapsedTime)

        elapsedTime -= NSTimeInterval(seconds)

        //find out the fraction of milliseconds to be displayed.

        let fraction = UInt8(elapsedTime * 100)

        //add the leading zero for minutes, seconds and millseconds and store them as string constants

        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%02d", fraction)
        
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        
        timerLabel.text = "\(strMinutes):\(strSeconds):\(strFraction)"

        
    }
    

    @IBAction func recordTapped(sender: UIButton) {

        if self.audioRecorder.recording {
            self.audioRecorder.stop()
            self.recordButton.setTitle("RECORD", forState: UIControlState.Normal)
            saveButton.enabled=true

            //timer function
            timer.invalidate()
            //timer = nil
            
        } else {
            self.audioRecorder.stop()
            var session = AVAudioSession.sharedInstance()
            session.setActive(true, error: nil)
            self.audioRecorder.record()
            self.recordButton.setTitle("Finish recording", forState: UIControlState.Normal)
            saveButton.enabled=false

            //timer function
            let aSelector : Selector = "updateTime"
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            startTime = NSDate.timeIntervalSinceReferenceDate()
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
