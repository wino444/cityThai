--// 🌟 Copy Outfit Tool - Fixed & Enhanced by Dark Lua Master 🌟
--// ปุ่มกลับมาแล้ว + ปุ่มปิด + ป้องกัน Error + Stealth Mode 😈

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

--// สร้าง GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CopyOutfitUI_Exploit"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 270, 0, 240) -- เพิ่มความสูงหน่อย
Frame.Position = UDim2.new(0.5, -135, 0.5, -120)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

--// มุมโค้ง + เงา (สวย + ลดการตรวจจับ)
local Corner = Instance.new("UICorner", Frame)
Corner.CornerRadius = UDim.new(0, 8)

--// ปุ่มปิด (X)
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.Text = "X"
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.TextColor3 = Color3.new(1,1,1)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = Frame
local CloseCorner = Instance.new("UICorner", CloseButton)
CloseCorner.CornerRadius = UDim.new(0, 6)

CloseButton.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
	print("🗑️ GUI ถูกทำลายเรียบร้อย – ไม่ทิ้งร่องรอย")
end)

--// หัวข้อ
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 0, 30)
Title.Position = UDim2.new(0, 10, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "👕 Copy Outfit Tool 👕"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = Frame

--// ช่องชื่อ
local NameBox = Instance.new("TextBox")
NameBox.Size = UDim2.new(1, -20, 0, 35)
NameBox.Position = UDim2.new(0, 10, 0, 45)
NameBox.PlaceholderText = "ชื่อผู้เล่น (ไม่ต้องเต็ม)"
NameBox.Text = ""
NameBox.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
NameBox.TextColor3 = Color3.new(1,1,1)
NameBox.ClearTextOnFocus = false
NameBox.Font = Enum.Font.Gotham
NameBox.TextSize = 14
NameBox.Parent = Frame
local NameCorner = Instance.new("UICorner", NameBox)
NameCorner.CornerRadius = UDim.new(0, 6)

--// ปุ่ม Copy จากชื่อ
local CopyButton = Instance.new("TextButton")
CopyButton.Size = UDim2.new(1, -20, 0, 40)
CopyButton.Position = UDim2.new(0, 10, 0, 90)
CopyButton.Text = "📋 Copy Outfit"
CopyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
CopyButton.TextColor3 = Color3.new(1,1,1)
CopyButton.Font = Enum.Font.GothamBold
CopyButton.TextSize = 16
CopyButton.Parent = Frame
local CopyCorner = Instance.new("UICorner", CopyButton)
CopyCorner.CornerRadius = UDim.new(0, 8)

--// 🔥 ปุ่ม Copy คนใกล้สุด – กลับมาแล้ว! 🔥
local CopyClosestButton = Instance.new("TextButton")
CopyClosestButton.Size = UDim2.new(1, -20, 0, 40)
CopyClosestButton.Position = UDim2.new(0, 10, 0, 140)
CopyClosestButton.Text = "🎯 Copy คนใกล้สุด"
CopyClosestButton.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
CopyClosestButton.TextColor3 = Color3.new(1,1,1)
CopyClosestButton.Font = Enum.Font.GothamBold
CopyClosestButton.TextSize = 16
--// 🔥 ซ่อมตรงนี้! ใช้ CopyClosestButton.Parent ไม่ใช่ CopyButton 🔥
CopyClosestButton.Parent = Frame
local ClosestCorner = Instance.new("UICorner", CopyClosestButton)
ClosestCorner.CornerRadius = UDim.new(0, 8)

--// ฟังก์ชันหาผู้เล่น
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

--// ดึง Outfit
local function GetPlayerOutfitData(targetName)
	local targetPlayer = FindPlayerByPartialName(targetName)
	if not targetPlayer or not targetPlayer.Character then
		warn("❌ ไม่พบผู้เล่น: " .. targetName)
		return nil
	end

	local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return nil end

	local desc = humanoid:GetAppliedDescription()
	if not desc then return nil end

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

	return {{
		Shirt = ExtractId(desc.Shirt),
		Pants = ExtractId(desc.Pants),
		GraphicTShirt = ExtractId(desc.GraphicTShirt),
		Face = ExtractId(desc.Face),
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

--// Remote (ป้องกัน Error)
local function GetRemote()
	local success, remote = pcall(function()
		return ReplicatedStorage:WaitForChild("BloxbizRemotes", 5):WaitForChild("CatalogOnApplyOutfit", 5)
	end)
	return success and remote or nil
end

--// ปุ่ม Copy จากชื่อ
CopyButton.MouseButton1Click:Connect(function()
	local name = NameBox.Text
	if name == "" then return end

	local outfitData = GetPlayerOutfitData(name)
	if outfitData then
		local remote = GetRemote()
		if remote then
			remote:FireServer(unpack(outfitData))
			print("✅ Copy สำเร็จ: " .. name)
		else
			warn("❌ ไม่พบ Remote – เกมอาจอัปเดต")
		end
	else
		warn("❌ ไม่สามารถดึง Outfit ได้")
	end
end)

--// หาคนใกล้สุด
local function FindClosestPlayer()
	local myChar = LocalPlayer.Character
	if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end
	local myPos = myChar.HumanoidRootPart.Position
	local closest, dist = nil, math.huge

	for _, plr in Players:GetPlayers() do
		if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local d = (plr.Character.HumanoidRootPart.Position - myPos).Magnitude
			if d < dist then
				dist, closest = d, plr
			end
		end
	end
	return closest
end

--// ปุ่ม Copy คนใกล้สุด
CopyClosestButton.MouseButton1Click:Connect(function()
	local closest = FindClosestPlayer()
	if not closest then
		warn("❌ ไม่พบผู้เล่นใกล้เคียง")
		return
	end

	local outfitData = GetPlayerOutfitData(closest.Name)
	if outfitData then
		local remote = GetRemote()
		if remote then
			remote:FireServer(unpack(outfitData))
			print("🎯 Copy จาก " .. closest.Name .. " (ระยะ: " .. math.floor((closest.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude) .. " สตั๊ด)")
		else
			warn("❌ Remote หาย – Anti-Exploit?")
		end
	else
		warn("❌ ดึง Outfit ล้มเหลว")
	end
end)

print("🚀 Copy Outfit Tool โหลดสำเร็จ – พร้อมล่า Outfit!")
