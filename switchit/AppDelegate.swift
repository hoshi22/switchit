//
//  AppDelegate.swift
//  switchit
//
//  Created by Dmitry Met on 2019-04-17.
//  Copyright © 2019 Dmitry Inc. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    
    let keycode = 48 // TAB key
    let keymask: NSEvent.ModifierFlags = .option // OPTION key
    var myWin: NSWindow? = nil

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("switchit-dock-icon"))
            button.action = #selector(printQuote(_:))
            
            self.myWin = NSApplication.shared.keyWindow!
            print(self.myWin)
//            myWin.makeKeyAndOrderFront(self)
//            print(myWin)
            
            //***** BEGINNING OF Key Combo handling stuff *****
            let options = NSDictionary(object: kCFBooleanTrue!, forKey: kAXTrustedCheckOptionPrompt.takeUnretainedValue() as NSString) as CFDictionary
            let trusted = AXIsProcessTrustedWithOptions(options)
            if (trusted) {
                print(options)
                NSEvent.addGlobalMonitorForEvents(matching: [.keyDown], handler: self.globalHotKeyHandler(event:))
            }
            //***** END OF Key Combo handling stuff *****
            
        }
    }
    
    func globalHotKeyHandler(event: NSEvent!) {
        if event.keyCode == self.keycode && (event.modifierFlags.rawValue & keymask.rawValue == keymask.rawValue) {
            print("PRESSED")
//            let myWin: NSWindow = NSApplication.shared.keyWindow!
            self.myWin?.makeKeyAndOrderFront(self)
            //            print(NSApplication.shared.mainWindow?.windowController?.window!)
        }
    }
    
    @objc func printQuote(_ sender: Any?) {
        let quoteText = "Never put off until tomorrow what you can do the day after tomorrow."
        let quoteAuthor = "Mark Twain"
        
        print("\(quoteText) — \(quoteAuthor)")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

class SwitchitWindow: NSWindow {
    override var canBecomeKey: Bool {
        get { return true }
    }
}
