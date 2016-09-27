// *****************************************************************************
// ******************  М о д у л ь    E - 1 5 4      ***************************
// *****************************************************************************

// Константы
const
	// индексы доступных диапазонов входного напряжения модуля E-154
	ADC_INPUT_RANGE_5000mV_E154			=	($00);
	ADC_INPUT_RANGE_1600mV_E154			=	($01);
	ADC_INPUT_RANGE_500mV_E154				=	($02);
	ADC_INPUT_RANGE_160mV_E154				=	($03);
	INVALID_ADC_INPUT_RANGE_E154			=	($04);

	// индексы доступных источников тактовых импульсов для АЦП
	INT_ADC_CLOCK_E154						=	($00);
	EXT_ADC_CLOCK_E154						=	($01);
	INVALID_ADC_CLOCK_E154				  	=	($02);

	// доступные индексы управления трансляцией тактовых импульсов АЦП
	// на линию SYN внешнего цифрового разъёма (только при внутреннем
	// источнике тактовых импульсоц АЦП)
	ADC_CLOCK_TRANS_DISABLED_E154		  	=	($00);
	ADC_CLOCK_TRANS_ENABLED_E154		  	=	($01);
	INVALID_ADC_CLOCK_TRANS_E154		  	=	($02);

	// индексы возможных типов синхронизации модуля E-154
	NO_SYNC_E154								=	($00);
	TTL_START_SYNC_E154						=	($01);
	TTL_KADR_SYNC_E154						=	($02);
	ANALOG_SYNC_E154							=	($03);
	INVALID_SYNC_E154							=	($04);

	// индексы возможных опций наличия микросхемы ЦАП
	DAC_INACCESSIBLED_E154					=	($00);
	DAC_ACCESSIBLED_E154						=	($01);
	INVALID_DAC_OPTION_E154					=	($02);

	// индексы доступных ревизий модуля E-154
	REVISION_A_E154 							=	($00);
	INVALID_REVISION_E154					=	($01);

	// константы для работы с модулем
	MAX_CONTROL_TABLE_LENGTH_E154			=	(16);
	ADC_INPUT_RANGES_QUANTITY_E154		=	(INVALID_ADC_INPUT_RANGE_E154);
	ADC_CALIBR_COEFS_QUANTITY_E154		=	(ADC_INPUT_RANGES_QUANTITY_E154);
	DAC_CHANNELS_QUANTITY_E154				=	($01);
	DAC_CALIBR_COEFS_QUANTITY_E154		=	(DAC_CHANNELS_QUANTITY_E154);
	TTL_LINES_QUANTITY_E154					=	($10);							// кол-во цифровых линий
	REVISIONS_QUANTITY_E154 				=	(INVALID_REVISION_E154);	// кол-во ревизий (модификаций) модуля

	// диапазоны входного напряжения АЦП в В
	ADC_INPUT_RANGES_E154 : array [0..(ADC_INPUT_RANGES_QUANTITY_E154-1)]  of double =	( 5.0, 1.6, 0.5, 0.16);
	// диапазоны выходного напряжения ЦАП в В
	DAC_OUTPUT_RANGE_E154					=	5.0;
	// доступные ревизии модуля
	REVISIONS_E154 : array [0..(REVISIONS_QUANTITY_E154-1)] of char = ( 'A' );


// Типы
type
	// структура с информацией об модуле E-154
	MODULE_DESCRIPTION_E154 = packed record
		Module 		: MODULE_INFO_LUSBAPI;		  	// общая информация о модуле
		DevInterface	: INTERFACE_INFO_LUSBAPI;	// информация об используемом устройстром интерфейсе
		Mcu			: MCU_INFO_LUSBAPI;				// информация о микроконтроллере
		Adc			: ADC_INFO_LUSBAPI;				// информация о АЦП
		Dac			: DAC_INFO_LUSBAPI;				// информация о ЦАП
		DigitalIo	: DIGITAL_IO_INFO_LUSBAPI;		// информация о цифровом вводе-выводе
	end;
	pMODULE_DESCRIPTION_E154 = ^MODULE_DESCRIPTION_E154;

	// структура параметров работы АЦП для модуля E-154
	ADC_PARS_E154 = packed record
		ClkSource : WORD;			  							// источник тактовых импульсов для запуска АПП
		EnableClkOutput : WORD; 							// разрешение трансляции тактовых импульсов запуска АЦП
		InputMode : WORD;										// режим ввода даных с АЦП
		SynchroAdType : WORD;								// тип аналоговой синхронизации
		SynchroAdMode : WORD; 								// режим аналоговой сихронизации
		SynchroAdChannel : WORD;  							// канал АЦП при аналоговой синхронизации
		SynchroAdPorog : SHORT;								// порог срабатывания АЦП при аналоговой синхронизации
		ChannelsQuantity : WORD;							// число активных логических каналов
		ControlTable : array [0..(MAX_CONTROL_TABLE_LENGTH_E154-1)] of WORD;	// управляющая таблица с активными логическими каналами
		AdcRate : double;	  			  						// тактовая частота АЦП в кГц
		InterKadrDelay : double;		  					// межкадровая задержка в мс
		KadrRate : double;									// частота ввода кадра в кГц
	end;
	pADC_PARS_E154 = ^ADC_PARS_E154;

// интерфейс модуля E-154
ILE154 = class(Lusbbase)
  public
		// функции для работы с АЦП
		Function GET_ADC_PARS(ap : pADC_PARS_E154) : BOOL; virtual; stdcall; abstract;
		Function SET_ADC_PARS(ap : pADC_PARS_E154) : BOOL; virtual; stdcall; abstract;
		Function START_ADC : BOOL; virtual; stdcall; abstract;
		Function STOP_ADC : BOOL; virtual; stdcall; abstract;
		Function ADC_KADR(Data : pSHORT) : BOOL; virtual; stdcall; abstract;
		Function ADC_SAMPLE(AdcData : pSHORT; AdcChannel : WORD) : BOOL; virtual; stdcall; abstract;
		Function ReadData(ReadRequest : pIO_REQUEST_LUSBAPI) : BOOL; virtual; stdcall; abstract;
		Function ProcessArray(src : pSHORT; dest : pDOUBLE; size : DWORD; calibr : BOOL; volt : BOOL) : BOOL; virtual; stdcall; abstract;
		Function ProcessOnePoint(src : SHORT; dest : pDOUBLE; channel : DWORD; calibr : BOOL; volt : BOOL) : BOOL; virtual; stdcall; abstract;
		Function FIFO_STATUS(FifoOverflowFlag : pDWORD; FifoMaxPercentLoad : pDOUBLE; FifoSize : pDWORD; MaxFifoBytesUsed : pDWORD) : BOOL; virtual; stdcall; abstract;

		// функции для работы с ЦАП
		Function DAC_SAMPLE(DacData : pSHORT; DacChannel : WORD) : BOOL; virtual; stdcall; abstract;
 		Function DAC_SAMPLE_VOLT(DacData : DOUBLE; calibr : BOOL) : BOOL; virtual; stdcall; abstract;

		// функции для работы с цифровыми линиями
		Function ENABLE_TTL_OUT(EnableTtlOut : BOOL) : BOOL; virtual; stdcall; abstract;
		Function TTL_IN(TtlIn : pWORD) : BOOL; virtual; stdcall; abstract;
		Function TTL_OUT(TtlOut : WORD) : BOOL; virtual; stdcall; abstract;

		// функции для работы с пользовательской информацией ППЗУ
		Function ENABLE_FLASH_WRITE(IsFlashWriteEnabled : BOOL) : BOOL; virtual; stdcall; abstract;
 		Function READ_FLASH_ARRAY(UserFlash : pBYTE) : BOOL; virtual; stdcall; abstract;
		Function WRITE_FLASH_ARRAY(UserFlash : pBYTE) : BOOL; virtual; stdcall; abstract;

		// функции для работы со служебной информацией ППЗУ
		Function GET_MODULE_DESCRIPTION(ModuleDescription : pMODULE_DESCRIPTION_E154) : BOOL; virtual; stdcall; abstract;
		Function SAVE_MODULE_DESCRIPTION(ModuleDescription : pMODULE_DESCRIPTION_E154) : BOOL; virtual; stdcall; abstract;

		// функции для прямого досупа к ARM
		Function GetArray (Buffer : pSHORT; Size : WORD; Address : WORD)  : BOOL; virtual; stdcall; abstract;
  		Function PutArray(Buffer : pSHORT; Size : WORD; Address : WORD)  : BOOL; virtual; stdcall; abstract;

	end;
	pILE154 = ^ILE154;
      