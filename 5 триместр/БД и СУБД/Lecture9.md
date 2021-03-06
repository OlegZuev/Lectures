# Лекция 9

11.03.20

- [Лекция 9](#Лекция-9)
  - [ER модель](#er-модель)
  - [Многоуровневая архитектура СУБД](#Многоуровневая-архитектура-СУБД)
    - [Концептуальные требования](#Концептуальные-требования)
    - [Концептуальная модель](#Концептуальная-модель)
    - [Логическая модель](#Логическая-модель)
    - [Внешние модели](#Внешние-модели)
    - [Физическая модель](#Физическая-модель)
  - [Понятия логической и физической независимости данных](#Понятия-логической-и-физической-независимости-данных)
  - [Поддержка транзакций](#Поддержка-транзакций)

## ER модель

Что делать на начальном шаге логического проектирования (несвязанного с физической организацией данных), если атрибутов больше 30 и/или предметная область такова, что хранить в одном универсальном отнощении все атрибуты информационных объектов даже напрямую, естественным образом накладно или неудобно, или в случае неполноты данных (касательно атрибутов). Пример: авиа, когда данные расписания не зависят от даты, а билет невозможно продать не в соответствии с расписанием, и так присутствует только дата, и при этом возможно, что не во все даты, соответствующие дням вылета, были осуществлены реальные полеты.

В перечисленных ситуациях рекомендуется на начальном шаге проектирования вместо универсального отношения строить ER-модель Чена (Entity Relation Model, модель сущность-связь).

__ER модель__ - семантическая модель данных, которая имеет графический язык описания данных и является составной частью большинства распространенных CASE-средств проектирования и реализации информационных систем (Computer Aided System Engineering).

Связи метятся типами соответствия 1:1, 1:М, М:1, М:М. _Если есть циклы, нужно убедиться, что так в действительно в области применения_.

И существуют однозначные правила, как перейти от этой графической схемы к нормализации. В общем случае отдельные сущности нормализуются отдельно, но учитывается тип соответствия, а именно: объекты, связанные как 1:1 сериализуются как один объект. М:М сериализуются как 3 объекта. При 1:М со стороны "Много" добавляется ключ объекта со стороны "Один".

Надо быть внимательным при анализе данных: обратить внимание на разнообразие контрольного примера необходимо не пропустить случай, когда 1:М является частным случаем М:М.

## Многоуровневая архитектура СУБД

Благодаря многоуровневой архитектуре СУБД в соответствии со стандартом ANSI SPARK позволяет поддержать физическую и логическую независимость данных, но полная гарантия этой независимости появляется только при тщательном проектировании БД.

### Концептуальные требования

- КТ1
- КТ2
- КТ3
- КТn

КТi - концептуальные требования потенциальных пользователей и/или приложений.

Начальный этап проектирования должен быть самым затратным с точки зрения времени, потраченного на анализ данныз, чтобы достаточно полно собрать все КТi требования, чтобы проверить все концептуальные данные со всеми видами зависимостей.

Для этого рекомендуется создать опросник, в котором заказчик и потенциальные пользователи отвечают на стандартные вопросы: "Приведите примеры информационных объектов", "Укажите их примерные значения", "Укажите ограничения атрибутов".

Очень часто об одних и тех же информационных объектах и атрибутах говорят, используя разные наименования, а с другой стороны - одно и то же имя в одной предметной области может использоваться для обозначения разных объектов и атрибутов.

Например: одному сервису нужно хранить дату рождения, а второму - возраст. Следует хранить дату рождения, а возраст должен быть виртуальным атрибутом.

Именования объектов и атрибутов на начальном этапе анализа должно устранить все имеющиеся противоречия, с тем чтобы все понятия определялись однозначно. Важно, что КТi не зависят ни от физической организации данных, ни от логической организации данных, ни от средств конкретной СУБД, а только от конкретной области.

### Концептуальная модель

КМ - концептуальная модель, представляющая собой интеграцию КТi представлений, где устранены все противоречия, о которых говорилось выше. КМ не зависит от конкретного типа СУБД и способов физической организации данных, но в некоторых современных СУБД (семантических СУБД) предоставляется такой высокоуровневый язык описания схемы БД, что КМ приближается к ЛМ (логической модели).

### Логическая модель

ЛМ (логическая модель) - концептуальная модель, описанная средствами конкретной СУБД вне зависимости от особенностей физической организации данных.

### Внешние модели

ВМi - внешние модели данных, представление которых видит конечный пользователь на уровне интерфейса приложения. Представления ВМi должны соответствовать КТi и могут быть ненормализованными.

Конкретное ВМi - необязательно подмножество логической модели - оно может содержать данные из разных таблиц, отфильтрованных как вертикально, так и горизонтально, и, возможно, виртуальные атрибуты.

### Физическая модель

ФМ (физическая модель) описывает физическую организацию данных, включая структуры хранения, методы доступа (прямой, последовательных, индексно-последовательный), способы индексации.

## Понятия логической и физической независимости данных

Описанная многоуровневая архитектура СУБД (К, Л, В, Ф) позволяет СУБД поддерживать логическую и физическую независимость данных, а также надежный уровень версионности, когда в новых версиях СУБД, где даже изменилась физическая организация данных (структура хранения данных), приложения, созданные на предыдущей версии СУБД, все равно работают надежно.

__DEF. Логическая независимость__ означает, что изменения данных на логическом уровне, т. е. добавление новых таблиц, индексов, взаимосвязей и т. п. не приводит к изменениям на внешнем уровне системы, если эти изменения их не касаются.

__DEF. Физическая независимость__ означает, что изменения в физической организации данных на уровне структур хранения, методах доступа, способах индексации не приводит к необходимости внесения изменений ни на логическом уровне, ни на внешнем.

Для обеспечения и логической, и физической независимости данных, СУБД таким образом поддерживает описанную многоуровневую архитектуру, что в случае изменений на логическом или физическом уровне разработчики СУБД переписывают протокол (интерфейс) взаимодействия моделей, т. е. СУБД автоматически поддерживает преобразование данных между различными уровнями, поэтому имеет более сложную организацию, чем средства работы с файлами.

## Поддержка транзакций

Свойства:

- Atomicity - атомарность - "все или ничего", а именно либо все действия, заявленные в одной транзакции, выполнятся и удачно зафиксируются во внешней памяти соответствующих серверов БД, либо в случае, например, недоступности хотя бы одного сервера, все действия система откатит и БД вернется в прежнее согласованное состояние.
- Isolation - изоляция - предполагает, что все транзакции, даже изменяющие одну и ту же запись в БД, выполняются изолированно, и при надлежащей работе сетевых коммуникаций пользователь должен вообще не замечать присутствие других пользователей в сети, изменяющих те же данные.

Для этого в СУБД реализуются специальные алгоритмы, предназначенные для обработки смеси транзакций.
