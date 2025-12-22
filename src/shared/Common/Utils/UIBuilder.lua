local UIBuilder = {}

type Properties = {[string]: any}

function UIBuilder.Create(ClassName: string, Properties: Properties, Children: {Instance}?)
    local Instance = Instance.new(ClassName)

    for Name, Value in pairs(Properties) do
        Instance[Name] = Value
    end

    if Children then
        for _, Child in ipairs(Children) do
            Child.Parent = Instance
        end
    end

    return Instance
end

UIBuilder.Theme = {
    Colors = {
        Background = Color3.fromRGB(20, 20, 20),
        Accent = Color3.fromRGB(200, 50, 50),
        Text = Color3.fromRGB(240, 240, 240),
        SlotBg = Color3.fromRGB(40, 40, 40)
    },
    Font = Enum.Font.GothamMedium
}

return UIBuilder