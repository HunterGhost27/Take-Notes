--  ==========================
--      CONSOLE COMMANDS
--  ==========================

--  ADD JOURNAL
--  -----------

local function addJournal()
    Osi.ItemTemplateAddTo(JournalTemplate, Osi.CharacterGetHostCharacter(), 1, 1)
    S7DebugPrint("BOOK_S7_Notebook Added to Host's Inventory", "S7_DebugMode")
end

--  LIST PERSISTENT JOURNALS
--  ------------------------

local function listPersistentJournals()
    if PersistentVars.JournalData then for fileName, _ in pairs(PersistentVars.JournalData) do S7DebugPrint(fileName, "DebugMode") end end
end

--  EXPORT PERSISTENT JOURNALS
--  --------------------------

local function exportPersistentJournals(param)
    if PersistentVars.JournalData then
        if string.lower(param) == "all" then
            for fileName, contents in pairs(PersistentVars.JournalData) do
                Ext.SaveFile(IDENTIFIER .. "/" .. tostring(fileName) .. ".json", Ext.JsonStringify(contents))
                S7DebugPrint("Exported: " .. tostring(fileName), "DebugMode")
            end
        elseif PersistentVars.JournalData[param] then
            Ext.SaveFile(IDENTIFIER .. "/" .. tostring(param) .. ".json", Ext.JsonStringify(PersistentVars.JournalData[param]))
            S7DebugPrint("Exported: " .. tostring(param), "DebugMode")
        else S7DebugPrint("No match found: " .. tostring(param), "DebugMode") end
    else S7DebugPrint("No entries in PersistentVars", "DebugMode")
    end
end

--  REMOVE JOURNAL DATA
--  -------------------

local function removeJournalData(param)
    if string.lower(tostring(param)) == "all" then
        PersistentVars.JournalData = nil
        S7DebugPrint("Removed all entries from PersistentVars", "DebugMode")
    elseif PersistentVars.JournalData[tostring(param)] ~= nil then
        PersistentVars.JournalData[tostring(param)] = nil
        S7DebugPrint("Removed: " .. tostring(param), "DebugMode")
    else S7DebugPrint("Invalid Parameter", "DebugMode") end
end

--  =========================
--  REGISTER CONSOLE COMMANDS
--  =========================

Ext.RegisterConsoleCommand("S7_Journal", function (cmd, command, ...)
    local args = {...}
    if command == "AddJournal" then addJournal() end
    if command == "ResyncSettings" then ResynchronizeModSettings() end
    if command == "ListPersistentJournals" then listPersistentJournals() end
    if command == "ExportPersistentJournals" then exportPersistentJournals(args[1]) end
    if command == "RemoveJournalData" then removeJournalData(args[1]) end
end)

-- Ext.RegisterOsirisListener("GameStarted", 2, "after", function (level, isEditorMode)
--     if Osi.ItemTemplateIsInCharacterInventory(Osi.CharacterGetHostCharacter(), JournalTemplate) < 1 then addJournal() end
-- end)
