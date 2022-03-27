#! /bin/bash
#
# A Garry's mod docker server startup and configuratin script 
#
# Prerequisites:
# -Docker installed and running




# This lets the script know the current settings by importing data from "startconf" file
SNAME="$(sed -n 1p startconf)"
SPORT="$(sed -n 2p startconf)"
SPASS="$(sed -n 3p startconf)"
RPASS="$(sed -n 4p startconf)"
SPLAYERCOUNT="$(sed -n 5p startconf)"
STICK="$(sed -n 6p startconf)"
LAN="$(sed -n 7p startconf)"
STOKEN="$(sed -n 8p startconf)"
SMODE="$(sed -n 9p startconf)"
SMAP="$(sed -n 10p startconf)"
WSHOP="$(sed -n 11p startconf)"
SRAM="$(sed -n 12p startconf)"
clear


# The config update function, updates the config with the current variables when called for
function update_conf() {
    [ -n "$SNAME" ] && sed -i 1s/.*/"$SNAME"/ startconf 
    [ -n "$SPORT" ] && sed -i 2s/.*/"$SPORT"/ startconf
    [ -n "$SPASS" ] && sed -i 3s/.*/"$SPASS"/ startconf
    [ -z "$SPASS" ] && sed -i 3s/.*/"$SPASS"/ startconf
    [ -n "$RPASS" ] && sed -i 4s/.*/"$RPASS"/ startconf
    [ -z "$RPASS" ] && sed -i 4s/.*/"$RPASS"/ startconf
    [ -n "$SPLAYERCOUNT" ] && sed -i 5s/.*/"$SPLAYERCOUNT"/ startconf
    [ -n "$STICK" ] && sed -i 6s/.*/"$STICK"/ startconf
    [ -n "$LAN" ] && sed -i 7s/.*/"$LAN"/ startconf 
    [ -n "$STOKEN" ] && sed -i 8s/.*/"$STOKEN"/ startconf
    [ -z "$STOKEN" ] && sed -i 8s/.*/"$STOKEN"/ startconf 
    [ -n "$SMODE" ] && sed -i 9s/.*/"$SMODE"/ startconf 
    [ -n "$SMAP" ] && sed -i 10s/.*/"$SMAP"/ startconf 
    [ -n "$WSHOP" ] && sed -i 11s/.*/"$WSHOP"/ startconf
    [ -z "$WSHOP" ] && sed -i 11s/.*/"$WSHOP"/ startconf
    [ -n "$SRAM" ] && sed -i 12s/.*/"$SRAM"/ startconf 
    echo start up config has been updated.
    }


function server_start(){
    LUNCH_PARAM="/home/steam/SteamCMD/gmod/srcds_run -console +hostname "$SNAME" +sv_password "$SPASS" +rcon_password "$RPASS"  +maxplayers "$SPLAYERCOUNT" +gamemode "$SMODE" +map "$SMAP" -tickrate "$STICK" +sv_lan "$LAN" +sv_setsteamaccount "$STOKEN" +host_workshop_collection "$WSHOP""
    (sudo docker run -it --rm -p $SPORT:27005 --memory="$SRAM"m --memory-swap="$SRAM"m -v $(pwd)/"server data"/cfg:/home/steam/SteamCMD/gmod/garrysmod/cfg -v $(pwd)/"server data"/addons:/home/steam/SteamCMD/gmod/garrysmod/addons -v $(pwd)/"server data"/data:/home/steam/SteamCMD/gmod/garrysmod/data --name gmod_server bareq/steamcmd:gmod su -c "$LUNCH_PARAM" steam) 2>&1 | tee -a ./"server data"/runtime.log
}
# The first time start up setup
function new_setup() {
    echo "Starting setup..."
    mkdir ./"server data"
    mkdir ./"server data"/addons
    mkdir ./"server data"/cfg
    mkdir ./"server data"/data
    echo "Docker GMOD" > ./startconf
    echo "27015" >> ./startconf
    echo "" >> ./startconf
    echo "admin" >> ./startconf
    echo "16" >> ./startconf
    echo "128" >> ./startconf
    echo "1" >> ./startconf
    echo "" >> ./startconf
    echo "sandbox" >> ./startconf
    echo "gm_construct" >> ./startconf
    echo "" >> ./startconf
    echo "2048" >> ./startconf
    
    echo "Choose hostname"
    echo "default: Docker GMOD"
    read -p ":" SNAME ;

    echo "Choose port"
    echo "default: 27015"
    read -p ":" SPORT ;

    echo "Choose a password for the server"
    echo "default is no password"
    read -p ":" SPASS ;
    
    echo "Choose rcon password"
    echo "default: admin"
    read -p ":" RPASS ;

    echo "Choose player count"
    echo "default: 16"
    read -p ":" SPLAYERCOUNT ;

    echo "Choose if this server gonna be LAN or online"
    echo "type 1 for LAN or 0 for online"
    echo "default: 1"
    read -p ":" LAN ;

    echo "Choose tickrate"
    echo "default: 128"
    read -p ":" STICK ;

    echo "Choose steam token (required for online)"
    echo "default: no token (local server)"
    read -p ":" STOKEN ;

    echo "Choose gamemode"
    echo "default: sandbox"
    read -p ":" SMODE ;

    echo "Choose map"
    echo "default: gm_construct"
    read -p ":" SMAP

    echo "Choose workshop collectin id"
    echo "If you want to import mods from collection"
    read -p ":" WSHOP

    echo "Choose how much ram to allocate to the server in megabytes"
    echo "default: 2048"
    read -p ":" SRAM
    update_conf
    start_menu
    }


function update_image(){
    echo: "Starting update process.."
    sudo docker pull bareq/steamcmd:gmod
}


# The main menu
function start_menu() {
    clear
    PS3='Choose option: '
    MODES=("Start server" "Update" "Change settings" "Quit")
    select OPTION in "${MODES[@]}"; do
    case $OPTION in
        "Start server")
            
            echo "Starting up..."
            server_start
	    # call startup function
            ;;
        "Update")
            
            echo "Starting the update service..."
	    # call update function
            ;;
        "Change settings")
            
            settings_menu
	    # call settings menu
	    break
            ;;
	"Quit")
        clear
	    echo "User requested exit"
	    exit
	    ;;
        *) echo "invalid option $REPLY";;
    esac
    done
 }

#The menu for settings, where you can change start up config
function settings_menu() {
    clear
    echo "Current start up config:"
    echo ""
    echo "Hostname          :$(sed -n 1p startconf)"
    echo "Server port       :$(sed -n 2p startconf)"
    echo "Server password   :$(sed -n 3p startconf)"
    echo "Admin password    :$(sed -n 4p startconf)"
    echo "Player count      :$(sed -n 5p startconf)"
    echo "Tickrate          :$(sed -n 6p startconf)"
    echo "LAN mode          :$(sed -n 7p startconf)"
    echo "Steam Token       :$(sed -n 8p startconf)"
    echo "Gamemode          :$(sed -n 9p startconf)"
    echo "Map               :$(sed -n 10p startconf)"
    echo "Workshop id       :$(sed -n 11p startconf)"
    echo "Memory            :$(sed -n 12p startconf)"
    echo ""
    echo "Choose the setting you want to change: "
    PS3='Choose setting: '
    SETTING=("Hostname" "Server port" "Server password" "Admin password" "Player count" "Tickrate" "LAN mode" "Steam token" "Gamemode" "Map" "Workshop id" "Memory" "Load defaults" "Exit this menu")
    select CHANGE in "${SETTING[@]}"; do
    case $CHANGE in
    "Hostname")
        echo Current:$(sed -n 1p startconf)
        read -p "New: " SNAME && update_conf && settings_menu
        ;;
    "Server port")
        echo Current:$(sed -n 2p startconf)
        read -p "New: " SPORT && update_conf && settings_menu
        ;;
    "Server password")
        echo Current:$(sed -n 3p startconf)
        read -p "New: " SPASS && update_conf && settings_menu
        ;;
    "Admin password")
        echo Current:$(sed -n 4p startconf)
        read -p "New: " RPASS && update_conf && settings_menu
        ;;
    "Player count")
        echo Current:$(sed -n 5p startconf)
        read -p "New: " SPLAYERCOUNT && update_conf && settings_menu
        ;;
    "Tickrate")
        echo Current:$(sed -n 6p startconf)
        read -p "New: " STICK && update_conf && settings_menu
        ;;
    "LAN mode")
        echo Current:$(sed -n 7p startconf)
        read -p "New: " LAN && update_conf && settings_menu
        ;;
    "Steam token")
        echo Current:$(sed -n 8p startconf)
        read -p "New: " STOKEN && update_conf && settings_menu
        ;;
    "Gamemode")
        echo Current:$(sed -n 9p startconf)
        read -p "New: " SMODE && update_conf && settings_menu
        ;;
    "Map")
        echo Current:$(sed -n 10p startconf)
        read -p "New: " SMAP && update_conf && settings_menu
        ;;
    "Workshop id")
        echo Current:$(sed -n 11p startconf)
        read -p "New: " WSHOP && update_conf && settings_menu
        ;;
    "Memory")
        echo Current:$(sed -n 12p startconf)
        read -p "New: " SRAM && update_conf && settings_menu
        ;;
    "Load defaults")
        SNAME="Docker GMOD" ; SPORT="27015" ; SPASS="" ; RPASS="admin" ; SPLAYERCOUNT="16" ; STICK="128" ; LAN="1" ; STOKEN="" ; SMODE="sandbox" ; SMAP="gm_construct" ; WSHOP="" ; SRAM="2048" ; update_conf ; settings_menu
        ;;
    "Exit this menu")
    clear
    start_menu
     ;;
    *) echo "invalid option, please choose a setting number or type 11 to exit settings menu";;
    esac
    done
    }


# Start up
 if [ -f $(pwd)/startconf ]
 then
   echo "start up config has been found"
   echo "starting up..."
   start_menu
 else 
   echo "server config not found"
   read -p "start new setup? y/n" ANSWER
   case "$ANSWER" in
   [nN] | [nN][oO])
   echo "exiting..."
   ;;
   *)
   new_setup
   ;;
   esac
 fi
