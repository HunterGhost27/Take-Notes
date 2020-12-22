--  ==========================
--      CONSOLE COMMANDS
--  ==========================

--  ADD JOURNAL
--  -----------

--- Add Journal to HostCharacter
local function addJournal()
    Osi.ItemTemplateAddTo(JournalTemplate, Osi.CharacterGetHostCharacter(), 1, 1)
    S7DebugPrint("BOOK_S7_Notebook Added to Host's Inventory", "DebugMode")
end

--  LIST PERSISTENT JOURNALS
--  ------------------------

--- List Journal entries in PersistentVars
local function listPersistentJournals()
    if PersistentVars.JournalData then for fileName, _ in pairs(PersistentVars.JournalData) do S7DebugPrint(fileName, "DebugMode") end end
end

--  EXPORT PERSISTENT JOURNALS
--  --------------------------

--- Export PersistentVars to OsirisData
---@param param string fileName or 'all'
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

--- Remove Journal entry from PersistentVars
---@param param string fileName or 'all'
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

--- Console Commands
---@param cmd string S7_Journal
---@param command string Command Name
---@vararg string[] Command Arguments
Ext.RegisterConsoleCommand(IDENTIFIER, function (cmd, command, ...)
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
