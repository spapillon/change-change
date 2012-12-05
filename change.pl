% Validation:

goal([A,B,C,D,_,_,_,_,E,F,G,H]) :-
	A = E,
	B = F,
	C = G,
	D = H.

valid_move(N,N1) :-
	(N1 is N+4, N < 9);
	(N1 is N-4, N > 4);
	(N1 is N+1, \+ N = 4, \+ N = 8, N < 12);
	(N1 is N-1, \+ N = 5, \+ N = 9, N > 1).

valid_moves(N, L) :-
	test1(N, L1),
	test2(N, L1, L2),
	test3(N, L2, L3),
	test4(N, L3, L), !.

test1(N, L) :-
	(N < 9,
	N1 is N+4,
	append([N1], [], L));
	append([], [], L).
test2(N, L, L1) :-
	(N > 4, 
	N1 is N-4,
	append([N1], L, L1));
	append([], L, L1).
test3(N, L, L1) :-
	(\+ N = 4,
	\+ N = 8,
	N < 12,
	N1 is N+1,
	append([N1], L, L1));
	append([], L, L1).
test4(N, L, L1) :-
	(\+ N = 5,
	\+ N = 9,
	N > 1,
	N1 is N-1,
	append([N1], L, L1));
        append([], L, L1).


misplaced_peices([A,B,C,D,_,_,_,_,E,F,G,H], N) :-
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Uninformed search :

change_N(STATE, SOLUTION, ACCUMULATOR, _) :-
	goal(STATE),
	reverse(ACCUMULATOR, SOLUTION).

change_N(STATE, SOLUTION, ACCUMULATOR, VISITED) :-
        place_vide(STATE, N),
        valid_move(N, N1),
	echanger(STATE, N, N1, NEWSTATE),
	\+member(NEWSTATE, VISITED),
        change_N(NEWSTATE, SOLUTION, [N1|ACCUMULATOR], [STATE|VISITED]).

change_N(STATE, SOLUTION) :-
	change_N(STATE, SOLUTION, [], STATE).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A* Body :

s(STATE, OPEN, 1) :-
	place_vide(STATE, EMPTY),	
	valid_move(EMPTY, MOVE),
	echanger(STATE, EMPTY, MOVE, OPEN).

get_changes([HEAD], CHANGES, CHANGES).
get_changes([HEAD|STATES],  ACC, CHANGES) :-
	place_vide(HEAD, N),
	get_changes(STATES, [N|ACC], CHANGES).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Heuristic 1:

h([A,B,C,D,_,_,_,_,E,F,G,H], N) :-
	difference(A, E, N1),
	difference(B, F, N1, N2),
	difference(C, G, N2, N3),
	difference(D, H, N3, N), !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Heuristic 2:

h([A,B,C,D,_,_,_,_,E,F,G,H], N) :-
	difference(A, E, N1),
	difference(B, F, N1, N2),
	difference(C, G, N2, N3),
	difference(D, H, N3, N), !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Example:
example([25,10,1,10,1,5,5,10,1,10,0,1]).
% Example query: example(POS), bestfirst(POS,SOL), get_changes(SOL, [],CHANGES), afficher(POS, CHANGES, m).

