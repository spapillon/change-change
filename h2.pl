h(STATE, N) :-
	place_25(STATE, P25),
	is_on_symmetric_row(P25),
	place_vide(STATE, P0),
	manhattan_distance(P25, P0, N).

is_on_symmetric_row(N) :-
	(N-1) // 4 =:= 0;
	(N-1) // 4 =:= 2, !.

manhattan_distance(A, B, D) :-
	Ax is A mod 4,
	Bx is B mod 4,
	Ay is (A-1) // 4,
	By is (B-1) // 4,
	abs_diff(Ax, Bx, Dx),
	abs_diff(Ay, By, Dy),
	D is Dx + Dy, !.

abs_diff(X, Y, D) :-
	((X > Y,
	D is X - Y);
	D is Y - X), !.
	

place_25([25|_],1).
place_25([A|B],N) :-
	place_25(B,N1), N is N1+1.
