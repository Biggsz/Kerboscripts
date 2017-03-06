@LAZYGLOBAL OFF.

Function orbit_start {
	Declare Parameter periapsis.
	Declare Parameter apoapsis.
	Declare Parameter wait Is True.

	Print "~~Set Orbit~~".

	If apoapsis > currentVessel:Obt:Apoapsis {
		Lock Steering To ship:Prograde.

		If wait {
			Kuniverse:TimeWarp:WarpTo(time:seconds + Eta:Periapsis - 30).
			Wait Until Eta:Periapsis <= 10.
		}

		Lock Throttle To 1.
		Wait Until currentVessel:Obt:Apoapsis >= apoapsis.
	}
	Else
	{
		Lock Steering To ship:Retrograde.

		If wait {
			Kuniverse:TimeWarp:WarpTo(time:seconds + Eta:Periapsis - 30).
			Wait Until Eta:Periapsis <= 10.
		}

		Lock Throttle To 1.
		Wait Until currentVessel:Obt:Apoapsis <= apoapsis.
	}

	Print "~~Apoapsis set.~~".
	Unlock Throttle.
	Wait 10.

	If periapsis > currentVessel:Obt:Periapsis {
		Lock Steering To ship:Prograde.
		Kuniverse:TimeWarp:WarpTo(time:seconds + Eta:Apoapsis - 30).
		Wait Until Eta:Apoapsis <= 10.
		Lock Throttle To 1.
		Wait Until currentVessel:Obt:Periapsis >= periapsis.
	}
	Else
	{
		Lock Steering To ship:Retrograde.
		Kuniverse:TimeWarp:WarpTo(time:seconds + Eta:Apoapsis - 30).
		Wait Until Eta:Apoapsis <= 10.
		Lock Throttle To 1.
		Wait Until currentVessel:Obt:Periapsis <= periapsis.
	}

	Unlock Throttle.	

	Print "~~Orbit : done~~".
}