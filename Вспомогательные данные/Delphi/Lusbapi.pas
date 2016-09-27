// *****************************************************************************
// Головной файл c объявлениями констант, структур, функций и т.д. для работы
// с модулями производства компании ЗАО "L-Kard" в среде Borland Delphi 6.0.
// Поддерживаемые модули: E14-140, E14-440 и E20-10.
// *****************************************************************************

unit Lusbapi;

interface

uses
	windows;

// Общие константы
const
	NAME_LINE_LENGTH_LUSBAPI				=	25;
	COMMENT_LINE_LENGTH_LUSBAPI			=	256;
	ADC_CALIBR_COEFS_QUANTITY_LUSBAPI	=	128;
	DAC_CALIBR_COEFS_QUANTITY_LUSBAPI	=	128;

// Общие структуры и типы данных
type
	pBYTE			= ^BYTE;
	pSHORT		= ^SHORT;
	pWORD			= ^WORD;
	pDWORD		= ^DWORD;
	pOVERLAPPED = ^OVERLAPPED;

	// структура, содержащая информацию о версии драйвера DSP
	IO_REQUEST_LUSBAPI = packed record
		Buffer : pSHORT;			 							//	указатель на буфер данных
		NumberOfWordsToPass : DWORD;			 			// кол-во отсчётов, которые требуется передать
		NumberOfWordsPassed : DWORD;						// реальное кол-во переданных отсчётов
		Overlapped : pOVERLAPPED;							// для асинхроннного запроса - указатель на структура типа OVERLAPPED
		TimeOut : DWORD;										// для синхронного запроса - таймаут в мс
	end;
	pIO_REQUEST_LUSBAPI = ^IO_REQUEST_LUSBAPI;

	// структура с информацией об последней ошибке выполнения библиотеки
	LAST_ERROR_INFO_LUSBAPI = packed record
		ErrorString : array [0..255] of BYTE;			// строка с последней ошибкой
		ErrorNumber : DWORD;	  								// номер последней ошибки
	end;
	pLAST_ERROR_INFO_LUSBAPI = ^LAST_ERROR_INFO_LUSBAPI;

	// информация о ПО, работающем в испольнительном устройстве: MCU, DSP, PLD и т.д.
	VERSION_INFO_LUSBAPI = packed record
		Version : array [0..9] of BYTE;				  	// версия ПО для испольнительного устройства
		Date : array [0..13] of BYTE;					  	// дата сборки ПО
		Manufacturer : array [0..(NAME_LINE_LENGTH_LUSBAPI-1)] of BYTE;	// производитель ПО
		Author : array [0..(NAME_LINE_LENGTH_LUSBAPI-1)] of BYTE;	  		// автор ПО
		Comment : array [0..(COMMENT_LINE_LENGTH_LUSBAPI-1)] of BYTE;		// строка комментария
	end;

	// информация о ПО MCU, которая включает в себя информацию о прошивках
	// как основной программы, так и загрузчика
	MCU_VERSION_INFO_LUSBAPI = packed record
		FwVersion : VERSION_INFO_LUSBAPI;				// информация о версии прошивки основной программы 'Приложение'(Application) микроконтроллера
		BlVersion : VERSION_INFO_LUSBAPI;				// информация о версии прошивки 'Загрузчика'(BootLoader) микроконтроллера
	end;

	// общая информация о модуле
	MODULE_INFO_LUSBAPI = packed record
		CompanyName : array [0..(NAME_LINE_LENGTH_LUSBAPI-1)] of BYTE;		// название фирмы-изготовителя изделия
		DeviceName : array [0..(NAME_LINE_LENGTH_LUSBAPI-1)] of BYTE; 		// название изделия
		SerialNumber : array [0..15] of BYTE;			// серийный номер изделия
		Revision : BYTE;										// ревизия изделия (латинская литера)
		Modification : BYTE;									// исполнение модуля (число);
		Comment : array [0..(COMMENT_LINE_LENGTH_LUSBAPI-1)] of BYTE;		// строка комментария
	end;

	// информация о DSP
	DSP_INFO_LUSBAPI = packed record
		Active : BOOL;											// флаг достоверности остальных полей структуры
		Name : array [0..(NAME_LINE_LENGTH_LUSBAPI-1)] of BYTE;				// название DSP
		ClockRate : double;									// тактовая частота работы DSP в кГц
		Version : VERSION_INFO_LUSBAPI;					// информация о драйвере DSP
		Comment : array [0..(COMMENT_LINE_LENGTH_LUSBAPI-1)] of BYTE;		// строка комментария
	end;

	// информация о микроконтроллере (без 'Загрузчика')
	MCU_INFO_LUSBAPI = packed record
		Active : BOOL;										  	// флаг достоверности остальных полей структуры
		Name : array [0..(NAME_LINE_LENGTH_LUSBAPI-1)] of BYTE;				// название микроконтроллера
		ClockRate : double;								  	// тактовая частота работы микроконтроллера в кГц
		Version : VERSION_INFO_LUSBAPI;				  	// информация о версии прошивки микроконтроллера
		Comment : array [0..(COMMENT_LINE_LENGTH_LUSBAPI-1)] of BYTE;		// строка комментария
	end;

	// информация о микроконтроллере (включая 'Загрузчик')
	MCU1_INFO_LUSBAPI = packed record
		Active : BOOL;										  	// флаг достоверности остальных полей структуры
		Name : array [0..(NAME_LINE_LENGTH_LUSBAPI-1)] of BYTE;				// название микроконтроллера
		ClockRate : double;								  	// тактовая частота работы микроконтроллера в кГц
		Version : MCU_VERSION_INFO_LUSBAPI;		 	  	// информация о версии как самой прошивки микроконтроллера, так и прошивки 'Загрузчика'
		Comment : array [0..(COMMENT_LINE_LENGTH_LUSBAPI-1)] of BYTE;		// строка комментария
	end;

	// информация о ПЛИС (PLD)
	PLD_INFO_LUSBAPI = packed record				 		// PLD - Programmable Logic Device
		Active : BOOL;									 		// флаг достоверности остальных полей структуры
		Name : array [0..(NAME_LINE_LENGTH_LUSBAPI-1)] of BYTE;		  		// название ПЛИС
		ClockRate : double;							 		// тактовая чатота работы ПЛИС в кГц
		Version : VERSION_INFO_LUSBAPI;			  		// информация о версии прошивки ПЛИС
		Comment : array [0..(COMMENT_LINE_LENGTH_LUSBAPI-1)] of BYTE;		// строка комментария
	end;

	// информация о АЦП
	ADC_INFO_LUSBAPI = packed record
		Active : BOOL;									 		// флаг достоверности остальных полей структуры
		Name : array [0..(NAME_LINE_LENGTH_LUSBAPI-1)] of BYTE;				// название микросхемы АЦП
		OffsetCalibration : array [0..(ADC_CALIBR_COEFS_QUANTITY_LUSBAPI-1)] of double;	// корректировочные коэффициенты смещения нуля
		ScaleCalibration : array [0..(ADC_CALIBR_COEFS_QUANTITY_LUSBAPI-1)] of double; 	// корректировочные коэффициенты масштаба
		Comment : array [0..(COMMENT_LINE_LENGTH_LUSBAPI-1)] of BYTE;		// строка комментария
	end;

	// информация о ЦАП
	DAC_INFO_LUSBAPI = packed record
		Active : BOOL;									 		// флаг достоверности остальных полей структуры
		Name : array [0..(NAME_LINE_LENGTH_LUSBAPI-1)] of BYTE;				// название микросхемы ЦАП
		OffsetCalibration : array [0..(DAC_CALIBR_COEFS_QUANTITY_LUSBAPI-1)] of double;	// корректировочные коэффициенты
		ScaleCalibration : array [0..(DAC_CALIBR_COEFS_QUANTITY_LUSBAPI-1)] of double;  	// корректировочные коэффициенты
		Comment : array [0..(COMMENT_LINE_LENGTH_LUSBAPI-1)] of BYTE;		// строка комментария
	end;

	// информация о цифрового ввода-вывода
	DIGITAL_IO_INFO_LUSBAPI = packed record
		Active : BOOL;											// флаг достоверности остальных полей структуры
		Name : array [0..(NAME_LINE_LENGTH_LUSBAPI-1)] of BYTE;				// название цифровой микросхемы
		InLinesQuantity : WORD;	 							// кол-во входных линий
		OutLinesQuantity : WORD; 							// кол-во выходных линий
		Comment : array [0..(COMMENT_LINE_LENGTH_LUSBAPI-1)] of BYTE;		// строка комментария
	end;

	// информация о используемого интерфейса для доступа к модулю
	INTERFACE_INFO_LUSBAPI = packed record
		Active : BOOL;										 	// флаг достоверности остальных полей структуры
		Name : array [0..(NAME_LINE_LENGTH_LUSBAPI-1)] of BYTE;			 	// название
		Comment : array [0..(COMMENT_LINE_LENGTH_LUSBAPI-1)] of BYTE;		// строка комментария
	end;

// объявления интерфейса Lusbbase
{$I 'Lusbbase.pas'}
// объявления интерфейса для модуля E14-140
{$I 'E140.pas'}
// объявления интерфейса для модуля E-154
{$I 'E154.pas'}
// объявления интерфейса для модуля E-310
{$I 'E310.pas'}
// объявления интерфейса для модуля E14-440
{$I 'E440.pas'}
// объявления интерфейса для модуля E20-10
{$I 'E2010.pas'}

const
	// текущая версия штатной библиотеки Lusbapi.dll
	VERSION_MAJOR_LUSBAPI 			=	($03);
	VERSION_MINOR_LUSBAPI 			=	($04);
	CURRENT_VERSION_LUSBAPI			=	((VERSION_MAJOR_LUSBAPI shl 16) or VERSION_MINOR_LUSBAPI);

	// возможные индексы скорости работы модуля на шине USB
	USB11_LUSBAPI						=	($00);
	USB20_LUSBAPI						=	($01);
	INVALID_USB_SPEED_LUSBAPI		=	($02);

	// полное отсутствме модификиций изделия
	NO_MODULE_MODIFICATION_LUSBAPI = -1;

	// максимально возможное кол-во опрашиваемых виртуальных слотов
	MAX_VIRTUAL_SLOTS_QUANTITY_LUSBAPI	= 127;

// объявление экспортируемых из Lusbapi.dll функций
Function GetDllVersion : DWORD; stdcall;
Function CreateLInstance(DeviceName : pAnsiChar) : Pointer; stdcall;

implementation
	Function GetDllVersion : DWORD; External 'Lusbapi.dll'
	Function CreateLInstance(DeviceName : pAnsiChar) : Pointer; External 'Lusbapi.dll'
end.

