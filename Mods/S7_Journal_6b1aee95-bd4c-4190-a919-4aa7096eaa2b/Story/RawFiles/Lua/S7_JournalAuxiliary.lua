--  =================
--  IMPORT DEPENDENCY
--  =================

UCL = Mods["S7_UI_Components_Library"]

--  =============
--  REMATERIALIZE
--  =============

function Rematerialize(element)
    return Ext.JsonParse(Ext.JsonStringify(element))
end

--  =================================
--      VALIDATE NON-EMPTY STRING
--  =================================

function ValidString(str) --  Checks if a string is not nil and is not empty.
    if type(str) == "string" and str ~= nil and str ~= "" and str ~= "{}" and str ~= "[]" then
        return true
    else
        return false
    end
end