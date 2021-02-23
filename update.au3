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
#include <FileConstants.au3>
#include <IE.au3>
#include <INet.au3>
#include <WinAPIFiles.au3>

; Break for Cancel
HotKeySet("{BREAK}","ExitScript")
HotKeySet("{PAUSE}","ExitScript")
Func ExitScript()
If MsgBox (4, "Break" ,"Break pressed. Stop Program?") = 6 Then Exit
EndFunc

;Global Vars

Global $serverVersionFile = "https://raw.githubusercontent.com/thechantaro/Youtube-DL-GUI/main/version.txt";txt file with version number
Global $UpdatePath = @ScriptDir & "\YoutubeDL-GUI.exe"; This is the local path where you want your update to be downloaded into.
Global $ToBeReplacedPath = @ScriptDir & "\YoutubeDL-GUI.exe"; This is the path to your original program that you want to update.
Global $Download
Global $updateFailed
Global $retryornot

; ---- These are the two main functions to run
GetCurrentSoftwareVersion()
CheckVersion()
;----

Func GetCurrentSoftwareVersion()
    ; Retrieve the file version of the target/original executable. | Retrieve the version number contained in your version.txt file.
    Global $localEXEversion = FileGetVersion($ToBeReplacedPath)
    Global $remoteEXEversion = _INetGetSource($serverVersionFile)

EndFunc   ;==>GetCurrentSoftwareVersion

Global $serverUpdateExe = "https://github.com/thechantaro/Youtube-DL-GUI/releases/download/v" & $remoteEXEVersion &"/YoutubeDL-GUI.exe" ; This is the path to the update.exe file on your server.

Func CheckVersion()
;check if local version is lower than server version - if server version higher than local version then push update
If $localEXEversion < $remoteEXEversion Then
    MsgBox(0,"Outdated Version detected","New Version will be downloaded now")

    Global $Download = InetGet($serverUpdateExe, $UpdatePath, $INET_FORCERELOAD, $INET_DOWNLOADBACKGROUND); This goes and downloads our update.exe file (forces a fresh download)
    ;The 'do' statment below forces the script to wait until the download has completed to continue.
    Do
        Sleep(250)
    Until InetGetInfo($Download, $INET_DOWNLOADCOMPLETE)
    MsgBox(0,"Done","Download Complete")
    DownloadDeleteRename()

Else
    MsgBox(0,"Newest Version","You are using the newest Version"); we do "lower" so that when you are working on updates locally and testing, your script doesn't force you to update.
EndIf

EndFunc;CheckVersion

Func DownloadDeleteRename()

    FileDelete($ToBeReplacedPath); this will delete the original exe file
    FileMove($UpdatePath,$ToBeReplacedPath,1); this will rename your update.exe to whatver your original exe file name was so that you have replaced the original exe with the updated exe

    ; lets check to make sure our update was successful - We do this by checking the local and remote file versions again... If the update was successful, then the local exe file and the remote version.txt file will be the same number.

    GetCurrentSoftwareVersion()

    MsgBox(0,"",$localEXEversion & $remoteEXEversion)

    If $localEXEversion = $remoteEXEversion Then
        ;all is good - the update was successful
        Global $updateFailed = false; this means the update did not fail
        ConsoleWrite($updateFailed)
    Else
        $retryornot = MsgBox(16 + 5,"Update error detected","Likely cause: Firewall/Antivirus prevented the download. ")
        ;this tells us what button the user clicked on msgbox... cancel = 2, and retry = 4
        Global $updateFailed = true; this means the update failed
        ConsoleWrite($updateFailed)

        EndIf

        ; with the if statement below we are telling the software to simply close if the user rejected our update instead of retrying.
        If $retryornot = 4 Then
            GetCurrentSoftwareVersion()
            CheckVersion()
        Else
            ;close application
            ;Exit (remove this text and uncomment 'exit' to make the program actually close)



    EndIf

    EndFunc;DownloadDeleteRename