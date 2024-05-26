# LiveSplit.WormsWMD
Worms W.M.D autosplitter for LiveSplit written in ASL (Auto-Splitter Language).

<!-- PROJECT SHIELDS -->
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
![Status](https://img.shields.io/badge/status-beta-blue)

## First Usage

This script is automatically detected by LiveSplit as part of https://github.com/LiveSplit/LiveSplit.AutoSplitters/blob/master/LiveSplit.AutoSplitters.xml

The layout and splits files are somewhat personal and meant to be created from scratch, but can still be imported:
 - .lss file (LiveSplit splits): keeps your own or someone else's splits times
    - import from speedrun.com
 - .lsl file (LiveSplit layout): your preferred layout
    - import from a URL

## Installation
  1. Open up LiveSplit
  2. Go to `Edit Layout`
  3. Select Worms W.M.D as the game
  4. You should now be able to select an autosplitter

## Rules

- Missions can be played in any order
- Restarting is allowed, the previous attempt game time will be counted
- Going back to the main menu triggers a split, this means:
  - starting a mission requires to finish it successfully
  - need to be careful not to enter the same level twice
- Restarting the first level resets the full run timer

### TODO:
- [x] Fix Bug: restarting a level sometimes substract a few seconds
  - [ ] Fix minor UI Bug: the fix above makes the timer flash quickly with the wrong time

## Development

### Import

Can be manually imported via the `Scriptable Auto Splitter` component on your layout.

### Changes

Main doc for auto splitters: https://github.com/LiveSplit/LiveSplit.AutoSplitters/

To apply changes to the script just edit the script and save it, there is no need to re-run the game or LiveSplit.

### Memory values

To find memory values, their base address and offsets, this technique is very efficient: https://www.unknowncheats.me/forum/programming-for-beginners/110375-cheat-engine-finding-base-address-pointer-scan.html

### Debugging

To view logs/prints, download [DebugView](https://learn.microsoft.com/en-us/sysinternals/downloads/debugview).
To view errors, use Event Viewer already on Windows.


<!-- VARIABLES -->
[issues-shield]: https://img.shields.io/github/issues/stephanebruckert/LiveSplit.WormsWMD.svg
[issues-url]: https://github.com/stephanebruckert/LiveSplit.WormsWMD/issues
[license-shield]: https://img.shields.io/github/license/stephanebruckert/LiveSplit.WormsWMD
[license-url]: https://github.com/stephanebruckert/LiveSplit.WormsWMD/blob/master/LICENSE

