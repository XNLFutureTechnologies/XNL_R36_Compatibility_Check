# Archived Status (24-10-2026)
This project is now officially archived and will no longer be updated nor supported!
It was (is) intended for use with ArkOS, and I no longer use ArkOS/dArkOS so I'm not able to keep maintaining this (simple) script/tool anymore either. 

I no longer use ArkOS/dArkOS and thus will not be able to support or update this project anymore, I'm currently actively working on my own distro specifically designed and optimized for the R36 (from scratch), and thus it's for me impossible to keep track of all ArkOS (now dArkOS) changes in the future, and to be very honest; I'm also not really up to it/'in the mood' to keep doing it for a project I no longer use myself for various reasons (NOTHING bad about ArkOS/dArkOS! it just does not fit my needs and doesn't do exactly what I want to do with it).
IF Anyone else does want to keep maintaining this project for other ArkOS/dArkOS users on the R36 for example, then you are of course free (AND WELCOME!) to fork the project and continue the project 😊, do obviously respect the GPL license and keep the credits as you should 😊
Thanks you all for a GREAT time ArkOS, but it's time to move on to bigger things now 😉 

# Introduction
This is a small and simple util/script which you can use to detect if your (handheld retro) console is (or at least should be) compatible with my scripts, programs, drivers, tweaks etc.  
  
<strong>TIP:</strong> On my [website](https://www.teamxnl.com/R36-XCC) you can also see a screenshot/photo of how the XNL Compatibiliy Check should look if your console passes the checks.

## Current Version 1.0
This tool will also create a small "registration file" on your console which basically tells my other scripts, programs, drivers etc if your console has previously passed or failed the check. This can then be used to warn users that they are for example trying to install a driver which is not recommended for their device. This is however an empty file which does not contain ANY device (or personal for that matter) information. This file is stored as <strong>/home/ark/.config/.xnlft-xcc-checkfail</strong> if the system previously failed the check, and it will be stored as <strong>/home/ark/.config/.xnlft-xcc-checkpass</strong> if the system previously passed the check.  
  
I do however also recommend to read the latest information in regards to R36 Clones and possible false positive system passed messages on my main website: https://www.teamxnl.com/R36-XCC  
  
## How to install:
1. Simply download the files (you can also get them from my website directly here: https://www.teamxnl.com/R36-XCC)  
2. Extract the zip file (on your computer) and copy the XNL Compatibility Check.sh file to your SD-Card in the Tools folder on the roms partition (often called/labeled EASYROMS by default)  
3. Put the SD-Card back into your console, boot it and then navigate to Options-> XNL Compatibility Check and see if your console passes the checks.  
  
ALL my ArkOS/R36 Tools are developed on, tested on and intended for only the R36S and R36H, I do not (and will) not offer or add support for other devices which I don’t own and thus can’t physically test my software on. Sorry.  

NOTE:  
This is simply a tool to make sure that your R36S or R36H is running the correct software, updates, kernel etc. It is NOT intended to check if a different device can run my software or not!  

<strong>But if your tool says that my device (which is not an R36S/R36H) passed all tests, can’t I use your tools anyway then?</strong>
Most likely you will be able to do so then, but this is fully at your own risk and responsibility! Most software should not give issues, but there are options/settings/tweaks which will communicate with the hardware directly (like setting GPIO pins for example for LEDS etc). And while the XNL Compatibility Check detected the (exact) same OS and even boot files as are used for the R36S/R36H (which should mean it’s basically the same hardware in most cases), it’s no guarantee that it will actually work. the RG351MP and RGB10X for example also use the same ArkOS image as the R36S/R36H (well the R36’s use their firmware actually 😉), the RGB10X only has one analog stick, and some of my tools (or future programs) might actually depend on two analog sticks. Which could mean that the software will just start “perfectly fine” but that you can’t use it (fully) due to missing controls for example.

## Pull Requests will (in most cases) not be accepted
Because this tool is intended to 'verify' if <strong>my</strong> tools, scripts, programs, tweaks and drivers will work on the R36S/R36H, it doesn't serve any purpose to let others add other functions/tweaks and edits to this script 😉. If someone however spots a (serious) bug, then I might indeed update it with 
