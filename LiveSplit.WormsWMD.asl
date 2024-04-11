state("Worms W.M.D") {
	string20 ExtraMission : "Worms W.M.D.exe", 0x0F103548, 0x1BC, 0x1BC, 0x1BC, 0xAAC;
	string20 BonusMission : "Worms W.M.D.exe", 0x0F103548, 0xDC, 0x1BC, 0xDC, 0x1BC, 0xAAC;

	bool MenuOrPaused : "Worms W.M.D.exe", 0x1036752;
}

startup {
	settings.Add("extra_missions", true, "Extra Missions");
	settings.CurrentDefaultParent = "extra_missions";
	settings.Add("FE.Header.Carentan1", true, "War of the Worms");
	settings.Add("FE.Header.Carentan2", true, "Downfall");
	settings.Add("FE.Header.Carentan3", true, "Chateau de Gateau");
	settings.Add("FE.Header.Carentan4", true, "Grieving Private Survivor");
	settings.Add("FE.Header.Carentan5", true, "Final Fury");

	settings.CurrentDefaultParent = null;

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
	if (current.ExtraMission.ToString() == "FE.Header.Carentan1" && !current.MenuOrPaused) {
		print(current.ExtraMission.ToString());
		print(current.MenuOrPaused.ToString());
		
		return settings["FE.Header.Carentan1"];
	}

	if (current.BonusMission.ToString() == "FE.Header.Bonus01" && !current.MenuOrPaused) {
		print(current.BonusMission.ToString());
		print(current.MenuOrPaused.ToString());
		
		return settings["FE.Header.Bonus01"];
	}
}

split {
	if (current.ExtraMission.ToString() != old.ExtraMission.ToString()) {
		print(current.ExtraMission.ToString());
		print(current.MenuOrPaused.ToString());

		return settings[current.ExtraMission.ToString()];
	}

	if (current.BonusMission.ToString() != old.BonusMission.ToString()) {
		print(current.BonusMission.ToString());
		print(current.MenuOrPaused.ToString());

		return settings[current.BonusMission.ToString()];
	}
}

isLoading {
	return current.MenuOrPaused;
}
