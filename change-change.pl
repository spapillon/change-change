% Validation:
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ordering:

insertion_sort(IN, OUT):-
        insertion_sort(IN, [], OUT).

insertion_sort([], ACC, ACC).

insertion_sort([HEAD|TAIL], ACC, OUT):-
        insert(HEAD, ACC, NEWACC),
        insertion_sort(TAIL, NEWACC, OUT).

insert([STATE, EMPTY, MOVE, VALUE],
	[[HSTATE, HEMPTY, HMOVE, HVALUE]|TAIL],
	[[HSTATE, HEMPTY, HMOVE, HVALUE]|NEWTAIL]):-
        VALUE > HVALUE,
        insert([STATE, EMPTY, MOVE, VALUE], TAIL, NEWTAIL).

insert([STATE, EMPTY, MOVE, VALUE],
	[[HSTATE, HEMPTY, HMOVE, HVALUE]|TAIL],
	[[STATE, EMPTY, MOVE, VALUE],[HSTATE, HEMPTY, HMOVE, HVALUE]|TAIL]):-
        VALUE =< HVALUE.

insert([STATE, EMPTY, MOVE, VALUE], [], [[STATE, EMPTY, MOVE, VALUE]]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Uninformed search :

change_N(STATE, SOLUTION, ACCUMULATOR, _) :-
	valid_state(STATE),
	reverse(ACCUMULATOR, SOLUTION).

change_N(STATE, SOLUTION, ACCUMULATOR, VISITED) :-
        place_vide(STATE, N),
        valid_move(N, N1),
	echanger(STATE, N, N1, NEWSTATE),
	\+member(NEWSTATE, VISITED),
        change_N(NEWSTATE, SOLUTION, [N1|ACCUMULATOR], [STATE|VISITED]).

change_N(STATE, SOLUTION):-
	change_N(STATE, SOLUTION, [], STATE).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Heuristic 1 :
change_M(STATE, SOLUTION, ACCUMULATOR, _, _, _) :-
	valid_state(STATE),
	reverse(ACCUMULATOR, SOLUTION).
	
change_M(STATE, SOLUTION, ACCUMULATOR, FRINGE, VISITED, DEPTH) :-
	place_vide(STATE, N),
	valid_moves(N, LIST),
	evaluate_moves(LIST, N, STATE, [], MOVES, DEPTH),
	insertion_sort(MOVES, FRINGE, SORTEDFRINGE),
	next_available_move(SORTEDFRINGE, VISITED, [NEWSTATE, EMPTY, NEXTMOVE], NEWFRINGE),
	write(' VISITED: '), write(VISITED), nl,
	write(' FRINGE: '), write(SORTEDFRINGE), nl,
	write(' NEXT: '), write(NEWSTATE) , write(' '), write(NEXTMOVE), nl,
	write('\t'), write(NEWFRINGE), nl, nl,
	echanger(NEWSTATE, EMPTY, NEXTMOVE, NEXTSTATE),
	change_M(NEXTSTATE, SOLUTION, [NEXTMOVE|ACCUMULATOR], NEWFRINGE, [NEXTSTATE|VISITED], DEPTH+1).
	

change_M(STATE, SOLUTION) :-
	change_M(STATE, SOLUTION, [], [], STATE, 0).

next_available_move([[STATE, EMPTY, MOVE, _]|FRINGE], VISITED, NEXTMOVE, NEWFRINGE) :-
	echanger(STATE, EMPTY, MOVE, NEWSTATE),
	member(NEWSTATE, VISITED),
	next_available_move(FRINGE, VISITED, NEXTMOVE, NEWFRINGE).

next_available_move([[STATE, EMPTY, MOVE, _]|FRINGE], _, [STATE, EMPTY, MOVE], FRINGE).


evaluate_moves([], _, _, ACCUMULATOR, ACCUMULATOR, _).

evaluate_moves([HEAD|LIST], EMPTY, STATE, ACCUMULATOR, MOVES, DEPTH) :-
	echanger(STATE, EMPTY, HEAD, NEWSTATE),
	misplaced_peices(NEWSTATE, VALUE),
	VALUE1 is VALUE+DEPTH,
	evaluate_moves(LIST, EMPTY, STATE, [[STATE, EMPTY, HEAD, VALUE1]|ACCUMULATOR], MOVES, DEPTH).

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

	

