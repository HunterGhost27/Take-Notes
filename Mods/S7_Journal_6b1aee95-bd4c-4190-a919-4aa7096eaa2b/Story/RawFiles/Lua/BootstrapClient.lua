Ext.Require("S7_JournalAuxiliary.lua")

BuildSpecs = {
    ["GMJournal"] = {
        ["Component"] = {
            ["Strings"] = {
                ["caption"] = "Your Journal",
                ["editButtonCaption"] = "TOGGLE EDIT MODE",
                ["addChapter"] = "Add New Chapter",
                ["addCategory"] = "Add New Category",
                ["addParagraph"] = "Add New Entry...",
                ["shareWithParty"] = "Share with Party"
            }
        }
    }
}

JournalUI = {}

local function handleJournal_Client(channel, payload)
    JournalUI = UCL.Journal
    if channel == "S7_HandleJournal" then
        local character, template, itemGuid = table.unpack(Ext.JsonParse(payload))
        if JournalUI.Exists == nil or JournalUI.Exists == false then
            UCL.S7_UCL_Build(Ext.JsonStringify(BuildSpecs))
        else
            JournalUI.Element.UI:Show()
        end
    end
end

--  =============================================================
Ext.RegisterNetListener("S7_HandleJournal", handleJournal_Client)
--  =============================================================