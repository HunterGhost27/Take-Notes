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
if UCL == nil then S7DebugPrint("Could Not Find UI Components Library!", "Auxiliary", "Error", true, true, "*") end

--  ===============
--  MOD INFORMATION
--  ===============

CENTRAL = {}    --  Holds Global Settings and Information
local file = Ext.LoadFile("S7Central.json") or "{}"
if ValidString(file) then CENTRAL = Ext.JsonParse(file) end
if CENTRAL[IDENTIFIER] == nil then CENTRAL[IDENTIFIER] = {} end

--  ====  MOD VERSIONING  ======
Ext.Require("ModVersioning.lua")
--  ============================

for k, v in pairs(ModInfo) do CENTRAL[IDENTIFIER][k] = v end
CENTRAL[IDENTIFIER]["ModVersion"] = ParseVersion(ModInfo.Version, "string")
Ext.SaveFile("S7Central.json", Ext.JsonStringify(CENTRAL))

--  ======
--  VARDEC
--  ======

JournalTemplate = "df7a8779-f908-43ac-b0ba-cb49d16308a9"    --  Journal's Item Root Template
