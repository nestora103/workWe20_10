// *****************************************************************************
// ******************  М о д у л ь    E 2 0 - 1 0  *****************************
// *****************************************************************************

// Константы
const
	// индексы доступных источников импульса старта сбора данных
	INT_ADC_START_E2010							=	($00);
	INT_ADC_START_WITH_TRANS_E2010			=	($01);
	EXT_ADC_START_ON_RISING_EDGE_E2010	 	=	($02);
	EXT_ADC_START_ON_FALLING_EDGE_E2010		=	($03);
	INVALID_ADC_START_E2010						=	($04);

	// индексы доступных источников тактовых импульсов для АЦП
	INT_ADC_CLOCK_E2010							=	($00);
	INT_ADC_CLOCK_WITH_TRANS_E2010			=	($01);
	EXT_ADC_CLOCK_ON_RISING_EDGE_E2010	 	=	($02);
	EXT_ADC_CLOCK_ON_FALLING_EDGE_E2010		=	($03);
	INVALID_ADC_CLOCK_E2010						=	($04);

	// возможные типы аналоговой синхронизации ввода данных (для Rev.B и выше)
	NO_ANALOG_SYNCHRO_E2010					 		=	($00); 	// отсутствие аналоговой синхронизации
	ANALOG_SYNCHRO_ON_RISING_CROSSING_E2010	=	($01);	// аналоговая синхронизация по переходу снизу-вверх
   ANALOG_SYNCHRO_ON_FALLING_CROSSING_E2010	=	($02);	// аналоговая синхронизация по переходу сверху-вниз
	ANALOG_SYNCHRO_ON_HIGH_LEVEL_E2010			=	($03);	// аналоговая синхронизация по уровню выше
   ANALOG_SYNCHRO_ON_LOW_LEVEL_E2010			=	($04);	// аналоговая синхронизация по уровню ниже
	INVALID_ANALOG_SYNCHRO_E2010					=	($05);

	// индексы доступных диапазонов входного напряжения модуля E20-10
	ADC_INPUT_RANGE_3000mV_E2010				=	($00);
	ADC_INPUT_RANGE_1000mV_E2010				=	($01);
	ADC_INPUT_RANGE_300mV_E2010				=	($02);
	INVALID_ADC_INPUT_RANGE_E2010				=	($03);

	// индексы возможных типов подключения входного тракта модуля E20-10
	ADC_INPUT_ZERO_E2010							=	($00);
	ADC_INPUT_SIGNAL_E2010					 	=	($01);
	INVALID_ADC_INPUT_E2010						=	($02);

	// возможные индексы для управления входным током смещения модуля E20-10 (для Rev.B и выше)
	INPUT_CURRENT_OFF_E2010						=	($00);
	INPUT_CURRENT_ON_E2010						=	($01);
	INVALID_INPUT_CURRENT_E2010				=	($02);

	// возможные режимы фиксации факта перегрузки входных каналов при сборе данных (только для Rev.A)
	CLIPPING_OVERLOAD_E2010		 				=	($00);
   MARKER_OVERLOAD_E2010		 				=	($01);
   INVALID_OVERLOAD_E2010		 				=	($02);

	// доступные номера битов ошибок при выполнении сбора данных с АЦП
		// поле BufferOverrun структуры DATA_STATE_E2010
		BUFFER_OVERRUN_E2010	 					=	($00);	// переполнение внутреннего буфера модуля
		// поле ChannelsOverFlow структуры DATA_STATE_E2010
		OVERFLOW_OF_CHANNEL_1_E2010	 		=	($00);	// локальные признаки переполнения
	   OVERFLOW_OF_CHANNEL_2_E2010			=	($01);	// разрядной сетки соответствующего канала
	   OVERFLOW_OF_CHANNEL_3_E2010	 		=	($03);	// за время выполнения одного запроса
	   OVERFLOW_OF_CHANNEL_4_E2010	 		=	($04);	// сбора данных ReadData()
		OVERFLOW_E2010	 							=	($07);	// глобальный признак факта переполнения разрядной сетки
																		// модуля за всё время сбора данных от момента START_ADC() до STOP_ADC()

	// доступные константы для задания тестовых режимов работы модуля E20-10 (для Rev.B и выше)
	// используются в функции TEST_MODULE()   
	NO_TEST_MODE_E2010	 						=	($00); 	// не задействовано никаких тестовых режимов
   TEST_MODE_1_E2010		 						=	($01); 	// тестовый режим, при котором после START_ADC() данные с АЦП
																		// подменяются обычным натуральным рядом: 0, 1, 2, 3, ...

	// индексы возможных опции наличия микросхемы ЦАП
	DAC_INACCESSIBLED_E2010						=	($00);
	DAC_ACCESSIBLED_E2010						=	($01);
	INVALID_DAC_OPTION_E2010					=	($02);

	// индексы доступных ревизий модуля E20-10
	REVISION_A_E2010								=	($00);
	REVISION_B_E2010								=	($01);
	INVALID_REVISION_E2010						=	($02);

	// доступные индексы модификиций модуля E20-10
	BASE_MODIFICATION_E2010						=	($00);	// полоса входных частот 1.25 МГц
	F5_MODIFICATION_E2010						=	($01);	// полоса входных частот 5.00 МГц
	INVALID_MODIFICATION_E2010					=	($02);

	// константы для работы с модулем
	MAX_CONTROL_TABLE_LENGTH_E2010 			=	(256);
	ADC_CHANNELS_QUANTITY_E2010				=	($04);
	ADC_INPUT_RANGES_QUANTITY_E2010			=	(INVALID_ADC_INPUT_RANGE_E2010);
	ADC_INPUT_TYPES_QUANTITY_E2010			=	(INVALID_ADC_INPUT_E2010);
	ADC_CALIBR_COEFS_QUANTITY_E2010			=	(ADC_CHANNELS_QUANTITY_E2010 * ADC_INPUT_RANGES_QUANTITY_E2010);
	DAC_CHANNELS_QUANTITY_E2010				=	($02);
	DAC_CALIBR_COEFS_QUANTITY_E2010			=	(DAC_CHANNELS_QUANTITY_E2010);
	TTL_LINES_QUANTITY_E2010					=	($10);	// кол-во входных и выходных цифровых линий
	USER_FLASH_SIZE_E2010 						=	($200);	// размер области пользовательского ППЗУ в байтах
	REVISIONS_QUANTITY_E2010 					=	(INVALID_REVISION_E2010);	// кол-во ревизий (модификаций) модуля
	ADC_PLUS_OVERLOAD_MARKER_E2010			=	($5FFF);	// признак 'плюс' перегрузки отсчёта с АЦП (только для Rev.A)
	ADC_MINUS_OVERLOAD_MARKER_E2010			=	($A000);	// признак 'минус' перегрузки отсчёта с АЦП (только для Rev.A)

	// диапазоны входного напряжения АЦП в В
	ADC_INPUT_RANGES_E2010 : array [0..(ADC_INPUT_RANGES_QUANTITY_E2010-1)]  of double =	( 3.0, 1.0, 0.3 );
	// диапазоны выходного напряжения ЦАП в В
	DAC_OUTPUT_RANGE_E2010	  					=	5.0;
	// доступные ревизии модуля
	REVISIONS_E2010 : array [0..(REVISIONS_QUANTITY_E2010-1)] of char = ( 'A', 'B' );


// Типы
type
	// структура с информацией об модуле E20-10
	MODULE_DESCRIPTION_E2010 = packed record
		Module 		: MODULE_INFO_LUSBAPI;		  	// общая информация о модуле
		DevInterface	: INTERFACE_INFO_LUSBAPI;	// информация об используемом устройстром интерфейсе
		Mcu			: MCU1_INFO_LUSBAPI;				// информация о микроконтроллере (включая 'Загрузчик')
		Pld			: PLD_INFO_LUSBAPI;				// информация о ПЛИС
		Adc			: ADC_INFO_LUSBAPI;				// информация о АЦП
		Dac			: DAC_INFO_LUSBAPI;				// информация о ЦАП
		DigitalIo	: DIGITAL_IO_INFO_LUSBAPI;		// информация о цифровом вводе-выводе
	end;
	pMODULE_DESCRIPTION_E2010 = ^MODULE_DESCRIPTION_E2010;

	// структура пользовательского ППЗУ
	USER_FLASH_E2010 = packed record
		Buffer : array [0..(USER_FLASH_SIZE_E2010-1)] of BYTE;
	end;
	pUSER_FLASH_E2010 = ^USER_FLASH_E2010;

	// структура с параметрами синхронизации ввода данных с АЦП
	SYNCHRO_PARS_E2010 = packed record
		StartSource		: WORD;				  	// тип и источник сигнала начала сбора данных с АЦП (внутренний или внешний и т.д.)
		StartDelay		: DWORD;					// задержка старта сбора данных в кадрах отсчётов c АЦП (для Rev.B и выше)
		SynhroSource	: WORD;					// источник тактовых импульсов запуска АЦП (внутренние или внешние и т.д.)
		StopAfterNKadrs: DWORD;					// останов сбора данных после задаваемого здесь кол-ва собранных кадров отсчётов АЦП (для Rev.B и выше)
		SynchroAdMode	: WORD;   				// режим аналоговой сихронизации: переход или уровень (для Rev.B и выше)
		SynchroAdChannel	: WORD;				// физический канал АЦП для аналоговой синхронизации (для Rev.B и выше)
		SynchroAdPorog		: SHORT;				// порог срабатывания при аналоговой синхронизации (для Rev.B и выше)
		IsBlockDataMarkerEnabled : BYTE;		// маркирование начала блока данных (удобно, например, при аналоговой синхронизации ввода по уровню) (для Rev.B и выше)
	end;

	// структура параметров работы АЦП для модуля E20-10
	ADC_PARS_E2010 = packed record
		IsAdcCorrectionEnabled : BOOL;		// управление разрешением автоматической корректировкой получаемых данных на уровне модуля (для Rev.B и выше)
		OverloadMode : WORD;	  					// режим фиксации факта перегрузки входных каналов модуля (только для Rev.A)
		InputCurrentControl: WORD;				// управление входным током смещения (для Rev.B и выше)
		SynchroPars : SYNCHRO_PARS_E2010;	// параметры синхронизации ввода данных с АЦП
		ChannelsQuantity : WORD; 		// число активных логических каналов
		ControlTable : array [0..(MAX_CONTROL_TABLE_LENGTH_E2010-1)] of WORD;	// управляющая таблица с активными логическими каналами
		InputRange : array [0..(ADC_CHANNELS_QUANTITY_E2010-1)] of WORD;	// индекс диапазона входного напряжения: 3.0В, 1.0В или 0.3В
		InputSwitch : array [0..(ADC_CHANNELS_QUANTITY_E2010-1)] of WORD;	// индекс типа входа канала АЦП: земля или сигнал
		AdcRate : double;	  		 		// тактовая частота АЦП в кГц
		InterKadrDelay : double; 		// межкадровая задержка в мс
		KadrRate : double;		 		// частота кадра в кГц
		AdcOffsetCoefs : array [0..(ADC_INPUT_RANGES_QUANTITY_E2010-1)] of array[0..(ADC_CHANNELS_QUANTITY_E2010-1)] of double;	// корректировочные коэффициенты смещение	АЦП: (3 диапазона)*(4 канала) (для Rev.B и выше)
		AdcScaleCoefs	: array [0..(ADC_INPUT_RANGES_QUANTITY_E2010-1)] of array[0..(ADC_CHANNELS_QUANTITY_E2010-1)] of double;	// корректировочные коэффициенты масштаба АЦП: (3 диапазона)*(4 канала) (для Rev.B и выше)
	end;
	pADC_PARS_E2010 = ^ADC_PARS_E2010;

	// структура с информацией о текущем состоянии процесса сбора данных
	DATA_STATE_E2010 = packed record
		ChannelsOverFlow : BYTE;				// битовые признаки перегрузки входных аналоговых каналов модуля
		BufferOverrun : BYTE;					// битовые признаки переполнения внутреннего буфера модуля
		CurBufferFilling : DWORD;				// заполненность внутреннего буфера модуля, в отсчётах
		MaxOfBufferFilling : DWORD;			// за время сбора максимальная заполненность внутреннего буфера модуля, в отсчётах
		BufferSize : DWORD;						// размер внутреннего буфера модуля, в отсчётах
		CurBufferFillingPercent : double;	// текущая степень заполнения внутреннего буфера модуля, в %
		MaxOfBufferFillingPercent : double;	// за время сбора максимальная степень заполнения внутреннего буфера модуля, в %
	end;
	pDATA_STATE_E2010 = ^DATA_STATE_E2010;

// интерфейс модуля E20-10
ILE2010 = class(Lusbbase)
  public
		// загрузка ПЛИС модуля
		Function LOAD_MODULE(FileName : pAnsiChar = nil) : BOOL; virtual; stdcall; abstract;
		Function TEST_MODULE(TestModeMask : WORD = 0) : BOOL; virtual; stdcall; abstract;

		// функции для работы с АЦП
		Function GET_ADC_PARS(ap : pADC_PARS_E2010) : BOOL; virtual; stdcall; abstract;
		Function SET_ADC_PARS(ap : pADC_PARS_E2010) : BOOL; virtual; stdcall; abstract;
		Function START_ADC : BOOL; virtual; stdcall; abstract;
		Function STOP_ADC : BOOL; virtual; stdcall; abstract;
		Function GET_DATA_STATE(DataState : pDATA_STATE_E2010) : BOOL; virtual; stdcall; abstract;
		Function ReadData(ReadRequest : pIO_REQUEST_LUSBAPI) : BOOL; virtual; stdcall; abstract;

		// функции для работы с ЦАП
		Function DAC_SAMPLE(DacData : pSHORT; DacChannel : WORD) : BOOL; virtual; stdcall; abstract;

		// функции для работы с цифровыми линиями
		Function ENABLE_TTL_OUT(EnableTtlOut : BOOL) : BOOL; virtual; stdcall; abstract;
		Function TTL_IN(TtlIn : pWORD) : BOOL; virtual; stdcall; abstract;
		Function TTL_OUT(TtlOut : WORD) : BOOL; virtual; stdcall; abstract;

		// функции для работы с пользовательской информацией ППЗУ
		Function ENABLE_FLASH_WRITE(IsUserFlashWriteEnabled : BOOL) : BOOL; virtual; stdcall; abstract;
		Function READ_FLASH_ARRAY(UserFlash : pUSER_FLASH_E2010) : BOOL; virtual; stdcall; abstract;
		Function WRITE_FLASH_ARRAY(UserFlash : pUSER_FLASH_E2010) : BOOL; virtual; stdcall; abstract;

		// функции для работы со служебной информацией из ППЗУ
		Function GET_MODULE_DESCRIPTION(ModuleDescription : pMODULE_DESCRIPTION_E2010) : BOOL; virtual; stdcall; abstract;
		Function SAVE_MODULE_DESCRIPTION(ModuleDescription : pMODULE_DESCRIPTION_E2010) : BOOL; virtual; stdcall; abstract;
	end;
	pILE2010 = ^ILE2010;

