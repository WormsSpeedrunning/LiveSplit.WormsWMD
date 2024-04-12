# LiveSplit.WormsWMD
Worms WMD autosplitter for LiveSplit written in ASL (Auto-Splitter Language).

## First Usage

This script is automatically detected by LiveSplit as part of https://github.com/LiveSplit/LiveSplit.AutoSplitters/blob/master/LiveSplit.AutoSplitters.xml

The layout and splits files are somewhat personal and meant to be created from scratch, but can still be imported:
 - .lss file (LiveSplit splits): keeps your own or someone else's splits times
    - import from speedrun.com
 - .lsl file (LiveSplit layout): your preferred layout
    - import from a URL

## Development

### Import

Can be manually imported via the `Scriptable Auto Splitter` component on your layout.

### Changes

Main doc: https://github.com/LiveSplit/LiveSplit.AutoSplitters/

To apply changes to the script just save it, there is no need to re-run the game or LiveSplit.

### Memory values

To find memory values, their base address and offsets, this technique is very efficient: https://www.unknowncheats.me/forum/programming-for-beginners/110375-cheat-engine-finding-base-address-pointer-scan.html

### Debugging

To view logs/prints, download [DebugView](https://learn.microsoft.com/en-us/sysinternals/downloads/debugview).
To view errors, use Event Viewer already on Windows.
