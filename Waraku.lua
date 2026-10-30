                                                                                       
local env = type(getgenv) == "function" and getgenv() or _G

if type(env.Waraku) == "table" and type(env.Waraku.Destroy) == "function" then
	pcall(function() env.Waraku:Destroy() end)
end

local function purgeOldVisuals()
	local guiParent = (gethui and gethui()) or game:GetService("CoreGui")
	for _, name in ipairs({"WarakuESP", "Waraku"}) do
		local old = guiParent:FindFirstChild(name) or game:GetService("CoreGui"):FindFirstChild(name)
		if old then pcall(function() old:Destroy() end) end
	end
	for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
		if p.Character then
			for _, c in ipairs(p.Character:GetChildren()) do
				if c:IsA("Highlight") and string.sub(c.Name, 1, 7) == "Waraku_" then
					pcall(function() c:Destroy() end)
				end
			end
		end
	end
end
pcall(purgeOldVisuals)

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
local CollectionService = game:GetService("CollectionService")
local TweenService = game:GetService("TweenService")
local InsertService = game:GetService("InsertService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Round = require(RS:WaitForChild("Modules"):WaitForChild("CurrentRoundClient"))
local Gameplay = RS:WaitForChild("Remotes"):WaitForChild("Gameplay")

local V = {
	Build = "Waraku",
    Release = "r23-fast-proximity-gun-pickup",
	Connections = {},
	PlayerConnections = {},
	CharacterConnections = {},
	Drawings = {},
	Highlights = {},
	Tracers = {},
	WeaponOriginal = setmetatable({}, {__mode = "k"}),
	WeaponMeshOriginal = setmetatable({}, {__mode = "k"}),
	WeaponPartLocks = setmetatable({}, {__mode = "k"}),
	WeaponMeshLocks = setmetatable({}, {__mode = "k"}),
	WeaponOverlays = setmetatable({}, {__mode = "k"}),
	ChamsOriginal = setmetatable({}, {__mode = "k"}),
	ChamsMeshOriginal = setmetatable({}, {__mode = "k"}),
	ChamsPartLocks = setmetatable({}, {__mode = "k"}),
	ChamsMeshLocks = setmetatable({}, {__mode = "k"}),
	ChamsAdornments = {},
	Enabled = true,
	RoundOnly = true,
	ShowInLobby = false,
	HighlightEnabled = false,
	BoxEnabled = false,
    AdaptiveESP = true,
    ESPAccessories = false,
    ESPPadding = 2,
	ChamsEnabled = false,
	BoxStyle = "Full",
	BoxRoleColor = false,
	BoxColor = Color3.fromRGB(255, 255, 255),
	ShowDead = false,
	MaxDistance = 15000,
	BoxThickness = 1,
	BoxCornerLength = 22,
	BoxOutlineColor = Color3.new(0, 0, 0),
	BoxTransparency = 1,
	BoxGradient = false,
	BoxGradientColor = Color3.fromRGB(0, 0, 255),
	BoxFillEnabled = false,
	BoxFillGradient = false,
	BoxFillAngle = 90,
	BoxFillAnim = "Off",
	BoxFillSpeed = 1,
	BoxGradientAngle = 90,
	BoxFillColor = Color3.fromRGB(255, 255, 255),
	BoxFillGradientColor = Color3.fromRGB(0, 0, 255),
	BoxFillTransparency = 0.5,
	BoxOutline = false,
	NameEnabled = false,
	NameUseDisplay = false,
	NameColor = Color3.fromRGB(255, 255, 255),
	NameGradient = false,
    NameGradientRotation = 0,
	NameGradientColor1 = Color3.fromRGB(255, 255, 255),
	NameGradientColor2 = Color3.fromRGB(255, 0, 0),
	NameSize = 10,
	NameFont = "Code",
	NameOutline = true,
	NameOutlineThickness = 1,
	NameBackground = false,
	NameBackgroundColor = Color3.fromRGB(12, 12, 14),
	NameBackgroundTransparency = 0.45,
	NameRoleColor = false,
	NameOffset = 0,
	DistanceFormat = "Brackets",
	DistanceEnabled = false,
	DistanceColor = Color3.fromRGB(255, 255, 255),
	DistanceGradient = false,
	DistanceGradientColor1 = Color3.fromRGB(255, 255, 255),
	DistanceGradientColor2 = Color3.fromRGB(255, 0, 0),
	DistanceSize = 11,
	DistanceFont = "Plex",
	DistanceOutline = true,
	RoleFlagEnabled = false,
	RoleFlagSize = 10,
	RoleFlagFont = "GothamBold",
	TextScale = 1,
    ShowRoleMurderer = true,
    ShowRoleSheriff = true,
    ShowRoleHero = true,
    ShowRoleInnocent = true,
	CustomRoleColors = true,
	RoleColorMurderer = Color3.fromRGB(255, 65, 72),
	RoleColorSheriff = Color3.fromRGB(65, 145, 255),
	RoleColorHero = Color3.fromRGB(255, 215, 0),
	RoleColorInnocent = Color3.fromRGB(255, 255, 255),
	ChamsStyle = "Flat",
    LocalChamsEnabled = false,
    LocalChamsStyle = "Flat",
    LocalChamsColor = Color3.fromRGB(170, 120, 255),
    LocalChamsRoleColor = false,
    LocalChamsTransparency = 0,
    LocalChamsAccessories = true,
    ChamsOutline = true,
    LocalChamsOutline = true,
    ChamsGlowColor = Color3.fromRGB(255, 75, 125),
    ChamsGlowStrength = 60,
    ChamsGlowWidth = 0.08,
    ChamsGlowPulse = false,
    ChamsOutlineAlpha = 0,
    LocalChamsGlowColor = Color3.fromRGB(255, 75, 125),
    LocalChamsGlowStrength = 60,
    LocalChamsGlowWidth = 0.08,
    LocalChamsGlowPulse = false,
    LocalChamsOutlineColor = Color3.fromRGB(255, 235, 245),
    LocalChamsOutlineAlpha = 0,
    ChamsColor = Color3.fromRGB(95, 30, 55),
    ChamsRoleColor = true,
    ChamsAmbient = 0.50,
    ChamsLight = 0.72,
    ChamsLightYaw = -35,
    ChamsLightPitch = -45,
    ChamsCameraLight = true,
    WorldDayCycle = false,
    WorldDaySpeed = 0.1,
    WorldGravityOverride = false,
    WorldGravity = 196.2,
    WorldLightsOverride = false,
    WorldLightBrightness = 1,
    WorldLightRange = 1,
    WorldLightColor = Color3.new(1,1,1),
    WorldLightTint = 0,
    WorldLightShadows = true,
    WorldSkyPitch = 0,
    WorldSkyYaw = 0,
    WorldSkyRoll = 0,
    WorldSkyOverride = false,
    WorldStars = 3000,
    WorldSunSize = 21,
    WorldMoonSize = 11,
    WorldCelestialBodies = true,
    WorldWaterOverride = false,
    WorldWaterColor = Color3.fromRGB(20, 90, 110),
    WorldWaterTransparency = 0.3,
    WorldWaterReflectance = 1,
    WorldWaterWaveSize = 0.15,
    WorldWaterWaveSpeed = 10,
    WorldCloudOverride = false,
    WorldCloudCover = 0.5,
    WorldCloudDensity = 0.5,
    WorldCloudColor = Color3.fromRGB(255, 255, 255),
    WorldColorGrading = true,
    WorldDOF = false,
    WorldFocusDistance = 30,
    WorldFocusRadius = 15,
    WorldNearIntensity = 0.25,
    WorldFarIntensity = 0.25,
    WorldBlur = false,
    WorldBlurSize = 0,
    WorldDisableGameEffects = false,

	LitAlpha = 0,
	LitDistance = 15000,
	LitVisible = true,
	LitVisibleColor = Color3.fromRGB(255, 200, 90),
	LitFade = true,
	LitOutline = false,
	ChinaHatEnabled = false,
	ChinaHatColor = Color3.fromRGB(255, 70, 190),
	ChinaHatHeight = 1.2,
	ChinaHatRadius = 1.8,
	ChinaHatOffset = 0.05,
	ChinaHatForward = 0,
	ChinaHatSide = 0,
	ChinaHatTransparency = 0.25,
	ChinaHatGlow = true,
	ChinaHatFlip = false,
	ChinaHatHideFirstPerson = true,
	RoleFlagOffset = 0,
	RoleFlagUseColor = true,
	RoleFlagColor = Color3.fromRGB(225, 225, 235),
	RoleFlagMurdererColor = Color3.fromRGB(255, 0, 0),
	RoleFlagSheriffColor = Color3.fromRGB(0, 153, 255),
	RoleFlagHeroColor = Color3.fromRGB(255, 215, 0),
	RoleFlagMurdererGradient = false,
	RoleFlagSheriffGradient = false,
	RoleFlagHeroGradient = false,
	RoleFlagMurdererGradient1 = Color3.fromRGB(255, 0, 0),
	RoleFlagMurdererGradient2 = Color3.fromRGB(255, 128, 0),
	RoleFlagSheriffGradient1 = Color3.fromRGB(0, 153, 255),
	RoleFlagSheriffGradient2 = Color3.fromRGB(0, 255, 255),
	RoleFlagHeroGradient1 = Color3.fromRGB(255, 215, 0),
	RoleFlagHeroGradient2 = Color3.fromRGB(255, 255, 100),
	RoleTracerEnabled = false,
	RoleTracerUseColor = true,
	RoleTracerColor = Color3.fromRGB(255, 255, 255),
	RoleTracerThickness = 1,
	RoleTracerOrigin = "Bottom",
	RoleTracerAlpha = 0.9,
	ArrowEnabled = false,
	ArrowRoleColor = true,
	ArrowColor = Color3.fromRGB(255, 255, 255),
	ArrowMurdererColor = Color3.fromRGB(255, 60, 60),
	ArrowInnocentColor = Color3.fromRGB(255, 255, 255),
	ArrowSheriffColor = Color3.fromRGB(0, 153, 255),
	ArrowHeroColor = Color3.fromRGB(255, 215, 0),
	ArrowSize = 42,
	ArrowDistance = 260,
	AvatarEnabled = false,
	AvatarSize = 20,
	AvatarAllowFile = false,
	HealthEnabled = false,
	HealthRoleColor = false,
	HealthColor = Color3.fromRGB(80, 235, 110),
	HealthLowColor = Color3.fromRGB(255, 65, 72),
	HealthGradient1 = Color3.fromRGB(0, 255, 120),
	HealthGradient2 = Color3.fromRGB(255, 45, 45),
	HealthPosition = "Bottom",
	HealthColorMode = "Gradient",
	HealthThickness = 4,
	HealthGap = 3,
	HealthOutline = true,
	HealthBackAlpha = 0.25,
	HealthSmooth = true,
	HealthSmoothSpeed = 10,
	HealthTrail = true,
	HealthTrailColor = Color3.fromRGB(255, 90, 90),
	HealthSegments = false,
	HealthPulse = true,
	HealthTextEnabled = true,
	HealthTextMode = "HP",
	HealthTextSize = 9,
	HealthTextFont = "Code",
	HealthTextFollow = true,
	HealthTextColorMode = "Bar",
	HealthTextColor = Color3.new(1, 1, 1),
	HealthTextHideFull = false,
	SkeletonEnabled = false,
	SkeletonColor = Color3.fromRGB(255, 255, 255),
	SkeletonRoleColor = false,
	SkeletonThickness = 1,
	SkeletonTransparency = 1,
	Fill = true,
	FillTransparency = 0.5,
	OutlineTransparency = 0,
	HighlightXRay = true,
	HighlightRoleColor = true,
	HighlightFillColor = Color3.fromRGB(255, 255, 255),
	HighlightOutlineColor = Color3.fromRGB(255, 255, 255),
	GlowFillColors = {
		Murderer = Color3.fromRGB(255, 0, 0),
		Sheriff = Color3.fromRGB(0, 153, 255),
		Hero = Color3.fromRGB(255, 215, 0),
		Innocent = Color3.fromRGB(255, 255, 255),
	},
	GlowOutlineColors = {
		Murderer = Color3.fromRGB(255, 0, 0),
		Sheriff = Color3.fromRGB(0, 153, 255),
		Hero = Color3.fromRGB(255, 215, 0),
		Innocent = Color3.fromRGB(255, 255, 255),
	},
	ChamsTransparency = 0,
	ChamsRoleColor = true,
	ChamsXRay = true,
	ChamsOutlineTransparency = 1,
	ChamsOutlineColor = Color3.fromRGB(255, 255, 255),
	ChamsColor = Color3.fromRGB(255, 255, 255),
	ChamsPreset = "ForceField",
	ChamsColors = {
		Murderer = Color3.fromRGB(255, 0, 0),
		Sheriff = Color3.fromRGB(0, 153, 255),
		Hero = Color3.fromRGB(255, 215, 0),
		Innocent = Color3.fromRGB(255, 255, 255),
	},
	Roles = {Murderer = true, Sheriff = true, Hero = true, Innocent = true},
	GunEnabled = false,
	GunText = false,
	GunTextColor = Color3.fromRGB(255, 255, 255),
	GunTextGradient = false,
	GunGradientColor1 = Color3.fromRGB(255, 255, 255),
	GunGradientColor2 = Color3.fromRGB(255, 0, 0),
	GunHighlightEnabled = false,
	GunFill = false,
	GunFillTransparency = 1,
	GunOutlineTransparency = 0,
	GunColor = Color3.fromRGB(255, 255, 255),
	TracerEnabled = false,
	TracerColor = Color3.fromRGB(0, 200, 255),
	TracerThickness = 0.5,
	TracerTransparency = 0.65,
	TracerDuration = 2,
	TracerGlow = false,
	Tracers = {},
	WeaponChams = false,
	WeaponColor = Color3.fromRGB(125, 90, 255),
	WeaponPreset = "ForceField",
	WeaponTransparency = 0,
	FOVEnabled = false,
	FOV = 70,
	Fullbright = false,
	WorldEnabled = false,
	WorldBrightness = 2,
	WorldClock = 14,
	WorldFog = true,
	WorldFogStart
	= 0,
	WorldFogEnd = 2500,
	WorldFogColor = Color3.fromRGB(190, 200, 220),
	WorldAmbient = Color3.fromRGB(120, 120, 135),
	WorldOutdoor = Color3.fromRGB(135, 135, 150),
	WorldTint = Color3.fromRGB(255, 255, 255),
	WorldSaturation = 0,
	WorldContrast = 0,
	WorldCCBrightness = 0,
	WorldShadows = true,
	WorldShadowSoftness = 0.2,
	WorldExposure = 0,
	WorldEnvDiffuse = 1,
	WorldEnvSpecular = 1,
	WorldLatitude = 41.7,
	WorldColorShiftTop = Color3.fromRGB(255, 255, 255),
	WorldColorShiftBottom = Color3.fromRGB(255, 255, 255),
	WorldBloom = false,
	WorldBloomIntensity = 0.35,
	WorldBloomSize = 22,
	WorldBloomThreshold = 0.95,
	WorldSunRays = false,
	WorldSunIntensity = 0.1,
	WorldSunSpread = 0.65,
	WorldAtmoDensity = 0.3,
	WorldAtmoOffset = 0,
	WorldAtmoHaze = 0,
	WorldAtmoGlare = 0,
	WorldAtmoColor = Color3.fromRGB(199, 199, 199),
	WorldAtmoDecay = Color3.fromRGB(92, 60, 13),
	RemoveAtmosphere = false,
	DeadBodiesEnabled = false,
	ShowDead = false,
	DeadBodyRoleColor = false,
	DeadBodyColor = Color3.fromRGB(180, 60, 70),
	DeadBodyFillColor = Color3.fromRGB(180, 60, 70),
	DeadBodyOutlineColor = Color3.fromRGB(255, 255, 255),
	DeadBodyFill = true,
	DeadBodyFillTransparency = 0.70,
	DeadBodyOutlineTransparency = 0.35,
	DeadBodyXRay = true,
	CorpseHighlights = {},
	SilentAim = false,
	AimPrediction = true,
	PredictionScale = 1,
	AutoShoot = false,
	AutoShootDelay = 0.12,
	AutoShootTeleportDistance = 300,
	WallShoot = false,
    ForceShoot = false,
    HitChance = 50,
    HitChanceSpread = 0,
	AutoGrabGun = false,
    GunGrabTeleport = true,

	MurderKillAura = false,
	MurderAuraRange = 18,
	MurderAuraDelay = 0.08,
	MurderAutoKillAll = false,
	MurderAutoEquip = true,
	MurderKnifeSilent = false,
	MurderKnifePrediction = 0.10,
    MurderKnifePing = true,
    MurderKnifeMaxLead = 0.65,
	MurderTarget = "Closest",
	MurderSilentWallCheck = true,
	MurderSilentFov = false,
	MurderSilentFovRadius = 350,
	MurderSilentRange = 1000000,
	MurderSilentPart = "Root",
    MurderMultipoint = true,
	AimPart = "Auto",
	AimMultipoint = true,
	AimWallCheck = true,
	AimBypass = true,
	AimRange = 1000000,
	AimPredictMode = "Smart",
	AimInterp = 0,
	AimPing = true,
	AimPingScale = 1,
	AimMaxLead = 0.45,
	AimJerkAdapt = true,
	AimCalibrate = true,
	AimSelfComp = 0.015,
	AimStrafeDamp = true,
	AimGravity = true,
	AimFov = false,
	AimFovRadius = 300,
	AimFovCircle = true,
	AimMarker = false,
	AimNamecall = true,
	AimGeometry = true,
	AimSmoothing = 0,
	AimSnap = true,
	AimOriginRotate = false,
	AutoShootMinConf = 0,
	AutoShootPatient = true,
	AutoShootMaxWait = 0.6,
	AutoShootTolerance = 1,
	AimAdaptive = false,
	AimTeleport = false,
	AimTeleportDelay = 0.07,
	AimTeleportRange = 250,
	AimOriginRadius = 10,
	AimAlwaysSpoof = false,
}

env.Waraku = V

local ESPGui = Instance.new("ScreenGui")
ESPGui.Name = "WarakuESP"
ESPGui.ResetOnSpawn = false
ESPGui.IgnoreGuiInset = true
ESPGui.DisplayOrder = 20
ESPGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
local guiParent
pcall(function()
	guiParent = gethui()
end)
ESPGui.Parent = guiParent or game:GetService("CoreGui")
V.ESPGui = ESPGui

local Overlay = Instance.new("Frame")
Overlay.Name = "ESP_OVERLAY"
Overlay.BackgroundTransparency = 1
Overlay.BorderSizePixel = 0
Overlay.Size = UDim2.fromScale(1, 1)
Overlay.Position = UDim2.fromOffset(0, 0)
Overlay.ZIndex = 1
Overlay.Parent = ESPGui

local GUI_FONTS = {
	UI = Enum.Font.Gotham,
	System = Enum.Font.SourceSans,
	Plex = Enum.Font.GothamMedium,
	Monospace = Enum.Font.Code,
}

local function isMobile()
	return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

local function pixelThickness(value)
	local t = math.clamp(math.floor((value or 1) + 0.5), 1, 2)
	if isMobile() then
		t = 1
	end
	return t
end

function V.acquireMotion(owner)
    if V.MotionOwner or V.Destroying or V.Destroyed then return nil end
    local token={owner=owner,character=LocalPlayer.Character}
    V.MotionOwner=token
    return token
end

function V.releaseMotion(token)
    if V.MotionOwner==token then V.MotionOwner=nil end
end

local VisualCache={characters=setmetatable({}, {__mode="k"}),gradients=setmetatable({}, {__mode="k"}),
    alphas=setmetatable({}, {__mode="k"}),edges={{1,2},{1,3},{1,5},{2,4},{2,6},{3,4},{3,7},{4,8},{5,6},{5,7},{6,8},{7,8}},
    worldCorners={},cameraCorners={},revision=0}

function VisualCache.invalidate()
    VisualCache.revision=VisualCache.revision+1
end

                                                                                
function VisualCache.shouldUpdate(record,now,distance,force,camera)
    record.renderAt,record.renderRevision,record.renderCamera=now,VisualCache.revision,camera
    return true
end

                                                                             
function VisualCache.inView(root,camera)
    if not root or not camera then return false end
    local point=camera:WorldToViewportPoint(root.Position)
    local radius=math.max(6,root.Size and root.Size.Magnitude*1.5 or 6)
    if point.Z<=-radius then return false end
    if point.Z<=radius then return true end
    local view=camera.ViewportSize
    local focal=math.max(view.X,view.Y)/(2*math.tan(math.rad(camera.FieldOfView or 70)/2))
    local margin=radius*focal/point.Z+12
    return point.X>=-margin and point.X<=view.X+margin and point.Y>=-margin and point.Y<=view.Y+margin
end

function VisualCache.set(object,key,value)
    if object[key]~=value then object[key]=value end
end

function VisualCache.gradient(object,a,b)
    local saved=VisualCache.gradients[object]
    if not saved or saved[1]~=a or saved[2]~=b then
        object.Color=ColorSequence.new(a,b)
        VisualCache.gradients[object]={a,b}
    end
end

function VisualCache.alpha(object,value)
    if VisualCache.alphas[object]~=value then
        object.Transparency=NumberSequence.new(value)
        VisualCache.alphas[object]=value
    end
end

function VisualCache.measure(entry,text,size,font)
    local saved=entry.NameMeasure
    if not saved or saved.text~=text or saved.size~=size or saved.font~=font then
        VisualCache.textService=VisualCache.textService or game:GetService("TextService")
        saved={text=text,size=size,font=font,value=VisualCache.textService:GetTextSize(text,size,font,Vector2.new(1000,100))}
        entry.NameMeasure=saved
    end
    return saved.value
end

function VisualCache.drop(character)
    local record=VisualCache.characters[character]
    if not record then return end
    for _,connection in ipairs(record.connections) do connection:Disconnect() end
    VisualCache.characters[character]=nil
end

function VisualCache.parts(character,accessories)
    local record=VisualCache.characters[character]
    if not record then
        record={dirty=true,body={},all={},geometry=setmetatable({}, {__mode="k"}),connections={}}
        VisualCache.characters[character]=record
        local function invalidate(object)
            if object:IsA("BasePart") or object:IsA("Tool") or object:IsA("Accessory") then record.dirty=true end
        end
        record.connections[1]=character.DescendantAdded:Connect(invalidate)
        record.connections[2]=character.DescendantRemoving:Connect(invalidate)
        record.connections[3]=character.Destroying:Connect(function() VisualCache.drop(character) end)
        record.connections[4]=character.ChildAdded:Connect(invalidate)
        record.connections[5]=character.ChildRemoved:Connect(invalidate)
    end
    if record.dirty then
        table.clear(record.body); table.clear(record.all)
        for _,part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                record.all[#record.all+1]=part
                if part.Parent==character then record.body[#record.body+1]=part end
            end
        end
        record.dirty=false
    end
    return accessories and record.all or record.body,record.geometry
end

function VisualCache.corners(geometry,part)
    local cached=geometry[part]
    local size=part.Size
    if not cached or cached.size~=size then
        cached={size=size}
        local half,index=size*0.5,0
        for x=-1,1,2 do for y=-1,1,2 do for z=-1,1,2 do
            index=index+1; cached[index]=Vector3.new(half.X*x,half.Y*y,half.Z*z)
        end end end
        geometry[part]=cached
    end
    return cached
end

function VisualCache.destroy()
    for character in pairs(VisualCache.characters) do VisualCache.drop(character) end
    table.clear(VisualCache.gradients); table.clear(VisualCache.alphas)
end

local function viewPoint(worldPos)
	Camera = Workspace.CurrentCamera or Camera
	local v, visible = Camera:WorldToViewportPoint(worldPos)
	local vs = Camera.ViewportSize
	local abs = Overlay.AbsoluteSize
	local x, y = v.X, v.Y
	if abs.X > 0 and vs.X > 0 then
		x = x * (abs.X / vs.X)
		y = y * (abs.Y / vs.Y)
	end
	return Vector2.new(x, y), visible, v.Z
end

local function scaledTextSize(size)
	local n = math.clamp(math.floor((size or 12) + 0.5), 10, 18)
	if isMobile() then
		n = math.min(n, 12)
	end
	return n
end

local ROLE = {
	Murderer = Color3.fromRGB(255, 65, 72),
	Sheriff = Color3.fromRGB(65, 145, 255),
	Hero = Color3.fromRGB(255, 215, 0),
	Innocent = Color3.fromRGB(255, 255, 255),
}

local applyingWeapon = false
local applyingChams = false

local function con(sig, fn, b)
	local c = sig:Connect(fn)
	table.insert(b or V.Connections, c)
	return c
end

local function clearCons(t)
	if not t then
		return
	end
	for _, c in ipairs(t) do
		pcall(function()
			c:Disconnect()
		end)
	end
	table.clear(t)
end

local function disconnectMap(map)
	for inst, list in pairs(map) do
		clearCons(list)
		map[inst] = nil
	end
end

local function destroyGui(d)
	if d then
		pcall(function()
			d:Destroy()
		end)
	end
end

local roundOver = false

local function hasAssignedRoles(pd)
	if not pd or next(pd) == nil then
		return false
	end
	for _, data in pairs(pd) do
		if type(data) == "table" and type(data.Role) == "string" and data.Role ~= "" then
			return true
		end
	end
	return false
end

local function getRoundMap()
	for _, child in ipairs(Workspace:GetChildren()) do
		if child:IsA("Model") and child.Name ~= "RegularLobby" and child.Name ~= "Lobby" and (child:FindFirstChild("CoinContainer") or child:FindFirstChild("Spawns") or child:FindFirstChild("CoinArea")) then
			return child
		end
	end
	return nil
end

local function isInLobby(p)
	local ch = p and p.Character
	local root = ch and (ch:FindFirstChild("HumanoidRootPart") or ch:FindFirstChild("UpperTorso") or ch:FindFirstChild("Torso"))
	if not root then return false end
	return root.Position.Y > 350 and math.abs(root.Position.X) < 500 and math.abs(root.Position.Z) < 500
end

local roundStateCache = { t = -1, v = false }

local function isRoundActive()
	if roundOver then
		return false
	end

	local now = os.clock()
	if now - roundStateCache.t < 0.2 then
		return roundStateCache.v
	end
	roundStateCache.t = now

	local active = false
	if getRoundMap() then
		active = true
	else
		local pd = Round and Round.PlayerData
		if hasAssignedRoles(pd) then
			for _, pl in ipairs(Players:GetPlayers()) do
				local data = pd[pl.Name]
				if type(data) == "table" and type(data.Role) == "string" and data.Role ~= ""
					and data.Dead ~= true and pl.Character and not isInLobby(pl)
				then
					active = true
					break
				end
			end
		end
	end

	roundStateCache.v = active
	return active
end

local function playerData(p)
	if not p then return nil end
	local pd = Round and Round.PlayerData
	local d = type(pd) == "table" and (pd[p.Name] or pd[p.UserId] or pd[tostring(p.UserId)])
	return type(d) == "table" and d or nil
end

local function hasRoundGun(p)
	local function find(root)
		if not root then return false end
		for _, o in ipairs(root:GetChildren()) do
			if o:IsA("Tool") then
				local lname = string.lower(o.Name)
				if lname == "gun" or lname == "revolver" or string.find(lname, "gun", 1, true) or string.find(lname, "revolver", 1, true) then
					return true
				end
			end
		end
		return false
	end
	return (p and p.Character and find(p.Character)) or (p and find(p:FindFirstChildOfClass("Backpack"))) or false
end

local function roleContextValid(p)
	return p ~= nil and isRoundActive() and not isInLobby(p)
end

-- PlayerData is the sole source of roles; equipment does not override it.
local function effectiveRole(p, d)
	d = d or playerData(p)
	return d and type(d.Role) == "string" and d.Role ~= "" and d.Role or "Innocent"
end

local function visualRoleName(p, d)
	local role = effectiveRole(p, d)
	return role or "Innocent"
end

local function visualRoleColor(p, d)
	return ROLE[visualRoleName(p, d)] or ROLE.Innocent
end

local function aliveRoot(p)
	local ch = p and p.Character
	local hum = ch and ch:FindFirstChildOfClass("Humanoid")
	local root = ch and (ch:FindFirstChild("HumanoidRootPart") or ch:FindFirstChild("UpperTorso") or ch:FindFirstChild("Torso"))
	if not hum or hum.Health <= 0 or not root then
		return nil
	end
	return root, hum, ch
end

local function roleOf(p)
	local d = p and playerData(p)
	return p and effectiveRole(p, d) or "Innocent", d
end

local function findMurderer()
	if not isRoundActive() then
		return nil
	end
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			local role, d = roleOf(p)
			if role == "Murderer" and (not d or d.Dead ~= true) and aliveRoot(p) then
				return p
			end
		end
	end
end

local function isLocalMurderer()
	if V.Destroying or V.Destroyed or not aliveRoot(LocalPlayer) then return false end
	local d = playerData(LocalPlayer)
	return d ~= nil and d.Dead ~= true and d.Role == "Murderer"
end

local function allowed(p, d)
	if not V.Enabled then
		return false
	end
	if not p or p == LocalPlayer then
		return false
	end
	local ch = p.Character
	if not ch or not ch.Parent then
		return false
	end
	local hum = ch:FindFirstChildOfClass("Humanoid")
	if not hum or hum.Health <= 0 then
		return false
	end

	local root = ch:FindFirstChild("HumanoidRootPart") or ch:FindFirstChild("UpperTorso") or ch:FindFirstChild("Torso")
	if not root then
		return false
	end

	Camera = Workspace.CurrentCamera or Camera
	if Camera then
		local studs = (root.Position - Camera.CFrame.Position).Magnitude
		if studs > V.MaxDistance then
			return false
		end
	end

	local inRound = isRoundActive()
	local inLobby = isInLobby(p)

	if V.RoundOnly then
		if not inRound or inLobby then
			return false
		end
		if d and d.Dead == true and not V.ShowDead then
			return false
		end
	else
		if inRound and not inLobby and d and d.Dead == true and not V.ShowDead then
			return false
		end
	end

	local role = effectiveRole(p, d)
	if role and V.Roles and V.Roles[role] == false then
		return false
	end
	return true
end

local function newLabel()
	local t = Instance.new("TextLabel")
	t.BackgroundTransparency = 1
	t.BorderSizePixel = 0
	t.AnchorPoint = Vector2.new(0.5, 0.5)
	t.AutomaticSize = Enum.AutomaticSize.XY
	t.TextScaled = false
	t.RichText = false
	t.Font = Enum.Font.Code
	t.TextSize = 10
	t.TextColor3 = Color3.new(1, 1, 1)
	t.TextXAlignment = Enum.TextXAlignment.Center
	t.TextYAlignment = Enum.TextYAlignment.Center
	t.TextStrokeTransparency = 1
	t.ZIndex = 5
	t.Visible = false
	t.Parent = Overlay
	local stroke = Instance.new("UIStroke")
	stroke.Name = "Stroke"
	stroke.Thickness = 1
	stroke.Color = Color3.new(0, 0, 0)
	stroke.Transparency = 0.35
	stroke.Parent = t
	local gradient = Instance.new("UIGradient")
	gradient.Name = "Gradient"
	gradient.Rotation = 0
	gradient.Enabled = false
	gradient.Parent = t
	return t
end

local function styleLabel(label, color, gradientEnabled, gradientColor1, gradientColor2)
	local gradient = label and label:FindFirstChild("Gradient")
	if gradient then
		gradient.Enabled = gradientEnabled == true
		if gradientEnabled then
			VisualCache.gradient(gradient,gradientColor1 or color,gradientColor2 or color)
			label.TextColor3 = Color3.new(1, 1, 1)
		else
			label.TextColor3 = color
		end
	elseif label then
		label.TextColor3 = color
	end
end

local function newAvatar()
	local image = Instance.new("ImageLabel")
	image.Name = "Avatar"
	image.BackgroundTransparency = 1
	image.BorderSizePixel = 0
	image.AnchorPoint = Vector2.new(0, 0.5)
	image.ScaleType = Enum.ScaleType.Crop
	image.ZIndex = 5
	image.Visible = false
	image.Parent = Overlay
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(1, 0)
	corner.Parent = image
	return image
end

local function newSkelLine()
	local f = Instance.new("Frame")
	f.AnchorPoint = Vector2.new(0.5, 0.5)
	f.BorderSizePixel = 0
	f.BackgroundColor3 = Color3.new(1, 1, 1)
	f.Visible = false
	f.ZIndex = 3
	f.Parent = Overlay
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(1, 0)
	corner.Parent = f
	return f
end

local function hideSkeleton(e)
	if not e then
		return
	end

	local lines, ls = e.Skeleton, e.SkelLS
	if lines and ls then
		for i = 1, #lines do
			local s = ls[i]
			if s and s.vis then
				s.vis = false
				lines[i].Visible = false
			end
		end
	end

	local joints, js = e.SkeletonJoints, e.SkelJS
	if joints and js then
		for i = 1, #joints do
			local s = js[i]
			if s and s.vis then
				s.vis = false
				joints[i].Visible = false
			end
		end
	end

	local circle = e.SkeletonCircle
	if circle then
		local hs = e.SkelHS
		if not hs or hs.vis then
			if hs then
				hs.vis = false
			end
			circle.Visible = false
		end
	end
end

local function setHidden(entry, keepSkeleton)
	if not entry then
		return
	end
	if entry.Root then
		entry.Root.Visible = false
	end
	if entry.BoxMain then
		entry.BoxMain.Visible = false
	end
	if entry.BoxOuter then
		entry.BoxOuter.Visible = false
	end
	if entry.BoxInner then
		entry.BoxInner.Visible = false
	end
	for _, bar in ipairs(entry.CornerBars or {}) do
		bar.Visible = false
	end
	for _, ob in ipairs(entry.CornerOutlines or {}) do
		ob.Visible = false
	end

	if not keepSkeleton then
		hideSkeleton(entry)
	end
	if entry.Name then
		entry.Name.Visible = false
	end
	if entry.Distance then
		entry.Distance.Visible = false
	end
	if entry.RoleFlag then
		entry.RoleFlag.Visible = false
	end
	if entry.RoleTracer then
		entry.RoleTracer.Visible = false
	end
	if entry.Arrow then
		entry.Arrow.Visible = false
	end
	if entry.Avatar then
		entry.Avatar.Visible = false
	end
	if entry.AvatarDraw then
		entry.AvatarDraw.Visible = false
	end
	if hideHealth then
		hideHealth(entry)
	end
	if entry.HealthTrail then
		entry.HealthTrail.Visible = false
	end
	if entry.HealthText then
		entry.HealthText.Visible = false
	end
	for _, tick in ipairs(entry.HealthTicks or {}) do
		tick.Visible = false
	end
end

local function setHiddenIdle(entry,keepArrow)
	if not entry then return end
    if not keepArrow then entry.renderAt=nil end
	local arrowVisible=keepArrow and entry.Arrow and entry.Arrow.Visible
	if not entry.IdleHidden then
		entry.IdleHidden=true
		setHidden(entry)
	elseif not keepArrow and entry.Arrow and entry.Arrow.Visible then
		entry.Arrow.Visible=false
	end
	if arrowVisible and not entry.Arrow.Visible then entry.Arrow.Visible=true end
end

local function removeSkelLine(line)
	if not line then return end
	if typeof(line) == "Instance" then
		destroyGui(line)
	elseif type(line) == "table" or typeof(line) == "Drawing" or (type(line) == "userdata" and line.Remove) then
		pcall(function() line:Remove() end)
	end
end

local function destroyPlayerVisual(p)
	local e = V.DrawByPlayer and V.DrawByPlayer[p]
	if not e then
		return
	end
	destroyGui(e.Root)
	destroyGui(e.Name)
	destroyGui(e.Distance)
	destroyGui(e.RoleFlag)
	destroyGui(e.RoleTracer)
	destroyGui(e.Arrow)
	destroyGui(e.Avatar)
	destroyGui(e.HealthTrail)
	destroyGui(e.HealthText)
	for _, tick in ipairs(e.HealthTicks or {}) do
		destroyGui(tick)
	end
	if e.AvatarDraw then
		pcall(function() e.AvatarDraw:Remove() end)
		e.AvatarDraw = nil
		e.AvatarDrawBytes = nil
	end

	for _, line in ipairs(e.Skeleton or {}) do
		removeSkelLine(line)
	end
	e.Skeleton = nil

	if e.SkeletonCircle then
		removeSkelLine(e.SkeletonCircle)
		e.SkeletonCircle = nil
	end

	for _, joint in ipairs(e.SkeletonJoints or {}) do
		removeSkelLine(joint)
	end
	e.SkeletonJoints = nil

	V.DrawByPlayer[p] = nil
end

local function clearVisual(p)
	local h = V.Highlights[p]
	if h then
		h:Destroy()
		V.Highlights[p] = nil
	end
	setHidden(V.DrawByPlayer and V.DrawByPlayer[p])
end

local function ensureHighlight(p,d)
    local character=p and p.Character
    local full=V.ChamsStyle == "Highlight"
    local enabled=V.HighlightEnabled and (full or V.ChamsOutline)
    local h=V.Highlights[p]
    local root=character and (character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Head"))
    if enabled and not VisualCache.inView(root,Workspace.CurrentCamera) then
        if h then VisualCache.set(h,"Enabled",false) end
        return nil
    end
    if not enabled or not character then
        if h then h:Destroy(); V.Highlights[p]=nil end
        return nil
    end
    if not h or not h.Parent then
        h=Instance.new("Highlight")
        VisualCache.set(h,"Name","Waraku_VISUAL_HIGHLIGHT")
        VisualCache.set(h,"Parent",ESPGui)
        V.Highlights[p]=h
    end
    local roleName=visualRoleName(p,d)
    local roleColor=visualRoleColor(p,d)
    VisualCache.set(h,"Adornee",character)
    VisualCache.set(h,"FillColor",V.HighlightRoleColor and (V.GlowFillColors[roleName] or roleColor) or V.HighlightFillColor)
    VisualCache.set(h,"OutlineColor",V.ChamsOutlineColor)
    VisualCache.set(h,"FillTransparency",full and V.Fill and math.clamp(V.FillTransparency,0,1) or 1)
    VisualCache.set(h,"OutlineTransparency",V.ChamsOutline and math.clamp(V.ChamsOutlineAlpha,0,1) or 1)
    VisualCache.set(h,"DepthMode",V.HighlightXRay and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded)
    VisualCache.set(h,"Enabled",true)
    return h
end

local function boxBounds(ch)
    Camera = Workspace.CurrentCamera or Camera
    if not Camera then return end
    local root = ch:FindFirstChild("HumanoidRootPart") or ch:FindFirstChild("UpperTorso") or ch:FindFirstChild("Torso")
    local hum = ch:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end
    if V.AdaptiveESP then
        local cameraFrame = Camera.CFrame
        local minX,minY,maxX,maxY = math.huge,math.huge,-math.huge,-math.huge
        local corners,worldCorners=VisualCache.cameraCorners,VisualCache.worldCorners
        local size,viewport=Overlay.AbsoluteSize,Camera.ViewportSize
        local scaleX,scaleY=1,1
        if size.X>0 and viewport.X>0 then scaleX=size.X/viewport.X; scaleY=size.Y/viewport.Y end
        if size.X<=0 or size.Y<=0 then size=viewport end
        local function include(screen)
            local x,y=screen.X*scaleX,screen.Y*scaleY
            minX,minY=math.min(minX,x),math.min(minY,y)
            maxX,maxY=math.max(maxX,x),math.max(maxY,y)
        end
        local function project(point)
            local screen=Camera:WorldToViewportPoint(cameraFrame:PointToWorldSpace(point))
            include(screen)
        end
        local parts,geometry=VisualCache.parts(ch,V.ESPAccessories)
        for _,part in ipairs(parts) do
            if part.Parent and (V.ESPAccessories or part.Parent==ch) and part~=root
                and not part:FindFirstAncestorOfClass("Tool") and part.Transparency<0.99 and string.sub(part.Name,1,7)~="Waraku_" then
                local localCorners=VisualCache.corners(geometry,part)
                local frame,front=part.CFrame,0
                for index=1,8 do
                    local world=frame:PointToWorldSpace(localCorners[index])
                    worldCorners[index]=world
                    local screen=Camera:WorldToViewportPoint(world)
                    if screen.Z>=0.15 then include(screen); front=front+1 end
                end
                if front>0 and front<8 then
                    for index=1,8 do corners[index]=cameraFrame:PointToObjectSpace(worldCorners[index]) end
                    for _,edge in ipairs(VisualCache.edges) do
                        local a,b=corners[edge[1]],corners[edge[2]]
                        if (a.Z < -0.15) ~= (b.Z < -0.15) then
                            project(a+(b-a)*((-0.15-a.Z)/(b.Z-a.Z)))
                        end
                    end
                end
            end
        end
        if minX == math.huge or maxX<0 or maxY<0 or minX>size.X or minY>size.Y then return end
        local padding=math.clamp(tonumber(V.ESPPadding) or 2,0,16)
        minX,minY=math.max(-size.X,minX-padding),math.max(-size.Y,minY-padding)
        maxX,maxY=math.min(size.X*2,maxX+padding),math.min(size.Y*2,maxY+padding)
        if maxX-minX < 1 or maxY-minY < 1 then return end
        return Vector2.new(minX,minY),Vector2.new(maxX,maxY),Vector2.new((minX+maxX)*0.5,(minY+maxY)*0.5)
    end
    local center,onScreen,depth=viewPoint(root.Position)
    if not center or not depth or depth<=0 or not onScreen then return end
    local half=math.clamp(3.15+(hum.HipHeight or 2)*0.16,3.15,3.75)
    local top,_,topDepth=viewPoint(root.Position+Vector3.yAxis*half)
    local bottom,_,bottomDepth=viewPoint(root.Position-Vector3.yAxis*half)
    if not top or not bottom or topDepth<=0 or bottomDepth<=0 then return end
    local height=math.abs(bottom.Y-top.Y)
    local size=Overlay.AbsoluteSize
    if height<3 or height>(size.Y>0 and size.Y or Camera.ViewportSize.Y)*2 then return end
    local width=height*0.52
    return Vector2.new(center.X-width*0.5,center.Y-height*0.5),Vector2.new(center.X+width*0.5,center.Y+height*0.5),center
end

local function guiFrame(parent, z)
	local f = Instance.new("Frame")
	f.BorderSizePixel = 0
	f.BackgroundColor3 = Color3.new(1, 1, 1)
	f.ZIndex = z or 2
	f.Parent = parent
	return f
end

local XT = { specs = {} }

do
	local specs = XT.specs

	local function reg(flag, key, kind, a, b)
		specs[flag] = { key = key, kind = kind, a = a, b = b }
	end

	local FONTS = { "Code", "RobotoMono", "Gotham", "GothamMedium", "GothamBold", "SourceSans", "SourceSansBold", "Ubuntu", "Roboto", "Arial" }

	local function opacityToTransparency(v)
		return 1 - v / 100
	end
	local function transparencyToOpacity(v)
		return math.floor((1 - v) * 100 + 0.5)
	end

	reg("V.HealthPos", "HealthPosition", "opt", { "Bottom", "Top", "Left", "Right" })
	reg("V.HealthMode", "HealthColorMode", "opt", { "Gradient", "Health", "Custom", "Role" })
	reg("V.HealthThick", "HealthThickness", "num")
	reg("V.HealthGap", "HealthGap", "num")
	reg("V.HealthOutline", "HealthOutline", "bool")
	reg("V.HealthBackA", "HealthBackAlpha", "num", opacityToTransparency, transparencyToOpacity)
	reg("V.HealthSmooth", "HealthSmooth", "bool")
	reg("V.HealthSmoothSpd", "HealthSmoothSpeed", "num")
	reg("V.HealthTrail", "HealthTrail", "bool")
	reg("V.HealthTrailColor", "HealthTrailColor", "color")
	reg("V.HealthSegs", "HealthSegments", "bool")
	reg("V.HealthPulse", "HealthPulse", "bool")
	reg("V.HealthFull", "HealthColor", "color")
	reg("V.HealthLow", "HealthLowColor", "color")
	reg("V.HealthTextOn", "HealthTextEnabled", "bool")
	reg("V.HealthTextMode", "HealthTextMode", "opt", { "HP", "Percent", "HP/Max" })
	reg("V.HealthTextSize", "HealthTextSize", "num")
	reg("V.HealthTextFollow", "HealthTextFollow", "bool")
	reg("V.HealthTextCol", "HealthTextColorMode", "opt", { "Bar", "White", "Custom" })
	reg("V.HealthTextColor", "HealthTextColor", "color")
	reg("V.HealthTextHideFull", "HealthTextHideFull", "bool")

	reg("V.AvatarSize", "AvatarSize", "num")
	reg("V.AvatarFile", "AvatarAllowFile", "bool")

	local function pct(v)
		return v / 100
	end
	local function unpct(v)
		return math.floor(v * 100 + 0.5)
	end

	reg("V.NameSize", "NameSize", "num")
	reg("V.NameFont", "NameFont", "opt", FONTS)
	reg("V.NameOutline", "NameOutline", "bool")
	reg("V.NameOutlineThick", "NameOutlineThickness", "num")
	reg("V.NameRole", "NameRoleColor", "bool")
    reg("V.NameGradient","NameGradient","bool")
    reg("V.NameGradientColor2","NameGradientColor2","color")
    reg("V.NameGradientRotation","NameGradientRotation","num")
	reg("V.NameOffset", "NameOffset", "num")
	reg("V.DistFormat", "DistanceFormat", "opt", { "Brackets", "Meters", "Studs", "Plain" })

    reg("V.AdaptiveESP", "AdaptiveESP", "bool")
    reg("V.ESPAccessories", "ESPAccessories", "bool")
    reg("V.ESPPadding", "ESPPadding", "num")
    reg("V.ChamsOutline", "ChamsOutline", "bool")
    reg("V.LocalChams.Outline", "LocalChamsOutline", "bool")
    reg("V.Chams.GlowColor", "ChamsGlowColor", "color")
    reg("V.Chams.GlowStrength", "ChamsGlowStrength", "num")
    reg("V.Chams.GlowWidth", "ChamsGlowWidth", "num")
    reg("V.Chams.GlowPulse", "ChamsGlowPulse", "bool")
    reg("V.Chams.OutlineColor", "ChamsOutlineColor", "color")
    reg("V.Chams.OutlineAlpha", "ChamsOutlineAlpha", "num", pct, unpct)
    reg("V.LocalChams.GlowColor", "LocalChamsGlowColor", "color")
    reg("V.LocalChams.GlowStrength", "LocalChamsGlowStrength", "num")
    reg("V.LocalChams.GlowWidth", "LocalChamsGlowWidth", "num")
    reg("V.LocalChams.GlowPulse", "LocalChamsGlowPulse", "bool")
    reg("V.LocalChams.OutlineColor", "LocalChamsOutlineColor", "color")
    reg("V.LocalChams.OutlineAlpha", "LocalChamsOutlineAlpha", "num", pct, unpct)
    reg("V.Chams.Color", "ChamsColor", "color")
    reg("V.Chams.RoleColor", "ChamsRoleColor", "bool")
    reg("V.ChamsAmbient", "ChamsAmbient", "num")
    reg("V.ChamsLight", "ChamsLight", "num")
    reg("V.ChamsLightYaw", "ChamsLightYaw", "num")
    reg("V.ChamsLightPitch", "ChamsLightPitch", "num")
    reg("V.ChamsCameraLight", "ChamsCameraLight", "bool")
    reg("world.dayCycle", "WorldDayCycle", "bool")
    reg("world.daySpeed", "WorldDaySpeed", "num")
    reg("world.gravityOverride", "WorldGravityOverride", "bool")
    reg("world.gravity", "WorldGravity", "num")
    reg("world.lightsOverride", "WorldLightsOverride", "bool")
    reg("world.lightBrightness", "WorldLightBrightness", "num")
    reg("world.lightRange", "WorldLightRange", "num")
    reg("world.lightColor", "WorldLightColor", "color")
    reg("world.lightTint", "WorldLightTint", "num")
    reg("world.lightShadows", "WorldLightShadows", "bool")
    reg("world.skyPitch", "WorldSkyPitch", "num")
    reg("world.skyYaw", "WorldSkyYaw", "num")
    reg("world.skyRoll", "WorldSkyRoll", "num")
	reg("V.BoxThick", "BoxThickness", "num")
	reg("V.BoxCorner", "BoxCornerLength", "num")
	reg("V.BoxOutlineColor", "BoxOutlineColor", "color")

	reg("V.RoleFlag", "RoleFlagEnabled", "bool")
	reg("V.RoleFlagUse", "RoleFlagUseColor", "bool")
	reg("V.RoleFlagColor", "RoleFlagColor", "color")
	reg("V.RoleFlagMurd", "RoleFlagMurdererColor", "color")
	reg("V.RoleFlagSher", "RoleFlagSheriffColor", "color")
	reg("V.RoleFlagHero", "RoleFlagHeroColor", "color")
	reg("V.RoleFlagSize", "RoleFlagSize", "num")
	reg("V.RoleFlagOffset", "RoleFlagOffset", "num")

	reg("V.RoleTracer", "RoleTracerEnabled", "bool")
	reg("V.RoleTracerRole", "RoleTracerUseColor", "bool")
	reg("V.RoleTracerColor", "RoleTracerColor", "color")
	reg("V.RoleTracerThick", "RoleTracerThickness", "num")
	reg("V.RoleTracerOrigin", "RoleTracerOrigin", "opt", { "Bottom", "Center", "Top" })
	reg("V.RoleTracerAlpha", "RoleTracerAlpha", "num", pct, unpct)

	reg("V.Arrow", "ArrowEnabled", "bool")
	reg("V.ArrowRole", "ArrowRoleColor", "bool")
	reg("V.ArrowColor", "ArrowColor", "color")
	reg("V.ArrowSize", "ArrowSize", "num")
	reg("V.ArrowDist", "ArrowDistance", "num")
	reg("V.ArrowMurd", "ArrowMurdererColor", "color")
	reg("V.ArrowSher", "ArrowSheriffColor", "color")
	reg("V.ArrowInno", "ArrowInnocentColor", "color")
	reg("V.RoleFlagFont", "RoleFlagFont", "opt", FONTS)
	reg("V.HealthTextFont", "HealthTextFont", "opt", FONTS)
	reg("V.TextScale", "TextScale", "num", pct, unpct)
    reg("V.ShowRole.Murderer", "ShowRoleMurderer", "bool")
    reg("V.ShowRole.Sheriff", "ShowRoleSheriff", "bool")
    reg("V.ShowRole.Hero", "ShowRoleHero", "bool")
    reg("V.ShowRole.Innocent", "ShowRoleInnocent", "bool")
	reg("V.RoleCustom", "CustomRoleColors", "bool")
	reg("V.RoleColMurd", "RoleColorMurderer", "color")
	reg("V.RoleColSher", "RoleColorSheriff", "color")
	reg("V.RoleColHero", "RoleColorHero", "color")
	reg("V.RoleColInno", "RoleColorInnocent", "color")
	reg("V.ChamsStyle", "ChamsStyle", "opt", { "Flat", "Glass", "Neon", "ForceField", "Glow", "Highlight" })

    reg("V.LocalChams", "LocalChamsEnabled", "bool")
    reg("V.LocalChams.Style", "LocalChamsStyle", "opt", { "Flat", "Glass", "Neon", "ForceField", "Glow", "Highlight" })
    reg("V.LocalChams.Color", "LocalChamsColor", "color")
    reg("V.LocalChams.RoleColor", "LocalChamsRoleColor", "bool")
    reg("V.LocalChams.Alpha", "LocalChamsTransparency", "num", pct, unpct)
    reg("V.LocalChams.Accessories", "LocalChamsAccessories", "bool")
    reg("world.skyOverride", "WorldSkyOverride", "bool")
    reg("world.stars", "WorldStars", "num")
    reg("world.sunSize", "WorldSunSize", "num")
    reg("world.moonSize", "WorldMoonSize", "num")
    reg("world.celestialBodies", "WorldCelestialBodies", "bool")
    reg("world.waterOverride", "WorldWaterOverride", "bool")
    reg("world.waterColor", "WorldWaterColor", "color")
    reg("world.waterTransparency", "WorldWaterTransparency", "num")
    reg("world.waterReflectance", "WorldWaterReflectance", "num")
    reg("world.waterWaveSize", "WorldWaterWaveSize", "num")
    reg("world.waterWaveSpeed", "WorldWaterWaveSpeed", "num")
    reg("world.cloudOverride", "WorldCloudOverride", "bool")
    reg("world.cloudCover", "WorldCloudCover", "num")
    reg("world.cloudDensity", "WorldCloudDensity", "num")
    reg("world.cloudColor", "WorldCloudColor", "color")
    reg("world.enabled", "WorldEnabled", "bool")
    reg("world.fullbright", "Fullbright", "bool")
    reg("world.brightness", "WorldBrightness", "num")
    reg("world.clock", "WorldClock", "num")
    reg("world.ambient", "WorldAmbient", "color")
    reg("world.outdoorAmbient", "WorldOutdoor", "color")
    reg("world.shadows", "WorldShadows", "bool")
    reg("world.shadowSoftness", "WorldShadowSoftness", "num")
    reg("world.diffuse", "WorldEnvDiffuse", "num")
    reg("world.specular", "WorldEnvSpecular", "num")
    reg("world.latitude", "WorldLatitude", "num")
    reg("world.colorShiftTop", "WorldColorShiftTop", "color")
    reg("world.colorShiftBottom", "WorldColorShiftBottom", "color")
    reg("world.fog", "WorldFog", "bool")
    reg("world.fogStart", "WorldFogStart", "num")
    reg("world.fogEnd", "WorldFogEnd", "num")
    reg("world.fogColor", "WorldFogColor", "color")
    reg("world.removeAtmosphere", "RemoveAtmosphere", "bool")
    reg("world.atmoDensity", "WorldAtmoDensity", "num")
    reg("world.atmoOffset", "WorldAtmoOffset", "num")
    reg("world.atmoHaze", "WorldAtmoHaze", "num")
    reg("world.atmoGlare", "WorldAtmoGlare", "num")
    reg("world.atmoColor", "WorldAtmoColor", "color")
    reg("world.atmoDecay", "WorldAtmoDecay", "color")
    reg("world.sunRays", "WorldSunRays", "bool")
    reg("world.sunIntensity", "WorldSunIntensity", "num")
    reg("world.sunSpread", "WorldSunSpread", "num")
    reg("world.disableGameEffects", "WorldDisableGameEffects", "bool")
    reg("postProcess.bloom", "WorldBloom", "bool")
    reg("postProcess.bloomIntensity", "WorldBloomIntensity", "num")
    reg("postProcess.bloomThreshold", "WorldBloomThreshold", "num")
    reg("postProcess.colorGrading", "WorldColorGrading", "bool")
    reg("postProcess.colorFilter", "WorldTint", "color")
    reg("postProcess.colorSaturation", "WorldSaturation", "num")
    reg("postProcess.colorBrightness", "WorldCCBrightness", "num")
    reg("postProcess.colorPostExposure", "WorldExposure", "num")
    reg("postProcess.colorContrast", "WorldContrast", "num")
    reg("postProcess.depthOfField", "WorldDOF", "bool")
    reg("postProcess.depthFocusDistance", "WorldFocusDistance", "num")
    reg("postProcess.bloomSize", "WorldBloomSize", "num")
    reg("postProcess.depthInFocusRadius", "WorldFocusRadius", "num")
    reg("postProcess.depthNearIntensity", "WorldNearIntensity", "num")
    reg("postProcess.depthFarIntensity", "WorldFarIntensity", "num")
    reg("postProcess.blur", "WorldBlur", "bool")
    reg("postProcess.blurSize", "WorldBlurSize", "num")

	reg("V.LitAlpha", "LitAlpha", "num", pct, unpct)
	reg("V.LitDist", "LitDistance", "num")
	reg("V.Hat", "ChinaHatEnabled", "bool")
	reg("V.HatColor", "ChinaHatColor", "color")
	reg("V.HatHeight", "ChinaHatHeight", "num")
	reg("V.HatRadius", "ChinaHatRadius", "num")
	reg("V.HatOffset", "ChinaHatOffset", "num")
	reg("V.HatAlpha", "ChinaHatTransparency", "num", opacityToTransparency, transparencyToOpacity)
	reg("V.HatFirstPerson", "ChinaHatHideFirstPerson", "bool")
	reg("V.HatForward", "ChinaHatForward", "num")
	reg("V.HatSide", "ChinaHatSide", "num")
	reg("V.HatGlow", "ChinaHatGlow", "bool")
	reg("V.HatFlip", "ChinaHatFlip", "bool")
	reg("V.BoxFillGrad", "BoxFillGradient", "bool")
	reg("V.BoxFillGradColor", "BoxFillGradientColor", "color")
	reg("V.BoxFillAngle", "BoxFillAngle", "num")
	reg("V.BoxFillAnim", "BoxFillAnim", "opt", { "Off", "Flow", "Spin", "Pulse" })
	reg("V.BoxFillSpeed", "BoxFillSpeed", "num", pct, unpct)
	reg("V.BoxGrad", "BoxGradient", "bool")
	reg("V.BoxGradColor", "BoxGradientColor", "color")
	reg("V.BoxGradAngle", "BoxGradientAngle", "num")
	reg("V.NameBg", "NameBackground", "bool")
	reg("V.NameBgColor", "NameBackgroundColor", "color")
	reg("V.NameBgAlpha", "NameBackgroundTransparency", "num", opacityToTransparency, transparencyToOpacity)

	local function ms(v)
		return v / 1000
	end
	local function unms(v)
		return math.floor(v * 1000 + 0.5)
	end
	reg("V.Weapon.Style", "WeaponPreset", "opt", { "ForceField", "Flat", "Neon", "Glass", "Metal" })
	reg("V.Weapon.Alpha", "WeaponTransparency", "num", pct, unpct)
	reg("C.SilentAim", "SilentAim", "bool")
	reg("C.AimPart", "AimPart", "opt", { "Auto", "Head", "Torso", "Root", "Closest" })
	reg("C.AimMultipoint", "AimMultipoint", "bool")
	reg("C.AimWallCheck", "AimWallCheck", "bool")
	reg("C.AimRange", "AimRange", "num")
	reg("C.Prediction", "AimPrediction", "bool")
	reg("C.AimPredictMode", "AimPredictMode", "opt", { "Smart", "Linear" })
	reg("C.PredictionScale", "PredictionScale", "num", pct, unpct)
	reg("C.AimInterp", "AimInterp", "num", ms, unms)
	reg("C.AimPing", "AimPing", "bool")
	reg("C.AimPingScale", "AimPingScale", "num", pct, unpct)
	reg("C.AimMaxLead", "AimMaxLead", "num", ms, unms)
	reg("C.AimJerkAdapt", "AimJerkAdapt", "bool")
	reg("C.AimCalibrate", "AimCalibrate", "bool")
	reg("C.AimSelfComp", "AimSelfComp", "num", ms, unms)
	reg("C.AimAdaptive", "AimAdaptive", "bool")
	reg("C.AimStrafeDamp", "AimStrafeDamp", "bool")
	reg("C.AimGravity", "AimGravity", "bool")
	reg("C.AimFov", "AimFov", "bool")
	reg("C.AimFovRadius", "AimFovRadius", "num")
	reg("C.AimFovCircle", "AimFovCircle", "bool")
	reg("C.AimMarker", "AimMarker", "bool")
	reg("C.AimNamecall", "AimNamecall", "bool")
	reg("C.AimGeometry", "AimGeometry", "bool")
	reg("C.AimSmoothing", "AimSmoothing", "num", pct, unpct)
	reg("C.AimSnap", "AimSnap", "bool")
	reg("C.AimOriginRotate", "AimOriginRotate", "bool")
	reg("C.WallShoot", "WallShoot", "bool")
    reg("C.ForceShoot", "ForceShoot", "bool")
    reg("C.HitChance", "HitChance", "num")
    reg("C.HitChanceSpread", "HitChanceSpread", "num")
	reg("C.AimOriginRadius", "AimOriginRadius", "num")
	reg("C.AimBypass", "AimBypass", "bool")
	reg("C.AimAlwaysSpoof", "AimAlwaysSpoof", "bool")
	reg("C.AimTeleport", "AimTeleport", "bool")
	reg("C.AimTeleportDelay", "AimTeleportDelay", "num", ms, unms)
	reg("C.AimTeleportRange", "AimTeleportRange", "num")
	reg("C.AutoShoot", "AutoShoot", "bool")
	reg("C.AutoShootDelay", "AutoShootDelay", "num", ms, unms)
	reg("C.AutoShootTeleportDistance", "AutoShootTeleportDistance", "num")
	reg("C.AutoShootPatient", "AutoShootPatient", "bool")
	reg("C.AutoShootMaxWait", "AutoShootMaxWait", "num", ms, unms)
	reg("C.AutoShootTolerance", "AutoShootTolerance", "num", pct, unpct)
	reg("C.AutoShootMinConf", "AutoShootMinConf", "num", pct, unpct)
	reg("C.AutoGrabGun", "AutoGrabGun", "bool")
    reg("C.GunGrabTeleport", "GunGrabTeleport", "bool")
    reg("M.AutoKillAll", "MurderAutoKillAll", "bool")
    reg("M.KillAura", "MurderKillAura", "bool")
    reg("M.AuraRange", "MurderAuraRange", "num")
    reg("M.AuraDelay", "MurderAuraDelay", "num", ms, unms)
    reg("M.KnifeSilent", "MurderKnifeSilent", "bool")
    reg("M.Target", "MurderTarget", "string")
    reg("M.SilentPart", "MurderSilentPart", "opt", {"Root", "Torso", "Head"})
    reg("M.Multipoint", "MurderMultipoint", "bool")
    reg("M.WallCheck", "MurderSilentWallCheck", "bool")
    reg("M.UseFov", "MurderSilentFov", "bool")
    reg("M.FovRadius", "MurderSilentFovRadius", "num")
    reg("M.SilentRange", "MurderSilentRange", "num")
    reg("M.KnifePrediction", "MurderKnifePrediction", "num", ms, unms)
    reg("M.KnifePing", "MurderKnifePing", "bool")
    reg("M.KnifeMaxLead", "MurderKnifeMaxLead", "num", ms, unms)
    reg("M.AutoEquip", "MurderAutoEquip", "bool")

	function XT.apply(flag, val)
		local s = specs[flag]
		if not s then
			return false
		end

		local kind = s.kind

        if flag == "V.ChamsStyle" and val == "Hologram" then val = "ForceField" end
		if kind == "bool" then
			V[s.key] = val == true
		elseif kind == "num" then
			if type(val) == "number" and val == val and val ~= math.huge and val ~= -math.huge then
                if s.min then val = math.clamp(val, s.min, s.max) end
				V[s.key] = s.a and s.a(val) or val
			end
        elseif kind=="strlist" then
            if type(val)=="table" then
                local list,seen={},{}
                for _,item in ipairs(val) do
                    if type(item)=="string" then
                        local name=item:gsub("<[^>]+>",""):match("^%s*(.-)%s*$")
                        local key=string.lower(name)
                        if name~="" and #name<=100 and not seen[key] and #list<(s.limit or 3) then list[#list+1]=name; seen[key]=true end
                    end
                end
                V[s.key]=list
            end
		elseif kind == "string" then
			if type(val) == "string" and #val > 0 then V[s.key] = val end
		elseif kind == "color" then
			if typeof(val) == "Color3" then
				V[s.key] = val
			end
		elseif kind == "opt" then
			if type(val) == "number" then
				val = s.a[val]
			end
			if type(val) == "string" and table.find(s.a, val) then
				V[s.key] = val
			end
		end
		if string.sub(flag,1,2)=="V." then VisualCache.invalidate() end
        return true
	end

	function XT.toggle(m, name, flag)
		local s = specs[flag]
		return m:AddToggle({
			Name = name,
			Flag = flag,
			Default = V[s.key] == true,
			Callback = function(x)
				XT.apply(flag, x)
			end,
		})
	end

	function XT.slider(m, name, flag, min, max, suffix, decimals)
		local s = specs[flag]
        s.min, s.max = min, max
		local default = V[s.key]
		if s.b then
			default = s.b(default)
		end
		return m:AddSlider({
			Name = name,
			Flag = flag,
			Min = min,
			Max = max,
			Default = math.clamp(default, min, max),
			Suffix = suffix,
			Decimals = decimals,
			Callback = function(x)
				XT.apply(flag, x)
			end,
		})
	end

	function XT.color(m, name, flag)
		local s = specs[flag]
		return m:AddColorPicker({
			Name = name,
			Flag = flag,
			Default = V[s.key],
			UseAlpha = false,
			Callback = function(c)
				XT.apply(flag, c)
			end,
		})
	end

	function XT.dropdown(m, name, flag)
		local s = specs[flag]
		return m:AddDropdown({
			Name = name,
			Flag = flag,
			Options = s.a,
			Default = V[s.key],
			Callback = function(x)
				XT.apply(flag, x)
			end,
		})
	end

	local fontCache = {}
	function XT.font(name)
		local font = fontCache[name]
		if not font then
			local ok, value = pcall(function()
				return Enum.Font[name]
			end)
			font = ok and value or Enum.Font.Code
			fontCache[name] = font
		end
		return font
	end

	function XT.textSize(base)
		return math.clamp(math.floor((base or 10) * (V.TextScale or 1) + 0.5), 6, 32)
	end

	function XT.formatDistance(studs)
		local format = V.DistanceFormat
		if format == "Meters" then
			return string.format("%dm", math.floor(studs * 0.28 + 0.5))
		elseif format == "Studs" then
			return string.format("%d studs", math.floor(studs + 0.5))
		elseif format == "Plain" then
			return tostring(math.floor(studs + 0.5))
		end
		return string.format("[%d]", math.floor(studs + 0.5))
	end
end

do
	local raw = XT.apply
	XT.after = {}

	function XT.apply(flag, val)
		local handled = raw(flag, val)
		local hook = XT.after[flag]
		if hook then
			hook()
		end
		return handled
	end

	function XT.syncRoleColors()
		local custom = V.CustomRoleColors
		local murderer = custom and V.RoleColorMurderer or Color3.fromRGB(255, 65, 72)
		local sheriff = custom and V.RoleColorSheriff or Color3.fromRGB(65, 145, 255)
		local hero = custom and V.RoleColorHero or Color3.fromRGB(255, 215, 0)
		local innocent = custom and V.RoleColorInnocent or Color3.fromRGB(255, 255, 255)

		ROLE.Murderer, ROLE.Sheriff, ROLE.Hero, ROLE.Innocent = murderer, sheriff, hero, innocent

		V.RoleFlagMurdererColor, V.RoleFlagSheriffColor, V.RoleFlagHeroColor = murderer, sheriff, hero
		V.ArrowMurdererColor, V.ArrowSheriffColor, V.ArrowHeroColor, V.ArrowInnocentColor = murderer, sheriff, hero, innocent

		for _, tbl in ipairs({ V.GlowFillColors, V.GlowOutlineColors, V.ChamsColors }) do
			if type(tbl) == "table" then
				tbl.Murderer, tbl.Sheriff, tbl.Hero, tbl.Innocent = murderer, sheriff, hero, innocent
			end
		end
	end

	XT.syncRoleColors()
end

local fetchAvatarAsset, placeAvatar

do
	local HttpService = game:GetService("HttpService")

	local sources = {}
	local busy = {}
	local retryAt = {}
	local active = 0
	local RETRY_DELAY = 30
	local FOLDER = "mm2_avatars"

	local function drawingReady()
		return type(Drawing) == "table" and type(Drawing.new) == "function"
	end

	local function httpGet(url)
		local body
		local ok = pcall(function()
			body = game:HttpGet(url)
		end)
		if ok and type(body) == "string" and #body > 0 then
			return body
		end

		local req = request or http_request or (syn and syn.request) or (http and http.request)
		if type(req) == "function" then
			local okReq, res = pcall(req, { Url = url, Method = "GET" })
			if okReq and type(res) == "table" then
				local text = res.Body
				local code = res.StatusCode
				if type(text) == "string" and #text > 0 and (code == nil or code == 200) then
					return text
				end
			end
		end
		return nil
	end

	local function downloadHeadshot(uid)
		local api = "https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds="
			.. uid .. "&size=100x100&format=Png&isCircular=false"
		local body = httpGet(api)
		if not body then
			return nil
		end

		local okJson, parsed = pcall(function()
			return HttpService:JSONDecode(body)
		end)
		local row = okJson and type(parsed) == "table" and parsed.data and parsed.data[1]
		local imageUrl = row and row.imageUrl
		if type(imageUrl) ~= "string" or imageUrl == "" then
			return nil
		end

		local bytes = httpGet(imageUrl)
		if not bytes then
			bytes = httpGet("https://images.weserv.nl/?url=" .. HttpService:UrlEncode(imageUrl))
		end
		if bytes and bytes:sub(2, 4) == "PNG" then
			return bytes
		end
		return nil
	end

	local function guiLoads(url)
		local probe = Instance.new("ImageLabel")
		probe.BackgroundTransparency = 1
		probe.Size = UDim2.fromOffset(2, 2)
		probe.Position = UDim2.fromOffset(0, 0)
		probe.ImageTransparency = 0.98
		probe.ZIndex = 1
		probe.Image = url
		probe.Parent = Overlay

		local loaded = false
		local started = os.clock()
		while os.clock() - started < 4 do
			local okRead, value = pcall(function()
				return probe.IsLoaded
			end)
			if not okRead then
				loaded = true
				break
			end
			if value then
				loaded = true
				break
			end
			task.wait(0.1)
		end

		probe:Destroy()
		return loaded
	end

	local function writeAsset(uid, bytes)
		if type(writefile) ~= "function" or type(getcustomasset) ~= "function" then
			return nil
		end
		if type(isfolder) == "function" and type(makefolder) == "function" then
			local okFolder, exists = pcall(isfolder, FOLDER)
			if okFolder and not exists then
				pcall(makefolder, FOLDER)
			end
		end
		local path = FOLDER .. "/" .. uid .. ".png"
		if not pcall(writefile, path, bytes) then
			return nil
		end
		local okAsset, asset = pcall(getcustomasset, path)
		if okAsset and type(asset) == "string" and asset ~= "" then
			return asset
		end
		return nil
	end

	local function drawingAccepts(bytes)
		if not drawingReady() then
			return false
		end
		local okNew, image = pcall(Drawing.new, "Image")
		if not okNew or not image then
			return false
		end
		local okData = pcall(function()
			image.Data = bytes
		end)
		pcall(function()
			image.Visible = false
			image:Remove()
		end)
		return okData
	end

	local function resolve(uid)
		if busy[uid] then
			return
		end
		local wait = retryAt[uid]
		if wait and os.clock() < wait then
			return
		end

		busy[uid] = true
		task.spawn(function()
			while active >= 3 do
				task.wait(0.2)
			end
			active += 1

			local rbxthumb = "rbxthumb://type=AvatarHeadShot&id=" .. uid .. "&w=150&h=150"
			local candidates = { rbxthumb }

			local okApi, apiUrl, ready = pcall(
				Players.GetUserThumbnailAsync, Players, uid,
				Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100
			)
			if okApi and type(apiUrl) == "string" and apiUrl ~= "" and ready then
				candidates[#candidates + 1] = apiUrl
			end
			candidates[#candidates + 1] = "https://www.roblox.com/headshot-thumbnail/image?userId="
				.. uid .. "&width=150&height=150&format=png"

			local found
			for _, url in ipairs(candidates) do
				if guiLoads(url) then
					found = { kind = "gui", url = url }
					break
				end
			end

			if not found then
				local bytes = downloadHeadshot(uid)
				if bytes then
					if V.AvatarAllowFile then
						local asset = writeAsset(uid, bytes)
						if asset and guiLoads(asset) then
							found = { kind = "gui", url = asset }
						end
					end
					if not found and drawingAccepts(bytes) then
						found = { kind = "draw", bytes = bytes }
					end
				end
			end

			if found then
				sources[uid] = found
				retryAt[uid] = nil
			else
				sources[uid] = { kind = "gui", url = rbxthumb, blind = true }
				retryAt[uid] = os.clock() + RETRY_DELAY
			end

			active -= 1
			busy[uid] = nil
		end)
	end

	local function ensureDraw(e, src)
		if e.AvatarDraw and e.AvatarDrawBytes == src.bytes then
			return true
		end
		if e.AvatarDraw then
			pcall(function()
				e.AvatarDraw:Remove()
			end)
			e.AvatarDraw = nil
		end
		if not drawingReady() then
			return false
		end
		local okNew, image = pcall(Drawing.new, "Image")
		if not okNew or not image then
			return false
		end
		local okData = pcall(function()
			image.Data = src.bytes
			image.Visible = false
		end)
		if not okData then
			pcall(function()
				image:Remove()
			end)
			return false
		end
		pcall(function()
			image.Rounding = 10
		end)
		e.AvatarDraw = image
		e.AvatarDrawBytes = src.bytes
		return true
	end

	fetchAvatarAsset = function(p, e)
		if not p or not e then
			return nil
		end
		local uid = p.UserId
		if not uid then
			return nil
		end

		local src = sources[uid]
		if not src or (src.blind and os.clock() >= (retryAt[uid] or 0)) then
			resolve(uid)
		end
		if not src then
			return nil
		end

		if src.kind == "draw" then
			if ensureDraw(e, src) then
				return "draw"
			end
			return nil
		end

		local image = e.Avatar
		if not image then
			return nil
		end
		if e.AvatarSrc ~= src.url then
			e.AvatarSrc = src.url
			image.Image = src.url
			image.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
			image.BackgroundTransparency = src.blind and 0.35 or 1
		end
		return "gui"
	end

	placeAvatar = function(e, kind, x, y, size)
		if kind == "draw" then
			local image = e.AvatarDraw
			if image then
				image.Position = Vector2.new(x, y)
				image.Size = Vector2.new(size, size)
				image.Visible = true
			end
			if e.Avatar then
				e.Avatar.Visible = false
			end
			return
		end

		local image = e.Avatar
		if image then
			image.AnchorPoint = Vector2.new(0, 0)
			image.Size = UDim2.fromOffset(size, size)
			image.Position = UDim2.fromOffset(x, y)
			image.Visible = true
		end
		if e.AvatarDraw then
			e.AvatarDraw.Visible = false
		end
	end

	function XT.reloadAvatars()
		for uid in pairs(sources) do
			sources[uid] = nil
		end
		for uid in pairs(retryAt) do
			retryAt[uid] = nil
		end
		for _, e in pairs(V.DrawByPlayer or {}) do
			e.AvatarSrc = nil
			if e.AvatarDraw then
				pcall(function()
					e.AvatarDraw:Remove()
				end)
				e.AvatarDraw = nil
				e.AvatarDrawBytes = nil
			end
		end
	end
end

local function ensureVisual(p, preview)
	V.DrawByPlayer = V.DrawByPlayer or {}
	local e = preview and preview.Visual or (not preview and V.DrawByPlayer[p])
	if e then
		return e
	end
	local root = guiFrame(preview and preview.Container or ESPGui, 1)
	root.Name = "ESP_" .. p.UserId
	root.BackgroundTransparency = 1
	root.ClipsDescendants = false
	root.Visible = false

	local boxMain = guiFrame(root, 1)
	boxMain.BackgroundTransparency = 1
	local boxMainStroke = Instance.new("UIStroke")
	boxMainStroke.Name = "Stroke"
	boxMainStroke.Thickness = 1
	pcall(function() boxMainStroke.StrokeSizingMode = Enum.StrokeSizingMode.FixedSize end)
	boxMainStroke.Color = Color3.fromRGB(255, 255, 255)
	boxMainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	boxMainStroke.LineJoinMode = Enum.LineJoinMode.Miter
	boxMainStroke.Parent = boxMain
	local boxMainGrad = Instance.new("UIGradient")
	boxMainGrad.Rotation = 90
	boxMainGrad.Enabled = false
	boxMainGrad.Parent = boxMainStroke

	local boxOuter = guiFrame(root, 2)
	boxOuter.BackgroundTransparency = 1
	local boxOuterStroke = Instance.new("UIStroke")
	boxOuterStroke.Name = "Stroke"
	boxOuterStroke.Thickness = 1
	pcall(function() boxOuterStroke.StrokeSizingMode = Enum.StrokeSizingMode.FixedSize end)
	boxOuterStroke.Color = Color3.new(0, 0, 0)
	boxOuterStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	boxOuterStroke.LineJoinMode = Enum.LineJoinMode.Miter
	boxOuterStroke.Enabled = false
	boxOuterStroke.Parent = boxOuter

	local boxInner = guiFrame(root, 2)
	boxInner.BackgroundTransparency = 1
	local boxInnerStroke = Instance.new("UIStroke")
	boxInnerStroke.Name = "Stroke"
	boxInnerStroke.Thickness = 1
	pcall(function() boxInnerStroke.StrokeSizingMode = Enum.StrokeSizingMode.FixedSize end)
	boxInnerStroke.Color = Color3.new(0, 0, 0)
	boxInnerStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	boxInnerStroke.LineJoinMode = Enum.LineJoinMode.Miter
	boxInnerStroke.Enabled = false
	boxInnerStroke.Parent = boxInner

	local cornerBars = {}
	local cornerOutlines = {}
	for i = 1, 8 do
		local ob = guiFrame(root, 2)
		ob.BackgroundColor3 = Color3.new(0, 0, 0)
		ob.BorderSizePixel = 0
		ob.Visible = false
		cornerOutlines[i] = ob

		local cb = guiFrame(root, 3)
		cb.BorderSizePixel = 0
		cb.Visible = false
		cornerBars[i] = cb
	end

	local healthBack = guiFrame(root, 3)
	healthBack.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
	healthBack.BackgroundTransparency = 0.25
	local healthStroke = Instance.new("UIStroke")
	healthStroke.Name = "Stroke"
	healthStroke.Thickness = 1
	healthStroke.Color = Color3.new(0, 0, 0)
	healthStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	healthStroke.LineJoinMode = Enum.LineJoinMode.Miter
	healthStroke.Parent = healthBack
	local healthFill = guiFrame(healthBack, 4)
	healthFill.BackgroundColor3 = Color3.new(1, 1, 1)
	healthFill.BorderSizePixel = 0
	local healthGrad = Instance.new("UIGradient")
	healthGrad.Rotation = 90
	healthGrad.Parent = healthFill

	e = {
		Root = root,
		BoxMain = boxMain,
		BoxMainStroke = boxMainStroke,
		BoxMainGrad = boxMainGrad,
		BoxOuter = boxOuter,
		BoxOuterStroke = boxOuterStroke,
		BoxInner = boxInner,
		BoxInnerStroke = boxInnerStroke,
		CornerBars = cornerBars,
		CornerOutlines = cornerOutlines,
		Skeleton = {},
		Name = newLabel(),
		Distance = newLabel(),
		RoleFlag = newLabel(),
		RoleTracer = newSkelLine(),
		Arrow = newLabel(),
		Avatar = newAvatar(),
		HealthBack = healthBack,
		HealthFill = healthFill,
		HealthGradient = healthGrad,
	}
	e.Arrow.Text = "▲"
	e.Arrow.Font = Enum.Font.GothamBold
	if preview then
        preview.Visual = e
        for _, object in ipairs({e.Name, e.Distance, e.RoleFlag, e.RoleTracer, e.Arrow, e.Avatar}) do
            object.Parent = preview.Container
        end
    else
        V.DrawByPlayer[p] = e
    end
	return e
end

local function requestAvatar(e, p)
	return fetchAvatarAsset(p, e)
end

local function circleAt(e)
	if e.SkeletonCircle then
		return e.SkeletonCircle
	end

	if type(Drawing) == "table" and type(Drawing.new) == "function" then
		local ok, circle = pcall(Drawing.new, "Circle")
		if ok and circle then
			circle.Visible = false
			circle.Filled = false
			circle.NumSides = 48
			e.SkeletonCircle = circle
			return circle
		end
	end

	local frame = Instance.new("Frame")
	frame.Name = "SkeletonHead"
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.BackgroundTransparency = 1
	frame.BorderSizePixel = 0
	frame.Visible = false
	frame.ZIndex = 4
	frame.Parent = Overlay

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(1, 0)
	corner.Parent = frame

	local stroke = Instance.new("UIStroke")
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Thickness = 1
	stroke.Parent = frame

	e.SkeletonCircle = frame
	return frame
end

local function placeCircle(circle, center, radius, thickness, color, opacity)
	if not circle then return end

	radius = math.max(1, radius)
	thickness = math.max(1, thickness)
	opacity = math.clamp(opacity, 0, 1)

	if typeof(circle) == "Instance" then
		circle.Position = UDim2.fromOffset(center.X, center.Y)
		circle.Size = UDim2.fromOffset(radius * 2, radius * 2)

		local stroke = circle:FindFirstChildOfClass("UIStroke")
		if stroke then
			stroke.Thickness = thickness
			stroke.Color = color
			stroke.Transparency = 1 - opacity
		end
	else
		circle.Position = center
		circle.Radius = radius
		circle.Thickness = thickness
		circle.Color = color
		circle.Transparency = opacity
		circle.Filled = false
	end

	circle.Visible = true
end

local function lineAt(group, index)
	local line = group[index]
	if line then return line end

	if type(Drawing) == "table" and type(Drawing.new) == "function" then
		local ok, drawingLine = pcall(Drawing.new, "Line")
		if ok and drawingLine then
			drawingLine.Visible = false
			group[index] = drawingLine
			return drawingLine
		end
	end

	line = newSkelLine()
	group[index] = line
	return line
end

local function placeLine(line, from, to, thickness, color, alpha)
	if typeof(line) == "Instance" then
		local delta = to - from
		local center = (from + to) * 0.5

		line.Position = UDim2.fromOffset(center.X, center.Y)
		line.Size = UDim2.fromOffset(delta.Magnitude, thickness)
		line.Rotation = math.deg(math.atan2(delta.Y, delta.X))
		line.BackgroundColor3 = color
		line.BackgroundTransparency = 1 - math.clamp(alpha, 0, 1)
		line.Visible = true
	else
		line.From = Vector2.new(from.X, from.Y)
		line.To = Vector2.new(to.X, to.Y)
		line.Thickness = math.max(1, thickness)
		line.Color = color
		line.Transparency = math.clamp(alpha, 0, 1)
		line.Visible = true
	end
end

local function gradientColor(a, b, t)
	return a:Lerp(b, math.clamp(t, 0, 1))
end

local function rect(frame, x, y, w, h)
	VisualCache.set(frame,"Position",UDim2.fromOffset(x, y))
	VisualCache.set(frame,"Size",UDim2.fromOffset(math.max(0, w), math.max(0, h)))
	VisualCache.set(frame,"Visible",w > 0 and h > 0)
end

local function solid(frame, gradient, color, transparency)
	VisualCache.set(frame,"BackgroundColor3",color)
	VisualCache.set(frame,"BackgroundTransparency",transparency)
	VisualCache.set(gradient,"Enabled",false)
end

local function graded(frame, gradient, c1, c2, transparency)
	VisualCache.set(frame,"BackgroundColor3",Color3.new(1, 1, 1))
	VisualCache.set(frame,"BackgroundTransparency",transparency)
	VisualCache.gradient(gradient,c1,c2)
	VisualCache.set(gradient,"Enabled",true)
end

local function hideBars(e)
	for i, bar in ipairs(e.Bars) do
		bar.Visible = false
		if e.BarStrokes and e.BarStrokes[i] then
			e.BarStrokes[i].Enabled = false
		end
	end
end

local function menuOverlap(a, b)
	local w = V.Library and V.Library.Window
	if not (w and w.Visible and w.Frame) then
		return false
	end
	local p, z = w.Frame.AbsolutePosition, w.Frame.AbsoluteSize
	return a.X < p.X + z.X and b.X > p.X and a.Y < p.Y + z.Y and b.Y > p.Y
end

local drawSkeleton, beginSkeletonFrame

do
	local SKEL_DOT_MIN_THICKNESS = 2
	local SKEL_LOD_HEIGHT_PX = 12
	local EPS = 0.08

	local abs, sqrt, atan2, deg, clamp, max =
		math.abs, math.sqrt, math.atan2, math.deg, math.clamp, math.max

	local J_CHEST, J_WAIST, J_LS, J_RS, J_LH, J_RH = 1, 2, 3, 4, 5, 6
	local J_LE, J_LW, J_LHAND = 7, 8, 9
	local J_RE, J_RW, J_RHAND = 10, 11, 12
	local J_LK, J_LA, J_LSOLE = 13, 14, 15
	local J_RK, J_RA, J_RSOLE = 16, 17, 18
	local J_NECK = 19
	local J_COUNT = 19

	local BONES_R15 = {
		J_CHEST, J_WAIST, J_CHEST, J_LS, J_CHEST, J_RS,
		J_WAIST, J_LH, J_WAIST, J_RH, J_LH, J_RH,
		J_LS, J_LE, J_LE, J_LW, J_LW, J_LHAND,
		J_RS, J_RE, J_RE, J_RW, J_RW, J_RHAND,
		J_LH, J_LK, J_LK, J_LA, J_LA, J_LSOLE,
		J_RH, J_RK, J_RK, J_RA, J_RA, J_RSOLE,
	}
	local BONES_R15_LOD = {
		J_CHEST, J_WAIST, J_CHEST, J_LS, J_CHEST, J_RS,
		J_WAIST, J_LH, J_WAIST, J_RH, J_LH, J_RH,
		J_LS, J_LHAND, J_RS, J_RHAND,
		J_LH, J_LSOLE, J_RH, J_RSOLE,
	}
	local BONES_R6 = {
		J_CHEST, J_WAIST,
		J_CHEST, J_LS, J_LS, J_LHAND,
		J_CHEST, J_RS, J_RS, J_RHAND,
		J_WAIST, J_LH, J_LH, J_LSOLE,
		J_WAIST, J_RH, J_RH, J_RSOLE,
		J_LH, J_RH,
	}

	local IDS_R15 = {
		J_WAIST, J_LH, J_RH, J_LE, J_LW, J_LHAND, J_RE, J_RW, J_RHAND,
		J_LK, J_LA, J_LSOLE, J_RK, J_RA, J_RSOLE,
	}
	local IDS_R15_LOD = { J_WAIST, J_LH, J_RH, J_LHAND, J_RHAND, J_LSOLE, J_RSOLE }
	local IDS_R6 = { J_WAIST, J_LS, J_RS, J_LH, J_RH, J_LHAND, J_RHAND, J_LSOLE, J_RSOLE }

	local DOTS_R15 = {
		J_CHEST, J_WAIST, J_LS, J_RS, J_LH, J_RH,
		J_LE, J_LW, J_RE, J_RW, J_LK, J_LA, J_RK, J_RA,
	}
	local DOTS_R6 = { J_CHEST, J_WAIST, J_LS, J_RS, J_LH, J_RH }

	local SK = { cam = false }

	local JW = table.create(J_COUNT, false)
	local PX = table.create(J_COUNT, 0)
	local PY = table.create(J_COUNT, 0)
	local PV = table.create(J_COUNT, false)

	local function bindJoint(rig, ch, id, partName, attName, fx, fy, altName)
		local part = ch:FindFirstChild(partName)
		if part and part:IsA("BasePart") then
			rig.part[id] = part
			local a = attName and part:FindFirstChild(attName)
			if a and a:IsA("Attachment") then
				rig.att[id] = a
			elseif fx then
				local s = part.Size
				rig.off[id] = Vector3.new(fx * s.X, fy * s.Y, 0)
			end
			return true
		end
		if altName then
			local part2 = ch:FindFirstChild(altName)
			if part2 and part2:IsA("BasePart") then
				rig.part[id] = part2
				local a = attName and part2:FindFirstChild(attName)
				if a and a:IsA("Attachment") then
					rig.att[id] = a
				end
				return true
			end
		end
		return false
	end

	local function buildRig(ch, now)
		local rig = {
			ch = ch,
			t = now,
			part = table.create(J_COUNT, false),
			att = table.create(J_COUNT, false),
			off = table.create(J_COUNT, false),
			anchor = false,
			head = false,
			headR = 1,
			r15 = false,
			incomplete = true,
		}

		local head = ch:FindFirstChild("Head")
		if head and head:IsA("BasePart") then
			rig.head = head
			rig.headR = max(head.Size.X, head.Size.Y) * 0.42
		end

		local miss = 0
		local function need(...)
			if not bindJoint(rig, ch, ...) then
				miss += 1
			end
		end

		local upper = ch:FindFirstChild("UpperTorso")
		if upper and upper:IsA("BasePart") then
			rig.r15 = true
			rig.anchor = upper

			need(J_LS, "UpperTorso", "LeftShoulderRigAttachment", -0.5, 0.35, "LeftUpperArm")
			need(J_RS, "UpperTorso", "RightShoulderRigAttachment", 0.5, 0.35, "RightUpperArm")
			bindJoint(rig, ch, J_NECK, "UpperTorso", "NeckRigAttachment")
			need(J_WAIST, "UpperTorso", "WaistRigAttachment", 0, -0.5, "LowerTorso")
			need(J_LH, "LowerTorso", "LeftHipRigAttachment", -0.25, -0.4, "LeftUpperLeg")
			need(J_RH, "LowerTorso", "RightHipRigAttachment", 0.25, -0.4, "RightUpperLeg")

			local function limb(side, elbow, wrist, hand, knee, ankle, sole)
				need(elbow, side .. "UpperArm", side .. "ElbowRigAttachment", 0, -0.5, side .. "LowerArm")
				need(wrist, side .. "LowerArm", side .. "WristRigAttachment", 0, -0.5, side .. "Hand")
				need(hand, side .. "Hand", nil, 0, -0.45)
				need(knee, side .. "UpperLeg", side .. "KneeRigAttachment", 0, -0.5, side .. "LowerLeg")
				need(ankle, side .. "LowerLeg", side .. "AnkleRigAttachment", 0, -0.5, side .. "Foot")
				need(sole, side .. "Foot", nil, 0, -0.45)
			end
			limb("Left", J_LE, J_LW, J_LHAND, J_LK, J_LA, J_LSOLE)
			limb("Right", J_RE, J_RW, J_RHAND, J_RK, J_RA, J_RSOLE)
		else
			local torso = ch:FindFirstChild("Torso")
			if torso and torso:IsA("BasePart") then
				rig.anchor = torso

				need(J_CHEST, "Torso", nil, 0, 0.35)
				need(J_WAIST, "Torso", nil, 0, -0.45)
				need(J_LS, "Torso", nil, -0.5, 0.35)
				need(J_RS, "Torso", nil, 0.5, 0.35)
				need(J_LH, "Torso", nil, -0.25, -0.45)
				need(J_RH, "Torso", nil, 0.25, -0.45)
				need(J_LHAND, "Left Arm", nil, 0, -0.48)
				need(J_RHAND, "Right Arm", nil, 0, -0.48)
				need(J_LSOLE, "Left Leg", nil, 0, -0.48)
				need(J_RSOLE, "Right Leg", nil, 0, -0.48)
			else
				miss += 1
			end
		end

		rig.incomplete = miss > 0
		return rig
	end

	local function readJoint(rig, i)
		local part = rig.part[i]
		if not part then
			return false
		end
		local a = rig.att[i]
		if a then
			return a.WorldPosition
		end
		local o = rig.off[i]
		if o then
			return part.CFrame * o
		end
		return part.Position
	end

	local function projectJoint(cam, i, w, scX, scY)
		local v, on = cam:WorldToViewportPoint(w)
		if on and v.Z > 0 then
			PX[i] = v.X * scX
			PY[i] = v.Y * scY
			PV[i] = true
		end
	end

	local function drawLine(lines, ls, index, fx, fy, tx, ty, th, col, op)
		local dx, dy = tx - fx, ty - fy
		local len = sqrt(dx * dx + dy * dy)
		local line = lines[index]
		local s = ls[index]

		if len < 0.01 then
			if s and s.vis then
				s.vis = false
				line.Visible = false
			end
			return false
		end

		if not line then
			line = lineAt(lines, index)
		end
		if not s then
			s = { gui = typeof(line) == "Instance", vis = false }
			ls[index] = s
		end

		if s.gui then
			local cx, cy = (fx + tx) * 0.5, (fy + ty) * 0.5
			if not s.cx or abs(cx - s.cx) > EPS or abs(cy - s.cy) > EPS then
				line.Position = UDim2.fromOffset(cx, cy)
				s.cx, s.cy = cx, cy
			end
			if not s.len or abs(len - s.len) > EPS or s.th ~= th then
				line.Size = UDim2.fromOffset(len, th)
				s.len, s.th = len, th
			end
			local rot = deg(atan2(dy, dx))
			if not s.rot or abs(rot - s.rot) > 0.03 then
				line.Rotation = rot
				s.rot = rot
			end
			if s.col ~= col then
				line.BackgroundColor3 = col
				s.col = col
			end
			if s.op ~= op then
				line.BackgroundTransparency = 1 - op
				s.op = op
			end
		else
			if not s.fx or abs(fx - s.fx) > EPS or abs(fy - s.fy) > EPS then
				line.From = Vector2.new(fx, fy)
				s.fx, s.fy = fx, fy
			end
			if not s.tx or abs(tx - s.tx) > EPS or abs(ty - s.ty) > EPS then
				line.To = Vector2.new(tx, ty)
				s.tx, s.ty = tx, ty
			end
			if s.th ~= th then
				line.Thickness = th
				s.th = th
			end
			if s.col ~= col then
				line.Color = col
				s.col = col
			end
			if s.op ~= op then
				line.Transparency = op
				s.op = op
			end
		end

		if not s.vis then
			s.vis = true
			line.Visible = true
		end
		return true
	end

	local function jointAt(e, index)
		local joints = e.SkeletonJoints
		if not joints then
			joints = {}
			e.SkeletonJoints = joints
		end

		local joint = joints[index]
		if joint then
			return joint
		end

		if type(Drawing) == "table" and type(Drawing.new) == "function" then
			local ok, dot = pcall(Drawing.new, "Circle")
			if ok and dot then
				dot.Visible = false
				dot.Filled = true
				dot.NumSides = 12
				joints[index] = dot
				return dot
			end
		end

		local frame = Instance.new("Frame")
		frame.Name = "SkeletonJoint"
		frame.AnchorPoint = Vector2.new(0.5, 0.5)
		frame.BorderSizePixel = 0
		frame.Visible = false
		frame.ZIndex = 4
		frame.Parent = Overlay

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(1, 0)
		corner.Parent = frame

		joints[index] = frame
		return frame
	end

	local function drawDot(e, index, x, y, th, col, op)
		local dot = jointAt(e, index)
		local js = e.SkelJS
		if not js then
			js = {}
			e.SkelJS = js
		end
		local s = js[index]
		if not s then
			s = { gui = typeof(dot) == "Instance", vis = false }
			js[index] = s
		end

		local moved = not s.x or abs(x - s.x) > EPS or abs(y - s.y) > EPS
		if s.gui then
			if moved then
				dot.Position = UDim2.fromOffset(x, y)
			end
			if s.th ~= th then
				dot.Size = UDim2.fromOffset(th, th)
			end
			if s.col ~= col then
				dot.BackgroundColor3 = col
			end
			if s.op ~= op then
				dot.BackgroundTransparency = 1 - op
			end
		else
			if moved then
				dot.Position = Vector2.new(x, y)
			end
			if s.th ~= th then
				dot.Radius = th * 0.5
			end
			if s.col ~= col then
				dot.Color = col
			end
			if s.op ~= op then
				dot.Transparency = op
			end
		end

		if moved then
			s.x, s.y = x, y
		end
		s.th, s.col, s.op = th, col, op

		if not s.vis then
			s.vis = true
			dot.Visible = true
		end
	end

	local function drawHead(e, x, y, r, th, col, op)
		local c = circleAt(e)
		local s = e.SkelHS
		if not s then
			s = { gui = typeof(c) == "Instance", vis = false }
			e.SkelHS = s
		end

		if s.gui then
			if not s.x or abs(x - s.x) > EPS or abs(y - s.y) > EPS then
				c.Position = UDim2.fromOffset(x, y)
				s.x, s.y = x, y
			end
			if not s.r or abs(r - s.r) > EPS then
				c.Size = UDim2.fromOffset(r * 2, r * 2)
				s.r = r
			end
			if s.stroke == nil then
				s.stroke = c:FindFirstChildOfClass("UIStroke") or false
			end
			local stroke = s.stroke
			if stroke then
				if s.th ~= th then
					stroke.Thickness = th
					s.th = th
				end
				if s.col ~= col then
					stroke.Color = col
					s.col = col
				end
				if s.op ~= op then
					stroke.Transparency = 1 - op
					s.op = op
				end
			end
		else
			if not s.x or abs(x - s.x) > EPS or abs(y - s.y) > EPS then
				c.Position = Vector2.new(x, y)
				s.x, s.y = x, y
			end
			if not s.r or abs(r - s.r) > EPS then
				c.Radius = r
				s.r = r
			end

			local sides = r < 5 and 14 or (r < 10 and 22 or (r < 20 and 32 or 48))
			if s.sides ~= sides then
				c.NumSides = sides
				s.sides = sides
			end
			if not s.init then
				c.Filled = false
				s.init = true
			end
			if s.th ~= th then
				c.Thickness = th
				s.th = th
			end
			if s.col ~= col then
				c.Color = col
				s.col = col
			end
			if s.op ~= op then
				c.Transparency = op
				s.op = op
			end
		end

		if not s.vis then
			s.vis = true
			c.Visible = true
		end
	end

	beginSkeletonFrame = function()
		local cam = Workspace.CurrentCamera
		if not cam or not V.SkeletonEnabled then
			SK.cam = false
			return
		end
		Camera = cam

		local cf = cam.CFrame
		local pos, look, up = cf.Position, cf.LookVector, cf.UpVector
		local vs = cam.ViewportSize
		local sz = Overlay.AbsoluteSize

		local scX, scY, w, h = 1, 1, vs.X, vs.Y
		if sz.X > 0 and sz.Y > 0 and vs.X > 0 and vs.Y > 0 then
			scX, scY = sz.X / vs.X, sz.Y / vs.Y
			w, h = sz.X, sz.Y
		end

		local base = pos + look * 10
		local a = cam:WorldToViewportPoint(base)
		local b = cam:WorldToViewportPoint(base + up)
		local k = abs(a.Y - b.Y) * 10 * scY
		if k < 1 then
			k = h * 0.5 / math.tan(math.rad(cam.FieldOfView) * 0.5)
		end

		local th = clamp(tonumber(V.SkeletonThickness) or 1, 1, 3)

		SK.cam = cam
		SK.pos, SK.look = pos, look
		SK.scX, SK.scY, SK.w, SK.h, SK.k = scX, scY, w, h, k
		SK.th = th
		SK.op = clamp(tonumber(V.SkeletonTransparency) or 1, 0, 1)
		SK.overlap = max(0.85, th * 0.6)
		SK.dots = th >= SKEL_DOT_MIN_THICKNESS
		SK.now = os.clock()
	end

	drawSkeleton = function(e, ch, color)
		local cam = SK.cam
		if not cam then
			beginSkeletonFrame()
			cam = SK.cam
		end
		if not cam or not ch then
			hideSkeleton(e)
			return
		end

		if typeof(color) ~= "Color3" then color = V.SkeletonColor end
		if typeof(color) ~= "Color3" then color = Color3.new(1, 1, 1) end

		local rig = e.SkelRig
		local now = SK.now
		if not (
			rig and rig.ch == ch
			and (not rig.anchor or rig.anchor.Parent)
			and (not rig.incomplete or now - rig.t < 0.35)
		) then
			rig = buildRig(ch, now)
			e.SkelRig = rig
		end

		local anchor = rig.anchor
		if not anchor then
			hideSkeleton(e)
			return
		end

		local r15 = rig.r15
		local scX, scY, k = SK.scX, SK.scY, SK.k
		local th, op, overlap = SK.th, SK.op, SK.overlap

		local chestW
		if r15 then
			local ls = readJoint(rig, J_LS)
			local rs = readJoint(rig, J_RS)
			JW[J_LS], JW[J_RS] = ls, rs
			chestW = (ls and rs) and (ls + rs) * 0.5 or readJoint(rig, J_NECK)
		else
			chestW = readJoint(rig, J_CHEST)
		end
		JW[J_CHEST] = chestW

		local cullW = chestW or anchor.Position
		local depth = (cullW - SK.pos):Dot(SK.look)
		if depth < -4 then
			hideSkeleton(e)
			return
		end

		local cv, con = cam:WorldToViewportPoint(cullW)
		local cx, cy = cv.X * scX, cv.Y * scY
		if cv.Z > 0 then

			local m = 4.5 * k / cv.Z + 4
			if cx < -m or cx > SK.w + m or cy < -m or cy > SK.h + m then
				hideSkeleton(e)
				return
			end
		end

		for i = 1, J_COUNT do
			PV[i] = false
		end
		if chestW and con and cv.Z > 0 then
			PX[J_CHEST], PY[J_CHEST], PV[J_CHEST] = cx, cy, true
		end

		local lod = r15 and cv.Z > 0 and (5 * k / cv.Z) < SKEL_LOD_HEIGHT_PX

		local ids, bones, dots
		if r15 then
			ids = lod and IDS_R15_LOD or IDS_R15
			bones = lod and BONES_R15_LOD or BONES_R15
			dots = DOTS_R15
			local lw, rw = JW[J_LS], JW[J_RS]
			if lw then projectJoint(cam, J_LS, lw, scX, scY) end
			if rw then projectJoint(cam, J_RS, rw, scX, scY) end
		else
			ids, bones, dots = IDS_R6, BONES_R6, DOTS_R6
		end

		for n = 1, #ids do
			local i = ids[n]
			local w = readJoint(rig, i)
			if w then
				projectJoint(cam, i, w, scX, scY)
			end
		end

		local lines, ls = e.Skeleton, e.SkelLS
		if not lines then
			lines = {}
			e.Skeleton = lines
		end
		if not ls then
			ls = {}
			e.SkelLS = ls
		end

		local hx, hy, hr
		local head = rig.head
		if head then
			local hv, hon = cam:WorldToViewportPoint(head.Position)
			if hon and hv.Z > 0 then
				hx, hy = hv.X * scX, hv.Y * scY
				hr = clamp(rig.headR * k / hv.Z, 2, 45)
				drawHead(e, hx, hy, hr, th, color, op)
			end
		end
		if not hx then
			local hs = e.SkelHS
			local circle = e.SkeletonCircle
			if circle and (not hs or hs.vis) then
				if hs then hs.vis = false end
				circle.Visible = false
			end
		end

		local used = 0

		if hx and PV[J_CHEST] then
			local chx, chy = PX[J_CHEST], PY[J_CHEST]
			local dx, dy = chx - hx, chy - hy
			local len = sqrt(dx * dx + dy * dy)
			if len > hr + 0.1 then
				local ux, uy = dx / len, dy / len
				local inset = max(0, hr - overlap)
				if drawLine(
					lines, ls, used + 1,
					hx + ux * inset, hy + uy * inset,
					chx + ux * overlap, chy + uy * overlap,
					th, color, op
				) then
					used += 1
				end
			end
		end

		for n = 1, #bones, 2 do
			local ia, ib = bones[n], bones[n + 1]
			if PV[ia] and PV[ib] then
				local ax, ay, bx, by = PX[ia], PY[ia], PX[ib], PY[ib]
				local dx, dy = bx - ax, by - ay
				local len = sqrt(dx * dx + dy * dy)
				if len >= 0.01 then
					local ux, uy = dx / len, dy / len
					if drawLine(
						lines, ls, used + 1,
						ax - ux * overlap, ay - uy * overlap,
						bx + ux * overlap, by + uy * overlap,
						th, color, op
					) then
						used += 1
					end
				end
			end
		end

		for i = used + 1, #lines do
			local s = ls[i]
			if s and s.vis then
				s.vis = false
				lines[i].Visible = false
			end
		end

		local dotsUsed = 0
		if SK.dots and not lod then
			for n = 1, #dots do
				local i = dots[n]
				if PV[i] then
					dotsUsed += 1
					drawDot(e, dotsUsed, PX[i], PY[i], th, color, op)
				end
			end
		end

		local joints, js = e.SkeletonJoints, e.SkelJS
		if joints and js then
			for i = dotsUsed + 1, #joints do
				local s = js[i]
				if s and s.vis then
					s.vis = false
					joints[i].Visible = false
				end
			end
		end
	end
end

do
	local clamp, sin, abs, cos, rad = math.clamp, math.sin, math.abs, math.cos, math.rad

	function XT.applyBoxFill(e, now)
		local frame = e.BoxMain
		local grad = e.BoxFillGrad
		if not grad then
			grad = Instance.new("UIGradient")
			grad.Name = "FillGradient"
			grad.Enabled = false
			grad.Parent = frame
			e.BoxFillGrad = grad
		end

		frame.BackgroundTransparency = V.BoxFillTransparency

		if not V.BoxFillGradient then
			frame.BackgroundColor3 = V.BoxFillColor
			if grad.Enabled then
				grad.Enabled = false
			end
			e.BoxFillSig = nil
			return
		end

		frame.BackgroundColor3 = Color3.new(1, 1, 1)
		grad.Enabled = true

		local c1, c2 = V.BoxFillColor, V.BoxFillGradientColor
		local angle = V.BoxFillAngle or 90
		local anim = V.BoxFillAnim
		local speed = clamp(V.BoxFillSpeed or 1, 0.1, 4)

		if anim == "Flow" then
			if e.BoxFillSig ~= "flow" or e.BoxFillC1 ~= c1 or e.BoxFillC2 ~= c2 then
				e.BoxFillSig, e.BoxFillC1, e.BoxFillC2 = "flow", c1, c2
				grad.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, c1),
					ColorSequenceKeypoint.new(0.5, c2),
					ColorSequenceKeypoint.new(1, c1),
				})
			end
			local phase = (now * speed * 0.6) % 2
			local triangle = 1 - abs(phase - 1)
			grad.Rotation = angle
			grad.Offset = Vector2.new(triangle * 2 - 1, 0)
		elseif anim == "Spin" then
			if e.BoxFillSig ~= "spin" or e.BoxFillC1 ~= c1 or e.BoxFillC2 ~= c2 then
				e.BoxFillSig, e.BoxFillC1, e.BoxFillC2 = "spin", c1, c2
				grad.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, c1),
					ColorSequenceKeypoint.new(0.5, c2),
					ColorSequenceKeypoint.new(1, c1),
				})
				grad.Offset = Vector2.zero
			end
			grad.Rotation = (angle + now * speed * 70) % 360
		elseif anim == "Pulse" then
			local p = math.floor((0.5 + 0.5 * sin(now * speed * 2.2)) * 50 + 0.5) / 50
			if e.BoxFillSig ~= "pulse" or e.BoxFillP ~= p or e.BoxFillC1 ~= c1 or e.BoxFillC2 ~= c2 then
				e.BoxFillSig, e.BoxFillP, e.BoxFillC1, e.BoxFillC2 = "pulse", p, c1, c2
				grad.Color = ColorSequence.new(c1:Lerp(c2, p), c2:Lerp(c1, p))
				grad.Offset = Vector2.zero
			end
			grad.Rotation = angle
		else
			if e.BoxFillSig ~= "static" or e.BoxFillC1 ~= c1 or e.BoxFillC2 ~= c2 then
				e.BoxFillSig, e.BoxFillC1, e.BoxFillC2 = "static", c1, c2
				grad.Color = ColorSequence.new(c1, c2)
				grad.Offset = Vector2.zero
			end
			grad.Rotation = angle
		end
	end

	function XT.gradientT(x, y, w, h, angleDegrees)
		local a = rad(angleDegrees or 90)
		local dx, dy = cos(a), sin(a)
		local ux, uy = x / math.max(w, 1) - 0.5, y / math.max(h, 1) - 0.5
		local extent = abs(dx) + abs(dy)
		if extent < 1e-4 then
			return 0
		end
		return clamp(0.5 + (ux * dx + uy * dy) / extent, 0, 1)
	end

	function XT.nameBackground(e)
		local label = e.Name
		local padding = e.NameBgPadding
		if not padding then
			padding = Instance.new("UIPadding")
			padding.Name = "BgPadding"
			padding.Parent = label

			local corner = Instance.new("UICorner")
			corner.Name = "BgCorner"
			corner.CornerRadius = UDim.new(0, 3)
			corner.Parent = label

			e.NameBgPadding = padding
		end

		if V.NameBackground then
			label.BackgroundColor3 = V.NameBackgroundColor
			label.BackgroundTransparency = V.NameBackgroundTransparency
			padding.PaddingLeft = UDim.new(0, 3)
			padding.PaddingRight = UDim.new(0, 3)
			padding.PaddingTop = UDim.new(0, 1)
			padding.PaddingBottom = UDim.new(0, 1)
			return 6, 2
		end

		label.BackgroundTransparency = 1
		padding.PaddingLeft = UDim.new(0, 0)
		padding.PaddingRight = UDim.new(0, 0)
		padding.PaddingTop = UDim.new(0, 0)
		padding.PaddingBottom = UDim.new(0, 0)
		return 0, 0
	end
end

do
	local function rgb(r, g, b)
		return Color3.fromRGB(r, g, b)
	end

	local STYLES = {
        Flat = {
            material = Enum.Material.SmoothPlastic, reflectance = 0,
            ambient = rgb(220,220,220), light = rgb(60,60,60),
            direction = Vector3.new(-0.6,-1,-0.35).Unit,
        },
        Glass = {
            material = Enum.Material.Glass, reflectance = 0.02,
            ambient = rgb(232,232,232), light = rgb(65,65,65),
            direction = Vector3.new(0.8,-0.45,-0.7).Unit,
        },
        Neon = {
            material = Enum.Material.Neon, reflectance = 0,
            ambient = rgb(242,242,242), light = rgb(25,25,25),
            direction = Vector3.new(-0.3,-0.7,0.8).Unit,
        },
        Glow = {
            material = Enum.Material.SmoothPlastic, reflectance = 0,
            ambient = rgb(255,255,255), light = rgb(0,0,0),
            direction = Vector3.new(0,-1,0),
        },
        ForceField = {
            material = Enum.Material.ForceField, reflectance = 0,
            ambient = rgb(230,230,230), light = rgb(45,45,45),
            direction = Vector3.new(0.45,-1,0.4).Unit,
        },
        Highlight = {
            material = Enum.Material.SmoothPlastic, reflectance = 0,
            ambient = rgb(255,255,255), light = rgb(255,255,255),
            direction = Vector3.new(-0.35,-0.8,-0.45).Unit,
        },
    }

    local function isWhite(color)
        return color.R >= 0.995 and color.G >= 0.995 and color.B >= 0.995
    end

    local function surfaceColor(base, source, root, now, styleName)
        styleName = styleName or V.ChamsStyle
        if isWhite(base) then return Color3.new(1,1,1) end
        local shade = 0
        local normal = source.CFrame.LookVector
        if styleName == "Flat" and normal then
            local diffuse = math.clamp(-normal:Dot(STYLES.Flat.direction),0,1)
            shade = 0.02*(1-diffuse)
        elseif styleName == "Glass" then
            local camera = Workspace.CurrentCamera
            local delta = camera and (camera.CFrame.Position-source.Position)
            if normal and delta and delta.Magnitude > 0.001 then
                local rim = 1-math.clamp(math.abs(normal:Dot(delta.Unit)),0,1)
                shade = 0.035*(1-rim*rim)
            end
        elseif styleName == "Neon" then
            shade = 0.015*(1+math.sin(now*2))
        elseif styleName == "ForceField" then
            local height = source.Position.Y-(root and root.Position.Y or 0)
            local wave = 0.5+0.5*math.cos(height*1.8-now*3)
            shade = 0.12*(1-wave)
        end
        return base:Lerp(Color3.new(0,0,0),shade)
    end

    XT.chamsStyles = STYLES
    XT.chamsSurfaceColor = surfaceColor

    local function createChamsRenderer(localMode)
	local viewport, world, renderCamera
	local removeRecord
	local records = {}
	local wanted,visibilityQueue={},{}
	local appliedStyle
	local scanTimer = 0
	local lastSourceCamera
	local visibilityCursor = 1
	local lastClock = os.clock()

	local rayParams = RaycastParams.new()
	rayParams.FilterType = Enum.RaycastFilterType.Exclude
	rayParams.IgnoreWater = true
	rayParams.RespectCanCollide = false

	local function styleName()
        return localMode and V.LocalChamsStyle or V.ChamsStyle
    end
	local function currentStyle()
		return STYLES[styleName()] or STYLES.Flat
	end

    local function nativeLocalForceField(source, copy)
        return localMode and styleName() == "ForceField" and copy:IsA("MeshPart")
            and source:IsA("MeshPart") and source.TextureID ~= ""
    end

    local function applyPartStyle(source, copy)
        local style = currentStyle()
        copy.MaterialVariant = ""
        copy.Material = style.material
        copy.Reflectance = style.reflectance
        if localMode and styleName() == "ForceField" and not nativeLocalForceField(source, copy) then
                                                                             
                                                                                              
            copy.Material = Enum.Material.SmoothPlastic
        end
        if copy:IsA("MeshPart") then
            copy.TextureID = nativeLocalForceField(source, copy) and source.TextureID or ""
        end
    end

	local function ensureViewport()
		if viewport and viewport.Parent then
			return
		end
		for player in pairs(records) do removeRecord(player) end
		scanTimer = 0
		viewport = Instance.new("ViewportFrame")
		viewport.Name = localMode and "Waraku_LOCAL_CHAMS" or "Waraku_CHAMS"
		viewport.Size = UDim2.fromScale(1, 1)
		viewport.BackgroundTransparency = 1
		viewport.BorderSizePixel = 0
		viewport.Active = false
		viewport.ZIndex = 1
		viewport.LightDirection = Vector3.new(-0.7, -1, -0.4).Unit
		viewport.Parent = ESPGui

		world = Instance.new("WorldModel")
		world.Parent = viewport

		renderCamera = Instance.new("Camera")
		renderCamera.CameraType = Enum.CameraType.Scriptable
		renderCamera.Parent = viewport
		viewport.CurrentCamera = renderCamera
		appliedStyle = nil
	end

	local function applyStyle()
		local name = STYLES[styleName()] and styleName() or "Flat"
		if appliedStyle == name then
			return
		end
		appliedStyle = name

		local style = currentStyle()
		viewport.Ambient = style.ambient
		viewport.LightColor = style.light
        viewport.LightDirection = style.direction
		for _, record in pairs(records) do
			for source, copy in pairs(record.parts) do
                applyPartStyle(source, copy)
			end
		end
	end

	removeRecord = function(player)
		local record = records[player]
		if not record then
			return
		end
		for _, connection in ipairs(record.connections) do
			connection:Disconnect()
		end
		pcall(function()
			record.model:Destroy()
		end)
		records[player] = nil
	end

local function copyGeometry(source,copy,record,owner)
        if source:IsA("LuaSourceContainer") or source:IsA("Tool") or source:IsA("Animator")
            or source:IsA("Decal") or source:IsA("Texture") or source:IsA("SurfaceAppearance")
            or source:IsA("Shirt") or source:IsA("Pants") or source:IsA("ShirtGraphic")
            or source:IsA("Highlight") or source:IsA("ForceField") or source:IsA("Sound")
            or source:IsA("ParticleEmitter") or source:IsA("Trail") or source:IsA("Beam")
            or source:IsA("Light") or source:IsA("GuiBase2d") then
            copy:Destroy(); return
        end
        if string.sub(source.Name,1,7)=="Waraku_" or source.Name=="TrailPart" then copy:Destroy(); return end
        if localMode and source:IsA("Accessory") and not V.LocalChamsAccessories then copy:Destroy(); return end
        if source:IsA("BasePart") then
            if localMode and XT.isLocalChamsWeapon and XT.isLocalChamsWeapon(source) then copy:Destroy(); return end
            owner=source
            record.parts[source]=copy
            copy.Anchored=true
            copy.CanCollide=false; copy.CanTouch=false; copy.CanQuery=false
            copy.CastShadow=false; copy.Massless=true
            copy.LocalTransparencyModifier=0; copy.Transparency=1
            copy.CFrame=source.CFrame
            applyPartStyle(source,copy)
            if copy:IsA("MeshPart") then
                pcall(function() copy.RenderFidelity=Enum.RenderFidelity.Precise end)
            elseif copy:IsA("UnionOperation") then copy.UsePartColor=true end
        elseif source:IsA("DataModelMesh") and owner then
            record.meshes[owner]={source,copy}
            if copy:IsA("SpecialMesh") then copy.TextureId=""; copy.VertexColor=Vector3.new(1,1,1) end
        elseif source:IsA("Bone") and owner then
            local bones=record.bones[owner] or {}
            bones[#bones+1]={source,copy}; record.bones[owner]=bones
        elseif source:IsA("Motor6D") then
            record.joints[source]=copy
        elseif source:IsA("Humanoid") then
            copy.DisplayDistanceType=Enum.HumanoidDisplayDistanceType.None
            copy.HealthDisplayType=Enum.HumanoidHealthDisplayType.AlwaysOff
            copy.AutoRotate=false; copy.BreakJointsOnDeath=false
            pcall(function() copy.RequiresNeck=false end)
        end
        local originals,copies=source:GetChildren(),copy:GetChildren()
        local used={}
        for _,child in ipairs(copies) do
            local matching
            for _,original in ipairs(originals) do
                if not used[original] and original.ClassName==child.ClassName and original.Name==child.Name then
                    used[original]=true; matching=original; break
                end
            end
            if matching then copyGeometry(matching,child,record,owner) else child:Destroy() end
        end
    end

    local function addRecord(player,character)
        removeRecord(player)
        local originals={}
        originals[character]=character.Archivable
        for _,object in ipairs(character:GetDescendants()) do originals[object]=object.Archivable end
        local ok,model=pcall(function()
            for object in pairs(originals) do object.Archivable=true end
            return character:Clone()
        end)
        for object,value in pairs(originals) do pcall(function() object.Archivable=value end) end
        if not ok or not model then return end
        local record={player=player,character=character,model=model,parts={},meshes={},bones={},joints={},pending={},
            halos={},rigDirty=true,connections={},alpha=0,visMix=0,visible=false,hidden=false,lastSeen=-math.huge,
            accessories=V.LocalChamsAccessories}
        local clean,err=pcall(copyGeometry,character,model,record)
        if not clean then model:Destroy(); V.LastChamsError=tostring(err); return end
        model.Name=player.Name.."_Chams"
        model.Parent=world
        records[player]=record
        local function changed(descendant)
            if descendant:IsA("BasePart") or descendant:IsA("DataModelMesh") or descendant:IsA("Bone")
                or descendant:IsA("WrapLayer") or descendant:IsA("WrapTarget") or descendant:IsA("Accessory")
                or descendant:IsA("Humanoid") or descendant:IsA("SurfaceAppearance") then
                record.rigDirty=true
                record.rebuildAt=os.clock()+0.15
            end
        end
        record.connections[1]=character.DescendantAdded:Connect(changed)
        record.connections[2]=character.DescendantRemoving:Connect(changed)
        scanTimer=0
    end

	local SAMPLE_PARTS = {
		{"Head"}, {"UpperTorso", "Torso"}, {"LowerTorso", "HumanoidRootPart"},
		{"LeftUpperArm", "Left Arm"}, {"RightUpperArm", "Right Arm"},
		{"LeftUpperLeg", "Left Leg"}, {"RightUpperLeg", "Right Leg"},
	}

	local function refreshRecord(record)
        local character = record.character
		if not record.rigDirty then return end
		record.rigDirty = false
		record.root = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
		record.humanoid = character:FindFirstChildOfClass("Humanoid")
		local samples = {}
		for _, names in ipairs(SAMPLE_PARTS) do
			for _, name in ipairs(names) do
				local part = character:FindFirstChild(name)
				if part and part:IsA("BasePart") then samples[#samples+1] = part; break end
			end
		end
		record.samples = samples
	end

	local function isClear(origin, point, character, ignore, budget)
		local delta = point-origin
		local distance=delta.Magnitude
		if distance~=distance or distance==math.huge then return false end
		if distance < 0.001 then return true end
		local direction=delta/distance
		local covered,skipped=0,0
		local filter = table.clone(ignore)
		while covered<distance do
			if budget.left <= 0 then return nil end
			budget.left = budget.left-1
			rayParams.FilterDescendantsInstances = filter
			local length=math.min(14000,distance-covered)
			local hit = Workspace:Raycast(origin+direction*covered, direction*length, rayParams)
			if not hit then
				covered=covered+length
			else
				local object = hit.Instance
				if object and object:IsDescendantOf(character) then return true end
				if object and object:IsA("BasePart")
					and (1-(1-object.Transparency)*(1-object.LocalTransparencyModifier)) >= 0.95 then
					if skipped>=6 then return nil end
					skipped=skipped+1; filter[#filter+1] = object
				else
					return false
				end
			end
		end
		return true
	end

    local function localPartVisible(camera, source, record, budget)
        if source.LocalTransparencyModifier > 0.95 then return false end
        local point, onScreen = camera:WorldToViewportPoint(source.Position)
        if not onScreen or point.Z <= 0 then return false end
        local origin = camera.CFrame.Position
        local ignore = {camera, record.character}
        local half = source.Size * 0.5

        if isClear(origin, source.Position, record.character, ignore, budget) ~= true then return false end
        for x = -1, 1, 2 do
            for y = -1, 1, 2 do
                for z = -1, 1, 2 do
                    local corner = source.CFrame:PointToWorldSpace(Vector3.new(half.X*x, half.Y*y, half.Z*z))
                    if isClear(origin, corner, record.character, ignore, budget) ~= true then return false end
                end
            end
        end
        return true
    end

	local function updateVisibility(camera, maxDistance, now)
		local origin = camera.CFrame.Position
		local ignore = {camera}
		if LocalPlayer.Character then ignore[#ignore+1] = LocalPlayer.Character end
		local queue=visibilityQueue
		table.clear(queue)
		for _, record in pairs(records) do
            refreshRecord(record)
            if VisualCache.inView(record.root,camera) then queue[#queue+1] = record end
        end
		local count = #queue
		if count == 0 then visibilityCursor = 1; return end
		local budget = {left = 96}
		local first = ((visibilityCursor-1)%count)+1
		for offset = 0, count-1 do
			local index = ((first+offset-1)%count)+1
			local record = queue[index]
			local ch = record.character
			local root = record.root
			local seen, unknown = false, false
			if root and root:IsA("BasePart") and (root.Position-origin).Magnitude <= maxDistance then
				for _, part in ipairs(record.samples) do
					if part then
						local point, onScreen = camera:WorldToViewportPoint(part.Position)
						if point.Z > 0 and onScreen then
							local clear = isClear(origin, part.Position, ch, ignore, budget)
							if clear == true then seen = true; break end
							if clear == nil then unknown = true; break end
						end
					end
				end
			end
			if seen then
				record.lastSeen, record.visible = now, true
			elseif not unknown then
				record.visible = record.visible and (now-record.lastSeen < 0.08)
			end
			if budget.left <= 0 then visibilityCursor = index+1; return end
		end
		visibilityCursor = first+1
	end

	local function clearAll()
		scanTimer, visibilityCursor = 0, 1
		for player in pairs(records) do
			removeRecord(player)
		end
		if viewport then
			viewport.Visible = false
		end
	end

    local function glowValue(suffix)
        return V[(localMode and "LocalChams" or "Chams")..suffix]
    end
    local function clearHalo(record,source)
        local halo=record.halos[source]
        if halo then
            for _,layer in ipairs(halo.layers) do layer.part:Destroy() end
            record.halos[source]=nil
        end
    end
    local function makeHaloLayer(copy,record)
        local ok,part=pcall(function() return copy:Clone() end)
        if not ok or not part then return nil end
        local layer={part=part,bones={}}
        local originals,clones=copy:GetDescendants(),part:GetDescendants()
        for i,child in ipairs(clones) do
            if child:IsA("Bone") and originals[i] and originals[i]:IsA("Bone") then
                layer.bones[#layer.bones+1]={originals[i],child}
            elseif not child:IsA("DataModelMesh") and not child:IsA("Bone") then child:Destroy() end
        end
        layer.mesh=part:FindFirstChildOfClass("DataModelMesh")
        part.Name="Waraku_GLOW_SHELL";part.Material=Enum.Material.SmoothPlastic
        part.CastShadow=false;part.CanCollide=false;part.CanTouch=false;part.CanQuery=false
        part.Parent=record.model
        return layer
    end
    local function updateHalo(record,source,copy,visible,now)
        local strength=math.clamp(tonumber(glowValue("GlowStrength")) or 60,0,100)/100
        if styleName()~="Glow" or not visible or strength<=0 then clearHalo(record,source);return end
        local halo=record.halos[source]
        if not halo then
            halo={layers={}}
            for i=1,2 do
                local layer=makeHaloLayer(copy,record)
                if not layer then
                    for _,created in ipairs(halo.layers) do created.part:Destroy() end
                    return
                end
                halo.layers[i]=layer
            end
            record.halos[source]=halo
        end
        local width=math.clamp(tonumber(glowValue("GlowWidth")) or 0.08,0.01,0.2)
        if glowValue("GlowPulse") then strength=strength*(0.85+0.15*math.sin(now*2.5)) end
                                                                                                
        strength=strength*math.clamp((1-source.Transparency)*(1-source.LocalTransparencyModifier),0,1)
        local camera=Workspace.CurrentCamera
        local forward=camera and camera.CFrame.LookVector or Vector3.new(0,0,0)
        local size=source.Size
        for i,layer in ipairs(halo.layers) do
            local padding=width*(i==1 and 0.45 or 1)
            local part=layer.part
                                                                                        
                                                                                        
            VisualCache.set(part,"CFrame",source.CFrame+forward*(padding*0.75))
            VisualCache.set(part,"Size",layer.mesh and size or size+Vector3.new(padding*2,padding*2,padding*2))
            VisualCache.set(part,"Color",glowValue("GlowColor"))
            VisualCache.set(part,"Transparency",1-strength*(i==1 and 0.28 or 0.12))
            if layer.mesh then
                local pair=record.meshes[source]
                if pair then
                    local mesh=pair[1];local scale=mesh.Scale
                    VisualCache.set(layer.mesh,"Scale",Vector3.new(
                        scale.X*(1+padding*2/math.max(size.X,0.05)),
                        scale.Y*(1+padding*2/math.max(size.Y,0.05)),
                        scale.Z*(1+padding*2/math.max(size.Z,0.05))))
                    VisualCache.set(layer.mesh,"Offset",mesh.Offset)
                    if mesh:IsA("SpecialMesh") then
                        VisualCache.set(layer.mesh,"MeshType",mesh.MeshType)
                        VisualCache.set(layer.mesh,"MeshId",mesh.MeshId)
                    end
                end
            end
            for _,pair in ipairs(layer.bones) do
                if pair[1].Parent and pair[2].Parent then
                    VisualCache.set(pair[2],"CFrame",pair[1].CFrame)
                    VisualCache.set(pair[2],"Transform",pair[1].Transform)
                end
            end
        end
    end

	local function step(list)
		local now = os.clock()
		local dt = math.clamp(now - lastClock, 0, 0.1)
		lastClock = now

		local enabled = (localMode and V.LocalChamsEnabled and not V.VoteRespawning and not V.VoteDupeRunning and now>=(V.VisualRespawnQuietUntil or 0)) or (not localMode and V.Enabled and V.HighlightEnabled)
		if not (list and #list > 0 and enabled and not V.Destroying and not V.Destroyed) then
			if next(records) or (viewport and viewport.Visible) then
				clearAll()
			end
			return
		end

		local camera = Workspace.CurrentCamera
		if not camera then
			if viewport then viewport.Visible = false end
			return
		end
		if camera ~= lastSourceCamera then
			lastSourceCamera = camera
			scanTimer = 0
		end
		if localMode and V.LocalChamsStyle == "Highlight" then clearAll(); return end
		ensureViewport()

		VisualCache.set(viewport,"ImageTransparency",styleName()=="Glow" and 0 or math.clamp((localMode and V.LocalChamsTransparency or V.LitAlpha) or 0, 0, 1))
		VisualCache.set(renderCamera,"CFrame",camera.CFrame)
		VisualCache.set(renderCamera,"FieldOfViewMode",camera.FieldOfViewMode)
		VisualCache.set(renderCamera,"FieldOfView",camera.FieldOfView)
        applyStyle()
        local ambient = math.clamp(tonumber(V.ChamsAmbient) or 0.5, 0, 1)
        local intensity = math.clamp(tonumber(V.ChamsLight) or 0.72, 0, 1)
                                                                                  
                                                                                  
                                                                                   
        local uniformLocal = localMode and (styleName() == "Neon" or styleName() == "ForceField")
        if uniformLocal then ambient, intensity = 1, 0 end
        if styleName()=="Glow" then ambient,intensity=1,0 end
        VisualCache.set(viewport,"Ambient",Color3.new(ambient,ambient,ambient))
        VisualCache.set(viewport,"LightColor",Color3.new(intensity,intensity,intensity))
        local yaw, pitch = math.rad(V.ChamsLightYaw), math.rad(V.ChamsLightPitch)
        local direction = Vector3.new(math.sin(yaw)*math.cos(pitch),math.sin(pitch),-math.cos(yaw)*math.cos(pitch))
        VisualCache.set(viewport,"LightDirection",V.ChamsCameraLight and camera.CFrame:VectorToWorldSpace(direction) or direction)

        table.clear(wanted)
		for _, item in ipairs(list) do
			local player, character = item[1], item[2]
			if character and character.Parent then
				wanted[player] = item
				local record = records[player]
                if record and record.character~=character then removeRecord(player);record=nil end
				local sourceRoot=character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Head")
                if VisualCache.inView(sourceRoot,camera) and (not record or record.character ~= character or (record.rebuildAt and now >= record.rebuildAt)
                    or (localMode and record.accessories ~= V.LocalChamsAccessories)) then
					addRecord(player, character)
				end
			end
		end
		for player in pairs(records) do
			if not wanted[player] then
				removeRecord(player)
			end
		end

		local cameraPosition = camera.CFrame.Position
		local maxDistance = math.clamp(tonumber(V.LitDistance) or 15000, 1, 100000)

		scanTimer = scanTimer - dt
		if not localMode and scanTimer <= 0 then
			scanTimer = 0.10
			updateVisibility(camera, maxDistance, now)
		end

        local anyRendered=false
		for player, record in pairs(records) do
			local item = wanted[player]
			local character = record.character
			refreshRecord(record)
			local root, humanoid = record.root, record.humanoid

			local distance = root and (root.Position - cameraPosition).Magnitude or math.huge
			local alive = humanoid ~= nil and (humanoid.Health > 0 or (not localMode and V.ShowDead))
			local inView=VisualCache.inView(root,camera)
            local target = (root ~= nil and alive and distance <= maxDistance and inView) and 1 or 0
            if target==1 then anyRendered=true end
			record.alpha = target

			if record.alpha < 0.004 and target == 0 then
				if not record.hidden then
					record.hidden = true
                    record.renderAt=nil
                    record.poseAt=nil
                                                                                         
                    record.model.Parent=nil
				end
			elseif VisualCache.shouldUpdate(record,now,distance,record.hidden or record.renderRole~=item[3]) then
                local poseDt=math.clamp(now-(record.poseAt or now-dt),0,0.1)
                record.poseAt,record.renderRole=now,item[3]
                if record.model.Parent~=world then record.model.Parent=world end
				record.hidden = false

				local seenTarget = record.visible and 1 or 0
				record.visMix = record.visMix + (seenTarget - record.visMix) * (1-math.exp(-poseDt*12))

                for sourceJoint, copyJoint in pairs(record.joints) do
                    if sourceJoint.Parent and copyJoint.Parent then
                        VisualCache.set(copyJoint,"Transform",sourceJoint.Transform)
                        VisualCache.set(copyJoint,"C0",sourceJoint.C0)
                        VisualCache.set(copyJoint,"C1",sourceJoint.C1)
                    end
                end
                local roleColor = item[3]

                local hiddenColor = isWhite(roleColor) and roleColor
                    or roleColor:Lerp(Color3.new(0,0,0),0.08)
                local baseColor = localMode and roleColor or hiddenColor:Lerp(roleColor,record.visMix)

				for source, copy in pairs(record.parts) do
					if source:IsDescendantOf(character) then
                        VisualCache.set(copy,"CFrame",source.CFrame)
                        if copy:IsA("MeshPart") then
                            local fidelity=distance>1000 and Enum.RenderFidelity.Automatic or Enum.RenderFidelity.Precise
                            if copy.RenderFidelity~=fidelity then copy.RenderFidelity=fidelity end
                        end
                        if copy.Size ~= source.Size then copy.Size = source.Size end
                        local skeleton = record.bones[source]
                        if skeleton then
                            for _,pair in ipairs(skeleton) do
                                if pair[1]:IsDescendantOf(source) and pair[2].Parent then
                                    VisualCache.set(pair[2],"CFrame",pair[1].CFrame)
                                    VisualCache.set(pair[2],"Transform",pair[1].Transform)
                                end
                            end
                        end
						local sourceAlpha = (1-source.Transparency)*(1-source.LocalTransparencyModifier)

                        local visibleSource = source.Name ~= "HumanoidRootPart" and sourceAlpha > 0.05
                        local finalTransparency = visibleSource and 0 or 1
                        if visibleSource and styleName()=="Glow" then
                            finalTransparency=math.clamp(localMode and V.LocalChamsTransparency or V.LitAlpha,0,1)
                        end
                        if visibleSource and localMode and styleName() == "ForceField"
                            and not nativeLocalForceField(source, copy) then
                                                                                   
                            finalTransparency = 0.2 + 0.06 * (0.5 + 0.5 * math.sin(now * 3))
                        end
						if copy.Transparency ~= finalTransparency then
							VisualCache.set(copy,"Transparency",finalTransparency)
						end
						if visibleSource and finalTransparency < 0.999 then
							local pair = record.meshes[source]
							if pair then
								local mesh, meshCopy = pair[1], pair[2]
								VisualCache.set(meshCopy,"Scale",mesh.Scale)
								VisualCache.set(meshCopy,"Offset",mesh.Offset)
								if mesh:IsA("SpecialMesh") then
									VisualCache.set(meshCopy,"MeshType",mesh.MeshType)
									VisualCache.set(meshCopy,"MeshId",mesh.MeshId)
                                    VisualCache.set(meshCopy,"TextureId","")
                                    VisualCache.set(meshCopy,"VertexColor",Vector3.new(1,1,1))
								end
							end
                            local color
                            if localMode and (styleName() == "Neon" or styleName() == "ForceField") then
                                color = baseColor
                            else
                                color = surfaceColor(baseColor,source,root,now,styleName())
                            end
                            if copy.Color ~= color then copy.Color = color end

						end
                        updateHalo(record,source,copy,visibleSource,now)
					else
                        clearHalo(record,source)
						record.parts[source], record.meshes[source], record.bones[source] = nil, nil, nil
						copy:Destroy()
					end
				end
			end
		end
        VisualCache.set(viewport,"Visible",anyRendered)
	end

	local function destroy()
		clearAll()
		if viewport then
			pcall(function()
				viewport:Destroy()
			end)
			viewport, world, renderCamera = nil, nil, nil
		end
	end
    return step, destroy
    end
    XT.litStep, V.RestoreLit = createChamsRenderer(false)

local function createLocalHighlightRenderer()
        local highlights={}
        local wanted={}
        local function clear()
            for key,h in pairs(highlights) do h:Destroy(); highlights[key]=nil end
        end
        local function step(list)
            local item=list and list[1]
            local character=item and item[2]
            local full=V.LocalChamsStyle=="Highlight"
            if not V.LocalChamsEnabled or V.VoteRespawning or V.VoteDupeRunning or os.clock()<(V.VisualRespawnQuietUntil or 0) or not character or not character.Parent or V.Destroying or V.Destroyed
                or (not full and not V.LocalChamsOutline) then clear(); return end
            table.clear(wanted)
            if V.LocalChamsAccessories then wanted[character]=true else
                for _,part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name~="HumanoidRootPart" and string.sub(part.Name,1,7)~="Waraku_" then wanted[part]=true end
                end
            end
            for key,h in pairs(highlights) do
                if not wanted[key] then h:Destroy(); highlights[key]=nil end
            end
            for key in pairs(wanted) do
                local h=highlights[key]
                if not h then
                    h=Instance.new("Highlight"); h.Name="Waraku_LOCAL_HIGHLIGHT"
                    h.Adornee=key; h.Parent=ESPGui; highlights[key]=h
                end
                VisualCache.set(h,"FillColor",item[3] or V.LocalChamsColor)
                VisualCache.set(h,"OutlineColor",V.LocalChamsOutlineColor)
                VisualCache.set(h,"FillTransparency",full and math.clamp(V.LocalChamsTransparency,0,1) or 1)
                VisualCache.set(h,"OutlineTransparency",V.LocalChamsOutline and math.clamp(V.LocalChamsOutlineAlpha,0,1) or 1)
                h.DepthMode=Enum.HighlightDepthMode.Occluded; h.Enabled=true
            end
        end
        return step,clear
    end
    local localRender,clearRender=createChamsRenderer(true)
    local localHighlight,clearHighlight=createLocalHighlightRenderer()
    XT.localLitStep=function(list) localRender(list); localHighlight(list) end
    V.RestoreLocalChams=function() clearRender(); clearHighlight() end

end

do
	local sqrt, atan2, deg, clamp, floor = math.sqrt, math.atan2, math.deg, math.clamp, math.floor

	local layer = Instance.new("Frame")
	layer.Name = "SKELETON_LAYER"
	layer.BackgroundTransparency = 1
	layer.BorderSizePixel = 0
	layer.Size = UDim2.fromScale(1, 1)
	layer.ZIndex = 3
	layer.Parent = Overlay

	local states = {}

	local R15_PARTS = {
		"Head", "UpperTorso", "LowerTorso", "LeftUpperArm", "LeftLowerArm", "LeftHand",
		"RightUpperArm", "RightLowerArm", "RightHand", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
		"RightUpperLeg", "RightLowerLeg", "RightFoot",
	}
	local R6_PARTS = { "Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg" }

	local R15_BONES = {
		{ "headBase", "neck" }, { "neck", "chest" }, { "chest", "waist" },
		{ "ls", "chest" }, { "chest", "rs" },
		{ "ls", "le" }, { "le", "lw" }, { "lw", "lhand" },
		{ "rs", "re" }, { "re", "rw" }, { "rw", "rhand" },
		{ "waist", "lh" }, { "waist", "rh" },
		{ "lh", "lk" }, { "lk", "la" }, { "la", "lfoot" },
		{ "rh", "rk" }, { "rk", "ra" }, { "ra", "rfoot" },
	}
	local R6_BONES = {
		{ "headBase", "neck" }, { "neck", "chest" }, { "chest", "waist" },
		{ "ls", "chest" }, { "chest", "rs" },
		{ "ls", "le" }, { "le", "lhand" }, { "rs", "re" }, { "re", "rhand" },
		{ "waist", "lh" }, { "waist", "rh" },
		{ "lh", "lk" }, { "lk", "lfoot" }, { "rh", "rk" }, { "rk", "rfoot" },
	}

	local function newLine()
		local frame = Instance.new("Frame")
		frame.AnchorPoint = Vector2.new(0.5, 0.5)
		frame.BorderSizePixel = 0
		frame.BackgroundColor3 = Color3.new(1, 1, 1)
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(1,0)
		corner.Parent = frame
		frame.ZIndex = 3
		frame.Visible = false
		frame.Parent = layer
		return frame
	end

	local function newHead()
		local frame = Instance.new("Frame")
		frame.AnchorPoint = Vector2.new(0.5, 0.5)
		frame.BackgroundTransparency = 1
		frame.BorderSizePixel = 0
		frame.ZIndex = 3
		frame.Visible = false
		frame.Parent = layer

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(1, 0)
		corner.Parent = frame

		local stroke = Instance.new("UIStroke")
		stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		stroke.Thickness = 1
		stroke.Parent = frame
		return frame
	end

	local function buildRig(character)
		local r15 = character:FindFirstChild("UpperTorso") ~= nil
		local rig = { character = character, r15 = r15, parts = {}, motors = {}, built = os.clock(), incomplete = false }
		for _, name in ipairs(r15 and R15_PARTS or R6_PARTS) do
			local part = character:FindFirstChild(name)
			if part and part:IsA("BasePart") then
				rig.parts[name] = part
			else
				rig.incomplete = true
			end
		end
		for _,object in ipairs(character:GetDescendants()) do
			if object:IsA("Motor6D") then rig.motors[object.Name] = object end
		end
		return rig
	end

	local function at(part, x, y)
		if not part then
			return nil
		end
		local size = part.Size
		return part.CFrame * Vector3.new(x * size.X, y * size.Y, 0)
	end

	local function center(part)
		return part and part.Position or nil
	end

	local function joint(rig,partA,partB,attachment,motorName,fallback)
		local a = partA and partA:FindFirstChild(attachment)
		local b = partB and partB:FindFirstChild(attachment)
		if a and a:IsA("Attachment") and b and b:IsA("Attachment") then
			return (a.WorldPosition+b.WorldPosition)*0.5
		elseif b and b:IsA("Attachment") then return b.WorldPosition
		elseif a and a:IsA("Attachment") then return a.WorldPosition end
		local motor = rig.motors[motorName]
		if motor and motor.Parent and motor.Part1 == partB and partB then
			return (partB.CFrame*motor.C1).Position
		end
		return fallback
	end

	local function computeJoints(rig,j)
		local p = rig.parts
		table.clear(j)
		j.head = center(p.Head)
		j.headBase = at(p.Head,0,-0.43)
		if rig.r15 then
			local ut,lt = p.UpperTorso,p.LowerTorso
			j.neck = joint(rig,ut,p.Head,"NeckRigAttachment","Neck",at(ut,0,0.5))
			j.waist = joint(rig,lt,ut,"WaistRigAttachment","Waist",at(ut,0,-0.5))
			local function limb(side,prefix,sign)
				local ua,la,hand = p[side.."UpperArm"],p[side.."LowerArm"],p[side.."Hand"]
				local ul,ll,foot = p[side.."UpperLeg"],p[side.."LowerLeg"],p[side.."Foot"]
				j[prefix.."s"] = joint(rig,ut,ua,side.."ShoulderRigAttachment",side.."Shoulder",at(ut,sign*0.5,0.35))
				j[prefix.."e"] = joint(rig,ua,la,side.."ElbowRigAttachment",side.."Elbow",at(ua,0,-0.5))
				j[prefix.."w"] = joint(rig,la,hand,side.."WristRigAttachment",side.."Wrist",at(la,0,-0.5))
				j[prefix.."hand"] = at(hand,0,-0.18)
				j[prefix.."h"] = joint(rig,lt,ul,side.."HipRigAttachment",side.."Hip",at(lt,sign*0.25,-0.4))
				j[prefix.."k"] = joint(rig,ul,ll,side.."KneeRigAttachment",side.."Knee",at(ul,0,-0.5))
				j[prefix.."a"] = joint(rig,ll,foot,side.."AnkleRigAttachment",side.."Ankle",at(ll,0,-0.5))
				j[prefix.."foot"] = at(foot,0,-0.15)
			end
			limb("Left","l",-1); limb("Right","r",1)
		else
			local torso = p.Torso
			j.neck = joint(rig,torso,p.Head,"NeckRigAttachment","Neck",at(torso,0,0.5))
			j.waist = at(torso,0,-0.42)
			local function limb(side,prefix,sign)
				local arm,leg = p[side.." Arm"],p[side.." Leg"]
				j[prefix.."s"] = joint(rig,torso,arm,side.."ShoulderRigAttachment",side.." Shoulder",at(torso,sign*0.5,0.35))
				j[prefix.."h"] = joint(rig,torso,leg,side.."HipRigAttachment",side.." Hip",at(torso,sign*0.25,-0.5))

				j[prefix.."e"],j[prefix.."hand"] = at(arm,0,0),at(arm,0,-0.43)
				j[prefix.."k"],j[prefix.."foot"] = at(leg,0,0),at(leg,0,-0.43)
			end
			limb("Left","l",-1); limb("Right","r",1)
		end
		local torso = p.UpperTorso or p.Torso
		j.chest = at(torso,0,0.25)
	end

    XT.buildSkeletonRig = buildRig
    XT.computeSkeletonJoints = computeJoints
    XT.skeletonBones = {R15 = R15_BONES, R6 = R6_BONES}

	local joints, screen = {}, {}

	local function project(key)
		local cached = screen[key]
		if cached ~= nil then
			return cached
		end
		local world = joints[key]
		local result = false
		if world then
			local point, _, depth = viewPoint(world)
			if point and depth and depth > 0 then
				result = point
			end
		end
		screen[key] = result
		return result
	end

	local function setLine(frame, a, b, thickness, color)
		local dx, dy = b.X - a.X, b.Y - a.Y
		local length = sqrt(dx * dx + dy * dy)
		if length < 0.5 then
			frame.Visible = false
			return false
		end
		frame.Position = UDim2.fromOffset((a.X + b.X) * 0.5, (a.Y + b.Y) * 0.5)
		frame.Size = UDim2.fromOffset(length+thickness*0.5,thickness)
		frame.Rotation = deg(atan2(dy, dx))
		frame.BackgroundColor3 = color
		frame.BackgroundTransparency = 1-clamp(V.SkeletonTransparency or 1,0,1)
		frame.Visible = true
		return true
	end

	local function hideState(state)
        state.renderAt=nil
		for _, line in ipairs(state.lines) do
			line.Visible = false
		end
		state.head.Visible = false
	end

	local function drawPlayer(player, character, color, thickness)
		local state = states[player]
		if not state then
			state = { lines = {}, head = newHead(), rig = nil }
			states[player] = state
		end

        local root=character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
        local camera=Workspace.CurrentCamera
        local distance=root and camera and (root.Position-camera.CFrame.Position).Magnitude or 0
        if not VisualCache.shouldUpdate(state,os.clock(),distance,state.renderCharacter~=character or state.renderColor~=color or state.renderThickness~=thickness,camera and camera.CFrame) then return end
        state.renderCharacter,state.renderColor,state.renderThickness=character,color,thickness
		local rig = state.rig
		local stale = false
		if rig then
			for _,part in pairs(rig.parts) do
				if part.Parent ~= character then stale = true; break end
			end
		end
		if not rig or rig.character ~= character or stale
			or os.clock()-rig.built > (rig.incomplete and 0.5 or 2) then
			rig = buildRig(character)
			state.rig = rig
		end

		computeJoints(rig, joints)
		table.clear(screen)

		local bones = rig.r15 and R15_BONES or R6_BONES
		local used = 0
		for _, bone in ipairs(bones) do
			local a, b = project(bone[1]), project(bone[2])
			if a and b then
				used += 1
				local line = state.lines[used]
				if not line then
					line = newLine()
					state.lines[used] = line
				end
				if not setLine(line, a, b, thickness, color) then
					used -= 1
				end
			end
		end
		for i = used + 1, #state.lines do
			state.lines[i].Visible = false
		end

		local head = rig.parts.Head
		local headPoint = project("head")
		if head and headPoint then
			local camera = Workspace.CurrentCamera
			local top = viewPoint(head.Position + camera.CFrame.UpVector * (head.Size.Y * 0.5))
			local radius = top and clamp((top - headPoint).Magnitude, 2, 40) or 4
			local frame = state.head
			frame.Position = UDim2.fromOffset(headPoint.X, headPoint.Y)
			frame.Size = UDim2.fromOffset(radius * 2, radius * 2)
			local stroke = frame:FindFirstChildOfClass("UIStroke")
			if stroke then
				stroke.Color = color
				stroke.Thickness = thickness
				stroke.Transparency = 1-clamp(V.SkeletonTransparency or 1,0,1)
			end
			frame.Visible = true
		else
			state.head.Visible = false
		end
	end

	local function hideAll()
		for _, state in pairs(states) do
			hideState(state)
		end
	end

    V.RestoreSkeleton = function()
        for player, state in pairs(states) do
            for _, line in ipairs(state.lines or {}) do destroyGui(line) end
            destroyGui(state.head)
            states[player] = nil
        end
    end

	local function step()
		if not (V.SkeletonEnabled and V.Enabled) then
			hideAll()
			return
		end

		local camera = Workspace.CurrentCamera
		if not camera then
			hideAll()
			return
		end
		Camera = camera

		if V.RoundOnly and not isRoundActive() then
			hideAll()
			return
		end

		local thickness = clamp(floor((tonumber(V.SkeletonThickness) or 1) + 0.5), 1, 3)
		local cameraPosition = camera.CFrame.Position
		local seen = {}

		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer then
				local data = playerData(player)
				if allowed(player, data) then
					local root, _, character = aliveRoot(player)
					if root and character and (root.Position - cameraPosition).Magnitude <= V.MaxDistance then
						seen[player] = true
						local color = V.SkeletonRoleColor and visualRoleColor(player, data) or V.SkeletonColor
						local ok, err = pcall(drawPlayer, player, character, color, thickness)
						if not ok then
							if states[player] then hideState(states[player]) end
							local message = tostring(err)
							if V._skeletonError ~= message then
								V._skeletonError = message

							end
						end
					end
				end
			end
		end

		for player, state in pairs(states) do
			if not seen[player] then
				hideState(state)
				if player.Parent ~= Players then
					for _,line in ipairs(state.lines) do line:Destroy() end
					state.head:Destroy()
					states[player] = nil
				end
			end
		end
	end

	con(RunService.RenderStepped, function()
		local ok, err = pcall(step)
		if not ok then
			local message = tostring(err)
			if V._skeletonError ~= message then
				V._skeletonError = message

			end
		end
	end)

end

do
	local CONE_MESH = "rbxassetid://1033714"

	local cone
	local loading, failed = false, false
	local shown = false
	local lastSizeKey, lastColor, lastAlpha, lastMaterial

	local function prepare(part)
		part.Name = "Waraku_CHINA_HAT"
		part.Anchored = true
		part.CanCollide = false
		part.CanQuery = false
		part.CanTouch = false
		part.CastShadow = false
		part.Massless = true
		part.TopSurface = Enum.SurfaceType.Smooth
		part.BottomSurface = Enum.SurfaceType.Smooth
		pcall(function()
			part.DoubleSided = true
		end)
		return part
	end

	local function loadCone()
		if loading or cone or failed then
			return
		end
		loading = true

		task.spawn(function()
			local made

			local okAsync, meshPart = pcall(function()
				return game:GetService("InsertService"):CreateMeshPartAsync(
					CONE_MESH, Enum.CollisionFidelity.Box, Enum.RenderFidelity.Automatic
				)
			end)
			if okAsync and typeof(meshPart) == "Instance" then
				made = meshPart
			end

			if not made then
				local okNew, fallback = pcall(function()
					local part = Instance.new("MeshPart")
					part.MeshId = CONE_MESH
					return part
				end)
				if okNew and fallback then
					pcall(function()
						game:GetService("ContentProvider"):PreloadAsync({ fallback })
					end)
					made = fallback
				end
			end

			if made then
				cone = prepare(made)
			else
				failed = true

			end
			loading = false
		end)
	end

	local function hide()
		if shown then
			shown = false
			if cone then
				cone.Parent = nil
			end
		end
	end

	local function update()
		if not V.ChinaHatEnabled then
			hide()
			return
		end

		if not cone then
			loadCone()
			return
		end

		local character = LocalPlayer.Character
		local head = character and character:FindFirstChild("Head")
		local hum = character and character:FindFirstChildOfClass("Humanoid")
		if not (head and head:IsA("BasePart") and hum and hum.Health > 0) then
			hide()
			return
		end

		local camera = Workspace.CurrentCamera
		if V.ChinaHatHideFirstPerson and camera
			and (camera.CFrame.Position - head.Position).Magnitude < 1.5
		then
			hide()
			return
		end

		local height = math.clamp(V.ChinaHatHeight, 0.2, 6)
		local radius = math.clamp(V.ChinaHatRadius, 0.3, 6)
		local sizeKey = height * 1000 + radius
		if sizeKey ~= lastSizeKey then
			lastSizeKey = sizeKey
			cone.Size = Vector3.new(radius * 2, height, radius * 2)
		end

		local color = V.ChinaHatColor
		if color ~= lastColor then
			lastColor = color
			cone.Color = color
		end

		local alpha = math.clamp(V.ChinaHatTransparency, 0, 0.95)
		if alpha ~= lastAlpha then
			lastAlpha = alpha
			cone.Transparency = alpha
		end

		local material = V.ChinaHatGlow and Enum.Material.Neon or Enum.Material.SmoothPlastic
		if material ~= lastMaterial then
			lastMaterial = material
			cone.Material = material
		end

		local look = head.CFrame.LookVector
		local flat = Vector3.new(look.X, 0, look.Z)
		flat = flat.Magnitude > 0.001 and flat.Unit or Vector3.new(0, 0, -1)
		local right = flat:Cross(Vector3.yAxis)

		local base = head.Position
			+ Vector3.new(0, head.Size.Y * 0.5 + V.ChinaHatOffset, 0)
			+ flat * V.ChinaHatForward
			+ right * V.ChinaHatSide

		local orientation = V.ChinaHatFlip and CFrame.Angles(math.pi, 0, 0) or CFrame.identity
		cone.CFrame = CFrame.new(base + Vector3.new(0, height * 0.5, 0)) * orientation

		if camera and cone.Parent ~= camera then
			cone.Parent = camera
		end
		shown = true
	end

	V.RestoreHat = function()
		shown = false
		if cone then
			pcall(function()
				cone:Destroy()
			end)
			cone = nil
		end
	end

	con(RunService.RenderStepped, function()
		pcall(update)
	end)
end

local drawHealth, hideHealth

do
	local floor, ceil, clamp, exp, sin, abs =
		math.floor, math.ceil, math.clamp, math.exp, math.sin, math.abs

	hideHealth = function(e)
		VisualCache.set(e.HealthBack,"Visible",false)
		VisualCache.set(e.HealthFill,"Visible",false)
	end

	local function ensureUI(e)
		if e.HealthInner then
			return
		end

		local back, fill = e.HealthBack, e.HealthFill

		if e.HealthGradient then
			VisualCache.set(e.HealthGradient,"Enabled",false)
		end
		VisualCache.set(fill,"BackgroundTransparency",1)
		VisualCache.set(fill,"ClipsDescendants",true)
		VisualCache.set(fill,"ZIndex",5)

		local trail = guiFrame(back, 4)
		VisualCache.set(trail,"Name","Trail")
		VisualCache.set(trail,"BorderSizePixel",0)
		VisualCache.set(trail,"Visible",false)
		e.HealthTrail = trail

		local inner = guiFrame(fill, 5)
		VisualCache.set(inner,"Name","Inner")
		VisualCache.set(inner,"BorderSizePixel",0)
		e.HealthInner = inner

		local grad = Instance.new("UIGradient")
		VisualCache.set(grad,"Parent",inner)
		e.HealthInnerGrad = grad

		local ticks = {}
		for i = 1, 3 do
			local tick = guiFrame(back, 6)
			VisualCache.set(tick,"Name","Tick" .. i)
			VisualCache.set(tick,"BorderSizePixel",0)
			VisualCache.set(tick,"BackgroundColor3",Color3.new(0, 0, 0))
			VisualCache.set(tick,"BackgroundTransparency",0.3)
			VisualCache.set(tick,"Visible",false)
			ticks[i] = tick
		end
		e.HealthTicks = ticks

		local text = Instance.new("TextLabel")
		VisualCache.set(text,"Name","HealthText")
		VisualCache.set(text,"BackgroundTransparency",1)
		VisualCache.set(text,"BorderSizePixel",0)
		VisualCache.set(text,"AutomaticSize",Enum.AutomaticSize.XY)
		VisualCache.set(text,"Font",Enum.Font.Code)
		VisualCache.set(text,"TextSize",10)
		VisualCache.set(text,"TextColor3",Color3.new(1, 1, 1))
		VisualCache.set(text,"ZIndex",7)
		VisualCache.set(text,"Visible",false)
		VisualCache.set(text,"Parent",back)

		local stroke = Instance.new("UIStroke")
		stroke.Name = "Stroke"
		stroke.Thickness = 1
		stroke.Color = Color3.new(0, 0, 0)
		stroke.Transparency = 0.2
		stroke.Parent = text

		e.HealthText = text
	end

	local function barColor(mode, ratio, role)
		if mode == "Role" and typeof(role) == "Color3" then
			return role
		elseif mode == "Health" then
			return V.HealthLowColor:Lerp(V.HealthColor, ratio)
		elseif mode == "Custom" then
			return V.HealthColor
		end
		return V.HealthGradient2:Lerp(V.HealthGradient1, ratio)
	end

	drawHealth = function(e, ch, bw, bh, role, now, sampleHealth, sampleMax)
        local maxHp, health
        if sampleHealth ~= nil then
            maxHp = tonumber(sampleMax) or 100
            health = tonumber(sampleHealth) or 0
        else
            local hum = e.HpHum
            if not hum or hum.Parent ~= ch then
                hum = ch:FindFirstChildOfClass("Humanoid")
                e.HpHum = hum
            end
            if not hum then hideHealth(e); return 0, 0 end
            maxHp, health = hum.MaxHealth, hum.Health
        end
        if maxHp ~= maxHp or maxHp <= 0 or maxHp == math.huge then hideHealth(e); return 0, 0 end
        if health ~= health then health = 0 end
        ensureUI(e)
        local target = clamp(health, 0, maxHp) / maxHp
        local dt = clamp(now - (e.HpT or now), 0, 0.1)
		e.HpT = now
		if e.HpChar ~= ch or e.HpShown == nil then
			e.HpChar = ch
			e.HpShown = target
			e.HpTrailV = target
			e.HpLast = target
			e.HpHitAt = 0
		end
		if target < e.HpLast - 0.001 then
			e.HpHitAt = now
		end
		e.HpLast = target

		local shown = e.HpShown
		if V.HealthSmooth then
			shown = shown + (target - shown) * (1 - exp(-math.max(1, tonumber(V.HealthSmoothSpeed) or 10) * dt))
			if abs(target - shown) <= math.max(0.0005, 0.5 / math.max(1, bw, bh)) then
				shown = target
			end
		else
			shown = target
		end
        shown = clamp(shown, 0, 1)
		e.HpShown = shown

		local trailV = e.HpTrailV
		if shown >= trailV then
			trailV = shown
		elseif now - e.HpHitAt > 0.35 then
			trailV = trailV + (shown - trailV) * (1 - exp(-4 * dt))
			if trailV - shown < 0.0005 then
				trailV = shown
			end
		end
        if not V.HealthTrail then trailV = shown end
        trailV = clamp(trailV, shown, 1)
		e.HpTrailV = trailV

		local pos = V.HealthPosition
		local thick = clamp(floor((tonumber(V.HealthThickness) or 4) + 0.5), 2, 12)
		local gap = clamp(floor((tonumber(V.HealthGap) or 3) + 0.5), 0, 12)
		local horizontal = pos == "Bottom" or pos == "Top"
		local length = math.max(0, floor((horizontal and bw or bh) + 0.5))
        local fillPixels = clamp(floor(length * shown + 0.5), 0, length)
        local trailPixels = clamp(floor(length * trailV + 0.5), fillPixels, length)
        e.HpFillPixels, e.HpLength = fillPixels, length

		local back = e.HealthBack
		if pos == "Bottom" then
			rect(back, 0, bh + gap, bw, thick)
		elseif pos == "Top" then
			rect(back, 0, -(gap + thick), bw, thick)
		elseif pos == "Right" then
			rect(back, bw + gap, 0, thick, bh)
		else
			rect(back, -(gap + thick), 0, thick, bh)
		end
		VisualCache.set(back,"BackgroundTransparency",V.HealthBackAlpha)
		local backStroke = back:FindFirstChild("Stroke")
		if backStroke then
			backStroke.Enabled = V.HealthOutline
		end

		local fill, inner, trail = e.HealthFill, e.HealthInner, e.HealthTrail
		local grad = e.HealthInnerGrad
		local mode = V.HealthColorMode

		VisualCache.set(fill,"Visible",fillPixels > 0)
		if horizontal then
			VisualCache.set(fill,"AnchorPoint",Vector2.new(0, 0))
			VisualCache.set(fill,"Position",UDim2.new(0, 0, 0, 0))
			VisualCache.set(fill,"Size",UDim2.fromOffset(fillPixels, thick))
			VisualCache.set(inner,"AnchorPoint",Vector2.new(0, 0))
			VisualCache.set(inner,"Position",UDim2.new(0, 0, 0, 0))
			VisualCache.set(inner,"Size",UDim2.fromOffset(length, thick))
			VisualCache.set(grad,"Rotation",0)
			VisualCache.gradient(grad,V.HealthGradient2,V.HealthGradient1)

			VisualCache.set(trail,"AnchorPoint",Vector2.new(0, 0))
			VisualCache.set(trail,"Position",UDim2.new(0, 0, 0, 0))
			VisualCache.set(trail,"Size",UDim2.fromOffset(trailPixels, thick))
		else
			VisualCache.set(fill,"AnchorPoint",Vector2.new(0, 1))
			VisualCache.set(fill,"Position",UDim2.new(0, 0, 1, 0))
			VisualCache.set(fill,"Size",UDim2.fromOffset(thick, fillPixels))
			VisualCache.set(inner,"AnchorPoint",Vector2.new(0, 1))
			VisualCache.set(inner,"Position",UDim2.new(0, 0, 1, 0))
			VisualCache.set(inner,"Size",UDim2.fromOffset(thick, length))
			VisualCache.set(grad,"Rotation",90)
			VisualCache.gradient(grad,V.HealthGradient1,V.HealthGradient2)

			VisualCache.set(trail,"AnchorPoint",Vector2.new(0, 1))
			VisualCache.set(trail,"Position",UDim2.new(0, 0, 1, 0))
			VisualCache.set(trail,"Size",UDim2.fromOffset(thick, trailPixels))
		end

		local color = barColor(mode, shown, role)
		if mode == "Gradient" then
			VisualCache.set(inner,"BackgroundColor3",Color3.new(1, 1, 1))
			VisualCache.set(grad,"Enabled",true)
		else
			VisualCache.set(inner,"BackgroundColor3",color)
			VisualCache.set(grad,"Enabled",false)
		end

		if V.HealthPulse and target > 0 and target <= 0.3 then
			VisualCache.set(inner,"BackgroundTransparency",0.45 * (0.5 + 0.5 * sin(now * 9)))
			if mode == "Gradient" then
				VisualCache.alpha(grad,0)
			end
		else
			VisualCache.set(inner,"BackgroundTransparency",0)
			VisualCache.alpha(grad,0)
		end

		if V.HealthTrail and trailPixels > fillPixels then
			VisualCache.set(trail,"BackgroundColor3",V.HealthTrailColor)
			VisualCache.set(trail,"Visible",true)
		else
			VisualCache.set(trail,"Visible",false)
		end

		local ticks = e.HealthTicks
		for i = 1, 3 do
			local tick = ticks[i]
			if V.HealthSegments then
				if horizontal then
					VisualCache.set(tick,"AnchorPoint",Vector2.new(0.5, 0))
					VisualCache.set(tick,"Position",UDim2.new(i / 4, 0, 0, 0))
					VisualCache.set(tick,"Size",UDim2.fromOffset(1, thick))
				else
					VisualCache.set(tick,"AnchorPoint",Vector2.new(0, 0.5))
					VisualCache.set(tick,"Position",UDim2.new(0, 0, 1 - i / 4, 0))
					VisualCache.set(tick,"Size",UDim2.fromOffset(thick, 1))
				end
				VisualCache.set(tick,"Visible",true)
			else
				VisualCache.set(tick,"Visible",false)
			end
		end

		local text = e.HealthText
		local textSize = XT.textSize(V.HealthTextSize)
		local textExtra = 0

		if V.HealthTextEnabled and not (V.HealthTextHideFull and target >= 0.999) then
			local hp = shown * maxHp
			local str
			if V.HealthTextMode == "Percent" then
				str = math.max(0, ceil(shown * 100 - 0.0001)) .. "%"
			elseif V.HealthTextMode == "HP/Max" then
				str = math.max(0, ceil(hp - 0.0001)) .. "/" .. ceil(maxHp - 0.0001)
			else
				str = tostring(math.max(0, ceil(hp - 0.0001)))
			end

            str = tostring(str)
			if e.HpTextStr ~= str then
				e.HpTextStr = str
				VisualCache.set(text,"Text",str)
			end
			if e.HpTextSize ~= textSize then
				e.HpTextSize = textSize
				VisualCache.set(text,"TextSize",textSize)
			end
			local healthFont = XT.font(V.HealthTextFont)
			if e.HpTextFont ~= healthFont then
				e.HpTextFont = healthFont
				VisualCache.set(text,"Font",healthFont)
			end

			local textMode = V.HealthTextColorMode
			if textMode == "White" then
				VisualCache.set(text,"TextColor3",Color3.new(1, 1, 1))
			elseif textMode == "Custom" then
				VisualCache.set(text,"TextColor3",V.HealthTextColor)
			else
				VisualCache.set(text,"TextColor3",color)
			end

			local bounds = text.TextBounds
			local tw = bounds.X > 0 and bounds.X or (#str * textSize * 0.6)
			local tth = bounds.Y > 0 and bounds.Y or (textSize + 2)

			if horizontal then
				local half = tw * 0.5
				local cx = V.HealthTextFollow and (length * shown) or (length * 0.5)
				cx = clamp(cx, half, math.max(half, length - half))
				if pos == "Bottom" then
					VisualCache.set(text,"AnchorPoint",Vector2.new(0.5, 0))
					VisualCache.set(text,"Position",UDim2.fromOffset(cx, thick + 2))
				else
					VisualCache.set(text,"AnchorPoint",Vector2.new(0.5, 1))
					VisualCache.set(text,"Position",UDim2.fromOffset(cx, -2))
				end
				textExtra = floor(tth) + 3
			else
				local half = tth * 0.5
				local cy = V.HealthTextFollow and (length * (1 - shown)) or (length * 0.5)
				cy = clamp(cy, half, math.max(half, length - half))
				if pos == "Left" then
					VisualCache.set(text,"AnchorPoint",Vector2.new(1, 0.5))
					VisualCache.set(text,"Position",UDim2.fromOffset(-3, cy))
				else
					VisualCache.set(text,"AnchorPoint",Vector2.new(0, 0.5))
					VisualCache.set(text,"Position",UDim2.fromOffset(thick + 3, cy))
				end
			end
			VisualCache.set(text,"Visible",true)
		else
			VisualCache.set(text,"Visible",false)
		end

		if pos == "Bottom" then
			return 0, gap + thick + textExtra
		elseif pos == "Top" then
			return gap + thick + textExtra, 0
		end
		return 0, 0
	end
end

local function drawPlayerESP(p, d, preview)
    if not V.Enabled then
        if preview then setHidden(preview.Visual) end
        return
    end
    if not preview and V.RoundOnly and not isRoundActive() then return end
    local e = preview and preview.Visual or (V.DrawByPlayer and V.DrawByPlayer[p])
    local ch = preview and preview.Api:GetModel() or p.Character
    local root = ch and (ch:FindFirstChild("HumanoidRootPart") or ch:FindFirstChild("UpperTorso") or ch:FindFirstChild("Torso"))
    if not root then setHiddenIdle(e); return end
    local studs, viewportPoint, onScreen
    if preview then
        studs = preview.Distance
        viewportPoint, onScreen = Vector3.zero, true
    else
        Camera = Workspace.CurrentCamera
        if not Camera then setHiddenIdle(e); return end
        studs = (root.Position - Camera.CFrame.Position).Magnitude
        if studs > V.MaxDistance then setHiddenIdle(e); return end
        viewportPoint, onScreen = Camera:WorldToViewportPoint(root.Position)
    end
    e = ensureVisual(p, preview)
    local roleName = preview and preview.Role or visualRoleName(p, d)
    local role = preview and preview.Color or visualRoleColor(p, d)
    if not preview and not VisualCache.shouldUpdate(e, os.clock(), studs, e.renderCharacter ~= ch or e.renderRole ~= role or e.renderRoleName ~= roleName, Camera.CFrame) then return end
    e.renderCharacter, e.renderRole, e.renderRoleName = ch, role, roleName
	if not preview and V.ArrowEnabled and (not onScreen or viewportPoint.Z <= 0) then
		local viewport = Overlay.AbsoluteSize
		if viewport.X <= 0 or viewport.Y <= 0 then
			viewport = Camera.ViewportSize
		end
		local middle = Vector2.new(viewport.X * 0.5, viewport.Y * 0.5)
		local direction = Vector2.new(viewportPoint.X, viewportPoint.Y) - middle
		if viewportPoint.Z <= 0 then
			direction = -direction
		end
		if direction.Magnitude < 0.01 then
			direction = Vector2.new(0, -1)
		else
			direction = direction.Unit
		end
		local radius = math.clamp(V.ArrowDistance, 40, math.max(40, math.min(viewport.X, viewport.Y) * 0.48))
		local position = middle + direction * radius
		VisualCache.set(e.Arrow,"TextSize",scaledTextSize(V.ArrowSize))
		local arrowRoles = {
			Murderer = V.ArrowMurdererColor,
			Sheriff = V.ArrowSheriffColor,
			Hero = V.ArrowHeroColor or Color3.fromRGB(255, 215, 0),
			Innocent = V.ArrowInnocentColor,
		}
		VisualCache.set(e.Arrow,"TextColor3",V.ArrowRoleColor and (arrowRoles[roleName] or V.ArrowInnocentColor) or V.ArrowColor)
		VisualCache.set(e.Arrow,"Position",UDim2.fromOffset(position.X, position.Y))
		VisualCache.set(e.Arrow,"Rotation",math.deg(math.atan2(direction.Y, direction.X)) + 90)
		VisualCache.set(e.Arrow,"Visible",true)
	else
		VisualCache.set(e.Arrow,"Visible",false)
	end
	local now = os.clock()
	local c1 = V.BoxRoleColor and role or V.BoxColor
	local c2 = V.BoxGradient and V.BoxGradientColor or c1
	local a, b, center
    if preview then
        if V.AdaptiveESP then
            a, b, center = preview.Api:GetBounds(V.ESPAccessories, V.ESPPadding)
        else
            local humanoid = ch:FindFirstChildOfClass("Humanoid")
            local half = math.clamp(3.15 + (humanoid and humanoid.HipHeight or 2) * 0.16, 3.15, 3.75)
            center = preview.Api:Project(root.Position)
            local top = preview.Api:Project(root.Position + Vector3.yAxis * half)
            local bottom = preview.Api:Project(root.Position - Vector3.yAxis * half)
            if center and top and bottom then
                local height = math.abs(bottom.Y - top.Y)
                local size = Vector2.new(height * 0.26, height * 0.5)
                a, b = center - size, center + size
            end
        end
    else
        a, b, center = boxBounds(ch)
    end
	if not a then
		setHiddenIdle(e,true)
		return
	end
	e.IdleHidden=false

	center = Vector2.new(math.floor(center.X + 0.5), math.floor(center.Y + 0.5))
	local x1, y1, x2, y2 = math.floor(a.X + 0.5), math.floor(a.Y + 0.5), math.floor(b.X + 0.5), math.floor(b.Y + 0.5)
	local bw, bh = x2 - x1, y2 - y1

	local boxVisible=V.BoxEnabled and bw>3 and bh>3
	local isFullBox=V.BoxStyle~="Corner" and V.BoxStyle~=2
	VisualCache.set(e.BoxMain,"Visible",boxVisible and (isFullBox or V.BoxFillEnabled))
	VisualCache.set(e.BoxOuter,"Visible",boxVisible and isFullBox and V.BoxOutline)
	VisualCache.set(e.BoxInner,"Visible",boxVisible and isFullBox and V.BoxOutline)
	for i = 1, 8 do
		VisualCache.set(e.CornerBars[i],"Visible",boxVisible and not isFullBox)
		VisualCache.set(e.CornerOutlines[i],"Visible",boxVisible and not isFullBox and V.BoxOutline)
	end
	VisualCache.set(e.Root,"Visible",(V.BoxEnabled or V.HealthEnabled) and bw>3 and bh>3)

	if (V.BoxEnabled or V.HealthEnabled) and bw > 3 and bh > 3 then
		VisualCache.set(e.Root,"Position",UDim2.fromOffset(x1, y1))
		VisualCache.set(e.Root,"Size",UDim2.fromOffset(bw, bh))
		VisualCache.set(e.Root,"Visible",true)
	end

	if V.BoxEnabled and bw > 3 and bh > 3 then
		local topColor = c1
		local bottomColor = V.BoxGradient and c2 or c1
		local borderTransparency = 1 - V.BoxTransparency
		local boxThick = math.clamp(math.floor((V.BoxThickness or 1) + 0.5), 1, 4)
		local outlineColor = V.BoxOutlineColor or Color3.new(0, 0, 0)

		local isFullBox = V.BoxStyle ~= "Corner" and V.BoxStyle ~= 2
		if isFullBox then
			rect(e.BoxMain, 0, 0, bw, bh)
			VisualCache.set(e.BoxMain,"Visible",true)
			if V.BoxFillEnabled then
				XT.applyBoxFill(e, now)
			else
				VisualCache.set(e.BoxMain,"BackgroundTransparency",1)
			end
			VisualCache.set(e.BoxMainStroke,"Enabled",true)
			VisualCache.set(e.BoxMainStroke,"Thickness",boxThick)
			VisualCache.set(e.BoxMainStroke,"Color",topColor)
			VisualCache.set(e.BoxMainStroke,"Transparency",borderTransparency)
			if V.BoxGradient then
				VisualCache.gradient(e.BoxMainGrad,c1,c2)
				VisualCache.set(e.BoxMainGrad,"Rotation",V.BoxGradientAngle or 90)
				VisualCache.set(e.BoxMainGrad,"Enabled",true)
			else
				VisualCache.set(e.BoxMainGrad,"Enabled",false)
			end

			if V.BoxOutline then
				rect(e.BoxOuter, -boxThick, -boxThick, bw + boxThick * 2, bh + boxThick * 2)
				VisualCache.set(e.BoxOuter,"Visible",true)
				VisualCache.set(e.BoxOuterStroke,"Enabled",true)
				VisualCache.set(e.BoxOuterStroke,"Color",outlineColor)
				VisualCache.set(e.BoxOuterStroke,"Transparency",borderTransparency)
			if bw > 3 and bh > 3 then
					rect(e.BoxInner, 1, 1, bw - 2, bh - 2)
					VisualCache.set(e.BoxInner,"Visible",true)
					VisualCache.set(e.BoxInnerStroke,"Enabled",true)
					VisualCache.set(e.BoxInnerStroke,"Color",outlineColor)
					VisualCache.set(e.BoxInnerStroke,"Transparency",borderTransparency)
				end
			end
		else

			VisualCache.set(e.BoxMainStroke,"Enabled",false)
			VisualCache.set(e.BoxMainGrad,"Enabled",false)
			if V.BoxFillEnabled then
				rect(e.BoxMain, 0, 0, bw, bh)
				XT.applyBoxFill(e, now)
				VisualCache.set(e.BoxMain,"Visible",true)
			else
				VisualCache.set(e.BoxMain,"Visible",false)
				VisualCache.set(e.BoxMain,"BackgroundTransparency",1)
			end

			local cornerFrac = math.clamp(V.BoxCornerLength or 22, 5, 50) / 100
			local cw = math.max(3, math.floor(math.min(bw * cornerFrac, 120)))
			local chh = math.max(3, math.floor(math.min(bh * cornerFrac, 120)))
			local armThick = boxThick

			rect(e.CornerBars[1], 0, 0, cw, armThick)
			rect(e.CornerBars[2], 0, 0, armThick, chh)

			rect(e.CornerBars[3], bw - cw, 0, cw, armThick)
			rect(e.CornerBars[4], bw - armThick, 0, armThick, chh)

			rect(e.CornerBars[5], 0, bh - armThick, cw, armThick)
			rect(e.CornerBars[6], 0, bh - chh, armThick, chh)

			rect(e.CornerBars[7], bw - cw, bh - armThick, cw, armThick)
			rect(e.CornerBars[8], bw - armThick, bh - chh, armThick, chh)

			local barCenters = {
				{ cw * 0.5, armThick * 0.5 }, { armThick * 0.5, chh * 0.5 },
				{ bw - cw * 0.5, armThick * 0.5 }, { bw - armThick * 0.5, chh * 0.5 },
				{ cw * 0.5, bh - armThick * 0.5 }, { armThick * 0.5, bh - chh * 0.5 },
				{ bw - cw * 0.5, bh - armThick * 0.5 }, { bw - armThick * 0.5, bh - chh * 0.5 },
			}
			for i = 1, 8 do
				local barColor = topColor
				if V.BoxGradient then
					local center = barCenters[i]
					barColor = c1:Lerp(c2, XT.gradientT(center[1], center[2], bw, bh, V.BoxGradientAngle))
				end
				VisualCache.set(e.CornerBars[i],"BackgroundColor3",barColor)
				VisualCache.set(e.CornerBars[i],"BackgroundTransparency",borderTransparency)
				VisualCache.set(e.CornerBars[i],"Visible",true)
			end

			if V.BoxOutline then

				rect(e.CornerOutlines[1], -1, -1, cw + 2, armThick + 2)
				rect(e.CornerOutlines[2], -1, -1, armThick + 2, chh + 2)

				rect(e.CornerOutlines[3], bw - cw - 1, -1, cw + 2, armThick + 2)
				rect(e.CornerOutlines[4], bw - armThick - 1, -1, armThick + 2, chh + 2)

				rect(e.CornerOutlines[5], -1, bh - armThick - 1, cw + 2, armThick + 2)
				rect(e.CornerOutlines[6], -1, bh - chh - 1, armThick + 2, chh + 2)

				rect(e.CornerOutlines[7], bw - cw - 1, bh - armThick - 1, cw + 2, armThick + 2)
				rect(e.CornerOutlines[8], bw - armThick - 1, bh - chh - 1, armThick + 2, chh + 2)

				for i = 1, 8 do
					VisualCache.set(e.CornerOutlines[i],"BackgroundColor3",outlineColor)
					VisualCache.set(e.CornerOutlines[i],"BackgroundTransparency",borderTransparency)
					VisualCache.set(e.CornerOutlines[i],"Visible",true)
				end
			end
		end
	end
	local healthTopOff, healthBotOff = 0, 0
	if V.HealthEnabled then
		healthTopOff, healthBotOff = drawHealth(e, ch, bw, bh, role, now, preview and preview.Health or nil, 100)
	else
		hideHealth(e)
	end

	hideSkeleton(e)
	local avatar = e.Avatar
	local showName = V.NameEnabled
	local showDist = V.DistanceEnabled
	local showAvatar = V.AvatarEnabled

	local avatarKind = nil
	if showAvatar then
        if preview then
            e.Avatar.Image = preview.AvatarImage
            avatarKind = "gui"
        else
            avatarKind = requestAvatar(e, p)
        end
	elseif avatar then
		avatar.Visible = false
	end
	if not showAvatar and e.AvatarDraw then
		VisualCache.set(e.AvatarDraw,"Visible",false)
	end
	local avatarLoaded = avatarKind ~= nil
	local avatarSize = math.clamp(math.floor((V.AvatarSize or 30) + 0.5), 12, 64)
	local gap = 4

	local distStr = XT.formatDistance(studs)
	local nameStr = V.NameUseDisplay and p.DisplayName or p.Name
	local labelText = ""
	if showName and showDist then
		labelText = nameStr .. " " .. distStr
	elseif showName then
		labelText = nameStr
	elseif showDist then
		labelText = distStr
	end

	local hasText = labelText ~= ""
	local textW = 0
	local textH = 12

	if hasText then
		local t = e.Name
		local stroke = t:FindFirstChild("Stroke")
		local nameFont = XT.font(V.NameFont)
		local nameSize = XT.textSize(V.NameSize)
		VisualCache.set(t,"Text",labelText)
		VisualCache.set(t,"Font",nameFont)
		VisualCache.set(t,"TextSize",nameSize)
        local gradientOn = showName and V.NameGradient == true
        VisualCache.set(t,"TextColor3",gradientOn and Color3.new(1,1,1) or
            (V.NameRoleColor and role or (V.NameColor or Color3.fromRGB(255,255,255))))
        local grad = t:FindFirstChild("Gradient")
        if grad then
            VisualCache.set(grad,"Enabled",gradientOn)
            if gradientOn then
                VisualCache.gradient(grad,V.NameColor,V.NameGradientColor2)
                VisualCache.set(grad,"Rotation",(V.NameGradientRotation or 0)%360)
            end
        end
		if stroke then
			stroke.Enabled = V.NameOutline ~= false
			stroke.Thickness = math.clamp(V.NameOutlineThickness or 1, 0.5, 3)
			stroke.Color = Color3.new(0, 0, 0)
			stroke.Transparency = 0
		end

		local measure = VisualCache.measure(e,labelText,nameSize,nameFont)
		local padW, padH = XT.nameBackground(e)
		textW = measure.X + padW
		textH = measure.Y + padH
	else
		VisualCache.set(e.Name,"Visible",false)
	end
	VisualCache.set(e.Distance,"Visible",false)

	local labelY = y1 - 2 - healthTopOff - (V.NameOffset or 0)

	if avatarLoaded and hasText then
		local totalW = avatarSize + gap + textW
		local startX = math.floor(center.X - totalW * 0.5 + 0.5)
		local textY = labelY
		local centerY = textY - math.floor(textH * 0.5)

		placeAvatar(e, avatarKind, startX, math.floor(centerY - avatarSize * 0.5 + 0.5), avatarSize)

		VisualCache.set(e.Name,"AnchorPoint",Vector2.new(0, 1))
		VisualCache.set(e.Name,"Position",UDim2.fromOffset(startX + avatarSize + gap, textY))
		VisualCache.set(e.Name,"Visible",true)
	elseif avatarLoaded and not hasText then
		placeAvatar(e, avatarKind, math.floor(center.X - avatarSize * 0.5 + 0.5), math.floor(labelY - avatarSize + 0.5), avatarSize)
		VisualCache.set(e.Name,"Visible",false)
	elseif not avatarLoaded and hasText then
		VisualCache.set(e.Name,"AnchorPoint",Vector2.new(0.5, 1))
		VisualCache.set(e.Name,"Position",UDim2.fromOffset(center.X, labelY))
		VisualCache.set(e.Name,"Visible",true)
		if avatar then avatar.Visible = false end
	else
		if avatar then avatar.Visible = false end
		VisualCache.set(e.Name,"Visible",false)
	end

	if V.RoleFlagEnabled and (preview or roleContextValid(p)) then
		local t = e.RoleFlag
		local stroke = t:FindFirstChild("Stroke")
		VisualCache.set(t,"Text",string.upper(roleName or "UNKNOWN"))
		VisualCache.set(t,"Font",XT.font(V.RoleFlagFont))
		VisualCache.set(t,"TextSize",XT.textSize(V.RoleFlagSize))
		local flagColor = V.RoleFlagColor
		local flagGradient = false
		local flagGradient1, flagGradient2 = flagColor, flagColor
		if V.RoleFlagUseColor and roleName == "Murderer" then
			flagColor = V.RoleFlagMurdererColor
			flagGradient = V.RoleFlagMurdererGradient
			flagGradient1, flagGradient2 = V.RoleFlagMurdererGradient1, V.RoleFlagMurdererGradient2
		elseif V.RoleFlagUseColor and roleName == "Sheriff" then
			flagColor = V.RoleFlagSheriffColor
			flagGradient = V.RoleFlagSheriffGradient
			flagGradient1, flagGradient2 = V.RoleFlagSheriffGradient1, V.RoleFlagSheriffGradient2
		elseif V.RoleFlagUseColor and roleName == "Hero" then
			flagColor = V.RoleFlagHeroColor or Color3.fromRGB(255, 215, 0)
			flagGradient = V.RoleFlagHeroGradient
			flagGradient1, flagGradient2 = V.RoleFlagHeroGradient1 or flagColor, V.RoleFlagHeroGradient2 or flagColor
		elseif V.RoleFlagUseColor then
			flagColor = ROLE.Innocent
		end
		styleLabel(t, flagColor, flagGradient, flagGradient1, flagGradient2)
		VisualCache.set(t,"AnchorPoint",Vector2.new(0.5, 0))
		VisualCache.set(t,"Position",UDim2.fromOffset(center.X, y2 + (V.DistanceEnabled and 17 or 2) + healthBotOff + (V.RoleFlagOffset or 0)))
		if stroke then
			stroke.Enabled = true
			stroke.Thickness = 1
		end
		VisualCache.set(t,"Visible",true)
	else
		VisualCache.set(e.RoleFlag,"Visible",false)
	end
	if V.RoleTracerEnabled then
		local size = preview and preview.Api:GetSize() or Overlay.AbsoluteSize
		local originMode = V.RoleTracerOrigin
		local fromY = math.max(0, size.Y - 2)
		if originMode == "Center" then
			fromY = size.Y * 0.5
		elseif originMode == "Top" then
			fromY = 2
		end
		local from = Vector2.new(size.X * 0.5, fromY)
		placeLine(
			e.RoleTracer, from, center,
			pixelThickness(V.RoleTracerThickness),
			V.RoleTracerUseColor and role or V.RoleTracerColor,
			math.clamp(V.RoleTracerAlpha or 0.9, 0.05, 1)
		)
	else
		VisualCache.set(e.RoleTracer,"Visible",false)
	end
end

local BODY_NAMES = {
	HumanoidRootPart = true,
	Head = true,
	Torso = true,
	UpperTorso = true,
	LowerTorso = true,
	LeftArm = true,
	RightArm = true,
	LeftLeg = true,
	RightLeg = true,
	["Left Arm"] = true,
	["Right Arm"] = true,
	["Left Leg"] = true,
	["Right Leg"] = true,
	LeftUpperArm = true,
	LeftLowerArm = true,
	LeftHand = true,
	RightUpperArm = true,
	RightLowerArm = true,
	RightHand = true,
	LeftUpperLeg = true,
	LeftLowerLeg = true,
	LeftFoot = true,
	RightUpperLeg = true,
	RightLowerLeg = true,
	RightFoot = true,
}

local function looksLikeWeaponName(name)
	name = string.lower(name or "")
	return string.find(name, "knife", 1, true) ~= nil
		or string.find(name, "gun", 1, true) ~= nil
		or string.find(name, "revolver", 1, true) ~= nil
		or string.find(name, "pistol", 1, true) ~= nil
		or string.find(name, "blade", 1, true) ~= nil
end

local function forbiddenWeaponPath(inst)
	local ok, full = pcall(function()
		return string.lower(inst:GetFullName())
	end)
	if not ok then
		return true
	end
	return string.find(full, "regularlobby", 1, true) ~= nil
		or string.find(full, "inventorypreview", 1, true) ~= nil
		or string.find(full, "shop", 1, true) ~= nil
end

local function isLocalDisplayWeapon(inst)
	if not inst then return false end
	local ch = LocalPlayer.Character
	if not ch then return false end
	for _, name in ipairs({"DisplayRefKnife", "DisplayRefGun"}) do
		local ref = ch:FindFirstChild(name, true)
		if ref and ref:IsA("ObjectValue") and ref.Value then
			if inst == ref.Value or inst:IsDescendantOf(ref.Value) then
				return true
			end
		end
	end
	return false
end

local trackedThrownRoots = setmetatable({}, {__mode = "k"})
local function isLocalThrownKnife(inst)
	if not inst then return false end
	local tracked = inst
	while tracked and tracked ~= Workspace do
		if trackedThrownRoots[tracked] then return true end
		tracked = tracked.Parent
	end
	if not isLocalMurderer() then return false end
	if CollectionService:HasTag(inst, "ThrowingKnife") then
		return true
	end
	local lname = string.lower(inst.Name)
	if lname == "throwingknife" or lname == "knifevisual" or string.find(lname, "throwingknife", 1, true) or string.find(lname, "knifevisual", 1, true) then
		return true
	end
	if inst:GetAttribute("Direction") ~= nil or inst:GetAttribute("ThrowSpeed") ~= nil then
		return true
	end
	local cur = inst.Parent
	while cur and cur ~= Workspace do
		if CollectionService:HasTag(cur, "ThrowingKnife") then
			return true
		end
		local cname = string.lower(cur.Name)
		if cname == "throwingknife" or cname == "knifevisual" or string.find(cname, "throwingknife", 1, true) or string.find(cname, "knifevisual", 1, true) then
			return true
		end
		cur = cur.Parent
	end
	local ok, tagged = pcall(function()
		return CollectionService:GetTagged("ThrowingKnife")
	end)
	if ok and type(tagged) == "table" then
		for _, t in ipairs(tagged) do
			if inst == t or inst:IsDescendantOf(t) then
				return true
			end
		end
	end
	return false
end

local function isLocalCharacterOrBackpackWeapon(inst)
	if not inst then return false end
	local ch = LocalPlayer.Character
	if ch and (inst:IsDescendantOf(ch) or inst == ch) then
		if inst:IsA("Tool") or looksLikeWeaponName(inst.Name) then
			return true
		end
		local cur = inst
		while cur and cur ~= ch do
			if cur:IsA("Tool") or ((cur:IsA("Model") or cur:IsA("BasePart") or cur:IsA("Folder")) and looksLikeWeaponName(cur.Name)) then
				return true
			end
			cur = cur.Parent
		end
	end
	local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
	if bp and inst:IsDescendantOf(bp) then
		return true
	end
	return false
end

XT.isLocalChamsWeapon = isLocalCharacterOrBackpackWeapon

local function isLocalWeaponRoot(inst)
	if not inst or not inst.Parent then
		return false
	end
	if inst.Name == "Waraku_WeaponChamsOverlay" then
		return false
	end
	if forbiddenWeaponPath(inst) then
		return false
	end
	if isLocalDisplayWeapon(inst) then
		return true
	end
	if isLocalThrownKnife(inst) then
		return true
	end
	if isLocalCharacterOrBackpackWeapon(inst) then
		return true
	end
	return false
end

local function restoreChamPart(part)
	local o = V.ChamsOriginal[part]
	if o and part.Parent then
		pcall(function()
			part.Material = o.Material
			part.Color = o.Color
			part.Reflectance = o.Reflectance or 0
			part.Transparency = o.Transparency
			part.Reflectance = o.Reflectance or 0
			if part:IsA("MeshPart") and o.TextureID ~= nil then
				part.TextureID = o.TextureID
			end
		end)
	end
	V.ChamsOriginal[part] = nil
	clearCons(V.ChamsPartLocks[part])
	V.ChamsPartLocks[part] = nil
end

local function restoreChamMesh(mesh)
	local o = V.ChamsMeshOriginal[mesh]
	if o and mesh.Parent then
		pcall(function()
			if mesh:IsA("SpecialMesh") then
				mesh.TextureId = o.TextureId
				mesh.VertexColor = o.VertexColor
			end
		end)
	end
	V.ChamsMeshOriginal[mesh] = nil
	clearCons(V.ChamsMeshLocks[mesh])
	V.ChamsMeshLocks[mesh] = nil
end

local function restorePlayerChams(p)
	local ch = p and p.Character
	if not ch then
		return
	end
	for part, _ in pairs(V.ChamsOriginal) do
		if part.Parent and part:IsDescendantOf(ch) then
			restoreChamPart(part)
		end
	end
	for mesh, _ in pairs(V.ChamsMeshOriginal) do
		if mesh.Parent and mesh:IsDescendantOf(ch) then
			restoreChamMesh(mesh)
		end
	end
end

local function restoreAllPlayerChams()
	for part, _ in pairs(V.ChamsOriginal) do
		restoreChamPart(part)
	end
	for mesh, _ in pairs(V.ChamsMeshOriginal) do
		restoreChamMesh(mesh)
	end
	disconnectMap(V.ChamsPartLocks)
	disconnectMap(V.ChamsMeshLocks)
end

-- The real character parts must use exactly the material of the style chosen in
-- the menu (Flat / Glass / Neon / ForceField / Glow).  It used to read the unused
-- ChamsPreset value, which painted ForceField (or Foil) on players whatever the
-- selection was.
local function playerChamsStyle()
	return XT.chamsStyles and XT.chamsStyles[V.ChamsStyle] or nil
end

local function playerChamsMaterial()
	local style = playerChamsStyle()
	return style and style.material or Enum.Material.SmoothPlastic
end

local function isPlayerChamPart(o)
	if not o or not o:IsA("BasePart") then
		return false
	end
	-- HumanoidRootPart is an implementation/physics part, not a visible body
	-- part. Never paint it: doing so makes the normally invisible HRP appear
	-- whenever Chams/Highlight are enabled.
	if o.Name == "HumanoidRootPart" or o.Name == "RootPart" then
		return false
	end
	if o:FindFirstAncestorOfClass("Tool") then
		return false
	end
	if looksLikeWeaponName(o.Name) then
		return false
	end
	local toolLike = o:FindFirstAncestorWhichIsA("Model")
	if toolLike and toolLike ~= o and looksLikeWeaponName(toolLike.Name) and not Players:GetPlayerFromCharacter(toolLike) then
		return false
	end
	return true
end

local function paintChamPart(part, color)
	if applyingChams or not part.Parent then
		return
	end
	applyingChams = true
	pcall(function()
		part.Material = playerChamsMaterial()
		part.Color = color
		part.Transparency = V.ChamsTransparency
		part.Reflectance = (playerChamsStyle() and playerChamsStyle().reflectance) or 0
		if part:IsA("MeshPart") then
			part.TextureID = ""
		end
	end)
	applyingChams = false
end

local function paintChamMesh(mesh, color)
	if applyingChams or not mesh.Parent then
		return
	end
	applyingChams = true
	pcall(function()
		if mesh:IsA("SpecialMesh") then
			mesh.TextureId = ""
			mesh.VertexColor = Vector3.new(color.R, color.G, color.B)
		end
	end)
	applyingChams = false
end

local function currentChamColor(inst)
	local current = inst
	while current and current ~= game do
		if current:IsA("Model") then
			local plr = Players:GetPlayerFromCharacter(current)
			if plr then
				local d = playerData(plr)
				local roleName = visualRoleName(plr, d)
				return V.ChamsRoleColor and (V.ChamsColors[roleName] or visualRoleColor(plr, d)) or V.ChamsColor
			end
		end
		current = current.Parent
	end
	return V.ChamsColor
end

local function lockChamPart(part, color)
	if not V.ChamsOriginal[part] then
		V.ChamsOriginal[part] = {
			Material = part.Material,
			Color = part.Color,
			Transparency = part.Transparency,
			Reflectance = part.Reflectance,
			TextureID = part:IsA("MeshPart") and part.TextureID or nil,
		}
	end
	paintChamPart(part, color)
	if not V.ChamsPartLocks[part] then
		local bag = {}
		local function relock()
			if applyingChams or not V.ChamsEnabled then
				return
			end
			paintChamPart(part, currentChamColor(part))
		end
		table.insert(bag, part:GetPropertyChangedSignal("Material"):Connect(relock))
		table.insert(bag, part:GetPropertyChangedSignal("Color"):Connect(relock))
		table.insert(bag, part:GetPropertyChangedSignal("Transparency"):Connect(relock))
		table.insert(bag, part:GetPropertyChangedSignal("Reflectance"):Connect(relock))
		if part:IsA("MeshPart") then
			table.insert(bag, part:GetPropertyChangedSignal("TextureID"):Connect(relock))
		end
		V.ChamsPartLocks[part] = bag
	end
end

local function lockChamMesh(mesh, color)
	if not mesh:IsA("SpecialMesh") then
		return
	end
	if not V.ChamsMeshOriginal[mesh] then
		V.ChamsMeshOriginal[mesh] = {TextureId = mesh.TextureId, VertexColor = mesh.VertexColor}
	end
	paintChamMesh(mesh, color)
	if not V.ChamsMeshLocks[mesh] then
		local bag = {}
		local function relock()
			if applyingChams or not V.ChamsEnabled then
				return
			end
			paintChamMesh(mesh, currentChamColor(mesh))
		end
		table.insert(bag, mesh:GetPropertyChangedSignal("TextureId"):Connect(relock))
		table.insert(bag, mesh:GetPropertyChangedSignal("VertexColor"):Connect(relock))
		V.ChamsMeshLocks[mesh] = bag
	end
end

local function applyChams(p, d)
	local ch = p.Character
	if not ch or p == LocalPlayer then
		return
	end
	-- Highlight style draws an outline only; never repaint the real body parts.
	if V.ChamsStyle == "Highlight" then
		restorePlayerChams(p)
		return
	end
	local roleName = visualRoleName(p, d)
	local c = V.ChamsRoleColor and (V.ChamsColors[roleName] or visualRoleColor(p, d)) or V.ChamsColor
	for _, o in ipairs(ch:GetDescendants()) do
		if isPlayerChamPart(o) then
			lockChamPart(o, c)
		elseif o:IsA("SpecialMesh") and isPlayerChamPart(o.Parent) then
			lockChamMesh(o, c)
		end
	end
end

local function refreshStatic()
	if V.Destroying or V.Destroyed then return end
    V.ChamsEnabled = V.HighlightEnabled == true
	if not V.Enabled then
		XT.litStep(nil)
		for _, p in ipairs(Players:GetPlayers()) do
			clearVisual(p)
		end
		return
	end
	local isRoundRestricted = V.RoundOnly
	local inRound = isRoundActive()
	local allowRender = (not isRoundRestricted) or inRound
	if not allowRender or not V.HighlightEnabled then XT.litStep(nil) end

	for _, p in ipairs(Players:GetPlayers()) do
		clearVisual(p)
		local d = playerData(p)
		local ch = p.Character
		local hum = ch and ch:FindFirstChildOfClass("Humanoid")
		local show = allowRender and p ~= LocalPlayer and allowed(p, d) and ch and hum and hum.Health > 0
		if show and V.HighlightEnabled then
			ensureHighlight(p, d)
		end
		if show and V.ChamsEnabled then
			applyChams(p, d)
		else
			restorePlayerChams(p)
		end
	end
end

local staticRefreshQueued=false
local function queueRefreshStatic()
    if staticRefreshQueued or V.Destroying or V.Destroyed or V.VoteRespawning or V.VoteDupeRunning then return end
    staticRefreshQueued=true
    task.delay(0.08,function()
        staticRefreshQueued=false
        if not V.Destroying and not V.Destroyed and not V.VoteRespawning and not V.VoteDupeRunning then refreshStatic() end
    end)
end

local function watch(p)
	clearCons(V.PlayerConnections[p])
	clearCons(V.CharacterConnections[p])
	local b = {}
	V.PlayerConnections[p] = b
	local function weaponChanged(o)
		if V.Destroying or V.Destroyed then return end
		if o and (o:IsA("Tool") or looksLikeWeaponName(o.Name)) then
			queueRefreshStatic()
			task.defer(refreshGun)
		end
	end
	local function hook(container, bag)
		if not container then
			return
		end
		con(container.ChildAdded, weaponChanged, bag or b)
		con(container.ChildRemoved, weaponChanged, bag or b)
	end
	local function hookChar(ch)
		clearCons(V.CharacterConnections[p])
		local cb = {}
		V.CharacterConnections[p] = cb
		if not ch then return end
		hook(ch, cb)
		local function onHum(hum)
			if hum and hum:IsA("Humanoid") then
				con(hum.Died, function()
					clearVisual(p)
					restorePlayerChams(p)
					queueRefreshStatic()
				end, cb)
			end
		end
		local hum = ch:FindFirstChildOfClass("Humanoid")
		if hum then onHum(hum) end
		con(ch.ChildAdded, function(c)
			if c:IsA("Humanoid") then onHum(c) end
		end, cb)
	end
	hook(p:FindFirstChildOfClass("Backpack"))
	if p.Character then
		hookChar(p.Character)
	end
	con(p.ChildAdded, function(o)
		if o:IsA("Backpack") then
			hook(o)
		end
	end, b)
	con(p.CharacterAdded, function(ch)
		hookChar(ch)
		queueRefreshStatic()
	end, b)
	con(p.CharacterRemoving, function()
		if p.Character then VisualCache.drop(p.Character) end
		clearCons(V.CharacterConnections[p])
		V.CharacterConnections[p] = nil
		clearVisual(p)
		restorePlayerChams(p)
		queueRefreshStatic()
	end, b)
end

for _, p in ipairs(Players:GetPlayers()) do
	watch(p)
end
con(Players.PlayerAdded, watch)
con(Players.PlayerRemoving, function(p)
	if p.Character then VisualCache.drop(p.Character) end
	clearCons(V.CharacterConnections[p])
	V.CharacterConnections[p] = nil
	clearCons(V.PlayerConnections[p])
	V.PlayerConnections[p] = nil
	clearVisual(p)
	destroyPlayerVisual(p)
	restorePlayerChams(p)
end)
local function handlePlayerData(newPd)
	roundStateCache.t = -1
	local pd = (type(newPd) == "table" and newPd) or (Round and Round.PlayerData)
	if Round and type(newPd) == "table" then
		Round.PlayerData = newPd
	end
	if hasAssignedRoles(pd) then
		roundOver = false
	end
	queueRefreshStatic()
	task.defer(refreshCorpses)
	task.defer(refreshGun)
end

con(Gameplay.PlayerDataChanged.OnClientEvent, handlePlayerData)
if Round and Round.PlayerDataChanged then
	con(Round.PlayerDataChanged.Event, function()
		handlePlayerData(Round.PlayerData)
	end)
end

local function onRoundStageBegins()
	roundStateCache.t = -1
	roundOver = false
	queueRefreshStatic()
	task.defer(refreshCorpses)
	task.defer(refreshGun)
	if Round and Round.GetLatestPlayerData then
		task.spawn(function()
			for _ = 1, 15 do
				if V.Destroying or V.Destroyed then return end
				pcall(Round.GetLatestPlayerData)
				if hasAssignedRoles(Round and Round.PlayerData) then
					roundOver = false
					refreshStatic()
					refreshCorpses()
					refreshGun()
					break
				end
				task.wait(0.2)
			end
		end)
	end
end

for _, n in ipairs({"TeleportToPart", "RoleSelect", "ShowRoleSelect", "ShowRoleSelectNew", "LoadingMap", "RoundStart", "GiveWeapon", "SpecialRound"}) do
	local r = Gameplay:FindFirstChild(n)
	if r then
		con(r.OnClientEvent, function()
			onRoundStageBegins()
			if n == "RoleSelect" or n == "ShowRoleSelect" or n == "ShowRoleSelectNew" or n == "GiveWeapon" then
				if Round and Round.GetLatestPlayerData then
					pcall(Round.GetLatestPlayerData)
				end
				queueRefreshStatic()
			end
		end)
	end
end

for _, n in ipairs({"GameOver", "RoundEndFade", "VictoryScreen"}) do
	local r = Gameplay:FindFirstChild(n)
	if r then
		con(r.OnClientEvent, function()
			roundOver = true
			queueRefreshStatic()
			task.defer(refreshCorpses)
			task.defer(refreshGun)
		end)
	end
end

con(Workspace.ChildAdded, function(c)
	if c:IsA("Model") and c.Name ~= "RegularLobby" and c.Name ~= "Lobby" then
		task.defer(function()
			if c:FindFirstChild("CoinContainer") or c:FindFirstChild("Spawns") or c:FindFirstChild("CoinArea") then
				roundOver = false
				queueRefreshStatic()
				task.defer(refreshCorpses)
				task.defer(refreshGun)
			end
		end)
	end
end)

con(Workspace.ChildRemoved, function(c)
	if c:IsA("Model") and c.Name ~= "RegularLobby" and c.Name ~= "Lobby" then
		task.defer(function()
			if not getRoundMap() then
				roundOver = true
				queueRefreshStatic()
				task.defer(refreshCorpses)
				task.defer(refreshGun)
			end
		end)
	end
end)

if getRoundMap() then
	roundOver = false
end

do
local litList,litEntries={},{}
con(Players.PlayerRemoving,function(player) litEntries[player]=nil end)
con(RunService.RenderStepped, function()
	if not V.Enabled then
		XT.litStep(nil)
		if V.DrawByPlayer then
			for _, e in pairs(V.DrawByPlayer) do
				setHiddenIdle(e)
			end
		end
		for _, p in ipairs(Players:GetPlayers()) do
			local h = V.Highlights and V.Highlights[p]
			if h then
				h.Enabled = false
			end
		end
		return
	end

	local isRoundRestricted = V.RoundOnly
	local inRound = isRoundActive()
	local allowRender = (not isRoundRestricted) or inRound

	local drawingActive = allowRender and (V.BoxEnabled or V.NameEnabled or V.DistanceEnabled or V.RoleFlagEnabled or V.RoleTracerEnabled
		or V.ArrowEnabled or V.AvatarEnabled or V.HealthEnabled)
	local highlightActive = allowRender and V.HighlightEnabled

	if not drawingActive and not highlightActive then
		if V.DrawByPlayer then
			for _, e in pairs(V.DrawByPlayer) do
				setHiddenIdle(e)
			end
		end
		for _, p in ipairs(Players:GetPlayers()) do
			local h = V.Highlights and V.Highlights[p]
			if h then
				h.Enabled = false
			end
		end
		XT.litStep(nil)
		return
	end

	table.clear(litList)
	for _, p in ipairs(Players:GetPlayers()) do
		local d = playerData(p)
		local isAllowed = p ~= LocalPlayer and allowed(p, d)
		if isAllowed then
			if drawingActive then
				local okDraw, errDraw = pcall(drawPlayerESP, p, d)
				if not okDraw then
					V.LastESPError = tostring(errDraw)
				end
			else
				setHiddenIdle(V.DrawByPlayer and V.DrawByPlayer[p])
			end
			if highlightActive then
				ensureHighlight(p, d)
				if V.ChamsStyle ~= "Highlight" and p.Character then
					local item=litEntries[p]
					if not item then item={p}; litEntries[p]=item end
					item[2],item[3],item[4]=p.Character,V.ChamsRoleColor and visualRoleColor(p,d) or V.ChamsColor,visualRoleName(p,d)
					litList[#litList+1]=item
				end
			else
				local h = V.Highlights and V.Highlights[p]
				if h then
					h.Enabled = false
				end
			end
		else
			setHiddenIdle(V.DrawByPlayer and V.DrawByPlayer[p])
			local h = V.Highlights and V.Highlights[p]
			if h then
				h.Enabled = false
			end
		end
	end
	XT.litStep(V.ChamsStyle == "Highlight" and nil or litList)
end)
end

local function isCorpseModel(model)
	if not model or not model:IsA("Model") or model == LocalPlayer.Character then
		return false
	end
	if Players:GetPlayerFromCharacter(model) then
		return false
	end
	if model:FindFirstChild("Spawns") or model:FindFirstChild("CoinContainer") or model:FindFirstChild("CoinArea") or model:FindFirstChild("Doors") then
		return false
	end
	local children = model:GetChildren()
	if #children > 60 then
		return false
	end
	if not model:FindFirstChild("Head") and not model:FindFirstChild("HumanoidRootPart") and not model:FindFirstChild("UpperTorso") and not model:FindFirstChild("Torso") then
		return false
	end
	local mName = model.Name
	local lname = string.lower(mName)
	if lname == "raggy" or lname == "ragdoll" or lname == "corpse" or lname == "deadbody" then
		return true
	end
	if string.find(lname, "raggy", 1, true) or string.find(lname, "ragdoll", 1, true) or string.find(lname, "corpse", 1, true) then
		return true
	end
	if model:FindFirstChild("PlayerName") or model:FindFirstChild("RagdollConstraintHead") or model:FindFirstChild("RagdollPrompt") then
		return true
	end
	for _, p in ipairs(children) do
		if p:IsA("BasePart") and p.CollisionGroup == "AnchoredRagdolls" then
			return true
		end
		if p:IsA("Constraint") and string.find(string.lower(p.Name), "ragdoll", 1, true) then
			return true
		end
	end
	return false
end

local function getCorpseInfo(model)
	if not model then return "Corpse", "Innocent" end
	local victimName
	local pVal = model:FindFirstChild("PlayerName", true)
	if pVal and pVal:IsA("StringValue") and pVal.Value ~= "" then
		victimName = pVal.Value
	end
	if not victimName then
		local p = Players:GetPlayerFromCharacter(model)
		if p then victimName = p.DisplayName or p.Name end
	end
	if not victimName then
		local attr = model:GetAttribute("PlayerName") or model:GetAttribute("Owner")
		if attr and attr ~= "" then victimName = tostring(attr) end
	end

	local role = "Innocent"
	if victimName and Round.PlayerData and Round.PlayerData[victimName] then
		local d = Round.PlayerData[victimName]
		role = d.Role or "Innocent"
	end
	return victimName or "Dead Body", role
end

local function clearCorpses()
	for model, h in pairs(V.CorpseHighlights) do
		if h then pcall(function() h:Destroy() end) end
	end
	table.clear(V.CorpseHighlights)
end

local function applyCorpseVisual(model)
	if not model or not model.Parent or not isCorpseModel(model) then return end
	if #model:GetChildren() > 60 then return end
	local _, role = getCorpseInfo(model)
	local roleCol = ROLE[role]
	local fillColor = V.DeadBodyRoleColor and (roleCol or V.DeadBodyFillColor) or V.DeadBodyFillColor
	local outlineColor = V.DeadBodyRoleColor and (roleCol or V.DeadBodyOutlineColor) or V.DeadBodyOutlineColor

	local h = V.CorpseHighlights[model]
	if not h or not h.Parent then
		h = Instance.new("Highlight")
		h.Name = "Waraku_CORPSE_ESP"
		h.Adornee = model
		h.Parent = model
		V.CorpseHighlights[model] = h
	end
	h.DepthMode = V.DeadBodyXRay and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
	h.FillColor = fillColor
	h.FillTransparency = V.DeadBodyFill and V.DeadBodyFillTransparency or 0.70
	h.OutlineColor = outlineColor
	h.OutlineTransparency = V.DeadBodyOutlineTransparency or 0.35
	h.Enabled = true
end

local function findAllCorpses()
	local corpses = {}
	local seen = {}
	local function checkModel(m)
		if m and m:IsA("Model") and not seen[m] and isCorpseModel(m) then
			seen[m] = true
			table.insert(corpses, m)
		end
	end

	for _, ch in ipairs(Workspace:GetChildren()) do
		if ch:IsA("Model") then
			checkModel(ch)
			if not Players:GetPlayerFromCharacter(ch) then
				for _, sub in ipairs(ch:GetChildren()) do
					if sub:IsA("Model") then
						checkModel(sub)
					end
				end
			end
		end
	end
	return corpses
end

local lastCorpseStep = 0
local function stepCorpses()
	if V.Destroying or V.Destroyed or not V.Enabled or not V.DeadBodiesEnabled then
		if next(V.CorpseHighlights) ~= nil then
			clearCorpses()
		end
		return
	end
	local isRoundRestricted = V.RoundOnly
	if isRoundRestricted and not isRoundActive() then
		if next(V.CorpseHighlights) ~= nil then
			clearCorpses()
		end
		return
	end

	local now = os.clock()
	if now - lastCorpseStep < 0.35 then
		return
	end
	lastCorpseStep = now

	local corpses = findAllCorpses()
	local active = {}
	for _, m in ipairs(corpses) do
		active[m] = true
		applyCorpseVisual(m)
	end

	for model, h in pairs(V.CorpseHighlights) do
		if not active[model] or not model.Parent then
			if h then pcall(function() h:Destroy() end) end
			V.CorpseHighlights[model] = nil
		end
	end
end

local function refreshCorpses()
	lastCorpseStep = 0
	stepCorpses()
end

con(Workspace.DescendantAdded, function(o)
	if V.DeadBodiesEnabled and o:IsA("Model") and isCorpseModel(o) then
		task.delay(0.05, refreshCorpses)
	end
end)
con(Workspace.DescendantRemoving, function(o)
	if V.CorpseHighlights[o] then
		pcall(function() V.CorpseHighlights[o]:Destroy() end)
		V.CorpseHighlights[o] = nil
	end
end)

local cachedGunDrop
local lastGunDropScan = -math.huge
local function resolveGunDrop(object)
	if not object or object.Name ~= "GunDrop" then
		return nil
	end
	if object:IsA("BasePart") then
		return object
	end
	if object:IsA("Model") or object:IsA("Tool") then
		return object:FindFirstChild("Handle", true) or object:FindFirstChildWhichIsA("BasePart", true)
	end
end

local function gunDrop()
	if cachedGunDrop and cachedGunDrop:IsDescendantOf(Workspace) then
		return cachedGunDrop
	end
	local now = os.clock()
	if now - lastGunDropScan < (V.AutoGrabGun and 0.1 or 0.4) then return nil end
	lastGunDropScan = now
	cachedGunDrop = resolveGunDrop(Workspace:FindFirstChild("GunDrop", true))
	return cachedGunDrop
end

local function clearGunVisuals()
	if V.GunHighlight then
		V.GunHighlight:Destroy()
		V.GunHighlight = nil
	end
	if V.GunBillboard then
		V.GunBillboard:Destroy()
		V.GunBillboard = nil
	end
	V.GunTextLabels = nil
end

local function refreshGun()
    if V.Destroying or V.Destroyed then return end
	clearGunVisuals()
	if not V.Enabled or not V.GunEnabled then
		return
	end
	local isRoundRestricted = V.RoundOnly
	if isRoundRestricted and not isRoundActive() then
		return
	end
	local g = gunDrop()
	if not g then
		return
	end
	local col = V.GunColor or Color3.fromRGB(255, 215, 0)
	local h = Instance.new("Highlight")
	h.Name = "Waraku_GUN_ESP"
	h.Adornee = g
	h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	h.FillColor = col
	h.FillTransparency = 0.5
	h.OutlineColor = col
	h.OutlineTransparency = 0
	h.Parent = g
	V.GunHighlight = h

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "Waraku_GUN_TEXT"
	billboard.Adornee = g
	billboard.AlwaysOnTop = true
	billboard.LightInfluence = 0
	billboard.Size = UDim2.fromOffset(50, 20)
	billboard.StudsOffset = Vector3.new(0, 1.4, 0)
	billboard.Parent = ESPGui

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.BorderSizePixel = 0
	label.Size = UDim2.fromScale(1, 1)
	label.Font = Enum.Font.GothamBold
	label.Text = "Gun"
	label.TextColor3 = col
	label.TextSize = 13
	label.TextStrokeColor3 = Color3.new(0, 0, 0)
	label.TextStrokeTransparency = 0.3
	label.Parent = billboard
	V.GunBillboard = billboard
end

con(Workspace.DescendantAdded, function(o)
	if o.Name == "GunDrop" then
		cachedGunDrop = resolveGunDrop(o) or cachedGunDrop
		task.defer(refreshGun)
	end
end)
con(Workspace.DescendantRemoving, function(o)
	if o == cachedGunDrop or o.Name == "GunDrop" then
		cachedGunDrop = nil
		lastGunDropScan = -math.huge
		task.defer(refreshGun)
	end
end)

local gunRemote
for _, o in ipairs(RS:GetDescendants()) do
	if o.Name == "GunFired" and o:IsA("RemoteEvent") then
		gunRemote = o
		break
	end
end

local function vec(v)
	if typeof(v) == "Vector3" then
		return v
	end
	if typeof(v) == "CFrame" then
		return v.Position
	end
	if type(v) == "string" then
		local a, b, c = v:match("([%-.%d]+),%s*([%-.%d]+),%s*([%-.%d]+)")
		if a then
			return Vector3.new(tonumber(a), tonumber(b), tonumber(c))
		end
	end
end

local function localGun()
	local ch = LocalPlayer.Character
	for _, o in ipairs(ch and ch:GetChildren() or {}) do
		if o:IsA("Tool") and string.find(string.lower(o.Name), "gun", 1, true) then
			return o
		end
	end
end

local function nearLocalGun(point, gun)
	for _, o in ipairs(gun:GetDescendants()) do
		if o:IsA("BasePart") and (o.Position - point).Magnitude <= 12 then
			return true
		end
	end
	return false
end

local function makeTracer(from, to)
	local length = (to - from).Magnitude
	if length < 0.05 then
		return
	end
	local userThick = math.clamp(V.TracerThickness or 0.5, 0, 1)
	if userThick <= 0 then
		return
	end
	local diameter = userThick * 0.2
	local trans = math.clamp(V.TracerTransparency or 0.65, 0, 0.95)

	local part = Instance.new("Part")
	part.Name = "Waraku_BULLET_TRACER"
	part.Anchored = true
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.CastShadow = false
	part.Shape = Enum.PartType.Cylinder
	part.Material = V.TracerGlow and Enum.Material.Neon or Enum.Material.SmoothPlastic
	part.Color = V.TracerColor or Color3.fromRGB(0, 200, 255)
	part.Transparency = trans
	part.Size = Vector3.new(length, diameter, diameter)
	part.CFrame = CFrame.new((from + to) / 2, to) * CFrame.Angles(0, math.rad(90), 0)
	part.Parent = Workspace

	table.insert(V.Tracers, {
		Part = part,
		Length = length,
		Born = os.clock(),
		Fading = false,
	})
end

local function hookGunRemote(rem)
	if not rem or not rem:IsA("RemoteEvent") then return end
	con(rem.OnClientEvent, function(...)
		if not V.TracerEnabled then
			return
		end
		local gun = localGun()
		if not gun then
			return
		end
		local args = {...}
		local from, to
		for _, a in ipairs(args) do
			local p = vec(a)
			if p then
				if not from then
					from = p
				elseif not to then
					to = p
					break
				end
			end
		end
		if not from or not to then
			return
		end

		if not nearLocalGun(from, gun) then
			if nearLocalGun(to, gun) then
				from, to = to, from
			else
				return
			end
		end
		makeTracer(from, to)
	end)
end

if gunRemote then
	hookGunRemote(gunRemote)
end

con(RS.DescendantAdded, function(o)
	if o.Name == "GunFired" and o:IsA("RemoteEvent") and not gunRemote then
		gunRemote = o
		hookGunRemote(o)
	end
end)

local function clearTracers()
	if V.Tracers then
		for _, t in ipairs(V.Tracers) do
			if t.Part then pcall(function() t.Part:Destroy() end) end
		end
		table.clear(V.Tracers)
	end
end

con(RunService.RenderStepped, function()
	for i = #V.Tracers, 1, -1 do
		local t = V.Tracers[i]
		local age = os.clock() - t.Born
		if age >= V.TracerDuration + 0.22 or not t.Part or not t.Part.Parent then
			if t.Part then pcall(function() t.Part:Destroy() end) end
			table.remove(V.Tracers, i)
		else
			t.Part.Color = V.TracerColor
			if age >= V.TracerDuration and not t.Fading then
				t.Fading = true
				TweenService:Create(t.Part, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
					Transparency = 1,
					Size = Vector3.new(t.Length, 0, 0),
				}):Play()
			end
		end
	end
end)

local flyingKnives = {}
local WeaponVisual = {
	Materials = {
		ForceField = Enum.Material.ForceField,
		Flat = Enum.Material.SmoothPlastic,
		Neon = Enum.Material.Neon,
		Glass = Enum.Material.Glass,
		Metal = Enum.Material.Metal,
	},
	Pending = setmetatable({}, {__mode = "k"}),
	Hidden = setmetatable({}, {__mode = "k"}),
	TemplateRetry = {},
	OverlayMeshIds = setmetatable({}, {__mode = "k"}),
}
function WeaponVisual.apply(part)
	part.MaterialVariant = ""
	if part:IsA("UnionOperation") then part.UsePartColor = true end
	part.Material = WeaponVisual.Materials[V.WeaponPreset] or Enum.Material.ForceField
	part.Color = V.WeaponColor
	part.Reflectance = V.WeaponPreset == "Metal" and 0.15 or 0
	part.Transparency = math.clamp(V.WeaponTransparency or 0, 0, 0.95)
end
function WeaponVisual.hide(part)
	if WeaponVisual.Hidden[part] == nil then
		WeaponVisual.Hidden[part] = part.Transparency
	end
	part.Transparency = 1
end
function WeaponVisual.restoreHidden()
	for part, transparency in pairs(WeaponVisual.Hidden) do
		if part.Parent then pcall(function() part.Transparency = transparency end) end
	end
	table.clear(WeaponVisual.Hidden)
end

con(RunService.RenderStepped, function()
	if V.WeaponChams then
		for part, info in pairs(flyingKnives) do

			if not part.Parent or not info.Overlay or not info.Overlay.Parent then
				if info.Connection then info.Connection:Disconnect() end
				if info.Overlay and info.Overlay.Parent then
					pcall(function() info.Overlay:Destroy() end)
				end
				flyingKnives[part] = nil
			else
				info.Overlay.CFrame = part.CFrame * CFrame.new(info.Offset)
				WeaponVisual.apply(info.Overlay)
				part.Transparency = 1
				local vh = part:FindFirstChild("VH")
				if vh and vh:IsA("BasePart") then
					WeaponVisual.hide(vh)
				end
				local parent = part.Parent
				if parent and (parent.Name == "ThrowingKnife" or CollectionService:HasTag(parent, "ThrowingKnife")) and parent:IsA("BasePart") then
					WeaponVisual.hide(parent)
				end
			end
		end
	end
	local ok7, err7 = pcall(stepCorpses)
	if not ok7 then V._corpseErr = err7 end
end)

local meshTemplateCache = {}
local meshTemplatePending = {}

local function getMeshTemplateAsync(meshId, callback)
	if not meshId or meshId == "" then callback(nil); return end
	if os.clock() < (WeaponVisual.TemplateRetry[meshId] or 0) then callback(nil); return end
	if meshTemplateCache[meshId] then
		callback(meshTemplateCache[meshId])
		return
	end
	if meshTemplatePending[meshId] then
		table.insert(meshTemplatePending[meshId], callback)
		return
	end
	meshTemplatePending[meshId] = {callback}
	task.spawn(function()
		local template
		pcall(function()
			template = InsertService:CreateMeshPartAsync(meshId, Enum.CollisionFidelity.Default, Enum.RenderFidelity.Precise)
		end)
		if not template then
			local num = string.match(meshId, "%d+")
			if num then
				pcall(function()
					template = InsertService:CreateMeshPartAsync("rbxassetid://" .. num, Enum.CollisionFidelity.Default, Enum.RenderFidelity.Precise)
				end)
			end
		end
		WeaponVisual.TemplateRetry[meshId] = not template and (os.clock() + 5) or nil
		meshTemplateCache[meshId] = template
		local cbs = meshTemplatePending[meshId]
		meshTemplatePending[meshId] = nil
		if cbs then
			for _, cb in ipairs(cbs) do
				task.spawn(cb, template)
			end
		end
	end)
end

local function applyOverlayProps(overlay, part, mesh)
	local scale = (mesh and mesh.Scale) or Vector3.new(1, 1, 1)
	local offset = (mesh and mesh.Offset) or Vector3.new(0, 0, 0)
	overlay.Size = overlay.MeshSize * scale
	overlay.CFrame = part.CFrame * CFrame.new(offset)
	WeaponVisual.apply(overlay)
	overlay.TextureID = ""
	overlay.CanCollide = false
	overlay.CanTouch = false
	overlay.CanQuery = false
	overlay.CastShadow = false
	overlay.Massless = true
end

local function ensureSpecialMeshOverlay(part, mesh)
	local isThrown = part.Anchored or isLocalThrownKnife(part)
	local overlay = part:FindFirstChild("Waraku_WeaponChamsOverlay") or V.WeaponOverlays[part]

	if overlay then
		local weld = overlay:FindFirstChildOfClass("WeldConstraint")
		if WeaponVisual.OverlayMeshIds[overlay] ~= mesh.MeshId or (weld and weld.Part0 ~= part) or (isThrown and not overlay.Anchored) or (not isThrown and overlay.Anchored) then
			pcall(function() overlay:Destroy() end)
			overlay = nil
			V.WeaponOverlays[part] = nil
		end
	end

	if overlay and overlay.Parent == part and overlay:IsA("MeshPart") then
		applyOverlayProps(overlay, part, mesh)
		part.Transparency = 1
		local vh = part:FindFirstChild("VH")
		if vh and vh:IsA("BasePart") then WeaponVisual.hide(vh) end
		if isThrown then
			overlay.Anchored = true
			local offset = (mesh and mesh.Offset) or Vector3.new(0, 0, 0)
			overlay.CFrame = part.CFrame * CFrame.new(offset)
			if not flyingKnives[part] then
				local syncCon = part:GetPropertyChangedSignal("CFrame"):Connect(function()
					if overlay.Parent and part.Parent then
						overlay.CFrame = part.CFrame * CFrame.new(offset)
					end
				end)
				flyingKnives[part] = {
					Overlay = overlay,
					Offset = offset,
					Part = part,
					Connection = syncCon,
				}
			end
		end
		return
	end

	WeaponVisual.apply(part)

	local meshId = mesh.MeshId
	if WeaponVisual.Pending[part] then return end
	local token = {}
	WeaponVisual.Pending[part] = token
	getMeshTemplateAsync(meshId, function(template)
		if WeaponVisual.Pending[part] ~= token then return end
		WeaponVisual.Pending[part] = nil
		if mesh.Parent ~= part or mesh.MeshId ~= meshId then return end
		isThrown = part.Anchored or isLocalThrownKnife(part)
		if not V.WeaponChams or not part.Parent or not isLocalWeaponRoot(part) or not mesh.Parent then
			return
		end
		if not template then
			return
		end

		local wasApplying = applyingWeapon
		applyingWeapon = true
		local ok, err = pcall(function()
			local existing = part:FindFirstChild("Waraku_WeaponChamsOverlay")
			if existing then
				pcall(function() existing:Destroy() end)
			end

			local newOverlay = template:Clone()
			newOverlay.Name = "Waraku_WeaponChamsOverlay"
			WeaponVisual.OverlayMeshIds[newOverlay] = meshId
			applyOverlayProps(newOverlay, part, mesh)

			local offset = (mesh and mesh.Offset) or Vector3.new(0, 0, 0)

			if isThrown then
				newOverlay.Anchored = true
				newOverlay.CFrame = part.CFrame * CFrame.new(offset)
				newOverlay.Parent = part
				V.WeaponOverlays[part] = newOverlay
				part.Transparency = 1
				local vh = part:FindFirstChild("VH")
				if vh and vh:IsA("BasePart") then WeaponVisual.hide(vh) end

				local syncCon = part:GetPropertyChangedSignal("CFrame"):Connect(function()
					if newOverlay.Parent and part.Parent then
						newOverlay.CFrame = part.CFrame * CFrame.new(offset)
					end
				end)

				local function cleanup()
					if syncCon then syncCon:Disconnect() end
					if newOverlay and newOverlay.Parent then pcall(function() newOverlay:Destroy() end) end
					flyingKnives[part] = nil
				end
				local destroyCon = part.Destroying:Connect(cleanup)
				newOverlay.Destroying:Once(function()
					syncCon:Disconnect()
					destroyCon:Disconnect()
					if flyingKnives[part] and flyingKnives[part].Overlay == newOverlay then flyingKnives[part] = nil end
				end)

				flyingKnives[part] = {
					Overlay = newOverlay,
					Offset = offset,
					Part = part,
					Connection = syncCon,
				}
			else
				newOverlay.Anchored = false
				local weld = Instance.new("WeldConstraint")
				weld.Part0 = part
				weld.Part1 = newOverlay
				weld.Parent = newOverlay

				newOverlay.Parent = part
				V.WeaponOverlays[part] = newOverlay
				part.Transparency = 1
				local vh = part:FindFirstChild("VH")
				if vh and vh:IsA("BasePart") then WeaponVisual.hide(vh) end
			end
		end)
		applyingWeapon = wasApplying
		if not ok then V._weaponOverlayErr = tostring(err) end
	end)
end

local function restoreWeaponPart(part)
	WeaponVisual.Pending[part] = nil
	clearCons(V.WeaponPartLocks[part])
	V.WeaponPartLocks[part] = nil
	local overlay = part:FindFirstChild("Waraku_WeaponChamsOverlay")
	if overlay then
		pcall(function() overlay:Destroy() end)
	end
	if V.WeaponOverlays[part] then
		pcall(function() V.WeaponOverlays[part]:Destroy() end)
		V.WeaponOverlays[part] = nil
	end
	if flyingKnives[part] then
		local fk = flyingKnives[part]
		if fk.Connection then fk.Connection:Disconnect() end
		if fk.Overlay and fk.Overlay.Parent then pcall(function() fk.Overlay:Destroy() end) end
		flyingKnives[part] = nil
	end
	local o = V.WeaponOriginal[part]
	if o and part.Parent then
		pcall(function()
			part.Material = o.Material
			if o.MaterialVariant ~= nil then part.MaterialVariant = o.MaterialVariant end
			if o.UsePartColor ~= nil then part.UsePartColor = o.UsePartColor end
			part.Color = o.Color
			part.Reflectance = o.Reflectance or 0
			part.Transparency = o.Transparency or 0
			if part:IsA("MeshPart") and o.TextureID ~= nil then
				part.TextureID = o.TextureID
			end
			local vh = part:FindFirstChild("VH")
			if vh and vh:IsA("BasePart") then
				local original = WeaponVisual.Hidden[vh]
				if original ~= nil then vh.Transparency = original; WeaponVisual.Hidden[vh] = nil end
			end
		end)
	end
	V.WeaponOriginal[part] = nil
	clearCons(V.WeaponPartLocks[part])
	V.WeaponPartLocks[part] = nil
end

local function restoreWeaponMesh(mesh)
	clearCons(V.WeaponMeshLocks[mesh])
	V.WeaponMeshLocks[mesh] = nil
	local o = V.WeaponMeshOriginal[mesh]
	if o and mesh.Parent then
		pcall(function()
			if mesh:IsA("SpecialMesh") then
				mesh.TextureId = o.TextureId
				mesh.VertexColor = o.VertexColor
			elseif mesh:IsA("SurfaceAppearance") and o.ColorMap ~= nil then
				mesh.ColorMap = o.ColorMap
			end
		end)
	end
	V.WeaponMeshOriginal[mesh] = nil
	clearCons(V.WeaponMeshLocks[mesh])
	V.WeaponMeshLocks[mesh] = nil
end

local function restoreWeapons()
	table.clear(WeaponVisual.Pending)
	for part, _ in pairs(V.WeaponOriginal) do
		restoreWeaponPart(part)
	end
	for mesh, _ in pairs(V.WeaponMeshOriginal) do
		restoreWeaponMesh(mesh)
	end
	for part, overlay in pairs(V.WeaponOverlays) do
		if overlay then
			pcall(function() overlay:Destroy() end)
		end
	end
	table.clear(V.WeaponOverlays)
	for part, info in pairs(flyingKnives) do
		if info.Connection then info.Connection:Disconnect() end
		if info.Overlay and info.Overlay.Parent then
			pcall(function() info.Overlay:Destroy() end)
		end
	end
	table.clear(flyingKnives)
	WeaponVisual.restoreHidden()
	disconnectMap(V.WeaponPartLocks)
	disconnectMap(V.WeaponMeshLocks)
end

local function isHitboxPart(part)
	if not part or not part:IsA("BasePart") then
		return false
	end
	local name = string.lower(part.Name)
	if name == "hitbox" or name == "vh" or name == "volumehitbox" or name == "trailpart" or name == "trail" or name == "root" or name == "touchpart" or name == "grip" or name == "handlehitbox" then
		return true
	end
	if name == "throwingknife" or CollectionService:HasTag(part, "ThrowingKnife") then
		if part:FindFirstChild("KnifeVisual") or part:FindFirstChildWhichIsA("SpecialMesh", true) or part:FindFirstChildWhichIsA("MeshPart", true) then
			return true
		end
	end
	local parent = part.Parent
	if parent and (string.lower(parent.Name) == "throwingknife" or CollectionService:HasTag(parent, "ThrowingKnife")) then
		if name ~= "knifevisual" and not part:FindFirstChildOfClass("SpecialMesh") and not part:IsA("MeshPart") then
			return true
		end
	end
	if not part:IsA("MeshPart") and not part:FindFirstChildOfClass("SpecialMesh") then
		local orig = V.WeaponOriginal and V.WeaponOriginal[part]
		local transp = orig and orig.Transparency or part.Transparency
		if transp >= 0.85 or name == "throwingknife" then
			return true
		end
	end
	return false
end

local function paintWeaponPart(part)
	if applyingWeapon or not part.Parent or part.Name == "Waraku_WeaponChamsOverlay" or part.Name == "TrailPart" then
		return
	end
	if isHitboxPart(part) then
		pcall(function() WeaponVisual.hide(part) end)
		return
	end
	applyingWeapon = true
	pcall(function()
		local vh = part:FindFirstChild("VH")
		if vh and vh:IsA("BasePart") then
			WeaponVisual.hide(vh)
		end
		local mesh = part:FindFirstChildOfClass("SpecialMesh")
		if mesh and mesh.MeshType == Enum.MeshType.FileMesh and mesh.MeshId ~= "" then
			ensureSpecialMeshOverlay(part, mesh)
		else
			WeaponVisual.apply(part)
			if part:IsA("MeshPart") then
				part.TextureID = ""
			end
			local existingOverlay = part:FindFirstChild("Waraku_WeaponChamsOverlay")
			if existingOverlay then
				existingOverlay:Destroy()
			end
		end
	end)
	applyingWeapon = false
end

local function paintWeaponMesh(mesh)
	if applyingWeapon or not mesh.Parent or mesh.Parent.Name == "Waraku_WeaponChamsOverlay" or mesh.Parent.Name == "TrailPart" then
		return
	end
	applyingWeapon = true
	pcall(function()
		if mesh:IsA("SpecialMesh") then
			mesh.TextureId = ""
			mesh.VertexColor = Vector3.new(V.WeaponColor.R, V.WeaponColor.G, V.WeaponColor.B)
			if mesh.MeshType == Enum.MeshType.FileMesh and mesh.MeshId ~= ""
				and mesh.Parent and mesh.Parent:IsA("BasePart") then
				ensureSpecialMeshOverlay(mesh.Parent, mesh)
			end
		end
	end)
	applyingWeapon = false
end

local function lockWeaponPart(part)
	if part.Name == "Waraku_WeaponChamsOverlay" then
		return
	end
	if isHitboxPart(part) then
		pcall(function() WeaponVisual.hide(part) end)
		return
	end
	if not V.WeaponOriginal[part] then
		V.WeaponOriginal[part] = {
			Material = part.Material,
			MaterialVariant = part.MaterialVariant,
			Color = part.Color,
			Reflectance = part.Reflectance,
			Transparency = part.Transparency,
			TextureID = part:IsA("MeshPart") and part.TextureID or nil,
		}
	end
	if part:IsA("UnionOperation") and V.WeaponOriginal[part].UsePartColor == nil then
		V.WeaponOriginal[part].UsePartColor = part.UsePartColor
	end
	paintWeaponPart(part)
	if not V.WeaponPartLocks[part] then
		local bag = {}
		local function relock()
			if applyingWeapon or not V.WeaponChams then
				return
			end
			if not isLocalWeaponRoot(part) then
				restoreWeaponPart(part)
				return
			end
			paintWeaponPart(part)
		end
		table.insert(bag, part:GetPropertyChangedSignal("Material"):Connect(relock))
		table.insert(bag, part:GetPropertyChangedSignal("MaterialVariant"):Connect(relock))
		if part:IsA("UnionOperation") then
			table.insert(bag, part:GetPropertyChangedSignal("UsePartColor"):Connect(relock))
		end
		table.insert(bag, part:GetPropertyChangedSignal("Color"):Connect(relock))
		table.insert(bag, part:GetPropertyChangedSignal("Reflectance"):Connect(relock))
		table.insert(bag, part:GetPropertyChangedSignal("Transparency"):Connect(function()
			if applyingWeapon or not V.WeaponChams then
				return
			end
			local mesh = part:FindFirstChildOfClass("SpecialMesh")
			if mesh and V.WeaponOverlays[part] and V.WeaponOverlays[part].Parent == part then
				if part.Transparency ~= 1 then
					applyingWeapon = true
					part.Transparency = 1
					applyingWeapon = false
				end
			end
		end))
		if part:IsA("MeshPart") then
			table.insert(bag, part:GetPropertyChangedSignal("TextureID"):Connect(relock))
		end
		table.insert(bag, part.AncestryChanged:Connect(function()
			if not isLocalWeaponRoot(part) then
				restoreWeaponPart(part)
			end
		end))
		V.WeaponPartLocks[part] = bag
	end
end

local function lockWeaponMesh(mesh)
	if mesh:IsA("SurfaceAppearance") or not mesh:IsA("SpecialMesh") then
		return
	end
	if mesh.Parent and mesh.Parent.Name == "Waraku_WeaponChamsOverlay" then
		return
	end
	if not V.WeaponMeshOriginal[mesh] then
		V.WeaponMeshOriginal[mesh] = {TextureId = mesh.TextureId, VertexColor = mesh.VertexColor}
	end
	paintWeaponMesh(mesh)
	if not V.WeaponMeshLocks[mesh] then
		local bag = {}
		local function relock()
			if applyingWeapon or not V.WeaponChams then
				return
			end
			if not isLocalWeaponRoot(mesh) then
				restoreWeaponMesh(mesh)
				return
			end
			paintWeaponMesh(mesh)
		end
		table.insert(bag, mesh:GetPropertyChangedSignal("TextureId"):Connect(relock))
		table.insert(bag, mesh:GetPropertyChangedSignal("VertexColor"):Connect(relock))
		table.insert(bag, mesh:GetPropertyChangedSignal("MeshId"):Connect(relock))
		table.insert(bag, mesh.AncestryChanged:Connect(function()
			if not isLocalWeaponRoot(mesh) then
				restoreWeaponMesh(mesh)
			end
		end))
		V.WeaponMeshLocks[mesh] = bag
	end
end

local function paintWeapon(root)
    if V.VoteDupeRunning then return end
	if not V.WeaponChams or not isLocalWeaponRoot(root) then
		return
	end
	local objects = {root}
	for _, child in ipairs(root:GetDescendants()) do
		table.insert(objects, child)
	end
	for _, o in ipairs(objects) do
		if o.Name ~= "Waraku_WeaponChamsOverlay" then
			if o:IsA("BasePart") then
				if isHitboxPart(o) then
					pcall(function() WeaponVisual.hide(o) end)
				elseif not BODY_NAMES[o.Name] then
					lockWeaponPart(o)
				end
			elseif o:IsA("SpecialMesh") then
				if o.Parent and not BODY_NAMES[o.Parent.Name] and not isHitboxPart(o.Parent) then
					lockWeaponMesh(o)
				end
			end
		end
	end
end

local function collectLocalWeaponRoots()
	local roots, seen = {}, {}
	local function add(root)
		if root and not seen[root] and isLocalWeaponRoot(root) then
			seen[root] = true
			table.insert(roots, root)
		end
	end
	local ch = LocalPlayer.Character
	if ch then
		for _, o in ipairs(ch:GetDescendants()) do
			if o:IsA("Tool") or ((o:IsA("Model") or o:IsA("BasePart") or o:IsA("Folder")) and looksLikeWeaponName(o.Name)) then
				add(o)
			end
		end
		for _, name in ipairs({"DisplayRefKnife", "DisplayRefGun"}) do
			local ref = ch:FindFirstChild(name, true)
			if ref and ref:IsA("ObjectValue") and ref.Value then
				add(ref.Value)
			end
		end
	end
	local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
	if bp then
		for _, o in ipairs(bp:GetChildren()) do
			if o:IsA("Tool") then
				add(o)
			end
		end
	end
	if isLocalMurderer() then
		pcall(function()
			for _, instance in ipairs(CollectionService:GetTagged("ThrowingKnife")) do
				local kv = instance:FindFirstChild("KnifeVisual")
				if kv and kv:IsA("BasePart") then
					add(kv)
				else
					add(instance)
				end
			end
		end)
		for _, child in ipairs(Workspace:GetChildren()) do
			if child.Name == "ThrowingKnife" or string.find(string.lower(child.Name), "knife", 1, true) then
				local kv = child:FindFirstChild("KnifeVisual")
				if kv and kv:IsA("BasePart") then
					add(kv)
				else
					add(child)
				end
			end
		end
	end
	return roots
end

local function pruneWeapons()
	for part, _ in pairs(V.WeaponOriginal) do
		if not part.Parent or (not isLocalWeaponRoot(part) and not flyingKnives[part]) then
			restoreWeaponPart(part)
		end
	end
	for mesh, _ in pairs(V.WeaponMeshOriginal) do
		if not mesh.Parent or (not isLocalWeaponRoot(mesh) and not flyingKnives[mesh]) then
			restoreWeaponMesh(mesh)
		end
	end
	for part, overlay in pairs(V.WeaponOverlays) do
		if not part.Parent or (not isLocalWeaponRoot(part) and not flyingKnives[part]) then
			if overlay then
				pcall(function() overlay:Destroy() end)
			end
			V.WeaponOverlays[part] = nil
		end
	end
end

local function recolorTrackedWeapons()
	if applyingWeapon then
		return
	end
	for part, _ in pairs(V.WeaponOriginal) do
		if part.Parent and isLocalWeaponRoot(part) then
			paintWeaponPart(part)
		else
			restoreWeaponPart(part)
		end
	end
	for mesh, _ in pairs(V.WeaponMeshOriginal) do
		if mesh.Parent and isLocalWeaponRoot(mesh) then
			paintWeaponMesh(mesh)
		else
			restoreWeaponMesh(mesh)
		end
	end
	for part, overlay in pairs(V.WeaponOverlays) do
		if overlay and overlay.Parent == part and isLocalWeaponRoot(part) then
			WeaponVisual.apply(overlay)
			overlay.TextureID = ""
		end
	end
	for part, info in pairs(flyingKnives) do
		if info.Overlay and info.Overlay.Parent then
			WeaponVisual.apply(info.Overlay)
			info.Overlay.TextureID = ""
		end
	end
end

local function scanWeapons()
    if V.VoteDupeRunning then return end
	if not V.WeaponChams then
		restoreWeapons()
		return
	end
	for _, root in ipairs(collectLocalWeaponRoots()) do
		paintWeapon(root)
	end
	pruneWeapons()
end

local function watchDisplayRef(ref)
	if not (ref and ref:IsA("ObjectValue")) then
		return
	end
	if V.WeaponChams and ref.Value then
		task.defer(paintWeapon, ref.Value)
	end
	con(ref:GetPropertyChangedSignal("Value"), function()
		if V.WeaponChams and ref.Value then
			task.defer(paintWeapon, ref.Value)
		end
		pruneWeapons()
	end,V.LocalWeaponConnections)
end

V.LocalWeaponConnections={}
local function watchLocalCharacter(ch)
    clearCons(V.LocalWeaponConnections)
	con(ch.ChildAdded, function(o)
		if not V.WeaponChams then
			return
		end
		if o:IsA("Tool") or looksLikeWeaponName(o.Name) then
			task.defer(paintWeapon, o)
		elseif o:IsA("ObjectValue") and (o.Name == "DisplayRefKnife" or o.Name == "DisplayRefGun") then
			watchDisplayRef(o)
			if o.Value then
				task.defer(paintWeapon, o.Value)
			end
		end
	end,V.LocalWeaponConnections)
	con(ch.ChildRemoved, function(o)
		if o:IsA("Tool") or looksLikeWeaponName(o.Name) then
			task.defer(pruneWeapons)
		end
	end,V.LocalWeaponConnections)
	con(ch.DescendantAdded, function(o)
		if not V.WeaponChams then
			return
		end
		if (o:IsA("Tool") or o:IsA("BasePart") or o:IsA("SpecialMesh")) and isLocalWeaponRoot(o) then
			task.defer(paintWeapon, o)
		end
	end,V.LocalWeaponConnections)
	for _, name in ipairs({"DisplayRefKnife", "DisplayRefGun"}) do
		watchDisplayRef(ch:FindFirstChild(name, true))
	end
	if V.WeaponChams then
		task.defer(scanWeapons)
	end
end

if LocalPlayer.Character then
	watchLocalCharacter(LocalPlayer.Character)
end
con(LocalPlayer.CharacterAdded, function(ch)
    V.VisualRespawnQuietUntil=os.clock()+0.20
	restoreWeapons()
	watchLocalCharacter(ch)
end)
con(LocalPlayer.CharacterRemoving, function()
    clearCons(V.LocalWeaponConnections)
	restoreWeapons()
end)

local function handleThrowingKnife(inst)
	if not isLocalMurderer() or not inst or inst.Name == "Waraku_WeaponChamsOverlay" or inst.Name == "TrailPart" then
		return
	end
	trackedThrownRoots[inst] = true
	if inst.Destroying then
		con(inst.Destroying, function() trackedThrownRoots[inst] = nil end)
	end
	if V.WeaponChams then
		task.defer(paintWeapon, inst)
	end
	for _, desc in ipairs(inst:GetDescendants()) do
		if desc.Name ~= "Waraku_WeaponChamsOverlay" and desc.Name ~= "TrailPart" and (desc:IsA("BasePart") or desc:IsA("SpecialMesh")) then
			if V.WeaponChams then
				task.defer(paintWeapon, desc)
			end
		end
	end
	con(inst.DescendantAdded, function(desc)
		if not isLocalMurderer() then return end
		if desc.Name ~= "Waraku_WeaponChamsOverlay" and desc.Name ~= "TrailPart" and (desc:IsA("BasePart") or desc:IsA("SpecialMesh")) then
			if V.WeaponChams then
				task.defer(paintWeapon, desc)
			end
		end
	end)
end

con(CollectionService:GetInstanceAddedSignal("ThrowingKnife"), function(inst)
	if isLocalMurderer() then
		handleThrowingKnife(inst)
	end
end)
if isLocalMurderer() then
	for _, inst in ipairs(CollectionService:GetTagged("ThrowingKnife")) do
		handleThrowingKnife(inst)
	end
end
con(Workspace.ChildAdded, function(child)
	if not isLocalMurderer() then return end
	local lname = string.lower(child.Name)
	if lname == "throwingknife" or lname == "knifevisual" or string.find(lname, "knife", 1, true) or string.find(lname, "throwing", 1, true) or CollectionService:HasTag(child, "ThrowingKnife") then
		handleThrowingKnife(child)
	end
end)
con(Workspace.DescendantAdded, function(desc)
	if not isLocalMurderer() then return end
	if desc.Name == "KnifeVisual" or desc:GetAttribute("Direction") ~= nil then
		if V.WeaponChams then
			task.defer(paintWeapon, desc)
		end
	end
end)

local weaponTick = 0
local lastWeaponState = false
con(RunService.Heartbeat, function(dt)
	if not V.WeaponChams then
		if lastWeaponState then
			lastWeaponState = false
			restoreWeapons()
		end
		weaponTick = 0
		return
	end
	lastWeaponState = true
	weaponTick += dt
	if weaponTick >= 0.5 then
		weaponTick = 0
		scanWeapons()
	end
end)

do
    local list={{}}
    local function refresh()
        local character = LocalPlayer.Character
        if V.LocalChamsEnabled and character and character.Parent and not V.Destroying and not V.Destroyed then
            local data = playerData(LocalPlayer)
            local color = V.LocalChamsRoleColor and visualRoleColor(LocalPlayer, data) or V.LocalChamsColor
            local item=list[1]
            item[1],item[2],item[3]=LocalPlayer,character,color
            XT.localLitStep(list)
        else
            XT.localLitStep(nil)
        end
    end

    V.RefreshLocalChams = function()
        VisualCache.invalidate()
        refresh()
    end
    con(RunService.RenderStepped, refresh)
end

local OriginalWorld = {
	Brightness = Lighting.Brightness,
	ClockTime = Lighting.ClockTime,
	FogStart = Lighting.FogStart,
	FogEnd = Lighting.FogEnd,
	FogColor = Lighting.FogColor,
	GlobalShadows = Lighting.GlobalShadows,
	Ambient = Lighting.Ambient,
	OutdoorAmbient = Lighting.OutdoorAmbient,
	ExposureCompensation = Lighting.ExposureCompensation,
	ShadowSoftness = Lighting.ShadowSoftness,
	EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
	EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
	GeographicLatitude = Lighting.GeographicLatitude,
	ColorShift_Top = Lighting.ColorShift_Top,
	ColorShift_Bottom = Lighting.ColorShift_Bottom,
	FOV = Camera and Camera.FieldOfView or 70,
}
local AtmosphereOriginal = setmetatable({}, {__mode = "k"})
local WorldCC = Instance.new("ColorCorrectionEffect")
WorldCC.Name = "Waraku_WORLD_COLOR"
WorldCC.Enabled = false
WorldCC.Parent = Lighting
local WorldBloom = Instance.new("BloomEffect")
WorldBloom.Name = "Waraku_WORLD_BLOOM"
WorldBloom.Enabled = false
WorldBloom.Parent = Lighting
local WorldSun = Instance.new("SunRaysEffect")
WorldSun.Name = "Waraku_WORLD_SUNRAYS"
WorldSun.Enabled = false
WorldSun.Parent = Lighting

local WorldExtra = {originalEffects = setmetatable({}, {__mode = "k"}), active = false,
    originals = setmetatable({}, {__mode = "k"}), owned = {},
    cameraFOV = setmetatable({}, {__mode = "k"})}

function WorldExtra.override(object, properties)
    if not object then return end
    local snapshot = WorldExtra.originals[object]
    if not snapshot then snapshot = {} WorldExtra.originals[object] = snapshot end
    for key, value in pairs(properties) do
        if snapshot[key] == nil then snapshot[key] = object[key] end
        if object[key] ~= value then object[key] = value end
    end
end
function WorldExtra.restoreClass(className)
    for object, snapshot in pairs(WorldExtra.originals) do
        if object:IsA(className) then
            pcall(function() for key, value in pairs(snapshot) do object[key] = value end end)
            WorldExtra.originals[object] = nil
        end
    end
end
function WorldExtra.applyEnvironment()
    local enabled = V.WorldEnabled
    if enabled and V.WorldSkyOverride then
        local sky = Lighting:FindFirstChildOfClass("Sky")
        if not sky then
            sky = Instance.new("Sky") sky.Name = "Waraku_WORLD_SKY" sky.Parent = Lighting
            WorldExtra.owned.sky = sky
        end
        WorldExtra.override(sky, {StarCount = math.clamp(math.floor(V.WorldStars), 0, 10000),
            SunAngularSize = math.clamp(V.WorldSunSize, 0, 60), MoonAngularSize = math.clamp(V.WorldMoonSize, 0, 60),
            CelestialBodiesShown = V.WorldCelestialBodies,
            SkyboxOrientation = Vector3.new(V.WorldSkyPitch,V.WorldSkyYaw,V.WorldSkyRoll)})
    else
        WorldExtra.restoreClass("Sky")
        if WorldExtra.owned.sky then WorldExtra.owned.sky:Destroy() WorldExtra.owned.sky = nil end
    end
    local terrain = Workspace:FindFirstChildOfClass("Terrain")
    if enabled and V.WorldWaterOverride and terrain then
        WorldExtra.override(terrain, {WaterColor = V.WorldWaterColor,
            WaterTransparency = math.clamp(V.WorldWaterTransparency, 0, 1),
            WaterReflectance = math.clamp(V.WorldWaterReflectance, 0, 1),
            WaterWaveSize = math.clamp(V.WorldWaterWaveSize, 0, 1),
            WaterWaveSpeed = math.clamp(V.WorldWaterWaveSpeed, 0, 100)})
    else WorldExtra.restoreClass("Terrain") end
    if enabled and V.WorldCloudOverride and terrain then
        local clouds = terrain:FindFirstChildOfClass("Clouds")
        if not clouds then
            clouds = Instance.new("Clouds") clouds.Name = "Waraku_WORLD_CLOUDS" clouds.Parent = terrain
            WorldExtra.owned.clouds = clouds
        end
        WorldExtra.override(clouds, {Enabled = true, Color = V.WorldCloudColor,
            Cover = math.clamp(V.WorldCloudCover, 0, 1), Density = math.clamp(V.WorldCloudDensity, 0, 1)})
    else
        WorldExtra.restoreClass("Clouds")
        if WorldExtra.owned.clouds then WorldExtra.owned.clouds:Destroy() WorldExtra.owned.clouds = nil end
    end
end
for _, info in ipairs({{"dof", "DepthOfFieldEffect"}, {"blur", "BlurEffect"}}) do
    local effect = Instance.new(info[2])
    effect.Name = "Waraku_WORLD_" .. string.upper(info[1])
    effect.Enabled = false
    effect.Parent = Lighting
    WorldExtra[info[1]] = effect
end
local function captureAtmosphere(a)
	if AtmosphereOriginal[a] then
		return
	end
	AtmosphereOriginal[a] = {
		Density = a.Density,
		Offset = a.Offset,
		Color = a.Color,
		Decay = a.Decay,
		Glare = a.Glare,
		Haze = a.Haze,
	}
end

local function restoreAtmosphere()
	for a, d in pairs(AtmosphereOriginal) do
		if a.Parent then
			pcall(function()
				a.Density = d.Density
				a.Offset = d.Offset
				a.Color = d.Color
				a.Decay = d.Decay
				a.Glare = d.Glare
				a.Haze = d.Haze
			end)
		end
        AtmosphereOriginal[a] = nil
	end
end

do
local lights=setmetatable({}, {__mode="k"})
    local gravityOriginal
    local dayStart,dayBase,dayRate
    local active=false
    local function isMapLight(object)
        return object:IsA("PointLight") or object:IsA("SpotLight") or object:IsA("SurfaceLight")
    end
    local function addLight(object)
        if not isMapLight(object) or lights[object] then return end
        if object:FindFirstAncestorOfClass("Tool") then return end
        for _,player in ipairs(Players:GetPlayers()) do
            if player.Character and object:IsDescendantOf(player.Character) then return end
        end
        lights[object]={Brightness=object.Brightness,Range=object.Range,Color=object.Color,Shadows=object.Shadows}
    end
    local function restoreLights()
        for light,original in pairs(lights) do
            if light.Parent then pcall(function()
                for key,value in pairs(original) do light[key]=value end
            end) end
            lights[light]=nil
        end
    end
    con(Workspace.DescendantAdded,function(object)
        if active then addLight(object) end
    end)
    function WorldExtra.clock()
        if not V.WorldDayCycle then dayStart=nil; return V.WorldClock end
        if not dayStart or dayBase~=V.WorldClock or dayRate~=V.WorldDaySpeed then
            dayStart,dayBase,dayRate=os.clock(),V.WorldClock,V.WorldDaySpeed
        end
        return (dayBase+(os.clock()-dayStart)*math.clamp(dayRate,0.01,2))%24
    end
    function WorldExtra.applyDetails()
        local overrideGravity=V.WorldEnabled and V.WorldGravityOverride
        if overrideGravity then
            if gravityOriginal==nil then gravityOriginal=Workspace.Gravity end
            Workspace.Gravity=math.clamp(V.WorldGravity,0,400)
        elseif gravityOriginal~=nil then
            Workspace.Gravity=gravityOriginal; gravityOriginal=nil
        end
        local enabled=V.WorldEnabled and V.WorldLightsOverride
        if enabled and not active then
            for _,object in ipairs(Workspace:GetDescendants()) do addLight(object) end
        elseif not enabled and active then restoreLights() end
        active=enabled
        if enabled then
            for light,original in pairs(lights) do
                if light.Parent then
                    VisualCache.set(light,"Brightness",math.clamp(original.Brightness*V.WorldLightBrightness,0,50))
                    VisualCache.set(light,"Range",math.clamp(original.Range*V.WorldLightRange,0,60))
                    VisualCache.set(light,"Color",original.Color:Lerp(V.WorldLightColor,math.clamp(V.WorldLightTint,0,1)))
                    VisualCache.set(light,"Shadows",V.WorldLightShadows)
                else lights[light]=nil end
            end
        end
    end
end

local function applyWorld()
	Camera = Workspace.CurrentCamera or Camera
    local previous = WorldExtra.fovCamera
    if previous and (not V.FOVEnabled or previous ~= Camera) then
        local original = WorldExtra.cameraFOV[previous]
        if original then pcall(function() previous.FieldOfView = original end) end
        WorldExtra.cameraFOV[previous] = nil
        WorldExtra.fovCamera = nil
    end
    if V.FOVEnabled and Camera then
        if not WorldExtra.cameraFOV[Camera] then WorldExtra.cameraFOV[Camera] = Camera.FieldOfView end
        Camera.FieldOfView = math.clamp(tonumber(V.FOV) or 70, 1, 120)
        WorldExtra.fovCamera = Camera
    end
    local lightingActive = V.WorldEnabled or V.Fullbright
    if lightingActive and not WorldExtra.lightingActive then

        for key in pairs(OriginalWorld) do
            if key ~= "FOV" then OriginalWorld[key] = Lighting[key] end
        end
    end
    WorldExtra.applyEnvironment()
    WorldExtra.applyDetails()

    local isolate = V.WorldEnabled and V.WorldDisableGameEffects
    for effect, enabled in pairs(WorldExtra.originalEffects) do
        local inScope = effect.Parent == Lighting or effect.Parent == Camera
        if not isolate or not inScope then
            pcall(function() effect.Enabled = enabled end)
            WorldExtra.originalEffects[effect] = nil
        end
    end
    if isolate then
        for _, parent in ipairs(Camera and {Lighting, Camera} or {Lighting}) do
            for _, effect in ipairs(parent:GetChildren()) do
                if effect:IsA("PostEffect") and effect ~= WorldCC and effect ~= WorldBloom
                    and effect ~= WorldSun and effect ~= WorldExtra.dof and effect ~= WorldExtra.blur then
                    if WorldExtra.originalEffects[effect] == nil then WorldExtra.originalEffects[effect] = effect.Enabled end
                    effect.Enabled = false
                end
            end
        end
    end
    if not V.WorldEnabled then
        VisualCache.set(WorldExtra.dof,"Enabled",false)
        VisualCache.set(WorldExtra.blur,"Enabled",false)
        if WorldExtra.atmosphere then WorldExtra.atmosphere:Destroy() WorldExtra.atmosphere = nil end
    end
	if V.WorldEnabled then
		VisualCache.set(Lighting,"Brightness",V.WorldBrightness)
		VisualCache.set(Lighting,"ClockTime",WorldExtra.clock())
		VisualCache.set(Lighting,"Ambient",V.WorldAmbient)
		VisualCache.set(Lighting,"OutdoorAmbient",V.WorldOutdoor)
		VisualCache.set(Lighting,"FogColor",V.WorldFogColor)
		VisualCache.set(Lighting,"FogStart",V.WorldFog and V.WorldFogStart or 100000)
		VisualCache.set(Lighting,"FogEnd",V.WorldFog and math.max(V.WorldFogStart + 1, V.WorldFogEnd) or 100001)
		VisualCache.set(Lighting,"GlobalShadows",V.WorldShadows)
		VisualCache.set(Lighting,"ShadowSoftness",V.WorldShadowSoftness)
		VisualCache.set(Lighting,"ExposureCompensation",V.WorldExposure)
		VisualCache.set(Lighting,"EnvironmentDiffuseScale",V.WorldEnvDiffuse)
		VisualCache.set(Lighting,"EnvironmentSpecularScale",V.WorldEnvSpecular)
		VisualCache.set(Lighting,"GeographicLatitude",V.WorldLatitude)
		VisualCache.set(Lighting,"ColorShift_Top",V.WorldColorShiftTop)
		VisualCache.set(Lighting,"ColorShift_Bottom",V.WorldColorShiftBottom)
		VisualCache.set(WorldCC,"Enabled",V.WorldColorGrading)
		VisualCache.set(WorldCC,"TintColor",V.WorldTint)
		VisualCache.set(WorldCC,"Saturation",V.WorldSaturation)
		VisualCache.set(WorldCC,"Contrast",V.WorldContrast)
		VisualCache.set(WorldCC,"Brightness",V.WorldCCBrightness)
		VisualCache.set(WorldBloom,"Enabled",V.WorldBloom)
		VisualCache.set(WorldBloom,"Intensity",V.WorldBloomIntensity)
		VisualCache.set(WorldBloom,"Size",V.WorldBloomSize)
		VisualCache.set(WorldBloom,"Threshold",V.WorldBloomThreshold)
		VisualCache.set(WorldSun,"Enabled",V.WorldSunRays)
		VisualCache.set(WorldSun,"Intensity",V.WorldSunIntensity)
		VisualCache.set(WorldSun,"Spread",V.WorldSunSpread)
        VisualCache.set(WorldExtra.dof,"Enabled",V.WorldDOF)
        VisualCache.set(WorldExtra.dof,"FocusDistance",math.clamp(V.WorldFocusDistance, 0, 10000))
        VisualCache.set(WorldExtra.dof,"InFocusRadius",math.clamp(V.WorldFocusRadius, 0, 500))
        VisualCache.set(WorldExtra.dof,"NearIntensity",math.clamp(V.WorldNearIntensity, 0, 1))
        VisualCache.set(WorldExtra.dof,"FarIntensity",math.clamp(V.WorldFarIntensity, 0, 1))
        VisualCache.set(WorldExtra.blur,"Enabled",V.WorldBlur)
        VisualCache.set(WorldExtra.blur,"Size",math.clamp(V.WorldBlurSize, 0, 56))
        if not Lighting:FindFirstChildOfClass("Atmosphere") then
            WorldExtra.atmosphere = Instance.new("Atmosphere")
            WorldExtra.atmosphere.Name = "Waraku_WORLD_ATMOSPHERE"
            WorldExtra.atmosphere.Parent = Lighting
        end
		for _, a in ipairs(Lighting:GetChildren()) do
			if a:IsA("Atmosphere") then
				if a ~= WorldExtra.atmosphere then captureAtmosphere(a) end
				if V.RemoveAtmosphere then
					a.Density = 0
					a.Haze = 0
					a.Glare = 0
				else
					a.Density = V.WorldAtmoDensity
					a.Offset = V.WorldAtmoOffset
					a.Haze = V.WorldAtmoHaze
					a.Glare = V.WorldAtmoGlare
					a.Color = V.WorldAtmoColor
					a.Decay = V.WorldAtmoDecay
				end
			end
		end
	elseif V.Fullbright then
        for k, x in pairs(OriginalWorld) do
            if k~="FOV" and k~="Brightness" and k~="ClockTime" and k~="FogStart" and k~="FogEnd"
                and k~="GlobalShadows" and k~="Ambient" and k~="OutdoorAmbient" then
                pcall(function() VisualCache.set(Lighting,k,x) end)
            end
        end
		restoreAtmosphere()
		VisualCache.set(Lighting,"Brightness",3)
		VisualCache.set(Lighting,"ClockTime",14)
		VisualCache.set(Lighting,"FogStart",100000)
		VisualCache.set(Lighting,"FogEnd",100001)
		VisualCache.set(Lighting,"GlobalShadows",false)
		VisualCache.set(Lighting,"Ambient",Color3.fromRGB(180, 180, 180))
		VisualCache.set(Lighting,"OutdoorAmbient",Color3.fromRGB(180, 180, 180))
		VisualCache.set(WorldCC,"Enabled",false)
		VisualCache.set(WorldBloom,"Enabled",false)
		VisualCache.set(WorldSun,"Enabled",false)
	elseif WorldExtra.lightingActive then
		for k, x in pairs(OriginalWorld) do
			if k ~= "FOV" then
				pcall(function()
					Lighting[k] = x
				end)
			end
		end
		VisualCache.set(WorldCC,"Enabled",false)
		VisualCache.set(WorldBloom,"Enabled",false)
		VisualCache.set(WorldSun,"Enabled",false)
		restoreAtmosphere()
	end
    WorldExtra.lightingActive = lightingActive
end

con(RunService.RenderStepped, function()
    local active = V.WorldEnabled or V.Fullbright or V.FOVEnabled

    if active or WorldExtra.active then applyWorld() end
    WorldExtra.active = active
end)

function V:SetEnabled(x)
	self.Enabled = x == true
	refreshStatic()
end

function V:Destroy(fromLibrary)
	if self.Destroying or self.Destroyed then
		return
	end
	self.Destroying = true
    if self.ESPPreview then
        self.ESPPreview:Destroy()
        self.ESPPreview = nil
    end
    clearCons(self.LocalWeaponConnections)
    VisualCache.destroy()
    if self.RestoreUtilities then pcall(self.RestoreUtilities) end
    if self.RestoreServerPlayers then pcall(self.RestoreServerPlayers) end
    if self.RestorePlayer then pcall(self.RestorePlayer) end
	self.Enabled = false
	if self.RestoreCombat then
		pcall(self.RestoreCombat)
	end
	if self.RestoreHat then
		pcall(self.RestoreHat)
	end
	if self.RestoreLit then
		pcall(self.RestoreLit)
	end
    if self.RestoreSkeleton then pcall(self.RestoreSkeleton) end
	if self.RestoreLocalChams then pcall(self.RestoreLocalChams) end
	clearCons(self.Connections)
	for _, b in pairs(self.PlayerConnections) do
		clearCons(b)
	end
	for _, b in pairs(self.CharacterConnections) do
		clearCons(b)
	end
	table.clear(self.PlayerConnections)
	table.clear(self.CharacterConnections)
	for _, p in ipairs(Players:GetPlayers()) do
		clearVisual(p)
		if p.Character then
			for _, c in ipairs(p.Character:GetChildren()) do
				if c:IsA("Highlight") and string.sub(c.Name, 1, 7) == "Waraku_" then
					pcall(function() c:Destroy() end)
				end
			end
		end
	end
	restoreAllPlayerChams()
	restoreWeapons()
	for _, t in ipairs(self.Tracers) do
		if t.Part then
			t.Part:Destroy()
		elseif t.Line then
			destroyGui(t.Line)
		end
		if t.Start then t.Start:Destroy() end
		if t.Finish then t.Finish:Destroy() end
	end
	table.clear(self.Tracers)
	if self.GunHighlight then
		self.GunHighlight:Destroy()
	end
	if self.GunBillboard then
		self.GunBillboard:Destroy()
	end
	clearCorpses()
    if V.DrawByPlayer then
        for player in pairs(V.DrawByPlayer) do destroyPlayerVisual(player) end
    end

	clearTracers()
	self.Fullbright = false
	self.WorldEnabled = false
	self.FOVEnabled = false
	applyWorld()
	if self.ESPGui then
		pcall(function() self.ESPGui:Destroy() end)
	end
	if ESPGui then
		pcall(function() ESPGui:Destroy() end)
	end
    WorldExtra.dof:Destroy()
    WorldExtra.blur:Destroy()
	if WorldCC then
		WorldCC:Destroy()
	end
	if WorldBloom then
		WorldBloom:Destroy()
	end
	if WorldSun then
		WorldSun:Destroy()
	end
	if self.RestoreCombat then
		pcall(self.RestoreCombat)
	end
	if self.RestoreHat then
		pcall(self.RestoreHat)
	end
	if self.RestoreLit then
		pcall(self.RestoreLit)
	end
	if self.Library and not fromLibrary then
		pcall(function()
			self.Library:Unload()
		end)
	end
	if env.Waraku == self then
		env.Waraku = nil
	end
	self.Destroyed = true
end

local WOLFUI_URL = "https://raw.githubusercontent.com/AWLOID/WolfUi/refs/heads/main/WolfUi.lua"
local okLibrary, Lib = pcall(function()
    local source = type(env.WarakuLibrarySource) == "string" and env.WarakuLibrarySource or nil
    V.LibrarySource = source and "Injected" or "Remote"
    if not source and type(isfile) == "function" and type(readfile) == "function" then
        local path = type(env.WarakuLibraryPath) == "string" and env.WarakuLibraryPath or "WolfUi.lua"
        if isfile(path) then
            source = readfile(path)
            if type(source) ~= "string" or source == "" then error("Empty WolfUi source: " .. path) end
            V.LibrarySource = "Local: " .. path
        elseif type(env.WarakuLibraryPath) == "string" then
            error("WolfUi file not found: " .. path)
        end
    end
    if not source then source = game:HttpGet(WOLFUI_URL) end
    local chunk, compileError = loadstring(source)
    if not chunk then error(compileError) end
    return chunk()
end)
if not okLibrary or type(Lib) ~= "table" or type(Lib.CreateWindow) ~= "function" then
	local libraryError = okLibrary and "invalid library response" or tostring(Lib)
	V:Destroy()
	error("WolfUi failed to load: " .. libraryError)
end
V.LibraryVersion = Lib.Version
V.PlayersListRevision = Lib.PlayersListRevision
if Lib.SetConfigAliases then Lib:SetConfigAliases({["V.NameGradientColor1"]="V.NameColor"}) end
                                                                                    
local function installCardNotificationCompatibility(Library)
    if type(Library.NotifyCards)=="function" and Library.CardNotificationVersion=="5.9.3" then return end
    local UI_FONT,UI_FONT_BOLD=Enum.Font.Gotham,Enum.Font.GothamBold
    local white=Color3.fromRGB(245,246,249)
    local palette=Library.Palette or {Color3.fromRGB(15,15,17),Color3.fromRGB(22,22,25),white,Color3.fromRGB(31,31,35),Color3.fromRGB(70,70,76)}
    local Maid=Library.MaidClass
    if not Maid then
        Maid={}
        function Maid.new()
            local maid={Tasks={},Destroyed=false}
            local function clean(item)
                if typeof(item)=="RBXScriptConnection" then item:Disconnect()
                elseif typeof(item)=="Instance" then item:Destroy()
                elseif type(item)=="function" then item() end
            end
            function maid:Add(item,key)
                key=key or (#self.Tasks+1)
                if self.Tasks[key] then pcall(clean,self.Tasks[key]) end
                self.Tasks[key]=item
                return item
            end
            function maid:Connect(signal,callback) return self:Add(signal:Connect(callback)) end
            function maid:Once(signal,callback)
                local connection
                connection=self:Connect(signal,function(...) connection:Disconnect();callback(...) end)
                return connection
            end
            function maid:Destroy()
                if self.Destroyed then return end
                self.Destroyed=true
                for _,item in pairs(self.Tasks) do pcall(clean,item) end
                self.Tasks={}
            end
            return maid
        end
    end
    local function new(class,parent,props)
        local object=Instance.new(class)
        for key,value in pairs(props or {}) do object[key]=value end
        object.Parent=parent
        return object
    end
    local function rect(parent,x,y,w,h,color,radius,class)
        local object=new(class or "Frame",parent,{Position=UDim2.fromOffset(x,y),Size=UDim2.fromOffset(w,h),
            BackgroundColor3=color or white,BorderSizePixel=0})
        if object:IsA("TextButton") then object.Text="";object.AutoButtonColor=false;object.Font=UI_FONT end
        if radius and radius>0 then new("UICorner",object,{CornerRadius=UDim.new(0,radius)}) end
        return object
    end
    local function iconLabel(parent,_,x,y,w,color,fallback)
        return new("TextLabel",parent,{BackgroundTransparency=1,Position=UDim2.fromOffset(x,y),
            Size=UDim2.fromOffset(w,w),Text=fallback or "M",TextColor3=color,TextSize=14,Font=UI_FONT_BOLD})
    end
                                                                         
    local iconSheet=Library.Icons or {}
    local sizeIndex,offsetIndex=2,3
    do
        local seen={[2]={},[3]={}};local distinct={[2]=0,[3]=0};local sampled=0
        for _,data in pairs(iconSheet) do
            if type(data)=="table" and type(data[2])=="table" and type(data[3])=="table" then
                sampled=sampled+1
                for _,index in ipairs({2,3}) do
                    local key=tostring(data[index][1]).."x"..tostring(data[index][2])
                    if not seen[index][key] then seen[index][key]=true;distinct[index]=distinct[index]+1 end
                end
                if sampled>=64 then break end
            end
        end
        if sampled>1 and distinct[3]<distinct[2] then sizeIndex,offsetIndex=3,2 end
    end
    function Library:CreateCheckMark(parent,x,y,size,color)
        local data=iconSheet.check or iconSheet.Check
        local object,isImage
        if type(data)=="table" and type(data[sizeIndex])=="table" and type(data[offsetIndex])=="table" then
            local asset=data[1]
            local image=type(asset)=="string" and asset:find("://",1,true) and asset or "rbxassetid://"..tostring(asset)
            object=new("ImageLabel",parent,{BackgroundTransparency=1,Position=UDim2.fromOffset(math.floor(x+0.5),math.floor(y+0.5)),
                Size=UDim2.fromOffset(math.floor(size+0.5),math.floor(size+0.5)),Image=image,
                ImageRectOffset=Vector2.new(data[offsetIndex][1],data[offsetIndex][2]),ImageRectSize=Vector2.new(data[sizeIndex][1],data[sizeIndex][2]),
                ImageColor3=color,ScaleType=Enum.ScaleType.Fit,ZIndex=2})
            isImage=true
        else
            object=new("TextLabel",parent,{BackgroundTransparency=1,Position=UDim2.fromOffset(math.floor(x+0.5),math.floor(y+0.5)),
                Size=UDim2.fromOffset(math.floor(size+0.5),math.floor(size+0.5)),Text="v",Font=UI_FONT_BOLD,TextSize=math.max(8,size-4),
                TextColor3=color,TextXAlignment=Enum.TextXAlignment.Center,TextYAlignment=Enum.TextYAlignment.Center,ZIndex=2})
        end
        local api={Object=object,IsImage=isImage}
        function api:Alpha(value)
            local alpha=math.clamp(value,0,1)
            if isImage then object.ImageTransparency=1-alpha else object.TextTransparency=1-alpha end
        end
        function api:Color(value) if isImage then object.ImageColor3=value else object.TextColor3=value end end
        return api
    end

    function Library:NotifyCards(opts)
        opts=opts or {}
        local window=self.Window
        if not window or not window.Gui or not window.Gui.Parent then return nil end
        local maid=Maid.new(Library.Maid)
        local ok,result=pcall(function()
        local api={Maid=maid,Destroyed=false,Closing=false,Selected=nil,Cards={}}
        local width,height=296,142
        local colors=Library.Palette or palette
        local tweenService=game:GetService("TweenService")
        local panel=rect(window.Gui,0,0,width,height,colors[2],10,"CanvasGroup")
        panel.Name="CardNotification"
        panel.AnchorPoint=Vector2.new(0,0)
        panel.ZIndex=80
        panel.GroupTransparency=1
        panel.BackgroundTransparency=0.20
        panel.ClipsDescendants=true
        maid:Add(panel)
        api.Object=panel
        local scale=new("UIScale",panel,{Scale=1})
        new("UIStroke",panel,{Color=colors[5],Thickness=1,Transparency=0.56})
        new("UIGradient",panel,{Rotation=105,Color=ColorSequence.new(Color3.fromRGB(255,255,255),Color3.fromRGB(220,220,220))})
        local function label(parent,caption,x,y,w,h,size,color,bold)
            return new("TextLabel",parent,{BackgroundTransparency=1,BorderSizePixel=0,
                Position=UDim2.fromOffset(x,y),Size=UDim2.fromOffset(w,h),Text=tostring(caption),
                Font=bold and UI_FONT_BOLD or UI_FONT,TextSize=size,TextColor3=color or white,
                TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,ZIndex=82})
        end
        label(panel,opts.Title or "Map vote",10,8,151,16,11,colors[3],true)
        local subtitle=label(panel,opts.Text or "Choose a map",10,25,width-20,13,9,colors[3])
        subtitle.TextTransparency=0.36
        local control=rect(panel,171,8,82,22,colors[4],6)
        control.ZIndex=85;control.BackgroundTransparency=0.16
        local value=label(control,"10",21,0,40,22,11,colors[3],true)
        value.TextXAlignment=Enum.TextXAlignment.Center;value.ZIndex=87
        local countValue=math.clamp(math.floor(tonumber(opts.Value) or 10),1,100)
        local minus=rect(control,0,0,21,22,colors[4],6,"TextButton")
        local plus=rect(control,61,0,21,22,colors[4],6,"TextButton")
        for _,button in ipairs({minus,plus}) do button.ZIndex=88;button.TextColor3=colors[3];button.TextSize=14;button.BackgroundTransparency=1 end
        minus.Text="−";plus.Text="+"
        api.ValueLabel=value
        function api:SetValue(number,silent)
            if self.Destroyed or self.Closing then return end
            countValue=math.clamp(math.floor(tonumber(number) or 10),1,100)
            self.Value=countValue;value.Text=tostring(countValue)
            if not silent and opts.ValueChanged then opts.ValueChanged(countValue,self) end
        end
        maid:Connect(minus.Activated,function() api:SetValue(countValue-1) end)
        maid:Connect(plus.Activated,function() api:SetValue(countValue+1) end)
        api:SetValue(countValue,true)
        local close=rect(panel,width-33,7,23,23,colors[4],6,"TextButton")
        close.ZIndex=89;close.BackgroundTransparency=1;close.Text="×";close.TextSize=17;close.TextColor3=colors[3]
        local cells={}
        local function applySelected()
            for _,cell in ipairs(cells) do
                local on=cell.Def and tostring(cell.Def.Id)==api.Selected
                cell.Edge.Transparency=on and 0 or 0.4
                cell.Edge.Color=on and colors[3] or colors[5]
                local tint=Library.Accent or colors[3]
                cell.Edge.Color=on and tint or colors[5]
                cell.CheckFill.BackgroundColor3=tint
                cell.CheckFill.BackgroundTransparency=on and (1-(Library.AccentAlpha or 1)) or 1
                cell.CheckFill.Size=UDim2.fromOffset(on and 14 or 0,on and 14 or 0)
                cell.CheckFill.Position=UDim2.fromOffset(on and 0 or 7,on and 0 or 7)
                cell.CheckMark:Alpha(on and 1 or 0)
                cell.CheckStroke.Color=on and tint or colors[5]
            end
        end
        for index=1,3 do
            local x=10+(index-1)*94
            local group=rect(panel,x,44,88,88,colors[4],7,"CanvasGroup")
            group.ZIndex=82;group.ClipsDescendants=true;group.BackgroundTransparency=0.16
            new("UIGradient",group,{Rotation=105,Color=ColorSequence.new(Color3.fromRGB(255,255,255),Color3.fromRGB(220,220,220))})
            local cellScale=new("UIScale",group,{Scale=1})
            local edge=new("UIStroke",group,{Color=colors[5],Thickness=1,Transparency=0.55})
            local image=new("ImageLabel",group,{Position=UDim2.fromOffset(6,6),Size=UDim2.fromOffset(76,60),
                BackgroundColor3=colors[1],BackgroundTransparency=0.35,BorderSizePixel=0,
                Image="",ScaleType=Enum.ScaleType.Crop,ZIndex=83})
            new("UICorner",image,{CornerRadius=UDim.new(0,3)})
            local placeholder=label(group,"",6,21,76,30,18,colors[3],true)
            placeholder.TextXAlignment=Enum.TextXAlignment.Center
            local title=label(group,"",6,71,76,14,9,colors[3],false)
            title.TextXAlignment=Enum.TextXAlignment.Center;title.ZIndex=85
            local pill=rect(group,10,9,20,17,colors[2],5);pill.BackgroundTransparency=0.1;pill.ZIndex=85
            local count=label(pill,"0",0,0,20,17,9,colors[3],true);count.ZIndex=86;count.TextXAlignment=Enum.TextXAlignment.Center
            local check=rect(group,64,10,14,14,colors[1],3)
            check.ZIndex=85;check.BackgroundTransparency=0.15
            local checkStroke=new("UIStroke",check,{Color=colors[5],Thickness=1,Transparency=0.3})
            checkStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
            local checkFill=rect(check,7,7,0,0,Library.Accent or colors[3],3);checkFill.ZIndex=86
            local checkMark=Library:CreateCheckMark(check,1,1,12,Color3.new(0,0,0))
            checkMark.Object.ZIndex=87;checkMark:Alpha(0)
            local button=new("TextButton",group,{Text="",BackgroundTransparency=1,AutoButtonColor=false,
                Size=UDim2.fromScale(1,1),ZIndex=90})
            local cell={Group=group,Image=image,Placeholder=placeholder,Title=title,Count=count,Check=check,CheckFill=checkFill,CheckMark=checkMark,CheckStroke=checkStroke,Edge=edge}
            cells[index]=cell
            local function hover(on)
                if api.Destroyed or api.Closing then return end
                local tween=tweenService:Create(cellScale,TweenInfo.new(0.12,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Scale=on and 0.97 or 1})
                maid:Add(tween,"hover"..index);tween:Play()
            end
            maid:Connect(button.MouseEnter,function() hover(true) end)
            maid:Connect(button.MouseLeave,function() hover(false) end)
            maid:Connect(button.Activated,function()
                if api.Destroyed or api.Closing or not cell.Def or cell.Def.Disabled then return end
                local selected=true
                if opts.ToggleSelection==true and api.Selected==tostring(cell.Def.Id) then selected=false end
                if selected then api:SetSelected(cell.Def.Id) else api:SetSelected(nil) end
                if opts.Callback then opts.Callback(cell.Def.Id,cell.Def,api,selected) end
                if opts.CloseOnSelect==true then api:Close("selected") end
            end)
        end
        function api:SetCards(cards)
            if self.Destroyed or self.Closing then return end
            self.Cards={}
            for index,cell in ipairs(cells) do
                local def=cards and cards[index]
                cell.Def=def
                cell.Group.Visible=def~=nil
                if def then
                    self.Cards[index]=def
                    if cell.Image.Image~=tostring(def.Image or "") then cell.Image.Image=tostring(def.Image or "") end
                    cell.Placeholder.Visible=not def.Image or def.Image==""
                    if cell.Title.Text~=tostring(def.Name or def.Title or "Map") then cell.Title.Text=tostring(def.Name or def.Title or "Map") end
                    if cell.Placeholder.Text~=tostring(def.Name or "?"):sub(1,2):upper() then cell.Placeholder.Text=tostring(def.Name or "?"):sub(1,2):upper() end
                    if cell.Count.Text~=tostring(def.Count or 0) then cell.Count.Text=tostring(def.Count or 0) end
                end
            end
            applySelected()
        end
        function api:SetSelected(id)
            if self.Destroyed then return end
            local selected=id~=nil and tostring(id) or nil
            if self.Selected==selected then return end
            self.Selected=selected
            applySelected()
        end
        function api:SetText(value)
            if not self.Destroyed then
                local caption=tostring(value or "")
                if subtitle.Text~=caption then subtitle.Text=caption end
            end
        end
        function api:Destroy()
            if self.Destroyed then return end
            self.Destroyed=true
            maid:Destroy()
        end
        function api:Close(reason)
            if self.Destroyed or self.Closing then return end
            self.Closing=true
            if opts.OnClose then opts.OnClose(reason or "manual",self) end
            local tween=tweenService:Create(panel,TweenInfo.new(0.16,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{GroupTransparency=1,Position=panel.Position+UDim2.fromOffset(0,8)})
            maid:Add(tween,"fade")
            maid:Once(tween.Completed,function() self:Destroy() end)
            tween:Play()
        end
        maid:Connect(close.Activated,function() api:Close("manual") end)
        local targetPosition
        local function layout()
            local view=window.Gui.AbsoluteSize
            if view.X<=0 or view.Y<=0 then view=window.Viewport end
            local factor=math.min(1,math.max(0.1,(view.X-24)/width),math.max(0.1,(view.Y-24)/height))
            scale.Scale=factor
            targetPosition=UDim2.new(0,12,0,math.max(12,math.min(66,view.Y-height*factor-12)))
            panel.Position=targetPosition
        end
        maid:Connect(window.Gui:GetPropertyChangedSignal("AbsoluteSize"),layout)
        layout()
        panel.Position=targetPosition+UDim2.fromOffset(0,12)
        api:SetCards(opts.Cards or {})
        local tween=tweenService:Create(panel,TweenInfo.new(0.22,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{GroupTransparency=0,Position=targetPosition})
        maid:Add(tween,"fade");tween:Play()
        return api
        end)
        if not ok then maid:Destroy();error(result,0) end
        return result
    end

                                                                                        
    Library.CardNotificationVersion="5.9.3"
    local original=Library.NotifyCards
    local activeNotices={}
    function Library:NotifyCards(options)
        local notice=original(self,options)
        for previous in pairs(activeNotices) do if previous.Destroyed then activeNotices[previous]=nil end end
        if notice then activeNotices[notice]=true end
        return notice
    end
    Library:OnUnload(function()
        for notice in pairs(activeNotices) do notice:Destroy() end
        activeNotices={}
    end)
end
installCardNotificationCompatibility(Lib)

V.Library = Lib
Lib:OnUnload(function()
	if not V.Destroying and not V.Destroyed then
		V:Destroy(true)
	end
end)

local W = Lib:CreateWindow({
	Name = "Waraku",
	Title = "Waraku",
	GuiName = "Waraku",
	Icon = 93892730255946,
	Accent = Color3.fromRGB(150, 160, 255),
	Scale = 75,
	Configs = {Enabled = true},
	Folder = "Waraku",
	OpenMode = "watermark",
	OpenAlways = true,
	Theme = "Black",
    MenuSettings = {Enabled = true, Theme = false, Scale = true},
	Performance = {IdleUpdateRate = 12, HiddenUpdateRate = 6, ActiveDuration = 0.45},
})
do
    if type(Lib.SetTheme)=="function" then
        local setTheme=Lib.SetTheme
        Lib.SetTheme=function(self) return setTheme(self,"Black") end
        pcall(Lib.SetTheme,Lib,"Black")
    end
    if type(Lib.SetAccent)=="function" then
        local setAccent=Lib.SetAccent
                                                                                  
        Lib.SetAccent=function(self) return setAccent(self,Color3.fromRGB(150,160,255),1) end
        pcall(Lib.SetAccent,Lib)
    end
end
W:SetWatermark({
	Enabled = true,
	Toggle = true,
	AlwaysVisible = true,
	Text = "Waraku",
	ShowIcon = false,
	ShowFPS = true,
	ShowPing = true,
	ShowTime = false,
	Transparency = 0.08,
	Radius = 5,
})
Lib:SetToggleKey("RightShift")


for _, flag in ipairs({"V.RoleCustom", "V.RoleColMurd", "V.RoleColSher", "V.RoleColHero", "V.RoleColInno"}) do
    XT.after[flag] = function() XT.syncRoleColors() refreshStatic() end
end
for _, role in ipairs({"Murderer", "Sheriff", "Hero", "Innocent"}) do
    local roleName = role
    XT.after["V.ShowRole." .. roleName] = function()
        V.Roles[roleName] = V["ShowRole" .. roleName] ~= false
        refreshStatic()
    end
end

local T = W:CreateTab({Name = "Visual", Title = "Visual", Icon = "eye"})

T:AddSection("General")

do
    if type(W.CreateESPPreview) ~= "function" then
        Lib:Notify({Title = "ESP preview", Text = "Update WolfUi.lua at the configured library URL to enable preview.", Duration = 8})
    else
        local context = {Role = "Murderer", Distance = 100, Health = 100, Lines = {}, Joints = {}, Screen = {}, Appearance = {},
            PreviewGlowFolder = nil, PreviewGlowParts = {}, PreviewGlowSource = nil,
            AvatarImage = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(LocalPlayer.UserId) .. "&w=150&h=150"}
        local function updateSkeleton(api)
            local count = 0
            local color = V.SkeletonRoleColor and context.Color or V.SkeletonColor
            local thickness = math.clamp(tonumber(V.SkeletonThickness) or 1, 1, 4)
            local opacity = math.clamp(tonumber(V.SkeletonTransparency) or 1, 0, 1)
            if context.Head then context.Head.Visible = false end
            if V.Enabled and V.SkeletonEnabled and context.Rig then
                XT.computeSkeletonJoints(context.Rig, context.Joints)
                table.clear(context.Screen)
                for key, point in pairs(context.Joints) do context.Screen[key] = api:Project(point) end
                local bones = context.Rig.r15 and XT.skeletonBones.R15 or XT.skeletonBones.R6
                for _, joint in ipairs(bones) do
                    local a, b = context.Screen[joint[1]], context.Screen[joint[2]]
                    if a and b then
                        count = count + 1
                        local line = context.Lines[count]
                        if not line then
                            line = newSkelLine()
                            line.Parent = context.Container
                            line.ZIndex = 12
                            line.Name = "PreviewSkeletonLine"
                            line:SetAttribute("PreviewSkeletonLine", true)
                            context.Lines[count] = line
                        end
                        placeLine(line, a, b, thickness, color, opacity)
                    end
                end
                local head = context.Rig.parts.Head
                local center = context.Screen.head
                if head and center then
                    local up = api.Camera.CFrame:VectorToWorldSpace(Vector3.yAxis)
                    local top = api:Project(head.Position + up * (head.Size.Y * 0.5))
                    if top then
                        if not context.Head then
                            local frame = Instance.new("Frame")
                            frame.Name, frame.BackgroundTransparency, frame.BorderSizePixel, frame.ZIndex = "PreviewSkeletonHead", 1, 0, 12
                            frame.AnchorPoint = Vector2.new(0.5, 0.5)
                            frame.Parent = context.Container
                            local corner = Instance.new("UICorner")
                            corner.CornerRadius, corner.Parent = UDim.new(1, 0), frame
                            local stroke = Instance.new("UIStroke")
                            stroke.ApplyStrokeMode, stroke.Parent = Enum.ApplyStrokeMode.Border, frame
                            context.Head, context.HeadStroke = frame, stroke
                        end
                        local radius = math.clamp((top - center).Magnitude, 2, 40)
                        VisualCache.set(context.Head, "Position", UDim2.fromOffset(center.X, center.Y))
                        VisualCache.set(context.Head, "Size", UDim2.fromOffset(radius * 2, radius * 2))
                        VisualCache.set(context.HeadStroke, "Color", color)
                        VisualCache.set(context.HeadStroke, "Thickness", thickness)
                        VisualCache.set(context.HeadStroke, "Transparency", 1 - opacity)
                        context.Head.Visible = true
                    end
                end
            end
            for index = count + 1, #context.Lines do context.Lines[index].Visible = false end
        end
        -- ViewportFrames do not reliably composite Roblox Highlight effects.
        -- Use a real Highlight when the runtime supports it, and a lightweight
        -- neon shell fallback for Glow so the effect is visible inside the
        -- WorldModel even on executors where Highlight is not composited.
        local function clearPreviewGlow()
            if context.PreviewGlowFolder then
                pcall(function() context.PreviewGlowFolder:Destroy() end)
            end
            if context.PreviewGlow2D then
                pcall(function() context.PreviewGlow2D:Destroy() end)
            end
            context.PreviewGlowFolder = nil
            context.PreviewGlow2D = nil
            table.clear(context.PreviewGlowParts)
            context.PreviewGlowSource = nil
        end

        -- ViewportFrame-safe Highlight/Glow implementation. Native Highlight
        -- is not used for the preview. A 3D enlarged Neon shell is combined
        -- with a 2D projected outline, so the effect remains visible even on
        -- runtimes where ViewportFrame does not composite Highlight.
        local function makePreviewGlow(api, model)
            clearPreviewGlow()
            local world = api and api.World
            local overlay = api and api.Overlay
            if not world or not overlay or not model then return end

            local folder = Instance.new("Folder")
            folder.Name = "PreviewFX3D"
            folder.Parent = world
            context.PreviewGlowFolder = folder
            context.PreviewGlowSource = model

            for _, source in ipairs(model:GetDescendants()) do
                if source:IsA("BasePart")
                    and source.Name ~= "HumanoidRootPart"
                    and source.Name ~= "RootPart"
                    and source ~= model.PrimaryPart
                    and source.Transparency < 1 then

                    local originalMesh = source:FindFirstChildOfClass("SpecialMesh")
                    for layerIndex = 1, 4 do
                        local ok, shell = pcall(function() return source:Clone() end)
                        if ok and shell then
                            shell.Name = "PreviewFX3D_" .. tostring(layerIndex)
                            shell.Anchored = true
                            shell.CanCollide = false
                            shell.CanTouch = false
                            shell.CanQuery = false
                            shell.CastShadow = false
                            shell.Massless = true
                            shell.LocalTransparencyModifier = 0
                            shell.Material = Enum.Material.Neon
                            shell.Reflectance = 0
                            shell.Transparency = 0.95

                            for _, child in ipairs(shell:GetDescendants()) do
                                if not child:IsA("DataModelMesh")
                                    and not child:IsA("Bone") then
                                    pcall(function() child:Destroy() end)
                                end
                            end

                            if shell:IsA("MeshPart") then
                                pcall(function() shell.TextureID = "" end)
                            end

                            local shellMesh = shell:FindFirstChildOfClass("SpecialMesh")
                            if shellMesh then
                                pcall(function()
                                    shellMesh.TextureId = ""
                                    shellMesh.VertexColor = Vector3.new(1, 1, 1)
                                end)
                            end

                            shell.Parent = folder
                            context.PreviewGlowParts[#context.PreviewGlowParts + 1] = {
                                Source = source,
                                Shell = shell,
                                Layer = layerIndex,
                                Mesh = shellMesh,
                                SourceMesh = originalMesh,
                            }
                        end
                    end
                end
            end

            local fx2d = Instance.new("Frame")
            fx2d.Name = "PreviewFX2D"
            fx2d.BackgroundTransparency = 1
            fx2d.BorderSizePixel = 0
            fx2d.Size = UDim2.fromScale(1, 1)
            fx2d.Position = UDim2.fromOffset(0, 0)
            fx2d.ClipsDescendants = true
            fx2d.ZIndex = 7
            fx2d.Parent = overlay
            context.PreviewGlow2D = fx2d
        end

        local function projectPartBounds(api, part)
            local half = part.Size * 0.5
            local x1, y1, x2, y2 = math.huge, math.huge, -math.huge, -math.huge
            local points = {
                Vector3.new(-half.X, -half.Y, -half.Z),
                Vector3.new(-half.X, -half.Y,  half.Z),
                Vector3.new(-half.X,  half.Y, -half.Z),
                Vector3.new(-half.X,  half.Y,  half.Z),
                Vector3.new( half.X, -half.Y, -half.Z),
                Vector3.new( half.X, -half.Y,  half.Z),
                Vector3.new( half.X,  half.Y, -half.Z),
                Vector3.new( half.X,  half.Y,  half.Z),
            }
            for _, localPoint in ipairs(points) do
                local point = api:Project(part.CFrame:PointToWorldSpace(localPoint))
                if point then
                    x1, y1 = math.min(x1, point.X), math.min(y1, point.Y)
                    x2, y2 = math.max(x2, point.X), math.max(y2, point.Y)
                end
            end
            if x1 == math.huge then return nil end
            return x1, y1, x2, y2
        end

        local function updatePreviewGlow(api, now, color)
            if not context.PreviewUnsupported then
                local label = Instance.new("TextLabel")
                label.Name = "PreviewUnsupported"
                label.BackgroundTransparency = 0.15
                label.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
                label.BorderSizePixel = 0
                label.Size = UDim2.fromScale(0.92, 0.16)
                label.Position = UDim2.fromScale(0.04, 0.82)
                label.Text = "This preview does not support Glow / Highlight"
                label.TextColor3 = Color3.fromRGB(235, 235, 240)
                label.TextSize = 10
                label.Font = Enum.Font.GothamMedium
                label.TextWrapped = true
                label.ZIndex = 20
                local overlay = api and api.Overlay
                if overlay then
                    label.Parent = overlay
                    context.PreviewUnsupported = label
                end
            end
            if context.PreviewUnsupported then context.PreviewUnsupported.Visible = true end
        end

                local function updateModel(api)
            local model = api:GetModel()
            if context.Model ~= model then
                clearPreviewGlow()
                context.Model = model
                table.clear(context.Joints)
                context.Rig = XT.buildSkeletonRig(model)
                table.clear(context.Appearance)
                context.AppearanceFolder = Instance.new("Folder")
                context.AppearanceFolder.Name = "PreviewAppearance"
                context.AppearanceFolder.Parent = model
                for _, object in ipairs(model:GetDescendants()) do
                    local properties
                    local isPreviewRoot = object:IsA("BasePart")
                        and (object.Name == "HumanoidRootPart" or object.Name == "RootPart"
                            or object == model.PrimaryPart)
                    if object:IsA("BasePart") then
                        -- Keep the root as a positioning reference, but never
                        -- render it as a body surface. This prevents Highlight/
                        -- Chams from exposing the normally invisible HRP.
                        properties = {
                            Color = object.Color,
                            Material = object.Material,
                            Reflectance = object.Reflectance,
                            Transparency = isPreviewRoot and 1 or object.Transparency,
                        }
                        if object:IsA("MeshPart") then properties.TextureID = object.TextureID end
                    elseif object:IsA("SpecialMesh") then
                        properties = {TextureId = object.TextureId, VertexColor = object.VertexColor}
                    elseif object:IsA("Decal") or object:IsA("Texture") then
                        properties = {Transparency = object.Transparency}
                    elseif object:IsA("Shirt") then properties = {ShirtTemplate = object.ShirtTemplate}
                    elseif object:IsA("Pants") then properties = {PantsTemplate = object.PantsTemplate}
                    elseif object:IsA("ShirtGraphic") then properties = {Graphic = object.Graphic}
                    elseif object:IsA("SurfaceAppearance") then properties = {Parent = object.Parent} end
                    if properties then
                        context.Appearance[#context.Appearance + 1] = {
                            Object = object, Properties = properties, Root = isPreviewRoot
                        }
                    end
                end
            end

            local tint = V.Enabled and (V.HighlightEnabled or V.ChamsEnabled)
            local style = XT.chamsStyles[V.ChamsStyle] or XT.chamsStyles.Flat
            local color = V.ChamsRoleColor and context.Color or V.ChamsColor
            for _, entry in ipairs(context.Appearance) do
                local object = entry.Object
                if object and object.Parent then
                    for property, original in pairs(entry.Properties) do
                        local value = original
                        if tint then
                            if entry.Root and property == "Transparency" then
                                value = 1
                            elseif entry.Root then
                                value = original
                            elseif property == "Color" then value = color
                            elseif property == "Material" then value = style.material
                            elseif property == "Reflectance" then value = style.reflectance
                            elseif property == "Transparency" then
                                value = math.clamp(tonumber(V.ChamsTransparency) or 0, 0, 1)
                            elseif property == "VertexColor" then value = Vector3.new(1, 1, 1)
                            elseif property == "Parent" then value = context.AppearanceFolder
                            else value = "" end
                        end
                        VisualCache.set(object, property, value)
                    end
                end
            end

            local ambient = tint and math.clamp(V.ChamsAmbient or 0.5, 0, 1) or 0.7
            local light = tint and math.clamp(V.ChamsLight or 0.72, 0, 1) or 0.86
            VisualCache.set(api.Viewport, "Ambient", Color3.new(ambient, ambient, ambient))
            VisualCache.set(api.Viewport, "LightColor", Color3.new(light, light, light))
            local direction = CFrame.Angles(math.rad(V.ChamsLightPitch or -45), math.rad(V.ChamsLightYaw or -35), 0).LookVector
            VisualCache.set(api.Viewport, "LightDirection", V.ChamsCameraLight and api.Camera.CFrame:VectorToWorldSpace(direction) or direction)
            VisualCache.set(api.Viewport, "ImageTransparency", 0)

            -- Viewport preview intentionally does not emulate Glow/Highlight.
            -- Keep the message visible instead of creating a fake effect.
            if V.ChamsStyle == "Glow" or V.ChamsStyle == "Highlight" then
                updatePreviewGlow(api, os.clock(), color)
            elseif context.PreviewUnsupported then
                context.PreviewUnsupported.Visible = false
            end
        end

        local ok, preview = pcall(function()
            return W:CreateESPPreview({OwnerTab = T, Title = "ESP preview", Width = 180, Height = 250, Gap = 16, UpdateRate = 30,
                Render = function(api)
                    context.Api, context.Container = api, api.Overlay
                    context.Color = V.CustomRoleColors and V["RoleColor" .. context.Role] or ROLE[context.Role]
                    context.Color = context.Color or Color3.new(1, 1, 1)
                    updateModel(api)
                    drawPlayerESP(LocalPlayer, nil, context)
                    updateSkeleton(api)
                end})
        end)
        if ok then
            V.ESPPreview = preview
            local previewEnabled = true
            local function updatePreviewVisibility()
                if preview.Destroyed then return end
                -- The tab/window state is checked live by Preview:CanShow every frame.
                -- Baking it into the flag here left the preview hidden whenever the
                -- event ran before the window or tab state had settled.
                preview:SetVisible(previewEnabled)
                preview.CameraDirty = true
            end
            preview:GetMaid():Connect(W.TabChanged.Event, updatePreviewVisibility)
            updatePreviewVisibility()
            preview:GetMaid():Add(function()
                context.Model, context.Api, context.Container, context.Visual = nil, nil, nil, nil
                table.clear(context.Lines)
                table.clear(context.Joints)
                table.clear(context.Screen)
                context.Rig, context.Head, context.HeadStroke = nil, nil, nil
                table.clear(context.Appearance)
                context.AppearanceFolder = nil
                if context.EffectWorld then context.EffectWorld:Destroy() end
                context.EffectWorld = nil
                context.EffectShells = nil
                if context.PreviewGlowFolder then context.PreviewGlowFolder:Destroy() end
                if context.PreviewUnsupported then pcall(function() context.PreviewUnsupported:Destroy() end) end
                context.PreviewUnsupported = nil
                if context.PreviewGlow2D then context.PreviewGlow2D:Destroy() end
                context.PreviewGlowFolder = nil
                context.PreviewGlow2D = nil
                table.clear(context.PreviewGlowParts)
                context.PreviewGlowSource = nil
            end)
            T:AddToggle({Name = "ESP preview", Flag = "UI.ESPPreview", Default = true,
                Callback = function(value)
                    previewEnabled = value == true
                    updatePreviewVisibility()
                end,
                Settings = {Name = "Preview settings", Width = 240, Build = function(menu)
                    menu:AddDropdown({Name = "Sample role", Flag = "UI.Preview.Role",
                        Options = {"Murderer", "Sheriff", "Hero", "Innocent"}, Default = "Murderer",
                        Callback = function(value)
                            if type(value) == "number" then value = ({"Murderer", "Sheriff", "Hero", "Innocent"})[value] end
                            if value == "Murderer" or value == "Sheriff" or value == "Hero" or value == "Innocent" then context.Role = value end
                        end})
                    menu:AddSlider({Name = "Sample health", Flag = "UI.Preview.Health", Min = 0, Max = 100, Default = 100,
                        Callback = function(value) context.Health = math.clamp(tonumber(value) or 100, 0, 100) end})
                    menu:AddSlider({Name = "Sample distance", Flag = "UI.Preview.Distance", Min = 1, Max = 1000, Default = 100,
                        Callback = function(value) context.Distance = math.clamp(tonumber(value) or 100, 1, 1000) end})
                    menu:AddButton({Name = "Reset model view", Callback = function() preview:ResetView() end})
                    menu:AddButton({Name = "Refresh character", Callback = function() preview:Refresh() end})
                end}})
        else
            warn("Waraku ESP preview: " .. tostring(preview))
            Lib:Notify({Title = "ESP preview", Text = "Could not create preview. Check the executor console.", Duration = 8})
        end
    end
end


T:AddToggle({
	Name = "Enable ESP",
	Flag = "V.Master",
	Default = true,
	Callback = function(x)
		V.Enabled = x
		if not x then
			if V.DrawByPlayer then
				for _, e in pairs(V.DrawByPlayer) do
					setHidden(e)
				end
			end
			for _, p in ipairs(Players:GetPlayers()) do
				local h = V.Highlights and V.Highlights[p]
				if h then
					h.Enabled = false
				end
			end
			clearCorpses()
			clearGunVisuals()
			clearTracers()
			restoreAllPlayerChams()
		else
			refreshStatic()
			refreshCorpses()
			refreshGun()
		end
	end,
	Settings = {
		Name = "ESP settings",
		Width = 270,
        MaxHeight = 260,
		Build = function(m)
            XT.toggle(m, "Adaptive bounds", "V.AdaptiveESP")
            XT.toggle(m, "Include accessories", "V.ESPAccessories")
            XT.slider(m, "Bounds padding", "V.ESPPadding", 0, 16, " px")
			m:AddToggle({
				Name = "Only in round",
				Flag = "V.RoundOnly",
				Default = true,
				Callback = function(x)
					V.RoundOnly = x
					refreshStatic()
					refreshCorpses()
					refreshGun()
			end,
			})
			m:AddSlider({
				Name = "Max distance",
				Flag = "V.MaxDistance",
				Min = 50,
				Max = 25000,
				Default = 15000,
				Suffix = " studs",
				Callback = function(x)
					V.MaxDistance = x
					refreshStatic()
					refreshCorpses()
					refreshGun()
			end,
			})
			XT.slider(m, "Text scale", "V.TextScale", 50, 200, "%")
            m:AddSettings({Name = "Roles", Width = 240, MaxHeight = 240, Build = function(roles)
                XT.toggle(roles, "Murderer", "V.ShowRole.Murderer")
                XT.toggle(roles, "Sheriff", "V.ShowRole.Sheriff")
                XT.toggle(roles, "Hero", "V.ShowRole.Hero")
                XT.toggle(roles, "Innocent", "V.ShowRole.Innocent")
            end})
            m:AddSettings({Name = "Role colors", Width = 250, MaxHeight = 250, Build = function(colors)
                XT.toggle(colors, "Custom colors", "V.RoleCustom")
                XT.color(colors, "Murderer", "V.RoleColMurd")
                XT.color(colors, "Sheriff", "V.RoleColSher")
                XT.color(colors, "Hero", "V.RoleColHero")
                XT.color(colors, "Innocent", "V.RoleColInno")
            end})
		end,
	},
})

T:AddSection("Players")

T:AddToggle({
	Name = "Box",
	Flag = "V.Box",
	Default = false,
	Callback = function(x)
		V.BoxEnabled = x
		if not x then
			V.BoxFillEnabled = false
			task.defer(function()
				local el = V.Library and V.Library:GetElement("V.BoxFill")
				if el and el.Set then
					el:Set(false)
				end
			end)
		end
	end,
	ColorPicker = {
		Name = "Primary color",
		Flag = "V.BoxColor",
		Default = V.BoxColor,
		UseAlpha = false,
		Callback = function(c)
			V.BoxColor = c
		end,
	},
	Settings = {
		Name = "Box settings",
		Width = 260,
		MaxHeight = 400,
		Build = function(m)
			m:AddDropdown({
				Name = "Style",
				Flag = "V.BoxStyle",
				Options = {"Full", "Corner"},
				Default = V.BoxStyle,
				Callback = function(x)
					if x == 1 or x == "Full" then
						V.BoxStyle = "Full"
					elseif x == 2 or x == "Corner" then
						V.BoxStyle = "Corner"
					else
						V.BoxStyle = "Full"
					end
				end,
			})
			m:AddToggle({
				Name = "Outline",
				Flag = "V.BoxOutline",
				Default = false,
				Callback = function(x)
					V.BoxOutline = x
				end,
			})
			m:AddToggle({
				Name = "Role colors",
				Flag = "V.BoxRole",
				Default = false,
				Callback = function(x)
					V.BoxRoleColor = x
				end,
			})
			m:AddToggle({
				Name = "Fill",
				Flag = "V.BoxFill",
				Default = false,
				Callback = function(x)
					if x and not V.BoxEnabled then
						V.BoxFillEnabled = false
						task.defer(function()
							local el = V.Library and V.Library:GetElement("V.BoxFill")
							if el and el.Set then
								el:Set(false)
							end
						end)
					else
						V.BoxFillEnabled = x
					end
				end,
			})
			m:AddColorPicker({
				Name = "Fill color",
				Flag = "V.BoxFillColor",
				Default = V.BoxFillColor,
				UseAlpha = false,
				Callback = function(c)
					V.BoxFillColor = c
				end,
			})
			m:AddSlider({
				Name = "Fill transparency",
				Flag = "V.BoxFillAlpha",
				Min = 0,
				Max = 100,
				Default = 82,
				Suffix = "%",
				Callback = function(x)
					V.BoxFillTransparency = x / 100
				end,
			})
			XT.toggle(m, "Fill gradient", "V.BoxFillGrad")
			XT.color(m, "Fill gradient color", "V.BoxFillGradColor")
			XT.dropdown(m, "Fill animation", "V.BoxFillAnim")
			XT.slider(m, "Line thickness", "V.BoxThick", 1, 4, " px")
		end,
	},
})

function XT.glowSettings(m,localMode)
    local base=localMode and "V.LocalChams" or "V.Chams"
    m:AddSettings({Name="Glow / outline",Width=260,MaxHeight=340,Build=function(g)
        local outline=localMode and "V.LocalChams.Outline" or "V.ChamsOutline"
        XT.toggle(g,"Outline",outline)
        XT.color(g,"Outline color",base..".OutlineColor")
        XT.slider(g,"Outline transparency",base..".OutlineAlpha",0,100,"%")
        XT.color(g,"Glow color",base..".GlowColor")
        XT.slider(g,"Glow strength",base..".GlowStrength",0,100,"%")
        XT.slider(g,"Halo width",base..".GlowWidth",0.01,0.2," studs",2)
        XT.toggle(g,"Pulse",base..".GlowPulse")
    end})
end

T:AddToggle({
	Name = "Chams",
	Flag = "V.Highlight",
	Default = false,
	Callback = function(x)
		V.HighlightEnabled = x == true
        -- The original UI used one master switch for both Highlight and Chams,
        -- while the renderer still consulted the legacy ChamsEnabled flag.
        -- Keep both flags synchronized so the Preview and live renderer cannot
        -- disagree about whether Chams are enabled.
        V.ChamsEnabled = x == true
		refreshStatic()
	end,
	Settings = {
		Name = "Chams settings",
		Width = 220,
		Build = function(m)
			XT.dropdown(m, "Material", "V.ChamsStyle")
			XT.slider(m, "Distance", "V.LitDist", 50, 100000, " studs")
			XT.slider(m, "Transparency", "V.LitAlpha", 0, 90, "%")
            XT.color(m,"Body color","V.Chams.Color")
            XT.toggle(m,"Role color","V.Chams.RoleColor")
            XT.glowSettings(m,false)
            m:AddSettings({Name = "Lighting", Width = 270, MaxHeight = 400, Build = function(light)
                XT.slider(light, "Ambient intensity", "V.ChamsAmbient", 0, 1, "", 2)
                XT.slider(light, "Light intensity", "V.ChamsLight", 0, 1, "", 2)
                XT.slider(light, "Light yaw", "V.ChamsLightYaw", -180, 180, " deg")
                XT.slider(light, "Light pitch", "V.ChamsLightPitch", -89, 89, " deg")
                XT.toggle(light, "Follow camera", "V.ChamsCameraLight")
            end})
		end,
	},
})

T:AddToggle({
	Name = "Skeleton ESP",
	Flag = "V.Skeleton",
	Default = V.SkeletonEnabled,
	Callback = function(x)
		V.SkeletonEnabled = x
		refreshStatic()
	end,
	ColorPicker = {
		Name = "Skeleton color",
		Flag = "V.SkeletonColor",
		Default = V.SkeletonColor,
		UseAlpha = false,
		Callback = function(c)
			V.SkeletonColor = c
			refreshStatic()
		end,
	},
	Settings = {
		Name = "Skeleton settings",
		Width = 220,
		Build = function(m)
			m:AddToggle({
				Name = "Role colors",
				Flag = "V.SkeletonRole",
				Default = V.SkeletonRoleColor,
				Callback = function(x)
					V.SkeletonRoleColor = x
					refreshStatic()
				end,
			})
			m:AddSlider({
				Name = "Thickness",
				Flag = "V.SkeletonThick",
				Min = 1,
				Max = 3,
				Default = V.SkeletonThickness,
				Suffix = " px",
				Callback = function(x)
					V.SkeletonThickness = x
					refreshStatic()
				end,
			})
		end,
	},
})

T:AddToggle({
	Name = "Health bar",
	Flag = "V.Health",
	Default = false,
	Callback = function(x)
		V.HealthEnabled = x
	end,
	Settings = {
		Name = "Health settings",
		Width = 260,
		MaxHeight = 420,
		Build = function(m)
			XT.dropdown(m, "Position", "V.HealthPos")
			XT.dropdown(m, "Color mode", "V.HealthMode")
			XT.slider(m, "Thickness", "V.HealthThick", 2, 12, " px")
			m:AddColorPicker({
				Name = "Gradient top",
				Flag = "V.HealthGrad1",
				Default = V.HealthGradient1,
				UseAlpha = false,
				Callback = function(c)
					V.HealthGradient1 = c
				end,
			})
			m:AddColorPicker({
				Name = "Gradient bottom",
				Flag = "V.HealthGrad2",
				Default = V.HealthGradient2,
				UseAlpha = false,
				Callback = function(c)
					V.HealthGradient2 = c
				end,
			})
			XT.toggle(m, "Smooth animation", "V.HealthSmooth")
			XT.toggle(m, "Damage trail", "V.HealthTrail")
			XT.toggle(m, "Show text", "V.HealthTextOn")
			XT.dropdown(m, "Text format", "V.HealthTextMode")
		end,
	},
})

T:AddSection("Labels")

T:AddToggle({
	Name = "Name ESP",
	Flag = "V.Name",
	Default = false,
	Callback = function(x)
		V.NameEnabled = x
	end,
	ColorPicker = {
		Name = "Name color",
		Flag = "V.NameColor",
		Default = V.NameColor,
		UseAlpha = false,
		Callback = function(c)
			V.NameColor = c
		end,
	},
    ColorPickers = {{Name="Gradient end",Flag="V.NameGradientColor2",Default=V.NameGradientColor2,
        UseAlpha=false,VisibleWhen="V.NameGradient",Callback=function(c) V.NameGradientColor2=c end}},
	Settings = {
		Name = "Name settings",
		Width = 260,
        MaxHeight = 240,
		Build = function(m)
            m:AddSection("Text")
			m:AddToggle({
				Name = "Use display name",
				Flag = "V.NameUseDisplay",
				Default = false,
				Callback = function(x)
					V.NameUseDisplay = x
				end,
			})
            XT.dropdown(m,"Font","V.NameFont")
            XT.slider(m,"Text size","V.NameSize",6,24," px")
            m:AddSection("Color")
            XT.toggle(m,"Gradient","V.NameGradient")
            local angle=XT.slider(m,"Gradient direction","V.NameGradientRotation",0,360,"°")
            if Lib.BindVisibility and angle then Lib:BindVisibility(angle,"V.NameGradient") end
            if not (Lib.Capabilities and Lib.Capabilities.ConditionalColors) then
                m:AddColorPicker({Name="Gradient end",Flag="V.NameGradientColor2",Default=V.NameGradientColor2,
                    UseAlpha=false,Callback=function(c) V.NameGradientColor2=c end})
            end
            XT.toggle(m, "Role colors", "V.NameRole")
			XT.toggle(m, "Background", "V.NameBg")
		end,
	},
})

T:AddToggle({
	Name = "Distance ESP",
	Flag = "V.Distance",
	Default = false,
	Callback = function(x)
		V.DistanceEnabled = x
	end,
	Settings = {
		Name = "Distance settings",
		Width = 220,
		Build = function(m)
			XT.dropdown(m, "Format", "V.DistFormat")
		end,
	},
})

T:AddToggle({
	Name = "Role flag",
	Flag = "V.RoleFlag",
	Default = false,
	Callback = function(x)
		XT.apply("V.RoleFlag", x)
	end,
	ColorPicker = {
		Name = "Flag color",
		Flag = "V.RoleFlagColor",
		Default = V.RoleFlagColor,
		UseAlpha = false,
		Callback = function(c)
			XT.apply("V.RoleFlagColor", c)
		end,
	},
	Settings = {
		Name = "Role flag settings",
		Width = 240,
		MaxHeight = 380,
		Build = function(m)
			XT.toggle(m, "Role colors", "V.RoleFlagUse")
			XT.slider(m, "Text size", "V.RoleFlagSize", 6, 24, " px")
		end,
	},
})

T:AddToggle({
	Name = "Avatar ESP",
	Flag = "V.Avatar",
	Default = false,
	Callback = function(x)
		V.AvatarEnabled = x
		refreshStatic()
	end,
	Settings = {
		Name = "Avatar settings",
		Width = 220,
		Build = function(m)
			XT.slider(m, "Size", "V.AvatarSize", 16, 56, " px")
		end,
	},
})

T:AddSection("Tracking")

T:AddToggle({
	Name = "Tracer line",
	Flag = "V.RoleTracer",
	Default = false,
	Callback = function(x)
		XT.apply("V.RoleTracer", x)
	end,
	ColorPicker = {
		Name = "Line color",
		Flag = "V.RoleTracerColor",
		Default = V.RoleTracerColor,
		UseAlpha = false,
		Callback = function(c)
			XT.apply("V.RoleTracerColor", c)
		end,
	},
	Settings = {
		Name = "Tracer line settings",
		Width = 230,
		Build = function(m)
			XT.toggle(m, "Role colors", "V.RoleTracerRole")
			XT.dropdown(m, "Start point", "V.RoleTracerOrigin")
			XT.slider(m, "Thickness", "V.RoleTracerThick", 1, 3, " px")
		end,
	},
})

T:AddToggle({
	Name = "Off-screen arrows",
	Flag = "V.Arrow",
	Default = false,
	Callback = function(x)
		XT.apply("V.Arrow", x)
	end,
	ColorPicker = {
		Name = "Arrow color",
		Flag = "V.ArrowColor",
		Default = V.ArrowColor,
		UseAlpha = false,
		Callback = function(c)
			XT.apply("V.ArrowColor", c)
		end,
	},
	Settings = {
		Name = "Arrow settings",
		Width = 240,
		MaxHeight = 380,
		Build = function(m)
			XT.toggle(m, "Role colors", "V.ArrowRole")
			XT.slider(m, "Size", "V.ArrowSize", 16, 80, " px")
		end,
	},
})

T:AddSection("Items")

T:AddToggle({
	Name = "Gun ESP",
	Flag = "V.Gun",
	Default = false,
	Callback = function(x)
		V.GunEnabled = x
		refreshGun()
	end,
	ColorPicker = {
		Name = "Gun color",
		Flag = "V.GunColor",
		Default = V.GunColor,
		UseAlpha = false,
		Callback = function(c)
			V.GunColor = c
			refreshGun()
		end,
	},
})

T:AddToggle({
	Name = "Dead bodies",
	Flag = "V.Corpse",
	Default = false,
	Callback = function(x)
		V.DeadBodiesEnabled = x
		V.ShowDead = x
		refreshCorpses()
		refreshStatic()
	end,
	ColorPicker = {
		Name = "Body color",
		Flag = "V.DeadBodyColor",
		Default = V.DeadBodyColor,
		UseAlpha = false,
		Callback = function(c)
			V.DeadBodyColor = c
			refreshCorpses()
		end,
	},
	Settings = {
		Name = "Dead body settings",
		Width = 240,
		Build = function(m)
			m:AddToggle({
				Name = "Role colors",
				Flag = "V.CorpseRole",
				Default = false,
				Callback = function(x)
					V.DeadBodyRoleColor = x
					refreshCorpses()
				end,
			})
			m:AddToggle({
				Name = "Through walls",
				Flag = "V.CorpseXRay",
				Default = true,
				Callback = function(x)
					V.DeadBodyXRay = x
					refreshCorpses()
				end,
			})
		end,
	},
})

T:AddToggle({
	Name = "Weapon chams",
	Flag = "V.Weapon",
	Default = false,
	Callback = function(x)
		V.WeaponChams = x
		if x then
			if Lib.Flags and Lib.Flags["V.Weapon.Color"] and typeof(Lib.Flags["V.Weapon.Color"]) == "Color3" then
				V.WeaponColor = Lib.Flags["V.Weapon.Color"]
			end
			scanWeapons()
			recolorTrackedWeapons()
		else
			restoreWeapons()
		end
	end,
	ColorPicker = {
		Name = "Weapon color",
		Flag = "V.Weapon.Color",
		Default = V.WeaponColor,
		UseAlpha = false,
		Callback = function(c)
			V.WeaponColor = c
			if V.WeaponChams then
				recolorTrackedWeapons()
			end
		end,
	},
	Settings = {
		Name = "Weapon settings",
		Width = 250,
		Build = function(m)
			local styles = { "ForceField", "Flat", "Neon", "Glass", "Metal" }
			m:AddDropdown({
				Name = "Material",
				Flag = "V.Weapon.Style",
				Options = styles,
				Default = V.WeaponPreset,
				Callback = function(x)
					if XT.apply("V.Weapon.Style", x) and V.WeaponChams then recolorTrackedWeapons() end
				end,
			})
			m:AddSlider({
				Name = "Transparency",
				Flag = "V.Weapon.Alpha",
				Min = 0, Max = 95,
				Default = V.WeaponTransparency * 100,
				Suffix = "%",
				Callback = function(x)
					if type(x) ~= "number" then return end
					XT.apply("V.Weapon.Alpha", math.clamp(x, 0, 95))
					if V.WeaponChams then recolorTrackedWeapons() end
				end,
			})
		end,
	},
})

T:AddToggle({
	Name = "Shot tracer",
	Flag = "V.ShotTracer",
	Default = false,
	Callback = function(x)
		V.TracerEnabled = x
		if not x then
			clearTracers()
		end
	end,
	ColorPicker = {
		Name = "Tracer color",
		Flag = "V.TracerColor",
		Default = V.TracerColor,
		UseAlpha = false,
		Callback = function(c)
			V.TracerColor = c
		end,
	},
	Settings = {
		Name = "Tracer settings",
		Width = 240,
		Build = function(m)
			m:AddSlider({
				Name = "Thickness",
				Flag = "V.TracerThickness",
				Min = 0,
				Max = 1,
				Decimals = 1,
				Default = 0.5,
				Suffix = "",
				Callback = function(x)
					V.TracerThickness = x
				end,
			})
			m:AddSlider({
				Name = "Duration",
				Flag = "V.TracerDuration",
				Min = 0.5,
				Max = 5,
				Default = 2,
				Suffix = "s",
				Callback = function(x)
					V.TracerDuration = x
				end,
			})
		end,
	},
})

T:AddSection("Local player")

T:AddToggle({
    Name = "Local player chams", Flag = "V.LocalChams", Default = V.LocalChamsEnabled,
    Callback = function(x) XT.apply("V.LocalChams", x) V.RefreshLocalChams() end,
    ColorPicker = {Name = "Local chams color", Flag = "V.LocalChams.Color",
        Default = V.LocalChamsColor, UseAlpha = false,
        Callback = function(c) XT.apply("V.LocalChams.Color", c) V.RefreshLocalChams() end},
    Settings = {Name = "Local chams settings", Width = 260, MaxHeight = 380,
        Build = function(m)
            XT.dropdown(m, "Material", "V.LocalChams.Style")
            XT.slider(m, "Transparency", "V.LocalChams.Alpha", 0, 95, "%")
            XT.toggle(m, "Role color", "V.LocalChams.RoleColor")
            XT.toggle(m, "Include accessories", "V.LocalChams.Accessories")
            XT.glowSettings(m,true)
        end},
})

T:AddToggle({
	Name = "China hat",
	Flag = "V.Hat",
	Default = false,
	Callback = function(x)
		XT.apply("V.Hat", x)
	end,
	ColorPicker = {
		Name = "Hat color",
		Flag = "V.HatColor",
		Default = V.ChinaHatColor,
		UseAlpha = false,
		Callback = function(c)
			XT.apply("V.HatColor", c)
		end,
	},
	Settings = {
		Name = "China hat settings",
		Width = 250,
		MaxHeight = 380,
		Build = function(m)
			XT.slider(m, "Height", "V.HatHeight", 0.3, 4, " studs", 1)
			XT.slider(m, "Radius", "V.HatRadius", 0.5, 4, " studs", 1)
			XT.slider(m, "Lift above head", "V.HatOffset", -0.5, 2, " studs", 2)
			XT.slider(m, "Forward offset", "V.HatForward", -2, 2, " studs", 1)
			XT.slider(m, "Opacity", "V.HatAlpha", 10, 100, "%")
			XT.toggle(m, "Flip cone", "V.HatFlip")
		end,
	},
})

T:AddSection("World")

T:AddToggle({Name = "World", Flag = "world.enabled", Default = false,
    Callback = function(x) XT.apply("world.enabled", x) applyWorld() end,
    Settings = {Name = "World settings", Width = 280, MaxHeight = 250, Build = function(m)
        m:AddSettings({Name = "Lighting", Width = 280, MaxHeight = 260, Build = function(m)

        XT.slider(m, "Brightness", "world.brightness", 0, 10, "", 2)
        XT.slider(m, "Time of day", "world.clock", 0, 24, " h", 2)
        XT.toggle(m, "Day cycle", "world.dayCycle")
        XT.slider(m, "Cycle speed", "world.daySpeed", 0.01, 2, " h/s", 2)
        XT.color(m, "Ambient", "world.ambient")
        XT.color(m, "Outdoor ambient", "world.outdoorAmbient")
        XT.toggle(m, "Shadows", "world.shadows")
        XT.slider(m, "Shadow softness", "world.shadowSoftness", 0, 1, "", 2)
        XT.slider(m, "Diffuse scale", "world.diffuse", 0, 1, "", 2)
        XT.slider(m, "Specular scale", "world.specular", 0, 1, "", 2)
        XT.slider(m, "Latitude", "world.latitude", -90, 90, " deg", 1)
        XT.color(m, "Top color shift", "world.colorShiftTop")
        XT.color(m, "Bottom color shift", "world.colorShiftBottom")
        XT.toggle(m, "Disable game post effects", "world.disableGameEffects")
        m:AddSettings({Name = "Map lights", Width = 270, MaxHeight = 400, Build = function(lights)
            XT.toggle(lights, "Override lights", "world.lightsOverride")
            XT.slider(lights, "Brightness multiplier", "world.lightBrightness", 0, 5, "", 2)
            XT.slider(lights, "Range multiplier", "world.lightRange", 0.1, 3, "", 2)
            XT.color(lights, "Light tint", "world.lightColor")
            XT.slider(lights, "Tint strength", "world.lightTint", 0, 1, "", 2)
            XT.toggle(lights, "Light shadows", "world.lightShadows")
        end})
        end})
        XT.toggle(m, "Fullbright", "world.fullbright")
        m:AddSettings({Name = "Environment", Width = 280, MaxHeight = 420, Build = function(m)
XT.toggle(m, "Override gravity", "world.gravityOverride")
XT.slider(m, "Gravity", "world.gravity", 0, 400, "", 1)
m:AddToggle({Name = "World fog", Flag = "world.fog", Default = V.WorldFog,
    Callback = function(x) XT.apply("world.fog", x) applyWorld() end,
    ColorPicker = {Name = "Fog color", Flag = "world.fogColor", Default = V.WorldFogColor,
        UseAlpha = false, Callback = function(c) XT.apply("world.fogColor", c) end},
    Settings = {Name = "Fog settings", Width = 260, Build = function(m)
        XT.slider(m, "Start", "world.fogStart", 0, 100000, " studs")
        XT.slider(m, "End", "world.fogEnd", 1, 1000000, " studs")
    end},
})
m:AddToggle({Name = "Remove atmosphere", Flag = "world.removeAtmosphere", Default = false,
    Callback = function(x) XT.apply("world.removeAtmosphere", x) applyWorld() end,
    Settings = {Name = "Atmosphere settings", Width = 280, MaxHeight = 440, Build = function(m)
        XT.slider(m, "Density", "world.atmoDensity", 0, 1, "", 2)
        XT.slider(m, "Offset", "world.atmoOffset", -1, 1, "", 2)
        XT.slider(m, "Haze", "world.atmoHaze", 0, 10, "", 2)
        XT.slider(m, "Glare", "world.atmoGlare", 0, 10, "", 2)
        XT.color(m, "Color", "world.atmoColor")
        XT.color(m, "Decay", "world.atmoDecay")
    end},
})
m:AddToggle({Name = "Customize sky", Flag = "world.skyOverride", Default = false,
    Callback = function(x) XT.apply("world.skyOverride", x) applyWorld() end,
    Settings = {Name = "Sky settings", Width = 270, Build = function(m)
        XT.toggle(m, "Show sun and moon", "world.celestialBodies")
        XT.slider(m, "Sky pitch", "world.skyPitch", -180, 180, " deg")
        XT.slider(m, "Sky yaw", "world.skyYaw", -180, 180, " deg")
        XT.slider(m, "Sky roll", "world.skyRoll", -180, 180, " deg")
        XT.slider(m, "Stars", "world.stars", 0, 10000, "")
        XT.slider(m, "Sun angular size", "world.sunSize", 0, 60, " deg", 1)
        XT.slider(m, "Moon angular size", "world.moonSize", 0, 60, " deg", 1)
    end},
})
m:AddToggle({Name = "Customize terrain water", Flag = "world.waterOverride", Default = false,
    Callback = function(x) XT.apply("world.waterOverride", x) applyWorld() end,
    ColorPicker = {Name = "Water color", Flag = "world.waterColor", Default = V.WorldWaterColor,
        UseAlpha = false, Callback = function(c) XT.apply("world.waterColor", c) end},
    Settings = {Name = "Terrain water settings", Width = 270, Build = function(m)
        XT.slider(m, "Transparency", "world.waterTransparency", 0, 1, "", 2)
        XT.slider(m, "Reflectance", "world.waterReflectance", 0, 1, "", 2)
        XT.slider(m, "Wave size", "world.waterWaveSize", 0, 1, "", 2)
        XT.slider(m, "Wave speed", "world.waterWaveSpeed", 0, 100, "", 1)
    end},
})
m:AddToggle({Name = "Customize clouds", Flag = "world.cloudOverride", Default = false,
    Callback = function(x) XT.apply("world.cloudOverride", x) applyWorld() end,
    ColorPicker = {Name = "Cloud color", Flag = "world.cloudColor", Default = V.WorldCloudColor,
        UseAlpha = false, Callback = function(c) XT.apply("world.cloudColor", c) end},
    Settings = {Name = "Cloud settings", Width = 270, Build = function(m)
        XT.slider(m, "Cover", "world.cloudCover", 0, 1, "", 2)
        XT.slider(m, "Density", "world.cloudDensity", 0, 1, "", 2)
    end},
})
        end})
        m:AddSettings({Name = "Post effects", Width = 280, MaxHeight = 250, Build = function(m)
m:AddToggle({Name = "Bloom", Flag = "postProcess.bloom", Default = false,
    Callback = function(x) XT.apply("postProcess.bloom", x) applyWorld() end,
    Settings = {Name = "Bloom settings", Width = 260, Build = function(m)
        XT.slider(m, "Intensity", "postProcess.bloomIntensity", 0, 5, "", 2)
        XT.slider(m, "Threshold", "postProcess.bloomThreshold", 0, 10, "", 2)
        XT.slider(m, "Size", "postProcess.bloomSize", 0, 56, " px", 1)
    end},
})
m:AddToggle({Name = "Color grading", Flag = "postProcess.colorGrading", Default = V.WorldColorGrading,
    Callback = function(x) XT.apply("postProcess.colorGrading", x) applyWorld() end,
    ColorPicker = {Name = "Color filter", Flag = "postProcess.colorFilter", Default = V.WorldTint,
        UseAlpha = false, Callback = function(c) XT.apply("postProcess.colorFilter", c) end},
    Settings = {Name = "Color grading settings", Width = 280, MaxHeight = 420, Build = function(m)
        XT.slider(m, "Saturation", "postProcess.colorSaturation", -1, 1, "", 2)
        XT.slider(m, "Brightness", "postProcess.colorBrightness", -1, 1, "", 2)
        XT.slider(m, "Post exposure", "postProcess.colorPostExposure", -5, 5, " EV", 2)
        XT.slider(m, "Contrast", "postProcess.colorContrast", -1, 1, "", 2)
    end},
})
m:AddToggle({Name = "Depth of field", Flag = "postProcess.depthOfField", Default = false,
    Callback = function(x) XT.apply("postProcess.depthOfField", x) applyWorld() end,
    Settings = {Name = "Depth of field settings", Width = 280, Build = function(m)
        XT.slider(m, "Focus distance", "postProcess.depthFocusDistance", 0, 1000, " studs", 1)
        XT.slider(m, "In-focus radius", "postProcess.depthInFocusRadius", 0, 500, " studs", 1)
        XT.slider(m, "Near intensity", "postProcess.depthNearIntensity", 0, 1, "", 2)
        XT.slider(m, "Far intensity", "postProcess.depthFarIntensity", 0, 1, "", 2)
    end},
})
m:AddToggle({Name = "Sun rays", Flag = "world.sunRays", Default = false,
    Callback = function(x) XT.apply("world.sunRays", x) applyWorld() end,
    Settings = {Name = "Sun ray settings", Width = 260, Build = function(m)
        XT.slider(m, "Intensity", "world.sunIntensity", 0, 1, "", 2)
        XT.slider(m, "Spread", "world.sunSpread", 0, 1, "", 2)
    end},
})
m:AddToggle({Name = "World blur", Flag = "postProcess.blur", Default = false,
    Callback = function(x) XT.apply("postProcess.blur", x) applyWorld() end,
    Settings = {Name = "Blur settings", Width = 260, Build = function(m)
        XT.slider(m, "Size", "postProcess.blurSize", 0, 56, " px", 1)
    end},
})
        end})
m:AddButton({Name = "Restore original world", Callback = function()
    for flag, value in pairs({["world.enabled"] = false, ["world.fullbright"] = false}) do
        XT.apply(flag, value)
        local element = Lib:GetElement(flag)
        if element and element.Set then element:Set(value) end
    end
    applyWorld()
end})
    end},
})

if Lib.Flags then
	if Lib.Flags["V.Master"] ~= nil then V.Enabled = Lib.Flags["V.Master"] end
	if Lib.Flags["V.RoundOnly"] ~= nil then V.RoundOnly = Lib.Flags["V.RoundOnly"] end
	if Lib.Flags["V.Avatar"] ~= nil then V.AvatarEnabled = Lib.Flags["V.Avatar"] end

	if Lib.Flags["V.Skeleton"] ~= nil then V.SkeletonEnabled = Lib.Flags["V.Skeleton"] end
	if typeof(Lib.Flags["V.SkeletonColor"]) == "Color3" then V.SkeletonColor = Lib.Flags["V.SkeletonColor"] end
	if Lib.Flags["V.SkeletonRole"] ~= nil then V.SkeletonRoleColor = Lib.Flags["V.SkeletonRole"] end
	if type(Lib.Flags["V.SkeletonThick"]) == "number" then V.SkeletonThickness = Lib.Flags["V.SkeletonThick"] end
	if type(Lib.Flags["V.SkeletonAlpha"]) == "number" then V.SkeletonTransparency = math.clamp(Lib.Flags["V.SkeletonAlpha"] / 100, 0, 1) end
	if type(Lib.Flags["V.MaxDistance"]) == "number" then V.MaxDistance = Lib.Flags["V.MaxDistance"] end
	if Lib.Flags["V.Highlight"] ~= nil then V.HighlightEnabled = Lib.Flags["V.Highlight"] end
	if typeof(Lib.Flags["V.HighlightColor"]) == "Color3" then V.HighlightFillColor = Lib.Flags["V.HighlightColor"] V.HighlightOutlineColor = Lib.Flags["V.HighlightColor"] end
	if Lib.Flags["V.HighlightRole"] ~= nil then V.HighlightRoleColor = Lib.Flags["V.HighlightRole"] end
	if typeof(Lib.Flags["V.HighlightFillColorPicker"]) == "Color3" then V.HighlightFillColor = Lib.Flags["V.HighlightFillColorPicker"] end
	if typeof(Lib.Flags["V.HighlightOutlineColorPicker"]) == "Color3" then V.HighlightOutlineColor = Lib.Flags["V.HighlightOutlineColorPicker"] end
	if Lib.Flags["V.HighlightXRay"] ~= nil then V.HighlightXRay = Lib.Flags["V.HighlightXRay"] end
	if Lib.Flags["V.Fill"] ~= nil then V.Fill = Lib.Flags["V.Fill"] end
	if type(Lib.Flags["V.FillAlpha"]) == "number" then V.FillTransparency = Lib.Flags["V.FillAlpha"] / 100 end
	if type(Lib.Flags["V.OutlineAlpha"]) == "number" then V.OutlineTransparency = Lib.Flags["V.OutlineAlpha"] / 100 end

	if Lib.Flags["V.Box"] ~= nil then V.BoxEnabled = Lib.Flags["V.Box"] end
	if typeof(Lib.Flags["V.BoxColor"]) == "Color3" then V.BoxColor = Lib.Flags["V.BoxColor"] end
	if Lib.Flags["V.BoxStyle"] ~= nil then
		local s = Lib.Flags["V.BoxStyle"]
		V.BoxStyle = (s == 2 or s == "Corner") and "Corner" or "Full"
	end
	if Lib.Flags["V.BoxOutline"] ~= nil then V.BoxOutline = Lib.Flags["V.BoxOutline"] end
	if Lib.Flags["V.BoxRole"] ~= nil then V.BoxRoleColor = Lib.Flags["V.BoxRole"] end
	if type(Lib.Flags["V.BoxAlpha"]) == "number" then V.BoxTransparency = Lib.Flags["V.BoxAlpha"] / 100 end
	if Lib.Flags["V.BoxFill"] ~= nil then V.BoxFillEnabled = Lib.Flags["V.BoxFill"] end
	if typeof(Lib.Flags["V.BoxFillColor"]) == "Color3" then V.BoxFillColor = Lib.Flags["V.BoxFillColor"] end
	if type(Lib.Flags["V.BoxFillAlpha"]) == "number" then V.BoxFillTransparency = Lib.Flags["V.BoxFillAlpha"] / 100 end

	if Lib.Flags["V.Health"] ~= nil then V.HealthEnabled = Lib.Flags["V.Health"] end
	if typeof(Lib.Flags["V.HealthGrad1"]) == "Color3" then V.HealthGradient1 = Lib.Flags["V.HealthGrad1"] end
	if typeof(Lib.Flags["V.HealthGrad2"]) == "Color3" then V.HealthGradient2 = Lib.Flags["V.HealthGrad2"] end
	for xtFlag in pairs(XT.specs) do
		if Lib.Flags[xtFlag] ~= nil then
			XT.apply(xtFlag, Lib.Flags[xtFlag])
		end
	end

	if Lib.Flags["V.Name"] ~= nil then V.NameEnabled = Lib.Flags["V.Name"] end
	if typeof(Lib.Flags["V.NameColor"]) == "Color3" then V.NameColor = Lib.Flags["V.NameColor"] end
	if Lib.Flags["V.NameUseDisplay"] ~= nil then V.NameUseDisplay = Lib.Flags["V.NameUseDisplay"] end

	if Lib.Flags["V.Distance"] ~= nil then V.DistanceEnabled = Lib.Flags["V.Distance"] end

	if Lib.Flags["V.Weapon"] ~= nil then V.WeaponChams = Lib.Flags["V.Weapon"] end
	if typeof(Lib.Flags["V.Weapon.Color"]) == "Color3" then V.WeaponColor = Lib.Flags["V.Weapon.Color"] end

	if Lib.Flags["V.Corpse"] ~= nil then V.DeadBodiesEnabled = Lib.Flags["V.Corpse"] V.ShowDead = Lib.Flags["V.Corpse"] end
	if typeof(Lib.Flags["V.DeadBodyColor"]) == "Color3" then V.DeadBodyColor = Lib.Flags["V.DeadBodyColor"] end
	if Lib.Flags["V.CorpseRole"] ~= nil then V.DeadBodyRoleColor = Lib.Flags["V.CorpseRole"] end
	if typeof(Lib.Flags["V.DeadBodyFillColorPicker"]) == "Color3" then V.DeadBodyFillColor = Lib.Flags["V.DeadBodyFillColorPicker"] end
	if typeof(Lib.Flags["V.DeadBodyOutlineColorPicker"]) == "Color3" then V.DeadBodyOutlineColor = Lib.Flags["V.DeadBodyOutlineColorPicker"] end
	if Lib.Flags["V.CorpseXRay"] ~= nil then V.DeadBodyXRay = Lib.Flags["V.CorpseXRay"] end
	if type(Lib.Flags["V.CorpseFillA"]) == "number" then V.DeadBodyFillTransparency = 1 - (Lib.Flags["V.CorpseFillA"] / 100) end
	if type(Lib.Flags["V.CorpseOutlineA"]) == "number" then V.DeadBodyOutlineTransparency = 1 - (Lib.Flags["V.CorpseOutlineA"] / 100) end

	if Lib.Flags["V.Gun"] ~= nil then V.GunEnabled = Lib.Flags["V.Gun"] end
	if typeof(Lib.Flags["V.GunColor"]) == "Color3" then V.GunColor = Lib.Flags["V.GunColor"] end
	if Lib.Flags["V.ShotTracer"] ~= nil then V.TracerEnabled = Lib.Flags["V.ShotTracer"] end
	if typeof(Lib.Flags["V.TracerColor"]) == "Color3" then V.TracerColor = Lib.Flags["V.TracerColor"] end
	if type(Lib.Flags["V.TracerDuration"]) == "number" then V.TracerDuration = Lib.Flags["V.TracerDuration"] end
	if type(Lib.Flags["V.TracerThickness"]) == "number" then V.TracerThickness = Lib.Flags["V.TracerThickness"] end
	if type(Lib.Flags["V.TracerTransparency"]) == "number" then V.TracerTransparency = Lib.Flags["V.TracerTransparency"] / 100 end
	if Lib.Flags["V.TracerGlow"] ~= nil then V.TracerGlow = Lib.Flags["V.TracerGlow"] end
	if Lib.Flags["V.TracerEveryone"] ~= nil then V.TracerEveryone = Lib.Flags["V.TracerEveryone"] end
end

Lib:OnChange(function(flag, val)
    if type(flag)=="string" and string.sub(flag,1,2)=="V." then VisualCache.invalidate() end
	if XT.apply(flag, val) then
        if string.sub(flag, 1, 12) == "V.LocalChams" then V.RefreshLocalChams() end
        if string.sub(flag, 1, 6) == "world." or string.sub(flag, 1, 12) == "postProcess." then applyWorld() end
		if V.WeaponChams and (flag == "V.Weapon.Style" or flag == "V.Weapon.Alpha") then recolorTrackedWeapons() end
		return
	end
	if flag == "V.Master" then
		V.Enabled = val
		if not val then
			if V.DrawByPlayer then
				for _, e in pairs(V.DrawByPlayer) do
					setHidden(e)
				end
			end
			for _, p in ipairs(Players:GetPlayers()) do
				local h = V.Highlights and V.Highlights[p]
				if h then
					h.Enabled = false
				end
			end
			clearCorpses()
			clearGunVisuals()
			clearTracers()
			restoreAllPlayerChams()
		else
			refreshStatic()
			refreshCorpses()
			refreshGun()
		end
	elseif flag == "V.RoundOnly" then
		V.RoundOnly = val
		refreshStatic()
		refreshCorpses()
		refreshGun()
	elseif flag == "V.Avatar" then
		V.AvatarEnabled = val
		refreshStatic()
	elseif flag == "V.Skeleton" then
		V.SkeletonEnabled = val
		refreshStatic()
	elseif flag == "V.SkeletonColor" and typeof(val) == "Color3" then
		V.SkeletonColor = val
		refreshStatic()
	elseif flag == "V.SkeletonRole" then
		V.SkeletonRoleColor = val
		refreshStatic()
	elseif flag == "V.SkeletonThick" and type(val) == "number" then
		V.SkeletonThickness = val
		refreshStatic()
	elseif flag == "V.SkeletonAlpha" and type(val) == "number" then
		V.SkeletonTransparency = math.clamp(val / 100, 0, 1)
		refreshStatic()
	elseif flag == "V.MaxDistance" and type(val) == "number" then
		V.MaxDistance = val
		refreshStatic()
		refreshCorpses()
		refreshGun()
	elseif flag == "V.Highlight" then
		V.HighlightEnabled = val
		refreshStatic()
	elseif flag == "V.HighlightColor" and typeof(val) == "Color3" then
		V.HighlightFillColor = val
		V.HighlightOutlineColor = val
		refreshStatic()
	elseif flag == "V.HighlightRole" then
		V.HighlightRoleColor = val
		refreshStatic()
	elseif flag == "V.HighlightFillColorPicker" and typeof(val) == "Color3" then
		V.HighlightFillColor = val
		refreshStatic()
	elseif flag == "V.HighlightOutlineColorPicker" and typeof(val) == "Color3" then
		V.HighlightOutlineColor = val
		refreshStatic()
	elseif flag == "V.HighlightXRay" then
		V.HighlightXRay = val
		refreshStatic()
	elseif flag == "V.Fill" then
		V.Fill = val
		refreshStatic()
	elseif flag == "V.FillAlpha" and type(val) == "number" then
		V.FillTransparency = val / 100
		refreshStatic()
	elseif flag == "V.OutlineAlpha" and type(val) == "number" then
		V.OutlineTransparency = val / 100
		refreshStatic()
	elseif flag == "V.Box" then
		V.BoxEnabled = val
	elseif (flag == "V.BoxColor" or flag == "V.Box.Color") and typeof(val) == "Color3" then
		V.BoxColor = val
	elseif flag == "V.BoxStyle" then
		V.BoxStyle = (val == 2 or val == "Corner") and "Corner" or "Full"
	elseif flag == "V.BoxOutline" then
		V.BoxOutline = val
	elseif flag == "V.BoxRole" then
		V.BoxRoleColor = val
	elseif flag == "V.BoxAlpha" and type(val) == "number" then
		V.BoxTransparency = val / 100
	elseif flag == "V.BoxFill" then
		V.BoxFillEnabled = val
	elseif flag == "V.BoxFillColor" and typeof(val) == "Color3" then
		V.BoxFillColor = val
	elseif flag == "V.BoxFillAlpha" and type(val) == "number" then
		V.BoxFillTransparency = val / 100
	elseif flag == "V.Health" then
		V.HealthEnabled = val
	elseif flag == "V.HealthGrad1" and typeof(val) == "Color3" then
		V.HealthGradient1 = val
	elseif flag == "V.HealthGrad2" and typeof(val) == "Color3" then
		V.HealthGradient2 = val
	elseif flag == "V.Name" then
		V.NameEnabled = val
	elseif flag == "V.NameColor" and typeof(val) == "Color3" then
		V.NameColor = val
	elseif flag == "V.NameUseDisplay" then
		V.NameUseDisplay = val
	elseif flag == "V.Distance" then
		V.DistanceEnabled = val
	elseif flag == "V.Weapon" and type(val) == "boolean" then
		V.WeaponChams = val
		if val then
			scanWeapons()
			recolorTrackedWeapons()
		else
			restoreWeapons()
		end
	elseif (flag == "V.Weapon.Color" or flag == "V.Weapon") and typeof(val) == "Color3" then
		V.WeaponColor = val
		if V.WeaponChams then
			recolorTrackedWeapons()
		end
	elseif flag == "V.Corpse" then
		V.DeadBodiesEnabled = val
		V.ShowDead = val
		refreshCorpses()
		refreshStatic()
	elseif (flag == "V.DeadBodyColor" or flag == "V.DeadBodyFillColor" or flag == "V.DeadBodyFillColorPicker") and typeof(val) == "Color3" then
		V.DeadBodyFillColor = val
		V.DeadBodyColor = val
		refreshCorpses()
	elseif (flag == "V.DeadBodyOutlineColor" or flag == "V.DeadBodyOutlineColorPicker") and typeof(val) == "Color3" then
		V.DeadBodyOutlineColor = val
		refreshCorpses()
	elseif flag == "V.CorpseRole" then
		V.DeadBodyRoleColor = val
		refreshCorpses()
	elseif flag == "V.CorpseXRay" then
		V.DeadBodyXRay = val
		refreshCorpses()
	elseif flag == "V.CorpseFillA" and type(val) == "number" then
		V.DeadBodyFillTransparency = 1 - (val / 100)
		refreshCorpses()
	elseif flag == "V.CorpseOutlineA" and type(val) == "number" then
		V.DeadBodyOutlineTransparency = 1 - (val / 100)
		refreshCorpses()
	elseif flag == "V.Gun" then
		V.GunEnabled = val
		refreshGun()
	elseif flag == "V.GunColor" and typeof(val) == "Color3" then
		V.GunColor = val
		refreshGun()
	elseif flag == "V.ShotTracer" then
		V.TracerEnabled = val
		if not val then
			clearTracers()
		end
	elseif flag == "V.TracerColor" and typeof(val) == "Color3" then
		V.TracerColor = val
	elseif flag == "V.TracerDuration" and type(val) == "number" then
		V.TracerDuration = val
	elseif flag == "V.TracerThickness" and type(val) == "number" then
		V.TracerThickness = val
	elseif flag == "V.TracerTransparency" and type(val) == "number" then
		V.TracerTransparency = val / 100
	elseif flag == "V.TracerGlow" then
		V.TracerGlow = val
	end
end)

local function initCombat()

local WeaponService
local OriginalMouseTarget
local OriginalScreenTarget
local HookedMouseTarget
local HookedScreenTarget
local lastAutoShot = 0
local internalGunShot=false

local gunOrigin, clearShot, findTool, teleportShot
local ShitaroAim
local StatsService = game:GetService("Stats")

local AIM_PARTS = {
	Auto = { "UpperTorso", "Torso", "HumanoidRootPart", "LowerTorso", "Head", "LeftUpperLeg", "RightUpperLeg", "Left Leg", "Right Leg" },
	Head = { "Head", "UpperTorso", "Torso", "HumanoidRootPart" },
	Torso = { "UpperTorso", "Torso", "HumanoidRootPart", "LowerTorso", "Head" },
	Root = { "HumanoidRootPart", "UpperTorso", "Torso", "Head" },
}

local AIM_POINTS_MULTI = {
	Vector3.new(0, 0, 0),
	Vector3.new(0.32, 0, 0), Vector3.new(-0.32, 0, 0),
	Vector3.new(0, 0.32, 0), Vector3.new(0, -0.32, 0),
	Vector3.new(0, 0, 0.32), Vector3.new(0, 0, -0.32),
	Vector3.new(0.28, 0.28, 0.28), Vector3.new(0.28, 0.28, -0.28),
	Vector3.new(0.28, -0.28, 0.28), Vector3.new(0.28, -0.28, -0.28),
	Vector3.new(-0.28, 0.28, 0.28), Vector3.new(-0.28, 0.28, -0.28),
	Vector3.new(-0.28, -0.28, 0.28), Vector3.new(-0.28, -0.28, -0.28),
}
local AIM_POINTS_CENTER = { Vector3.new(0, 0, 0) }

local AIM_MAX_TRACK_SPEED=600
local AIM_MAX_TRACK_ACCELERATION=600
local AIM_WINDOW = 0.24
local AIM_MAX_RAYS = 48
local TRACK_N = 24

local aimTracks = {}
local SC_T = table.create(TRACK_N, 0)
local SC_X = table.create(TRACK_N, 0)
local SC_Y = table.create(TRACK_N, 0)
local SC_Z = table.create(TRACK_N, 0)

local ADAPT_SCALES = { 1, 0.8, 1.25, 0.6, 1.5 }
local AIM_TIME_ERROR = 0.08
local PEEK_DIRS = {
	Vector3.new(1,0,0),Vector3.new(-1,0,0),Vector3.new(0,1,0),Vector3.new(0,-1,0),
	Vector3.new(0,0,1),Vector3.new(0,0,-1),
	Vector3.new(1,0,1).Unit,Vector3.new(-1,0,1).Unit,
	Vector3.new(1,0,-1).Unit,Vector3.new(-1,0,-1).Unit,
	Vector3.new(1,1,0).Unit,Vector3.new(-1,1,0).Unit,
}

local aim = {
	cf = nil, origin = nil, bypass = false, point = nil,
	clear = false, blocked = false, conf = 0, lat = 0, dist = 0,
	target = nil, lastTarget = nil, t = -1, targetCheck = -1,
	waitStart = nil, shotAt = -1, adaptChecked = -1, adaptIndex = 1,
	spoofT = -1, spoofCF = nil, peekOffset = nil, peekT = -1,
}
local knifeAimCFrame, knifeHandle, findKnife
local teleporting = false
local lastTeleport = -10
local rttCache = { t = -10, v = 0 }
local knifeSelection = {}

local Geo = {}

local GEO_DEGREES = 180 / math.pi
local GEO_RADIANS = math.pi / 180

function Geo.finite(value)
	return type(value) == "number" and value == value and value ~= math.huge and value ~= -math.huge
end

function Geo.vectorFinite(value)
	return typeof(value) == "Vector3" and Geo.finite(value.X) and Geo.finite(value.Y) and Geo.finite(value.Z)
end

function Geo.wrapDelta(value)
	if not Geo.finite(value) then return nil end
	return (value+180)%360-180
end

function Geo.originFree(position,character)
	local ok,parts = pcall(function()
		local params = Geo.overlap
		if not params then
			params = OverlapParams.new()
			params.FilterType = Enum.RaycastFilterType.Exclude
			Geo.overlap = params
		end
		params.FilterDescendantsInstances = {LocalPlayer.Character,character}
		return Workspace:GetPartBoundsInBox(CFrame.new(position),Vector3.new(0.3,0.3,0.3),params)
	end)
	if not ok then return true end
	for _,part in ipairs(parts) do
		if part.CanCollide and part.Transparency < 0.95 then return false end
	end
	return true
end

function Geo.shotFrame(point, origin)
    if not (Geo.vectorFinite(point) and Geo.vectorFinite(origin)) then return nil end
    local delta = point - origin
    if delta.Magnitude < 0.0001 then return nil end
    local direction = delta.Unit
    local up = math.abs(direction.Y) > 0.999 and Vector3.zAxis or Vector3.yAxis
    return CFrame.lookAt(point, point + direction, up)
end

function Geo.rayBox(origin, direction, frame, size, maxDistance)
	if not (Geo.vectorFinite(origin) and Geo.vectorFinite(direction) and Geo.vectorFinite(size)) then return nil end
	if direction.Magnitude < 1e-6 then return nil end
	local o = frame:PointToObjectSpace(origin)
	local d = frame:VectorToObjectSpace(direction.Unit)
	local half = size*0.5
	local lo, hi = 0, maxDistance or math.huge
	for _, axis in ipairs({"X","Y","Z"}) do
		local p,v,h = o[axis],d[axis],math.max(0,half[axis])
		if math.abs(v) < 1e-8 then
			if p < -h or p > h then return nil end
		else
			local a,b = (-h-p)/v,(h-p)/v
			if a > b then a,b = b,a end
			lo,hi = math.max(lo,a),math.min(hi,b)
			if lo > hi then return nil end
		end
	end
	return lo,hi
end

function Geo.calculateAngles(origin, point, currentYaw, currentPitch, smoothing, snap)
	if not (Geo.vectorFinite(origin) and Geo.vectorFinite(point)
		and Geo.finite(currentYaw) and Geo.finite(currentPitch) and Geo.finite(smoothing)) then
		return nil
	end

	local dx, dy, dz = point.X - origin.X, point.Y - origin.Y, point.Z - origin.Z
	local square = dy * dy
	square = dx * dx + square
	square = dz * dz + square
	local length = math.sqrt(square)
	if not Geo.finite(length) or length < 0.0001 then
		return nil
	end

	local ux, uy, uz = dx / length, dy / length, dz / length
	local horizontal = math.sqrt(ux * ux + uz * uz)

	local desiredYaw = horizontal < 1e-8 and currentYaw or math.atan2(ux, uz) * GEO_DEGREES
	local desiredPitch = math.atan2(uy, horizontal) * -GEO_DEGREES

	local limited = math.clamp(smoothing,0,0.95)
	local state = Geo.state
	local dt = state and math.clamp(os.clock()-state.t,1/240,0.1) or 1/60
	local factor = (snap or limited == 0) and 1 or 1-limited^(dt*60)

	return
		Geo.wrapDelta(desiredYaw - currentYaw) * factor + currentYaw,
		Geo.wrapDelta(desiredPitch - currentPitch) * factor + currentPitch
end

function Geo.fireQuaternion(yaw, pitch)
	local hp = (pitch * GEO_RADIANS) * 0.5
	local hy = (yaw * GEO_RADIANS) * 0.5
	local sp, cp = math.sin(hp), math.cos(hp)
	local sy, cy = math.sin(hy), math.cos(hy)
	return sp * cy, sy * cp, -(sp * sy), cy * cp
end

function Geo.anglesOf(direction)
	local horizontal = math.sqrt(direction.X * direction.X + direction.Z * direction.Z)
	return
		math.atan2(direction.X, direction.Z) * GEO_DEGREES,
		math.atan2(direction.Y, horizontal) * -GEO_DEGREES
end

function Geo.directionOf(yaw, pitch)
	local y, p = yaw * GEO_RADIANS, pitch * GEO_RADIANS
	return Vector3.new(math.sin(y) * math.cos(p), -math.sin(p), math.cos(y) * math.cos(p))
end

function Geo.rotationCFrame(position, yaw, pitch)
	local qx, qy, qz, qw = Geo.fireQuaternion(yaw, pitch)
	return CFrame.new(position.X, position.Y, position.Z, qx, qy, qz, qw) * CFrame.Angles(0, math.pi, 0)
end

function Geo.refine(origin, point, smoothing, snap, hitFrame, hitSize)
	if not (Geo.vectorFinite(origin) and Geo.vectorFinite(point)) or (point - origin).Magnitude < 0.0001 then return nil end

	local currentYaw, currentPitch
	local state = Geo.state
	if state and smoothing > 0 and not snap and os.clock() - state.t < 0.35
		and (not state.origin or (origin-state.origin).Magnitude < 8) then
		currentYaw, currentPitch = state.yaw, state.pitch
	else
		local look = Camera and Camera.CFrame.LookVector or Vector3.new(0, 0, 1)
		currentYaw, currentPitch = Geo.anglesOf(look)
	end
	local yaw, pitch = Geo.calculateAngles(origin, point, currentYaw, currentPitch, smoothing, snap)
	if not yaw then
		return nil
	end
	local distance = (point-origin).Magnitude
	local direction = Geo.directionOf(yaw,pitch)
	if hitFrame and hitSize then
		local entry,exit = Geo.rayBox(origin,direction,hitFrame,hitSize,distance+hitSize.Magnitude)
		if entry then
			distance = math.clamp(distance,entry,exit)
		else

			yaw,pitch = Geo.anglesOf((point-origin).Unit)
			direction = Geo.directionOf(yaw,pitch)
		end
	end
	Geo.state = {yaw=yaw,pitch=pitch,t=os.clock(),origin=origin}
	return origin+direction*distance,yaw,pitch
end

local aimFovGui, aimMarkerGui
local aimHookLive = false
local namecallInstalled = false
local roleCache = { t = -10, ok = false }

local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude
rayParams.IgnoreWater = true
local rayFilterChar
local floorRayParams = RaycastParams.new()
floorRayParams.FilterType = Enum.RaycastFilterType.Exclude
floorRayParams.IgnoreWater = true
floorRayParams.RespectCanCollide = true

gunOrigin = function()
	local ch = LocalPlayer.Character
	local root = ch and ch:FindFirstChild("HumanoidRootPart")
	if not root then
		return nil
	end
	local attachment = root:FindFirstChild("GunRaycastAttachment")
	return attachment and attachment.WorldCFrame or root.CFrame
end

clearShot = function(origin,target,targetCharacter)
    if not (Geo.vectorFinite(origin) and Geo.vectorFinite(target)) then return false end
    local delta=target-origin
    local length=delta.Magnitude
    if length<0.001 then return true end
    if not Geo.finite(length) or length>1000000 then return false end
    local direction=delta/length
    local filter={}
    if LocalPlayer.Character then filter[#filter+1]=LocalPlayer.Character end
    if Workspace.CurrentCamera then filter[#filter+1]=Workspace.CurrentCamera end
    rayParams.RespectCanCollide=false
    local covered,skips=0,0
    while covered<length do
        local segment=math.min(14000,length-covered)
        rayParams.FilterDescendantsInstances=filter
        local result=Workspace:Raycast(origin+direction*covered,direction*segment,rayParams)
        if result then
            local hit=result.Instance
            if targetCharacter and hit and hit:IsDescendantOf(targetCharacter) then return true end
            if hit and hit:IsA("BasePart") and (1-(1-hit.Transparency)*(1-(hit.LocalTransparencyModifier or 0)))>=0.95 then
                skips=skips+1
                if skips>32 then return false end
                filter[#filter+1]=hit
            else return false end
        else
            covered=covered+segment
        end
    end
    return true
end

local function holdsGunRole(now)
    local _, _, character = aliveRoot(LocalPlayer)
    if not character or not isRoundActive() or isInLobby(LocalPlayer) then
        roleCache.ok = false
        roleCache.character = nil
        return false
    end
    local hasGun = hasRoundGun(LocalPlayer)
    if character ~= roleCache.character or hasGun ~= roleCache.hasGun or now - roleCache.t > 0.15 then
        roleCache.t, roleCache.character, roleCache.hasGun = now, character, hasGun
        local data = playerData(LocalPlayer)
        local role = effectiveRole(LocalPlayer, data)
        roleCache.ok = (not data or data.Dead ~= true) and hasGun and (role == "Sheriff" or role == "Hero")
    end
    return roleCache.ok
end

local function trackerFor(player)
	local tr = aimTracks[player]
	if not tr or tr.character ~= player.Character then
		tr = {
			character = player.Character,
			t = table.create(TRACK_N, 0),
			x = table.create(TRACK_N, 0),
			y = table.create(TRACK_N, 0),
			z = table.create(TRACK_N, 0),
			head = 0, count = 0, lastPush = -1,
			vel = Vector3.zero, acc = Vector3.zero,
			stab = 1, grounded = true, seen = 0,
		}
		aimTracks[player] = tr
	end
	return tr
end

local function pushSample(tr, now, position)
	if not (Geo.finite(now) and Geo.vectorFinite(position)) then return end
	if now<tr.lastPush then
        tr.count,tr.lastPush,tr.vel,tr.acc,tr.confidence=0,-1,Vector3.zero,Vector3.zero,0
    end
    if now-tr.lastPush<0.008 then
        local last=tr.head
        local delta=tr.count>0 and position-Vector3.new(tr.x[last],tr.y[last],tr.z[last]) or Vector3.zero
        if delta.Magnitude<=math.max(4,AIM_MAX_TRACK_SPEED*math.max(0,now-tr.lastPush)+0.5) then return end
        tr.count,tr.vel,tr.acc,tr.confidence=0,Vector3.zero,Vector3.zero,0
        Geo.state=nil
        aim.spoofCF,aim.peekOffset,aim.waitStart=nil,nil,nil
    end

	if tr.count > 0 then
		local last = tr.head
		local dt = now - tr.t[last]
		if dt > 0 then
			local dx = position.X - tr.x[last]
			local dy = position.Y - tr.y[last]
			local dz = position.Z - tr.z[last]
			local speed = math.sqrt(dx * dx + dy * dy + dz * dz) / dt
			if not Geo.finite(speed) or speed > AIM_MAX_TRACK_SPEED or dt > 0.5 then
				tr.vel,tr.acc = Vector3.zero,Vector3.zero
				Geo.state = nil
				tr.count = 0
                tr.confidence = 0
                aim.spoofCF, aim.peekOffset, aim.waitStart = nil, nil, nil
			end
		end
	end

	tr.lastPush = now
	local i = tr.head % TRACK_N + 1
	tr.head = i
	tr.t[i], tr.x[i], tr.y[i], tr.z[i] = now, position.X, position.Y, position.Z
	tr.count = math.min(tr.count + 1, TRACK_N)
	tr.seen = now
end

local function slope(ts,vs,a,b)
    if b-a<1 then return 0 end
    local baseT,baseV=ts[a],vs[a]
    local sw,st,sv,stt,stv=0,0,0,0,0
    for i=a,b do
        local t,v=ts[i]-baseT,vs[i]-baseV
        local weight=math.exp(t/0.06)
        sw=sw+weight; st=st+weight*t; sv=sv+weight*v
        stt=stt+weight*t*t; stv=stv+weight*t*v
    end
    local denominator=sw*stt-st*st
    if math.abs(denominator)<1e-10 then return 0 end
    return (sw*stv-st*sv)/denominator
end

local function fitTrack(tr,now,root,hum)
    local n,index=0,tr.head
    for _=1,tr.count do
        local time=tr.t[index]
        if now-time>AIM_WINDOW then break end
        n=n+1
        SC_T[n],SC_X[n],SC_Y[n],SC_Z[n]=time-now,tr.x[index],tr.y[index],tr.z[index]
        index=index-1; if index<1 then index=TRACK_N end
    end
    local velocity=Vector3.zero
    local acceleration=Vector3.zero
    local stability,agreement=1,1
    local recentN=0
    for i=1,n do
        if SC_T[1]-SC_T[i]<=0.085 then recentN=i else break end
    end
                                                                                
                                                                                 
    local fitN=recentN>=2 and recentN or n
    if fitN>=2 then
        velocity=Vector3.new(slope(SC_T,SC_X,1,fitN),slope(SC_T,SC_Y,1,fitN),slope(SC_T,SC_Z,1,fitN))
    end
    local half=n//2
    if half>=2 then
        local recent=Vector3.new(slope(SC_T,SC_X,1,half),0,slope(SC_T,SC_Z,1,half))
        local older=Vector3.new(slope(SC_T,SC_X,n-half+1,n),0,slope(SC_T,SC_Z,n-half+1,n))
        local span=(SC_T[1]+SC_T[half]-SC_T[n-half+1]-SC_T[n])*0.5
        if recent.Magnitude>3 and older.Magnitude>3 then
            stability=math.clamp(recent:Dot(older)/(recent.Magnitude*older.Magnitude),0,1)
        elseif recent.Magnitude>3 or older.Magnitude>3 then stability=0.5 end
        if span>0.025 and stability>0.3 then acceleration=(recent-older)/span end
    end
    local ok,assembly=pcall(function() return root.AssemblyLinearVelocity end)
    local physical=ok and Geo.vectorFinite(assembly) and assembly.Magnitude<=AIM_MAX_TRACK_SPEED
    local grounded=not hum or hum.FloorMaterial~=Enum.Material.Air
    if physical then
        local horizontal=Vector3.new(assembly.X,0,assembly.Z)
        local fitted=Vector3.new(velocity.X,0,velocity.Z)
        local difference=(horizontal-fitted).Magnitude
        agreement=math.clamp(1-difference/80,0.3,1)
        local turn=horizontal.Magnitude>3 and fitted.Magnitude>3
            and horizontal:Dot(fitted)/(horizontal.Magnitude*fitted.Magnitude)<0.2
        if n<3 or turn or (horizontal.Magnitude<0.75 and fitted.Magnitude>3) then
            velocity=assembly
            acceleration=Vector3.zero
            if turn then stability=0 end
        elseif difference>12 then
            velocity=velocity*0.25+assembly*0.75
            acceleration=Vector3.zero
        else velocity=velocity*0.7+assembly*0.3 end
        if tr.physicalVelocity and tr.physicalTime and now-tr.physicalTime<=0.2 then
            local change=Vector3.new(assembly.X-tr.physicalVelocity.X,0,assembly.Z-tr.physicalVelocity.Z).Magnitude
                                                                                     
                                                                                 
            if change<2 or change>12 then acceleration=Vector3.zero end
        end
        tr.physicalVelocity,tr.physicalTime=assembly,now
        if grounded and horizontal.Magnitude<0.75 and n>=2 then
            local still=1
            for i=2,n do
                local dx,dz=SC_X[i]-SC_X[1],SC_Z[i]-SC_Z[1]
                if dx*dx+dz*dz>0.000225 then break end
                still=i
            end
            if SC_T[1]-SC_T[still]>=0.035 then
                velocity=Vector3.new(0,assembly.Y,0)
                acceleration=Vector3.zero
            end
        end
        if not grounded or math.abs(assembly.Y)>6 then
            velocity=Vector3.new(velocity.X,assembly.Y,velocity.Z)
            grounded=false
        end
    end
    if not Geo.vectorFinite(velocity) then velocity=Vector3.zero end
    if velocity.Magnitude>AIM_MAX_TRACK_SPEED then velocity=velocity.Unit*AIM_MAX_TRACK_SPEED end
    if not Geo.vectorFinite(acceleration) then acceleration=Vector3.zero end
    if acceleration.Magnitude>AIM_MAX_TRACK_ACCELERATION then acceleration=acceleration.Unit*AIM_MAX_TRACK_ACCELERATION end
    tr.vel,tr.acc,tr.stab,tr.grounded=velocity,acceleration,stability,grounded
    tr.confidence=math.clamp(math.clamp(n/6,0.25,1)*(0.65+0.35*stability)*agreement,0,1)
end

local function currentRtt(now)
    if now - rttCache.t >= 0.25 then
        rttCache.t = now
        local measured
        local ok, ping = pcall(function() return LocalPlayer:GetNetworkPing() end)
        if ok and Geo.finite(ping) and ping >= 0 then measured = ping end
        if not measured then
            local okStats, value = pcall(function()
                return StatsService.Network.ServerStatsItem["Data Ping"]:GetValue()
            end)
            if okStats and Geo.finite(value) and value >= 0 then measured = value / 1000 end
        end
        if measured then
            measured = math.clamp(measured, 0, 1.2)
            if not rttCache.initialized then
                rttCache.v, rttCache.jitter, rttCache.initialized = measured, 0, true
            else
                local error = math.abs(measured - rttCache.v)
                rttCache.jitter = (rttCache.jitter or 0) * 0.75 + error * 0.25
                local weight = error > 0.15 and 0.65 or 0.35
                rttCache.v = rttCache.v + (measured - rttCache.v) * weight
            end
        end
    end
    return rttCache.v
end

local function leadTime(now)
    if ShitaroAim then return ShitaroAim:LeadTime() end
	if not V.AimPrediction then
		return 0
	end

	local lead = V.AimInterp or 0.07
	if V.AimPing then
		lead += (currentRtt(now)*0.5+math.min((rttCache.jitter or 0)*0.25,0.025)) * math.clamp(V.AimPingScale or 1,0,3)
	end

	lead *= math.clamp(V.PredictionScale or 1, 0, 3)
	if V.AimAdaptive then
		lead *= ADAPT_SCALES[aim.adaptIndex] or 1
	end
	return math.clamp(lead,0,math.clamp(V.AimMaxLead or 0.45,0,1))
end

local function predictOffset(tr,partPosition,lead,root,options)
    if not Geo.finite(lead) or lead<=0 or not Geo.vectorFinite(partPosition) then return Vector3.zero end
    lead=math.clamp(lead,0,1)
    local velocity=Geo.vectorFinite(tr.vel) and tr.vel or Vector3.zero
    local acceleration=Geo.vectorFinite(tr.acc) and tr.acc or Vector3.zero
    local confidence=math.clamp(tr.confidence or 0,0,1)
    local stability=math.clamp(tr.stab or 0,0,1)
    local horizontal=Vector3.new(velocity.X,0,velocity.Z)
    local mode=options and options.mode or V.AimPredictMode
    local strafeDamp,gravity=V.AimStrafeDamp,V.AimGravity
    if options then strafeDamp,gravity=options.strafeDamp,options.gravity end
    local displacement=horizontal*lead
    if mode~="Linear" then
        local horizon=math.min(lead,0.12)
        local weight=confidence*(strafeDamp and stability*stability or 1)
        local correction=Vector3.new(acceleration.X,0,acceleration.Z)*(0.5*horizon*horizon*weight)
        local limit=math.max(2,horizontal.Magnitude*0.3)*lead
        if correction.Magnitude>limit then correction=correction.Unit*limit end
        displacement=displacement+correction
    end
    local dy=not tr.grounded and velocity.Y*lead or 0
    if root and root.Parent then
        floorRayParams.FilterDescendantsInstances={LocalPlayer.Character,root.Parent}
        if displacement.Magnitude>0.05 then
            local obstacle=Workspace:Raycast(root.Position,displacement,floorRayParams)
            if obstacle and Geo.finite(obstacle.Distance) then
                displacement=displacement.Unit*math.clamp(obstacle.Distance-0.1,0,displacement.Magnitude)
            end
        end
    end
    if gravity and not tr.grounded then
        dy=velocity.Y*lead-0.5*math.clamp(Workspace.Gravity,0,1000)*lead*lead
        if dy<0 and root and root.Parent then
            floorRayParams.FilterDescendantsInstances={LocalPlayer.Character,root.Parent}
            local floor=Workspace:Raycast(partPosition+displacement,Vector3.new(0,dy-6,0),floorRayParams)
            if floor then
                local hum=root.Parent:FindFirstChildOfClass("Humanoid")
                local hip=hum and hum.HipHeight or 0
                local r15=root.Parent:FindFirstChild("UpperTorso")~=nil
                local feet=root.Position.Y-(r15 and (hip+root.Size.Y*0.5) or 3)
                dy=math.max(dy,floor.Position.Y-feet)
            end
        end
    end
    if dy>0.05 and root and root.Parent then
        local head=root.Parent:FindFirstChild("Head")
        local top=head and head:IsA("BasePart") and head.Position+Vector3.new(0,head.Size.Y*0.5,0)
            or root.Position+Vector3.new(0,root.Size.Y*0.5,0)
        floorRayParams.FilterDescendantsInstances={LocalPlayer.Character,root.Parent}
        local ceiling=Workspace:Raycast(top+displacement,Vector3.new(0,dy,0),floorRayParams)
        if ceiling and Geo.finite(ceiling.Distance) then dy=math.clamp(ceiling.Distance-0.1,0,dy) end
    end
    return displacement+Vector3.new(0,dy,0)
end

local function candidateParts(character, mode)
	local names = AIM_PARTS[mode] or AIM_PARTS.Auto
	local list = {}
	for _, name in ipairs(names) do
		local part = character:FindFirstChild(name)
		if part and part:IsA("BasePart") then
			list[#list + 1] = part
		end
	end

	if mode == "Closest" and #list > 1 then
		local size = Overlay.AbsoluteSize
		if size.X <= 0 or size.Y <= 0 then size = Workspace.CurrentCamera.ViewportSize end
		local middle = Vector2.new(size.X * 0.5, size.Y * 0.5)
		local score = {}
		for _, part in ipairs(list) do
			local point, _, depth = viewPoint(part.Position)
			score[part] = (point and depth and depth > 0) and (point - middle).Magnitude or math.huge
		end
		table.sort(list, function(a, b)
			return score[a] < score[b]
		end)
	end

	return list
end

local function updateAim(now,manual,freshShot,shotOrigin)
    aim.cf, aim.point, aim.origin, aim.originRot = nil, nil, nil, nil
    aim.character, aim.part, aim.hitFrame, aim.hitSize = nil, nil, nil, nil
    aim.clear, aim.blocked, aim.bypass, aim.conf = false, false, false, 0
    if not ShitaroAim then return end
    local cf, origin, target, part, character, track = ShitaroAim:Resolve(manual and "Manual" or true, true)
    local network = ShitaroAim:GetDiagnostics()
    rttCache.jitter = network.Jitter or 0
    if not cf or not origin or not target or not part then return end
    aim.target, aim.character, aim.part, aim.cf = target, character, part, cf
    aim.point, aim.t = cf.Position, now
    aim.hitFrame = part.CFrame + (cf.Position - part.Position)
    aim.hitSize, aim.partPosition, aim.partFrame = part.Size, part.Position, part.CFrame
    aim.conf = track.ready and math.clamp(1 - (track.turn or 0) * 0.5, 0, 1) or 0.25
    aim.clear = clearShot(origin.Position, cf.Position, character)
    aim.blocked = not aim.clear
    if V.WallShoot and not V.AimTeleport then
        aim.origin, aim.bypass = origin, true
    end
    local root = aliveRoot(target)
    aim.targetVelocity = root and root.AssemblyLinearVelocity or Vector3.zero
    aim.lat = track.fresh.Magnitude
    aimTracks[target] = {vel = track.fresh, acc = Vector3.zero, confidence = aim.conf}
end

local function updateAimVisuals()
	local showFov = V.SilentAim and V.AimFov and V.AimFovCircle
	if showFov then
		if not aimFovGui then
			local frame = Instance.new("Frame")
			frame.Name = "Waraku_AIM_FOV"
			frame.AnchorPoint = Vector2.new(0.5, 0.5)
			frame.BackgroundTransparency = 1
			frame.BorderSizePixel = 0
			frame.ZIndex = 2
			frame.Visible = false
			frame.Parent = Overlay

			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(1, 0)
			corner.Parent = frame

			local stroke = Instance.new("UIStroke")
			stroke.Thickness = 1
			stroke.Transparency = 0.35
			stroke.Color = Color3.fromRGB(255, 255, 255)
			stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			stroke.Parent = frame

			aimFovGui = frame
		end
		local size = Overlay.AbsoluteSize
		local radius = V.AimFovRadius or 300
		aimFovGui.Position = UDim2.fromOffset(size.X * 0.5, size.Y * 0.5)
		aimFovGui.Size = UDim2.fromOffset(radius * 2, radius * 2)
		aimFovGui.Visible = true
	elseif aimFovGui then
		aimFovGui.Visible = false
	end

	local showMarker = V.SilentAim and V.AimMarker and aim.point and os.clock() - aim.t < 0.2
	if showMarker then
		local point, _, depth = viewPoint(aim.point)
		if point and depth and depth > 0 then
			if not aimMarkerGui then
				local dot = Instance.new("Frame")
				dot.Name = "Waraku_AIM_MARKER"
				dot.AnchorPoint = Vector2.new(0.5, 0.5)
				dot.Size = UDim2.fromOffset(7, 7)
				dot.BorderSizePixel = 0
				dot.ZIndex = 6
				dot.Visible = false
				dot.Parent = Overlay

				local corner = Instance.new("UICorner")
				corner.CornerRadius = UDim.new(1, 0)
				corner.Parent = dot

				local stroke = Instance.new("UIStroke")
				stroke.Thickness = 1
				stroke.Color = Color3.new(0, 0, 0)
				stroke.Parent = dot

				aimMarkerGui = dot
			end
			aimMarkerGui.Position = UDim2.fromOffset(point.X, point.Y)
			aimMarkerGui.BackgroundColor3 = aim.clear and Color3.fromRGB(80, 255, 120) or Color3.fromRGB(255, 80, 80)
			aimMarkerGui.Visible = true
			return
		end
	end
	if aimMarkerGui then
		aimMarkerGui.Visible = false
	end
end

local function getWeaponService()
	if WeaponService then
		return WeaponService
	end
	local folder = RS:FindFirstChild("ClientServices")
	local module = folder and folder:FindFirstChild("WeaponService")
	if not module then
		return nil
	end
	local ok, service = pcall(require, module)
	if ok and type(service) == "table" then
		WeaponService = service
	end
	return WeaponService
end

                                                                              
                                                                                   
ShitaroAim = (function()
local players, rs, collection, run, lp, stats = Players, RS, CollectionService, RunService, LocalPlayer, StatsService
local S = {enabled = false, predict = true, force = false, auto_on = false,
    auto_delay = 0, am_sheriff = false, fire_gap = 0, last_shot = 0, stand_off = 15}
local previewing, resolved_origin = false, nil
local MAX_RANGE = 300

local gap_min = 0
local gap_seen = false
local gap_gun = nil
local want_since = 0

local function gap_reset()
	gap_min = 0
	gap_seen = false
	S.fire_gap = 0
end

local function gap_push(value)
	if value <= 0 then return end
	if not gap_seen or value < gap_min then
		gap_min = value
		gap_seen = true
		S.fire_gap = value
	end
end

local round_mod = nil

local function get_round() return Round end

local function holds(container, name)
	return container ~= nil and container:FindFirstChild(name) ~= nil
end

local function lp_has_gun()
	return holds(lp.Character, "Gun") or holds(lp:FindFirstChildOfClass("Backpack"), "Gun")
end

local target_player = nil
local target_char = nil
local target_part = nil
local target_hum = nil

local function refresh_target()
	local found = nil
	local m = get_round()
	local data = m and m.PlayerData or nil
	if type(data) == "table" then
		local me = data[lp.Name]
		S.am_sheriff = (me ~= nil and (me.Role == "Sheriff" or me.Role == "Hero")) or lp_has_gun()
		for name, d in pairs(data) do
			if type(d) == "table" and d.Role == "Murderer" and not d.Dead then
				found = players:FindFirstChild(name)
				break
			end
		end
	else
		S.am_sheriff = lp_has_gun()
	end
	if not found then
		for _, plr in ipairs(players:GetPlayers()) do
			if plr ~= lp and holds(plr.Character, "Knife") then
				found = plr
				break
			end
		end
	end
	if found ~= target_player then
		target_player = found
		target_char = nil
		target_part = nil
		target_hum = nil
	end
	if not found then return end
	local char = found.Character
	if char ~= target_char then
		target_char = char
		target_part = nil
		target_hum = nil
	end
	if not char then return end
	if not target_part or not target_part.Parent then
		target_part = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
	end
	if not target_hum or not target_hum.Parent then
		target_hum = char:FindFirstChildOfClass("Humanoid")
	end
end

local function target_alive()
	if not target_part or not target_part.Parent then return false end
	if not target_hum or not target_hum.Parent then return false end
	return target_hum.Health > 0
end

local ray_params = RaycastParams.new()
ray_params.FilterType = Enum.RaycastFilterType.Exclude
ray_params.IgnoreWater = false

local ignore_base = {}
local ignore_work = {}
local ignore_time = 0

local function refresh_ignore()
	local now = os.clock()
	if #ignore_base > 0 and now - ignore_time < 0.5 then return end
	ignore_time = now
	table.clear(ignore_base)
	local char = lp.Character
	if char then ignore_base[1] = char end
	local ok, tagged = pcall(function() return collection:GetTagged("WeaponPassthrough") end)
	if ok and type(tagged) == "table" then
		for k = 1, #tagged do
			ignore_base[#ignore_base + 1] = tagged[k]
		end
	end
end

local function trace(origin, direction)
	refresh_ignore()
	table.clear(ignore_work)
	for k = 1, #ignore_base do ignore_work[k] = ignore_base[k] end
	local result = nil
	for _ = 1, 6 do
		ray_params.FilterDescendantsInstances = ignore_work
		result = workspace:Raycast(origin, direction, ray_params)
		if not result then break end
		local inst = result.Instance
		if not inst then break end
		local ok, tr = pcall(function() return inst.Transparency end)
		if not ok or tr ~= 1 then break end
		ignore_work[#ignore_work + 1] = inst
	end
	return result
end

local function gun_attachment()
	local char = lp.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return nil, nil end
	return hrp:FindFirstChild("GunRaycastAttachment"), hrp
end

local function origin_cframe()
	local att, hrp = gun_attachment()
	if att then return att.WorldCFrame end
	if hrp then return hrp.CFrame end
	return nil
end

local function grav()
	if V.AimGravity == false then return 0 end
	local ok, g = pcall(function() return workspace.Gravity end)
	if ok and type(g) == "number" and g > 0 then return g end
	return 0
end

local P = {
	snap = 48,
	ring = 48,
	hit_r = 2.1,
	pad = 2.6,
	min_span = 5,
	max_span = 90,
	acc_t = 0.15,
	acc_max = 280,
	acc_min = 40,
	speed_floor = 26,
	speed_head = 1.3,
}

local snap_t = table.create(P.snap, 0)
local snap_p = table.create(P.snap, Vector3.zero)
local snap_n = 0
local snap_i = 0

local TR = {
	part = nil,
	pos = nil,
	time = 0,
	vel = Vector3.zero,
	gap = 0,
	ready = false,
	fresh = Vector3.zero,
	air = false,
	air_since = 0,
	jumping = false,
	jump_v = 0,
	fresh_ok = false,
	turn = 0,
	spoof = 0,
	clr = 0,
	air_edge = 0,
	jump_fresh = false,
}

local SK = {
	vt = table.create(P.ring, 0),
	dx = table.create(P.ring, 0),
	dz = table.create(P.ring, 0),
	vn = 0,
	vi = 0,
}

local EC = {
	ping = 0,
	rtt = 0,
	jitter = 0,
	seen = false,
	step = 0,
	step_seen = false,
}

-- Jerk tracker: sharp reversals and speed spikes of the target (dashes, strafe
-- spam).  The level (0..1) shortens the prediction window for erratic targets
-- and keeps the full window for clean straight runs.
local JK = {t = {}, m = {}, n = 0}
local function jerk_clear()
	JK.t, JK.m, JK.n = {}, {}, 0
end
local function jerk_push(now, magnitude)
	JK.n = JK.n % 12 + 1
	JK.t[JK.n], JK.m[JK.n] = now, magnitude
end
local function jerk_level(now)
	if V.AimJerkAdapt == false then return 0 end
	local total = 0
	for k = 1, 12 do
		local t = JK.t[k]
		if t then
			local age = now - t
			if age >= 0 and age < 1.4 then
				total = total + math.clamp((JK.m[k] or 0) / 40, 0.25, 1.5) * (1 - age / 1.4)
			end
		end
	end
	return math.clamp(total / 2.2, 0, 1)
end

-- Prediction-gain calibrator.  For every recent sample the velocity that would
-- have been used is compared with what the target really did over the lead
-- window; the least-squares gain k (1 = the target keeps its velocity, ~0 = it
-- reverses/stops constantly, >1 = it accelerates) scales the lead.  This adapts
-- to dashes, strafe spam and straight runs without hand-tuned thresholds.
local CAL_SIZE = 96
local CAL = {t = {}, x = {}, z = {}, vx = {}, vz = {}, n = 0, i = 0,
	k = 1, err = 0, stamp = 0, valid = false,
	px = {}, pz = {}, ax = {}, az = {}, w = {}}
local function cal_clear()
	CAL.t, CAL.x, CAL.z, CAL.vx, CAL.vz = {}, {}, {}, {}, {}
	CAL.n, CAL.i, CAL.k, CAL.err, CAL.stamp, CAL.valid = 0, 0, 1, 0, 0, false
end
local function cal_push(now, pos, vel)
	CAL.i = CAL.i % CAL_SIZE + 1
	CAL.t[CAL.i], CAL.x[CAL.i], CAL.z[CAL.i] = now, pos.X, pos.Z
	CAL.vx[CAL.i], CAL.vz[CAL.i] = vel.X, vel.Z
	if CAL.n < CAL_SIZE then CAL.n = CAL.n + 1 end
end
local function cal_index(m)
	return (CAL.i - CAL.n + m - 1) % CAL_SIZE + 1
end
local function cal_update(now, horizon)
	if now - CAL.stamp < 0.07 then return end
	CAL.stamp = now
	if CAL.n < 12 then
		CAL.valid = false
		CAL.k = CAL.k + (1 - CAL.k) * 0.5
		return
	end
	horizon = math.clamp(horizon, 0.04, 0.30)
	local newest = CAL.t[cal_index(CAL.n)]
	local num, den, count, jj = 0, 0, 0, 1
	for ii = 1, CAL.n - 1 do
		local a = cal_index(ii)
		local ta = CAL.t[a]
		if newest - ta <= 1.8 then
			if jj <= ii then jj = ii + 1 end
			while jj <= CAL.n and CAL.t[cal_index(jj)] - ta < horizon do jj = jj + 1 end
			if jj > CAL.n then break end
			local b = cal_index(jj)
			local dt = CAL.t[b] - ta
			if dt <= horizon * 1.6 then
				local px, pz = CAL.vx[a] * dt, CAL.vz[a] * dt
				local mag2 = px * px + pz * pz
				if mag2 > 0.25 then
					local w = math.exp(-(newest - ta) / 0.9)
					local ax, az = CAL.x[b] - CAL.x[a], CAL.z[b] - CAL.z[a]
					num = num + w * (ax * px + az * pz)
					den = den + w * mag2
					count = count + 1
					CAL.px[count], CAL.pz[count], CAL.ax[count], CAL.az[count], CAL.w[count] = px, pz, ax, az, w
				end
			end
		end
	end
	if count < 5 or den < 2 then
		CAL.valid = false
		CAL.k = CAL.k + (1 - CAL.k) * 0.4
		return
	end
	local raw = math.clamp(num / den, 0.2, 1.3)
	CAL.k = CAL.k * 0.4 + raw * 0.6
	local sq, ws = 0, 0
	for q = 1, count do
		local ex = CAL.ax[q] - CAL.k * CAL.px[q]
		local ez = CAL.az[q] - CAL.k * CAL.pz[q]
		sq = sq + CAL.w[q] * (ex * ex + ez * ez)
		ws = ws + CAL.w[q]
	end
	CAL.err = CAL.err * 0.5 + math.sqrt(sq / math.max(ws, 1e-6)) * 0.5
	CAL.valid = true
end

local function step_push(dt)
	if dt <= 0 or dt > 0.5 then return end
	if EC.step_seen then
		EC.step = EC.step * 0.85 + dt * 0.15
	else
		EC.step = dt
		EC.step_seen = true
	end
end

local function sample_span()
	local span = math.max(EC.step, TR.gap)
	if span <= 0 then return 0 end
	return span
end

local HY = {
	pos = {},
	w = {},
	n = 0,
	weight = 0,
	primary = nil,
	stamp = 0,
	conf = 0,
}

local ground_params = RaycastParams.new()
ground_params.FilterType = Enum.RaycastFilterType.Exclude
ground_params.IgnoreWater = true
ground_params.RespectCanCollide = true

local ground_filter = {}
local axis_pool = {}

local function ground_below(pos, reach)
	table.clear(ground_filter)
	local n = 0
	local char = target_char
	if char then
		n = n + 1
		ground_filter[n] = char
	end
	local mine = lp.Character
	if mine then
		n = n + 1
		ground_filter[n] = mine
	end
	ground_params.FilterDescendantsInstances = ground_filter
	local res = workspace:Raycast(pos, Vector3.new(0, -reach, 0), ground_params)
	if res then return res.Position.Y end
	return nil
end

local function snap_push(now, pos)
	snap_i = snap_i % P.snap + 1
	snap_t[snap_i] = now
	snap_p[snap_i] = pos
	if snap_n < P.snap then snap_n = snap_n + 1 end
end

local function snap_get(k)
	local idx = (snap_i - k - 1) % P.snap + 1
	return snap_t[idx], snap_p[idx]
end

local function fit_velocity()
	if snap_n < 3 then return nil end
	local newest = snap_get(0)
	local used = 0
	local sum_d = 0
	local win = sample_span() * 4
	for k = 0, snap_n - 1 do
		local t = snap_get(k)
		if newest - t > win then break end
		used = used + 1
		sum_d = sum_d + t - newest
	end
	if used < 3 then return nil end
	local mean_d = sum_d / used
	local num = Vector3.zero
	local den = 0
	for k = 0, used - 1 do
		local t, p = snap_get(k)
		local d = t - newest - mean_d
		num = num + p * d
		den = den + d * d
	end
	if den < 1e-8 then return nil end
	return num / den, -mean_d
end

local function recent_velocity()
	if snap_n < 2 then return nil end
	local newest, head = snap_get(0)
	local fallback, fallback_age = nil, nil
	local target_span = sample_span() * 2
	local max_span = target_span * 2
	for k = 1, snap_n - 1 do
		local t, p = snap_get(k)
		local dt = newest - t
		if dt > max_span then break end
		if dt > 0 then
			fallback = (head - p) / dt
			fallback_age = dt * 0.5
			if dt >= target_span then
				return fallback, fallback_age
			end
		end
	end
	return fallback, fallback_age
end

local KIN = {
	ok = false,
	ax = 0,
	az = 0,
	smax = 0,
}

local function kin_clear()
	KIN.ok = false
	KIN.ax = 0
	KIN.az = 0
	KIN.smax = 0
end

local function fit_kin()
	if snap_n < 5 then return nil end
	local t0 = snap_get(0)
	local win = math.max(sample_span() * 5, 0.12)
	local scale = win
	local n, s1, s2, s3, s4 = 0, 0, 0, 0, 0
	local bx0, bx1, bx2 = 0, 0, 0
	local bz0, bz1, bz2 = 0, 0, 0
	for k = 0, snap_n - 1 do
		local t, p = snap_get(k)
		local age = t0 - t
		if age > win then break end
		local u = -age / scale
		local u2 = u * u
		n = n + 1
		s1 = s1 + u
		s2 = s2 + u2
		s3 = s3 + u2 * u
		s4 = s4 + u2 * u2
		bx0 = bx0 + p.X
		bx1 = bx1 + p.X * u
		bx2 = bx2 + p.X * u2
		bz0 = bz0 + p.Z
		bz1 = bz1 + p.Z * u
		bz2 = bz2 + p.Z * u2
	end
	if n < 5 then return nil end
	local det = n * (s2 * s4 - s3 * s3)
		- s1 * (s1 * s4 - s3 * s2)
		+ s2 * (s1 * s3 - s2 * s2)
	if math.abs(det) < 1e-9 then return nil end
	local function solve(b0, b1, b2)
		local d1 = n * (b1 * s4 - s3 * b2)
			- b0 * (s1 * s4 - s3 * s2)
			+ s2 * (s1 * b2 - b1 * s2)
		local d2 = n * (s2 * b2 - b1 * s3)
			- s1 * (s1 * b2 - b1 * s2)
			+ b0 * (s1 * s3 - s2 * s2)
		return d1 / det, d2 / det
	end
	local cx1, cx2 = solve(bx0, bx1, bx2)
	local cz1, cz2 = solve(bz0, bz1, bz2)
	local vx, vz = cx1 / scale, cz1 / scale
	local ax, az = 2 * cx2 / (scale * scale), 2 * cz2 / (scale * scale)
	if vx ~= vx or vz ~= vz or ax ~= ax or az ~= az then return nil end
	return Vector3.new(vx, 0, vz), Vector3.new(ax, 0, az)
end

local function kin_update()
	local kv, ka = fit_kin()
	if not kv then
		KIN.ok = false
		KIN.ax = 0
		KIN.az = 0
		return nil
	end
	KIN.ok = true
	local sp = math.sqrt(kv.X * kv.X + kv.Z * kv.Z)
	if sp > KIN.smax then
		KIN.smax = sp
	else
		KIN.smax = KIN.smax * 0.985 + sp * 0.015
	end
	if ka and not TR.air then
		local am = math.sqrt(ka.X * ka.X + ka.Z * ka.Z)
		local ax, az = ka.X, ka.Z
		if am > P.acc_max and am > 0 then
			ax = ax * P.acc_max / am
			az = az * P.acc_max / am
		end
		KIN.ax = KIN.ax * 0.5 + ax * 0.5
		KIN.az = KIN.az * 0.5 + az * 0.5
	else
		KIN.ax = KIN.ax * 0.5
		KIN.az = KIN.az * 0.5
	end
	return kv
end

local function snap_vel(k)
	local t0, p0 = snap_get(k)
	local t1, p1 = snap_get(k + 1)
	local d = t0 - t1
	if d <= 0 then return nil end
	return (p0 - p1) / d, d
end

local function vert_accel()
	if snap_n < 3 then return nil end
	local v0, d0 = snap_vel(0)
	local v1, d1 = snap_vel(1)
	if not v0 or not v1 then return nil end
	local span = (d0 + d1) * 0.5
	if span <= 1e-4 then return nil end
	return (v0.Y - v1.Y) / span
end

local function air_vy()
    if snap_n < 2 then return nil end
    local edge = TR.air_edge
    if edge <= 0 then return nil end
    local g = grav()
    local newest, head = snap_get(0)
    local want = math.max(sample_span() * 2, 0.035)
    local best, bestDt
    for k = 1, snap_n - 1 do
        local t, p = snap_get(k)
        if t < edge then break end
        local dt = newest - t
        if dt > 1e-4 then
            -- y(t) = y0 + v0*t - 0.5*g*t^2, therefore
            -- v0 = dy/dt + 0.5*g*dt.  The previous implementation used
            -- the opposite sign and systematically under-estimated jump speed.
            local estimate = (head.Y - p.Y) / dt + 0.5 * g * dt
            if best == nil or math.abs(dt - want) < math.abs(bestDt - want) then
                best, bestDt = estimate, dt
            end
            if dt >= want then break end
        end
    end
    return best
end

local function body_clearance()
	local part = target_part
	local hum = target_hum
	if not part or not hum then return 0 end
	local ok, value = pcall(function() return part.Size.Y * 0.5 + hum.HipHeight end)
	if ok and type(value) == "number" and value > 0 then return value end
	return 0
end

local GC = {
	base = 0,
	seen = false,
}

local JL = {
	v = 0,
	seen = false,
}

local function stand_clearance()
	if GC.seen then return GC.base end
	return body_clearance()
end

local function engine_vel(part)
	local ok, v = pcall(function() return part.AssemblyLinearVelocity end)
	if not ok or typeof(v) ~= "Vector3" then
		ok, v = pcall(function() return part.Velocity end)
	end
	if not ok or typeof(v) ~= "Vector3" then return nil end
	if v.Magnitude ~= v.Magnitude then return nil end
	return v
end

local function vel_trust(pv, ev)
	if not pv or not ev then return 0 end
	local ph = Vector3.new(pv.X, 0, pv.Z)
	local eh = Vector3.new(ev.X, 0, ev.Z)
	local pm, em = ph.Magnitude, eh.Magnitude
	if pm < 1 and em < 1 then return 1 end
	if pm < 1 or em < 1 then return 0 end
	local ratio = em / pm
	if ratio > 1.5 or ratio < 0.6 then return 0 end
	local align = ph.Unit:Dot(eh.Unit)
	if align < 0.7 then return 0 end
	local a = math.clamp((align - 0.7) / 0.25, 0, 1)
	local r = 1 - math.clamp(math.abs(ratio - 1) / 0.4, 0, 1)
	return a * r
end

local function phase_velocity(v, age, air)
	if not v then return nil end
	local y = 0
	if air then
		y = v.Y - grav() * math.clamp(age or 0, 0, sample_span() * 4)
	end
	return Vector3.new(v.X, y, v.Z)
end

local function merge_vel(fit, fit_age, fast, fast_age, engine, engine_age, air)
	local stable = phase_velocity(fit, fit_age, air)
	local instant = phase_velocity(fast, fast_age, air)
	local turn = 0
	if stable and instant then
		local sh = Vector3.new(stable.X, 0, stable.Z)
		local ih = Vector3.new(instant.X, 0, instant.Z)
		if sh.Magnitude > 1 and ih.Magnitude > 1 then
			turn = math.acos(math.clamp(sh.Unit:Dot(ih.Unit), -1, 1)) / math.pi
		end
	end
	local base = instant or stable
	if not base then return Vector3.zero, 0, nil, 0 end
	if stable and instant then
		local agility = math.clamp(turn * 2.2, 0, 1)
		base = stable:Lerp(instant, 0.4 + 0.6 * agility)
	end
	local trust = 0
	if engine then
		local live = phase_velocity(engine, engine_age, air)
		trust = vel_trust(base, live)
		if trust > 0 and air then
			base = Vector3.new(base.X, base.Y, base.Z):Lerp(Vector3.new(base.X, live.Y, base.Z), trust * 0.35)
		end
	end
	return base, turn, instant or stable, trust
end

local function vel_push(now, hx, hz)
	SK.vi = SK.vi % P.ring + 1
	SK.vt[SK.vi] = now
	SK.dx[SK.vi] = hx
	SK.dz[SK.vi] = hz
	if SK.vn < P.ring then SK.vn = SK.vn + 1 end
end

local function track_clear()
	jerk_clear()
	cal_clear()
	TR.part = nil
	TR.pos = nil
	TR.vel = Vector3.zero
	TR.gap = 0
	TR.ready = false
	TR.fresh = Vector3.zero
	TR.air = false
	TR.jumping = false
	TR.jump_v = 0
	TR.fresh_ok = false
	TR.turn = 0
	TR.spoof = 0
	TR.clr = 0
	TR.air_edge = 0
	TR.jump_fresh = false
	GC.base = 0
	GC.seen = false
	JL.v = 0
	JL.seen = false
	snap_n, snap_i = 0, 0
	SK.vn, SK.vi = 0, 0
	kin_clear()
end

local function track_seed(part, pos, now)
	jerk_clear()
	cal_clear()
	TR.part = part
	TR.pos = pos
	TR.time = now
	TR.vel = Vector3.zero
	TR.fresh = Vector3.zero
	TR.fresh_ok = false
	TR.turn = 0
	TR.jump_v = 0
	TR.gap = 0
	TR.ready = false
	TR.spoof = 0
	TR.air_edge = 0
	TR.jump_fresh = false
	GC.base = 0
	GC.seen = false
	snap_n, snap_i = 0, 0
	kin_clear()
	snap_push(now, pos)
end

local function track_fresh(now)
	local part = target_part
	if not part or not part.Parent then
		TR.fresh_ok = false
		return
	end
	local pos = part.Position
	local g = grav()
	local sv = snap_vel(0)
	local vy = sv and sv.Y or 0
	local accel = vert_accel()
	local falling = accel ~= nil and accel < -g * 0.5
	local guess = stand_clearance()
	local reach = guess + 6 + math.abs(vy) * sample_span() * 4
    local stateAir = false
    if target_hum and target_hum.Parent then
        local okState, state = pcall(function() return target_hum:GetState() end)
        if okState then
            stateAir = state == Enum.HumanoidStateType.Jumping
                or state == Enum.HumanoidStateType.Freefall
                or state == Enum.HumanoidStateType.FallingDown
                or state == Enum.HumanoidStateType.Flying
                or state == Enum.HumanoidStateType.PlatformStanding
        end
    end
	local air
	local gy = ground_below(pos, reach)
	if gy then
		local clr = pos.Y - gy
		TR.clr = clr
		if math.abs(vy) < 1 and not falling and not stateAir then
			if GC.seen then
				if clr < GC.base then
					GC.base = GC.base * 0.7 + clr * 0.3
				else
					GC.base = GC.base * 0.98 + clr * 0.02
				end
			else
				GC.base = clr
				GC.seen = true
			end
		end
		local floor = GC.seen and GC.base or guess
		local tol = math.max(floor * 0.35, 1)
		air = clr > floor + tol
		if not air and falling and math.abs(vy) > 4 and clr > floor + 0.35 then
			air = true
		end
	else
		air = true
	end
    -- Humanoid state is a stronger airborne signal than a single ground ray,
    -- especially during short hops and when the player is using a flight mover.
    if stateAir then air = true end
	if air ~= TR.air then
		TR.air_edge = now
		if air then
			TR.air_since = now
			TR.jump_fresh = true
			TR.jump_v = JL.seen and JL.v or math.max(vy, 0)
		else
			TR.jump_fresh = false
			TR.jump_v = 0
		end
	end
	local model_vy = TR.jump_v - g * math.max(0, now - TR.air_since)
	TR.air = air
	TR.jumping = air and (vy > 1 or model_vy > 1)
end

local function track(now)
	local part = target_part
	if not part or not part.Parent then
		if TR.part then track_clear() end
		return
	end
	track_fresh(now)
	local pos = part.Position
	if part ~= TR.part or not TR.pos then
		track_seed(part, pos, now)
		return
	end
	local dt = now - TR.time
	if dt > 0.75 or (pos - TR.pos).Magnitude > 140 then
		track_seed(part, pos, now)
		return
	end
	if dt <= 0 then return end
    if (pos - TR.pos).Magnitude < 0.005 then
        local quiet = math.clamp((TR.gap > 0 and TR.gap or 0.025) * 1.5, 0.035, 0.15)
        if dt >= quiet then
            TR.vel, TR.fresh = Vector3.zero, Vector3.zero
            TR.ready, TR.fresh_ok, TR.turn = false, false, 0
            kin_clear(); SK.vn, SK.vi = 0, 0
            snap_n, snap_i = 0, 0
            snap_push(now, pos)
            TR.pos, TR.time = pos, now
        end
        return
    end
    local observed = (pos - TR.pos) / dt
    local current = Vector3.new(observed.X, 0, observed.Z)
    local previous = Vector3.new(TR.fresh.X, 0, TR.fresh.Z)
    local reversal = current.Magnitude > 2 and previous.Magnitude > 2
        and current.Unit:Dot(previous.Unit) < 0.35
    local speedChange = previous.Magnitude > 2
        and math.abs(current.Magnitude - previous.Magnitude) > math.max(10, previous.Magnitude * 0.55)
    if (reversal or speedChange) and (current - previous).Magnitude > 12 then
        jerk_push(now, (current - previous).Magnitude)
    end
    if reversal or speedChange then
                                                                                           
        kin_clear(); SK.vn, SK.vi = 0, 0
        snap_n, snap_i = 0, 0
        snap_push(TR.time, TR.pos)
    end
	step_push(dt)
	TR.gap = dt
	snap_push(now, pos)
	TR.pos = pos
	TR.time = now
	local fit, fit_age = fit_velocity()
	local fast, fast_age = recent_velocity()
	local engine = engine_vel(part)
	local fresh, turn, instant, trust = merge_vel(fit, fit_age, fast, fast_age, engine, sample_span() * 0.5, TR.air)
	local kv = kin_update()
    if kv and not reversal and not speedChange then
        local fitted = Vector3.new(kv.X, 0, kv.Z)
        local live = Vector3.new(fresh.X, 0, fresh.Z)
        local aligned = fitted.Magnitude < 1 or live.Magnitude < 1 or fitted.Unit:Dot(live.Unit) > 0.65
        if aligned and (fitted - live).Magnitude < math.max(12, live.Magnitude * 0.5) then
            fresh = Vector3.new(kv.X, fresh.Y, kv.Z)
        else kin_clear() end
    end
    if reversal or speedChange then fresh = Vector3.new(observed.X, fresh.Y, observed.Z) end
	if engine and trust <= 0 then
		if TR.spoof < 20 then TR.spoof = TR.spoof + 1 end
	elseif TR.spoof > 0 then
		TR.spoof = TR.spoof - 1
	end
	if TR.air then
		local vy = air_vy()
		if vy then
			fresh = Vector3.new(fresh.X, vy, fresh.Z)
			local since = math.max(0, now - TR.air_edge)
			if TR.jump_fresh and since <= 0.2 then
				local impulse = vy + grav() * since
				if impulse > 1 then
					if JL.seen then
						JL.v = JL.v * 0.7 + impulse * 0.3
					else
						JL.v = impulse
						JL.seen = true
					end
					if impulse > TR.jump_v then TR.jump_v = impulse end
				end
			else
				TR.jump_fresh = false
			end
		end
	end
	TR.vel = fresh
	TR.ready = fit ~= nil or fast ~= nil
	TR.fresh = TR.vel
	TR.fresh_ok = TR.ready
	TR.turn = turn
	local raw = instant or fresh
	vel_push(now, raw.X, raw.Z)
	cal_push(now, pos, fresh)
end

local function raw_rtt()
	local a, b
	local ok, ms = pcall(function()
		return stats.Network.ServerStatsItem["Data Ping"]:GetValue()
	end)
	if ok and type(ms) == "number" and ms == ms and ms > 4 and ms < 800 then
		a = ms / 1000
	end
	local fine, value = pcall(function() return lp:GetNetworkPing() end)
	if fine and type(value) == "number" and value == value and value > 0 then
		local rtt = value                                                 
        if rtt > 0.004 and rtt < 0.8 then b = rtt * 2 end
	end
	if a and b then return (a + b) * 0.5 end
	return a or b
end

local ping_samples, ping_index = {}, 0
local function sample_ping()
    local rtt = raw_rtt()
    if not rtt or rtt ~= rtt then return end
    ping_index = ping_index % 5 + 1
    ping_samples[ping_index] = math.clamp(rtt, 0, 1)
    local sorted = {}
    for _, value in ipairs(ping_samples) do sorted[#sorted + 1] = value end
    table.sort(sorted)
    local median = sorted[math.ceil(#sorted * 0.5)]
    if EC.seen then
        local error = math.abs(median - EC.rtt)
        local weight = #sorted >= 3 and error > math.max(0.08, EC.rtt * 0.3) and 0.45 or 0.18
        EC.jitter = EC.jitter * 0.85 + error * 0.15
        EC.rtt = EC.rtt + (median - EC.rtt) * weight
    else EC.rtt, EC.jitter, EC.seen = median, 0, true end
    EC.ping = EC.rtt
end

local function lead_time()
    if not S.predict then return 0 end

    local stale = 0
    if TR.time > 0 and EC.step_seen then
        stale = math.clamp(os.clock() - TR.time, 0, EC.step)
    end

    local ping = V.AimPing and
        (EC.rtt * 0.5 + math.min((EC.jitter or 0) * 0.25, 0.020))
        * math.clamp(V.AimPingScale or 1, 0, 3) or 0

    local base = math.max(0, V.AimInterp or 0)
    local scale = math.clamp(V.PredictionScale or 1, 0, 3)
    local lead = (ping + stale + base) * scale

    -- Sheriff is a hitscan weapon. Large prediction windows overshoot fast
    -- strafes and are especially destructive while either player is airborne.
    -- Smart mode therefore uses a conservative hard cap; Linear mode keeps
    -- the larger user-selected window for people who explicitly want it.
    local smartCap = TR.air and 0.090 or 0.120
    do
        -- Clean fast runs / dashes may use a longer window; erratic targets a
        -- shorter one (a long window overshoots every reversal).
        local jerk = jerk_level(os.clock())
        local speed = math.sqrt(TR.vel.X * TR.vel.X + TR.vel.Z * TR.vel.Z)
        local boost = (speed > 34 and jerk < 0.25 and not TR.air) and 0.02 or 0
        smartCap = (smartCap + boost) * (1 - 0.25 * jerk)
    end
    local hardCap = V.AimPredictMode == "Linear" and 0.220 or smartCap
    if V.AimAdaptive then
        local adaptive = ADAPT_SCALES[aim.adaptIndex] or 1
        lead = lead * adaptive
    end
    return math.clamp(lead, 0, math.min(math.clamp(V.AimMaxLead or 0.45, 0, 1), hardCap))
end

local function rotate_y(v, ang)
	local c, s = math.cos(ang), math.sin(ang)
	return Vector3.new(v.X * c - v.Z * s, v.Y, v.X * s + v.Z * c)
end

local function dir_stats(win)
	if SK.vn < 4 then return 1, 0 end
	win = math.max(win, sample_span() * 3)
	local newest = SK.vt[SK.vi]
	local sx, sz, n = 0, 0, 0
	local prev = nil
	local turn, turn_n = 0, 0
	local oldest = newest
	for k = 0, SK.vn - 1 do
		local idx = (SK.vi - k - 1) % P.ring + 1
		local t = SK.vt[idx]
		if newest - t > win then break end
		local hx, hz = SK.dx[idx], SK.dz[idx]
		local m = math.sqrt(hx * hx + hz * hz)
		if m > 0 then
			sx = sx + hx / m
			sz = sz + hz / m
			n = n + 1
			local ang = math.atan2(hz, hx)
			if prev then
				local d = ang - prev
				while d > math.pi do d = d - 6.2831853 end
				while d < -math.pi do d = d + 6.2831853 end
				turn = turn + d
				turn_n = turn_n + 1
			end
			prev = ang
			oldest = t
		end
	end
	if n < 2 then return 1, 0 end
	local coh = math.clamp(math.sqrt(sx * sx + sz * sz) / n, 0, 1)
	local omega = 0
	local elapsed = newest - oldest
	if turn_n >= 1 and elapsed > 1e-3 then
		omega = -turn / elapsed
	end
	return coh, omega
end

local function clip_prediction(base, point)
    local horizontal = Vector3.new(point.X - base.X, 0, point.Z - base.Z)
    local y = point.Y
    table.clear(ground_filter)
    if target_char then ground_filter[#ground_filter + 1] = target_char end
    if lp.Character then ground_filter[#ground_filter + 1] = lp.Character end
    ground_params.FilterDescendantsInstances = ground_filter
    if horizontal.Magnitude > 0.05 then
        local hit = workspace:Raycast(base, horizontal, ground_params)
        if hit and type(hit.Distance) == "number" and hit.Distance == hit.Distance then
            horizontal = horizontal.Unit * math.clamp(hit.Distance - 0.15, 0, horizontal.Magnitude)
        end
    end
    if y - base.Y > 0.05 then
        local head = target_char and target_char:FindFirstChild("Head")
        local top = head and head.Position + Vector3.new(0, head.Size.Y * 0.5, 0) or base
        local hit = workspace:Raycast(top + horizontal, Vector3.new(0, y - base.Y, 0), ground_params)
        if hit and type(hit.Distance) == "number" and hit.Distance == hit.Distance then
            y = base.Y + math.clamp(hit.Distance - 0.15, 0, y - base.Y)
        end
    end
    return Vector3.new(base.X + horizontal.X, y, base.Z + horizontal.Z)
end

local function predict_from(base, sa, sb, fh, now)
    local span = math.clamp(math.max(0, sa + sb), 0, 0.30)
    if span <= 0 then return base end
    -- Scale the window by how well "keeps its velocity" has predicted this
    -- target lately (calibrator), and cut it further right after sharp events.
    cal_update(now, span)
    local jerk = jerk_level(now)
    local scale = 1
    if CAL.valid and V.AimCalibrate ~= false then scale = math.clamp(CAL.k, 0.55, 1.1) end
    if jerk > 0.05 then scale = math.min(scale, 1 - 0.35 * jerk) end
    span = span * scale

    local direct = engine_vel(target_part)
    local observed = (TR.fresh_ok and TR.fresh) or (TR.ready and TR.vel) or nil
    local velocity
    if direct and observed then
        -- Blend consistent observations; reject misleading engine velocity.
        local em = Vector3.new(direct.X, 0, direct.Z).Magnitude
        local om = Vector3.new(observed.X, 0, observed.Z).Magnitude
        local disagreement = (Vector3.new(direct.X, 0, direct.Z) - Vector3.new(observed.X, 0, observed.Z)).Magnitude
        local bogus = (em < 1.5 and om > 8) or (em > 25 and em > math.max(om * 2.5, 40))
        local reversal = em > 3 and om > 3 and (direct.X * observed.X + direct.Z * observed.Z) < 0
        local weight = bogus and 0 or reversal and 0.9
            or math.clamp(0.65 - disagreement / math.max(40, em + om), 0.2, 0.65)
        velocity = observed:Lerp(direct, weight)
        -- The vertical component is not smoothed across jump transitions.
        if TR.air and not bogus then velocity = Vector3.new(velocity.X, direct.Y, velocity.Z) end
    else
        velocity = direct or observed or TR.vel or fh or Vector3.zero
    end
    if not Geo.vectorFinite(velocity) then velocity = Vector3.zero end
    if velocity.Magnitude > AIM_MAX_TRACK_SPEED then
        velocity = velocity.Unit * AIM_MAX_TRACK_SPEED
    end

    local mode = V.AimPredictMode
    local horizontal = Vector3.new(velocity.X, 0, velocity.Z)
    local x = base.X + horizontal.X * span
    local z = base.Z + horizontal.Z * span

    -- Only use fitted acceleration on grounded targets. Airborne movement is
    -- frequently quantized by the humanoid controller, so extrapolating a noisy
    -- acceleration curve is worse than the live assembly velocity.
    if mode ~= "Linear" and not TR.air and KIN.ok then
        local age = math.clamp(now - TR.time, 0, sample_span() * 2)
        local ax, az = KIN.ax, KIN.az
        local am = math.sqrt(ax * ax + az * az)
        if am >= P.acc_min then
            local ta = math.min(span, P.acc_t)
            local correction = Vector3.new(ax, 0, az) * (age * span + 0.5 * ta * ta)
            local confidence = math.clamp(1 - jerk, 0, 1)
            if CAL.valid then confidence = confidence / (1 + math.max(0, CAL.err)) end
            correction = correction * confidence
            local limit = math.max(0.15, horizontal.Magnitude * span * 0.25)
            if correction.Magnitude > limit then correction = correction.Unit * limit end
            x, z = x + correction.X, z + correction.Z
        end
    end

    local y = base.Y
    if TR.air then
        local vy = velocity.Y
        local applyGravity = V.AimGravity ~= false
        if applyGravity and target_hum and target_hum.Parent then
            local okState, state = pcall(function() return target_hum:GetState() end)
            -- Flight/PlatformStanding usually has a mover supplying vertical
            -- velocity, so applying workspace gravity there double-corrects it.
            if okState and (state == Enum.HumanoidStateType.Flying
                or state == Enum.HumanoidStateType.PlatformStanding) then
                applyGravity = false
            end
        end
        if applyGravity then
            y = base.Y + vy * span - 0.5 * grav() * span * span
        else
            y = base.Y + vy * span
        end
    end

    local predicted = Vector3.new(x, y, z)
    -- Keep the existing geometry guard, but never replace a valid airborne
    -- prediction with a ground position.
    if TR.air then
        return predicted
    end
    return clip_prediction(base, predicted)
end


local function build_hyps(base, now)
	table.clear(HY.pos)
	table.clear(HY.w)
	local horizon = S.predict and TR.ready and lead_time() or 0
	if TR.turn and TR.turn > 0.55 then horizon = horizon * 0.65 end
	local fh = Vector3.new(TR.fresh.X, 0, TR.fresh.Z)
	local primary = predict_from(base, 0, horizon, fh, now)
	HY.primary = primary
	HY.n, HY.weight = 0, 0
	local function add(position, weight)
		HY.n = HY.n + 1
		HY.pos[HY.n] = position
		HY.w[HY.n] = weight
		HY.weight = HY.weight + weight
	end
	add(primary, 1)
	if horizon > 0 and TR.ready then
		-- The ray has to catch the target wherever it really is on the server:
		-- where it is seen now (replication lag), further along (ping spike or a
		-- late shot) and slightly behind (a reversal).  All of them lie on the
		-- movement axis, so one corridor covers the whole range.
		add(base, 0.6)
		add(predict_from(base, 0, horizon * 1.6, fh, now), 0.5)
		add(base:Lerp(primary, 0.5), 0.4)
		add(base - (primary - base) * 0.35, 0.35 + 0.3 * jerk_level(now))
	end
	HY.stamp = now
end

local function score_axis(anchor, axis)
	local covered = 0
	local lo, hi = 0, 0
	for k = 1, HY.n do
		local d = HY.pos[k] - anchor
		local a = d:Dot(axis)
		local perp = (d - axis * a).Magnitude
		if perp <= P.hit_r then
			covered = covered + HY.w[k]
			if a < lo then lo = a end
			if a > hi then hi = a end
		end
	end
	return covered, lo, hi
end

local function corridor_axes(anchor)
	table.clear(axis_pool)
	local n = 0
	local function add(v)
		if typeof(v) ~= "Vector3" or v.Magnitude < 1e-4 then return end
		local u = v.Unit
		for k = 1, n do
			if axis_pool[k]:Dot(u) > 0.985 then return end
		end
		n = n + 1
		axis_pool[n] = u
	end
	-- Priority order: the target's own motion first (the corridor then covers
	-- every hypothesis), then our line of sight, then a ring around the target.
	-- A standing target has no motion axis; the old code fell back to a single
	-- vertical axis, which starts underground.  Both signs of every axis are
	-- candidates so the shot can come from whichever side is clear.
	local fh = Vector3.new(TR.fresh.X, 0, TR.fresh.Z)
	if TR.air then add(TR.fresh); add(-TR.fresh) end
	add(fh); add(-fh)
	for k = 1, HY.n do
		local d = HY.pos[k] - anchor
		add(d); add(-d)
	end
	add(TR.fresh); add(-TR.fresh)
	local mine = origin_cframe()
	if mine then
		local d = anchor - mine.Position
		add(d)
		local flat = Vector3.new(d.X, 0, d.Z)
		add(flat); add(-flat)
	end
	for k = 0, 11 do
		local angle = k * math.pi / 6
		add(Vector3.new(math.cos(angle), 0, math.sin(angle)))
	end
	for k = 0, 7 do
		local angle = k * math.pi / 4
		local c, sn = math.cos(angle), math.sin(angle)
		add(Vector3.new(c * 0.8, -0.6, sn * 0.8))
		add(Vector3.new(c * 0.8, 0.6, sn * 0.8))
	end
	add(Vector3.new(0, -1, 0)); add(Vector3.new(0, 1, 0))
	return n
end

local function build_corridor(now)
	local part = target_part
	if not part or not part.Parent then return nil end
	local base = part.Position
	build_hyps(base, now)
	local anchor = HY.primary or base
	local count = corridor_axes(anchor)
	local best_axis, best_cov, best_lo, best_hi = nil, -1, 0, 0
	for k = 1, count do
		local axis = axis_pool[k]
		local cov, lo, hi = score_axis(anchor, axis)
		if cov > best_cov then
			best_axis, best_cov, best_lo, best_hi = axis, cov, lo, hi
		end
	end
	if not best_axis then return nil end
	HY.conf = HY.weight > 0 and best_cov / HY.weight or 0

	local pad = P.pad
	local origin = anchor + best_axis * (best_lo - pad)
	local aim = anchor + best_axis * (best_hi + pad)
	if (aim - origin).Magnitude < 4 then
		origin = anchor - best_axis * 4
		aim = anchor + best_axis * 4
	end
	return origin, aim, HY.conf, anchor
end

local pred_off = Vector3.zero
local pred_stamp = 0

local function lead_offset()
	local part = target_part
	if not part or not part.Parent then return Vector3.zero end
	if not S.predict or not TR.ready then return Vector3.zero end
	local base = part.Position
	local now = os.clock()
	local fh = Vector3.new(TR.fresh.X, 0, TR.fresh.Z)
    local horizon = lead_time()
    if TR.turn and TR.turn > 0.55 then horizon = horizon * 0.65 end
	local point = predict_from(base, 0, horizon, fh, now)
	local off = point - base
	pred_stamp = now
	pred_off = off
	return pred_off
end

local function cloud_confidence()
	local anchor = HY.primary
	if not anchor or HY.n == 0 or HY.weight <= 0 then return 0 end
	local covered = 0
	for k = 1, HY.n do
		if (HY.pos[k] - anchor).Magnitude <= P.hit_r then
			covered = covered + HY.w[k]
		end
	end
	return covered / HY.weight
end
local hit_names = {
	"HumanoidRootPart", "UpperTorso", "Torso", "LowerTorso", "Head",
	"RightUpperArm", "LeftUpperArm", "Right Arm", "Left Arm",
	"RightUpperLeg", "LeftUpperLeg", "Right Leg", "Left Leg",
	"RightLowerLeg", "LeftLowerLeg",
}

local hit_parts = {}
local hit_count = 0
local hit_char = nil
local hit_mode = nil
local hit_refresh = 0

local function refresh_parts()
	local char = target_char
	if char == hit_char and hit_mode == V.AimPart and hit_count > 0 and os.clock() < hit_refresh then return end
    hit_refresh = os.clock() + 0.5
    hit_mode = V.AimPart
	table.clear(hit_parts)
	hit_count = 0
	hit_char = char
	if not char then return end
	local names = AIM_PARTS[V.AimPart] or hit_names
    if V.AimPart == "Auto" then names = AIM_PARTS.Auto or hit_names end
    for k = 1, #names do
		local part = char:FindFirstChild(names[k])
		if part and part:IsA("BasePart") then
			hit_count = hit_count + 1
			hit_parts[hit_count] = part
		end
	end
end

local function los_clear(origin, point)
	if not origin or not point then return false end
	local delta = point - origin
	local dist = delta.Magnitude
	if dist < 0.5 then return true end
	if dist > MAX_RANGE then return false end
	local hit = trace(origin, delta)
	if not hit then return true end
	local inst = hit.Instance
	local char = target_char
	if inst and char and (inst == char or inst:IsDescendantOf(char)) then return true end
	return (hit.Position - origin).Magnitude >= dist - 0.75
end

local selected_part
local point_offsets = {Vector3.zero, Vector3.new(0.28,0,0), Vector3.new(-0.28,0,0),
    Vector3.new(0,0.28,0), Vector3.new(0,-0.28,0), Vector3.new(0,0,0.28), Vector3.new(0,0,-0.28)}
local function pick_point(origin, strict)
    refresh_parts()
    if hit_count == 0 then selected_part = nil; return nil end
    local off = lead_offset()
    if not Geo.vectorFinite(off) then selected_part = nil; return nil end
    local candidates = {}
    local count = V.AimMultipoint ~= false and #point_offsets or 1
    local camera = workspace.CurrentCamera
    local size = Overlay.AbsoluteSize
    if size.X <= 0 or size.Y <= 0 then size = camera and camera.ViewportSize or Vector2.new(1, 1) end
    local center = size * 0.5
    local radius = math.max(1, V.AimFovRadius or 300)
    local uncertainty = math.clamp(jerk_level(os.clock()) + (CAL.valid and CAL.err / 4 or 0), 0, 1)
    local automatic = V.AimPart == "Auto" or V.AimPart == "Closest"
    for k = 1, hit_count do
        local part = hit_parts[k]
        if part and part.Parent then
            local area = math.max(part.Size.X * part.Size.Y, 0.1)
            for j = 1, count do
                local point = part.CFrame:PointToWorldSpace(point_offsets[j] * part.Size) + off
                local distance = origin and (point - origin).Magnitude or 0
                local projected, _, depth = viewPoint(point)
                local pixels = projected and depth and depth > 0 and (projected - center).Magnitude or math.huge
                if Geo.vectorFinite(point) and distance <= MAX_RANGE and (not V.AimFov or pixels <= radius) then
                    local screen = pixels < math.huge and pixels / radius or 4
                    local score = (automatic and screen or k * 0.1) + distance / math.max(MAX_RANGE, 1) * 0.05
                        + (j == 1 and 0 or 0.06) + (automatic and uncertainty * 0.25 / math.sqrt(area) or 0)
                    -- Retain a valid part when improvements are only marginal.
                    if part == selected_part then score = score - 0.08 end
                    candidates[#candidates + 1] = {part=part, point=point, score=score, order=k*count+j}
                end
            end
        end
    end
    table.sort(candidates, function(a,b)
        if a.score == b.score then return a.order < b.order end
        return a.score < b.score
    end)
    for i = 1, math.min(#candidates, 32) do
        local candidate = candidates[i]
        if not origin or los_clear(origin, candidate.point) then
            selected_part = candidate.part
            return candidate.point
        end
    end
    if not strict and candidates[1] then
        selected_part = candidates[1].part
        return candidates[1].point
    end
    selected_part = nil
    return nil
end

local force_att = nil
local force_saved = nil
local force_stamp = 0

local function restore_origin()
	local att = force_att
	if not att then return end
	local saved = force_saved
	force_att = nil
	force_saved = nil
	if saved then
		pcall(function()
			if att.Parent then att.CFrame = saved end
		end)
	end
end

local function push_origin(cf)
	local att = gun_attachment()
	if not att then return false end
    resolved_origin = cf
    if previewing then return true end
	if force_att and force_att ~= att then restore_origin() end
	if not force_att then
		local ok, saved = pcall(function() return att.CFrame end)
		if not ok or typeof(saved) ~= "CFrame" then return false end
		force_att = att
		force_saved = saved
	end
	force_stamp = os.clock()
	local ok = pcall(function() att.WorldCFrame = cf end)
	if not ok then
		restore_origin()
		return false
	end
	task.defer(restore_origin)
	return true
end

local function is_target_hit(inst)
	local char = target_char
	if not inst or not char then return false end
	return inst == char or inst:IsDescendantOf(char)
end

local function force_clear(origin, aim)
	local hit = trace(origin, aim - origin)
	if not hit then return false end
	return is_target_hit(hit.Instance)
end

local function force_velocity()
	if TR.fresh_ok and TR.fresh.Magnitude > 0.5 then return TR.fresh end
	if TR.ready and TR.vel.Magnitude > 0.5 then return TR.vel end
	return Vector3.zero
end

local plan_cache = {t = 0, origin = nil, aim = nil, conf = 0, anchor = nil, axis = nil}

-- Picks the shot line.  Candidate axes are ranked by how much of the target's
-- possible motion they cover; the first one that also has a clear path from the
-- spoofed origin to the target wins, so a blocked axis is never chosen.
local function force_plan(now, allowCache)
	local part = target_part
	if not part or not part.Parent then return nil end
	if allowCache and plan_cache.origin and now - plan_cache.t < 0.05 then
		return plan_cache.origin, plan_cache.aim, plan_cache.conf, plan_cache.anchor
	end
	local live = part.Position
	build_hyps(live, now)
	local anchor = HY.primary or live
	local count = corridor_axes(anchor)
	local scored = {}
	for k = 1, count do
		local axis = axis_pool[k]
		local cov, lo, hi = score_axis(anchor, axis)
		local rank = k
		if plan_cache.axis and plan_cache.axis:Dot(axis) > 0.985 then rank = 0 end
		scored[k] = {axis = axis, cov = cov, lo = lo, hi = hi, rank = rank}
	end
	table.sort(scored, function(a, b)
		if math.abs(a.cov - b.cov) > 1e-6 then return a.cov > b.cov end
		return a.rank < b.rank
	end)
	local steps = {}
	local distance = S.stand_off
	while distance > 0 do
		steps[#steps + 1] = distance
		distance = distance - 3
	end
	steps[#steps + 1] = 0
	local needLive = (live - anchor).Magnitude >= 1
	local budget = 56
	local function clear(from, to)
		if budget <= 0 then return false end
		budget = budget - 1
		return los_clear(from, to)
	end
	for tried = 1, math.min(#scored, 8) do
		local c = scored[tried]
		local u = c.axis
		local start = anchor + u * (c.lo - P.pad)
		local aim = anchor + u * (c.hi + P.pad)
		for _, want in ipairs(steps) do
			local probe = start - u * want
			if (aim - probe).Magnitude <= P.max_span and clear(probe, anchor)
				and (not needLive or clear(probe, live)) then
				local conf = c.cov / math.max(HY.weight, 1e-6)
				plan_cache.t, plan_cache.origin, plan_cache.aim = now, CFrame.new(probe, aim), CFrame.new(aim)
				plan_cache.conf, plan_cache.anchor, plan_cache.axis = conf, anchor, u
				return plan_cache.origin, plan_cache.aim, conf, anchor
			end
		end
	end
	plan_cache.origin = nil
	return nil
end

local function resolve_force()
	local part = target_part
	if not part or not part.Parent then return nil end
	local live = part.Position
	local now = os.clock()

	local origin_cf, aim_cf, conf, anchor = force_plan(now, previewing)
	if origin_cf then return origin_cf, aim_cf, conf or 0, anchor end

	local vel = force_velocity()
	local dir = Vector3.new(0, -1, 0)
	if vel.Magnitude > 3 then
		dir = vel.Unit
	else
		local mine = origin_cframe()
		if mine then
			local delta = live - mine.Position
			if delta.Magnitude > 2 then dir = delta.Unit end
		end
	end
	local back = live - dir * 6
	local front = live + dir * math.max(P.min_span, vel.Magnitude * lead_time() + 8)
	if not force_clear(back, front) then
		back = live - dir * 2.5
	end
	return CFrame.new(back, front), CFrame.new(front), 0, live
end

local function shot_shift(dt)
	if not S.predict or not TR.ready or dt <= 0 then return Vector3.zero end
	local shift = Vector3.new(TR.vel.X * dt, 0, TR.vel.Z * dt)
	if TR.air then
		local g = grav()
		local horizon = lead_time()
		local vy = TR.vel.Y
		local phase = math.max(0, os.clock() - TR.air_since)
		local modeled = TR.jump_v - g * phase
		if TR.jumping and TR.jump_v > 0 and g > 0 and phase <= TR.jump_v / g and modeled > vy then vy = modeled end
		shift = Vector3.new(shift.X, vy * dt - g * horizon * dt - 0.5 * g * dt * dt, shift.Z)
	end
	return shift
end

local function compensate_force(origin_cf, aim_cf, started)
	local shift = shot_shift(math.max(0, os.clock() - started))
	if shift == Vector3.zero then return origin_cf, aim_cf end
	local origin = origin_cf.Position + shift
	local aim = aim_cf.Position + shift
	return CFrame.new(origin, aim), CFrame.new(aim)
end

-- The server places our shot origin from the replicated character, which lags
-- the client by a few milliseconds.  While we dash that offset is several
-- studs, so the aim point is shifted by our own velocity over that lag.
local function self_comp()
	local lag = tonumber(V.AimSelfComp) or 0
	if lag <= 0 then return Vector3.zero end
	local char = lp.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return Vector3.zero end
	local v = engine_vel(hrp)
	if not v then return Vector3.zero end
	local speed = v.Magnitude
	if speed < 22 then return Vector3.zero end
	local shift = v * math.clamp(lag, 0, 0.08) * math.clamp((speed - 22) / 24, 0, 1)
	if shift.Magnitude > 3 then shift = shift.Unit * 3 end
	return shift
end

local function resolve_shot()
	if not S.enabled or not S.am_sheriff or not target_alive() then return nil end
	if S.force then
		local started = os.clock()
		local origin_cf, aim_cf = resolve_force()
		if origin_cf and aim_cf then
			origin_cf, aim_cf = compensate_force(origin_cf, aim_cf, started)
			if push_origin(origin_cf) then return aim_cf end
		end
	end
	local cf = origin_cframe()
	local aim = pick_point(cf and cf.Position or nil, V.AimWallCheck == true)
	if not aim then return nil end
	return CFrame.new(aim + self_comp())
end

local function compensate_resolve(cf)
	if S.force or typeof(cf) ~= "CFrame" then return cf end
	return CFrame.new(cf.Position + shot_shift(math.max(0, os.clock() - pred_stamp)))
end

local api = {Destroyed = false, State = S, Origin = "shitaro full work.txt"}
local nextRole, nextPing = 0, 0
local function sync(forCombat)
    S.enabled = not api.Destroyed and not V.Destroying and not V.Destroyed
        and (V.SilentAim or V.WallShoot or (forCombat and (V.AutoShoot or V.ForceShoot or forCombat == "Manual")))
    S.predict = V.AimPrediction ~= false
    S.force = V.WallShoot == true and V.AimTeleport ~= true
    S.stand_off = math.clamp(V.AimOriginRadius or 15, 0, 40)
    MAX_RANGE = math.clamp(V.AimRange or 1000000, 1, 1000000)
end
function api:Tick(now, forCombat)
    sync(forCombat)
    if not S.enabled then restore_origin(); return end
    if now >= nextRole or not target_alive() or (target_player and target_player.Character ~= target_char) then
        nextRole = now + 0.04
        refresh_target()
    end
    if now >= nextPing then nextPing = now + 0.10; sample_ping() end
    track(now)
    if force_att and now - force_stamp > 0.05 then restore_origin() end
end
function api:Resolve(forCombat, preview)
    self:Tick(os.clock(), forCombat)
    if not S.enabled then return nil end
    previewing, resolved_origin = preview == true, nil
    local success, cf = pcall(resolve_shot)
    previewing = false
    -- Never recycle a point from a previous solve after occlusion/respawn.
    if not success then
        V.LastSilentError = tostring(cf)
        restore_origin()
        return nil
    end
    if typeof(cf) ~= "CFrame" then restore_origin(); return nil end
    cf = compensate_resolve(cf)
                                                                                       
    if V.AimFov then
        local point, _, depth = viewPoint(cf.Position)
        local size = Overlay.AbsoluteSize
        if size.X <= 0 or size.Y <= 0 then size = Workspace.CurrentCamera.ViewportSize end
        if not point or not depth or depth <= 0 or
            (point - Vector2.new(size.X * 0.5, size.Y * 0.5)).Magnitude > (V.AimFovRadius or 300) then
            restore_origin(); return nil
        end
    end
    local part = (S.force and target_part) or selected_part or target_part
    local origin = resolved_origin or origin_cframe()
    if not origin or not part or not part:IsDescendantOf(target_char) or not Geo.vectorFinite(cf.Position)
        or (cf.Position - origin.Position).Magnitude > MAX_RANGE then
        restore_origin(); return nil
    end
    -- Compensation may shift a valid point behind cover: validate final output.
    if not S.force and V.AimWallCheck and not los_clear(origin.Position, cf.Position) then
        restore_origin(); return nil
    end
    return cf, origin, target_player, part, target_char, TR
end
function api:LeadTime() return lead_time() end
function api:Reset()
    restore_origin(); track_clear(); hit_char = nil; hit_refresh = 0
    plan_cache.origin, plan_cache.axis, plan_cache.anchor = nil, nil, nil
    table.clear(HY.pos); table.clear(HY.w); HY.n, HY.weight, HY.primary = 0, 0, nil
    table.clear(hit_parts); hit_count = 0; selected_part = nil
    table.clear(ignore_base); table.clear(ignore_work); table.clear(ground_filter)
    ray_params.FilterDescendantsInstances = {}
    ground_params.FilterDescendantsInstances = {}
    target_player, target_char, target_part, target_hum = nil, nil, nil, nil
    nextRole = 0
end
function api:Destroy()
    if self.Destroyed then return end
    self.Destroyed = true
    S.enabled, S.force = false, false
    self:Reset()
end
function api:GetDiagnostics()
    return {Source = self.Origin, Target = target_player and target_player.Name or "none",
        RTT = EC.rtt, Jitter = EC.jitter, Lead = lead_time(), Ready = TR.ready,
        Velocity = TR.fresh, Airborne = TR.air, Spoof = force_att ~= nil}
end
return api
end)()
V.AimSource = ShitaroAim.Origin
V.GetAimDiagnostics = function()
    local report = ShitaroAim:GetDiagnostics()
    report.Mode, report.Queries = V.AimHookMode, V.SilentQueriesResolved or 0
    report.Error = V.LastAimHookError
    return report
end

                                                                                
local function installNamecallHook()
    if namecallInstalled or not V.MurderKnifeSilent or V.AimNamecall == false then return end
    if type(hookmetamethod) ~= "function" or type(getnamecallmethod) ~= "function" then return end
    local wrap = type(newcclosure) == "function" and newcclosure or function(fn) return fn end
    local original
    local ok = pcall(function()
        original = hookmetamethod(game, "__namecall", wrap(function(remote, ...)
            local got, method = pcall(getnamecallmethod)
            if not got or method ~= "FireServer" or not aimHookLive or not V.MurderKnifeSilent
                or V.Destroying or V.Destroyed or typeof(remote) ~= "Instance" or remote.ClassName ~= "RemoteEvent" then
                return original(remote, ...)
            end
            local name = string.lower(remote.Name)
            if name ~= "throw" and name ~= "throwknife" and name ~= "throwingknife" then return original(remote, ...) end
            local fire, inputs = remote.FireServer, table.pack(...)
            local success, args = pcall(function()
                if type(checkcaller) == "function" and checkcaller() then return nil end
                local knife = findKnife and findKnife()
                if not knife or not remote:IsDescendantOf(knife) then return nil end
                local cf = knifeAimCFrame and knifeAimCFrame()
                if typeof(cf) ~= "CFrame" then return nil end
                local t1,t2=typeof(inputs[1]),typeof(inputs[2])
                local index
                if (t1=="CFrame" or t1=="Vector3") and (t2=="CFrame" or t2=="Vector3") then index=2
                elseif inputs.n==1 and (t1=="CFrame" or t1=="Vector3") then index=1 end
                if not index then return nil end
                local values=table.pack(table.unpack(inputs,1,inputs.n))
                values[index]=typeof(inputs[index])=="Vector3" and cf.Position or cf
                return values
            end)
            if not success then V.LastKnifeAimError = tostring(args) end
            local values = success and args or inputs
            return fire(remote,table.unpack(values,1,values.n))
        end))
    end)
    if ok and type(original)=="function" then namecallInstalled=true end
end

local resolvingAimTarget = false
local function safeTargetCFrame()
    if resolvingAimTarget or not aimHookLive or V.Destroying or V.Destroyed then return nil end
    resolvingAimTarget = true
    local ok, cf = pcall(function()
                                                                                
                                                  
        local result = ShitaroAim:Resolve()
        if typeof(result) == "CFrame" then return result end
        if V.MurderKnifeSilent and knifeAimCFrame then return knifeAimCFrame() end
        return nil
    end)
    resolvingAimTarget = false
    if ok then return cf end
    V.LastAimHookError = tostring(cf)
    return nil
end

local function installAimHooks()
    if V.Destroying or V.Destroyed then return false end
    aimHookLive = true
    installNamecallHook()
    local service = getWeaponService()
    if not service then V.AimHookMode = "Unavailable" return false end
    pcall(function() if setreadonly then setreadonly(service,false) end end)
    local function redirect(original, ...)
                                                                                   
                                                                              
        local cf = safeTargetCFrame()
        if typeof(cf) == "CFrame" then
            V.SilentQueriesResolved = (V.SilentQueriesResolved or 0)+1
            return cf
        end
        return original(...)
    end
    local ok, err = pcall(function()
        if not HookedMouseTarget and type(service.GetMouseTargetCFrame)=="function" then
            OriginalMouseTarget=service.GetMouseTargetCFrame
            HookedMouseTarget=function(...) return redirect(OriginalMouseTarget,...) end
        end
        if not HookedScreenTarget and type(service.GetTargetPosition)=="function" then
            OriginalScreenTarget=service.GetTargetPosition
            HookedScreenTarget=function(...) return redirect(OriginalScreenTarget,...) end
        end
        if HookedMouseTarget then service.GetMouseTargetCFrame=HookedMouseTarget end
        if HookedScreenTarget then service.GetTargetPosition=HookedScreenTarget end
    end)
    if not ok then V.LastAimHookError=tostring(err) end
    V.AimHookMode=ok and (HookedMouseTarget or HookedScreenTarget) and "ShitaroService" or "Unavailable"
    return V.AimHookMode=="ShitaroService"
end


findTool = function(name)
	local ch = LocalPlayer.Character
	local tool = ch and ch:FindFirstChild(name)
	if tool and tool:IsA("Tool") then
		return tool, true
	end
	local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
	tool = backpack and backpack:FindFirstChild(name)
	if tool and tool:IsA("Tool") then
		return tool, false
	end
end

local function equipTool(tool)
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if hum and tool then
		pcall(function()
			hum:EquipTool(tool)
		end)
	end
end

local shootRemoteCache = setmetatable({}, {__mode = "k"})
local function findShootRemote(gun)
	if not gun then return nil end
	local cached = shootRemoteCache[gun]
	if cached and cached.Parent and cached:IsDescendantOf(gun) then return cached end
	local best
	for _, object in ipairs(gun:GetDescendants()) do
		if object:IsA("RemoteEvent") then
			local name = string.lower(object.Name)
			if name == "shoot" then best = object; break end
			if not best and (name == "fire" or name == "shootgun" or name == "activate") then best = object end
		end
	end
	shootRemoteCache[gun] = best
	return best
end

local function fireGun(gun, origin, point)
	if not gun or gun.Parent~=LocalPlayer.Character or gun.Enabled==false then return false end
	local remote = findShootRemote(gun)
	if not remote or typeof(origin) ~= "CFrame" or not Geo.vectorFinite(point) then return false end
    local targetFrame = CFrame.new(point)
    if not targetFrame then return false end
	local previous=internalGunShot;internalGunShot=true
    local ok = pcall(function() remote:FireServer(origin, targetFrame) end)
    internalGunShot=previous
	return ok
end

local function findTeleportSpot(point, character, rel)
	local localCharacter = LocalPlayer.Character
	local lroot = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")
	if not lroot then
		return nil
	end
	local hum = localCharacter:FindFirstChildOfClass("Humanoid")
	local heightOffset = (hum and hum.HipHeight > 0) and (hum.HipHeight + lroot.Size.Y * 0.5) or 3

	local overlap = OverlapParams.new()
	overlap.FilterType = Enum.RaycastFilterType.Exclude
	overlap.RespectCanCollide = true
	overlap.FilterDescendantsInstances = { localCharacter, character }

	if rayFilterChar ~= localCharacter then
		rayFilterChar = localCharacter
		rayParams.FilterDescendantsInstances = { localCharacter }
	end

	floorRayParams.FilterDescendantsInstances = {localCharacter,character}
	local best, bestScore
	local from = lroot.Position
	for _, radius in ipairs({ 6, 9, 13, 18 }) do
		for step = 0, 11 do
			local angle = step * math.pi / 6
			local above = Vector3.new(point.X + math.cos(angle) * radius, point.Y + 4, point.Z + math.sin(angle) * radius)
			local floor = Workspace:Raycast(above,Vector3.new(0,-40,0),floorRayParams)
			if floor then
				local position = floor.Position + Vector3.new(0, heightOffset, 0)
				local destination = CFrame.new(position, Vector3.new(point.X, position.Y, point.Z))
				local originPosition = (destination * rel).Position
				if clearShot(originPosition, point, character)
					and #Workspace:GetPartBoundsInBox(destination, Vector3.new(2.5, 4.5, 2.5), overlap) == 0
				then
					local score = (position - from).Magnitude
					if not best or score < bestScore then
						best, bestScore = destination, score
					end
				end
			end
		end
		if best then
			break
		end
	end
	return best
end

V.FindTeleportSpot=findTeleportSpot

local function autoTeleportNeeded(target,manual)
    if not manual and not V.AutoShoot then return false end
    local root=aliveRoot(LocalPlayer)
    local targetRoot=target and aliveRoot(target)
    if not root or not targetRoot or not Geo.vectorFinite(root.Position) or not Geo.vectorFinite(targetRoot.Position) then return false end
    local threshold=math.clamp(V.AutoShootTeleportDistance or 300,1,25000)
    return (targetRoot.Position-root.Position).Magnitude*0.28>threshold
end

                                                                                
local function estimateHitChance(origin,point,frame,size,tr,now)
    if not origin or not Geo.vectorFinite(point) or not frame or not size then return 0 end
    local delta=point-origin.Position
    local distance=delta.Magnitude
    if distance<0.001 then return 100 end
    local confidence=math.clamp(tr and tr.confidence or 0,0,1)
    local speed=tr and tr.vel and tr.vel.Magnitude or 0
    local acceleration=tr and tr.acc and tr.acc.Magnitude or 0
    local jitter=math.clamp(rttCache.jitter or 0,0,0.15)
    local horizon=math.clamp(leadTime(now),0,0.65)
    local sigma=math.clamp(0.03+(1-confidence)*speed*horizon+speed*(0.008+jitter)+acceleration*horizon*horizon*0.5,0.03,12)
    local spread=distance*math.tan(math.rad(math.clamp(V.HitChanceSpread or 0,0,5)))
    local basis=CFrame.lookAt(origin.Position,point)
    local right,up=basis.RightVector,basis.UpVector
    local hits=0
    for i=1,64 do
        local angle=i*2.399963229728653
        local gaussian=math.sqrt(-2*math.log((i-0.5)/64))
        local uncertainty=(right*math.cos(angle)+up*math.sin(angle))*gaussian*sigma
        local spreadAngle=angle+1.570796326794897
        local spreadRadius=spread*math.sqrt((i-0.5)/64)
        local endpoint=point+(right*math.cos(spreadAngle)+up*math.sin(spreadAngle))*spreadRadius
        local ray=endpoint-origin.Position
        if ray.Magnitude>0.001 and Geo.rayBox(origin.Position,ray.Unit,frame+uncertainty,size,distance+size.Magnitude+sigma*4) then hits=hits+1 end
    end
    return hits*100/64
end
local function hitChanceAllowed(origin,point,frame,size,tr,now)
    V.HitChanceBypassed=V.ForceShoot==true
    if V.HitChanceBypassed then return true end
    local threshold=math.clamp(tonumber(V.HitChance) or 50,0,100)
    if threshold==0 then return true end
    local chance=estimateHitChance(origin,point,frame,size,tr,now)
    V.LastHitChance=chance
    return chance+0.000001>=threshold
end

teleportShot = function(mode)
    local manual=mode=="Manual"
    local automatic=mode=="Auto" or manual
    local enabled=manual or (automatic and V.AutoShoot) or (not automatic and V.WallShoot and V.AimTeleport)
	if V.Destroying or V.Destroyed or not enabled or not holdsGunRole(os.clock())
		or (not manual and os.clock() < (aim.manualUntil or 0))
		or teleporting or os.clock() - lastTeleport < 0.8 then
		return false
	end

	local character = LocalPlayer.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	local target = aim.target
	local targetCharacter = target and target.Character
	local targetRoot=target and aliveRoot(target)
    local point=automatic and targetRoot and targetRoot.Position or aim.point
	if not (root and targetRoot and targetCharacter and Geo.vectorFinite(point))
        or effectiveRole(target,playerData(target))~="Murderer" or isInLobby(target)
        or (automatic and not autoTeleportNeeded(target,manual)) then
		return false
	end

	local gun, equipped = findTool("Gun")
	if not gun then
		return false
	end
	if not equipped then
		equipTool(gun)
		return false
	end
	if gun.Enabled==false then return false end

	local origin = gunOrigin()
	if not origin then
		return false
	end

	local rel = root.CFrame:ToObjectSpace(origin)
	local spot = findTeleportSpot(point, targetCharacter, rel)
	if not spot or (not automatic and (spot.Position-root.Position).Magnitude>(V.AimTeleportRange or 250)) then
		return false
	end

    local motion=V.acquireMotion and V.acquireMotion("Shot")
    if V.acquireMotion and not motion then return false end
	teleporting = true
	lastTeleport = os.clock()
	local home = root.CFrame
	local homeVelocity,homeAngular = root.AssemblyLinearVelocity,root.AssemblyAngularVelocity

	task.spawn(function()
        local fired=false
		local ok,err=pcall(function()
			root.CFrame = spot
			root.AssemblyLinearVelocity,root.AssemblyAngularVelocity = Vector3.zero,Vector3.zero
			task.wait(math.clamp(V.AimTeleportDelay or 0.07,0,0.5))

            local stillEnabled=manual or (automatic and V.AutoShoot) or (not automatic and V.WallShoot and V.AimTeleport)
			if V.Destroying or V.Destroyed or not stillEnabled or not holdsGunRole(os.clock())
                or (not manual and os.clock() < (aim.manualUntil or 0))
				or LocalPlayer.Character ~= character or aim.target ~= target
				or target.Character ~= targetCharacter or gun.Parent~=character or not root.Parent
                or effectiveRole(target,playerData(target))~="Murderer" or isInLobby(target)
                or (automatic and autoTeleportNeeded(target,manual)) then return end
            local freshRoot,freshHumanoid=aliveRoot(target)
            if not freshRoot then return end
			local freshNow=os.clock()
            updateAim(freshNow,manual,true)
            local tr=aimTracks[target]
            local freshPoint,freshFrame,freshSize = aim.point,aim.hitFrame,aim.hitSize
			local freshOrigin = gunOrigin() or (spot*rel)
			if freshPoint
				and clearShot(freshOrigin.Position,freshPoint,targetCharacter)
                and (manual or hitChanceAllowed(freshOrigin,freshPoint,freshFrame,freshSize,tr,freshNow)) then
				fired=fireGun(gun,freshOrigin,freshPoint)
                if fired then
                    aim.shotAt=os.clock()
                    if automatic then lastAutoShot=aim.shotAt end
                end
			end
			task.wait(0.06)
		end)
        if not ok then V.LastTeleportError=tostring(err) end
		pcall(function()
			if (not automatic or not fired) and LocalPlayer.Character == character and root.Parent and isRoundActive() and aliveRoot(LocalPlayer) then
				root.CFrame = home
				root.AssemblyLinearVelocity,root.AssemblyAngularVelocity = homeVelocity,homeAngular
			end
		end)
		teleporting = false
        if motion then V.releaseMotion(motion) end
	end)
	return true
end

local function autoShootStep(now)
	if not V.AutoShoot or teleporting or V.MotionOwner or V.Destroying or V.Destroyed
        or now < (aim.manualUntil or 0)
        or now-lastAutoShot<math.max(0.05,tonumber(V.AutoShootDelay) or 0.12) then
		return
	end
	if not holdsGunRole(now) then
		return
	end

    updateAim(now)
	local target=aim.target
    if target and effectiveRole(target,playerData(target))=="Murderer" and not isInLobby(target) and autoTeleportNeeded(target) then
        if teleportShot("Auto") then
            lastAutoShot=now
            aim.waitStart=nil
        end
        return
    end
	local point = aim.point
	if not point or not aim.target or aim.target.Character ~= aim.character or now - aim.t > 0.05 then
		aim.waitStart = nil
		return
	end
	local teleportOn = V.WallShoot and V.AimTeleport
	if aim.blocked and not (aim.origin or teleportOn) then
		return
	end
	if not V.ForceShoot and aim.conf < (V.AutoShootMinConf or 0) then
		return
	end

	if V.AutoShootPatient and not V.ForceShoot then
		local drift = aim.lat * AIM_TIME_ERROR
		if drift > (V.AutoShootTolerance or 1) then
			aim.waitStart = aim.waitStart or now
			if now - aim.waitStart < (V.AutoShootMaxWait or 0.6) then
				return
			end
        else
            aim.waitStart = nil
		end
	end

	local gun, equipped = findTool("Gun")
	if not gun then
		return
	end
	if not equipped then
		equipTool(gun)
		return
	end
	if gun.Enabled==false then return end

	if aim.blocked and teleportOn then
		if teleportShot() then
			lastAutoShot = now
			aim.waitStart = nil
		end
		return
	end

	local origin = gunOrigin()
	if not origin then
		return
	end
	if aim.originRot then
		origin = aim.originRot
	elseif aim.bypass and aim.origin then
		origin = aim.origin
	end

	if not clearShot(origin.Position,point,aim.character) then return end
    if not hitChanceAllowed(origin,point,aim.hitFrame,aim.hitSize,aimTracks[target],now) then return end
	if findShootRemote(gun) then
		if fireGun(gun, origin, point) then
			lastAutoShot = now
			aim.shotAt = now
			aim.waitStart = nil
		end
	end
end

V.ShootMurderer=function()
    local character=LocalPlayer.Character
    if V.Destroying or V.Destroyed or not holdsGunRole(os.clock()) or os.clock()-lastAutoShot<(V.AutoShootDelay or 0.12) then return false end
    local gun,equipped=findTool("Gun")
    if not gun then return false end
    if not equipped then
        equipTool(gun)
        for _=1,18 do
            if LocalPlayer.Character~=character or V.Destroying or V.Destroyed or not holdsGunRole(os.clock()) then return false end
            if gun.Parent==character then break end
            task.wait(1/60)
        end
    end
    if gun.Parent~=character or gun.Enabled==false then return false end
    local now=os.clock()
    updateAim(now,true)
    if aim.target and autoTeleportNeeded(aim.target,true) then
        local started=teleportShot("Manual")
        if started then lastAutoShot=now end
        return started
    end
    local origin=gunOrigin()
    if not origin or not aim.point or not aim.target or aim.target.Character~=aim.character then return false end
    if not clearShot(origin.Position,aim.point,aim.character) then return false end
    if fireGun(gun,origin,aim.point) then lastAutoShot,aim.shotAt=now,now; return true end
    return false
end

local pickup = {drop = nil, root = nil, nextTry = 0, started = 0, busy = false, queued = false}
local function canGrabGun()
	local role, d = roleOf(LocalPlayer)
	return type(d) == "table" and type(d.Role) == "string" and d.Dead ~= true
		and role ~= "Murderer" and not hasRoundGun(LocalPlayer)
end

local function touchGunDrop(drop)
	if not V.AutoGrabGun or V.Destroying or V.Destroyed or pickup.busy or not canGrabGun() then return false end
	local root = aliveRoot(LocalPlayer)
	if not root or not drop or not drop:IsA("BasePart") or not drop:IsDescendantOf(Workspace) then return false end
	local now = os.clock()
	if pickup.drop ~= drop or pickup.root ~= root then
		pickup.drop, pickup.root, pickup.started, pickup.nextTry = drop, root, now, 0
	end
	if now < pickup.nextTry then return false end
	pickup.nextTry = now + (now-pickup.started < 1 and 0.016 or 0.08)
	pickup.busy = true
	local ok, err = pcall(function()

		-- Touch the existing drop without relocating it or changing its physics.
		-- firetouchinterest is executor-specific; a successful call is not proof of pickup.
		local prompt = drop:FindFirstChildWhichIsA("ProximityPrompt", true)
		local owner = drop.Parent
		if not prompt and owner and owner ~= Workspace and (owner:IsA("Model") or owner:IsA("Tool")) then
			prompt = owner:FindFirstChildWhichIsA("ProximityPrompt", true)
		end
		if prompt and prompt.Enabled and type(fireproximityprompt) == "function" then
			pcall(fireproximityprompt, prompt, 0)
		end
		if type(firetouchinterest) == "function" then
			local character = LocalPlayer.Character
			local torso = character and (character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso"))
			local parts = {root}
			if torso and torso ~= root then parts[#parts+1] = torso end
			local head = character and character:FindFirstChild("Head")
			if head and head:IsA("BasePart") then parts[#parts+1] = head end
			for _, part in ipairs(parts) do

				pcall(firetouchinterest, part, drop, 0)
				pcall(firetouchinterest, part, drop, 1)
			end
		end
	end)
	pickup.busy = false
	if not ok then V.LastGunGrabError = tostring(err) end
	return ok
end

-- Short pickup visit for servers that require physical proximity to the drop.
local grabVisit
local function finishGrabVisit()
    local visit = grabVisit
    if not visit then return end
    grabVisit = nil
    if V.MotionOwner == visit.motion and LocalPlayer.Character == visit.character and visit.root.Parent then
        pcall(function()
            visit.character:PivotTo(visit.home)
            visit.root.AssemblyLinearVelocity = visit.linear
            visit.root.AssemblyAngularVelocity = visit.angular
        end)
    end
    V.releaseMotion(visit.motion)
end
local function grabGunDrop(drop)
    local sent = touchGunDrop(drop)
    if V.GunGrabTeleport == false or grabVisit or not V.AutoGrabGun or not canGrabGun()
        or V.Destroying or V.Destroyed then return sent end
    local root, hum, character = aliveRoot(LocalPlayer)
    if not root or not drop or not drop:IsDescendantOf(Workspace) or (root.Position-drop.Position).Magnitude<7
        or os.clock() < (pickup.nextVisit or 0) then return sent end
    local motion = V.acquireMotion("GunPickup")
    if not motion then return sent end
    pickup.nextVisit = os.clock() + 0.5
    local visit = {motion=motion,character=character,root=root,home=character:GetPivot(),
        linear=root.AssemblyLinearVelocity,angular=root.AssemblyAngularVelocity}
    grabVisit = visit
    task.spawn(function()
        local ok, err = pcall(function()
            for _ = 1, 3 do
                if grabVisit ~= visit or V.MotionOwner ~= motion or not V.AutoGrabGun or V.Destroying or V.Destroyed
                    or LocalPlayer.Character ~= character or hum.Health <= 0 or not drop:IsDescendantOf(Workspace)
                    or hasRoundGun(LocalPlayer) then break end
                local point = drop.CFrame + Vector3.new(0, 2, 0)
                character:PivotTo(point * root.CFrame:Inverse() * character:GetPivot())
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
                pickup.nextTry = 0
                touchGunDrop(drop)
                RunService.Heartbeat:Wait()
            end
        end)
        if grabVisit == visit then finishGrabVisit() end
        if not ok then V.LastGunGrabError = tostring(err) end
    end)
    return sent
end

local function autoGrabGunStep(now)
	if not V.AutoGrabGun or V.Destroying or V.Destroyed then return end
	if not canGrabGun() then
		pickup.drop, pickup.root, pickup.nextTry = nil, nil, 0
		return
	end
	if now < pickup.nextTry then return end
	local drop = gunDrop()
	if drop then grabGunDrop(drop) end
end

con(Workspace.DescendantAdded, function(object)
	if not V.AutoGrabGun or V.Destroying or V.Destroyed then return end
	local owner = object
	while owner and owner ~= Workspace and owner.Name ~= "GunDrop" do owner = owner.Parent end
	if not owner or owner == Workspace then return end
	local drop = resolveGunDrop(owner)
	if drop then
		cachedGunDrop = drop
		if V.AutoGrabGun then pcall(grabGunDrop, drop) end
	end

	if V.AutoGrabGun and not pickup.queued then
		pickup.queued = true
		task.defer(function()
			pickup.queued = false
			if V.Destroying or V.Destroyed or not V.AutoGrabGun then return end
			local candidate = resolveGunDrop(owner)
			if candidate then cachedGunDrop = candidate; pcall(grabGunDrop, candidate) end
		end)
	end
end)

con(RunService.PreSimulation, function()
    local ok, err = pcall(autoGrabGunStep, os.clock())
    if not ok then V.LastGunGrabError = tostring(err) end
end)
con(Gameplay.PlayerDataChanged.OnClientEvent, function()
    if V.AutoGrabGun then task.defer(autoGrabGunStep, os.clock()) end
end)

V.RestoreCombat = function()
    finishGrabVisit()
    if ShitaroAim then ShitaroAim:Destroy() end
	V.SilentAim = false
	V.AutoShoot = false
	V.WallShoot = false
    V.ForceShoot = false
	V.AutoGrabGun = false

	V.MurderKillAura = false
	V.MurderAutoKillAll = false
	V.MurderKnifeSilent = false
	pickup.drop, pickup.root, pickup.nextTry = nil, nil, 0
	aimHookLive = false
	V.AimTeleport = false
	table.clear(aimTracks)
    table.clear(knifeSelection)
	aim.cf,aim.origin,aim.point,aim.target = nil,nil,nil,nil
	Geo.state,aim.spoofCF,aim.peekOffset = nil,nil,nil
	if aimFovGui then
		aimFovGui:Destroy()
		aimFovGui = nil
	end
	if aimMarkerGui then
		aimMarkerGui:Destroy()
		aimMarkerGui = nil
	end
	local service = WeaponService
	if service then
		pcall(function()
			if setreadonly then
				setreadonly(service, false)
			end
			if OriginalMouseTarget and service.GetMouseTargetCFrame == HookedMouseTarget then
				service.GetMouseTargetCFrame = OriginalMouseTarget
			end
			if OriginalScreenTarget and service.GetTargetPosition == HookedScreenTarget then
				service.GetTargetPosition = OriginalScreenTarget
			end
		end)
	end
end

local manualGun, manualGunConnection
local function markManualInput()
    if V.Destroying or V.Destroyed or internalGunShot then return end
    V.LastManualInputTime = os.clock()
    aim.manualUntil = math.max(aim.manualUntil or 0, os.clock() + 0.25)
end
local function observeManualGun()
    local gun, equipped = findTool("Gun")
    if not equipped then gun = nil end
    if gun == manualGun then return end
    if manualGunConnection then manualGunConnection:Disconnect(); manualGunConnection = nil end
    manualGun = gun
    if gun then manualGunConnection = gun.Activated:Connect(markManualInput) end
end
con(UserInputService.InputBegan, function(input, processed)
    if processed then return end
    local kind = input.UserInputType
    if kind ~= Enum.UserInputType.MouseButton1 and kind ~= Enum.UserInputType.Touch then return end
    local gun, equipped = findTool("Gun")
    if gun and equipped then markManualInput() end
end)
con(LocalPlayer.CharacterAdded, function()
    if manualGunConnection then manualGunConnection:Disconnect(); manualGunConnection = nil end
    manualGun = nil
    aim.manualUntil = nil
    if ShitaroAim then ShitaroAim:Reset() end
end)
-- Round boundaries: the roles, characters and map all change.  Drop the target,
-- tracker, calibrator, cached shot plan and spoofed origin so nothing from the
-- previous round (old murderer, old velocities) can be reused.
for _, name in ipairs({"RoleSelect", "ShowRoleSelect", "ShowRoleSelectNew", "LoadingMap", "TeleportToPart",
	"RoundStart", "GiveWeapon", "SpecialRound", "GameOver", "RoundEndFade", "VictoryScreen"}) do
	local remote = Gameplay:FindFirstChild(name)
	if remote then
		con(remote.OnClientEvent, function()
			if ShitaroAim then ShitaroAim:Reset() end
		end)
	end
end
local previousCombatRestore = V.RestoreCombat
V.RestoreCombat = function(...)
    if manualGunConnection then manualGunConnection:Disconnect(); manualGunConnection = nil end
    manualGun = nil
    return previousCombatRestore(...)
end

local lastHookTry = 0
con(RunService.Heartbeat, function()
	local now = os.clock()
    pcall(observeManualGun)
	if (V.SilentAim or V.WallShoot or V.MurderKnifeSilent) and now - lastHookTry > 1 then
		lastHookTry = now
		pcall(installAimHooks)
	end
	local okAim,errAim = pcall(updateAim,now)
	if not okAim then
        aim.cf,aim.point,aim.origin,aim.originRot,aim.part,aim.character=nil,nil,nil,nil,nil,nil
        aim.t,aim.waitStart=-1,nil
        V.LastAimError=tostring(errAim)
    end
	pcall(updateAimVisuals)
	local okShot,errShot = pcall(function()
        autoShootStep(now)
    end)
	if not okShot then V.LastShotError = tostring(errShot) end
end)

local murderClock = 0
local murderBusy = false
local murderCursor = 0
local murderQueued = false
local murderAttempts = setmetatable({}, {__mode="k"})
findKnife = function()
    local character = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    for index = 1, 2 do
        local container
        if index == 1 then container = character else container = backpack end
        if container then
            for _, object in ipairs(container:GetChildren()) do
                if object:IsA("Tool") then
                    local name = string.lower(object.Name)
                    if name == "knife" or string.find(name, "knife", 1, true) or string.find(name, "blade", 1, true) then
                        return object, container == character
                    end
                end
            end
        end
    end
end

knifeHandle = function(tool)
    if not tool then return nil end
    local handle = tool:FindFirstChild("Handle")
    if handle and handle:IsA("BasePart") then return handle end
    return tool:FindFirstChildWhichIsA("BasePart", true)
end

local function murderVictims()
    local result = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Parent == Players and aliveRoot(player) and not isInLobby(player) then
            local data = playerData(player)
            if (not data or data.Dead ~= true) and effectiveRole(player, data) ~= "Murderer" then
                result[#result + 1] = player
            end
        end
    end
    return result
end

local function murderTargetPart(player)
    local character = player and player.Character
    if not character then return nil end
    for _, name in ipairs(AIM_PARTS[V.MurderSilentPart] or AIM_PARTS.Root) do
        local part = character:FindFirstChild(name)
        if part and part:IsA("BasePart") then return part end
    end
    return nil
end

local function murderOrigin()
    local tool, equipped = findKnife()
    local handle = equipped and knifeHandle(tool)
    if handle and Geo.vectorFinite(handle.Position) then return handle.Position end
    local root = aliveRoot(LocalPlayer)
    return root and root.Position or nil
end

local function murderVisible(point, character, originOverride, enabled)
    if enabled == nil then enabled = V.MurderSilentWallCheck end
    if not enabled then return true end
    local origin = originOverride or murderOrigin()
    return origin ~= nil and clearShot(origin, point, character)
end

local function solveKnifeTarget(player,origin,camera,mouse,now,range,radius,lead,forAim)
    local root,humanoid,character=aliveRoot(player)
    if not root then return nil end
    local shift=Vector3.zero
    if forAim and lead>0 then
        local track=trackerFor(player)
        pushSample(track,now,root.Position)
        fitTrack(track,now,root,humanoid)
        shift=predictOffset(track,root.Position,lead,root,{mode="Smart",strafeDamp=true,gravity=true})
        if not Geo.vectorFinite(shift) then return nil end
    end
    local parts=candidateParts(character,V.MurderSilentPart)
    local offsets=forAim and V.MurderMultipoint and AIM_POINTS_MULTI or AIM_POINTS_CENTER
    for pass=1,2 do
      for _,part in ipairs(parts) do
        for index,offset in ipairs(offsets) do
          if (index==1)==(pass==1) then
            local point=part.Position+shift
            if offset.Magnitude>0 then point=part.CFrame:PointToWorldSpace(offset*part.Size)+shift end
            local distance=Geo.vectorFinite(point) and (point-origin).Magnitude or math.huge
            local eligible=distance<=range
            local score=distance
            if eligible and forAim and V.MurderSilentFov then
                if camera then
                    local screen,onScreen=camera:WorldToScreenPoint(point)
                    local pixels=(Vector2.new(screen.X,screen.Y)-mouse).Magnitude
                    eligible=onScreen and screen.Z>0 and pixels<=radius
                    score=pixels
                else eligible=false end
            end
            if eligible and forAim then eligible=murderVisible(point,character,origin) end
            if eligible then return part,point,score end
          end
        end
      end
    end
    return nil
end

local function chosenMurderTarget(forAim)
    local localRoot=aliveRoot(LocalPlayer)
    if not localRoot then return nil end
    local camera=Workspace.CurrentCamera
    local mouse=UserInputService:GetMouseLocation()
    local origin=murderOrigin()
    if not Geo.vectorFinite(origin) then return nil end
    local best,bestPart,bestPoint,bestScore
    local selected=V.MurderTarget or "Closest"
    local now=os.clock()
    for player,track in pairs(aimTracks) do
        if player.Parent~=Players or now-track.seen>2 then aimTracks[player]=nil end
    end
    local range=math.clamp(tonumber(V.MurderSilentRange) or 1000000,1,1000000)
    local radius=math.clamp(tonumber(V.MurderSilentFovRadius) or 350,1,2000)
    local lead=math.clamp(tonumber(V.MurderKnifePrediction) or 0.1,0,0.5)
    if lead>0 and V.MurderKnifePing then
        lead=lead+currentRtt(now)*0.5+math.min((rttCache.jitter or 0)*0.25,0.025)
    end
    lead=math.min(lead,math.clamp(V.MurderKnifeMaxLead or 0.65,0,1))
    local previous=forAim and selected=="Closest" and knifeSelection.character==LocalPlayer.Character and knifeSelection.player or nil
    local previousPart,previousPoint,previousScore
    for _,player in ipairs(murderVictims()) do
        if selected=="Closest" or player.Name==selected then
            local part,point,score=solveKnifeTarget(player,origin,camera,mouse,now,range,radius,lead,forAim)
            if part and player==previous then previousPart,previousPoint,previousScore=part,point,score end
            if part and (not best or score<bestScore or (score==bestScore and player.UserId<best.UserId)) then
                best,bestPart,bestPoint,bestScore=player,part,point,score
            end
        end
    end
    if best and previousPart and previous~=best and previousScore<=bestScore*1.08+(V.MurderSilentFov and 6 or 2) then
        best,bestPart,bestPoint=previous,previousPart,previousPoint
    end
    if forAim then knifeSelection.player,knifeSelection.character=best,LocalPlayer.Character end
    return best,bestPart,bestPoint,origin
end

knifeAimCFrame = function()
    if V.Destroying or V.Destroyed or not V.MurderKnifeSilent or not isLocalMurderer() then return nil end
    local target, part, point = chosenMurderTarget(true)
    if not target or not part or not Geo.vectorFinite(point) then return nil end
    return CFrame.new(point)
end

local function murderAllowed(player,character,targetCharacter,mode)
    if V.Destroying or V.Destroyed or LocalPlayer.Character~=character or not isLocalMurderer() then return false end
    if mode=="Auto" and not V.MurderAutoKillAll then return false end
    if mode=="Aura" and not V.MurderKillAura then return false end
    if not player or player==LocalPlayer or player.Parent~=Players or player.Character~=targetCharacter
        or not aliveRoot(player) or isInLobby(player) then return false end
    local data=playerData(player)
    if (data and data.Dead==true) or effectiveRole(player,data)=="Murderer" then return false end
    if mode=="Aura" then
        local root,targetRoot=aliveRoot(LocalPlayer),aliveRoot(player)
        if not root or not targetRoot or (root.Position-targetRoot.Position).Magnitude>(V.MurderAuraRange or 18) then return false end
    end
    return true
end

local function equippedKnife(character,allowed)
    local tool,equipped=findKnife()
    if not tool or not allowed() then return nil end
    if not equipped then
        for attempt=1,18 do
            if not allowed() then return nil end
            if attempt==1 or attempt==7 or attempt==13 then equipTool(tool) end
            task.wait(1/60)
            if tool.Parent==character then break end
            if not tool.Parent then
                tool=findKnife()
                if not tool then return nil end
            end
        end
    end
    if tool.Parent~=character or tool.Enabled==false or not allowed() then return nil end
    return tool
end

local function touchVictim(tool,player,activated)
    local handle=knifeHandle(tool)
    local character=player and player.Character
    if not handle or not character or tool.Parent~=LocalPlayer.Character or (not activated and tool.Enabled==false)
        or not handle:IsDescendantOf(tool) or type(firetouchinterest)~="function" then return false end
    if not activated and not pcall(function() tool:Activate() end) then return false end
    if player.Character~=character or not aliveRoot(player) then return false end
    local touched=false
    for _,name in ipairs({"HumanoidRootPart","UpperTorso","Torso","Head"}) do
        local part=character:FindFirstChild(name)
        if part and part:IsA("BasePart") then
            local began=pcall(firetouchinterest,handle,part,0)
            local ended=pcall(firetouchinterest,handle,part,1)
            touched=touched or (began and ended)
        end
    end
    return touched
end

local function murderAttack(player,mode)
    local character=LocalPlayer.Character
    local targetCharacter=player and player.Character
    local function allowed() return murderAllowed(player,character,targetCharacter,mode) end
    if murderBusy or not allowed() then return false end
    murderBusy=true
    local ok,result=pcall(function()
        local tool=equippedKnife(character,allowed)
        if not tool then return false end
        return touchVictim(tool,player)
    end)
    murderBusy=false
    if not ok then V.LastMurderError=tostring(result); return false end
    if result then murderAttempts[player]={character=targetCharacter,time=os.clock()} end
    return result
end

-- Explicit bridge: these closures belong to initCombat, not initServerPlayers.
V.CanAttackPlayer = function(player)
    return murderAllowed(player, LocalPlayer.Character, player and player.Character, nil)
end
V.AttackPlayer = function(player)
    return murderAttack(player)
end

local killAllBusy=false
local function killAll(sheriffOnly,mode)
    if killAllBusy or murderBusy or murderQueued or not isLocalMurderer() then return false end
    local character=LocalPlayer.Character
    local function allowed()
        return not V.Destroying and not V.Destroyed and LocalPlayer.Character==character
            and isLocalMurderer() and (mode~="Auto" or V.MurderAutoKillAll)
    end
    local victims={}
    local now=os.clock()
    for _,player in ipairs(murderVictims()) do
        local previous=murderAttempts[player]
        if (not sheriffOnly or hasRoundGun(player)) and (mode~="Auto" or not previous
            or previous.character~=player.Character or now-previous.time>=math.max(V.MurderAuraDelay or 0.08,0.15)) then
            victims[#victims+1]={player=player,character=player.Character}
        end
    end
    if #victims==0 or not allowed() then return false end
    killAllBusy,murderBusy=true,true
    local ok,result=pcall(function()
        local tool=equippedKnife(character,allowed)
        local handle=tool and knifeHandle(tool)
        if not handle or not handle:IsDescendantOf(tool) or type(firetouchinterest)~="function" then return false end
        if not pcall(function() tool:Activate() end) or not allowed() then return false end
        local sent=0
        for _,entry in ipairs(victims) do
            if not allowed() or tool.Parent~=character then break end
            local player=entry.player
            if murderAllowed(player,character,entry.character,mode) and (not sheriffOnly or hasRoundGun(player))
                and touchVictim(tool,player,true) then
                sent=sent+1
                murderAttempts[player]={character=entry.character,time=os.clock()}
            end
        end
        V.LastKillAllAttempts=sent
        return sent>0
    end)
    killAllBusy,murderBusy=false,false
    if not ok then V.LastMurderError=tostring(result); return false end
    return result
end

V.KillSheriff=function() return killAll(true) end

con(RunService.Heartbeat, function(dt)
	if V.Destroying or V.Destroyed or not isLocalMurderer() then
        table.clear(knifeSelection)
        return
    end
    if V.MurderKnifeSilent and V.MurderKnifePrediction>0 then
        local now=os.clock()
        for player,track in pairs(aimTracks) do
            if player.Parent~=Players or now-track.seen>2 then aimTracks[player]=nil end
        end
        for _,player in ipairs(murderVictims()) do
            if V.MurderTarget=="Closest" or player.Name==V.MurderTarget then
                local root,humanoid=aliveRoot(player)
                if root then
                    local track=trackerFor(player)
                    pushSample(track,now,root.Position)
                    fitTrack(track,now,root,humanoid)
                end
            end
        end
    else table.clear(knifeSelection) end
	murderClock += dt
	if murderClock < math.clamp(V.MurderAuraDelay or 0.08, 0.02, 0.5) then return end
	murderClock = 0
    if murderBusy or murderQueued or killAllBusy then return end
    if V.MurderAutoKillAll then
        task.spawn(function()
            local ok,err=pcall(killAll,false,"Auto")
            if not ok then V.LastMurderError=tostring(err) end
        end)
    elseif V.MurderKillAura then
        local victims=murderVictims()
        local now=os.clock()
        for _=1,#victims do
            murderCursor=murderCursor%#victims+1
            local player=victims[murderCursor]
            local previous=murderAttempts[player]
            local ready=not previous or previous.character~=player.Character
                or now-previous.time>=math.max(V.MurderAuraDelay or 0.08,0.15)
            if ready and murderAllowed(player,LocalPlayer.Character,player.Character,"Aura") then
                murderQueued=true
                task.spawn(function()
                    local ok,err=pcall(murderAttack,player,"Aura")
                    murderQueued=false
                    if not ok then V.LastMurderError=tostring(err) end
                end)
                break
            end
        end
    elseif V.MurderAutoEquip then
        local tool,equipped=findKnife()
        if tool and not equipped then equipTool(tool) end
    end
end)

local CombatTab = W:CreateTab({Name = "Combat", Title = "Combat", Icon = "crosshair"})
CombatTab:AddSection("Murderer")
CombatTab:AddButton({Name = "Kill all", Text = "Kill all", Callback = function()
    task.spawn(killAll)
end})
CombatTab:AddButton({Name="Kill sheriff",Callback=function() task.spawn(V.KillSheriff) end})
CombatTab:AddToggle({Name="Auto kill all",Flag="M.AutoKillAll",Default=V.MurderAutoKillAll,Callback=function(x) V.MurderAutoKillAll=x==true end})
for _,flag in ipairs({"M.TeleportAttacks","M.TeleportDelay"}) do
    Lib.Flags[flag]=nil
    if Lib.NoSaveFlags then Lib.NoSaveFlags[flag]=true end
end
CombatTab:AddToggle({Name = "Kill aura", Flag = "M.KillAura", Default = V.MurderKillAura, Callback = function(x) V.MurderKillAura = x == true end,
	Settings = {Name = "Kill aura settings", Width = 250, Build = function(m)
		m:AddSlider({Name = "Range", Flag = "M.AuraRange", Min = 4, Max = 100, Default = V.MurderAuraRange, Suffix = " studs", Callback = function(x) V.MurderAuraRange = x end})
		m:AddSlider({Name = "Attack interval", Flag = "M.AuraDelay", Min = 20, Max = 500, Default = math.floor(V.MurderAuraDelay * 1000), Suffix = " ms", Callback = function(x) V.MurderAuraDelay = x / 1000 end})
	end}})
CombatTab:AddToggle({Name = "Knife silent aim", Flag = "M.KnifeSilent", Default = V.MurderKnifeSilent, Callback = function(x)
	V.MurderKnifeSilent = x == true
	if x then task.spawn(installAimHooks) end
end, Settings = {Name = "Knife silent settings", Width = 270, MaxHeight = 440, Build = function(m)
	local targets = {"Closest"}
	for _, player in ipairs(Players:GetPlayers()) do if player ~= LocalPlayer then targets[#targets + 1] = player.Name end end
	local parts = {"Root", "Torso", "Head"}
	m:AddDropdown({Name = "Target", Flag = "M.Target", Options = targets, Default = V.MurderTarget, Callback = function(x) if type(x) == "number" then x = targets[x] end; if x then V.MurderTarget = x end end})
	m:AddDropdown({Name = "Hit part", Flag = "M.SilentPart", Options = parts, Default = V.MurderSilentPart, Callback = function(x) if type(x) == "number" then x = parts[x] end; if table.find(parts, x) then V.MurderSilentPart = x end end})
	m:AddToggle({Name = "Multi point", Flag = "M.Multipoint", Default = V.MurderMultipoint, Callback = function(x) V.MurderMultipoint = x == true end})
	m:AddToggle({Name = "Visible Check", Flag = "M.WallCheck", Default = V.MurderSilentWallCheck, Callback = function(x) V.MurderSilentWallCheck = x == true end})
	m:AddToggle({Name = "Limit to FOV", Flag = "M.UseFov", Default = V.MurderSilentFov, Callback = function(x) V.MurderSilentFov = x == true end})
	m:AddSlider({Name = "FOV radius", Flag = "M.FovRadius", Min = 30, Max = 1000, Default = V.MurderSilentFovRadius, Suffix = " px", Callback = function(x) V.MurderSilentFovRadius = x end})
	m:AddSlider({Name = "Maximum range", Flag = "M.SilentRange", Min = 50, Max = 1000000, Default = V.MurderSilentRange, Suffix = " studs", Callback = function(x) V.MurderSilentRange = x end})
	m:AddSlider({Name = "Prediction", Flag = "M.KnifePrediction", Min = 0, Max = 500, Default = math.floor(V.MurderKnifePrediction * 1000), Suffix = " ms", Callback = function(x) V.MurderKnifePrediction = x / 1000 end})
    XT.toggle(m, "Ping compensation", "M.KnifePing")
    XT.slider(m, "Maximum lead", "M.KnifeMaxLead", 0, 1000, " ms")
	end}})
CombatTab:AddToggle({Name = "Auto equip knife", Flag = "M.AutoEquip", Default = V.MurderAutoEquip, Callback = function(x) V.MurderAutoEquip = x == true end})
CombatTab:AddSection("Sheriff")
CombatTab:AddToggle({
	Name = "Silent aim",
	Flag = "C.SilentAim",
	Default = false,
	Callback = function(x)
		V.SilentAim = x
		if x then
			task.spawn(installAimHooks)
		end
	end,
	Settings = {
		Name = "Aim settings",
		Width = 270,
		MaxHeight = 460,
		Build = function(m)
			local function pick(options, key)
				return function(x)
					if type(x) == "number" then
						x = options[x]
					end
					if table.find(options, x) then
						V[key] = x
					end
				end
			end
			local function toggle(name, flag, key)
				m:AddToggle({
					Name = name,
					Flag = flag,
					Default = V[key],
					Callback = function(x)
						V[key] = x == true
					end,
				})
			end
			local function slider(name, flag, key, min, max, suffix, scale)
				scale = scale or 1
				m:AddSlider({
					Name = name,
					Flag = flag,
					Min = min,
					Max = max,
					Default = math.clamp(math.floor(V[key] / scale + 0.5), min, max),
					Suffix = suffix,
					Callback = function(x)
						V[key] = x * scale
					end,
				})
			end

			local parts = {"Auto", "Head", "Torso", "Root", "Closest"}
			m:AddDropdown({
				Name = "Hit part",
				Flag = "C.AimPart",
				Options = parts,
				Default = V.AimPart,
				Callback = pick(parts, "AimPart"),
			})
			toggle("Multi point", "C.AimMultipoint", "AimMultipoint")
			toggle("Wall check", "C.AimWallCheck", "AimWallCheck")
			slider("Max range", "C.AimRange", "AimRange", 50, 1000000, " studs")

			toggle("Prediction", "C.Prediction", "AimPrediction")
			XT.dropdown(m, "Prediction mode", "C.AimPredictMode")
			XT.slider(m, "Base lead", "C.AimInterp", 0, 250, " ms")
			XT.toggle(m, "Use network ping", "C.AimPing")
			XT.slider(m, "Maximum lead", "C.AimMaxLead", 0, 450, " ms")
			XT.toggle(m, "Jerk adaptation", "C.AimJerkAdapt")
			XT.toggle(m, "Self-calibration", "C.AimCalibrate")
			XT.slider(m, "Own motion compensation", "C.AimSelfComp", 0, 60, " ms")
			XT.toggle(m, "Strafe damping", "C.AimStrafeDamp")
			XT.toggle(m, "Airborne gravity", "C.AimGravity")
			slider("Prediction scale", "C.PredictionScale", "PredictionScale", 0, 200, "%", 0.01)

			toggle("Limit to FOV", "C.AimFov", "AimFov")
			slider("FOV radius", "C.AimFovRadius", "AimFovRadius", 30, 800, " px")
			toggle("FOV circle", "C.AimFovCircle", "AimFovCircle")
		end,
	},
})
CombatTab:AddToggle({
	Name = "WallShoot",
	Flag = "C.WallShoot",
	Default = false,
	Callback = function(x)
		V.WallShoot = x
		if x then
			task.spawn(installAimHooks)
		end
	end,
	Settings = {
		Name = "WallShoot settings",
		Width = 260,
		Build = function(m)
			m:AddSlider({
				Name = "Origin peek radius",
				Flag = "C.AimOriginRadius",
				Min = 0,
				Max = 40,
				Default = math.clamp(V.AimOriginRadius, 0, 40),
				Suffix = " studs",
				Callback = function(x)
					V.AimOriginRadius = x
				end,
			})
			m:AddToggle({
				Name = "Near target fallback",
				Flag = "C.AimBypass",
				Default = V.AimBypass,
				Callback = function(x)
					V.AimBypass = x == true
				end,
			})
			m:AddToggle({
				Name = "Teleport shot",
				Flag = "C.AimTeleport",
				Default = V.AimTeleport,
				Callback = function(x)
					V.AimTeleport = x == true
				end,
			})
		end,
	},
})
CombatTab:AddToggle({Name="Force Shoot",Flag="C.ForceShoot",Default=false,Callback=function(value)
    XT.apply("C.ForceShoot",value)
end})
CombatTab:AddToggle({
	Name = "Auto shoot",
	Flag = "C.AutoShoot",
	Default = false,
	Callback = function(x)
		V.AutoShoot = x
	end,
	Settings = {
		Name = "Auto shoot settings",
		Width = 240,
		Build = function(m)
			XT.slider(m,"Hit chance","C.HitChance",0,100,"%")
            XT.slider(m,"Spread estimate","C.HitChanceSpread",0,5,"°",2)
            XT.slider(m,"Teleport distance","C.AutoShootTeleportDistance",50,5000," m")
			m:AddSlider({
				Name = "Delay",
				Flag = "C.AutoShootDelay",
				Min = 50,
				Max = 1000,
				Default = 120,
				Suffix = " ms",
				Callback = function(x)
					V.AutoShootDelay = x / 1000
				end,
			})
			m:AddToggle({
				Name = "Patient timing",
				Flag = "C.AutoShootPatient",
				Default = true,
				Callback = function(x)
					V.AutoShootPatient = x
				end,
			})
		end,
	},
})
CombatTab:AddButton({Name="Shoot murderer",Callback=function() task.spawn(V.ShootMurderer) end})
CombatTab:AddSection("Utility")
CombatTab:AddToggle({
	Name = "Auto Grab Gun",
	Flag = "C.AutoGrabGun",
	Default = false,
	Callback = function(x)
		V.AutoGrabGun = x
        if not x then finishGrabVisit() end
		pickup.drop, pickup.root, pickup.nextTry = nil, nil, 0
		if x then
			lastGunDropScan = -math.huge
			pcall(autoGrabGunStep, os.clock())
		end
	end,
    Settings = {Name="Gun pickup", Width=260, Build=function(m)
        m:AddToggle({Name="Teleport pickup and return", Flag="C.GunGrabTeleport", Default=V.GunGrabTeleport,
            Callback=function(x) V.GunGrabTeleport=x==true; if not x then finishGrabVisit() end end})
    end},
})
end
initCombat()

local function initPlayer()
    local defaults={SpeedEnabled=false,SpeedValue=32,SpeedMode="Humanoid",SprintEnabled=false,SprintMultiplier=1.6,
        JumpEnabled=false,JumpValue=60,InfiniteJump=false,Noclip=false,FlyEnabled=false,FlySpeed=65,FlyResponse=14,
        AntiFling=false,AntiSit=false,AntiVoid=false}
    for key,value in pairs(defaults) do if V[key]==nil then V[key]=value end end
    local function register(flag,key,kind,min,max,options)
        XT.specs[flag]={key=key,kind=kind,min=min,max=max,a=options}
    end
    register("P.Speed","SpeedEnabled","bool")
    register("P.SpeedValue","SpeedValue","num",1,500)
    register("P.SpeedMode","SpeedMode","opt",nil,nil,{"Humanoid","Velocity"})
    register("P.Sprint","SprintEnabled","bool")
    register("P.SprintMultiplier","SprintMultiplier","num",1,4)
    register("P.Jump","JumpEnabled","bool")
    register("P.JumpValue","JumpValue","num",1,250)
    register("P.InfiniteJump","InfiniteJump","bool")
    register("P.Noclip","Noclip","bool")
    register("P.Fly","FlyEnabled","bool")
    register("P.FlySpeed","FlySpeed","num",1,500)
    register("P.FlyResponse","FlyResponse","num",1,40)
    register("P.AntiFling","AntiFling","bool")
    register("P.AntiSit","AntiSit","bool")
    register("P.AntiVoid","AntiVoid","bool")

    local currentCharacter,humanoid,root,original
    local flyAttachment,flyVelocity,flyOrientation
    local flyHumanoidState
    local velocity=Vector3.zero
    local collisions=setmetatable({}, {__mode="k"})
    local antiCollisions=setmetatable({}, {__mode="k"})
    local cachedParts={}
    local playerParts={}
    local scanClock=0
    local lastSafe
    local lastJump=-1
    local speedActive,jumpActive,sitActive=false,false,false
    local controlModule
    local function finite(v) return typeof(v)=="Vector3" and v.X==v.X and v.Y==v.Y and v.Z==v.Z and v.Magnitude<1e7 end
    local function restoreCollisions(records)
        for part,value in pairs(records) do
            if part.Parent then pcall(function() part.CanCollide=value end) end
            records[part]=nil
        end
    end
    local function stopFly()
        for _,object in pairs({flyAttachment,flyVelocity,flyOrientation}) do pcall(function() object:Destroy() end) end
        flyAttachment,flyVelocity,flyOrientation=nil,nil,nil
        velocity=Vector3.zero
        if humanoid and humanoid.Parent and flyHumanoidState then
            humanoid.PlatformStand=flyHumanoidState.PlatformStand
            humanoid.AutoRotate=flyHumanoidState.AutoRotate
            if humanoid.Health>0 and not humanoid.PlatformStand then humanoid:ChangeState(Enum.HumanoidStateType.GettingUp) end
        end
        if flyHumanoidState and root and root.Parent then
            root.AssemblyLinearVelocity=Vector3.zero; root.AssemblyAngularVelocity=Vector3.zero
        end
        flyHumanoidState=nil
    end
    local function restoreCharacter()
        stopFly()
        restoreCollisions(collisions)
        if humanoid and humanoid.Parent and original then
            if speedActive then humanoid.WalkSpeed=original.WalkSpeed end
            if jumpActive then
                humanoid.JumpPower=original.JumpPower; humanoid.JumpHeight=original.JumpHeight
                humanoid.UseJumpPower=original.UseJumpPower
            end
            if sitActive then humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,original.Seated) end
        end
        currentCharacter,humanoid,root,original=nil,nil,nil,nil
        table.clear(cachedParts); lastSafe=nil
        speedActive,jumpActive,sitActive=false,false,false
    end
    local function bindCharacter(character,newHumanoid,newRoot)
        restoreCharacter()
        currentCharacter,humanoid,root=character,newHumanoid,newRoot
        original={WalkSpeed=humanoid.WalkSpeed,JumpPower=humanoid.JumpPower,JumpHeight=humanoid.JumpHeight,
            UseJumpPower=humanoid.UseJumpPower,Seated=humanoid:GetStateEnabled(Enum.HumanoidStateType.Seated)}
        scanClock=1
    end
    local function createFly()
        if flyVelocity or not root or root.Anchored then return end
        flyHumanoidState={PlatformStand=humanoid.PlatformStand,AutoRotate=humanoid.AutoRotate}
        local attachment=Instance.new("Attachment")
        attachment.Name="Waraku_FLY_ATTACHMENT"; attachment.Parent=root; flyAttachment=attachment
        local linear=Instance.new("LinearVelocity")
        linear.Name="Waraku_FLY_VELOCITY"; linear.Attachment0=attachment
        linear.RelativeTo=Enum.ActuatorRelativeTo.World
        linear.VelocityConstraintMode=Enum.VelocityConstraintMode.Vector
        linear.ForceLimitsEnabled=false
        linear.VectorVelocity=Vector3.zero; linear.Parent=root; flyVelocity=linear
        local orientation=Instance.new("AlignOrientation")
        orientation.Name="Waraku_FLY_ORIENTATION"; orientation.Attachment0=attachment
        orientation.Mode=Enum.OrientationAlignmentMode.OneAttachment
        orientation.MaxTorque=1e9; orientation.MaxAngularVelocity=math.huge
        orientation.Responsiveness=30; orientation.RigidityEnabled=false
        orientation.CFrame=root.CFrame.Rotation; orientation.Parent=root; flyOrientation=orientation
        humanoid.PlatformStand=true; humanoid.AutoRotate=false
    end
    local function pressed(key) return UserInputService:IsKeyDown(key) and 1 or 0 end
    local function movementInput()
        if UserInputService:GetFocusedTextBox() then return Vector3.zero,0 end
        local input
        if controlModule then
            local ok,value=pcall(function() return controlModule:GetMoveVector() end)
            if ok and finite(value) then input=value end
        end
        if not input then
            input=Vector3.new(pressed(Enum.KeyCode.D)-pressed(Enum.KeyCode.A),0,
                pressed(Enum.KeyCode.S)-pressed(Enum.KeyCode.W))
        end
        local up=pressed(Enum.KeyCode.E)+pressed(Enum.KeyCode.Space)
        local down=pressed(Enum.KeyCode.Q)+pressed(Enum.KeyCode.LeftControl)
        return input,math.clamp(up-down,-1,1)
    end
    local function refreshParts()
        table.clear(cachedParts); table.clear(playerParts)
        if currentCharacter then
            for _,part in ipairs(currentCharacter:GetDescendants()) do
                if part:IsA("BasePart") then cachedParts[#cachedParts+1]=part end
            end
        end
        if V.AntiFling then
            for _,player in ipairs(Players:GetPlayers()) do
                if player~=LocalPlayer and player.Character then
                    for _,part in ipairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") then playerParts[#playerParts+1]=part end
                    end
                end
            end
        end
    end
    local function playerStep(dt)
        if V.Destroying or V.Destroyed then return end
        local newRoot,newHumanoid,character=aliveRoot(LocalPlayer)
        if not newRoot then
            if currentCharacter then restoreCharacter() end
            restoreCollisions(antiCollisions); return
        end
        if character~=currentCharacter or newHumanoid~=humanoid or newRoot~=root then bindCharacter(character,newHumanoid,newRoot) end
        scanClock=scanClock+dt
        if scanClock>=0.15 then scanClock=0; refreshParts() end
        if V.MotionOwner and V.MotionOwner.owner == "PlayerFling" then
            restoreCollisions(collisions)
            restoreCollisions(antiCollisions)
            stopFly(); lastSafe = nil
            return
        end
        if V.Noclip then
            for _,part in ipairs(cachedParts) do
                if part.Parent then
                    if collisions[part]==nil then collisions[part]=part.CanCollide end
                    part.CanCollide=false
                end
            end
        elseif next(collisions) then restoreCollisions(collisions) end
        if V.AntiFling then
            for _,part in ipairs(playerParts) do
                if part.Parent then
                    if antiCollisions[part]==nil then antiCollisions[part]=part.CanCollide end
                    part.CanCollide=false
                end
            end
        elseif next(antiCollisions) then restoreCollisions(antiCollisions) end
        if V.AntiSit then
            if not sitActive then original.Seated=humanoid:GetStateEnabled(Enum.HumanoidStateType.Seated); sitActive=true end
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
            if humanoid.Sit then humanoid.Sit=false end
        elseif sitActive then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,original.Seated); sitActive=false
        end
        if V.MotionOwner then
            stopFly(); lastSafe=nil; return
        end
        local sprint=V.SprintEnabled and not UserInputService:GetFocusedTextBox() and UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)
        local speedOn=V.SpeedEnabled or sprint
        if speedOn and not speedActive then original.WalkSpeed=humanoid.WalkSpeed; speedActive=true end
        local speed=V.SpeedEnabled and math.clamp(V.SpeedValue,1,500) or (speedActive and original.WalkSpeed or humanoid.WalkSpeed)
        if sprint then speed=speed*math.clamp(V.SprintMultiplier,1,4) end
        if speedOn then
            local desired=(V.SpeedMode=="Humanoid" or not V.SpeedEnabled) and speed or original.WalkSpeed
            if humanoid.WalkSpeed~=desired then humanoid.WalkSpeed=desired end
        elseif speedActive then
            humanoid.WalkSpeed=original.WalkSpeed; speedActive=false
        end
        if V.JumpEnabled then
            if not jumpActive then
                original.UseJumpPower=humanoid.UseJumpPower
                original.JumpPower,original.JumpHeight=humanoid.JumpPower,humanoid.JumpHeight
                jumpActive=true
            end
            humanoid.UseJumpPower=true; humanoid.JumpPower=math.clamp(V.JumpValue,1,250)
        elseif jumpActive then
            humanoid.UseJumpPower=original.UseJumpPower
            humanoid.JumpPower=original.JumpPower; humanoid.JumpHeight=original.JumpHeight
            jumpActive=false
        end
        local camera=Workspace.CurrentCamera
        if V.FlyEnabled and camera and not root.Anchored then
            createFly()
            if flyVelocity and flyOrientation then
                local input,height=movementInput()
                local direction=camera.CFrame.RightVector*input.X-camera.CFrame.LookVector*input.Z+Vector3.yAxis*height
                if direction.Magnitude>1 then direction=direction.Unit end
                local target=direction*math.clamp(V.FlySpeed,1,500)
                velocity=velocity+(target-velocity)*(1-math.exp(-math.clamp(dt,0,0.1)*math.clamp(V.FlyResponse,1,40)))
                if direction.Magnitude<0.01 and velocity.Magnitude<0.05 then velocity=Vector3.zero end
                flyVelocity.VectorVelocity=velocity
                flyOrientation.CFrame=camera.CFrame.Rotation
                humanoid.PlatformStand=true; humanoid.AutoRotate=false
                root.AssemblyAngularVelocity=Vector3.zero
            end
        else
            if flyVelocity then stopFly() end
            if V.SpeedEnabled and V.SpeedMode=="Velocity" and humanoid.MoveDirection.Magnitude>0.01 and not root.Anchored then
                local direction=humanoid.MoveDirection
                local horizontal=Vector3.new(direction.X,0,direction.Z)
                if horizontal.Magnitude>1 then horizontal=horizontal.Unit end
                local old=root.AssemblyLinearVelocity
                root.AssemblyLinearVelocity=horizontal*speed+Vector3.new(0,old.Y,0)
            end
        end
        local limit=math.max(250,V.FlyEnabled and V.FlySpeed*3 or speed*3)
        local linear,angular=root.AssemblyLinearVelocity,root.AssemblyAngularVelocity
        local flung=not finite(linear) or not finite(angular) or linear.Magnitude>limit or angular.Magnitude>120
        if V.AntiFling and flung then
            if lastSafe and not root.Anchored then root.CFrame=lastSafe end
            root.AssemblyLinearVelocity=Vector3.zero; root.AssemblyAngularVelocity=Vector3.zero
        elseif V.AntiVoid and lastSafe and root.Position.Y<Workspace.FallenPartsDestroyHeight+35 then
            root.CFrame=lastSafe+Vector3.new(0,3,0)
            root.AssemblyLinearVelocity=Vector3.zero; root.AssemblyAngularVelocity=Vector3.zero
        elseif humanoid.FloorMaterial~=Enum.Material.Air and not humanoid.Sit and not flung then
            lastSafe=root.CFrame
        end
    end
    task.spawn(function()
        local scripts=LocalPlayer:FindFirstChild("PlayerScripts")
        local module=scripts and scripts:FindFirstChild("PlayerModule")
        local ok,controls=pcall(function() return module and require(module):GetControls() end)
        if ok then controlModule=controls end
    end)
    con(UserInputService.JumpRequest,function()
        if not V.InfiniteJump or V.MotionOwner or V.FlyEnabled or UserInputService:GetFocusedTextBox() or os.clock()-lastJump<0.12 then return end
        local _,hum=aliveRoot(LocalPlayer)
        if hum then lastJump=os.clock(); hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end)
    con(LocalPlayer.CharacterRemoving,restoreCharacter)
    con(RunService.PreSimulation,function(dt)
        local ok,err=pcall(playerStep,dt)
        if not ok then V.LastPlayerError=tostring(err); stopFly() end
    end)
    V.RestorePlayer=function()
        V.FlyEnabled=false; V.SpeedEnabled=false; V.Noclip=false; V.AntiFling=false
        restoreCharacter(); restoreCollisions(antiCollisions)
    end
    V.ResetMovement=function()
        for _,key in ipairs({"SpeedEnabled","SprintEnabled","JumpEnabled","FlyEnabled","InfiniteJump","Noclip"}) do V[key]=false end
        for _,flag in ipairs({"P.Speed","P.Sprint","P.Jump","P.Fly","P.InfiniteJump","P.Noclip"}) do
            local element=Lib:GetElement(flag)
            if element and element.Set then pcall(element.Set,element,false) end
        end
        restoreCharacter()
    end
    local tab=W:CreateTab({Name="Player",Title="Player",Icon="user"})
    V.PlayerTab=tab
    tab:AddSection("Movement")
    tab:AddToggle({Name="Speed",Flag="P.Speed",Default=false,Callback=function(x) XT.apply("P.Speed",x) end,
        Settings={Name="Speed settings",Width=270,Build=function(m)
            XT.slider(m,"Speed","P.SpeedValue",1,500," studs/s")
            XT.dropdown(m,"Mode","P.SpeedMode")
        end}})
    tab:AddToggle({Name="Sprint",Flag="P.Sprint",Default=false,Callback=function(x) XT.apply("P.Sprint",x) end,
        Settings={Name="Sprint settings",Width=250,Build=function(m) XT.slider(m,"Multiplier","P.SprintMultiplier",1,4,"",1) end}})
    tab:AddToggle({Name="Jump power",Flag="P.Jump",Default=false,Callback=function(x) XT.apply("P.Jump",x) end,
        Settings={Name="Jump settings",Width=250,Build=function(m) XT.slider(m,"Power","P.JumpValue",1,250,"") end}})
    XT.toggle(tab,"Infinite jump","P.InfiniteJump")
    XT.toggle(tab,"Noclip","P.Noclip")
    tab:AddToggle({Name="Fly",Flag="P.Fly",Default=false,Callback=function(x)
        XT.apply("P.Fly",x); if not x then stopFly() end
    end,Settings={Name="Fly settings",Width=270,Build=function(m)
        XT.slider(m,"Speed","P.FlySpeed",1,500," studs/s")
        XT.slider(m,"Response","P.FlyResponse",1,40,"")
    end}})
    tab:AddSection("Protection")
    XT.toggle(tab,"Anti Fling","P.AntiFling")
    XT.toggle(tab,"Anti Sit","P.AntiSit")
    XT.toggle(tab,"Anti Void","P.AntiVoid")
    tab:AddButton({Name="Reset velocity",Text="Reset velocity",Callback=function()
        local part=aliveRoot(LocalPlayer)
        if part then part.AssemblyLinearVelocity=Vector3.zero; part.AssemblyAngularVelocity=Vector3.zero end
    end})
end

initPlayer()

local function initServerPlayers()
    local PlayersTab = W:CreateTab({Name = "Players", Title = "Players", Icon = "users"})
    local spectate = {
        Player = nil,
        Subject = nil,
        CameraType = nil,
        OriginalSubject = nil,
        OriginalCameraType = nil,
    }
    local FLING_POWER = 550
    local FLING_DURATION = 0.14

    local function notify(text)
        pcall(function()
            Lib:Notify({Title = "Players", Text = tostring(text), Duration = 3})
        end)
    end

    local ROLE_ALIASES = {murderer = "Murderer", murdererteam = "Murderer", sheriff = "Sheriff",
        sheriffteam = "Sheriff", hero = "Hero", innocent = "Innocent", dead = "Dead"}

    local function getRoleText(plr)
        if not plr then return "Unknown" end
        local ok, result = pcall(function()
            local d = playerData(plr)
            local character = plr.Character
            local hum = character and character:FindFirstChildOfClass("Humanoid")
            if (d and d.Dead == true) or (hum and hum.Health <= 0) then return "Dead" end
            local raw = d and type(d.Role) == "string" and d.Role ~= "" and d.Role or nil
            local role = raw and (ROLE_ALIASES[string.lower(raw)] or raw) or nil
            if role == "Murderer" or role == "Sheriff" or role == "Hero" then return role end
            if role then return role end
            return isRoundActive() and "Innocent" or "Lobby"
        end)
        return ok and tostring(result) or "Unknown"
    end

    -- Spectating is a small state machine driven by one Heartbeat loop (below):
    -- it re-applies the camera whenever something else changes it, keeps the view
    -- on the body / last position while the target is dead, and resumes on respawn.
    -- Cancelling is immediate and final.
    local function restoreCamera()
        if spectate.CharacterConnection then
            pcall(function() spectate.CharacterConnection:Disconnect() end)
            spectate.CharacterConnection = nil
        end
        local originalType, originalSubject = spectate.OriginalCameraType, spectate.OriginalSubject
        spectate.Player, spectate.Subject, spectate.CameraType = nil, nil, nil
        spectate.OriginalSubject, spectate.OriginalCameraType = nil, nil
        spectate.Frozen, spectate.LastCFrame = false, nil
        local camera = Workspace.CurrentCamera
        if not camera then return end
        local localHum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        local subject = (originalSubject and originalSubject.Parent and originalSubject) or localHum
        pcall(function()
            if originalType and originalType ~= Enum.CameraType.Scriptable then
                camera.CameraType = originalType
            else
                camera.CameraType = Enum.CameraType.Custom
            end
            -- With no valid subject (we are dead) drop the target's humanoid; the
            -- default camera script picks our character up on respawn.
            camera.CameraSubject = subject
        end)
    end

    local function watchPlayer(plr)
        if not plr or plr == LocalPlayer then return end
        if spectate.Player == plr then
            restoreCamera()
            notify("Spectate disabled")
            return
        end
        -- Switching targets keeps the user's real camera, not the previous target.
        if spectate.Player then restoreCamera() end
        local camera = Workspace.CurrentCamera
        if not camera then return end
        spectate.CameraType = camera.CameraType
        spectate.OriginalCameraType = camera.CameraType
        spectate.OriginalSubject = camera.CameraSubject
        spectate.Subject, spectate.Frozen, spectate.LastCFrame = nil, false, camera.CFrame
        spectate.Player = plr
        notify("Watching: " .. plr.DisplayName)
    end

    local function teleportToPlayer(plr)
        if not plr or plr == LocalPlayer then return end
        local localRoot = aliveRoot(LocalPlayer)
        local targetRoot = aliveRoot(plr)
        if not localRoot or not targetRoot then
            notify("Teleport unavailable: character not found")
            return
        end
        local destination = targetRoot.CFrame * CFrame.new(0, 2.5, -3.5)
        local previousMotion = V.acquireMotion and V.acquireMotion("PlayerTeleport") or nil
        local ok = pcall(function()
            localRoot.CFrame = CFrame.lookAt(destination.Position, targetRoot.Position)
            localRoot.AssemblyLinearVelocity = Vector3.zero
            localRoot.AssemblyAngularVelocity = Vector3.zero
        end)
        if previousMotion and V.releaseMotion then V.releaseMotion(previousMotion) end
        notify(ok and ("Teleported to " .. plr.DisplayName) or "Teleport failed")
    end

    local flingBusy = false
    local FLING_SECONDS = 2
    -- Fling ported from the KILASIK / zqyDSUWX mechanism: the local root is
    -- pinned onto the target part, alternates above/below it with huge linear and
    -- angular velocity, held in place by a BodyVelocity, with void-kill disabled.
    local function flingPlayer(plr)
        if not plr or plr == LocalPlayer or flingBusy then return end
        local localRoot, targetRoot = aliveRoot(LocalPlayer), aliveRoot(plr)
        if not localRoot or not targetRoot or localRoot.Anchored or targetRoot.Anchored then return end
        local seatedTarget = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
        if seatedTarget and seatedTarget.Sit then return end
        local motion = V.acquireMotion("PlayerFling")
        if not motion then return end
        flingBusy = true
        task.spawn(function()
            local character, targetCharacter = LocalPlayer.Character, plr.Character
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local targetHumanoid = targetCharacter:FindFirstChildOfClass("Humanoid")
            local targetHead = targetCharacter:FindFirstChild("Head")
            local camera = Workspace.CurrentCamera
            local homeCF = localRoot.CFrame
            local autoRotate = humanoid and humanoid.AutoRotate
            local oldSubject = camera and camera.CameraSubject
            local oldDestroyHeight = Workspace.FallenPartsDestroyHeight
            local holder
            local moved = false
            local ok, err = xpcall(function()
                local function alive()
                    return not (V.Destroying or V.Destroyed or V.MotionOwner ~= motion
                        or LocalPlayer.Character ~= character or plr.Character ~= targetCharacter
                        or not plr.Parent or not localRoot.Parent or not targetRoot.Parent
                        or (humanoid and humanoid.Health <= 0))
                end
                local function place(offset, angle)
                    local cf = CFrame.new(targetRoot.Position) * offset * angle
                    localRoot.CFrame = cf
                    pcall(function() character:PivotTo(cf) end)
                    localRoot.Velocity = Vector3.new(9e7, 9e8, 9e7)
                    localRoot.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
                end
                local function step(offset, angle)
                    place(offset, angle)
                    RunService.Heartbeat:Wait()
                    return alive()
                end

                if camera then
                    if targetHead then camera.CameraSubject = targetHead
                    elseif targetHumanoid then camera.CameraSubject = targetHumanoid end
                end
                Workspace.FallenPartsDestroyHeight = 0 / 0
                holder = Instance.new("BodyVelocity")
                holder.Velocity = Vector3.zero
                holder.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                holder.Parent = localRoot
                if humanoid then
                    humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
                    humanoid.AutoRotate = false
                end

                local started, angle = os.clock(), 0
                while os.clock() - started < FLING_SECONDS and alive() do
                    local speed = targetRoot.Velocity.Magnitude
                    if speed > 120 then moved = true end
                    local moveDir = targetHumanoid and targetHumanoid.MoveDirection or Vector3.zero
                    local walk = targetHumanoid and targetHumanoid.WalkSpeed or 16
                    local sequence
                    if speed < 50 then
                        angle = angle + 100
                        local rot = CFrame.Angles(math.rad(angle), 0, 0)
                        local lead = moveDir * speed / 1.25
                        sequence = {
                            {CFrame.new(0, 1.5, 0) + lead, rot},
                            {CFrame.new(0, -1.5, 0) + lead, rot},
                            {CFrame.new(0, 1.5, 0) + lead, rot},
                            {CFrame.new(0, -1.5, 0) + lead, rot},
                            {CFrame.new(0, 1.5, 0) + moveDir, rot},
                            {CFrame.new(0, -1.5, 0) + moveDir, rot},
                        }
                    else
                        local flat, upright = CFrame.Angles(0, 0, 0), CFrame.Angles(math.rad(90), 0, 0)
                        sequence = {
                            {CFrame.new(0, 1.5, walk), upright},
                            {CFrame.new(0, -1.5, -walk), flat},
                            {CFrame.new(0, 1.5, walk), upright},
                            {CFrame.new(0, -1.5, 0), upright},
                            {CFrame.new(0, -1.5, 0), flat},
                            {CFrame.new(0, -1.5, 0), upright},
                            {CFrame.new(0, -1.5, 0), flat},
                        }
                    end
                    for _, entry in ipairs(sequence) do
                        if not step(entry[1], entry[2]) then break end
                    end
                end
                if targetRoot.Parent and targetRoot.Velocity.Magnitude > 120 then moved = true end
            end, debug.traceback)

            -- Cleanup runs after success, errors, target leaving or character change.
            if holder then pcall(function() holder:Destroy() end) end
            pcall(function()
                if humanoid and humanoid.Parent then
                    humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
                    humanoid.AutoRotate = autoRotate
                end
            end)
            pcall(function()
                if camera then
                    camera.CameraSubject = (oldSubject and oldSubject.Parent) and oldSubject or humanoid
                end
            end)
            pcall(function()
                if LocalPlayer.Character ~= character or not localRoot.Parent then return end
                local returnStarted = os.clock()
                repeat
                    local back = homeCF * CFrame.new(0, 0.5, 0)
                    localRoot.CFrame = back
                    pcall(function() character:PivotTo(back) end)
                    if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.GettingUp) end
                    for _, part in ipairs(character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.Velocity = Vector3.zero
                            part.RotVelocity = Vector3.zero
                        end
                    end
                    RunService.Heartbeat:Wait()
                until not localRoot.Parent
                    or (localRoot.Position - homeCF.Position).Magnitude < 25
                    or os.clock() - returnStarted > 3
                localRoot.AssemblyLinearVelocity = Vector3.zero
                localRoot.AssemblyAngularVelocity = Vector3.zero
            end)
            Workspace.FallenPartsDestroyHeight = oldDestroyHeight
            V.releaseMotion(motion)
            flingBusy = false
            -- Silent by design: no notifications for fling results.
            if not ok then V.LastFlingError = tostring(err) end
        end)
    end

    -- Murderer-only: kill one chosen player with the knife (same touch path as
    -- Kill aura / Kill all, but limited to the selected target).
    local function canKillPlayer(plr)
        if not plr or plr == LocalPlayer or not isLocalMurderer() then return false end
        local ok, allowed = pcall(V.CanAttackPlayer, plr)
        if not ok then V.LastMurderError = tostring(allowed) end
        return ok and allowed == true
    end

    local function killPlayer(plr)
        if not canKillPlayer(plr) then
            if not isLocalMurderer() then notify("Kill is available only for the murderer") end
            return
        end
        if type(firetouchinterest) ~= "function" then
            notify("Kill unavailable: this executor does not support firetouchinterest")
            return
        end
        local character = plr.Character
        local attempted = false
        for _ = 1, 4 do
            if not canKillPlayer(plr) or plr.Character ~= character then break end
            local ok, hit = pcall(V.AttackPlayer, plr)
            if not ok then V.LastMurderError = tostring(hit) end
            if ok and hit then
                attempted = true
                task.wait(0.25)
            else
                task.wait(0.12)
            end
        end
        if not attempted and canKillPlayer(plr) then
            notify("Attack was not sent: check the knife and try again")
        end
    end

    -- The original remains the network character. Only this client drives the copy.
    local invis = {Active = false, Busy = false, Token = 0, Connections = {}, Tracks = {}, Toggle = nil}
    local invisOff
    invisOff = function(skipReturn)
        invis.Token = invis.Token + 1
        invis.Active = false
        clearCons(invis.Connections)
        local original, clone, root = invis.Original, invis.Clone, invis.Root
        local cloneRoot = clone and clone:FindFirstChild("HumanoidRootPart")
        local destination = cloneRoot and cloneRoot.CFrame or invis.Home
        for _, track in pairs(invis.Tracks) do
            pcall(function() track:Stop(0); track:Destroy() end)
        end
        table.clear(invis.Tracks)
        if root and root.Parent then
            pcall(function()
                if not skipReturn and LocalPlayer.Character == original and destination then
                    original:PivotTo(destination * root.CFrame:Inverse() * original:GetPivot())
                end
                root.Anchored = invis.WasAnchored == true
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
            end)
        end
        local camera = Workspace.CurrentCamera
        if camera and clone and camera.CameraSubject and camera.CameraSubject:IsDescendantOf(clone) then
            local current = LocalPlayer.Character
            camera.CameraSubject = current and current:FindFirstChildOfClass("Humanoid") or invis.CameraSubject
            camera.CameraType = invis.CameraType or Enum.CameraType.Custom
        end
        if clone then clone:Destroy() end
        if invis.Platform then invis.Platform:Destroy() end
        if invis.Motion then V.releaseMotion(invis.Motion) end
        invis.Clone, invis.Platform, invis.Original, invis.Root, invis.Motion = nil, nil, nil, nil, nil
        V.VisualCopyActive = false
        if invis.Toggle then invis.Toggle:Set(false, true) end
    end

    local function invisOn()
        if invis.Active then return true end
        if invis.Busy then return false, "Character setup is still finishing" end
        local root, humanoid, character = aliveRoot(LocalPlayer)
        if not root then return false, "Character is not ready" end
        local motion = V.acquireMotion("VisualCopy")
        if not motion then return false, "Another movement action is running" end
        invis.Motion, invis.Busy = motion, true
        invis.Token = invis.Token + 1
        local token = invis.Token
        local archived = character.Archivable
        local ok, problem = pcall(function()
            local scripts = LocalPlayer:FindFirstChild("PlayerScripts")
            local module = scripts and scripts:FindFirstChild("PlayerModule")
            local controls = module and require(module):GetControls()
            if not controls or type(controls.GetMoveVector) ~= "function" then error("Player controls unavailable") end
            if invis.Token ~= token or V.Destroying or LocalPlayer.Character ~= character or humanoid.Health <= 0 then error("Character changed or setup cancelled") end
            character.Archivable = true
            local clone = character:Clone()
            character.Archivable = archived
            if not clone then error("Cannot clone character") end
            invis.Clone = clone
            invis.Original, invis.Root = character, root
            invis.Home, invis.WasAnchored = root.CFrame, root.Anchored
            clone.Name = "Waraku_VisualCopy"
            local animate = character:FindFirstChild("Animate")
            local isR15 = character:FindFirstChild("UpperTorso") ~= nil
            local ids = isR15 and {idle="507766388",walk="507777826",jump="507765000",fall="507767968"}
                or {idle="180435571",walk="180426354",jump="125750702",fall="180436148"}
            for state in pairs(ids) do
                local folder = animate and animate:FindFirstChild(state)
                local animation = folder and folder:FindFirstChildWhichIsA("Animation", true)
                ids[state] = animation and animation.AnimationId or ("rbxassetid://" .. ids[state])
            end
            for _, object in ipairs(clone:GetDescendants()) do
                if object:IsA("LuaSourceContainer") or object:IsA("Tool") or object:IsA("Animator")
                    or object:IsA("Highlight") or object:IsA("Sound") or object:IsA("BillboardGui")
                    or object.Name:sub(1,7) == "Waraku_" then
                    object:Destroy()
                elseif object:IsA("BasePart") then
                    object.Anchored = false
                    object.LocalTransparencyModifier = 0
                    object.Transparency = object.Name == "HumanoidRootPart" and 1 or math.max(0.5, object.Transparency)
                    object.CanTouch = false
                    object.AssemblyLinearVelocity = Vector3.zero
                    object.AssemblyAngularVelocity = Vector3.zero
                elseif object:IsA("Decal") then object.Transparency = math.max(0.5, object.Transparency) end
            end
            local copyHum = clone:FindFirstChildOfClass("Humanoid")
            local copyRoot = clone:FindFirstChild("HumanoidRootPart")
            if not copyHum or not copyRoot then error("Clone is incomplete") end
            copyHum.Health = copyHum.MaxHealth
            copyHum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            clone.Parent = Workspace
            local animator = Instance.new("Animator")
            animator.Parent = copyHum
            for state, id in pairs(ids) do
                local animation = Instance.new("Animation")
                animation.AnimationId = id
                local loaded, track = pcall(animator.LoadAnimation, animator, animation)
                animation:Destroy()
                if loaded then
                    track.Looped = state ~= "jump"
                    track.Priority = state == "idle" and Enum.AnimationPriority.Idle or Enum.AnimationPriority.Movement
                    invis.Tracks[state] = track
                end
            end
            local platform = Instance.new("Part")
            invis.Platform = platform
            platform.Name = "Waraku_InvisibilityPlatform"
            platform.Size = Vector3.new(30, 2, 30)
            platform.Anchored, platform.CanCollide = true, true
            platform.CFrame = CFrame.new(root.Position + Vector3.new(0, 10000, 0))
            platform.Parent = Workspace
            local height = humanoid.HipHeight + root.Size.Y * 0.5 + 1
            if not isR15 then height = height + 2 end
            local parked = platform.CFrame * CFrame.new(0, height, 0)
            root.CFrame = parked
            root.Anchored = true
            local camera = Workspace.CurrentCamera
            invis.CameraSubject, invis.CameraType = camera.CameraSubject, camera.CameraType
            camera.CameraSubject, camera.CameraType = copyHum, Enum.CameraType.Custom
            invis.Active, V.VisualCopyActive = true, true
            local currentState
            invis.Connections[#invis.Connections+1] = RunService.PreSimulation:Connect(function()
                if not invis.Active then return end
                if LocalPlayer.Character ~= character or not root.Parent or humanoid.Health <= 0 then invisOff(true); return end
                if not copyRoot.Parent or copyHum.Health <= 0 then invisOff(); return end
                root.CFrame = parked
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
                local move = UserInputService:GetFocusedTextBox() and Vector3.zero or controls:GetMoveVector()
                copyHum:Move(move, true)
                copyHum.WalkSpeed = V.SpeedEnabled and V.SpeedValue or humanoid.WalkSpeed
                if humanoid.Jump then copyHum.Jump = true end
                local state = copyHum:GetState()
                local name = state == Enum.HumanoidStateType.Jumping and "jump"
                    or state == Enum.HumanoidStateType.Freefall and "fall"
                    or move.Magnitude > 0.05 and "walk" or "idle"
                if name ~= currentState then
                    for key, track in pairs(invis.Tracks) do
                        if key ~= name then track:Stop(0.15) end
                    end
                    local track = invis.Tracks[name]
                    if track then track:Play(0.15) end
                    currentState = name
                end
            end)
            invis.Connections[#invis.Connections+1] = UserInputService.JumpRequest:Connect(function()
                if invis.Active and not UserInputService:GetFocusedTextBox() then copyHum.Jump = true end
            end)
            invis.Connections[#invis.Connections+1] = humanoid.Died:Connect(function() invisOff(true) end)
        end)
        character.Archivable = archived
        invis.Busy = false
        if not ok then
            invisOff()
            V.LastInvisibilityError = tostring(problem)
            return false, tostring(problem)
        end
        return true
    end
    if Lib.NoSaveFlags then Lib.NoSaveFlags["P.Invisible"] = true end
    invis.Toggle = V.PlayerTab:AddToggle({Name = "Invisibility (visual copy)", Flag = "P.Invisible", Default = false,
        Callback = function(value)
            if not value then invisOff(); return end
            local ok, reason = invisOn()
            if not ok then
                if invis.Toggle then invis.Toggle:Set(false, true) end
                notify(reason or "Invisibility unavailable")
            end
        end})
    con(LocalPlayer.CharacterRemoving, function(character)
        if invis.Original == character then invisOff(true) end
    end)
    con(LocalPlayer.CharacterAdded, function() if invis.Active then invisOff(true) end end)

    -- BEGIN SERVER PLAYERS UI
    assert(type(PlayersTab.AddPlayerList) == "function",
        "WolfUi has no player cards API. Load the matching WolfUi.lua from this archive.")
    local playerList = PlayersTab:AddPlayerList({
        Name = "Players on server",
        Flag = "P.ServerPlayers",
        Width = 380,
        Height = 390,
        RowHeight = 64,
        FitViewport = true,
        IncludeSelf = false,
        Placeholder = "Find player...",
        GetRole = getRoleText,
        ImmediateRoles = true,
        OnWatch = watchPlayer,
        OnTeleport = teleportToPlayer,
        OnFling = flingPlayer,
        OnKill = killPlayer,
        CanKill = canKillPlayer,
    })
    con(Gameplay.PlayerDataChanged.OnClientEvent, function()
        task.defer(function() if not playerList.Destroyed then playerList:Refresh() end end)
    end)
    -- END SERVER PLAYERS UI

    con(Players.PlayerRemoving, function(plr)
        if spectate.Player == plr then
            restoreCamera()
        end
    end)

    con(RunService.Heartbeat, function()
        local target = spectate.Player
        if not target then return end
        if target.Parent ~= Players then restoreCamera() return end
        local camera = Workspace.CurrentCamera
        if not camera then return end

        local character = target.Character
        local hum = character and character:FindFirstChildOfClass("Humanoid")
        local function follow()
            if spectate.Subject ~= hum or camera.CameraSubject ~= hum or camera.CameraType ~= Enum.CameraType.Custom then
                spectate.Subject = hum
                pcall(function()
                    camera.CameraType = Enum.CameraType.Custom
                    camera.CameraSubject = hum
                end)
            end
        end
        if hum and hum.Parent and hum.Health > 0 then
            spectate.Frozen = false
            follow()
            spectate.LastCFrame = camera.CFrame
            return
        end
        -- Target is dead or between respawns: stay on the body while it exists,
        -- otherwise hold the last view until the new character appears.
        local body = character and (character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart"))
        if hum and hum.Parent and body and body.Parent then
            spectate.Frozen = false
            follow()
            spectate.LastCFrame = camera.CFrame
        elseif spectate.LastCFrame then
            spectate.Frozen = true
            pcall(function()
                camera.CameraType = Enum.CameraType.Scriptable
                camera.CFrame = spectate.LastCFrame
            end)
        end
    end)

    V.RestoreServerPlayers = function()
        pcall(invisOff)
        if spectate.Player then restoreCamera() end
        if playerList and playerList.Destroy then pcall(playerList.Destroy, playerList) end
    end
end

initServerPlayers()

local function initUtilities()
                                                                                  
    V.VoteDupeEnabled=true
    V.VoteAutoEnabled=false
    V.VotePopupEnabled=true
    V.VoteDupeCount=math.clamp(math.floor(tonumber(V.VoteDupeCount) or 10),1,100)
    V.VoteMaps=type(V.VoteMaps)=="table" and V.VoteMaps or {}
    XT.specs["U.VotePopup"]={key="VotePopupEnabled",kind="bool"}
    XT.specs["U.VoteAuto"]={key="VoteAutoEnabled",kind="bool"}
    XT.specs["U.VoteDupe"]={key="VoteDupeEnabled",kind="bool"}
    XT.specs["U.VoteDupeCount"]={key="VoteDupeCount",kind="num",min=1,max=100,a=math.floor}
    XT.specs["U.VoteMaps"]={key="VoteMaps",kind="strlist",limit=math.huge}
    for _,flag in ipairs({"U.VotePad","U.Bhop","U.BhopMode","U.BhopMax","U.BhopGain","U.Spin","U.SpinSpeed",
        "U.SpinDirection","U.Target","U.Spectate","U.Follow","U.FollowDistance"}) do
        Lib.Flags[flag]=nil
        if Lib.NoSaveFlags then Lib.NoSaveFlags[flag]=true end
    end
    local catalog,pads,padConns,worldConns={},{},{},{}
    local session,alive,pending=0,true,false
    local running,completed=false,false
    local active,spot,home,homeCharacter,motion
    local holdConn,tallyConn,spawnConn
    local spawnReadyConns = {}
    local used,mark,observed=0,0,0
    local confirmedVotes=0
    local phase,cycleCharacter,lastConfirmed="Idle",nil,nil
    local grid,status,schedule,refreshWorld,scanVoting
    local discoveryAt=-1
    local entriesByModel={}
    local guisByAdornee={}
    local guiCache,guiWatchConns={},{}
    local guiRoot,guiCacheDirty,guiCacheAt=nil,true,-10
    local votingSignature=""
    local voteGuiSeenAt=-10
    local voteNotice,popupDismissed,popupRoundOpen=nil,false,false
    local popupId,popupStartedVote=0,false
    local popupRetryAt=0
    local syncVoteNotice,choosePopupMap
    local popupEntries={}
    local dirty=true
    local aliases={hospitaliii="hospital3",hotelii="hotel2",houseii="house2",mansionii="mansion2",officeiii="office3",bankii="bank2"}
    local function key(name)
        local id=string.lower(tostring(name):gsub("<[^>]+>","")):gsub("[%s%p]","")
        return aliases[id] or id
    end
    local function addMap(name,image)
        if type(name)~="string" then return end
        name=name:gsub("<[^>]+>",""):match("^%s*(.-)%s*$")
        if name=="" or #name>100 then return end
        local id=key(name)
        local entry=catalog[id] or {name=name}
        if type(image)=="number" and image>0 then image="rbxassetid://"..tostring(image)
        elseif type(image)=="string" and image:match("^%d+$") then image="rbxassetid://"..image end
        if type(image)=="string" and image~="" then entry.image=image end
        catalog[id]=entry
    end
    local function loadMapCatalog()
        for _,name in ipairs({"Bank 2","Bio Lab","Factory","Hospital 3","Hotel 2","House 2",
            "Mansion 2","Mil Base","Office 3","Police Station","Research Facility","Workplace"}) do addMap(name) end
        local database=RS:FindFirstChild("Database")
        local sync=database and database:FindFirstChild("Sync")
        local modules=RS:FindFirstChild("Modules")
        local sources={}
        for _,parent in ipairs({RS,database or RS,sync or RS,modules or RS}) do
            for _,name in ipairs({"Map","Maps","MapData"}) do
                local object=parent:FindFirstChild(name)
                if object then sources[object]=true end
            end
        end
        for object in pairs(sources) do
            if object:IsA("ModuleScript") then
                local ok,data=pcall(require,object)
                if ok and type(data)=="table" then
                    data=type(data.Maps)=="table" and data.Maps or data
                    for id,entry in pairs(data) do
                        if type(entry)=="table" then
                            local name=entry.MapName or entry.DisplayName or entry.Name or (type(id)=="string" and id)
                            addMap(name,entry.Thumbnail or entry.Image or entry.ImageId or entry.Icon)
                        elseif type(entry)=="string" then addMap(type(id)=="number" and entry or id) end
                    end
                end
            elseif object:IsA("Folder") or object:IsA("Model") then
                for _,child in ipairs(object:GetChildren()) do
                    if child:IsA("Model") or child:IsA("Folder") then addMap(child.Name) end
                end
            end
        end
    end

    local function disconnect(c) if c then pcall(function() c:Disconnect() end) end end
    local function clearConnections(list)
        for _,c in pairs(list) do disconnect(c) end
        table.clear(list)
    end
    local function dropSessionConnections()
        disconnect(holdConn); disconnect(tallyConn); disconnect(spawnConn)
        holdConn,tallyConn,spawnConn=nil,nil,nil
        clearConnections(spawnReadyConns)
    end
    local function setStatus(text)
        V.VoteDupeStatus=text
        if voteNotice and not voteNotice.Destroyed then voteNotice:SetText(text) end
        if status then status:SetText(text.."\nVotes: "..confirmedVotes.."/"..V.VoteDupeCount.." | Respawns: "..used) end
    end
    local function restoreHome()
        local char=LocalPlayer.Character
        local root=char and char:FindFirstChild("HumanoidRootPart")
        if not root or not home or not motion or V.MotionOwner~=motion then return end
        root.CFrame=home
        root.AssemblyLinearVelocity=Vector3.zero
        root.AssemblyAngularVelocity=Vector3.zero
    end
    local function finish(reason,restore)
        session=session+1                                                              
        dropSessionConnections()
        if restore then restoreHome() end
        if motion then V.releaseMotion(motion) end
        motion,home,homeCharacter,active,spot=nil,nil,nil,nil,nil
        running=false
        V.VoteRespawning=false
        V.VoteDupeRunning=false
        queueRefreshStatic()
        phase,cycleCharacter="Idle",nil
        if reason then setStatus(reason) end
    end
    local function selected(name)
        for _,value in ipairs(V.VoteMaps) do if key(value)==key(name) then return true end end
        return false
    end
    local function guiOpen(gui)
        return gui and gui.Parent and (not gui:IsA("LayerCollector") or gui.Enabled)
    end
    local function ready(entry)
        if not entry or not entry.pad or not entry.pad.Parent or not entry.title or not entry.tally then return false end
        local name=entry.title.Text:gsub("<[^>]+>",""):match("^%s*(.-)%s*$")
        return guiOpen(entry.titleGui) and guiOpen(entry.tallyGui)
            and name~="" and name~="MAP NAME" and name~="???" and name~="..."
            and entry.tally.Text:match("%d+")~=nil
    end
    local function windowOpen()
        for _,entry in ipairs(pads) do if ready(entry) then return true end end
        return false
    end
    local function tallyOf(entry)
        return tonumber(entry.tally.Text:gsub("<[^>]+>",""):match("%d+")) or 0
    end
    local function refreshGrid()
        if not grid or not dirty then return end
        dirty=false
        local rows={}
        for _,entry in pairs(catalog) do
            rows[#rows+1]={Id=entry.name,Name=entry.name,Image=entry.image or ""}
        end
        table.sort(rows,function(a,b) return a.Name:lower()<b.Name:lower() end)
        grid:SetCards(rows)
        grid:Set(V.VoteMaps,true)
    end
    local function learnPads()
        for _,entry in ipairs(pads) do
            if ready(entry) then
                local old=catalog[key(entry.title.Text)]
                local image=entry.icon and entry.icon.Image or nil
                if not old or (image and image~="" and old.image~=image) then
                    addMap(entry.title.Text,image); dirty=true
                end
            end
        end
        refreshGrid()
    end
    local function standPoint(pad)
        local params=RaycastParams.new()
        params.FilterType=Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances=LocalPlayer.Character and {LocalPlayer.Character} or {}
        local hit=Workspace:Raycast(pad.Position+Vector3.new(0,8,0),Vector3.new(0,-40,0),params)
        local hum=LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
        local char=LocalPlayer.Character
        local root=char and char:FindFirstChild("HumanoidRootPart")
        local offset=(hum and hum.HipHeight or 2)+(root and root.Size and root.Size.Y/2 or 1)
        if hum and hum.RigType==Enum.HumanoidRigType.R6 then
            local leg=char:FindFirstChild("Left Leg") or char:FindFirstChild("Right Leg")
            offset=offset+(leg and leg.Size.Y or 2)
        end
        return Vector3.new(pad.Position.X,hit and hit.Position.Y+offset or pad.Position.Y+offset,pad.Position.Z)
    end
    local function plant(point)
        local char=LocalPlayer.Character
        local root=char and char:FindFirstChild("HumanoidRootPart")
        if not root or not motion or V.MotionOwner~=motion then return false end
        root.CFrame=CFrame.new(point)
        root.AssemblyLinearVelocity=Vector3.zero
        root.AssemblyAngularVelocity=Vector3.zero
        return true
    end
    local function killSelf()
        local char=LocalPlayer.Character
        local hum=char and char:FindFirstChildWhichIsA("Humanoid")
        if hum then
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.Dead) end)
            pcall(function() hum.Health=0 end)
        elseif char then pcall(function() char:BreakJoints() end) end
    end
    local function begin()
        local list={}
        for _,entry in ipairs(pads) do
            if ready(entry) and selected(entry.title.Text) then list[#list+1]=entry end
        end
        if #list==0 then setStatus("Waiting for selected maps"); return end
        local char=LocalPlayer.Character
        local root=char and char:FindFirstChild("HumanoidRootPart")
        local hum=char and char:FindFirstChildWhichIsA("Humanoid")
        if not root or (hum and hum.Health<=0) then
            setStatus("Waiting for character")
            task.delay(0.1,function() if alive and V.VoteAutoEnabled then schedule() end end)
            return
        end
        motion=V.acquireMotion("Vote")
        if not motion then setStatus("Waiting for movement"); task.delay(0.1,function() if alive then schedule() end end); return end
        session=session+1
        local id=session
        active=list[math.random(1,#list)]
        local entry=active
        local targetName=entry.title.Text
        spot=standPoint(entry.pad)
        home,homeCharacter=root.CFrame,char
        mark,used,observed=tallyOf(entry),0,0
        confirmedVotes=0
        running=true
        V.VoteDupeRunning=V.VoteDupeEnabled==true
        lastConfirmed=nil
        local function valid()
            local boardReady=ready(entry)
            local respawnGrace=phase=="Respawn" and not entry.voteClosed and os.clock()-voteGuiSeenAt<3
            return alive and id==session and running and V.VoteAutoEnabled
                and ((boardReady and entry.title.Text==targetName) or respawnGrace)
                and selected(targetName) and V.MotionOwner==motion
        end
        local function touchPad(c)
            local r=c and c:FindFirstChild("HumanoidRootPart")
            if r and type(firetouchinterest)=="function" then
                pcall(firetouchinterest,r,entry.pad,0)
                pcall(firetouchinterest,r,entry.pad,1)
            end
        end
        local nextTouch, touchRetries = 0, 0
        local function submit(c)
            if not valid() or LocalPlayer.Character~=c then return false end
            if phase=="Confirm" and cycleCharacter==c then return true end
            local h=c:FindFirstChildWhichIsA("Humanoid")
            if not h or h.Health<=0 then return false end
            cycleCharacter=c
            mark=tallyOf(entry)
            phase="Confirm"
            nextTouch, touchRetries = os.clock() + 0.12, 0
            clearConnections(spawnReadyConns)
            spot=standPoint(entry.pad)
            if not plant(spot) then return false end
            touchPad(c)
            if not valid() or phase~="Confirm" then return true end
            setStatus("Waiting for vote count: "..targetName)
            task.delay(8,function()
                if valid() and phase=="Confirm" and cycleCharacter==c then
                    completed=true
                    finish("No vote count increase; repeat was not confirmed",true)
                end
            end)
            return true
        end
                                                                                            
        local checkTally
        holdConn=RunService.Heartbeat:Connect(function()
            if not alive or id~=session then return end
            if not valid() then finish("Voting stopped",true); return end
            if checkTally then checkTally() end
            if not valid() then return end
            if phase=="Respawn" and ready(entry) then
                local current=LocalPlayer.Character
                local hum=current and current:FindFirstChildWhichIsA("Humanoid")
                if current~=cycleCharacter and hum and hum.Health>0 and current:FindFirstChild("HumanoidRootPart") then
                    V.VoteRespawning=false;V.VisualRespawnQuietUntil=os.clock()+0.20
                    if not submit(current) then finish("Respawn character is not ready",true) end
                end
            end
            if phase~="Confirm" then return end
            local c=LocalPlayer.Character
            local r=c and c:FindFirstChild("HumanoidRootPart")
            local h=c and c:FindFirstChildWhichIsA("Humanoid")
            if c~=cycleCharacter or not r or not h or h.Health<=0 then return end
            local flat=Vector3.new(r.Position.X-spot.X,0,r.Position.Z-spot.Z)
            local now = os.clock()
            if flat.Magnitude>2.5 then plant(spot) end
            -- Recover a missed touch promptly, without submitting a new cycle.
            if now >= nextTouch and touchRetries < 5 then
                nextTouch, touchRetries = now + 0.12, touchRetries + 1
                touchPad(c)
            end
        end)
        checkTally=function()
            if not valid() or phase~="Confirm" then return end
            local c=LocalPlayer.Character
            local h=c and c:FindFirstChildWhichIsA("Humanoid")
            if c~=cycleCharacter or not h or h.Health<=0 then return end
            local now=tallyOf(entry)
            if now<=mark then mark=now; return end
            observed=observed+now-mark; mark=now
            if lastConfirmed and now<=lastConfirmed then
                completed=true
                finish("Vote count did not accumulate after respawn",true)
                return
            end
            lastConfirmed=now
            confirmedVotes=confirmedVotes+1
            if not V.VoteDupeEnabled or confirmedVotes>=V.VoteDupeCount then
                completed=true; finish("Voting complete; final vote count: "..now,true); return
            end
            used=used+1
            V.VoteRespawning=true
            phase="Respawn"                                                          
            setStatus("Respawning · next vote "..(confirmedVotes+1).."/"..V.VoteDupeCount)
            killSelf()
            task.delay(15,function()
                if valid() and phase=="Respawn" and cycleCharacter==c then
                    completed=true; finish("Respawn not received",true)
                end
            end)
        end
        tallyConn=entry.tally:GetPropertyChangedSignal("Text"):Connect(checkTally)
        spawnConn=LocalPlayer.CharacterAdded:Connect(function(c)
            if not valid() or (cycleCharacter==c and phase=="Confirm") then return end
            phase="Respawn"
            clearConnections(spawnReadyConns)
            local watchedHumanoid
            local function attempt()
                if not valid() or LocalPlayer.Character~=c or phase~="Respawn" then return end
                local r=c:FindFirstChild("HumanoidRootPart")
                local h=c:FindFirstChildWhichIsA("Humanoid")
                if h and h~=watchedHumanoid then
                    watchedHumanoid=h
                    spawnReadyConns[#spawnReadyConns+1]=h:GetPropertyChangedSignal("Health"):Connect(attempt)
                end
                if not r or not h or h.Health<=0 or not ready(entry) then return end
                V.VoteRespawning=false
                V.VisualRespawnQuietUntil=os.clock()+0.20
                if not submit(c) then finish("Respawn character is not ready",true) end
            end
            spawnReadyConns[#spawnReadyConns+1]=c.ChildAdded:Connect(attempt)
            attempt()
        end)
        if not submit(char) then finish("Waiting for character",true) end
    end

    local nextVotePresentation = 0
    local function settle()
        pending=false
        if not alive then return end
        if scanVoting then scanVoting() end
        if running and phase=="Respawn" and not windowOpen() and os.clock()-voteGuiSeenAt<3 then return end
        local now = os.clock()
        if not running or now >= nextVotePresentation then
            nextVotePresentation = now + 0.5
            learnPads()
            if syncVoteNotice then syncVoteNotice() end
        end
        if not windowOpen() then
            completed=false
            if running then finish("Waiting for voting",true) else setStatus("Waiting for voting") end
            return
        end
        if running and (not active or not ready(active) or not selected(active.title.Text)) then
            finish("Waiting for selected maps",true)
        end
        if V.VoteAutoEnabled and not running and not completed then begin() end
    end
    schedule=function()
        if pending or not alive then return end
        pending=true
        task.defer(settle)
    end
                                                                                      
    local function scanGuis()
        table.clear(guisByAdornee)
        local playerGui=LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if playerGui~=guiRoot then
            clearConnections(guiWatchConns)
            guiRoot=playerGui;guiCacheDirty=true
            table.clear(guiCache)
            if guiRoot then
                local function changed(object)
                    if object:IsA("SurfaceGui") or object:IsA("BillboardGui") then guiCacheDirty=true end
                end
                guiWatchConns[#guiWatchConns+1]=guiRoot.DescendantAdded:Connect(changed)
                guiWatchConns[#guiWatchConns+1]=guiRoot.DescendantRemoving:Connect(changed)
            end
        end
        if not playerGui then return end
        for _,gui in ipairs(guiCache) do if not gui.Parent then guiCacheDirty=true;break end end
        local now=os.clock()
        if guiCacheDirty or now-guiCacheAt>=2 then
            guiCacheDirty=false;guiCacheAt=now
            table.clear(guiCache)
            for _,gui in ipairs(playerGui:GetDescendants()) do
                if gui:IsA("SurfaceGui") or gui:IsA("BillboardGui") then guiCache[#guiCache+1]=gui end
            end
        end
        for _,gui in ipairs(guiCache) do
            if gui.Parent and gui.Adornee then
                local list=guisByAdornee[gui.Adornee] or {}
                guisByAdornee[gui.Adornee]=list;list[#list+1]=gui
            end
        end
    end
    local function readPad(model)
        local guis,seen={},{}
        local function add(gui)
            if gui and not seen[gui] then seen[gui]=true; guis[#guis+1]=gui end
        end
        add(model:FindFirstChild("VoteInfoGui",true))
        add(model:FindFirstChild("MapInfoGui",true))
        for _,object in ipairs(model:GetDescendants()) do
            if object:IsA("SurfaceGui") or object:IsA("BillboardGui") then add(object) end
        end
        for adornee,list in pairs(guisByAdornee) do
            if adornee==model or adornee:IsDescendantOf(model) then
                for _,gui in ipairs(list) do add(gui) end
            end
        end
        local title,tally,titleGui,tallyGui,icon,count
        local inactiveBoard=false
        for _,gui in ipairs(guis) do
            if gui.Parent and gui:IsA("LayerCollector") and gui.Enabled==false
                and gui:FindFirstChild("MapName",true) and gui:FindFirstChild("Votes",true) then inactiveBoard=true end
            if guiOpen(gui) then
                local box=gui:FindFirstChild("Container",true) or gui
                local t=box:FindFirstChild("MapName",true)
                local v=box:FindFirstChild("Votes",true)
                if t and (t:IsA("TextLabel") or t:IsA("TextButton")) then
                    local name=t.Text:gsub("<[^>]+>",""):match("^%s*(.-)%s*$")
                    if name~="" and name~="MAP NAME" and name~="???" and name~="..." and not title then title,titleGui=t,gui end
                end
                if v and (v:IsA("TextLabel") or v:IsA("TextButton")) then
                    local number=tonumber(v.Text:gsub("<[^>]+>",""):match("%d+"))
                    if number and (not count or number>count) then tally,tallyGui,count=v,gui,number end
                end
                icon=icon or gui:FindFirstChild("MapIcon",true)
            end
        end
        return title,tally,titleGui,tallyGui,icon,not (title and tally) and inactiveBoard
    end
    local function padImage(entry)
        if entry.icon and entry.icon.Image~="" then return entry.icon.Image end
        local best,score=nil,0
        for _,object in ipairs(entry.model:GetDescendants()) do
            local image
            if object:IsA("ImageLabel") or object:IsA("ImageButton") then image=object.Image
            elseif object:IsA("Decal") or object:IsA("Texture") then image=object.Texture end
            if image and image~="" then
                local name=object.Name:lower()
                local weight=(name:find("map") or name:find("thumb") or name:find("preview")) and 3 or 1
                if weight>score then best,score=image,weight end
            end
        end
        local def=entry.title and catalog[key(entry.title.Text)]
        return best or (def and def.image) or ""
    end
    scanVoting=function()
        scanGuis()
        local candidates,seen={},{}
        local function add(model)
            if model and not seen[model] then seen[model]=true; candidates[#candidates+1]=model end
        end
                                                                              
        for _,name in ipairs({"RegularLobby","Lobby","SummerLobby"}) do
            local lobby=Workspace:FindFirstChild(name)
            if lobby then
                for i=1,3 do add(lobby:FindFirstChild("VotePad"..i,true)) end
                local folder=lobby:FindFirstChild("VotePads",true)
                if folder then for _,model in ipairs(folder:GetChildren()) do add(model) end end
            end
        end
        local found,signature={},{}
        for _,model in ipairs(candidates) do
            local pad=model:IsA("BasePart") and model or model:FindFirstChild("Pad",true)
                or model:FindFirstChildWhichIsA("BasePart",true)
            if pad and pad:IsA("BasePart") then
                local entry=entriesByModel[model]
                if not entry then popupId=popupId+1;entry={model=model,PopupId=tostring(popupId)};entriesByModel[model]=entry end
                entry.pad=pad
                entry.title,entry.tally,entry.titleGui,entry.tallyGui,entry.icon,entry.voteClosed=readPad(model)
                found[#found+1]=entry
                if ready(entry) then signature[#signature+1]=model.Name..":"..entry.title.Text end
            end
        end
        for model in pairs(entriesByModel) do if not seen[model] then entriesByModel[model]=nil end end
        pads=found
        table.sort(signature)
        local value=table.concat(signature,"|")
        if value~="" then voteGuiSeenAt=os.clock() end
        if value~=votingSignature then
            votingSignature=value
            completed=false
        end
        if running and (not active or not seen[active.model] or (not ready(active) and (active.voteClosed or phase~="Respawn" or os.clock()-voteGuiSeenAt>=3))) then
            finish("Waiting for voting",true)
        end
    end
    local function bindWorld()
        if not alive then return end
        scanVoting()
        schedule()
    end
    refreshWorld=function() if alive then schedule() end end
    local function setSelection(value)
        if type(value)~="table" then return end
        XT.apply("U.VoteMaps",value)
        Lib.Flags["U.VoteMaps"]=V.VoteMaps
        if grid then grid:Set(V.VoteMaps,true) end
        for _,name in ipairs(V.VoteMaps) do
            if not catalog[key(name)] then addMap(name);dirty=true end
        end
        if #V.VoteMaps==0 and V.VoteAutoEnabled then
            local auto=Lib:GetElement("U.VoteAuto")
            if auto and auto.Set then auto:Set(false,true) end
            Lib.Flags["U.VoteAuto"]=false;XT.apply("U.VoteAuto",false)
        end
        completed=false;schedule()
    end
    local function setVoteFlag(flag,value)
        Lib.Flags[flag]=value
        local element=Lib:GetElement(flag)
        if element and element.Set then element:Set(value,true) end
        XT.apply(flag,value)
    end
    local function stopSelectedVote()
        popupStartedVote=false
        setVoteFlag("U.VoteAuto",false)
        setVoteFlag("U.VoteDupe",false)
        setSelection({})
        if running then finish("Stopped",true) else setStatus("Stopped") end
        if voteNotice and not voteNotice.Destroyed then voteNotice:SetSelected(nil) end
    end
    choosePopupMap=function(id,wantSelected)
        if not alive or not V.VotePopupEnabled then return end
        local entry=popupEntries[tostring(id)]
                                                                                  
        if wantSelected==false or (wantSelected==nil and running and active==entry) then stopSelectedVote();return end
        scanVoting()
        if not ready(entry) or entriesByModel[entry.model]~=entry then schedule();return end
        if running then finish("Changing map",true) end
        setSelection({entry.title.Text})
        setVoteFlag("U.VoteDupe",true)
        setVoteFlag("U.VoteAuto",true)
        completed=false;popupStartedVote=true
        begin()
        if voteNotice and not voteNotice.Destroyed then voteNotice:SetSelected(id) end
    end
    syncVoteNotice=function()
        local open=windowOpen()
        if not open then
            popupDismissed=false;popupRoundOpen=false;popupEntries={}
            if popupStartedVote then
                popupStartedVote=false
                local auto=Lib:GetElement("U.VoteAuto")
                if auto and auto.Set then auto:Set(false) end
                Lib.Flags["U.VoteAuto"]=false;XT.apply("U.VoteAuto",false)
            end
            if voteNotice then voteNotice:Close("ended");voteNotice=nil end
            return
        end
        if not popupRoundOpen then popupRoundOpen=true;popupDismissed=false end
        if not V.VotePopupEnabled or popupDismissed then
            if voteNotice then voteNotice:Close("disabled");voteNotice=nil end
            return
        end
        local available={}
        for _,entry in ipairs(pads) do if ready(entry) then available[#available+1]=entry end end
        table.sort(available,function(a,b) return a.model.Name<b.model.Name end)
        local rows,selectedId={},nil
        popupEntries={}
        for index=1,math.min(3,#available) do
            local entry=available[index]
            local id=entry.PopupId                                                           
            popupEntries[id]=entry
            rows[#rows+1]={Id=id,Name=entry.title.Text:gsub("<[^>]+>",""),Image=padImage(entry),Count=tallyOf(entry),
                Subtitle=running and active==entry and "Duping…" or "Click to dupe"}
            if running and active==entry then selectedId=id end
        end
        if voteNotice and (voteNotice.Destroyed or voteNotice.Closing) then voteNotice=nil end
        if not voteNotice then
            if os.clock()<popupRetryAt then return end
            if type(Lib.NotifyCards)~="function" then
                V.LastVotePopupError="Update WolfUi.lua to 5.9.3 for card notifications"
                return
            end
            local ok,notice=pcall(function()
                return Lib:NotifyCards({Title="Map vote",Text="Voting is open · choose a map",Icon="map",Cards=rows,Value=V.VoteDupeCount,
                    ValueChanged=function(value)
                        Lib.Flags["U.VoteDupeCount"]=value;XT.apply("U.VoteDupeCount",value)
                        local e=Lib:GetElement("U.VoteDupeCount");if e and e.Set then e:Set(value) end
                    end,
                    ToggleSelection=true,Callback=function(id,_,_,selected) choosePopupMap(id,selected) end,
                    OnClose=function(reason) if reason=="manual" then popupDismissed=true end end})
            end)
            if not ok or not notice then
                popupRetryAt=os.clock()+3
                V.LastVotePopupError=ok and "Notification GUI is not ready" or tostring(notice)
                if status then status:SetText("Notification error: "..V.LastVotePopupError) end
                return
            end
            V.LastVotePopupError=nil
            voteNotice=notice
        else voteNotice:SetCards(rows) end
        if voteNotice then
            voteNotice:SetValue(V.VoteDupeCount,true)
            voteNotice:SetSelected(selectedId)
            voteNotice:SetText((running or completed) and (V.VoteDupeStatus or "Duping…") or "Voting is open · choose a map")
        end
    end
    local lastAutoState,lastDupeState=false,V.VoteDupeEnabled
    local selectionState=""
    local function autoChanged()
        if lastAutoState==V.VoteAutoEnabled then return end
        lastAutoState=V.VoteAutoEnabled
        completed=false
        if V.VoteAutoEnabled then schedule() else finish("Stopped",true) end
    end
    local function dupeChanged()
        if lastDupeState==V.VoteDupeEnabled then return end
        lastDupeState=V.VoteDupeEnabled
        if running then finish("Mode changed",true) end
        completed=false; schedule()
    end
    XT.after["U.VoteAuto"]=autoChanged
    XT.after["U.VoteDupe"]=dupeChanged
    XT.after["U.VoteMaps"]=function()
        local signature=table.concat(V.VoteMaps,"\31")
        if selectionState==signature then return end
        selectionState=signature;completed=false;schedule()
    end
    XT.after["U.VotePopup"]=function()
        if V.VotePopupEnabled then popupDismissed=false end
        if syncVoteNotice then syncVoteNotice() end
    end
    local tab=W:CreateTab({Name="Vote duper",Title="Vote duper",Icon="map"})
    XT.toggle(tab,"Map vote notification","U.VotePopup")
    tab:AddToggle({Name="Vote duper",Flag="U.VoteAuto",Default=false,Callback=function(x)
        local e=Lib:GetElement("U.VoteAuto")
        if e and e.Get and e:Get()~=x then return end
        XT.apply("U.VoteAuto",x)
    end,
        Settings={Name="Voting settings",Width=270,Build=function(m)
            m:AddToggle({Name="Dupe",Flag="U.VoteDupe",Default=V.VoteDupeEnabled,Callback=function(x)
                local e=Lib:GetElement("U.VoteDupe")
                if e and e.Get and e:Get()~=x then return end
                XT.apply("U.VoteDupe",x)
            end})
            XT.slider(m,"Vote count","U.VoteDupeCount",1,100,"")
        end}})
    tab:AddButton({Name="Stop voting",Width=1/2,Compact=true,Callback=stopSelectedVote})
    tab:AddButton({Name="Clear selection",Width=1/2,Compact=true,Callback=stopSelectedVote})
    status=tab:AddParagraph({Name="Voting",Text="Select maps and enable Vote duper"})
    tab:AddButton({Name="Show map vote",Width=1/2,Compact=true,Callback=function()
        popupDismissed=false;popupRetryAt=0
        local element=Lib:GetElement("U.VotePopup")
        if element and element.Set then element:Set(true) end
        Lib.Flags["U.VotePopup"]=true;XT.apply("U.VotePopup",true)
        scanVoting();syncVoteNotice()
        if not windowOpen() then status:SetText("Waiting for actual voting; the notification opens when maps become available.") end
    end})
    loadMapCatalog()
    grid=tab:AddCardGrid({Name="Maps",Flag="U.VoteMaps",Columns=3,CardHeight=116,Height=320,
        Mode="multi",Cards={},Default=V.VoteMaps,ShowOrder=false,ShowCheck=true,
        Callback=function(value) setSelection(value) end})
    bindWorld(); refreshGrid()
    con(Workspace.ChildAdded,function(child)
        if child.Name=="SummerLobby" or child.Name=="RegularLobby" or child.Name=="Lobby" then refreshWorld() end
    end)
    con(Workspace.ChildRemoved,function(child)
        if child.Name=="SummerLobby" or child.Name=="RegularLobby" or child.Name=="Lobby" then refreshWorld() end
    end)
    con(LocalPlayer.CharacterAdded,function() if alive and not running then schedule() end end)
    con(RunService.Heartbeat,function()
        if not alive or V.Destroying or V.Destroyed then return end
        local now=os.clock()
        if now-discoveryAt<(running and 0.05 or 0.10) then return end
        discoveryAt=now
        local ok,err=pcall(settle)
        if not ok then
            V.LastVoteError=tostring(err)
            finish("Voting detection error: "..tostring(err),true)
        end
    end)
    V.RestoreUtilities=function()
        alive=false; V.VoteAutoEnabled=false; V.VoteDupeEnabled=false
        if voteNotice then voteNotice:Destroy();voteNotice=nil end
        finish("Unloaded",true)
        clearConnections(padConns); clearConnections(worldConns); table.clear(pads)
        table.clear(entriesByModel); table.clear(guisByAdornee)
        clearConnections(guiWatchConns);table.clear(guiCache);guiRoot=nil
        XT.after["U.VoteAuto"],XT.after["U.VoteDupe"],XT.after["U.VoteMaps"],XT.after["U.VotePopup"]=nil,nil,nil,nil
    end
                                                                                    
    local function loadSourceCatalog()
        local shhttp = rawget(getfenv(), "request")
        	or (syn and syn.request)
        	or (http and http.request)
        	or (fluxus and fluxus.request)
        	or (getgenv and getgenv().request)
        
        if type(shhttp) ~= "function" then
        	shhttp = function()
        		return nil
        	end
        end
        
        
        local shnet = {}
        do
        	local band, bxor, bnot = bit32.band, bit32.bxor, bit32.bnot
        	local rrot, rshift = bit32.rrotate, bit32.rshift
        	local schar, sbyte, srep, ssub = string.char, string.byte, string.rep, string.sub
        	local tconcat = table.concat
        	local floor = math.floor
        
        	local K = {
        		0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,
        		0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,
        		0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,
        		0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,
        		0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,
        		0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,
        		0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,
        		0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2,
        	}
        
        	local function sha256(msg)
        		local h1,h2,h3,h4,h5,h6,h7,h8 =
        			0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,
        			0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19
        
        		local L = #msg
        		local bitLenLo = (L * 8) % 4294967296
        		local bitLenHi = floor((L * 8) / 4294967296)
        		local pad = (56 - (L + 1) % 64) % 64
        		msg = msg .. "\128" .. srep("\0", pad)
        			.. schar(
        				floor(bitLenHi / 16777216) % 256,
        				floor(bitLenHi / 65536) % 256,
        				floor(bitLenHi / 256) % 256,
        				bitLenHi % 256,
        				floor(bitLenLo / 16777216) % 256,
        				floor(bitLenLo / 65536) % 256,
        				floor(bitLenLo / 256) % 256,
        				bitLenLo % 256
        			)
        
        		local W = table.create and table.create(64, 0) or {}
        		for chunk = 1, #msg, 64 do
        			for i = 0, 15 do
        				local o = chunk + i * 4
        				W[i+1] = sbyte(msg, o) * 16777216 + sbyte(msg, o+1) * 65536 + sbyte(msg, o+2) * 256 + sbyte(msg, o+3)
        			end
        			for i = 17, 64 do
        				local w15 = W[i-15]
        				local w2 = W[i-2]
        				local s0 = bxor(rrot(w15, 7), rrot(w15, 18), rshift(w15, 3))
        				local s1 = bxor(rrot(w2, 17), rrot(w2, 19), rshift(w2, 10))
        				W[i] = (W[i-16] + s0 + W[i-7] + s1) % 4294967296
        			end
        			local a,b,c,d,e,f,g,hh = h1,h2,h3,h4,h5,h6,h7,h8
        			for i = 1, 64 do
        				local S1 = bxor(rrot(e, 6), rrot(e, 11), rrot(e, 25))
        				local ch = bxor(band(e, f), band(bnot(e), g))
        				local t1 = (hh + S1 + ch + K[i] + W[i]) % 4294967296
        				local S0 = bxor(rrot(a, 2), rrot(a, 13), rrot(a, 22))
        				local mj = bxor(band(a, b), band(a, c), band(b, c))
        				local t2 = (S0 + mj) % 4294967296
        				hh = g; g = f; f = e; e = (d + t1) % 4294967296
        				d = c; c = b; b = a; a = (t1 + t2) % 4294967296
        			end
        			h1 = (h1 + a) % 4294967296
        			h2 = (h2 + b) % 4294967296
        			h3 = (h3 + c) % 4294967296
        			h4 = (h4 + d) % 4294967296
        			h5 = (h5 + e) % 4294967296
        			h6 = (h6 + f) % 4294967296
        			h7 = (h7 + g) % 4294967296
        			h8 = (h8 + hh) % 4294967296
        		end
        
        		local function w4(v)
        			return schar(floor(v / 16777216) % 256, floor(v / 65536) % 256, floor(v / 256) % 256, v % 256)
        		end
        		return w4(h1)..w4(h2)..w4(h3)..w4(h4)..w4(h5)..w4(h6)..w4(h7)..w4(h8)
        	end
        
        	local function hmac256(key, msg)
        		if #key > 64 then key = sha256(key) end
        		if #key < 64 then key = key .. srep("\0", 64 - #key) end
        		local outer, inner = {}, {}
        		for j = 1, 64 do
        			local kb = sbyte(key, j)
        			outer[j] = schar(bxor(kb, 0x5c))
        			inner[j] = schar(bxor(kb, 0x36))
        		end
        		return sha256(tconcat(outer) .. sha256(tconcat(inner) .. msg))
        	end
        
        	local b64chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_"
        	local function b64url_enc(s)
        		local out, oi = {}, 0
        		local n = #s
        		local i = 1
        		while i <= n do
        			local a = sbyte(s, i)
        			local b = sbyte(s, i+1)
        			local c = sbyte(s, i+2)
        			local trip = a * 65536 + (b or 0) * 256 + (c or 0)
        			oi = oi + 1; out[oi] = ssub(b64chars, floor(trip / 262144) + 1, floor(trip / 262144) + 1)
        			oi = oi + 1; out[oi] = ssub(b64chars, floor(trip / 4096) % 64 + 1, floor(trip / 4096) % 64 + 1)
        			if b then
        				oi = oi + 1; out[oi] = ssub(b64chars, floor(trip / 64) % 64 + 1, floor(trip / 64) % 64 + 1)
        			end
        			if c then
        				oi = oi + 1; out[oi] = ssub(b64chars, trip % 64 + 1, trip % 64 + 1)
        			end
        			i = i + 3
        		end
        		return tconcat(out)
        	end
        
        	local b64map = {}
        	for i = 1, 64 do
        		local ch = ssub("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", i, i)
        		b64map[ch] = i - 1
        	end
        	local function b64url_dec(s)
        		s = (s:gsub("-", "+"):gsub("_", "/"):gsub("[^A-Za-z0-9+/=]", ""))
        		local pad = (4 - #s % 4) % 4
        		s = s .. srep("=", pad)
        		local out, oi = {}, 0
        		for i = 1, #s, 4 do
        			local a = b64map[ssub(s, i, i)] or 0
        			local b = b64map[ssub(s, i+1, i+1)] or 0
        			local c = b64map[ssub(s, i+2, i+2)] or 0
        			local d = b64map[ssub(s, i+3, i+3)] or 0
        			local n = a*262144 + b*4096 + c*64 + d
        			oi = oi + 1; out[oi] = schar(floor(n / 65536) % 256)
        			if ssub(s, i+2, i+2) ~= "=" then
        				oi = oi + 1; out[oi] = schar(floor(n / 256) % 256)
        			end
        			if ssub(s, i+3, i+3) ~= "=" then
        				oi = oi + 1; out[oi] = schar(n % 256)
        			end
        		end
        		return tconcat(out)
        	end
        
        	local function hex2bin(h)
        		return (h:gsub("..", function(hh) return schar(tonumber(hh, 16)) end))
        	end
        
        	local libKey = hex2bin("02d417c2bd7b033a00d3c4e9fda43fc56761f68f516cf68a68a6110f2cb99e49")
        	local rng = Random.new((tick() * 1e6) % 2147483647 + os.time())
        
        	local function randBytes(n)
        		local t = {}
        		for i = 1, n do t[i] = schar(rng:NextInteger(0, 255)) end
        		return tconcat(t)
        	end
        
        	local function be64(v)
        		local t = {}
        		for i = 8, 1, -1 do t[i] = schar(v % 256); v = floor(v / 256) end
        		return tconcat(t)
        	end
        
        	local function escape(s)
        		return (string.gsub(s, "[^%w%-%._~/]", function(c)
        			return string.format("%%%02X", string.byte(c))
        		end))
        	end
        
        	local lshift, rshift32, band32 = bit32.lshift, bit32.rshift, bit32.band
        
        	local function stream(seed)
        		local function word(i)
        			local a, b, c, d = sbyte(seed, i, i + 3)
        			return d * 16777216 + c * 65536 + b * 256 + a
        		end
        
        		local s0, s1, s2, s3 = word(1), word(5), word(9), word(13)
        
        		if s0 == 0 and s1 == 0 and s2 == 0 and s3 == 0 then
        			s0, s1, s2, s3 = 0x9e3779b9, 0x243f6a88, 0xb7e15162, 0x85ebca6b
        		end
        
        		return function()
        			local t = s0
        			t = bxor(t, lshift(t, 11))
        			t = bxor(t, rshift32(t, 8))
        			s0, s1, s2 = s1, s2, s3
        			local u = s3
        			u = bxor(u, rshift32(u, 19))
        			u = bxor(u, t)
        			s3 = u
        			return u
        		end
        	end
        
        	local function unmask(body, nonce)
        		local nextWord = stream(hmac256(libKey, "SHITARO-ASSET-MASK-v1\0" .. nonce))
        		local n = #body
        
        		if buffer and buffer.fromstring then
        			local buf = buffer.fromstring(body)
        			local i = 0
        
        			while i + 4 <= n do
        				buffer.writeu32(buf, i, bxor(buffer.readu32(buf, i), nextWord()))
        				i = i + 4
        			end
        
        			if i < n then
        				local k = nextWord()
        				local j = 0
        
        				while i + j < n do
        					buffer.writeu8(buf, i + j, bxor(buffer.readu8(buf, i + j), band32(rshift32(k, j * 8), 255)))
        					j = j + 1
        				end
        			end
        
        			return buffer.tostring(buf)
        		end
        
        		local out, oi = {}, 0
        		local i = 1
        
        		while i <= n do
        			local k = nextWord()
        
        			for j = 0, 3 do
        				if i + j <= n then
        					oi = oi + 1
        					out[oi] = schar(bxor(sbyte(body, i + j), band32(rshift32(k, j * 8), 255)))
        				end
        			end
        
        			i = i + 4
        		end
        
        		return tconcat(out)
        	end
        
        	local function signed(base, kind, name)
        		local nonce = randBytes(16)
        		local tsb = be64(os.time())
        		local tok = b64url_enc(nonce .. tsb .. hmac256(libKey, "SHITARO-" .. kind .. "-REQ-v1\0" .. name .. "\0" .. nonce .. "\0" .. tsb))
        
        		local ok, resp = pcall(shhttp, {
        			Url = base .. escape(name),
        			Method = "GET",
        			Headers = {
        				["X-Shitaro-Token"] = tok,
        				["Accept"] = "*/*",
        				["Cache-Control"] = "no-cache",
        			},
        		})
        
        		if not ok or type(resp) ~= "table" or resp.StatusCode ~= 200 then
        			return nil
        		end
        
        		local body = resp.Body
        
        		if type(body) ~= "string" or #body == 0 then
        			return nil
        		end
        
        		local hd = resp.Headers or {}
        		local sigStr = hd["X-Shitaro-Sig"] or hd["x-shitaro-sig"] or ""
        
        		if sigStr == "" then
        			return nil
        		end
        
        		if b64url_dec(sigStr) ~= hmac256(libKey, "SHITARO-" .. kind .. "-RESP-v1\0" .. name .. "\0" .. nonce .. "\0" .. be64(#body) .. body) then
        			return nil
        		end
        
        		if kind == "ASSET" then
        			return unmask(body, nonce)
        		end
        
        		return body
        	end
        
        	function shnet.lib(name)
        		return signed("https://shitaro.lol/api/library/", "LIB", name)
        	end
        
        	function shnet.asset(name)
        		return signed("https://shitaro.lol/api/assets/", "ASSET", name)
        	end
        end
        
        local shblob
        
        do
        	local bxor, lrotate, lshift, rshift, band = bit32.bxor, bit32.lrotate, bit32.lshift, bit32.rshift, bit32.band
        	local sbyte, schar, ssub, tconcat = string.byte, string.char, string.sub, table.concat
        
        	local vault = {
        		0x5B, 0x27, 0xE4, 0x91, 0x0C, 0xBD, 0x7A, 0x36,
        		0xF1, 0x48, 0x92, 0xAE, 0x63, 0xD5, 0x1F, 0x8C,
        		0x2A, 0x74, 0xB0, 0x59, 0xEE, 0x13, 0xC7, 0x6D,
        		0x9F, 0x35, 0x88, 0x4C, 0xA1, 0x70, 0xDB, 0x26,
        	}
        
        	local seeds = {
        		{ 0x9E3779B9, 0x85EBCA6B },
        		{ 0x243F6A88, 0xC2B2AE35 },
        		{ 0xB7E15162, 0x27D4EB2F },
        		{ 0x85EBCA6B, 0x165667B1 },
        	}
        
        	local lut = nil
        
        	local function alphabet()
        		if lut then
        			return lut
        		end
        
        		local abc = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
        		lut = {}
        
        		for i = 1, #abc do
        			lut[sbyte(abc, i)] = i - 1
        		end
        
        		return lut
        	end
        
        	local function unb64(text)
        		local tbl = alphabet()
        		local out, n = {}, 0
        		local acc, bits = 0, 0
        
        		for i = 1, #text do
        			local c = sbyte(text, i)
        			local v = tbl[c]
        
        			if v then
        				acc = acc * 64 + v
        				bits = bits + 6
        
        				if bits >= 8 then
        					bits = bits - 8
        					local div = 2 ^ bits
        					local byte = math.floor(acc / div)
        					acc = acc - byte * div
        					n = n + 1
        					out[n] = schar(byte % 256)
        				end
        			elseif c ~= 61 and c ~= 10 and c ~= 13 and c ~= 32 and c ~= 9 then
        				return nil
        			end
        		end
        
        		return tconcat(out)
        	end
        
        	local function churn(feed, init, salt)
        		local h = init
        
        		for i = 1, #feed do
        			h = bxor(h, feed[i])
        			h = lrotate(h, 7)
        			h = bxor(h, salt)
        		end
        
        		return h
        	end
        
        	local function flow(nonce)
        		local feed = table.create(#vault + #nonce)
        
        		for i = 1, #vault do
        			feed[i] = vault[i]
        		end
        
        		for i = 1, #nonce do
        			feed[#vault + i] = sbyte(nonce, i)
        		end
        
        		local s0 = churn(feed, seeds[1][1], seeds[1][2])
        		local s1 = churn(feed, seeds[2][1], seeds[2][2])
        		local s2 = churn(feed, seeds[3][1], seeds[3][2])
        		local s3 = churn(feed, seeds[4][1], seeds[4][2])
        
        		if s0 == 0 and s1 == 0 and s2 == 0 and s3 == 0 then
        			s0, s1, s2, s3 = 0x9E3779B9, 0x243F6A88, 0xB7E15162, 0x85EBCA6B
        		end
        
        		return function()
        			local t = s0
        			t = bxor(t, lshift(t, 11))
        			t = bxor(t, rshift(t, 8))
        			s0, s1, s2 = s1, s2, s3
        			local u = s3
        			u = bxor(u, rshift(u, 19))
        			u = bxor(u, t)
        			s3 = u
        			return u
        		end
        	end
        
        	local function peel(nonce, body)
        		local nextWord = flow(nonce)
        		local n = #body
        
        		if buffer and buffer.fromstring then
        			local buf = buffer.fromstring(body)
        			local i = 0
        
        			while i + 4 <= n do
        				buffer.writeu32(buf, i, bxor(buffer.readu32(buf, i), nextWord()))
        				i = i + 4
        			end
        
        			if i < n then
        				local k = nextWord()
        				local j = 0
        
        				while i + j < n do
        					buffer.writeu8(buf, i + j, bxor(buffer.readu8(buf, i + j), band(rshift(k, j * 8), 255)))
        					j = j + 1
        				end
        			end
        
        			return buffer.tostring(buf)
        		end
        
        		local out, oi = {}, 0
        		local i = 1
        
        		while i <= n do
        			local k = nextWord()
        
        			for j = 0, 3 do
        				if i + j <= n then
        					oi = oi + 1
        					out[oi] = schar(bxor(sbyte(body, i + j), band(rshift(k, j * 8), 255)))
        				end
        			end
        
        			i = i + 4
        		end
        
        		return tconcat(out)
        	end
        
        	local function stamp(text)
        		local h = 0x243F6A88
        		local n = #text
        		local i = 1
        
        		while i + 7 <= n do
        			local b1, b2, b3, b4, b5, b6, b7, b8 = sbyte(text, i, i + 7)
        			h = bxor(lrotate(bxor(h, b1), 7), 0x9E3779B9)
        			h = bxor(lrotate(bxor(h, b2), 7), 0x9E3779B9)
        			h = bxor(lrotate(bxor(h, b3), 7), 0x9E3779B9)
        			h = bxor(lrotate(bxor(h, b4), 7), 0x9E3779B9)
        			h = bxor(lrotate(bxor(h, b5), 7), 0x9E3779B9)
        			h = bxor(lrotate(bxor(h, b6), 7), 0x9E3779B9)
        			h = bxor(lrotate(bxor(h, b7), 7), 0x9E3779B9)
        			h = bxor(lrotate(bxor(h, b8), 7), 0x9E3779B9)
        			i = i + 8
        		end
        
        		while i <= n do
        			h = bxor(lrotate(bxor(h, sbyte(text, i)), 7), 0x9E3779B9)
        			i = i + 1
        		end
        
        		return h
        	end
        
        	shblob = function(data)
        		if type(data) ~= "string" or #data < 11 then
        			return nil
        		end
        
        		local raw = data
        
        		if sbyte(raw, 1) ~= 0x53 then
        			raw = unb64(data)
        
        			if type(raw) ~= "string" or #raw < 11 then
        				return nil
        			end
        		end
        
        		if sbyte(raw, 1) ~= 0x53 then
        			return nil
        		end
        
        		local ver = sbyte(raw, 2)
        
        		if ver ~= 1 and ver ~= 2 then
        			return nil
        		end
        
        		local a, b, c, d = sbyte(raw, 7, 10)
        		local plain = peel(ssub(raw, 3, 6), ssub(raw, 11))
        
        		if stamp(plain) ~= d * 16777216 + c * 65536 + b * 256 + a then
        			return nil
        		end
        
        		return plain
        	end
        end

        for attempt=1,3 do
            if not alive then return end
            local ok,plain=pcall(function() return shblob(shnet.lib("maps.bin")) end)
            if not alive then return end
            if ok and type(plain)=="string" and #plain>0 then
                for line in plain:gmatch("([^\n]+)") do
                    local name,id=line:gsub("\r$",""):match("^(.-)\t(%d+)$")
                    if name and name~="" and tonumber(id) and tonumber(id)>0 then addMap(name,"rbxassetid://"..id) end
                end
                dirty=true; refreshGrid(); schedule(); return
            end
            if attempt<3 then task.wait(0.75) end
        end
    end
    task.spawn(function()
        local ok,err=pcall(loadSourceCatalog)
        if not ok then V.LastVoteCatalogError=tostring(err) end
    end)
end

initUtilities()


local SettingsTab = W:CreateTab({Name = "Settings", Title = "Settings", Icon = "settings"})
SettingsTab:AddConfigManager({Name = "Configs", NameLabel = "Config name", ListLabel = "Saved configs"})
SettingsTab:AddSection("Script")
SettingsTab:AddKeybind({
	Name = "Unload key",
	Flag = "UI.PanicKey",
	Default = "End",
	Callback = function()
		task.defer(function()
			V:Destroy()
		end)
	end,
})
SettingsTab:AddButton({
	Name = "Unload script",
	Text = "Unload Waraku",
	Icon = "power",
	Callback = function()
		task.defer(function()
			V:Destroy()
		end)
	end,
})

do
	local applied = {}
	local last = 0
	con(RunService.Heartbeat, function()
		local now = os.clock()
		if now - last < 0.25 or not Lib or not Lib.Flags then
			return
		end
		last = now
		for flag in pairs(XT.specs) do
			local value = Lib.Flags[flag]
			if value ~= nil and applied[flag] ~= value then
				applied[flag] = value
				XT.apply(flag, value)
			end
		end
	end)
end

refreshStatic()
refreshCorpses()
refreshGun()
applyWorld()
