# LiveSplit.WormsWMD
Worms W.M.D autosplitter for LiveSplit written in ASL (Auto-Splitter Language).

## First Usage

This script is automatically detected by LiveSplit as part of https://github.com/LiveSplit/LiveSplit.AutoSplitters/blob/master/LiveSplit.AutoSplitters.xml

The layout and splits files are somewhat personal and meant to be created from scratch, but can still be imported:
 - .lss file (LiveSplit splits): keeps your own or someone else's splits times
    - import from speedrun.com
 - .lsl file (LiveSplit layout): your preferred layout
    - import from a URL

## Installation
  1. Go to the [releases](https://github.com/stephanebruckert/LiveSplit.WormsWMD/releases/) page and download the `Worms-WMD-Autosplitter.zip` from the latest release
  2. Extract the archive into your desired location
  3. Open up [LiveSplit](https://livesplit.org/)
  4. Right click on the timer
  5. Click on `Edit Layout`
  6. Click on the `+` icon
  7. `Control > Scriptable Auto Splitter`
  8. Double click on the `Scriptable Auto Splitter` component
  9. Click browse and select the `.asl` file from the extracted folder (step 2)
  10. Create or download the splits (`Right click on the timer > Edit Splits`)
  11. Done. You should now be able to open up a level and the timer should automatically start

### TODO:
- [x] Add support for Bonus Missions
- [x] Add support for Extra Missions
- [x] Add support for Challenge Missions
- [ ] Add support for Campaign Missions
- [ ] Add support for Training Missions
- [ ] Split only after in game rather than immidiately when the level loads
- [ ] Fix problem when exiting a mission timer keeps going for a little and then stops again


## Development

### Import

Can be manually imported via the `Scriptable Auto Splitter` component on your layout. (look [Installation](#installation))

### Changes

Main doc for auto splitters: https://github.com/LiveSplit/LiveSplit.AutoSplitters/

To apply changes to the script just edit the script and save it, there is no need to re-run the game or LiveSplit.

### Memory values

To find memory values, their base address and offsets, this technique is very efficient: https://www.unknowncheats.me/forum/programming-for-beginners/110375-cheat-engine-finding-base-address-pointer-scan.html

### Debugging

To view logs/prints, download [DebugView](https://learn.microsoft.com/en-us/sysinternals/downloads/debugview).
To view errors, use Event Viewer already on Windows.
