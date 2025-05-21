-- Solara / Synapse compatible HTTP request function
local http_request = http_request or syn.request or request
local HttpService = game:GetService("HttpService")

-- Your Discord webhook URL here
local webhook_url = "https://discord.com/api/webhooks/1374572921145655348/U5Gz0q4VhLXImjH0O16e28BjibRC0u0aOzz0elwxuxuGHPxDOdSI-J6Fre1MJFX-EkTlasda"

-- Replace these with the actual GUI paths from Grow a Garden
local playerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

-- Example GUI container and labels, change these to match Grow a Garden's GUI names!
local gardenUI = playerGui:WaitForChild("GardenUI") -- Example name, change it
local seedsLabel = gardenUI:WaitForChild("SeedsText") -- e.g. "Carrot: 120, Corn: 85"
local gearLabel = gardenUI:WaitForChild("GearText")   -- e.g. "Hoe: 20, Watering Can: 15"
local weatherLabel = gardenUI:WaitForChild("WeatherText") -- e.g. "Rainy 🌧️"

local lastState = ""

local function sendEmbedWebhook(seeds, gear, weather)
    local embed = {
        title = "🌱 Grow a Garden Restock Update",
        color = 5763719, -- green color
        fields = {
            {
                name = "🌾 Seeds",
                value = seeds ~= "" and seeds or "No data",
                inline = false
            },
            {
                name = "⚙️ Gear",
                value = gear ~= "" and gear or "No data",
                inline = false
            },
            {
                name = "☀️ Weather",
                value = weather ~= "" and weather or "No data",
                inline = false
            }
        },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }

    local payload = HttpService:JSONEncode({
        username = "Garden Bot",
        embeds = {embed}
    })

    http_request({
        Url = webhook_url,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = payload
    })

    print("✅ Sent restock embed to Discord")
end

task.spawn(function()
    while true do
        local currentState = seedsLabel.Text .. gearLabel.Text .. weatherLabel.Text
        if currentState ~= lastState then
            sendEmbedWebhook(seedsLabel.Text, gearLabel.Text, weatherLabel.Text)
            lastState = currentState
        end
        wait(5)
    end
end)
