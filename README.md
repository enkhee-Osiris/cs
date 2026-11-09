# Osiris's Counter-Strike 2 config

Based on the [osko CS2 profile on Settings.gg](https://settings.gg/user/1051044106/cs2). The autoexec uses 1.04 sensitivity at 800 DPI (832 eDPI), 1.0 zoom sensitivity, and the exported viewmodel, HUD, audio and keybinds. Set 800 DPI and 1000 Hz polling in your mouse software.

## Install

### Windows PowerShell

Close CS2, then paste this into PowerShell.

```powershell
irm 'https://raw.githubusercontent.com/enkhee-Osiris/cs/master/install.ps1' | iex
```

The installer checks your Steam libraries for CS2 and backs up any `.cfg` files it replaces. If it cannot identify a single installation, download `install.ps1` and run it with `-CfgDirectory` set to your full `game\csgo\cfg` path.

```powershell
.\install.ps1 -CfgDirectory 'D:\SteamLibrary\steamapps\common\Counter-Strike Global Offensive\game\csgo\cfg'
```

### Manual install

1. In Steam, right-click **Counter-Strike 2** and choose **Manage → Browse local files**. Open `game/csgo/cfg` inside that folder.
2. Back up any files with the same names, then copy the repository's `.cfg` files into that folder.
3. Set your resolution and refresh rate under **Settings → Video**. Enable **Developer Console** under **Settings → Game**, then run `exec autoexec` once from the main menu. Look for `Osiris CS2 config loaded`. Run `exec show_keybinds` to see the custom controls.
4. Clear the old CS:GO launch options in Steam. The game normally runs `autoexec.cfg` at startup. If the load message is missing on restart, use `+exec autoexec.cfg` as the Steam launch option.

The autoexec replaces the keys it lists. Other key assignments stay in place. To change an option that the autoexec sets, edit `osiris.cfg` so it survives the next launch.

## Video and performance

The optional `cs2_video.txt` is for the display and GPU in the export. Set these values in the Video menu on a different PC. To use the file on the original setup, close CS2, back up your current `cs2_video.txt`, and put the new one in `Steam/userdata/<account ID>/730/local/cfg/`. Select stretched scaling in your display or GPU settings.

| Setting | Starting point |
| --- | --- |
| Display | Fullscreen, 4:3 stretched, 1280×960 at 270 Hz |
| Player contrast and shadows | Boost Player Contrast enabled, Global Shadow Quality High, Dynamic Shadows All |
| Multisampling | 4× MSAA, down from 8× in the export |
| Textures and shaders | Medium textures, 4× anisotropic filtering, High shaders |
| Effects | Low particles, Ambient Occlusion disabled, HDR Performance, FSR disabled |
| Latency | NVIDIA Reflex Enabled on supported GeForce GPUs, V-Sync disabled for this profile |

- Repeat the same demo segment at 4×, 2× and 8× MSAA. Compare 1% lows and frame-time spikes and check how clearly you can see targets at range. If you still see GPU-related drops, compare High and Low shader detail next. Keep Dynamic Shadows on All while testing so you can still see shadows cast by local lights.
- Start with the exported caps of 501 FPS in game and 61 FPS in menus. Compare 501 with a lower cap your PC can sustain in busy rounds. Set the in-game cap in the main menu because CS2 locks `fps_max` while connected to a server. [Valve FPS cap update](https://www.counter-strike.net/newsentry/657081807721726196)
- Keep Reflex on **Enabled** as the baseline. Test **Enabled + Boost** if lower latency is worth the extra power draw. If you use G-SYNC, Valve recommends pairing it with V-Sync and Reflex for smooth frame pacing. [NVIDIA Reflex in CS2](https://www.nvidia.com/en-eu/geforce/news/counter-strike-2-released-featuring-nvidia-reflex/) · [Valve video settings](https://help.steampowered.com/en/faqs/view/418E-7A04-B0DA-9032)
- The autoexec shows frame time and ping, with network warnings starting at 0.5% missed ticks. Start with **Buffering to smooth over packet loss** at None on a stable connection. Try one tick if the HUD repeatedly shows loss or jitter and compare again. Extra buffering adds latency. [Valve telemetry guide](https://help.steampowered.com/en/faqs/view/5E6F-5B36-5485-F6B9)

## Local practice

Start **Practice → Competitive** and join a team before running these commands.

| Console command | What it does |
| --- | --- |
| `exec warmup` | Starts a local round with instant respawns, infinite ammo, rifles and buying anywhere. |
| `exec gren` | Loads the warmup rules and adds grenade trails, trajectory preview and bullet impacts. Buy grenades from the normal buy menu. |
| `exec stop_warmup` or `exec comp` | Restores CS2's stock Competitive round rules with the repo's local overrides for free team selection, no bots and overtime. |

For grenade practice, use `noclip` to fly and `sv_rethrow_last_grenade` to replay your last throw. Use `toggle sv_grenade_trajectory_prac_pipreview` to switch the preview. These actions are available from the console so practice leaves the match keybinds alone.

## Changes from CS:GO and the export

- The default is ZywOo's cyan static crosshair, with 2 px length, thickness and gap at its authored height of 768p. CS2 scales those dimensions to your display resolution. Page Up cycles dynamic, recoil-follow and static modes. [ZywOo on ProSettings](https://prosettings.net/players/zywoo/) · [Valve crosshair update](https://www.counter-strike.net/newsentry/674006995886408819)
- Set the radar HUD scale to the current maximum of 1.3 and fixed the F3/F4 volume commands. Enter opens the scoreboard, and holding Tab takes out the knife.
- Replaced the legacy net graph with CS2 telemetry. Removed CS:GO tickrate and interpolation overrides, cache flushes, obsolete render commands, and jump-throw and clear-decals binds. Use separate jump and release inputs for jump throws. [Valve input rules](https://store.steampowered.com/news/app/730/view/6500469346429600837)
- Moved the profile's `rate 786432` into the autoexec. Dropped the old launch flags, including `-high`, `-novid` and `-allow_third_party_software`. Steam documents the last flag as an opt-in for blocked software that needs to interact with the game process. [Valve Trusted Mode FAQ](https://help.steampowered.com/en/faqs/view/09A0-4879-4353-EF95)

Console commands and ranges were checked against the [November 5, 2026 CS2 game dump](https://github.com/SteamTracking/GameTracking-CS2/tree/cce7bf1f190144c1c08fb0fe75fd3c9514f2637f/DumpSource2).
