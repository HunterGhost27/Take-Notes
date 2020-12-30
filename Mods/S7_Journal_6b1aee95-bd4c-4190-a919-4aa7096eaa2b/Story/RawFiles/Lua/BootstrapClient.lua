--  =======
--  IMPORTS
--  =======

Ext.Require("Auxiliary.lua")
Ext.Require("TreasureTables.lua")

--  ==================
--  FETCH JOURNAL DATA
--  ==================

FileName = ""
local function SaveJournal()
    local journal = {
        ["ID"] = "SaveJournal",
        ["fileName"] = FileName,
        ["Data"] = {
            ["Component"] = Rematerialize(UCL.Journal.Component),
            ["SubComponent"] = Rematerialize(UCL.Journal.SubComponent),
            ["JournalData"] = Rematerialize(UCL.Journal.JournalData)
        }
    }
    Ext.PostMessageToServer(IDENTIFIER, Ext.JsonStringify(journal))
end

--  ==============
--  HANDLE JOURNAL
--  ==============

Ext.RegisterNetListener(IDENTIFIER, function (channel, payload)
    local journal = Ext.JsonParse(payload)
    if journal.ID == "CharacterOpenJournal" then
        FileName = journal.Data.fileName
        S7Debug:Print("Dispatching BuildSpecs to UI-Components-Library.")
        local BuildSpecs = {["GMJournal"] = Rematerialize(journal.Data.content)}
        if not UCL.Journal.Exists then
            UCL.UCLBuild(BuildSpecs)
            Ext.RegisterUICall(UCL.Journal.UI, "S7_Journal_UI_Hide", function (ui, call, ...) SaveJournal(); UCL.UnloadJournal() end)
        else UCL.UCLBuild(BuildSpecs) end
        SaveJournal()
    end
end)