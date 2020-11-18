local YellowPageArray = {}
local lstnotificationsyp = {}

RegisterNetEvent('betrayed_phone:listaAmarillas')
AddEventHandler('betrayed_phone:listaAmarillas', function(pass)
    YellowPageArray = pass
end)

local jobnames = {
    ["taxi"] = "taxi",
    ["mechanic"] = "mechanic",
    ["police"] = "police",
    ["ambulance"] = "ambulance",
}
  
RegisterNUICallback('newPostSubmit', function(data, cb)
    local myjob = miTrabajo()
    print(myjob)
    if jobnames[myjob] == nil then
        TriggerServerEvent('betrayed_phone:paginasAmarillas', data.advert)
    else
        TriggerServerEvent('betrayed_phone:paginasAmarillas', jobnames[myjob] .. " | " .. data.advert)
    end

end)

RegisterNUICallback('deleteYP', function()
    TriggerServerEvent('betrayed_phone:borrarAmarilla')
end)

RegisterNetEvent('betrayed_phone:actAmarillas')
AddEventHandler('betrayed_phone:actAmarillas', function()

    lstnotificationsyp = {}

    for i = 1, #YellowPageArray do
        local messageConverted = "<b>" .. YellowPageArray[tonumber(i)].job .. "</b> <br> Telephone " .. YellowPageArray[tonumber(i)].phonenumber
        local message2 = {
            id = tonumber(i),
            name = YellowPageArray[tonumber(i)].name,
            message = messageConverted
        }
        table.insert(lstnotificationsyp, message2)
    end

        
    SendNUIMessage({openSection = "notificationsYP", list = lstnotificationsyp})
end)

RegisterNUICallback('assistance', function(data, cb)
    SendNUIMessage({openSection = "assistance"})
    cb('ok')
end)

RegisterNUICallback('notificationsYP', function()

    lstnotificationsyp = {}

    for i = 1, #YellowPageArray do
        local messageConverted = "<b>" .. YellowPageArray[tonumber(i)].job .. "</b> <br> Telephone " .. YellowPageArray[tonumber(i)].phonenumber
        local message2 = {
          id = tonumber(i),
          name = YellowPageArray[tonumber(i)].name,
          message = messageConverted
        }

        table.insert(lstnotificationsyp, message2)
    end

    
  SendNUIMessage({openSection = "notificationsYP", list = lstnotificationsyp})

end)