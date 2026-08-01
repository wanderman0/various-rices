local beautiful = require("beautiful")
local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local json = require("dkjson")

local api_key = "c8a09a2199c726a68fe74c7fba6ed92a"
local lat = "36.54178"
local lon = "3.081"
local units = "metric"

local weather_widget = wibox.widget {
    {
        id = "icon",
        text = "⛅",
        font = "Sans 14",
        widget = wibox.widget.textbox,
    },
    {
        id = "temp",
        text = "...",
        font = "Sans 12",
        widget = wibox.widget.textbox,
    },
    layout = wibox.layout.fixed.horizontal,
    set_weather = function(self, weather, condition, is_day)
    local emoji_map_day = {
        ["Clear"] = "🌞",
        ["Clouds"] = "☁️",
        ["Rain"] = "🌧️",
        ["Drizzle"] = "🌦️",
        ["Thunderstorm"] = "⛈️",
        ["Snow"] = "❄️",
        ["Mist"] = "🌫️",
    }
    local emoji_map_night = {
        ["Clear"] = "🌙",
        ["Clouds"] = "☁️",
        ["Rain"] = "🌧️",
        ["Drizzle"] = "🌦️",
        ["Thunderstorm"] = "⛈️",
        ["Snow"] = "❄️",
        ["Mist"] = "🌫️",
    }
    local emoji_map = is_day and emoji_map_day or emoji_map_night
    local emoji = emoji_map[condition] or (is_day and "⛅" or "🌙")
    self:get_children_by_id("icon")[1]:set_text(emoji)
    self:get_children_by_id("temp")[1]:set_text(weather)
end
}

-- Tooltip pour l'humidité et le vent
local weather_tooltip = awful.tooltip {
    objects = { weather_widget },
    text = "Chargement...",
    mode = "outside",
    align = "right",
}

-- Clic gauche : ouvrir les prévisions détaillées dans le navigateur
weather_widget:buttons(gears.table.join(
    awful.button({}, 1, function()
        awful.spawn.with_shell(
            string.format("xdg-open 'https://openweathermap.org/weathermap?zoom=10&lat=%s&lon=%s'", lat, lon)
        )
    end)
))

local function update_weather()
    local cmd = string.format(
        "curl -s --max-time 5 'http://api.openweathermap.org/data/2.5/weather?lat=%s&lon=%s&appid=%s&units=%s'",
        lat, lon, api_key, units
    )

    awful.spawn.easy_async_with_shell(cmd, function(stdout, stderr, reason, exit_code)
        local ok, data = pcall(function()
            local weather_data = stdout and stdout:match("{.*}")
            if not weather_data then return nil end
            return json.decode(weather_data, 1, nil)
        end)

if ok and data and data.main and data.weather and #data.weather > 0 then
    local temp = math.floor(data.main.temp) .. "°"
    local condition = data.weather[1].main
    local description = data.weather[1].description or condition
    local humidity = data.main.humidity
    local wind_speed = data.wind and data.wind.speed or 0
    local is_day = data.weather[1].icon and data.weather[1].icon:sub(-1) == "d"

    weather_widget:set_weather(temp, condition, is_day)

    weather_tooltip.text = string.format(
        "%s\nHumidité 💧: %d%%\nVent 🌬️: %.1f km/h 💨",
        description:gsub("^%l", string.upper),
        humidity,
        wind_speed * 3.6
            )
        else
            weather_widget:set_weather("N/A", "⛅")
            weather_tooltip.text = "Données indisponibles"
        end
    end)
end

update_weather()
gears.timer {
    timeout = 600,
    call_now = true,
    autostart = true,
    callback = update_weather,
}

return weather_widget