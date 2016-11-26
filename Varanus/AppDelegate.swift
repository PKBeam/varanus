//
//  AppDelegate.swift
//  Varanus
//
//  Created by Vincent Liu on 25/11/16.
//  Copyright © 2016 Vincent Liu. All rights reserved.
//

import Cocoa
import SMCKit
import IOKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    var useColourCoding = false
    
    func changeColourCoding() {
        if useColourCoding == false {
            useColourCoding = true
        } else {
            useColourCoding = false
        }
    }
    
    func updateSensors() {
        var CPUTemp: Int = 0
        var fanSpeed = "Varanus"
        var couldConnectToSMC = false
        while couldConnectToSMC == false {
            do {
                try SMCKit.open()
                couldConnectToSMC = true
            } catch {
                couldConnectToSMC = false
                print("Error - could not open connection to SMC")
            }
        }
        
        do {
            let code = FourCharCode(fromStaticString: "TC0F")
            let x = try SMCKit.temperature(code)
            CPUTemp = Int(x)
        } catch {
            print("Error - could not retrieve CPU temperature")
        }
        
        do {
            let x = try SMCKit.fanCurrentSpeed(0)
            let y = try SMCKit.fanCurrentSpeed(1)
            fanSpeed = "\((x+y)/2)"
            while fanSpeed.characters.count < 4 {
                fanSpeed.insert("0", at: fanSpeed.startIndex)
            }
        } catch {
            print("Error - could not retrieve fan speed")
        }
        let final = "\(CPUTemp)°C | \(fanSpeed) RPM"
        statusItem.attributedTitle = NSAttributedString(string: final, attributes: [NSFontAttributeName: NSFont.boldSystemFont(ofSize: 12)])                        
    }
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let refreshTimer = Timer(timeInterval: 1.5, target: self, selector: #selector(updateSensors), userInfo: nil, repeats: true)
        RunLoop.main.add(refreshTimer, forMode: RunLoopMode.defaultRunLoopMode)
        
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Quit Varanus", action: #selector(NSApplication.shared().terminate(_:)), keyEquivalent: ""))
        statusItem.menu = menu
        
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

