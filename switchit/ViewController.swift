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
        
        switch kCode {
        case 36:
            NSRunningApplication.current.hide()
            _ = apps[self.selectedRow].activate(options: actOpts)
            self.updateHistory()
        case 18:
            NSRunningApplication.current.hide()
            _ = apps[0].activate(options: actOpts)
            self.updateHistory(pos: 0)
        case 19:
            NSRunningApplication.current.hide()
            _ = apps[1].activate(options: actOpts)
            self.updateHistory(pos: 1)
        case 20:
            NSRunningApplication.current.hide()
            _ = apps[2].activate(options: actOpts)
            self.updateHistory(pos: 2)
        case 21:
            NSRunningApplication.current.hide()
            _ = apps[3].activate(options: actOpts)
            self.updateHistory(pos: 3)
        case 23:
            NSRunningApplication.current.hide()
            _ = apps[4].activate(options: actOpts)
            self.updateHistory(pos: 4)
        case 22:
            NSRunningApplication.current.hide()
            _ = apps[5].activate(options: actOpts)
            self.updateHistory(pos: 5)
        case 26:
            NSRunningApplication.current.hide()
            _ = apps[6].activate(options: actOpts)
            self.updateHistory(pos: 6)
        case 28:
            NSRunningApplication.current.hide()
            _ = apps[7].activate(options: actOpts)
            self.updateHistory(pos: 7)
        case 25:
            NSRunningApplication.current.hide()
            _ = apps[8].activate(options: actOpts)
            self.updateHistory(pos: 8)
        case 29:
            NSRunningApplication.current.hide()
            _ = apps[9].activate(options: actOpts)
            self.updateHistory(pos: 9)
        case 53:
            NSRunningApplication.current.hide()
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
        print("Repaint")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.refreshAppsList()
        tableView.reloadData()
        self.repaintListWindow()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        self.refreshAppsList()
        tableView.reloadData()
        self.repaintListWindow()
        
        // Select the previously used app
        print("Zashli")
        print(lastUsed)
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
