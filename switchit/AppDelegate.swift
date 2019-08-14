//
//  AppDelegate.swift
//  switchit
//
//  Created by Dmitry Met on 2019-04-17.
//  Copyright © 2019 Dmitry Inc. All rights reserved.
//

import Cocoa
import Carbon

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        //***************** Registering global hot kay handler *******************************************************************
        var gMyHotKeyID = EventHotKeyID()
        gMyHotKeyID.signature = OSType(1234)
        gMyHotKeyID.id = UInt32(48)
        
        var eventType = EventTypeSpec()
        eventType.eventClass = OSType(kEventClassKeyboard)
        eventType.eventKind = OSType(kEventHotKeyPressed)
        
        var myHotKeyRef = EventHotKeyRef.init(bitPattern: 1154541)
        
        // Install handler.
        InstallEventHandler(GetApplicationEventTarget(), {(nextHanlder, theEvent, userData) -> OSStatus in
            var hkCom = EventHotKeyID()
            GetEventParameter(theEvent, EventParamName(kEventParamDirectObject), EventParamType(typeEventHotKeyID), nil, MemoryLayout.size(ofValue: EventHotKeyID.self), nil, &hkCom)
            
                // Activate Switchit app by hotkey registered below in RegisterEventHotkey
                NSRunningApplication.current.activate(options: [NSApplication.ActivationOptions.activateIgnoringOtherApps])
            return 12345
        }, 1, &eventType, nil, nil)
        
        // Register hotkey "Option (Alt) + Tab"
        _ = RegisterEventHotKey(48, UInt32(optionKey), gMyHotKeyID, GetApplicationEventTarget(), 0, &myHotKeyRef)
        //************************************************************************************
        
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("switchit-dock-icon"))
            button.action = #selector(printQuote(_:))
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
