// Define the executable and variables
state("Worms W.M.D") {
    string21 selectedChallengeMission : "Worms W.M.D.exe", 0x0F10354C, 0xE0, 0xDC, 0x1BC, 0xD8, 0xD8, 0xAAC;
    string19 selectedExtraMission : "Worms W.M.D.exe", 0x0F103548, 0x1BC, 0x1BC, 0x1BC, 0xAAC;
    string17 selectedBonusMission : "Worms W.M.D.exe", 0x0F103548, 0xDC, 0x1BC, 0xDC, 0x1BC, 0xAAC;

    // Is the game paused or not
    bool menuOrPaused : "Worms W.M.D.exe", 0x1036752;

    // TODO: Is the in game timer stopped or not (Cheat Engine Search: type is byte, 1 if timer moving, 0 if not)
    // bool IgTimerRunning : "Worms W.M.D.exe", offsets;
}

startup {
    // Add challenge missions to the settings (Edit Layout > Scriptable Autosplitter)
    settings.Add("challenge_missions", true, "Challenge Missions");

    settings.CurrentDefaultParent = "challenge_missions";
    settings.Add("FE.Header.Challenge01", true, "Jetpack to Work!");
    settings.Add("FE.Header.Challenge02", true, "I'm gonna Mech you Mine");
    settings.Add("FE.Header.Challenge03", true, "Don't be Greedy!");
    settings.Add("FE.Header.Challenge04", true, "Assault and Battery");
    settings.Add("FE.Header.Challenge05", true, "Sharpshooter");
    settings.Add("FE.Header.Challenge06", true, "Blast Off!");
    settings.Add("FE.Header.Challenge07", true, "Batter Up!");
    settings.Add("FE.Header.Challenge08", true, "Mi Pun Chu");
    settings.Add("FE.Header.Challenge09", true, "Tanked Up");
    settings.Add("FE.Header.Challenge10", true, "Ice Spy");
    settings.CurrentDefaultParent = null;

    // Add extra missions to the settings (Edit Layout > Scriptable Autosplitter)
    settings.Add("extra_missions", true, "Extra Missions");

    settings.CurrentDefaultParent = "extra_missions";
    settings.Add("FE.Header.Carentan1", true, "War of the Worms");
    settings.Add("FE.Header.Carentan2", true, "Downfall");
    settings.Add("FE.Header.Carentan3", true, "Château de Gâteau");
    settings.Add("FE.Header.Carentan4", true, "Grieving Private Survivor");
    settings.Add("FE.Header.Carentan5", true, "Final Fury");
    settings.CurrentDefaultParent = null;

    // Add bonus missions to the settings (Edit Layout > Scriptable Autosplitter)
    settings.Add("bonus_missions", true, "Bonus Missions");

    settings.CurrentDefaultParent = "bonus_missions";
    settings.Add("FE.Header.Bonus01", true, "Cool As Ice");
    settings.Add("FE.Header.Bonus02", true, "Operation Alcatraz");
    settings.Add("FE.Header.Bonus03", true, "Steeple Jack");
    settings.Add("FE.Header.Bonus04", true, "Sinking Icecaps");
    settings.Add("FE.Header.Bonus05", true, "Countdown To Armaggeddon");
    settings.Add("FE.Header.Bonus06", true, "Unturned");
    settings.Add("FE.Header.Bonus07", true, "The Escapists");
}

start {
    // TODO: Instead of starting the timer when the bool changes, Start the timer when IgTimerRunning changes the first time
    //       This will prevent the timer from starting before the player can move.
    if (!current.menuOrPaused) { // && current.IgTimerRunning
        return true;
    }
}

init {
    // Temporary variables used in split{}.
    // Selected mission change is detected only once before the game/timer starts,
    // therefore we need to keep that information in memory until the timer starts.
    vars.tmpMissionIsChanging = false;
}

split {
    if (current.selectedChallengeMission != old.selectedChallengeMission
        || current.selectedExtraMission != old.selectedExtraMission
        || current.selectedBonusMission != old.selectedBonusMission) {
        // Step 1: detect selection of new mission in menu
        vars.tmpMissionIsChanging = true;
    } else if (vars.tmpMissionIsChanging && !current.menuOrPaused) {
        // Step 2: detect timer start
        vars.tmpMissionIsChanging = false;
        return true;
    }
}

isLoading {
    // TODO: FIX THIS! This will return true when it's the enemy's turn. NOT WHAT WE WANT!

    // The code bellow should work once IgTimerRunning is defined
    // return (current.MenuOrPaused && !current.IgTimerRunning) || !current.IgTimerRunning;

    // Return true if the game is paused or in the menu
    return current.menuOrPaused;
}
