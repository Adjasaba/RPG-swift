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
    
    // Fonction pour réinitialiser les potions et techniques spéciales
    func reinitialiser() {
        potions = 2
        utilisationsTechniqueSpeciale = 2
    }
}

// Classe pour représenter une salle
class Salle {
    let id: Int
    let nom: String
    let description: String
    let niveau: Int
    var ennemi: Personnage?
    var estBoss: Bool
    var sallesConnectees: [Int]
    var tresor: (description: String, effet: (Personnage) -> Void)?
    
    init(id: Int, nom: String, description: String, niveau: Int, ennemi: Personnage? = nil, estBoss: Bool = false, sallesConnectees: [Int] = [], tresor: (description: String, effet: (Personnage) -> Void)? = nil) {
        self.id = id
        self.nom = nom
        self.description = description
        self.niveau = niveau
        self.ennemi = ennemi
        self.estBoss = estBoss
        self.sallesConnectees = sallesConnectees
        self.tresor = tresor
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

// Fonction pour créer toutes les salles du jeu
func creerSalles() -> [Salle] {
    var salles: [Salle] = []
    
    // Niveau 1 - Entrée du donjon
    salles.append(Salle(
        id: 1,
        nom: "Entrée du Donjon",
        description: "Une grande porte en bois massif donne accès à un couloir sombre.",
        niveau: 1,
        sallesConnectees: [2, 3]
    ))
    
    salles.append(Salle(
        id: 2,
        nom: "Salle des Gardes",
        description: "Une petite salle où les gardes se reposaient. Un elfe sombre monte la garde.",
        niveau: 1,
        ennemi: creerElfe(nom: "Elfe Sombre"),
        sallesConnectees: [1, 4],
        tresor: (
            description: "Potion avancée",
            effet: { personnage in
                personnage.potions += 1
                print("Vous avez trouvé une potion avancée! (+1 potion)")
            }
        )
    ))
    
    salles.append(Salle(
        id: 3,
        nom: "Couloir Abandonné",
        description: "Un long couloir abandonné. Les murs sont couverts de mousse.",
        niveau: 1,
        sallesConnectees: [1, 5]
    ))
    
    // Niveau 2 - Étage intermédiaire
    salles.append(Salle(
        id: 4,
        nom: "Salle d'Entraînement",
        description: "Une grande salle remplie d'équipements d'entraînement. Un chevalier noir s'y exerce.",
        niveau: 2,
        ennemi: creerOrdre(nom: "Chevalier Noir"),
        sallesConnectees: [2, 6, 7],
        tresor: (
            description: "Amulette de Force",
            effet: { personnage in
                personnage.attaque += 5
                print("Vous avez trouvé une Amulette de Force! (+5 en attaque)")
            }
        )
    ))
    
    salles.append(Salle(
        id: 5,
        nom: "Bibliothèque Ancienne",
        description: "Une vaste bibliothèque remplie de livres anciens.",
        niveau: 2,
        sallesConnectees: [3, 7],
        tresor: (
            description: "Parchemin de Savoir",
            effet: { personnage in
                personnage.defense += 3
                print("Vous avez trouvé un Parchemin de Savoir! (+3 en défense)")
            }
        )
    ))
    
    // Niveau 3 - Profondeurs du donjon
    salles.append(Salle(
        id: 6,
        nom: "Crypte Oubliée",
        description: "Une crypte froide et humide. Des bruits étranges résonnent dans les ténèbres.",
        niveau: 3,
        ennemi: creerFee(nom: "Esprit Vengeur"),
        sallesConnectees: [4, 8],
        tresor: (
            description: "Essence Magique",
            effet: { personnage in
                personnage.utilisationsTechniqueSpeciale += 1
                print("Vous avez trouvé une Essence Magique! (+1 utilisation de technique spéciale)")
            }
        )
    ))
    
    salles.append(Salle(
        id: 7,
        nom: "Jardin Intérieur",
        description: "Un jardin magique à l'intérieur du donjon. La végétation y est étrangement vivante.",
        niveau: 3,
        ennemi: creerElfe(nom: "Gardien Végétal"),
        sallesConnectees: [4, 5, 8]
    ))
    
    // Niveau 4 - Salle du boss
    salles.append(Salle(
        id: 8,
        nom: "Chambre du Trône",
        description: "Une immense salle ornée d'or et de pierres précieuses. La Fée Corrompue vous attend sur son trône.",
        niveau: 4,
        ennemi: {
            let boss = creerFee(nom: "Fée Corrompue")
            boss.pointsDeVie = 150 // Boss plus puissant
            return boss
        }(),
        estBoss: true,
        sallesConnectees: [6, 7]
    ))
    
    return salles
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

// Fonction principale pour explorer une salle
func explorerSalle(joueur: Personnage, salles: [Salle], idSalle: Int) -> Int? {
    let salle = salles.first(where: { $0.id == idSalle })!
    
    print("\n=== SALLE: \(salle.nom) (Niveau \(salle.niveau)) ===")
    print(salle.description)
    
    // Gérer le combat si un ennemi est présent
    if let ennemi = salle.ennemi {
        print("\nUn ennemi approche: \(ennemi.nom) (\(ennemi.type))!")
        
        if combat(joueur: joueur, ennemi: ennemi) {
            // Victoire
            print("\nVous avez vaincu \(ennemi.nom)!")
            
            // Réinitialisation après le combat
            joueur.reinitialiser()
            
            // Donner le trésor s'il y en a un
            if let tresor = salle.tresor {
                print("\nVous avez trouvé un trésor: \(tresor.description)")
                tresor.effet(joueur)
            }
            
            // Si c'était le boss final
            if salle.estBoss {
                return 0  // Code spécial pour indiquer la fin du jeu avec victoire
            }
            
            // Supprimer l'ennemi pour ne pas refaire le combat
            salle.ennemi = nil
        } else {
            // Défaite
            return -1  // Code spécial pour indiquer la défaite
        }
    } else {
        // S'il n'y a pas d'ennemi mais qu'il y a un trésor qui n'a pas été pris
        if let tresor = salle.tresor {
            print("\nVous avez trouvé un trésor: \(tresor.description)")
            tresor.effet(joueur)
            salle.tresor = nil  // Le trésor a été pris
        }
    }
    
    // Montrer les salles connectées
    print("\nVous pouvez aller vers:")
    for idSalleConnectee in salle.sallesConnectees {
        if let salleConnectee = salles.first(where: { $0.id == idSalleConnectee }) {
            print("[\(idSalleConnectee)] \(salleConnectee.nom) (Niveau \(salleConnectee.niveau))")
        }
    }
    
    // Choix de la prochaine salle
    print("\nOù souhaitez-vous aller? (Entrez le numéro de la salle)")
    
    if let choix = readLine(), let idSalleChoisie = Int(choix) {
        if salle.sallesConnectees.contains(idSalleChoisie) {
            return idSalleChoisie
        } else {
            print("Choix invalide. Veuillez choisir une salle connectée.")
            return idSalle  // Rester dans la même salle
        }
    } else {
        print("Entrée invalide. Veuillez entrer un numéro de salle.")
        return idSalle  // Rester dans la même salle
    }
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
    print("- Après chaque combat, vous récupérez vos potions et utilisations de technique spéciale")
    print("- Le donjon est divisé en 4 niveaux, avec un boss final au niveau 4")
    print("- Explorez les salles pour trouver des trésors et progresser vers le boss")
    
    print("\nVotre personnage: \(joueur!.description())")
    print("\nVotre aventure commence!")
    
    // Créer toutes les salles du donjon
    let salles = creerSalles()
    
    // Commencer l'exploration à la salle 1
    var idSalleActuelle = 1
    
    // Boucle principale du jeu
    while true {
        let resultat = explorerSalle(joueur: joueur!, salles: salles, idSalle: idSalleActuelle)
        
        if resultat == 0 {
            // Victoire finale contre le boss
            print("\n=== FÉLICITATIONS ===")
            print("Vous avez vaincu la Fée Corrompue et terminé le jeu!")
            print("Le royaume est sauvé grâce à votre bravoure!")
            break
        } else if resultat == -1 {
            // Défaite
            print("\nVous avez été vaincu...")
            print("Fin du jeu.")
            break
        } else if let nouvelleSalle = resultat {
            // Continuer l'exploration à la nouvelle salle
            idSalleActuelle = nouvelleSalle
        }
    }
}

// Lancement du jeu
jouer()
