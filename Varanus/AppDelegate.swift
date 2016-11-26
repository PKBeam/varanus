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
    var refreshInterval = 1.0
    
    func updateSensors() {
        var CPUTemp: Double = 0
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
            CPUTemp = x
        } catch {
            print("Error - could not retrieve CPU temperature")
        }
        
        do {
            let x = try SMCKit.fanCurrentSpeed(0)
            let y = try SMCKit.fanCurrentSpeed(1)
            var fanRPM = (x+y)/2
            if "\(fanRPM)".characters.count < 4 {
                fanRPM += 1000
                fanSpeed = "\(fanRPM)"
                fanSpeed.insert("0", at: fanSpeed.startIndex)
            } else {
                fanSpeed = "\(fanRPM)"
            }
            
        } catch {
            print("Error - could not retrieve fan speed")
        }
        let final = "\(CPUTemp)°C | \(fanSpeed) rpm"
        statusItem.attributedTitle = NSAttributedString(
            string: final, attributes: [NSFontAttributeName: NSFont(name: "Menlo", size: 11) ?? NSFont.systemFont(ofSize: 13)])
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

