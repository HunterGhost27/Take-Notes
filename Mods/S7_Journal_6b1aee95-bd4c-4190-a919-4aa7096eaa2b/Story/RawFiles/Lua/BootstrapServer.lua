--  ======
--  IMPORT
--  ======

Ext.Require("S7_JournalAuxiliary.lua")

--  =================
--  FETCH PLAYER DATA
--  =================

CharacterInfo = {
    ["clientCharacters"] = {}, -- Information about all clients
    ["hostCharacter"] = {} -- Information about host
}

local function FetchPlayers()

    --  CLIENT CHARACTERS
    --  -----------------
    local count = 1
    local tempUsers = {} --  Temporary table.
    for _, player in ipairs(Osi.DB_IsPlayer:Get(nil)[1] or {}) do --  Extract Player CharacterGUIDs
        tempUsers[count] = Osi.CharacterGetReservedUserID(player) --  Get UserIDs
        count = count + 1
    end

    for _, user in ipairs(tempUsers) do -- Iterate over all active characters
        local userProfileID = Osi.GetUserProfileID(user) -- Get User's ProfileID
        local _, characterName = Osi.CharacterGetDisplayName(Osi.GetCurrentCharacter(user)) -- Get Controlled Character's DisplayName
        -- Build ClientCharacter table.
        CharacterInfo.clientCharacters[userProfileID] = {
            ["userID"] = user,
            ["userName"] = Osi.GetUserName(user),
            ["userProfileID"] = Osi.GetUserProfileID(user),
            ["hostUserProfileID"] = Osi.GetUserProfileID(Osi.CharacterGetReservedUserID(Osi.CharacterGetHostCharacter())),
            ["currentCharacter"] = Osi.GetCurrentCharacter(user),
            ["currentCharacterName"] = characterName
        }
    end
    --  HOST CHARACTER
    --  --------------
    local hostUserID = Osi.CharacterGetReservedUserID(Osi.CharacterGetHostCharacter()) -- Get Host Character's UserID
    local _, hostCharacterName = Osi.CharacterGetDisplayName(Osi.GetCurrentCharacter(hostUserID)) -- Host Character's DisplayName
    --   Build Host Character's table.
    CharacterInfo.hostCharacter = {
        ["hostUserID"] = hostUserID,
        ["hostUserName"] = Osi.GetUserName(hostUserID),
        ["hostProfileID"] = Osi.GetUserProfileID(hostUserID),
        ["currentCharacter"] = Osi.GetCurrentCharacter(hostUserID),
        ["currentCharacterName"] = hostCharacterName
    }
    S7DebugPrint("Built CharacterInfo Table.", "BootstrapServer")
end

--  ===============================================================
Ext.RegisterOsirisListener("GameStarted", 2, "after", FetchPlayers)
--  ===============================================================

--  ======================
--  BROADCAST SERVER READY
--  ======================

Ext.RegisterOsirisListener("GameStarted", 2, "after", function()
    S7DebugPrint("Server Ready.", "BootstrapServer")
    local signal = {["ID"] = "S7_JournalServerReady", ["Data"] = "S7_JournalServerReady"}
    Ext.BroadcastMessage("S7_Journal", Ext.JsonStringify(signal))
end)

--  ==================================
--  RESPOND TO CHARACTER-INFO REQUESTS
--  ==================================

Ext.RegisterNetListener("S7_Journal", function (channel, stringifiedPayload)
    local charInfoRequest = Ext.JsonParse(stringifiedPayload)
    if charInfoRequest.ID == "RequestingCharacterInfo" then
        FetchPlayers()
        for _, player in ipairs(Osi.DB_IsPlayer:Get(nil)[1]) do
            S7DebugPrint("Dispatching CharacterInfo to " .. player, "BootstrapServer")
            local userProfileID = Osi.GetUserProfileID(Osi.CharacterGetReservedUserID(player))
            local package = {["ID"] = "ProvidingCharacterInfo", ["Data"] = CharacterInfo.clientCharacters[userProfileID]}
            Ext.PostMessageToClient(player, "S7_Journal", Ext.JsonStringify(package))
        end
    end
end)

--  ============
--  OPEN JOURNAL
--  ============

Ext.RegisterOsirisListener("CharacterUsedItemTemplate", 3, "after", function (character, template, itemGuid)
    if template == JournalTemplate then
        S7DebugPrint(character .. " opened Journal.", "BootstrapServer")
        local package = table.pack(character, template, itemGuid)
        local payload = {["ID"] = "CharacterOpenJournal", ["Data"] = Rematerialize(package)}
        Ext.PostMessageToClient(character, "S7_Journal", Ext.JsonStringify(payload))
    end
end)

--  =====================
--  ADD TO HOST CHARACTER
--  =====================

Ext.RegisterOsirisListener("SavegameLoaded", 4, "after", function ()
    if Osi.ItemTemplateIsInCharacterInventory(Osi.CharacterGetHostCharacter(), JournalTemplate) < 1 then
        Osi.ItemTemplateAddTo(JournalTemplate, Osi.CharacterGetHostCharacter(), 1, 1)
    end
end)