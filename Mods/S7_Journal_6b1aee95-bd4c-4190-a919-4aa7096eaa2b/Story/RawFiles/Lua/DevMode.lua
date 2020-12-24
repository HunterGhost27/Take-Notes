--  ==========================
--      CONSOLE COMMANDS
--  ==========================

--  ADD JOURNAL
--  -----------

--- Add Journal to HostCharacter
local function addJournal()
    Osi.ItemTemplateAddTo(JournalTemplate, Osi.CharacterGetHostCharacter(), 1, 1)
    S7DebugPrint("BOOK_S7_Notebook Added to Host's Inventory", "DevMode")
end

--  LIST PERSISTENT JOURNALS
--  ------------------------

--- List Journal entries in PersistentVars
local function listPersistentJournals()
    if PersistentVars.JournalData then for fileName, _ in pairs(PersistentVars.JournalData) do S7DebugPrint(fileName, "DevMode") end end
end

--  EXPORT PERSISTENT JOURNALS
--  --------------------------

--- Export PersistentVars to OsirisData
---@param param string fileName or 'all'
local function exportPersistentJournals(param)
    if PersistentVars.JournalData then
        if string.lower(param) == "all" then
            for fileName, contents in pairs(PersistentVars.JournalData) do
                SaveFile(IDENTIFIER .. "/" .. tostring(fileName), contents)
                S7DebugPrint("Exported: " .. tostring(fileName), "DevMode")
            end
        elseif PersistentVars.JournalData[param] then
            SaveFile(IDENTIFIER .. "/" .. tostring(param), PersistentVars.JournalData[param])
            S7DebugPrint("Exported: " .. tostring(param), "DevMode")
        else S7DebugPrint("No match found: " .. tostring(param), "DevMode") end
    else S7DebugPrint("No entries in PersistentVars", "DevMode")
    end
end

--  IMPORT TO PERSISTENT JOURNALS
--  -----------------------------

--- Import file from OsirisData into PersistentVars
---@param param string fileName
local function importFromOsirisData(param)
    local file = LoadFile(IDENTIFIER .. "/" .. tostring(param) .. ".json")
    if file then
        PersistentVars.JournalData[tostring(param) .. ".json"] = Ext.JsonParse(file)
        S7DebugPrint("Imported from OsirisData: " .. tostring(param), "DevMode")
    else
        S7DebugPrint("Could not import file: " .. tostring(param), "DevMode")
    end
end

--  REMOVE JOURNAL DATA
--  -------------------

--- Remove Journal entry from PersistentVars
---@param param string fileName or 'all'
local function removeJournalData(param)
    if string.lower(tostring(param)) == "all" then
        PersistentVars.JournalData = nil
        S7DebugPrint("Removed all entries from PersistentVars", "DevMode")
    elseif PersistentVars.JournalData[tostring(param)] ~= nil then
        PersistentVars.JournalData[tostring(param)] = nil
        S7DebugPrint("Removed: " .. tostring(param), "DevMode")
    else S7DebugPrint("Invalid Parameter", "DevMode") end
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
