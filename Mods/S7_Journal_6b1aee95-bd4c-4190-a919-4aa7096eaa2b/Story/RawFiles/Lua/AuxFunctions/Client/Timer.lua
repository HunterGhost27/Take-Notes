---@class Timer @Timer
Timer = {}

---Executes callback after a delay
---@param self Timer
---@param time number Time to delay
---@param callback function callback function to delay
function Timer:Delay(time, callback, ...)
    if type(callback) ~= 'function' then return end

    local functionID = tostring(callback)
    Timer[functionID] = {
        callback = callback,
        args = {...}
    }

    local payload = {
        CharacterGUID = UserInformation.CurrentCharacter,
        functionID = functionID,
        Time = time
    }

    Ext.PostMessageToServer('S7Aux::DelayedCallback', Ext.JsonStringify(payload))
end

Ext.RegisterNetListener('S7Aux::DelayedCallback', function(channel, payload)
    local payload = Ext.JsonParse(payload) or {}
    if not Timer[payload.functionID] then return end

    Timer[payload.functionID].callback(table.unpack(Timer[payload.functionID].args))
    Timer[payload.functionID] = nil
end)