Timer = {}

Ext.RegisterNetListener('S7Aux::DelayedCallback', function(channel, payload)
    local payload = Ext.JsonParse(payload) or {}
    Timer[payload.functionID] = payload.CharacterGUID
    Osi.TimerLaunch(payload.functionID, tonumber(payload.Time))
end)

Ext.RegisterOsirisListener('TimerFinished', 1, 'after', function(timerName)
    if not Timer[timerName] then return end
    local payload = {
        functionID = timerName
    }
    Ext.PostMessageToClient(Timer[timerName], 'S7Aux::DelayedCallback', Ext.JsonStringify(payload))
end)