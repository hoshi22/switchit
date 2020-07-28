//
//  WindowController.swift
//  switchit
//
//  Created by dmitry.met on 09/01/2020.
//  Copyright © 2020 Dmitry Inc. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController, NSWindowDelegate {
  
    var firstAppearance = true
     
    override func windowDidLoad() {
        super.windowDidLoad()
        self.window?.isOpaque = false
//        self.window?.hasShadow = true
        self.window?.backgroundColor = NSColor.clear
//        self.window?.titlebarAppearsTransparent = true
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
     
    func windowDidBecomeMain(_ notification: Notification) {
//        if firstAppearance {
//            let newFrame = NSRect(x: 120, y: 100, width: 300, height: 200)
//            self.window?.setFrame(newFrame, display: true)
//
//            let effect = NSVisualEffectView(frame: newFrame) // NSRect(x: 0, y: 0, width: 0, height: 0))
//            effect.blendingMode = .behindWindow
//            effect.state = .active
//            if #available(OSX 10.14, *) {
//                effect.material = .contentBackground
//            } else {
//                // Fallback on earlier versions
//                effect.material = .dark
//            }
//            effect.wantsLayer = true
//            effect.layer?.cornerRadius = 30.0
//            effect.layer?.borderColor = .clear
//            self.window?.contentView = effect
//            self.window?.titlebarAppearsTransparent = true
//            self.window?.titleVisibility = .hidden
//            self.window?.isOpaque = false
//            self.window?.backgroundColor = .clear
//        }
//        firstAppearance = false
    }
     
}
