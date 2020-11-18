ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Citizen.CreateThread(function()
	while ESX == nil do
		Wait(1)
	end
end)

RegisterServerEvent("drp-washm:washMoney")
AddEventHandler("drp-washm:washMoney", function(amount)
	local tax = (--[[ (math.random(6, 8) ]]8/10) -- 0.80 : 100000$ dirty = 80000$  // 0.80 : 100 000
	local _source = source
	local washamount = amount
	local xPlayer = ESX.GetPlayerFromId(source)
	local money = xPlayer.getMoney() -- gets normal money
    local black_money_amount = xPlayer.getAccount('black_money').money
    
    local taxamount = math.floor(((tax * washamount) - washamount))


	if (black_money_amount <= 0) then
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = 'You have no dirty money to wash!', length = 7500, style = { ['background-color'] = '#e43838', ['color'] = '#ffffff' } })
	else
		if black_money_amount < washamount then
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = "You don't have enough dirty money!", length = 7500, style = { ['background-color'] = '#e43838', ['color'] = '#ffffff' } })
		else
			local finalamount = washamount * tax
			xPlayer.removeAccountMoney('black_money', washamount)
			Wait(500)
			xPlayer.addMoney(finalamount)
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'success', text = "You washed $"..washamount..", Harry took $"..-taxamount.." for his troubles.", length = 7500, style = { ['background-color'] = '#74ca74', ['color'] = '#ffffff' } })
		end
	end
end)