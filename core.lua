--BBVO is a 'global Object for the Addon'
--Files referenced in the TOC can add functions to this Object

local appName, BBVO = ...
-- Using Ace3 to bootstrap the simple addon
-- see https://www.wowace.com/projects/ace3
local AceConfig = LibStub("AceConfig-3.0")                                                    --Ace3 Module for Config
local AceConfigDialog = LibStub("AceConfigDialog-3.0")                                        --Ace3 Module for Config Dialog
local BattleBrisketVO = LibStub("AceAddon-3.0"):NewAddon("BattleBrisketVO", "AceConsole-3.0") --Console shouldn't even be needed, but is useful for 'dirty debugging' via BattleBrisketVO:Print("Debug Message")

--Default Settings for the Addon
--Note how the keys are equal to the function names inside soundregister.lua
-- Cleaner to define this in a separate file, but for the sake of simplicity it is here
local defaults = {
    profile = {
        countdown = false,
        raidmarkers = false,
        cardinaldirections = false,
        relativedirections = false,
        groupings = false,
        phases = false,
        dpstimings = false,
        commoninstructions = false,
        miscellaneous = false,
        causese = false
    }
}
--Option structure used by Ace3 Config to create the GUI
-- see https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables
-- Cleaner to define this in a separate file, but for the sake of simplicity it is here
local options = {
    type = "group",
    handler = BattleBrisketVO, --Object where getter and setter functions are defined
    args = {
        sounds = {
            name = "BattleBrisketVo", --Group inside Addon Options
            type = "group",
            args = {
                tooltip = { --Text to explain the options
                    type = "description",
                    name = "Toggle wich set of voicelines to load. Reload your UI, then set Up your Addons that are using the additional sounds. If the Sound Selector is clogged up with a large number of custom sounds you can disable the loading of sound groups. ",
                    order = 0
                },
                note ={
                    type = "description",
                    name = "NOTE: Sounds that are used by other addons will still work as intended. This just toggles the possibility to select these sounds from dropdown menues.",
                    order = 1
                },
                reload = {
                    type = "execute",
                    name = "Reload UI",
                    desc = "Reload UI to apply changes",
                    func = function() ReloadUI() end
                },
                countdown = { --Checkbox to set countdown loading
                    type = "toggle",
                    name = "Countdown",
                    desc = "Load Countdown Voicelines",
                    set = "setToggle",
                    get = "getToggle"
                },
                raidmarkers = {                                                    --Checkbox to set raidmarkers loading
                    type = "toggle",
                    name = "Raidmarkers",
                    desc = "Load Raidmarker Voicelines",
                    set = "setToggle",
                    get = "getToggle"
                },
                cardinaldirections = { --Checkbox to set cardinaldirections loading
                    type = "toggle",
                    name = "Cardinal Directions",
                    desc = "Load Cardinal Directions Voicelines",
                    set = "setToggle",
                    get = "getToggle"
                },
                relativedirections = { --Checkbox to set relativedirections loading
                    type = "toggle",
                    name = "Relative Directions",
                    desc = "Load Relative Directions Voicelines",
                    set = "setToggle",
                    get = "getToggle"
                },
                groupings = { --Checkbox to set groupings loading
                    type = "toggle",
                    name = "Groupings",
                    desc = "Load Groupings Voicelines",
                    set = "setToggle",
                    get = "getToggle"
                },
                phases = { --Checkbox to set phases loading
                    type = "toggle",
                    name = "Phases",
                    desc = "Load Phases Voicelines",
                    set = "setToggle",
                    get = "getToggle"
                },
                dpstimings = { --Checkbox to set dpstimings loading
                    type = "toggle",
                    name = "DPS Timings",
                    desc = "Load DPS Timings Voicelines",
                    set = "setToggle",
                    get = "getToggle"
                },
                commoninstructions = { --Checkbox to set commoninstructions loading
                    type = "toggle",
                    name = "Common Instructions",
                    desc = "Load Common Instructions Voicelines",
                    set = "setToggle",
                    get = "getToggle"
                },
                miscellaneous = { --Checkbox to set miscellaneous loading
                    type = "toggle",
                    name = "Miscellaneous",
                    desc = "Load Miscellaneous Voicelines",
                    set = "setToggle",
                    get = "getToggle"
                },
                causese = { --Checkbox to set causese loading
                    type = "toggle",
                    name = "Causese",
                    desc = "Load Causeses Voicelines",
                    set = "setToggle",
                    get = "getToggle"
                },
            }
        }
    }
}


--This function is run when your addon initializes itself to the game
function BattleBrisketVO:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("BattleBrisketVO", defaults, true)  --AceDB is the persistent Datastore for addon settings if i am not mistaken (90%confidendce)
    AceConfig:RegisterOptionsTable("BattleBrisketVO", options)             --Create the options Structure using the defined options Table
    AceConfigDialog:AddToBlizOptions("BattleBrisketVO", "BattleBrisketVO") --Add the options to the Blizzard Options Menu

    for key, value in pairs(self.db.profile) do                            --Iterate over the settings

        if value then                                                      --If value is set to true (Persistnat through using AceDB)
            local func = string.lower(key)
            BBVO[func]()                                                   --Call the function with the same name as key definied in soundregister.lua. That is the reason the keys are the same as the function names
        end
    end
end

function BattleBrisketVO:OnEnable()

end

function BattleBrisketVO:OnDisable()

end

--Getter and Setter Functions for the DB used by Options since BattleBrisketVO is the handler
function BattleBrisketVO:setToggle(info, val)    
    self.db.profile[info[#info]] = val
end
function BattleBrisketVO:getToggle(info)

    return self.db.profile[info[#info]]
end
