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
    @IBOutlet weak var conversionPopUp: NSPopUpButton!
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
    var latestValue: Double! = 0.0
    
    var units: Array<DEUnit> = []
    var conversionTypes: Array<[String:Array<DEUnit>]> = Units
    
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
        
        self.units = initUnits(unitType: Length)
        
        // MARK: Input Field Setup
        self.inputField.delegate = self
        self.outputLabel.isSelectable = true
        
        // MARK: Pop-Up Menu Setup
        
        conversionPopUp.removeAllItems()
        initMenu(menu: conversionPopUp, entries: self.conversionTypes)
        
        conversionPopUp.selectItem(withTitle: "Length")
        initializeConversions()
    }
    
    func initializeConversions() {
        let i = self.conversionPopUp.indexOfSelectedItem
        self.units = (self.conversionTypes[i].first?.value)!
        resetMenus()
        self.inputPopUp.selectItem(withTitle: (self.units[0].first?.key)!)
        self.outputPopUp.selectItem(withTitle: (self.units[1].first?.key)!)
        updateSelection()
        updateFromInput()
    }
    
    func resetMenus() {
        inputPopUp.removeAllItems()
        outputPopUp.removeAllItems()
        initMenu(menu: inputPopUp, entries: self.units)
        initMenu(menu: outputPopUp, entries: self.units)
    }
    
    // MARK: Pop-Up Menus
    // Call @unitDidChange whenever the value for the popups change
    @IBAction func conversionSelectionDidChange(_ sender: NSPopUpButton) {
        initializeConversions()
    }
    
    @IBAction func inputUnitDidChange(_ sender: NSPopUpButton) { unitDidChange(sender) }
    @IBAction func outputUnitDidChange(_ sender: NSPopUpButton) { unitDidChange(sender) }
    
    func initUnits(unitType: Array<DEUnit>) -> Array<DEUnit> {
        return unitType
    }
    
    // @unitDidChange is called by any of the popup menus when their selection changes
    func unitDidChange(_ sender: NSPopUpButton) {
        let changed: NSPopUpButton,
            opposite: NSPopUpButton,
            changedUnit: [String:Unit]
        
        changed     = (sender == self.inputPopUp ? self.inputPopUp : self.outputPopUp)
        opposite    = (sender == self.inputPopUp ? self.outputPopUp : self.inputPopUp)
        changedUnit = (sender == self.inputPopUp ? self.inputUnit : self.outputUnit)

        if(changed.selectedItem?.title == opposite.selectedItem?.title) {
            opposite.selectItem(withTitle: (changedUnit.first?.key)!)
        }
        
        updateSelection()
        updateFromInput()
    }
    
    // @initMenu populates the popup menus with the units for conversion
    func initMenu(menu: NSPopUpButton, entries: Array<[String:Any]>) {
        for (entry) in entries {
            menu.addItem(withTitle: (entry.first?.key)!)
        }
    }
    
    func findUnitInDict(dict: Array<DEUnit>, unit: String) -> Int {
        for i in 0 ..< dict.count {
            if(dict[i].first?.key == unit) {
                return i
            }
        }
        
        return -1
    }
    
    // @updateSelection updates the records of the unit types to the currently selected units
    func updateSelection() {
        let i: String = (self.inputPopUp.selectedItem?.title)!
        let o: String = (self.outputPopUp.selectedItem?.title)!
        let iunit = findUnitInDict(dict: self.units, unit: i)
        let ounit = findUnitInDict(dict: self.units, unit: o)
        self.inputUnit = [i: (self.units[iunit].first?.value)!]
        self.outputUnit = [o: (self.units[ounit].first?.value)!]
    }
    
    // MARK: Text Input
    override func controlTextDidChange(_ obj: Notification) {
        updateFromInput()
    }
    
    // @updateFromInput reads the input text field, converts the value, and outputs to the output label
    func updateFromInput() {
        let valueField: NSTextField = self.inputField
        let val = convertorFormatter.number(from: valueField.objectValue as! String)
        let newVal = (val != nil ? val : self.latestValue as NSNumber)
        
        let input = Measurement.init(value: Double(newVal!), unit: (self.inputUnit.first?.value)! as! Dimension)
        let convertedValue = roundTo(decimals: 3, value: input.converted(to: (self.outputUnit.first?.value)! as! Dimension).value)
        self.outputLabel.stringValue = String(convertedValue)
        self.latestValue = newVal as! Double
        
        if(val == nil) {
            self.inputField.stringValue = String(latestValue)
        }
    }
    
    // @roundTo rounds a value to n decimal places, where n is the first argument
    func roundTo(decimals: Double, value: Double) -> Double {
        let n = pow(10, decimals)
        return round(value * n) / n
    }
}
