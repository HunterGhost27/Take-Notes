--  =======
--  IMPORTS
--  =======

Ext.Require("S7_JournalAuxiliary.lua")

--  =========
--  VARIABLES
--  =========

Character = nil
S7Journal = {}

--  ============
--  LOAD JOURNAL
--  ============

function LoadJournal()
    local file = Ext.LoadFile("S7Journal.json") or ""
    if ValidString(file) then S7Journal = Ext.JsonParse(file)
    else
        S7Journal = {
            ["Component"] = {
                ["Strings"] = {
                    ["caption"] = "Your Journal",
                    ["addCategory"] = "Add New Category",
                    ["addChapter"] = "Add New Chapter",
                    ["addParagraph"] = "Add New Paragraph",
                    ["editButtonCaption"] = "Toggle Edit Mode",
                    ["shareWithParty"] = "Share With Party"
                }
            },
            ["SubComponents"] = {},
            ["JournalData"] = {},
            ["JournalMetaData"] = {
                ["CategoryEntryMap"] = {},
                ["ChapterEntryMap"] = {},
                ["ParagraphEntryMap"] = {}
            }
        }
    end
end

--  ==============================================
Ext.RegisterListener("SessionLoaded", LoadJournal)
--  ==============================================

--  ============
--  SAVE JOURNAL
--  ============

function SaveJournal()
    S7Journal.Component = UCL.UILibrary.GMJournal.Component
    S7Journal.JournalMetaData = UCL.UILibrary.GMJournal.JournalMetaData
    S7Journal.JournalData = UCL.UILibrary.GMJournal.JournalData
    Ext.SaveFile("S7Journal.json", Ext.JsonStringify(S7Journal))
end

--  ##########################################################################################################################

--  ==============
--  HANDLE JOURNAL
--  ==============

local function handleJournal_Client(channel, payload)
    if channel == "S7_HandleJournal" then
        local package = Ext.JsonParse(payload)
        Character = package["1"]
        local tempate = package["2"]
        local itemGuid = package["3"]

        local BuildSpecs = {["GMJournal"] = Rematerialize(S7Journal)}
        if not UCL.UILibrary.GMJournal.Exists then
            UCL.UCLBuild(Ext.JsonStringify(BuildSpecs))
            Ext.RegisterUICall(UCL.UILibrary.GMJournal.UI, "S7_UI_Journal_Hide", function (ui, call, ...)
                SaveJournal()
            end)
        else
            UCL.UpdateJournal(S7Journal.JournalData)
            UCL.UILibrary.GMJournal.UI:Show()
        end
        SaveJournal()
    end
end

--  =============================================================
Ext.RegisterNetListener("S7_HandleJournal", handleJournal_Client)
--  =============================================================