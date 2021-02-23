#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=icon.ico
#AutoIt3Wrapper_Res_Fileversion=1.1.0.0
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <Array.au3>
#include <MsgBoxConstants.au3>
#include <File.au3>
#include <Date.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

; Break to Cancel
HotKeySet("{BREAK}","ExitScript")
HotKeySet("{PAUSE}","ExitScript")
Func ExitScript()
If MsgBox (4, "Break" ,"Break pressed. Stop Program?") = 6 Then Exit
EndFunc

Global $ytdl_path = (@ScriptDir & "\youtube-dl.exe")

Global $argsmp3 = (' --extract-audio --format=bestaudio --audio-format mp3 --audio-quality=320k --output "%(title)s.%(ext)s"')

Global $argsmp3channel = (' --extract-audio --format=bestaudio --audio-format mp3 --audio-quality=320k --output "%(uploader)s - %(title)s.%(ext)s"')

Global $argsmp4 = (' -f bestvideo[ext=mp4]+bestaudio --output "%(title)s.%(ext)s"')

Global $argsmp4channel = (' -f bestvideo[ext=mp4]+bestaudio --output "%(title)s.%(ext)s"')

Global $empty = ""

;test link
;https://youtu.be/HQnC1UHBvWA


#Region GUI
YoutubeDL()

Func YoutubeDL()
    ; Create a GUI with various controls.
   Global $hGUI = GUICreate("YouTube Downloader",370, 220,1000,500)
   Global $icon = GUISetIcon(@ScriptDir & "\icon.ico")
   TraySetIcon(@ScriptDir & "\icon.ico")
   Global $Menu1 = GUICtrlCreateMenu("Info")
   Local $idInfoitem = GUICtrlCreateMenuItem("DL Arguments", $Menu1)
   Local $idTipitem = GUICtrlCreateMenuItem("Tip for Downloading", $Menu1)
   Local $idVersitem = GUICtrlCreateMenuItem("Version", $Menu1)
   Global $Label1 = GUICtrlCreateLabel("Insert Youtube link here", 10, 45, 300, 24)
   GUICtrlSetFont(-1, 10, 200, 0, "Arial")
   Global $Pic1 = GUICtrlCreatePic(@ScriptDir & "\logo.jpg", 10, 10, 120, 33)



   Global $video_url = GUICtrlCreateInput("", 10, 70, 350, 20)
   Global $idConvertMP3 = GUICtrlCreateButton("Convert to MP3", 10, 100, 85, 25)
   Global $idConvertMP4 = GUICtrlCreateButton("Convert to MP4", 10, 140, 85, 25)
   Local  $idCheckbox = GUICtrlCreateCheckbox("Include Uploader", 10, 170, 185, 25)
   Global $idUpdate = GUICtrlCreateButton("Update YT-DL", 250, 100, 85, 25)
   Global $Label1 = GUICtrlCreateLabel("Download not working? Try Updating YT-DL", 230, 140, 130, 50)
   GUICtrlSetFont(-1, 9, 0, 0, "Arial")




    ; Display the GUI.
    GUISetState(@SW_SHOW, $hGUI)

    ; Loop until the user exits.
	While 1

		$nMsg = GUIGetMsg()
        Switch $nMsg
            Case $GUI_EVENT_CLOSE
                Exit

					 Case $idConvertMP3

						   Global $link = GUICtrlRead($video_url)

						   If $link = $empty Then
							  MsgBox(0, "Error", "Please insert a Link")
						   ElseIf _IsChecked($idCheckbox) Then
							  ConvertMP3Channel()
						   Else
						   ConvertMP3()
						   EndIf

					 Case $idConvertMP4

						   Global $link = GUICtrlRead($video_url)

						   If $link = $empty Then
							  MsgBox(0, "Error", "Please insert a Link")
						   ElseIf _IsChecked($idCheckbox) Then
							  ConvertMP4Channel()
						   Else
							  ConvertMP4()
						   EndIf

					 Case $idUpdate
						UpdateYTDL()

					 Case $idInfoitem
						MsgBox(0, "Arguments", "Arguments for MP3 = " & $argsmp3 & " Arguments for MP4 = " & $argsmp4)

					 Case $idTipitem
						MsgBox(0,"Word of Advice", "When Downloading an MP3 on Youtube, always use Topic Channels when available because those are the Uploads from the Distributor, which is always in the highest Quality")

					 Case $idVersitem
						If MsgBox(4,"Version", "This is Version 1.1. Would you like to check for Updates?") = 6 Then
							ShellExecute(@ScriptDir & "\update.exe")
							Exit
						Else
						EndIf


        EndSwitch
    WEnd

    ; Delete the previous GUI and all controls.
    GUIDelete($hGUI)
EndFunc
#EndRegion

;Run Conversion
Func ConvertMP3()
	Run($ytdl_path & " " & $link & $argsmp3)
EndFunc

Func ConvertMP3Channel()
	Run($ytdl_path & " " & $link & $argsmp3channel)
EndFunc

Func ConvertMP4()
	Run($ytdl_path & " " & $link & $argsmp4)
EndFunc

Func ConvertMP4Channel()
	Run($ytdl_path & " " & $link & $argsmp4channel)
EndFunc

;Other Functions

Func UpdateYTDL()
   Run($ytdl_path & " -U")
EndFunc

Func _IsChecked($idControlID)
    Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>_IsChecked