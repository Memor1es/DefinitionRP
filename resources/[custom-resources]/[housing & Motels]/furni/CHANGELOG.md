# 23/12/2019
Added furni.neverGrab table to the top of client.lua
Add hash values in there to avoid grabbing said models while in delete/move mode.

Also removed a few controls from disablecontrols.lua, that stopped esx menu activity (wardrobe, mostly..)

# 2/01/2020
New dependency required. Check readme.md
UI now invisible while not in use (instead of low opacity).
Fixed UI appearing briefly on client login.

# 2/02/2020
Added support for Native Housing mod.
Set Config.UsingNativeHousing = true if you're using NativeHousing instead of PlayerHousing.

# 3/03/2020
Added alternate SQL table to save to in config.lua (SaveToTable var)
If not using playerhousing for some reason, and wanting to save furniture to an alternate table in the database, use this var.
Set it to your database table name.
NOTE: Will still save under "furniture" column.