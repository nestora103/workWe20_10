// *****************************************************************************
// ******************  М о д у л ь    E 1 4 - 1 4 0  ***************************
// *****************************************************************************

// Константы
const
	// индексы доступных диапазонов входного напряжения модуля E14-440
	ADC_INPUT_RANGE_10000mV_E140			=	($00);
	ADC_INPUT_RANGE_2500mV_E140			=	($01);
	ADC_INPUT_RANGE_625mV_E140				=	($02);
	ADC_INPUT_RANGE_156mV_E140				=	($03);
	INVALID_ADC_INPUT_RANGE_E140			=	($04);

	// индексы доступных источников тактовых импульсов для АЦП
	INT_ADC_CLOCK_E140						=	($00);
	EXT_ADC_CLOCK_E140						=	($01);
	INVALID_ADC_CLOCK_E140				  	=	($02);

	// доступные индексы управления трансляцией тактовых импульсов АЦП
	// на линию SYN внешнего цифрового разъёма (только при внутреннем
	// источнике тактовых импульсоц АЦП)
	ADC_CLOCK_TRANS_DISABLED_E140		  	=	($00);
	ADC_CLOCK_TRANS_ENABLED_E140		  	=	($01);
	INVALID_ADC_CLOCK_TRANS_E140		  	=	($02);

	// индексы возможных типов синхронизации модуля E14-440
	NO_SYNC_E140								=	($00);
	TTL_START_SYNC_E140						=	($01);
	TTL_KADR_SYNC_E140						=	($02);
	ANALOG_SYNC_E140							=	($03);
	INVALID_SYNC_E140							=	($04);

	// индексы возможных опций наличия микросхемы ЦАП
	DAC_INACCESSIBLED_E140					=	($00);
	DAC_ACCESSIBLED_E140						=	($01);
	INVALID_DAC_OPTION_E140					=	($02);

	// доступные индексы синхронизации потоковой работы ЦАП и АЦП
	DIS_ADC_DAC_SYNC_E140					=	($00);
	ENA_ADC_DAC_SYNC_E140					=	($01);
	INVALID_ADC_DAC_SYNC_E140				=	($02);

	// индексы доступных ревизий модуля E14-440
	REVISION_A_E140 							=	($00);
	REVISION_B_E140							=  ($01);
	INVALID_REVISION_E140					=	($02);

	// константы для работы с модулем
	MAX_CONTROL_TABLE_LENGTH_E140			=	(128);
	ADC_INPUT_RANGES_QUANTITY_E140		=	(INVALID_ADC_INPUT_RANGE_E140);
	ADC_CALIBR_COEFS_QUANTITY_E140		=	(ADC_INPUT_RANGES_QUANTITY_E140);
	DAC_CHANNELS_QUANTITY_E140				=	($02);
	DAC_CALIBR_COEFS_QUANTITY_E140		=	(DAC_CHANNELS_QUANTITY_E140);
	TTL_LINES_QUANTITY_E140					=	($10);							// кол-во цифровых линий
	USER_FLASH_SIZE_E140 					=	($200);							// размер области пользовательского ППЗУ в байтах
	REVISIONS_QUANTITY_E140 				=	(INVALID_REVISION_E140);	// кол-во ревизий модуля

	// диапазоны входного напряжения АЦП в В
	ADC_INPUT_RANGES_E140 : array [0..(ADC_INPUT_RANGES_QUANTITY_E140-1)]  of double =	( 10.0, 10.0/4.0, 10.0/16.0, 10.0/64.0 );
	// диапазоны выходного напряжения ЦАП в В
	DAC_OUTPUT_RANGE_E140					=	5.0;
	// доступные ревизии модуля
	REVISIONS_E140 : array [0..(REVISIONS_QUANTITY_E140-1)] of AnsiChar = ( 'A', 'B' );


// Типы
type
	// структура с информацией об модуле E14-440
	MODULE_DESCRIPTION_E140 = packed record
		Module 		: MODULE_INFO_LUSBAPI;		  	// общая информация о модуле
		DevInterface	: INTERFACE_INFO_LUSBAPI;	// информация об используемом устройстром интерфейсе
		Mcu			: MCU_INFO_LUSBAPI;				// информация о микроконтроллере
		Adc			: ADC_INFO_LUSBAPI;				// информация о АЦП
		Dac			: DAC_INFO_LUSBAPI;				// информация о ЦАП
		DigitalIo	: DIGITAL_IO_INFO_LUSBAPI;		// информация о цифровом вводе-выводе
	end;
	pMODULE_DESCRIPTION_E140 = ^MODULE_DESCRIPTION_E140;

	// структура пользовательского ППЗУ модуля
	USER_FLASH_E140 = packed record
		Buffer : array [0..(USER_FLASH_SIZE_E140-1)] of BYTE;
	end;
	pUSER_FLASH_E140 = ^USER_FLASH_E140;

	// структура параметров работы АЦП для модуля
	ADC_PARS_E140 = packed record
		ClkSource : WORD;			  							// источник тактовых импульсов для запуска АПП
		EnableClkOutput : WORD; 							// разрешение трансляции тактовых импульсов запуска АЦП
		InputMode : WORD;										// режим ввода даных с АЦП
		SynchroAdType : WORD;								// тип аналоговой синхронизации
		SynchroAdMode : WORD; 								// режим аналоговой сихронизации
		SynchroAdChannel : WORD;  							// канал АЦП при аналоговой синхронизации
		SynchroAdPorog : SHORT;								// порог срабатывания АЦП при аналоговой синхронизации
		ChannelsQuantity : WORD;							// число активных логических каналов
		ControlTable : array [0..(MAX_CONTROL_TABLE_LENGTH_E140-1)] of WORD;	// управляющая таблица с активными логическими каналами
		AdcRate : double;	  			  						// тактовая частота АЦП в кГц
		InterKadrDelay : double;		  					// межкадровая задержка в мс
		KadrRate : double;									// частота ввода кадра в кГц
	end;
	pADC_PARS_E140 = ^ADC_PARS_E140;

	// структура параметров потоковой работы ЦАП модуля
	DAC_PARS_E140 = packed record
		SyncWithADC : BYTE;									// 0 = обычный пуск ЦАП; !0 = синхронизировать с пуском АЦП
		SetZeroOnStop : BYTE;								// !0 = при остановке потокового вывода установить на выходе ЦАП 0 В
		DacRate : double;										// частота работы ЦАП в кГц
	end;
	pDAC_PARS_E140 = ^DAC_PARS_E140;

// интерфейс модуля E14-440
ILE140 = class(Lusbbase)
  public
		// функции для работы с АЦП
		Function GET_ADC_PARS(AdcPars : pADC_PARS_E140) : BOOL; virtual; stdcall; abstract;
		Function SET_ADC_PARS(AdcPars : pADC_PARS_E140) : BOOL; virtual; stdcall; abstract;
		Function START_ADC : BOOL; virtual; stdcall; abstract;
		Function STOP_ADC : BOOL; virtual; stdcall; abstract;
		Function ADC_KADR(Data : pSHORT) : BOOL; virtual; stdcall; abstract;
		Function ADC_SAMPLE(AdcData : pSHORT; AdcChannel : WORD) : BOOL; virtual; stdcall; abstract;
		Function ReadData(ReadRequest : pIO_REQUEST_LUSBAPI) : BOOL; virtual; stdcall; abstract;

		// функции для работы с ЦАП
		Function GET_DAC_PARS(DacPars : pDAC_PARS_E140) : BOOL; virtual; stdcall; abstract;
		Function SET_DAC_PARS(DacPars : pDAC_PARS_E140) : BOOL; virtual; stdcall; abstract;
		Function START_DAC : BOOL; virtual; stdcall; abstract;
		Function STOP_DAC : BOOL; virtual; stdcall; abstract;
		Function WriteData(WriteRequest : pIO_REQUEST_LUSBAPI) : BOOL; virtual; stdcall; abstract;
		Function DAC_SAMPLE(DacData : pSHORT; DacChannel : WORD) : BOOL; virtual; stdcall; abstract;
		Function DAC_SAMPLES(DacData1, DacData2 : pSHORT) : BOOL; virtual; stdcall; abstract;

		// функции для работы с цифровыми линиями
		Function ENABLE_TTL_OUT(EnableTtlOut : BOOL) : BOOL; virtual; stdcall; abstract;
		Function TTL_IN(TtlIn : pWORD) : BOOL; virtual; stdcall; abstract;
		Function TTL_OUT(TtlOut : WORD) : BOOL; virtual; stdcall; abstract;

		// функции для работы с пользовательской информацией ППЗУ
		Function ENABLE_FLASH_WRITE(IsFlashWriteEnabled : BOOL) : BOOL; virtual; stdcall; abstract;
		Function READ_FLASH_ARRAY(UserFlash : pUSER_FLASH_E140) : BOOL; virtual; stdcall; abstract;
		Function WRITE_FLASH_ARRAY(UserFlash : pUSER_FLASH_E140) : BOOL; virtual; stdcall; abstract;

		// функции для работы со служебной информацией ППЗУ
		Function GET_MODULE_DESCRIPTION(ModuleDescription : pMODULE_DESCRIPTION_E140) : BOOL; virtual; stdcall; abstract;
		Function SAVE_MODULE_DESCRIPTION(ModuleDescription : pMODULE_DESCRIPTION_E140) : BOOL; virtual; stdcall; abstract;

		// функции для прямого досупа к микроконтроллеру
		Function GetArray(Buffer : pBYTE; Size, Address : WORD) : BOOL; virtual; stdcall; abstract;
		Function PutArray(Buffer : pBYTE; Size, Address : WORD) : BOOL; virtual; stdcall; abstract;

	end;
	pILE140 = ^ILE140;

