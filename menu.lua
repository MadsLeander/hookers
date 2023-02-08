local serviceSelected = nil
local ServicesMenu = {
    Title = "Services Available",
    Buttons = {
        { service = "SERVICE_BLOWJOB", label = "Blow Job" },
        { service = "SERVICE_SEX", label = "Sex" },
        { service = "SERVICE_DECLINE", label = "Decline Service" },
    },
    OnButtonSelected = function(button)
		serviceSelected = button.service
    end
}

local colour = {
	white = { 255, 255, 255 },
	black = { 0, 0, 0 }
}

local menu = {
    x = 0.24, y = 0.05, width = 0.225, height = 0.035
}

local function LoadStreamedTextureDict(textureDict)
    RequestStreamedTextureDict(textureDict, false)
    if not HasStreamedTextureDictLoaded(textureDict) then
        Wait(100)
    end
end

local function UnloadStreamedTextureDict(textureDict)
	if HasStreamedTextureDictLoaded(textureDict) then
		SetStreamedTextureDictAsNoLongerNeeded(textureDict)
	end
end

local function DrawText(intFont, stirngText, floatScale, intPosX, intPosY, color)
	SetTextFont(intFont)
	SetTextScale(floatScale, floatScale)
	SetTextColour(color[1], color[2], color[3], 255)

	BeginTextCommandDisplayText("STRING")
	AddTextComponentSubstringPlayerName(stirngText)
	EndTextCommandDisplayText(intPosX, intPosY)
end

local function GetButtons()
	local allButtons = ServicesMenu.Buttons
	if not allButtons then return {} end
    
	ServicesMenu.TempData = { allButtons, #allButtons }

	return allButtons, #allButtons
end

local function DrawMenuButton(button, intX, intY, boolSelected, intW, intH)
	local rectColour = boolSelected and colour.white or colour.black
	local rectAlpha = boolSelected and 255 or 100
	DrawRect(intX, intY, intW, intH, rectColour[1], rectColour[2], rectColour[3], rectAlpha)

	local textColour = boolSelected and colour.black or colour.white
	DrawText(0, button.label, 0.35, intX - intW / 2 + 0.005, intY - intH / 2 + 0.0025, textColour)
end

local function DrawTitle()
	DrawRect(ServicesMenu.Width - menu.width / 2, ServicesMenu.Height - menu.height / 2, menu.width, menu.height, colour.black[1], colour.black[2], colour.black[3], 255)
	ServicesMenu.Height = ServicesMenu.Height + 0.005

	DrawText(0, ServicesMenu.Title, 0.35, ServicesMenu.Width - menu.width + 0.005, ServicesMenu.Height - menu.height - 0.002, colour.white)
	ServicesMenu.Height = ServicesMenu.Height + 0.01
end

local function DrawButtons()
	for index, data in ipairs(ServicesMenu.Buttons) do
        local boolSelected = index == ServicesMenu.Line.current
        DrawMenuButton(data, ServicesMenu.Width - menu.width / 2, ServicesMenu.Height, boolSelected, menu.width, menu.height)
        ServicesMenu.Height = ServicesMenu.Height + menu.height
    end
end

local function DrawMenu()
	ServicesMenu.Height = menu.y
	ServicesMenu.Width = menu.x

	DrawTitle()
	DrawButtons()
end

local function HandleControls()
	-- Move up/down
	local moveUp, moveDown = IsControlPressed(1, 172), IsControlPressed(1, 173)
	if moveUp or moveDown then
		PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FREEMODE_SOUNDSET", true)

		local newLine = ServicesMenu.Line.current
		if moveUp then
			newLine = newLine - 1
			if newLine < ServicesMenu.Line.min then
				newLine = ServicesMenu.Line.max
			end
		elseif moveDown then
			newLine = newLine + 1
			if newLine > ServicesMenu.Line.max then
				newLine = ServicesMenu.Line.min
			end
		end
		ServicesMenu.Line.current = newLine

		Citizen.Wait(75)
	end

    -- Selected current button
    if IsControlJustPressed(1, 201) then
		PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
		local currentButtons = table.unpack(ServicesMenu.TempData)
        ServicesMenu.OnButtonSelected(currentButtons[ServicesMenu.Line.current])
    end

    -- Exits the menu
	if IsControlJustPressed(1, 202) then
		serviceSelected = "SERVICE_DECLINE"
		Wait(100)
	end
end

local function MenuThreads()
	CreateThread(function()
		while ServicesMenu.IsOpen do
			DrawMenu()
			Wait(0)
		end
	end)
	
	CreateThread(function()
		while ServicesMenu.IsOpen do
			HandleControls()
			Wait(0)
		end
	end)
end

local function CloseMenu()
	if ServicesMenu.IsOpen then
		ServicesMenu.IsOpen = false
		ServicesMenu.TempData = {}
		ServicesMenu.Line = {}

		UnloadStreamedTextureDict("CommonMenu")
	end
end

local function OpenMenu()
	LoadStreamedTextureDict("CommonMenu")
	local newButtons, buttonsCount = GetButtons()
	
	ServicesMenu.Line = { min = 1, max = buttonsCount, current = 1 }
	ServicesMenu.TempData = { newButtons, buttonsCount }
	ServicesMenu.IsOpen = true

	MenuThreads()
end


function OfferServices()
	OpenMenu()
	
	while not serviceSelected do
		Wait(25)
	end

	CloseMenu()
	local service = serviceSelected
	serviceSelected = nil

	return service
end

