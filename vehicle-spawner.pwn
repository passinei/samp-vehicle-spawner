#define FILTERSCRIPT

#include <a_samp>

new name[] = "vehicle-spawner";
new version[] = "v1.0.0";
new repoURL[] = "https://github.com/pcmferreira/samp-vehicle-spawner";

new cmdname[] = "/v";

#define COLOR_WHITE 0xFFFFFFFF
#define COLOR_GREEN 0x88FF88FF
#define COLOR_RED 0xFF8888FF

#define LOWEST_MODELID 400
#define HIGHEST_MODELID 611

#define IsValidModelid(%0) ((%0>=LOWEST_MODELID)&&(%0<= HIGHEST_MODELID))

new vehicleNames[HIGHEST_MODELID - LOWEST_MODELID + 1][30] = {
    "Landstalker","Bravura","Buffalo","Linerunner","Perennial","Sentinel","Dumper","Firetruck",
    "Trashmaster","Stretch","Manana","Infernus","Voodoo","Pony","Mule","Cheetah","Ambulance",
    "Leviathan","Moonbeam","Esperanto","Taxi","Washington","Bobcat","Mr. Whoopee","BF Injection",
    "Hunter","Premier","Enforcer","Securicar","Banshee","Predator","Bus","Rhino","Barracks",
    "Hotknife","Article Trailer","Previon","Coach","Cabbie","Stallion","Rumpo","RC Bandit",
    "Romero","Packer","Monster","Admiral","Squallo","Seasparrow","Pizzaboy","Tram",
    "Article Trailer 2","Turismo","Speeder","Reefer","Tropic","Flatbed","Yankee","Caddy","Solair",
    "Topfun Van (Berkley's RC)","Skimmer","PCJ-600","Faggio","Freeway","RC Baron","RC Raider",
    "Glendale","Oceanic","Sanchez","Sparrow","Patriot","Quad","Coastguard","Dinghy","Hermes",
    "Sabre","Rustler","ZR-350","Walton","Regina","Comet","BMX","Burrito","Camper","Marquis",
    "Baggage","Dozer","Maverick","SAN News Maverick","Rancher","FBI Rancher","Virgo","Greenwood",
    "Jetmax","Hotring Racer","Sandking","Blista Compact","Police Maverick","Boxville","Benson",
    "Mesa","RC Goblin","Hotring Racer A","Hotring Racer B","Bloodring Banger","Rancher Lure",
    "Super GT","Elegant","Journey","Bike","Mountain Bike","Beagle","Cropduster","Stuntplane",
    "Tanker","Roadtrain","Nebula","Majestic","Buccaneer","Shamal","Hydra","FCR-900","NRG-500",
    "HPV1000","Cement Truck","Towtruck","Fortune","Cadrona","FBI Truck","Willard","Forklift",
    "Tractor","Combine Harvester","Feltzer","Remington","Slamvan","Blade","Freight (Train)",
    "Brownstreak (Train)","Vortex","Vincent","Bullet","Clover","Sadler","Firetruck LA","Hustler",
    "Intruder","Primo","Cargobob","Tampa","Sunrise","Merit","Utility Van","Nevada","Yosemite"
    ,"Windsor","Monster \"A\"","Monster \"B\"","Uranus","Jester","Sultan","Stratum","Elegy",
    "Raindance","RC Tiger","Flash","Tahoma","Savanna","Bandito","Freight Flat Trailer (Train)",
    "Streak Trailer (Train)","Kart","Mower","Dune","Sweeper","Broadway","Tornado","AT400","DFT-30",
    "Huntley","Stafford","BF-400","Newsvan","Tug","Petrol Trailer","Emperor","Wayfarer","Euros",
    "Hotdog","Club","Freight Box Trailer (Train)","Article Trailer 3","Andromada","Dodo","RC Cam",
    "Launch","Police Car (LSPD)","Police Car (SFPD)","Police Car (LVPD)","Police Ranger","Picador"
    ,"S.W.A.T.","Alpha","Phoenix","Glendale Shit","Sadler Shit","Baggage Trailer \"A\"",
    "Baggage Trailer \"B\"","Tug Stairs Trailer","Boxville","Farm Trailer","Utility Trailer"
};


forward PrintLine(size);
forward SendUsageMsg(playerid);
forward SendSuccessMsg(playerid, modelid);
forward SendFailureMsg(playerid, modelid);
forward VehicleSpawn(playerid, modelid);
forward TryVehicleSpawn(playerid, modelid);

public OnFilterScriptInit() {
    new linesize = max(strlen(repoURL), 22 + strlen(name) + strlen(version));
    printf("");
    PrintLine(linesize);
    printf("Loaded filterscript: %s %s", name, version);
    printf("%s", repoURL);
    PrintLine(linesize);
    printf("");
    return 1;
}

public OnFilterScriptExit() {
    new linesize = max(strlen(repoURL), 24 + strlen(name) + strlen(version));
    printf("");
    PrintLine(linesize);
    printf("Unloaded filterscript: %s %s", name, version);
    printf("%s", repoURL);
    PrintLine(linesize);
    printf("");
    return 1;
}

public PrintLine(size) {
    const maxsize = 100;
    size = min(size, maxsize);
    new line[maxsize + 1];
    for (new i = 0; i < size; ++i) {
        line[i] = '-';
    }
    printf("%s", line);
}

public SendUsageMsg(playerid) {
    new msg[100];
    format(
        msg, sizeof(msg),
        "Usage: %s [modelid]",
        cmdname
    );
    SendClientMessage(playerid, COLOR_WHITE, msg);
    return 1;
}

public SendSuccessMsg(playerid, modelid) {
    if (!IsValidModelid(modelid)) return 0;

    new msg[100];
    format(
        msg, sizeof(msg),
        "Spawned [%d] %s",
        modelid, vehicleNames[modelid - 400]
    );
    SendClientMessage(playerid, COLOR_GREEN, msg);
    return 1;
}

public SendFailureMsg(playerid, modelid) {
    if (!IsValidModelid(modelid)) return 0;

    new msg[100];
    format(
        msg, sizeof(msg),
        "Failed to spawn [%d] %s: vehicle limit reached",
        modelid, vehicleNames[modelid - 400]
    );
    SendClientMessage(playerid, COLOR_RED, msg);
    return 1;
}

public VehicleSpawn(playerid, modelid) {
    new Float:x, Float:y, Float:z, Float:ang;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, ang);

    new vehicleid = AddStaticVehicle(modelid, x, y, z, ang, -1, -1);
    if (vehicleid == INVALID_VEHICLE_ID) return 0;

    PutPlayerInVehicle(playerid, vehicleid, 0);

    return 1;
}

public TryVehicleSpawn(playerid, modelid) {
    if (VehicleSpawn(playerid, modelid)) {
        SendSuccessMsg(playerid, modelid);
    } else {
        SendFailureMsg(playerid, modelid);
    }
    return 1;
}

public OnPlayerCommandText(playerid, cmdtext[]) {
    new cmdtextsize = strlen(cmdtext);

    new cmdsize = cmdtextsize;
    for (new i = 1; i < cmdtextsize; ++i) {
        if (cmdtext[i] == ' ') {
            cmdsize = i;
            break;
        }
    }

    if (cmdsize == strlen(cmdname) && strcmp(cmdtext, "/v", true, cmdsize) == 0) {
        if (cmdsize != cmdtextsize) {
            new param[100];
            strmid(param, cmdtext, cmdsize + 1, cmdtextsize);
            new modelid = strval(param);
            if (modelid == 0 && strcmp(param, "0") != 0) {
                SendUsageMsg(playerid);
            } else if (IsValidModelid(modelid)) {
                TryVehicleSpawn(playerid, modelid);
            } else {
                SendClientMessage(playerid, COLOR_RED, "modelid must be in range [400-611]");
            }
        } else {
            SendUsageMsg(playerid);
        }
        return 1;
    }
    return 0;
}
