--  ============
--  CONTEXT MENU
--  ============

Ext.RegisterListener('SessionLoaded', function ()
    local activator = "RootTemplate::" .. JournalTemplate
    local ctxMenu = UCL.ContextMenu:Get(activator) or {}

    table.insert(ctxMenu, {
        ['actionID'] = 27501,
        ['clickSound'] = true,
        ['text'] = Color:Blue("Mod Information"),
        ['isDisabled'] = false,
        ['isLegal'] = true
    })

    UCL.ContextMenu:Register({ [activator] = ctxMenu })
end)

Ext.RegisterNetListener("S7UCL::ContextMenu", function (channel, payload)
    local payload = Ext.JsonParse(payload) or {}
    Destringify(payload)
    if payload.actionID == 27501 then
        local manual = LoadFile("Mods/S7_Journal_6b1aee95-bd4c-4190-a919-4aa7096eaa2b/ModInformation.md", "data")

        local replacers = {
            {["?TakeNotesVersion"] = Version:Parse(MODINFO.Version):String()},
            {["?TakeNotesAuthor"] = MODINFO.Author},
            {["?TakeNotesDescription"] = MODINFO.Description},
            {["?UCLVersion"] = Version:Parse(UCL.MODINFO.Version):String()},
            {["?UCLAuthor"] = UCL.MODINFO.Author},
            {["?UCLDescription"] = UCL.MODINFO.Description},
            {["?UniquesOption"] = tostring(MODINFO.ModSettings.Uniques)},
            {["?StorageOption"] = tostring(MODINFO.ModSettings.Storage)},
            {["?SyncOption"] = tostring(MODINFO.ModSettings.SyncTo)}
        }

        local specs = UCL.Journalify(manual, replacers)
        specs = Integrate(specs, {["GMJournal"] = {
            ["Component"] = {["Name"] = "S7_NotebookCtxMenu"},
            ["SubComponent"] = {["ToggleEditButton"] = {["Visible"] = false}}
        }})
        UCL.Render(specs)
    end
end)