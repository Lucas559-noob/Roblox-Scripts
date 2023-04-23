local UserInputService = game:GetService("UserInputService")

local function isLootableObject(object)
    local keywords = {"money", "robux", "gold", "ring", "cash", "jewel"} -- specify the keywords to look for
    local currentObject = object

    while currentObject ~= nil do
        for _, keyword in ipairs(keywords) do
            if string.find(string.lower(currentObject.Name), keyword) ~= nil then
                return true
            end
        end
        currentObject = currentObject.Parent
    end

    return false
end

local function onKeyPressed(input, gameProcessedEvent)
    if input.KeyCode == Enum.KeyCode.L then -- check for the "l" key
        for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
            if v:IsA("ProximityPrompt") and isLootableObject(v) then
                fireproximityprompt(v)
            end
        end
    end
end

UserInputService.InputBegan:Connect(onKeyPressed)
