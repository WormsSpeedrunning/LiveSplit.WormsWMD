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

    // Current training mission name if selected
    string33 selectedTrainingMission : "Worms W.M.D.exe", 0x0F103540, 0xE8, 0x1C0, 0xDC, 0xAAC;
}

init {
    // Whether the first hotseat timer of a level is active
    vars.firstHotseatTimerTriggered = false;

    // The initial timer for a mission
    vars.missionInitialTotalSeconds = 0;

    // Sum of seconds played on the same level, including restarts
    vars.lastEnteredLevelTotalSecondsPlayed = 0;
    vars.lastEnteredLevelTotalMillisecondsPlayed = 0;  // training

    // SOTT, sum of turn times
    vars.sumOfTurnTimes = 0;
    vars.sumOfTurnTimesMs = 0;  // training

    // Seconds remaining since start or restart of a level
    vars.currentTimerSecondsRemaining = 0;
    vars.currentTimerMilliseconds = 0;  // training

    // Whether we need to handle milliseconds
    vars.isTraining = false;

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
        if (vars.isTraining) {
            vars.lastEnteredLevelTotalMillisecondsPlayed += vars.currentTimerMilliseconds;
        } else {
            vars.lastEnteredLevelTotalSecondsPlayed += vars.missionInitialTotalSeconds - vars.currentTimerSecondsRemaining;
        }
    }

    // When the mission timer is visible and it just changed
    if (current.displayedTimer != null && current.displayedTimer != old.displayedTimer) {
        string displayedTimer = current.displayedTimer;
        double milliseconds = -1;

        if (displayedTimer.IndexOf('.') != -1 && (
            current.selectedTrainingMission.Contains("Basic")
            || current.selectedTrainingMission.Contains("Training")
            || current.selectedTrainingMission.Contains("Advanced"))) {
            vars.isTraining = true;
            string[] splitDurationMs = displayedTimer.Split('.');
            milliseconds = Convert.ToInt32(splitDurationMs[1]);
            displayedTimer = splitDurationMs[0];
        } else {
            vars.isTraining = false;
        }

        string[] splitDuration = displayedTimer.Split(':');
        int minutes = Convert.ToInt32(splitDuration[0]);
        int seconds = minutes * 60 + Convert.ToInt32(splitDuration[1]);

        if (vars.isTraining && milliseconds != -1) {
            milliseconds *= 10;
            milliseconds += 1000 * seconds;
            vars.currentTimerMilliseconds = milliseconds;
        } else if (seconds > 0) {
            vars.currentTimerSecondsRemaining = seconds;
        }
    }

    if (vars.comingFromMainMenu && (vars.currentTimerSecondsRemaining > 0 || vars.currentTimerMilliseconds > 0)) {
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
        if (vars.isTraining) {
            vars.sumOfTurnTimesMs += vars.lastEnteredLevelTotalMillisecondsPlayed
                                  + vars.currentTimerMilliseconds;
        } else {
            vars.sumOfTurnTimes += vars.lastEnteredLevelTotalSecondsPlayed
                                + vars.missionInitialTotalSeconds
                                - vars.currentTimerSecondsRemaining;
        }

        // Reset timers
        vars.missionInitialTotalSeconds = 0;
        vars.lastEnteredLevelTotalSecondsPlayed = 0;
        vars.currentTimerSecondsRemaining = 0;
        vars.currentTimerMilliseconds = 0;
        vars.lastEnteredLevelTotalMillisecondsPlayed = 0;

        // Set state
        vars.inGame = false;
        vars.comingFromMainMenu = true;

        return true;
    }
}

gameTime {
    if (vars.isTraining) {
        return TimeSpan.FromMilliseconds(
            vars.sumOfTurnTimesMs
            + vars.lastEnteredLevelTotalMillisecondsPlayed
            + vars.currentTimerMilliseconds);
    }

    return TimeSpan.FromSeconds(
        vars.sumOfTurnTimes
        + vars.lastEnteredLevelTotalSecondsPlayed
        + vars.missionInitialTotalSeconds
        - vars.currentTimerSecondsRemaining);
}
