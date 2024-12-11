# Simple Space Shooter

## Principe de jeu
Simple Space Shooter est un jeu de type « Vampire Survivor » dans l'espace entrecoupé de boss fight exigeants.

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
#### Scenes

##### Scene Manager
Scène parent héritée par toutes les scènes. Elle est appelée depuis le main et gère la scène actuelle.

##### Scene Menu
Le jeu démarre sur la scène menu, actuellement simple et permettant uniquement de lancer une partie.
Elle pourra être enrichie avec un système de sauvegarde et un tableau des scores.

##### Scene Game
Scène parent pour le gameplay, contenant les principales fonctions update et draw.
* La boucle d'update alterne entre deux fonctions selon l'état de pause :
  * Update game : actualise tous les éléments du jeu en mode actif
    * Update background : synchronise le fond avec la position du joueur, créant un effet de parallaxe
    * Update camera : suit les mouvements du joueur
    * Update playership : actualise le joueur
    * Update enemies : actualise tous les ennemis
    * Update projectile : actualise les projectiles
    * Update trigger : actualise les déclencheurs
    * Update pause : gère les éléments d'interface en pause
      * Update button : réagit aux clics et relance le jeu si nécessaire
* La boucle de draw affiche en continu tous les éléments graphiques

##### Scene Survivor
Hérite de Scene Game et implémente un système de spawn d'ennemis à intervalles réguliers

##### Scene Boss
Hérite de Scene Game et initialise le boss au chargement

#### Utils
Bibliothèque d'outils pour la gestion des sprites, du son, des vecteurs, etc.

#### Level
Gère le background, la caméra et les déclencheurs

#### UI
Contient l'élément Button pour créer l'interface utilisateur
Button génère des zones cliquables réagissant au survol et aux clics

#### Characters
Contient le cœur du code

##### Components
Éléments constitutifs des vaisseaux (joueur et ennemis)
* weapons
* projectiles
* engines
La variété des vaisseaux provient des fichiers de configuration définissant les armes et projectiles

##### Ships
Contient la ShipFactory, base de tous les vaisseaux
Un vaisseau combine sprite, moteur, arme, animation de destruction et caractéristiques de mouvement

###### Player
Hérite de ShipFactory
Adapte la fonction update pour le contrôle clavier/souris
Modules :
* experience : gère la progression et les améliorations de niveau, et le spawn du trigger du boss
* inventory : stocke et affiche les armes
* upgrade : propose des améliorations en pause

###### EnemyShip
Hérite de ShipFactory
Utilise une machine à états pour gérer déplacements et tirs
Configuration flexible des ennemis via paramètres d'armes et de comportement
Intègre le système de spawn des ennemis

###### EnemyBoss
Hérite de ShipFactory
Implémente le boss avec sa machine à états spécifique
Spawn une trigger quand il meurt


### Machine à états
#### Machine à états des ennemis
![Machine à états des ennemis](doc%2FEnemyStateMachine.drawio.png)
* High speed chase: lorsqu'un ennemi est loin du joueur, il va accelerer pour l'atteindre le plus vite possible
* Chase: l'ennemi calcul un vecteur d'offset, il va ensuite essayer d'aller a la position du joueur plus cet offset. 
Lorsqu'il arrive, il calcul un nouvel offset et va a cette nouvelle position. L'offset est calculé de maniere a ce que l'ennemi tourne autour du joueur
* Avoid ship: Meme principe que chase sauf que l'offset est calculé pour que l'ennemi fui le joueur. La vitesse de l'ennemi est aussi accéléré pour faciliter sa fuite
* Get Around: Si le joueur essai de fuir trop loin de l'ennemi, celui ci va accelerer et contourner le joueur. 
Cela permets d'empecher les strategies ou le joueur fui toujours dans le meme sens

#### Machine à états du boss
![Machine à états du boss](doc%2FBossStateMachine.drawio.png)