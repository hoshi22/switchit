//
//  ViewController.swift
//  switchit
//
//  Created by Dmitry Met on 2019-04-17.
//  Copyright © 2019 Dmitry Inc. All rights reserved.
//

import Cocoa
import Carbon

// **** Settings which is needs to be defined in settings UI
let initialListSize = 12
let iconSize = 32
let rowHeight = iconSize + 20
let transparencyLvl = 0.90
// ****

var itemsQuantity = 12
let thisapp = NSApplication.shared
var lastUsed = [0]

class TableView: NSTableView {
    
    func updateHistory(pos: Int = -1) {
        if lastUsed.count < 2 {
            lastUsed.append(self.selectedRow)
        }
        else {
                lastUsed[0] = lastUsed[1]
                lastUsed[1] = (pos == -1 ? self.selectedRow : pos)
        }
    }
    
    override func keyDown(with event: NSEvent) {
        let viewController = NSApplication.shared.keyWindow!.contentViewController as! ViewController
        let apps = viewController.apps_list
        let kCode = event.keyCode
        let actOpts: NSApplication.ActivationOptions = [.activateAllWindows, .activateIgnoringOtherApps]
        
        var currpos: Int? = nil
        switch kCode {
        case 36: // Enter
            currpos = -1
            NSApp.hide(self)
        case 29, 82: // 0
            currpos = 0
            NSApp.hide(self)
        case 18, 83: // 1
            currpos = 1
            NSApp.hide(self)
        case 19, 84: // 2
            currpos = 2
            NSApp.hide(self)
        case 20, 85: // 3
            currpos = 3
            NSApp.hide(self)
        case 21, 86: // 4
            currpos = 4
            NSApp.hide(self)
        case 23, 87: // 5
            currpos = 5
            NSApp.hide(self)
        case 22, 88: // 6
            currpos = 6
            NSApp.hide(self)
        case 26, 89: // 7
            currpos = 7
            NSApp.hide(self)
        case 28, 91: // 8
             currpos = 8
            NSApp.hide(self)
        case 25, 92: // 9
            currpos = 9
            NSApp.hide(self)
        case 53: // "esc" pressed
            NSApp.hide(self)
        default:
            super.keyDown(with: event)
        }
        if currpos != nil {
            NSRunningApplication.current.hide()
            if currpos! >= 0 {
                _ = apps[currpos!].activate(options: actOpts)
                self.updateHistory(pos: currpos!)
            }
            else {
                _ = apps[self.selectedRow].activate(options: actOpts)
                self.updateHistory()
                NSApp.hide(self)
            }
        }
    }
}

class ViewController: NSViewController {

    @IBOutlet weak var tableView: TableView!
    var apps_list: [NSRunningApplication] = []

    // Refresh list of applications running
    func refreshAppsList() {
        let ws = NSWorkspace.shared
        // Get alphabet sorted list of running applications
        let apps = ws.runningApplications.sorted(by: {(($0 as NSRunningApplication).localizedName as String?)!.lowercased() < (($1 as NSRunningApplication).localizedName as String?)!.lowercased() })
        self.apps_list = []
        for app in apps {
            // Would like to see only running GUI apps
            if app.activationPolicy.rawValue == 0 {
                self.apps_list.append(app)
            }
        }
	
    }
    
    func repaintListWindow() {
        // Setting semi-transparent background and window size
        self.view.window?.isOpaque = false
        self.view.window?.backgroundColor = NSColor(red: 255 / 255.0, green: 255 / 255.0, blue: 255 / 255.0, alpha: transparencyLvl)
        let toSize = tableView.numberOfRows >= initialListSize ? initialListSize : tableView.numberOfRows
        self.view.window?.setFrame(CGRect(x: 0, y: 0, width: 400, height: (toSize * rowHeight) + 60), display: true)
        self.view.window?.layoutIfNeeded()
        self.view.window?.center()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = CGFloat(rowHeight)
        self.refreshAppsList()
        tableView.reloadData()
        self.repaintListWindow()
        NSApp.setActivationPolicy(.accessory)
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        self.refreshAppsList()
        tableView.reloadData()
        self.repaintListWindow()
        
        // Select the previously used app
        tableView.selectRowIndexes([lastUsed[0]], byExtendingSelection: false)
    }
}

extension ViewController: NSTableViewDataSource, NSTableViewDelegate {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.apps_list.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let item = (self.apps_list)[row]
        let cell = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView
        switch tableColumn!.identifier.rawValue {
        case "Num":
            if row < 10 {
                cell?.textField?.stringValue = String(row)
                cell?.textField?.isBezeled = true
            }
            else {
                cell?.textField?.stringValue = ""
                cell?.textField?.isBezeled = false
            }
        case "App":
            cell?.textField?.stringValue = (item.localizedName!)
            item.icon?.size = NSSize(width: iconSize, height: iconSize)
            cell?.imageView?.image = item.icon
        case "Windows":
            cell?.textField?.stringValue = ">"
        default:
            cell?.textField?.stringValue = "***"
        }
        return cell
    }
}
