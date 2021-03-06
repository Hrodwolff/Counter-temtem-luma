#include <GuiConstantsEx.au3>
#include <ImageSearch2015.au3>
#include <MsgBoxConstants.au3>
#include <FileConstants.au3>
#include <WinAPIFiles.au3>
#include <File.au3>
#include <Array.au3>
#include <WindowsConstants.au3>
#Include <WinAPI.au3>
#Include <FontConstants.au3>
#include <ColorConstants.au3>

Opt("GUIOnEventMode", 1)
; ===============================================================================================================================
; Description ...: Counter temtem for luma hunter
; Author ........: Rodolphe Dumas (Hrodwolf)
; Notes .........:
; ===============================================================================================================================

; ===============================================================================================================================
; Global variables
; ===============================================================================================================================
Global $Var_1 = 0
Global $rate = 8000
Global $Var_2 = (100*$Var_1)/$rate
Global $y = 0, $x = 0
Global $combat_statut = 0
Global $first_tem = 0
Global $second_tem = 0
Global $List
Global $Selected
Global $icon
Global $img

;=================================== BEGIN Normal Window ======================================================
; Title
$hGUI = GUICreate("Temtem Counter Luma", 450, 150, $WS_EX_OVERLAPPEDWINDOW)
; Close
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEButton")

; Content
; Manque Variable pour définir image à chercher pour
GUICtrlCreateLabel("Choose temtem:", 30, 11)
$List = GUICtrlCreateCombo ( "", 110, 8, 200, 30)
GUICtrlSetData($List, "Oree|Zaobian|Platypet|Platox|Platimous|Swali|Loali|Tateru|Paharo|Paharac|Granpah|Ampling|Amphatyr|Bunbun|Mudrid|Hidody|Taifu|Fomu|Wiplump|Skail|Skunch|Houchic|Tental|Orphyll|Nidrasil|Banapi|Capyre|Lapinite|Azuroc|Zenoreth|Bigu|Babawa|Kaku|Saku|Valash|Barnshe|Gyalis|Occlura|Myx|Raiber|Raize|Raican|Pewki|Piraniant|Saipat|Crystle|Sherald|Hocus|Pocus|Sparzy|Mushi|Mushook|Magmis|Mastionne|Umishi|Ukama|Raignet|Smazee|Baboong|Zizare|Spriole|Deendre|Cerneaf|Toxolotl|Noxolotl|Blooze|Goolder|Zephyruff|Volarend|Ganki|Gazuma|Oceara|Shuine|Nessla|Valiar|Kalazu|Kalabyss|Adoroboros|Tuwai|Tuvine|Kinu|Vulvir|Vulor|Vulcrane|Pigepic|Anahir")

Local $iSaiparkBox = GUICtrlCreateCheckbox("Saipark", 350, 11)

Local $iOKButton = GUICtrlCreateButton("OK", 30, 40, 60)
GUICtrlSetOnEvent($iOKButton, "OKButton")

Local $iSaveButton = GUICtrlCreateButton("Save Hunt", 110, 40, 60)
GUICtrlSetOnEvent($iSaveButton, "SaveButton")

Local $iLoadButton = GUICtrlCreateButton("Load Hunt", 190, 40, 60)
GUICtrlSetOnEvent($iLoadButton, "LoadButton")

Local $iMeetButton = GUICtrlCreateLabel("Number of meetings : " & $Var_1, 30, 80, 190)
Local $iPercentButton = GUICtrlCreateLabel("Progress : " & $Var_2 & "%", 30, 100, 190, 200)
GUISetState()

;=================================== END Normal Window ======================================================

;=================================== BEGIN OVERLAY ======================================================

    Local $Form1 = GUICreate("", 500, 500, 0, 0, $WS_POPUP, $WS_EX_TOOLWINDOW + $WS_EX_TOPMOST + $WS_EX_LAYERED)
    GUISetBkColor(0x0000F4)
    _WinAPI_SetLayeredWindowAttributes($Form1, 0x0000F4)

    Local $overlay_count_meet = GUICtrlCreateLabel("Number of meetings : " & $Var_1, 30, 80, 400, 100)
    GUICtrlSetFont($overlay_count_meet, 20, 600, 2, "Arial", $ANTIALIASED_QUALITY)
    GUICtrlSetColor($overlay_count_meet, $COLOR_WHITE)
    Local $overlay_count_progress = GUICtrlCreateLabel("Progress : " & $Var_2 & "%", 30, 120, 400, 100)
    GUICtrlSetFont($overlay_count_progress, 20, 600, 2, "Arial", $ANTIALIASED_QUALITY)
    GUICtrlSetColor($overlay_count_progress, $COLOR_WHITE)
    
    GUISetState()

;=================================== END OVERLAY ======================================================


Func OKButton()
    $Selected = GUICtrlRead($List)
    MsgBox(0, "Temtem selected !", $Selected)
EndFunc   ;==>OKButton

Func SaveButton()
    Local Const $sFilePath = @ScriptDir&"/Save-hunt/"& $Selected &"-"& $rate & ".txt"

    Local $hFileOpen = FileOpen($sFilePath, $FO_OVERWRITE)

    FileWrite($hFileOpen, $Selected & @CRLF)
    FileWrite($hFileOpen, $Var_1 & @CRLF)
    FileWrite($hFileOpen, $Var_2 & @CRLF)
    FileWrite($hFileOpen, $rate & @CRLF)

    FileClose($hFileOpen)

    MsgBox($MB_SYSTEMMODAL, "Save", "You saved your hunt !")
EndFunc   ;==>SaveButton

Func LoadButton()
    Local Const $sMessage = "Load Hunt"

    Local $sFileOpenDialog = FileOpenDialog($sMessage, @ScriptDir & "\Save-hunt", "text (*.txt)", $FD_FILEMUSTEXIST)
    If @error Then
        MsgBox($MB_SYSTEMMODAL, "", "No file selected")

        FileChangeDir(@ScriptDir)
    Else
        FileChangeDir(@ScriptDir)

        $sFileOpenDialog = StringReplace($sFileOpenDialog, "|", @CRLF)
    EndIf

    Local $aInput

    _FileReadToArray($sFileOpenDialog, $aInput)
    For $i = 1 to UBound($aInput) -1
        $Selected = $aInput[1]
        $Var_1 = $aInput[2]
        $Var_2 = $aInput[3]
        $rate = $aInput[4]

        GUICtrlSetData($List, $Selected)
        GUICtrlSetData($iMeetButton, "Number of meetings : " & $Var_1)
        GUICtrlSetData($iPercentButton, "Progress : " & $Var_2 & "%")
        GUICtrlSetData($overlay_count_meet, "Number of meetings : " & $Var_1)
        GUICtrlSetData($overlay_count_progress, "Progress : " & $Var_2 & "%")
        
        If $rate = 3200 Then
            GUICtrlSetState($iSaiparkBox, $GUI_CHECKED)
        EndIf

    Next
    FileClose($sFileOpenDialog)
EndFunc   ;==>LoadButton

Func CLOSEButton()
    ; Note: At this point @GUI_CtrlId would equal $GUI_EVENT_CLOSE,
    ; and @GUI_WinHandle would equal $hMainGUI
    Exit
EndFunc   ;==>CLOSEButton

; Loop until user exits
While 1
    If _IsChecked($iSaiparkBox) Then
        $rate = 3200
    Else
        $rate = 8000
    EndIf
    ;check combat or not
    Local $check_combat = _ImageSearchArea2("DB/img_analysis/check_combat.png", 0, 430, 780, 585, 820, $x, $y, 0)
    Local $check_map = _ImageSearchArea("DB/img_analysis/check_map.png", 0, 1700, 235, 1830, 280, $x, $y, 50)
    Local $check_inventory = _ImageSearchArea("DB/img_analysis/check_inventory.png", 0, 620, 0, 1310, 90, $x, $y, 50)
    Local $check_team = _ImageSearchArea("DB/img_analysis/check_team.png", 0, 1740, 260, 1850, 450, $x, $y, 50)
    Local $check_catch = _ImageSearchArea("DB/img_analysis/check_catch.png", 0, 590, 320, 730, 490, $x, $y, 50)
    If $check_combat = True AND $check_map = 0 AND $check_inventory = 0 AND $check_team = 0 AND $check_catch = 0 Then
        $combat_statut = 1
        ;first temtem
        Local $search_tem_1 = _ImageSearchArea("DB/img_analysis/"& $Selected &".png", 0, 1140, 0, 1400, 120, $x, $y, 170)
        If $search_tem_1 == True AND $first_tem = 0 Then
            $Var_1+= 1
            $Var_2 = (100*$Var_1)/$rate
            GUICtrlSetData($iMeetButton, "Number of meetings : " & $Var_1)
            GUICtrlSetData($iPercentButton, "Progress : " & $Var_2 & "%")
            GUICtrlSetData($overlay_count_meet, "Number of meetings : " & $Var_1)
            GUICtrlSetData($overlay_count_progress, "Progress : " & $Var_2 & "%")
            $first_tem = 1
        EndIf

        ;second or alone temtem
        Local $search_tem_2 = _ImageSearchArea("DB/img_analysis/"& $Selected &".png", 1, 1550, 70, 1750, 120, $x, $y, 170)
        If $search_tem_2 == True AND $second_tem = 0 Then
            $Var_1+= 1
            $Var_2 = (100*$Var_1)/$rate
            GUICtrlSetData($iMeetButton, "Number of meetings : " & $Var_1)
            GUICtrlSetData($iPercentButton, "Progress : " & $Var_2 & "%")
            GUICtrlSetData($overlay_count_meet, "Number of meetings : " & $Var_1)
            GUICtrlSetData($overlay_count_progress, "Progress : " & $Var_2 & "%")
            $second_tem = 1
        EndIf
    Else
        $combat_statut = 0
    EndIf

    If $check_combat = False AND $check_map = 1 Then
        $combat_statut = 0
        $first_tem = 0
        $second_tem = 0
    EndIf
    Sleep(1000) ; Sleep to reduce CPU usage

    ;$mPos = MouseGetPos()
    ;ToolTip("x: " & $mPos[0] & @CRLF & "y: " & $mPos[1] )
    ;ToolTip($check_combat & @CRLF & "x: " & $mPos[0] & @CRLF & "y: " & $mPos[1] )
WEnd

Func _IsChecked($idControlID)
    Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>_IsChecked