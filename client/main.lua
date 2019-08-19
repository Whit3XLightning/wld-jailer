--so it fucking works, whoever comes in and desides to change something in here make sure it's not in the config.
--if you have a problem with the code suck my fucking cock
--i would also like to thank my mom for feeding me a meal during this proccess

--I desided I'll probably release this on my gh, the code it pretty cool. will also try and work on saving their ped and giving it back to them when they get out!

local jailed = false
local int = 0
local time = config.jail.defTime

RegisterNetEvent('wld-jailer:jail')
AddEventHandler('wld-jailer:jail', function(input)
    if input ~= nil then time = input end
    if time > config.jail.maxTime then time = config.jail.maxTime end
    if not jailed then
        jail(time) --realizing i'm going to have to do all of this from scratch
        jailed = true
    end
end)

RegisterNetEvent('wld-jailer:unjail')
AddEventHandler('wld-jailer:unjail', function()
    if jailed then jailed = false end
end)

function jail(time) --why tf did I make this a function?
    if DoesEntityExist(GetPlayerPed(-1)) then
        Citizen.CreateThread(function()
            if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                local pv = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                SetEntityAsMissionEntity(pv, true, true )
                DeleteVehicle(pv)
            end
            SetEntityCoords(GetPlayerPed(-1), config.jail.coords)
            SetEntityInvincible(GetPlayerPed(-1), true) --idk if I should do this but idrc either way
            local skin = GetHashKey(config.jail.skin)
            RequestModel(skin)
	        while not HasModelLoaded(skin) do --fucking slow ass 5m
                Citizen.Wait(0)
	        end
            SetPlayerModel(PlayerId(), skin) --why tf is it playerid instead of playerpedid
            while time > 0 and jailed do
                ResetPed(GetPlayerPed(-1))
                if IsEntityAwayFromJail(GetPlayerPed(-1), config.jail.radius) then
                    time = time + config.jail.escapeExtension
                    TriggerEvent('chat:addMessage', {color={255,102,0},muiltiline=true,args={"[JAIL]","Your Jail time has been extended to "..time.." seconds due to a escape attempt!"}})
                    SetEntityCoords(GetPlayerPed(-1), config.jail.coords) --where i'm starting to hate my life
                end
                int = int + 1
                if int == config.jail.annouceInterval and time ~= 1 then --and a time check because it would say 0 seconds until release, like no bitch, fuck you...
                    local undertime = time - 1 --this is the most retarted thing about this script
                    TriggerEvent('chat:addMessage', {color={255,102,0},muiltiline=true,args={"[JAIL]",undertime.." more second(s) until release"}})
                    int = 0
                end
                Citizen.Wait(1000) --i mean... it still does the job for the count down :|
                time = time - 1
            end
            int = 0 --like wtf was I thinking
            jailed = false
            ResetPed(GetPlayerPed(-1))
            SetEntityInvincible(GetPlayerPed(-1), false)
            SetEntityCoords(GetPlayerPed(-1), config.jail.releaseCoords)
            TriggerServerEvent('wld-jailer:unjailed')
        end)
    end
end

function ResetPed(ped) --this is pretty cool might use it again somewhere else
    SetPedArmour(ped, 0)
    RemoveAllPedWeapons(ped, true) --no rdm at the prison now mother fuckers
    ClearPedBloodDamage(ped)
    ResetPedVisibleDamage(ped)
    ClearPedLastWeaponDamage(ped)
    if IsPedSittingInAnyVehicle(ped) then
        local rpv = GetVehiclePedIsIn(ped, false)
        ClearPedTasksImmediately(ped)
        SetVehicleDoorsLocked(rpv, 2) --Incase the vehicle doesn't delete bc 1s is shit (2 means people can get out but not in)
        SetEntityAsMissionEntity(rpv, true, true)
        DeleteVehicle(rpv) --this works just fine idk why tf people use the raw native
        TriggerEvent('chat:addMessage', {color={255,102,0},muiltiline=true,args={"[JAIL]","You can't drive a car in jail, dumb dumb..."}}) --hehe
    end
end

function IsEntityAwayFromJail(e, md)
    local d = Vdist(config.jail.coords, GetEntityCoords(e))
    if d > md then return true else return false end --really hope this works
end