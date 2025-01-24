# Introduction
This is a small and simple util/script which you can use to detect if your (handheld retro) console is (or at least should be) compatible with my scripts, programs, drivers, tweaks etc.  
<strong>TIP:</strong> On my [website](https://www.teamxnl.com/R36-XCC) you can also see a screenshot/photo of how the XNL Compatibiliy Check should look if your console passes the checks.

## Current Version 1.0
  
## How to install:
1. Simply download the files (you can also get them from my website directly here: https://www.teamxnl.com/R36-XCC)  
2. Extract the zip file (on your computer) and copy the XNL Compatibility Check.sh file to your SD-Card in the Tools folder on the roms partition (often called/labeled EASYROMS by default)  
3. Put the SD-Card back into your console, boot it and then navigate to Options-> XNL Compatibility Check and see if your console passes the checks.  
  
ALL my ArkOS/R36 Tools are developed on, tested on and intended for only the R36S and R36H, I do not (and will) not offer or add support for other devices which I don’t own and thus can’t physically test my software on. Sorry.  

NOTE:  
This is simply a tool to make sure that your R36S or R36H is running the correct software, updates, kernel etc. It is NOT intended to check if a different device can run my software or not!  

<strong>But if your tool says that my device (which is not an R36S/R36H) passed all tests, can’t I use your tools anyway then?</strong>
Most likely you will be able to do so then, but this is fully at your own risk and responsibility! Most software should not give issues, but there are options/settings/tweaks which will communicate with the hardware directly (like setting GPIO pins for example for LEDS etc). And while the XNL Compatibility Check detected the (exact) same OS and even boot files as are used for the R36S/R36H (which should mean it’s basically the same hardware in most cases), it’s no guarantee that it will actually work. the RG351MP and RGB10X for example also use the same ArkOS image as the R36S/R36H (well the R36’s use their firmware actually 😉), the RGB10X only has one analog stick, and some of my tools (or future programs) might actually depend on two analog sticks. Which could mean that the software will just start “perfectly fine” but that you can’t use it (fully) due to missing controls for example.

## Pull Requests Will (in most cases) not be accepted!
Because this tool is intended to 'verify' if <strong>my</strong> tools, scripts, programs, tweaks and drivers will work on the R36S/R36H, it doesn't serve any purpose to let others add other functions/tweaks and edits to this script 😉. If someone however spots a (serious) bug, then I might indeed update it with 
