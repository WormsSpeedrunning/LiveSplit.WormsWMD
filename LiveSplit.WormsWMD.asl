// Define the executable and variables
state("Worms W.M.D") {
    string21 SelectedChallengeMission : "Worms W.M.D.exe", 0x0F10354C, 0xE0, 0xDC, 0x1BC, 0xD8, 0xD8, 0xAAC;
    string19 SelectedExtraMission : "Worms W.M.D.exe", 0x0F103548, 0x1BC, 0x1BC, 0x1BC, 0xAAC;
    string17 SelectedBonusMission : "Worms W.M.D.exe", 0x0F103548, 0xDC, 0x1BC, 0xDC, 0x1BC, 0xAAC;
    
    // Variable to check if the game is paused
    bool MenuOrPaused : "Worms W.M.D.exe", 0x1036752;
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
    if (!current.MenuOrPaused) {
        if (current.SelectedBonusMission.ToString() == "FE.Header.Bonus01") {
            // Selected bonus mission is the first mission and the game is not paused
            print(current.SelectedBonusMission.ToString());        
            return settings["FE.Header.Bonus01"];
        }
    }

    if (!current.MenuOrPaused) {
        if (current.SelectedChallengeMission.ToString() == "FE.Header.Challenge01") {
            // Selected challenge mission is the first mission and the game is not paused
            print(current.SelectedChallengeMission.ToString());        
            return settings["FE.Header.Challenge01"];
        }
    }

    if (!current.MenuOrPaused) {
        if (current.SelectedExtraMission.ToString() == "FE.Header.Carentan1") {
            // Selected extra mission is the first mission and the game is not paused
            print(current.SelectedExtraMission.ToString());        
            return settings["FE.Header.Carentan1"];
        }
    }
}

split {
    // If the selected bonus mission changed, split
    if (current.SelectedBonusMission.ToString() != old.SelectedBonusMission.ToString()) {
        print(current.SelectedBonusMission.ToString());
        return settings[current.SelectedBonusMission.ToString()];
    }

    // If the selected challenge mission changed, split
    if (current.SelectedChallengeMission.ToString() != old.SelectedChallengeMission.ToString()) {
        print(current.SelectedChallengeMission.ToString());
        return settings[current.SelectedChallengeMission.ToString()];
    }

    // If the selected extra mission changed, split
    if (current.SelectedExtraMission.ToString() != old.SelectedExtraMission.ToString()) {
        print(current.SelectedExtraMission.ToString());
        return settings[current.SelectedExtraMission.ToString()];
    }
}

isLoading {
    // Return true if the game is paused or in the menu
    return current.MenuOrPaused;
}