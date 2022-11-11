# CS:GO cfg

Osiris's cs go config

## Steam

```
steamID: STEAM_0:0:525522053
steamID3: [U:1:1051044106]
steamID64: 76561199011309834
customURL: http://steamcommunity.com/id/osko_suga
profile: http://steamcommunity.com/profiles/76561199011309834
profile created: December 18th, 2019
name: .
real name: .
location: Ulaanbaatar, Ulaanbaatar, Mongolia
```

## Installation

1. Find your config folder You can find CS:GOs config folder under the path: `<STEAM>\userdata\<YOURID>\730\local\cfg`. For example: `C:\Steam\userdata\525522053\730\local\cfg`.
2. Download - https://github.com/enkhee-osiris/cs/archive/main.zip
3. Extract `main.zip`, then move the contents to your config folder.

## Launch option

```
-novid -freq 240 -tickrate 128 -console +exec autoexec
```

## LAN Game options

### WARMUP

```
mp_startmoney "16000"
sv_cheats "1"
sv_infinite_ammo "1"
sv_grenade_trajectory "1"
mp_roundtime_defuse "60"
ammo_grenade_limit_default "1"
ammo_grenade_limit_flashbang "2"
ammo_grenade_limit_total "4"
mp_freezetime "0"
sv_showimpacts "2"
mp_restartgame "1"
mp_limitteams "0"
mp_autoteambalance "0"
bot_kick all
```

### WARMUP Copiable

```
mp_startmoney "16000"; sv_cheats "1"; sv_infinite_ammo "1"; sv_grenade_trajectory "1"; mp_roundtime_defuse "60"; ammo_grenade_limit_default "1"; ammo_grenade_limit_flashbang "2"; ammo_grenade_limit_total "4"; mp_freezetime "0"; sv_showimpacts "2"; mp_restartgame "1"; mp_limitteams "0"; mp_autoteambalance "0"; bot_kick all
```

### COMPETITIVE

```
game_mode "1"
game_type "0"
exec gamemode_competitive
```
