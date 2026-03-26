-- ============================================================================
-- ARCANE HUB v3.0 — Redesigned GUI
-- ============================================================================
local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local LocalPlayer      = Players.LocalPlayer
local PlayerGui        = LocalPlayer:WaitForChild("PlayerGui")

-- ===================== SCREEN GUI =====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name           = "ArcaneHub"
ScreenGui.ResetOnSpawn   = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.Parent         = PlayerGui

-- ===================== FONTS & THEME =====================
local FONT_TITLE  = Enum.Font.GothamBold
local FONT_BODY   = Enum.Font.GothamSemibold
local FONT_SMALL  = Enum.Font.Gotham
local FONT_MONO   = Enum.Font.Code

local THEME = {
    BG_DEEP      = Color3.fromRGB(9, 9, 15),
    BG_MAIN      = Color3.fromRGB(13, 13, 22),
    BG_PANEL     = Color3.fromRGB(16, 16, 28),
    BG_ROW       = Color3.fromRGB(20, 20, 36),
    BG_SIDEBAR   = Color3.fromRGB(11, 11, 20),
    BORDER       = Color3.fromRGB(45, 55, 110),
    BORDER_LIT   = Color3.fromRGB(70, 95, 200),
    ACCENT       = Color3.fromRGB(80, 110, 255),
    ACCENT2      = Color3.fromRGB(140, 90, 255),
    TEXT_BRIGHT  = Color3.fromRGB(200, 215, 255),
    TEXT_MID     = Color3.fromRGB(140, 155, 200),
    TEXT_DIM     = Color3.fromRGB(75, 90, 145),
    TEXT_MONO    = Color3.fromRGB(90, 115, 210),
    TOGGLE_ON    = Color3.fromRGB(50, 100, 240),
    TOGGLE_OFF   = Color3.fromRGB(30, 32, 55),
    STATUS_LIVE  = Color3.fromRGB(50, 200, 90),
    STATUS_OFF   = Color3.fromRGB(45, 55, 100),
}

local TAB_COLORS = {
    Combat  = Color3.fromRGB(200, 55, 65),
    Auto    = Color3.fromRGB(35, 175, 210),
    ESP     = Color3.fromRGB(50, 200, 110),
    Player  = Color3.fromRGB(210, 175, 40),
    Visual  = Color3.fromRGB(155, 75, 220),
    Event   = Color3.fromRGB(255, 130, 30),
    Misc    = Color3.fromRGB(120, 125, 150),
}

local TAB_NAMES = {"Combat","Auto","ESP","Player","Visual","Event","Misc"}

-- ===================== HELPERS =====================
local function Tween(obj, props, t, style, dir)
    TweenService:Create(obj,
        TweenInfo.new(t or 0.18, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out),
        props
    ):Play()
end

local function AddCorner(parent, radius)
    local c = Instance.new("UICorner", parent)
    c.CornerRadius = UDim.new(0, radius or 8)
    return c
end

local function AddStroke(parent, color, thickness, trans)
    local s = Instance.new("UIStroke", parent)
    s.Color = color or THEME.BORDER
    s.Thickness = thickness or 1
    s.Transparency = trans or 0
    return s
end

local function AddPadding(parent, top, bottom, left, right)
    local p = Instance.new("UIPadding", parent)
    p.PaddingTop    = UDim.new(0, top    or 0)
    p.PaddingBottom = UDim.new(0, bottom or 0)
    p.PaddingLeft   = UDim.new(0, left   or 0)
    p.PaddingRight  = UDim.new(0, right  or 0)
    return p
end

local function Label(parent, text, size, font, color, xAlign)
    local l = Instance.new("TextLabel", parent)
    l.BackgroundTransparency = 1
    l.Text     = text
    l.TextSize = size or 13
    l.Font     = font or FONT_SMALL
    l.TextColor3 = color or THEME.TEXT_MID
    l.TextXAlignment = xAlign or Enum.TextXAlignment.Left
    l.TextTruncate = Enum.TextTruncate.AtEnd
    return l
end

-- ===================== MAIN WINDOW =====================
local Win = Instance.new("Frame", ScreenGui)
Win.Name              = "Win"
Win.Size              = UDim2.new(0, 700, 0, 490)
Win.Position          = UDim2.new(0.5, -350, 0.5, -245)
Win.BackgroundColor3  = THEME.BG_MAIN
Win.BorderSizePixel   = 0
Win.ClipsDescendants  = false
Win.ZIndex            = 2
AddCorner(Win, 12)
AddStroke(Win, THEME.BORDER, 1)

-- Top glow line
local topGlow = Instance.new("Frame", Win)
topGlow.Size             = UDim2.new(0.7, 0, 0, 1)
topGlow.Position         = UDim2.new(0.15, 0, 0, 0)
topGlow.BackgroundColor3 = THEME.ACCENT
topGlow.BackgroundTransparency = 0.3
topGlow.BorderSizePixel  = 0
topGlow.ZIndex           = 10

-- ===================== TITLEBAR =====================
local TitleBar = Instance.new("Frame", Win)
TitleBar.Size             = UDim2.new(1, 0, 0, 46)
TitleBar.BackgroundColor3 = THEME.BG_DEEP
TitleBar.BorderSizePixel  = 0
TitleBar.ZIndex           = 5
AddCorner(TitleBar, 12)

-- Fix bottom corners of titlebar
local tbFix = Instance.new("Frame", TitleBar)
tbFix.Size             = UDim2.new(1, 0, 0, 12)
tbFix.Position         = UDim2.new(0, 0, 1, -12)
tbFix.BackgroundColor3 = THEME.BG_DEEP
tbFix.BorderSizePixel  = 0
tbFix.ZIndex           = 5

-- Bottom border line
local tbLine = Instance.new("Frame", TitleBar)
tbLine.Size             = UDim2.new(1, 0, 0, 1)
tbLine.Position         = UDim2.new(0, 0, 1, -1)
tbLine.BackgroundColor3 = THEME.BORDER
tbLine.BackgroundTransparency = 0.4
tbLine.BorderSizePixel  = 0
tbLine.ZIndex           = 6

-- Accent bar
local accentBar = Instance.new("Frame", TitleBar)
accentBar.Size             = UDim2.new(0, 3, 0, 24)
accentBar.Position         = UDim2.new(0, 12, 0.5, -12)
accentBar.BackgroundColor3 = THEME.ACCENT
accentBar.BorderSizePixel  = 0
accentBar.ZIndex           = 6
AddCorner(accentBar, 2)

-- Title text
local titleLabel = Label(TitleBar, "⚡  ARCANE HUB", 15, FONT_TITLE, THEME.TEXT_BRIGHT, Enum.TextXAlignment.Left)
titleLabel.Size     = UDim2.new(0, 180, 1, 0)
titleLabel.Position = UDim2.new(0, 22, 0, 0)
titleLabel.ZIndex   = 6

-- Version badge
local verBadge = Instance.new("TextLabel", TitleBar)
verBadge.Size     = UDim2.new(0, 44, 0, 18)
verBadge.Position = UDim2.new(0, 210, 0.5, -9)
verBadge.BackgroundColor3 = Color3.fromRGB(20, 25, 55)
verBadge.BorderSizePixel  = 0
verBadge.Text     = "v3.0"
verBadge.Font     = FONT_MONO
verBadge.TextSize = 10
verBadge.TextColor3 = THEME.TEXT_DIM
verBadge.ZIndex   = 6
AddCorner(verBadge, 4)
AddStroke(verBadge, THEME.BORDER, 1)

-- Hotkey badge
local hkBadge = Instance.new("TextLabel", TitleBar)
hkBadge.Size     = UDim2.new(0, 62, 0, 18)
hkBadge.Position = UDim2.new(0, 264, 0.5, -9)
hkBadge.BackgroundColor3 = Color3.fromRGB(20, 25, 55)
hkBadge.BorderSizePixel  = 0
hkBadge.Text     = "RShift"
hkBadge.Font     = FONT_MONO
hkBadge.TextSize = 10
hkBadge.TextColor3 = THEME.TEXT_DIM
hkBadge.ZIndex   = 6
AddCorner(hkBadge, 4)
AddStroke(hkBadge, THEME.BORDER, 1)

-- Window buttons
local function makeWinBtn(offsetX, bgCol, labelText)
    local b = Instance.new("TextButton", TitleBar)
    b.Size             = UDim2.new(0, 24, 0, 24)
    b.Position         = UDim2.new(1, offsetX, 0.5, -12)
    b.BackgroundColor3 = bgCol
    b.Text             = labelText
    b.Font             = FONT_TITLE
    b.TextSize         = 11
    b.TextColor3       = Color3.new(1, 1, 1)
    b.BorderSizePixel  = 0
    b.ZIndex           = 7
    AddCorner(b, 12)
    b.MouseEnter:Connect(function() Tween(b, {BackgroundTransparency = 0.25}, 0.1) end)
    b.MouseLeave:Connect(function() Tween(b, {BackgroundTransparency = 0}, 0.1) end)
    return b
end

local CloseBtn = makeWinBtn(-38, Color3.fromRGB(180, 45, 55), "✕")
local MinBtn   = makeWinBtn(-70, Color3.fromRGB(35, 38, 70), "−")

CloseBtn.MouseButton1Click:Connect(function()
    Tween(Win, {Size = UDim2.new(0, 700, 0, 0)}, 0.2, Enum.EasingStyle.Quad)
    task.delay(0.22, function() Win.Visible = false; Win.Size = UDim2.new(0, 700, 0, 490) end)
end)

local minimised = false
MinBtn.MouseButton1Click:Connect(function()
    minimised = not minimised
    Tween(Win, {Size = minimised and UDim2.new(0, 700, 0, 46) or UDim2.new(0, 700, 0, 490)}, 0.22, Enum.EasingStyle.Quad)
end)

-- Drag
local drag, dragStart, startPos = false, nil, nil
TitleBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        drag = true; dragStart = i.Position; startPos = Win.Position
    end
end)
TitleBar.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
end)
UserInputService.InputChanged:Connect(function(i)
    if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
        local d = i.Position - dragStart
        Win.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
                                  startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)

-- ===================== BODY LAYOUT =====================
local Body = Instance.new("Frame", Win)
Body.Size             = UDim2.new(1, 0, 1, -46)
Body.Position         = UDim2.new(0, 0, 0, 46)
Body.BackgroundTransparency = 1
Body.BorderSizePixel  = 0
Body.ZIndex           = 3
Body.ClipsDescendants = true

-- ===================== SIDEBAR =====================
local Sidebar = Instance.new("Frame", Body)
Sidebar.Size             = UDim2.new(0, 115, 1, -28)
Sidebar.Position         = UDim2.new(0, 0, 0, 0)
Sidebar.BackgroundColor3 = THEME.BG_SIDEBAR
Sidebar.BorderSizePixel  = 0
Sidebar.ZIndex           = 4

-- Rounded left corners only via overlap trick
local sidebarRight = Instance.new("Frame", Sidebar)
sidebarRight.Size             = UDim2.new(0, 12, 1, 0)
sidebarRight.Position         = UDim2.new(1, -12, 0, 0)
sidebarRight.BackgroundColor3 = THEME.BG_SIDEBAR
sidebarRight.BorderSizePixel  = 0
sidebarRight.ZIndex           = 4

local sideDiv = Instance.new("Frame", Body)
sideDiv.Size             = UDim2.new(0, 1, 1, -28)
sideDiv.Position         = UDim2.new(0, 115, 0, 0)
sideDiv.BackgroundColor3 = THEME.BORDER
sideDiv.BackgroundTransparency = 0.5
sideDiv.BorderSizePixel  = 0
sideDiv.ZIndex           = 4

local TabList = Instance.new("Frame", Sidebar)
TabList.Size             = UDim2.new(1, 0, 1, 0)
TabList.BackgroundTransparency = 1
TabList.BorderSizePixel  = 0
TabList.ZIndex           = 5

local tabLayout = Instance.new("UIListLayout", TabList)
tabLayout.FillDirection = Enum.FillDirection.Vertical
tabLayout.Padding       = UDim.new(0, 3)
tabLayout.SortOrder     = Enum.SortOrder.LayoutOrder
AddPadding(TabList, 8, 6, 6, 6)

-- ===================== CONTENT AREA =====================
local ContentArea = Instance.new("Frame", Body)
ContentArea.Size             = UDim2.new(1, -123, 1, -28)
ContentArea.Position         = UDim2.new(0, 120, 0, 2)
ContentArea.BackgroundTransparency = 1
ContentArea.BorderSizePixel  = 0
ContentArea.ZIndex           = 4
ContentArea.ClipsDescendants = true

-- ===================== STATUS BAR =====================
local StatusBar = Instance.new("Frame", Body)
StatusBar.Size             = UDim2.new(1, 0, 0, 28)
StatusBar.Position         = UDim2.new(0, 0, 1, -28)
StatusBar.BackgroundColor3 = THEME.BG_DEEP
StatusBar.BorderSizePixel  = 0
StatusBar.ZIndex           = 5

local stLine = Instance.new("Frame", StatusBar)
stLine.Size             = UDim2.new(1, 0, 0, 1)
stLine.BackgroundColor3 = THEME.BORDER
stLine.BackgroundTransparency = 0.5
stLine.BorderSizePixel  = 0
stLine.ZIndex           = 5

local stDot = Instance.new("Frame", StatusBar)
stDot.Size             = UDim2.new(0, 7, 0, 7)
stDot.Position         = UDim2.new(0, 12, 0.5, -3)
stDot.BackgroundColor3 = THEME.STATUS_LIVE
stDot.BorderSizePixel  = 0
stDot.ZIndex           = 6
AddCorner(stDot, 10)

-- Pulse animation for dot
task.spawn(function()
    while true do
        Tween(stDot, {BackgroundTransparency = 0.6}, 0.9)
        task.wait(0.9)
        Tween(stDot, {BackgroundTransparency = 0}, 0.9)
        task.wait(0.9)
    end
end)

local stText = Label(StatusBar, "CONNECTED", 10, FONT_MONO, THEME.STATUS_LIVE, Enum.TextXAlignment.Left)
stText.Size     = UDim2.new(0, 90, 1, 0)
stText.Position = UDim2.new(0, 25, 0, 0)
stText.ZIndex   = 6

local stTextR = Label(StatusBar, "ARCANE HUB // ZENTRA BUILD", 10, FONT_MONO, THEME.TEXT_DIM, Enum.TextXAlignment.Right)
stTextR.Size     = UDim2.new(1, -16, 1, 0)
stTextR.Position = UDim2.new(0, 8, 0, 0)
stTextR.ZIndex   = 6

-- ===================== SCROLLFRAME FACTORY =====================
local function makeScrollFrame()
    local sf = Instance.new("ScrollingFrame", ContentArea)
    sf.Size                   = UDim2.new(1, 0, 1, 0)
    sf.BackgroundTransparency = 1
    sf.BorderSizePixel        = 0
    sf.ScrollBarThickness     = 3
    sf.ScrollBarImageColor3   = Color3.fromRGB(65, 90, 200)
    sf.CanvasSize             = UDim2.new(0, 0, 0, 0)
    sf.AutomaticCanvasSize    = Enum.AutomaticSize.Y
    sf.Visible                = false
    sf.ZIndex                 = 5
    sf.ClipsDescendants       = false
    local layout = Instance.new("UIListLayout", sf)
    layout.Padding   = UDim.new(0, 5)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    AddPadding(sf, 8, 8, 4, 10)
    return sf
end

-- ===================== UI HELPERS =====================
local openDropFrame = nil

local function makeSection(parent, title, order)
    local f = Instance.new("Frame", parent)
    f.Size             = UDim2.new(1, 0, 0, 22)
    f.BackgroundTransparency = 1
    f.BorderSizePixel  = 0
    f.LayoutOrder      = order or 0
    f.ZIndex           = 6

    local lbl = Label(f, "// " .. title:upper(), 10, FONT_MONO, THEME.TEXT_DIM)
    lbl.Size          = UDim2.new(1, -8, 1, 0)
    lbl.Position      = UDim2.new(0, 4, 0, 0)
    lbl.ZIndex        = 6

    local line = Instance.new("Frame", f)
    line.Size             = UDim2.new(1, -8, 0, 1)
    line.Position         = UDim2.new(0, 4, 1, -1)
    line.BackgroundColor3 = THEME.BORDER
    line.BackgroundTransparency = 0.6
    line.BorderSizePixel  = 0
    line.ZIndex           = 6
end

local function makeToggle(parent, labelText, default, callback, order)
    local row = Instance.new("Frame", parent)
    row.Size             = UDim2.new(1, 0, 0, 36)
    row.BackgroundColor3 = THEME.BG_ROW
    row.BackgroundTransparency = 0.35
    row.BorderSizePixel  = 0
    row.LayoutOrder      = order or 0
    row.ZIndex           = 6
    AddCorner(row, 7)
    AddStroke(row, THEME.BORDER, 1, 0.5)

    local lbl = Label(row, labelText, 13, FONT_BODY, THEME.TEXT_BRIGHT)
    lbl.Size     = UDim2.new(1, -60, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.ZIndex   = 7

    -- Pill toggle
    local pillBg = Instance.new("Frame", row)
    pillBg.Size             = UDim2.new(0, 38, 0, 20)
    pillBg.Position         = UDim2.new(1, -48, 0.5, -10)
    pillBg.BackgroundColor3 = default and THEME.TOGGLE_ON or THEME.TOGGLE_OFF
    pillBg.BorderSizePixel  = 0
    pillBg.ZIndex           = 7
    AddCorner(pillBg, 10)
    AddStroke(pillBg, THEME.BORDER, 1, default and 1 or 0.3)

    local knob = Instance.new("Frame", pillBg)
    knob.Size             = UDim2.new(0, 14, 0, 14)
    knob.Position         = default and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.BorderSizePixel  = 0
    knob.ZIndex           = 8
    AddCorner(knob, 10)

    local enabled = default or false
    local hitbox = Instance.new("TextButton", row)
    hitbox.Size             = UDim2.new(1, 0, 1, 0)
    hitbox.BackgroundTransparency = 1
    hitbox.Text             = ""
    hitbox.ZIndex           = 9

    hitbox.MouseButton1Click:Connect(function()
        enabled = not enabled
        Tween(pillBg, {BackgroundColor3 = enabled and THEME.TOGGLE_ON or THEME.TOGGLE_OFF}, 0.15)
        Tween(knob, {Position = enabled and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)}, 0.15)
        if callback then callback(enabled) end
    end)
    hitbox.MouseEnter:Connect(function()
        Tween(row, {BackgroundTransparency = 0.1}, 0.1)
        Tween(row, {}, 0.1) -- stroke handled by UIStroke
    end)
    hitbox.MouseLeave:Connect(function()
        Tween(row, {BackgroundTransparency = 0.35}, 0.1)
    end)
end

local function makeSlider(parent, labelText, minV, maxV, default, callback, order)
    local row = Instance.new("Frame", parent)
    row.Size             = UDim2.new(1, 0, 0, 50)
    row.BackgroundColor3 = THEME.BG_ROW
    row.BackgroundTransparency = 0.35
    row.BorderSizePixel  = 0
    row.LayoutOrder      = order or 0
    row.ZIndex           = 6
    AddCorner(row, 7)
    AddStroke(row, THEME.BORDER, 1, 0.5)

    local lbl = Label(row, labelText, 12, FONT_BODY, THEME.TEXT_BRIGHT)
    lbl.Size     = UDim2.new(1, -70, 0, 20)
    lbl.Position = UDim2.new(0, 10, 0, 5)
    lbl.ZIndex   = 7

    local valLbl = Label(row, tostring(default), 12, FONT_MONO, THEME.ACCENT, Enum.TextXAlignment.Right)
    valLbl.Size     = UDim2.new(0, 56, 0, 20)
    valLbl.Position = UDim2.new(1, -64, 0, 5)
    valLbl.ZIndex   = 7

    local track = Instance.new("Frame", row)
    track.Size             = UDim2.new(1, -18, 0, 4)
    track.Position         = UDim2.new(0, 9, 0, 33)
    track.BackgroundColor3 = Color3.fromRGB(35, 38, 65)
    track.BorderSizePixel  = 0
    track.ZIndex           = 7
    AddCorner(track, 2)

    local fill = Instance.new("Frame", track)
    fill.Size             = UDim2.new((default - minV) / (maxV - minV), 0, 1, 0)
    fill.BackgroundColor3 = THEME.ACCENT
    fill.BorderSizePixel  = 0
    fill.ZIndex           = 8
    AddCorner(fill, 2)

    local handle = Instance.new("Frame", fill)
    handle.Size             = UDim2.new(0, 12, 0, 12)
    handle.Position         = UDim2.new(1, -6, 0.5, -6)
    handle.BackgroundColor3 = Color3.new(1, 1, 1)
    handle.BorderSizePixel  = 0
    handle.ZIndex           = 9
    AddCorner(handle, 6)

    local value    = default
    local dragging = false

    local function update(x)
        local rel = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        value       = math.floor(minV + rel * (maxV - minV) + 0.5)
        fill.Size   = UDim2.new(rel, 0, 1, 0)
        valLbl.Text = tostring(value)
        if callback then callback(value) end
    end

    track.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; update(i.Position.X)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            update(i.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    row.MouseEnter:Connect(function() Tween(row, {BackgroundTransparency = 0.1}, 0.1) end)
    row.MouseLeave:Connect(function() Tween(row, {BackgroundTransparency = 0.35}, 0.1) end)
end

local function makeDropdown(parent, labelText, values, default, callback, order)
    local row = Instance.new("Frame", parent)
    row.Size             = UDim2.new(1, 0, 0, 38)
    row.BackgroundColor3 = THEME.BG_ROW
    row.BackgroundTransparency = 0.35
    row.BorderSizePixel  = 0
    row.LayoutOrder      = order or 0
    row.ZIndex           = 6
    AddCorner(row, 7)
    AddStroke(row, THEME.BORDER, 1, 0.5)

    local lbl = Label(row, labelText, 12, FONT_BODY, THEME.TEXT_BRIGHT)
    lbl.Size     = UDim2.new(0.48, 0, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.ZIndex   = 7

    local selected = default or values[1]

    local dropBtn = Instance.new("TextButton", row)
    dropBtn.Size             = UDim2.new(0.46, 0, 0, 26)
    dropBtn.Position         = UDim2.new(0.52, 0, 0.5, -13)
    dropBtn.BackgroundColor3 = Color3.fromRGB(22, 24, 46)
    dropBtn.Text             = selected .. "  ▾"
    dropBtn.Font             = FONT_SMALL
    dropBtn.TextSize         = 11
    dropBtn.TextColor3       = THEME.TEXT_MONO
    dropBtn.BorderSizePixel  = 0
    dropBtn.ZIndex           = 7
    AddCorner(dropBtn, 5)
    AddStroke(dropBtn, THEME.BORDER, 1, 0.3)

    local listH = #values * 28
    local dropList = Instance.new("Frame", ScreenGui)
    dropList.Size             = UDim2.new(0, 0, 0, listH)
    dropList.BackgroundColor3 = Color3.fromRGB(18, 18, 34)
    dropList.BorderSizePixel  = 0
    dropList.Visible          = false
    dropList.ZIndex           = 300
    AddCorner(dropList, 7)
    AddStroke(dropList, THEME.BORDER_LIT, 1, 0.3)

    local listLayout = Instance.new("UIListLayout", dropList)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder

    for i, v in ipairs(values) do
        local opt = Instance.new("TextButton", dropList)
        opt.Size             = UDim2.new(1, 0, 0, 28)
        opt.BackgroundTransparency = 1
        opt.Text             = "   " .. v
        opt.Font             = FONT_SMALL
        opt.TextSize         = 12
        opt.TextColor3       = THEME.TEXT_MID
        opt.TextXAlignment   = Enum.TextXAlignment.Left
        opt.BorderSizePixel  = 0
        opt.LayoutOrder      = i
        opt.ZIndex           = 301

        opt.MouseEnter:Connect(function()
            Tween(opt, {BackgroundTransparency = 0.7, TextColor3 = THEME.TEXT_BRIGHT}, 0.1)
            opt.BackgroundColor3 = THEME.ACCENT
        end)
        opt.MouseLeave:Connect(function()
            Tween(opt, {BackgroundTransparency = 1, TextColor3 = THEME.TEXT_MID}, 0.1)
        end)
        opt.MouseButton1Click:Connect(function()
            selected          = v
            dropBtn.Text      = v .. "  ▾"
            dropList.Visible  = false
            openDropFrame     = nil
            if callback then callback(v) end
        end)
    end

    local isOpen = false
    dropBtn.MouseButton1Click:Connect(function()
        if openDropFrame and openDropFrame ~= dropList then
            openDropFrame.Visible = false
        end
        isOpen = not isOpen
        if isOpen then
            local ap = dropBtn.AbsolutePosition
            local as = dropBtn.AbsoluteSize
            dropList.Position = UDim2.new(0, ap.X, 0, ap.Y + as.Y + 3)
            dropList.Size     = UDim2.new(0, as.X, 0, listH)
            dropList.Visible  = true
            openDropFrame     = dropList
        else
            dropList.Visible = false
            openDropFrame    = nil
        end
    end)

    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
        if not isOpen then return end
        task.wait()
        if not isOpen then return end
        local mp = UserInputService:GetMouseLocation()
        local lp = dropList.AbsolutePosition; local ls = dropList.AbsoluteSize
        local bp = dropBtn.AbsolutePosition; local bs = dropBtn.AbsoluteSize
        local inList = mp.X >= lp.X and mp.X <= lp.X + ls.X and mp.Y >= lp.Y and mp.Y <= lp.Y + ls.Y
        local inBtn  = mp.X >= bp.X and mp.X <= bp.X + bs.X and mp.Y >= bp.Y and mp.Y <= bp.Y + bs.Y
        if not inList and not inBtn then
            isOpen = false; dropList.Visible = false; openDropFrame = nil
        end
    end)
end

local function makeButton(parent, labelText, callback, order)
    local btn = Instance.new("TextButton", parent)
    btn.Size             = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(32, 42, 115)
    btn.BackgroundTransparency = 0.35
    btn.Text             = labelText
    btn.Font             = FONT_BODY
    btn.TextSize         = 13
    btn.TextColor3       = THEME.TEXT_MID
    btn.BorderSizePixel  = 0
    btn.LayoutOrder      = order or 0
    btn.ZIndex           = 6
    AddCorner(btn, 7)
    AddStroke(btn, THEME.BORDER, 1, 0.4)

    btn.MouseButton1Click:Connect(function()
        Tween(btn, {BackgroundTransparency = 0.05, TextColor3 = THEME.TEXT_BRIGHT}, 0.1)
        task.delay(0.25, function() Tween(btn, {BackgroundTransparency = 0.35, TextColor3 = THEME.TEXT_MID}, 0.15) end)
        if callback then callback() end
    end)
    btn.MouseEnter:Connect(function() Tween(btn, {BackgroundTransparency = 0.15, TextColor3 = THEME.TEXT_BRIGHT}, 0.1) end)
    btn.MouseLeave:Connect(function() Tween(btn, {BackgroundTransparency = 0.35, TextColor3 = THEME.TEXT_MID}, 0.1) end)
end

-- ===================== TOGGLE FLOAT BUTTON =====================
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size             = UDim2.new(0, 46, 0, 46)
ToggleBtn.Position         = UDim2.new(1, -56, 0, 10)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(45, 65, 185)
ToggleBtn.Text             = "⚡"
ToggleBtn.Font             = FONT_TITLE
ToggleBtn.TextSize         = 22
ToggleBtn.TextColor3       = Color3.new(1, 1, 1)
ToggleBtn.BorderSizePixel  = 0
ToggleBtn.ZIndex           = 100
AddCorner(ToggleBtn, 23)
AddStroke(ToggleBtn, THEME.ACCENT, 1, 0.4)

ToggleBtn.MouseButton1Click:Connect(function()
    Win.Visible = not Win.Visible
    if Win.Visible then
        Win.Size = UDim2.new(0, 700, 0, 0)
        Tween(Win, {Size = UDim2.new(0, 700, 0, 490)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        Win.Visible = not Win.Visible
        if Win.Visible then
            Win.Size = UDim2.new(0, 700, 0, 0)
            Tween(Win, {Size = UDim2.new(0, 700, 0, 490)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        end
    end
end)

-- ===================== TAB SYSTEM =====================
local tabs      = {}
local TabFrames = {}
local activeTab = nil

for _, name in ipairs(TAB_NAMES) do
    TabFrames[name] = makeScrollFrame()
end

local function selectTab(name)
    if activeTab then
        if TabFrames[activeTab] then TabFrames[activeTab].Visible = false end
        local oldBtn = tabs[activeTab]
        if oldBtn then
            Tween(oldBtn, {BackgroundTransparency = 0.85, TextColor3 = THEME.TEXT_DIM}, 0.15)
            local bar = oldBtn:FindFirstChild("AccentBar")
            if bar then Tween(bar, {BackgroundTransparency = 1}, 0.15) end
        end
    end
    activeTab = name
    if TabFrames[name] then TabFrames[name].Visible = true end
    local newBtn = tabs[name]
    if newBtn then
        Tween(newBtn, {BackgroundTransparency = 0.82, TextColor3 = Color3.new(1, 1, 1)}, 0.15)
        local bar = newBtn:FindFirstChild("AccentBar")
        if bar then Tween(bar, {BackgroundTransparency = 0}, 0.15) end
    end
end

for i, name in ipairs(TAB_NAMES) do
    local col = TAB_COLORS[name] or THEME.ACCENT
    local btn = Instance.new("TextButton", TabList)
    btn.Name             = name
    btn.Size             = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = col
    btn.BackgroundTransparency = 0.85
    btn.Text             = ""
    btn.BorderSizePixel  = 0
    btn.LayoutOrder      = i
    btn.ZIndex           = 5
    AddCorner(btn, 7)

    -- Left accent bar
    local acBar = Instance.new("Frame", btn)
    acBar.Name             = "AccentBar"
    acBar.Size             = UDim2.new(0, 2, 0, 20)
    acBar.Position         = UDim2.new(0, 0, 0.5, -10)
    acBar.BackgroundColor3 = col
    acBar.BackgroundTransparency = 1
    acBar.BorderSizePixel  = 0
    acBar.ZIndex           = 6
    AddCorner(acBar, 1)

    -- Dot
    local dot = Instance.new("Frame", btn)
    dot.Size             = UDim2.new(0, 6, 0, 6)
    dot.Position         = UDim2.new(0, 9, 0.5, -3)
    dot.BackgroundColor3 = col
    dot.BackgroundTransparency = 0.4
    dot.BorderSizePixel  = 0
    dot.ZIndex           = 6
    AddCorner(dot, 3)

    -- Label
    local lbl = Label(btn, name, 12, FONT_BODY, THEME.TEXT_DIM, Enum.TextXAlignment.Left)
    lbl.Size     = UDim2.new(1, -20, 1, 0)
    lbl.Position = UDim2.new(0, 20, 0, 0)
    lbl.ZIndex   = 6

    tabs[name] = btn
    btn.MouseButton1Click:Connect(function() selectTab(name) end)
    btn.MouseEnter:Connect(function()
        if activeTab ~= name then Tween(btn, {BackgroundTransparency = 0.75}, 0.1) end
    end)
    btn.MouseLeave:Connect(function()
        if activeTab ~= name then Tween(btn, {BackgroundTransparency = 0.85}, 0.1) end
    end)
end

-- ===================== ZENTRA FEATURE VARIABLES =====================
local shoveRadius = 8
local hitboxEnabled = false
local hitboxSize = 10
local zombieFolder = workspace:WaitForChild("Zombies")

local function addOuterHitbox(zombie)
    if not zombie or not zombie.Parent then return end
    local hrp = zombie:FindFirstChild("HumanoidRootPart")
    if hrp and not zombie:FindFirstChild("OuterHitbox") then
        pcall(function()
            local part = Instance.new("Part")
            part.Name = "OuterHitbox"; part.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
            part.Transparency = 1; part.Anchored = false; part.CanCollide = false
            part.Massless = true; part.CanTouch = true; part.CFrame = hrp.CFrame; part.Parent = zombie
            local weld = Instance.new("WeldConstraint"); weld.Part0 = hrp; weld.Part1 = part; weld.Parent = part
        end)
    end
end

local function removeHitboxes(zombie)
    if not zombie then return end
    pcall(function() local outer = zombie:FindFirstChild("OuterHitbox"); if outer then outer:Destroy() end end)
end

local function updateHitboxes(zombie)
    if not zombie then return end
    if hitboxEnabled then removeHitboxes(zombie); task.wait(0.05); addOuterHitbox(zombie)
    else removeHitboxes(zombie) end
end

local function toggleHitboxExpander(enabled)
    hitboxEnabled = enabled
    pcall(function() for _, zombie in pairs(zombieFolder:GetChildren()) do updateHitboxes(zombie) end end)
    pcall(function()
        for _, child in pairs(workspace.Camera:GetChildren()) do
            if child.Name == "m_Zombie" then updateHitboxes(child) end
        end
    end)
end

local function setHitboxSize(newSize)
    hitboxSize = newSize
    if hitboxEnabled then
        pcall(function() for _, zombie in pairs(zombieFolder:GetChildren()) do updateHitboxes(zombie) end end)
        pcall(function()
            for _, child in pairs(workspace.Camera:GetChildren()) do
                if child.Name == "m_Zombie" then updateHitboxes(child) end
            end
        end)
    end
end

zombieFolder.ChildAdded:Connect(function(zombie)
    if hitboxEnabled then task.spawn(function() task.wait(0.2); addOuterHitbox(zombie) end) end
end)
workspace.Camera.ChildAdded:Connect(function(child)
    if child.Name == "m_Zombie" and hitboxEnabled then
        task.spawn(function() task.wait(0.2); addOuterHitbox(child) end)
    end
end)

local maxShovePerCycle     = 30
local maxKillPerCycle      = 1
local killDelayMultiplier  = 1.0
local bayonetKillAuraRadius = 13
local bayonetAttackCooldown = 0.05
local autoFireRange         = 50
local autoFireHeadlessRange = 100
local basePrediction        = 0.15
local killAuraToggled       = false
local killAuraBomber        = false
local killAuraHitMode       = "Head"
local shoveAuraToggled      = false
local bayonetKillAuraToggled = false
local observerOnline        = false
local killAuraConnection    = nil
local isDead                = false

-- ===================== FEATURE CODE =====================
local success, errorMsg = pcall(function()

local zombiesToIgnore = {}
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Stats = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer

espRToggled = false; espBToggled = false; espIToggled = false
espCuToggled = false; espBossToggled = false; espZToggled = false
autoFaceToggled = false; autoFaceConnection = nil
autoFireToggled = false; autoFireConnection = nil; isFiring = false
isReloading = false; isFireAnimPlaying = false; currentTarget = nil; isHoldingAim = false
autoFireHeadlessToggled = false; autoFireHeadlessConnection = nil
isFireHeadless = false; isFireHeadlessAnimPlaying = false; headlessBoss = nil
local FLYING = false; local NO_FALL_DAMAGE = false; local FLY_SPEED = 35
local QEfly = true; local iyflyspeed = 1
local flyKeyDown, flyKeyUp
local IsOnMobile = table.find({Enum.Platform.Android,Enum.Platform.IOS},UIS:GetPlatform()) or (UIS.TouchEnabled and not UIS.KeyboardEnabled)
local NOCLIPPING = false; local noclipConnection = nil
local lastPosition = nil; local positionHistory = {}
local pullbackThreshold = 1.5; local stuckCounter = 0; local lastSafePosition = nil
local CAMERA = workspace.CurrentCamera
wallbangEnabled = false

local autoPredictionEnabled = true
if type(basePrediction) ~= "number" then basePrediction = 0.15 end
local currentPrediction = basePrediction

local AUTO_FIRE_TARGETS = {BARREL=1,IGNITER=2}
local smoothRotationSpeed = 8

local function smoothLookAtWithVelocity(hrp, targetPosition, deltaTime)
    if not hrp then return end
    local targetDirection = Vector3.new(targetPosition.X - hrp.Position.X, 0, targetPosition.Z - hrp.Position.Z)
    if targetDirection.Magnitude > 0 then
        local targetCFrame = CFrame.lookAt(hrp.Position, hrp.Position + targetDirection.Unit)
        local alpha = 1 - math.exp(-smoothRotationSpeed * deltaTime)
        hrp.CFrame = hrp.CFrame:Lerp(targetCFrame, alpha)
    end
end

local function getRoot(char)
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
end

local function playWeaponAnimation(weapon, animationName)
    if not weapon then return nil end
    local animTrack = nil
    pcall(function()
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if not humanoid then return end
        local animator = humanoid:FindFirstChild("Animator"); if not animator then return end
        local animFolder = weapon:FindFirstChild("Animations")
        if animFolder then
            local anim = animFolder:FindFirstChild(animationName)
            if anim and anim:IsA("Animation") then
                animTrack = animator:LoadAnimation(anim)
                animTrack.Looped = false; animTrack:Play()
            end
        end
    end)
    return animTrack
end

local function stopWeaponAnimation(animTrack)
    if animTrack then pcall(function() animTrack:Stop(); animTrack:Destroy() end) end
end

local function getWeaponAnimationLength(weapon, animationType)
    local animationTimes = {Fire=0.5,Reload=3.5,Aim=0.3,Aiming=999}
    if weapon then
        local n = weapon.Name:lower()
        if n:find("musket") or n:find("charleville") then animationTimes.Reload = 4.0
        elseif n:find("pistol") then animationTimes.Reload = 3.0; animationTimes.Fire = 0.4
        elseif n:find("blunderbuss") then animationTimes.Reload = 3.5; animationTimes.Fire = 0.6
        elseif n:find("carbine") then animationTimes.Reload = 3.2 end
    end
    return animationTimes[animationType] or 1.0
end

local function getEquippedFlintlock()
    if not LocalPlayer.Character then return nil end
    for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
        if tool:IsA("Tool") then
            local config = tool:FindFirstChild("Configuration")
            if config and (tool:FindFirstChild("RemoteEvent") or tool:FindFirstChild("Remote")) then return tool end
        end
    end
    return nil
end

local function isTargetVisible(startPos, targetPos, targetModel)
    if wallbangEnabled then return true end
    local rayParams = RaycastParams.new()
    local ignoreList = {LocalPlayer.Character}
    rayParams.FilterType = Enum.RaycastFilterType.Exclude; rayParams.IgnoreWater = true
    pcall(function() for _, zombie in pairs(workspace.Zombies:GetChildren()) do if zombie ~= targetModel then table.insert(ignoreList, zombie) end end end)
    pcall(function()
        for _, child in pairs(workspace.Camera:GetChildren()) do
            if child.Name == "m_Zombie" then
                local Origin = child:FindFirstChild("Orig")
                if Origin and Origin.Value and Origin.Value ~= targetModel then
                    table.insert(ignoreList, child); table.insert(ignoreList, Origin.Value)
                end
            end
        end
    end)
    rayParams.FilterDescendantsInstances = ignoreList
    local direction = targetPos - startPos
    local rayResult = workspace:Raycast(startPos, direction, rayParams)
    if rayResult then
        local hitPart = rayResult.Instance
        if hitPart:IsDescendantOf(targetModel) then return true end
        if hitPart.Parent.Name == "m_Zombie" then
            local Origin = hitPart.Parent:FindFirstChild("Orig")
            if Origin and Origin.Value == targetModel then return true end
        end
        if hitPart.CanCollide == false then
            local newRayParams = RaycastParams.new()
            newRayParams.FilterDescendantsInstances = {LocalPlayer.Character, hitPart, unpack(zombiesToIgnore)}
            newRayParams.FilterType = Enum.RaycastFilterType.Exclude; newRayParams.IgnoreWater = true
            local newRayResult = workspace:Raycast(startPos, direction, newRayParams)
            if newRayResult then
                if newRayResult.Instance:IsDescendantOf(targetModel) then return true end
                if newRayResult.Instance.Parent.Name == "m_Zombie" then
                    local Origin = newRayResult.Instance.Parent:FindFirstChild("Orig")
                    if Origin and Origin.Value == targetModel then return true end
                end
                return false
            else return false end
        end
        return false
    end
    return true
end

local function isHeadlessVisible(startPos, targetPos, headlessBoss)
    if wallbangEnabled then return true end
    local zIgnore = {}
    pcall(function() for _, zombie in pairs(workspace.Zombies:GetChildren()) do table.insert(zIgnore, zombie) end end)
    pcall(function()
        for _, child in pairs(workspace.Camera:GetChildren()) do
            if child.Name == "m_Zombie" then
                table.insert(zIgnore, child)
                local Origin = child:FindFirstChild("Orig")
                if Origin and Origin.Value then table.insert(zIgnore, Origin.Value) end
            end
        end
    end)
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {LocalPlayer.Character, unpack(zIgnore)}
    rayParams.FilterType = Enum.RaycastFilterType.Exclude; rayParams.IgnoreWater = true
    local direction = targetPos - startPos
    local rayResult = workspace:Raycast(startPos, direction, rayParams)
    if rayResult then
        local hitPart = rayResult.Instance
        if headlessBoss and hitPart:IsDescendantOf(headlessBoss) then return true end
        if hitPart.CanCollide == false then
            local newRayParams = RaycastParams.new()
            newRayParams.FilterDescendantsInstances = {LocalPlayer.Character, hitPart, unpack(zIgnore)}
            newRayParams.FilterType = Enum.RaycastFilterType.Exclude; newRayParams.IgnoreWater = true
            local newRayResult = workspace:Raycast(startPos, direction, newRayParams)
            if newRayResult then
                if headlessBoss and newRayResult.Instance:IsDescendantOf(headlessBoss) then return true end
                return false
            else return false end
        end
        return false
    end
    return true
end

local function findHeadlessBoss()
    local success, result = pcall(function()
        local sh = workspace:FindFirstChild("Sleepy Hollow"); if not sh then return nil end
        local modes = sh:FindFirstChild("Modes"); if not modes then return nil end
        local boss = modes:FindFirstChild("Boss"); if not boss then return nil end
        local hb = boss:FindFirstChild("HeadlessHorsemanBoss"); if not hb then return nil end
        return hb:FindFirstChild("HeadlessHorseman")
    end)
    return success and result or nil
end

local function calculateAutoPrediction()
    if not autoPredictionEnabled or not headlessBoss then return basePrediction end
    local torso = headlessBoss:FindFirstChild("Torso"); if not torso then return basePrediction end
    local velocity = torso.AssemblyLinearVelocity or Vector3.new(0,0,0)
    local speed = velocity.Magnitude
    local prediction = basePrediction
    if speed < 5 then prediction = 0.05
    elseif speed < 15 then prediction = 0.1
    elseif speed < 25 then prediction = 0.15
    elseif speed < 35 then prediction = 0.25
    else prediction = 0.35 end
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp and torso then
        local direction = (torso.Position - hrp.Position).Unit
        local moveDirection = velocity.Unit
        local dotProduct = direction:Dot(moveDirection)
        if math.abs(dotProduct) < 0.5 then prediction = prediction * 1.3 end
    end
    return prediction
end

task.spawn(function()
    while true do
        task.wait(0.1)
        if autoPredictionEnabled and autoFireHeadlessToggled then
            currentPrediction = calculateAutoPrediction()
        end
    end
end)

local function getPredictedHeadlessPosition()
    if not headlessBoss or not headlessBoss.Parent then return nil end
    local torso = headlessBoss:FindFirstChild("Torso"); if not torso then return nil end
    local velocity = torso.AssemblyLinearVelocity or Vector3.new(0,0,0)
    return torso.Position + (velocity * currentPrediction)
end

local function findNearestTarget()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return nil,nil,nil end
    local hrp = LocalPlayer.Character.HumanoidRootPart
    local head = LocalPlayer.Character:FindFirstChild("Head"); if not head then return nil,nil,nil end
    local candidates = {}
    pcall(function()
        for _, zombie in pairs(workspace.Zombies:GetChildren()) do
            local zombieHRP = zombie:FindFirstChild("HumanoidRootPart")
            local zombieHead = zombie:FindFirstChild("Head")
            local hasBarrel = zombie:FindFirstChild("Barrel") ~= nil
            if zombieHRP and zombieHead and hasBarrel then
                local distance = (zombieHRP.Position - hrp.Position).Magnitude
                if distance < autoFireRange then
                    table.insert(candidates, {zombie=zombie,head=zombieHead,distance=distance,priority=AUTO_FIRE_TARGETS.BARREL,targetType="Barrel"})
                end
            end
        end
    end)
    pcall(function()
        for _, child in pairs(workspace.Camera:GetChildren()) do
            if child.Name == "m_Zombie" then
                local Origin = child:FindFirstChild("Orig")
                if Origin and Origin.Value then
                    local zombie = Origin.Value
                    local zombieHRP = zombie:FindFirstChild("HumanoidRootPart")
                    local zombieHead = zombie:FindFirstChild("Head")
                    local hasBarrel = child:FindFirstChild("Barrel") ~= nil
                    if zombieHRP and zombieHead and hasBarrel then
                        local distance = (zombieHRP.Position - hrp.Position).Magnitude
                        if distance < autoFireRange then
                            table.insert(candidates, {zombie=zombie,head=zombieHead,distance=distance,priority=AUTO_FIRE_TARGETS.BARREL,targetType="Barrel"})
                        end
                    end
                end
                local lantern = child:FindFirstChild("Whale Oil Lantern")
                if lantern then
                    local Origin = child:FindFirstChild("Orig")
                    if Origin and Origin.Value then
                        local zombie = Origin.Value
                        local zombieHRP = zombie:FindFirstChild("HumanoidRootPart")
                        local zombieHead = zombie:FindFirstChild("Head")
                        if zombieHRP and zombieHead then
                            local distance = (zombieHRP.Position - hrp.Position).Magnitude
                            if distance < autoFireRange then
                                table.insert(candidates, {zombie=zombie,head=zombieHead,distance=distance,priority=AUTO_FIRE_TARGETS.IGNITER,targetType="Igniter"})
                            end
                        end
                    end
                end
            end
        end
    end)
    table.sort(candidates, function(a, b)
        if a.priority ~= b.priority then return a.priority < b.priority end
        return a.distance < b.distance
    end)
    if wallbangEnabled and #candidates > 0 then
        local target = candidates[1]; return target.zombie, target.head, target.targetType
    end
    for _, candidate in ipairs(candidates) do
        if isTargetVisible(head.Position, candidate.head.Position, candidate.zombie) then
            return candidate.zombie, candidate.head, candidate.targetType
        end
    end
    return nil, nil, nil
end

local currentAimTrack, currentFireTrack, currentHeadlessAimTrack, currentHeadlessFireTrack
local aimingForShot, rotatingToTarget, targetRotation

local function autoFireAtTarget()
    if not autoFireToggled or not LocalPlayer.Character then return end
    if isFiring or isReloading or isFireAnimPlaying then return end
    local weapon = getEquippedFlintlock(); if not weapon then return end
    local ammo = weapon:FindFirstChild("Ammo") or weapon:FindFirstChild("ShotsLoaded")
    if not ammo or ammo.Value <= 0 then
        if isHoldingAim then stopWeaponAnimation(currentAimTrack); currentAimTrack = nil; isHoldingAim = false end
        currentTarget = nil; return
    end
    local targetZombie, targetHead, targetType = findNearestTarget()
    if not targetZombie or not targetHead then
        if isHoldingAim then stopWeaponAnimation(currentAimTrack); currentAimTrack = nil; isHoldingAim = false end
        currentTarget = nil; return
    end
    local remoteEvent = weapon:FindFirstChild("RemoteEvent") or weapon:FindFirstChild("Remote"); if not remoteEvent then return end
    local model = weapon:FindFirstChild("ModelReference"); if model then model = model.Value end; if not model then return end
    isFiring = true; isFireAnimPlaying = true; aimingForShot = true; currentTarget = targetZombie
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not isHoldingAim then
        currentAimTrack = playWeaponAnimation(weapon, "Aim")
        if currentAimTrack then currentAimTrack.Looped = false end
        task.wait(getWeaponAnimationLength(weapon, "Aim"))
        stopWeaponAnimation(currentAimTrack)
        currentAimTrack = playWeaponAnimation(weapon, "Aiming")
        if currentAimTrack then currentAimTrack.Looped = true end
        isHoldingAim = true
    end
    if hrp then
        rotatingToTarget = true; targetRotation = targetHead.Position
        local rotationTime = 0; local maxRotationTime = 1.0
        local rotateConnection
        rotateConnection = RunService.RenderStepped:Connect(function(deltaTime)
            if not rotatingToTarget or not targetRotation then if rotateConnection then rotateConnection:Disconnect() end return end
            if currentTarget and currentTarget:FindFirstChild("Head") then targetRotation = currentTarget.Head.Position end
            smoothLookAtWithVelocity(hrp, targetRotation, deltaTime)
            rotationTime = rotationTime + deltaTime
            local currentDirection = hrp.CFrame.LookVector
            local targetDirection = (targetRotation - hrp.Position).Unit
            local dotProduct = currentDirection:Dot(Vector3.new(targetDirection.X, 0, targetDirection.Z).Unit)
            if dotProduct > 0.98 or rotationTime >= maxRotationTime then
                rotatingToTarget = false; if rotateConnection then rotateConnection:Disconnect() end
            end
        end)
        while rotatingToTarget do task.wait() end
    end
    stopWeaponAnimation(currentAimTrack); currentAimTrack = nil; aimingForShot = false; isHoldingAim = false
    local fireOk = pcall(function()
        local targetPosition = targetHead.Position
        local serverTime = workspace:GetServerTimeNow()
        currentFireTrack = playWeaponAnimation(weapon, "Fire")
        remoteEvent:FireServer("Fire", model, targetPosition, serverTime)
    end)
    local fireTime = getWeaponAnimationLength(weapon, "Fire")
    if fireOk then task.wait(fireTime) end
    stopWeaponAnimation(currentFireTrack); currentFireTrack = nil
    isFireAnimPlaying = false; isFiring = false; aimingForShot = false; isHoldingAim = false; currentTarget = nil
    if fireOk then _G.AutoReloadV2.ReloadWeapon(weapon) end
end

local function autoFireAtHeadless()
    if not autoFireHeadlessToggled or not LocalPlayer.Character then return end
    if isFireHeadless or isReloading or isFireHeadlessAnimPlaying then return end
    headlessBoss = findHeadlessBoss()
    if not headlessBoss or not headlessBoss.Parent then
        if isHoldingAim then stopWeaponAnimation(currentHeadlessAimTrack); currentHeadlessAimTrack = nil; isHoldingAim = false end
        return
    end
    local torso = headlessBoss:FindFirstChild("Torso"); if not torso then return end
    local hrp = LocalPlayer.Character.HumanoidRootPart
    local head = LocalPlayer.Character:FindFirstChild("Head"); if not hrp or not head then return end
    local distance = (torso.Position - hrp.Position).Magnitude
    if distance > autoFireHeadlessRange then
        if isHoldingAim then stopWeaponAnimation(currentHeadlessAimTrack); currentHeadlessAimTrack = nil; isHoldingAim = false end
        return
    end
    local predictedPos = getPredictedHeadlessPosition(); if not predictedPos then return end
    if not isHeadlessVisible(head.Position, predictedPos, headlessBoss) then
        if isHoldingAim then stopWeaponAnimation(currentHeadlessAimTrack); currentHeadlessAimTrack = nil; isHoldingAim = false end
        return
    end
    local weapon = getEquippedFlintlock(); if not weapon then return end
    local ammo = weapon:FindFirstChild("Ammo") or weapon:FindFirstChild("ShotsLoaded")
    if not ammo or ammo.Value <= 0 then
        if isHoldingAim then stopWeaponAnimation(currentHeadlessAimTrack); currentHeadlessAimTrack = nil; isHoldingAim = false end
        return
    end
    local remoteEvent = weapon:FindFirstChild("RemoteEvent") or weapon:FindFirstChild("Remote"); if not remoteEvent then return end
    local model = weapon:FindFirstChild("ModelReference"); if model then model = model.Value end; if not model then return end
    isFireHeadless = true; isFireHeadlessAnimPlaying = true
    if not isHoldingAim then
        currentHeadlessAimTrack = playWeaponAnimation(weapon, "Aim")
        if currentHeadlessAimTrack then currentHeadlessAimTrack.Looped = false end
        task.wait(getWeaponAnimationLength(weapon, "Aim"))
        stopWeaponAnimation(currentHeadlessAimTrack)
        currentHeadlessAimTrack = playWeaponAnimation(weapon, "Aiming")
        if currentHeadlessAimTrack then currentHeadlessAimTrack.Looped = true end
        isHoldingAim = true
    end
    local rotatingToHeadless = true; local targetHeadlessRotation = predictedPos
    local rotationTime = 0; local maxRotationTime = 1.0
    local rotateConnection
    rotateConnection = RunService.RenderStepped:Connect(function(deltaTime)
        if not rotatingToHeadless or not targetHeadlessRotation then if rotateConnection then rotateConnection:Disconnect() end return end
        local newPredicted = getPredictedHeadlessPosition()
        if newPredicted then targetHeadlessRotation = newPredicted end
        smoothLookAtWithVelocity(hrp, targetHeadlessRotation, deltaTime)
        rotationTime = rotationTime + deltaTime
        local currentDirection = hrp.CFrame.LookVector
        local targetDirection = (targetHeadlessRotation - hrp.Position).Unit
        local dotProduct = currentDirection:Dot(Vector3.new(targetDirection.X, 0, targetDirection.Z).Unit)
        if dotProduct > 0.98 or rotationTime >= maxRotationTime then
            rotatingToHeadless = false; if rotateConnection then rotateConnection:Disconnect() end
        end
    end)
    while rotatingToHeadless do task.wait() end
    stopWeaponAnimation(currentHeadlessAimTrack); currentHeadlessAimTrack = nil; isHoldingAim = false
    local fireOk = pcall(function()
        local serverTime = workspace:GetServerTimeNow()
        currentHeadlessFireTrack = playWeaponAnimation(weapon, "Fire")
        remoteEvent:FireServer("Fire", model, predictedPos, serverTime)
    end)
    local fireTime = getWeaponAnimationLength(weapon, "Fire")
    if fireOk then task.wait(fireTime) end
    stopWeaponAnimation(currentHeadlessFireTrack); currentHeadlessFireTrack = nil
    isFireHeadlessAnimPlaying = false; isFireHeadless = false; isHoldingAim = false
    if fireOk then _G.AutoReloadV2.ReloadWeapon(weapon) end
end

local function toggleWallbang(enabled) wallbangEnabled = enabled end

local function startAutoFire()
    if autoFireConnection then autoFireConnection:Disconnect(); autoFireConnection = nil end
    autoFireConnection = RunService.Heartbeat:Connect(function()
        if not autoFireToggled then autoFireConnection:Disconnect(); autoFireConnection = nil; return end
        if not isFiring and not isFireAnimPlaying then task.spawn(autoFireAtTarget) end
    end)
end

local function startAutoFireHeadless()
    if autoFireHeadlessConnection then autoFireHeadlessConnection:Disconnect(); autoFireHeadlessConnection = nil end
    autoFireHeadlessConnection = RunService.Heartbeat:Connect(function()
        if not autoFireHeadlessToggled then autoFireHeadlessConnection:Disconnect(); autoFireHeadlessConnection = nil; return end
        if not isFireHeadless and not isFireHeadlessAnimPlaying then task.spawn(autoFireAtHeadless) end
    end)
end

local function toggleAutoFire(enabled)
    autoFireToggled = enabled
    if enabled then
        isFiring = false; isReloading = false; isFireAnimPlaying = false; currentTarget = nil; startAutoFire()
    else
        stopWeaponAnimation(currentAimTrack); stopWeaponAnimation(currentFireTrack)
        currentAimTrack = nil; currentFireTrack = nil
        if autoFireConnection then autoFireConnection:Disconnect(); autoFireConnection = nil end
        isFiring = false; isReloading = false; isFireAnimPlaying = false; aimingForShot = false; currentTarget = nil
    end
end

local function toggleAutoFireHeadless(enabled)
    autoFireHeadlessToggled = enabled
    if enabled then
        isFireHeadless = false; isReloading = false; isFireHeadlessAnimPlaying = false; headlessBoss = nil; startAutoFireHeadless()
    else
        stopWeaponAnimation(currentHeadlessAimTrack); stopWeaponAnimation(currentHeadlessFireTrack)
        currentHeadlessAimTrack = nil; currentHeadlessFireTrack = nil
        if autoFireHeadlessConnection then autoFireHeadlessConnection:Disconnect(); autoFireHeadlessConnection = nil end
        isFireHeadless = false; isReloading = false; isFireHeadlessAnimPlaying = false; headlessBoss = nil
    end
end

-- Auto Reload V2
local RunService2 = game:GetService("RunService")
local autoReloadToggled = false; local autoReloadConnection = nil; local currentReloadMode = 2
local activeReloads = {}; local lastReloadAttempt = {}
local ReloadMode = {FAST=1,ANIMATION=2,BACKGROUND=3}

local function getEquippedWeapon()
    if not LocalPlayer.Character then return nil end
    for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
        if tool:IsA("Tool") then
            local remoteEvent = tool:FindFirstChild("RemoteEvent") or tool:FindFirstChild("Remote")
            if remoteEvent then return tool end
        end
    end
    return nil
end

local function getWeaponAmmo(weapon) if not weapon then return 0 end; local ammo = weapon:FindFirstChild("Ammo") or weapon:FindFirstChild("ShotsLoaded"); if ammo then return ammo.Value end; return 0 end
local function getWeaponCartridges(weapon) if not weapon then return 0 end; local c = weapon:FindFirstChild("Cartridges"); if c then return c.Value end; return 999 end
local function needsReload(weapon) if not weapon then return false end; return getWeaponAmmo(weapon) <= 0 and getWeaponCartridges(weapon) > 0 end
local function isWeaponInInventory(weapon)
    if not weapon or not weapon.Parent then return false end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(weapon.Name) then return true end
    if LocalPlayer.Backpack:FindFirstChild(weapon.Name) then return true end
    return false
end

local function bypassServerReloadChecks(weapon)
    if not weapon then return false end
    pcall(function()
        weapon:SetAttribute("Reloading", false); weapon:SetAttribute("Stancing", false)
        weapon:SetAttribute("Firing", false); weapon:SetAttribute("Aiming", false)
        weapon:SetAttribute("IsReloading", false); weapon:SetAttribute("ReloadLocked", false)
        local reloadStage = weapon:FindFirstChild("ReloadStage"); if reloadStage then reloadStage.Value = 0 end
        local ammo = weapon:FindFirstChild("Ammo") or weapon:FindFirstChild("ShotsLoaded")
        if ammo then ammo.Value = 0; task.wait(0.03) end
        local cfg = weapon:FindFirstChild("Configuration")
        if cfg then pcall(function() cfg:SetAttribute("Reloading", false); cfg:SetAttribute("Stancing", false) end) end
    end)
    return true
end

local function stealthReloadSequence(weapon)
    if not weapon then return false end
    local remoteEvent = weapon:FindFirstChild("RemoteEvent") or weapon:FindFirstChild("Remote"); if not remoteEvent then return false end
    local success = false
    task.spawn(function()
        bypassServerReloadChecks(weapon)
        for i = 1, 3 do
            pcall(function() remoteEvent:FireServer("Reload") end); task.wait(0.1)
            local ammo = getWeaponAmmo(weapon); if ammo > 0 then success = true; break end
            pcall(function()
                local reloadStage = weapon:FindFirstChild("ReloadStage")
                if reloadStage then
                    reloadStage.Value = 1; task.wait(0.05); remoteEvent:FireServer("Reload")
                    task.wait(0.1); reloadStage.Value = 2; task.wait(0.05); remoteEvent:FireServer("Reload")
                end
            end); task.wait(0.1)
        end
        if success then pcall(function() weapon:SetAttribute("Reloading", false); weapon:SetAttribute("Stancing", false) end) end
    end)
    return true
end

local function fastReload(weapon)
    if not weapon then return false end
    local remoteEvent = weapon:FindFirstChild("RemoteEvent") or weapon:FindFirstChild("Remote"); if not remoteEvent then return false end
    bypassServerReloadChecks(weapon); pcall(function() remoteEvent:FireServer("Reload") end); task.wait(0.5); return true
end

local function animationReloadMode(weapon)
    if not weapon or not weapon.Parent then return false end
    if not LocalPlayer.Character then return false end
    if isReloading then return false end
    local remoteEvent = weapon:FindFirstChild("RemoteEvent") or weapon:FindFirstChild("Remote"); if not remoteEvent then return false end
    local isEquipped = LocalPlayer.Character:FindFirstChild(weapon.Name) ~= nil; if not isEquipped then return false end
    isReloading = true; bypassServerReloadChecks(weapon); pcall(function() remoteEvent:FireServer("Reload") end); task.wait(4.5); isReloading = false; return true
end

local function backgroundReload(weapon)
    if not weapon then return false end
    if activeReloads[weapon] then return false end
    activeReloads[weapon] = true
    task.spawn(function()
        stealthReloadSequence(weapon)
        local maxWait = 8; local startTime = tick(); local startAmmo = getWeaponAmmo(weapon)
        while tick() - startTime < maxWait do
            task.wait(0.2)
            if not isWeaponInInventory(weapon) then break end
            if getWeaponAmmo(weapon) > startAmmo then break end
            local remoteEvent = weapon:FindFirstChild("RemoteEvent") or weapon:FindFirstChild("Remote")
            if remoteEvent then pcall(function() bypassServerReloadChecks(weapon); remoteEvent:FireServer("Reload") end) end
        end
        activeReloads[weapon] = nil
        pcall(function() weapon:SetAttribute("Reloading", false); weapon:SetAttribute("Stancing", false); weapon:SetAttribute("Firing", false) end)
    end)
    return true
end

local function performReload(weapon)
    if not weapon or not needsReload(weapon) then return false end
    local currentTime = tick()
    if lastReloadAttempt[weapon] and currentTime - lastReloadAttempt[weapon] < 0.8 then return false end
    lastReloadAttempt[weapon] = currentTime
    if currentReloadMode == ReloadMode.FAST then return fastReload(weapon)
    elseif currentReloadMode == ReloadMode.ANIMATION then return animationReloadMode(weapon)
    elseif currentReloadMode == ReloadMode.BACKGROUND then return backgroundReload(weapon) end
    return false
end

local lastCheck = 0; local CHECK_INTERVAL = 0.3

local function startAutoReload()
    if autoReloadConnection then autoReloadConnection:Disconnect() end
    autoReloadConnection = RunService2.Heartbeat:Connect(function()
        if not autoReloadToggled then return end
        local currentTime = tick(); if currentTime - lastCheck < CHECK_INTERVAL then return end; lastCheck = currentTime
        local equippedWeapon = getEquippedWeapon()
        if equippedWeapon and needsReload(equippedWeapon) then
            if currentReloadMode == ReloadMode.ANIMATION or currentReloadMode == ReloadMode.FAST then
                task.spawn(function() performReload(equippedWeapon) end)
            end
        end
        if currentReloadMode == ReloadMode.BACKGROUND then
            for _, weapon in pairs(LocalPlayer.Backpack:GetChildren()) do
                if weapon:IsA("Tool") and needsReload(weapon) then task.spawn(function() performReload(weapon) end) end
            end
            if equippedWeapon and needsReload(equippedWeapon) then task.spawn(function() performReload(equippedWeapon) end) end
        end
    end)
end

local function toggleAutoReload(enabled)
    autoReloadToggled = enabled
    if enabled then startAutoReload()
    else if autoReloadConnection then autoReloadConnection:Disconnect(); autoReloadConnection = nil end end
end

local function setReloadMode(mode)
    if mode < 1 or mode > 3 then return end
    currentReloadMode = mode
    if autoReloadToggled then toggleAutoReload(false); task.wait(0.1); toggleAutoReload(true) end
end

_G.AutoReloadV2 = {
    Toggle = toggleAutoReload, SetMode = setReloadMode,
    IsEnabled = function() return autoReloadToggled end,
    GetMode = function() return currentReloadMode end,
    ReloadWeapon = performReload, Modes = ReloadMode
}

-- ESP
local bossFolder = nil; local bossESPConnection = nil
local function updateBossESP()
    pcall(function()
        local sleepyHollow = workspace:WaitForChild("Sleepy Hollow", 5); if not sleepyHollow then return end
        local modes = sleepyHollow:FindFirstChild("Modes"); if not modes then return end
        local boss = modes:FindFirstChild("Boss"); if not boss then return end
        bossFolder = boss:FindFirstChild("HeadlessHorsemanBoss")
        if bossFolder then
            if not espBossToggled then
                for _, child in pairs(bossFolder:GetChildren()) do if child:FindFirstChild("Highlight") then child.Highlight:Destroy() end end
                return
            end
            for _, child in pairs(bossFolder:GetChildren()) do
                if child and child.Parent and not child:FindFirstChild("Highlight") then
                    local h = Instance.new("Highlight"); h.Parent = child; h.Adornee = child
                    h.FillColor = Color3.fromRGB(255,0,0); h.OutlineColor = Color3.fromRGB(255,255,255); h.OutlineTransparency = 0.5
                end
            end
        end
    end)
end
local function setupBossESP()
    if bossESPConnection then bossESPConnection:Disconnect(); bossESPConnection = nil end
    task.spawn(function()
        while task.wait(2) do
            if not espBossToggled then return end
            updateBossESP()
            if bossFolder and not bossESPConnection then
                bossESPConnection = bossFolder.ChildAdded:Connect(function(child)
                    if espBossToggled and child and child.Parent then
                        task.wait(0.1)
                        if not child:FindFirstChild("Highlight") then
                            local h = Instance.new("Highlight"); h.Parent = child; h.Adornee = child
                            h.FillColor = Color3.fromRGB(255,0,0); h.OutlineColor = Color3.fromRGB(255,255,255); h.OutlineTransparency = 0.5
                        end
                    end
                end)
            elseif not bossFolder and bossESPConnection then bossESPConnection:Disconnect(); bossESPConnection = nil end
        end
    end)
end
setupBossESP()

workspace.Camera.ChildAdded:Connect(function(child)
    if child.Name == "m_Zombie" then
        task.spawn(function()
            local Origin = child:FindFirstChild("Orig")
            if not Origin then task.wait(0.1); Origin = child:FindFirstChild("Orig") end
            if Origin and Origin.Value ~= nil then
                local zombie = Origin.Value:FindFirstChild("Zombie"); if not zombie then return end
                if espRToggled and zombie.WalkSpeed > 20 then local h = Instance.new("Highlight"); h.Parent = child; h.Adornee = child end
                if espBToggled and child:FindFirstChild("Barrel") ~= nil then local h = Instance.new("Highlight"); h.Parent = child; h.Adornee = child; h.FillColor = Color3.fromRGB(65,105,225) end
                if espIToggled and child:FindFirstChild("Whale Oil Lantern") ~= nil then local h = Instance.new("Highlight"); h.Parent = child; h.Adornee = child; h.FillColor = Color3.fromRGB(255,255,51) end
                if espCuToggled and child:FindFirstChild("Sword") ~= nil then local h = Instance.new("Highlight"); h.Parent = child; h.Adornee = child; h.FillColor = Color3.fromRGB(65,105,225) end
                if espZToggled and child:FindFirstChild("Axe") ~= nil then local h = Instance.new("Highlight"); h.Parent = child; h.Adornee = child; h.FillColor = Color3.fromRGB(255,0,255) end
            end
        end)
    end
end)

espMedicToggled = false; espInfectionToggled = false
function checkPlayersLife()
    if not espMedicToggled and not espInfectionToggled then
        for _, player in pairs(workspace.Players:GetChildren()) do if player:FindFirstChild("Highlight") then player.Highlight:Destroy() end end
        return
    end
    while espMedicToggled or espInfectionToggled do
        for _, player in pairs(workspace.Players:GetChildren()) do
            if espMedicToggled then
                local humanoid = player:FindFirstChild("Humanoid")
                if humanoid and humanoid.Health < 60 and player.Name ~= LocalPlayer.Name and
                   (LocalPlayer.Backpack:FindFirstChild("Medical Supplies") or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Medical Supplies"))) then
                    if not player:FindFirstChild("Highlight") then
                        local h = Instance.new("Highlight"); h.Parent = player; h.Adornee = player
                        h.FillColor = Color3.fromRGB(255,169,108); h.FillTransparency = 0.8
                        h.OutlineColor = Color3.fromRGB(255,206,108); h.OutlineTransparency = 0.2
                    end
                else if player:FindFirstChild("Highlight") then player.Highlight:Destroy() end end
            end
            if espInfectionToggled then
                if LocalPlayer.Backpack:FindFirstChild("Mercy") or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Mercy")) then
                    local userStates = player:FindFirstChild("UserStates")
                    if userStates and userStates:FindFirstChild("Infected") then
                        local infectedVal = userStates.Infected.Value
                        if infectedVal > 10 then
                            local existingHighlight = player:FindFirstChild("Highlight")
                            if infectedVal > 89 then
                                local h = existingHighlight or Instance.new("Highlight")
                                h.Parent = player; h.Adornee = player; h.FillColor = Color3.fromRGB(178,34,34)
                            else
                                if not existingHighlight then
                                    local h = Instance.new("Highlight"); h.Parent = player; h.Adornee = player
                                    h.FillColor = Color3.fromRGB(255,169,108); h.FillTransparency = 0.8
                                    h.OutlineColor = Color3.fromRGB(255,206,108); h.OutlineTransparency = 0.2
                                end
                            end
                        elseif player:FindFirstChild("Highlight") and infectedVal == 0 then player.Highlight:Destroy() end
                    end
                end
            end
        end
        task.wait(2.0)
    end
end

toolEquip = true

LocalPlayer.CharacterAdded:Connect(function(character)
    stopWeaponAnimation(currentAimTrack); stopWeaponAnimation(currentFireTrack)
    currentAimTrack = nil; currentFireTrack = nil
    stopWeaponAnimation(currentHeadlessAimTrack); stopWeaponAnimation(currentHeadlessFireTrack)
    currentHeadlessAimTrack = nil; currentHeadlessFireTrack = nil
    isReloading = false; activeReloads = {}; lastReloadAttempt = {}
    isFiring = false; isFireAnimPlaying = false; currentTarget = nil
    isFireHeadless = false; isFireHeadlessAnimPlaying = false; headlessBoss = nil
    if autoFireToggled then task.wait(1); startAutoFire() end
    if autoFireHeadlessToggled then task.wait(1); startAutoFireHeadless() end
    if autoReloadToggled then task.wait(1); _G.AutoReloadV2.Toggle(false); task.wait(0.1); _G.AutoReloadV2.Toggle(true) end
end)

-- Kill & Shove Aura
observerOnline = false; killAuraToggled = false; shoveAuraToggled = false; isDead = false; killAuraConnection = nil
shoveRadius = 8; maxShovePerCycle = 30
local stunCooldowns = {}; local lastShoveTime = 0; local shoveStunCooldown = 0.15; local lastAttackTime = 0
local killAuraRadius = 13
maxKillPerCycle = maxKillPerCycle or 1; killDelayMultiplier = killDelayMultiplier or 1.0
local adaptiveKillDelay = 0.2; local adaptiveAttackDelay = 0.2; local killAuraActive = true
local cycleStartTime = tick(); local cycleDuration = 0.1; local pauseDuration = 1.0
local currentPing = 0; local lagCompensationMultiplier = 1.0

local function updatePing()
    task.spawn(function()
        while task.wait(2) do
            pcall(function()
                currentPing = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
                if currentPing > 200 then lagCompensationMultiplier = 1.3; adaptiveAttackDelay = 0.3; pauseDuration = 1.5
                elseif currentPing > 100 then lagCompensationMultiplier = 1.15; adaptiveAttackDelay = 0.25; pauseDuration = 1.2
                else lagCompensationMultiplier = 1.0; adaptiveAttackDelay = 0.2; pauseDuration = 1.0 end
            end)
        end
    end)
end
updatePing()

local raycastParams = RaycastParams.new()
raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
raycastParams.FilterType = Enum.RaycastFilterType.Exclude
local params = OverlapParams.new()
params.FilterDescendantsInstances = {LocalPlayer.Character}

function getEquippedWeapon()
    if not LocalPlayer.Character then return nil end
    for _, child in pairs(LocalPlayer.Character:GetChildren()) do
        if child:IsA("Tool") and (child:FindFirstChild("RemoteEvent") or child:FindFirstChild("Remote")) then return child end
    end
    return nil
end

function canWeaponShove(weapon)
    if not weapon then return false end
    local shoveWeapons = {"Pickaxe","Axe","Carbine","Navy Pistol","Baguette"}
    for _, sw in pairs(shoveWeapons) do if weapon.Name:lower():find(sw:lower()) then return true end end
    if weapon:GetAttribute("CanShove") == true then return true end
    return false
end

function batchShoveAttack(weapon, zombieList)
    if not weapon or #zombieList == 0 then return end
    local currentTime = tick()
    local remoteEvent = weapon:FindFirstChild("RemoteEvent") or weapon:FindFirstChild("Remote"); if not remoteEvent then return end
    local weaponName = weapon.Name:lower()
    for i, zombieData in ipairs(zombieList) do
        local hit = zombieData.hit; local zombieId = tostring(hit); stunCooldowns[zombieId] = currentTime
        task.spawn(function()
            pcall(function()
                if weaponName:find("axe") then remoteEvent:FireServer("BraceBlock"); remoteEvent:FireServer("StopBraceBlock") end
                local rs = game:GetService("ReplicatedStorage")
                if rs:FindFirstChild("Remotes") then
                    local remotes = rs.Remotes
                    if remotes:FindFirstChild("Stun") then remotes.Stun:FireServer(hit) end
                end
            end)
        end)
    end
end

function getPredictedPosition(zombie, currentPos, velocity)
    if not zombie or not currentPos then return currentPos end
    local predictionTime = (currentPing / 1000) * lagCompensationMultiplier
    return currentPos + (velocity * predictionTime)
end

function attackWithWeapon(weapon, hit, hitPart, calc, normal)
    if not weapon then return end
    local remoteEvent = weapon:FindFirstChild("RemoteEvent") or weapon:FindFirstChild("Remote"); if not remoteEvent then return end
    pcall(function() game:GetService("ReplicatedStorage").Remotes.Gib:FireServer(hit, "Head", hitPart.CFrame.Position, normal, true) end)
    local success = false
    pcall(function()
        remoteEvent:FireServer("Swing", "Thrust"); task.wait(0.02)
        remoteEvent:FireServer("HitZombie", hit, hitPart.CFrame.Position, true, calc * 25, "Head", normal); success = true
    end)
    if not success then pcall(function() remoteEvent:FireServer("HitZombie", hit, hitPart.CFrame.Position, true, calc * 25, "Head", normal) end) end
end

function detectEnemy(hitbox, hrp)
    if killAuraConnection then return end
    local lastHitTime   = 0
    local lastSwingTime = 0
    killAuraConnection = RunService.Heartbeat:Connect(function()
        if not killAuraToggled and not shoveAuraToggled then
            isDead = false; observerOnline = false
            if killAuraConnection then killAuraConnection:Disconnect(); killAuraConnection = nil end
            return
        end
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
        local currentTime = tick()

        if shoveAuraToggled then
            if not hitbox or not hitbox.Parent then return end
            local equippedWeapon = getEquippedWeapon()
            local success, parts = pcall(function() return workspace:GetPartsInPart(hitbox, params) end)
            if not success then return end
            local zombiesToShove = {}
            for _, part in pairs(parts) do
                if part.Parent and part.Parent.Name == "m_Zombie" then
                    local Origin = part.Parent:FindFirstChild("Orig")
                    if Origin and Origin.Value then
                        local hit = Origin.Value
                        local zombieComponent = hit:FindFirstChild("Zombie")
                        local head = hit:FindFirstChild("Head")
                        local zombieHRP = hit:FindFirstChild("HumanoidRootPart")
                        if head and zombieHRP and zombieComponent and equippedWeapon and canWeaponShove(equippedWeapon) then
                            local distance = (zombieHRP.Position - hrp.Position).Magnitude
                            if distance <= shoveRadius then
                                local zombieId = tostring(hit)
                                if not stunCooldowns[zombieId] or currentTime - stunCooldowns[zombieId] >= shoveStunCooldown then
                                    local raycastResult = workspace:Raycast(hrp.CFrame.Position, head.CFrame.Position - hrp.CFrame.Position, raycastParams)
                                    if raycastResult then
                                        table.insert(zombiesToShove, {hit=hit,hitPart=head,zombie=zombieComponent,raycast=raycastResult,priority=zombieComponent.WalkSpeed>16 and 1 or 2,distance=distance})
                                    end
                                end
                            end
                        end
                    end
                end
            end
            if #zombiesToShove > 0 and equippedWeapon and canWeaponShove(equippedWeapon) and toolEquip then
                table.sort(zombiesToShove, function(a, b) if a.priority ~= b.priority then return a.priority < b.priority end; return a.distance < b.distance end)
                local batchList = {}; for i = 1, math.min(#zombiesToShove, maxShovePerCycle) do table.insert(batchList, zombiesToShove[i]) end
                batchShoveAttack(equippedWeapon, batchList)
            end
        end

        if killAuraToggled then
            local doHit   = currentTime - lastHitTime   >= 0.25
            local doSwing = currentTime - lastSwingTime >= 0.4
            if not doHit and not doSwing then return end
            local equippedWeapon = getEquippedWeapon()
            if not equippedWeapon or not toolEquip then return end
            local remoteEvent = equippedWeapon:FindFirstChild("RemoteEvent") or equippedWeapon:FindFirstChild("Remote")
            if not remoteEvent then return end
            local candidates = {}
            for _, child in pairs(workspace.Camera:GetChildren()) do
                if child.Name == "m_Zombie" then
                    local Origin = child:FindFirstChild("Orig")
                    if Origin and Origin.Value then
                        local hit = Origin.Value
                        local zombieHRP = hit:FindFirstChild("HumanoidRootPart")
                        local head = hit:FindFirstChild("Head")
                        local zombieComponent = hit:FindFirstChild("Zombie")
                        if zombieHRP and head and zombieComponent then
                            local distance = (zombieHRP.Position - hrp.Position).Magnitude
                            if distance <= killAuraRadius then
                                local isBarrel = child:FindFirstChild("Barrel") ~= nil
                                if isBarrel and not killAuraBomber then continue end
                                local isRunner = zombieComponent.WalkSpeed > 20
                                table.insert(candidates, {child=child,hit=hit,head=head,zombieHRP=zombieHRP,distance=distance,isRunner=isRunner})
                            end
                        end
                    end
                end
            end
            table.sort(candidates, function(a, b)
                local aPriority = a.isRunner and 1 or 2
                local bPriority = b.isRunner and 1 or 2
                if aPriority ~= bPriority then return aPriority < bPriority end
                return a.distance > b.distance
            end)
            local count = math.min(#candidates, 3)
            for i = 1, count do
                local c = candidates[i]
                local headPart = nil
                for _, part in pairs(c.child:GetChildren()) do
                    if part.Name == "Head" and (part.ClassName == "Part" or part.ClassName == "MeshPart") then headPart = part; break end
                end
                local headPos
                if killAuraHitMode == "Head" then
                    headPos = (headPart and headPart.CFrame.Position) or c.head.CFrame.Position
                elseif killAuraHitMode == "AimBot" then
                    local camCF = workspace.CurrentCamera.CFrame
                    headPos = camCF.Position + camCF.LookVector * c.distance
                elseif killAuraHitMode == "Feet" then
                    headPos = c.zombieHRP.CFrame.Position - Vector3.new(0, c.zombieHRP.Size.Y / 2, 0)
                else
                    headPos = (headPart and headPart.CFrame.Position) or c.head.CFrame.Position
                end
                local dir = (headPos - hrp.Position)
                if dir.Magnitude > 0 then dir = dir.Unit end
                local knockback = dir * 25
                local rcParams = RaycastParams.new()
                rcParams.FilterDescendantsInstances = {LocalPlayer.Character}
                rcParams.FilterType = Enum.RaycastFilterType.Exclude
                local rc = workspace:Raycast(hrp.Position, headPos - hrp.Position, rcParams)
                local normal = rc and rc.Normal or Vector3.new(0, 1, 0)
                pcall(function()
                    game:GetService("ReplicatedStorage").Remotes.Gib:FireServer(c.hit, "Head", headPos, normal, true)
                    if doSwing then remoteEvent:FireServer("Swing", "Thrust") end
                    if doHit   then remoteEvent:FireServer("HitZombie", c.hit, headPos, true, knockback, "Head", normal) end
                end)
            end
            if doHit   then lastHitTime   = currentTime end
            if doSwing then lastSwingTime = currentTime end
        end
    end)
end

function startAutoFace()
    if autoFaceConnection then return end
    autoFaceConnection = RunService.RenderStepped:Connect(function(deltaTime)
        if not (killAuraToggled or shoveAuraToggled or bayonetKillAuraToggled) or not autoFaceToggled then return end
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart"); if not hrp then return end
        local activeRadius = math.max((killAuraToggled and killAuraRadius or 0),(shoveAuraToggled and shoveRadius or 0),(bayonetKillAuraToggled and bayonetKillAuraRadius or 0))
        if activeRadius == 0 then return end
        local nearestDist = math.huge; local nearestTarget = nil
        for _, agent in pairs(workspace.Zombies:GetChildren()) do
            local zombieHRP = agent:FindFirstChild("HumanoidRootPart")
            if zombieHRP then local dist = (zombieHRP.Position - hrp.Position).Magnitude; if dist < nearestDist and dist <= activeRadius then nearestDist = dist; nearestTarget = zombieHRP end end
        end
        for _, child in pairs(workspace.Camera:GetChildren()) do
            if child.Name == "m_Zombie" then
                local Origin = child:FindFirstChild("Orig")
                if Origin and Origin.Value then
                    local zombieHRP = Origin.Value:FindFirstChild("HumanoidRootPart")
                    if zombieHRP then local dist = (zombieHRP.Position - hrp.Position).Magnitude; if dist < nearestDist and dist <= activeRadius then nearestDist = dist; nearestTarget = zombieHRP end end
                end
            end
        end
        if nearestTarget then smoothLookAtWithVelocity(hrp, nearestTarget.Position, deltaTime) end
    end)
end

function stopAutoFace()
    if autoFaceConnection then autoFaceConnection:Disconnect(); autoFaceConnection = nil end
end

function setShoveRadius(newRadius)
    shoveRadius = newRadius
    if (killAuraToggled or shoveAuraToggled) and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        observerOnline = false
        if killAuraConnection then killAuraConnection:Disconnect(); killAuraConnection = nil end
        local existingHitbox = LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Hitbox")
        if existingHitbox then existingHitbox:Destroy() end
        task.wait(0.1); createHitBox()
    end
end

function setMaxShovePerCycle(newMax) maxShovePerCycle = newMax end
function setMaxKillPerCycle(newMax) maxKillPerCycle = newMax end

function createHitBox()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return false end
    local torso = LocalPlayer.Character.HumanoidRootPart
    local existingHitbox = torso:FindFirstChild("Hitbox")
    local _hitboxSz, hitboxOffset
    if shoveAuraToggled and not killAuraToggled then
        _hitboxSz = Vector3.new(shoveRadius*2,6,shoveRadius*2); hitboxOffset = CFrame.new(0,0,-shoveRadius*0.6)
    elseif killAuraToggled and not shoveAuraToggled then
        _hitboxSz = Vector3.new(killAuraRadius*2,7,killAuraRadius*2); hitboxOffset = CFrame.new(0,0,-killAuraRadius*0.6)
    else
        local maxRadius = math.max(shoveRadius, killAuraRadius)
        _hitboxSz = Vector3.new(maxRadius*2,7,maxRadius*2); hitboxOffset = CFrame.new(0,0,-maxRadius*0.6)
    end
    if existingHitbox then
        existingHitbox.Size = _hitboxSz; existingHitbox.CFrame = torso.CFrame * hitboxOffset
        if not observerOnline then observerOnline = true; detectEnemy(existingHitbox, torso) end
        return true
    else
        local hitbox = Instance.new("Part"); hitbox.Name = "Hitbox"; hitbox.Parent = torso
        hitbox.Anchored = false; hitbox.Massless = true; hitbox.CanCollide = false; hitbox.CanTouch = false
        hitbox.Transparency = 1; hitbox.Size = _hitboxSz; hitbox.CFrame = torso.CFrame * hitboxOffset
        local weld = Instance.new("WeldConstraint"); weld.Parent = torso; weld.Part0 = hitbox; weld.Part1 = torso
        if not observerOnline then observerOnline = true; detectEnemy(hitbox, torso) end
        return true
    end
end

task.spawn(function()
    while true do task.wait(3); local currentTime = tick(); for zombieId, lastTime in pairs(stunCooldowns) do if currentTime - lastTime > 5 then stunCooldowns[zombieId] = nil end end end
end)

-- Bayonet Kill Aura
bayonetKillAuraToggled = false; bayonetKillAuraConnection = nil; bayonetKillAuraRadius = 13
lastBayonetAttack = 0; bayonetAttackCooldown = 0.05; maxBayonetPerCycle = 5
local bayonetHitCooldowns = {}

local function hasBayonetWeapon()
    if not LocalPlayer.Character then return nil end
    for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
        if tool:IsA("Tool") then
            local hasBayonet = tool:FindFirstChild("Configuration") and tool.Configuration:GetAttribute("HasBayonet")
            if hasBayonet and (tool:FindFirstChild("RemoteEvent") or tool:FindFirstChild("Remote")) then return tool end
        end
    end
    return nil
end

local function findAgentFromZombie(mZombie)
    local Origin = mZombie:FindFirstChild("Orig"); if not Origin or not Origin.Value then return nil end
    local agent = Origin.Value
    if agent and agent.Parent == workspace.Zombies then return agent end
    return nil
end

local function bayonetAttack(weapon, agent, hitPosition, direction)
    if not weapon or not agent or not hitPosition then return end
    local remoteEvent = weapon:FindFirstChild("RemoteEvent") or weapon:FindFirstChild("Remote"); if not remoteEvent then return end
    pcall(function()
        remoteEvent:FireServer("ThrustBayonet")
        remoteEvent:FireServer("Bayonet_HitZombie", agent, hitPosition, true, "Head")
        local hitID = tick()
        agent:SetAttribute("WepHitID", hitID); agent:SetAttribute("WepHitDirection", direction*10); agent:SetAttribute("WepHitPos", hitPosition)
        task.delay(0.2, function()
            if agent:GetAttribute("WepHitID") == hitID then
                agent:SetAttribute("WepHitDirection", nil); agent:SetAttribute("WepHitPos", nil); agent:SetAttribute("WepHitID", nil)
            end
        end)
        local gibRemote = game:GetService("ReplicatedStorage").Remotes:FindFirstChild("Gib")
        if gibRemote then gibRemote:FireServer(agent, "Head", hitPosition, direction.Unit, true) end
    end)
end

local function createBayonetHitbox()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return nil end
    local torso = LocalPlayer.Character.HumanoidRootPart
    local existingHitbox = torso:FindFirstChild("BayonetHitbox")
    if existingHitbox then
        existingHitbox.Size = Vector3.new(bayonetKillAuraRadius*2,7,bayonetKillAuraRadius*2)
        existingHitbox.CFrame = torso.CFrame * CFrame.new(0,0,-bayonetKillAuraRadius*0.6); return existingHitbox
    end
    local hitbox = Instance.new("Part"); hitbox.Name = "BayonetHitbox"; hitbox.Parent = torso
    hitbox.Anchored = false; hitbox.Massless = true; hitbox.CanCollide = false; hitbox.CanTouch = false
    hitbox.Transparency = 1; hitbox.Size = Vector3.new(bayonetKillAuraRadius*2,7,bayonetKillAuraRadius*2)
    hitbox.CFrame = torso.CFrame * CFrame.new(0,0,-bayonetKillAuraRadius*0.6)
    local weld = Instance.new("WeldConstraint"); weld.Parent = torso; weld.Part0 = hitbox; weld.Part1 = torso
    return hitbox
end

local function startBayonetKillAura()
    if bayonetKillAuraConnection then bayonetKillAuraConnection:Disconnect(); bayonetKillAuraConnection = nil end
    local bayonetHitbox = createBayonetHitbox(); if not bayonetHitbox then return end
    local bayonetParams = OverlapParams.new(); bayonetParams.FilterDescendantsInstances = {LocalPlayer.Character}
    bayonetKillAuraConnection = RunService.Heartbeat:Connect(function()
        if not bayonetKillAuraToggled then
            if bayonetKillAuraConnection then bayonetKillAuraConnection:Disconnect(); bayonetKillAuraConnection = nil end
            if bayonetHitbox and bayonetHitbox.Parent then bayonetHitbox:Destroy() end; return
        end
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
        if not bayonetHitbox or not bayonetHitbox.Parent then bayonetHitbox = createBayonetHitbox(); if not bayonetHitbox then return end end
        local currentTime = tick()
        if currentTime - lastBayonetAttack < bayonetAttackCooldown then return end
        local weapon = hasBayonetWeapon(); if not weapon or not toolEquip then return end
        local hrp = LocalPlayer.Character.HumanoidRootPart; local zombiesToAttack = {}
        local success, parts = pcall(function() return workspace:GetPartsInPart(bayonetHitbox, bayonetParams) end)
        if not success then return end
        for _, part in pairs(parts) do
            if part.Parent and part.Parent.Name == "m_Zombie" then
                local agent = findAgentFromZombie(part.Parent)
                if agent then
                    local zombie = agent:FindFirstChild("Zombie"); local head = agent:FindFirstChild("Head"); local zombieHRP = agent:FindFirstChild("HumanoidRootPart")
                    if zombie and head and zombieHRP then
                        local velocity = zombieHRP.AssemblyLinearVelocity or Vector3.new(0,0,0)
                        local predictedPos = zombieHRP.Position + velocity * 0.13
                        local distance = (predictedPos - hrp.Position).Magnitude
                        if distance <= bayonetKillAuraRadius then
                            local zombieId = tostring(agent)
                            if not bayonetHitCooldowns[zombieId] or currentTime - bayonetHitCooldowns[zombieId] >= 1.0 then
                                local bayonetRayParams = RaycastParams.new()
                                bayonetRayParams.FilterDescendantsInstances = {LocalPlayer.Character}
                                bayonetRayParams.FilterType = Enum.RaycastFilterType.Exclude
                                local raycastResult = workspace:Raycast(hrp.Position, head.Position - hrp.Position, bayonetRayParams)
                                if raycastResult and raycastResult.Instance:IsDescendantOf(agent) then
                                    local direction = (head.Position - hrp.Position).Unit
                                    table.insert(zombiesToAttack, {agent=agent,head=head,distance=distance,priority=zombie.WalkSpeed>16 and 1 or 2,zombieId=zombieId,direction=direction,hitPosition=head.Position})
                                end
                            end
                        end
                    end
                end
            end
        end
        if #zombiesToAttack > 0 then
            table.sort(zombiesToAttack, function(a, b) if a.priority ~= b.priority then return a.priority < b.priority end; return a.distance < b.distance end)
            local target = zombiesToAttack[1]
            bayonetAttack(weapon, target.agent, target.hitPosition, target.direction)
            bayonetHitCooldowns[target.zombieId] = currentTime; lastBayonetAttack = currentTime
        end
    end)
end

local function toggleBayonetKillAura(enabled)
    bayonetKillAuraToggled = enabled
    if enabled then
        startBayonetKillAura()
        if autoFaceToggled then stopAutoFace(); startAutoFace() end
    else
        if bayonetKillAuraConnection then bayonetKillAuraConnection:Disconnect(); bayonetKillAuraConnection = nil end
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hitbox = LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BayonetHitbox")
            if hitbox then hitbox:Destroy() end
        end
        bayonetHitCooldowns = {}
    end
end

-- Fullbright
local Light = game:GetService("Lighting"); local fullbrightEnabled = false; local fullbrightConnection = nil
local originalLighting = {Ambient=Light.Ambient,ColorShift_Bottom=Light.ColorShift_Bottom,ColorShift_Top=Light.ColorShift_Top,OutdoorAmbient=Light.OutdoorAmbient,Brightness=Light.Brightness}
local function doFullbright() if not fullbrightEnabled then return end; Light.Ambient = Color3.new(1,1,1); Light.ColorShift_Bottom = Color3.new(1,1,1); Light.ColorShift_Top = Color3.new(1,1,1); Light.OutdoorAmbient = Color3.new(1,1,1); Light.Brightness = 2 end
local function restoreLighting() Light.Ambient = originalLighting.Ambient; Light.ColorShift_Bottom = originalLighting.ColorShift_Bottom; Light.ColorShift_Top = originalLighting.ColorShift_Top; Light.OutdoorAmbient = originalLighting.OutdoorAmbient; Light.Brightness = originalLighting.Brightness end
local function toggleFullbright(enabled)
    fullbrightEnabled = enabled
    if fullbrightConnection then fullbrightConnection:Disconnect(); fullbrightConnection = nil end
    if enabled then doFullbright(); fullbrightConnection = Light.LightingChanged:Connect(doFullbright)
    else restoreLighting() end
end

-- Killbrick
local killbrickEnabled = true; local killbrickConnection = nil
local function toggleKillbrick(enabled)
    killbrickEnabled = enabled
    if killbrickConnection then killbrickConnection:Disconnect(); killbrickConnection = nil end
    if not enabled then
        killbrickConnection = RunService.Heartbeat:Connect(function()
            if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
            local parts = workspace:GetPartBoundsInRadius(LocalPlayer.Character.HumanoidRootPart.Position, 10)
            for _, part in ipairs(parts) do part.CanTouch = false end
        end)
    end
end

-- WalkSpeed
local connection = nil; walkSpeedToggled = false; walkSpeedValue = 16
local function changeWalkSpeed(newValue, wsToggled)
    local workPlayer = LocalPlayer.Character
    if workPlayer and workPlayer:FindFirstChild("Humanoid") then
        workPlayer.Humanoid.WalkSpeed = newValue
        if wsToggled then
            if connection then connection:Disconnect() end
            connection = workPlayer.Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function() workPlayer.Humanoid.WalkSpeed = newValue end)
        else if connection then connection:Disconnect(); connection = nil end end
    end
end

-- Auto Repair
local autoRepairToggled = false; local autoEquipHammerToggled = false; local autoRepairConnection = nil
local lastRepairTime = 0; local isRepairing = false
local function equipHammer()
    local hammer = LocalPlayer.Backpack:FindFirstChild("Hammer"); if not hammer then return false end
    pcall(function() LocalPlayer.Character.Humanoid:EquipTool(hammer) end); task.wait(0.2)
    return LocalPlayer.Character:FindFirstChild("Hammer") ~= nil
end
local function performRepair()
    if isRepairing or not autoRepairToggled or not LocalPlayer.Character then return false end
    local currentTime = tick(); if currentTime - lastRepairTime < 0.1 then return false end
    local hammerTool = LocalPlayer.Character:FindFirstChild("Hammer")
    if not hammerTool and autoEquipHammerToggled then if not equipHammer() then return false end; hammerTool = LocalPlayer.Character:FindFirstChild("Hammer") end
    if not hammerTool then return false end
    isRepairing = true
    local remoteEvent = hammerTool:FindFirstChild("RemoteEvent"); if not remoteEvent then isRepairing = false; return false end
    local repairParams = RaycastParams.new(); repairParams.IgnoreWater = true; repairParams.FilterDescendantsInstances = {LocalPlayer.Character}; repairParams.FilterType = Enum.RaycastFilterType.Exclude
    local head = LocalPlayer.Character:FindFirstChild("Head"); if not head then isRepairing = false; return false end
    local repaired = false
    pcall(function()
        local direction = workspace.CurrentCamera.CFrame.LookVector
        local raycast = workspace:Raycast(head.Position, direction * 8, repairParams)
        if raycast and raycast.Instance then
            local buildingHealth = raycast.Instance.Parent:FindFirstChild("BuildingHealth") or raycast.Instance.Parent.Parent:FindFirstChild("BuildingHealth")
            local constructHealth = raycast.Instance:FindFirstChild("ConstructHealth")
            if buildingHealth or constructHealth then remoteEvent:FireServer("Repair", buildingHealth or constructHealth); lastRepairTime = currentTime; repaired = true end
        end
    end)
    isRepairing = false; return repaired
end
local function autoRepair(Value)
    autoRepairToggled = Value
    if autoRepairConnection then autoRepairConnection:Disconnect(); autoRepairConnection = nil end
    if autoRepairToggled then
        isRepairing = false
        autoRepairConnection = RunService.Heartbeat:Connect(function()
            if not autoRepairToggled then if autoRepairConnection then autoRepairConnection:Disconnect(); autoRepairConnection = nil end; return end
            if tick() - lastRepairTime >= 0.1 then task.spawn(function() pcall(performRepair) end) end
        end)
    else isRepairing = false end
end

-- Auto Play
autoplay = false; local autoPlayConnection = nil; local lastUpdateAccuracy = 0; local updateInterval = 0.5
local autoStartConnection = nil
local function autoPerfectPlay()
    if not autoplay or not LocalPlayer.Character then return end
    pcall(function()
        for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:find("Fife") or tool.Name:find("Drum") or tool.Name:find("Bagpipe")) then
                local remoteEvent = tool:FindFirstChild("RemoteEvent")
                if remoteEvent then remoteEvent:FireServer("UpdateAccuracy", 100); break end
            end
        end
    end)
end
local function startAutoPlay()
    if autoPlayConnection then autoPlayConnection:Disconnect() end
    lastUpdateAccuracy = 0
    autoStartConnection = task.spawn(function()
        while autoplay do
            pcall(function()
                if not LocalPlayer.Character then return end
                for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
                    if tool:IsA("Tool") and (tool.Name:find("Fife") or tool.Name:find("Drum") or tool.Name:find("Bagpipe")) then
                        local remoteEvent = tool:FindFirstChild("RemoteEvent")
                        if remoteEvent then
                            local songSource = tool:FindFirstChild("Model") and tool.Model:FindFirstChild("Handle") and tool.Model.Handle:FindFirstChild("SoundSource")
                            if songSource and not songSource.IsPlaying then remoteEvent:FireServer("Play", "La Marseillaise"); task.wait(0.5) end
                        end
                    end
                end
            end)
            task.wait(2)
        end
    end)
    autoPlayConnection = RunService.Heartbeat:Connect(function(deltaTime)
        if not autoplay then if autoPlayConnection then autoPlayConnection:Disconnect(); autoPlayConnection = nil end; return end
        lastUpdateAccuracy = lastUpdateAccuracy - deltaTime
        if lastUpdateAccuracy <= 0 then lastUpdateAccuracy = updateInterval; autoPerfectPlay() end
    end)
end

-- Fly
local FLYING = false; local NO_FALL_DAMAGE = false
local QEfly2 = true; local iyflyspeed2 = 1
local flyKeyDown2, flyKeyUp2

local function sFLY()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then repeat task.wait() until char:FindFirstChildOfClass("Humanoid"); humanoid = char:FindFirstChildOfClass("Humanoid") end
    if flyKeyDown2 or flyKeyUp2 then flyKeyDown2:Disconnect(); flyKeyUp2:Disconnect() end
    local T = getRoot(char); local CONTROL = {F=0,B=0,L=0,R=0,Q=0,E=0}; local lCONTROL = {F=0,B=0,L=0,R=0,Q=0,E=0}; local SPEED = 0
    local function FLY()
        FLYING = true
        local BG = Instance.new("BodyGyro"); local BV = Instance.new("BodyVelocity")
        BG.P = 9e4; BG.Parent = T; BV.Parent = T; BG.MaxTorque = Vector3.new(9e9,9e9,9e9); BG.CFrame = T.CFrame; BV.Velocity = Vector3.new(0,0,0); BV.MaxForce = Vector3.new(9e9,9e9,9e9)
        task.spawn(function()
            repeat task.wait()
                local camera = workspace.CurrentCamera; if not FLY then humanoid.PlatformStand = true end
                if CONTROL.L+CONTROL.R ~= 0 or CONTROL.F+CONTROL.B ~= 0 or CONTROL.Q+CONTROL.E ~= 0 then SPEED = 50
                elseif SPEED ~= 0 then SPEED = 0 end
                if (CONTROL.L+CONTROL.R) ~= 0 or (CONTROL.F+CONTROL.B) ~= 0 or (CONTROL.Q+CONTROL.E) ~= 0 then
                    BV.Velocity = ((camera.CFrame.LookVector*(CONTROL.F+CONTROL.B))+((camera.CFrame*CFrame.new(CONTROL.L+CONTROL.R,(CONTROL.F+CONTROL.B+CONTROL.Q+CONTROL.E)*0.2,0).p)-camera.CFrame.p))*SPEED
                    lCONTROL = {F=CONTROL.F,B=CONTROL.B,L=CONTROL.L,R=CONTROL.R}
                elseif (CONTROL.L+CONTROL.R)==0 and (CONTROL.F+CONTROL.B)==0 and (CONTROL.Q+CONTROL.E)==0 and SPEED ~= 0 then
                    BV.Velocity = ((camera.CFrame.LookVector*(lCONTROL.F+lCONTROL.B))+((camera.CFrame*CFrame.new(lCONTROL.L+lCONTROL.R,(lCONTROL.F+lCONTROL.B+CONTROL.Q+CONTROL.E)*0.2,0).p)-camera.CFrame.p))*SPEED
                else BV.Velocity = Vector3.new(0,0,0) end
                BG.CFrame = camera.CFrame
            until not FLYING
            CONTROL = {F=0,B=0,L=0,R=0,Q=0,E=0}; lCONTROL = {F=0,B=0,L=0,R=0,Q=0,E=0}; SPEED = 0
            BG:Destroy(); BV:Destroy(); if humanoid then humanoid.PlatformStand = false end
        end)
    end
    flyKeyDown2 = UIS.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.W then CONTROL.F = iyflyspeed2
        elseif input.KeyCode == Enum.KeyCode.S then CONTROL.B = -iyflyspeed2
        elseif input.KeyCode == Enum.KeyCode.A then CONTROL.L = -iyflyspeed2
        elseif input.KeyCode == Enum.KeyCode.D then CONTROL.R = iyflyspeed2
        elseif input.KeyCode == Enum.KeyCode.E and QEfly2 then CONTROL.Q = iyflyspeed2 * 2
        elseif input.KeyCode == Enum.KeyCode.Q and QEfly2 then CONTROL.E = -iyflyspeed2 * 2 end
    end)
    flyKeyUp2 = UIS.InputEnded:Connect(function(input, processed)
        if input.KeyCode == Enum.KeyCode.W then CONTROL.F = 0
        elseif input.KeyCode == Enum.KeyCode.S then CONTROL.B = 0
        elseif input.KeyCode == Enum.KeyCode.A then CONTROL.L = 0
        elseif input.KeyCode == Enum.KeyCode.D then CONTROL.R = 0
        elseif input.KeyCode == Enum.KeyCode.E then CONTROL.Q = 0
        elseif input.KeyCode == Enum.KeyCode.Q then CONTROL.E = 0 end
    end)
    FLY()
end

local function NOFLY()
    FLYING = false
    if flyKeyDown2 or flyKeyUp2 then flyKeyDown2:Disconnect(); flyKeyUp2:Disconnect() end
    if LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid"); hum.PlatformStand = false
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Climbing,true); hum:ChangeState(Enum.HumanoidStateType.Freefall); task.wait(0.1); hum:ChangeState(Enum.HumanoidStateType.Landing) end)
    end
end

-- Noclip
local NOCLIPPING2 = false; local noclipConnection2 = nil
local function startNoclip()
    if NOCLIPPING2 then return end; NOCLIPPING2 = true
    local char = LocalPlayer.Character; local hrp = char and char:FindFirstChild("HumanoidRootPart"); local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    pcall(function() hrp:SetNetworkOwner(LocalPlayer) end)
    noclipConnection2 = RunService.Stepped:Connect(function()
        if not NOCLIPPING2 then return end
        local char = LocalPlayer.Character; if not char then return end
        for _, part in pairs(char:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end
        local hrp = char:FindFirstChild("HumanoidRootPart"); local hum = char:FindFirstChildOfClass("Humanoid")
        if hrp then hrp.AssemblyLinearVelocity = Vector3.new(0,0,0); hrp.AssemblyAngularVelocity = Vector3.new(0,0,0) end
        if hum then hum:ChangeState(Enum.HumanoidStateType.NoPhysics) end
    end)
end
local function stopNoclip()
    if not NOCLIPPING2 then return end; NOCLIPPING2 = false
    if noclipConnection2 then noclipConnection2:Disconnect(); noclipConnection2 = nil end
    local char = LocalPlayer.Character; if not char then return end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part:IsDescendantOf(char) then
            if part.Name == "Head" or part.Name == "Torso" or part.Name == "HumanoidRootPart" then part.CanCollide = true end
        end
    end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then pcall(function() hrp:SetNetworkOwner(LocalPlayer) end) end
    task.wait(0.15)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.PlatformStand = false; hum:ChangeState(Enum.HumanoidStateType.Running) end
end

-- Silent Aim
local silentAimEnabled = false; local silentAimMode = "Auto"
local function findSilentAimTarget()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return nil,nil,nil end
    local hrp = LocalPlayer.Character.HumanoidRootPart; local head = LocalPlayer.Character:FindFirstChild("Head"); if not head then return nil,nil,nil end
    local candidates = {}
    for _, zombie in pairs(workspace.Zombies:GetChildren()) do
        local zombieHRP = zombie:FindFirstChild("HumanoidRootPart"); local zombieHead = zombie:FindFirstChild("Head"); local hasBarrel = zombie:FindFirstChild("Barrel") ~= nil
        if zombieHRP and zombieHead and hasBarrel then
            local distance = (zombieHRP.Position - hrp.Position).Magnitude
            if distance < autoFireRange then table.insert(candidates, {zombie=zombie,head=zombieHead,distance=distance,targetType="Barrel"}) end
        end
    end
    for _, child in pairs(workspace.Camera:GetChildren()) do
        if child.Name == "m_Zombie" then
            local Origin = child:FindFirstChild("Orig")
            if Origin and Origin.Value then
                local zombie = Origin.Value; local zombieHRP = zombie:FindFirstChild("HumanoidRootPart"); local zombieHead = zombie:FindFirstChild("Head"); local hasBarrel = child:FindFirstChild("Barrel") ~= nil
                if zombieHRP and zombieHead and hasBarrel then
                    local distance = (zombieHRP.Position - hrp.Position).Magnitude
                    if distance < autoFireRange then table.insert(candidates, {zombie=zombie,head=zombieHead,distance=distance,targetType="Barrel"}) end
                end
            end
            local lantern = child:FindFirstChild("Whale Oil Lantern")
            if lantern then
                local Origin = child:FindFirstChild("Orig")
                if Origin and Origin.Value then
                    local zombie = Origin.Value; local zombieHRP = zombie:FindFirstChild("HumanoidRootPart"); local zombieHead = zombie:FindFirstChild("Head")
                    if zombieHRP and zombieHead then
                        local distance = (zombieHRP.Position - hrp.Position).Magnitude
                        if distance < autoFireRange then table.insert(candidates, {zombie=zombie,head=zombieHead,distance=distance,targetType="Igniter"}) end
                    end
                end
            end
        end
    end
    local boss = findHeadlessBoss()
    if boss and boss.Parent then
        local torso = boss:FindFirstChild("Torso")
        if torso then local distance = (torso.Position - hrp.Position).Magnitude; if distance <= autoFireHeadlessRange then table.insert(candidates, {zombie=boss,head=torso,distance=distance,targetType="Headless"}) end end
    end
    local filtered = {}
    for _, c in ipairs(candidates) do
        if silentAimMode == "Auto" then table.insert(filtered, c)
        elseif silentAimMode == "Barrel/Igniter" and (c.targetType == "Barrel" or c.targetType == "Igniter") then table.insert(filtered, c)
        elseif silentAimMode == "Headless" and c.targetType == "Headless" then table.insert(filtered, c) end
    end
    table.sort(filtered, function(a, b) return a.distance < b.distance end)
    for _, candidate in ipairs(filtered) do
        if wallbangEnabled or isTargetVisible(head.Position, candidate.head.Position, candidate.zombie) then
            return candidate.zombie, candidate.head, candidate.targetType
        end
    end
    return nil, nil, nil
end

_G.silentAimEnabled = false; _G.silentShootEnabled = false
_G._zentra_findSilentAimTarget = findSilentAimTarget
_G._zentra_getPredictedHeadless = getPredictedHeadlessPosition
_G.toggleSilentAim = function(enabled) silentAimEnabled = enabled; _G.silentAimEnabled = enabled end
_G.setSilentAimMode = function(mode) silentAimMode = mode end

-- Head Lock
local FlintLock, originBayonet_, v_u_1
local flintOk = pcall(function()
    FlintLock = require(game:GetService("ReplicatedStorage").Modules.Weapons:WaitForChild("Flintlock"))
    originBayonet_ = FlintLock.BayonetHitCheck
end)
v_u_1 = {}

function v_u_1.BayonetHitCheck(p115,p116,p117,p118,p119)
    local v120 = workspace:Raycast(p116,p117,p118)
    if v120 then
        if v120.Instance.Parent.Name == "m_Zombie" then
            local v121 = p118.FilterDescendantsInstances; table.insert(v121,v120.Instance); p118.FilterDescendantsInstances = v121
            local v123 = v120.Instance.Parent:FindFirstChild("Orig")
            if v123 then
                local Head = ""
                for _, part in pairs(v120.Instance.Parent:GetChildren()) do
                    if part.Name == "Head" and (part.ClassName == "Part" or part.ClassName == "MeshPart") then Head = part end
                end
                p115.remoteEvent:FireServer("Bayonet_HitZombie",v123.Value,Head.CFrame.Position,true,"Head")
                local v_u_124 = v123.Value; local v_u_125 = tick()
                v_u_124:SetAttribute("WepHitID",tick()); v_u_124:SetAttribute("WepHitDirection",p117*10); v_u_124:SetAttribute("WepHitPos",v120.Position)
                task.delay(0.2,function()
                    if v_u_124:GetAttribute("WepHitID") == v_u_125 then
                        v_u_124:SetAttribute("WepHitDirection",nil); v_u_124:SetAttribute("WepHitPos",nil); v_u_124:SetAttribute("WepHitID",nil)
                    end
                end)
            end
            return 1
        end
        local v126 = v120.Instance.Parent:FindFirstChild("DoorHit") or v120.Instance:FindFirstChild("BreakGlass")
        if v126 and not table.find(p119,v126) then
            table.insert(p119,v126); p115.remoteEvent:FireServer("Bayonet_HitCon",v120.Instance,v120.Position,v120.Normal,v120.Material); return 2
        end
        local v127 = v120.Instance.Parent:FindFirstChild("Humanoid") or v120.Instance.Parent.Parent:FindFirstChild("Humanoid")
        if v127 and not table.find(p119,v127) then table.insert(p119,v127); p115.remoteEvent:FireServer("Bayonet_HitPlayer",v127,v120.Position); return 2 end
    end
    return 0
end

function changeBayonet(value)
    if flintOk and FlintLock then FlintLock.BayonetHitCheck = value and v_u_1.BayonetHitCheck or originBayonet_ end
end

local MeleeBase, originMelee_, u1
local meleeOk = pcall(function()
    MeleeBase = require(game:GetService("ReplicatedStorage").Modules.Weapons:WaitForChild("MeleeBase"))
    originMelee_ = MeleeBase.MeleeHitCheck
end)
u1 = {}

function u1.MeleeHitCheck(p100,p101,p102,p103,p104,p105)
    local v106 = workspace:Raycast(p101,p102,p103)
    if v106 then
        if v106.Instance.Parent.Name == "m_Zombie" then
            local v107 = p103.FilterDescendantsInstances; table.insert(v107,v106.Instance); p103.FilterDescendantsInstances = v107
            local v109 = v106.Instance.Parent:FindFirstChild("Orig")
            if v109 then
                if p100.sharp and shared.Gib ~= nil then
                    if v109.Value then
                        local v110 = v109.Value:FindFirstChild("Zombie")
                        local v111 = not p100.Stats.HeadshotMulti and 2.3 or p100.Stats.HeadshotMulti
                        if v110 and v110.Health - p100.Stats.Damage*v111 <= 0 then shared.Gib(v109.Value,v106.Instance.Name,v106.Position,v106.Normal,true) end
                    else shared.Gib(v109.Value,v106.Instance.Name,v106.Position,v106.Normal,true) end
                end
                if not p104[v109] or p104[v109] < (p100.Stats.MaxHits or 3) then
                    if p105 then
                        p100.remoteEvent:FireServer("ThrustCharge",v109.Value,v106.Position,v106.Normal)
                    else
                        local Head = ""
                        for _, part in pairs(v106.Instance.Parent:GetChildren()) do
                            if part.Name == "Head" and (part.ClassName == "Part" or part.ClassName == "MeshPart") then Head = part end
                        end
                        local u112 = v109.Value
                        local v113 = Head.CFrame.Position - p101
                        if v113:Dot(v113) > 1 then v113 = v113.Unit end
                        local v114 = v113 * 25
                        p100.remoteEvent:FireServer("HitZombie",u112,Head.CFrame.Position,true,v114,"Head",v106.Normal)
                        if not u112:GetAttribute("WepHitDirection") then
                            local u115 = tick()
                            u112:SetAttribute("WepHitID",tick()); u112:SetAttribute("WepHitDirection",v114); u112:SetAttribute("WepHitPos",v106.Position)
                            task.delay(0.2,function()
                                if u112:GetAttribute("WepHitID") == u115 then
                                    u112:SetAttribute("WepHitDirection",nil); u112:SetAttribute("WepHitPos",nil); u112:SetAttribute("WepHitID",nil)
                                end
                            end)
                        end
                    end
                    if p104[v109] then p104[v109] = p104[v109] + 1
                    else table.insert(p104,v109); p104[v109] = 1 end
                end
            end
            return 1
        end
        if not p105 then
            local v117 = v106.Instance.Parent:FindFirstChild("DoorHit") or v106.Instance:FindFirstChild("BreakGlass")
            if v117 and not table.find(p104,v117) then table.insert(p104,v117); p100.remoteEvent:FireServer("HitCon",v106.Instance); return 2 end
            local v118 = v106.Instance.Parent:FindFirstChild("Humanoid") or v106.Instance.Parent.Parent:FindFirstChild("Humanoid")
            if v118 and not table.find(p104,v118) then table.insert(p104,v118); p100.remoteEvent:FireServer("HitPlayer",v118,v106.Position); return 2 end
        end
    end
    return 0
end

function changeMelee(value)
    if meleeOk and MeleeBase then MeleeBase.MeleeHitCheck = value and u1.MeleeHitCheck or originMelee_ end
end

function onLights()
    local ligthPost = workspace:FindFirstChild("Saint Petersburg"); if not ligthPost then return end
    local modes = ligthPost:FindFirstChild("Modes"); if not modes then return end
    local holdout = modes:FindFirstChild("Holdout"); if not holdout then return end
    local lampPosts = holdout:FindFirstChild("LampPosts"); if not lampPosts then return end
    for _, part in pairs(lampPosts:GetChildren()) do
        local metal = part:FindFirstChild("Metal")
        if metal and metal:FindFirstChild("Light") then metal.Light.PointLight.Enabled = true; metal.Light.Visible = true end
    end
end

LocalPlayer.CharacterAdded:Connect(function(character)
    task.wait(1); stunCooldowns = {}; lastShoveTime = 0; lastAttackTime = 0
    if killAuraToggled or shoveAuraToggled then
        observerOnline = false; if killAuraConnection then killAuraConnection:Disconnect(); killAuraConnection = nil end
        task.wait(0.1); createHitBox()
    end
    if bayonetKillAuraToggled then toggleBayonetKillAura(false); task.wait(0.2); toggleBayonetKillAura(true) end
    raycastParams.FilterDescendantsInstances = {character}; params.FilterDescendantsInstances = {character}
    if not killbrickEnabled then toggleKillbrick(false) end
    if hitboxEnabled then task.wait(0.5); toggleHitboxExpander(true) end
end)

RunService.PreSimulation:Connect(function(dt)
    local char = LocalPlayer.Character; local hrp = char and char:FindFirstChild("HumanoidRootPart"); local hum = char and char:FindFirstChildOfClass("Humanoid")
    if FLYING and hrp and hum then
        hum:ChangeState(Enum.HumanoidStateType.NoPhysics)
        hrp.Velocity = Vector3.new(0,0.01,0); hrp.AssemblyLinearVelocity = Vector3.new(0,0.01,0); hrp.AssemblyAngularVelocity = Vector3.new(0,0,0)
        pcall(function() if hrp.ReceiveAge > 0.08 then hrp:SetNetworkOwner(LocalPlayer) end end)
    end
end)

task.spawn(function()
    while true do task.wait(1); if NO_FALL_DAMAGE then
        local char = LocalPlayer.Character
        if char then local health = char:FindFirstChild("Health"); if health then local fsd = health:FindFirstChild("ForceSelfDamage"); if fsd then pcall(function() fsd:FireServer(0) end) end end end
    end end
end)

end) -- end pcall

if not success then warn("Feature load error: " .. tostring(errorMsg)) end

-- ===================== BUILD GUI TABS =====================
local o = 0
local function nextOrder() o = o + 1; return o end

-- ========== COMBAT TAB ==========
local cf = TabFrames["Combat"]
makeSection(cf, "Combat Functions", nextOrder())
makeToggle(cf, "Silent Shoot", false, function(v) _G.toggleSilentAim(v) end, nextOrder())
makeDropdown(cf, "Silent Shoot Target", {"Auto (Priority)","Barrel/Igniter Only","Headless Only"}, "Auto (Priority)", function(v)
    local m = {["Auto (Priority)"]="Auto",["Barrel/Igniter Only"]="Barrel/Igniter",["Headless Only"]="Headless"}
    _G.setSilentAimMode(m[v] or "Auto")
end, nextOrder())
makeToggle(cf, "Kill Aura", false, function(v)
    killAuraToggled = v
    if v then task.wait(0.1); createHitBox(); if autoFaceToggled then startAutoFace() end
    else
        if not shoveAuraToggled then
            if killAuraConnection then killAuraConnection:Disconnect(); killAuraConnection = nil end
            observerOnline = false
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local h = LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Hitbox"); if h then h:Destroy() end
            end
        end
        if not shoveAuraToggled and autoFaceToggled then stopAutoFace() end
    end
end, nextOrder())
makeToggle(cf, "Kill Aura Bomber", false, function(v) killAuraBomber = v end, nextOrder())
makeDropdown(cf, "Kill Aura Hit Point", {"Head","AimBot Bypass","Feet"}, "Head", function(v)
    local m = {["Head"]="Head",["AimBot Bypass"]="AimBot",["Feet"]="Feet"}
    killAuraHitMode = m[v] or "Head"
end, nextOrder())
makeToggle(cf, "Shove Aura", false, function(v)
    shoveAuraToggled = v
    if v then task.wait(0.1); createHitBox(); if autoFaceToggled then startAutoFace() end
    else
        if not killAuraToggled then
            if killAuraConnection then killAuraConnection:Disconnect(); killAuraConnection = nil end
            observerOnline = false
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local h = LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Hitbox"); if h then h:Destroy() end
            end
        end
        if not killAuraToggled and autoFaceToggled then stopAutoFace() end
    end
end, nextOrder())
makeToggle(cf, "Bayonet Kill Aura", false, function(v) toggleBayonetKillAura(v) end, nextOrder())
makeToggle(cf, "Auto Face Zombies", false, function(v)
    autoFaceToggled = v
    if v and (killAuraToggled or shoveAuraToggled or bayonetKillAuraToggled) then startAutoFace() else stopAutoFace() end
end, nextOrder())
makeToggle(cf, "Head Lock (Melee+Bayonet)", false, function(v) changeBayonet(v); changeMelee(v) end, nextOrder())
makeSection(cf, "Radius & Size Settings", nextOrder())
makeSlider(cf, "Shove Radius", 1, 15, 8, function(v) setShoveRadius(v) end, nextOrder())
makeSlider(cf, "Max Shove/Cycle", 1, 50, 30, function(v) setMaxShovePerCycle(v) end, nextOrder())
makeSlider(cf, "Kill Aura Radius", 0, 20, 13, function(v) killAuraRadius = v end, nextOrder())
makeSlider(cf, "Bayonet Kill Radius", 5, 25, 13, function(v) bayonetKillAuraRadius = v; if bayonetKillAuraToggled then toggleBayonetKillAura(false); task.wait(0.1); toggleBayonetKillAura(true) end end, nextOrder())
makeToggle(cf, "Zombie Hitbox Expander", false, function(v) toggleHitboxExpander(v) end, nextOrder())
makeSlider(cf, "Hitbox Size", 1, 30, 10, function(v) setHitboxSize(v) end, nextOrder())

-- ========== AUTO TAB ==========
o = 0
local af2 = TabFrames["Auto"]
makeSection(af2, "Auto Functions", nextOrder())
makeToggle(af2, "Auto Fire", false, function(v) toggleAutoFire(v) end, nextOrder())
makeSlider(af2, "Auto Fire Range", 10, 100, 50, function(v) autoFireRange = v end, nextOrder())
makeToggle(af2, "Wallbang Mode", false, function(v) toggleWallbang(v) end, nextOrder())
makeToggle(af2, "Auto Reload", false, function(v) _G.AutoReloadV2.Toggle(v) end, nextOrder())
makeDropdown(af2, "Reload Mode", {"Fast","Animation","Background"}, "Animation", function(v)
    local m = {["Fast"]=1,["Animation"]=2,["Background"]=3}
    _G.AutoReloadV2.SetMode(m[v] or 2)
end, nextOrder())
makeToggle(af2, "Auto Repair", false, function(v) autoRepair(v) end, nextOrder())
makeToggle(af2, "Auto Equip Hammer", false, function(v) autoEquipHammerToggled = v end, nextOrder())
makeToggle(af2, "Auto Play (Music)", false, function(v)
    autoplay = v
    if v then startAutoPlay()
    else
        if autoPlayConnection then autoPlayConnection:Disconnect(); autoPlayConnection = nil end
        if autoStartConnection then task.cancel(autoStartConnection); autoStartConnection = nil end
        lastUpdateAccuracy = 0
    end
end, nextOrder())

-- ========== ESP TAB ==========
o = 0
local ef = TabFrames["ESP"]
makeSection(ef, "Zombie ESP", nextOrder())
makeToggle(ef, "ESP Runner (Fast)", false, function(v) espRToggled = v end, nextOrder())
makeToggle(ef, "ESP Bomber", false, function(v) espBToggled = v end, nextOrder())
makeToggle(ef, "ESP Igniter", false, function(v) espIToggled = v end, nextOrder())
makeToggle(ef, "ESP Cuirassier", false, function(v) espCuToggled = v end, nextOrder())
makeToggle(ef, "ESP Zapper", false, function(v) espZToggled = v end, nextOrder())
makeSection(ef, "Boss & Player ESP", nextOrder())
makeToggle(ef, "ESP Boss (Headless)", false, function(v) espBossToggled = v; updateBossESP() end, nextOrder())
makeToggle(ef, "Medic Player ESP", false, function(v) espMedicToggled = v; if v or espInfectionToggled then checkPlayersLife() end end, nextOrder())
makeToggle(ef, "Infection ESP", false, function(v) espInfectionToggled = v; if v or espMedicToggled then checkPlayersLife() end end, nextOrder())

-- ========== PLAYER TAB ==========
o = 0
local pf = TabFrames["Player"]
makeSection(pf, "Movement", nextOrder())
makeToggle(pf, "Fly", false, function(v)
    FLYING = v
    if v then sFLY() else NOFLY() end
end, nextOrder())
makeToggle(pf, "Noclip", false, function(v) if v then startNoclip() else stopNoclip() end end, nextOrder())
makeToggle(pf, "No Fall Damage", false, function(v) NO_FALL_DAMAGE = v end, nextOrder())
makeSlider(pf, "Fly Speed", 10, 100, 35, function(v) FLY_SPEED = v; iyflyspeed2 = v / 50 end, nextOrder())
makeSection(pf, "WalkSpeed", nextOrder())
makeToggle(pf, "WalkSpeed Override", false, function(v) walkSpeedToggled = v; changeWalkSpeed(walkSpeedValue, walkSpeedToggled) end, nextOrder())
makeSlider(pf, "Walk Speed Value", 4, 100, 16, function(v) walkSpeedValue = v; changeWalkSpeed(v, walkSpeedToggled) end, nextOrder())
makeSection(pf, "Protection", nextOrder())
makeToggle(pf, "Killbrick Protection", false, function(v) toggleKillbrick(not v) end, nextOrder())

-- ========== VISUAL TAB ==========
o = 0
local vf = TabFrames["Visual"]
makeSection(vf, "Lighting", nextOrder())
makeToggle(vf, "Fullbright", false, function(v) toggleFullbright(v) end, nextOrder())

-- ========== EVENT TAB ==========
o = 0
local evf = TabFrames["Event"]
makeSection(evf, "Headless Horseman", nextOrder())
makeToggle(evf, "Auto Fire Headless", false, function(v) toggleAutoFireHeadless(v) end, nextOrder())
makeSlider(evf, "Headless Fire Range", 50, 200, 100, function(v) autoFireHeadlessRange = v end, nextOrder())
makeToggle(evf, "Auto Prediction", true, function(v) autoPredictionEnabled = v; if not v then currentPrediction = basePrediction end end, nextOrder())
makeSlider(evf, "Base Prediction (x100)", 5, 50, 15, function(v) basePrediction = v / 100; if not autoPredictionEnabled then currentPrediction = v / 100 end end, nextOrder())

-- ========== MISC TAB ==========
o = 0
local mf = TabFrames["Misc"]
makeSection(mf, "Utilities", nextOrder())
makeButton(mf, "Lights On (Saint Petersburg)", function() pcall(onLights) end, nextOrder())
makeButton(mf, "Load Old Source", function()
    local ok, err = pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/cjbbth1-crypto/Chaos-Hub-GB/refs/heads/main/Chaos%20Hub"))() end)
    if not ok then warn("Load failed: " .. tostring(err)) end
end, nextOrder())
makeButton(mf, "Load Animation Fun", function()
    local ok, err = pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/cjbbth1-crypto/Animation-fun/refs/heads/main/Animation%20fun"))() end)
    if not ok then warn("Load failed: " .. tostring(err)) end
end, nextOrder())

-- ===================== SHOW GUI =====================
selectTab("Combat")
task.wait(0.2)
Win.Visible = true
Win.Size = UDim2.new(0, 700, 0, 0)
Tween(Win, {Size = UDim2.new(0, 700, 0, 490)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

print("[ArcaneHub v3.0] Loaded! Press RightShift to toggle.")