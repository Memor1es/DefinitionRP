ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


AddEventHandler("playerDropped", function()
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer then
        local job = xPlayer.job.name
        local grade = xPlayer.job.grade

        if job == 'police' or job == 'ambulance' or job == 'mechanic' or job == 'flywheels' or job == 'racersedge' or job == 'merryweather' or job == 'vanillaunicorn' or job == 'reporter' or job == 'hellscustoms' or job == 'vagos' or job == 'lswc' or job == 'lawyer' or job == 'secondchance' then
            if job == 'police' or job == 'ambulance' or job == 'mechanic' or job == 'flywheels' or job == 'racersedge' or job == 'lawyer' then 
                TriggerEvent("TokoVoip:removePlayerFromAllRadio", _source)
                TriggerEvent("eblips:remove", _source)
            end
            xPlayer.setJob('off' ..job, grade)
            TriggerEvent('clockingstatus:drop', _source, xPlayer, job)
        end
    end
end)

RegisterServerEvent('duty:onoff')
AddEventHandler('duty:onoff', function(job)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local job = xPlayer.job.name
    local grade = xPlayer.job.grade
    local gradel = xPlayer.job.grade_name
    local radioCount = xPlayer.getInventoryItem('radio').count

    if job == 'police' or job == 'ambulance' or job == 'racersedge' or job == 'flywheels' or job == 'hellscustoms' then
        xPlayer.setJob('off' ..job, grade)
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You are now off-duty', length = 9000})
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Tracker status = off', length = 9000})
        TriggerEvent("TokoVoip:removePlayerFromAllRadio", _source)
        TriggerEvent("eblips:remove", _source)
    elseif job == 'offpolice' or job == 'offambulance' then
        if job == 'offpolice' then
            xPlayer.setJob('police', grade)
            if radioCount >= 1 then
                TriggerEvent("TokoVoip:addPlayerToRadio", 1, _source)
            end
            
            if gradel == "commissioner" then
                TriggerEvent("eblips:add", {name = "BoC Member", src = _source, color = 58})
            else
                TriggerEvent("eblips:add", {name = "Police", src = _source, color = 42})
            end
        elseif job == 'offambulance' then
            xPlayer.setJob('ambulance', grade)
            if radioCount >= 1 then
                TriggerEvent("TokoVoip:addPlayerToRadio", 2, _source)
            end
            TriggerEvent("eblips:add", {name = "EMS", src = _source, color = 1})
        end
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You are now on-duty', length = 9000})
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'Tracker status = on', length = 9000})
    elseif job == 'offracersedge' or job == 'offflywheels' or job == 'offhellscustoms' then
        if job == 'offracersedge' then
            xPlayer.setJob('racersedge', grade) 
            if radioCount >= 1 then
                TriggerEvent("TokoVoip:addPlayerToRadio", 11, _source)
            end
        elseif job == 'offflywheels' then
            xPlayer.setJob('flywheels', grade) 
            if radioCount >= 1 then
                TriggerEvent("TokoVoip:addPlayerToRadio", 12, _source)
            end
        elseif job == 'offhellscustoms' then
            xPlayer.setJob('hellscustoms', grade) 
            if radioCount >= 1 then
                TriggerEvent("TokoVoip:addPlayerToRadio", 13, _source)
            end
        end
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You are now on-duty', length = 9000})
    elseif job == 'vagos' or job == 'lswc' or job == 'merryweather' or job == 'vanillaunicorn' or job == 'reporter' or job == 'lawyer' then
        xPlayer.setJob('off'..job, grade) 
    elseif job == 'offreporter' then
        xPlayer.setJob('reporter', grade) 
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You are now on-duty', length = 9000})
    elseif job == 'offvagos' then
        xPlayer.setJob('vagos', grade) 
    elseif job == 'offdiamondcasino' then
        xPlayer.setJob('diamondcasino', grade) 
    elseif job == 'offlswc' then
        xPlayer.setJob('lswc', grade) 
    elseif job == 'offvanillaunicorn' then
        xPlayer.setJob('vanillaunicorn', grade) 
    elseif job == 'offmerryweather' then
        xPlayer.setJob('merryweather', grade)
    elseif job == 'offlawyer' then
        xPlayer.setJob('lawyer', grade)
    end
    Wait(500)
    TriggerEvent('clockingstatus:switchJobs', _source)
end)