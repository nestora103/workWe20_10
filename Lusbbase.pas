// *****************************************************************************
// предок всех классов для USB устройств от L-Card
// *****************************************************************************

type
	Lusbbase = class
		// функции общего назначения для работы с USB устройствами
		Function OpenLDevice(VirtualSlot : WORD) : BOOL; virtual; stdcall; abstract;
		Function CloseLDevice : BOOL; virtual; stdcall; abstract;
		Function ReleaseLInstance : BOOL; virtual; stdcall; abstract;
		// получение дескриптора устройства USB
		Function GetModuleHandle : THandle; virtual; stdcall; abstract;
		// получение названия используемого модуля
		Function GetModuleName(ModuleName : pAnsiChar) : BOOL; virtual; stdcall; abstract;
		// получение текущей скорости работы шины USB
		Function GetUsbSpeed(UsbSpeed : pBYTE) : BOOL; virtual; stdcall; abstract;
		// управления режимом низкого электропотребления модуля
		Function LowPowerMode(LowPowerFlag : BOOL) : BOOL; virtual; stdcall; abstract;
		// функция выдачи строки с последней ошибкой
		Function GetLastErrorInfo(LastErrorInfo : pLAST_ERROR_INFO_LUSBAPI) : BOOL; virtual; stdcall; abstract;
	end;
