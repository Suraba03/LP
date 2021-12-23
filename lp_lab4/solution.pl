:- encoding(utf8).
:- op(200, xfy, ':').

object(['шоколад', 'деньги', 'кровать', 'стена', 'книга', 'алгоритм']).
agent(['Даша', 'Маша', 'Саша', 'Паша']).

verb(Data) :- Data = 
    ['любить' : ['любит', 'любят'],
     'лежать' : ['лежат', 'лежит'],
     'программировать' : ['программирует', 'программируют'],
     'стать' : ['спал', 'стали'],
     'сдать' : ['сдал', 'сдали']].

question_mark(X) :-
    member(X, ['?']).

cond(Verb, Inf, Inf : Y) :-
    member(Verb, Y).

search_verb(Verb, Inf) :-
    verb(Data),
    member(Mem, Data),
    cond(Verb, Inf, Mem).

% пример : Что любит Даша?
% неизвестен объект
ask(['Что', Verb, Noun, E], X) :- 
    question_mark(E),
    search_verb(Verb, Inf),
    agent(List),
    member(Noun, List),
    X=..[Inf, agent(Noun), object(y)].

% пример : Где лежит книга? --
% неизвестна локация
ask(['Где', Verb, Noun, E], X) :- 
    question_mark(E),
    search_verb(Verb, Inf),
    agent(List),
    member(Noun, List),
    write(41), nl,
    X=..[Inf, agent(Noun), loc(x)].

% пример : Кто программирует алгоритм? --
% неизвестен тот, кто совершает действие 
ask(['Кто', Verb, Noun, E], X) :- 
    question_mark(E),
    search_verb(Verb, Inf),
    X=..[Inf, agent(y), object(Noun)].
