# Simple Space Shooter
* auto-gen TOC:
{:toc}

## Principe de jeu
Simple Space Shooter est un jeu de type « Vampire Survivor » dans l'espace. 

### Joueur
* Le joueur contrôle un vaisseau spatial dont le niveau augmente lorsqu'il élimine des ennemis.
* Il peut tirer son arme principale et utiliser son boost
* À chaque niveau, le joueur peut choisir une amélioration parmi trois options pour augmenter ses dégâts, sa vie, sa vitesse de tir, etc.
* Tous les dix niveaux, le joueur peut choisir une nouvelle arme. Il y a 4 armes disponibles au total, chacune avec ses caractéristiques propres :
  * Auto Gun : arme de base, tir rapide et dégâts modérés
  * Big Space Gun : arme lourde, tir lent et dégâts moyens, mais ses balles traversent les ennemis
  * Rockers : arme légère, tir lent et faibles dégâts, mais ses balles sont à tête chercheuse
  * Zapper : arme lourde, tir à vitesse moyenne et dégâts élevés, les balles rebondissent sur les ennemis

### Ennemis
* Les ennemis apparaissent de manière aléatoire.
* Plus le niveau du joueur est élevé, plus le nombre d'ennemis augmente et plus ils apparaissent rapidement.
* Il y a trois types d'ennemis :
  * Fighter : ennemi léger qui tire des roquettes destructibles par le joueur.
  * Torpedo : ennemi kamikaze qui cherche à détruire le joueur en le percutant.
  * BattleShip : ennemi lourd qui tire des salves de 6 boules indestructibles.


* Tous les dix niveaux, un portail s'ouvre. Le joueur peut choisir d'y entrer pour affronter un boss.
* Le boss possède 3 patterns distincts et devient invincible entre chacun d'eux.

### But du jeu
Survivre le plus longtemps possible et accumuler le plus de point. Le score est affiché en haut a droite de l'écran

### Controles
#### Controle de base
* a: left
* w: up
* s: down
* d: right

* left_click: shoot or select
* left_shift: boost

* p: pause music
* escape: pause game
* space: return to main menu

* 1-4 : change weapon

#### Cheat Codes
* v: Spawn weapon selection menu
* t: Spawn upgrade selection menu
* y: Spawn boss vortex
* h: Spawn survival vortex
* return: Change level (from boss to survival and back)


## Code Source
### Structure
![Structure du code](doc/Module1GameStructure.drawio.png)

### Decoupage

### Machine à états
#### Machine à états des ennemis
![Machine à états des ennemis](doc%2FEnemyStateMachine.drawio.png)

#### Machine à états du boss
![Machine à états du boss](doc%2FBossStateMachine.drawio.png)