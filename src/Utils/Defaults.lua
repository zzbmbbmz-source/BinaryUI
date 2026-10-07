local Defaults = {}

Defaults.Theme = {
    Fonts = {Main=Enum.Font.Gotham, Mono=Enum.Font.Code},
    Colors = {
        Background=Color3.fromRGB(10,11,17),
        Surface=Color3.fromRGB(17,18,27),
        Surface2=Color3.fromRGB(24,25,37),
        Text=Color3.fromRGB(240,241,250),
        Muted=Color3.fromRGB(150,153,170),
        Accent=Color3.fromRGB(166,92,255),
        Accent2=Color3.fromRGB(74,211,255),
        Success=Color3.fromRGB(72,220,143),
        Warning=Color3.fromRGB(255,190,70),
        Danger=Color3.fromRGB(255,91,115),
    },
    Corner=8,
    Stroke=1,
}

Defaults.Window = {
    Title="BinaryUI",
    Subtitle="Obsidian Neon",
    Size=UDim2.fromOffset(560,420),
    MinSize=Vector2.new(320,240),
}

return Defaults
