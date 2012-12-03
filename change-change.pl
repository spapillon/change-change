% Utils :
valid_solution([A,B,C,D,_,_,_,_,E,F,G,H]) :-
	A = E,
	B = F,
	C = G,
	D = H.

valid_move(N,N1) :-
	(N1 is N+4, N < 9);
	(N1 is N-4, N > 4);
	(N1 is N+1, \+ N = 4, \+ N = 8);
	(N1 is N-1, \+ N = 5, \+ N = 9).

reverse(L, R) :-
	reverse(L, [], R).

reverse([], R, R).
reverse([H|T], S, Rd) :-
	reverse(T, [H|S], R).


% Uninformed search :
change_N(C, S, ACC, F) :-
	valid_solution(C),
	reverse(ACC,S).

change_N(C, S, ACC, F) :-
        place_vide(C, N),
        valid_move(N,N1),
	echanger(C, N, N1, C1),
	\+member(C1, F),
        change_N(C1, S, [N1|ACC], [C|F]).

change_N(C, S):-
	change_N(C, S, [], C).

% Heuristic 1 :
misplaced_peices([A,B,C,D,_,_,_,_,E,F,G,H], N) :-
	difference(A, E, N1),
	difference(B, F, N1, N2),
	difference(C, G, N2, N3),
	difference(D, H, N3, N).

difference(A, B, C, C1) :-
	(A = B, C1 is C);
	C1 is C+1.
difference(A, B, C) :-
	(A = B, C is 0);
	C is 1.

change_M(D, S) :-
	

% Test cases : 
change_N([1,10,0,10,25,1,5,1,1,10,5,10],S) ,  afficher([1,10,0,10,25,1,5,1,1,10,5,10], S, m).
change_N([0,1,5,10,10,1,10,5,1,10,1,25], S).
change_N([1,1,5,1,10,10,1,10,5,10,25,0], S) , afficher([1,1,5,1,10,10,1,10,5,10,25,0], S, m).

change_M(D,S).
change_H(D,S). 
