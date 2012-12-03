% afficher(C, L, M): affiche les configurations d'une partie de jeux
%   selon les mouvements (L) de la case vide, en commencant par la 
%   configuration C. Si M=m, alors muet, sinon etape par etape.

afficher(C,[],M) :- visualiser(C), 
     write('-----------------------'), nl, !.
afficher(C,[A|B],M) :- visualiser(C), 
     write('-----------------------'), nl, !, 
     modif(C,A,C1),
     (M=m -> true; (see(user),get(_))),
     afficher(C1,B,M).

%visualiser(C): afficher une configuration C.
visualiser([]).
visualiser([A,B,C,D|Y]) :- vis1(A), vis1(B), vis1(C), vis1(D), nl, 
                           visualiser(Y).

vis1(X) :- write('   '), write(X), (X<10 -> write(' '); true).

% modif(C,V,C1): modifier la configuration C en C1 selon le mouvement de
% l'espace vide qui est represente par V.
modif(C,V,C1) :-
         place_vide(C,N), 
         adjacent(N,V), !, 
         echanger(C,N,V,C1).

% place_vide(C,N): l'espace vide se trouve a la place N, 1<=N<=12.
place_vide([0|_],1).
place_vide([A|B],N) :- place_vide(B,N1), N is N1+1.

%adjacent(N,N1): verifie si la place N et la place N1 sont adjacentes.
adjacent(N,N1) :- N1 =:= N+4; N1 =:= N-4;
       (N1 =:= N+1, N=\=4, N=\=8);
       (N1 =:= N-1, N=\=5, N=\=9).

adjacent(N,N1) :- write('Violation: On ne peut pas aller de '), write(N),
   write(' a '), write(N1), !, fail.

%echanger(C,N_vide,N,C1): echanger l'element de la place N_vide avec l'element
% de la place N, et le resultat est C1.
echanger(C,N_vide,N,C1) :- element(C,N,A),
   remplacer(C,N_vide,A,C2), remplacer(C2,N,0,C1).

%element(L,N,A): le n-ieme element de la liste L est A.
element([A|B],1,A).
element([A|B],N,C) :- N>1, N1 is N-1, element(B,N1,C).

%remplacer(L,N,A,L1): remplacer le n-ieme element de la liste L par A, et
% le resultat est L1.
remplacer([X|Y],1,A,[A|Y]).
remplacer([X|Y],N,A,[X|Z]) :- N>1, N1 is N-1, remplacer(Y,N1,A,Z).
