local Menu = {}



Menu.create_buttons = function()
    local buttons_size = newVector2(200,50)
    Menu.start_button = newTextButton(newVector2(ScreenWidth * 0.5 - buttons_size.x * 0.5, ScreenHeight * 0.5 -buttons_size.y), buttons_size, "START GAME", true)
end




return Menu