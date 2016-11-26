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
    
    func setMinimumFanspeed1200() {
        do {
            try SMCKit.open()
        } catch {
            print("Error - could not open connection to SMC")
        }
        do {
            let fanCount = try SMCKit.fanCount()
            for fans in 1...fanCount {
                do {
                    try SMCKit.fanSetMinSpeed(fans-1, speed: 1200)
                } catch {
                    print("Error - could not set fanspeed for fan \(fans)")
                }
            }
        } catch {
            print("Error - could not retrieve fan count")
        }
    }
    
    func setMinimumFanspeed2400() {
        do {
            try SMCKit.open()
        } catch {
            print("Error - could not open connection to SMC")
        }
        do {
            try SMCKit.fanSetMinSpeed(0, speed: 1200)
        } catch {
            print("Error - could not set fan speed")
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
            let fanCount = try SMCKit.fanCount()
            var fanRPM = 0
            for fans in 1...fanCount {
                do {
                    fanRPM += try SMCKit.fanCurrentSpeed(fans-1)
                } catch {
                    print("Error - could not retrieve fan speed")
                }
            }
            if fanRPM == 0 {
                fanSpeed = "Fans Off"
            } else {
                fanSpeed = "\(fanRPM/fanCount)"
                while fanSpeed.characters.count < 4 {
                    fanSpeed.insert("0", at: fanSpeed.startIndex)
                }
                fanSpeed.append("RPM")
            }
        } catch {
            print("Error - could not retrieve fan count")
        }
        let final = "\(CPUTemp)°C | \(fanSpeed)"
        statusItem.attributedTitle = NSAttributedString(string: final, attributes: [NSFontAttributeName: NSFont.boldSystemFont(ofSize: 12)])                        
    }
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let refreshTimer = Timer(timeInterval: 1.5, target: self, selector: #selector(updateSensors), userInfo: nil, repeats: true)
        RunLoop.main.add(refreshTimer, forMode: RunLoopMode.defaultRunLoopMode)
        
        //let fanspeedSubmenu = NSMenu()
        //fanspeedSubmenu.addItem(withTitle: "1200 rpm", action: #selector(setMinimumFanspeed1200), keyEquivalent: "")
        //fanspeedSubmenu.addItem(withTitle: "2400 rpm", action: #selector(setMinimumFanspeed2400), keyEquivalent: "")
        
        let menu = NSMenu()
        //let fanspeedMenu = NSMenuItem(title: "Minimum Fan Speed", action: nil, keyEquivalent: "")
        //fanspeedMenu.submenu = fanspeedSubmenu
        //menu.addItem(fanspeedMenu)
        //menu.addItem(NSMenuItem.separator())
        menu.addItem(withTitle: "Quit Varanus", action: #selector(NSApplication.shared().terminate(_:)), keyEquivalent: "")
        statusItem.menu = menu
        
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

