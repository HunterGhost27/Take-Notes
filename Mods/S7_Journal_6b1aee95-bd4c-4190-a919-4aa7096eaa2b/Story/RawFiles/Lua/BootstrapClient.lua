--  =======
--  IMPORTS
--  =======

Ext.Require("S7_JournalAuxiliary.lua")

--  ======
--  VARDEC
--  ======

Character = {}
S7Journal = {
    ["Component"] = {
        ["Strings"] = {
            ["caption"] = "Your Journal",
            ["addCategory"] = "Add New Category",
            ["addChapter"] = "Add New Chapter",
            ["addParagraph"] = "Add New Paragraph",
            ["editButtonCaption"] = "TOGGLE EDIT MODE",
            ["shareWithParty"] = "Share With Party"
        }
    },
    ["SubComponent"] = {
        ["ToggleEditButton"] = {
            ["Title"] = "ToggleEditButton",
            ["Visible"] = true
        }
    },
    ["JournalData"] = {},
    ["JournalMetaData"] = {
        ["CategoryEntryMap"] = {},
        ["ChapterEntryMap"] = {},
        ["ParagraphEntryMap"] = {}
    }
}

--  ============
--  LOAD JOURNAL
--  ============

--      REQUEST CHARACTER INFO FROM SERVER
--      ----------------------------------

Ext.RegisterNetListener("S7_Journal", function (channel, stringifiedPayload)
    local signal = Ext.JsonParse(stringifiedPayload)
    if signal.ID == "S7_JournalServerReady" then
        S7DebugPrint("Client Ready. Requesting CharacterInfo.", "BootstrapClient")
        local request = {["ID"] = "RequestingCharacterInfo", ["Data"] = "RequestingCharacterInfo"}
        Ext.PostMessageToServer("S7_Journal", Ext.JsonStringify(request))
    end
end)

local function LoadJournal()
    local file = {}
    S7DebugPrint("Loading Journal File.", "BootstrapClient")
    if Character ~= nil then
        local fileName = "S7Journal/" .. tostring(Character.hostUserProfileID) .. "/" .. tostring(Character.currentCharacterName) .. ".json"
        file = Ext.JsonParse(Ext.LoadFile(fileName) or "{}")
        S7Journal = file
    end
end

Ext.RegisterNetListener("S7_Journal", function (channel, stringifiedPayload)
    local charInfoPayload = Ext.JsonParse(stringifiedPayload)
    if charInfoPayload.ID == "ProvidingCharacterInfo" then
        Character = Rematerialize(charInfoPayload.Data)
        LoadJournal()
    end
end)

--  ============
--  SAVE JOURNAL
--  ============

function SaveJournal()
    S7DebugPrint("Saving Journal File.", "BootstrapClient")
    local fileName = "S7Journal/" .. tostring(Character.hostUserProfileID) .. "/" .. tostring(Character.currentCharacterName) .. ".json"
    local journal = Ext.JsonParse(Ext.LoadFile(fileName) or "{}")

    S7Journal.Component = Rematerialize(UCL.UILibrary.GMJournal.Component)
    S7Journal.SubComponent = Rematerialize(UCL.UILibrary.GMJournal.SubComponent)
    S7Journal.JournalMetaData = Rematerialize(UCL.UILibrary.GMJournal.JournalMetaData)
    S7Journal.JournalData = Rematerialize(UCL.UILibrary.GMJournal.JournalData)

    journal = Rematerialize(S7Journal)

    Ext.SaveFile(fileName, Ext.JsonStringify(journal))
end

--  ##########################################################################################################################

--  ==============
--  HANDLE JOURNAL
--  ==============

Ext.RegisterNetListener("S7_Journal", function (channel, stringifiedPayload)
    local journalPayload = Ext.JsonParse(stringifiedPayload)
    if journalPayload.ID == "CharacterOpenJournal" then
        local package = journalPayload.Data
        local character = package["1"]
        local tempate = package["2"]
        local itemGuid = package["3"]

        LoadJournal()
        local BuildSpecs = {["GMJournal"] = Rematerialize(S7Journal)}
        UCL.UCLBuild(Ext.JsonStringify(BuildSpecs))
        if not UCL.UILibrary.GMJournal.Exists then
            Ext.RegisterUICall(UCL.UILibrary.GMJournal.UI, "S7_Journal_UI_Hide", function (ui, call, ...)
                SaveJournal()
            end)
        else
            UCL.UILibrary.GMJournal.UI:Show()
        end
        SaveJournal()
    end
end)