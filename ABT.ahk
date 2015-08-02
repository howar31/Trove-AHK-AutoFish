#WinActivateForce

F11::	; Start the script
WinGet, pidn, PID, A
pid := pidn
WinGet, hwnds, ID, A
Handle := hwnds
Lure := 9999	; Set max lure
BT := 0	; Auto boot trhow setting, 1 is on, 0 is off
Base := getProcessBaseAddress()
WaterAddress := GetAddressWater(Base,0x00989230)	; Water memory address
LavaAddress := GetAddressLava(Base,0x00989230)		; Lava memory address
ChocoAddress := GetAddressChoco(Base,0x00989230)	; Choco memory address

LureCount := 0	; Used lure count
Loop %Lure% {	; If still have lure (by counting)
	LureCount := LureCount +1
	; Open character panel for anti-idle
	ControlSend, , {c down}, ahk_pid %pid%
	Sleep, 86
	ControlSend, , {c up}, ahk_pid %pid%
	Sleep, 500

	; Casting the line
	ControlSend, , {f down}, ahk_pid %pid%
	Sleep, 86
	ControlSend, , {f up}, ahk_pid %pid%

	Catch := 0	; Set "caught" singal as false
	PoleCheck := 40	; Set pole check interval

	Loop {
	; Line casted and pole checking loop
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

		if (BT = 1) {
		; If BT is set to true(1) then execute auto boot throw script
			Imagesearch, Foundx, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *70 c:\boot.bmp
			if (errorlevel = 0) {
				MouseClickDrag, Left, %FoundX%, %FoundY%, 779, 412
			}
		}
	}
}
ExitApp

F10::	; Stop the script
ExitApp

F9::	; Toggle boot throw
if (BT = 1) {
	BT := 0
} else {
	BT := 1
}

GetAddressWater(Base, Address) {
	pointerBase := base + Address
	y1 := ReadMemory(pointerBase)
	y2 := ReadMemory(y1 + 0x144)
	y3 := ReadMemory(y2 + 0xe4)
	Return WaterAddress := (y3 + 0x70) 
}

GetAddressLava(Base, Address) {
	pointerBase := base + Address
	y1 := ReadMemory(pointerBase)
	y2 := ReadMemory(y1 + 0x144)
	y3 := ReadMemory(y2 + 0xe4)
	Return LavaAddress := (y3 + 0x514) 
}

GetAddressChoco(Base, Address) {
	pointerBase := base + Address
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