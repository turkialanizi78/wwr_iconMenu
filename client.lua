 

local menuConfig = {
    {
        icon = "📁",
        label = "Inventory",
        description = "Open your inventory",
        action = "openInventory"
    },
    {
        image = "gamer.png",
        label = "Vehicle",
        description = "Vehicle options",
        submenu = {
            {
                icon = "🚗",
                label = "Spawn Vehicle",
                description = "Spawn a new vehicle",
                action = "spawnVehicle"
            },
            {
                icon = "🔧",
                label = "Repair Vehicle",
                description = "Repair your current vehicle",
                action = "repairVehicle"
            }
        }
    },
    {
        label = "Settings",
        description = "Game settings",
        action = "openSettings"
    }
}

local menuActions = {
    openInventory = function()
        print("Opening inventory...")
        -- Add your inventory opening logic here
    end,
    spawnVehicle = function()
        print("Spawning vehicle...")
        -- Add your vehicle spawning logic here
    end,
    repairVehicle = function()
        print("Repairing vehicle...")
        -- Add your vehicle repair logic here
    end,
    openSettings = function()
        print("Opening settings...")
        -- Add your settings opening logic here
    end
}

local isMenuOpen = false
local currentMenu = menuConfig
local menuHistory = {}

function OpenMenu(menu, actions)
  
    isMenuOpen = true
    if menu then
 
        currentMenu = menu
        -- Merge the provided actions with the existing menuActions
        for k, v in pairs(actions or {}) do
            menuActions[k] = v
        end
    else
 
        currentMenu = menuConfig
    end
    
    -- Ensure currentMenu is always an array
    if type(currentMenu) == "table" and not currentMenu[1] then
        currentMenu = {currentMenu}
    end
 
    SendNUIMessage({
        type = "openMenu",
        items = currentMenu
    })
 
    SetNuiFocus(true, true)
 
end

 

function CloseMenu()
    isMenuOpen = false
    currentMenu = menuConfig
    menuHistory = {}
    SendNUIMessage({
        type = "closeMenu"
    })
    SetNuiFocus(false, false)
end

RegisterCommand("openmenu", function()
    print("openmenu command triggered")
    if not isMenuOpen then
        OpenMenu()
    else
        CloseMenu()
    end
end, false)

RegisterNUICallback("menuItemClicked", function(data, cb)
 
    if data.action and menuActions[data.action] then
        print("Executing action: " .. data.action)
        menuActions[data.action]()
    else
        print("No action found for: " .. tostring(data.label))
    end
    cb('ok')
end)

RegisterNUICallback("goBack", function(data, cb)
    if #menuHistory > 0 then
        currentMenu = table.remove(menuHistory)
        OpenMenu(currentMenu)
    else
        CloseMenu()
    end
    cb('ok')
end)

RegisterNUICallback("closeMenu", function(data, cb)
    CloseMenu()
    cb('ok')
end)

-- Export the OpenMenu function so it can be used in other scripts
exports('OpenMenu', OpenMenu)

 