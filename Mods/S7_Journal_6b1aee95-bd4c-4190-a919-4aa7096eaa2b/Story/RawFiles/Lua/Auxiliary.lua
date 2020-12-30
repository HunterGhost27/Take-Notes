--  ------------------------------------------------------------
ModInfo = Ext.GetModInfo("6b1aee95-bd4c-4190-a919-4aa7096eaa2b")
SubdirectoryPrefix = "TakeNotes/"
IDENTIFIER = "S7_Journal"
--  ------------------------------------------------------------

--  =================
--  IMPORT DEPENDENCY
--  =================

UCL = Mods["S7_UI_Components_Library"]  --  Import UI Components Library
ValidString = UCL.ValidString
Integrate = UCL.Integrate
Rematerialize = UCL.Rematerialize
S7Debug = UCL.S7Debug
LoadFile = UCL.LoadFile
SaveFile = UCL.SaveFile
if UCL == nil then S7Debug:HFError("Could Not Find UI Components Library!") end

--  ===============
--  MOD INFORMATION
--  ===============

local modInfoTable = {
    ["Author"] = ModInfo.Author,
    ["Name"] = ModInfo.Name,
    ["UUID"] = ModInfo.UUID,
    ["Version"] = ModInfo.Version,
    ["PublishedVersion"] = ModInfo.PublishVersion,
    ["ModVersion"] = "0.0.0.0",
    ["ModSettings"] = {
        ["Storage"] = "Internal",
        ["SyncTo"] = "ItemGUID",
        ["Uniques"] = false
    }
}

CENTRAL = LoadFile("S7Central.json") or {} --  Holds Global Settings and Information
if CENTRAL[IDENTIFIER] == nil then CENTRAL[IDENTIFIER] = Rematerialize(modInfoTable) end

--  ====  MOD VERSIONING  ======
Ext.Require("ModVersioning.lua")
--  ============================

--- Initialize CENTRAL
---@param ref table Reference table
---@param tar table Target table
local function initCENTRAL(ref, tar)
    for field, value in pairs(ref) do
        if type(value) == 'table' then initCENTRAL(value, tar[field]) end
        if ModInfo[field] then tar[field] = Rematerialize(ModInfo[field])
        else if not tar[field] then tar[field] = Rematerialize(value) end end
    end
end

initCENTRAL(modInfoTable, CENTRAL[IDENTIFIER])
CENTRAL[IDENTIFIER]["ModVersion"] = ParseVersion(ModInfo.Version, "string")
SaveFile("S7Central.json", CENTRAL)

--  ======
--  VARDEC
--  ======

JournalTemplate = "df7a8779-f908-43ac-b0ba-cb49d16308a9"    --  Journal's Item Root Template
PersistentVars = {}
PersistentVars.JournalData = {}
PersistentVars.Settings = Rematerialize(CENTRAL[IDENTIFIER]["ModSettings"])

--  ==========================
--  RESYNCHRONIZE MOD-SETTINGS
--  ==========================

--- Resyncs ModSettings and PersistentVar Settings.
function ResynchronizeModSettings()
    CENTRAL = LoadFile("S7Central.json") or {}
    if Ext.JsonStringify(PersistentVars.Settings) ~= Ext.JsonStringify(CENTRAL[IDENTIFIER]["ModSettings"]) then
        S7Debug:HFPrint("Synchronizing ModSettings")
        for setting, value in pairs(CENTRAL[IDENTIFIER]["ModSettings"]) do
            if CENTRAL[IDENTIFIER]["ModSettings"][setting] ~= PersistentVars.Settings[setting] then
                PersistentVars.Settings[setting] = value
                S7Debug:FPrint(setting .. ": " .. tostring(value))
            end
        end
    end
end

--  ===========================================================
Ext.RegisterListener("SessionLoaded", ResynchronizeModSettings)
--  ===========================================================