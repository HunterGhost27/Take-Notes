--  =======
--  IMPORTS
--  =======

Ext.Require("Shared/Auxiliary.lua")
Ext.Require("Client/ContextMenu.lua")
Ext.Require("Client/TreasureTables.lua")

--  ========
--  NOTEBOOK
--  ========

Notebook = {
    ["FileName"] = "",
    ["Data"] = {},
}

--  ==================
--  FETCH JOURNAL DATA
--  ==================

local function SaveJournal()
    if Notebook.Data.Component.Name ~= "S7_Notebook" then return end
    Debug:Print("Saving " .. Notebook.Data.Component.Name)
    local saveData = {
        ["ID"] = "SaveJournal",
        ["fileName"] = Notebook.FileName,
        ["Data"] = UCL.Markdownify(Notebook.Data)
    }
    Ext.PostMessageToServer(IDENTIFIER, Ext.JsonStringify(saveData))
end

--  ==============
--  HANDLE JOURNAL
--  ==============

Ext.RegisterNetListener(IDENTIFIER, function (channel, payload)
    local journal = Ext.JsonParse(payload)
    if journal.ID == "CharacterOpenJournal" then
        Notebook.FileName = journal.Data.fileName
        Debug:Print("Dispatching BuildSpecs to UI-Components-Library")
        local BuildSpecs = Rematerialize(journal.Data.content)
        BuildSpecs = Integrate(BuildSpecs, {["GMJournal"] = {["Component"] = {["Listeners"] = {["Before:S7_Journal_UI_Hide"] = function(ui, call, ...) SaveJournal() end}}}})
        Notebook.Data = UCL.Render(BuildSpecs)
    end
end)