Declare Global currentVessel Is Ship.

Function init {
	List Volumes In volumesList.

	Declare Local i Is 0.
	For thisVolume In volumesList {		
		If thisVolume:name <> "archive" {
			Set thisVolume:name To i:toString.
		} 

		Set i to i+1.
	}
}

Function LoadLib {
	Declare Parameter libName.
	Declare Parameter path Is "lib/".
	Declare Parameter run Is True.

	Declare Local destinationVolume is Volume():Name.

	If destinationVolume <>  "Archive" {
		Compile "archive:" + path + libName to destinationVolume + ":" + path + libName + ".ksm".
	}
	
	If run {
		RunOncePath(destinationVolume + ":" + path + libName).
	}
}

Print "--Init lib loaded--".