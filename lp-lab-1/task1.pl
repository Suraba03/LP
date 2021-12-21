%
% Insert an element at the specified position in list via standart predicate
%


append([], List2, List2).
append([Head|Tail], List2, [Head|Result]):-
   append(Tail, List2, Result).


addtolist(Item, 1, [Head|Tail], Result) :-
	append([Item], [Head], New),
	append(New, Tail, Result).
	
addtolist(Item, K, [Head|Tail], Result) :-
	K > 1,
	K1 is K - 1, 
    addtolist(Item, K1, Tail, List),
    append([Head], List, Result).


%
% Insert an item into the list at the specified position via my predicate
%


insert_mine(Item, 1, [Head|Tail], Result) :-
	Tail \= [],
	Result = [Item, Head|Tail].
	
insert_mine(Item, 1, [], Result) :-
	Result = [Item].

insert_mine(Item, K, [Head|Tail], Result) :-
	K > 1,
	K1 is K - 1,
	insert_mine(Item, K1, Tail, List),
	Result = [Head|List].


%
% Check the list for arithmetic progression via a standard predicate
% 
makePr([X], X, _, _).
makePr([Head|Tail], Head, K, N) :-
	N > 1,
	G is N - 1,
	X is Head + K,
	makePr(Tail, X, K, G).

sublist([], _).
sublist([X|Tail1],[X|Tail2] ) :- sublist(Tail1, Tail2).

check(L) :- L = [_].
check(L) :- L = [_, _].
check([Head1, Head2|Tail]) :-
	X is Head2 - Head1,
	length([Head1, Head2|Tail], K),
	makePr(PrList, Head1, X, K), 
    length(PrList, K),
    sublist([Head1, Head2|Tail], PrList).


%
% Check the list for arithmetic progression via my predicate
%


checkPr_mine([H1, H2|Tail], M) :-
	N is H2 - H1,
	M = N,
	Tail \= [],
	checkPr_mine([H2|Tail], M). 
checkPr_mine([H1, H2|Tail], M) :-
	N is H2 - H1,
	M = N,
	Tail = [].

check_mine(L) :-
	L = [_].
check_mine(L) :-
	L = [_, _].
check_mine([H1, H2|Tail]) :-
	M is H2 - H1,
	checkPr_mine([H2|Tail], M).
