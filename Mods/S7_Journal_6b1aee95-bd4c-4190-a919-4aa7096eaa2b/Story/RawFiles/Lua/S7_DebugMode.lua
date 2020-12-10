--  ==========================
--  ADD ITEM TO HOST CHARACTER
--  ==========================

Ext.RegisterOsirisListener("SavegameLoaded", 4, "after", function ()
    if Osi.ItemTemplateIsInCharacterInventory(Osi.CharacterGetHostCharacter(), JournalTemplate) < 1 then
        Osi.ItemTemplateAddTo(JournalTemplate, Osi.CharacterGetHostCharacter(), 1, 1)
    end
end)