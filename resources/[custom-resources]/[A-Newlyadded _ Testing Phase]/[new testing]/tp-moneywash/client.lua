ESX = nil
local openKey = 51 -- PRESS E TO OPEN MENU


Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    while ESX.GetPlayerData().job == nil do Citizen.Wait(10) end
    PlayerData = ESX.GetPlayerData()
end)


--- Location
Citizen.CreateThread(function()
	--X, Y, Z coords 
		local x = 1129.3 
		local y = -3194.22
		local z = -40.39
		while true do
			Citizen.Wait(0)
			local playerPos = GetEntityCoords(GetPlayerPed(-1), true)
			if (Vdist(playerPos.x, playerPos.y, playerPos.z, x, y, z) < 2.0) then
				DrawMarker(27, x, y, z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.0001, 255, 10, 10,165, 0, 0, 0,0)
				Draw3DText(x,y,z,"Press ~r~[E]~w~ to open menu")
				if (Vdist(playerPos.x, playerPos.y, playerPos.z, x, y, z) < 2.0) then						
					if (IsControlJustReleased(1, openKey)) then 
						WashCashMenu()
					end 
				end

			end
		end
end)

--3dtext
function Draw3DText(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

function WashCashMenu()
	ESX.UI.Menu.CloseAll() -- Close all current menus

	local player = PlayerPedId()
	FreezeEntityPosition(player,true)
	local elements = {}
			

	table.insert(elements,{itemName = 'wash', label = ('Wash Dirty Money')})
	table.insert(elements,{itemName = 'exit', label = ('Exit')})

		
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "drp-washmoney",
		{
			title    = "Harry's Dirty Laundry",
			align    = "bottom-right",
			elements = elements
		},
	function(data, menu)
			if data.current.itemName ~= 'exit' then
				OpenWashDialogMenu()
			else
				menu.close()
				FreezeEntityPosition(player,false)
			end
	end, function(data, menu)
		menu.close()
		FreezeEntityPosition(player,false)
	end, function(data, menu)
	end)
end

-- Function for Money Wash Dialog
function OpenWashDialogMenu()
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'drp-washmoney-wash-dialog', {
		title = "Amount to Wash?"
	}, function(data, menu)
		menu.close()
		amountToWash = tonumber(data.value)
		TriggerServerEvent("drp-washm:washMoney",amountToWash)
	end,
	function(data, menu)
		menu.close()
		FreezeEntityPosition(player,false)
	end)
end