//
//  ViewController.swift
//  switchit
//
//  Created by Dmitry Met on 2019-04-17.
//  Copyright © 2019 Dmitry Inc. All rights reserved.
//

import Cocoa
import Carbon

let itemsQuantityLimit = 18
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
        
        var currpos: Int? = nil
        switch kCode {
        case 36:
            currpos = -1
        case 18:
            currpos = 0
        case 19:
            currpos = 1
        case 20:
            currpos = 2
        case 21:
            currpos = 3
        case 23:
            currpos = 4
        case 22:
            currpos = 5
        case 26:
            currpos = 6
        case 28:
            currpos = 7
        case 25:
            currpos = 8
        case 29:
            currpos = 9
        case 53: // "esc" pressed
            NSApp.hide(self)
        default:
            print("Key pressed, code is: ", kCode)
            super.keyDown(with: event)
        }
        if currpos != nil {
            NSRunningApplication.current.hide()
            if currpos! > 0 {
                _ = apps[currpos!].activate(options: actOpts)
                self.updateHistory(pos: currpos!)
            }
            else {
                _ = apps[self.selectedRow].activate(options: actOpts)
                self.updateHistory()
                print("Enter pressed")
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
        NSApp.setActivationPolicy(.accessory)
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
