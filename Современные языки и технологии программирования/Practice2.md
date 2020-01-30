# Практика 2

30.01.20

- [Практика 2](#Практика-2)
  - [Быстрая сортировка (сортировка Хоара)](#Быстрая-сортировка-сортировка-Хоара)
  - [Бинарное дерево](#Бинарное-дерево)
    - [Вывод на экран](#Вывод-на-экран)
      - ["Ленивый" способ](#Ленивый-способ)
      - ["Неленивый" способ](#Неленивый-способ)
    - [Сравнение](#Сравнение)
      - [Лениво](#Лениво)
    - [Возможность работать не только с целыми числами](#Возможность-работать-не-только-с-целыми-числами)
  - [Ввод-вывод](#Ввод-вывод)
    - [Композиция функций](#Композиция-функций)
  - [Построение дерева выражения (лабораторная по Haskell, часть 3)](#Построение-дерева-выражения-лабораторная-по-haskell-часть-3)

## Быстрая сортировка (сортировка Хоара)

```hs
-- написал я
sort [] = []
sort (x : xs) = sort(filter (\y -> y < x) xs) ++ x ++ sort(filter (\y -> y >= x) xs)
```

```hs
-- написал А. Ю. Городилов
-- сложность: n*log(n)
qsort [] = []
qsort (x : t) =
 (qsort [y | y <- t, y <= x])
 ++ x
 ++ (qsort [y | y <- t, y > x])
```

```hs
type IntList = [Int]
qsort :: IntList -> IntList
qsort [] = []
qsort (x : t) =
 (qsort [y | y <- t, y <= x])
 ++ x
 ++ (qsort [y | y <- t, y > x])
```

## Бинарное дерево

data имя_типа =
 конструктор1 тип1
 конструктор2 тип2
 ...

```hs
data BinTree =
 None
 | Node (int, BinTree, BinTree)

t1 = Node (5, Node(3, None, None),
     Node(6, Node(6, None, None), None))
```

Мы не можем вывести BinTree, т. к. BinTree не является экземпляром класса Show.

Укоротим запись создания дерева:

```hs
leaf x = Node (x, None, None)
```

### Вывод на экран

#### "Ленивый" способ

Тип BinTree будет экземпляром класса Show:

```hs
data BinTree =
 None
 | Node (int, BinTree, BinTree)
 deriving Show
```

#### "Неленивый" способ

```hs
instance Show BinTree where
 show None = ""
 show (Node(x, None, None)) = show x
 show (Node(x, lt, None)) = '(' ++ show lt ++ ')' ++ show x
 show (Node(x, None, rt)) = show x ++ '(' ++ show rt ++ ')'
 show (Node(x, lt, rt)) = '(' ++ show lt ++ ')' ++ show x ++ '(' ++ show rt ++ ')'

-- (3)5((6)8)
```

### Сравнение

#### Лениво

```hs
data BinTree =
 None
 | Node (int, BinTree, BinTree)
 deriving Eq
```

```hs
data BinTree =
 None
 | Node (int, BinTree, BinTree)
 deriving (Eq, Ord)
```

### Возможность работать не только с целыми числами

BinTree теперь работает с деревьями любых типов, которые поддерживают

```hs
data BinTree t =
 None
 | Node (t, BinTree t, BinTree t)
```

```hs
instance (Show t) => Show (BinTree t)
 show None = ""
 show (Node(x, None, None)) = show x
 show (Node(x, lt, None)) = '(' ++ show lt ++ ')' ++ show x
 show (Node(x, None, rt)) = show x ++ '(' ++ show rt ++ ')'
 show (Node(x, lt, rt)) = '(' ++ show lt ++ ')' ++ show x ++ '(' ++ show rt ++ ')'
```

## Ввод-вывод

Введем два числа и выведем сумму.

```hs
mysum x y = x + y

main = do -- без do не работает
 putStrLn "Hello! Input first number"
 x <- getLine
 putStrLn "Input second number"
 y <- getLine
 putStrLn "Sum of this two numbers is "
 putStrLn (show (mysum (read x) (read y)))
```

Писать do и императивный код за пределами main при сдаче лаб не рекомендуется.

### Композиция функций

```hs
-- аналогично вышеприведенному
putStrLn.show (mysum (read x) (read y))
```

## Построение дерева выражения (лабораторная по Haskell, часть 3)

Выражение = слагаемое +/- слагаемое { +/- слагаемое }

или

__Выражение__ = слагаемое +/- выражение

либо

__Выражение__ = слагаемое

Слагаемое = число { \*/: число }

или

__Слагаемое__ = число \*/: слагаемое

либо

__Слагаемое__ = число
