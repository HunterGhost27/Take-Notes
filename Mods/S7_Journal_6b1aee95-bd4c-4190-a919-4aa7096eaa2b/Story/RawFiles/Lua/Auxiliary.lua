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
MODINFO.DefaultSettings = {
    ["Storage"] = "Internal",
    ["SyncTo"] = "ItemGUID",
    ["Uniques"] = false
}

--  ======= AUX FUNCTIONS  ==========
Ext.Require('AuxFunctions/Index.lua')
--  =================================

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