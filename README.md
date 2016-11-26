# varanus

A simple fan and temperature monitoring application for macOS, made with the SMCKit framework, found at http://github.com/beltex/SMCKit.

Temperature shown is taken from the CPU die sensor, which is hotter than the sensors used by other programs like smcFanControl.

Fanspeed shown on the menu bar is the average RPM of all fans that the SMC returns. 
If all fans are off, "Fans Off" will be displayed. 
If the fan count returned by the SMC is zero, "No Fans" will be displayed,

## Requirements:
- macOS 10.12 "Sierra" or later.
