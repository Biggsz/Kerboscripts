Print "--Init com--".

Declare Global currentVessel Is Core:Vessel.
Declare Local dish Is currentVessel:PartsTitled("Reflectron KR-7")[0]:GetModule("ModuleRTAntenna").
dish:DoEvent("activate").
dish:SetField("target",Kerbin).