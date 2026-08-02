function y = quantalph(x, alphabet)
% 1. Forcer en vecteurs colonnes
alphabet = alphabet(:);
x = x(:);

% 2. Calculer les distances au carré (Expansion implicite)
% x est un vecteur colonne (N x 1) et alphabet' est un vecteur ligne (1 x M)
% MATLAB crée automatiquement la matrice (N x M) en arrière-plan
dist = (x - alphabet').^2;

% 3. Trouver l'indice du symbole le plus proche
[~, i] = min(dist, [], 2);

% 4. Assigner la valeur finale
y = alphabet(i); 
end