@LAZYGLOBAL OFF.

loadLib("checklist").

Declare Global currentThrottle is 1.

function getAscendingThrottle {
	Declare Parameter EtaToKeep.
	Declare Parameter MinThrust Is True.

	Declare Local ascendingThrottle IS 0.

	Set ascendingThrottle To Round((EtaToKeep / Eta:Apoapsis) * Max(CurrentThrottle,0.01),2).

	If minThrust {
		Set currentThrottle To Max(ascendingThrottle,0.1).
	}
	Else {
		Set currentThrottle To ascendingThrottle.
	}


	Return currentThrottle.
}

function launch_leaveAtmo {

	Print "~~Leaving Atmosphere~~".
	Lock Throttle To 1.0.
	Lock Steering To Heading(90,90).	

	WAIT UNTIL currentVessel:VerticalSpeed >= 100.

	Print "Begin Gravity Turn...".

	Lock Steering To Heading(90,70).

	WAIT 10.

	Print "Aligh to Prograde...".

	Lock Steering To currentVessel:Velocity:Surface.	

	Wait Until Eta:Apoapsis > 50.

	Set Warp to 3.

	Lock Throttle To getAscendingThrottle(50).

	When currentVessel:Altitude >= 36000 Then {
		Lock Steering To currentVessel:Velocity:Orbit.
	}	

	Until currentVessel:Obt:Apoapsis >= 71000
	{
		Wait Until currentVessel:Obt:Apoapsis >= 71000 Or currentVessel:MaxThrust = 0.
		If currentVessel:MaxThrust = 0 {
			Stage.
		}
	}

	Unlock Throttle.

	Print "~~Apoapsis >= 71000~~".	
	Set Warp To 0.
}

function launch_circularize {
	Print "~~Circularize~~".

	Set Warp To 3.

	Until ETA:Apoapsis <= 30 {
		Wait Until ETA:Apoapsis <= 30 or currentVessel:Obt:Apoapsis < 71000.
		If currentVessel:Obt:Apoapsis < 71000 {
			Set Warp To 0.
			Lock Steering To currentVessel:Velocity:Orbit.
			Lock Throttle To 0.1.
			Wait Until currentVessel:Obt:Apoapsis >= 71000.
			Unlock Throttle.
			Set Warp To 3.
		}
	}

	Set Warp To 0.

	Lock Throttle To getAscendingThrottle(10,False).

	Wait Until currentVessel:Obt:Periapsis >= 70000.

	Unlock Throttle.

	Print "~~Circularize done~~".
}

function launch_start{
	SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.
	Stage.
	If check_start() {
		launch_leaveAtmo().
		launch_circularize().
	}	
}

Print "--Launch lib loaded--".