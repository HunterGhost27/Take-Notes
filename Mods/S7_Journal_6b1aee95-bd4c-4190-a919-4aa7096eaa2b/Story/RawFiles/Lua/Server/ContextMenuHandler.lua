--  ====================
--  CONTEXT MENU HANDLER
--  ====================

Ext.RegisterNetListener("S7UCL_ContextMenu", function (channel, payload)
    if tonumber(payload) == 272 then
        ResynchronizeModSettings()
        local modSettings = LoadFile("Mods/S7_Journal_6b1aee95-bd4c-4190-a919-4aa7096eaa2b/Story/RawFiles/Lua/Server/ModSettings.json", "data")

        Ext.PostMessageToClient(Osi.CharacterGetHostCharacter(), "CharacterOpenModSettings", Ext.JsonStringify(modSettings))
    end
end)