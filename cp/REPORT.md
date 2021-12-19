# Отчет по курсовому проекту
## по курсу "Логическое программирование"

### студент: Чекменев Вячеслав Алексеевич

## Результат проверки

Вариант задания:

 - [ ] стандартный, без NLP (на 3)
 - [x] стандартный, с NLP (на 3-4)
 - [ ] продвинутый (на 3-5)
 
| Преподаватель     | Дата         |  Оценка       |
|-------------------|--------------|---------------|
| Сошников Д.В. |              |               |
| Левинская М.А.|              |               |

> *Комментарии проверяющих (обратите внимание, что более подробные комментарии возможны непосредственно в репозитории по тексту программы)*




## Введение

Данный курсовой проект является большой работой, охватывающей весь курс логического программирования на языке пролог в МАИ. Я выбрал стандартное задание, так как понимаю, что не смогу выделить много времени на логическое програмирование, однако данные задание тоже не назовешь простым, если выполнять все пункты. Данное задание состоит из 5 пунктов:

1. Найти или создать gedcom file для использования его как данных для будущих программ и скриптов. Я выбрал взять дерево одной знатной европейской семьи, о ней будет в разделе "Получение родословного дерева". Это важная часть задания, так как она требует навыков поиска и проверки информации на валидность. К тому же, мне надо будет изучить, что из себя представляет формат текстового файла gedcom.

2. Написать парсер на удобном для меня языке программирования, об этом будет в разделе "Конвертация родословного дерева". С этой части начнутся трудности, так как единственным подходящим для этого языком, которым я владею хотя бы на уровне основ, является Python3. Мне нужно будет изучить библиотеку для парсинга gedcom файлов и некоторые основы ООП, так как библиотеки python написаны в виде модулей->классов. 

3. Написать на языке пролог предикат для second cousin, то есть для троюродного брата или сестры. Возможно, для этого потребуются другие предикаты по типу first cousin и sibling. Это не будет сложной задачей после выполнения первой лабораторной работы. 

4. Написать специализированный предикат, который позволит определять степень родства двух произвольных индивидуумов в дереве, это уже более сложная задача, в которой мне предстоит использовать знания из ЛР3.

5. Реализовать естественно-языковый интерфейс (ЕЯИ) к системе, позволяющий задавать вопросы относительно степеней родства, и получать осмысленные ответы. Данный пункт я считаю наиболее интересным с точки зрения получения новых знаний, так как раньше я очень мало занимался синтаксическим разбором. Хотя этот пункт является облегченной версией ЛР4.

После выполнения всех вышеперечисленных пунктов, я думаю, что научусь лучше понимать и проектировать программы в логической парадигме, а именно в системе языка пролог. Поэтому я считаю данную работу самой важной частью курса со стороны практики.

## Задание

1. Создать родословное дерево `европейской знати` в формате GEDCOM
2. Преобразовать файл в формате GEDCOM в набор утверждений на языке Prolog: с использованием предиката `child(ребенок, родитель)`, `male(человек)`, `female(человек)` 
3. Реализовать предикат проверки/поиска: `Троюродный брат или сестра`
4. Реализовать программу на языке Prolog, которая позволит определять `степень родства` двух произвольных индивидуумов в дереве.
5. Реализовать естественно-языковый интерфейс к системе, позволяющий задавать вопросы относительно степеней родства, и получать осмысленные ответы. Для отличной оценки требуется:
    + Учесть контекст (возможность использования it/him/her с отсылкой на упомянутый на прошлом шаге объект)
    + Выполнять запросы относительно количества (How many brothers does Mary have?)
    + Выполнить разбор предложения с построением смысловой модели.

## Получение родословного дерева

Я большой фанат поэм и сонет Шекспира, поэтому данный курсовой проект - отличная возможность узнать больше личной информации о писателе. 
Приведу здесь генеалогическое дерево рода шекспиров начиная с дедушки Уильяма Шекспира - Ричарда Шекспира. Всего 6 поколений.

![GenTree](https://github.com/MAILabs-Edu-2021/lp-capstone-Suraba03/blob/master/sh_fam.png)

## Конвертация родословного дерева

Для разбора GEDCOM файла я выбрал язык пайтом и библиотеку python-gedcom для парсина.

+ подключим библиотеки:
```py
# library for system functions
import sys 
# library with class for parser imlementation
from gedcom.parser import Parser
# import IndividualElement object from gedcom.element class 
from gedcom.element.individual import IndividualElement
```
+ напишем функцию которая последовательно запишет в выходной файл все сформированные предикаты:
```py
# function for writing to file parsed ged document
def writeToFile(fileName, children, males, females):
    # whereas open file
    with open(fileName, 'w') as fres:
        # write all child's causes to parsed file
        for child in children:
            fres.write(child + '\n')
        # write all male's causes to parsed file
        for male in males:
            fres.write(male + '\n')
        # write all female's causes to parsed file
        for female in females:
            fres.write(female + '\n')
```

+ напишем функцию для извлечения имени и фамилии человека из gedcom файла, которая после сформирует готовые имена в виде строк:
```py
# retrieve name of the person
def nameGet(pers):
    # assing name of pers object via get_name method
    (first, last) = pers.get_name()
    # if last == empty space => add \''\ symbols
    if (last != ""):
        return "\'" + first + " " + last + "\'"
    return "\'" + first + "\'"
```

+ напишем функцию для извлечения и формирования прелидактов `male`, `female` в виде строк

```py
# Adds gender cause 
def genAdd(pers, males, females):
    # assing gender of pers object via get_gender method
    gen = pers.get_gender()

    # there is two cases: Male and Female
    if (gen == "F"):    
        females.append("female(" + nameGet(pers) + ").")
    elif (gen == "M"):
        males.append("male(" + nameGet(pers) + ").")
```

+ основной цикл. Сначала добавляем `gender` (`male` or `female`), потом, если он (она) является чьим-то ребенком,то добавляем соответствующий предикат `child` 

```py
for p in rootChildElems:
    # if p is olbject of IndividualElement class 
    if isinstance(p, IndividualElement):
        # add gender cause
        genAdd(p, males, females)
        # if p is child   
        if (p.is_child()):
            # loop for all parents
            for par in gparser.get_parents(p, "ALL"):
                # add to back cause string 
                children.append("child(" + nameGet(p) + ", " + nameGet(par) + ").")
```

## Предикат поиска родственника

В данном задании нужно найти троюродных братьев/сестер

+ напишем предикат поиска `siblings`, если X и Y имеют одного общего родителя, например 

``` prolog
sibling(Self, Sibling) :-
    child(Self, ParentSelf),
    child(Sibling, ParentSelf),
    (male(ParentSelf);female(ParentSelf)),
    Self \= Sibling.
```

+ напишем предикат двоуюродного брата/сестры `cousin` - это значит, что родители двух введеных людей - братья или сестры

``` prolog
cousin(X, Y) :-
	child(X, Z),
	sibling(Z, V),
	child(Y, V). 
```

+ напишем наконец предикат троуююродного брата/сестры `second cousin` - это значит, что родители двух введеных людей - братья или сестры

``` prolog
secondcousin(X, Y) :-
	child(X, Z),
	cousin(Z, V),
	child(Y, V).
```

### протокол выполнения программы в GNU prolog
+ sibling
``` prolog
?- sibling('William Shakespeare', Y).
Y = 'Joan Shakespeare'
Y = 'Margaret Shakespeare'
Y = 'Gilbert Shakespeare'
Y = 'Anne Shakespeare'
Y = 'Richard Shakespeare'
Y = 'Edmund Shakespeare'
```
+ cousin
``` prolog
?- firstCousin('John Shakespeare', Y).
Y = 'Susanna Shakespeare'
Y = 'Hamnet Shakespeare'
Y = 'Judith Shakespeare'
```
+ second cousin
``` prolog
?- secondCousin('William Shakespeare', Y).
Y = 'Elizabeth Shakespeare'
Y = 'Shakespeare Quiney'
Y = 'Richard Quiney'
Y = 'Thomas Quiney'
```

## Определение степени родства

+ приведем тривиальные случаи поиска, когда найдется нужный человек и реляция. Первый аргумент `pattern` является как-бы функцией действующей на X, то есть `brother(X) = Y`
```prolog
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
```

+ Определим переход от одного состояния к другому (дял поиска в пространстве состояний)
```prolog
move(X, Y) :- child(X, Y).
move(X, Y) :- child(Y, X).
move(X, Y) :- sibling(X, Y).
move(X, Y) :- sibling(Y, X).
```

+ определим два преликата поиска в глубину в пространстве состояний (такие же как и в ЛР3), первый ищет только первое нахождение, второй все
``` prolog
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
```

+ сделаем красивый вывод на английском языке
``` prolog
% как связаны X и Y 
find_a_relation(X, Y) :-
    dfs(Relation, X, Y),
    write(Y), write(" is "), write(X),
    write("`s "), write(Relation), write("."), nl.
    
% как связаны X и Y (все виды сязей)
find_all_relations(X, Y) :-
    dfs_all(Relation, X, Y),
    write(Y), write(" is "), write(X),
    write("`s "), write(Relation), write("."), nl.

% найти такого Y, что он является Relation для X
find_a_relative(Relation, X) :-
    dfs(Relation, X, Y), 
    write(Relation), write(" of "), write(X),
    write(" is "), write(Y), write("."), nl.

% найти всех таких Y, что они является Relation для X
find_all_relatives(Relation, X) :-
    dfs_all(Relation, X, Y), 
    write(Relation), write(" of "), write(X),
    write(" is "), write(Y), write("."), nl.
```
## Естественно-языковый интерфейс

+ определим типы термов в запросе (они будут идти в виде списка)
``` prolog
% определим все виды связей 
relation(X) :-
    member(X, ['sibling', 'first cousin',
               'second cousin', 'second cousin',
               'brother', 'sister', 'mother',
               'father', 'daughter', 'son']).

% и еще несколько термов, тут все тривиально 
question_word(X) :-
    member(X, [who, what]).
auxiliary_word(X) :-
    member(X, [is, are]).
linkage(X) :-
    member(X, [to, between, all, relation, and]).
question_mark(X) :-
    member(X, ['?']).
```

+ определим четыре вида вопросов, в комментариях написаны: шаблон, пример испоьзования и ответ. В каждом вопросе проверятеся на валидность каждый терм по-отдельности с помощью определенных выше фактов.
``` prolog
% who is Relation to Self? --- who is brother to 'William Shakespeare'?
	% answer: 'name name' 
ask(List) :-
    List = [A, B, C, D, E, F],
    question_word(A),
    auxiliary_word(B),
    relation(C),
    linkage(D),
    (male(E); female(E)),
	question_mark(F),
    find_a_relative(C, E).
    

% who are all Relation to Self? --- who are all 'second cousin' to 'William Shakespeare'?
	% answer:  'name1 name1'; 'name2 name2'; ...
ask(List) :-
    List = [A, B, I, C, D, E, F],
    question_word(A),
    auxiliary_word(B),
    linkage(I),
    relation(C),
    linkage(D),
    (male(E); female(E)),
	question_mark(F),
    find_all_relatives(C, E).
    
% what is relation between Self and Relative? --- what is relation between 'William Shakespeare' and 'Mary Arden'?
	% answer: 'mother'
ask(List) :-
    List = [A, B, C, D, E, F, G, H],
    question_word(A),
    auxiliary_word(B),
    linkage(C),
    linkage(D),
    (male(E); female(E)),
    linkage(F),
    (male(G); female(G)),
	question_mark(H),
    find_a_relation(E, G).

% what are all relations between Self and Relative? --- what are all relations between 'William Shakespeare' and 'Mary Arden'?
	% answer: 'relation1'; 'relation2'; ...

ask(List) :-
    List = [A, B, I, C, D, E, F, G, H],
    question_word(A),
    auxiliary_word(B),
    linkage(I),
    linkage(C),
    linkage(D),
    (male(E); female(E)),
    linkage(F),
    (male(G); female(G)),
	question_mark(H),
    find_all_relations(E, G).
```
### примеры использования
``` prolog
% найти мать William Shakespeare-а
?- ask([who, is, mother, to, 'William Shakespeare', ?]).
mother of William Shakespeare is Mary Arden.

% найти всех брато-сестер William Shakespeare-а
?- ask([who, are, all, sibling, to, 'William Shakespeare', ?]).
sibling of William Shakespeare is Joan Shakespeare.;
sibling of William Shakespeare is Margaret Shakespeare.;
sibling of William Shakespeare is Gilbert Shakespeare.;
sibling of William Shakespeare is Anne Shakespeare.;
sibling of William Shakespeare is Richard Shakespeare.;
sibling of William Shakespeare is Edmund Shakespeare.;

% какая связь между William Shakespeare и Mary Arden
?- ask([what, is, relation, between, 'William Shakespeare', and, 'Mary Arden', ?]).
Mary Arden is William Shakespeare`s mother.

% какая связь между William Shakespeare и Richard Shakespeare
?- ask([what, are, all, relation, between, 'William Shakespeare', and, 'Richard Shakespeare', ?]).
Richard Shakespeare is William Shakespeare`s sibling.;
Richard Shakespeare is William Shakespeare`s brother.
```

## Выводы
Данная работа оказалась не самой простой. Возникли трудности уже в самом начале: не получалось найти корректный gedcom файл. Потом пришлось долго разбираться с питоном, чтобы написать рабочий парсер. После этого уже стало полегче, 3 часть оказалась очень простой. На четвертой возникли трудности, точнее не было даже минимального понятия, как его делать, однако после выполнения ЛР 3, стало понятно, что это несложная задача. С пятым возникли некоторые трудности, потому что в задании не было точного паттерна вывода, поэтому я придумал его сам, выглядит удобно, поэтому, я думаю, что тут я более или менее справился. 
Думаю, что стоит пройтись по понятиям, которые мне сильно запомнились после выполнения КП:

В этой работе мне пришли некоторые интересные мысли, однако с учетом моих знаний в области логики, эти идеи разобьются о суровую реальность. Однако я все же приведу их здесь. Полагаю, что возможно изобрести такой логический язык, который будет основан на теории категорий, на таком языке будет возможно сделать что-то более интересное для мира математики, нежели это делает пролог. После данного курса я заинтересовался в целом логикой и разными теориями, связанными с доказательствами. Поэтому я точно продолжу изучать все это дело. Начну наверное, хаскелла и лиспа, потому что много о них слышал.
