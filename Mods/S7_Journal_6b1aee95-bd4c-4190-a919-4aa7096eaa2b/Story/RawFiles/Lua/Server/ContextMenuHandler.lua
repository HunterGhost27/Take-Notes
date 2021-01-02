--  ====================
--  CONTEXT MENU HANDLER
--  ====================

Ext.RegisterNetListener("S7UCL_ContextMenu", function(channel, payload)
    if payload == "271" then S7Debug:Print("271 SUCCESS") end
    if payload == "272" then S7Debug:Print("272 SUCCESS") end
end)