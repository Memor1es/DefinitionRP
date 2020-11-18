local TweetsActuales = {}
local userTwitter = nil
local allowpopups = true

RegisterNUICallback('btnNotifyToggle', function(data, cb)
    allowpopups = not allowpopups
    if allowpopups then
      TriggerEvent("DoLongHudText","Activated Popups")
    else
      TriggerEvent("DoLongHudText","Popups Off")
    end
end)

RegisterNetEvent("betrayed_phone:userTwitter")
AddEventHandler("betrayed_phone:userTwitter", function(user)
 userTwitter = user
end)

RegisterNetEvent("tryTweet")
AddEventHandler("tryTweet", function(tweetinfo,message,user)
  if hasPhone() then
    TriggerServerEvent("AllowTweet",tweetinfo,message)
  end
end)

RegisterNetEvent('betrayed_phone:actualizaTweets')
AddEventHandler('betrayed_phone:actualizaTweets', function(tweets,primero)
    local handle = userTwitter
    TweetsActuales = tweets 
    if #TweetsActuales == 0 or primero then return; end
    if TweetsActuales[#TweetsActuales]["handle"] == handle then
      SendNUIMessage({openSection = "twatter", twats = TweetsActuales, myhandle = handle})
    end

    if appInstalada("twatter") then
      if string.find(TweetsActuales[#TweetsActuales]["message"],handle) then
        --
        if TweetsActuales[#TweetsActuales]["handle"] ~= handle then
          SendNUIMessage({openSection = "newtweet"})
        end


        if phoneNotifications then
          PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1)
          TriggerEvent("DoLongHudText","You were just mentioned in a tweet on your phone.",15)
        end
      end

      if allowpopups and not GuiEnabled() then
        SendNUIMessage({openSection = "notify", handle = TweetsActuales[#TweetsActuales]["handle"], message =TweetsActuales[#TweetsActuales]["message"]})
      end
    end
end)

function AbrirTwitter()
  local handle = userTwitter
  SendNUIMessage({openSection = "twatter", twats = TweetsActuales, myhandle = handle})
end

RegisterNUICallback('btnTwatter', function()
    local handle = userTwitter
    if handle == nil then
      TriggerServerEvent('betrayed_phone:getUser')
      print("no tiene user")
    else
      SendNUIMessage({openSection = "twatter", twats = TweetsActuales, myhandle = handle})
    end
end)
  
RegisterNUICallback('newTwatSubmit', function(data, cb)
    local handle = userTwitter
    TriggerServerEvent('betrayed_phone:twittear', handle, data.twat)
end)