//
//  TodayViewController.swift
//  Converge NC
//
//  Created by Daniel Eden on 12/22/16.
//  Copyright © 2016 Daniel Eden. All rights reserved.
//

import Cocoa
import CoreFoundation
import NotificationCenter

class TodayViewController: NSViewController, NCWidgetProviding, NSTextFieldDelegate {
    
    override var nibName: String? {
        return "TodayViewController"
    }
    
    func widgetMarginInsets(forProposedMarginInsets defaultMarginInset: EdgeInsets) -> EdgeInsets {
        return NSEdgeInsetsMake(0, 0, 0, 0)
    }
    
    @IBOutlet weak var outputLabel: NSTextField!
    @IBOutlet weak var inputField: NSTextField!
    
    var convertorFormatter: NumberFormatter!
    var latestValue: Float!
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Update your data and prepare for a snapshot. Call completion handler when you are done
        // with NoData if nothing has changed or NewData if there is new data since the last
        // time we called you
        completionHandler(.noData)
        
        convertorFormatter = NumberFormatter()
        convertorFormatter.allowsFloats = true
        convertorFormatter.numberStyle = .decimal
        convertorFormatter.minimumFractionDigits = 0
        convertorFormatter.maximumFractionDigits = 4
        
        self.inputField.delegate = self
        self.inputField.formatter = convertorFormatter
    }
    
    override func controlTextDidChange(_ obj: Notification) {
        let valueField: NSTextField = self.inputField
        let formatter: NumberFormatter = valueField.formatter as! NumberFormatter
        let editor: NSText = valueField.currentEditor()!
        let newVal = formatter.number(from:editor.string!)?.stringValue
        
        // Checking for any text value should yield nil if non-numeric values are used
        // since we're using NumberFormatter to clean the output
        if (newVal?.range(of: ".*", options: .regularExpression, range: nil, locale: nil)) == nil {
            // NumberFormatter.typeValue triggers a validation, so the field will be
            // cleared of non-numeric characters
            let _ = convertorFormatter.number(from: self.inputField.stringValue)?.stringValue
            self.inputField.stringValue = String(self.latestValue)
        } else {
            let n = (newVal == nil ? 0 : Float(newVal!))
            self.outputLabel.stringValue = String(cmToIn(n!))
            self.latestValue = n
        }
        
    }
    
    func cmToIn(_ val: Float) -> Float {
        return val * 0.393701
    }
    
}
