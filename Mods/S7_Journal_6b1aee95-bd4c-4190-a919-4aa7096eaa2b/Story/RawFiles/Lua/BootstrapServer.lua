--  ======
--  IMPORT
--  ======

Ext.Require("S7_JournalAuxiliary.lua")

--  ==============
--  HANDLE JOURNAL
--  ==============

local function handleJournal_Server(character, template, itemGuid)
    if template ==  JournalTemplate then
        local package = table.pack(character, template, itemGuid)
        Ext.PostMessageToClient(character, "S7_HandleJournal", Ext.JsonStringify(package))
    end
end

--  =====================================================================================
Ext.RegisterOsirisListener("CharacterUsedItemTemplate", 3, "after", handleJournal_Server)
--  =====================================================================================

--  =====================
--  ADD TO HOST CHARACTER
--  =====================

Ext.RegisterOsirisListener("SavegameLoaded", 4, "after", function ()
    if Osi.ItemTemplateIsInCharacterInventory(Osi.CharacterGetHostCharacter(), JournalTemplate) < 1 then
        Osi.ItemTemplateAddTo(JournalTemplate, Osi.CharacterGetHostCharacter(), 1, 1)
    end
end)