

# 🧙‍♂️ Jeu RPG Fantasy en Swift

Bienvenue dans un petit jeu de rôle (RPG) codé en **Swift**, qui vous plonge dans un univers fantastique où vous incarnez un personnage appartenant à l'une des trois classes disponibles : **Ordre**, **Fée** ou **Elfe**. Combattez des ennemis dans un système au tour par tour, utilisez des potions et déclenchez des techniques spéciales pour triompher !

## 🎮 Fonctionnalités

- Trois classes de personnage jouable :
  - **Ordre** : grande défense, technique spéciale "Bouclier Divin"
  - **Fée** : grande attaque, technique spéciale "Explosion Arcanique"
  - **Elfe** : personnage équilibré, technique spéciale "Flèche Perçante"

- Système de combat au tour par tour
- Potions de soin (x2 par personnage)
- Techniques spéciales limitées à deux utilisations
- Intelligence artificielle simple pour l'ennemi

## 🔧 Lancer le jeu

1. Ouvre le projet dans **Xcode** ou tout éditeur compatible avec Swift.
2. Lance le fichier principal (`main.swift`) contenant la fonction `jouer()`.
3. Suivez les instructions dans le terminal :
   - Choix de la classe
   - Saisie du nom
   - Tour par tour dans un combat contre un ennemi aléatoire

## 🧪 Exemple d'utilisation

```bash
==============================================
         BIENVENUE DANS LE JEU RPG           
==============================================
Choisissez votre classe de personnage:
[1] Ordre - Guerrier discipliné avec forte défense
[2] Fée - Magicienne puissante avec forte attaque
[3] Elfe - Archer agile et équilibré
> 2

Entrez le nom de votre personnage:
> Lyria
```

Vous serez ensuite plongé dans un combat épique ⚔️ !

## 📦 Structure du projet

- `Personnage.swift` : classe principale avec logique de combat et potions
- `creerOrdre/Fee/Elfe` : fonctions de création avec leurs techniques spéciales
- `combat(...)` : gère l’affrontement tour par tour
- `jouer()` : interface utilisateur simple en ligne de commande

## 🚀 Améliorations possibles

- Ajouter des effets temporaires pour les boosts (durée limitée)
- Créer plusieurs combats (mode aventure)
- Intégrer un système de niveau et d'expérience
- Ajouter des sons et une interface graphique avec SwiftUI

