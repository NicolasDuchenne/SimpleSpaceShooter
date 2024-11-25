local deathUI = {}

deathUI.button = {}
deathUI.button_size = newVector2(248,124)
deathUI.pos = newVector2(ScreenWidth/2-deathUI.button_size.x/2, ScreenHeight/2+deathUI.button_size.y/2)

deathUI.create_button = function()
    deathUI.button = newTextButton(deathUI.pos, deathUI.button_size, "YOU DIED \n CLICK TO RESTART", true)
end

deathUI.remove_button = function()
    deathUI.button.remove = true
end


return deathUI