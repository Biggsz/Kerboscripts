@LAZYGLOBAL OFF.

RunOncepath("archive:lib/init.ks").
init().

loadLib("misc").
loadLib("launch").
loadLib("orbit").
loadLib("land").

launch_start().
orbit_start(4583478,5560144).
Wait 30.
land_start().