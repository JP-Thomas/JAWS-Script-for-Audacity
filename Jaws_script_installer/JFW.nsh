/*
Audacity Jaws script installer
Written by Dang Manh Cuong <dangmanhcuong@gmail.com> and Gary Campbell <campg2003@gmail.com>
This installer requires the NSIS program from http://nsis.sourceforge.net

This installer has the following features and limitations:
Features:
. Installs into all English versions of Jaws. This will be true as long as Freedom Scientific does not change the place to put scripts.
. The user can choose whether to install scripts for all users or the current user.
. Gets the correct install path of Jaws from the registry.
. Checks for a Jaws installation before starting setup. If Jaws is not installed, displays a warning message and quits.
. contains macros for extracting, compiling, deleting, and modifying scripts, so user can create a package containing multiple scripts quickly and easily.
;. Macro to copy script from all users to current user.
Limitations:
. This installer works with English versions only.
Date created: Wednesday, September 20, 2012
Last updated: Thursday,  November 12, 2015

Modifications:
11/12/15 Converted to use language strings.  
11/11/15 Previous saved to HG changeset:   203:3395f730d20d.
11/11/15 Now does not dump log file for just scripts install.
11/9/15 Converted body of macro CompileSingle to function __CompileSingle.  This was to see if not compiling problem was caused by being a macro.  Didn't help.
Reactivated could not compile messageBox and converted to yes/no.  If yes retries the compile.  Hasn't helped.
Have seen the funny list view again.
Added missing pop in CompileSingle.  This was causing only one version to be compiled.  Earlier I thought I could compile the failing version if I compiled them 1 at a time.  That isn't working now.
Changed CompileSingle so that it passes only the base file name and extension to scompile.  Did not help.
Added DetailPrint of scompile command.
11/8/15 Made DumpLog append to an existing log file.  Changed some logic to use LogicLib.
Now writes install time to log.  Added log message for good compile.
Added Alt+i to install confirm page.
Removed "CompileSingle" from DetailPrints for compile.
11/8/15 Previous saved to HG changeset:   202:8701e1cd473f.
11/7/15 Added DumpLog function, called in leave function of instfiles page.  Writes to installer.log in the $InstDir.
One compile seems to work, with multiple compiles it seems like only 1 works, although the files are extracted for all of them.  If you run separate installs the compiles work.
11/6/15 Removed "not found" message.
Changed DEFAULT_GUI_FONT to GUI_DEFAULT_FONT, removed 1 warning.
Now adds all versions.
Commented out debug messages.
With this version the list view does not speak properly in JAWS 16.0.4463. (It does now, no known changes.) Items speak when SayLine is pressed but not for prior/next line.  The checked state is not spoken for either of these, only when SPACE is pressed to change state.  It does work in NVDA 2015.3.
Reordered pushes in CheckScriptExists to prevent clobbering register.
When installing to a fra or esn directory the script is not compiled, compiled successfully manually.
Language files are copied to the proper folders.
Issue:  I observe that after running the installer from File Explorer, the focus has moved a couple of tabs to the right-- i.e. to View Mode or something.
11/5/15 Widened listview to accomodate language.
Compiles and executes up to display of JAWS list.  Only displays 1 version when 2 folders (fra and enu) exist, displays fra.
Prints "fra not found" in messagebox.
Debug MessageBoxes are active in DisplayJawsList and some of the getversion functions.
11/3/15 Wrote and tested ${StrContainsTok}.
Added star to unsupported version/language pairs in list view.
11/1/15 Converted keywords in JAWSSaveInstallInfo and JAWSRestoreInstallInfo to JAWSVersionLangs and JAWSVersionLangsCount.
Macro JAWSInstallItems now receives version in $0 and lang in $1.
10/31/15 Documented list view code.
Documented JAWSSelectVersionsPage for version/language pairs.
Added count to GetVersionLangs.
Converted GetJawsVersions, not tested.
10/30/15 Finished GetVersionLangs, tested in stand-alone test program.  It gets the lang dirs in a version.
Converted GetJawsScriptDir to work with a version/language pair or just a version.
Converted CompileSingle to work with version/lang pair.
JawsInstallVersion should be okay.  Changed documentation and commented out can't find compiler message which duplicates one in CompileSingle.
10/30/15 Added qs and qsm files to default JAWSInstallScriptItems macro.
10/29/15 Added define ScriptVerLangSep to separate version and language directory.  Removed enu from ScriptDir.
*/

/*
  h  Copyright (C) 2012, 2013  Gary Campbell and Dang Manh Cuong.  All rights reserved.

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
    
    See the file copying.txt for details.
*/

!ifndef __JAWSSCRIPTSINCLUDED
!define __JAWSSCRIPTSINCLUDED

;If you want to enable support for choosing to install in either the current user or all users, define JAWSALLOWALLUSERS before including this file.  If not defined, the default is to install into the current user.  If you execute SetShellVarContext you should also set the variable JAWSSHELLCONTEXT to match.
!ifdef JAWSALLOWALLUSERS
!echo "Including support for choosing between current user and all users."
!else
!warning "Support for installing for all users is not enabled.  To enable, define JAWSALLOWALLUSERS before including this file."
!EndIf ; else not JAWSALLOWALLUSERS

!ifndef JAWSSrcDir
!define JAWSSrcDir "script\" ;Folder relative to current folder containing JAWS scripts, empty or ends with backslash.
!EndIf

!ifndef JAWSDefaultProgDir
!define JAWSDefaultProgDir "$JAWSPROGDIR" ;Default directory containing JAWS program files (in JAWSDefaultProgDir\<JAWSVersion>)
!EndIf

!Define InstallFile $instdir\Install.ini ; file that stores information for the uninstaller
!Define tempFile $temp\Install.ini
!Define UnInstaller "Uninst.exe"
!Define JawsDir "$appdata\Freedom Scientific\Jaws" ;the folder where app data for Jaws 6.0 and above is located
!Define ScriptVerLangSep "/" ;separates JAWS version and language string.  The language string is the folder under ScriptDir for the scripts.
!ifndef JAWSScriptLangs
!Define JAWSScriptLangs "" ;default supported languages.
!EndIf
!Define ScriptDefaultLang "enu" ;default language string, these script files will be in the script source directory.
!Define Scriptdir "Settings" ;folder in $JawsDir, the script is put in a language folder under this folder
!Define JawsApp "JFW.EXE" ;Used to check if Jaws is installed
!Define Compiler "Scompile.exe" ;Used to compile script after installation

; Name of folder relative to $INSTDIR in which to install the installer source files.
!define JAWSINSTALLERSRC "Installer Source"

!include "uninstlog.nsh"
!include "strfunc.nsh" ; used in DisplayJawsList to check for a digit, and other things
!include "filefunc.nsh" ; used to get language subfolders
;!include "stack.nsh" ; debug

; Declare used functions from strfunc.nsh.
!ifndef StrTok_INCLUDED
${StrTok}
!endif
!ifndef StrLoc_INCLUDED
${StrLoc}
!endif

!include "nsDialogs.nsh"
;Modern UI configurations
!Include "MUI2.nsh"

;Timestamp of this run for messages.
!define /DATE MsgTimeStamp "%Y-%m-%d %H:%M"
;!define MUI_FINISHPAGE_NOAUTOCLOSE ; debug

;Global variables

var JAWSPROGDIR ; directory containing the JAWS programs.
var JAWSDLG ; handle of JAWS page dialog
var JAWSLV ; handle of JAWS versions list view
var JAWSGB
var JAWSRB1
var JAWSRB2
var JAWSREADME ;location of the README file for the Finish page

;-----
;Multi-language script support
function GetVersionLangs
  ;$0 -- JAWS version
  ;Returns language subfolders separated by | in $1, count in $2.
  ;Uses defines ${JawsDir} and ${ScriptDir}.
  push $R1
push $R2
  Push $R6
  Push $R7
  Push $R8
  Push $R9
  StrCpy $R1 "" ;accumulator
StrCpy $R2 0 ; count
  ${Locate} "${JawsDir}\$0\${ScriptDir}" "/L=D /G=0 /M=???" "GetVersionLangsHelper"
  Pop $R9
  Pop $R8
  Pop $R7
  Pop $R6
  StrCpy $2 $R2
  pop $R2
  StrCpy $1 $R1
  Pop $R1
  ${if} $1 != ""
    StrCpy $1 $1 -1
  ${endif}
FunctionEnd ;GetVersionLangs
  
Function GetVersionLangsHelper
StrCpy $R1 "$R1$R7|"
intop $R2 $R2 + 1 ;count
Push $R1 ;used to stop execution
FunctionEnd ; GetVersionLangsHelper

Function GetVerLang
  ;Separate version and lang dir.
  ;$0 - ver/lang pair, or just ver which will use default for lang
  ;Return: TOS = lang  dir (default lang dir if none given), TOS -1 = ver
  ;Uses ${ScriptVerLangSep}, ${ScriptDefaultDir}
push $1 ; used for version
push $3 ;used for lang dir
${StrLoc} $3 "$0" "${ScriptVerLangSep}" ">"
${if} $3 != ""
  ${StrTok} $1 "$0" "${ScriptVerLangSep}" "0" "0"
  ${StrTok} $3 "$0" "${ScriptVerLangSep}" "1" "0"
${else}
  ;Assume $0 is just a version, so copy it.
  StrCpy $1 "$0"
  StrCpy $3 "${ScriptDefaultLang}"
${endif}
;$1 = version, $3 = lang dir
;TOS = old $3, TOS-1 = old $1
exch 
; TOS = old $1, TOS-1 = old $3
exch $1 ; TOS = ver
exch ; TOS = old $3, TOS-1 = ver
exch $3 ; TOS = lang
FunctionEnd ;GetVerLang

!ifndef StrLoc_INCLUDED
  ${StrLoc}
!endif
function _StrContainsTok
  ;Report if token $1 is in $0 where $0 is a list of tokens with separator $2.  $2 must be a single character.
  ; Returns "" in $3 if not found, a number >= 0 otherwise.
  Push $R0
  StrCpy $R0 "$2$0$2"
  ${StrLoc} $3 $R0 "$2$1$2" ">"
  pop $R0
FunctionEnd ;_StrContainsTok

!macro StrContainsTok rslt list tok sep
  ;Determine if string tok is a token in list which is separated by character sep.
  ;Returns 1 in rslt if found, 0 otherwise.
  push $3
  push $0
  push $1
  push $2
  StrCpy $0 "${list}"
  StrCpy $1 "${tok}"
  StrCpy $2 "${sep}"
  call _StrContainsTok
  ${If} $3 == ""
    ;MessageBox MB_OK "StrContainsTok: $1 not found" ; debug
    StrCpy $3 0
  ${Else}
    StrCpy $3 1
    ${EndIf}
  pop $2
  pop $1
  pop $0
  exch $3
  pop ${rslt}
!MacroEnd ;StrContainsTok
!define StrContainsTok "!InsertMacro strContainsTok"

;-----

;Additional scripts from Cuong's cjfw.nsh
!Macro CompileSingle JAWSVer Source
;Assumes $OUTDIR points to folder where source file is and compiled file will be placed.
;JAWSVer - JAWS version/lang or version, i.e. "10.0/enu" or "10.0"
;Source - name of script to compile without .jss extension
;return: writes error message on failure, returns exit code of scompile (0 if successful) in $1.
;Recommend for scripts wich have only one source (*.JSS) file, or don't make any modification to any original files
;This macro saves time because it doesn't store and delete any temporary files.
push $0
strcpy $0 ${JAWSVer}
push $R1
;StrCpy $R1 "$OUTDIR\${Source}"
StrCpy $R1 "${Source}"
call __CompileSingle
pop $R1
pop $0
!MacroEnd

Function __CompileSingle
;$0 - JAWS version/lang or version, i.e. "10.0/enu" or "10.0"
;$R1 - name of script to compile without .jss extension
push $R0
push $R2 ;stdout/stderr output of scompile.
call GetVerLang
pop $0 ;lang, we don't need it
pop $0 ;version
call GetJawsProgDir
pop $R0
; $R0 has backslash at end of path.
StrCpy $R0 "$R0${Compiler}"
;StrCpy $R1 "$OUTDIR\${Source}"
;${GetFileAttributes} "$R1.jss" "all" $1
;DetailPrint "Attributes of file $R1.jss: $1"
!ifndef JAWSDEBUG ; debug
IfFileExists "$R0" +1 csNoCompile
!endif ; debug
!ifdef JAWSDEBUG
  MessageBox MB_OK `Pretending to run nsexec::Exec '"$R0" "$R1.jss"'`
  !Else ; not JAWSJEBUG
  csRecompile:
    DetailPrint `Executing command '"$R0" "$R1.jss"'` ; debug
  ;nsexec::Exec '"$R0" "$R1.jss"'
  ;pop $1 ;exit code of scompile
  ;StrCpy $R0 "c:\progra~2\mingw_sylvan\win32\wbin\cp" ; debug
  ;nsexec::ExecToStack '"$R0" "$R1.jss" "$R1.jsb"' ; debug
  nsexec::ExecToStack '"$R0" "$R1.jss"'
  pop $1 ;exit code of scompile
  pop $R2 ;scompile output
    ;MessageBox MB_OK "compile $R1.jss, SCompile returned $1$\r$\n$$OutDir=$OutDir, Output:$\R$\N$R2" ; debug
    IntCmp $1 0 csGoodCompile +1 +1
    DetailPrint "Could not compile $R1.jss, SCompile returned $1$\r$\n$$OutDir=$OutDir, Output:$\r$\n$R2$\r$\n"
    MessageBox MB_YESNO "$(CouldNotCompile)" /SD IDNO IDYES csRecompile
    GoTo csEnd
  csGoodCompile:
    DetailPrint "Compiled $R1.jss"
!EndIf ; else not JAWSDEBUG
GoTo csEnd
csNoCompile:
DetailPrint "Could not find JAWS script compiler $R0.  You will need to compile it with JAWS Script Manager to use it."
MessageBox MB_OK "$(CouldNotFindCompiler)"
strcpy $1 1 ; return error
  csEnd:
    pop $R2
  pop $R0
  FunctionEnd ;__CompileSingle

!Macro AdvanceCompileSingle JAWSVer Path Source
;Assumes $OUTDIR points to folder where source file is and compiled file will be placed.
;JAWSVer - JAWS version/lang or version, i.e. "10.0/enu" or "10.0"
;Path - desired context, either "current" or "all".
;Source - name of script to compile without .jss extension
;return: writes error message on failure, returns exit code of scompile (0 if successful)-- actually returns 1 on failure.
SetShellVarContext ${path}
!insertmacro CompileSingle ${JAWSVer} ${Source}
SetShellVarContext $JAWSShellContext
/*
ReadIniStr $0 ${TempFile} Install ${Path}
ReadIniStr $1 ${TempFile} Install Compiler
;Exec the sCompile.exe hiddently
;The extention of script source has been added
nsExec::Exec '"$1" "$0\${Source}.jss"'
*/
!MacroEnd

!Macro AddHotkey JKM Key Script
;Add hotkeys to *.jkm file
;Usually used by advanced user
;Assumes JKM file is in $OUTDIR.
;JKM - name of JKM file without the .jkm extension.
;key - string containing the key sequence, like "CTRL+JAWSKey+a".
;Script - name of script to bind to key.
;Entries will be added to the "Common Keys" section.
push $0
WriteIniStr "$OUTDIR\${JKM}.jkm" "Common Keys" "${Key}" "${Script}"
pop $0
!MacroEnd

!Macro CopyScript JAWSVer Name
;Use to copy any script source from share folder
push $0
push $1
SetShellVarContext "current"
strcpy $0 ${JAWSVer}
call GetJawsScriptDir
pop $0
IfFileExists $0\${Name} end
SetShellVarContext "all"
push $0
strcpy $0 ${JAWSVer}
call GetJAWSScriptDir
pop $1
pop $0
CopyFiles /silent "$1\${Name}" "$0\${Name}"
end:
SetShellVarContext $JAWSShellContext
pop $1
pop $0
!Macroend

!macro ModifyScript JAWSVer File Code
;Use to add some code to the existing script
;Like adding: use "skypewatch.jsb"" to default.jss
push $0
push $1
strcpy $0 $JAWSVer
call GetJAWSScriptDir
pop $0
FileOpen $1 "$0\${File}"
;Go to the botum of file
FileSeek $1 0 end
;Add a blank line to safely modify
FileWrite $1 `$\r$\n${Code}$\r$\n`
FileClose $1
pop $1
pop $0
!Macroend

!macro AdvanceModifyScript JAWSVer Path File Code
;Use to add some code to the existing script
;Like adding: use "skypewatch.jsb"" to default.jss
SetShellVarContext ${Path}
!insertmacro ModifyScript "${JAWSVer}" "${File}" "${Code}"
SetShellVarContext $JAWSShellContext
/*
ReadIniStr $0 ${TempFile} Install ${Path}
FileOpen $1 $0\${File} a
;Go to the bottom of file
FileSeek $1 0 end
;Add a blank lines to safely modify
FileWrite $1 "$\r$\n"
FileWrite $1 `${Code}`
FileClose $1
*/
!Macroend

!Macro Un.RemoveHotkey JAWSVer JKM Key
push $0
strcpy $0 ${JAWSVer}
call GetJAWSScriptDir
pop $1
DeleteIniStr "$1\${jkm}.jkm" "Common Keys" ${Key}"
pop $1
!macroend

;JAWS uninstall log macros.
!define JAWSLOGFILENAME "jawsuninstlog.txt"
!macro JAWSLOG_OPENINSTALL
push $UninstLog
!ifdef UninstLog
!define __JAWSLOGTemp ${UninstLog}
undef Uninstlog
!EndIf
!define UninstLog ${JAWSLOGFILENAME}
!insertmacro UNINSTLOG_OPENINSTALL
!macroend ;JAWSLOG_OPENINSTALL

!macro JAWSLOG_CLOSEINSTALL
!insertmacro UNINSTLOG_CLOSEINSTALL
pop $UninstLog
!undef UninstLog
!ifdef __JAWSLOGTemp
!define UninstLog ${__JAWSLOGTemp}
!undef __JAWSLOGTemp
!EndIf
!macroend ;JAWSLOG_CLOSEINSTALL

!macro JAWSLOG_UNINSTALL
push $UninstLog ; save log file handle if it exists
; if the log file name is defined, save it.
!ifdef UninstLog
!define __JAWSLOGTemp ${UninstLog}
!undef UninstLog
!EndIf
!define UninstLog ${JAWSLOGFILENAME}
!insertmacro UNINSTLOG_UNINSTALL
pop $UninstLog ; restore log file handle
!undef UninstLog
;If the log file name was previously defined, restore it.
!ifdef __JAWSLOGTemp
!define UninstLog ${__JAWSLOGTemp}
!undef __JAWSLOGTemp
!EndIf
!macroend ;JAWSLOG_UNINSTALL

;-----
; The following goes in the .nsh file.
!macro __FileDatedNF path item
!define __FileDatedNFUID ${__LINE__}
File /nonfatal "${path}${item}"
IfFileExists "$OUTDIR\${item}" 0 end${__FileDatedNFUID}
${AddItemDated} "$OUTDIR\${item}"
end${__FileDatedNFUID}:
!undef __FileDatedNFUID
!macroend
!define FileDatedNF "!insertmacro __FileDatedNF"

; If not defined, we use this default macro.  It copies the jss file, then tries to copy every other kind of script file if it exists.
!ifmacrondef JAWSInstallScriptItems
!macro JAWSInstallScriptItems
${FileDated} "${JAWSSrcDir}" "${ScriptApp}.jss"
${FileDatedNF} "${JAWSSrcDir}" "${ScriptApp}.jbf"
${FileDatedNF} "${JAWSSrcDir}" "${ScriptApp}.jbs"
${FileDatedNF} "${JAWSSrcDir}" "${ScriptApp}.jbt"
${FileDatedNF} "${JAWSSrcDir}" "${ScriptApp}.jcf"
${FileDatedNF} "${JAWSSrcDir}" "${ScriptApp}.jdf"
${FileDatedNF} "${JAWSSrcDir}" "${ScriptApp}.jfd"
${FileDatedNF} "${JAWSSrcDir}" "${ScriptApp}.jff"
${FileDatedNF} "${JAWSSrcDir}" "${ScriptApp}.jgf"
${FileDatedNF} "${JAWSSrcDir}" "${ScriptApp}.jkm"
${FileDatedNF} "${JAWSSrcDir}" "${ScriptApp}.jsd"
${FileDatedNF} "${JAWSSrcDir}" "${ScriptApp}.jsh"
${FileDatedNF} "${JAWSSrcDir}" "${ScriptApp}.jsm"
${FileDatedNF} "${JAWSSrcDir}" "${ScriptApp}.qs"
${FileDatedNF} "${JAWSSrcDir}" "${ScriptApp}.qsm"
!macroend ; JAWSInstallScriptItems
!EndIf ;macro JAWSInstallScriptItems not defined


;-----
; These are section indexes of sections whose state we need to know to write the installation summary.  They are set by code in macro JAWSAfterImstallSections and used in function JAWSInstConfirmPre.
var JAWSSecInstSrc
var JAWSSecUninstaller
var JAWSSecInstDirFiles

;-----
;Now deals with version/language pairs.
Var INSTALLEDJAWSVERSIONS ;separated by |
var INSTALLEDJAWSVERSIONCOUNT
var SELECTEDJAWSVERSIONS
var SELECTEDJAWSVERSIONCOUNT
var JAWSSHELLCONTEXT ; value for SetShellVarContext-- current or all, default set to "current" in .OnInit

;-----

; Multiline edit box for nsdialogs
!define __NSD_TextMultiline_CLASS EDIT
!define __NSD_TextMultiline_STYLE ${DEFAULT_STYLES}|${WS_TABSTOP}|${ES_MULTILINE}
!define __NSD_TextMultiline_EXSTYLE ${WS_EX_WINDOWEDGE}|${WS_EX_CLIENTEDGE}
!insertmacro __NSD_DefineControl TextMultiline

;-----

;Remove a style from a control.
!macro _NSD_RemoveStyle CONTROL STYLE
	Push $0
push $1

	System::Call "user32::GetWindowLong(i ${CONTROL}, i ${GWL_STYLE}) i .r0"
	intop $1 ${STYLE} ~
	intop $0 $0 & $1
	System::Call "user32::SetWindowLong(i ${CONTROL}, i ${GWL_STYLE}, i $0)"

	pop $1
	Pop $0

!macroend ;_NSD_RemoveStyle

!define NSD_RemoveStyle "!insertmacro _NSD_RemoveStyle"

;-----
!macro _ForJawsVersions
; Execute a block of code for each selected JAWS version.
; Place before the code to be executed for each selected JAWS version.
; Follow the code block with _ForJawsVersionsEnd.  These macros can be used more than once but they cannot be nested.
;In the code block $0 contains the current version and $R0 contains the 0-based index of this version in $SELECTEDJAWSVERSIONS.  The code block must protect $R0 since it is the loop index.
!ifndef _ForJawsVersionsCounter
!define _ForJawsVersionsCounter 0
!else
!define /math _ForJawsVersionsCounterTemp ${_ForJawsVersionsCounter} + 1
!undef _ForJawsVersionsCounter
!define _ForJawsVersionsCounter ${_ForJawsVersionsCounterTemp}
!undef _ForJawsVersionsCounterTemp
!endif
push $0
push $R0
strcpy $R0 0
_ForJawsVersionsLoop${_ForJawsVersionsCounter}:
${StrTok} $0 "$SELECTEDJAWSVERSIONS" "|" $R0 0
Push $R0 ; protect loop index
;DetailPrint "ForJawsVersions: running code block with $$R0 = $R0" ; debug
!macroend ; _ForJawsVersions
!define ForJawsVersions "!insertmacro _ForJawsVersions"

!macro _ForJawsversionsEnd
; Place after the code that installs scripts to a version.
Pop $R0 ;restore loop index
;DetailPrint "ForJawsVersionsEnd: before incrementing, $$R0 = $R0" ; debug
intop $R0 $R0 + 1
intcmp $R0 $SELECTEDJAWSVERSIONCOUNT 0 _ForJawsVersionsLoop${_ForJawsVersionsCounter} 0
pop $R0
pop $0
!macroend
!define ForJawsVersionsEnd "!insertmacro _ForJawsVersionsEnd"



;-----
;Pages
!macro JAWSWelcomePage
!define MUI_WELCOMEPAGE_TITLE "$(WelcomePageTitle)"

!ifdef LegalCopyright
!define MUI_WELCOMEPAGE_TEXT "$(WelcomeTextCopyright)"
!else
!define MUI_WELCOMEPAGE_TEXT "$(WelcomeTextNoCopyright)"
!EndIf
!Insertmacro Mui_Page_Welcome
!macroend ; JAWSWelcomePage

!macro JAWSComponentsPage
;The order of the insstype commands is important.
insttype "Full"
insttype "JustScripts"
;insttype /NOCUSTOM
insttype /COMPONENTSONLYONCUSTOM
!define INST_FULL 1
!define INST_JUSTSCRIPTS 2
;!define INST_CUSTOM 33
!define INST_CUSTOM 32

; Displays 3 lines of about 98 chars.
!define MUI_COMPONENTSPAGE_TEXT_TOP "$(InstTypeFullMsg)"
;!define MUI_COMPONENTSPAGE_TEXT_COMPLIST text
;!define MUI_COMPONENTSPAGE_TEXT_INSTTYPE text
;!define MUI_COMPONENTSPAGE_TEXT_DESCRIPTION_TITLE text
;!define MUI_COMPONENTSPAGE_TEXT_DESCRIPTION_INFO text ;Text to display inside the description box when no section is selected.
!define MUI_PAGE_CUSTOMFUNCTION_LEAVE ComponentsPageLeave
!insertmacro mui_page_Components

function ComponentsPageLeave
getcurinsttype $0
intop $0 $0 + 1
;messagebox MB_OK "ComponentsPageLeave: insttype = $0, justscripts = ${INST_JUSTSCRIPTS}" ; debug
;sectiongetflags $JAWSSecInstSrc $1 ; debug
;messagebox MB_OK "ComponentsPageLeave: SecInstSrc flags = $1" ; debug
intcmp $0 ${INST_JUSTSCRIPTS} end +1 +1
;sectiongetflags $JAWSSecUninstaller $1 ; debug
;messagebox MB_OK "ComponentsPageLeave: before selecting insttype = $0, section flags = $1" ; debug

!insertmacro SelectSection $JAWSSecUninstaller
!insertmacro SelectSection $JAWSSecInstDirFiles
;sectiongetflags $JAWSSecUninstaller $1 ; debug
;messagebox MB_OK "ComponentsPageLeave: after selecting section flags = $1" ; debug
end:
functionend
!macroend ;JAWSComponentsPage

;-----

; List view control

;(Windows) Messages, styles, and structs for handling a list view.
;!define LVM_FIRST           0x1000
!define /math LVM_GETITEMCOUNT ${LVM_FIRST} + 4
!define /math LVM_GETITEMTEXTA ${LVM_FIRST} + 45
!define /math LVM_GETITEMTEXTW ${LVM_FIRST} + 115
!define LVM_GETUNICODEFORMAT 0x2006
!define /math LVM_GETITEMSTATE ${LVM_FIRST} + 44
!define /math LVM_SETITEMSTATE ${LVM_FIRST} + 43
!define /math LVM_GETITEMA ${LVM_FIRST} + 5
!define /math LVM_GETITEMW ${LVM_FIRST} + 75
!define /math LVM_SETITEMA ${LVM_FIRST} + 6
!define /math LVM_INSERTITEMA ${LVM_FIRST} + 7
!define /math LVM_INSERTITEMW ${LVM_FIRST} + 77
!define /math LVM_INSERTCOLUMNA ${LVM_FIRST} + 27
!define /math LVM_INSERTCOLUMNW ${LVM_FIRST} + 97
!define /math LVM_GETEXTENDEDLISTVIEWSTYLE ${LVM_FIRST} + 55
!define /math LVM_SETEXTENDEDLISTVIEWSTYLE ${LVM_FIRST} + 54 ; wparam is mask, lparam is style, returns old style


;!define LVS_DEFAULT 0x0000000D ; Default control style  LVS_SHOWSELALWAYS + LVS_SINGLESEL + LVS_REPORT
; Itt looks like LVS_REPORT causes the items to disappear from the screen (but JAWS can still read them).
!define LVS_DEFAULT 0x0000000 ; Default control style  
!define LVS_LIST 0x0003 ; This style specifies list view
!define LVS_NOCOLUMNHEADER 0x4000 ; Column headers are not displayed in report view
;!define LVS_REPORT 0x0001 ; This style specifies report view
!define LVS_EX_CHECKBOXES 0x00000004 ; Enables check boxes for items

;This is similar to the code that defines a control in nsdialogs.nsh.
!define __NSD_ListView_CLASS SysListView32
;!define __NSD_ListView_STYLE ${DEFAULT_STYLES}|${WS_TABSTOP}|${WS_VSCROLL}|${LVS_DEFAULT}|${LVS_NOCOLUMNHEADER}
!define __NSD_ListView_STYLE ${DEFAULT_STYLES}|${WS_TABSTOP}|${WS_VSCROLL}|${LVS_DEFAULT}|${LVS_LIST} ; debug
!define __NSD_ListView_EXSTYLE ${WS_EX_WINDOWEDGE}|${WS_EX_CLIENTEDGE}|${LVS_EX_CHECKBOXES}
;!define __NSD_ListView_EXSTYLE 0 ; debug
;!define __NSD_ListView_EXSTYLE ${LVS_EX_CHECKBOXES} ; debug
; This is an "internal" macro from nsdialogs.nsh.
!insertmacro __NSD_DefineControl ListView
; values for LVITEM struct mask field
!define LVIF_TEXT 0x00000001
!define LVIF_STATE 0x00000008

/* I got these struct definitions from AutoIt v3.3.8.1 structureconstants.au3
$tagLVITEM = "uint Mask;int Item;int SubItem;uint State;uint StateMask;ptr Text;int TextMax;int Image;lparam Param;" & _
		"int Indent;int GroupID;uint Columns;ptr pColumns;ptr piColFmt;int iGroup"
*/

; You can't use /* */ in the definition because the params for system::call is a NSIS string, but this is a good reference.
;!define tagLVITEM "u /*Mask*/, i /*Item*/, i /*SubItem*/, u /*State*/, u /*StateMask*/, t /*Text*/, i /*TextMax*/, i /*Image*/, i /*Param*/, i /*Indent*/, i /*GroupID*/, u /*Columns*/, i /*pColumns*/, i /*piColFmt*/, i /*iGroup*/"
!define LVIS_IMAGESTATEMASK 0xf000
!define LVIS_IMAGESTATECHECKED 0x2000 ; item is checked
!define LVIS_IMAGESTATEUNCHECKED 0x1000 ; item is unchecked

/*
!define tagLVCOLUMN "uint Mask;int Fmt;int CX;ptr Text;int TextMax;int SubItem;int Image;int Order;int cxMin;int cxDefault;int cxIdeal"
*/

!define LVCF_FMT 0x0001
!define LVCF_TEXT 0x0004
!define LVCF_WIDTH 0x0002

; i is integers, I think t is a pointer to a text string.
!define tagLVCOLUMN "i, i, i, t, i, i, i, i, i, i, i"

; debug function
function DisplayLVItem
; Display the LVITEM struct for item $0 in $JAWSLV.  For debugging.
;store manipulates the stack: p# pushes $#, P# pushes $R#, r# pops into $#, R# pops into $R#.
;This pushes $1-7 and $R0-2.
system::store "p1p2p3p4p5p6p7P0P1P2"
;This allocates a struct.  A register without a . stores that register into the struct, .r# reads into $#, .R# reads into $R#, result address to $4
system::call "*(i -1, i $0, i .r2, i .r3, i 0xffff, t .r5, i .r6, i, i, i, i, i .r7, i, i, i) i .r4"
SendMessage $JAWSLV ${LVM_GETITEMA} 0 $4
;Read from the struct.
system::call "*$4(i -1, i .r1, i .r2, i .r3, i 0xffff, t .r5, i .r6, i, i, i, i, i .r7, i, i, i)"
intfmt $R1 "%x" $3
;intfmt $R2 "%x" $4
strcpy $R0 "item $1, subitem $2, state 0x$R1, text $5, len $6, columns $7"
messagebox MB_OK "LVItem: $R0"
system::free $4
;Pop registers stored at start.
system::store "R2R1R0r7r6r5r4r3r2r1"
functionend
!macro _DisplayLVItem item
push $0
strcpy $0 ${item}
call DisplayLVItem
pop $0
!macroend
!define DisplayLVItem "!insertmacro _DisplayLVItem"

; Adapted from AutoIt include file winapi.au3.
!macro GetStockObject obj
; return is on stack.
system::call "gdi32::GetStockObject(${obj}) i .s"
!macroend

; Adapted from AutoIt include file guilistview.au3.
!define GUI_DEFAULT_FONT 17
!macro _LVSetFont font
push $0
!insertmacro GetStockObject ${font}
;Do we need to pop to $0?
;$0 is WPARAM, 1 is LPARAM, no return.
SendMessage $JAWSLV ${WM_SETFONT} $0 1
pop $0
!macroend
!define LVSetFont "!insertmacro _LVSetFont"

!macro _NSD_GetStyle CONTROL
; Window style of CONTROL, returned on stack.
; GWL_STYLE is defined in nsdialogs.nsh.
	System::Call "user32::GetWindowLong(i ${CONTROL}, i ${GWL_STYLE}) i .s"
!macroend
!define NSD_GetStyle "!insertmacro _NSD_GetStyle"

!macro LVGetExStyle
; Returns extended style on stack.
push $0
SendMessage $JAWSLV ${LVM_GETEXTENDEDLISTVIEWSTYLE} 0 0 $0
;Result in $0.
exch $0
!macroend

function LVInsertItem
; $0 - item number
; $1 - item text
; Assumes the list view handle is in variable $JAWSLV.
push $R0
push $R1
push $R2
strlen $R0 $1 ; length of item text
intop $R0 $R0 + 1 ; for terminating null in case we need it.
intop $R0 $R0 * 2 ; unicode?
;Allocate a struct, its address placed in $R1.
;u doesn't seem to allocate memory, changed to i.
system::call "*(i ${LVIF_TEXT}, i r0, i 0, i, i, t r1, i R0, i, i, i, i, i, i, i, i) i .R1"
SendMessage $JAWSLV ${LVM_INSERTITEMA} 0 $R1 $R2 ; result in $R2
intcmp $R2 -1 0 +2 +2
; returned -1, error
messagebox MB_OK "LVInsertItem: LVM_INSERTITEMA failed for item $0" ; debug
system::free $R1
;messagebox MB_OK "added item $R2" ; debug
pop $R2
pop $R1
pop $R0
functionend ; LVInsertItem

!macro _LVAddItem text
; Add an item to the end of the list view.  Does not handle subitems.
; text - text of item
;The list view handle is in variable $JAWSLV.

push $0
push $1
strcpy $0 9999 ; item number, larger than current number of items
strcpy $1 "${text}"
call LvInsertItem
pop $1
pop $0
!macroend
!define LVAddItem "!insertmacro _LVAddItem"

function LVIsItemChecked
; $0 - (in) item index
; $1 - (out) true if checked
;The list view handle is in variable $JAWSLV.
push $R0
; set up the LVitem struct.
;system::call "*(u ${LVIF_STATE}, i $0, i 0, u, u 0xffff, t, i, i, i, i, i, u, i, i,i) i .R0"
SendMessage $JAWSLV ${LVM_GETITEMSTATE} $0 ${LVIS_IMAGESTATEMASK} $1 ; result in $1
;push $R0 ; debug
;intfmt $R0 "%x" $1 ; debug
;messagebox MB_OK "LVIsItemChecked: item state = 0x$R0" ; debug
;pop $R0 ; debug
intop $1 $1 & ${LVIS_IMAGESTATECHECKED} ; mask all but desired bit
;system::free $R0
pop $R0
;messagebox MB_OK "LVIsItemChecked: returning $1" ; debug
functionend

function LVCheckItem
; $0 - item index
; $1 - 0 = unchecked, else checked.
;10/31/15 Result of SendMessage ${LVM_SETITEMSTATE} in $R3.  Is this intended or a bug?
push $2
push $R0
strcpy $2 ${LVIS_IMAGESTATECHECKED}
intcmp $1 0 +1 +2 +2
strcpy $2 ${LVIS_IMAGESTATEUNCHECKED} ; unchecked
;Allocate struct, ptr to it in $R0.
; We probably don't need to set LVIF_STATE or item.
system::call "*(i ${LVIF_STATE}, i r0, i 0, i r2, i ${LVIS_IMAGESTATEMASK}, t, i, i, i, i, i, i, i, i, i) i .R0"
;messagebox MB_OK "LVCheckItem: setting item $0 to $2 in $JAWSLV" ; debug
SendMessage $JAWSLV ${LVM_SETITEMSTATE} $0 $R0 $R3 ;result in $R3
system::free $R0
;SendMessage $JAWSLV ${LVM_GETITEMSTATE} $0 ${LVIS_IMAGESTATEMASK} $R4 ; debug
;intfmt $R4 "%x" $R4 ; debug
;messagebox MB_OK "GetItemState returned 0x$R4, SetItemState returned $R3" ; debug
pop $R0
pop $2
functionend ;LVCheckItem

!macro _LVCheckItem item checked
push $0
push $1
strcpy $0 ${item}
strcpy $1 ${checked}
call LVCheckItem
pop $1
pop $0
!macroend
!define LVCheckItem "!insertmacro _LVCheckItem"

; Adapted from NSDialogs ${NSD_LB_GetSelection, has not been used.
!macro __NSD_LV_GetSelection CONTROL VAR

	SendMessage ${CONTROL} ${LVM_GETCURSEL} 0 0 ${VAR}
	System::Call 'user32::SendMessage(i ${CONTROL}, i ${LVM_GETITEMTEXT}, i ${VAR}, t .s)' ;result seems to be passed back in LPARAM, returned on stack
	Pop ${VAR} ; placed in ${VAR}

!macroend ;__NSD_LV_GetSelection

!define NSD_LV_GetSelection `!insertmacro __NSD_LV_GetSelection`

;-----

!macro JAWSSelectVersionsPage
page custom DisplayJawsList DisplayJawsListLeave ;Select Jaws version page
function MarkSelectedVersions
; Causes the list view items for the JAWS versions that have been previously selected to be checked.  This is to restore the selections if the user comes back to the JAWS versions page.
intcmp $SELECTEDJAWSVERSIONCOUNT 0 0 +2 +2
return ; return if no selected versions
;messagebox MB_OK "Enter MarkSelectedVersions" ; debug
push $0 ; index in $INSTALLEDJAWSVERSIONS
push $1 ; index in $SELECTEDJAWSVERSIONS
push $2 ; value we're looking for
push $3 ; value we're examining
strcpy $0 0
strcpy $1 0
${StrTok} $2 "$SELECTEDJAWSVERSIONS" "|" $1 0 ; index of first checked version in $2
strcpy $3 ""
loop:
intcmp $0 $INSTALLEDJAWSVERSIONCOUNT done 0 done ;jump out if index >= count
intcmp $1 $SELECTEDJAWSVERSIONCOUNT done 0 done
${StrTok} $3 "$INSTALLEDJAWSVERSIONS" "|" $0 0
;messagebox MB_OK "MarkSelectedVersions: checking item $0 $3 against $1 $2" ; debug
${If} $2 == $3
${LVCheckItem} $0 1
intop $1 $1 + 1 ; inc $1
${StrTok} $2 "$SELECTEDJAWSVERSIONS" "|" $1 0 ;next value we're looking for
${EndIf}
intop $0 $0 + 1 ;index for installed version
goto loop
done:
pop $3
pop $2
pop $1
pop $0
functionend ; MarkSelectedVersions

;Create installed JAWS versions page.
Function DisplayJawsList
  ;If no versions installed writes message and aborts (what is aborted? the page?).
;!InsertMacro SectionFlagIsSet ${SecJAWS} ${SF_SELECTED} DoJawsPage ""
goto DoJawsPage ; to debug, uncomment section selected test above.
DetailPrint "DisplayJawsList: install JAWS section not selected" ; debug
abort ; JAWS script install section not selected
  DoJawsPage:
    ;MessageBox MB_OK "Enter DisplayJawsList" ; debug
; .oninit has determined that there is at least 1 JAWS version installed, but we'll check here so maybe we can eliminate checking in .oninit.
; I use ${If} here so that I can include a debug message which can later be commented out without rewriting the code.
call GetJAWSVersions
pop $INSTALLEDJAWSVERSIONS
pop $INSTALLEDJAWSVERSIONCOUNT
DetailPrint "DisplayJawsList: found  $INSTALLEDJAWSVERSIONCOUNT versions: $INSTALLEDJAWSVERSIONS" ; debug
;messagebox MB_OK "DisplayJawsList: Found $INSTALLEDJAWSVERSIONCOUNT installed JAWS versions compatible with this application: $INSTALLEDJAWSVERSIONS" ; debug
${If} $INSTALLEDJAWSVERSIONCOUNT = 0
DetailPrint "DisplayJawsList: JAWS is not installed, skipping JAWS versions page" ; debug
messagebox MB_OK "DisplayJawsList: JAWS is not installed, skipping JAWS versions page" ; debug
abort ; no JAWS
${EndIf}

;If we allow install for all users then we need to show the JAWS Versions page even if there is only 1 version installed.
!ifndef JAWSALLOWALLUSERS
${If} $INSTALLEDJAWSVERSIONCOUNT = 1
DetailPrint "DisplayJawsList: 1 JAWS version/lang, skipping JAWS versions page" ; debug
;MessageBox MB_OK "DisplayJawsList: 1 JAWS version $INSTALLEDJAWSVERSIONS, skipping JAWS versions page" /SD IDOK ; debug
strcpy $SELECTEDJAWSVERSIONS $INSTALLEDJAWSVERSIONS
strcpy $SELECTEDJAWSVERSIONCOUNT $INSTALLEDJAWSVERSIONCOUNT
;quit ; debug
abort ; only 1 JAWS version
${EndIf} ; if a version installed
!endif ; if not allow install to all users
nsDialogs::Create 1018
pop $JAWSDLG
;The versions do not include those installed that are outside JAWSMINVRSION and JAWSMAXVERSION.
${NSD_CreateLabel} 0 0 100% 10u "$(SelectJawsVersions)"
Pop $0
;math::script 'r0 = ${__NSD_ListView_EXSTYLE}' ; debug
;IntFmt $0 "%x" $0 ; debug
;messagebox MB_OK "Before creating list view ex style = 0x$0, defined is '${__NSD_ListView_EXSTYLE}'" ; debug
${NSD_CreateListView} 3u 12u 55u 100u "JAWS Version/Languagess"
Pop $JAWSLV
math::script 'r0 = ${__NSD_ListView_EXSTYLE}'
SendMessage $JAWSLV ${LVM_SetExtendedListViewStyle} 0 $0 $1
;IntFmt $0 "%x" $0 ; debug
;messagebox MB_OK "After sending LVM_SetExtendedListViewStyle, old ex style = 0x$0" ; debug
${LVSetFont} ${GUI_DEFAULT_FONT}

; Set column header
/*
; Doesn't work, don't know why.
push $R0
push $R1
;Allocate struct, ptr to it in $R0
system::call "*(${tagLVCOLUMN}) (${LVCF_TEXT}, , , t "Version", 7) i .$R0"
SendMessage $JAWSLV ${LVM_INSERTCOLUMNA} 0 $R0 $R1 ;result in $R1
system::free $R0
${If} $R1 = -1
messagebox MB_OK "DisplayJawsList: unable to insert column, returned $R1"
${EndIf}
pop $R1
pop $R0
*/ ; column header
push $0
push $1
push $2
push $3
push $4
StrCpy $3 "${ScriptDefaultLang}|${JawsScriptLangs}" ; all the supported languages.
;MessageBox MB_OK "DisplayJawsList: before loop Supported languages ($$3) = $3" ; debug
strcpy $0 0
loop:
  intcmp $0 $INSTALLEDJAWSVERSIONCOUNT done 0 done ;jump out if >= limit
  ${strtok} $1 $INSTALLEDJAWSVERSIONS "|" $0 0 ;get the version/language pair
  ;MessageBox MB_OK "DisplayJawsList: got $1 from InstalledJawsVersions" ; debug
  push $0
  StrCpy $0 $1
  ;MessageBox MB_OK "DisplayJawsList: before GetVerLang $$1=$1" ; debug
  call GetVerLang
  exch
  pop $2 ;version, we don't need it
  pop $2 ;lang dir
  pop $0 ; restore the loop counter
  ;MessageBox MB_OK "DisplayJawsList: got language $2, $$1=$1" ; debug
  ${StrContainsTok} $4 "$3" "$2" "|"
  ${If} $4 == 0
    StrCpy $1 "$1*"
  ${EndIf}
  ;MessageBox MB_OK "DisplayJawsList: adding $1 to list view" ; debug
  ${LVAddItem} "$1"
  intop $0 $0 + 1
goto loop
done:
;messagebox MB_OK "DisplayJawsList: added $0 of $INSTALLEDJAWSVERSIONCOUNT items" ; debug
pop $4
pop $3
pop $2
pop $1
pop $0


!ifdef JAWSALLOWALLUSERS
${If} $INSTALLEDJAWSVERSIONCOUNT = 1
${LVCheckItem} 0 1
${EndIf}
; Install for group box
${NSD_CreateGroupBox} 55u 12u 60u 40u "Install for"
pop $JAWSGB
${NSD_CreateRadioButton} 60u 22u 55u 10u "&Current user"
pop $JAWSRB1
${NSD_AddStyle} $JAWSRB1 ${BS_AUTORADIOBUTTON}
${NSD_CreateRadioButton} 60u 35u 55u 10u "&All users"
pop $JAWSRB2
${NSD_AddStyle} $JAWSRB2 ${BS_AUTORADIOBUTTON}
${If} $JAWSSHELLCONTEXT == "current"
${NSD_Check} $JAWSRB1
;Initially remove the unselected button from the tabbing order.
${NSD_RemoveStyle} $JAWSRB2 ${WS_TABSTOP}
${Else}
${NSD_Check} $JAWSRB2
;Initially remove the unselected button from the tabbing order.
${NSD_RemoveStyle} $JAWSRB1 ${WS_TABSTOP}
${EndIf} ; else all users
;Set initial focus
${If} $INSTALLEDJAWSVERSIONCOUNT = 1
  ${LVCheckItem} 0 1
  ${If} $JAWSSHELLCONTEXT == "all"
    ${NSD_SetFocus} $JAWSRB2
  ${Else}
    ${NSD_SetFocus} $JAWSRB1
  ${EndIf} ; else all users
${Else}
  ; more than one version
  ${NSD_SETFOCUS} $JAWSLV
${EndIf} ; else more than one version

!else
;Don't allow all users.  We won't be here if only 1 installed version.
${NSD_SETFOCUS} $JAWSLV
!endif ; JAWSALLOWALLUSERS

; In case we come back to this page check the previously selected versions.
call MarkSelectedVersions
nsDialogs::Show
FunctionEnd ; DisplayJawsList

Function DisplayJawsListLeave
; On exit, var $SELECTEDJAWSVERSIONS contains the list of selected version/language pairs separated by | and $SELECTEDJAWSVERSIONCOUNT contains the number of version/language pairs selected.
push $0
push $1
push $3
/*
${NSD_GetStyle} $JAWSLV ; debug
pop $0 ; debug
IntFmt $1 "%x" $0 ; debug
!insertmacro LVGetExStyle ; debug
pop $0 ; debug
IntFmt $3 "%x" $0 ; debug
;messagebox MB_OK "Enter DisplayJawsListLeave with $INSTALLEDJAWSVERSIONCOUNT versions installed$\r$\nList view style = 0x$1, extended style = 0x$3." ; debug
*/
;messagebox MB_OK "Enter DisplayJawsListLeave with $INSTALLEDJAWSVERSIONCOUNT versions installed"

!ifdef JAWSALLOWALLUSERS
; Get the selected context.
${NSD_GetState} $JAWSRB1 $0
  ${If} $0 == ${BST_CHECKED}
  strcpy $JAWSSHELLCONTEXT "current"
  SetShellVarContext current
${Else}
  strcpy $JAWSSHELLCONTEXT "all"
  SetShellVarContext all
${EndIf}
;messagebox MB_OK "Context is $JAWSSHELLCONTEXT" ; debug
!EndIf ;if JAWSALLOWALLUSERS
; Get the selected JAWS version/language pairs.
strcpy $SELECTEDJAWSVERSIONS ""
strcpy $SELECTEDJAWSVERSIONCOUNT 0
strcpy $0 0
loop: ;over installed version/language pairs
intcmp $0 $INSTALLEDJAWSVERSIONCOUNT done 0 done ;jump out if >= limit
;${DisplayLVItem} $0 ; debug
call LVIsItemChecked
; $1 is nonzero if item $0 is checked
;messagebox MB_OK "after LVIsItemChecked $$1 = $1" ; debug
intcmp $1 0 skip 0 0 ;skip if =0-- not checked

;messagebox MB_OK "item $0 is checked" ; debug
${strtok} $3 $INSTALLEDJAWSVERSIONS "|" $0 0
; CheckScriptExists expects version string in $0.
push $0
strcpy $0 $3
call CheckScriptExists
pop $0
; $1 = 0 if script does not exist or user chooses to overwrite.
;MessageBox MB_OK "DisplayJawsListLeave: CheckScriptExists returned $1" ; debug
${If} $1 = 0
  strcpy $SELECTEDJAWSVERSIONS "$SELECTEDJAWSVERSIONS$3|"
  intop $SELECTEDJAWSVERSIONCOUNT $SELECTEDJAWSVERSIONCOUNT + 1
${Else}
  ${LVCheckItem} $0 0 ; uncheck
${EndIf} ; else $1 != 1
skip:
intop $0 $0 + 1
goto loop

done: ; we have finished searching for selected JAWS version/language pairs.
; If any were checked, remove final separator.
strcmp $SELECTEDJAWSVERSIONS "" +2
strcpy $SELECTEDJAWSVERSIONS $SELECTEDJAWSVERSIONS -1 ; remove trailing |
DetailPrint "DisplayJawsListLeave: found  $SELECTEDJAWSVERSIONCOUNT versions: $SELECTEDJAWSVERSIONS" ; debug
;messagebox MB_OK "DisplayJawsListLeave: found  $SELECTEDJAWSVERSIONCOUNT versions: $SELECTEDJAWSVERSIONS" ; debug
${If} $SELECTEDJAWSVERSIONCOUNT = 0
  messagebox MB_OK "$(NoVersionSelected)"
  abort
${EndIf} ; if no versions
pop $3
pop $1
pop $0
;quit ; debug
functionend ; DisplayJawsListLeave
!macroend ;JAWSSelectVersionsPage

!macro JAWSDirectoryPage
PageEx Directory
PageCallbacks DirPagePre "" DirPageLeave
DirText "$(DirPageText)"
PageExEnd

function DirPagePre
${Unless} ${SectionIsSelected} $JAWSSecUninstaller
  Abort ; skip page if it is not full installation.
${EndUnless}
functionend

function DirPageLeave
IfFileExists $INSTDIR +1 next
  ${GetFileAttributes} $INSTDIR DIRECTORY $0
  intcmp $0 1 +1 +3
    MessageBox MB_YESNO "$(InstallFolderExists)" IDYES next
    abort
  MessageBox MB_OK "$(InstDirNotFolder)" /SD IDOK
  abort
next:
FunctionEnd
!macroend ;JAWSDirectoryPage

!macro JAWSInstConfirmPage
page custom PageInstConfirmPre

!ifndef StrRepIncluded
${StrRep}
!EndIf

function PageInstConfirmPre
!insertmacro MUI_HEADER_TEXT "$(InstConfirmHdr)" "$(InstConfirmText)"
${StrRep} $1 "$SELECTEDJAWSVERSIONS" "|" ", "

;!ifdef JAWSALLOWALLUSERS
; These messages (added to $2) need to have a trailing space.
${If} $JAWSSHELLCONTEXT == "current"
  strcpy $2 "$(InstConfirmCurrentUser) "
${Else}
  strcpy $2 "$(InstConfirmAllUsers) "
${EndIf}
;!Else
;strcpy $2 "$(InstConfirmCurrentUser) "
;!EndIf

;$2 contains the trailing space if nonempty.
strcpy $0 "$(InstConfirmVersions)"
;See if any of the selected JAWS versions contain files for this app.
strcpy $1 "" ;versions containing files
${ForJawsVersions}
  ;$0 contains current version, $R0 contains index.
  call GetJawsScriptDir
  pop $2
  strcpy $2 "$2\${ScriptApp}.*"
  ${If} ${FileExists} $2
    strcpy $1 "$1$0, "
  ${EndIf} ; files exist
${ForJawsVersionsEnd}
${If} $1 != ""
  ; Remove final comma and space.
  strcpy $1 $1 -2
  strcpy $0 "$(InstConfirmHaveFiles)"
${EndIf} ; if versions

;getcurinsttype $2 ; debug
;messagebox MB_OK "PageInstConfirmPRE: inst type $2" ; debug
${If} ${SectionIsSelected} $JAWSSecUninstaller
  strcpy $0 "$(InstConfirmUninstAddRemovePrograms)"
  ${If} ${FileExists} "$INSTDIR\*.*"
    strcpy $0 "$(InstConfirmExistingInstall)"
  ${EndIf} ; $INSTDIR exists
  ${If} ${SectionIsSelected} $JAWSSecInstSrc ; SecInstSrc
    strcpy $0 "$(InstConfirmInstallerSrc)"
  ${EndIf} ; installer source
${Else}
  strcpy $0 "$(InstConfirmNotInstalled)"
${EndIf} ; else uninstaller section not selected


nsDialogs::create 1018
pop $2

${NSD_CreateTextMultiline} 0u 0u 100% 100% "$0"
pop $3
${NSD_AddStyle} $3 ${ES_READONLY}

${NSD_SetFocus} $3
nsDialogs::show
functionend
!macroend ;JAWSInstConfirmPage

!macro JAWSInstallScriptsSectionCode
; Insert this inside the section that installs the scripts.
; Assumes setOverWrite is set.
; Must be inserted before function JawsInstallVersion.
GetCurInstType $0
IntOp $0 $0 + 1 ;make it the same as for SectionIn
${If} $0 <> ${INST_JUSTSCRIPTS}
  !insertmacro JAWSLOG_OPENINSTALL
${EndIf} ;logging
${ForJawsVersions}
  ; $0 contains the version/lang pair string, $R0 contains the index into $SELECTEDJAWSVERSIONS.
  call JawsInstallVersion
${ForJawsVersionsEnd}
GetCurInstType $0
IntOp $0 $0 + 1 ;make it the same as for SectionIn
${If} $0 <> ${INST_JUSTSCRIPTS}
  !insertmacro JAWSLOG_CLOSEINSTALL
${EndIf} ;logging
!macroend

!macro JAWSAfterInstallSections
;Insert this after your last installer section.
function JAWSOnInit
;To be called from .OnInit.  Quits if JAWS is not installed.
strCpy $0 0 ; index into registry keys
EnumRegkey $1 hklm "software\Freedom Scientific\Jaws" $0
${If} $1 == ""
  MessageBox MB_ICONINFORMATION|MB_OK "$(JawsNotInstalled)" /SD IDOK
  quit
${EndIf} ; if JAWS not installed

functionend ;JAWSOnInit

Function JAWSOnInstSuccess
IfFileExists ${TempFile} 0 +2
delete ${TempFile}
SetAutoClose false ; debug
FunctionEnd ;JAWSOnInstSuccess

function GetSecIDs
; Places the section index of the Get Installer Source and the SecUninstaller sections in variables.  This is because SecInstSrc is not defined before the code for PageInstConfirmPre that references them.
strcpy $JAWSSecInstSrc ${SecInstSrc}
strcpy $JAWSSecUninstaller ${SecUninstaller}
strcpy $JAWSSecInstDirFiles ${SecInstDirFiles}
;messagebox MB_OK "GetSecIDs:$$JAWSSecUninstaller = $JAWSSecUninstaller, $$JAWSSecInstSrc = $JAWSSecInstSrc" ; debug 
functionend
!macroend ;JAWSAfterInstallSections

function CheckScriptExists
; See if there are scripts for this app installed in the target dir, if so ask user if they should be overwritten.
; $0 string containing JAWS version to check.
; Returns 1 in $1 if scripts not present or user says they can be overwritten, else 0.
push $2
strcpy $1 0 ; return value
;Entry: $0 = version string like "6.0".
call GetJAWSScriptDir
pop $2
; $2 = full script destination path.
;StrCpy $2 "${JAWSSCRIPTROOT}\$0\${ScriptDir}"
;StrCpy $JAWSPROGDIR "${JAWSPROGROOT}\$0"
;StrCpy $JAWSSCRIPTDEST $2
;messagebox MB_OK "CheckScriptExists: checking $2\${ScriptApp}.*" ; debug
IfFileExists "$2\${ScriptApp}.*" 0 end
MessageBox MB_YESNO "$(OverwriteScriptsQuery)" IDYES +2
strcpy $1 1 ; no
End:
pop $2
;!ifdef JAWSDEBUG ; debug
;strcpy $1 1 ; debug
;!endif ; debug
;messagebox MB_OK "CheckScriptExists: returning $1" ; debug
FunctionEnd

function GetJawsScriptDir
; Get the JAWS script directory based on its version and language.  If there is just a version use the default lang dir.  (This is intended for transitioning.)
; $0 - string containing JAWS version number or version-lang pair.
; Returns script directory on stack.
; Does logicLib support the >= test for strings? yes!
push $2 ;used for return value
push $1 ; used for version
push $3 ;used for lang dir
;messagebox MB_OK "GetJawsScriptDir: checking version/lang $0" ; debug
call GetVerLang
pop $3 ;lang dir
pop $1 ;version
;MessageBox MB_OK "GetJawsScriptDir: version ($$1) = $1, langdir ($$3) = $3" ; debug
${If} $1 >= "6.0" ;Current selected version is 6.0 or later
strcpy $2 "${JawsDir}\$1\${ScriptDir}\$3" ;get the script location from current user
;messagebox MB_OK "GetJawsScriptDir: $${JawsScriptDir} = ${JawsScriptDir}, returning $2" ; debug
${Else}
;Jaws 5.0 or erlier, the language folder is inside the folder containing the JAWS program, so we'll find the path by reading from the registry.
ReadRegStr $2 HKLM "SOFTWARE\Freedom Scientific\Jaws\$1" "Target"
strcpy $2 "$2\${ScriptDir}\$3"
${EndIf}
pop $3
pop $1
exch $2 ; return value
functionend

function GetJawsProgDir
; Get the JAWS program directory based on its version.
; $0 - string containing JAWS version number.
; Returns JAWS program directory on stack.
;If registry key not found uses ${JAWSDefaultProgDir}\$0\.
push $2
ReadRegStr $2 HKLM "SOFTWARE\Freedom Scientific\Jaws\$0" "Target"
  ;StrCpy $2 "" ; test ReadRegStr failure
${If} $2 == ""
  strCpy $2 "${JAWSDefaultProgDir}\$0\"
  ;MessageBox MB_OKCANCEL `GetJawsProgDir: error reading registry key HKLM "SOFTWARE\Freedom Scientific\Jaws\$0" "Target": Using default program dir $2$\r$\nThis is probably okay, but please advise the JAWS script developers.` IDOK +2
    ;abort ; camcel
${EndIf}
exch $2 ; return to TOS, $2 same as before call
functionend


/*
; for debugging
!ifndef StrTok_INCLUDED
${StrTok}
!endif


!macro tstenumjawsversions var root key index
; Resembles enumregkey to test GetJAWSVersions.
strcpy ${var} ""
; compare with number of items in strtok.
intcmp ${index} 6 tstenumskip 0 tstenumskip
${strtok} ${var} "5.0|6.0|9.0|10.0|11.0|12.0" "|" ${index} 0
;intcmp ${index} 3 tstenumskip 0 tstenumskip
;${strtok} ${var} "9.0|10.2|11.0" "|" ${index} 0
tstenumskip:
!macroend
*/

function GetJAWSVersions
; Makes a list of installed JAWS version/language pairs.  If ${JAWSMINVERSION} or ${JAWSMAXVERSION} are defined, versions outside of their limits are excluded.
; return: TOS - string containing list of JAWS version/language pairs separated by |, TOS-1 - number of JAWS versions found.
push $5
push $6
push $R0
push $7
push $8
push $9
;Yes, an odd order, long story, you don't want to know!
push $0
push $1
push $2
push $3
push $4
strCpy $R0 0 ; registry entry index
strcpy $6 0 ; number of JAWS versions found
strcpy $5 "" ; JAWS versions found
loop:
EnumRegkey $7 hklm "software\Freedom Scientific\Jaws" $R0 ;Enumerate the existing version of Jaws
;!insertmacro tstEnumJawsversions $7 hklm "software\Freedom Scientific\Jaws" $R0 ;test Enumerate the existing versions of Jaws
;messagebox MB_OK "GetJawsVersions: got version $7 at index $R0" ; debug
strcmp $7 "" done ; exit loop if after last JAWS version
IntOp $R0 $R0 + 1 ;increase the registry key index by one unit
; Is this registry key a version number?  I have seen "Common" Victor checks for "Registration", and I don't know of any version that doesn't start with a digit.
; We search for the first character of the entry in a string of digits.  If we find it, we know it starts with a digit.  If not, we can skip this entry.
strcpy $8 $7 1 ; copy first character
${StrLoc} $9 "0123456789" $8 ">"
strcmp $9 "" loop ; if "", the character was not found
; character is in "0" through "9"
; Starts with a digit, is a version.

;Is it within min and max version limits?
${If} "${JAWSMINVERSION}" == ""
${OrIf} $7 >= "${JAWSMINVERSION}"
;messagebox MB_OK "passed minversion" ; debug
${If} "${JAWSMAXVERSION}" == ""
${OrIf} $7 <= "${JAWSMAXVERSION}"
  ;messagebox MB_OK "passed minversion" ; debug
  ;Get the languages for this version
  StrCpy $0 $7 ; version
  call GetVersionLangs  ;$1 contains langs separated by |, $2 contains number of langs.
  ;Index of last lang is $2 - 1.
  loop2:
  IntOp $2 $2 - 1
${StrTok} $3  "$1" "|" "$2" "0"
intop $6 $6 + 1 ; increment version/langs count
;Add this version/lang to the Jaws versions we have already found if any
strcpy $5 "$5$7${ScriptVerLangSep}$3|"
IntCmp $2 0 0 0 loop2
${EndIf} ; meets max version conditions
${EndIf} ; meets min version condition
goto loop ;continue checking

done: ; done with loop
strcmp $5 "" +2 ; Did we find any JAWS versions?
strcpy $5 $5 -1 ;yes, remove trailing |
detailprint "GetJAWSVersions: got $6 versions: $5" ; debug
;messagebox MB_OK "GetJAWSVersions: got $6 versions: $5" ; debug
pop $4
pop $3
pop $2
pop $1
pop $0
pop $9
pop $8
pop $7
;messagebox MB_OK "After popping $$7 $$9 = $9, $$8 = $8, $$7 = $7" ; debug
pop $R0
; Put the return values on the stack and restore to the registers their original values.
exch $6
exch
exch $5
; stack contains: versions, version count
functionend

;VAR STACKSIZE ; debug
function JawsInstallVersion
; Installs scripts to a JAWS version/lang.
; $0 - string containing JAWS version/lang pair or version.
; Assumes overwrite is set to on.
; On exit $outDir set to script directory for the version.
; Should we return an error indication if the script did not compile?
;DetailPrint "JawsInstallVersion: on entry $$R0 = $R0" ; debug
;${stack::ns_size} $STACKSIZE ; debug
;DetailPrint "  stack size = $STACKSIZE" ; debug
push $1
push $R0
push $R1
call GetJawsScriptDir
pop $R1 ; script dir
${SetOutPath} "$R1"
!ifndef JAWSDEBUG
StrCpy $UninstLogAlwaysLog 1
DetailPrint "JAWSInstallVersion: invoking macro JAWSInstallScriptItems for version $0" ; debug
push $0 ; save version/lang
push $1
call GetVerLang
pop $1
pop $0
; $0 = version, $1 = lang
;${stack::ns_size} $STACKSIZE ; debug
;DetailPrint "Before JAWSInstallScriptItems stack size = $STACKSIZE" ; debug
!insertmacro JAWSInstallScriptItems
;${stack::ns_size} $STACKSIZE ; debug
;DetailPrint "After JAWSInstallVersion stack size = $STACKSIZE" ; debug
pop $1
pop $0 ; restore version
StrCpy $UninstLogAlwaysLog ""
!EndIf ;ifndef JAWSDEBUG
;${stack::ns_size} $STACKSIZE ; debug
;DetailPrint "Before CompileSingle stack size = $STACKSIZE" ; debug
!insertmacro CompileSingle $0 "${ScriptApp}"
;${stack::ns_size} $STACKSIZE ; debug
;DetailPrint "after CompileSingle stack size = $STACKSIZE" ; debug
!ifdef JAWSDEBUG
  ;$R0 doesn't contain compiler!!
  ;MessageBox MB_OK `Pretending to run ExecWait '"$R0" "$R1.jss"' $$1`
!Else ; not JAWSDEBUG
  IntCmp $1 0 GoodCompile +1 +1
    ;MessageBox MB_OK "Could not compile $R1, CompileSingle returned $1"
    ;GoTo End
    goto NoCompile
  GoodCompile:
  ;Add .jsb file to log
  strCpy $R0 "$UninstLogAlwaysLog"
  StrCpy $UninstLogAlwaysLog "1"
  ${AddItemDated} "$OUTDIR\${ScriptApp}.jsb"
  StrCpy $UninstLogAlwaysLog "$R0"
!EndIf ; else not JAWSDEBUG
GoTo End
NoCompile:
/*
;$R0 isn't compiler here!
MessageBox MB_OK "$(CouldNotFindCompiler)"
*/
End:
pop $R1
pop $R0
pop $1
;DetailPrint "JawsInstallVersion: on exit $$R0 = $R0" ; debug
;${stack::ns_size} $STACKSIZE ; debug
;DetailPrint "  stack size = $STACKSIZE" ; debug
functionend ; JawsInstallVersion

;-----
;Save/restore uninstaller information

function JAWSSaveInstallInfo
;Store information needed by the uninstaller.  Only JAWSShellContext is needed right now but we store versions and version count for future use.
;Writes to ${TempFile}.
writeinistr "${TempFile}" "Install" JAWSVersionLangs $SELECTEDJAWSVERSIONS
writeinistr "${TempFile}" "Install" JAWSVersionLangsCount $SELECTEDJAWSVERSIONCOUNT
!ifdef JAWSALLOWALLUSERS
  writeinistr "${TempFile}" "Install" JAWSShellContext $JAWSSHELLCONTEXT
!EndIf
functionend ; JAWSSaveInstallInfo

function un.JAWSRestoreInstallInfo
;Restore installation info from ini file.  All we need right now is JAWSShELLCONTEXT but we'll get the other stuff anyway.
;Reads from ${InstallFile}.
readinistr $SELECTEDJAWSVERSIONS "${InstallFile}" "Install" JAWSVersionLangs
readinistr $SELECTEDJAWSVERSIONCOUNT "${InstallFile}" "Install" JAWSVersionLangsCount
!ifdef JAWSALLOWALLUSERS
  readinistr $JAWSSHELLCONTEXT "${InstallFile}" "Install" JAWSShellContext
!EndIf
functionend ; un.JAWSRestoreInstallInfo

!macro JAWSSectionRemoveScript
Section Un.RemoveScript
;!insertmacro un.DeleteScript "${ScriptApp}*.*"
;SetShellVarContext all
!insertmacro JAWSLOG_UNINSTALL
SetOutPath "$INSTDIR"


Delete "${JAWSLOGFILENAME}"

SectionEnd
!macroend ;JAWSSectionRemoveScript

!macro JAWSscriptInstaller
;defines for product info and paths
!ifndef VERSION
!searchparse /ignorecase /file "${JAWSSrcDir}${ScriptApp}.jss" `const CS_SCRIPT_VERSION = "` VERSION `"`
;Get script version.
!ifndef VERSION
!warn "VERSION not gotten from source file, defining it here."
;!define VERSION "0.8.0.00"
!define VERSION ""
!endif ;ifdef VERSION
!endif ;first ifdef VERSION
!echo "VERSION='${VERSION}'"

;Language string files.  They are here because they have to come after the definition of ${VERSION}.
!include "JFW_lang_enu.nsh" ;English language strings for this file


;The registry key in HKLM where the uninstall information is stored.
!define UNINSTALLKEY "Software\Microsoft\Windows\CurrentVersion\Uninstall"

ShowInstDetails Show ; debug
AutoCloseWindow False ; debug;
;Name shown to user, also name of installer file
Name "${ScriptName}"
;The executable file to write
OutFile "${ScriptName}.exe"
;installation directory
InstallDir "$programfiles\${scriptName}" 
;In case it is already installed.
installdirregkey HKLM "${UNINSTALLKEY}\${ScriptName}" "UninstallString"
BrandingText "$(BrandingText)"

  !define MUI_ABORTWARNING
  !define MUI_UNABORTWARNING
!ifndef JAWSNoReadme
!ifndef MUI_FINISHPAGE_SHOWREADME
;!define MUI_FINISHPAGE_SHOWREADME "$instdir\${SCriptApp}_readme.txt"
!define MUI_FINISHPAGE_SHOWREADME "$JAWSREADME"
!EndIf
!define MUI_FINISHPAGE_SHOWREADME_TEXT "$(ViewReadmeFile)"
!EndIf ;ifndef JAWSNoReadme
!define MUI_FINISHPAGE_TEXT_LARGE


!insertmacro JAWSWelcomePage ; ::nsi

!ifdef JAWSLicenseFile
;JAWSSrcDir is empty or contains a trailing backslash.
!insertmacro MUI_PAGE_LICENSE "${JAWSSrcDir}${JAWSLicenseFile}"
!EndIf

!insertmacro JAWSComponentsPage

!insertmacro JAWSSelectVersionsPage

!insertmacro JAWSDirectoryPage

!insertmacro JAWSInstConfirmPage

!define mui_page_customfunction_leave InstFilesLeave
!insertmacro mui_page_instfiles

Function InstFilesLeave
;If we are installing just scripts we don't have the folder in program files, so we don't dump the log file to not clutter up the sripts folder.
  GetCurInstType $0
IntOp $0 $0 + 1 ;make it like SectionIn
${IfNot} $0 = ${INST_JUSTSCRIPTS}
  push "$INSTDIR\installer.log"
  call dumplog
${EndIf}
FunctionEnd ; InstFilesLeave
  
!insertmacro mui_page_Finish

;Uninstall pages
;  !insertmacro MUI_UNPAGE_COMPONENTS
  !insertmacro MUI_UNPAGE_INSTFILES
  !insertmacro MUI_LANGUAGE "English"

Function .OnInit
  ;Find where the JAWS program files are located.
push $0
strcpy $0 "Freedom Scientific\JAWS"
${If} ${FileExists} "$programfiles\$0"
  StrCpy $JAWSPROGDIR "$programfiles\$0"
${ElseIf} ${FileExists} "$programfiles64\$0"
  StrCpy $JAWSPROGDIR "$programfiles64\$0"
${Else}
  ; couldn't find one.
  DetailPrint "Couldn't find the folder $0 in either $programfiles or $programfiles64."
  messagebox MB_OK "$(CantFindJawsProgDir)"
${EndIf}
pop $0

;See if the program is already installed
readregstr $0 HKLM "${UNINSTALLKEY}\${ScriptName}" "UninstallString"
iferrors notinstalled
  messagebox MB_YESNOCANCEL "$(AlreadyInstalled)" /SD IDCANCEL IDNO notinstalled IDYES +2
    abort ; cancel
  DetailPrint "Uninstalling $0"
  CopyFiles /silent $INSTDIR\${uninstaller} $TEMP
  ;messagebox MB_OK "Executing $\"$TEMP\${uninstaller}$\" /S _?=$INSTDIR" ; debug
  nsexec::Exec '"$TEMP\${uninstaller}" /S _?=$INSTDIR'
  pop $1
  DetailPrint "Uninstall returned exit code $1"
  intcmp $1 0 +3
    messagebox MB_OKCANCEL|MB_DEFBUTTON2 "$(UninstallUnsuccessful)" IDOK +2
    abort
notinstalled:

strcpy $JAWSSHELLCONTEXT "current" ; default context

call GetSecIDs ; Initializes variables with some section indexes.
call JAWSOnInit
FunctionEnd ; .OnInit

Function .OnInstSuccess
call JAWSOnInstSuccess
functionend ;JAWSOnInstSuccess


Section -Install
/*
;This won't work here because the install will set it!
!ifdef MUI_FINISHPAGE_SHOWREADME
${If} $JAWSREADME == ""
;No location has been defined for the README file.  We'll try to give it a default since we can't tell the Finish page there isn't one, and there might be one if the define doesn't reference $JAWSREADME.  If it doesn't use $JAWSREADME, no harm is done.
StrCpy $JAWSREADME "$InstDir\${ScriptApp}_README.txt"
${EndIf}
!EndIf ; ifdef MUI_FINISHPAGE_SHOWREADME
*/
${GetTime} "" "l" $R0 $R1 $R2 $R3 $R4 $R5 $R6
DetailPrint "Installing JAWS scripts for Audacity, installer compiled at ${MsgTimeStamp}, installed at $R2-$R1-$R0 $R4:$R5."
SectionEnd

!ifmacrodef JAWSInstallFullItems
section "-install files in instdir" SecInstDirFiles
SectionIn ${INST_FULL}
SetOutPath $INSTDIR
!insertmacro JAWSLOG_OPENINSTALL
!insertmacro JAWSInstallFullItems
!insertmacro JAWSLOG_CLOSEINSTALL
sectionend
!EndIf ;if JAWSInstallFullItems

Section -Uninstaller SecUninstaller
;Writes the uninstaller and supporting info.
sectionIn ${INST_FULL}
!insertmacro JAWSLOG_OPENINSTALL
;Set up for uninstallation.
call JAWSSaveInstallInfo ; saves to ${TempFile}
${AddItem} ${InstallFile} ; won't log it if after copy
CopyFiles /silent ${TempFile} ${InstallFile} ;copy the install.ini to the instal directory
;Write the uninstaller and add it to the uninstall log.
${WriteUninstaller} "$Instdir\${UnInstaller}"
;Add the app to Add or Remove programs.
WriteRegStr HKLM "${UNINSTALLKEY}\${ScriptName}" "DisplayName" "${ScriptName} (remove only)"
WriteRegStr HKLM "${UNINSTALLKEY}\${ScriptName}" "UninstallString" '"$INSTDIR\${UnInstaller}"'
!insertmacro JAWSLOG_CLOSEINSTALL
sectionEnd

;---
; Install JAWS Scripts section
Section "-Install JAWS Scripts" SecJAWS
SectionIn ${INST_FULL} ${INST_JUSTSCRIPTS}
SetOverwrite on ;Always overwrite
!insertmacro JAWSInstallScriptsSectionCode
SetOverwrite ${SetOverwriteDefault}
SectionEnd ;Install JAWS scripts

section "Installer Source" SecInstSrc
;SectionIn ${INST_FULL}
!insertmacro JAWSLOG_OPENINSTALL
${CreateDirectory} "$INSTDIR\${JAWSINSTALLERSRC}"
SetOutPath  "$INSTDIR\Installer Source"
${File} "" "uninstlog.nsh"
${File} "" "installer.nsi"
${File} "" "jfw.nsh"
SetOutPath $INSTDIR
!insertmacro JAWSLOG_CLOSEINSTALL
SectionEnd

!insertmacro JAWSAfterInstallSections

;-----
;From NSIS user manual appendix:
/*
To use it, push a file name and call it. It will dump the log to the file specified. For example:

GetTempFileName $0
Push $0
Call DumpLog
*/
;These are defined in list view stuff.
;!define LVM_GETITEMCOUNT 0x1004
;!define LVM_GETITEMTEXT 0x102D

Function DumpLog
  Exch $5
  Push $0
  Push $1
  Push $2
  Push $3
  Push $4
  Push $6
  push $7 ; error description

  FindWindow $0 "#32770" "" $HWNDPARENT
  ;DetailPrint "DumpLog: $$HWNDPARENT=$HWNDPARENT, FindWindow found $0$\r$\n"
  StrCpy $7 "in FindWindow"
  IntCmp $0 0 error
  GetDlgItem $0 $0 1016
  ;DetailPrint "  GetDlgItem found $0$\r$\n"
  StrCpy $7 "in GetDlgItem"
  StrCmp $0 0 error
  ;delete $5
  !insertmacro JAWSLOG_OPENINSTALL
  DetailPrint "Adding $5."
  ${AddItemAlways} "$5"
  !insertmacro JAWSLOG_CLOSEINSTALL
  ${IfNot} ${FileExists} $5
    FileOpen $5 $5 "w"
    StrCpy $7 "opening file"
    StrCmp $5 0 error
  ${Else}
    ;SetFileAttributes "$INSTDIR\$0" NORMAL
    FileOpen $5 $5 "a"
    StrCpy $7 "opening file for append"
    StrCmp $5 0 error
    FileSeek $5 0 END
  ${EndIf}
  SendMessage $0 ${LVM_GETITEMCOUNT} 0 0 $6
  StrCpy $7 "no items"
  IntCmp $6 0 error
    System::Alloc ${NSIS_MAX_STRLEN}
    Pop $3
    StrCpy $2 0
    System::Call "*(i, i, i, i, i, i, i, i, i) i \
      (0, 0, 0, 0, 0, r3, ${NSIS_MAX_STRLEN}) .r1"
    loop: StrCmp $2 $6 done
      System::Call "User32::SendMessageA(i, i, i, i) i \
        ($0, ${LVM_GETITEMTEXTA}, $2, r1)"
      System::Call "*$3(&t${NSIS_MAX_STRLEN} .r4)"
      FileWrite $5 "$4$\r$\n"
      IntOp $2 $2 + 1
      Goto loop
    done:
      FileClose $5
      System::Free $1
      System::Free $3
      Goto exit
  error:
    DetailPrint "DumpLog: error $7$\r$\n"
    ;MessageBox MB_OK "DumpLog: error $7"
  exit:
    Pop $7
    Pop $6
    Pop $4
    Pop $3
    Pop $2
    Pop $1
    Pop $0
    Exch $5
FunctionEnd ;DumpLog

;-----
;Uninstaller function and Section
Function un.onInit
MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "$(SureYouWantToUninstall)" /SD IDYES IDYES +2
  Abort
call un.JAWSRestoreInstallInfo
${If} $JAWSSHELLCONTEXT == "all"
  ;messagebox MB_OK "Setting all users context" ; debug
  SetShellVarContext all
${Else}
  SetShellVarContext current
${EndIf}
FunctionEnd

Function un.OnUninstSuccess
  ;!Insertmacro RemoveTempFile
  HideWindow
  IfFileExists "$INSTDIR" +1 instdirgone
    MessageBox MB_ICONEXCLAMATION|MB_OK "$(InstallFolderNotRemoved)" /SD IDOK
    return
  instdirgone:
  MessageBox MB_ICONINFORMATION|MB_OK "$(SuccessfullyRemoved)" /SD IDOK
FunctionEnd

!insertmacro JAWSSectionRemoveScript

Section un.Uninstaller
DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${ScriptName}"
; Set outpath to somewhere else, ProgramFiles for now, should be maybe parent of $INSTDIR.
SetOutPath "$PROGRAMFILES"
DetailPrint "Attempting to remove $INSTDIR$\r$\n"
;We don't use rmdir /r in case user chose something like c:\Program Files as install dir.
Rmdir "$INSTDIR" 
SetAutoclose true
SectionEnd
!macroend ;JAWSScriptInstaller

!EndIf ;__JAWSSCRIPTSINCLUDED





;-----

/*
;Install JAWS scripts.
; I don't think these two are used, maybe they should be.
!define JAWSPROGROOT "$PROGRAMFILES\Freedom Scientific\JAWS"
!define JAWSSCRIPTROOT "$APPDATA\Freedom Scientific\JAWS" ; for v6.0 and later
*/

