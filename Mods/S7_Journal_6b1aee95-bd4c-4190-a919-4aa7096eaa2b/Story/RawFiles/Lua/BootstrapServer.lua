--  ======
--  IMPORT
--  ======

Ext.Require("Auxiliary.lua")

--  ======
--  VARDEC
--  ======

Journal = {}
Journal.prototype = {
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
    ["JournalData"] = {}
}
Journal.mt = {}
setmetatable(Journal, Journal.mt)
Journal.mt.__index = Journal.prototype

function Journal:New(object)
    local object = object or {}
    setmetatable(object, self.mt)
    self.mt.__index = self.prototype
    return object
end

--  =====================
S7Journal = Journal:New()
--  =====================

--  ####################################################################################################################################################

--  ============
--  LOAD JOURNAL
--  ============

local function LoadJournal(fileName)
    S7DebugPrint("Loading Journal File: " .. fileName, "BootstrapServer")
    local file = PersistentVars.Settings.Storage == "External" and Ext.JsonParse(Ext.LoadFile(fileName) or "{}") or PersistentVars.JournalData[fileName] or {}
    S7Journal = Journal:New(file)
    S7DebugPrint("Loaded Successfully", "BootstrapServer")
end

--  ============
--  SAVE JOURNAL
--  ============

Ext.RegisterNetListener(IDENTIFIER, function (channel, payload)
    local journal = Ext.JsonParse(payload)
    if journal.ID == "SaveJournal" then
        S7DebugPrint("Saving Journal File: " .. journal.fileName, "BootstrapServer")
        if PersistentVars.Settings.Storage == "External" then Ext.SaveFile(journal.fileName, Ext.JsonStringify(journal.Data))
        else PersistentVars.JournalData[journal.fileName] = Rematerialize(journal.Data) end
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

if Ext.IsDeveloperMode() then Ext.Require("DebugMode.lua") end