//checklist before launch

@LAZYGLOBAL OFF.

Function check_deltaV {
	Declare Parameter requiredDeltaV.
	Declare Parameter launching Is False.

	Declare Local requiredDeltaVVWithMargin is requiredDeltaV * 1.1.
	Declare Local actualDeltaV is 0.

	Set actualDeltaV To calculateDeltaV(launching).

	Return actualDeltaV >= requiredDeltaVVWithMargin.
}

Function check_start {
	Declare Parameter deltaV Is 1000.

	Print "~~Checklist~~".

	If not check_deltaV(deltaV, True) {
		Print "DeltaV Failed".
		Return False.
	}

	Return True.
}

Print "--Checklist lib loaded--".