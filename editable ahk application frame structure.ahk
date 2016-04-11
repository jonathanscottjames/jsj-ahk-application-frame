;copyright jsj jonathanscottjames@hotmail.com jsj@altavista.net jsj@msn.com jsj@hotmail.com
;this was authored in autohotykey script mostly a compilation of examples includud in ahk help file rhcp coresponded with script  segments that became the font selector and skan produced scripts that i used to construct the find not to mention ahk author of the script inturpreter/compiler Chris Mallett. i am releacing this  ahk script to allow people to launch and or make their own ahk applications. you can re edit this script and try to make dynamicly relocqatable moduels or just hack it to bits. lol
Regmon_Timer_ms=1000
Menu, FileMenu, Add, &New, FileNew
Menu, FileMenu, Add, &Open, FileOpen
Menu, FileMenu, Add, Open &default file(regmon.txt), defaultfile
Menu, FileMenu, Add, create regmon.txt, setregmontoambiguousvalue
Menu, FileMenu, Add, &Save, FileSave
Menu, FileMenu, Add, Save &As, FileSaveAs
Menu, FileMenu, Add  ; Separator line.
Menu, FileMenu, Add, E&xit, FileExit
Menu, SearchMenu, Add, &Find, FindText
Menu, OptionsMenu, Add, F&ont select, fontselector
Menu, OptionsMenu, Add, &Default font (Fixed Miriam Transparent), defaultfont
Menu, OptionsMenu, Add, &Wrap , wrapmode
Menu, optionsMenu, Add, caret position Status &bar, StatusOnOff
Menu, HelpMenu, Add, &About, HelpAbout
Menu, HelpMenu, Add, &Help, HelpOnCommands
Menu, modeMenu, Add, &Disassemble(Stm8), DisassembleStm8
Menu, modeMenu, Add, &Regkey monitor, regmon
Menu, modeMenu, Add, registry monitor re&fresh rate(default 1000ms),RegmonTimerSet
;Create the menu bar by attaching the sub-menus to it:
Menu, MyMenuBar, Add, &File,    :FileMenu
Menu, MyMenuBar, Add, &search,  :SearchMenu
Menu, MyMenuBar, Add, &options, :optionsMenu
Menu, MyMenuBar, Add, &Mode,   :modeMenu
Menu, MyMenuBar, Add, &Help,    :HelpMenu
; Attach the menu bar to the window:
Gui, Menu, MyMenuBar

Gui, +Resize  ; Make the window resizable.
Gui, Add, Edit, border hwndMainwin -wrap vMainEdit WantTab W600 R20
GuiControl,+HScroll,MainEdit ;add h scroll bar
Gui, Show

Gui, Add, StatusBar , Hidden vMyStatusBar

;Gui, Add, StatusBar, Hidden vMyStatusBar
;SB_SetText("x:" . A_CaretX . "`ty:" . A_CaretY . ,,1)
gosub, defaultfont
gosub, defaultfile
return


setregmontoambiguousvalue:
FileDelete,regmon.txt
FileAppend,HKLM\SOFTWARE\Microsoft\Cryptography\RNG\REG_SZ`nHKLM\SOFTWARE\Microsoft\Cryptography\RNG\REG_BINARY`n,regmon.txt
return

DisassembleStm8:
return
;******** end disassemble

;*** reg monitor start ************
;******** regmon timer set ********
regmon:
if cartetstatusonoff=
{
cartetstatusonoff=Yes
Menu, modeMenu,  Check, &Regkey monitor
GuiControl, Show, MyStatusBar
SetTimer, RegmonUpdate, %Regmon_Timer_ms%
GuiControlGet,MainEdit ;transfer text from Edit control to variable.
return
}
Menu, modeMenu,  UnCheck, &Regkey monitor
GuiControl, Hide, MyStatusBar
cartetstatusonoff=
SetTimer, RegmonUpdate,off
return
;***** END REGMON MODE on off ******

;****** regmon set timer refresh rate ****
RegmonTimerSet:
Gui setregnon_ms: Destroy  ;Destroy before reopening
Gui,setregnon_ms: Add, Edit ,vRegmon_Timer_ms,%Regmon_Timer_ms%
Gui,setregnon_ms: Add, Button, gOkSet_ms Default, &ok
if UnknownOption
Gui,setregnon_ms: Add, Checkbox, x50 y40 vUnknownOption Checked,&Unknown_Option
else Gui,setregnon_ms: Add,Checkbox, x50 y40 vUnknownOption,&Unknown_Option
Gui,setregnon_ms: Show
return

OkSet_ms:
GuiControlGet, Regmon_Timer_ms  ;store timer data
GuiControlGet, UnknownOption ;store regmon unknown option checkbox.
Gui setregnon_ms: Destroy   ;Destroy before reopening
return
;****** end regmon set timer refresh rate ********

;**** refresh display reg contents start *****
RegmonUpdate:
regmonline:=0
regdisp=
Regmoncount:
regmonline:=regmonline+1
FileReadLine,regkeyname,%CurrentFileName%, %regmonline%
SoundBeep,5000,10
if ErrorLevel ;if end of file then update display
{
GuiControl,, MainEdit,%regdisp% 
return
}
RegRead,regvalue,%regkeyname%
regdisp=%regdisp%`n%regkeyname% %regvalue%
goto, Regmoncount
;**** refresh display reg contents end *****
;************ regmon end *****

;***start caret position stratus bar*******
;****start caret position status bar on off*************
StatusOnOff:
if cartetstatusonoff=
{
cartetstatusonoff=Yes
menu, optionsMenu, Check, caret position Status &bar
GuiControl, Show, MyStatusBar
SetTimer, caretxyUpdate, 1000
return
}

menu, optionsMenu, UnCheck, caret position Status &bar
GuiControl, Hide, MyStatusBar
cartetstatusonoff=
SetTimer,caretxyUpdate,off
return
;****** end caret position status bar on off ******
caretxyUpdate:
GetKeyState,mouseLbut,LButton
if mouseLbut=d
SB_SetText("***use shift + arrow keys for real time display*****")
if mouseLbut=d
return

DllCall("User32.dll\SendMessage","Ptr",Mainwin,"UInt",0x00B0,"UIntP",Start,"UIntP",End,"Ptr")
storestart:=start
storeend:=end
SendInput,+{Right}
DllCall("User32.dll\SendMessage","Ptr",Mainwin,"UInt",0x00B0,"UIntP",Start,"UIntP",End,"Ptr")

if (start>storestart){
SB_SetText("position:" . storestart+1 . "")
SendMessage,0xB1,storeend,storestart,,ahk_id %Mainwin%
return
}

SB_SetText("position:" . storeend+1 . "")
SendMessage,0xB1,storestart,storeend,,ahk_id %Mainwin%
return
;******** end caret update ***********************
;***** end caret position status bar ********

;**********start find************
~f3::
IfWinNotActive,%CurrentFileName%
return
if findthis
goto, findagain

~^f::
IfWinNotActive,%CurrentFileName%
return
FindText:
Gui finder: Destroy  ;Destroy before reopening
Gui,finder: Add, Edit ,vfindthis,%findthis%
Gui,finder: Add, Button, gFindIt Default, &Find
if CaseSense
Gui,finder: Add, Checkbox, x50 y40 vCaseSense Checked,&Case Sensitive
else Gui,finder: Add,Checkbox, x50 y40 vCaseSense,&Case Sensitive
Gui,finder: Show
return

FindIt:
;GuiControlGet,MainEdit ;Retrieve text in Edit control.
;GuiControl,,MainEdit,%MainEdit% ;restore text to edit.
GuiControlGet, FindThis  ;store find data
GuiControlGet, CaseSense ;store case sense checkbox.
Gui finder: Destroy   ;Destroy before reopening

findagain:
;GuiControlGet,MainEdit ;Retrieve text in Edit control.
ClipboardB4:=Clipboard ;save clipboard
CLIPBOARD= ;clear clipboard
SendInput,^+{home}^{Insert}{RIGHT} ;copy to carret
caretpos:=strlen(Clipboard) ;determine clipboard len
Clipboard=%ClipboardB4% ;restore clipboard
;restore carret position after mark and copy
SendMessage,0xB1,caretpos,caretpos,,ahk_id %Mainwin%
foundpos:=InStr(mainedit,findthis,CaseSense,caretpos+2)-1

if foundpos=-1 ;if not found, beep and search from start
{
soundbeep 1000,50 
foundpos:=InStr(mainedit,findthis,CaseSense,1)
if foundpos=0
{
MsgBox,,not found in %CurrentFileName%, can't find "%findthis%" try (non case sensitive)
return
}
}

foundlen:=strlen(findthis)
SendMessage,0xB1,foundpos,foundpos,,ahk_id %Mainwin%
SendInput,+{right %foundlen%}
return

finderGuiClose: ;cleanup "find" when x, escape, or exit
finderGuiEscape:
Gui finder: Destroy  ; Destroy the find box.
return
;******end find ********************

wrapmode:
if wrapmode=Yes
{
wrapmode=
WinGetPos,wrapX,wrapY,wrapWidth,wrapHeight,%CurrentFileName%
menu, OptionsMenu, unCheck, &Wrap
GuiControlGet,MainEdit ;Retrieve text in Edit control.
gui, destroy ;colse old non wrap mode gui
Gui,font,s%size% w%weight%,%fontname% ;restore font
Gui, Menu, MyMenuBar ;restore the menu bar

Gui, +Resize  ; Make the window resizable.
Gui, Add, Edit,hwndMainwin -wrap vMainEdit WantTab  w180 h200
GuiControl, +HScroll,MainEdit ;add h scroll bar
Gui, Show,, %CurrentFileName%
WinMove,%CurrentFileName%,,wrapX,wrapY,wrapWidth,wrapHeight
GuiControl,,MainEdit,%MainEdit% ;restore text to edit.
return
}

if wrapmode=
{
wrapmode=Yes
WinGetPos,wrapX,wrapY,wrapWidth,wrapHeight,%CurrentFileName%
menu, OptionsMenu, Check, &Wrap
GuiControlGet,MainEdit ;Retrieve text in Edit control.
gui, destroy ;colse old non wrap mode gui
Gui,font,s%size% w%weight%,%fontname% ;restore font
Gui, Menu, MyMenuBar ;restore the menu bar
Gui, +Resize  ; Make the window resizable.
Gui, Add, Edit,hwndMainwin +wrap vMainEdit WantTab  w180 h200
Gui, Show,, %CurrentFileName%
WinMove,%CurrentFileName%,,wrapX,wrapY,wrapWidth,wrapHeight
GuiControl,,MainEdit,%MainEdit% ;restore text to edit.
return
}

defaultfile:
SelectedFileName=regmon.TXT
CurrentFileName = %SelectedFileName%
goto, FileRead
return

defaultfont:
size=10
weight=400
fontname=Fixed Miriam Transparent
gui, font, s%size% w%weight%, %fontname% ;update 
GuiControl , Font , MainEdit
return

;font selector(authored by rhcp on ahk forum (revised by jsj)
fontselector:
VarSetCapacity(LOGFONT, 92, 0)
VarSetCapacity(ChooseFont, 60, 0)
numput(60, ChooseFont)
numput(&LOGFONT, ChooseFont, 12)
numput(0x101, ChooseFont, 20)
returnValue := DllCall("comdlg32\ChooseFont", "Ptr", &ChooseFont)
size:= NumGet(ChooseFont, 16)//10 
Colour:=NumGet(ChooseFont, 24) 
Weight:=NumGet(LOGFONT, 16, "UInt")
Italic:=NumGet(LOGFONT, 20, "UChar")
Underline:=NumGet(LOGFONT, 21, "UChar")
StrikeOut:=NumGet(LOGFONT, 22, "UChar")
fontname:=StrGet(&LOGFONT + 28)
if not returnValue
return
gui, font, s%size% w%weight%, %fontname% ;update font options
GuiControl, Font, mainedit ;control font must be updated
return




FileNew:
GuiControl,, MainEdit  ; Clear the Edit control.
return

FileOpen:
Gui +OwnDialogs  ; Force the user to dismiss the FileSelectFile dialog before returning to the main window.
FileSelectFile, SelectedFileName, 3,, Open File, Text Documents (*.txt)
if SelectedFileName =  ; No file selected.
    return
Gosub FileRead
return

FileRead:  ; Caller has set the variable SelectedFileName for us.
FileRead, MainEdit, %SelectedFileName%  ; Read the file's contents into the variable.
if ErrorLevel
{
    MsgBox Could not open "%SelectedFileName%".
    return
}
GuiControl,, MainEdit, %MainEdit%  ; Put the text into the control.
CurrentFileName = %SelectedFileName%
Gui, Show,,%CurrentFileName% ;Show file name in title bar.
return

FileSave:
if CurrentFileName =   ; No filename selected yet, so do Save-As instead.
    Goto FileSaveAs
Gosub SaveCurrentFile
return

FileSaveAs:
Gui +OwnDialogs  ; Force the user to dismiss the FileSelectFile dialog before returning to the main window.
FileSelectFile, SelectedFileName, S16,, Save File, Text Documents (*.txt)
if SelectedFileName =  ; No file selected.
    return
CurrentFileName = %SelectedFileName%
Gosub SaveCurrentFile
return

SaveCurrentFile:  ; Caller has ensured that CurrentFileName is not blank.
IfExist %CurrentFileName%
{
    FileDelete %CurrentFileName%
    if ErrorLevel
    {
        MsgBox The attempt to overwrite "%CurrentFileName%" failed.
        return
    }
}
GuiControlGet, MainEdit  ; Retrieve the contents of the Edit control.
FileAppend, %MainEdit%, %CurrentFileName%  ; Save the contents to the file.
; Upon success, Show file name in title bar (in case we were called by FileSaveAs):
Gui, Show,, %CurrentFileName%
return

HelpAbout:
Gui, About:+owner1  ; Make the main window (Gui #1) the owner of the "about box".
Gui +Disabled  ; Disable main window.
Gui, About:Add, Text,, jsj revision of oem ahk sample editor with added search`n wrap on off`n font select`n default file`n default font and command help`n caret position status bar`n regmon mode.

Gui, About:Add, Button, Default, OK
Gui, About:Show
return


AboutButtonOK: ;ok button target glabel of "about box".
AboutGuiClose:
AboutGuiEscape:
Gui, 1:-Disabled  ; Re-enable the main window (must be done prior to the next step).
Gui About: Destroy  ; Destroy the about box.
return


HelpOnCommands:
Gui, helpcom: Add, Text,,options default file=load regmon.txt`n options f&ont select=  select a new font`n default font= select Fixed Miriam Transparent font`n options wrap= enablew text wrap mode`n options caret position status bar= display the position of the text insertion caret in the status bar`n mode registry monitor= displays the values of listed reg keys in real time`n registry monitor re&fresh rate= the refresh rate of the registry key data display

Gui, helpcom: Add, Button, Default, OK
Gui, helpcom: Show
return

helpcomButtonOK: ; cleanup help com window on exit
helpcomGuiClose:
helpcomGuiEscape:
Gui, helpcom: Destroy  ; Destroy the about box.
return



GuiDropFiles:  ; Support drag & drop.
Loop, Parse, A_GuiEvent, `n
{
    SelectedFileName = %A_LoopField%  ; Get the first file only (in case there's more than one).
    break
}
SplitPath, SelectedFileName,,, FileExt  ; Get the file's extension.

Gosub FileRead
return

GuiSize:
if ErrorLevel = 1  ; The window has been minimized.  No action needed.
    return
; Otherwise, the window has been resized or maximized. Resize the Edit control to match.
NewWidth := A_GuiWidth - 20
NewHeight := A_GuiHeight - 20
GuiControl,Move,MainEdit,W%NewWidth% H%NewHeight%
return

FileExit:     ; User chose "Exit" from the File menu.
GuiClose:  ; User closed the window.
ExitApp