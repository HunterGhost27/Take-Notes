--  ======
--  IMPORT
--  ======

Ext.Require("Auxiliary.lua")

--  ======
--  VARDEC
--  ======

Journal = {
    ["Component"] = {
        ["Strings"] = {
            ["caption"] = "Notebook",
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

function Journal:New(object)
    local object = object or {}
    object = Integrate(object, self)
    return object
end

--  =====================
S7Journal = Journal:New()
--  =====================

--  ####################################################################################################################################################

--  ============
--  LOAD JOURNAL
--  ============

--- Load Journal
---@param fileName string
local function LoadJournal(fileName)
    S7DebugPrint("Loading Journal File: " .. fileName, "BootstrapServer")
    local file = PersistentVars.Settings.Storage == "External" and Ext.JsonParse(Ext.LoadFile(fileName) or "{}") or PersistentVars.JournalData[fileName] or {}
    S7Journal = Journal:New(file)
    S7DebugPrint("Loaded Successfully", "BootstrapServer")
end

--  ============
--  SAVE JOURNAL
--  ============

--- Save Journal
---@param channel string
---@param payload string
Ext.RegisterNetListener(IDENTIFIER, function (channel, payload)
    local journal = Ext.JsonParse(payload)
    if journal.ID == "SaveJournal" then
        S7DebugPrint("Saving Journal File: " .. journal.fileName, "BootstrapServer")
        if PersistentVars.Settings.Storage == "External" then Ext.SaveFile(journal.fileName, Ext.JsonStringify(journal.Data))
        elseif PersistentVars.Settings.Storage == "Internal" then PersistentVars.JournalData[journal.fileName] = Rematerialize(journal.Data) end
        S7DebugPrint("Saved Successfully", "BootstrapServer")
    end
end)

--  ============
--  OPEN JOURNAL
--  ============

--- Character Opens Journal
---@param character string
---@param itemGuid string
Ext.RegisterOsirisListener("CharacterUsedItem", 2, "after", function(character, itemGuid)
    local item = Ext.GetItem(itemGuid)
    if item.RootTemplate.Id == JournalTemplate then
        if CENTRAL[IDENTIFIER].ModSettings.Uniques then item.StoryItem = true else item.StoryItem = false end
        S7DebugPrint(character .. " opened Journal", "BootstrapServer")

        local fileName = PersistentVars.Settings.Storage == "External" and IDENTIFIER .. "/" or ""
        if PersistentVars.Settings.SyncTo == "CharacterGUID" then fileName = fileName .. tostring(character) .. ".json"
        elseif PersistentVars.Settings.SyncTo == "ItemGUID" then fileName = fileName .. tostring(itemGuid) .. ".json" end

        LoadJournal(fileName)
        item.CustomDisplayName = S7Journal.Component.Strings.caption
        local payload = {["ID"] = "CharacterOpenJournal", ["Data"] = {["fileName"] = fileName, ["content"] = Rematerialize(S7Journal)}}
        Ext.PostMessageToClient(character, IDENTIFIER, Ext.JsonStringify(payload))
    end
end)

--  ==========================
--  GRANT UNIQUES ON GAMESTART
--  ==========================

if CENTRAL[IDENTIFIER].ModSettings.Uniques then
    Ext.RegisterOsirisListener("GameStarted", 2, "after", function(level, isEditorMode)
        for _, player in pairs(Osi.DB_IsPlayer:Get(nil)[1]) do Osi.ItemTemplateAddTo(JournalTemplate, player, 1, 1) end
    end)
end

--  ==================
--  REQUIRE DEBUG MODE
--  ==================

if Ext.IsDeveloperMode() then Ext.Require("DevMode.lua") end