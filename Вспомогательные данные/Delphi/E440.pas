// *****************************************************************************
// ******************  М о д у л ь    E 1 4 - 4 4 0  ***************************
// *****************************************************************************

// Константы
const
	// адрес начала сегмента данных LBIOS ( располагается в памяти программ DSP модуля)
	VarsBaseAddress_E440 					= $30;

	// адреса переменных штатного LBIOS для модуля E14-440 (раполагаются в памяти программ DSP модуля)
	L_PROGRAM_BASE_ADDRESS_E440		  	= 	(VarsBaseAddress_E440 + $0);
	L_READY_E440   							= 	(VarsBaseAddress_E440 + $1);
	L_TMODE1_E440   							= 	(VarsBaseAddress_E440 + $2);
	L_TMODE2_E440	   						= 	(VarsBaseAddress_E440 + $3);
	L_TEST_LOAD_E440	 						= 	(VarsBaseAddress_E440 + $4);
	L_COMMAND_E440		 						= 	(VarsBaseAddress_E440 + $5);

	L_DAC_SCLK_DIV_E440 						= 	(VarsBaseAddress_E440 + $7);
	L_DAC_RATE_E440	 						= 	(VarsBaseAddress_E440 + $8);
	L_ADC_RATE_E440	 						= 	(VarsBaseAddress_E440 + $9);
	L_ADC_ENABLED_E440 						= 	(VarsBaseAddress_E440 + $A);
	L_ADC_FIFO_BASE_ADDRESS_E440			= 	(VarsBaseAddress_E440 + $B);
	L_CUR_ADC_FIFO_LENGTH_E440				= 	(VarsBaseAddress_E440 + $C);
	L_ADC_FIFO_LENGTH_E440					= 	(VarsBaseAddress_E440 + $E);
	L_CORRECTION_ENABLED_E440				= 	(VarsBaseAddress_E440 + $F);

	L_ADC_SAMPLE_E440							= 	(VarsBaseAddress_E440 + $11);
	L_ADC_CHANNEL_E440	 					= 	(VarsBaseAddress_E440 + $12);
	L_INPUT_MODE_E440							= 	(VarsBaseAddress_E440 + $13);

	L_SYNCHRO_AD_CHANNEL_E440				= 	(VarsBaseAddress_E440 + $16);
	L_SYNCHRO_AD_POROG_E440					= 	(VarsBaseAddress_E440 + $17);
	L_SYNCHRO_AD_MODE_E440 					= 	(VarsBaseAddress_E440 + $18);
	L_SYNCHRO_AD_TYPE_E440 					= 	(VarsBaseAddress_E440 + $19);

	L_CONTROL_TABLE_LENGHT_E440			= 	(VarsBaseAddress_E440 + $1B);
	L_FIRST_SAMPLE_DELAY_E440				= 	(VarsBaseAddress_E440 + $1C);
	L_INTER_KADR_DELAY_E440					= 	(VarsBaseAddress_E440 + $1D);

	L_DAC_SAMPLE_E440							= 	(VarsBaseAddress_E440 + $20);
	L_DAC_ENABLED_E440					 	= 	(VarsBaseAddress_E440 + $21);
	L_DAC_FIFO_BASE_ADDRESS_E440			= 	(VarsBaseAddress_E440 + $22);
	L_CUR_DAC_FIFO_LENGTH_E440				= 	(VarsBaseAddress_E440 + $24);
	L_DAC_FIFO_LENGTH_E440					= 	(VarsBaseAddress_E440 + $25);

	L_FLASH_ENABLED_E440 					= 	(VarsBaseAddress_E440 + $26);
	L_FLASH_ADDRESS_E440 					= 	(VarsBaseAddress_E440 + $27);
	L_FLASH_DATA_E440 						= 	(VarsBaseAddress_E440 + $28);

	L_ENABLE_TTL_OUT_E440					= 	(VarsBaseAddress_E440 + $29);
	L_TTL_OUT_E440								= 	(VarsBaseAddress_E440 + $2A);
	L_TTL_IN_E440								= 	(VarsBaseAddress_E440 + $2B);

	L_SCALE_E440								= 	(VarsBaseAddress_E440 + $30);
	L_ZERO_E440									= 	(VarsBaseAddress_E440 + $34);

	L_CONTROL_TABLE_E440						=	($80);

	L_DSP_INFO_STUCTURE_E440				=	($200);

	// индексы доступных состояний сброса модуля E14-440
	INIT_E440									=	($00);
	RESET_E440									=	($01);
	INVALID_RESET_TYPE_E440					=	($02);

	// доступные индексы источника тактовых импульсов для АЦП
	INT_ADC_CLOCK_E440						=	($00);
	INT_ADC_CLOCK_WITH_TRANS_E440			=	($01);
	EXT_ADC_CLOCK_E440						=	($02);
	INVALID_ADC_CLOCK_E440					=	($03);

	// индексы доступных диапазонов входного напряжения модуля E14-440
	ADC_INPUT_RANGE_10000mV_E440			=	($00);
	ADC_INPUT_RANGE_2500mV_E440			=	($01);
	ADC_INPUT_RANGE_625mV_E440				=	($02);
	ADC_INPUT_RANGE_156mV_E440				=	($03);
	INVALID_ADC_INPUT_RANGE_E440			=	($04);

	// индексы возможных типов синхронизации модуля E14-440
	NO_SYNC_E440								=	($00);
	TTL_START_SYNC_E440						=	($01);
	TTL_KADR_SYNC_E440						=	($02);
	ANALOG_SYNC_E440							=	($03);
	INVALID_SYNC_E440							=	($04);

	// индексы возможных опций наличия микросхемы ЦАП
	DAC_INACCESSIBLED_E440					=	($00);
	DAC_ACCESSIBLED_E440						=	($01);
	INVALID_DAC_OPTION_E440					=	($02);

	// индексы возможных типов DSP (сейчас только ADSP-2185)
	ADSP2184_E440								=	($00);
	ADSP2185_E440								=	($01);
	ADSP2186_E440								=	($02);
	INVALID_DSP_TYPE_E440					=	($03);

	// индексы возможных тактовых частот модудя (сейчас только 24000 кГц)
	F14745_E440									=	($00);
	F16667_E440									=	($01);
	F20000_E440									=	($02);
	F24000_E440									=	($03);
	INVALID_QUARTZ_FREQ_E440				=	($04);

	// индексы доступных ревизий модуля E14-440
	REVISION_A_E440	  						=	($00);
	REVISION_B_E440	  						=	($01);
	REVISION_C_E440	  						=	($02);
	REVISION_D_E440							=	($03);
	REVISION_E_E440							=	($04);
	REVISION_F_E440							=	($05);							
	INVALID_REVISION_E440					=	($06);

	// константы для работы с модулем
	MAX_CONTROL_TABLE_LENGTH_E440			=	(128);
	ADC_INPUT_RANGES_QUANTITY_E440		=	(INVALID_ADC_INPUT_RANGE_E440);
	ADC_CALIBR_COEFS_QUANTITY_E440		=	(ADC_INPUT_RANGES_QUANTITY_E440);
	MAX_ADC_FIFO_SIZE_E440					=	($3000);			// 12288
	DAC_CHANNELS_QUANTITY_E440				=	($02);
	DAC_CALIBR_COEFS_QUANTITY_E440		=	(DAC_CHANNELS_QUANTITY_E440);
	MAX_DAC_FIFO_SIZE_E440					=	($0FC0);			// 4032
	TTL_LINES_QUANTITY_E440					=	($10);							// кол-во цифровых линий
	REVISIONS_QUANTITY_E440 				=	(INVALID_REVISION_E440);	// кол-во ревизий (модификаций) модуля

	// диапазоны входного напряжения АЦП в В
	ADC_INPUT_RANGES_E440 : array [0..(ADC_INPUT_RANGES_QUANTITY_E440-1)]  of double =	( 10.0, 10.0/4.0, 10.0/16.0, 10.0/64.0 );
	// диапазоны выходного напряжения ЦАП в В
	DAC_OUTPUT_RANGE_E440					=	5.0;
	// доступные ревизии модуля
	REVISIONS_E440 : array [0..(REVISIONS_QUANTITY_E440-1)] of char = ( 'A', 'B', 'C', 'D', 'E', 'F' );

   
// Типы
type
	// структура с информацией об модуле E14-440
	MODULE_DESCRIPTION_E440 = packed record
		Module 		: MODULE_INFO_LUSBAPI;		  	// общая информация о модуле
		DevInterface	: INTERFACE_INFO_LUSBAPI;	// информация об используемом устройстром интерфейсе
		Mcu			: MCU_INFO_LUSBAPI;				// информация о микроконтроллере
		Dsp			: DSP_INFO_LUSBAPI;				// информация о DSP
		Adc			: ADC_INFO_LUSBAPI;				// информация о АЦП
		Dac			: DAC_INFO_LUSBAPI;				// информация о ЦАП
		DigitalIo	: DIGITAL_IO_INFO_LUSBAPI;		// информация о цифровом вводе-выводе
	end;
	pMODULE_DESCRIPTION_E440 = ^MODULE_DESCRIPTION_E440;

	// структура параметров работы АЦП для модуля E14-440
	ADC_PARS_E440 = packed record
		IsAdcEnabled : BOOL;			  						// флажок разрешение/запрещение ввода данных (только при чтении)
		IsCorrectionEnabled : BOOL;						// разрешение управление корректировкой данных на уровне драйвера DSP
		AdcClockSource : WORD;								// источник тактовых импульсов запуска АЦП: внутренние или внешние
		InputMode : WORD;										// режим ввода даных с АЦП
		SynchroAdType : WORD;								// тип аналоговой синхронизации
		SynchroAdMode : WORD; 								// режим аналоговой сихронизации
		SynchroAdChannel : WORD;  							// канал АЦП при аналоговой синхронизации
		SynchroAdPorog : SHORT;								// порог срабатывания АЦП при аналоговой синхронизации
		ChannelsQuantity : WORD;							// число активных логических каналов
		ControlTable : array [0..(MAX_CONTROL_TABLE_LENGTH_E440-1)] of WORD;	// управляющая таблица с активными логическими каналами
		AdcRate : double;	  			  						// тактовая частота АЦП в кГц
		InterKadrDelay : double;		  					// межкадровая задержка в мс
		KadrRate : double;									// частота кадра в кГц
		AdcFifoBaseAddress : WORD;							// базовый адрес FIFO буфера ввода
		AdcFifoLength : WORD;	  							// длина FIFO буфера ввода
		AdcOffsetCoefs : array [0..3] of double; 		// корректировочные коэф. смещение нуля для АЦП
		AdcScaleCoefs : array [0..3] of double; 		// корректировочные коэф. масштаба для АЦП
	end;
	pADC_PARS_E440 = ^ADC_PARS_E440;

	// структура параметров работы ЦАП модуля E14-440
	DAC_PARS_E440 = packed record
		DacEnabled : BOOL;									// разрешение/запрещение вывода данных
		DacRate : double;	  		  							// частота вывода данных в кГц
		DacFifoBaseAddress : WORD;  						// базовый адрес FIFO буфера вывода
		DacFifoLength : WORD;								// длина FIFO буфера вывода
	end;
	pDAC_PARS_E440 = ^DAC_PARS_E440;

// интерфейс модуля E14-440
ILE440 = class(Lusbbase)
  public
		// функции для работы с DSP модуля
		Function RESET_MODULE(ResetFlag : BYTE = INIT_E440) : BOOL; virtual; stdcall; abstract;
		Function LOAD_MODULE(FileName : pAnsiChar = nil) : BOOL; virtual; stdcall; abstract;
		Function TEST_MODULE : BOOL; virtual; stdcall; abstract;
		Function SEND_COMMAND(Command : WORD) : BOOL; virtual; stdcall; abstract;

		// функции для работы с АЦП
		Function GET_ADC_PARS(ap : pADC_PARS_E440) : BOOL; virtual; stdcall; abstract;
		Function SET_ADC_PARS(ap : pADC_PARS_E440) : BOOL; virtual; stdcall; abstract;
		Function START_ADC : BOOL; virtual; stdcall; abstract;
		Function STOP_ADC : BOOL; virtual; stdcall; abstract;
		Function ADC_KADR(Data : pSHORT) : BOOL; virtual; stdcall; abstract;
		Function ADC_SAMPLE(AdcData : pSHORT; AdcChannel : WORD) : BOOL; virtual; stdcall; abstract;
		Function ReadData(ReadRequest : pIO_REQUEST_LUSBAPI) : BOOL; virtual; stdcall; abstract;

		// функции для работы с ЦАП
		Function GET_DAC_PARS(dm : pDAC_PARS_E440) : BOOL; virtual; stdcall; abstract;
		Function SET_DAC_PARS(dm : pDAC_PARS_E440) : BOOL; virtual; stdcall; abstract;
		Function START_DAC : BOOL; virtual; stdcall; abstract;
		Function STOP_DAC : BOOL; virtual; stdcall; abstract;
		Function WriteData(WriteRequest : pIO_REQUEST_LUSBAPI) : BOOL; virtual; stdcall; abstract;
		Function DAC_SAMPLE(DacData : pSHORT; DacChannel : WORD) : BOOL; virtual; stdcall; abstract;

		// функции для работы с цифровыми линиями
		Function ENABLE_TTL_OUT(EnableTtlOut : BOOL) : BOOL; virtual; stdcall; abstract;
		Function TTL_IN(TtlIn : pWORD) : BOOL; virtual; stdcall; abstract;
		Function TTL_OUT(TtlOut : WORD) : BOOL; virtual; stdcall; abstract;

		// функции для работы c пользовательским ППЗУ модуля
		Function ENABLE_FLASH_WRITE(EnableFlashWrite : BOOL) : BOOL; virtual; stdcall; abstract;
		Function READ_FLASH_WORD(FlashAddress : WORD; FlashWord : pSHORT) : BOOL; virtual; stdcall; abstract;
		Function WRITE_FLASH_WORD(FlashAddress : WORD; FlashWord : SHORT) : BOOL; virtual; stdcall; abstract;

		// функции для работы со служебной информацией из ППЗУ
		Function GET_MODULE_DESCRIPTION(ModuleDescription : pMODULE_DESCRIPTION_E440) : BOOL; virtual; stdcall; abstract;
		Function SAVE_MODULE_DESCRIPTION(ModuleDescription : pMODULE_DESCRIPTION_E440) : BOOL; virtual; stdcall; abstract;

		// функции для работы с памятью DSP
		Function PUT_LBIOS_WORD(Address : WORD; Data : SHORT) : BOOL; virtual; stdcall; abstract;
		Function GET_LBIOS_WORD(Address : WORD; Data : pSHORT) : BOOL; virtual; stdcall; abstract;
		Function PUT_DM_WORD(Address : WORD; Data : SHORT) : BOOL; virtual; stdcall; abstract;
		Function GET_DM_WORD(Address : WORD; Data : pSHORT) : BOOL; virtual; stdcall; abstract;
		Function PUT_PM_WORD(Address : WORD; Data : DWORD) : BOOL; virtual; stdcall; abstract;
		Function GET_PM_WORD(Address : WORD; Data : pDWORD) : BOOL; virtual; stdcall; abstract;
		Function PUT_DM_ARRAY(BaseAddress, NPoints : WORD; Data : pSHORT) : BOOL; virtual; stdcall; abstract;
		Function GET_DM_ARRAY(BaseAddress, NPoints : WORD; Data : pSHORT) : BOOL; virtual; stdcall; abstract;
		Function PUT_PM_ARRAY(BaseAddress, NPoints : WORD; Data : pDWORD) : BOOL; virtual; stdcall; abstract;
		Function GET_PM_ARRAY(BaseAddress, NPoints : WORD; Data : pDWORD) : BOOL; virtual; stdcall; abstract;

		// функции для работы с загрузочным ППЗУ модуля
		Function ERASE_BOOT_FLASH : BOOL; virtual; stdcall; abstract;
		Function PUT_ARRAY_BOOT_FLASH(BaseAddress, NBytes : DWORD; Data : pBYTE) : BOOL; virtual; stdcall; abstract;
		Function GET_ARRAY_BOOT_FLASH(BaseAddress, NBytes : DWORD; Data : pBYTE) : BOOL; virtual; stdcall; abstract;
	end;
	pILE440 = ^ILE440;

