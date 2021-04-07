--  =========
--  NETWORKER
--  =========

Ext.RegisterNetListener('S7_AuxFunctions::UserInfoSync', function (channel, payload)
    local package = Ext.JsonParse(payload) or {}
    UserInformation = Integrate(UserInformation, package.UserInfo)
    UserInformation = Integrate(UserInformation, package.UserSpec)
end)

Ext.RegisterListener('AfterUIInvoke', function(ui, call, handle)
    if call ~= 'setPlayerHandle' or call ~= 'selectPlayer' then return end
    local character = Ext.GetCharacter(handle)
    if not character then return end
    UserInformation.CurrentCharacter = character.MyGuid
end)