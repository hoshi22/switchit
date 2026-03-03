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
let defaultIconsSize = 32
let rowHeight = defaultIconsSize + 20
let heightOffset = 28
let transparencyLvl = 0.90
var bgColor = NSColor(hex: "f2f3f4", alpha: transparencyLvl)
// ****

var itemsQuantity = 12
let thisapp = NSApplication.shared
var lastUsed = [0]

let userSettings = UserDefaults.standard

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
        
        // Capture selected row before any hiding, since hiding can invalidate it
        let selectedRow = self.selectedRow
        
        var currpos: Int? = nil
        switch kCode {
        case 36: // Enter
            currpos = selectedRow
        case 29, 82: // 0
            currpos = 0
        case 18, 83: // 1
            currpos = 1
        case 19, 84: // 2
            currpos = 2
        case 20, 85: // 3
            currpos = 3
        case 21, 86: // 4
            currpos = 4
        case 23, 87: // 5
            currpos = 5
        case 22, 88: // 6
            currpos = 6
        case 26, 89: // 7
            currpos = 7
        case 28, 91: // 8
            currpos = 8
        case 25, 92: // 9
            currpos = 9
        case 53: // "esc" pressed
            NSApp.hide(self)
        default:
            super.keyDown(with: event)
        }
        if let pos = currpos, pos >= 0, pos < apps.count {
            self.updateHistory(pos: pos)
            _ = apps[pos].activate(options: actOpts)
            NSRunningApplication.current.hide()
            NSApp.hide(self)
        }
    }
}

class ViewController: NSViewController {

    @IBOutlet public weak var tableView: TableView!
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
                if app.localizedName! != "switchit" {
                    self.apps_list.append(app)
                }
            }
        }

    }
    
    @objc func repaintListWindow() {
        let wnd = self.view.window
        let toSize = tableView.numberOfRows >= initialListSize ? initialListSize : tableView.numberOfRows
        wnd?.setFrame(CGRect(x: 0, y: 0, width: 400, height: (toSize * rowHeight) + heightOffset), display: true)
        wnd?.center()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = CGFloat(rowHeight)
        self.refreshAppsList()
        tableView.reloadData()
        self.repaintListWindow()
        thisapp.setActivationPolicy(.accessory)
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
        let iconsSize = userSettings.object(forKey: "swIconsSize") as? Int ?? defaultIconsSize
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
            item.icon?.size = NSSize(width: iconsSize, height: iconsSize)
            cell?.imageView?.image = item.icon
        case "Windows":
            cell?.textField?.stringValue = ">"
        default:
            cell?.textField?.stringValue = "***"
        }
        return cell
    }
}

extension NSColor {
    
    convenience init(hex: String, alpha: CGFloat) {
        let ui64 = UInt64(hex, radix: 16)
        let value = ui64 != nil ? Int(ui64!) : 0
        let components = (
            R: CGFloat((value >> 16) & 0xff) / 255,
            G: CGFloat((value >> 08) & 0xff) / 255,
            B: CGFloat((value >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: alpha)
    }
}
