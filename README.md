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

Why docker ?
1. Docker image will include all the required basic dependencies.
2. Everything is is presetup and ready to run within few clicks
3. Personal config files and mods are stored outside of docker, which means you can update, downgrade and experiment with different versions of the server without having to worry about personal configs.
4. Migrating to different compute server is much easier.


What next ?
This was more of small proof of concept I might make a script with support for more games, ability to install CSGO, TF2..etc within the same script for easy deployment.
