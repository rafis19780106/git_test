﻿
#Область ПрограммныйИнтерфейс

#Область ОповещениеПользователя

// Формирует путь к заданной строке НомерСтроки и колонке ИмяРеквизита 
// табличной части ИмяТабличнойЧасти для выдачи сообщений в форме.
// Для совместного использования с процедурой СообщитьПользователю
// (для передачи в параметры Поле или ПутьКДанным). 
//
// Параметры:
//  ИмяТабличнойЧасти - Строка - имя табличной части.
//  НомерСтроки - Число - номер строки табличной части.
//  ИмяРеквизита - Строка - имя реквизита.
//
// Возвращаемое значение:
//  Строка - путь к ячейке таблицы.
//
Функция ПутьКТабличнойЧасти(
		Знач ИмяТабличнойЧасти,
		Знач НомерСтроки, 
		Знач ИмяРеквизита) Экспорт
	
	Возврат СтрШаблон("%1[%2].%3",
		ИмяТабличнойЧасти,
		Формат(НомерСтроки - 1, "ЧН=0; ЧГ=0"),
		ИмяРеквизита);
	
КонецФункции

#КонецОбласти

#Область Данные

// Создает массив и помещает в него переданное значение.
//
// Параметры:
//  Значение - Произвольный - любое значение.
//
// Возвращаемое значение:
//  Массив - массив из одного элемента.
//
Функция ЗначениеВМассиве(Знач Значение) Экспорт
	
	ВозвращаемоеЗначение = Новый Массив;
	ВозвращаемоеЗначение.Добавить(Значение);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

#КонецОбласти

#Область Оформление

// Создает элемент условного ооформления одного параметра одного поля по одному отбору.
// Параметры:
//  Форма                        - ФормаКлиентскогоПриложения       - На которую необходимо добавить условное оформление
//  ОформляемоеПоле              - Строка, Неопределено             - Имя офомляемого элемента формы. Например, "Товары". Если не передавать, то оформляемое поле не будет добавлено
//  ИмяПараметраОформления       - Строка, ПараметрКомпоновкиДанных - Указывает что будет изменено в офомлении поля. Например, "ЦветФона" / "Текст"
//  ЗначениеПараметраОформления  - Произвольный                     - Значение оформления. Например, <Новый Цвет(222, 255, 222)>
//  ПутьКЛевомуЗначениюОтбора    - Строка, Неопределено             - Путь к полю по которому выполняется отбор условного оформления. Например, "Товары.Номенклатура" / "Контрагент". Если не передавать, то отбор не будет установлен
//  ВидСравненияОтбора           - ВидСравненияКомпоновкиДанных     - Вид сравнения. По умолчанию "ВидСравненияКомпоновкиДанных.Равно"
//  ПравоеЗначениеОтбора         - Произвольный                     - С чем сравнивать левое значение
//
// ВозвращаемоеЗначение:
//  ЭлементУсловногоОформления - Добавленный элемент оформления
Функция ДобавитьПростойЭлементУсловногоОформления(Форма, ОформляемоеПоле = Неопределено, 
	ИмяПараметраОформления = Неопределено, ЗначениеПараметраОформления = Неопределено, 
	ПутьКЛевомуЗначениюОтбора = Неопределено, ВидСравненияОтбора = Неопределено, ПравоеЗначениеОтбора = Неопределено) Экспорт
	
	//Добавляем элемент:
	ЭлементУсловногоОформления = Форма.УсловноеОформление.Элементы.Добавить();
	
	Если ЗначениеЗаполнено(ИмяПараметраОформления) Тогда
		ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра(ИмяПараметраОформления, ЗначениеПараметраОформления);
	КонецЕсли;
	
	Если НЕ ПутьКЛевомуЗначениюОтбора = Неопределено Тогда
		ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(ПутьКЛевомуЗначениюОтбора);
		ОтборЭлемента.ВидСравнения   = ?(ВидСравненияОтбора = Неопределено, ВидСравненияКомпоновкиДанных.Равно, ВидСравненияОтбора);
		ОтборЭлемента.ПравоеЗначение = ПравоеЗначениеОтбора;
	КонецЕсли;
	
	Если НЕ ОформляемоеПоле = Неопределено Тогда
		ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ОформляемоеПоле);
	КонецЕсли;

	Возврат ЭлементУсловногоОформления;
	
КонецФункции

#КонецОбласти

#Область ДинамическийСписок

////////////////////////////////////////////////////////////////////////////////
// Функции для работы с отборами и параметрами динамических списков.
//

// Найти элемент или группу отбора по заданному имени поля или представлению.
//
// Параметры:
//  ОбластьПоиска - ОтборКомпоновкиДанных
//                - КоллекцияЭлементовОтбораКомпоновкиДанных
//                - ГруппаЭлементовОтбораКомпоновкиДанных    - контейнер с элементами и группами отбора,
//                                                             например Список.Отбор или группа в отборе.
//  ИмяПоля       - Строка - имя поля компоновки (не используется для групп).
//  Представление - Строка - представление поля компоновки.
//
// Возвращаемое значение:
//  Массив - коллекция отборов.
//
Функция НайтиЭлементыИГруппыОтбора(Знач ОбластьПоиска,
									Знач ИмяПоля = Неопределено,
									Знач Представление = Неопределено) Экспорт
	
	Если ЗначениеЗаполнено(ИмяПоля) Тогда
		ЗначениеПоиска = Новый ПолеКомпоновкиДанных(ИмяПоля);
		СпособПоиска = 1;
	Иначе
		СпособПоиска = 2;
		ЗначениеПоиска = Представление;
	КонецЕсли;
	
	МассивЭлементов = Новый Массив;
	
	НайтиРекурсивно(ОбластьПоиска.Элементы, МассивЭлементов, СпособПоиска, ЗначениеПоиска);
	
	Возврат МассивЭлементов;
	
КонецФункции

// Добавить группу отбора в коллекцию КоллекцияЭлементов.
//
// Параметры:
//  КоллекцияЭлементов - ОтборКомпоновкиДанных
//                     - КоллекцияЭлементовОтбораКомпоновкиДанных
//                     - ГруппаЭлементовОтбораКомпоновкиДанных    - контейнер с элементами и группами отбора,
//                                                                  например Список.Отбор или группа в отборе.
//  Представление      - Строка - представление группы.
//  ТипГруппы          - ТипГруппыЭлементовОтбораКомпоновкиДанных - тип группы.
//
// Возвращаемое значение:
//  ГруппаЭлементовОтбораКомпоновкиДанных - группа отбора.
//
Функция СоздатьГруппуЭлементовОтбора(Знач КоллекцияЭлементов, Представление, ТипГруппы) Экспорт
	
	Если ТипЗнч(КоллекцияЭлементов) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных")
		Или ТипЗнч(КоллекцияЭлементов) = Тип("ОтборКомпоновкиДанных") Тогда
		
		КоллекцияЭлементов = КоллекцияЭлементов.Элементы;
	КонецЕсли;
	
	ГруппаЭлементовОтбора = НайтиЭлементОтбораПоПредставлению(КоллекцияЭлементов, Представление);
	Если ГруппаЭлементовОтбора = Неопределено Тогда
		ГруппаЭлементовОтбора = КоллекцияЭлементов.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	Иначе
		ГруппаЭлементовОтбора.Элементы.Очистить();
	КонецЕсли;
	
	ГруппаЭлементовОтбора.Представление    = Представление;
	ГруппаЭлементовОтбора.Применение       = ТипПримененияОтбораКомпоновкиДанных.Элементы;
	ГруппаЭлементовОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ГруппаЭлементовОтбора.ТипГруппы        = ТипГруппы;
	ГруппаЭлементовОтбора.Использование    = Истина;
	
	Возврат ГруппаЭлементовОтбора;
	
КонецФункции

// Добавить элемент компоновки в контейнер элементов компоновки.
//
// Параметры:
//  ОбластьДобавления - КоллекцияЭлементовОтбораКомпоновкиДанных - контейнер с элементами и группами отбора,
//                                                                 например, Список.Отбор или группа в отборе.
//  ИмяПоля                 - Строка - имя поля компоновки данных (заполняется всегда).
//  ВидСравнения            - ВидСравненияКомпоновкиДанных - вид сравнения.
//  ПравоеЗначение          - Произвольный - сравниваемое значение.
//  Представление           - Строка - представление элемента компоновки данных.
//  Использование           - Булево - использование элемента.
//  РежимОтображения        - РежимОтображенияЭлементаНастройкиКомпоновкиДанных - режим отображения.
//  ИдентификаторПользовательскойНастройки - Строка - см. ОтборКомпоновкиДанных.ИдентификаторПользовательскойНастройки
//                                                    в синтакс-помощнике.
// Возвращаемое значение:
//  ЭлементОтбораКомпоновкиДанных - элемент компоновки.
//
Функция ДобавитьЭлементКомпоновки(ОбластьДобавления,
									Знач ИмяПоля,
									Знач ВидСравнения,
									Знач ПравоеЗначение = Неопределено,
									Знач Представление  = Неопределено,
									Знач Использование  = Неопределено,
									знач РежимОтображения = Неопределено,
									знач ИдентификаторПользовательскойНастройки = Неопределено) Экспорт
	
	Элемент = ОбластьДобавления.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	Элемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяПоля);
	Элемент.ВидСравнения = ВидСравнения;
	
	Если РежимОтображения = Неопределено Тогда
		Элемент.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	Иначе
		Элемент.РежимОтображения = РежимОтображения;
	КонецЕсли;
	
	Если ПравоеЗначение <> Неопределено Тогда
		Элемент.ПравоеЗначение = ПравоеЗначение;
	КонецЕсли;
	
	Если Представление <> Неопределено Тогда
		Элемент.Представление = Представление;
	КонецЕсли;
	
	Если Использование <> Неопределено Тогда
		Элемент.Использование = Использование;
	КонецЕсли;
	
	// Важно: установка идентификатора должна выполняться
	// в конце настройки элемента, иначе он будет скопирован
	// в пользовательские настройки частично заполненным.
	Если ИдентификаторПользовательскойНастройки <> Неопределено Тогда
		Элемент.ИдентификаторПользовательскойНастройки = ИдентификаторПользовательскойНастройки;
	ИначеЕсли Элемент.РежимОтображения <> РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный Тогда
		Элемент.ИдентификаторПользовательскойНастройки = ИмяПоля;
	КонецЕсли;
	
	Возврат Элемент;
	
КонецФункции

// Изменить элемент отбора с заданным именем поля или представлением.
//
// Параметры:
//  ОбластьПоиска - КоллекцияЭлементовОтбораКомпоновкиДанных - контейнер с элементами и группами отбора,
//                                                             например Список.Отбор или группа в отборе.
//  ИмяПоля                 - Строка - имя поля компоновки данных (заполняется всегда).
//  Представление           - Строка - представление элемента компоновки данных.
//  ПравоеЗначение          - Произвольный - сравниваемое значение.
//  ВидСравнения            - ВидСравненияКомпоновкиДанных - вид сравнения.
//  Использование           - Булево - использование элемента.
//  РежимОтображения        - РежимОтображенияЭлементаНастройкиКомпоновкиДанных - режим отображения.
//  ИдентификаторПользовательскойНастройки - Строка - см. ОтборКомпоновкиДанных.ИдентификаторПользовательскойНастройки
//                                                    в синтакс-помощнике.
//
// Возвращаемое значение:
//  Число - количество измененных элементов.
//
Функция ИзменитьЭлементыОтбора(ОбластьПоиска,
								Знач ИмяПоля = Неопределено,
								Знач Представление = Неопределено,
								Знач ПравоеЗначение = Неопределено,
								Знач ВидСравнения = Неопределено,
								Знач Использование = Неопределено,
								Знач РежимОтображения = Неопределено,
								Знач ИдентификаторПользовательскойНастройки = Неопределено) Экспорт
	
	Если ЗначениеЗаполнено(ИмяПоля) Тогда
		ЗначениеПоиска = Новый ПолеКомпоновкиДанных(ИмяПоля);
		СпособПоиска = 1;
	Иначе
		СпособПоиска = 2;
		ЗначениеПоиска = Представление;
	КонецЕсли;
	
	МассивЭлементов = Новый Массив;
	
	НайтиРекурсивно(ОбластьПоиска.Элементы, МассивЭлементов, СпособПоиска, ЗначениеПоиска);
	
	Для Каждого Элемент Из МассивЭлементов Цикл
		Если ИмяПоля <> Неопределено Тогда
			Элемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяПоля);
		КонецЕсли;
		Если Представление <> Неопределено Тогда
			Элемент.Представление = Представление;
		КонецЕсли;
		Если Использование <> Неопределено Тогда
			Элемент.Использование = Использование;
		КонецЕсли;
		Если ВидСравнения <> Неопределено Тогда
			Элемент.ВидСравнения = ВидСравнения;
		КонецЕсли;
		Если ПравоеЗначение <> Неопределено Тогда
			Элемент.ПравоеЗначение = ПравоеЗначение;
		КонецЕсли;
		Если РежимОтображения <> Неопределено Тогда
			Элемент.РежимОтображения = РежимОтображения;
		КонецЕсли;
		Если ИдентификаторПользовательскойНастройки <> Неопределено Тогда
			Элемент.ИдентификаторПользовательскойНастройки = ИдентификаторПользовательскойНастройки;
		КонецЕсли;
	КонецЦикла;
	
	Возврат МассивЭлементов.Количество();
	
КонецФункции

// Удалить элементы отбора с заданным именем поля или представлением.
//
// Параметры:
//  ОбластьУдаления - КоллекцияЭлементовОтбораКомпоновкиДанных - контейнер с элементами и группами отбора,
//                                                               например, Список.Отбор или группа в отборе..
//  ИмяПоля         - Строка - имя поля компоновки (не используется для групп).
//  Представление   - Строка - представление поля компоновки.
//
Процедура УдалитьЭлементыГруппыОтбора(Знач ОбластьУдаления, Знач ИмяПоля = Неопределено, Знач Представление = Неопределено) Экспорт
	
	Если ЗначениеЗаполнено(ИмяПоля) Тогда
		ЗначениеПоиска = Новый ПолеКомпоновкиДанных(ИмяПоля);
		СпособПоиска = 1;
	Иначе
		СпособПоиска = 2;
		ЗначениеПоиска = Представление;
	КонецЕсли;
	
	МассивЭлементов = Новый Массив; // Массив из ЭлементОтбораКомпоновкиДанных, ГруппаЭлементовОтбораКомпоновкиДанных
	
	НайтиРекурсивно(ОбластьУдаления.Элементы, МассивЭлементов, СпособПоиска, ЗначениеПоиска);
	
	Для Каждого Элемент Из МассивЭлементов Цикл
		Если Элемент.Родитель = Неопределено Тогда
			ОбластьУдаления.Элементы.Удалить(Элемент);
		Иначе
			Элемент.Родитель.Элементы.Удалить(Элемент);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Добавить или заменить существующий элемент отбора.
//
// Параметры:
//  ОбластьПоискаДобавления - КоллекцияЭлементовОтбораКомпоновкиДанных - контейнер с элементами и группами отбора,
//                                     например, Список.Отбор или группа в отборе.
//  ИмяПоля                 - Строка - имя поля компоновки данных (заполняется всегда).
//  ПравоеЗначение          - Произвольный - сравниваемое значение.
//  ВидСравнения            - ВидСравненияКомпоновкиДанных - вид сравнения.
//  Представление           - Строка - представление элемента компоновки данных.
//  Использование           - Булево - использование элемента.
//  РежимОтображения        - РежимОтображенияЭлементаНастройкиКомпоновкиДанных - режим отображения.
//  ИдентификаторПользовательскойНастройки - Строка - см. ОтборКомпоновкиДанных.ИдентификаторПользовательскойНастройки
//                                                    в синтакс-помощнике.
//
Процедура УстановитьЭлементОтбора(ОбластьПоискаДобавления,
								Знач ИмяПоля,
								Знач ПравоеЗначение = Неопределено,
								Знач ВидСравнения = Неопределено,
								Знач Представление = Неопределено,
								Знач Использование = Неопределено,
								Знач РежимОтображения = Неопределено,
								Знач ИдентификаторПользовательскойНастройки = Неопределено) Экспорт
	
	ЧислоИзмененных = ИзменитьЭлементыОтбора(ОбластьПоискаДобавления, ИмяПоля, Представление,
							ПравоеЗначение, ВидСравнения, Использование, РежимОтображения, ИдентификаторПользовательскойНастройки);
	
	Если ЧислоИзмененных = 0 Тогда
		Если ВидСравнения = Неопределено Тогда
			Если ТипЗнч(ПравоеЗначение) = Тип("Массив")
				Или ТипЗнч(ПравоеЗначение) = Тип("ФиксированныйМассив")
				Или ТипЗнч(ПравоеЗначение) = Тип("СписокЗначений") Тогда
				ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
			Иначе
				ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
			КонецЕсли;
		КонецЕсли;
		Если РежимОтображения = Неопределено Тогда
			РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		КонецЕсли;
		ДобавитьЭлементКомпоновки(ОбластьПоискаДобавления, ИмяПоля, ВидСравнения,
								ПравоеЗначение, Представление, Использование, РежимОтображения, ИдентификаторПользовательскойНастройки);
	КонецЕсли;
	
КонецПроцедуры

// Добавить или заменить существующий элемент отбора динамического списка.
//
// Параметры:
//   ДинамическийСписок - ДинамическийСписок - список, в котором требуется установить отбор.
//   ИмяПоля            - Строка - поле, по которому необходимо установить отбор.
//   ПравоеЗначение     - Произвольный - значение отбора.
//       Необязательный. Значение по умолчанию Неопределено.
//       Внимание! Если передать Неопределено, то значение не будет изменено.
//   ВидСравнения  - ВидСравненияКомпоновкиДанных - условие отбора.
//   Представление - Строка - представление элемента компоновки данных.
//       Необязательный. Значение по умолчанию Неопределено.
//       Если указано, то выводится только флажок использования с указанным представлением (значение не выводится).
//       Для очистки (чтобы значение снова выводилось) следует передать пустую строку.
//   Использование - Булево - флажок использования этого отбора.
//       Необязательный. Значение по умолчанию: Неопределено.
//   РежимОтображения - РежимОтображенияЭлементаНастройкиКомпоновкиДанных - способ отображения этого отбора
//                                                                          пользователю:
//        РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ - в группе быстрых настроек над списком.
//        РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный       - в настройка списка (в подменю Еще).
//        РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный   - запретить пользователю менять этот отбор.
//   ИдентификаторПользовательскойНастройки - Строка - уникальный идентификатор этого отбора.
//       Используется для связи с пользовательскими настройками.
//
Процедура УстановитьЭлементОтбораДинамическогоСписка(ДинамическийСписок, ИмяПоля,
	ПравоеЗначение = Неопределено,
	ВидСравнения = Неопределено,
	Представление = Неопределено,
	Использование = Неопределено,
	РежимОтображения = Неопределено,
	ИдентификаторПользовательскойНастройки = Неопределено) Экспорт
	
	Если РежимОтображения = Неопределено Тогда
		РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	КонецЕсли;
	
	Если РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный Тогда
		ОтборДинамическогоСписка = ДинамическийСписок.КомпоновщикНастроек.ФиксированныеНастройки.Отбор;
	Иначе
		ОтборДинамическогоСписка = ДинамическийСписок.КомпоновщикНастроек.Настройки.Отбор;
	КонецЕсли;
	
	УстановитьЭлементОтбора(
		ОтборДинамическогоСписка,
		ИмяПоля,
		ПравоеЗначение,
		ВидСравнения,
		Представление,
		Использование,
		РежимОтображения,
		ИдентификаторПользовательскойНастройки);
	
КонецПроцедуры

// Удалить элемент группы отбора динамического списка.
//
// Параметры:
//  ДинамическийСписок - ДинамическийСписок - реквизит формы, для которого требуется установить отбор.
//  ИмяПоля         - Строка - имя поля компоновки (не используется для групп).
//  Представление   - Строка - представление поля компоновки.
//
Процедура УдалитьЭлементыГруппыОтбораДинамическогоСписка(ДинамическийСписок, ИмяПоля = Неопределено, Представление = Неопределено) Экспорт
	
	УдалитьЭлементыГруппыОтбора(
		ДинамическийСписок.КомпоновщикНастроек.ФиксированныеНастройки.Отбор,
		ИмяПоля,
		Представление);
	
	УдалитьЭлементыГруппыОтбора(
		ДинамическийСписок.КомпоновщикНастроек.Настройки.Отбор,
		ИмяПоля,
		Представление);
	
КонецПроцедуры

// Установить или обновить значение параметра ИмяПараметра динамического списка Список.
//
// Параметры:
//  Список          - ДинамическийСписок - реквизит формы, для которого требуется установить параметр.
//  ИмяПараметра    - Строка             - имя параметра динамического списка.
//  Значение        - Произвольный        - новое значение параметра.
//  Использование   - Булево             - признак использования параметра.
//
Процедура УстановитьПараметрДинамическогоСписка(Список, ИмяПараметра, Значение, Использование = Истина) Экспорт
	
	ЗначениеПараметраКомпоновкиДанных = Список.Параметры.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных(ИмяПараметра));
	Если ЗначениеПараметраКомпоновкиДанных <> Неопределено Тогда
		Если Использование И ЗначениеПараметраКомпоновкиДанных.Значение <> Значение Тогда
			ЗначениеПараметраКомпоновкиДанных.Значение = Значение;
		КонецЕсли;
		Если ЗначениеПараметраКомпоновкиДанных.Использование <> Использование Тогда
			ЗначениеПараметраКомпоновкиДанных.Использование = Использование;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ДинамическийСписок

Процедура НайтиРекурсивно(КоллекцияЭлементов, МассивЭлементов, СпособПоиска, ЗначениеПоиска)
	
	Для каждого ЭлементОтбора Из КоллекцияЭлементов Цикл
		
		Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			
			Если СпособПоиска = 1 Тогда
				Если ЭлементОтбора.ЛевоеЗначение = ЗначениеПоиска Тогда
					МассивЭлементов.Добавить(ЭлементОтбора);
				КонецЕсли;
			ИначеЕсли СпособПоиска = 2 Тогда
				Если ЭлементОтбора.Представление = ЗначениеПоиска Тогда
					МассивЭлементов.Добавить(ЭлементОтбора);
				КонецЕсли;
			КонецЕсли;
		Иначе
			
			НайтиРекурсивно(ЭлементОтбора.Элементы, МассивЭлементов, СпособПоиска, ЗначениеПоиска);
			
			Если СпособПоиска = 2 И ЭлементОтбора.Представление = ЗначениеПоиска Тогда
				МассивЭлементов.Добавить(ЭлементОтбора);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Выполняет поиск элемента отбора в коллекции по заданному представлению.
//
// Параметры:
//  КоллекцияЭлементов - КоллекцияЭлементовОтбораКомпоновкиДанных - контейнер с элементами и группами отбора,
//                                                                  например, Список.Отбор.Элементы или группа в отборе.
//  Представление - Строка - представление группы.
// 
// Возвращаемое значение:
//  ЭлементОтбораКомпоновкиДанных - элемент отбора.
//
Функция НайтиЭлементОтбораПоПредставлению(КоллекцияЭлементов, Представление) Экспорт
	
	ВозвращаемоеЗначение = Неопределено;
	
	Для каждого ЭлементОтбора Из КоллекцияЭлементов Цикл
		Если ЭлементОтбора.Представление = Представление Тогда
			ВозвращаемоеЗначение = ЭлементОтбора;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ВозвращаемоеЗначение
	
КонецФункции

#КонецОбласти

#КонецОбласти