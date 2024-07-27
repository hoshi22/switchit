//
//  AppDelegate.swift
//  switchit
//
//  Created by Dmitry Met on 2019-04-17.
//  Copyright © 2019 Dmitry Inc. All rights reserved.
//

import Cocoa
import Carbon

var switchitWnds: [String: NSWindow] = [:]

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    let statusBarMenu = NSMenu(title: "Switchit App")
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        //***** Registering windows
        for wnd in thisapp.windows {
            if wnd.identifier?.rawValue != nil {
                switchitWnds[wnd.identifier!.rawValue] = wnd
            }
        }
        
        //***** Restore user settings
        if let bgColorData = UserDefaults.standard.object(forKey: "swBckColor") as? Data {
            if let bgSelectedColor = NSKeyedUnarchiver.unarchiveObject(with:bgColorData as Data) as? NSColor {
                switchitWnds["switchitWindow"]?.backgroundColor = bgSelectedColor
            }
        }

        //***** Registering global hot key handler
        var gMyHotKeyID = EventHotKeyID()
        gMyHotKeyID.signature = OSType(1234)
        gMyHotKeyID.id = UInt32(48)
        var eventType = EventTypeSpec()
        eventType.eventClass = OSType(kEventClassKeyboard)
        eventType.eventKind = OSType(kEventHotKeyPressed)
        var myHotKeyRef = EventHotKeyRef.init(bitPattern: 1154541)

        InstallEventHandler(GetApplicationEventTarget(), {(nextHanlder, theEvent, userData) -> OSStatus in
            var hkCom = EventHotKeyID()
            GetEventParameter(theEvent, EventParamName(kEventParamDirectObject), EventParamType(typeEventHotKeyID), nil, MemoryLayout.size(ofValue: EventHotKeyID.self), nil, &hkCom)
            thisapp.activate(ignoringOtherApps: true)
            return 12345
        }, 1, &eventType, nil, nil)
        // Register hotkey "Option (Alt) + Tab"
        _ = RegisterEventHotKey(48, UInt32(optionKey), gMyHotKeyID, GetApplicationEventTarget(), 0, &myHotKeyRef)
        
        //***** Dock icon stuff
        if let button = statusBarItem.button {
            button.image = NSImage(named:NSImage.Name("switchit-dock-icon"))
            statusBarItem.menu = statusBarMenu
            statusBarMenu.addItem(
                withTitle: "Preferences...",
                action: #selector(AppDelegate.switchitPreferences),
                keyEquivalent: ""
            )
            statusBarMenu.addItem(
                withTitle: "Quit",
                action: #selector(AppDelegate.switchitQuit),
                keyEquivalent: ""
            )
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        userSettings.setValue(defaultIconsSize, forKey: "IconsSize")
    }
    
    @objc func switchitPreferences() {
        if switchitWnds["switchitPreferences"] == nil {
            let storyboard = NSStoryboard(name: "Main", bundle: nil)
            let swg = storyboard.instantiateController(withIdentifier: "switchitSettingsWnd") as! NSWindowController
            switchitWnds["switchitPreferences"] = swg.window
        }
        switchitWnds["switchitPreferences"]?.orderFrontRegardless()
    }
    
    @objc func switchitQuit() {
        NSApp.terminate(self)
    }
}
