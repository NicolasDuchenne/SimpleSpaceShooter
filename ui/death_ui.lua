local deathUI = {}
deathUI.test = newTextButton(
    newVector2(100, 100),
    newVector2(50,20),
    "test")
deathUI.button = newTextButton(newVector2(ScreenWidth/2, ScreenHeight/2), newVector2(124,64), "YOU DIED \n CLICK TO RESTART")
return deathUI