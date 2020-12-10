--  ======
--  IMPORT
--  ======

Ext.Require("S7_JournalAuxiliary.lua")

--  ======
--  VARDEC
--  ======

local function ReinitJournal()
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
    S7DebugPrint("Reinitializing S7Journal", "BootstrapServer")
    end
    ReinitJournal()

--  ####################################################################################################################################################

--  ============
--  LOAD JOURNAL
--  ============

local function LoadJournal(itemGUID)
    local fileName = IDENTIFIER .. "/" .. tostring(itemGUID) .. ".json"
    S7DebugPrint("Loading Journal File: " .. fileName, "BootstrapClient")
    local file = Ext.LoadFile(fileName) or "{}"
    if ValidString(file) then
        S7Journal = Ext.JsonParse(file)
        S7DebugPrint("Loaded ".. fileName .. " Successfully", "BootstrapClient")
    else
        ReinitJournal()
    end
end

--  ============
--  SAVE JOURNAL
--  ============

Ext.RegisterNetListener("S7_Journal", function (channel, payload)
    local journal = Ext.JsonParse(payload)
    if journal.ID == "SaveJournal" then
        S7DebugPrint("Saving Journal File.", "BootstrapServer")
        Ext.SaveFile(IDENTIFIER .. "/" .. journal.fileName .. ".json", Ext.JsonStringify(journal.Data))
        S7DebugPrint("Saved " .. journal.fileName, "BootstrapServer")
    end
end)

--  ============
--  OPEN JOURNAL
--  ============

Ext.RegisterOsirisListener("CharacterUsedItemTemplate", 3, "after", function (character, template, itemGuid)
    if template == JournalTemplate then
        S7DebugPrint(character .. " opened Journal.", "BootstrapServer")
        LoadJournal(itemGuid)
        local payload = {["ID"] = "CharacterOpenJournal", ["Data"] = {["fileName"] = itemGuid, ["content"] = Rematerialize(S7Journal)}}
        Ext.PostMessageToClient(character, "S7_Journal", Ext.JsonStringify(payload))
    end
end)

--  ==================
--  REQUIRE DEBUG MODE
--  ==================

if Ext.IsDeveloperMode() then Ext.Require("S7_DebugMode.lua") end