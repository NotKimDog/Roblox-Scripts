if not getgenv().totalServers then
	getgenv().totalServers = 0
end
if not game:IsLoaded() then
    game.Loaded:Wait()
end
local console = loadstring(game:HttpGet("https://raw.githubusercontent.com/4lve/SynapseXConsole/main/maine.lua"))()
console.new()
console.windowname('PSX Script Created By 4lve#0001')
console.clear()
console.log('Joined Server! Script Created By 4lve#0001')
console.newline()
local Lib = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))
while not Lib.Loaded do
	game:GetService("RunService").Heartbeat:Wait()
end

spawn(function()
	local PlaceID = game.PlaceId
	local AllIDs = {}
	local foundAnything = ""
	local actualHour = os.date("!*t").hour
	local Deleted = false
	function TPReturner()
		local Site;
		if foundAnything == "" then
			Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
		else
			Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
		end
		local ID = ""
		if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
			foundAnything = Site.nextPageCursor
		end
		local num = 0;
		for i,v in pairs(Site.data) do
			local Possible = true
			ID = tostring(v.id)
			if tonumber(v.maxPlayers) > tonumber(v.playing) then
				for _,Existing in pairs(AllIDs) do
					if num ~= 0 then
						if ID == tostring(Existing) then
							Possible = false
						end
					else
						if tonumber(actualHour) ~= tonumber(Existing) then
							local delFile = pcall(function()
								delfile("NotSameServers.json")
								AllIDs = {}
								table.insert(AllIDs, actualHour)
							end)
						end
					end
					num = num + 1
				end
				if Possible == true then
					table.insert(AllIDs, ID)
					wait()
					pcall(function()
						writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
						wait()
						game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
					end)
					wait(4)
				end
			end
		end
	end
	function Teleport()
		while wait() do
			pcall(function()
				TPReturner()
				if foundAnything ~= "" then
					TPReturner()
				end
			end)
		end
	end
end)

nextTeleport = queue_on_teleport or syn.queue_on_teleport



function sendPet(coinID, petID)
    Lib.Network.Fire("change pet target", petID, "Coin", coinID)
    Lib.Network.Fire("farm coin", coinID, petID)
end

function sendPets(coinID)
	console.newline()
	console.log('[2] Sending Pets To Chest')
	equippedPets = {}
    for i, v in pairs(Lib.Save.Get().Pets) do
        if v.e then
            table.insert(equippedPets, v.uid)
        end
    end

	Lib.Network.Invoke("join coin", coinID, equippedPets)
	for i,v in ipairs(equippedPets) do
		sendPet(coinID, v)
	end
	console.newline()
	console.log('[3] Pets Sent To Chest')

	Lib.Network.Fired("Remove Coin"):Connect(function(cID)
		if(cID == coinID) then
			console.newline()
			console.log('[4] Chest Destroyed Teleporting To Another Game')
			getgenv().totalServers = getgenv().totalServers + 1
			spawn(function()
				Teleport()
			end)
			pcall(function()
				nextTeleport([[
				getgenv().totalServers = ]]..totalServers..[[
				loadstring(game:HttpGet("https://raw.githubusercontent.com/4lve/Roblox/main/QuestCompleter"))()
				]])
			end)
			return true
		end
	end)

	wait(60)
	console.log('[4] Pets Took To Long To Destroy Chest Server Hopping Anyways')
	getgenv().totalServers = getgenv().totalServers + 1
	spawn(function()
		Teleport()
	end)
	pcall(function()
		nextTeleport([[
		getgenv().totalServers = ]]..totalServers..[[
		loadstring(game:HttpGet("https://raw.githubusercontent.com/4lve/Roblox/main/QuestCompleter"))()
		]])
	end)
end


function searchWorld(world)
    Lib.Network.Fire("request world", world)
    coins = (Lib.Network.Invoke("Get Coins"))
    for i,v in pairs(coins) do
        if(v.n == ('Christmas Gingerbread Chest')) then
            console.log("[1] Found Gingerbread Chest In "..world)
			sendPets(i)
            return true
        end
    end
    console.log("No Chest Found In "..world)
	return false
end

Stage = Lib.Save.Get().ChristmasEventQuest.Stage
Proggres = Lib.Save.Get().ChristmasEventQuest.Progress
Needed = Lib.Shared.ChristmasEventQuests[Stage].Needed

console.formatcolors("Current Job ID: &a"..game.JobId)
console.newline()
console.newline()
console.formatcolors("Total Servers Joined: &a"..totalServers)
console.newline()
console.newline()
console.log("Total Progress: ")
console.progressbar(Proggres, Needed, 20)

console.newline()
console.newline()
console.log("Activity:")
console.newline()



if searchWorld("Spawn") then
	return true
end
console.newline()
if searchWorld("Fantasy") then
	return true
end
console.newline()
if searchWorld("Tech") then
	return true
end
console.newline()
console.log("No Chest Found")

getgenv().totalServers = getgenv().totalServers + 1
spawn(function()
	Teleport()
end)
pcall(function()
	nextTeleport([[
	getgenv().totalServers = ]]..totalServers..[[
	loadstring(game:HttpGet("https://raw.githubusercontent.com/4lve/Roblox/main/QuestCompleter"))()
	]])
end)
console.newline()
console.log("Teleporting To New Server")
