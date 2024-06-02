// Define the executable and variables
state("Worms W.M.D") {
    // Game is loading (true between the menu and game music playing)
    bool loading : "Worms W.M.D.exe", 0xE0FBA12;

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

    // True when replaying
    bool replay : "Worms W.M.D.exe", 0x00415D8C, 0x0;

    // True when on the results page
    bool resultsPage : "Worms W.M.D.exe", 0xF10388D;
}

init {
    // Whether the first hotseat timer of a level is active
    vars.firstHotseatTimerTriggered = false;

    // Training
    vars.isTraining = false;  // whether we need to handle milliseconds
    vars.lastEnteredLevelTotalMillisecondsPlayed = 0;  // sum of seconds played on the same level, including restarts
    vars.sumOfTurnTimesMs = 0;  // SOTT, sum of turn times
    vars.currentTimerMilliseconds = 0;  // seconds remaining since start or restart of a level
    // bugfix #1: fixes restarting a level sometimes ignores the last game seconds.
    // this temp var keeps the last game timer in memory
    vars.tmpPreviousTimerMilliseconds = 0;

    // Helper vars
    vars.inGame = false;
    vars.comingFromMainMenu = true;
    vars.isFirstLevel = true;
    vars.shouldReset = false;
}

reset {
    if (vars.shouldReset) {
        return true;
    }
}

onReset {
    // Needed as init{} is entered on game launch only
    vars.sumOfTurnTimesMs = 0;
}

// State management
update {
    //// Order of the following conditions matters

    if (current.replay) {
        // Fixes bug where timer would show replay time
        return false;
    }

    if (current.levelTimer < old.levelTimer && vars.inGame
            && !current.replay) {  // fixes bug where game replay triggers a restart)
        print("Current level restarted");

        if (vars.isFirstLevel) {
            vars.shouldReset = true;
        } else {
            // Sum timers
            if (vars.isTraining) {
                if (vars.currentTimerMilliseconds == 0) {
                    // For bugfix #1: use previous timer value when occasionally the previous game timer already reset to 0
                    vars.lastEnteredLevelTotalMillisecondsPlayed += vars.tmpPreviousTimerMilliseconds;
                } else {
                    vars.lastEnteredLevelTotalMillisecondsPlayed += vars.currentTimerMilliseconds;
                }
            }
        }
    }

    // When the mission timer is visible and it just changed
    if (current.displayedTimer != null && current.displayedTimer != old.displayedTimer || vars.shouldReset) {
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
        }
    }

    if (vars.comingFromMainMenu && vars.currentTimerMilliseconds > 0) {
        print("New level started");

        // Set state
        vars.inGame = true;
        vars.comingFromMainMenu = false;
        vars.isFirstLevel = false;
    }

    vars.firstHotseatTimerTriggered = current.playerHotseatTimer && current.playerHotseatTimer != old.playerHotseatTimer;
}

start {
    if (current.displayedTimer != null && vars.firstHotseatTimerTriggered) {
        print("First level started");

        if (vars.shouldReset) {
            vars.shouldReset = false;
        }

        // Set state
        vars.inGame = true;
        vars.comingFromMainMenu = false;
        vars.isFirstLevel = true;

        return true;
    }
}

split {
    if (current.resultsPage && vars.inGame) {
        print("Exited level, split");

        // Sum & reset timers
        if (vars.isTraining) {
            vars.sumOfTurnTimesMs += vars.lastEnteredLevelTotalMillisecondsPlayed
                                  + vars.currentTimerMilliseconds;

            vars.currentTimerMilliseconds = 0;
            vars.lastEnteredLevelTotalMillisecondsPlayed = 0;
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
}

isLoading {
    if (vars.isTraining) {
        // Needed to prevent the timer from flashing (adding 0.01s) when paused
        return true;
    }

    return current.loading;
}
