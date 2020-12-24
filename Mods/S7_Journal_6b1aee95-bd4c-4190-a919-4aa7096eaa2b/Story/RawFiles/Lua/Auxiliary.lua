--  ------------------------------------------------------------
ModInfo = Ext.GetModInfo("6b1aee95-bd4c-4190-a919-4aa7096eaa2b")
IDENTIFIER = "S7_Journal"
--  ------------------------------------------------------------

--  ===========
--  DEBUG PRINT
--  ===========

function S7DebugPrint(...)
    local args = {...}
    local logMsg = args[1] or ""    -- The message to display
    local logSource = args[2] or "" -- The Source/Origin of the message
    local logType = args[3] or "Log"    -- The type of message (Log, Warning, Error)
    local ignoreDevMode = args[4] or false  -- Print message regardless of DeveloperMode
    local highlight = args[5] or false  -- Highlights the display message
    local highlightChar = args[6] or "="    -- Highlighting character

    if Ext.IsDeveloperMode() or ignoreDevMode then
        local context = ""
        if Ext.IsClient() then context = "C"
        elseif Ext.IsServer() then context = "S" end

        local logFunctions = {["Log"] = Ext.Print, ["Warning"] = Ext.PrintWarning, ["Error"] = Ext.PrintError}
        local printFunction = logFunctions[logType]

        local displayString = "[" .. IDENTIFIER .. ":Lua(" .. context .. "):" .. logSource .. "] --- " .. logMsg

        if highlight then printFunction(string.rep(highlightChar, string.len(displayString))) end
        printFunction(displayString)
        if highlight then printFunction(string.rep(highlightChar, string.len(displayString))) end
    end
end

--  =================
--  IMPORT DEPENDENCY
--  =================

UCL = Mods["S7_UI_Components_Library"]  --  Import UI Components Library
ValidString = UCL.ValidString
Rematerialize = UCL.Rematerialize
Integrate = UCL.Integrate
LoadFile = UCL.LoadFile
SaveFile = UCL.SaveFile
if UCL == nil then S7DebugPrint("Could Not Find UI Components Library!", "Auxiliary", "Error", true, true, "*") end

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
        S7DebugPrint("Synchronizing ModSettings", "Auxiliary", "Log", true, true)
        for setting, value in pairs(CENTRAL[IDENTIFIER]["ModSettings"]) do
            if CENTRAL[IDENTIFIER]["ModSettings"][setting] ~= PersistentVars.Settings[setting] then
                PersistentVars.Settings[setting] = value
                S7DebugPrint(setting .. ": " .. tostring(value), "Auxiliary", "Log", true)
            end
        end
    end
end

--  =============================================================================
Ext.RegisterListener("SessionLoaded", function () ResynchronizeModSettings() end)
--  =============================================================================