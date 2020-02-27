# Лекция 8

27.02.20

- [Лекция 8](#Лекция-8)
  - [LINQ](#linq)
    - [IEnumerable](#ienumerable)
    - [Order by](#order-by)
    - [Long queries](#long-queries)
    - [Parsing numbers](#parsing-numbers)
    - [Any, All](#any-all)
    - [List of objects of another type](#list-of-objects-of-another-type)
    - [Group by](#group-by)

## LINQ

IEnumerable

IEnumerable\<T>

### IEnumerable

```cs
int[] arr = { 1, 3, -2, 10, -17 };

// Тут никаких реальных вычислений не происходит
var res = from n in arr
          where n > 0 // ?? n < 10
          // where n % 2 == 1
          orderby n
          // orderby n descending
          select n * n;

// Здесь будет происходить вычисление запроса по мере прохождения цикла
foreach (var r in res)
{
    Console.WriteLine(r);
}

// Выполняет запрос
var lst = res.ToList();
```

### Order by

```cs
var res2 = arr.Where(n => n > 0)
              .OrderByDescending(n);
```

### Long queries

```cs
// v1
var s = Console.ReadLine();
var n = s.Split(' ');
var nums = new int[n.Length];
// foreach

// v2
var nums = Console.ReadLine()
                  .Split(' ')
                  .Select(int.Parse)
                  .OrderBy()
                  .ToArray();

nums.ForEach(Console.WriteLine);
```

### Parsing numbers

```cs
var nums = Console.ReadLine()
                  .Split(' ')
                  .Select(i => int.TryParse(i, out var _))
                  .Select(int.Parse)
                  .OrderBy()
                  .ToArray();
```

### Any, All

```cs
var sorted = names.OrderByDescending(s => s.Length)
                  .ThenBy(s => s);
                  // .Any(...) // true, если истинно хотя бы для одного
                  // .All(...) // true, если для всех истинно
```

### List of objects of another type

```cs
class Student
{
    public string Name;
    public int Score;

    public Student(string name, int score)
    {
        Name = name;
        Score = score;
    }
}

class Person
{
    public string Name;

    public Person(string name)
    {
        Name = name;
    }
}

Student[] students = ...;
var people = students.Select(s => new Person(s.Name)).ToArray();
```

### Group by

```cs
IGrouping<char, string[]> groups = names.OrderByDescending(s => s.Length)
                  .ThenBy(s => s)
                  .GroupBy(name => name[0])
                  .ToArray();

foreach (var group in groups)
{
    Console.WriteLine(group.Key);
    foreach (var name in group)
    {
        Console.WriteLine(name);
    }
}
```
