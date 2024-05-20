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

    // Bugfix #1: fixes restarting a level sometimes ignores the last game seconds
    // This temp var keeps the last game timer in memory
    vars.tmpPreviousTimerSecondsRemaining = 0;
    vars.tmpPreviousTimerMilliseconds = 0;  // training

    // Whether we need to handle milliseconds
    vars.isTraining = false;

    // Helper vars
    vars.inGame = false;
    vars.comingFromMainMenu = true;
}

onReset {
    // Needed as init{} is entered on game launch only
    vars.sumOfTurnTimes = 0;
    vars.sumOfTurnTimesMs = 0;
}

// State management
update {
    //// Order of the following conditions matters

    if (current.levelTimer < old.levelTimer && vars.inGame) {
        print("Current level restarted");

        // Sum timers
        if (vars.isTraining) {
            if (vars.currentTimerMilliseconds == 0) {
                // For bugfix #1: use previous timer value when occasionally the previous game timer already reset to 0
                vars.lastEnteredLevelTotalMillisecondsPlayed += vars.tmpPreviousTimerMilliseconds;
            } else {
                vars.lastEnteredLevelTotalMillisecondsPlayed += vars.currentTimerMilliseconds;
            }
        } else {
            if (vars.currentTimerSecondsRemaining == vars.missionInitialTotalSeconds) {
                // For bugfix #1: use previous timer value when occasionally the previous game timer already reset to 0
                vars.lastEnteredLevelTotalSecondsPlayed += vars.missionInitialTotalSeconds - vars.tmpPreviousTimerSecondsRemaining;
            } else {
                vars.lastEnteredLevelTotalSecondsPlayed += vars.missionInitialTotalSeconds - vars.currentTimerSecondsRemaining;
            }
        }
    }

    // When the mission timer is visible and it just changed
    if (current.displayedTimer != null && current.displayedTimer != old.displayedTimer) {
        string displayedTimer = current.displayedTimer;
        double milliseconds = -1;

        vars.isTraining = displayedTimer.IndexOf('.') != -1 && (
            current.selectedTrainingMission.Contains("Basic") ||
            current.selectedTrainingMission.Contains("Training") ||
            current.selectedTrainingMission.Contains("Advanced"));

        if (vars.isTraining) {
            string[] splitDurationMs = displayedTimer.Split('.');
            milliseconds = Convert.ToInt32(splitDurationMs[1]);
            displayedTimer = splitDurationMs[0];
        }

        string[] splitDuration = displayedTimer.Split(':');
        int minutes = Convert.ToInt32(splitDuration[0]);
        int seconds = minutes * 60 + Convert.ToInt32(splitDuration[1]);

        if (vars.isTraining && milliseconds != -1) {
            milliseconds *= 10;
            milliseconds += 1000 * seconds;
            vars.tmpPreviousTimerMilliseconds = vars.currentTimerMilliseconds;  // bugfix #1: keep previous timer value
            vars.currentTimerMilliseconds = milliseconds;
        } else if (seconds > 0) {
            vars.tmpPreviousTimerSecondsRemaining = vars.currentTimerSecondsRemaining;  // bugfix #1: keep previous timer value
            vars.currentTimerSecondsRemaining = seconds;
        }
    }

    if (vars.comingFromMainMenu && (vars.currentTimerSecondsRemaining > 0 || vars.currentTimerMilliseconds > 0)) {
        print("New level started");

        // Init timers
        if (!vars.isTraining) {
            vars.missionInitialTotalSeconds = vars.currentTimerSecondsRemaining;
        }

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
        if (!vars.isTraining) {
            vars.missionInitialTotalSeconds = vars.currentTimerSecondsRemaining;
        }

        // Set state
        vars.inGame = true;
        vars.comingFromMainMenu = false;

        return true;
    }
}

split {
    if (!current.inGame && vars.inGame) {
        print("Exited level, split");

        // Sum & reset timers
        if (vars.isTraining) {
            vars.sumOfTurnTimesMs += vars.lastEnteredLevelTotalMillisecondsPlayed
                                  + vars.currentTimerMilliseconds;

            vars.currentTimerMilliseconds = 0;
            vars.lastEnteredLevelTotalMillisecondsPlayed = 0;
        } else {
            vars.sumOfTurnTimes += vars.lastEnteredLevelTotalSecondsPlayed
                                + vars.missionInitialTotalSeconds
                                - vars.currentTimerSecondsRemaining;

            vars.missionInitialTotalSeconds = 0;
            vars.lastEnteredLevelTotalSecondsPlayed = 0;
            vars.currentTimerSecondsRemaining = 0;
        }

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

isLoading {
    // Needed to prevent the timer from flashing (adding 0.01s) when paused
    return true;
}
