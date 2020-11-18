ESX = nil
local shopItems = {}
local stockCheck = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

MySQL.ready(function()
	Citizen.CreateThread(function()
		if Config.Refill_stock then
			Citizen.Wait(2000)
			if Config.Restart_refill then
				weaponRestock()
			else
				weaponRandomizer()
			end
		else
			return
		end
	end)
end)

ESX.RegisterServerCallback('rid_blackmarket:getShop', function(source, cb)
	cb(shopItems)
end)

ESX.RegisterServerCallback('rid_blackmarket:buyWeapon', function(source, cb, weaponName, zone)
	print("buying", weaponName)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = GetPrice(weaponName, zone) -- Pull current price from DB
	local stock = GetStock(weaponName, zone) -- Pull current stock level from DB

	if price == 0 then
		print(('rid_blackmarket: %s attempted to buy a unknown weapon!'):format(xPlayer.identifier))
		cb(false)
	else
		if xPlayer.hasWeapon(weaponName) then
			TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You already have one!!', length = 12000})
			cb(false)
		else
			
			-- check stock logic
			if stock == 0 or stock < 0 then
				print(('rid_blackmarket: %s attempted to buy 0 stock weapon!'):format(xPlayer.identifier))
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Sorry, I\'ve ran out of those!', length = 12000})
				cb(false)
			else
				print("buying 3")
				if zone == 'BlackMarket' then
					local money_type = ''

					if Config.Use_black_money then
						money_type = 'black_money'
					else
						money_type = 'money'
					end

					if xPlayer.getAccount(money_type).money >= price then
						xPlayer.removeAccountMoney(money_type, price)
						Wait(100)
						xPlayer.addInventoryItem(weaponName, 1)

						-- Take stock logic
						MySQL.Async.execute('UPDATE black_market SET stock = stock - 1 WHERE item = @item', {
							['@item'] = weaponName
						}, nil)

						cb(true)
					else
						TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'I only accept the dirty cash, and you\'re short!', length = 12000})
						cb(false)
					end
				end
			end
		end
	end
end)

function GetPrice(weaponName, zone)
	local price = MySQL.Sync.fetchScalar('SELECT price FROM black_market WHERE zone = @zone AND item = @item', {
		['@zone'] = zone,
		['@item'] = weaponName
	})

	if price then
		return price
	else
		return 0
	end
end

function GetStock(weaponName, zone)
	local stock = MySQL.Sync.fetchScalar('SELECT stock FROM black_market WHERE zone = @zone AND item = @item', {
		['@zone'] = zone,
		['@item'] = weaponName
	})

	if stock then
		return stock
	else
		return 0
	end
end

RegisterServerEvent('rid_blackmarket:stockUpdate')
AddEventHandler('rid_blackmarket:stockUpdate', function()

	-- Clear Current Table Inserts To prevent table stacking
	shopItems["BlackMarket"] = {}

	MySQL.Async.fetchAll('SELECT * FROM black_market', {}, function(result)
		for i=1, #result, 1 do
			if shopItems[result[i].zone] == nil then
				shopItems[result[i].zone] = {}
			end

			table.insert(shopItems[result[i].zone], {
				item  = result[i].item,
				price = result[i].price,
                label = ESX.GetWeaponLabel(result[i].item),
                stock = result[i].stock
			})
		end

		TriggerClientEvent('rid_blackmarket:sendShop', -1, shopItems)
	end)
end)

Citizen.CreateThread(function()
    print("rid_blackmarket: Started!")

	if Config.Timed_restock then
		if Config.Restart_restock then
			TriggerEvent("cron:runAt",Config.Hour,Config.Minute,weaponRandomizer)
		else
			TriggerEvent("cron:runAt",Config.Hour,Config.Minute,Weapon_restock)
		end
	end
end)

function weaponRandomizer(d,h,m)
	-- CRON Function at specified time
	print("rid_blackmarket: New Weapons in Black Market")

	MySQL.Async.fetchAll('SELECT * FROM black_market', {}, function(result)
        for i=1, #result, 1 do

            if stockCheck[result[i].zone] == nil then
                stockCheck[result[i].zone] = {}
            end

			stockCheck[result[i].zone].id = result[i].id
			stockCheck[result[i].zone].item = result[i].item
			stockCheck[result[i].zone].price = result[i].price
			stockCheck[result[i].zone].label = ESX.GetWeaponLabel(result[i].item)
			stockCheck[result[i].zone].stock = result[i].stock
			stockCheck[result[i].zone].category = result[i].category

			local current_id = stockCheck[result[i].zone].id
			local current_stock = stockCheck[result[i].zone].stock
			local current_weapon = stockCheck[result[i].zone].item
			local target_category = stockCheck[result[i].zone].category
			local new_stock = 0
			local new_weapon = ""
			local new_price = 0

			if target_category == "pistol" then

				-- Choose Random from config set
				new_set = Config.Weapon_restock["pistol"][math.random(Config.Cat_pistols)]

				new_weapon = new_set.name
				new_price = new_set.price
				new_stock = new_set.starting_stock

			elseif target_category == "shotgun" then

				-- Choose Random from config set
				new_set = Config.Weapon_restock["shotgun"][math.random(Config.Cat_shotgun)]

				new_weapon = new_set.name
				new_price = new_set.price
				new_stock = new_set.starting_stock

			elseif target_category == "smg" then

				-- Choose Random from config set
				new_set = Config.Weapon_restock["smg"][math.random(Config.Cat_smg)]

				new_weapon = new_set.name
				new_price = new_set.price
				new_stock = new_set.starting_stock

			elseif target_category == "rifle" then

				-- Choose Random from config set
				new_set = Config.Weapon_restock["rifle"][math.random(Config.Cat_rifles)]

				new_weapon = new_set.name
				new_price = new_set.price
				new_stock = new_set.starting_stock

			elseif target_category == "sniper" then

				-- Choose Random from config set
				new_set = Config.Weapon_restock["sniper"][math.random(Config.Cat_snipers)]

				new_weapon = new_set.name
				new_price = new_set.price
				new_stock = new_set.starting_stock

			end

			if current_stock == 0 then

				-- Re-Stock Logic On Script Restart / Server Restart
				MySQL.Async.execute('UPDATE black_market SET item = @item, stock = @stock, price = @price WHERE id = @id', {
					['@id'] = current_id,
					['@item'] = new_weapon,
					['@stock'] = new_stock,
					['@price'] = new_price
				}, nil)

            end

        end
    end)

end

function weaponRestock()
	-- On Resource Restart
	print("rid_blackmarket: Refilling all weapon stock")

    MySQL.Async.fetchAll('SELECT * FROM black_market', {}, function(result)
        for i=1, #result, 1 do

            if stockCheck[result[i].zone] == nil then
                stockCheck[result[i].zone] = {}
            end

			stockCheck[result[i].zone].item = result[i].item
			stockCheck[result[i].zone].price = result[i].price
			stockCheck[result[i].zone].label = ESX.GetWeaponLabel(result[i].item)
			stockCheck[result[i].zone].stock = result[i].stock
			stockCheck[result[i].zone].category = result[i].category

			local current_stock = stockCheck[result[i].zone].stock
			local current_weapon = stockCheck[result[i].zone].item
			local target_category = stockCheck[result[i].zone].category
			local new_stock = 0

			if target_category == "pistol" then
				new_stock = Config.Pistol_stock
			elseif target_category == "shotgun" then
				new_stock = Config.Shotgun_stock
			elseif target_category == "smg" then
				new_stock = Config.Smg_stock
			elseif target_category == "rifle" then
				new_stock = Config.Rifle_stock
			elseif target_category == "sniper" then
				new_stock = Config.Sniper_stock
			else
				new_stock = -1
			end

			if current_stock == 0 then

				-- Re-Stock Logic On Script Restart / Server Restart
				MySQL.Async.execute('UPDATE black_market SET stock = @stock WHERE item = @item', {
					['@item'] = current_weapon,
					['@stock'] = new_stock
				}, nil)

            end

        end
    end)
end
