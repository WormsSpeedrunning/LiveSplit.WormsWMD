state("Worms W.M.D") {
	string20 Mission : "Worms W.M.D.exe", 0x0F103548, 0xDC, 0x1BC, 0xDC, 0x1BC, 0xAAC;
}

startup {
	settings.Add("FE.Header.Bonus01", true, "Start on entering bonus level 1.");
	for (int i = 2; i <= 7; i++) {
		settings.Add("FE.Header.Bonus0"+i, true, "Split on entering bonus level "+i+".");
	}
}

start {
	if (current.Mission.ToString() == "FE.Header.Bonus01") {
		print(current.Mission.ToString());
		return settings["FE.Header.Bonus01"];
	}
}

split {
	if (current.Mission.ToString() != old.Mission.ToString()) {
		print(current.Mission.ToString());
		return settings[current.Mission.ToString()];
	}
}
