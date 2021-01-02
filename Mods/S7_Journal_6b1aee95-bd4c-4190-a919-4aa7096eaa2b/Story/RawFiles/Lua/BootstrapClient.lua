--  =======
--  IMPORTS
--  =======

Ext.Require("Shared/Auxiliary.lua")
Ext.Require("Client/ContextMenu.lua")
Ext.Require("Client/TreasureTables.lua")

--  ==================
--  FETCH JOURNAL DATA
--  ==================

FileName = ""
local function SaveJournal()
    local saveData = {
        ["ID"] = "SaveJournal",
        ["fileName"] = FileName,
        ["Data"] = {
            ["Component"] = Rematerialize(UCL.Journal.Component),
            ["SubComponent"] = Rematerialize(UCL.Journal.SubComponent),
            ["JournalData"] = Rematerialize(UCL.Journal.JournalData)
        }
    }
    Ext.PostMessageToServer(IDENTIFIER, Ext.JsonStringify(saveData))
end

--  ==============
--  HANDLE JOURNAL
--  ==============

Ext.RegisterNetListener(IDENTIFIER, function (channel, payload)
    local journal = Ext.JsonParse(payload)
    if journal.ID == "CharacterOpenJournal" then
        FileName = journal.Data.fileName
        S7Debug:Print("Dispatching BuildSpecs to UI-Components-Library")
        local BuildSpecs = {["GMJournal"] = Rematerialize(journal.Data.content)}
        if not UCL.Journal.Exists then
            UCL.UCLBuild(BuildSpecs)
            Ext.RegisterUICall(UCL.Journal.UI, "S7_Journal_UI_Hide", function (ui, call, ...) SaveJournal(); UCL.UnloadJournal() end)
        else UCL.UCLBuild(BuildSpecs) end
        SaveJournal()
    end
end)

--  ===================
--  HANDLE MOD-SETTINGS
--  ===================

Ext.RegisterNetListener("CharacterOpenModSettings", function (channel, payload)
    local payload = Ext.JsonParse(payload)
    UCL.UCLBuild(payload)
end)