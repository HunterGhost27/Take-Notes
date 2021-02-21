--  ==========================
--      CONSOLE COMMANDS
--  ==========================

--  ADD JOURNAL
--  -----------

ConsoleCommander:Register({
    Name = 'AddJournal',
    Description = 'Adds a new notebook to the host character',
    Context = 'Server',
    Action = function ()
        Osi.ItemTemplateAddTo(JournalTemplate, Osi.CharacterGetHostCharacter(), 1, 1)
        Debug:Print("BOOK_S7_Notebook added to host's inventory")
    end
})

--  LIST PERSISTENT JOURNALS
--  ------------------------

ConsoleCommander:Register({
    Name = 'ListPersistentJournals',
    Description = 'Lists Journal entries in PersistentVars',
    Context = 'Server',
    Action = function ()
        ForEach(PersistentVars.JournalData, function (fileName) Debug:Print(fileName) end)
    end,
})

--  EXPORT PERSISTENT JOURNALS
--  --------------------------

ConsoleCommander:Register({
    Name = 'ExportJournalData',
    Description = 'Export PersistentVar journal entries to OsirisData',
    Context = 'Server',
    Params = {'param'},
    Action = function (param)
        local param = param or "all"
        if PersistentVars.JournalData then
            if string.lower(param) == "all" then
                for fileName, contents in pairs(PersistentVars.JournalData) do
                    SaveFile(MODINFO.SubdirPrefix .. tostring(fileName), contents)
                    Debug:Print("Exported: " .. tostring(fileName))
                end
            elseif PersistentVars.JournalData[param] then
                SaveFile(MODINFO.SubdirPrefix .. tostring(param), PersistentVars.JournalData[param])
                Debug:Print("Exported: " .. tostring(param))
            else Debug:Warn("No match found: " .. tostring(param)) end
        else Debug:Warn("No entries in PersistentVars") end
    end,
})

--  IMPORT TO PERSISTENT JOURNALS
--  -----------------------------

ConsoleCommander:Register({
    Name = 'ImportJournalData',
    Description = "Import file from OsirisData into PersistentVars",
    Context = 'Server',
    Params = {'param'},
    Action = function (param)
        local file = LoadFile(MODINFO.SubdirPrefix .. tostring(param))
        if file then
            PersistentVars.JournalData[tostring(param)] = file
            Debug:Print("Imported from OsirisData: " .. tostring(param))
        else Debug:Error("Could not import file: " .. tostring(param)) end
    end,
})

--  REMOVE JOURNAL DATA
--  -------------------

ConsoleCommander:Register({
    Name = 'RemoveJournalData',
    Description = "Remove journal entry from PersistentVars",
    Context = 'Server',
    Params = {'param'},
    Action = function (param)
        if string.lower(tostring(param)) == "all" then
            PersistentVars.JournalData = nil
            Debug:Print("Removed all entries from PersistentVars")
        elseif PersistentVars.JournalData[tostring(param)] ~= nil then
            PersistentVars.JournalData[tostring(param)] = nil
            Debug:Print("Removed: " .. tostring(param))
        else Debug:Error("Invalid Parameter") end
    end,
})
