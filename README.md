# wld-jailer
 A simple stand alone jail script for FiveM made with lua. This jailer script nativally runs on ace perms. There are alot of check and balances including: adding time for a excape attempt, changing clothing, deleting ped weapons, and deleting vehicles.
# Installation
 1. First, download and extract the lastest release to your resources folder. 
 2. Next, modify the config.lua to meet the needs of your server.
 3. Then, add `start wld-jailer` to your server.cfg.
 4. Finally, add ace permissions to your cfg file for people to use the commands.
 ```
 add_ace identifier.steam:STEAM_ID_HERE command.jail allow
 add_ace identifier.steam:STEAM_ID_HERE command.unjail allow
 ```
 or
 ```
 add_ace group.cop command.jail allow
 add_ace group.cop command.unjail allow
 add_principal identifier.steam:STEAM_ID_HERE group.cop
 ```
