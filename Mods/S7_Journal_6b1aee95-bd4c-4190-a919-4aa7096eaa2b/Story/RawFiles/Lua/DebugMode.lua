--  ==========================
--  ADD ITEM TO HOST CHARACTER
--  ==========================

local function addJournal()
    Osi.ItemTemplateAddTo(JournalTemplate, Osi.CharacterGetHostCharacter(), 1, 1)
    S7DebugPrint("S7_Journal Added to Host's Inventory", "S7_DebugMode")
end

local function listPersistentJournals()
    if PersistentVars.JournalData then for fileName, content in pairs(PersistentVars.JournalData) do S7DebugPrint(fileName, "DebugMode") end end
end

Ext.RegisterConsoleCommand("S7_Journal", function (cmd, command)
    if command == "AddJournal" then addJournal() end
    if command == "ResyncSettings" then ResynchronizeModSettings() end
    if command == "ListPersistentJournals" then listPersistentJournals() end
end)

-- Ext.RegisterOsirisListener("GameStarted", 2, "after", function (level, isEditorMode)
--     if Osi.ItemTemplateIsInCharacterInventory(Osi.CharacterGetHostCharacter(), JournalTemplate) < 1 then addJournal() end
-- end)
