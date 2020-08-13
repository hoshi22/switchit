//
//  ViewController.swift
//  switchit
//
//  Created by Dmitry Met on 2019-04-17.
//  Copyright © 2019 Dmitry Inc. All rights reserved.
//

import Cocoa
import Carbon

let itemsQuantityLimit = 14
var itemsQuantity = 0
let thisapp = NSApplication.shared

class TableView: NSTableView {
    
    override func keyDown(with event: NSEvent) {
        let viewController = NSApplication.shared.keyWindow!.contentViewController as! ViewController
        let apps = viewController.apps_list
        let kCode = event.keyCode
        let actOpts: NSApplication.ActivationOptions = [.activateAllWindows, .activateIgnoringOtherApps]
        
        switch kCode {
        case 36:
            NSRunningApplication.current.hide()
            _ = apps[self.selectedRow].activate(options: actOpts)
        case 18:
            NSRunningApplication.current.hide()
            _ = apps[0].activate(options: actOpts)
        case 19:
            NSRunningApplication.current.hide()
            _ = apps[1].activate(options: actOpts)
        case 20:
            NSRunningApplication.current.hide()
            _ = apps[2].activate(options: actOpts)
        case 21:
            NSRunningApplication.current.hide()
            _ = apps[3].activate(options: actOpts)
        case 23:
            NSRunningApplication.current.hide()
            _ = apps[4].activate(options: actOpts)
        case 22:
            NSRunningApplication.current.hide()
            _ = apps[5].activate(options: actOpts)
        case 26:
            NSRunningApplication.current.hide()
            _ = apps[6].activate(options: actOpts)
        case 28:
            NSRunningApplication.current.hide()
            _ = apps[7].activate(options: actOpts)
        case 25:
            NSRunningApplication.current.hide()
            _ = apps[8].activate(options: actOpts)
        case 29:
            NSRunningApplication.current.hide()
            _ = apps[9].activate(options: actOpts)
        default:
            super.keyDown(with: event)
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
        itemsQuantity = self.apps_list.count
        if itemsQuantity > itemsQuantityLimit {
            itemsQuantity = itemsQuantityLimit
        }
        
        // Setting semi-transparent background and window size
        self.view.window?.isOpaque = false
        self.view.window?.backgroundColor = NSColor(red: 255 / 255.0, green: 255 / 255.0, blue: 255 / 255.0, alpha: 0.86)
        self.view.window?.setFrame(CGRect(x: 0, y: 0, width: 400, height: (itemsQuantity * 42) + 2), display: true)
        
        self.view.window?.layoutIfNeeded()
        self.view.window?.center()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        self.refreshAppsList()
        tableView.reloadData()
        
        self.repaintListWindow()
        
//        itemsQuantity = apps_list.count
//        if itemsQuantity > itemsQuantityLimit {
//            itemsQuantity = itemsQuantityLimit
//        }
//
//        // Adjust rows quantity to the height of app window, center the window
//        print("Items quantity: ", itemsQuantity)
//        print("List row height:", tableView.rowHeight)
//        print("Current view size: ", self.view.frame.size)
//        self.view.frame.size = NSSize(width: 400, height: (itemsQuantity * 42) + 2)
//        print("New view size: ", self.view.frame.size)
//        self.view.window?.center()
//        print("Monitors I have: ", NSScreen.screens)
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        print("viewWillAppear")
        self.refreshAppsList()
        tableView.reloadData()
        self.repaintListWindow()
        
        // Select the first row by default
        let indSet: IndexSet = [0]
        tableView.selectRowIndexes(indSet, byExtendingSelection: false)
        
        
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
            cell?.textField?.stringValue = String(row + 1)
        case "App":
            cell?.textField?.stringValue = (item.localizedName!)
            cell?.imageView?.image = item.icon
        case "Windows":
            cell?.textField?.stringValue = ">"
        default:
            cell?.textField?.stringValue = "***"
        }
        return cell
    }
}
