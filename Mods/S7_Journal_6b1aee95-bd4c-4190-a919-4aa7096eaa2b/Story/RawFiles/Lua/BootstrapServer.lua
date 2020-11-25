Ext.Require("S7_JournalAuxiliary.lua")

local function handleJournal_Server(character, template, itemGuid)
    if template ==  "BOOK_S7_Journal_df7a8779-f908-43ac-b0ba-cb49d16308a9" then
        local package = table.pack(character, template, itemGuid)
        Ext.PostMessageToClient(character, "S7_HandleJournal", Ext.JsonStringify(package))
    end
end

--  =====================================================================================
Ext.RegisterOsirisListener("CharacterUsedItemTemplate", 3, "after", handleJournal_Server)
--  =====================================================================================

Ext.RegisterOsirisListener("SavegameLoaded", 4, "after", function ()
    if Osi.ItemTemplateIsInCharacterInventory(Osi.CharacterGetHostCharacter(), "BOOK_S7_Journal_df7a8779-f908-43ac-b0ba-cb49d16308a9") < 1 then
        Osi.ItemTemplateAddTo("BOOK_S7_Journal_df7a8779-f908-43ac-b0ba-cb49d16308a9", Osi.CharacterGetHostCharacter(), 1, 1)
    end
end)