child('William Shakespeare', 'John Shakespeare').
child('William Shakespeare', 'Mary Arden').
child('Mary Arden', 'Robert Arden').
child('Mary Arden', 'Agnes Webbe').
child('John Shakespeare', 'Richard Shakespeare').
child('John Shakespeare', ' Unknown').
child('Anne Hathaway', 'Richard Hathaway').
child('Susanna Shakespeare', 'William Shakespeare').
child('Susanna Shakespeare', 'Anne Hathaway').
child('Hamnet Shakespeare', 'William Shakespeare').
child('Hamnet Shakespeare', 'Anne Hathaway').
child('Judith Shakespeare', 'William Shakespeare').
child('Judith Shakespeare', 'Anne Hathaway').
child('Joan Shakespeare', 'John Shakespeare').
child('Joan Shakespeare', 'Mary Arden').
child('Margaret Shakespeare', 'John Shakespeare').
child('Margaret Shakespeare', 'Mary Arden').
child('Gilbert Shakespeare', 'John Shakespeare').
child('Gilbert Shakespeare', 'Mary Arden').
child('Anne Shakespeare', 'John Shakespeare').
child('Anne Shakespeare', 'Mary Arden').
child('Richard Shakespeare', 'John Shakespeare').
child('Richard Shakespeare', 'Mary Arden').
child('Edmund Shakespeare', 'John Shakespeare').
child('Edmund Shakespeare', 'Mary Arden').
child('Henry Shakespeare', 'Richard Shakespeare').
child('Henry Shakespeare', ' Unknown').
child('Elizabeth Shakespeare', 'John Hall').
child('Elizabeth Shakespeare', 'Susanna Shakespeare').
child('Shakespeare Quiney', 'Thomas Quiney').
child('Shakespeare Quiney', 'Judith Shakespeare').
child('Richard Quiney', 'Thomas Quiney').
child('Richard Quiney', 'Judith Shakespeare').
child('Thomas Quiney', 'Thomas Quiney').
child('Thomas Quiney', 'Judith Shakespeare').
child('Not named Quiney', 'Thomas Quiney').
child('Not named Quiney', 'Margaret Wheeler').
male('William Shakespeare').
male('John Shakespeare').
male('Hamnet Shakespeare').
male('Gilbert Shakespeare').
male('Richard Shakespeare').
male('Edmund Shakespeare').
male('Richard Shakespeare').
male('Henry Shakespeare').
male('Robert Arden').
male('John Hall').
male('Thomas Nash').
male('John Barnard').
male('Thomas Quiney').
male('Shakespeare Quiney').
male('Richard Quiney').
male('Thomas Quiney').
male('Richard Hathaway').
female('Mary Arden').
female('Anne Hathaway').
female('Susanna Shakespeare').
female('Judith Shakespeare').
female('Joan Shakespeare').
female('Margaret Shakespeare').
female('Joan Shakespeare').
female('Anne Shakespeare').
female('Margaret').
female('Agnes Webbe').
female('Elizabeth Shakespeare').
female('Margaret Wheeler').
female(' Unknown').

% 3 ------------------------------------------------

sibling(Self, Sibling) :-
    child(Self, ParentSelf),
    child(Sibling, ParentSelf),
    male(ParentSelf),
    Self \= Sibling.

firstCousin(Self, Cousin) :-
    child(Self, ParentSelf),
    sibling(ParentSelf, ParentCousin),
    child(Cousin, ParentCousin).

secondCousin(Self, SecondCousin) :-
    child(Self, ParentSelf),
    firstCousin(ParentSelf, ParentSecondCousin),
    child(SecondCousin, ParentSecondCousin).

% 4 ------------------------------------------------

% SIMPLE pattern to search

pattern('sibling', X, Y) :-
    sibling(X, Y).
pattern('first cousin', X, Y) :-
    firstCousin(X, Y).
pattern('second cousin', X, Y) :-
    secondCousin(X, Y).
pattern('brother', X, Y) :-
    sibling(X, Y),
    male(Y).
pattern('sister', X, Y) :-
    sibling(X, Y),
    female(Y).
pattern('mother', X, Y) :-
    child(X, Y),
    female(Y).
pattern('father', X, Y) :-
    child(X, Y),
    male(Y).
pattern('daughter', X, Y) :-
    child(Y, X),
    female(Y).
pattern('son', X, Y) :-
    child(Y, X),
    male(Y).

% MOVE to the next node of the genealogic tree

move(X, Y) :- child(X, Y).
move(X, Y) :- child(Y, X).
move(X, Y) :- sibling(X, Y).
move(X, Y) :- sibling(Y, X).

% DF search 

dfs(Relation, X, Y) :-
    pattern(Relation, X, Y), !.
dfs(Relation, X, Y) :-
    move(X, Y),
    dfs(Relation, X, Y).

% DF search for all relatives and relations

dfs_all(Relation, X, Y) :-
    pattern(Relation, X, Y).
dfs_all(Relation, X, Y) :-
    move(X, Y),
    dfs_all(Relation, X, Y).

% DF ID search

inf_integers(1).
inf_integers(N) :-
    inf_integers(N1),
    N is N1 + 1.

dfs_bounded(Relation, X, Y, _) :-
    pattern(Relation, X, Y).
dfs_bounded(Relation, X, Y, N) :-
    N > 0,
    move(X, Y),
    N1 is N - 1,
    dfs_bounded(Relation, X, Y, N1).

dfs_id(Relation, X, Y) :-
    inf_integers(N),
    dfs_bounded(Relation, X, Y, N), !.

% DF ID search for all relatives and relations

dfs_id_all(Relation, X, Y) :-
    inf_integers(N),
    dfs_bounded(Relation, X, Y, N).

% pretty OUTPUT

find_a_relation(X, Y) :-
    dfs(Relation, X, Y),
    write(Y), write(" is "), write(X),
    write("`s "), write(Relation), write("."), nl.

find_all_relations(X, Y) :-
    dfs_all(Relation, X, Y),
    write(Y), write(" is "), write(X),
    write("`s "), write(Relation), write("."), nl.

find_a_relative(Relation, X) :-
    dfs(Relation, X, Y), 
    write(Relation), write(" of "), write(X),
    write(" is "), write(Y), write("."), nl.

find_all_relatives(Relation, X) :-
    dfs_all(Relation, X, Y), 
    write(Relation), write(" of "), write(X),
    write(" is "), write(Y), write("."), nl.
    

% 5 -------------------------------------------------

% Its still empty here...
