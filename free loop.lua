package.path = FileMgr.GetMenuRootPath() .. "\\Lua\\?.lua;"
require("natives/natives")

function InvokeNative(returnType, hash)
    local arg1, arg2 = (type(returnType) == "string") and returnType or "Void", hash or returnType
    return function(...) return Natives[string.format("Invoke%s", arg1)](arg2, ...) end
end

Native = {
    NETSHOPPING = {
        NET_GAMESERVER_BASKET_IS_ACTIVE = InvokeNative("Bool", 11985600000000000000),
        NET_GAMESERVER_BASKET_END = InvokeNative("Bool", 18028875000000000000)
    }
}

local DELAY_LOOP = 1000
local TRANSACTION_TYPE = "Basket Transaction"

function TriggerBKT(hash, amount)
    if TRANSACTION_TYPE == "Basket Transaction" then
        if Native.NETSHOPPING.NET_GAMESERVER_BASKET_IS_ACTIVE() then
            Native.NETSHOPPING.NET_GAMESERVER_BASKET_END()
        end
        local price = amount or 180000
        local valid, id = GTA.BeginService(-1135378931, 1474183246, hash, 1445302971, price, 2)
        if valid then GTA.CheckoutStart(id) end
    end
end

-- 180k Loop
FeatureMgr.AddFeature(
    Utils.Joaat("180kloop"),
    "180k Loop",
    eFeatureType.Toggle,
    "Earn 180k every second",
    function(f)
        while f:IsToggled() do
            TriggerBKT(Utils.Joaat("SERVICE_EARN_JOBS"), 180000)
            Script.Yield(DELAY_LOOP)
        end
    end
)

-- 680k Loop
FeatureMgr.AddFeature(
    Utils.Joaat("680kloop"),
    "680k Loop",
    eFeatureType.Toggle,
    "Earn 680k every second",
    function(f)
        while f:IsToggled() do
            TriggerBKT(Utils.Joaat("SERVICE_EARN_BETTING"), 680000)
            Script.Yield(DELAY_LOOP)
        end
    end
)

-- 2–3M Loop
FeatureMgr.AddFeature(
    Utils.Joaat("2-3mloop"),
    "2-3M Loop",
    eFeatureType.Toggle,
    "Earn 2M-3M per cycle",
    function(f)
        while f:IsToggled() do
            local amount = math.random(2000000, 3000000)
            TriggerBKT(Utils.Joaat("SERVICE_EARN_CASINO_HEIST_FINALE"), amount)
            Script.Yield(DELAY_LOOP)
        end
    end
)

-- GUI
ClickGUI.AddTab("Money Loop", function()
    if ImGui.BeginTabBar("SimpleMoneyLua") then
        if ImGui.BeginTabItem("Main") then
            if ClickGUI.BeginCustomChildWindow("Loop") then
                ClickGUI.RenderFeature(Utils.Joaat("180kloop"))
                ClickGUI.RenderFeature(Utils.Joaat("680kloop"))
                ClickGUI.RenderFeature(Utils.Joaat("2-3mloop"))
                ClickGUI.EndCustomChildWindow()
            end
            ImGui.EndTabItem()
        end
        ImGui.EndTabBar()
    end
end)
