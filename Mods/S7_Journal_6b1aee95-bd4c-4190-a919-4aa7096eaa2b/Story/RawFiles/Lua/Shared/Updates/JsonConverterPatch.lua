--  ========================
--  JSON TO MARKDOWN PATCHER
--  ========================

Ext.RegisterListener('SessionLoaded', function()

    --  LOAD EXTERNAL FILES
    --  ===================

    local fileList = LoadFile("TakeNotes/fileList.json")
    for _, fileName in pairs(fileList) do
        local file = LoadFile("TakeNotes/" .. fileName)
        PersistentVars.JournalData[fileName] = file
    end

    --  PATCH PERSISTENT-VARS
    --  =====================

    for fileName, fileContents in pairs(PersistentVars.JournalData) do
        if string.match(fileName, ".json") then
            S7Debug:FWarn("Deprecated External JSON JournalData detected. Patching...")
            local specs = UCL.Journalify(fileContents)
            local md = UCL.Markdownify(specs.GMJournal.JournalData)
            local newFileName = fileName:sub(0, -5) .. "md"
            PersistentVars.JournalData[newFileName] = md
            PersistentVars.JournalData[fileName] = nil
            S7Debug:FWarn("Converted " .. fileName .. " to " .. newFileName)
        end
    end

    --  RESAVE EXTERNAL FILES
    --  =====================

    for _, fileName in pairs(fileList) do
        local newFileName = fileName:sub(0, -5) .. "md"
        if PersistentVars.JournalData[newFileName] then
            SaveFile(newFileName, PersistentVars.JournalData[newFileName])
            S7Debug:FWarn("Resaving " .. fileName .. " as " .. newFileName)
        end
    end
end)