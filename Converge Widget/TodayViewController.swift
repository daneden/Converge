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
    
    
    // MARK: Variable Setup
    override var nibName: String? {
        return "TodayViewController"
    }
    
    // InterfaceKit items
    @IBOutlet weak var outputLabel: NSTextField!
    @IBOutlet weak var inputField: NSTextField!
    @IBOutlet weak var inputPopUp: NSPopUpButton!
    @IBOutlet weak var outputPopUp: NSPopUpButton!
    
    // input/outputUnit will be our record of the current unit types
    var inputUnit: [String:Unit] = [:]
    var outputUnit: [String:Unit] = [:]
    
    // The number formatter for text input
    var convertorFormatter: NumberFormatter!
    
    // latest value of the text input (used as backup for overzealous number formatter)
    var latestValue: Double!
    
    // MARK: Misc. Setup
    // Reset margin insets
    func widgetMarginInsets(forProposedMarginInsets defaultMarginInset: EdgeInsets) -> EdgeInsets {
        return NSEdgeInsetsMake(0, 0, 0, 0)
    }
    
    // MARK: Initialization
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Update your data and prepare for a snapshot. Call completion handler when you are done
        // with NoData if nothing has changed or NewData if there is new data since the last
        // time we called you
        completionHandler(.noData)
        
        // MARK: Formatter Setup
        // convertorFormatter will format our input to disallow non-numeric chars
        convertorFormatter = NumberFormatter()
        convertorFormatter.usesGroupingSeparator = false
        convertorFormatter.allowsFloats = true
        convertorFormatter.numberStyle = .decimal
        convertorFormatter.minimumFractionDigits = 0
        
        // MARK: Input Field Setup
        self.inputField.delegate = self
        self.inputField.formatter = convertorFormatter
        
        // MARK: Pop-Up Menu Setup
        inputPopUp.removeAllItems()
        outputPopUp.removeAllItems()
        initMenu(menu: inputPopUp, entries: Length)
        initMenu(menu: outputPopUp, entries: Length)
        
        inputPopUp.selectItem(withTitle: "Centimeters")
        outputPopUp.selectItem(withTitle: "Inches")
        updateSelection()
    }
    
    // MARK: Pop-Up Menus
    // Call @unitDidChange whenever the value for the popups change
    @IBAction func inputUnitDidChange(_ sender: NSPopUpButton) { unitDidChange(sender) }
    @IBAction func outputUnitDidChange(_ sender: NSPopUpButton) { unitDidChange(sender) }
    
    // @unitDidChange is called by any of the popup menus when their selection changes
    func unitDidChange(_ sender: NSPopUpButton) {
        let changed: NSPopUpButton,
            opposite: NSPopUpButton,
            changedUnit: [String:Unit]
        
        if(sender == self.inputPopUp) {
            changed = self.inputPopUp
            opposite = self.outputPopUp
            changedUnit = self.inputUnit
        } else {
            changed = self.outputPopUp
            opposite = self.inputPopUp
            changedUnit = self.outputUnit
        }
        
        if(changed.selectedItem?.title == opposite.selectedItem?.title) {
            opposite.selectItem(withTitle: (changedUnit.first?.key)!)
        }
        
        updateSelection()
        updateFromInput()
    }
    
    // @initMenu populates the popup menus with the units for conversion
    func initMenu(menu: NSPopUpButton, entries: [String:Unit]) {
        for (key, _) in entries {
            menu.addItem(withTitle: key)
        }
    }
    
    // @updateSelection updates the records of the unit types to the currently selected units
    func updateSelection() {
        let i: String = (self.inputPopUp.selectedItem?.title)!
        let o: String = (self.outputPopUp.selectedItem?.title)!
        self.inputUnit = [i: Length[i]!]
        self.outputUnit = [o: Length[o]!]
    }
    
    // MARK: Text Input
    override func controlTextDidChange(_ obj: Notification) {
        updateFromInput()
    }
    
    // @updateFromInput reads the input text field, converts the value, and outputs to the output label
    // FIXME: Overzealous Formatter
    //        The formatter strips periods and resets the text field when an invalid character is entered.
    //        Previous behavior was to select entire field when invalid character was entered, and to allow
    //        periods, which is preferable.
    func updateFromInput() {
        let valueField: NSTextField = self.inputField
        let val = valueField.objectValue
        if(val == nil) {
            
        }
        let newVal = (valueField.objectValue != nil ? valueField.objectValue! : 0.0)
        let convertedValue = convertLength(from: self.inputUnit.first?.value as! UnitLength,
                                           to: self.outputUnit.first?.value as! UnitLength,
                                           value: newVal as! Double)
        self.outputLabel.stringValue = String(convertedValue)
        self.latestValue = convertedValue
    }
    
    // @convertLength takes two unit types and a value and outputs the converted value
    func convertLength(from: UnitLength, to: UnitLength, value: Double) -> Double {
        let input = Measurement.init(value: Double(value), unit: from)
        return roundTo(decimals: 3, value: input.converted(to: to).value)
    }
    
    // @roundTo rounds a value to n decimal places, where n is the first argument
    func roundTo(decimals: Double, value: Double) -> Double {
        let n = pow(10, decimals)
        return round(value * n) / n
    }
}
