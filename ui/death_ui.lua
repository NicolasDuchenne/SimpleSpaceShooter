local deathUI = {}

deathUI.button = {}

deathUI.create_button = function()
    deathUI.button = newTextButton(newVector2(ScreenWidth/2, ScreenHeight/2), newVector2(124,64), "YOU DIED \n CLICK TO RESTART")
end

deathUI.remove_button = function()
    deathUI.button.remove = true
end


return deathUI