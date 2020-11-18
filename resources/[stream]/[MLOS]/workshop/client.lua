Citizen.CreateThread(function()

RequestIpl("imp_impexp_interior_placement_interior_1_impexp")
interiorID = GetInteriorAtCoords(941.10520000,-971.67590000,39.39997000)
	if IsValidInterior(interiorID) then
	
		--EnableInteriorProp(interiorID, "Basic_style_set")
		EnableInteriorProp(interiorID, "Branded_style_set")
		--EnableInteriorProp(interiorID, "car_floor_hatch")
		EnableInteriorProp(interiorID, "door_blocker")
		
		--EnableInteriorProp(interiorID, "pump_01")
		--EnableInteriorProp(interiorID, "pump_06")
		--EnableInteriorProp(interiorID, "pump_07")
		--EnableInteriorProp(interiorID, "pump_08")
		--EnableInteriorProp(interiorID, "pump_02")
		--EnableInteriorProp(interiorID, "pump_03")
		--EnableInteriorProp(interiorID, "pump_04")
		--EnableInteriorProp(interiorID, "pump_05")
		
		--EnableInteriorProp(interiorID, "Garage_Decor_01")
		--EnableInteriorProp(interiorID, "Garage_Decor_02")
		--EnableInteriorProp(interiorID, "Garage_Decor_03")
		--EnableInteriorProp(interiorID, "Garage_Decor_04")
		
		
		RefreshInterior(interiorID)
	end
end)