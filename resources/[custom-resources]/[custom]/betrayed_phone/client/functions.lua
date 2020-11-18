function hasPhone()
	return true
    -- check if have phone
end

function loading()
    SendNUIMessage({
        openSection = "error",
        textmessage = "Loading please wait.",
    })  
end

function doTimeUpdate()
  local hour, minute = GetClockHours(), GetClockMinutes()
  local timestamp = ("%.2d"):format((hour == 0) and 12 or hour) .. ":" .. ("%.2d"):format( minute)
    SendNUIMessage({
      openSection = "timeheader",
      timestamp = timestamp,
    })   
end

function tablefind(tab,el)
  for index, value in pairs(tab) do
    if value == el then
      return index
    end
  end
end

function tablefindKeyVal(tab,key,val)
  for index, value in pairs(tab) do
    if value ~= nil  and value[key] ~= nil and value[key] == val then
      return index
    end
  end
end

function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
  SetTextFont(4)
  SetTextProportional(0)
  SetTextScale(scale, scale)
  SetTextColour(r, g, b, a)
  SetTextDropShadow(0, 0, 0, 0,255)
  SetTextEdge(2, 0, 0, 0, 255)
  SetTextDropShadow()
  SetTextOutline()
  SetTextEntry("STRING")
  AddTextComponentString(text)
  DrawText(x - width/2, y - height/2 + 0.005)
end
