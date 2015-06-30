//
//  RecordTableViewCell.swift
//  PerfectPianoPractice
//
//  Created by Lew Flauta on 6/5/15.
//  Copyright (c) 2015 lew flauta. All rights reserved.
//

import UIKit
import QuartzCore

// A protocol that the TableViewCell uses to inform its delegate of state change
protocol RecordTableViewCellDelegate {
    // indicates that the given item has been deleted
    func recordChanged(record: Record, action: String)

}



class RecordTableViewCell: UITableViewCell {

    @IBOutlet weak var detail: UILabel!
    let gradientLayer = CAGradientLayer()
    var originalCenter = CGPoint()
    var deleteOnDragRelease = false, completeOnDragRelease = false
    var tickLabel: UILabel, crossLabel: UILabel
//    let label: StrikeThroughText
    var itemCompleteLayer = CALayer()



    // The object that acts as delegate for this cell.
    var delegate: RecordTableViewCellDelegate?
//    var delegate2: RecordTableViewCellDelegate2?
    // The item that this cell renders.
    var record : Record? {
        didSet {
//            label.text = toDoItem!.text
//            label.strikeThrough = toDoItem!.completed
//            itemCompleteLayer.hidden = !label.strikeThrough

        }
    }



    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {

        // create a label that renders the to-do item text
//        label = StrikeThroughText(frame: CGRect.nullRect)
//        label.textColor = UIColor.whiteColor()
//        label.font = UIFont.boldSystemFontOfSize(16)
//        label.backgroundColor = UIColor.clearColor()

        // utility method for creating the contextual cues
        func createCueLabel() -> UILabel {
            let label = UILabel(frame: CGRect.nullRect)
            label.textColor = UIColor.whiteColor()
            label.font = UIFont.boldSystemFontOfSize(32.0)
            label.backgroundColor = UIColor.clearColor()
            return label
        }

        // tick and cross labels for context cues
        tickLabel = createCueLabel()
        tickLabel.text = "\u{2713}"
        tickLabel.textAlignment = .Right
        crossLabel = createCueLabel()
        crossLabel.text = "\u{2717}"
        crossLabel.textAlignment = .Left

        super.init(style: style, reuseIdentifier: reuseIdentifier)

//        addSubview(label)
        addSubview(tickLabel)
        addSubview(crossLabel)
        // remove the default blue highlight for selected cells
        selectionStyle = .None

        // gradient layer for cell
        gradientLayer.frame = bounds
        let color1 = UIColor(white: 1.0, alpha: 0.2).CGColor as CGColorRef
        let color2 = UIColor(white: 1.0, alpha: 0.1).CGColor as CGColorRef
        let color3 = UIColor.clearColor().CGColor as CGColorRef
        let color4 = UIColor(white: 0.0, alpha: 0.1).CGColor as CGColorRef
        gradientLayer.colors = [color1, color2, color3, color4]
        gradientLayer.locations = [0.0, 0.01, 0.95, 1.0]
        layer.insertSublayer(gradientLayer, atIndex: 0)

        // add a layer that renders a green background when an item is complete
        itemCompleteLayer = CALayer(layer: layer)
        itemCompleteLayer.backgroundColor = UIColor(red: 0.0, green: 0.6, blue: 0.0, alpha: 1.0).CGColor
        itemCompleteLayer.hidden = true
        layer.insertSublayer(itemCompleteLayer, atIndex: 0)

        // add a pan recognizer
        var recognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        recognizer.delegate = self
        addGestureRecognizer(recognizer)


    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    //MARK: - horizontal pan gesture methods
    func handlePan(recognizer: UIPanGestureRecognizer) {
        // 1
        if recognizer.state == .Began {
            // when the gesture begins, record the current center location
            originalCenter = center
        }
        // 2
        if recognizer.state == .Changed {
            let translation = recognizer.translationInView(self)
            center = CGPointMake(originalCenter.x + translation.x, originalCenter.y)
            // has the user dragged the item far enough to initiate a delete/complete?
            deleteOnDragRelease = frame.origin.x < -frame.size.width / 2.0
            completeOnDragRelease = frame.origin.x > frame.size.width / 2.0
            // fade the contextual clues
            let cueAlpha = fabs(frame.origin.x) / (frame.size.width / 2.0)
            tickLabel.alpha = cueAlpha
            crossLabel.alpha = cueAlpha
            // indicate when the user has pulled the item far enough to invoke the given action
            tickLabel.textColor = completeOnDragRelease ? UIColor.greenColor() : UIColor.whiteColor()
            crossLabel.textColor = deleteOnDragRelease ? UIColor.redColor() : UIColor.whiteColor()
        }
        // 3
        if recognizer.state == .Ended {
            let originalFrame = CGRect(x: 0, y: frame.origin.y,
                width: bounds.size.width, height: bounds.size.height)
            if deleteOnDragRelease {
                NSLog("pre delete dragonrelease")
                if (delegate == nil) {NSLog("delegate nil")}
                if (record == nil) {NSLog("record nil")}
                if delegate != nil && record != nil {
                    // notify the delegate that this item should be deleted
                    NSLog("delete now")
                    delegate!.recordChanged(record!,action: "delete")

                }
                } else 
                if completeOnDragRelease {
                    if (record == nil) {NSLog(" complete record nil")}
                    if record != nil {
                    //record!.isCompleted = true
                    //NSLog("complete drag release now")
                    delegate!.recordChanged(record!,action: "complete")
                }
//                label.strikeThrough = true
//                itemCompleteLayer.hidden = false
                UIView.animateWithDuration(0.2, animations: {self.frame = originalFrame})
            } else {
                UIView.animateWithDuration(0.2, animations: {self.frame = originalFrame})
                NSLog("everythingelse")
            }
        }
    }


    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translationInView(superview!)
            if fabs(translation.x) > fabs(translation.y) {
                return true
            }
            return false
        }
        return false
    }


}
