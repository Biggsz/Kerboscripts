@LAZYGLOBAL OFF.

Function isEngineStage {
	Declare Parameter stageNumber.

	Declare Local enginesList IS List().
	List Engines In enginesList.

	For engine In enginesList {
		If engine:Stage = stageNumber {
			Return True.
		}			
	}

	Return False.
}

Function getNextEngineStage {
	Declare Parameter stageNumber.

	Declare Local enginesList Is List().
	List Engines In enginesList.

	From {Local i is stageNumber-1.} Until i = -2 STEP {Set i to i-1.} Do {
		For engine In enginesList {
			If engine:stage = i {
				Return i.
			}
		}
	}

	Return -2.
}

Function getStageIsp {
	Declare Parameter stageNumber.
	Declare Parameter pressure IS 1.

	Declare Local thrustSum Is 0.
	Declare Local thrustByIspSum Is 0.
	Declare Local enginesList IS List().
	List Engines In enginesList.

	For engine In enginesList {
		If engine:Stage = stageNumber {
			Declare Local availableThust Is engine:AvailableThrustAt(pressure).
			Set thrustSum To thrustSum + availableThust.
			Set thrustByIspSum To availableThust / engine:IspAt(pressure).
		}
	}

	Return thrustSum / thrustByIspSum.
}


Function getStageMass{
	Declare Parameter stageNumber.

	Declare Local mass Is 0. 
	Declare Local partsList Is List().
	List Parts In partsList.

	For part In partsList {
		If part:Stage <= stageNumber {
			Set mass to mass + part:Mass.
		}
	}

	return mass.
}

Function getStageDryMass{
	Declare Parameter stageNumber.

	Declare Local stageLimit is 0.
	Declare Local mass Is 0.
	Declare Local partsList Is List().
	List Parts In partsList.

	Set stageLimit To getNextEngineStage(stageNumber).

	FOR part In partsList {
		If part:Stage <= stageNumber {
			Declare Local addFullMass Is True.

			If part:Stage > stageLimit {				
				For resource In part:resources {
					If resource:Name = "Oxidizer" Or resource:Name = "LiquidFuel" {
						Set addFullMass To False.
						Set mass To mass + part:DryMass.
						Break.
					}
				}
			}

			If addFullMass {
				Set mass To mass + part:Mass.
			}
		}
	}

	return mass.
}

Function calculateDeltaV {
	Declare Parameter launching IS False.

	Declare Local currentVessel Is Ship.
	Declare Local enginesList IS List().
	Declare Local numberOfStages IS Stage:Number.

	List Engines In enginesList.

	From {Local i is numberOfStages.} Until i = -1 STEP {Set i to i-1.} Do {		

		If isEngineStage(i) {
			Declare Local currentDeltaV Is 9.81 * getStageIsp(i) * Ln(getStageMass(i) / getStageDryMass(i)).

			If launching {
				Declare Local vacuumDeltaV Is 9.81 * getStageIsp(i,0) * Ln(getStageMass(i) / getStageDryMass(i)).
				Return ((currentDeltaV - 1000) / currentDeltaV) * vacuumDeltaV + 1000.
			}
			Else {
				Return currentDeltaV.
			}
		}
	}
}

Print "--Misc lib loaded--".