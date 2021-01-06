--  ==========================
--      CONSOLE COMMANDS
--  ==========================

--  ADD JOURNAL
--  -----------

--- Add Journal to HostCharacter
local function addJournal()
    Osi.ItemTemplateAddTo(JournalTemplate, Osi.CharacterGetHostCharacter(), 1, 1)
    S7Debug:Print("BOOK_S7_Notebook added to host's inventory")
end

--  LIST PERSISTENT JOURNALS
--  ------------------------

--- List Journal entries in PersistentVars
local function listPersistentJournals()
    if PersistentVars.JournalData then for fileName, _ in pairs(PersistentVars.JournalData) do S7Debug:Print(fileName) end end
end

--  EXPORT PERSISTENT JOURNALS
--  --------------------------

--- Export PersistentVars to OsirisData
---@param param string fileName or 'all'
local function exportPersistentJournals(param)
    local param = param or "all"
    if PersistentVars.JournalData then
        if string.lower(param) == "all" then
            for fileName, contents in pairs(PersistentVars.JournalData) do
                SaveFile(SubdirectoryPrefix .. tostring(fileName), contents)
                S7Debug:Print("Exported: " .. tostring(fileName))
            end
        elseif PersistentVars.JournalData[param] then
            SaveFile(SubdirectoryPrefix .. tostring(param), PersistentVars.JournalData[param])
            S7Debug:Print("Exported: " .. tostring(param))
        else S7Debug:Warn("No match found: " .. tostring(param)) end
    else S7Debug:Warn("No entries in PersistentVars") end
end

--  IMPORT TO PERSISTENT JOURNALS
--  -----------------------------

--- Import file from OsirisData into PersistentVars
---@param param string fileName
local function importFromOsirisData(param)
    local file = LoadFile(SubdirectoryPrefix .. tostring(param))
    if file then
        PersistentVars.JournalData[tostring(param)] = file
        S7Debug:Print("Imported from OsirisData: " .. tostring(param))
    else S7Debug:Error("Could not import file: " .. tostring(param)) end
end

--  REMOVE JOURNAL DATA
--  -------------------

--- Remove Journal entry from PersistentVars
---@param param string fileName or 'all'
local function removeJournalData(param)
    if string.lower(tostring(param)) == "all" then
        PersistentVars.JournalData = nil
        S7Debug:Print("Removed all entries from PersistentVars")
    elseif PersistentVars.JournalData[tostring(param)] ~= nil then
        PersistentVars.JournalData[tostring(param)] = nil
        S7Debug:Print("Removed: " .. tostring(param))
    else S7Debug:Error("Invalid Parameter") end
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
    if command == "ImportFromOsirisData" then importFromOsirisData(args[1]) end
    if command == "RemoveJournalData" then removeJournalData(args[1]) end
end)

-- Ext.RegisterOsirisListener("GameStarted", 2, "after", function (level, isEditorMode)
--     if Osi.ItemTemplateIsInCharacterInventory(Osi.CharacterGetHostCharacter(), JournalTemplate) < 1 then addJournal() end
-- end)
