// *****************************************************************************
// *********************  М о д у л ь    E - 3 1 0  ****************************
// *****************************************************************************

// Константы
const
	// -============= генератор ==============-
	// типы циклического автосканирования по частоте для генератора
	NO_CYCLIC_AUTOSCAN_E310							=	($00);
	CYCLIC_PILA_AUTO_SCAN_E310						=	($01);
	CYCLIC_TRIANGLE_AUTO_SCAN_E310				=	($02);
	INVALID_CYCLIC_AUTOSCAN_TYPE_E310			=	($03);

	// типы приращений частоты генератора
	WAVEFORM_CYCLE_INCREMENT_INTERVAL_E310		=	($00);
	CLOCK_PERIOD_INCREMENT_INTERVAL_E310		=	($01);
	INVALID_INCREMENT_INTERVAL_TYPE_E310		=	($02);

	// доступные индексы умножителя приращений частоты генератора
	INCREMENT_INTERVAL_MULTIPLIERS_001_E310	=	($00);
	INCREMENT_INTERVAL_MULTIPLIERS_005_E310	=	($01);
	INCREMENT_INTERVAL_MULTIPLIERS_100_E310	=	($02);
	INCREMENT_INTERVAL_MULTIPLIERS_500_E310	=	($03);
	INVALID_INCREMENT_INTERVAL_MULTIPLIER_E310=	($04);

	// доступные индексы источника тактирующих импульсов для генератора
	INTERNAL_MASTER_CLOCK_E310						=	($00);
	EXTERNAL_MASTER_CLOCK_E310						=	($01);
	INVALID_MASTER_CLOCK_SOURCE_E310				=	($02);

	// возможные типы инкрементации частоты генератора
	AUTO_INCREMENT_E310								=	($00);
	CTRL_LINE_INCREMENT_E310						=	($01);
	INVALID_INCREMENT_TYPE_E310					=	($02);

	// возможные типы линии CTRL
	INTERNAL_CTRL_LINE_E310							=	($00);
	EXTERNAL_CTRL_LINE_E310							=	($01);
	INVALID_CTRL_LINE_TYPE_E310					=	($02);

	// возможные типы линии INTERRUPT
	INTERNAL_INTERRUPT_LINE_E310					=	($00);
	EXTERNAL_INTERRUPT_LINE_E310					=	($01);
	INVALID_INTERRUPT_LINE_TYPE_E310				=	($02);

	// возможные типы формирования выходного синхросигнала на линии "SYNCOUT"
	SYNCOUT_ON_EACH_INCREMENT_E310				=	($00);
	SYNCOUT_AT_END_OF_SCAN_E310					=	($01);
	INVALID_SYNCOUT_TYPES_E310						=	($02);

	// доступные типы аналоговых выходных сигналов
	TRIANGULAR_ANALOG_OUTPUT_E310					=	($00);
	SINUSOIDAL_ANALOG_OUTPUT_E310					=	($01);
	INVALID_ANALOG_OUTPUT_TYPE_E310				=	($02);

	// доступные индексы усиления выходного тракта генератора
	ANALOG_OUTPUT_GAIN_PLUS_10_DB_E310			=	($00);
	ANALOG_OUTPUT_GAIN_PLUS_06_DB_E310			=	($01);
	ANALOG_OUTPUT_GAIN_PLUS_04_DB_E310			=	($02);
	ANALOG_OUTPUT_GAIN_PLUS_03_DB_E310			=	($03);
	ANALOG_OUTPUT_GAIN_00_DB_E310					=	($04);
	ANALOG_OUTPUT_GAIN_MINUS_02_DB_E310			=	($05);
	ANALOG_OUTPUT_GAIN_MINUS_03_DB_E310			=	($06);
	ANALOG_OUTPUT_GAIN_MINUS_06_DB_E310			=	($07);
	ANALOG_OUTPUT_GAIN_MINUS_09_DB_E310			=	($08);
	ANALOG_OUTPUT_GAIN_MINUS_12_DB_E310			=	($09);
	ANALOG_OUTPUT_GAIN_MINUS_14_DB_E310			=	($0A);
	ANALOG_OUTPUT_GAIN_MINUS_18_DB_E310			=	($0B);
	ANALOG_OUTPUT_GAIN_MINUS_21_DB_E310			=	($0C);
	ANALOG_OUTPUT_GAIN_MINUS_24_DB_E310			=	($0D);
	INVALID_ANALOG_OUTPUT_GAINS_INDEX_E310		=	($0E);
	ANALOG_OUTPUT_GAINS_QUANTITY_E310 = INVALID_ANALOG_OUTPUT_GAINS_INDEX_E310;

	// доступные индексы смещения на выходе 10 Ом
	INTERNAL_OUTPUT_10_OHM_OFFSET_E310			=	($00);
	EXTERNAL_OUTPUT_10_OHM_OFFSET_E310			=	($01);
	INVALID_OUTPUT_10_OHM_OFFSET_SOURCE_E310	=	($02);
	// -======================================-

	// -============= частотомер FM ==============-
	// доступные индексы делителя входного сигнала FM
	PERIOD_MODE_FM_E310								=	($00);
	GATE_MODE_FM_E310									=	($01);
	CAPTURE_MODE_FM_E310								=	($02);
	INVALID_FM_MODE_E310								=	($03);

	// возможные индексы делители входного сигнала измерителя частоты FM
	INPUT_DIVIDER_8_FM_E310							=	($00);
	INPUT_DIVIDER_1_FM_E310							=	($01);
	INVALID_INPUT_DIVIDER_FM_E310					=	($02);

	// доступные индексы делителя базовой частоты FM
	BASE_CLOCK_DIV_01_INDEX_FM_E310				=	($00);
	BASE_CLOCK_DIV_02_INDEX_FM_E310				=	($01);
	BASE_CLOCK_DIV_04_INDEX_FM_E310				=	($02);
	BASE_CLOCK_DIV_08_INDEX_FM_E310				=	($03);
	BASE_CLOCK_DIV_16_INDEX_FM_E310				=	($04);
	BASE_CLOCK_DIV_32_INDEX_FM_E310				=	($05);
	BASE_CLOCK_DIV_64_INDEX_FM_E310				=	($06);
	INVALID_BASE_CLOCK_DIV_INDEX_FM_E310		=	($07);
	// -==========================================-

	// -============= А Ц П ==============-
	// доступные источники запуска АЦП
	INTERNAL_ADC_START_E310							=	($00);
	EXTERNAL_ADC_START_E310							=	($01);
	INVALID_ADC_START_SOURCES_E310				=	($02);

	// доступные номера бит для битовой маски каналов АЦП
	ADC_CHANNEL_1_E310								=	($00);
	ADC_CHANNEL_2_E310								=	($01);
	ADC_CHANNEL_3_E310								=	($02);
	ADC_CHANNEL_4_E310								=	($03);
	INVALID_ADC_CHANNEL_BIT_NUMBER_E310			=	($04);
	ADC_CHANNEL_QUANTITY_E310 = INVALID_ADC_CHANNEL_BIT_NUMBER_E310;
	// -==================================-

	// индексы доступных ревизий модуля E-310
	REVISION_A_E310 									=	($00);
	INVALID_REVISION_E310							=	($01);
	// кол-во ревизий модуля
	REVISIONS_QUANTITY_E310 						=	(INVALID_REVISION_E310);	

	// размер области пользовательского ППЗУ в байтах
	USER_FLASH_SIZE_E310 							=	($200);							

	// доступные ревизии модуля
	REVISIONS_E310 : array [0..(REVISIONS_QUANTITY_E310-1)] of char = ( 'A' );


// Типы
type
	// структура с информацией об модуле E-310
	MODULE_DESCRIPTION_E310 = packed record
		Module 		: MODULE_INFO_LUSBAPI;		  	// общая информация о модуле
		DevInterface	: INTERFACE_INFO_LUSBAPI;	// информация об используемом устройстром интерфейсе
		Mcu			: MCU1_INFO_LUSBAPI;				// информация о микроконтроллере (включая 'Загрузчик')
		Adc			: ADC_INFO_LUSBAPI;				// информация о АЦП
		Dac			: DAC_INFO_LUSBAPI;				// информация о ЦАП
		DigitalIo	: DIGITAL_IO_INFO_LUSBAPI;		// информация о цифровом вводе-выводе
	end;
	pMODULE_DESCRIPTION_E310 = ^MODULE_DESCRIPTION_E310;

	// структура пользовательского ППЗУ модуля
	USER_FLASH_E310 = packed record
		Buffer : array [0..(USER_FLASH_SIZE_E310-1)] of BYTE;
	end;
	pUSER_FLASH_E310 = ^USER_FLASH_E310;

	// структура с параметрами частотного приращения
	INCREMENT_INTRERVAL_PARS_E310 = packed record
		BaseIntervalType	: BYTE;			// [in-out]	тип базового интервала приращения, который может быть кратен: периоду MCLK или периоду выходного сигнала
		MultiplierIndex	: BYTE;			// [in-out]	индекс умножителя для базового интервала приращения
		MultiplierValue	: double;		// [out]		величина умножителя для базового интервала приращения: 1, 5, 100 или 500
		BaseIntervalsNumber : WORD;		// [in-out]	кол-во базовых интервалов в интервале приращения
		Duration				: double;		// [out] 	общая длительность приращения в мс (только для интервала приращений по MCLK), иначе 0.0
	end;

	// структура с параметрами аналоговых выходов генератора
	ANALOG_OUTPUTS_PARS_E310 = packed record
		SignalType 			: BYTE;			// [in-out]	тип аналогового сигнала на выходах 10 и 50 Ом: синусоидальный или треугольный
		GainIndex 			: BYTE;			// [in-out]	индекс усиления выходного тракта генератора
		GaindB 				: double; 		// [out]		усиление выходного тракта генератора в дБ
		Output10OhmInV		: double; 		// [out]		амплитуда сигнала на выходе 10 Ом в В
		Output10OhmIndB	: double; 		// [out]		амплитуда сигнала на выходе 10 Ом в дБ
		Output10OhmOffset : double;		// [in-out]	величина внутреннего смещения на выходе 10 Ом в В
		Output10OhmOffsetSource : BYTE;	//[in-out]	тип смещения на выходе 10 Ом: внутреннее или внешнее
		Output50OhmInV		: double; 		// [out]		амплитуда сигнала на выходе 50 Ом в В
		Output50OhmIndB	: double; 		// [out]		амплитуда сигнала на выходе 50 Ом в дБ
	end;

	// структура с параметрами работы генератора
	GENERATOR_PARS_E310 = packed record
		GeneratorEna		: BOOL;			// [in]		текущее состояние работы генератора
		StartFrequency		: double;		// [in-out]	начальная частота в кГц
		FinalFrequency		: double;		// [out]		конечная частота в кГц
		FrequencyIncrements 	: double;	// [in-out]	частота приращения в кГц
		NumberOfIncrements	: WORD;		// [in-out]	кол-во приращений частоты сканирования
		IncrementIntervalPars: INCREMENT_INTRERVAL_PARS_E310;	// [in-out] параметры частотного приращения
		MasterClock			: double;		// [in-out]	частота тактирующего сигнала генератора в кГц
		MasterClockSource : BYTE;			// [in-out]	источник тактирующего сигнала генератора: внутренний или внешний
		CyclicAutoScanType: BYTE;			// [in-out]	тип циклического автосканирования выходного сигнала: нет циклического сканирования, 'пила' или 'треугольник'
		IncrementType		: BYTE;			// [in-out]	тип инкрементации частоты генератора: внутренняя (автоматическая) или с помощью управляющей линии "CTRL"
		CtrlLineType		: BYTE;			// [in-out]	тип линии "CTRL" для (управления инкрементацией частоты)/старта генератора: внутренняя (от MCU) или внешняя
		InterrupLineType	: BYTE;			// [in-out]	тип линии "INTERRUPT" для останова работы генератора: внутренняя (от MCU) или внешняя
		SquareWaveOutputEna	: BOOL;		// [in-out]	разрешение сигнала генератора на цифровом выходе "Меандр"
		SynchroOutEna		: BOOL;			// [in-out]	разрешение синхросигнала генератора на выходной линии "SYNCOUT"
		SynchroOutType		: BYTE;			// [in-out]	тип формирования синхросигнала генератора: при каждом приращении частоты или только по окончании сканирования
		AnalogOutputsPars	: ANALOG_OUTPUTS_PARS_E310;	//	[in-out] параметры работы аналоговых выходов
	end;
	pGENERATOR_PARS_E310 = ^GENERATOR_PARS_E310;

	// структура с параметрами работы измерителя частоты (FM)
	FM_PARS_E310 = packed record
		FmEna					: BOOL;			// [out]		текущее состояние работы измерителя частоты
		Mode					: BYTE;			// [in-out]	режим работы измерителя частоты
		InputDivider		: BYTE;			// [in-out]	управление входным частоты делителем 1/8: 0x0 или 0x1
		BaseClockRateDivIndex : BYTE;		// [in-out]	индекс делителя базовой тактовой частоты
		ClockRate			: DWORD;			// [out]		рабочая тактовая частота счётчика FM в Гц
		BaseClockRate		: DWORD;			// [const]	базовая тактовая частота счётчика FM 25 000 000 Гц
		Offset				: double;		// [in-out]	смещение порога измерителя частоты в В
	end;
	pFM_PARS_E310 = ^FM_PARS_E310;

	// структура с информацией о частоте измеряемого сигнала
	FM_SAMPLE_E310 = packed record
		IsActual				: BOOL;			// [out]	признак действительности получeнных данных
		Frequency			: double;		// [out]	частота измеряемого сигнала в кГц
		Period				: double;		// [out]	период измеряемого сигнала в мс
		DutyCycle			: double;		// [out]	скважность измеряемого сигнала в мс
	end;
	pFM_SAMPLE_E310 = ^FM_SAMPLE_E310;

	// структура для работы с АЦП
	ADC_PARS_E310 = packed record
		AdcStartSource		: BYTE; 			// [in-out]	источник сигнала запуска АЦП: внутренний или внешний
		ChannelsMask		: BYTE;			// [in-out]	битовая маска активных каналов (младшие 4 бита)
		InputRange			: double;		// [out]		входной диапазон АЦП в В
	end;
	pADC_PARS_E310 = ^ADC_PARS_E310;

	// структура с отсчётами АЦП
	ADC_DATA_E310 = packed record
		DataInCode	: array [0..(ADC_CHANNEL_QUANTITY_E310-1)] of SHORT;		// [out] массив данных с АЦП в кодах
		DataInV		: array [0..(ADC_CHANNEL_QUANTITY_E310-1)] of double;		// [out] массив данных с АЦП в В
	end;
	pADC_DATA_E310 = ^ADC_DATA_E310;

// интерфейс модуля E-310
ILE310 = class(Lusbbase)
  public
		// ---------------- функции для работы с генератором ----------------------------
		Function GET_GENERATOR_PARS(GenPars : pGENERATOR_PARS_E310) : BOOL; virtual; stdcall; abstract;
		Function SET_GENERATOR_PARS(GenPars : pGENERATOR_PARS_E310) : BOOL; virtual; stdcall; abstract;
		Function START_GENERATOR : BOOL; virtual; stdcall; abstract;
		Function STOP_GENERATOR : BOOL; virtual; stdcall; abstract;

		// ---------- функции для работы с частотометром (FM) -------------------
		Function GET_FM_PARS(FmPars : pFM_PARS_E310) : BOOL; virtual; stdcall; abstract;
		Function SET_FM_PARS(FmPars : pFM_PARS_E310) : BOOL; virtual; stdcall; abstract;
		Function START_FM : BOOL; virtual; stdcall; abstract;
		Function STOP_FM : BOOL; virtual; stdcall; abstract;
		Function FM_SAMPLE(FmSample : pFM_SAMPLE_E310) : BOOL; virtual; stdcall; abstract;

		// ------------------ функции для работы АЦП ---------------------------
		Function GET_ADC_PARS(AdcPars : pADC_PARS_E310) : BOOL; virtual; stdcall; abstract;
		Function SET_ADC_PARS(AdcPars : pADC_PARS_E310) : BOOL; virtual; stdcall; abstract;
		Function GET_ADC_DATA(AdcData : pADC_DATA_E310) : BOOL; virtual; stdcall; abstract;

		// ---------- функции для работы с цифровыми линиями -------------------
		Function CONFIG_TTL_LINES(Pattern : WORD; AddTtlLinesEna : BOOL = FALSE) : BOOL; virtual; stdcall; abstract;
		Function TTL_IN(TtlIn 	: pWORD) : BOOL; virtual; stdcall; abstract;
		Function TTL_OUT(TtlOut : pWORD) : BOOL; virtual; stdcall; abstract;

		// ------- функции для работы с пользовательской информацией ППЗУ  -------
		Function ENABLE_FLASH_WRITE(IsFlashWriteEnabled : BOOL) : BOOL; virtual; stdcall; abstract;
		Function READ_FLASH_ARRAY(UserFlash : pUSER_FLASH_E310) : BOOL; virtual; stdcall; abstract;
		Function WRITE_FLASH_ARRAY(UserFlash : pUSER_FLASH_E310) : BOOL; virtual; stdcall; abstract;

		// ------- функции для работы со служебной информацией из ППЗУ -----------
		Function GET_MODULE_DESCRIPTION(ModuleDescription : pMODULE_DESCRIPTION_E310) : BOOL; virtual; stdcall; abstract;
		Function SAVE_MODULE_DESCRIPTION(ModuleDescription : pMODULE_DESCRIPTION_E310) : BOOL; virtual; stdcall; abstract;

	end;
	pILE310 = ^ILE310;

