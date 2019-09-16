//
//  ViewController.swift
//  switchit
//
//  Created by Dmitry Met on 2019-04-17.
//  Copyright © 2019 Dmitry Inc. All rights reserved.
//

import Cocoa
import Carbon

let itemsSize = 10

class TableView: NSTableView {
    
    override func keyDown(with event: NSEvent) {
        let viewController = NSApplication.shared.keyWindow!.contentViewController as! ViewController
        let apps = viewController.apps_list
        let kCode = event.keyCode
        
        switch kCode {
        case 36:
            NSRunningApplication.current.hide()
            _ = apps![self.selectedRow]["App"]!.activate(options: [NSApplication.ActivationOptions.activateAllWindows, NSApplication.ActivationOptions.activateIgnoringOtherApps])
        case 18:
            NSRunningApplication.current.hide()
            _ = apps![0]["App"]!.activate(options: [NSApplication.ActivationOptions.activateAllWindows, NSApplication.ActivationOptions.activateIgnoringOtherApps])
        case 19:
            NSRunningApplication.current.hide()
            _ = apps![1]["App"]!.activate(options: [NSApplication.ActivationOptions.activateAllWindows, NSApplication.ActivationOptions.activateIgnoringOtherApps])
        case 20:
            NSRunningApplication.current.hide()
            _ = apps![2]["App"]!.activate(options: [NSApplication.ActivationOptions.activateAllWindows, NSApplication.ActivationOptions.activateIgnoringOtherApps])
        case 21:
            NSRunningApplication.current.hide()
            _ = apps![3]["App"]!.activate(options: [NSApplication.ActivationOptions.activateAllWindows, NSApplication.ActivationOptions.activateIgnoringOtherApps])
        case 23:
            NSRunningApplication.current.hide()
            _ = apps![4]["App"]!.activate(options: [NSApplication.ActivationOptions.activateAllWindows, NSApplication.ActivationOptions.activateIgnoringOtherApps])
        case 22:
            NSRunningApplication.current.hide()
            _ = apps![5]["App"]!.activate(options: [NSApplication.ActivationOptions.activateAllWindows, NSApplication.ActivationOptions.activateIgnoringOtherApps])
        case 26:
            NSRunningApplication.current.hide()
            _ = apps![6]["App"]!.activate(options: [NSApplication.ActivationOptions.activateAllWindows, NSApplication.ActivationOptions.activateIgnoringOtherApps])
        case 28:
            NSRunningApplication.current.hide()
            _ = apps![7]["App"]!.activate(options: [NSApplication.ActivationOptions.activateAllWindows, NSApplication.ActivationOptions.activateIgnoringOtherApps])
        case 25:
            NSRunningApplication.current.hide()
            _ = apps![8]["App"]!.activate(options: [NSApplication.ActivationOptions.activateAllWindows, NSApplication.ActivationOptions.activateIgnoringOtherApps])
        case 29:
            NSRunningApplication.current.hide()
            _ = apps![9]["App"]!.activate(options: [NSApplication.ActivationOptions.activateAllWindows, NSApplication.ActivationOptions.activateIgnoringOtherApps])
        default:
            super.keyDown(with: event)
        }
    }
}

class ViewController: NSViewController {

    @IBOutlet weak var tableView: TableView!
    var apps_list: [[String: AnyObject]]?

    // Refresh list of applications running
    func refreshAppsList() {
        let ws = NSWorkspace.shared
        // Get alphabet sorted list of running applications
        let apps = ws.runningApplications.sorted(by: {(($0 as AnyObject).localizedName as String?)!.lowercased() < (($1 as AnyObject).localizedName as String?)!.lowercased() })
        apps_list = []
        var ind = 1
        for app in apps {
            // Would like to see only running GUI apps
            if app.activationPolicy.rawValue == 0 {
                apps_list?.append(["Num": ind as AnyObject, "App": app])
                ind += 1
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        // Adjust rows coantity to the height of app window, center the window
        print("List row height:", tableView.rowHeight)
        print("Current view size: ", self.view.frame.size)
        self.view.frame.size = NSSize(width: 400, height: (itemsSize * 42) + 6)
        print("New view size: ", self.view.frame.size)
        self.view.window?.center()
        
        refreshAppsList()
        tableView.reloadData()
        
        // Select the first row by default
        tableView.selectRowIndexes([0], byExtendingSelection: true)
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        self.refreshAppsList()
        tableView.reloadData()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

extension ViewController: NSTableViewDataSource, NSTableViewDelegate {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return apps_list?.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let item = (apps_list!)[row]
        let cell = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView
        let val = item[(tableColumn?.identifier.rawValue)!]!
        switch tableColumn!.identifier.rawValue {
        case "App":
            cell?.textField?.stringValue = val.localizedName!
            cell?.imageView?.image = val.icon
        default:
            cell?.textField?.stringValue = String(Int(truncating: val as! NSNumber))
        }
        return cell
    }
}
