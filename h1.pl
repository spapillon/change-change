% Heuristic 1 : Raw number of differences
h([A,B,C,D,_,_,_,_,E,F,G,H], N) :-
	difference(A, E, N1),
	difference(B, F, N1, N2),
	difference(C, G, N2, N3),
	difference(D, H, N3, N), !.

difference(A, B, C, C1) :-
	(A = B, C1 is C);
	C1 is C+1.
	difference(A, B, C) :-
	(A = B, C is 0);
	C is 1.
