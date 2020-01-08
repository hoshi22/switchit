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
        apps_list = []
        for app in apps {
            // Would like to see only running GUI apps
            if app.activationPolicy.rawValue == 0 {
                apps_list.append(app)
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
        return apps_list.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let item = (apps_list)[row]
        let cell = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView
        switch tableColumn!.identifier.rawValue {
        case "App":
            cell?.textField?.stringValue = (item.localizedName!)
            cell?.imageView?.image = item.icon
        default:
            cell?.textField?.stringValue = String(row + 1)
        }
        return cell
    }
}
