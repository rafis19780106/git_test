﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ЗаполнитьДокументПоОтбору(ДанныеЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	// Нестандартные проверки реквизитов:
	МассивНепроверяемыхРеквизитов.Добавить("Товары.Склад");
	ПроверкиКорректностиДанных.ПроверитьКорректностьЗаполненияДокумента(ЭтотОбъект, Отказ);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	Для Каждого КоллекцияДвижений Из Движения Цикл
		КоллекцияДвижений.Записывать = Истина;
		КоллекцияДвижений.Очистить();
	КонецЦикла;
	
	Движения.Записать();
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
	
	ОтразитьДвиженияТоварыНаСкладах(Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Процедура ОтразитьДвиженияТоварыНаСкладах(Отказ)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	&Период КАК Период,
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Склад КАК Склад,
	|	Товары.Количество КАК Количество
	|ИЗ
	|	Документ.ПриобретениеТоваровИУслуг.Товары КАК Товары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
	|		ПО Товары.Номенклатура = СправочникНоменклатура.Ссылка
	|			И (СправочникНоменклатура.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар))
	|ГДЕ
	|	Товары.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Период", Дата);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Движения.ТоварыНаСкладах.Записывать = Истина;
	
	Пока Выборка.Следующий() Цикл
		Движение = Движения.ТоварыНаСкладах.ДобавитьПриход();
		ЗаполнитьЗначенияСвойств(Движение, Выборка);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ИнициализацияИЗаполнение

Процедура ЗаполнитьДокументПоОтбору(Знач ДанныеЗаполнения)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	
	Если ДанныеЗаполнения.Свойство("Номенклатура") Тогда
		Для Каждого Номенклатура Из ДанныеЗаполнения.Номенклатура Цикл
			Товары.Добавить().Номенклатура = Номенклатура;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли




