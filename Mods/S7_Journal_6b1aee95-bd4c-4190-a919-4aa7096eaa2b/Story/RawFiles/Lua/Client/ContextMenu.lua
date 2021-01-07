--  ============
--  CONTEXT MENU
--  ============

UCL.ContextMenu:Register({
    ["RootTemplate::" .. JournalTemplate] = {
        {
            ['actionID'] = 27001,
            ['clickSound'] = true,
            ['text'] = Color:Blue("Mod Information"),
            ['isDisabled'] = false,
            ['isLegal'] = true
        }
    }
})

Ext.RegisterNetListener("S7UCL::ContextMenu", function (channel, payload)
    local payload = Ext.JsonParse(payload) or {}
    Destringify(payload)
    if payload.actionID == 27001 then
        local manual = LoadFile("Mods/S7_Journal_6b1aee95-bd4c-4190-a919-4aa7096eaa2b/ModInformation.md", "data")
        local replacers = {
            {["?TakeNotesVersion"] = ParseVersion(ModInfo.Version, 'string')}, {["?TakeNotesAuthor"] = ModInfo.Author},
            {["?UCLVersion"] = ParseVersion(UCL.ModInfo.Version, 'string')}, {["?UCLAuthor"] = UCL.ModInfo.Author}
        }
        local specs = UCL.Journalify(manual, replacers)

        specs = Integrate(specs, {["GMJournal"] = {
            ["Component"] = {["Name"] = "S7_NotebookCtxMenu"},
            ["SubComponent"] = {["ToggleEditButton"] = {["Visible"] = false}}
        }})
        UCL.Render(specs)
    end
end)