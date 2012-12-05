h2(STATE, N) :-
	place_25(STATE, P25),
	place_vide(STATE, P0),
	((is_on_symmetric_row(P25),
	manhattan_distance(P25, P0, D1));
	D1 is 0),
	differences(STATE, L),
	difference_distance(L, P0, [], DISTANCES),
	max(DISTANCES, D2),
	((is_on_symmetric_row(P0), 
	D3 is D2);
	D3 is D2 + 1),
	max([D1,D3], N), !.

difference_distance([], _, ACC, ACC).
difference_distance([X|TAIL], EMPTY, ACC, OUT) :-
	abs_diff(EMPTY mod 4, X, Dx),
	difference_distance(TAIL, EMPTY, [Dx|ACC], OUT).
	

differences([A,B,C,D,_,_,_,_,E,F,G,H], L) :-
	equals(A, E, 1, [], L1),
	equals(B, F, 2, L1, L2),
	equals(C, G, 3, L2, L3),
	equals(D, H, 4, L3, L).

max([], 0).
max([X], X).
max([X|Xs], X):-
	max(Xs, Y),	
	X >=Y.
max([X|Xs], N):-
	max(Xs, N),
	N > X.

equals(X, X, POS, IN, IN) :- !.
equals(X, Y, POS, IN, [POS|IN]).


is_on_symmetric_row(N) :-
	(N-1) // 4 =:= 0;
	(N-1) // 4 =:= 2, !.

manhattan_distance(A, B, D) :-
	getX(A, Ax),
	getX(B, Bx),
	getY(A, Ay),
	getY(B, By),
	abs_diff(Ax, Bx, Dx),
	abs_diff(Ay, By, Dy),
	D is Dx + Dy, !.

getX(A, X) :-
	Axtemp is A mod 4,
	((Axtemp = 0,
	X is Axtemp+4);
	X is Axtemp), !.

getY(A, Y) :-
	Y is (A-1) // 4.

abs_diff(X, Y, D) :-
	((X > Y,
	D is X - Y);
	D is Y - X), !.
	

place_25([25|_],1).
place_25([A|B],N) :-
	place_25(B,N1), N is N1+1.

