-- Config Module
-- Loads configuration from config.json
-- Provides default values if config file is missing or invalid

local Config = {}

-- Default configuration values
local defaults = {
    version = "0.2.0",
    corruptionDecayRate = 0.5,
    corruptionDecayInterval = 5.0,
    masteryMultiplier = 1.0,
    enableDebugMode = false,
    enableDebugLogging = false,
    possessionSpreadChance = 0.3,
    visualEffectsIntensity = 1.0,
    corruptionThresholds = {
        low = 25,
        medium = 50,
        high = 75,
        critical = 90
    },
    depthUnlockRequirements = {
        depth1 = 0,
        depth2 = 10,
        depth3 = 25,
        depth4 = 50,
        depth5 = 100
    },
    quickhackCorruptionCost = {
        BlackwallTrace = 5,
        NeuralHijack = 10,
        CascadeProtocol = 15,
        SummonDaemon = 20,
        BlackwallOverload = 30,
        Stabilize = -25
    },
    feedbackDamageChance = {
        depth1 = 0.05,
        depth2 = 0.10,
        depth3 = 0.15,
        depth4 = 0.20,
        depth5 = 0.25
    },
    masteryReduction = {
        enabled = true,
        maxReduction = 0.5,
        masteryRequired = 100
    },
    whispers = {
        enabled = true,
        minCooldown = 30.0,
        maxChanceAtFullCorruption = 0.15,
        hostileWhisperReduction = 0.5
    },
    events = {
        enabled = true,
        minCooldown = 60.0,
        pulseChance = 0.1,
        glitchChance = 0.2,
        thinSpotDiscoveryRange = 50.0,
        thinSpotCorruptionRange = 30.0
    },
    cyberwareMalfunction = {
        enabled = true,
        checkInterval = 5.0,
        minCorruptionForMalfunction = 50,
        baseChanceAtCritical = 0.1,
        shieldedReduction = 0.9
    },
    moralConsequences = {
        enabled = true,
        netwatchAlertThreshold = 50,
        corruptedAlignmentThreshold = 95,
        symbioticRequiredTrust = 75
    },
    ui = {
        showCorruptionMeter = true,
        showMasteryProgress = true,
        showDepthLevel = true,
        showAlignment = true,
        showWhispers = true,
        hudPosition = {
            x = 50,
            y = 100
        },
        updateInterval = 0.1
    }
}

-- Deep copy function for tables
local function deepCopy(orig)
    local copy
    if type(orig) == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepCopy(orig_key)] = deepCopy(orig_value)
        end
        setmetatable(copy, deepCopy(getmetatable(orig)))
    else
        copy = orig
    end
    return copy
end

-- Merge tables (source values override destination)
local function mergeTables(dest, source)
    for key, value in pairs(source) do
        if type(value) == "table" and type(dest[key]) == "table" then
            mergeTables(dest[key], value)
        else
            dest[key] = value
        end
    end
    return dest
end

-- Simple JSON parser for config file (handles basic JSON structure)
local function parseJSON(str)
    -- Remove comments (not standard JSON but sometimes used)
    str = str:gsub("//[^\n]*", "")

    -- Basic JSON parsing using Lua pattern matching
    -- This is a simplified parser suitable for config files
    local pos = 1
    local char = function()
        return str:sub(pos, pos)
    end
    local skip_whitespace = function()
        while pos <= #str and str:sub(pos, pos):match("%s") do
            pos = pos + 1
        end
    end
    local parse_value

    local function parse_string()
        if char() ~= '"' then return nil end
        pos = pos + 1
        local start = pos
        while pos <= #str and char() ~= '"' do
            if char() == '\\' then
                pos = pos + 2
            else
                pos = pos + 1
            end
        end
        local result = str:sub(start, pos - 1)
        pos = pos + 1  -- skip closing quote
        -- Handle escape sequences
        result = result:gsub("\\n", "\n")
        result = result:gsub("\\t", "\t")
        result = result:gsub("\\\"", "\"")
        result = result:gsub("\\\\", "\\")
        return result
    end

    local function parse_number()
        local start = pos
        if char() == '-' then pos = pos + 1 end
        while pos <= #str and char():match("[%d]") do
            pos = pos + 1
        end
        if char() == '.' then
            pos = pos + 1
            while pos <= #str and char():match("[%d]") do
                pos = pos + 1
            end
        end
        if char() == 'e' or char() == 'E' then
            pos = pos + 1
            if char() == '+' or char() == '-' then pos = pos + 1 end
            while pos <= #str and char():match("[%d]") do
                pos = pos + 1
            end
        end
        return tonumber(str:sub(start, pos - 1))
    end

    local function parse_object()
        if char() ~= '{' then return nil end
        pos = pos + 1
        skip_whitespace()
        local obj = {}
        if char() == '}' then
            pos = pos + 1
            return obj
        end
        while true do
            skip_whitespace()
            local key = parse_string()
            if not key then break end
            skip_whitespace()
            if char() ~= ':' then break end
            pos = pos + 1
            skip_whitespace()
            local value = parse_value()
            obj[key] = value
            skip_whitespace()
            if char() == '}' then
                pos = pos + 1
                return obj
            end
            if char() ~= ',' then break end
            pos = pos + 1
        end
        return obj
    end

    local function parse_array()
        if char() ~= '[' then return nil end
        pos = pos + 1
        skip_whitespace()
        local arr = {}
        if char() == ']' then
            pos = pos + 1
            return arr
        end
        while true do
            skip_whitespace()
            local value = parse_value()
            table.insert(arr, value)
            skip_whitespace()
            if char() == ']' then
                pos = pos + 1
                return arr
            end
            if char() ~= ',' then break end
            pos = pos + 1
        end
        return arr
    end

    parse_value = function()
        skip_whitespace()
        local c = char()
        if c == '{' then
            return parse_object()
        elseif c == '[' then
            return parse_array()
        elseif c == '"' then
            return parse_string()
        elseif c == 't' then
            if str:sub(pos, pos + 3) == "true" then
                pos = pos + 4
                return true
            end
        elseif c == 'f' then
            if str:sub(pos, pos + 4) == "false" then
                pos = pos + 5
                return false
            end
        elseif c == 'n' then
            if str:sub(pos, pos + 3) == "null" then
                pos = pos + 4
                return nil
            end
        elseif c:match("[%d%-]") then
            return parse_number()
        end
        return nil
    end

    return parse_value()
end

-- Encode Lua table to JSON string
local function encodeJSON(tbl, indent)
    indent = indent or 0
    local spaces = string.rep("  ", indent)
    local nextSpaces = string.rep("  ", indent + 1)

    if type(tbl) ~= "table" then
        if type(tbl) == "string" then
            return '"' .. tbl:gsub("\\", "\\\\"):gsub('"', '\\"'):gsub("\n", "\\n") .. '"'
        elseif type(tbl) == "boolean" then
            return tbl and "true" or "false"
        elseif type(tbl) == "number" then
            return tostring(tbl)
        else
            return "null"
        end
    end

    -- Check if array
    local isArray = #tbl > 0
    if isArray then
        for k, _ in pairs(tbl) do
            if type(k) ~= "number" then
                isArray = false
                break
            end
        end
    end

    local result = {}
    if isArray then
        table.insert(result, "[\n")
        for i, v in ipairs(tbl) do
            table.insert(result, nextSpaces .. encodeJSON(v, indent + 1))
            if i < #tbl then
                table.insert(result, ",")
            end
            table.insert(result, "\n")
        end
        table.insert(result, spaces .. "]")
    else
        table.insert(result, "{\n")
        local keys = {}
        for k in pairs(tbl) do
            table.insert(keys, k)
        end
        table.sort(keys, function(a, b)
            return tostring(a) < tostring(b)
        end)
        for i, k in ipairs(keys) do
            table.insert(result, nextSpaces .. '"' .. tostring(k) .. '": ' .. encodeJSON(tbl[k], indent + 1))
            if i < #keys then
                table.insert(result, ",")
            end
            table.insert(result, "\n")
        end
        table.insert(result, spaces .. "}")
    end

    return table.concat(result)
end

-- Load config from file
local function loadConfig()
    local config = deepCopy(defaults)

    -- Try to load config.json
    local file = io.open("config.json", "r")
    if file then
        local content = file:read("*a")
        file:close()

        local success, parsed = pcall(parseJSON, content)
        if success and parsed then
            config = mergeTables(config, parsed)
            print("[BTW] Configuration loaded from config.json")
        else
            print("[BTW] Warning: Could not parse config.json, using defaults")
        end
    else
        print("[BTW] No config.json found, using defaults")
    end

    return config
end

-- Export JSON functions for use by other modules
Config.parseJSON = parseJSON
Config.encodeJSON = encodeJSON

-- Load and return config
local loadedConfig = loadConfig()
for k, v in pairs(loadedConfig) do
    Config[k] = v
end

return Config
