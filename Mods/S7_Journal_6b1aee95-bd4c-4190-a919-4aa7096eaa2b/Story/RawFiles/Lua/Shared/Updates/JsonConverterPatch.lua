--  ========================
--  JSON TO MARKDOWN PATCHER
--  ========================

Ext.RegisterListener('SessionLoaded', function()

    --  LOAD EXTERNAL FILES
    --  ===================

    local fileList = LoadFile(SubdirectoryPrefix .."fileList.json")
    if type(fileList) ~= 'table' then return end
    for _, fileName in pairs(fileList) do
        if fileName:match(".json") then
            local file = LoadFile(SubdirectoryPrefix .. fileName)
            PersistentVars.JournalData[fileName] = file
        end
    end

    --  PATCH PERSISTENT-VARS
    --  =====================

    for fileName, fileContents in pairs(PersistentVars.JournalData) do
        if fileName:match(".json") then
            S7Debug:FWarn("Deprecated External JSON JournalData detected. Patching...")
            Destringify(fileContents)
            local specs = UCL.Journalify(fileContents)
            local md = UCL.Markdownify(specs.GMJournal)
            local newFileName = fileName:sub(0, -5) .. "md"
            PersistentVars.JournalData[newFileName] = md
            PersistentVars.JournalData[fileName] = nil
            S7Debug:FWarn("Converted " .. fileName .. " to " .. newFileName)
        end
    end

    --  RESAVE EXTERNAL FILES
    --  =====================

    for pos, fileName in pairs(fileList) do
        local newFileName = fileName:sub(0, -5) .. "md"
        if PersistentVars.JournalData[newFileName] then
            SaveFile(SubdirectoryPrefix .. newFileName, PersistentVars.JournalData[newFileName])
            PersistentVars.JournalData[newFileName] = nil
            S7Debug:FWarn("Resaving " .. fileName .. " as " .. newFileName)
        end
        fileList[pos] = nil
        SaveFile(SubdirectoryPrefix .. "fileList.json", fileList)
    end
end)