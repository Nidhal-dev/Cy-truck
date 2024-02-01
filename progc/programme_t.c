typedef struct AVL{
    int route_ID;
    float min;
    float max;
    float moy;
    float diff;
    int eq;
    struct AVL* pLeft;
    struct AVL* pRight;
}spTree*;


// issu du cours
spTree insertAVL(spTree avl, int* h, pTree abr){
    spTree new = createNodeAVL(abr);

    if(avl ==  NULL){
        *h = 1;
        return new;
    }
    else if(new->diff < avl->diff){
        avl->pLeft = insertAVL(avl->pLeft, h, abr);
        *h = -(*h);
    }
    else if(new->diff > avl->diff){
        avl->pRight = insertAVL(avl->pRight, h, abr);
    }
    else{
        *h = 0;
        return avl;
    }

    if(*h != 0){
        avl->eq = avl->eq + *h;
        avl = equilibrageAVL(avl);
        if(avl->eq == 0){
            *h = 0;
        }
        else{
            *h = 1;
        }

    }
    return avl;
}

// issu du cours
spTree rightRotation(spTree avl){
    if(avl == NULL){
        printf("L'arbre est null\n");
        exit(5);
    }
    spTree pivot;
    int eq_a, eq_p;

    pivot = avl->pLeft;
    avl->pLeft = pivot->pRight;
    pivot->pRight = avl;
    
    eq_a = avl->eq;
    eq_p = pivot->eq;
    avl->eq = eq_a - min2(eq_p, 0) + 1;
    pivot->eq = max3(eq_a + 2, eq_a + eq_p + 2, eq_p + 1);

    avl = pivot;

    return avl;
}

// issu du cours
spTree doubleLeftRotation(spTree avl){
    if(avl == NULL){
        printf("L'arbre est null\n");
        exit(6);
    }
    avl->pRight = rightRotation(avl->pRight);
    return leftRotation(avl);
}
// issu du cours
spTree doubleRightRotation(spTree avl){
        if(avl == NULL){
        printf("L'arbre est null\n");
        exit(7);
    }
    avl->pLeft = leftRotation(avl->pLeft);
    return rightRotation(avl);
}
// issu du cours
spTree equilibrageAVL(spTree avl){
        if(avl == NULL){
        printf("L'arbre est null\n");
        exit(8);
    }
    if(avl->eq > 1){
        if(avl->pRight->eq >= 0){
            return leftRotation(avl);
        }
        else{
            return doubleLeftRotation(avl);
        }
    }
    else if(avl->eq < -1){
        if(avl->pLeft->eq <= 0){
            return rightRotation(avl);
        }
        else{
            return doubleRightRotation(avl);
        }
    }
    return avl;
}



