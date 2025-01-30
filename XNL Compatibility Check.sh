#!/bin/bash
# =================================================================================
# XNL Future Technologies R36 Compatibility Check
#
# This Script: XNL Compatibility Check
# Purpose: This script is intended to first check IF your device is/COULD BE compatible
# with my other scripts, programs, patches, mods etc.
# 
# NOTE: Basically all my releases for ArkOS are currently ONLY intended to be used on
# R36S and R36H units running on the ORIGINAL ArkOS (NOT the community maintained version!)
# Reason for this is that I don't own any of the other devices and thus can't test, debug
# etc my stuff on it. Next to this I don't (and won't) run the community maintained image
# so I can't confirm (or test/debug) on that particular image either.
#
# INSTALLATION INSTRUCTION:
# Simply copy this file to your Tools folder on your SD card and start it from the options
# menu (or RetroPie menu depending on your Theme).
#
#------------------------
# Project: XNL Future Technologies R36 Compatibility Check
# Website: http://www.teamxnl.com/R36-XCC
# YouTube: https://www.youtube.com/@XNLFutureTechnologies
# GitHub:  https://github.com/XNLFutureTechnologies/XNL_R36_Compatibility_Check
# License: XNL CUSTOM (Included as LICENSE file otherwise found at: http://www.teamxnl.com/R36-XCC)
#          You are free to use, modify, and distribute this software under the terms of the license mentioned above
#          However, if you distribute a modified version or create a derivative work:
#          1. You must provide appropriate credit to the original author(s).
#          2. You must clearly mention on which project/program your version is based on (XNL TermCap).
#          3. You must link back to the original source (http://www.teamxnl.com/R36-XCC).
#          4. You must license your derivative work it's license must comply with the original license
#             and can't impose additional restrictions to your users
# 
# TIP: Just copying this 'info block' and then for example changing Project: to BasedOn: would be sufficient :)
#------------------------
#
# Redistribution request:
# Yeah, you could redistribute it, but at what purpose ;) :'). This script (and
# possible future versions of it) is purely intended to check if MY scripts and
# such are (possibly) compatible with your console/device.
# =================================================================================

# Preset Variables which make it easier to work with the path of this script and
# also make it easier/faster to re-use pieces of code in new/other scripts without
# having to pay attention to changing the correct file names
Application="XNL Compatibility Check"

if ! command -v dialog &> /dev/null; then
	printf "\n\n======================================\n"
	printf "XNL Error Message:\n"
	printf "It seems like you are trying to run the XNL Compatibility Check from a non supported device\n" 
	printf "or from a non-supported operating system. The XNL Compatibility Check uses the program dialog\n"
	printf "to show a 'graphical interface', and this program does not seem to be installed on your system.\n"
	printf "And this should by default be installed on R36S and R36H devices running on ArkOS!\n\n"
	printf "Please note that my tools, programs, scripts, drivers, tweaks etc are ONLY developed for and\n"
	printf "tested on R36S and R36H consoles!\n"
	printf "\nAffected Program: $Application\n\n"
	printf "======================================\n\n\n"
	sleep 5
	exit 1
fi

if [[ -n "$SSH_TTY" || "$(tty 2>/dev/null)" == "/dev/ttyFIQ0" ]]; then
	printf "\n\n======================================\n"
	printf "XNL Error Message:\n"
	printf "This program, tool or script can't be run via either SSH or the serial console!\n"
	printf "Sorry, this is because it for example runs, controls or needs local hardware on the R36S/R36H\n"
	printf "and because it for example could rely on local variables on the device itself.\n"
	printf "\nAffected Program: $Application\n\n"
	printf "======================================\n\n\n"
	sleep 5
	exit 1
fi


CurScriptDir=$(realpath "$(dirname "$0")")
CurScriptName=$(basename "$0")


# Variables which are used to determine if the Compatibility Check Passes or note
# YES! You could change them so that your system passes xD but that obviously doesn't
# mean that the REAL tools which depend on these specifications will actually work (safely)!
XCCVersion="1.0"
RequiredVersionArkOS="12242024"
RequiredLinux="Ubuntu 19.10"
IntendedKernel="4.4.189"

# YES! I know! Global vars don't need to be declared like this in bash/sh scripts!
# I'm a .NET programmer, let me be! xD
DetectedVersionArkOS=""

# Take control of tty1 (the terminal), clearing the terminal and printing the "Application" start text in color
sudo chmod 666 /dev/tty1
printf "\033c" > /dev/tty1
printf "\e[34mStarting XNL Compatibility Check $XCCVersion\n\e[32mPlease wait...\e[0m" > /dev/tty1
reset


# hide cursor
printf "\e[?25l" > /dev/tty1
dialog --clear

# Preset dialog height and width
height="15"
sheight="10"
width="55"
swidth="45"

# If it's running on a device containing RG503 in it's name then adjust the
# dialog size. NOT needed for my R36S/R36H tools, but I have left them in for
# SOME compatibility if users do run my scripts on other devices which run ArkOS
if test ! -z "$(cat /home/ark/.config/.DEVICE | grep RG503 | tr -d '\0')"
then
  height="20"
  sheight="15"
  width="60"
  swidth="50"
fi

export TERM=linux
export XDG_RUNTIME_DIR=/run/user/$UID/

pgrep -f gptokeyb | sudo xargs kill -9
pgrep -f osk.py | sudo xargs kill -9

# Compatibility for additional systems (originally from the ArkOs wifi.sh)
# Do note though that most of my scripts are only developed for and tested on
# R36S and R36H devices! Most of them should run fine on other systems, but this
# is just a guess and NOT supported by me in any way.
if [[ ! -e "/dev/input/by-path/platform-odroidgo2-joypad-event-joystick" ]]; then
if test ! -z "$(cat /home/ark/.config/.DEVICE | grep RG503 | tr -d '\0')"
then
	sudo setfont /usr/share/consolefonts/Lat7-TerminusBold20x10.psf.gz
else
	sudo setfont /usr/share/consolefonts/Lat7-TerminusBold22x11.psf.gz
fi
else
sudo setfont /usr/share/consolefonts/Lat7-Terminus16.psf.gz
fi
printf "\033c" > /dev/tty1


# Function to compare the versions based on date
SystemHasMinimalVersionArkOK() {
	# Reading the passed parameter (the required minimal version of ArkOS)
    local RequiredVer="$1"
	
	# The path where the ArkOS update files (well the 'version registration') can be found
	ConfigDir="/home/ark/.config/"
	
	
	# Check if we have a the ark config folder and abort if we haven't (we don't want to mess with other RetroConsole interfaces!)
	if [ ! -d "$ConfigDir" ]; then
		dialog --backtitle "$Application" --title "Incompatibility Issue Detected!" --msgbox "Unable to detect the directory:\n$ConfigDir\n\nAre you sure that you are running ArkOS on your device?\n\nIf this folder can't even be found, then it's unfortunately a hard no in terms of compatibility.\n\nThe XNL Compatibility Check will now abort\n\n " 12 $swidth
		
		# IF for some reason there was previously a 'system passed' registration on this installation
		# then we will now remove it due to this fail
		if [ -f /home/ark/.config/.xnlft-xcc-checkpass ]; then
			sudo rm -f /home/ark/.config/.xnlft-xcc-checkpass
		fi

		# make a 'XCC Failed registration' so that my other applications can detect (and warn users) that
		# the current system has failed the XNL Compatibility Check!
		sudo touch /home/ark/.config/.xnlft-xcc-checkfail
		exit 1
	fi
	
	# Find all the update files, filter by .update prefix, and sort by the date part in the filename (and ignore any dashes)
	local CurrentVer=$(sudo ls "$ConfigDir" -at | grep '^\.update' | sed 's/^\.update\([^-]*\).*/\1/' | head -n 1)


	if [ -z "$CurrentVer" ]; then
		dialog --backtitle "$Application" --title "Incompatibility Issue Detected!" --msgbox "Unable to detect ANY ArkOS updates in the directory:\n$ConfigDir\n\nAre you sure that you are running on a valid ArkOS installation?\n\nIf these updates can't be detected, then it's unfortunately a hard no in terms of compatibility.\n\nThe XNL Compatibility Check will now abort\n\n " $height $swidth

		# IF for some reason there was previously a 'system passed' registration on this installation
		# then we will now remove it due to this fail
		if [ -f /home/ark/.config/.xnlft-xcc-checkpass ]; then
			sudo rm -f /home/ark/.config/.xnlft-xcc-checkpass
		fi

		# make a 'XCC Failed registration' so that my other applications can detect (and warn users) that
		# the current system has failed the XNL Compatibility Check!
		sudo touch /home/ark/.config/.xnlft-xcc-checkfail

		exit 1
	fi

    # Convert MMDDYYYY to a comparable format (Unix timestamp)
    local CurrentVerTimestamp
    local RequiredVerTimestamp
    CurrentVerTimestamp=$(date -d "${CurrentVer:0:2}/${CurrentVer:2:2}/${CurrentVer:4:4}" +%s)
    RequiredVerTimestamp=$(date -d "${RequiredVer:0:2}/${RequiredVer:2:2}/${RequiredVer:4:4}" +%s)

	DetectedVersionArkOS="$CurrentVer"

    # Now we compare the timestamps and will detect if the currently installed version of ArkOS is
	# older than the latest update this program was designed for and/or tested on
    if [ "$CurrentVerTimestamp" -lt "$RequiredVerTimestamp" ]; then
        return 1 # In bash anything above 0 in a return code bascially put means 'error code' 
    else
        return 0 # In bash this means 'okay resume' 
    fi
}


StartUpApp(){
	local MessageOutput=""
	local ResultOutput=""
	local ErrorsFound=0
	local NeedToUpdateArkOS="n"
	local KernelFail="n"
	local DistroFail="n"
	local BootFilesFail="n"
	local ResolutionFail="n"
	local MainPass="y"
	
	if ! SystemHasMinimalVersionArkOK "$RequiredVersionArkOS"; then
		let ErrorsFound++
		ResultOutput+="[PASS] ArkOS Config Folder Detected\n"
		ResultOutput+="[PASS] ArkOS Update Files Detected[PASS]\n"
		ResultOutput+="[FAIL] Minimal ArkOS Version ($RequiredVersionArkOS)\n"
		ResultOutput+="       - Detected Version: $DetectedVersionArkOS\n"
		NeedToUpdateArkOS="y"
	else
		ResultOutput+="[PASS] ArkOS Config Folder Detected\n"
		ResultOutput+="[PASS] ArkOS Update Files Detected\n"
		ResultOutput+="[PASS] Minimal ArkOS Version ($RequiredVersionArkOS)\n"
	fi

	DetectedKernel=$(uname -r)
	if [[ ! $IntendedKernel == $DetectedKernel ]]; then
		let ErrorsFound++
		KernelFail="y"
		ResultOutput+="[FAIL] Kernel Version ($IntendedKernel)\n"
		ResultOutput+="       - Detected Version: $DetectedKernel\n"
		MainPass="n"
	else
		ResultOutput+="[PASS] Kernel Version ($IntendedKernel)\n"
	fi

	DetectedLinux=$(grep "PRETTY_NAME" /etc/os-release | cut -d= -f2 | tr -d '"\n')

	if [[ ! $DetectedLinux == $RequiredLinux ]]; then
		let ErrorsFound++
		ResultOutput+="[FAIL] Linux Distro ($RequiredLinux)\n"
		ResultOutput+="       - Detected: $DetectedLinux\n"
		DistroFail="y"
		MainPass="n"
	else
		ResultOutput+="[PASS] Linux Distro ($RequiredLinux)\n"
	fi

	if [ ! -f "/boot/rk3326-rg351mp-linux.dtb" ]; then
		let ErrorsFound++
		BootFilesFail="y"
		ResultOutput+="[FAIL] R36S/R36H/RG351MP Boot Files Not Found\n"
		MainPass="n"
	else
		ResultOutput+="[PASS] R36S/R36H/RG351MP Boot Files Detected\n"
	fi

	DisplayInfCat=$(cat /sys/class/drm/card0-DSI-1/mode | tr -d '\n' | tr -s ' ')
	# Check if the returned information matches something like: 640x480p77 
	if [[ $DisplayInfCat =~ ^([0-9]+x[0-9]+)([pi])([0-9]+)$ ]]; then
		resolution="${BASH_REMATCH[1]}"        # 640x480 for the R36S/R36H
	else
		resolution="$DisplayInfCat"
	fi

	if [[ ! $resolution == "640x480" ]]; then
		let ErrorsFound++
		ResolutionFail="y"
		ResultOutput+="[FAIL] Resolution Check (640x480)\n"
		ResultOutput+="       - Detected: $resolution\n"
		MainPass="n"
	else
		ResultOutput+="[PASS] Resolution Check (640x480)\n"
	fi

	if [[ $ErrorsFound == "0" ]]; then
		MessageOutput+="XNL Compatibility Check Result:\nCOMPATIBLE (Most Likely)\n"
		MessageOutput+="\n"
		MessageOutput+="It seems like it that your device is (or atleast should be) compatible for all my scripts, programs, tools etc."
		MessageOutput+=" It most likely is an R36S/R36H an RG351MP or an RGB10X. Do however yet again keep in mind that my releases are "
		MessageOutput+="ONLY intended to be used with the R36S or R36H.\n\n"
		MessageOutput+="TEST RESULTS LOG:\n"
		MessageOutput+="$ResultOutput"
	else
		if [[ $ErrorsFound == "1" && NeedToUpdateArkOS == "y" ]]; then
			MessageOutput+="XNL Compatibility Check Result:\nCOMPATIBLE but update required!"
			MessageOutput+="\n"
			MessageOutput+="It seems like it that your device is (or atleast should be) compatible for all my scripts, programs, tools etc."
			MessageOutput+=" It most likely is an R36S/R36H an RG351MP or an RGB10X. Do however yet again keep in mind that my releases are "
			MessageOutput+="ONLY intended to be used with the R36S or R36H.\n\n"
		else
			MainPass="n"
			MessageOutput+="XNL Compatibility Check Result:\n"
			MessageOutput+="INCOMPATIBLE (most likely)\n"
			MessageOutput+="\n"
			MessageOutput+="One or more compatibility checks have failed to confirm you are using a compatible console (R36S/R36H),"
			MessageOutput+=" and/or the required operating system version(s). Please do note that it could be your XNL Compatibility Check tool"
			MessageOutput+=" is out-of-date and for example doesn't recognize an updated ArkOS Linux Kernel or even distro. So please make sure that"
			MessageOutput+=" you are actually using the latest version of the XNL Compatibility Check tool and otherwise download a newer version from"
			MessageOutput+=" either my GitHub or my website directly: www.teamxnl.com/R36-XCC\n"
			MessageOutput+="\n"
			MessageOutput+="Installed XNL Compatibility Tool Version: $XCCVersion\n"
			MessageOutput+="\n"
			MessageOutput+="Detected issues:\n"
		
			if [[ $KernelFail == "y" ]]; then
				MessageOutput+="Possible Incompatible Kernel Detected:\n"
				MessageOutput+="The detected Linux Kernel on your system doesn't seem to match with the supported kernel for my tools and drivers.\n\n"
			fi
			if [[ $DistroFail == "y" ]]; then
				MessageOutput+="Possible Incompatible Linux Distro Detected:\n"
				MessageOutput+="The detected Linux Distro on your system doesn't seem to match with the supported distro for my tools and drivers."
				MessageOutput+=" It could simply be that the version number has increased and that you're using an out-dated XNL Compatibility Check tool,"
				MessageOutput+=" or you are not running on the expected linux distro.\n\n"
			fi

			if [[ $ResolutionFail == "y" ]]; then
				MessageOutput+="Incompatible Display Resolution Detected:\n"
				MessageOutput+="The detected resolution does not seem to match the resolution expected for the R36S/R36H consoles,"
				MessageOutput+=" due to this it is VERY unlikely that you are actually running on an supported R36S/R36H. Or you are for example"
				MessageOutput+=" running modified display drivers. My software does not account for this and might (WILL) cause issues when used on"
				MessageOutput+=" non-supported resolutions.\n\n"
			fi

			if [[ $BootFilesFail == "y" ]]; then
				MessageOutput+="Incompatible Boot Files:\n"
				MessageOutput+="I could not detect the correct bootfiles which would match the R36S/R36H/RG351MP bootfiles!"
				MessageOutput+=" this most likely means that your device is NOT an R36S or R36H! Therefor the XNL Compatibility Check will not be able to let your device pass.\n\n"
			fi


			MessageOutput+="Can I Use the XNL R36 Programs, Tools, Scripts Anyway?\n"
			MessageOutput+="NO IDEA! I have only developed and tested them on our own R36S and R36H devices. I would not recommend doing so because lots of my tools directly interface with the hardware or drivers in some sort of way."
			MessageOutput+=" And obviously this COULD cause (serious) issues if your device uses completely different hardware/circuitry. Also keep in mind that some of my tools actually expect certain hardware and/or controls (like two analog sticks for example) to function properly!"
			MessageOutput+="\n\n"
			MessageOutput+="RUNNING MY R36 TOOLS, SCRIPTS, PROGRAMS ETC ON ANY OTHER DEVICE THAN THE R36S/R36H IS AT YOUR OWN RISK. THEY MIGHT WORK JUST FINE, THEY MIGHT 'JUST' RENDER YOUR OS UNUSABLE (SIMPLY REQUIRING A REINSTALL), BUT THEY MIGHT ALSO CAUSE DAMAGE TO YOUR HARDWARE IF YOU ARE USING GPIO/HARDWARE CONTROL FUNCTIONS ON AN UNSUPPORTED DEVICE!\n\n"
		fi
		
		MessageOutput+="TEST RESULTS LOG (ERRORS: $ErrorsFound):\n"
		MessageOutput+="$ResultOutput"
	fi

	MessageOutput+="\n\n"
	MessageOutput+="NOTE: Despite if your device turns out to be compatible or not, using my tools, tweaks, programs ect are at your own risk.\n\n"
	MessageOutput+="CLONE DEVICES WARNING:\nThere are quite a lot of clones of the R36S and R36H, which have quite a few issues in both quality and compatibility, please make sure you are running the real R36S or R36H by checking this website if you are not certain:\nhttps://handhelds.miraheze.org/wiki/R36S_Clones\n\n "
	
	
	

	# Here we'll "register" if the XNL Compatibility Check has previously passed or failed on this system
	# we can then use this in my/our other applications to for example warn the user that it is for example
	# not recommended to install a certain driver, application etc 
	if [[ $MainPass == "y" ]]; then
		if [ -f /home/ark/.config/.xnlft-xcc-checkfail ]; then
			sudo rm -f /home/ark/.config/.xnlft-xcc-checkfail
		fi
	
		sudo touch /home/ark/.config/.xnlft-xcc-checkpass
	else
		if [ -f /home/ark/.config/.xnlft-xcc-checkpass ]; then
			sudo rm -f /home/ark/.config/.xnlft-xcc-checkpass
		fi
	
		sudo touch /home/ark/.config/.xnlft-xcc-checkfail
	fi

	dialog --title "XNL Compatibility Check Results ($XCCVersion)" --msgbox "$MessageOutput" 20 80
	exit 0
}


#==============================================================================================================================
# Cleanup function to 'cleanup after our script' 
#==============================================================================================================================
CleanUpOnExit() {
  printf "\033c" > /dev/tty1				# Clear the terminal
  if [[ ! -z $(pgrep -f gptokeyb) ]]; then  # Kill all running gptokeyb instances
    pgrep -f gptokeyb | sudo xargs kill -9 
  fi
  # Used to check for a specific platform this script is running on (a different device
  # than the R36S/H but I re-used this part for POSSIBLE future compatibility with other
  # handhelds like mine (code re-used from wifi.sh)
  if [[ ! -e "/dev/input/by-path/platform-odroidgo2-joypad-event-joystick" ]]; then
    sudo setfont /usr/share/consolefonts/Lat7-Terminus20x10.psf.gz
  fi
  exit 0
}

#==============================================================================================================================
# Gamepad control, 'trapping' the script exit and starting the menu
#==============================================================================================================================
# Set the permissions to interact with uinput (the 'device')
sudo chmod 666 /dev/uinput

# Loading a database (Simple DirectMedia Layer) which holds the info for lots of 'pre-configured' controllers so that the
# gamepad(s) (which also include the internal gamepad of the R36S/H) buttons are propperly assigned with gptokeyb
#(Gamepad to Keyboard/Mouse).
export SDL_GAMECONTROLLERCONFIG_FILE="/opt/inttools/gamecontrollerdb.txt"

# Find all (already) running processes of gptokeyb and kill (terminate) them. We do this to ensure that you for example
# wont get double key emulations or other issues which might arrise from multiple instances running.
if [[ ! -z $(pgrep -f gptokeyb) ]]; then
  pgrep -f gptokeyb | sudo xargs kill -9
fi

# Here we link gptokeyb to our script so that gptokeyb knows which script to instantly kill when we press
# Select + Start on the R36S or R36H. and option -C (followed by the file .gptk file location) tell gptokyb
# which buttons have to be emulated when we press the game controller buttons (and thus convert them to
# keyboard presses). The last section of this line basically ensures that gptokeyb runs in the background
# and that all it's output will be 'tossed into dev/null' (aka disappear in oblivion)/be discarded,
# esentially making it run silently.
/opt/inttools/gptokeyb -1 "$CurScriptName" -c "/opt/inttools/keys.gptk" > /dev/null 2>&1 &

# Reset/clear the terminal
printf "\033c" > /dev/tty1

# This ensures that the function CleanUpOnExit will be called when the script exits.
# we can/will use this to perform additional clean-ups and/or other routines we (might) need to
# do at the end our script/program
trap CleanUpOnExit EXIT

StartUpApp