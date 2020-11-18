ESX = nil
local Jobs = {}
local RegisteredSocieties = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function GetSociety(name)
	for i=1, #RegisteredSocieties, 1 do
		if RegisteredSocieties[i].name == name then
			return RegisteredSocieties[i]
		end
	end
end

MySQL.ready(function()
	local result = MySQL.Sync.fetchAll('SELECT * FROM jobs', {})

	for i=1, #result, 1 do
		Jobs[result[i].name]        = result[i]
		Jobs[result[i].name].grades = {}
	end

	local result2 = MySQL.Sync.fetchAll('SELECT * FROM job_grades', {})

	for i=1, #result2, 1 do
		Jobs[result2[i].job_name].grades[tostring(result2[i].grade)] = result2[i]
	end
end)

AddEventHandler('esx_society:registerSociety', function(name, label, account, datastore, inventory, data)
	local found = false

	local society = {
		name      = name,
		label     = label,
		account   = account,
		datastore = datastore,
		inventory = inventory,
		data      = data,
	}

	for i=1, #RegisteredSocieties, 1 do
		if RegisteredSocieties[i].name == name then
			found = true
			RegisteredSocieties[i] = society
			break
		end
	end

	if not found then
		table.insert(RegisteredSocieties, society)
	end
end)

AddEventHandler('esx_society:getSocieties', function(cb)
	cb(RegisteredSocieties)
end)

AddEventHandler('esx_society:getSociety', function(name, cb)
	cb(GetSociety(name))
end)

RegisterServerEvent('esx_society:withdrawMoney')
AddEventHandler('esx_society:withdrawMoney', function(society, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local society = GetSociety(society)
	amount = ESX.Math.Round(tonumber(amount))

	if xPlayer.job.name ~= society.name then
		print(('esx_society: %s attempted to call withdrawMoney!'):format(xPlayer.identifier))
		return
	end

	TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
		if amount > 0 and account.money >= amount then
			account.removeMoney(amount)
			xPlayer.addMoney(amount)
			TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, {type = "success", text = "You have withdrawn "..ESX.Math.GroupDigits(amount), length = 5000})
			TriggerEvent('discordbot:societyLog', "```["..string.upper(society.name).." ".."WITHDRAW] "..GetPlayerName(source).." has withdrawn $"..amount.." remaining balance $"..account.money-amount.."```")
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, {type = "error", text = "Invalid Amount", length = 5000})
		end
	end)
end)

RegisterServerEvent('esx_society:depositMoney')
AddEventHandler('esx_society:depositMoney', function(society, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local society = GetSociety(society)
	amount = ESX.Math.Round(tonumber(amount))

	if xPlayer.job.name ~= society.name then
		print(('esx_society: %s attempted to call depositMoney!'):format(xPlayer.identifier))
		return
	end

	if amount > 0 and xPlayer.getMoney() >= amount then
		TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
			xPlayer.removeMoney(amount)
			account.addMoney(amount)
			TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, {type = "success", text = "You have deposited "..ESX.Math.GroupDigits(amount), length = 5000})
			TriggerEvent('discordbot:societyLog', "```["..string.upper(society.name).." ".."DEPOSIT] "..GetPlayerName(source).." has desposited $"..amount.." remaining balance $"..account.money+amount.."```")
		end)	
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, {type = "error", text = "Invalid Amount", length = 5000})
	end
end)

function GetRPName1(playerId, cb)
	local Identifier = ESX.GetPlayerFromId(playerId).identifier
	MySQL.Async.fetchAll("SELECT firstname, lastname FROM users WHERE identifier = @identifier", { ["@identifier"] = Identifier }, function(result)
		cb(result[1].firstname.." "..result[1].lastname)
	end)
end

RegisterServerEvent('esx_society:washMoney')
AddEventHandler('esx_society:washMoney', function(society, amount)
	local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	local account = xPlayer.getAccount('black_money')
	amount = ESX.Math.Round(tonumber(amount))
	if xPlayer.job.name ~= society then
		print(('esx_society: %s attempted to call washMoney!'):format(xPlayer.identifier))
		return
	end

	if amount and amount > 0 and account.money >= amount then
		xPlayer.removeAccountMoney('black_money', amount)

		if xPlayer then
			TriggerEvent('discordbot:moneyWashUsr', "["..xPlayer.job.label.."] Has deposited $"..math.floor(amount).." black money to be washed", xPlayer.source)
		end

		MySQL.Async.execute('INSERT INTO society_moneywash (identifier, society, amount) VALUES (@identifier, @society, @amount)', {
			['@identifier'] = xPlayer.identifier,
			['@society']    = society,
			['@amount']     = amount,
		}, function(rowsChanged)
			TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, {type = "success", text = "You have "..ESX.Math.GroupDigits(amount).." waiting in your money wash. (24hr)", length = 5000})
		end)
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, {type = "error", text = "Invalid Amount", length = 5000})
	end
end)

RegisterServerEvent('esx_society:putVehicleInGarage')
AddEventHandler('esx_society:putVehicleInGarage', function(societyName, vehicle)
	local society = GetSociety(societyName)

	TriggerEvent('esx_datastore:getSharedDataStore', society.datastore, function(store)
		local garage = store.get('garage') or {}

		table.insert(garage, vehicle)
		store.set('garage', garage)
	end)
end)

RegisterServerEvent('esx_society:removeVehicleFromGarage')
AddEventHandler('esx_society:removeVehicleFromGarage', function(societyName, vehicle)
	local society = GetSociety(societyName)

	TriggerEvent('esx_datastore:getSharedDataStore', society.datastore, function(store)
		local garage = store.get('garage') or {}

		for i=1, #garage, 1 do
			if garage[i].plate == vehicle.plate then
				table.remove(garage, i)
				break
			end
		end

		store.set('garage', garage)
	end)
end)

ESX.RegisterServerCallback('esx_society:getSocietyMoney', function(source, cb, societyName)
	local society = GetSociety(societyName)

	if society then
		TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
			cb(account.money)
		end)
	else
		cb(0)
	end
end)

ESX.RegisterServerCallback('esx_society:getEmployees', function(source, cb, society)
	if Config.EnableESXIdentity then

		MySQL.Async.fetchAll('SELECT firstname, lastname, identifier, job, job_grade FROM users WHERE job LIKE @job ORDER BY job_grade DESC', {
			['@job'] = "%"..society
		}, function (results)
			local employees = {}

			for i=1, #results, 1 do
				table.insert(employees, {
					name       = results[i].firstname .. ' ' .. results[i].lastname,
					identifier = results[i].identifier,
					job = {
						name        = results[i].job,
						label       = Jobs[results[i].job].label,
						grade       = results[i].job_grade,
						grade_name  = Jobs[results[i].job].grades[tostring(results[i].job_grade)].name,
						grade_label = Jobs[results[i].job].grades[tostring(results[i].job_grade)].label
					}
				})
			end

			cb(employees)
		end)
	else
		MySQL.Async.fetchAll('SELECT name, identifier, job, job_grade FROM users WHERE job = @job ORDER BY job_grade DESC', {
			['@job'] = society
		}, function (result)
			local employees = {}

			for i=1, #result, 1 do
				table.insert(employees, {
					name       = result[i].name,
					identifier = result[i].identifier,
					job = {
						name        = result[i].job,
						label       = Jobs[result[i].job].label,
						grade       = result[i].job_grade,
						grade_name  = Jobs[result[i].job].grades[tostring(result[i].job_grade)].name,
						grade_label = Jobs[result[i].job].grades[tostring(result[i].job_grade)].label
					}
				})
			end

			cb(employees)
		end)
	end
end)

ESX.RegisterServerCallback('esx_society:getJob', function(source, cb, society)
	local job    = json.decode(json.encode(Jobs[society]))
	local grades = {}

	for k,v in pairs(job.grades) do
		table.insert(grades, v)
	end

	table.sort(grades, function(a, b)
		return a.grade < b.grade
	end)

	job.grades = grades

	cb(job)
end)


ESX.RegisterServerCallback('esx_society:setJob', function(source, cb, identifier, job, grade, type)
	local xPlayer = ESX.GetPlayerFromId(source)
	local isBoss = (xPlayer.job.grade_name == 'boss' or xPlayer.job.grade_name == 'asstchief' or xPlayer.job.grade_name == 'chief' or xPlayer.job.grade_name == 'commissioner')

	if isBoss then 
		local xTarget = ESX.GetPlayerFromIdentifier(identifier)

		if xTarget then
			xTarget.setJob(job, grade)
			local jobName = xTarget.getJob().label

			if type == 'hire' then
				TriggerClientEvent('mythic_notify:client:SendAlert', xTarget.source, {type = "success", text = "You have been hired by "..jobName, length = 5000})
			elseif type == 'promote' then
				TriggerClientEvent('mythic_notify:client:SendAlert', xTarget.source, {type = "inform", text = "You have been promoted at "..jobName, length = 5000})
			elseif type == 'fire' then
				TriggerClientEvent('mythic_notify:client:SendAlert', xTarget.source, {type = "error", text = "You have been fired from "..jobName, length = 5000})
			end
			cb()
		else
			MySQL.Async.execute('UPDATE users SET job = @job, job_grade = @job_grade WHERE identifier = @identifier', {
				['@job']        = job,
				['@job_grade']  = grade,
				['@identifier'] = identifier
			}, function(rowsChanged)
				cb()
			end)
		end
	else
		print(('esx_society: %s attempted to setJob'):format(xPlayer.identifier))
		cb()
	end
end)

ESX.RegisterServerCallback('tp-anti-society:setJobSalary', function(source, cb, job, grade, salary)
	local isBoss = isPlayerBoss(source, job)
	local identifier = GetPlayerIdentifier(source, 0)

	if isBoss then
		if salary <= Config.MaxSalary then
			MySQL.Async.execute('UPDATE job_grades SET salary = @salary WHERE job_name = @job_name AND grade = @grade', {
				['@salary']   = salary,
				['@job_name'] = job,
				['@grade']    = grade
			}, function(rowsChanged)
				Jobs[job].grades[tostring(grade)].salary = salary
				local xPlayers = ESX.GetPlayers()

				for i=1, #xPlayers, 1 do
					local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

					if xPlayer.job.name == job and xPlayer.job.grade == grade then
						xPlayer.setJob(job, grade)
					end
				end

				cb()
			end)
		else
			print(('esx_society: %s attempted to setJobSalary over config limit!'):format(identifier))
			cb()
		end
	else
		print(('esx_society: %s attempted to setJobSalary'):format(identifier))
		cb()
	end
end)

ESX.RegisterServerCallback('esx_society:getOnlinePlayers', function(source, cb)
	local xPlayers = ESX.GetPlayers()
	local players  = {}
	MySQL.Async.fetchAll("SELECT * FROM characters", {
	},function(result)
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			for ii=1, #result do
				if xPlayer.identifier == result[ii].identifier then
					table.insert(players, {
						source     = xPlayer.source,
						identifier = xPlayer.identifier,
						name       = xPlayer.name,
						job        = xPlayer.job,
						fullname = result[ii].firstname.." "..result[ii].lastname
					})
				end
			end
		end
		cb(players)
	end)
end)

ESX.RegisterServerCallback('esx_society:getVehiclesInGarage', function(source, cb, societyName)
	local society = GetSociety(societyName)

	TriggerEvent('esx_datastore:getSharedDataStore', society.datastore, function(store)
		local garage = store.get('garage') or {}
		cb(garage)
	end)
end)

ESX.RegisterServerCallback('esx_society:isBoss', function(source, cb, job)
	cb(isPlayerBoss(source, job))
end)

function isPlayerBoss(playerId, job)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer.job.name == job and (xPlayer.job.grade_name == 'boss' or xPlayer.job.grade_name == 'asstchief' or xPlayer.job.grade_name == 'chief' or xPlayer.job.grade_name == 'commissioner') then
		return true
	else
		print(('esx_society: %s attempted open a society boss menu!'):format(xPlayer.identifier))
		return false
	end
end

function WashMoneyCRON(d, h, m)
	MySQL.Async.fetchAll('SELECT * FROM society_moneywash', {}, function(result)
		for i=1, #result, 1 do
			local society = GetSociety(result[i].society)
			local xPlayer = ESX.GetPlayerFromIdentifier(result[i].identifier)

			-- add society money
			TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
				account.addMoney(result[i].amount)
				if xPlayer then
					TriggerEvent('discordbot:moneyWashUsr', "["..xPlayer.job.label.."] Wash Cycle Complete $"..math.floor(result[i].amount).." has been deposited into society account. New Balance: $"..account.money..".", xPlayer.source)
					TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, {type = "success", text = "You have washed your money "..ESX.Math.GroupDigits(result[i].amount), length = 5000})
				else
					TriggerEvent('discordbot:societyLog', "```["..society.label.."] Wash Cycle Complete $"..math.floor(result[i].amount).." has been deposited into society account. New Balance: $"..account.money..".```")
				end
			end)

			MySQL.Async.execute('DELETE FROM society_moneywash WHERE id = @id', {
				['@id'] = result[i].id
            })
            print("Washed $" .. result[i].amount .. " for ".. result[i].society)
		end
	end)
end



-- TriggerEvent('cron:runAt', 2, 25, WashMoneyCRON)

-- Debug function

--[[ function CronTask()
    print("Printing from Cron")
end

TriggerEvent('cron:runAt', 18, 24, CronTask)
TriggerEvent('cron:runAt', 18, 25, CronTask) ]]

Citizen.CreateThread(function()
    while true do
		Wait(60000)
		local date = os.date("*t", os.time())
		
		if date.hour == 3 and date.min == 30 then
            WashMoneyCRON()
		elseif date.hour == 22 and date.min == 0 then
			SocietyInvest()
		end
    end
end)

TriggerEvent('es:addGroupCommand', 'forcewash', 'admin', function(source, args, user)
	WashMoneyCRON()
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Forces money wash cycle. Do not use without Developer permissions.", })



function SocietyInvest()
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_police', function(account)
        local amount = 50000
		account.addMoney(amount)
		TriggerEvent('discordbot:societyLog', "```[POLICE INVESTMENT] Government has invested $"..amount.." remaining balance $"..account.money+amount.."```")
	end)
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_ambulance', function(account)
		local amount = 20000
		account.addMoney(amount)
		TriggerEvent('discordbot:societyLog', "```[AMBULANCE INVESTMENT] Government has invested $"..amount.." remaining balance $"..account.money+amount.."```")
	end)
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_lawyer', function(account)
		local amount = 60000
		account.addMoney(amount)
		TriggerEvent('discordbot:societyLog', "```[DOJ INVESTMENT] Government has invested $"..amount.." remaining balance $"..account.money+amount.."```")
	end)
end