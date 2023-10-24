-- Main action wheel page

if host:isHost() then
    local mainPage=action_wheel:newPage("HomePage")
    mainPage:setAction(-1,require("tail"))
    mainPage:setAction(-1,require("ears"))
    mainPage:setAction(-1,require("Facescript"))
    mainPage:setAction(-1,require("script"))
    mainPage:setAction(-1, require("modules.Wings2D.Wings"))
    --mainPage:setAction(-1, require("Kick"))
    action_wheel:setPage(mainPage)
end