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
change_M(STATE, SOLUTION) :-
	[h1],
	bestfirst(STATE, STATES),
	get_changes(STATES, [], SOLUTION).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Heuristic 2:

change_H(STATE, SOLUTION) :-
	[h2],
	bestfirst(STATE, STATES),
	get_changes(STATES, [], SOLUTION).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Example:
example1([25,10,1,10,1,5,5,10,1,10,0,1]).
example2([1,1,5,1,10,10,1,10,5,10,25,0]).
example3([1,10,10,25,10,1,0,1,5,10,5,1]).
example4([10,10,1,0,1,25,5,10,5,1,10,1]).
example5([1,10,5,25,0,10,10,1,1,5,10,1]).
example6([5,0,5,10,10,25,1,10,1,1,1,10]).
example7([0,1,5,10,10,1,10,5,1,10,1,25]).

% Example query: example(POS), change_N(POS,SOL), afficher(POS, SOL, m).

