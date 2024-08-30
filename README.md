# LiveSplit.WormsWMD

Worms W.M.D autosplitter for LiveSplit written in ASL (Auto-Splitter Language).

<!-- PROJECT SHIELDS -->
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]

## First Usage

This script is automatically detected by LiveSplit as part of https://github.com/LiveSplit/LiveSplit.AutoSplitters/blob/master/LiveSplit.AutoSplitters.xml

The layout and splits files are somewhat personal and meant to be created from scratch, but can still be imported:
 - .lss file (LiveSplit splits): keeps your own or someone else's splits times
    - import from speedrun.com
    - levels or run categories are not part of the script and need to be set in the LiveSplit splits. You can copy the missions from [here][missions-url].
 - .lsl file (LiveSplit layout): your preferred layout
    - import from a URL

## Installation

  1. Open up LiveSplit
  2. Go to the Splits Editor via `Edit Splits...`
  3. Select Worms W.M.D as the game
  4. Click Activate

## Timing methods (Training vs Campaign)

Categories are automatically detected and will set the timing method accordingly:

- For training levels: Game Time only counts the in-game timers (LRT does not work for training runs, at least for now.)
- For campaign levels: Real Time removes level loading times (LRT)

The splitter also works for single level runs, as long as only one level is set in the Splits Editor.

## Rules

- Timers starts when first level timer starts
- Levels can be played in any order
- Restarting:
  - any level is allowed, the previous attempt game time will be counted
  - the first level resets all timers, as if a new run starts
- Split occurs when the mission results appear
  - ⚠️ failing a campaign mission will automatically detect a split, which can be undone using the Undo Split hotkey (F3 by default)
- Timer ends when the last split happens

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
[issues-shield]: https://img.shields.io/github/issues/WormsSpeedrunning/LiveSplit.WormsWMD.svg
[issues-url]: https://github.com/WormsSpeedrunning/LiveSplit.WormsWMD/issues
[license-shield]: https://img.shields.io/github/license/WormsSpeedrunning/LiveSplit.WormsWMD
[license-url]: /LICENSE
[missions-url]: https://docs.google.com/spreadsheets/d/1wLOU4FbLXlK7e3cd_i5Iwp5cv3UWQyyUSuk-VmZqfHk/edit

