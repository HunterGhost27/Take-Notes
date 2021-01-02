--  ============
--  CONTEXT MENU
--  ============

UCL.ContextMenu:Register({
    ["RootTemplate::df7a8779-f908-43ac-b0ba-cb49d16308a9"] = {
        {
            -- ["ID"] = 1,
            ["actionID"] = 271,
            ['clickSound'] = true,
            ['text'] = "<font color='#3333CC'>Foo</font>",
            ['isDisabled'] = false,
            ['isLegal'] = true,
            ['action'] = function() Ext.Print("Foo") end
        },
        {
        -- ["ID"] = 2,
        ["actionID"] = 272,
        ['clickSound'] = true,
        ['text'] = "<font color='#CC3333'>Bar</font>",
        ['isDisabled'] = false,
        ['isLegal'] = true,
        ['action'] = function() Ext.Print("Bar") end
        }
    }
})
