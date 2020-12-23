ORGS_Config = {}
--[[

	Organisations Addon for DarkRP 2.x.x
				Config File

]]--

--Main settings

-- Name for the addon
ORGS_Config.addonName = "Организация"

-- Creation Price
ORGS_Config.createPrice = 100000

-- Key to open the menu
ORGS_Config.keyToActivate = 101 --Change the value that you want to open the menu (values from Binds.txt)


--NPC Settings

-- NPC model
ORGS_Config.npcModel = "models/breen.mdl" -- models/breen.mdl  "models/Humans/Group01/male_02.mdl"

-- If you want to draw the bubble above the npc's head set it to true else set it to false
ORGS_Config.npcDrawBubble = true



--Other Settings

-- Show the organisation name on the player
ORGS_Config.showNames = false

-- The color of the organisation name that shown on the player
--ORGS_Config.nameColor = Color(255, 0, 0, 255)

-- frienly fire beetween members (true is on, false is off)
ORGS_Config.enableFriendlyFire = false

-- halo effect (effected on online players of the organisation - kind of wallhack of the members)
ORGS_Config.enableHaloEffect = false

-- Enabling the org bank
ORGS_Config.enableOrgBank = true

-- Enabling the org meetings
ORGS_Config.enableOrgMeetups = true