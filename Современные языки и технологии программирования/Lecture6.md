# Лекция 6

13.02.20

- [Лекция 6](#Лекция-6)
  - [Делегаты](#Делегаты)
  - [Лямбда-выражения](#Лямбда-выражения)
  - [Задача: найти наименьшее из 3 чисел](#Задача-найти-наименьшее-из-3-чисел)
  - [События](#События)

## Делегаты

Делегаты хранят указатель на некоторый метод.

Для объявления используется `delegate`.

Использование делегата:

```cs
delegate тип_возвращаемого_значения имя(параметры);

delegate bool MyComp(int x, int y);

bool Cmp1(int x, int y)
{
    return x > y;
}

bool Cmp2(int x, int y)
{
    return Math.Abs(x) > Math.Abs(y);
}

MyComp cmp = new MyComp(Cmp1);
// или
MyComp cmp = Cmp1;

if (cmp(5, 7)) ...
```

Передача делегата:

```cs
void Sort(..., MyComp cmp)
{
    ...
    cmp(...);
    ...
}

Sort(..., Cmp1);
```

## Лямбда-выражения

Анонимный метод, т. е. метод, не имеющий имени.

```cs
(параметры) => возвращаемое значение;
```

Происходит автоматическое определение типов.

```cs
Sort(..., (x, y) => x > y);
```

## Задача: найти наименьшее из 3 чисел

```cs
delegate bool MyComp(string s1, string s2);

var s1 = Console.ReadLine();
var s2 = Console.ReadLine();
var s3 = Console.ReadLine();

MyComp cmp = (s1, s2) => int.Parse(s1) > int.Parse(s2);
try
{
    int.Parse(s1);
    int.Parse(s2);
    int.Parse(s3);
}
catch (FormatException e)
{
    cmp = (s1, s2) => s1.CompareTo(s2) == 1;
}
if (cmp(s2, s1) && cmp(s3, s1)) Console.WriteLine(s1);
// аналогично для s2 и s3
```

## События

Событие - механизм автоматического оповещения о каком-либо произошедшем действии.

1. Объекты могут порождать события. В этих объектах событие должно быть объявлено и в какой-то момент вызываться.
2. Должен быть создан обработчик события, т. е. метод, соответствующий событию по сигнатуре.

Событие вызывается <-> Основная программа (подписка/отписка) <-> Обработчик события.

Событие является элементом класса и объявляется ключевым словом `event`.

Пример:

```cs
// 1
delegate void Alarm(int bal);

class Client
{
    string name;
    int balance;

    public event Alarm LowBal;
    public bool Payment(int sum, string name)
    {
        if (balance < sum) return false;
        balance -= sum;
        if (balance < 100)
            if (LowBal != null)
                LowBal(balance, name)
        return true;
    }
}

// 2
class Operator
{
    static void ShowMes(int ourBal, string name)
    {
        Console.WriteLine(...);
    }
}

// 3
Client x = new Client("Городилов", 300);
x.LowBal += Operator.ShowMes;
x.Payment(250);
```

Если назначено несколько обработчиков, то событие является широковещательным, и тип возвращаемого значения - void.

Можно отписаться от уведомлений о событии.

```cs
x.LowBal -= Operator.ShowMes;
```
