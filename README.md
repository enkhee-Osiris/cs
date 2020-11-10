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

## Launch option

```
-novid -freq 144 -tickrate 128 -console +exec autoexec
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
mp_startmoney "16000";sv_cheats "1";sv_infinite_ammo "1";sv_grenade_trajectory "1";mp_roundtime_defuse "60";ammo_grenade_limit_default "1";ammo_grenade_limit_flashbang "2";ammo_grenade_limit_total "4";mp_freezetime "0";sv_showimpacts "2";mp_restartgame "1";mp_limitteams "0";mp_autoteambalance "0";bot_kick all;
```

### COMPETITIVE

```
game_mode "1"
game_type "0"
exec gamemode_competitive
```

## In Game options

```
voice_mixer_volume "0.5"

snd_mixahead "0.05"
snd_headphone_pan_exponent "2"
snd_musicvolume "0.0"
snd_tensecondwarning_volume "0.04"

cl_cmdrate "128"
cl_updaterate "128"
rate "786432"
cl_interp "1"
cl_interp_ratio "2"

m_rawinput "1"
m_mouseaccel1 "0"
m_mouseaccel2 "0"

r_drawtracers_firstperson "0"
cl_autowepswitch "0"
hud_showtargetid "1"
hud_scaling "0.95"
fps_max "700"
cl_autohelp "0"
cl_showhelp "0"

net_graph "0"
net_graphpos "2"
```

## Anti-Young

```
hud_showtargetid "0"
cl_hide_avatar_images "1"
cl_sanitize_player_names "1"
```

### Copyable

```
hud_showtargetid "0";cl_hide_avatar_images "1";cl_sanitize_player_names "1";
```
