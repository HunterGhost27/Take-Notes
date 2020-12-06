--  =================
--  IMPORT DEPENDENCY
--  =================

UCL = Mods["S7_UI_Components_Library"]  --  Import UI Components Library

--  ======
--  VARDEC
--  ======

JournalTemplate = "BOOK_S7_Journal_df7a8779-f908-43ac-b0ba-cb49d16308a9"

--  =============
--  REMATERIALIZE
--  =============

function Rematerialize(element) -- For immediate translation of nested tables
    return Ext.JsonParse(Ext.JsonStringify(element))
end

--  =================================
--      VALIDATE NON-EMPTY STRING
--  =================================

function ValidString(str) --  Checks if a string is not nil and is not empty.
    if type(str) == "string" and str ~= nil and str ~= "" and str ~= "{}" and str ~= "[]" then return true
    else return false end
end