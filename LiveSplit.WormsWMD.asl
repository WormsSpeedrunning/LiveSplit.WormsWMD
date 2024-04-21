// Define the executable and variables
state("Worms W.M.D") {
    string33 selectedTrainingMission : "Worms W.M.D.exe", 0x0F103540, 0xE8, 0x1C0, 0xDC, 0xAAC;
    string20 selectedCampaignMission : "Worms W.M.D.exe", 0x0F103540, 0xE8, 0x1C0, 0xDC, 0x1BC, 0xAAC;
    string21 selectedChallengeMission : "Worms W.M.D.exe", 0x0F10354C, 0xE0, 0xDC, 0x1BC, 0xD8, 0xD8, 0xAAC;
    string19 selectedExtraMission : "Worms W.M.D.exe", 0x0F103548, 0x1BC, 0x1BC, 0x1BC, 0xAAC;
    string17 selectedBonusMission : "Worms W.M.D.exe", 0x0F103548, 0xDC, 0x1BC, 0xDC, 0x1BC, 0xAAC;

    // False in main menu, True otherwise (in game, paused, results)
    bool inGame : "Worms W.M.D.exe", 0x0011E7A8, 0x0;

    // 1 if inventory open, 2 if paused, 3 if both, 0 otherwise
    byte paused : "Worms W.M.D.exe", 0x50C342A;

    // True when replaying
    bool replay : "Worms W.M.D.exe", 0x00415D8C, 0x0;

    // True when it's the current player's turn, but:
    //      Initially true in the menu
    //      False when loading the level
    //      True when the first pre-timer starts
    //      False when the CPU pre-timer starts
    //      True or false in the results page and main menu depending on who played last
    bool playerTurn : "Worms W.M.D.exe", 0x0032593C, 0x0;
}

start {
    return current.inGame && current.playerTurn;
}

init {
    // Temporary variable used in split{}.
    // Selected mission change is detected only once before the game/timer starts,
    // therefore we need to keep that information in memory until the timer starts.
    vars.tmpMissionIsChanging = false;
}

split {
    if (current.selectedTrainingMission != old.selectedTrainingMission
            && (current.selectedTrainingMission.Contains("Basic")
                || current.selectedTrainingMission.Contains("Training")
                || current.selectedTrainingMission.Contains("Advanced"))
        || current.selectedCampaignMission != old.selectedCampaignMission
        || current.selectedChallengeMission != old.selectedChallengeMission
        || current.selectedExtraMission != old.selectedExtraMission
        || current.selectedBonusMission != old.selectedBonusMission) {
        // Step 1: detect selection of new mission in menu
        vars.tmpMissionIsChanging = true;
    } else if (vars.tmpMissionIsChanging && current.inGame) {
        // TODO: use playerTurn for a later split, but make sure isLoading is true until the split happens

        // Step 2: detect timer start
        vars.tmpMissionIsChanging = false;
        return true;
    }
}

isLoading {
    // Return true if the game is paused, in the menu, or replaying
    return
        !current.inGame // check if we are in game
        || current.paused > 1 // 1 = inventory open, 2 = paused, 3 = inventory open and paused
        || current.replay; // check if we are playing an instant replay
}

startup {
    // Add training missions to the settings (Edit Layout > Scriptable Autosplitter)
    settings.Add("training_missions", true, "Training Missions");

    settings.CurrentDefaultParent = "training_missions";
    settings.Add("basic_training_missions", true, "Basic Training Missions");
    settings.Add("pro_training_missions", true, "Pro Training Missions");

    settings.CurrentDefaultParent = "basic_training_missions";
    settings.Add("FE.Header.NavigationTraining", true, "Navigation");
    settings.Add("FE.Header.BazookaBasicTraining", true, "Bazooka");
    settings.Add("FE.Header.StaticGunBasic", true, "Gun Turret");
    settings.Add("FE.Header.GrenadeBasicTraining", true, "Grenade");
    settings.Add("FE.Header.TankTraining", true, "Tank");
    settings.Add("FE.Header.ShotgunBasicTraining", true, "Shotgun");
    settings.Add("FE.Header.MechTraining", true, "Mech");
    settings.Add("FE.Header.Airstrike Training", true, "Airstrike");
    settings.Add("FE.Header.HelicopterTraining", true, "Helicopter");
    settings.Add("FE.Header.SheepTraining", true, "Sheep");

    settings.CurrentDefaultParent = "pro_training_missions";
    settings.Add("FE.Header.BazookaAdvancedTraining", true, "Pro: Bazooka");
    settings.Add("FE.Header.ParachuteTraining", true, "Pro: Parachute");
    settings.Add("FE.Header.StaticGunAdvanced", true, "Pro: Gun Turret");
    settings.Add("FE.Header.JetPackTraining", true, "Pro: Jet Pack");
    settings.Add("FE.Header.GrenadeAdvancedTraining", true, "Pro: Grenade");
    settings.Add("FE.Header.HomingMissileTraining", true, "Pro: Homing Missile");
    settings.Add("FE.Header.SuperSheepTraining", true, "Pro: Super Sheep");
    settings.Add("FE.Header.SheepRopeTraining", true, "Pro: Sheep-On-A-Rope");
    settings.Add("FE.Header.HHGTraining", true, "Pro: Holy Hand Grenade");
    settings.Add("FE.Header.NinjaRopeTraining", true, "Pro: Ninja Rope");
    settings.CurrentDefaultParent = null;

    // Add campaign missions to the settings (Edit Layout > Scriptable Autosplitter)
    settings.Add("campaign_missions", true, "Campaign Missions");

    settings.CurrentDefaultParent = "campaign_missions";
    settings.Add("FE.Header.Campaign1", true, "Church and Destroy");
    settings.Add("FE.Header.Campaign2", true, "Building for Protection");
    settings.Add("FE.Header.Campaign3", true, "Tanks for the Memories");
    settings.Add("FE.Header.Campaign4", true, "Chopper Suey");
    settings.Add("FE.Header.Campaign5", true, "Crème de la Kremlin");
    settings.Add("FE.Header.Campaign6", true, "Tijuana Dance With Me?");
    settings.Add("FE.Header.Campaign7", true, "Russian to the Crate");
    settings.Add("FE.Header.Campaign8", true, "The States of Play");
    settings.Add("FE.Header.Campaign9", true, "When Will I Siege You Again?");
    settings.Add("FE.Header.Campaign10", true, "Rumble in the Jungle");
    settings.Add("FE.Header.Campaign11", true, "Koo and the Gang");
    settings.Add("FE.Header.Campaign12", true, "Temple Troubles");
    settings.Add("FE.Header.Campaign13", true, "Juan Shot, Juan Kill");
    settings.Add("FE.Header.Campaign14", true, "Fur the Win");
    settings.Add("FE.Header.Campaign15", true, "The Banks of England");
    settings.Add("FE.Header.Campaign16", true, "Don’t Believe the Snype");
    settings.Add("FE.Header.Campaign17", true, "Keep Your Chinook");
    settings.Add("FE.Header.Campaign18", true, "Enemy At the Crates");
    settings.Add("FE.Header.Campaign19", true, "We’re Foo Yung To Die");
    settings.Add("FE.Header.Campaign20", true, "Mount-A-Strike");
    settings.Add("FE.Header.Campaign21", true, "Reach for the Tsars");
    settings.Add("FE.Header.Campaign22", true, "Stormtroupers");
    settings.Add("FE.Header.Campaign23", true, "The Crate Wall");
    settings.Add("FE.Header.Campaign24", true, "Chip Chopper Disaster");
    settings.Add("FE.Header.Campaign25", true, "You Got the Hanger This");
    settings.Add("FE.Header.Campaign26", true, "Blockbuster");
    settings.Add("FE.Header.Campaign27", true, "It’s Nacho’s Fault");
    settings.Add("FE.Header.Campaign28", true, "The Legend of Ro Ping ");
    settings.Add("FE.Header.Campaign29", true, "Crafty Cavern Capers");
    settings.Add("FE.Header.Campaign30", true, "Tsarface");
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
