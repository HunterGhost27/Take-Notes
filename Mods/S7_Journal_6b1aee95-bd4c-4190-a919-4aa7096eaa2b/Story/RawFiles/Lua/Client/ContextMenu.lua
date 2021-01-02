--  ============
--  CONTEXT MENU
--  ============

UCL.ContextMenu:Register({
    ["RootTemplate::df7a8779-f908-43ac-b0ba-cb49d16308a9"] = {
        {
            ['actionID'] = 271,
            ['clickSound'] = true,
            ['text'] = "<font color='#3333AA'>Mod Information</font>",
            ['isDisabled'] = false,
            ['isLegal'] = true,
            ['action'] = function()
                local file = LoadFile("Mods/S7_Journal_6b1aee95-bd4c-4190-a919-4aa7096eaa2b/Story/RawFiles/Lua/Client/ModInformation.json", "data")
                UCL.UCLBuild(file)
            end
        },
        {
            ['actionID'] = 272,
            ['clickSound'] = true,
            ['text'] = "<font color='#AA6633'>Mod Settings</font>",
            ['isDisabled'] = false,
            ['isLegal'] = true
        }
    }
})
