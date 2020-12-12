--  ==========================
--  ADD ITEM TO HOST CHARACTER
--  ==========================

local function addJournal()
    Osi.ItemTemplateAddTo(JournalTemplate, Osi.CharacterGetHostCharacter(), 1, 1)
end

Ext.RegisterConsoleCommand("S7_Journal", function (cmd, command)
    if command == "AddJournal" then addJournal() end
end)

Ext.RegisterOsirisListener("GameStarted", 2, "after", function (level, isEditorMode)
    if Osi.ItemTemplateIsInCharacterInventory(Osi.CharacterGetHostCharacter(), JournalTemplate) < 1 then addJournal() end
end)
