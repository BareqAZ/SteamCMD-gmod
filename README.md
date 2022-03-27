# SteamCMD-gmod
Interactive bash script to run Garry's mod server in docker


This requires docker to be installed and the docker daemon running.

How to use:
1. Create a folder and place start.sh inside (start.sh will create folders and files)
2. It will ask you for server values such as "Hostname, RAM, Port..etc" you can just press enter for default value
3. Choose update, this will download the latest gmod server docker image
4. And start

if you have any addons/mods or cfg files you can place them in their respective folders inside "server data"
it's recommended to create custom server.cfg file and place it inside "server data/cfg"
server.cfg file will let you set complex names and advanced server settings.
the server will prefer server.cfg settings instead of the start up settings set by the script.
