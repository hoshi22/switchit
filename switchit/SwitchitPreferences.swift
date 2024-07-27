//
//  SwitchitPreferences.swift
//  switchit
//
//  Created by Dmitry Met on 27/07/2024.
//  Copyright © 2024 Dmitry Inc. All rights reserved.
//

import Foundation
import Cocoa
import Carbon

class swPrefsController: NSViewController {
    @IBOutlet weak var swBckColor: NSColorWell!
    @IBAction func changeBgColor(_ sender: Any) {
        switchitWnds["switchitWindow"]?.backgroundColor = swBckColor.color
        let data: Data = NSKeyedArchiver.archivedData(withRootObject: swBckColor.color) as Data
        userSettings.setValue(data, forKey: "swBckColor")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let bgColorData = UserDefaults.standard.object(forKey: "swBckColor") as? Data {
            if let bgSelectedColor = NSKeyedUnarchiver.unarchiveObject(with:bgColorData as Data) as? NSColor {
                swBckColor.color = bgSelectedColor
            }
        }
    }
}
