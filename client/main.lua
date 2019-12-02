local jailed = false
local int = 0
local time = config.defTime

RegisterNetEvent('wld-jailer:jail')
AddEventHandler('wld-jailer:jail', function(input)
    if input ~= nil then time = input end
    if time > config.maxTime then time = config.maxTime end
    if not jailed then
        jail(time)
        jailed = true
    end
end)

RegisterNetEvent('wld-jailer:unjail')
AddEventHandler('wld-jailer:unjail', function()
    if jailed then jailed = false end
end)

function jail(time)
    if DoesEntityExist(GetPlayerPed(-1)) then
        Citizen.CreateThread(function()
            if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                local pv = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                SetEntityAsMissionEntity(pv, true, true )
                DeleteVehicle(pv)
            end
            SetEntityCoords(GetPlayerPed(-1), config.coords)
            SetEntityInvincible(GetPlayerPed(-1), true)
            local skin = GetHashKey(config.skin)
            RequestModel(skin)
	        while not HasModelLoaded(skin) do
                Citizen.Wait(0)
	        end
            SetPlayerModel(PlayerId(), skin)
            while time > 0 and jailed do
                ResetPed(GetPlayerPed(-1))
                if IsEntityAwayFromJail(GetPlayerPed(-1), config.radius) then
                    time = time + config.escapeExtension
                    TriggerEvent('chat:addMessage', {color={255,102,0},muiltiline=true,args={"[JAIL]","Your Jail time has been extended to "..time.." seconds due to a escape attempt!"}})
                    SetEntityCoords(GetPlayerPed(-1), config.coords)
                end
                int = int + 1
                if int == config.annouceInterval and time ~= 1 then
                    local undertime = time - 1
                    TriggerEvent('chat:addMessage', {color={255,102,0},muiltiline=true,args={"[JAIL]",undertime.." more second(s) until release"}})
                    int = 0
                end
                Citizen.Wait(1000)
                time = time - 1
            end
            int = 0
            jailed = false
            ResetPed(GetPlayerPed(-1))
            SetEntityInvincible(GetPlayerPed(-1), false)
            SetEntityCoords(GetPlayerPed(-1), config.releaseCoords)
            TriggerServerEvent('wld-jailer:unjailed')
        end)
    end
end

function ResetPed(ped)
    SetPedArmour(ped, 0)
    RemoveAllPedWeapons(ped, true)
    ClearPedBloodDamage(ped)
    ResetPedVisibleDamage(ped)
    ClearPedLastWeaponDamage(ped)
    if IsPedSittingInAnyVehicle(ped) then
        local rpv = GetVehiclePedIsIn(ped, false)
        ClearPedTasksImmediately(ped)
        SetVehicleDoorsLocked(rpv, 2)
SetEntityAsMissionEntity(rpv, true, true)
        DeleteVehicle(rpv)
        TriggerEvent('chat:addMessage', {color={255,102,0},muiltiline=true,args={"[JAIL]","You can't drive a car in jail, dumb dumb..."}})
    end
end

function IsEntityAwayFromJail(e, md)
    local d = Vdist(config.jail.coords, GetEntityCoords(e))
    if d > md then return true else return false end
end