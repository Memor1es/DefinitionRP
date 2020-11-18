function AddTextEntry(key, value)
    Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), key, value)
end

Citizen.CreateThread(function()
	Citizen.Wait(0)
	AddTextEntry('0x73920F8E', 'ALS5')
	AddTextEntry('vic', 'Crown Vic')
	AddTextEntry('tau', 'Taurus')
	AddTextEntry('charger18', 'Dodge Charger 18')
	AddTextEntry('charger14', 'Dodge Charger 14')
	AddTextEntry('explorer16', 'Ford Explorer 16')
	AddTextEntry('2015polstang', 'Ford Mustang GT500')
end)