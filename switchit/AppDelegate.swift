//
//  AppDelegate.swift
//  switchit
//
//  Created by Dmitry Met on 2019-04-17.
//  Copyright © 2019 Dmitry Inc. All rights reserved.
//

import Cocoa
import Carbon

let switchitApp = NSApplication.shared

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    let popover = NSPopover()
    var eventMonitor: EventMonitor?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        //***************** Registering global hot key handler *******************************************************************
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
            switchitApp.activate(ignoringOtherApps: true)
            return 12345
        }, 1, &eventType, nil, nil)
        
        // Register hotkey "Option (Alt) + Tab"
        _ = RegisterEventHotKey(48, UInt32(optionKey), gMyHotKeyID, GetApplicationEventTarget(), 0, &myHotKeyRef)
        //************************************************************************************
        
        // Dock icon stuff
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("switchit-dock-icon"))
            button.action = #selector(togglePopover(_:))
        }
        popover.contentViewController = SettingsPopupController.showSettingsWindow()
        
        // To close popover if user click outside it
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
          if let strongSelf = self, strongSelf.popover.isShown {
              strongSelf.closePopover(sender: event)
              switchitApp.activate(ignoringOtherApps: true)
          }
        }

    }
    
    @objc func togglePopover(_ sender: Any?) {
      if popover.isShown {
        closePopover(sender: sender)
      } else {
        showPopover(sender: sender)
      }
    }

    func showPopover(sender: Any?) {
      if let button = statusItem.button {
          popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
          eventMonitor?.start()
      }
    }

    func closePopover(sender: Any?) {
        popover.performClose(sender)
//        popover.close()
        eventMonitor?.stop()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
   
}
