local aniadido = false
local servicios = config.servicios

RegisterNUICallback('assistAlerts', function(data, cb)
    if not aniadido then
        aniadido = true
        for c,v in pairs(servicios) do
            SendNUIMessage({
                nuevoServicio = true,
                servicio = {
                  id = c,
                  nombre = v
                },
              })
        end
    end
    SendNUIMessage({openSection = "alerts"})
    cb('ok')
end)