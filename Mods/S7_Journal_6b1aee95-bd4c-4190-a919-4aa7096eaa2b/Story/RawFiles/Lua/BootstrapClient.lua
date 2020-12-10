--  =======
--  IMPORTS
--  =======

Ext.Require("S7_JournalAuxiliary.lua")

--  ==================
--  FETCH JOURNAL DATA
--  ==================

local function SaveJournal(fileName)
    local journal = {
        ["ID"] = "SaveJournal",
        ["fileName"] = fileName,
        ["Data"] = {
            ["Component"] = Rematerialize(UCL.UILibrary.GMJournal.Component),
            ["SubComponent"] = Rematerialize(UCL.UILibrary.GMJournal.SubComponent),
            ["JournalMetaData"] = Rematerialize(UCL.UILibrary.GMJournal.JournalMetaData),
            ["JournalData"] = Rematerialize(UCL.UILibrary.GMJournal.JournalData)
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
        S7DebugPrint("Dispatching BuildSpecs to UI-Components-Library.", "BootstrapClient")
        local BuildSpecs = {["GMJournal"] = Rematerialize(journal.Data.content)}
        if not UCL.UILibrary.GMJournal.Exists then
            UCL.UCLBuild(Ext.JsonStringify(BuildSpecs))
            Ext.RegisterUICall(UCL.UILibrary.GMJournal.UI, "S7_Journal_UI_Hide", function (ui, call, ...) SaveJournal(journal.Data.fileName) end)
        else UCL.UILibrary.GMJournal.UI:Show() end
        SaveJournal(journal.Data.fileName)
    end
end)