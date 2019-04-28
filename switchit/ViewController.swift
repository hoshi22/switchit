//
//  ViewController.swift
//  switchit
//
//  Created by Dmitry Met on 2019-04-17.
//  Copyright © 2019 Dmitry Inc. All rights reserved.
//

import Cocoa
import Carbon


class ViewController: NSViewController {

    @IBOutlet weak var tableView: NSTableView!
    var data: [[String: AnyObject]]?
    
//    let keycode = 48 // TAB key
//    let keymask: NSEvent.ModifierFlags = .option // OPTION key
    
//    func globalHotKeyHandler(event: NSEvent!) {
//        if event.keyCode == self.keycode && (event.modifierFlags.rawValue & keymask.rawValue == keymask.rawValue) {
//            print("PRESSED")
////            print(NSApplication.shared.mainWindow?.windowController?.window!)
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        //***** BEGINNING OF Key Combo handling stuff *****
//        let options = NSDictionary(object: kCFBooleanTrue!, forKey: kAXTrustedCheckOptionPrompt.takeUnretainedValue() as NSString) as CFDictionary
//        let trusted = AXIsProcessTrustedWithOptions(options)
//        if (trusted) {
//            print(options)
//            NSEvent.addGlobalMonitorForEvents(matching: [.keyDown], handler: self.globalHotKeyHandler(event:))
//        }
//        //***** END OF Key Combo handling stuff *****
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let ws = NSWorkspace.shared
        let apps = ws.runningApplications
        data = []
        var ind = 1
        for app in apps {
            // Would like to see only running GUI apps
            if app.activationPolicy.rawValue == 0 {
                data?.append(["Num": ind as AnyObject, "App": app])
                ind += 1
            }
        }
        
        var test: [[Int: NSRunningApplication]] = []
        for curr in apps.enumerated() {
            test.append([curr.offset: curr.element])
        }

        tableView.reloadData()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    override func keyDown(with event: NSEvent) {
        if event.keyCode == 36 {
            let app = data![self.tableView.selectedRow]["App"]!
            _ = app.activate(options: NSApplication.ActivationOptions.activateAllWindows)
        }
    }
}

extension ViewController: NSTableViewDataSource, NSTableViewDelegate {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return data?.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let item = (data!)[row]
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
