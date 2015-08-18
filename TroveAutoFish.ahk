#WinActivateForce
; Script config. Do NOT change value here, might working inproperly!
global Version := "v20150818"	; The version number of this script
global FishAddress := "0x00966B98"	; The memory address for fishing

; Tooltip settings
global TooltipX := 80	; Tooltip's X position
global TooltipY := 150	; Tooltip's Y position

; Hotkeys settings, change the hotkeys here
global HK_AutoFish := "F11"	; Hotkey for auto fishing
global HK_AutoBoot := "F10"	; Hotkey for auto boot throw
global HK_AntiAFK := "F9"	; Hotkey for anti-AFK
global HK_Info := "F8"	; Hotkey for info tooltip toggle
global HK_Exit := "F6"	; Hotkey for exit the script

; Auto Boot Throw settings
global Interval_Boot := 2000	; Auto Throw Boot trigger interval in milliseconds.  The default is 2000ms.  Set longer interval to save CPU usage.  Set shorter interval to throw boot faster.
global BootImgPath := "c:\boot.bmp"	; set your Old Bood image path here
global FastABTDelay := 0.5	; Long press delay before triggering Fast ABT.  The default is 0.5 seconds

; Anti-AFK settings
global Interval_AFK := 10000	; Anti-AFK trigger interval in milliseconds.  The default is 10 seconds (10000ms)
global AFK_Key := "End"	; The key to send to prevent AFK by Anti-AFK.  The default is "End" key which will not effect Trove gameplay

; Flags startup settings. Do NOT change value here, might working inproperly!
global Flag_ABT := false	; Auto boot throw default setting, 1 is on, 0 is off
global Flag_AFK := false	; Anti-AFK default setting, 1 is on, 0 is off
global Flag_Tooltip := true	; 1 for showing tooltip, 0 for hiding tooltip
global Flag_Fishing := false	; If auto fishing started, set to 1

; Fishing info settings. Do NOT change value here, might working inproperly!
global TimerS := 0	; Fishing timer seconds
global TimerM := 0	; Fishing timer minutes
global TimerH := 0	; Fishing timer hours
global LureCount := 0	; Used lure count

CoordMode, ToolTip, Screen
UpdateTooltip()

Hotkey, %HK_AutoFish%, L_AutoFish
Hotkey, %HK_AutoBoot%, L_AutoBoot
Hotkey, %HK_AntiAFK%, L_AntiAFK
Hotkey, %HK_Info%, L_Info
Hotkey, %HK_Exit%, L_Exit
Return

L_AutoFish:	; Auto Fishing
	if (Flag_Fishing) {
		Flag_Fishing := false
		TimerS := 0
		TimerM := 0
		TimerH := 0
		LureCount := 0
		; Stop fishing timer
		SetTimer, UpdateTimer, Off
		UpdateTooltip()
	} else {
		Flag_Fishing := true
		SetTimer, AutoFish, -1
		; Start fishing timer
		SetTimer, UpdateTimer, 1000
	}
Return

AutoFish:
	WinGet, pidn, PID, A
	pid := pidn
	WinGet, hwnds, ID, A
	Handle := hwnds

	Lure := 9999	; Set max lure
	Base := getProcessBaseAddress()
	WaterAddress := GetAddressWater(Base,FishAddress)	; Water memory address
	LavaAddress := GetAddressLava(Base,FishAddress)		; Lava memory address
	ChocoAddress := GetAddressChoco(Base,FishAddress)	; Choco memory address

	Loop %Lure% {
	; If still have lure (by counting)
		if (!Flag_Fishing)
			break

		NatualPress("b", pid)	; Open backpack to prevent camera rotate while moving mouse, and also for ImageSearch to find the Old Boot

		LureCount := LureCount +1
		UpdateTooltip()

		; Anti-AFK
		Gosub, AntiAFK

		NatualPress("f", pid)	; Casting the line
		Sleep, 15000	; Check for bite after 15 seconds.  Players must wait for 20-30 seconds for the lure to start splashing in order to reel in a fish. Reduce the pole checking loop.
		FishingTimeCount := 0
		
		Loop {
		; Line casted and pole checking loop, 1 second per check
			if (!Flag_Fishing)
				break

			UpdateTooltip()
			
			; Already cast and checking for biting
			CaughtWater := ReadMemory(WaterAddress)
			CaughtLava := ReadMemory(LavaAddress)
			CaughtChoco := ReadMemory(ChocoAddress)

			if (CaughtWater || CaughtLava || CaughtChoco) {
			; Fish caught, reel in
				NatualPress("f", pid)
				Random, Wait, 2000, 3500 ; Wait a few seconds
				Sleep, %Wait%
				NatualPress("b", pid)
				break
			}
			
			; caught nothing, wait 1 second and continue checking
			Sleep, 1000
			
			if (FishingTimeCount++ > 20) {	; If waiting time is over 35 seconds, it must be a miss or something wrong.  Re-cast.
				NatualPress("b", pid)
				break
			}
				
		}
	}
Return

L_AutoBoot:	; Toggle auto boot throw
	KeyWait, %HK_AutoBoot%, T%FastABTDelay%    ;Detect how long HK_AutoBoot has been pressed. Set 0.5 second
	if (errorlevel) {
		loop {
			UpdateTooltip()
			if (!GetKeyState(HK_AutoBoot, "P"))
				Break
			Gosub, AutoBootThrow
			Random, Wait, 10, 50 ; Wait a few milliseconds
			Sleep, %Wait%
		}
	} else {
		if (Flag_ABT) {
			Flag_ABT := false
			UpdateTooltip()
			SetTimer, AutoBootThrow, Off
		} else {
			Flag_ABT := true
			UpdateTooltip()
			Gosub, AutoBootThrow
			SetTimer, AutoBootThrow, %Interval_Boot%
		}
	}
Return

L_AntiAFK:	; Anti-AFK
	if (Flag_AFK) {
		SetTimer, AntiAFK, Off
		Flag_AFK := false
	} else {
		WinGet, pidn, PID, A
		pid := pidn

		SetTimer, AntiAFK, %Interval_AFK%
		Flag_AFK := true
	}
	UpdateTooltip()
Return

L_Info:	; Toggle tooltip
	if (Flag_Tooltip) {
		Flag_Tooltip := false
		ToolTip
	} else {
		Flag_Tooltip := true
		UpdateTooltip()
	}
Return

L_Exit:	; Stop the script
ExitApp

AutoBootThrow:
	Imagesearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *70 %BootImgPath%
	if (errorlevel = 0) {
		if (GetKeyState(HK_AutoBoot, "P")) {
			DragSpeed = 2	; Fast ABT
		} else {
			Random, DragSpeed, 4, 10	; Throw naturally
		}
		MouseClickDrag, Left, %FoundX%, %FoundY%, FoundX-450, %FoundY% ,%DragSpeed%
	}
Return

AntiAFK:
; Sending key to prevent AFK
	NatualPress(AFK_Key, pid)
Return

UpdateTimer:
	if (TimerS = 59) { 
		TimerS = 0 
		TimerM += 1
	}
	if (TimerM = 60) { 
		TimerM = 0 
		TimerH += 1 
		UpdateTooltip()
		Return
	}
	TimerS += 1
	UpdateTooltip()
Return

GetAddressWater(Base, Address) {
	pointerBase := Base + Address
	y1 := ReadMemory(pointerBase)
	y2 := ReadMemory(y1 + 0x144)
	y3 := ReadMemory(y2 + 0xe4)
	Return WaterAddress := (y3 + 0x70) 
}

GetAddressLava(Base, Address) {
	pointerBase := Base + Address
	y1 := ReadMemory(pointerBase)
	y2 := ReadMemory(y1 + 0x144)
	y3 := ReadMemory(y2 + 0xe4)
	Return LavaAddress := (y3 + 0x514) 
}

GetAddressChoco(Base, Address) {
	pointerBase := Base + Address
	y1 := ReadMemory(pointerBase)
	y2 := ReadMemory(y1 + 0x144)
	y3 := ReadMemory(y2 + 0xe4)
	Return ChocoAddress := (y3 + 0x2c0) 
}

getProcessBaseAddress() {
	global Handle
	return DllCall( A_PtrSize = 4
		? "GetWindowLong"
		: "GetWindowLongPtr"
		, "Ptr", Handle
		, "Int", -6
		, "Int64") ; Use Int64 to prevent negative overflow when AHK is 32 bit and target process is 64bit
	; if DLL call fails, returned value will = 0
} 

ReadMemory(MADDRESS) {
	global pid
	VarSetCapacity(MVALUE,4,0)
	ProcessHandle := DllCall("OpenProcess", "Int", 24, "Char", 0, "UInt", pid, "UInt")
	;DllCall("ReadProcessMemory", "UInt", ProcessHandle, "UInt", MADDRESS, "Str", MVALUE, "UInt", 4, "UInt *", 0)
	DllCall("ReadProcessMemory", "UInt", ProcessHandle, "Ptr", MADDRESS, "Ptr", &MVALUE, "Uint", 4)
	Loop 4
	result += *(&MVALUE + A_Index-1) << 8*(A_Index-1)
	return, result
}

NatualSleep() {
	Random, SleepTime, 66, 122
	Sleep, %SleepTime%
}

NatualPress(npbtn, nppid) {
	ControlSend, , {%npbtn% down}, ahk_pid %nppid%
	NatualSleep()
	ControlSend, , {%npbtn% up}, ahk_pid %nppid%
	NatualSleep()
}

UpdateTooltip() {
	if (!Flag_Tooltip) {
		return
	}

	Info_Tips := "`n[" . HK_Info . "] Toggle this info."
	Info_Exit := "`n[" . HK_Exit . "] Exit script."
	Info_Lure := "`nLure used - " . (LureCount - 1)

	if (!Flag_Fishing) {
		Info_Fish := "`n[" . HK_AutoFish . "] Auto Fishing is OFF."
	} else if (Flag_Fishing) {
		Info_Fish := "`n[" . HK_AutoFish . "] Auto Fishing is ON."
	}

	if (GetKeyState(HK_AutoBoot, "P")) {
		Info_Boot := "`n[FAST] Auto Boot Throw is ON."
	} else {
		if (!Flag_ABT) {
				Info_Boot := "`n[" . HK_AutoBoot . "] Auto Boot Throw is OFF."
		} else if (Flag_ABT) {
			Info_Boot := "`n[" . HK_AutoBoot . "] Auto Boot Throw is ON."
		}
	}

	if (!Flag_AFK) {
		Info_AFK := "`n[" . HK_AntiAFK . "] Anti-AFK is OFF."
	} else if (Flag_AFK) {
		Info_AFK := "`n[" . HK_AntiAFK . "] Anti-AFK is ON."
	}

	TimerS := SubStr("0" . TimerS, -1)
	TimerM := SubStr("0" . TimerM, -1)
	Timerinfo := "`nFishing Time - " . TimerH . ":" . TimerM . ":" . TimerS

	HeaderTip := "<AutoFish>`n---  " . Version . "  by Howar31"
	FuncTip := Info_Fish . Info_Boot . Info_AFK
	StatusTip := "`n---" . Info_Lure . Timerinfo
	FooterTip := "`n---" . Info_Tips . Info_Exit

	if (!Flag_Fishing) {
		ToolTip, %HeaderTip%%FuncTip%%FooterTip%, TooltipX, TooltipY
	} else if (Flag_Fishing) {
		ToolTip, %HeaderTip%%FuncTip%%StatusTip%%FooterTip%, TooltipX, TooltipY
	}
}