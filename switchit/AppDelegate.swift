//
//  AppDelegate.swift
//  switchit
//
//  Created by Dmitry Met on 2019-04-17.
//  Copyright © 2019 Dmitry Inc. All rights reserved.
//

import Cocoa
import Carbon
import ApplicationServices

var switchitWnds: [String: NSWindow] = [:]

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    static var shared: AppDelegate?

    let statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    let statusBarMenu = NSMenu(title: "Switchit App")
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        AppDelegate.shared = self
        
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
    
    // Changed to accept NSRunningApplication for future extensibility.
    // Uses Accessibility API to unminimize all windows of the app.
    // Accessibility permission required for this to work on external apps.
    func unhideApp(app: NSRunningApplication) {
        let appElement = AXUIElementCreateApplication(app.processIdentifier)
        var value: CFTypeRef?
        
        app.unhide()
        app.activate(options: [.activateAllWindows, .activateIgnoringOtherApps])
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            // AXUIElementCopyAttributeValue logic
        }
        
        let result = AXUIElementCopyAttributeValue(appElement, kAXWindowsAttribute as CFString, &value)
        
        if result != .success {
            print("Failed to get windows for app PID \(app.processIdentifier), error: \(result.rawValue)")
            return
        }
        
        guard let windows = value as? [AXUIElement] else {
            print("Windows attribute is not a list of AXUIElement")
            return
        }
        
        for windowElement in windows {
            var minimizedValue: CFTypeRef?
            let minResult = AXUIElementCopyAttributeValue(windowElement, kAXMinimizedAttribute as CFString, &minimizedValue)
            if minResult == .success, let minimized = minimizedValue as? Bool {
                print("Window minimized state: \(minimized)")
                if minimized {
                    let setResult = AXUIElementSetAttributeValue(windowElement, kAXMinimizedAttribute as CFString, kCFBooleanFalse)
                    if setResult == .success {
                        print("Window restored/unminimized successfully")
                        let raiseResult = AXUIElementPerformAction(windowElement, kAXRaiseAction as CFString)
                        print("Attempted to raise window, result: \(raiseResult.rawValue)")
                    } else {
                        print("Failed to unminimize window, error: \(setResult.rawValue)")
                    }
                }
            } else {
                print("Failed to get minimized attribute, error: \(minResult.rawValue)")
            }
        }
        
        app.activate(options: [.activateAllWindows, .activateIgnoringOtherApps])
        print("Activated app with options: [.activateAllWindows, .activateIgnoringOtherApps]")
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

