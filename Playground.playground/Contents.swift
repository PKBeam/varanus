//: Playground - noun: a place where people can play

import Cocoa
import SMCKit

do {
    let fans = try SMCKit.fanCount()
    print(fans)
} catch {
    print("Error")
}

do {
    let fanspeed = try SMCKit.fanCurrentSpeed(0)
    print(fanspeed)
} catch {
    print("Error")
}

print(SMCKit.fanName(0))