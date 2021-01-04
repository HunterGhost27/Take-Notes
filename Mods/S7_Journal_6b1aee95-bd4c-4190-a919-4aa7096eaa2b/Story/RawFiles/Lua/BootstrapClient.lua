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
    if UCL.Journal.Component.Name ~= "S7_Notebook" then return end
    S7Debug:Print("Saving " .. UCL.Journal.Component.Name)
    local saveData = {
        ["ID"] = "SaveJournal",
        ["fileName"] = FileName,
        ["Data"] = UCL.Markdownify(UCL.Journal)
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
        local BuildSpecs = Rematerialize(journal.Data.content)
        BuildSpecs = Integrate(BuildSpecs, {["GMJournal"] = {
            ["Component"] = {
                ["Name"] = "S7_Notebook",
                ["Listeners"] = {["S7_Journal_UI_Hide"] = function(ui, call, ...) SaveJournal() end}
            }
        }})
        UCL.UCLBuild(BuildSpecs)
    end
end)