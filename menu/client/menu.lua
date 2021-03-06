local Menu = RageUI.CreateMenu("Menu", " ")

local PlayerMenu = RageUI.CreateSubMenu(Menu, "Player", " ")

local VehMenu = RageUI.CreateSubMenu(Menu, "Vehicles", " ")

local WeapMenu = RageUI.CreateSubMenu(Menu, "Weapons", " ")
local WeapSubMenu = RageUI.CreateSubMenu(WeapMenu, "Component", " ")

local showCoordsPed = false

Menu.EnableMouse = false

function RageUI.PoolMenus:Menu()
    Menu:IsVisible(function(Items)
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
                if position == nil then return end
                NCS.Ped:setPosition(ply, position)
            end
        end)
        Items:AddButton("Teleport to marker", "Place a marquer to teleport", { IsDisabled = false }, function(onSelected)
            if (onSelected) then
                NCS.Player:setMarkerPosition()
            end
        end)
        Items:AddButton("Respawn", " ", { IsDisabled = false }, function(onSelected)
            if (onSelected) then
                coords = {
                    position = GetEntityCoords(ply),
                    heading = GetEntityHeading(ply)
                }
                NCS.Player:spawn(coords)
            end
        end)
        Items:AddButton("Show coords", false, { IsDisabled = false }, function(onSelected)
            if (onSelected) then
                showCoordsPed = not showCoordsPed
            end
        end)
        Items:AddButton("Print coords (F8)", false, { IsDisabled = false }, function(onSelected)
            if (onSelected) then
                print(NCS.Entity:getPosition(PlayerPedId()))
            end
        end)
    end, function()
    end)

    VehMenu:IsVisible(function(Items)
        local ply = PlayerPedId()
        Items:AddButton("Spawn", "Choose your vehicle", { IsDisabled = false }, function(onSelected)
            if (onSelected) then
                local plyCoords = NCS.Entity:getPosition(ply)
                local vehicle = NCS.Player:showKeyboard("Choose some vehicle", "Name", 20)
                if vehicle == nil or vehicle == '' then return end
                local veh = NCS.Vehicles:spawn(vehicle, plyCoords, 0)
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
                local plyCoords = NCS.Entity:getPosition(ply)
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
                if weapon == nil then return end
                NCS.Ped:giveWeapon(ply, weapon, 500, false, true)
            end
        end)
        Items:AddButton("Remove", "Choose weapon to remove", { IsDisabled = false }, function(onSelected)
            if (onSelected) then
                local weapon = NCS.Player:showKeyboard("Choose some weapon to remove","weapon_", 20)
                if weapon == nil then return end
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
                if weapon == nil then return end
                if NCS.Ped:hasWeapon(ply, weapon) then
                    weaponComponent = NCS.Player:showKeyboard("Choose your component to add", "COMPONENT_", 30)
                    if weaponComponent == nil then return end
                    NCS.Ped:giveWeaponComponent(ply, weapon, weaponComponent)
                end
            end
        end)
        Items:AddButton("Remove a component", "Open a list for choose", { IsDisabled = false }, function(onSelected)
            if (onSelected) then
                weapon = NCS.Player:showKeyboard("Choose your weapon", "weapon_", 20)
                if weapon == nil then return end
                if NCS.Ped:hasWeapon(ply, weapon) then
                    weaponComponent = NCS.Player:showKeyboard("Choose your component to remove", "COMPONENT_", 30)
                    if weaponComponent == nil then return end
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

function DrawText2D(x, y, width, height, text, r, g, b, a, outline)
    SetTextFont(7)
    SetTextProportional(0)
    SetTextScale(0.4, 0.4)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

CreateThread(function()
    while true do
        if showCoordsPed then
            time = 3
            local plyCoords = GetEntityCoords(PlayerPedId())
            local plyHeading = GetEntityHeading(PlayerPedId())
            DrawText2D(0.66, 1.345, 1.0,1.0, " ~o~H ~s~: " ..string.format( "%6.3f", plyHeading), 255, 255, 255, 255)
            DrawText2D(0.66, 1.37, 1.0,1.0, " ~o~X ~s~: " ..string.format( "%6.3f", plyCoords.x), 255, 255, 255, 255)
            DrawText2D(0.66, 1.395, 1.0,1.0, " ~o~Y ~s~: "..string.format( "%6.3f", plyCoords.y), 255, 255, 255, 255)
            DrawText2D(0.66, 1.42, 1.0,1.0, " ~o~Z ~s~: "..string.format( "%6.3f", plyCoords.z), 255, 255, 255, 255)
        else
            time = 500
        end
        Wait(time)
    end
end)

Keys.Register("F2", "F2", "Dev Menu", function()
    RageUI.Visible(Menu, not RageUI.Visible(Menu))
end)
