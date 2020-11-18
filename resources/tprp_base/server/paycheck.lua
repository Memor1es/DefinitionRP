ESX.StartPayCheck = function()

	function payCheck()
		local xPlayers = ESX.GetPlayers()

		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			local job     = xPlayer.job.grade_name
			local salary  = xPlayer.job.grade_salary

			if salary > 0 then
				if job == 'unemployed' then -- unemployed
					xPlayer.addAccountMoney('bank', salary)
					TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, {type = "success", text = "You have received your welfare benefit of $"..ESX.Math.GroupDigits(salary), length = 5000})
				elseif Config.EnableSocietyPayouts then -- possibly a society
					TriggerEvent('esx_society:getSociety', xPlayer.job.name, function (society)
						if society ~= nil then -- verified society
							TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function (account)
								if account.money >= salary then -- does the society money to pay its employees?
									xPlayer.addAccountMoney('bank', salary)
									account.removeMoney(salary)
									TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, {type = "success", text = "You have received your paycheck $"..ESX.Math.GroupDigits(salary), length = 5000})
								else
									TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, {type = "error", text = "The company that you currently work for is unable to pay your paycheck due to insufficent funds", length = 5000})
								end
							end)
						else -- not a society
							xPlayer.addAccountMoney('bank', salary)
							TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, {type = "success", text = "You have received your paycheck $"..ESX.Math.GroupDigits(salary), length = 5000})
						end
					end)
				else -- generic job
					xPlayer.addAccountMoney('bank', salary)
					TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, {type = "success", text = "You have received your paycheck $"..ESX.Math.GroupDigits(salary), length = 5000})
				end
			end

		end

		SetTimeout(Config.PaycheckInterval, payCheck)

	end

	SetTimeout(Config.PaycheckInterval, payCheck)

end
