--  =======
--  IMPORTS
--  =======

Ext.Require("Auxiliary.lua")

--  ==================
--  FETCH JOURNAL DATA
--  ==================

FileName = ""
local function SaveJournal()
    local journal = {
        ["ID"] = "SaveJournal",
        ["fileName"] = FileName,
        ["Data"] = {
            ["Component"] = Rematerialize(UCL.Journal.Component),
            ["SubComponent"] = Rematerialize(UCL.Journal.SubComponent),
            ["JournalData"] = Rematerialize(UCL.Journal.JournalData)
        }
    }
    Ext.PostMessageToServer(IDENTIFIER, Ext.JsonStringify(journal))
end

--  ==============
--  HANDLE JOURNAL
--  ==============

Ext.RegisterNetListener(IDENTIFIER, function (channel, payload)
    local journal = Ext.JsonParse(payload)
    if journal.ID == "CharacterOpenJournal" then
        FileName = journal.Data.fileName
        S7DebugPrint("Dispatching BuildSpecs to UI-Components-Library.", "BootstrapClient")
        local BuildSpecs = {["GMJournal"] = Rematerialize(journal.Data.content)}
        if not UCL.Journal.Exists then
            UCL.UCLBuild(BuildSpecs)
            Ext.RegisterUICall(UCL.Journal.UI, "S7_Journal_UI_Hide", function (ui, call, ...)
                SaveJournal()
                UCL.UnloadJournal()
            end)
        else UCL.UCLBuild(BuildSpecs) end
        SaveJournal()
    end
end)

--  ===============
--  TREASURE TABLES
--  ===============


if not CENTRAL[IDENTIFIER].ModSettings.Uniques then
    Ext.RegisterListener("StatsLoaded", function()
        local treasureCat = {
            ["Category"] = "I_BOOK_S7_JournalStat",
            ["Items"] =
            {
                {
                    ["ActPart"] = 5,
                    ["MaxAmount"] = 1,
                    ["MaxLevel"] = 0,
                    ["MinAmount"] = 1,
                    ["MinLevel"] = 5,
                    ["Name"] = "BOOK_S7_JournalStat",
                    ["Priority"] = 1,
                    ["Unique"] = 0
                },
            }
        }

        Ext.UpdateTreasureCategory("I_BOOK_S7_JournalStat", treasureCat)

        S7DebugPrint("Created Treasure Category for Journals", "BootstrapClient")

        local targetTreasureTables = {
            "ST_IngredientsTrader",
            "ST_KitchenThings",
            "ST_PaperWork"
        }

        for _, target in pairs(targetTreasureTables) do
            local treasure = Ext.GetTreasureTable(target)
            treasure.SubTables[#treasure.SubTables+1] = {
                ["Categories"] = {
                    {
                        ["Common"] = 0,
                        ["Divine"] = 0,
                        ["Epic"] = 0,
                        ["Frequency"] = 1,
                        ["Legendary"] = 0,
                        ["Rare"] = 0,
                        ["TreasureCategory"] =  "I_BOOK_S7_JournalStat",
                        ["Uncommon"] = 0,
                        ["Unique"] = 0
                    }
                },
                ["DropCounts"] = {
                    {
                        ["Amount"] = 1,
                        ["Chance"] = 0
                    },
                    {
                        ["Amount"] = 1,
                        ["Chance"] = 1
                    }
                },
                ["EndLevel"] = 0,
                ["StartLevel"] = 0,
                ["TotalCount"] = 1
            }
            Ext.UpdateTreasureTable(treasure)
            S7DebugPrint("Added Journals to treasure-table: " .. target, "BootstrapClient")
        end
    end)
else
    Ext.RegisterListener("StatsLoaded", function()
        local stat = Ext.GetStat("BOOK_S7_JournalStat")
        stat.Unique = 1
    end)
end