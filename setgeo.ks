@LAZYGLOBAL OFF.

RunOncepath("archive:lib/init.ks").
init().

loadLib("misc").
loadLib("launch").
loadLib("orbit").
loadLib("initcom","boot/",False).

launch_start().
Wait Until Round(currentVessel:GEOPOSITION:LNG) = -165.
orbit_start(2863334.06,2863334.06,False).

RunOncePath("boot/initcom").
Set Core:BootFileName To "initcom.ks".