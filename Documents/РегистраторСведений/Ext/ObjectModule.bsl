﻿

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	ОтразитьДвиженияТестовыйРегистр(Отказ);
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	Для Каждого КоллекцияДвижений Из Движения Цикл
		КоллекцияДвижений.Записывать = Истина;
		КоллекцияДвижений.Очистить();
	КонецЦикла;
	
	Движения.Записать();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОтразитьДвиженияТестовыйРегистр(Отказ)
	
	Движения.ТестовыйРегистр.Записывать = Истина;
	Движение = Движения.ТестовыйРегистр.Добавить();
	Движение.Период = Дата;
	Движение.Организация = Организация;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли






