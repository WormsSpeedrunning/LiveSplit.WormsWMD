// Define the executable and variables
state("Worms W.M.D") {
    // False in main menu, True otherwise (in game, paused, results)
    bool inGame : "Worms W.M.D.exe", 0x0011E7A8, 0x0;

    // Only true when player's turn hotseat timer
    bool playerHotseatTimer : "Worms W.M.D.exe", 0xF10384D;

    // Not the timer the player can see, but a general timer with microseconds precision
    // starting from level load and ending on results page.
    // Only pauses when pausing the game
    float levelTimer : "Worms W.M.D.exe", 0xDCCF090;

    // Training time looks like mm:ss.ms
    string8 displayedTimer: "Worms W.M.D.exe", 0x0F103838, 0x2A8;

    //// Graveyard

    // Doesn't work for everyone
    // // True when it's the current player's turn, but:
    // //      Initially true in the menu
    // //      False when loading the level
    // //      True when the first hotseat timer starts
    // //      False when the CPU hotseat timer starts
    // //      True or false in the results page and main menu depending on who played last
    // bool playerTurn : "Worms W.M.D.exe", 0x0032593C, 0x0;

    // // Works but not needed atm
    // string33 selectedTrainingMission : "Worms W.M.D.exe", 0x0F103540, 0xE8, 0x1C0, 0xDC, 0xAAC;
    // string20 selectedCampaignMission : "Worms W.M.D.exe", 0x0F103540, 0xE8, 0x1C0, 0xDC, 0x1BC, 0xAAC;
    // string21 selectedChallengeMission : "Worms W.M.D.exe", 0x0F10354C, 0xE0, 0xDC, 0x1BC, 0xD8, 0xD8, 0xAAC;
    // string19 selectedExtraMission : "Worms W.M.D.exe", 0x0F103548, 0x1BC, 0x1BC, 0x1BC, 0xAAC;
    // string17 selectedBonusMission : "Worms W.M.D.exe", 0x0F103548, 0xDC, 0x1BC, 0xDC, 0x1BC, 0xAAC;

    // // 1 if inventory open, 2 if paused, 3 if both, 0 otherwise
    // byte paused : "Worms W.M.D.exe", 0x50C342A;

    // // True when replaying
    // bool replay : "Worms W.M.D.exe", 0x00415D8C, 0x0;

    // // True when on the results page
    // bool resultsPage : "Worms W.M.D.exe", 0xF10388D;
}

init {
    // Whether the first hotset timer of a level is active
    vars.firstHotseatTimerTriggered = false;

    // The initial timer for a mission
    vars.missionInitialTotalSeconds = 0;

    // Sum of seconds played on the same level, including restarts
    vars.lastEnteredLevelTotalSecondsPlayed = 0;

    // SOTT, sum of turn times
    vars.sumOfTurnTimes = 0;

    // Seconds played since start or restart of a level
    vars.currentTimerSecondsRemaining = 0;

    // Helper vars
    vars.inGame = false;
    vars.comingFromMainMenu = true;
}

// State management
update {
    //// Order of the following conditions matters

    if (current.levelTimer < old.levelTimer && vars.inGame) {
        print("Current level restarted");

        // Sum timers
        vars.lastEnteredLevelTotalSecondsPlayed += vars.missionInitialTotalSeconds - vars.currentTimerSecondsRemaining;
    }

    // When the mission timer is visible and it just changed
    if (current.displayedTimer != null && current.displayedTimer != old.displayedTimer) {
        string[] splitDuration = current.displayedTimer.Split(':');
        int minutes = Convert.ToInt32(splitDuration[0]);
        int seconds = minutes * 60 + Convert.ToInt32(splitDuration[1]);
        if (seconds > 0) {
            print("Seconds: " + seconds);
            vars.currentTimerSecondsRemaining = seconds;
        }
    }

    if (vars.comingFromMainMenu && vars.currentTimerSecondsRemaining > 0) {
        print("New level started");

        // Init timers
        vars.missionInitialTotalSeconds = vars.currentTimerSecondsRemaining;

        // Set state
        vars.inGame = true;
        vars.comingFromMainMenu = false;
    }

    vars.firstHotseatTimerTriggered = current.playerHotseatTimer && current.playerHotseatTimer != old.playerHotseatTimer;
}

start {
    if (current.displayedTimer != null && vars.firstHotseatTimerTriggered) {
        print("First level started");

        // Init timers
        vars.missionInitialTotalSeconds = vars.currentTimerSecondsRemaining;

        // Set state
        vars.inGame = true;
        vars.comingFromMainMenu = false;

        return true;
    }
}

split {
    if (!current.inGame && vars.inGame) {
        print("Exited level, split");

        // Sum timers
        vars.sumOfTurnTimes += vars.lastEnteredLevelTotalSecondsPlayed
                            + vars.missionInitialTotalSeconds
                            - vars.currentTimerSecondsRemaining;

        // Reset timers
        vars.lastEnteredLevelTotalSecondsPlayed = 0;
        vars.missionInitialTotalSeconds = 0;
        vars.currentTimerSecondsRemaining = 0;

        // Set state
        vars.inGame = false;
        vars.comingFromMainMenu = true;

        return true;
    }
}

gameTime {
    return TimeSpan.FromSeconds(
        vars.sumOfTurnTimes
        + vars.lastEnteredLevelTotalSecondsPlayed
        + vars.missionInitialTotalSeconds
        - vars.currentTimerSecondsRemaining);
}
