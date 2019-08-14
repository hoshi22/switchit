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

class ViewController: NSViewController {

    @IBOutlet weak var tableView: NSTableView!
    var apps_list: [[String: AnyObject]]?

    // Refresh list of applications running
    func refreshAppsList() {
        let ws = NSWorkspace.shared
        let apps = ws.runningApplications
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
    
    override func keyDown(with event: NSEvent) {
        if event.keyCode == 36 {
            NSRunningApplication.current.hide()
            let app = apps_list![self.tableView.selectedRow]["App"]!
            _ = app.activate(options: [NSApplication.ActivationOptions.activateAllWindows, NSApplication.ActivationOptions.activateIgnoringOtherApps])
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
