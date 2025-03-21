﻿
#Область ОбработчикиСобытий

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	МассивНепроверяемыхРеквизитов.Добавить("ОсновнойРеквизитФормы");
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Остатки, "Организация",
		Организация, ВидСравненияКомпоновкиДанных.Равно, "ОтборОрганизация", ЗначениеЗаполнено(Организация));
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Остатки, "Подразделение",
		Подразделение, ВидСравненияКомпоновкиДанных.Равно, "ОтборПодразделение", ЗначениеЗаполнено(Подразделение));
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьДокументы(Команда)
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю("Не заполнена организация",,, "Организация");
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Подразделение) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю("Не заполнено подразделение",,, "Подразделение");
		Возврат;
	КонецЕсли;
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	СоздатьДокументыНаСервере(Элементы.Остатки.ВыделенныеСтроки);
	
КонецПроцедуры

&НаСервере
Функция СоздатьДокументыНаСервере(Знач ДанныеСтрок)
	
	Результат = Новый Массив;
	
	// Проверяем возможность запуска:
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат Результат;
	КонецЕсли;
	
	// Готовим данные:
	ТаблицаОтборов = Обработки.ФормированиеРеализаций.ТаблицаОтборов();
	Для Каждого ДанныеСтроки Из ДанныеСтрок Цикл
		ЗаполнитьЗначенияСвойств(ТаблицаОтборов.Добавить(), ДанныеСтроки);
	КонецЦикла;
	
	// Вызываем основной интерфейс:
	Результат = Обработки.ФормированиеРеализаций.СоздатьДокументы(ТаблицаОтборов);
	
	// Собираем информацию о результате:
	ПроведенныеДокументы = Новый Массив;
	Для Каждого ДокументОбъект Из Результат Цикл
		Если ДокументОбъект.Проведен Тогда
			ПроведенныеДокументы.Добавить(ДокументОбъект);
		КонецЕсли;
	КонецЦикла;

	Элементы.Остатки.Обновить(); // Перечитываем остатки

КонецФункции

#КонецОбласти