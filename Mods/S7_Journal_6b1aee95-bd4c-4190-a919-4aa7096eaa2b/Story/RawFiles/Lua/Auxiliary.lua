-----------------------------------------------------------------------------
--===========================================================================

IDENTIFIER = 'S7_Journal'

---@class MODINFO: ModInfo
---@field ModVersion string
---@field ModSettings table
---@field DefaultSettings table
---@field SubdirPrefix string
MODINFO = Ext.GetModInfo('6b1aee95-bd4c-4190-a919-4aa7096eaa2b')
MODINFO.SubdirPrefix = "TakeNotes/"

--  ========================== AUX FUNCTIONS  ===============================
Ext.Require('b66d56c6-12f9-4abc-844f-0c30b89d32e4', 'AuxFunctions/Index.lua')
--  =========================================================================

--===========================================================================
-----------------------------------------------------------------------------

UCL = Mods["S7_UI_Components_Library"]  --  Import UI Components Library
if UCL == nil then Debug:HFError("Could Not Find UI Components Library!") end

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
        Debug:HFPrint("Synchronizing ModSettings")
        for setting, value in pairs(CENTRAL[IDENTIFIER]["ModSettings"]) do
            if CENTRAL[IDENTIFIER]["ModSettings"][setting] ~= PersistentVars.Settings[setting] then
                PersistentVars.Settings[setting] = value
                Debug:FPrint(setting .. ": " .. Ext.JsonStringify(Rematerialize(value)))
            end
        end
    end
end

--  ===========================================================
Ext.RegisterListener("SessionLoaded", ResynchronizeModSettings)
--  ===========================================================