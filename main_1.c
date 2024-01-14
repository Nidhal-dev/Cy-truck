#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <stdbool.h>
#include <string.h>

typedef struct noeud{
    long routeID; 
    int stepID;
    char townA[50];
    char townB[50];
    float distance;
    char name[30];
    int hauteur;
    struct noeud* fg;
    struct noeud* fd;
    struct noeud* suivant;
}noeud;                                   // structure des données pour l'AVL : fg et fd pour les arbres, suivant pour une possible pile ou file(parcours de l'arbre)


typedef struct VilleTrajets {
    char nom[50];
    int nbTrajets;
    struct VilleTrajets *fg;
    struct VilleTrajets *fd;
    int hauteur;
} VilleTrajets;            // structure uniquement pour classer les villes les plus citées

int max(int a, int b) {
    return (a > b) ? a : b;
}

int hauteur(VilleTrajets *N) {
    if (N == NULL)
        return 0;
    return N->hauteur;
}

VilleTrajets* nouveauNoeud(const char *nomVille, int nbTrajets) {
    VilleTrajets* node = (VilleTrajets*)malloc(sizeof(VilleTrajets));
    if (node == NULL) {
        fprintf(stderr, "Erreur d'allocation mémoire pour le nouveau nœud.\n");
        return NULL;
    }

    // Allocation réussie, initialisation des valeurs
    strcpy(node->nom, nomVille);
    node->nbTrajets = nbTrajets;
    node->fg = NULL;
    node->fd = NULL;
    node->hauteur = 1;

    return node;
}

VilleTrajets *rotationDroite(VilleTrajets *y) {
    VilleTrajets *x = y->fg;
    VilleTrajets *T2 = x->fd;

    x->fd = y;
    y->fg = T2;

    y->hauteur = max(hauteur(y->fg), hauteur(y->fd)) + 1;
    x->hauteur = max(hauteur(x->fg), hauteur(x->fd)) + 1;

    return x;
}

VilleTrajets *rotationGauche(VilleTrajets *x) {
    VilleTrajets *y = x->fd;
    VilleTrajets *T2 = y->fg;

    y->fg = x;
    x->fd = T2;

    x->hauteur = max(hauteur(x->fg), hauteur(x->fd)) + 1;
    y->hauteur = max(hauteur(y->fg), hauteur(y->fd)) + 1;

    return y;
}

int facteurEquilibre(VilleTrajets *N) {
    if (N == NULL)
        return 0;
    return hauteur(N->fg) - hauteur(N->fd);
}



void afficherVilles(VilleTrajets *racine) {
    if (racine != NULL) {
        afficherVilles(racine->fg);
        printf("Ville : %s, Nombre de trajets : %d\n", racine->nom, racine->nbTrajets);
        afficherVilles(racine->fd);
    }
}

// Structure pour stocker une ligne de données CSV
typedef struct Trajet {
    char villeA[50];
    char villeB[50];
} Trajet;

// Insérer une ville dans l'AVL
VilleTrajets* insererAVL(VilleTrajets* racine, const char *nomVille) {
    if (racine == NULL) {
        return nouveauNoeud(nomVille, 1); // Nouveau nœud avec 1 trajet pour cette ville
    }

    int comparaison = strcmp(nomVille, racine->nom);
    if (comparaison < 0) {
        racine->fg = insererAVL(racine->fg, nomVille);
    } else if (comparaison > 0) {
        racine->fd = insererAVL(racine->fd, nomVille);
    } else {
        // La ville est déjà présente, incrémenter le nombre de trajets pour cette ville
        racine->nbTrajets++;
        return racine;
    }

    racine->hauteur = 1 + max(hauteur(racine->fg), hauteur(racine->fd));

    int equilibre = facteurEquilibre(racine);

    if (equilibre > 1 && strcmp(nomVille, racine->fg->nom) < 0)
        return rotationDroite(racine);

    if (equilibre < -1 && strcmp(nomVille, racine->fd->nom) > 0)
        return rotationGauche(racine);

    if (equilibre > 1 && strcmp(nomVille, racine->fg->nom) > 0) {
        racine->fg = rotationGauche(racine->fg);
        return rotationDroite(racine);
    }

    if (equilibre < -1 && strcmp(nomVille, racine->fd->nom) < 0) {
        racine->fd = rotationDroite(racine->fd);
        return rotationGauche(racine);
    }

    return racine;
}


void extraireVillesDepuisCSV(const char *nomFichier, VilleTrajets **racineAVL) {
    FILE *fichier = fopen(nomFichier, "r");
    if (fichier == NULL) {
        printf("Erreur lors de l'ouverture du fichier.\n");
        return;
    }

    char ligne[400];
    while (fgets(ligne, sizeof(ligne), fichier)) {
                                                                         // Analyse des données CSV pour extraire les villes
        char villeA[50], villeB[50];
                                                                         // Exemple d'utilisation de sscanf pour extraire les villes de la ligne CSV
        sscanf(ligne, "%49[^,],%49[^,]", villeA, villeB);

                                                                        // Insérer les villes extraites dans l'AVL
        *racineAVL = insererAVL(*racineAVL, villeA);
        *racineAVL = insererAVL(*racineAVL, villeB);
    }

    fclose(fichier);
}



int main()
{
    clock_t debut, fin;
    double temps_ecoule;

    // Enregistrez le temps de début
    debut = clock();

    printf("Hello World\n");
    
    // Enregistrez le temps de fin
    fin = clock();

    // Calculez le temps écoulé en secondes
    temps_ecoule = ((double)(fin - debut)) / CLOCKS_PER_SEC;

    

    
    printf("Le temps d'execution est de : %f secondes\n", temps_ecoule);

    return 0;
}

