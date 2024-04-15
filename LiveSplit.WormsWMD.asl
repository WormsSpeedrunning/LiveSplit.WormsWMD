// Define the executable and variables
state("Worms W.M.D") {
    string20 selectedCampaignMission : "Worms W.M.D.exe", 0x0F103540, 0xE8, 0x1C0, 0xDC, 0x1BC, 0xAAC;
    string21 selectedChallengeMission : "Worms W.M.D.exe", 0x0F10354C, 0xE0, 0xDC, 0x1BC, 0xD8, 0xD8, 0xAAC;
    string19 selectedExtraMission : "Worms W.M.D.exe", 0x0F103548, 0x1BC, 0x1BC, 0x1BC, 0xAAC;
    string17 selectedBonusMission : "Worms W.M.D.exe", 0x0F103548, 0xDC, 0x1BC, 0xDC, 0x1BC, 0xAAC;

    // Is the game paused or not
    bool menuOrPaused : "Worms W.M.D.exe", 0x1036752;

    // TODO: Is the in game timer stopped or not (Cheat Engine Search: type is byte, 1 if timer moving, 0 if not)
    // bool IgTimerRunning : "Worms W.M.D.exe", offsets;
}

startup {
    // Add campaign missions to the settings (Edit Layout > Scriptable Autosplitter)
    settings.Add("campaign_missions", true, "Campaign Missions");

    settings.CurrentDefaultParent = "challenge_missions";
    settings.Add("FE.Header.Campaign", true, "Church and Destroy");
    settings.Add("FE.Header.Campaign", true, "Building for Protection");
    settings.Add("FE.Header.Campaign", true, "Tanks for the Memories");
    settings.Add("FE.Header.Campaign", true, "Chopper Suey");
    settings.Add("FE.Header.Campaign", true, "Crème de la Kremlin");
    settings.Add("FE.Header.Campaign", true, "Tijuana Dance With Me?");
    settings.Add("FE.Header.Campaign", true, "Russian to the Crate");
    settings.Add("FE.Header.Campaign", true, "The States of Play");
    settings.Add("FE.Header.Campaign", true, "When Will I Siege You Again?");
    settings.Add("FE.Header.Campaign", true, "Rumble in the Jungle");
    settings.Add("FE.Header.Campaign", true, "Koo and the Gang");
    settings.Add("FE.Header.Campaign", true, "Temple Troubles");
    settings.Add("FE.Header.Campaign", true, "Juan Shot, Juan Kill");
    settings.Add("FE.Header.Campaign", true, "Fur the Win");
    settings.Add("FE.Header.Campaign", true, "The Banks of England");
    settings.Add("FE.Header.Campaign", true, "Don’t Believe the Snype");
    settings.Add("FE.Header.Campaign", true, "Keep Your Chinook");
    settings.Add("FE.Header.Campaign", true, "Enemy At the Crates");
    settings.Add("FE.Header.Campaign", true, "We’re Foo Yung To Die");
    settings.Add("FE.Header.Campaign", true, "Mount-A-Strike");
    settings.Add("FE.Header.Campaign", true, "Reach for the Tsars");
    settings.Add("FE.Header.Campaign", true, "Stormtroupers");
    settings.Add("FE.Header.Campaign", true, "The Crate Wall");
    settings.Add("FE.Header.Campaign", true, "Chip Chopper Disaster");
    settings.Add("FE.Header.Campaign", true, "You Got the Hanger This");
    settings.Add("FE.Header.Campaign", true, "Blockbuster");
    settings.Add("FE.Header.Campaign", true, "It’s Nacho’s Fault");
    settings.Add("FE.Header.Campaign", true, "The Legend of Ro Ping ");
    settings.Add("FE.Header.Campaign", true, "Crafty Cavern Capers");
    settings.Add("FE.Header.Campaign", true, "Tsarface");
    settings.CurrentDefaultParent = null;

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
    if (current.selectedCampaignMission != old.selectedCampaignMission
        || current.selectedChallengeMission != old.selectedChallengeMission
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
