--  =======
--  IMPORTS
--  =======

Ext.Require("S7_JournalAuxiliary.lua")

Character = nil
BuildSpecs = {}
S7Journal = {}

function LoadJournal()
    local file = Ext.LoadFile("S7Journal.json") or ""
    if ValidString(file) then
        S7Journal = Ext.JsonParse(file)
    else
        S7Journal = {
            ["JournalData"] = {},
            ["JournalMetaData"] = {
                ["CategoryEntryMap"] = {},
                ["ChapterEntryMap"] = {},
                ["ParagraphEntryMap"] = {}
            }
        }
    end

    BuildSpecs = {
        ["GMJournal"] = {
            ["Component"] = {
                ["Strings"] = {
                    ["caption"] = "Fane's Journal",
                    ["editButtonCaption"] = "TOGGLE EDIT MODE",
                    ["addChapter"] = "Add New Chapter",
                    ["addCategory"] = "Add New Category",
                    ["addParagraph"] = "Add New Entry...",
                    ["shareWithParty"] = "Share with Party"
                },
            },
            ["JournalMetaData"] = {},
            ["JournalData"] = {
                [1] = {
                    ["JournalNodeType"] = 1,
                    ["entriesMapId"] = 2000000,
                    ["parentMapId"] = 2000000,
                    ["StringContent"] = "Driftwood",
                    ["isShared"] = false,
                    ["Chapters"] = {
                        [1] = {
                            ["JournalNodeType"] = 2,
                            ["entriesMapId"] = 2001000,
                            ["parentMapId"] = 2000000,
                            ["StringContent"] = "Shopping List",
                            ["isShared"] = false,
                        },
                        [2] = {
                            ["JournalNodeType"] = 2,
                            ["entriesMapId"] = 2002000,
                            ["parentMapId"] = 2000000,
                            ["StringContent"] = "Todos",
                            ["isShared"] = false,
                            ["Paragraphs"] = {
                                [1] = {
                                    ["JournalNodeType"] = 3,
                                    ["entriesMapId"] = 2002001,
                                    ["parentMapId"] = 2000000,
                                    ["StringContent"] = "<font color='#3333CC'>Investigate Rumour:</font> Seagulls killed Bishop Alexandar?",
                                    ["isShared"] = false,
                                }
                            }
                        }
                    }
                },
                [2] = {
                    ["JournalNodeType"] = 1,
                    ["entriesMapId"] = 1000000,
                    ["parentMapId"] = 1000000,
                    ["StringContent"] = "Fort <font color='#CC3333'>Misery</font>",
                    ["isShared"] = false,
                    ["Chapters"] = {
                        [1] = {
                            ["JournalNodeType"] = 2,
                            ["entriesMapId"] = 1003000,
                            ["parentMapId"] = 1000000,
                            ["StringContent"] = "<font color='#3333CC'>Escape Plan</font>",
                            ["isShared"] = false,
                        },
                        [2] = {
                            ["JournalNodeType"] = 2,
                            ["entriesMapId"] = 1002000,
                            ["parentMapId"] = 1000000,
                            ["StringContent"] = "Chapter Two: Crocodilian Boogaloo",
                            ["isShared"] = false,
                        },
                        [3] = {
                            ["JournalNodeType"] = 2,
                            ["entriesMapId"] = 1001000,
                            ["parentMapId"] = 1000000,
                            ["StringContent"] = "Teenage Mutant Explosive Turtles",
                            ["isShared"] = false,
                            ["Paragraphs"] = {
                                [1] = {
                                    ["JournalNodeType"] = 3,
                                    ["entriesMapId"] = 1001001,
                                    ["parentMapId"] = 1001000,
                                    ["StringContent"] = "Exploding Turtles!!! What's next? ... Teleporting Crocodiles?!",
                                    ["isShared"] = false
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    local entryMaps = {
        "CategoryEntryMap",
        "ChapterEntryMap",
        "ParagraphEntryMap"
    }

    for _, x in pairs(entryMaps) do
        if S7Journal["JournalMetaData"] ~= nil and S7Journal["JournalMetaData"][x] ~= nil then
            BuildSpecs.GMJournal.JournalMetaData[x] = S7Journal["JournalMetaData"][x] or {}
        end
    end
end

--  ==============================================
Ext.RegisterListener("SessionLoaded", LoadJournal)
--  ==============================================

local function handleJournal_Client(channel, payload)
    if channel == "S7_HandleJournal" then
        local package = Ext.JsonParse(payload)
        Character = package["1"]
        local tempate = package["2"]
        local itemGuid = package["3"]

        if not UCL.UILibrary.GMJournal.Exists then
            UCL.UCLBuild(Ext.JsonStringify(BuildSpecs))
            SaveJournal()
            Ext.RegisterUICall(UCL.UILibrary.GMJournal.UI, "S7_UI_Journal_Hide", function (ui, call, ...)
                SaveJournal()
            end)
        else
            UCL.UILibrary.GMJournal.UI:Show()
        end
    end
end

--  =============================================================
Ext.RegisterNetListener("S7_HandleJournal", handleJournal_Client)
--  =============================================================

function SaveJournal()
    local saveTable = {}
    S7Journal["JournalMetaData"] = {
        ["CategoryEntryMap"] = UCL.UILibrary.GMJournal.JournalMetaData.CategoryEntryMap,
        ["ChapterEntryMap"] = UCL.UILibrary.GMJournal.JournalMetaData.ChapterEntryMap,
        ["ParagraphEntryMap"] = UCL.UILibrary.GMJournal.JournalMetaData.ParagraphEntryMap,
    }
    Ext.Print("MetaData")
    Ext.Print(Ext.JsonStringify(S7Journal["JournalMetaData"]))
    Ext.Print("===============================================")
    for i, catID in pairs(UCL.UILibrary.GMJournal.JournalMetaData.CategoryEntryMap) do
        local object = UCL.UILibrary.GMJournal.Root.entriesMap[catID]
        if object ~= nil then
            saveTable[i] = {
                ["JournalNodeType"] = 1,
                ["entriesMapId"] = catID,
                ["parentMapId"] = catID,
                ["StringContent"] = object.editableElement_mc._text.htmlText,
                -- ["isShared"] = object.editableElement_mc._shared or false,
            }
            S7Journal["JournalMetaData"]["CategoryEntryMap"][i] = catID
        end
        for parentID, chapGroup in pairs(UCL.UILibrary.GMJournal.JournalMetaData.ChapterEntryMap) do
            if catID == parentID then
                if saveTable[i]["Chapters"] == nil then
                    saveTable[i]["Chapters"] = {}
                end
                for j, chapID in pairs(chapGroup) do
                    saveTable[i]["Chapters"][j] = {
                        ["JournalNodeType"] = 2,
                        ["entriesMapId"] = chapID,
                        ["parentMapId"] = catID,
                        ["StringContent"] = object._chapters[j].editableElement_mc._text.htmlText,
                        -- ["isShared"] = object.editableElement_mc._shared or false,
                    }
                    S7Journal["JournalMetaData"]["ChapterEntryMap"][catID][j] = chapID
                    -- for pID, paraGroup in pairs(UCL.UILibrary.GMJournal.JournalMetaData.ParagraphEntryMap) do
                    --     if chapID == pID then
                    --         if saveTable[i]["Chapters"][j] ~= nil and saveTable[i]["Chapters"][j]["Paragraphs"] == nil then
                    --             saveTable[i]["Chapters"][j]["Paragraphs"] = {}
                    --         end
                    --         for k, paraID in pairs(paraGroup) do
                    --             if saveTable[i]["Chapters"] ~= nil and saveTable[i]["Chapters"][j]["Paragraphs"] ~= nil then
                    --                 saveTable[i]["Chapters"][j]["Paragraphs"][k] = {
                    --                     ["JournalNodeType"] = 3,
                    --                     ["entriesMapId"] = paraID,
                    --                     ["parentMapId"] = chapID,
                    --                     ["StringContent"] = object.editableElement_mc._text.htmlText,
                    --                     -- ["isShared"] = object.editableElement_mc._shared or false
                    --                 }
                    --                 if S7Journal["JournalMetaData"]["ParagraphEntryMap"][catID] ~= nil and S7Journal["JournalMetaData"]["ParagraphEntryMap"][catID][chapID] ~= nil then
                    --                 S7Journal["JournalMetaData"]["ParagraphEntryMap"][catID][chapID][k] = paraID
                    --                 end
                    --             end
                    --         end
                    --     end
                    -- end
                end
            end
        end
    end
    S7Journal["JournalData"] = UCL.Rematerialize(saveTable)
    Ext.SaveFile("S7Journal.json", Ext.JsonStringify(S7Journal))
    Ext.Print(Ext.JsonStringify(S7Journal))
end