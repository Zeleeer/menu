local Menu = RageUI.CreateMenu("Menu", " ")

local PlayerMenu = RageUI.CreateSubMenu(Menu, "Player", " ")

local VehMenu = RageUI.CreateSubMenu(Menu, "Vehicles", " ")

local WeapMenu = RageUI.CreateSubMenu(Menu, "Weapons", " ")
local WeapSubMenu = RageUI.CreateSubMenu(WeapMenu, "Component", " ")

Menu.EnableMouse = false

function RageUI.PoolMenus:Menu()
    Menu:IsVisible(function(Items)
        local ply = PlayerPedId()
        Items:AddButton("Player", false, { IsDisabled = false }, function(onSelected)
            if (onSelected) then
            end
        end, PlayerMenu)
        Items:AddButton("Vehicles", false, { IsDisabled = false }, function(onSelected)
            if (onSelected) then
            end
        end, VehMenu)
        Items:AddButton("Weapon", false, { IsDisabled = false }, function(onSelected)
            if (onSelected) then
            end
        end, WeapMenu)
    end, function()
    end)

    PlayerMenu:IsVisible(function(Items)
        local ply = PlayerPedId()
        Items:AddButton("Teleport to", "\"X Y Z\" with one space", { IsDisabled = false }, function(onSelected)
            if (onSelected) then
                position = NCS.Player:showKeyboard("Choose your position \"X Y Z\" ", "X Y Z", 30)
                NCS.Ped:setPosition(ply, position)
            end
        end)
        Items:AddButton("Teleport to marker", "Place a marquer to teleport", { IsDisabled = false }, function(onSelected)
            if (onSelected) then
                NCS.Player:setMarkerPosition()
            end
        end)
    end, function()
    end)

    VehMenu:IsVisible(function(Items)
        local ply = PlayerPedId()
        Items:AddButton("Spawn", "Choose your vehicle", { IsDisabled = false }, function(onSelected)
            if (onSelected) then
                local plyCoords = NCS.Ped:getPosition(ply)
                local vehicle = NCS.Player:showKeyboard("Choose some vehicle", "Name", 20)
                NCS.Vehicles:spawn(vehicle, plyCoords, 0)
                TaskWarpPedIntoVehicle(ply, veh, -1)
            end
        end)
        Items:AddButton("Repear", "Repear your vehicle", { IsDisabled = false }, function(onSelected)
            if (onSelected) then
                local onVehicle, vehicle = NCS.Ped:driveVehicle(ply)
                if (onVehicle) then
                    NCS.Vehicles:repair(vehicle)
                else
                    NCS.Player:showNotification("You need to drive a car", 6)
                end
            end
        end)
        Items:AddButton("Clean", "Clean your vehicle", { IsDisabled = false }, function(onSelected)
            if (onSelected) then
                local onVehicle, vehicle = NCS.Ped:driveVehicle(ply)
                if (onVehicle) then
                    NCS.Vehicles:clean(vehicle)
                else
                    NCS.Player:showNotification("You need to drive a car", 6)
                end
            end
        end)
        Items:AddButton("Delete", "Delete most proximity vehicle", { IsDisabled = false }, function(onSelected)
            if (onSelected) then
                local plyCoords = NCS.Ped:getPosition(ply)
                local proxVeh, distVeh = NCS.Vehicles:getClosest(plyCoords)
                if (distVeh < 3) then
                    NCS.Vehicles:delete(proxVeh)
                else return end
            end
        end)
    end, function()
    end)

    WeapMenu:IsVisible(function(Items)
        local ply = PlayerPedId()
        Items:AddButton("Choose", "Choose your weapon", { IsDisabled = false }, function(onSelected)
            if (onSelected) then
                local weapon = NCS.Player:showKeyboard("Choose some weapon","weapon_", 20)
                NCS.Ped:giveWeapon(ply, weapon, 500, false, true)
            end
        end)
        Items:AddButton("Remove", "Choose weapon to remove", { IsDisabled = false }, function(onSelected)
            if (onSelected) then
                local weapon = NCS.Player:showKeyboard("Choose some weapon to remove","weapon_", 20)
                NCS.Ped:removeWeapon(ply, weapon)
            end
        end)
        Items:AddButton("Component", false, { IsDisabled = false }, function(onSelected)
            if (onSelected) then
            end
        end, WeapSubMenu)
    end, function()
    end)

    WeapSubMenu:IsVisible(function(Items)
        local ply = PlayerPedId()
        Items:AddButton("Choose a component", "Typ your choose", { IsDisabled = false }, function(onSelected)
            if (onSelected) then
                weapon = NCS.Player:showKeyboard("Choose your weapon", "weapon_", 20)
                if NCS.Ped:hasWeapon(ply, weapon) then
                    weaponComponent = NCS.Player:showKeyboard("Choose your component to add", "COMPONENT_", 30)
                    NCS.Ped:giveWeaponComponent(ply, weapon, weaponComponent)
                end
            end
        end)
        Items:AddButton("Remove a component", "Open a list for choose", { IsDisabled = false }, function(onSelected)
            if (onSelected) then
                weapon = NCS.Player:showKeyboard("Choose your weapon", "weapon_", 20)
                if NCS.Ped:hasWeapon(ply, weapon) then
                    weaponComponent = NCS.Player:showKeyboard("Choose your component to remove", "COMPONENT_", 30)
                    NCS.Ped:removeWeaponComponent(ply, weapon, weaponComponent)
                end
            end
        end)
        --[[Items:AddButton(" ", " ", { IsDisabled = false }, function(onSelected)
            if (onSelected) then
            end
        end)]]
    end, function()
    end)
end

Keys.Register("F2", "F2", "Dev Menu", function()
    RageUI.Visible(Menu, not RageUI.Visible(Menu))
end)
