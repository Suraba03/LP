% Task 2: Relational Data

:- encoding(utf8).
:- consult('one.pl').

%
% Task: Get a table of groups and the average score for each of the groups
%

write_groups_members() :-
	group_list(GrList),
	write_members(GrList).
write_groups_members() :-
	group_list(GrList),
	write_average_mark(GrList).

%
% List of groups
%

group(N) :-
	student(N, _).

group_list(L) :-
	setof(Gr, group(Gr), L).

%
% Students in the group
%

write_members([Gr|T]) :-
	write(Gr), nl, 
    setof(Stud, student(Gr, Stud), L), 
    write(L), nl, nl, 
    write_members(T), fail.

%
% Average score for the group
%

write_average_mark([Gr|T]) :-
	aver_mark(Gr, Res),
	write("Среднее значение для "), 
	write(Gr), write(" группы: "),
	write(Res), nl, 
    write_average_mark(T), fail.

aver_mark(Gr, Res) :-
	findall(Mark, (student(Gr, Stud), grade(Stud, _, Mark)), L), 
    length(L, Len),
    sum_list(L, S),
    Res is (S / Len).

%
% Task: For each subject, get a list of students who failed the exam (grade=2)
%

write_bad_marks() :-
	subject(N, M),
	write(M), nl, 
    bagof(Y, grade(Y, N, 2), L), 
    write(L), nl, nl, fail.

%
% Task: Find the number of failed students in each of the groups
%

dont_pass() :-
	group_list(Gr),
	write_dont_pass(Gr).

has_bad_mark(Stud, Gr) :-
	student(Gr, Stud),
	grade(Stud, _, 2).

write_dont_pass([H|T]) :-
	setof(Stud, has_bad_mark(Stud, H), L),
	length(L, Len),
    write("Количество несдавших в группе "),
    write(H), write(": "), write(Len), nl, 
    write_dont_pass(T), fail.
