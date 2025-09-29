local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CopyOutfitUI"
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 270, 0, 210)
Frame.Position = UDim2.new(0.5, -135, 0.5, -105)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Text = "Copy Outfit Tool"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = Frame

local NameBox = Instance.new("TextBox")
NameBox.Size = UDim2.new(1, -20, 0, 30)
NameBox.Position = UDim2.new(0, 10, 0, 50)
NameBox.PlaceholderText = "ใส่ชื่อผู้เล่น (ไม่ต้องเต็ม)"
NameBox.Text = ""
NameBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
NameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
NameBox.ClearTextOnFocus = false
NameBox.Font = Enum.Font.Gotham
NameBox.TextSize = 14
NameBox.Parent = Frame

local CopyButton = Instance.new("TextButton")
CopyButton.Size = UDim2.new(1, -20, 0, 40)
CopyButton.Position = UDim2.new(0, 10, 0, 100)
CopyButton.Text = "Copy Outfit"
CopyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyButton.Font = Enum.Font.GothamBold
CopyButton.TextSize = 16
CopyButton.Parent = Frame

local CopyClosestButton = Instance.new("TextButton")
CopyClosestButton.Size = UDim2.new(1, -20, 0, 40)
CopyClosestButton.Position = UDim2.new(0, 10, 0, 150)
CopyClosestButton.Text = "Copy คนที่อยู่ใกล้สุด"
CopyClosestButton.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
CopyClosestButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyButton.Font = Enum.Font.GothamBold
CopyButton.TextSize = 16
CopyButton.Parent = Frame

local function FindPlayerByPartialName(partName)
	partName = string.lower(partName)
	for _, plr in ipairs(Players:GetPlayers()) do
		if string.find(string.lower(plr.Name), partName) then
			return plr
		end
	end
	return nil
end
local function ExtractId(id)
	if type(id) == "string" then
		return tonumber(id:match("%d+")) or 0
	end
	return tonumber(id) or 0
end

local function GetPlayerOutfitData(targetName)
	local targetPlayer = FindPlayerByPartialName(targetName)
	if not targetPlayer then
		warn("ไม่พบผู้เล่น: " .. targetName)
		return nil
	end

	local character = targetPlayer.Character
	if not character then
		warn("ไม่พบตัวละครผู้เล่น")
		return nil
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		warn("ไม่พบ Humanoid")
		return nil
	end

	local desc = humanoid:GetAppliedDescription()

	local accessories = {}

	for _, acc in ipairs(desc:GetAccessories(true)) do
		table.insert(accessories, {
			Rotation = Vector3.new(0, 0, 0),
			AssetId = ExtractId(acc.AssetId),
			Position = Vector3.new(0, 0, 0),
			Scale = Vector3.new(1, 1, 1),
			IsLayered = acc.IsLayered or false,
			AccessoryType = acc.AccessoryType
		})
	end

	local faceId = ExtractId(desc.Face)

	return {{
		Shirt = ExtractId(desc.Shirt),
		Pants = ExtractId(desc.Pants),
		GraphicTShirt = ExtractId(desc.GraphicTShirt),
		Face = faceId,
		LeftArm = ExtractId(desc.LeftArm),
		RightArm = ExtractId(desc.RightArm),
		Torso = ExtractId(desc.Torso),
		LeftLeg = ExtractId(desc.LeftLeg),
		RightLeg = ExtractId(desc.RightLeg),
		Head = ExtractId(desc.Head),
		Accessories = accessories,

		HeadColor = desc.HeadColor,
		LeftArmColor = desc.LeftArmColor,
		RightArmColor = desc.RightArmColor,
		TorsoColor = desc.TorsoColor,
		LeftLegColor = desc.LeftLegColor,
		RightLegColor = desc.RightLegColor,

		BodyTypeScale = desc.BodyTypeScale,
		DepthScale = desc.DepthScale,
		HeadScale = desc.HeadScale,
		HeightScale = desc.HeightScale,
		ProportionScale = desc.ProportionScale,
		WidthScale = desc.WidthScale,

		RunAnimation = ExtractId(desc.RunAnimation),
		WalkAnimation = ExtractId(desc.WalkAnimation),
		JumpAnimation = ExtractId(desc.JumpAnimation),
		IdleAnimation = ExtractId(desc.IdleAnimation),
		FallAnimation = ExtractId(desc.FallAnimation),
		ClimbAnimation = ExtractId(desc.ClimbAnimation),
		SwimAnimation = ExtractId(desc.SwimAnimation),
		MoodAnimation = ExtractId(desc.MoodAnimation)
	}}
end
CopyButton.MouseButton1Click:Connect(function()
	local name = NameBox.Text
	if name ~= "" then
		local outfitData = GetPlayerOutfitData(name)
		if outfitData then
			local remote = ReplicatedStorage:WaitForChild("BloxbizRemotes"):WaitForChild("CatalogOnApplyOutfit")
			remote:FireServer(unpack(outfitData))
			print("✅ Copy Outfit สำเร็จ: " .. name)
		else
			warn("❌ ไม่สามารถ Copy Outfit ได้")
		end
	end
end)
local function FindClosestPlayer()
	local closestPlayer = nil
	local shortestDistance = math.huge
	local myCharacter = LocalPlayer.Character
	if not myCharacter or not myCharacter:FindFirstChild("HumanoidRootPart") then
		return nil
	end
	local myPos = myCharacter.HumanoidRootPart.Position

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local dist = (plr.Character.HumanoidRootPart.Position - myPos).Magnitude
			if dist < shortestDistance then
				shortestDistance = dist
				closestPlayer = plr
			end
		end
	end

	return closestPlayer
end
CopyClosestButton.MouseButton1Click:Connect(function()
	local closest = FindClosestPlayer()
	if closest then
		local outfitData = GetPlayerOutfitData(closest.Name)
		if outfitData then
			local remote = ReplicatedStorage:WaitForChild("BloxbizRemotes"):WaitForChild("CatalogOnApplyOutfit")
			remote:FireServer(unpack(outfitData))
			print("✅ Copy Outfit จาก " .. closest.Name)
		else
			warn("❌ ไม่สามารถ Copy Outfit ได้")
		end
	else
		warn("❌ ไม่พบผู้เล่นที่อยู่ใกล้ที่สุด")
	end
end)
