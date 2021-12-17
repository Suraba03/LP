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

Данный курсовой проект является большой работой, охватывающей весь курс логического программирования на языке пролог в МАИ. Я выбрал стандартное задание, так как понимаю, что не смогу выделить много времени на логическое програмирование, поэтому и не претендую на оценку 5. Данное задание состоит из 5 пунктов:
1. Найти или создать gedcom file для использования его как данных для будущих программ и скриптов. Я выбрал взять дерево одной знатной европейской семьи, о ней будет в разделе "Получение родословного дерева". Это важная часть задания, так как она требует навыков поиска и проверки информации на валидность. К тому же, мне надо будет изучить, что из себя представляет формат текстового файла gedcom.
2. Написать парсер на удобном для меня языке программирования, об этом будет в разделе "Конвертация родословного дерева". С этой части начнутся трудности, так как единственным подходящим для этого языком, которым я владею хотя бы на уровне основ, является Python3. Мне нужно будет изучить библиотеку для парсинга gedcom файлов и некоторые основы ООП, так как библиотеки python написаны в виде модулей->классов. 
3. Написать на языке пролог предикат для second cousin, то есть для троюродного брата или сестры. Возможно, для этого потребуются другие предикаты по типу first cousin. Это не будет сложной задачей после выполнения первой лабораторной работы. 
4. Написать специализированный предикат, который позволит определять степень родства двух произвольных индивидуумов в дереве, это уже более сложная.
5. Реализовать естественно-языковый интерфейс (ЕЯИ) к системе, позволяющий задавать вопросы относительно степеней родства, и получать осмысленные ответы. Данный пункт я считаю наиболее интересным с точки зрения получения новых знаний, так как раньше я очень мало занимался синтаксическим разбором.


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

### подключим библиотеки:
```py
# library for system functions
import sys 
# library with class for parser imlementation
from gedcom.parser import Parser
# import IndividualElement object from gedcom.element class 
from gedcom.element.individual import IndividualElement
```
### напишем функцию которая последовательно запишет в выходной файл все сформированные предикаты:
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

### напишем функцию для извлечения имени и фамилии человека из gedcom файла, которая после сформирует готовые имена в виде строк:
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

### напишем функцию для извлечения и формирования прелидактов `male`, `female` в виде строк

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

### основной цикл. Сначала добавляем `gender` (`male` or `female`), потом, если он(она) является чьим-то ребенком,то добавляем соответствующий предикат `child` 

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

### напишем предикат поиска siblings, если X и Y имеют одного общего родителя и он существует

```pl
% sibling predicate
sibling(X, Y) :-
	child(X, Z),
	child(Y, Z),
	male(Z),
	Y \= X.
sibling(X, Y) :-
	child(X, Z),
	child(Y, Z),
	female(Z),
	Y \= X.
```

### напишем предикат двоуюродного брата/сестры, cousin это дети siblings

```pl
% first cousin (second sibling) predicate
cousin(X, Y) :-
	child(X, Z),
	sibling(Z, V),
	child(Y, V). 
```

### напишем предикат троюродного брата/сестры, second cousin это дети cousin родителей

```pl
% second cousin (third sibling) predicate
secondcousin(X, Y) :-
	child(X, Z),
	cousin(Z, V),
	child(Y, V).

```

### протокол выполнения программы в GNU prolog

```pl
| ?- sibling('William Shakespeare', X).

X = 'Joan Shakespeare' ? ;

X = 'Margaret Shakespeare' ? ;

X = 'Gilbert Shakespeare' ? ;

X = 'Joan Shakespeare' ? ;

X = 'Anne Shakespeare' ? ;

X = 'Richard Shakespeare' ? ;

X = 'Edmund Shakespeare' ? ;

(2 ms) no
| ?- cousin(X, Y).                    

X = 'John Shakespeare'
Y = 'Susanna Shakespeare' ? ;

X = 'John Shakespeare'
Y = 'Hamnet Shakespeare' ? ;

X = 'John Shakespeare'
Y = 'Judith Shakespeare' ? ;

X = 'Susanna Shakespeare'
Y = 'John Shakespeare' ? ;

X = 'Susanna Shakespeare'
Y = 'Henry Shakespeare' ? ;

X = 'Hamnet Shakespeare'
Y = 'John Shakespeare' ? ;

X = 'Hamnet Shakespeare'
Y = 'Henry Shakespeare' ? ;

X = 'Judith Shakespeare'
Y = 'John Shakespeare' ? ;

X = 'Judith Shakespeare'
Y = 'Henry Shakespeare' ? ;

X = 'Henry Shakespeare'
Y = 'Susanna Shakespeare' ? ;

X = 'Henry Shakespeare'
Y = 'Hamnet Shakespeare' ? ;

X = 'Henry Shakespeare'
Y = 'Judith Shakespeare' ? ;

X = 'Elizabeth Shakespeare'
Y = 'Shakespeare Quiney' ? ;

X = 'Elizabeth Shakespeare'
Y = 'Richard Quiney' ? ;

X = 'Elizabeth Shakespeare'
Y = 'Thomas Quiney' ? ;

X = 'Shakespeare Quiney'
Y = 'Elizabeth Shakespeare' ? ;

X = 'Richard Quiney'
Y = 'Elizabeth Shakespeare' ? ;

X = 'Thomas Quiney'
Y = 'Elizabeth Shakespeare' ? ;

(1 ms) no
| ?- secondcousin('William Shakespeare', Y).

Y = 'Elizabeth Shakespeare' ? ;

Y = 'Shakespeare Quiney' ? ;

Y = 'Richard Quiney' ? ;

Y = 'Thomas Quiney' ? ;

no
```

# -------------------------------------------------------------------------------------

## Определение степени родства

Приведите описание метода решения, важные фрагменты исходного кода, протокол работы.

## Естественно-языковый интерфейс

## Выводы

Сформулируйте *содержательные* выводы по курсовому проекту в целом. Чему он вас научила? 
Над чем заставила задуматься? Помните, что несодержательные выводы -
самая частая причина снижения оценки.
