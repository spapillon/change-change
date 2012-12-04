% Utils :
valid_state([A,B,C,D,_,_,_,_,E,F,G,H]) :-
	A = E,
	B = F,
	C = G,
	D = H.

valid_move(N,N1) :-
	(N1 is N+4, N < 9);
	(N1 is N-4, N > 4);
	(N1 is N+1, \+ N = 4, \+ N = 8, N < 12);
	(N1 is N-1, \+ N = 5, \+ N = 9, N > 1).

reverse(L, R) :-
	reverse(L, [], R).

reverse([], R, R).
reverse([H|T], S, Rd) :-
	reverse(T, [H|S], R).
% Iterate through list where if the current head is < E.
insert([N,C], [[H,CC]|TAIL], [[H,CC]|NEWTAIL]):-
        C > CC,
        insert([N,C], TAIL, NEWTAIL).
% Position is adequate, insert element
insert([N,C], [[H,CC]|TAIL], [[N,C],[H,CC]|TAIL]):-
        C =< CC.
% Basal case where an element is inserted in an empty list
insert([N,C], [], [[N,C]]).

% Uninformed search :
change_N(STATE, SOLUTION, ACCUMULATOR, FRINGE) :-
	valid_state(STATE),
	reverse(ACCUMULATOR, SOLUTION).

change_N(STATE, SOLUTION, ACCUMULATOR, FRINGE) :-
        place_vide(STATE, N),
        valid_move(N, N1),
	echanger(STATE, N, N1, NEWSTATE),
	\+member(NEWSTATE, FRINGE),
        change_N(NEWSTATE, SOLUTION, [N1|ACCUMULATOR], [STATE|FRINGE]).

change_N(STATE, SOLUTION):-
	change_N(STATE, SOLUTION, [], STATE).

% Heuristic 1 :
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

change_M(STATE, SOLUTION, ACCUMULATOR, FRINGE) :-
	valid_state(STATE),
	reverse(ACCUMULATOR, SOLUTION).
	
change_M(STATE, SOLUTION, ACCUMULATOR, FRINGE) :-
	place_vide(STATE, N),
	valid_moves(N, LIST),
	evaluate_moves(LIST, STATE, MOVES),
	insert(MOVES, FRINGE, [HEAD|NEWFRINGE]),
	echanger(STATE, N, V1, C1).

change_M(STATE, SOLUTION) :-
	change_M(STATE, SOLUTION, ACCUMULATOR, []).
	
valid_moves(N, L):-
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
	

	

% Test cases : 
change_N([1,10,0,10,25,1,5,1,1,10,5,10],S) ,  afficher([1,10,0,10,25,1,5,1,1,10,5,10], S, m).
change_N([0,1,5,10,10,1,10,5,1,10,1,25], S).
change_N([1,1,5,1,10,10,1,10,5,10,25,0], S) , afficher([1,1,5,1,10,10,1,10,5,10,25,0], S, m).

change_M(D,S).
change_H(D,S). 
