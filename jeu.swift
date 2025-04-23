import Foundation

// Classe de base pour tous les personnages
class Personnage {
    let nom: String
    var pointsDeVie: Int
    var attaque: Int        // Changé en var pour permettre les modifications
    var defense: Int        // Changé en var pour permettre les modifications
    let type: String
    var potions: Int = 2    // Chaque personnage commence avec 2 potions
    var techniqueSpeciale: (nom: String, description: String, effet: () -> Void)
    var utilisationsTechniqueSpeciale: Int = 2  // Nombre d'utilisations max de la technique spéciale
    
    init(nom: String, pointsDeVie: Int, attaque: Int, defense: Int, type: String, techniqueSpeciale: (nom: String, description: String, effet: () -> Void)) {
        self.nom = nom
        self.pointsDeVie = pointsDeVie
        self.attaque = attaque
        self.defense = defense
        self.type = type
        self.techniqueSpeciale = techniqueSpeciale
    }
    
    var estVivant: Bool {
        return pointsDeVie > 0
    }
    
    func attaquer(cible: Personnage) -> Int {
        let degats = max(1, attaque - cible.defense)
        cible.pointsDeVie = max(0, cible.pointsDeVie - degats)
        return degats
    }
    
    func utiliserPotion() -> Bool {
        if potions > 0 {
            pointsDeVie += 20  // La potion restaure 20 points de vie
            potions -= 1
            return true
        }
        return false
    }
    
    func utiliserTechniqueSpeciale() -> Bool {
        if utilisationsTechniqueSpeciale > 0 {
            techniqueSpeciale.effet()
            utilisationsTechniqueSpeciale -= 1
            return true
        }
        return false
    }
    
    func description() -> String {
        return "\(nom) (\(type)) - PV: \(pointsDeVie), ATT: \(attaque), DEF: \(defense), Potions: \(potions), Technique spéciale: \(utilisationsTechniqueSpeciale) utilisations restantes"
    }
}

// Fonctions pour créer les différentes classes de personnages avec leurs techniques spéciales
func creerOrdre(nom: String) -> Personnage {
    let personnage = Personnage(
        nom: nom,
        pointsDeVie: 120,
        attaque: 15,
        defense: 10,
        type: "Ordre",
        techniqueSpeciale: (
            nom: "Bouclier Divin",
            description: "Augmente temporairement la défense de 8 points",
            effet: { }
        )
    )
    
    // On redéfinit l'effet avec une référence au personnage
    personnage.techniqueSpeciale.effet = {
        personnage.defense += 8
        print("\(personnage.nom) active Bouclier Divin et gagne +8 en défense!")
    }
    
    return personnage
}

func creerFee(nom: String) -> Personnage {
    let personnage = Personnage(
        nom: nom,
        pointsDeVie: 80,
        attaque: 20,
        defense: 5,
        type: "Fée",
        techniqueSpeciale: (
            nom: "Explosion Arcanique",
            description: "Inflige 25 points de dégâts directs à l'ennemi",
            effet: { }
        )
    )
    
    return personnage
}

func creerElfe(nom: String) -> Personnage {
    let personnage = Personnage(
        nom: nom,
        pointsDeVie: 90,
        attaque: 18,
        defense: 7,
        type: "Elfe",
        techniqueSpeciale: (
            nom: "Flèche Perçante",
            description: "Ignore la défense de l'ennemi et inflige 15 points de dégâts",
            effet: { }
        )
    )
    
    return personnage
}

// Gestion des combats
func combat(joueur: Personnage, ennemi: Personnage) -> Bool {
    var tour = 1
    let joueurActuel = joueur
    let ennemiActuel = ennemi
    
    print("\n=== DÉBUT DU COMBAT: \(joueurActuel.nom) vs \(ennemiActuel.nom) ===")
    
    // Création de closures pour les techniques spéciales qui nécessitent une cible
    // Ces closures doivent être définies ici pour avoir accès aux références correctes
    if joueurActuel.type == "Fée" {
        joueurActuel.techniqueSpeciale.effet = {
            ennemiActuel.pointsDeVie = max(0, ennemiActuel.pointsDeVie - 25)
            print("\(joueurActuel.nom) lance Explosion Arcanique et inflige 25 points de dégâts directs à \(ennemiActuel.nom)!")
        }
    } else if joueurActuel.type == "Elfe" {
        joueurActuel.techniqueSpeciale.effet = {
            ennemiActuel.pointsDeVie = max(0, ennemiActuel.pointsDeVie - 15)
            print("\(joueurActuel.nom) tire une Flèche Perçante qui ignore la défense et inflige 15 points de dégâts à \(ennemiActuel.nom)!")
        }
    }
    
    // Même chose pour l'ennemi
    if ennemiActuel.type == "Fée" {
        ennemiActuel.techniqueSpeciale.effet = {
            joueurActuel.pointsDeVie = max(0, joueurActuel.pointsDeVie - 25)
            print("\(ennemiActuel.nom) lance Explosion Arcanique et inflige 25 points de dégâts directs à \(joueurActuel.nom)!")
        }
    } else if ennemiActuel.type == "Elfe" {
        ennemiActuel.techniqueSpeciale.effet = {
            joueurActuel.pointsDeVie = max(0, joueurActuel.pointsDeVie - 15)
            print("\(ennemiActuel.nom) tire une Flèche Perçante qui ignore la défense et inflige 15 points de dégâts à \(joueurActuel.nom)!")
        }
    }
    
    while joueurActuel.estVivant && ennemiActuel.estVivant {
        print("\n--- TOUR \(tour) ---")
        print(joueurActuel.description())
        print(ennemiActuel.description())
        
        // Tour du joueur
        var actionValide = false
        
        while !actionValide {
            print("\nQue souhaitez-vous faire?")
            print("[1] Attaquer")
            print("[2] Utiliser une potion (\(joueurActuel.potions) restantes)")
            print("[3] Utiliser technique spéciale: \(joueurActuel.techniqueSpeciale.nom) (\(joueurActuel.utilisationsTechniqueSpeciale) restantes)")
            print("    \(joueurActuel.techniqueSpeciale.description)")
            
            if let choix = readLine(), let action = Int(choix) {
                switch action {
                case 1: // Attaquer
                    let degatsJoueur = joueurActuel.attaquer(cible: ennemiActuel)
                    print("\(joueurActuel.nom) attaque et inflige \(degatsJoueur) points de dégâts à \(ennemiActuel.nom)!")
                    actionValide = true
                    
                case 2: // Utiliser une potion
                    if joueurActuel.utiliserPotion() {
                        print("\(joueurActuel.nom) utilise une potion et récupère 20 points de vie! PV actuels: \(joueurActuel.pointsDeVie)")
                        actionValide = true
                    } else {
                        print("Vous n'avez plus de potions!")
                    }
                    
                case 3: // Utiliser technique spéciale
                    if joueurActuel.utiliserTechniqueSpeciale() {
                        // L'effet est exécuté dans la closure définie dans utiliserTechniqueSpeciale
                        actionValide = true
                    } else {
                        print("Vous avez épuisé votre technique spéciale!")
                    }
                    
                default:
                    print("Action non reconnue. Veuillez choisir 1 pour attaquer, 2 pour utiliser une potion, ou 3 pour la technique spéciale.")
                }
            } else {
                print("Entrée invalide. Veuillez choisir une action valide.")
            }
        }
        
        if !ennemiActuel.estVivant {
            print("\(ennemiActuel.nom) est vaincu!")
            break
        }
        
        // Tour de l'ennemi - l'IA simple améliorée
        print("\nAu tour de \(ennemiActuel.nom)...")
        
        // L'ennemi utilise la technique spéciale s'il peut et si le joueur a plus de 40 PV
        if ennemiActuel.utilisationsTechniqueSpeciale > 0 && joueurActuel.pointsDeVie > 40 {
            _ = ennemiActuel.utiliserTechniqueSpeciale()  // Utilisation du résultat de l'appel
        }
        // Sinon, utilise une potion si ses PV sont bas
        else if ennemiActuel.pointsDeVie < 30 && ennemiActuel.potions > 0 {
            if ennemiActuel.utiliserPotion() {
                print("\(ennemiActuel.nom) utilise une potion et récupère 20 points de vie! PV actuels: \(ennemiActuel.pointsDeVie)")
            }
        } 
        // Sinon, attaque normalement
        else {
            let degatsEnnemi = ennemiActuel.attaquer(cible: joueurActuel)
            print("\(ennemiActuel.nom) attaque et inflige \(degatsEnnemi) points de dégâts à \(joueurActuel.nom)!")
        }
        
        if !joueurActuel.estVivant {
            print("\(joueurActuel.nom) est vaincu!")
            break
        }
        
        tour += 1
    }
    
    return joueurActuel.estVivant
}

// Fonction principale du jeu
func jouer() {
    print("==============================================")
    print("         BIENVENUE DANS LE JEU RPG           ")
    print("==============================================")
    print("Vous êtes sur le point d'entrer dans un monde")
    print("fantastique peuplé d'elfes, de fées et de    ")
    print("membres de l'Ordre, une guilde respectée.    ")
    print("==============================================")
    
    print("\nChoisissez votre classe de personnage:")
    print("[1] Ordre - Guerrier discipliné avec forte défense")
    print("    Technique spéciale: Bouclier Divin (+8 défense)")
    print("[2] Fée - Magicienne puissante avec forte attaque")
    print("    Technique spéciale: Explosion Arcanique (25 dégâts directs)")
    print("[3] Elfe - Archer agile et équilibré")
    print("    Technique spéciale: Flèche Perçante (15 dégâts, ignore défense)")
    
    var joueur: Personnage? = nil
    
    while joueur == nil {
        if let choix = readLine(), let classeChoix = Int(choix) {
            print("\nEntrez le nom de votre personnage:")
            if let nom = readLine(), !nom.isEmpty {
                switch classeChoix {
                case 1:
                    joueur = creerOrdre(nom: nom)
                    print("Vous avez créé un membre de l'Ordre nommé \(nom)!")
                case 2:
                    joueur = creerFee(nom: nom)
                    print("Vous avez créé une Fée nommée \(nom)!")
                case 3:
                    joueur = creerElfe(nom: nom)
                    print("Vous avez créé un Elfe nommé \(nom)!")
                default:
                    print("Choix invalide. Veuillez choisir entre 1 et 3.")
                }
            } else {
                print("Nom invalide. Veuillez entrer un nom.")
            }
        } else {
            print("Entrée invalide. Veuillez choisir entre 1 et 3.")
        }
    }
    
    print("\nRègles du jeu:")
    print("- Chaque personnage dispose de 2 potions maximum par combat")
    print("- Une potion restaure 20 points de vie")
    print("- Chaque personnage a une technique spéciale utilisable 2 fois max par combat")
    print("- Les ennemis peuvent aussi utiliser des potions et leurs techniques spéciales!")
    
    print("\nVotre personnage: \(joueur!.description())")
    print("\nVotre aventure commence!")
    print("Vous rencontrez un ennemi sur votre chemin!")
    
    let ennemi1 = creerElfe(nom: "Elfe Sombre")
    if combat(joueur: joueur!, ennemi: ennemi1) {
        // Réinitialisation des potions et techniques spéciales entre les combats
        joueur!.potions = 2
        joueur!.utilisationsTechniqueSpeciale = 2
        
        print("\nFélicitations! Vous avez vaincu l'Elfe Sombre!")
        print("Vous avez récupéré 2 potions et 2 utilisations de technique spéciale pour le prochain combat!")
        print("\nVous continuez votre aventure et rencontrez un autre ennemi...")
        
        let ennemi2 = creerOrdre(nom: "Chevalier Noir")
        if combat(joueur: joueur!, ennemi: ennemi2) {
            // Réinitialisation des potions et techniques spéciales entre les combats
            joueur!.potions = 2
            joueur!.utilisationsTechniqueSpeciale = 2
            
            print("\nBravo! Vous avez également vaincu le Chevalier Noir!")
            print("Vous avez récupéré 2 potions et 2 utilisations de technique spéciale pour le combat final!")
            print("\nVous avancez plus profondément dans le donjon...")
            print("Vous vous retrouvez face au boss final!")
            
            let boss = creerFee(nom: "Fée Corrompue")
            boss.pointsDeVie = 150 // Boss plus puissant
            
            if combat(joueur: joueur!, ennemi: boss) {
                print("\n=== FÉLICITATIONS ===")
                print("Vous avez terminé le jeu et sauvé le royaume!")
            } else {
                print("\nVous avez été vaincu par le boss final...")
                print("Fin du jeu.")
            }
        } else {
            print("\nVous avez été vaincu par le Chevalier Noir...")
            print("Fin du jeu.")
        }
    } else {
        print("\nVous avez été vaincu par l'Elfe Sombre...")
        print("Fin du jeu.")
    }
}

// Lancement du jeu
jouer()
