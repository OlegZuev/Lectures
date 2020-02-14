# Практика 3

13.02.20

- [Практика 3](#Практика-3)
  - [Сериализация](#Сериализация)
    - [Бинарная сериализация](#Бинарная-сериализация)
    - [Бинарная десериализация](#Бинарная-десериализация)
    - [Сериализация в XML](#Сериализация-в-xml)
    - [Десериализация из XML](#Десериализация-из-xml)
    - [Сериализация списка](#Сериализация-списка)
    - [Десериализация списка](#Десериализация-списка)
    - [Сериализация разных типов в списке](#Сериализация-разных-типов-в-списке)
    - [Дополнительные атрибуты](#Дополнительные-атрибуты)

## Сериализация

1. Текстовый файл
2. Сериализация
3. БД

__Сериализация__ - сохранение состояния объекта во внешней памяти.

Виды сериализации в .Net:

1. Бинарная - самый простой вариант. Прочитать результат можно только обратной десериализацией потоком байт. Принимающая программа должна уметь воссоздать объект. Может зависеть от архитектуры. `BinaryFormatter` : `IFormatter`.

2. SOAP - более универсальный формат. `SoapFormatter` : `IFormatter`.

3. XML - еще более гибкий формат. Другое приложение может прочитать данные. `XmlSerializer`.

4. JSON - `DataContractJsonSerializer`.

```cs
[Serializable]
public class Ts
{
    // ...
}

[Serializable]
public class Car : Ts
{
    // ...
}
```

__Атрибуты__ - способы введения метаданных.

__Метаданные__ - данные о программе.

Базовые классы тоже должны быть сериализуемы.

### Бинарная сериализация

```cs
var a = new Auto();
var bf = new BinaryFormatter();
var fs = new FileStream("filepath.bin", FileMode.Create);
bf.Serialize(fs, a);
fs.Close();
```

```cs
var a = new Auto();
var bf = new BinaryFormatter();
using (var fs = new FileStream("filepath.bin", FileMode.Create))
{
    bf.Serialize(fs, a);
}
```

### Бинарная десериализация

```cs
var bf = new BinaryFormatter();
using (var fs = new FileStream("filepath.bin", FileMode.Open))
{
    var a = (Auto)bf.Deserialize(fs);
}
```

### Сериализация в XML

Требования:

1. Классы должны быть публичными.
2. Поля должны быть публичными.
3. Должен быть конструктор по умолчанию (без параметров).

```cs
var xs = new XmlSerializer(typeof(Auto));
using (var fs = new FileStream("filepath.xml", FileMode.Create))
{
    xs.Serialize(fs, a);
}
```

### Десериализация из XML

```cs
var xs = new XmlSerializer(typeof(Auto));
using (var fs = new FileStream("filepath.xml", FileMode.Open))
{
    var a = (Auto)xs.Deserialize(fs);
}
```

### Сериализация списка

```cs
var a = new List<Auto>();
// ...
var xs = new XmlSerializer(typeof(List<Auto>));
using (var fs = new FileStream("filepath.xml", FileMode.Create))
{
    xs.Serialize(fs, a);
}
```

### Десериализация списка

```cs
var xs = new XmlSerializer(typeof(List<Auto>));
using (var fs = new FileStream("filepath.xml", FileMode.Open))
{
    var a = (List<Auto>)xs.Deserialize(fs);
}
```

### Сериализация разных типов в списке

Атрибут класса - `XmlInclude`.

При создании `XmlSerializer` можно передавать не один тип, а массив типов.

### Дополнительные атрибуты

```cs
// Если строка объявлена с помощью директивы #define, то этот метод будет вызываться
// В противном случае метод и его вызов исключается из компиляции
[System.Diagnostics.Conditional("mystring")]
public void DebugInfo()
{
    // ...
}

// DEBUG объявлено по умолчанию
[System.Diagnostics.Conditional("DEBUG")]
public void DebugInfo()
{
    // ...
}
```
