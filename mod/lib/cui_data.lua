include("CitySupport")
include("SupportFunctions")

-- ---------------------------------------------------------------------------

GameDistrictsTypes = {
    CITY_CENTER = {
        "DISTRICT_CITY_CENTER"
    },
    GOVERNMENT = {
        "DISTRICT_GOVERNMENT"
    },
    WONDER = {
        "DISTRICT_WONDER"
    },
    HOLY_SITE = {
        "DISTRICT_HOLY_SITE",
        "DISTRICT_LAVRA" -- Russia
    },
    CAMPUS = {
        "DISTRICT_CAMPUS",
        "DISTRICT_SEOWON" -- Korea
    },
    THEATER = {
        "DISTRICT_THEATER",
        "DISTRICT_ACROPOLIS" -- Greece
    },
    ENCAMPMENT = {
        "DISTRICT_ENCAMPMENT",
        "DISTRICT_IKANDA" -- Zulu
    },
    COMMERCIAL_HUB = {
        "DISTRICT_COMMERCIAL_HUB",
        "DISTRICT_SUGUBA" -- Mali
    },
    HARBOR = {
        "DISTRICT_HARBOR",
        "DISTRICT_COTHON", -- Phoenicia
        "DISTRICT_ROYAL_NAVY_DOCKYARD" -- England
    },
    ENTERTAINMENT_COMPLEX = {
        "DISTRICT_ENTERTAINMENT_COMPLEX",
        "DISTRICT_STREET_CARNIVAL", -- Brazil
        "DISTRICT_WATER_ENTERTAINMENT_COMPLEX",
        "DISTRICT_WATER_STREET_CARNIVAL" -- Brazil
    },
    INDUSTRIAL_ZONE = {
        "DISTRICT_INDUSTRIAL_ZONE",
        "DISTRICT_HANSA" -- Germany
    },
    AERODROME = {
        "DISTRICT_AERODROME"
    },
    SPACEPORT = {
        "DISTRICT_SPACEPORT"
    },
    AQUEDUCT = {
        "DISTRICT_AQUEDUCT",
        "DISTRICT_BATH" -- Rome
    },
    CANAL = {
        "DISTRICT_CANAL"
    },
    NEIGHBORHOOD = {
        "DISTRICT_NEIGHBORHOOD",
        "DISTRICT_MBANZA" -- Kongo
    },
    DAM = {
        "DISTRICT_DAM"
    }
}

-- ---------------------------------------------------------------------------
function CuiGetCityYield(city, round)
    local data = GetCityData(city)
    local n = round == nil and 1 or round
    local yields = {}
    yields.Food = Round(CuiGetFoodPerTurn(data), n)
    yields.Production = Round(data.ProductionPerTurn, n)
    yields.Gold = Round(data.GoldPerTurn, n)
    yields.Science = Round(data.SciencePerTurn, n)
    yields.Culture = Round(data.CulturePerTurn, n)
    yields.Faith = Round(data.FaithPerTurn, n)
    -- yields.Tourism = Round(CuiGetCityTourism(city), n)

    return yields
end

-- ---------------------------------------------------------------------------
function CuiGetFoodPerTurn(data)
    local modifiedFood
    local foodPerTurn
    if data.TurnsUntilGrowth > -1 then
        local growthModifier = math.max(1 + (data.HappinessGrowthModifier / 100) + data.OtherGrowthModifiers, 0)
        modifiedFood = Round(data.FoodSurplus * growthModifier, 2)
        if data.Occupied then
            foodPerTurn = modifiedFood * data.OccupationMultiplier
        else
            foodPerTurn = modifiedFood * data.HousingMultiplier
        end
    else
        foodPerTurn = data.FoodSurplus
    end
    return foodPerTurn
end

-- ---------------------------------------------------------------------------
function CuiGetCityTourism(city)
    local tourism = 0

    local playerID = Game.GetLocalPlayer()
    if playerID == PlayerTypes.NONE then
        UI.DataError("Unable to get valid playerID for report screen.")
        return 0
    end
    local player = Players[playerID]
    local pCulture = player:GetCulture()
    local cityPlots = Map.GetCityPlots():GetPurchasedPlots(city)
    for _, plotID in ipairs(cityPlots) do
        tourism = tourism + pCulture:GetTourismAt(plotID)
    end

    return tourism
end

-- ---------------------------------------------------------------------------
function CuiGetDistrictIcon(dType)
end
