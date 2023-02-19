"""
Curses in Hindsight

Realtime Isometric Action Puzzler
Boons become curses on next level
Play goal: get through all the levels


Roles:
	Plexsoup = framework for menus, etc.
	Disco = art for menus, etc.
	Hayden = Player controller, shooting, npcs,
	BitGhost = quest system
	Eddy = tilemap and level framework
	Andy = level design
	twilightrc = interactive Terrain (windows that smash or ricochet bullets)
	
Accessibility Guidelines:
	https://drive.google.com/file/d/1YBCVIlETy_qSzvsYDQg_aaW0ZdKCG-kE/view?usp=sharing
	
HackNPlan Page:
	https://app.hacknplan.com/p/181387/gamemodel?nodeId=1&nodeTabId=basicinfo
	
GitHub:
	https://github.com/IMAFIREHAZARD/GWJ-54-Solid-Gold

Game Page:
	https://imafirehazard.itch.io/solid-gold-jam-54-project


	
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

Level 1: Shoot the creeps. Gun is slow, creeps replicate quickly.
Level 1 Boons: Gun Hands: fast, continuous shooting. Makes it easier to kill the creeps

Level 2: Navigate through the panes of glass. 
	If you have continuous shooting hands, it'll be challenging, but possible.
	Level 2 Boon: Glass can become impenetrable.
	
Level 3: 
	Navigate through the level safely
	If the glass is impenetrable, bullets ricochet, and might cause you harm.

"""

extends Node

