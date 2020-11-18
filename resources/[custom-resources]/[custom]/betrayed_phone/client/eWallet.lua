ESX = nil
local PlayerData = {}
local licencias = ""

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	
	while ESX.GetPlayerData().accounts == nil or ESX.GetPlayerData().job == nil or ESX.GetPlayerData().money == nil do
        Citizen.Wait(10)
    end
	
    PlayerData = ESX.GetPlayerData()
    ESX.TriggerServerCallback('esx_license:getLicenses', function(lic)
        for c,v in pairs(lic) do
            licencias = licencias.."<b>"..v.label.."</b><br>"
        end
    end,GetPlayerServerId(PlayerId()))
end)

RegisterNUICallback('btnAccount', function()
        local datos = ESX.GetPlayerData()
        local accounts = datos.accounts
        local job = datos.job
        local banco = accounts[tablefindKeyVal(accounts,"name","bank")].money
        local sucio = accounts[tablefindKeyVal(accounts,"name","black_money")].money
        --local ecoin = accounts[tablefindKeyVal(accounts,"name","Ecoin")].money
        local myjob = job.label.." - "..job.grade_label
        local licensestring = licencias
        local infoStats = "<div class='accountbubble'>  <div class='h6'>Accounts</div> <b>Bank</b>: $" .. banco .. " <br><br> <b>Dirty</b>: $" .. sucio .. " </div> <div class='accountbubble'>  <div class='h6'>Work related</div> <b> Job</b>: " .. myjob .. "<br></div> <div class='accountbubble'><div class='h6'>Licenses</div>" .. licensestring .. " </div>"
        SendNUIMessage({openSection = "account", InfoString = infoStats})
  end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

function miTrabajo()
    return ESX.GetPlayerData().job.name
end