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

        S7Debug:Print("Created Treasure Category for Journals")

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
            S7Debug:Print("Added Journals to treasure-table: " .. target)
        end
    end)
else
    Ext.RegisterListener("StatsLoaded", function()
        local stat = Ext.GetStat("BOOK_S7_JournalStat")
        stat.Unique = 1
    end)
end