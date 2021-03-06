2017-02-18  JAWS script for Audacity V2.0 (for script version 2.1.0 by Gary Campbell <campg2003@gmail.com> and Dang Manh Cuong <dangmanhcuong@gmail.com>

This JAWS script package provides support for Audacity 2.0.0 and later.

# Features:
- Keystrokes to speak selection start, selection end or length, and Audio Position from anywhere in the main window.
- Keystrokes to move the focus to the selection start and selection end/length controls.
- Displays JAWS and Audacity hotkey help.
- The Audacity Guide for JAWS users, by David Bailes, is accessible from the Audacity keys help (JAWSKey+w).
- Speaks main window areas: Toolbars, Track Panel, and selection Bar, as focus moves between them.
- Speaks the toolbar name when focus moves from one toolbar to another.
- When focus is in the toolbars pressing `CTRL+TAB` and `Shift+CTRL+TAB` move to the first control on the next toolbar and the last control on the previous toolbar, respectively.
- `JAWSKey+Delete` speaks the current program state: stop, play, play pause, record, or record pause.
- Speaks cursor position when left/right arrows are pressed and Audacity is stopped when focus is in the track panel.
- Keystrokes that extend or contract the selection speak the new position (or length).
- Indicates when there are no tracks in the project for many operations.
- Keystrokes speak (maximum peak) value of recording and playback meters.
- Track gain and pan controls now are passed to the application when the PC cursor is active and focus is in the main window.  Otherwise they execute their default mouse movement functions.
- In many VST plug-ins, keystrokes move focus to the Presets control and activate save/Load Presets.
- In many plug-in dialogs control names and values are spoken.  
- Multilanguage support: English and Spanish are supported.  There is also a Vietnamese translation of the README file.  Thanks to Nguyen Hoang Giang, Dang Manh Cuong, and Le Thi Theu for providing this.  It is in the file audacity_readme_vi.txt in the installation folder in your program files folder.
- You can go to a track by number.  You can also move a track to a specific position by number.  You can also set a "mark" on a track and later return there, or move a track there.
- Feedback is provided when moving a track via the keyboard.  (See below.)
- The installer can now install for all users or the current user.  All user installs can install in the shared scripts, including for JAWS 17.
- When playing or recording the `ENTER` key executes pause/resume.  In this case, pressing `CTRL+ENTER` sends `ENTER`.  I like this because the numpad ENTER key is easier to find than "p" if your hands are off the keyboard.  this can be turned off with an option in Adjust JAWS Options.  Try it out and let us know if it works for you and if you like it.  
 
# Installing and Uninstalling the Script

## To install:

1. Place the installer in a folder on your machine.
2. Run it to install the files.

Three install types are supported:

- Just Script: installs the script but does not install uninstall information or make a folder in %ProgramFiles%.
- Full: installs the script in the script folder for the selected versions/languages, creates a folder in `%programfiles%` (`%localappdata%` for current user install) (the installation folder) wich contains an uninstaller and optional additional files such as README, etc.
- Custom: like Full but allows installation of the installer source.

For full or custom installations for all users the uninstaller and README files are installed in the installation folder.  

If you choose the Just Script install type, the README and What's New files will be installed in the JAWS scripts folder for each version, and `What's new.md` will be called `audacity_whatsnew.md`.  (The Vietnamese README file will not be installed in a Just Script install.)

If the user's priveleges allow for installing for all users, an all user install is performed.  Otherwise a current user install is performed.  If privileges allow for all user installation, current user installation can be forced by adding the `/currentuser` command line switch.

For all user installs, on the Versions/Languages page you can choose whether to install the script for the current user or for all users.  

The installer allows you to choose which JAWS versions and languages to install into.  It will compile the script package for each JAWS version.  Note that the script will only be properly compiled for the language of the currently running JAWS.

If you want to modify the installer, or are just curious how it works, you can install the installer source by selecting the Custom install type and choosing the Install Installer source component.

##To uninstall:
The package can be uninstalled via Program Features (Add/Remove Programs).  You can also run `uninst.exe` in the installation folder (`%programfiles(x86)%\Jaws Script for Audacity` or `%localappdata%\Jaws Script for Audacity`).

If the uninstaller detects that the script files have been modified since they were installed, it asks for confirmation before removing them.  A Yes response will delete all modified files.  A No response will leave them all.  The settings file (`audacity.jcf` or `audacity.jsi`) is not removed.

# Using the Script

Note: The script speaks names for some Audacity keystrokes, and uses others for performing some of its operations.  If you reassign these keys in Preferences > Keyboard, you must also change their assignments in `audacity.jkm` if you want the script to continue to function properly.

## Basics
Once installed, the script will speak a welcome message the first time Audacity gains focus.  You can browse the list of keystrokes the script provides by pressing `JAWSKey+h` (`HotKeyHelp`).  You can get a list of Audacity keystrokes by pressing `JAWSKey+w`.  This page also has a link that will open the Audacity Guide for JAWS users, by David Bailes, in your web browser.

You can read the Selection Start and Selection End/Length fields by pressing `Alt+[` and `Alt+]`, respectively.  Pressing these keys twice quickly will move focus to the fields.  Note that `Alt+]` speaks "end" or "length" depending on the setting of the radio buttons.  When the PC cursor is active, pressing `Alt+DEL` speaks the value of the Audio Position field.  (This is useful when playing or recording.)  When pressed twice quickly, the normal JAWS function is performed.  Pressing `JAWSKey+DEL` announces what state Audacity is in currently-- stopped, play, play pause, record, or record pause.  (This information is also available on the status bar in recent versions of Audacity.)

The script version can be obtained by pressing `JAWSKey+CONTROL+V` (twice quickly to display it in the virtual viewer), and also appears in JAWS hot key help.

The URL for accessing the Audacity Guide for JAWS users can be modified via the script by pressing `Control+Shift+j`.  This opens a dialog with an edit box containing the URL.  Update or replace it and press OK.

When entering a label in a label track JAWS used to speak the Audacity functions for letter keys even though the letters were being entered into the label.  We now suppress this behavior if you use the standard methods for creating a label.  This feature is activated by the `Control+b` and `Control+m` keystrokes and is deactivated when `ENTER` is pressed.  (It is also deactivated if you arrow to another track or if focus moves out of the track panel.)  It will not activate if you arrow to the label track and start writing.  If you change the standard key assignments for these commands you will also need to change `audacity.jkm` accordingly.

When focus is in a label track pressing `TAB` will try to speak the "current" label.  This is done by searching for text with a white background.    This doesn't always work, particularly with a lot of labels.  


## Script Options

The script has several options that control some of its features.  They can be accessed by pressing `JAWSKey+v`.  For JAWS versions prior to 13 these settings are stored in file `audacity.jsi` in the PersonalSettings folder of the JAWS installation.  For version 13 and later they are stored in `audacity.jcf` in the `NonJCFOptions` section.  If you upgrade from a version of JAWS before 13 to 13 or later the settings are not transferred from `audacity.jsi`, so you will have to set them again.

## Going to and Moving Tracks

It is possible to go to a track by number, move a track to a position by number, and remember a track position to return there later or to move a track there.  Feedback is also given if you move a track with the keyboard.  This feature only works in Audacity 2.1.1 and later, and requires some configuration in Audacity to work.  You must assign the `Move Focused Track Up` Audacity command to `Control+Shift+UpArrow` and `Move Focused Track Down` to `Control+Shift+DownArrow`.  To do this:

1. In Audacity open Preferences (`CTRL+p`) and go to the Keyboard category (press `k`).
2. Tab to the edit box and enter "move focused" (I'm using tree view).
3. Tab to the tree view and find `Move focused track down`.
4. Tab to the Shortcut field and press `Control+Shift+DownArrow`.
5. Tab to the `Set` button and press SPACE to activate it.
6. Press `Shift+TAB` twice to move back to the tree view.
7. Find the `Move focused track up` command and assign `Control+Shift+UpArrow` to it in the same way.
8. Tab to OK and press SPACEBAR.

If you want to use different keys you will have to change the assignments in `audacity.jkm`.

Once configured, you can go to a track by pressing `JAWSKey+a,g`.  The script prompts for a number.  You can enter a number to go to that track.  Prefix the number with `+` to move down (to higher track numbers) that many tracks, or `-` to move up.  You can move a track with `JAWSKey+a,m`.  You can mark the current track with `JAWSKey+a,k`.  Then you can return to the marked track with `JAWSKey+a,Shift+g` and move the current track to the marked position with `JAWSKey+a,Shift+m`.  Note that this mark simply remembers a track number, so if you add or delete tracks above it, it will point to the wrong track.  `SayLine` (`JAWSKey+Numpad5`) speaks the number of the current track and the total number of tracks when focus is in the track panel.  (Some of you may be thinking, "but Audacity already says track numbers."  It does when you create a track, but not if you rename it, or if it is the result of importing a file.)

# Issues:

1.  This version of the script adds the ability to silence previewing in effects like Amplify.  Sometimes this doesn't get turned off.  If this happens, switching focus away from Audacity and back will turn it off.

2.  The position fields sometimes are not shortened.  This happens because the JAWS `GetWindowText` function returns just the numbers with no h, m, :, etc.  We do not know what causes this.  I have been able to correct this by shutting down and restarting Audacity.  This was observed with JAWS 10, 15, 16, and 17.  I have observed that this problem sometimes goes away on its own.

3.  If the "ENTER Pauses during play/record" feature is on (which is the default), `ENTER` will not select or unselect the current track while playing or recording.  Use `Control+ENTER` instead of `ENTER` in this case.

4.  If you redefine the `numpad ENTER` key and set JAWS to treat extended keys separately, both `ENTER` keys will be mapped to the typing keys `ENTER`.  If you don't like this feature you can deactivate it by adding a semicolon on the lines for `ENTER`, `NumPadEnter`, and `Control+ENTER` in `audacity.jkm` and removing semicolons on the lines containing `/*` and `*/` before and after scripts `Enter` and `CtrlEnter` in `audacity.jss`.  If you modify `audacity.jss`, please change the date in the version constant so we'll know it is a modified version if you communicate with us about it.

5.  The JAWS script compiler only compiles for the currently running language.  (See below.)

6.  In versions of JAWS prior to 13 the keystroke for setting script options (`JAWSKey+v`) will not appear in hotkey help.  It will still work, however.  We could script around this if it turns out to be a problem.


# Multiple Language Support
This version of the installer framework contains the first cut of support for installation of the script in multiple languages.  It now treats version/language pairs as it previously treated versions, so the version selection list view now shows entries like 16.0/enu.  English and Spanish are currently supported.  Fernando Gregoire has contributed the Spanish translation.  Gracias!

Although the installer installs and compiles the script into the selected language folders, the JAWS script compiler always compiles the script files for the language of the currently-running version of JAWS.  Therefore, after installing you will need to run JAWS with each of the other languages and compile the script.

# Notes for script developers
If you modify the script files, please update the version constant near the beginning of `audacity.jss`.  This is particularly important if you distribute the script.  Even if you just modify it for your own use, this will make sure we know it is a modified version if you communicate with us about it.

Messages and string constants for the JAWS script are in `audacity.jsm` and `audacity.qsm`.  

The installer messages are now localizable.  The message text has now been separated from the installer code so that message sets can be prepared for each language.  English and Spanish are currently supported.  Messages are in `.nsh` header files with names like `*_enu.nsh` or `*_lang_enu.nsh`.

This package is now hosted on GitHub.  The repository is at <https://github.com/campg2j003/JAWS-Script-for-Audacity>.  If you would like to contribute changes to the script, please see [CONTRIBUTING.md][] in the repository.
[CONTRIBUTING.md]: https://github.com/campg2j003/JAWS-Script-for-Audacity/blob/master/CONTRIBUTING.md

# Notes for Translators
Note that `readme.html` is generated from `readme.md`, which is only available from the GitHub repository.  See [CONTRIBUTING.md][] for more information.

Note that the script is compiled using `#pragma usePoFile 0`.

# Conclusion
The script was developed with Audacity 2.0.3, 2.0.4, 2.0.5, 2.1.0, 2.1.1, and 2.1.2.  It has also been tested with 2.1.3 alpha versions.  It will probably work with any JAWS after 5.0, although the options for Audacity in Adjust JAWS Verbosity may not look very good, and this hasn't been tested.  (I remember that one of the JAWS functions we use was marked in the FSDN as requiring JAWS 10.)  Recent development has been done with JAWS 17 and 18 on a 64-bit laptop running Windows 10.  Although support remains for previous versions of JAWS, the current code has not been tested with them.  There is no specific Braille support at this time.

I would be interested in feedback on the script and suggestions for improvement, but can't promise any updates.

# Here is the text of the JAWS hot key help:

```
To say the selection start position, press Alt+[.
To say the selection end position or length, press Alt+].
To move focus to these controls, press the key twice quickly.
To say the Audio Position value, press Alt+Delete.
To say the active cursor while the PC cursor is active, press Alt+Delete twice quickly.

To increase gain of focus track, press Alt+Shift+UpArrow.
To reduce gain of focus track, press Alt+Shift+DownArrow.
To adjust pan left, press Alt+Shift+LeftArrow.
To adjust pan right, press Alt+Shift+RightArrow.
The last 4 keys replace the default JAWS mouse movement scripts while focus is in the main window.  If you want to activate the original functionality while
in the main window, turn on the JAWS cursor.

To say the value of the recording meter, press g.
 Press twice quickly to move focus to the meter.
To say the value of the playback meter, press h.
 Press twice quickly to move focus to the meter.

To go to a track by number, press JAWSKey+a, g.
To move the current track to a track position by number, press JAWSKey+a, m.
To mark the current track, press JAWSKey+a, k.
To go to the marked track, press JAWSKey+a, Shift+g.
To go to the marked track and mark the starting track, press JAWSKey+a, x.
To move the current track to the position of the marked track and set the mark to the current track, press Insert+a, Shift+m.

To toggle speech on or off, press Shift+Insert+S.
To toggle alert messages on or off, press Control+`).  This duplicates the Announce Audacity messages option in Adjust JAWS options.
See What's new.md for more info.

In a toolbar to move to the next toolbar press Control+Tab
In a toolbar to move to the previous toolbar press Control+Shift+Tab

To speak the program's state (play/pause/record/stop) press JAWSKey+delete
To reset all script options to default values, press Shift+Control+`
To switch between the two lists in the Edit Chains dialog, press F6.

To get help with Audacity hot keys, press Insert+w.
To get the default Windows hot key help, press Insert+w twice quickly.

If the "ENTER pauses during play/record" option is on, pressing Enter while playing or recording sends the Pause key.  Use Control+ENTER to execute ENTER
in this situation.

In some common VST plugins, such as L1V:
To set focus to the preset control, press Alt+P.
To load an existing preset, press  .
To save the current settings as a preset, press  Alt+S.

If SilencePreview is on and you hit the Preview button in an effect, sometimes the silencing of the previewing does not get turned off.  This will result
in missing speech that occurs as a result of focus changes.  You can fix this by switching away from Audacity and back.
 
To change settings for the Audacity script, press   JAWSKey+V.

To Change the URL for the Audacity Jaws Guide, press Shift+Control+J
 ```

Enjoy!
