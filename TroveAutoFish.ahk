#WinActivateForce
global ABTflag := 0	; Auto boot throw default setting, 1 is on, 0 is off
global BootImgPath := "c:\boot.bmp"	; set your Old Bood image here
global TooltipX := 80	; Unified the tooltip's X position
global TooltipY := 150	; Unified the tooltip's Y position
global Tooltipflag := 1	; 1 for showing tooltip, 0 for hiding tooltip
global FishingStart := 0	; If auto fishing started, set to 1
global LureCount := 0	; Used lure count
global TimerS := 0
global TimerM := 0
global TimerH := 0

CoordMode, ToolTip, Screen
UpdateTooltip()

SetTimer, AutoBootThrow, 1

F11::	; Start the script
FishingStart := 1
SetTimer, UpdateTimer, 1000

WinGet, pidn, PID, A
pid := pidn
WinGet, hwnds, ID, A
Handle := hwnds

Lure := 9999	; Set max lure
Base := getProcessBaseAddress()
WaterAddress := GetAddressWater(Base,0x00964DDC)	; Water memory address
LavaAddress := GetAddressLava(Base,0x00964DDC)		; Lava memory address
ChocoAddress := GetAddressChoco(Base,0x00964DDC)	; Choco memory address

Loop %Lure% {
; If still have lure (by counting)
	LureCount := LureCount +1
	UpdateTooltip()

	; Open character panel for anti-idle
	ControlSend, , {c down}, ahk_pid %pid%
	Sleep, 86
	ControlSend, , {c up}, ahk_pid %pid%
	Sleep, 86
	ControlSend, , {c down}, ahk_pid %pid%
	Sleep, 86
	ControlSend, , {c up}, ahk_pid %pid%
	Sleep, 500

	; Casting the line
;	ControlSend, , {f down}, ahk_pid %pid%
	Sleep, 86
;	ControlSend, , {f up}, ahk_pid %pid%

	Catch := 0	; Set "caught" singal as false
	PoleCheck := 40	; Set pole check interval

	Loop {
	; Line casted and pole checking loop
		UpdateTooltip()
		if (Catch = 1) {
		; Already caught and need to cast again
			break
		} else {
		; Already cast and waiting for biting
			if (PoleCheckN = PoleCheck) {
				ControlSend, , {f down}, ahk_pid %pid%
				Sleep, 86
				ControlSend, , {f up}, ahk_pid %pid%
				LureCount := 0
			} else {
			}

			CaughtWater := ReadMemory(WaterAddress)
			CaughtLava := ReadMemory(LavaAddress)
			CaughtChoco := ReadMemory(ChocoAddress)

			if (CaughtWater = 1 or CaughtLava = 1 or CaughtChoco = 1) {
				ControlSend, , {f down}, ahk_pid %pid%
				Sleep, 86
				ControlSend, , {f up}, ahk_pid %pid%
				Random, Wait, 2000, 3500
				Sleep, %Wait%
				Catch := 1
			} else {
				PoleCheckN := PoleCheckN +1	; Pole check interval advance
				Sleep, 1000
			}
		}
	}
}
ExitApp

F10::	; Stop the script
ExitApp

F9::	; Toggle auto boot throw
if (ABTflag = 1) {
	ABTflag := 0
} else {
	ABTflag := 1
}
UpdateTooltip()
Return

F8::	; Toggle tooltip
if (Tooltipflag = 0) {
	Tooltipflag := 1
	UpdateTooltip()
} else {
	Tooltipflag := 0
	ToolTip
}
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
	Global Handle
	return DllCall( A_PtrSize = 4
		? "GetWindowLong"
		: "GetWindowLongPtr"
		, "Ptr", Handle
		, "Int", -6
		, "Int64") ; Use Int64 to prevent negative overflow when AHK is 32 bit and target process is 64bit
	; if DLL call fails, returned value will = 0
} 

ReadMemory(MADDRESS) {
	Global pid
	VarSetCapacity(MVALUE,4,0)
	ProcessHandle := DllCall("OpenProcess", "Int", 24, "Char", 0, "UInt", pid, "UInt")
	;DllCall("ReadProcessMemory", "UInt", ProcessHandle, "UInt", MADDRESS, "Str", MVALUE, "UInt", 4, "UInt *", 0)
	DllCall("ReadProcessMemory", "UInt", ProcessHandle, "Ptr", MADDRESS, "Ptr", &MVALUE, "Uint", 4)
	Loop 4
	result += *(&MVALUE + A_Index-1) << 8*(A_Index-1)
	return, result
}

UpdateTooltip() {
	F8info := "`n[F8] Toggle this info."
	F10info := "`n[F10] Exit script."
	F11info := "`n[F11] Start auto fishing."
	if (ABTflag = 0) {
		F9info := "`n[F9] Auto Boot Throw is OFF."
	} else if (ABTflag = 1) {
		F9info := "`n[F9] Auto Boot Throw is ON."
	}
	Lureinfo := "`nLure used - " . (LureCount - 1)
	TimerS := SubStr("0" . TimerS, -1)
	TimerM := SubStr("0" . TimerM, -1)
	Timerinfo := "`nFishing Time - " . TimerH . ":" . TimerM . ":" . TimerS

	StatusTip := "`n---" . Lureinfo . Timerinfo
	FooterTip := "`n---" . F8info . F10info

	if (Tooltipflag = 1) {
		if (FishingStart = 0) {
			ToolTip, =AutoFish= %F11info%%F9info%%FooterTip%, TooltipX, TooltipY
		} else if (FishingStart = 1) {
			ToolTip, =AutoFish= Now Fishing... %F9info%%StatusTip%%FooterTip%, TooltipX, TooltipY
		}
	} else {
		ToolTip
	}
}

AutoBootThrow:
	if (ABTflag = 1) {
	; If ABTflag is set to true(1) then execute AutoBootThrow script
		Imagesearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *70 %BootImgPath%
		if (errorlevel = 0) {
			MouseClickDrag, Left, %FoundX%, %FoundY%, FoundX-450, %FoundY%
		}
	}
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
		RETURN 
	}
	TimerS += 1
	UpdateTooltip()
Return