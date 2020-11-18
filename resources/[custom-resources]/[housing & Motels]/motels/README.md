# Installation

1. Drag the motels folder into your resource directory.
2. Consider renaming the folder (and possibly filenames).
3. If a sql file is provided, import it to your database.
4. Check the config for things you might want to change.
5. Make sure you set your order number in the config.
6. Overwrite the property.lua found in esx_inventoryhud/client with the one provided.
7. If you're using esx_kashacters, add the sql tables into the kashacters server.lua.
  * {table = "playermotels",                column = "owner"},
  * {table = "playermotels_homeinventory",  column = "owner"},
8. Re-read the previous steps and make sure you done them.
9. Start the mod in your server.cfg

The mod will request authentication from our server before
you're able to use it. It should take no longer then 12 hours to be authorized.



# Requirements

- ESX
- esx_inventoryhud
- cron
- mysql-async
- mythic_interiors
- vSync
  * Optional, can use alternative.
  * If using vSync, use the one provided. Has some additional events that are used for motels.
  * Change corresponding code yourself, just ctrl+f vSync in client.lua to figure out what its doing).



# Notes

- Don't try changing the home motel after you've set it initially.
  * Doing so will mess with player inventories.
  * Make sure you know which motel you want as your hub before you let players on.
- If you don't want to spawn at the home motel on login, disable it in the config.

