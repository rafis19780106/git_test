﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ТаблицаОтборов() Экспорт
	
	ТаблицаОтборов = Новый ТаблицаЗначений;
	ТаблицаОтборов.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТаблицаОтборов.Колонки.Добавить("Склад",        Новый ОписаниеТипов("СправочникСсылка.Склады"));
	
	Возврат ТаблицаОтборов;
	
КонецФункции

Функция СоздатьДокументы(ТаблицаОтборов) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаОтборов.Номенклатура КАК Номенклатура,
	|	ТаблицаОтборов.Склад КАК Склад
	|ПОМЕСТИТЬ ТаблицаОтборов
	|ИЗ
	|	&ТаблицаОтборов КАК ТаблицаОтборов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТоварыНаСкладахОстатки.Склад.Организация КАК Организация,
	|	ТоварыНаСкладахОстатки.Номенклатура КАК Номенклатура,
	|	ТоварыНаСкладахОстатки.Склад КАК Склад,
	|	ТоварыНаСкладахОстатки.КоличествоОстаток КАК Количество
	|ИЗ
	|	РегистрНакопления.ТоварыНаСкладах.Остатки(
	|			,
	|			(Номенклатура, Склад) В
	|				(ВЫБРАТЬ
	|					ТаблицаОтборов.Номенклатура,
	|					ТаблицаОтборов.Склад
	|				ИЗ
	|					ТаблицаОтборов)) КАК ТоварыНаСкладахОстатки
	|
	|УПОРЯДОЧИТЬ ПО
	|	Организация";
	
	Запрос.УстановитьПараметр("ТаблицаОтборов", ТаблицаОтборов);
	ТаблицаОстатков = Запрос.Выполнить().Выгрузить();
	МассивТаблиц = ОбеспечениеСервер.РазбитьТаблицуПоЗначениюКлюча(ТаблицаОстатков, "Организация");
	
	Результат = Новый Массив;
	
	Для Каждого Элемент Из МассивТаблиц Цикл
		ДанныеЗаполнения = Элемент.Ключ;
		ДанныеЗаполнения.Вставить("Товары", Элемент.Таблица); 
		
		Документ = ЗаполнитьИПровестиДокумент(ДанныеЗаполнения);
		Результат.Добавить(Документ);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Заполняет и проводит документ созданный обработкой.
//
Функция ЗаполнитьИПровестиДокумент(ДанныеЗаполнения)
	
	ДокументОбъект = Документы.РеализацияТоваровИУслуг.СоздатьДокумент();
	ДанныеЗаполнения.Вставить("Дата", ТекущаяДатаСеанса());
	
	ДокументОбъект.Заполнить(ДанныеЗаполнения);
	
	ЗаписатьДокумент(ДокументОбъект);
	
	Возврат ДокументОбъект;
	
КонецФункции

Процедура ЗаписатьДокумент(ДокументОбъект)
	
	ОшибокНеОбнаружено = ДокументОбъект.ПроверитьЗаполнение();
	
	Если Не ОшибокНеОбнаружено Тогда
		
		ДокументОбъект.Записать(РежимЗаписиДокумента.Запись);
		
	Иначе //нет ошибок, проводим документ
		
		Попытка
			
			ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
			
		Исключение
			
			ДокументОбъект.Записать(РежимЗаписиДокумента.Запись);
			ЗаписьЖурналаРегистрации("Создание реализаций", УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли