--[[ Drugs = {

{x =-1938.9282226563, y =2630.3798828125, z =2.9226372241974},
{x =-1756.5212402344, y =2574.2727050781, z =3.3475306034088},
{x =-1991.8244628906, y =2516.056640625, z =3.0529675483704},
{x =-2137.6945800781, y =2653.6770019531, z =3.7418472766876},
{x =-2239.4614257813, y =2693.3366699219, z =3.0875754356384},
{x =-2340.9274902344, y =2724.2346191406, z =3.0770964622498},
{x =-2378.9982910156, y =2673.029296875, z =3.2516634464264},
{x =-2379.7053222656, y =2673.8569335938, z =3.182966709137},
{x =-2425.3234863281, y =2662.6179199219, z =2.8686444759369},
-- {x =-2007.0396728516, y =2585.7180175781, z =2.8033239841461}
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k,v in pairs(Drugs) do
            DrawMarker(1, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 200.0, 255, 10, 10, 255, false, false, 2, false, null, null, false)
        end
    end
end) ]]


function PedCoords()
    local ply = PlayerPedId()
    return Citizen.InvokeNative(0xA86D5F069399F44D, ply, Citizen.ResultAsVector())
end

function drawTxt(text)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(0.32, 0.32)
    SetTextColour(180, 180, 180, 255)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(1)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(0.5, 0.97)
  end

Citizen.CreateThread(function()
    Wait(100)
    local ply = PlayerPedId()
    local coords = PedCoords()
    local heading = GetEntityHeading(PlayerPedId())
  
    -- Reveal all map
    
    while true do
        Wait(1)
        local coords = PedCoords()
        local ply = PlayerPedId()
        heading = GetEntityHeading(PlayerPedId())
        drawTxt("X: "..math.ceil(coords.x*10) / 10 .. " Y: " .. math.ceil(coords.y*10) / 10 .. " Z: " .. math.ceil(coords.z*10) / 10 .. " H: " .. math.ceil(heading*10) / 10 --[[ 0.0,0.0,0.3 ]])
    end
end)