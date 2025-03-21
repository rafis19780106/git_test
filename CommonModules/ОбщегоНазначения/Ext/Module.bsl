﻿
#Область ПрограммныйИнтерфейс

#Область ОповещениеПользователя

// Формирует и выводит сообщение, которое может быть связано с элементом управления формы.
//
// Параметры:
//  ТекстСообщенияПользователю - Строка - текст сообщения.
//  КлючДанных - ЛюбаяСсылка - объект или ключ записи информационной базы, к которому это сообщение относится.
//  Поле - Строка - наименование реквизита формы.
//  ПутьКДанным - Строка - путь к данным (путь к реквизиту формы).
//  Отказ - Булево - выходной параметр, всегда устанавливается в значение Истина.
//
// Пример:
//
//  1. Для вывода сообщения у поля управляемой формы, связанного с реквизитом объекта:
//  ОбщегоНазначенияКлиент.СообщитьПользователю(
//   НСтр("ru = 'Сообщение об ошибке.'"), ,
//   "ПолеВРеквизитеФормыОбъект",
//   "Объект");
//
//  Альтернативный вариант использования в форме объекта:
//  ОбщегоНазначенияКлиент.СообщитьПользователю(
//   НСтр("ru = 'Сообщение об ошибке.'"), ,
//   "Объект.ПолеВРеквизитеФормыОбъект");
//
//  2. Для вывода сообщения рядом с полем управляемой формы, связанным с реквизитом формы:
//  ОбщегоНазначенияКлиент.СообщитьПользователю(
//   НСтр("ru = 'Сообщение об ошибке.'"), ,
//   "ИмяРеквизитаФормы");
//
//  3. Для вывода сообщения связанного с объектом информационной базы:
//  ОбщегоНазначенияКлиент.СообщитьПользователю(
//   НСтр("ru = 'Сообщение об ошибке.'"), ОбъектИнформационнойБазы, "Ответственный",,Отказ);
//
//  4. Для вывода сообщения по ссылке на объект информационной базы:
//  ОбщегоНазначенияКлиент.СообщитьПользователю(
//   НСтр("ru = 'Сообщение об ошибке.'"), Ссылка, , , Отказ);
//
//  Случаи некорректного использования:
//   1. Передача одновременно параметров КлючДанных и ПутьКДанным.
//   2. Передача в параметре КлючДанных значения типа отличного от допустимого.
//   3. Установка ссылки без установки поля (и/или пути к данным).
//
Процедура СообщитьПользователю( 
	Знач ТекстСообщенияПользователю,
	Знач КлючДанных = Неопределено,
	Знач Поле = "",
	Знач ПутьКДанным = "",
	Отказ = Ложь) Экспорт
	
	ЭтоОбъект = Ложь;
	
	Если КлючДанных <> Неопределено
		И XMLТипЗнч(КлючДанных) <> Неопределено Тогда
		
		ТипЗначенияСтрокой = XMLТипЗнч(КлючДанных).ИмяТипа;
		ЭтоОбъект = СтрНайти(ТипЗначенияСтрокой, "Object.") > 0;
	КонецЕсли;
	
	ОбщегоНазначенияСлужебныйКлиентСервер.СообщитьПользователю(
		ТекстСообщенияПользователю,
		КлючДанных,
		Поле,
		ПутьКДанным,
		Отказ,
		ЭтоОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ДанныеВБазе

////////////////////////////////////////////////////////////////////////////////
// Общие процедуры и функции для работы с данными в базе.

// Возвращает значения реквизита, прочитанного из информационной базы по ссылке на объект.
//
// Если необходимо зачитать реквизит независимо от прав текущего пользователя,
// то следует использовать предварительный переход в привилегированный режим.
//
// Параметры:
//  Ссылка    - ЛюбаяСсылка - объект, значения реквизитов которого необходимо получить.
//  ИмяРеквизита       - Строка - имя получаемого реквизита.
//                                Допускается указание имени реквизита через точку
//  ВыбратьРазрешенные - Булево - если Истина, то запрос к объекту выполняется с учетом прав пользователя;
//                                если есть ограничение на уровне записей, то возвращается Неопределено;
//                                если нет прав для работы с таблицей, то возникнет исключение;
//                                если Ложь, то возникнет исключение при отсутствии прав на таблицу
//                                или любой из реквизитов.
//
// Возвращаемое значение:
//  Произвольный - если в параметр Ссылка передана пустая ссылка, то возвращается Неопределено.
//                 Если в параметр Ссылка передана ссылка несуществующего объекта (битая ссылка), 
//                 то возвращается Неопределено.
//
Функция ЗначениеРеквизитаОбъекта(Ссылка, ИмяРеквизита, ВыбратьРазрешенные = Ложь) Экспорт
	
	//	Тестируем мерж

	Возврат ЗначенияРеквизитовОбъекта(Ссылка, ИмяРеквизита, ВыбратьРазрешенные)[ИмяРеквизита];
	
КонецФункции

// Возвращает структуру, содержащую значения реквизитов, прочитанные из информационной базы по ссылке на объект.
//
// Если необходимо зачитать реквизит независимо от прав текущего пользователя,
// то следует использовать предварительный переход в привилегированный режим.
//
// Параметры:
//  Ссылка    - ЛюбаяСсылка - объект, значения реквизитов которого необходимо получить.
//  Реквизиты - Строка - имена реквизитов, перечисленные через запятую, в формате
//                       требований к свойствам структуры.
//                       Например, "Код, Наименование, Родитель".
//            - Структура
//            - ФиксированнаяСтруктура - в качестве ключа передается
//                       псевдоним поля для возвращаемой структуры с результатом, а в качестве
//                       значения (опционально) фактическое имя поля в таблице.
//                       Если ключ задан, а значение не определено, то имя поля берется из ключа.
//                       Допускается указание имени поля через точку
//            - Массив
//            - ФиксированныйМассив - имена реквизитов в формате требований
//                       к свойствам структуры.
//  ВыбратьРазрешенные - Булево - если Истина, то запрос к объекту выполняется с учетом прав пользователя;
//                                если есть ограничение на уровне записей, то все реквизиты вернутся со 
//                                значением Неопределено; если нет прав для работы с таблицей, то возникнет исключение;
//                                если Ложь, то возникнет исключение при отсутствии прав на таблицу 
//                                или любой из реквизитов.
//
// Возвращаемое значение:
//  Структура - содержит имена (ключи) и значения затребованных реквизитов.
//              Если в параметр Ссылка передана пустая ссылка, то возвращается структура, 
//              соответствующая именам реквизитов со значениями Неопределено.
//              Если в параметр Ссылка передана ссылка несуществующего объекта (битая ссылка), 
//              то все реквизиты вернутся со значением Неопределено.
//
Функция ЗначенияРеквизитовОбъекта(Ссылка, Знач Реквизиты, ВыбратьРазрешенные = Ложь) Экспорт
	
	Ссылки = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Ссылка);
	Возврат ЗначенияРеквизитовОбъектов(Ссылки, Реквизиты, ВыбратьРазрешенные)[Ссылка];
	
КонецФункции

// Возвращает значения реквизита, прочитанного из информационной базы для нескольких объектов.
//
// Если необходимо зачитать реквизит независимо от прав текущего пользователя,
// то следует использовать предварительный переход в привилегированный режим.
//
// Параметры:
//  МассивСсылок       - Массив - массив ссылок на объекты.
//  ИмяРеквизита       - Строка - например, "Код".
//  ВыбратьРазрешенные - Булево - если Истина, то запрос к объектам выполняется с учетом прав пользователя;
//                                если какой-либо объект будет исключен из выборки по правам, то этот объект
//                                будет исключен и из результата;
//                                если Ложь, то возникнет исключение при отсутствии прав на таблицу
//                                или любой из реквизитов.
//
// Возвращаемое значение:
//  Соответствие из КлючИЗначение:
//      * Ключ     - ЛюбаяСсылка  - ссылка на объект,
//      * Значение - Произвольный - значение прочитанного реквизита.
// 
Функция ЗначениеРеквизитаОбъектов(МассивСсылок, ИмяРеквизита, ВыбратьРазрешенные = Ложь) Экспорт
	
	ЗначенияРеквизитов = ЗначенияРеквизитовОбъектов(МассивСсылок, ИмяРеквизита, ВыбратьРазрешенные);
	Для каждого Элемент Из ЗначенияРеквизитов Цикл
		ЗначенияРеквизитов[Элемент.Ключ] = Элемент.Значение[ИмяРеквизита];
	КонецЦикла;
		
	Возврат ЗначенияРеквизитов;
	
КонецФункции

// Возвращает значения реквизитов, прочитанные из информационной базы для нескольких объектов.
//
// Если необходимо зачитать реквизит независимо от прав текущего пользователя,
// то следует использовать предварительный переход в привилегированный режим.
//
// Параметры:
//  Ссылки - Массив
//         - ФиксированныйМассив - ссылки на объекты.
//                    Если массив пуст, то результатом будет пустое соответствие.
//  Реквизиты - Строка - имена реквизитов перечисленные через запятую, в формате требований к свойствам
//                       структуры. Например, "Код, Наименование, Родитель".
//            - Массив
//            - ФиксированныйМассив - имена реквизитов в формате требований
//                       к свойствам структуры.
//  ВыбратьРазрешенные - Булево - если Истина, то запрос к объектам выполняется с учетом прав пользователя;
//                                если какой-либо объект будет исключен из выборки по правам, то этот объект
//                                будет исключен и из результата;
//                                если Ложь, то возникнет исключение при отсутствии прав на таблицу
//                                или любой из реквизитов.
//
// Возвращаемое значение:
//  Соответствие из КлючИЗначение - список объектов и значений их реквизитов:
//   * Ключ - ЛюбаяСсылка - ссылка на объект;
//   * Значение - Структура:
//    ** Ключ - Строка - имя реквизита;
//    ** Значение - Произвольный - значение реквизита.
// 
Функция ЗначенияРеквизитовОбъектов(Ссылки, Знач Реквизиты, ВыбратьРазрешенные = Ложь) Экспорт
	
	ВозвращаемоеЗначение = Новый Соответствие;
	
	Запрос = Новый Запрос;
	ТекстыЗапросов = Новый Массив;
	
	// Формирование выбираемых полей:
	ПсевдонимыПолей = Новый Массив;
	ВыбираемыеПоля = Новый Массив;
	ШаблонВыбираемогоПоля = "ТаблицаДанных.%1 КАК %2";
	
	СтруктураРеквизитов = ПреобразоватьПараметрВСтруктуру(Реквизиты, Истина);
	
	Для Каждого КлючИЗначение Из СтруктураРеквизитов Цикл
		ПсевдонимыПолей.Добавить(КлючИЗначение.Ключ);
		ВыбираемыеПоля.Добавить(
			СтрШаблон(
				ШаблонВыбираемогоПоля, 
				КлючИЗначение.Значение,
				КлючИЗначение.Ключ));
	КонецЦикла;
	
	ПсевдонимыПолей = СтрСоединить(ПсевдонимыПолей, ", ");
	ВыбираемыеПоля = СтрСоединить(ВыбираемыеПоля, ",
		|	");
	
	// Разбивка соответствия по типам:
	СоответствиеПоТипам = Новый Соответствие;
	
	Для Каждого Ссылка Из Ссылки Цикл
		
		ТипСсылки = ТипЗнч(Ссылка);
		
		СсылкиТипа = СоответствиеПоТипам.Получить(ТипСсылки);
		
		Если СсылкиТипа = Неопределено Тогда
			
			СсылкиТипа = Новый Массив;
			СоответствиеПоТипам.Вставить(ТипСсылки, СсылкиТипа);
			
		КонецЕсли;
		
		СсылкиТипа.Добавить(Ссылка);
		
	КонецЦикла;
	
	// При пустом массиве ссылок нет возможности выполнить запрос. Возврат пустого соответствия:
	Если НЕ ЗначениеЗаполнено(СоответствиеПоТипам) Тогда
		Возврат ВозвращаемоеЗначение;
	КонецЕсли;
	
	// Формирование текста:
	Для Каждого КлючИЗначение Из СоответствиеПоТипам Цикл
		
		Тип = КлючИЗначение.Ключ;
		СсылкиТипа = КлючИЗначение.Значение;
		
		МетаданныеТипа = Метаданные.НайтиПоТипу(Тип);
		ИмяТаблицы = МетаданныеТипа.ПолноеИмя();
		
		ТекстЗапроса =
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ТаблицаДанных.Ссылка,
			|	&ВыбираемыеПоля
			|ИЗ
			|	&ИмяТаблицы КАК ТаблицаДанных
			|ГДЕ
			|	ТаблицаДанных.Ссылка В (&Ссылки)";
		
		Если НЕ ВыбратьРазрешенные ИЛИ ЗначениеЗаполнено(ТекстыЗапросов) Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "РАЗРЕШЕННЫЕ", "");
		КонецЕсли;
		
		ИмяПараметра = "Ссылки" + СтрЗаменить(ИмяТаблицы, ".", "");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ВыбираемыеПоля", ВыбираемыеПоля);
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИмяТаблицы", ИмяТаблицы);
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&Ссылки", "&" + ИмяПараметра);
		
		Запрос.УстановитьПараметр(ИмяПараметра, СсылкиТипа);
		
		ТекстыЗапросов.Добавить(ТекстЗапроса);
		
	КонецЦикла;

	Запрос.Текст = СтрСоединить(ТекстыЗапросов, РазделительЗапросовВОбъединении());
	
	// Выполнение запроса и возврат результата:
	РезультатЗапроса = Запрос.Выполнить();
		
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		ДанныеОбъекта = Новый Структура(ПсевдонимыПолей);
		ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Выборка);
		ВозвращаемоеЗначение.Вставить(Выборка.Ссылка, ДанныеОбъекта);
	КонецЦикла;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Выполняет преобразование переданного параметра в структуру
// Параметры:
//  Параметр - Неопределено, Строка, Массив, Структура - Который необходимо преобразовать
//  ЗаполнятьПустыеЗначенияКлючами - Булево - Указывает, что необходимо вместо пустых значений подставить значения ключей
//
// ВозвращаемоеЗначение:
//  Структура - Преобразованный параметр
Функция ПреобразоватьПараметрВСтруктуру(Параметр, ЗаполнятьПустыеЗначенияКлючами = Ложь)
	
	ТипПараметра = ТипЗнч(Параметр);
	
	Если ТипПараметра = Тип("Неопределено") Тогда
		ВозвращаемоеЗначение = Новый Структура;
	ИначеЕсли ТипПараметра = Тип("Строка") Тогда
		ВозвращаемоеЗначение = Новый Структура(Параметр);
	ИначеЕсли ТипПараметра = Тип("Массив") 
		ИЛИ ТипПараметра = Тип("ФиксированныйМассив") Тогда
		ВозвращаемоеЗначение = Новый Структура(СтрСоединить(Параметр, ", "));
	ИначеЕсли ТипПараметра = Тип("Структура") 
		ИЛИ ТипПараметра = Тип("ФиксированнаяСтруктура") Тогда
		
		ВозвращаемоеЗначение = Новый Структура;
		Для Каждого КлючИЗначение Из Параметр Цикл
			ВозвращаемоеЗначение.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение)
		КонецЦикла;
		
	Иначе
		ТекстОшибки = "В функцию ""ОбщегоНазначенияКлиентСервер.ПреобразоватьПараметрВСтруктуру"" передан параметр неверного типа " + ТипПараметра;
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	Если ЗаполнятьПустыеЗначенияКлючами Тогда
		Для Каждого КлючИЗначение Из ВозвращаемоеЗначение Цикл
			Если НЕ ЗначениеЗаполнено(КлючИЗначение.Значение) Тогда
				ВозвращаемоеЗначение[КлючИЗначение.Ключ] = КлючИЗначение.Ключ;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

	Возврат ВозвращаемоеЗначение;
	
КонецФункции

#КонецОбласти

#Область Данные

// Процедура удаляет из массива МассивРеквизитов элементы, соответствующие именам 
// реквизитов объекта из массива МассивНепроверяемыхРеквизитов.
// Для использования в обработчиках события ОбработкаПроверкиЗаполнения.
//
// Параметры:
//  МассивРеквизитов              - Массив - коллекция имен реквизитов объекта.
//  МассивНепроверяемыхРеквизитов - Массив - коллекция имен реквизитов объекта, не требующих проверки.
//
Процедура УдалитьНепроверяемыеРеквизитыИзМассива(МассивРеквизитов, МассивНепроверяемыхРеквизитов) Экспорт
	
	Для Каждого ЭлементМассива Из МассивНепроверяемыхРеквизитов Цикл
	
		ПорядковыйНомер = МассивРеквизитов.Найти(ЭлементМассива);
		Если ПорядковыйНомер <> Неопределено Тогда
			МассивРеквизитов.Удалить(ПорядковыйНомер);
		КонецЕсли;
	
	КонецЦикла;
	
КонецПроцедуры

// Создает объект ОписаниеТипов, содержащий тип Число.
//
// Параметры:
//  Разрядность - Число - общее количество разрядов числа (количество разрядов
//                        целой части плюс количество разрядов дробной части).
//  РазрядностьДробнойЧасти - Число - число разрядов дробной части.
//  ЗнакЧисла - ДопустимыйЗнак - допустимый знак числа.
//
// Возвращаемое значение:
//  ОписаниеТипов - описание типа Число.
//
Функция ОписаниеТипаЧисло(Разрядность, РазрядностьДробнойЧасти = 0, Знач ЗнакЧисла = Неопределено) Экспорт
	
	Если ЗнакЧисла = Неопределено Тогда 
		ЗнакЧисла = ДопустимыйЗнак.Любой;
	КонецЕсли;
	
	Возврат Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(Разрядность, РазрядностьДробнойЧасти, ЗнакЧисла));
	
КонецФункции

#КонецОбласти

#Область МетодыРаботыСЗапросом

// Возвращает текст разделителя для вставки между текстами пакета запросов.
//
// Возвращаемое значение:
//  Строка - текст разделителя.
//
Функция РазделительЗапросовВПакете() Экспорт
	
	Возврат "
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|";
	
КонецФункции

// Возвращает текст разделителя для вставки между текстами объединяемых запросов.
//
// Параметры:
//  ТолькоУникальные - Булево - признак того, что необходимо выбирать только уникальные записи при объединении.
//
// Возвращаемое значение:
//  Строка - текст разделителя.
//
Функция РазделительЗапросовВОбъединении(ТолькоУникальные = Ложь) Экспорт
	
	Если ТолькоУникальные Тогда
		Возврат "
		|
		|ОБЪЕДИНИТЬ
		|
		|";
	Иначе
		Возврат "
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|";
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Выгружает запрос в строку XML, которую можно вставить в Консоль запросов.
//   Для переноса запроса и всех его параметров в Консоль запросов, необходимо вызвать функцию в окне.
//   «Вычислить выражение»(Shift + F9), скопировать полученный XML в поле "Текст запроса"
//   консоли запросов и выполнить команду "Заполнить из XML" из меню "Еще".
//   Подробнее об использование функции смотрите в справке к консоли запросов.
//
// Параметры:
//   Запрос - Запрос - запрос, который необходимо выгрузить в формат строки XML.
//
// Возвращаемое значение:
//   Строка - строка в формате XML, которую можно извлечь при помощи метода "ОбщегоНазначения.ЗначениеИзСтрокиXML".
//       После извлечения получится объект типа "Структура" с полями:
//       * Текст     - Строка - текст запроса.
//       * Параметры - Структура - параметры запроса.
//
Функция ЗапросВСтрокуXML(Запрос) Экспорт 
	Структура = Новый Структура("Текст, Параметры");
	ЗаполнитьЗначенияСвойств(Структура, Запрос);
	Возврат ЗначениеВСтрокуXML(Структура);
КонецФункции

// Преобразует (сериализует) любое значение в XML-строку.
// Преобразованы в могут быть только те объекты, для которых в синтакс-помощнике указано, что они сериализуются.
// См. также ЗначениеИзСтрокиXML.
//
// Параметры:
//  Значение - Произвольный - значение, которое необходимо сериализовать в XML-строку.
//
// Возвращаемое значение:
//  Строка - XML-строка.
//
Функция ЗначениеВСтрокуXML(Значение) Экспорт
	
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку();
	СериализаторXDTO.ЗаписатьXML(ЗаписьXML, Значение, НазначениеТипаXML.Явное);
	
	Возврат ЗаписьXML.Закрыть();

КонецФункции

#КонецОбласти
