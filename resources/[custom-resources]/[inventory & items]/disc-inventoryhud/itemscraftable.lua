CraftList = {}
CraftList["WEAPON_PISTOL"] = {
    id = "WEAPON_PISTOL",
    description = "9mm Pistol",
    count = 1,
    recipe = {
        {item = "Pistol Jacket", label = "Pistol Jacket", qty = 1},
        {item = "Rubber Grip", label = "Rubber Grip",  qty = 1},
        {item = "9mm Barrel", "9mm Barrel", qty = 1}
    },
    time = 30,
}
CraftList["bread"] = {
    id = "bread",
    description = "Bread...",
    count = 1,
    recipe = {
        {item = "milk", qty = 1},
    },
    time = 5,
}
CraftList["thermite"] = {
    id = "thermite",
    description = "Highly Explosive",
    count = 1,
    
    recipe = {
        {item = "aluminum", label = "Aluminum", qty = 3},
        {item = "copper_oxide", label = "Copper Oxide", qty = 8},
        {item = "magnesium", label = "Magnesium", qty = 1},
        {item = "plastic_casing", label = "Plastic Casing", qty = 1}
    },
    time = 60,
}
CraftList["WEAPON_VINTAGEPISTOL"] = {
    id = "WEAPON_VINTAGEPISTOL",
    description = "An old pistol",
    count = 1,
    recipe = {
        {item = "Pistol Jacket", label = "Pistol Jacket", qty = 1},
        {item = "Rubber Grip", label = "Rubber Grip",  qty = 1},
        {item = "9mm Barrel", label = "9mm Barrel", qty = 1}
    },
    time = 5,
}
CraftList["lingot_iron"] = {
    id = "lingot_iron",
    description = "A bar of iron",
    count = 1,
    craftText = "Smelting Ores...",
    recipe = {
        {item = "iron_piece", label = "Iron Ore", qty = 10},
    },
    time = 15,
}
CraftList["lingot_iron_craft"] = {
    id = "lingot_iron",
    description = "A bar of iron, just as valuable as any",
    count = 1,
    craftText = "Melting Scrap Pieces...",
    recipe = {
        {item = "scrap_pieces", label = "Scrap Piece", qty = 200},
    },
    gift = {
        {item = "aluminum", chance = 15, amount = 1},
        {item = "magnesium", chance = 5, amount = 1}
    },
    time = 30,
}
CraftList["lingot_gold"] = {
    id = "lingot_gold",
    description = "A bar of gold",
    count = 1,
    craftText = "Smelting Ores...",
    recipe = {
        {item = "gold_piece", label = "Gold Ore", qty = 10},
    },
    time = 15,
}
CraftList["lingot_silver"] = {
    id = "lingot_silver",
    description = "A bar of silver",
    count = 1,
    craftText = "Smelting Ores...",
    recipe = {
        {item = "silver_piece", label = "Silver Ore", qty = 10},
    },
    time = 15,
}
CraftList["lingot_carbon"] = {
    id = "lingot_carbon",
    description = "A lump of carbon",
    count = 1,
    craftText = "Smelting Ores...",
    recipe = {
        {item = "carbon_piece", label = "Carbon Piece", qty = 10},
    },
    time = 15,
}
CraftList["copper_oxide"] = {
    id = "copper_oxide",
    description = "A course red powder",
    count = 1,
    craftText = "Heating Copper Ore...",
    recipe = {
        {item = "copper_piece", label = "Copper Ore", qty = 10},
    },
    time = 60,
}
CraftList["plastic_casing"] = {
    id = "plastic_casing",
    description = "A plastic case, to hold something",
    count = 1,
    craftText = "Melting and Molding Plastic...",
    recipe = {
        {item = "empty-battery", label = "Empty Battery", qty = 10},
    },
    time = 60,
}