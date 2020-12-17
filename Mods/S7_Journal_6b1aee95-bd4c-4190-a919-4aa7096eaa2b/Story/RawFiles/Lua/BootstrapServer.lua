--  ======
--  IMPORT
--  ======

Ext.Require("Auxiliary.lua")

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

local function LoadJournal(fileName)
    S7DebugPrint("Loading Journal File: " .. fileName, "BootstrapServer")
    local file = Ext.LoadFile(fileName) or "{}"
    if ValidString(file) then S7Journal = Ext.JsonParse(file)
    else ReinitJournal() end
    S7DebugPrint("Loaded Successfully", "BootstrapServer")
end

--  ============
--  SAVE JOURNAL
--  ============

Ext.RegisterNetListener(IDENTIFIER, function (channel, payload)
    local journal = Ext.JsonParse(payload)
    if journal.ID == "SaveJournal" then
        S7DebugPrint("Saving Journal File: " .. journal.fileName, "BootstrapServer")
        Ext.SaveFile(journal.fileName, Ext.JsonStringify(journal.Data))
        S7DebugPrint("Saved Successfully", "BootstrapServer")
    end
end)

--  ============
--  OPEN JOURNAL
--  ============

Ext.RegisterOsirisListener("CharacterUsedItem", 2, "after", function(character, itemGuid)
    local item = Ext.GetItem(itemGuid)
    if item.RootTemplate.Id == JournalTemplate then
        S7DebugPrint(character .. " opened Journal", "BootstrapServer")
        local fileName = IDENTIFIER .. "/" .. tostring(itemGuid) .. ".json"
        LoadJournal(fileName)
        item.CustomDisplayName = S7Journal.Component.Strings.caption
        local payload = {["ID"] = "CharacterOpenJournal", ["Data"] = {["fileName"] = fileName, ["content"] = Rematerialize(S7Journal)}}
        Ext.PostMessageToClient(character, IDENTIFIER, Ext.JsonStringify(payload))
    end
end)

--  ==================
--  REQUIRE DEBUG MODE
--  ==================

if Ext.IsDeveloperMode() then Ext.Require("S7_DebugMode.lua") end