//******************************************************************************
// Модуль E20-10.
// Консольная программа с организацией потокового ввода данных с АЦП
// с одновременной записью получаемых данных на диск в реальном масштабе времени.
// Ввод осуществляется с первых четырёх каналов АЦП на частоте 5000 кГц.
//******************************************************************************
unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Lusbapi, StdCtrls;

const
	// столько блоков по DataStep отсчётов нужно собрать в файл
	//NBlockToRead : WORD = 4*20;
	// кол-во активных каналов
	ChannelsQuantity : WORD = $01{4};
	// частота ввода данных
	AdcRate : double  = 10000.0{5000.0};

type
  TShortrArray = array [0..1] of array of SHORT;
  TForm1 = class(TForm)
    btn1: TButton;
    lbl1: TLabel;
    procedure btn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  // идентификатор потока ввода
	hReadThread : THANDLE;
	ReadTid : DWORD;

	// Идентификатор файла данных
	FileHandle: Integer;

	// интерфейс модуля E20-10
	pModule : ILE2010;
	// версия библиотеки Lusbapi.dll
	DllVersion : DWORD;
	// идентификатор устройства
	ModuleHandle : THandle;
	// название модуля
	ModuleName: String;
	// скорость работы шины USB
	UsbSpeed : BYTE;
	// структура с полной информацией о модуле
	ModuleDescription : MODULE_DESCRIPTION_E2010;
	// структура параметров работы АЦП
	ap : ADC_PARS_E2010;
	// буфер пользовательского ППЗУ
   UserFlash : USER_FLASH_E2010;
	// состояние процесса сбора данных
	DataState : DATA_STATE_E2010;
	// кол-во отсчетов в запросе ReadData
	DataStep : DWORD = 1024*1024;

	// экранный счетчик-индикатор
	Counter, OldCounter : WORD;
	// указатель на буфер для данных
	Buffer : TShortrArray;

	// номер ошибки при выполнения потока сбора данных
	ReadThreadErrorNumber : WORD;
	// флажок завершения потоков ввода данных
	IsReadThreadComplete : boolean;

	// *** вспомогательные переменные ***
	// Дескриптор стандартного устройства ввода компьютера - клавиатура
	InputConsoleHandle : THandle;
	// Дескриптор стандартного устройства вывода компьютера - дисплей
	OutputConsoleHandle : THandle;
	// Для хранения максимальных размеров окна
	MaxX, MaxY : DWORD;
 	// вспомогательная строчка
	Str : string;

  ProgramRun:Boolean;
  procedure AbortProgram(ErrorString: string; AbortionFlag : bool = true);
  procedure AdcInit();
  procedure AdcStart();
  procedure AdcStop ();
  function ReadThread(var param : pointer): DWORD;
  //procedure ShowThreadErrorMessage;
  function WaitingForRequestCompleted(var ReadOv : OVERLAPPED) : boolean;

implementation

{$R *.dfm}

//==============================================================================
// Ожидание завершения выполнения очередного запроса на сбор данных
//==============================================================================
function WaitingForRequestCompleted(var ReadOv : OVERLAPPED) : boolean;
var
    BytesTransferred : DWORD;
begin
  Result := true;
  while true do
	begin
    if GetOverlappedResult(ModuleHandle, ReadOv, BytesTransferred, FALSE) then
		begin
			break;
    end
		else
    begin
      if (GetLastError() <>  ERROR_IO_INCOMPLETE) then
      begin
        // ошибка ожидания ввода очередной порции данных
        ReadThreadErrorNumber := 3;
        Result := false;
        break;
      end
    end;
  end;
end;


//==============================================================================
// аварийное завершение программы
//==============================================================================
procedure AbortProgram(ErrorString: string; AbortionFlag : bool = true);
{var
	i : WORD ;
begin
	// освободим интерфейс модуля
	if pModule <> nil then
  begin
    // освободим интерфейс модуля
    if not pModule.ReleaseLInstance() then
    begin
      //form1.mmo1.Lines.add(' ReleaseLInstance() --> Bad');
    end
    else
    begin
      //form1.mmo1.Lines.add(' ReleaseLInstance() --> OK');
    end;

    // обнулим указатель на интерфейс модуля
    pModule := nil;
  end;

	// освободим идентификатор потока сбора данных
	if hReadThread = THANDLE(nil) then
  begin
    CloseHandle(hReadThread);
  end;
	// закроем файл данных
	if FileHandle <> -1 then
  begin
    FileClose(FileHandle);
  end;
	// освободим память из-под буферов данных
	for i := 0 to 1 do
  begin
    Buffer[i] := nil;
  end;
	// если нужно - выводим сообщение с ошибкой
	if ErrorString <> ' ' then
  begin
    MessageBox(HWND(nil), pCHAR(ErrorString), 'ОШИБКА!!!', MB_OK + MB_ICONINFORMATION);
  end;
	// если нужно - аварийно завершаем программу
	if AbortionFlag = true then
  begin
    halt;
  end; }


var
	i : WORD ;
begin
  // обнулим указатель на интерфейс модуля
  pModule := nil;
  // освободим идентификатор потока сбора данных
	if hReadThread = THANDLE(nil) then CloseHandle(hReadThread);
  /////////////////////////////////
  // освободим память из-под буферов данных
	for i := 0 to 1 do
  begin
    Buffer[i] := nil;
  end;
	if ErrorString <> ' ' then
  begin
    // если нужно - выводим сообщение с ошибкой
    MessageBox(HWND(nil),pCHAR(ErrorString),'ОШИБКА!!!',
    MB_OK + MB_ICONINFORMATION);
  end;
	// если нужно - аварийно завершаем программу
	if AbortionFlag = true then halt;
end;
//==============================================================================






//==============================================================================
//
//==============================================================================
procedure AdcInit();
var
	i,j:integer;
	str:string;

  //iGeneralTh:Integer;
  //jGeneralTh:Integer;
begin
  // сбросим флаги ошибки потока ввода
	ReadThreadErrorNumber := 0;
	// сбросим флажок завершённости потока сбора данных
	IsReadThreadComplete := false;
	// пока откытого файла нет :(
	FileHandle := -1;
	// сбросим счётчики
	Counter := $0; OldCounter := $FFFF;

  // проверим версию используемой DLL библиотеки
	DllVersion := GetDllVersion;
	if DllVersion <> CURRENT_VERSION_LUSBAPI then
  begin
    Str := 'Неверная версия DLL библиотеки Lusbapi.dll! ' + #10#13 +
      '           Текущая: ' + IntToStr(DllVersion shr 16) +  '.'+
        IntToStr(DllVersion and $FFFF) + '.' +
          ' Требуется: ' + IntToStr(CURRENT_VERSION_LUSBAPI shr 16) + '.' +
            IntToStr(CURRENT_VERSION_LUSBAPI and $FFFF) + '.';
    AbortProgram(Str);
  end
	else
  begin
    //form1.mmo1.Lines.add(' DLL Version --> OK');
  end;

	// попробуем получить указатель на интерфейс для модуля E20-10
	pModule := CreateLInstance(pCHAR('e2010'));
	if pModule = nil then
  begin
    AbortProgram('Не могу найти интерфейс модуля E20-10!');
  end
	else
  begin
   //form1.mmo1.Lines.add(' Module Interface --> OK');
  end;

	// попробуем обнаружить модуль E20-10 в первых MAX_VIRTUAL_SLOTS_QUANTITY_LUSBAPI виртуальных слотах
	for i := 0 to MAX_VIRTUAL_SLOTS_QUANTITY_LUSBAPI-1 do
  begin
    if pModule.OpenLDevice(i) then
    begin
      break;
    end;
  end;

	// что-нибудь обнаружили?
	if i = MAX_VIRTUAL_SLOTS_QUANTITY_LUSBAPI then
  begin
    AbortProgram('Не удалось обнаружить модуль E20-10 в первых 127 виртуальных слотах!');
  end
	else
  begin
    //form1.mmo1.Lines.add(Format(' OpenLDevice(%u) --> OK', [i]));
  end;

	// получим идентификатор устройства
	ModuleHandle := pModule.GetModuleHandle();

	// прочитаем название модуля в текущем виртуальном слоте
	ModuleName := '0123456';
	if not pModule.GetModuleName(pCHAR(ModuleName)) then
  begin
    AbortProgram('Не могу прочитать название модуля!')
  end
	else
  begin
    //form1.mmo1.Lines.add(' GetModuleName() --> OK');
  end;

	// проверим, что это модуль E20-10
	if Boolean(AnsiCompareStr(ModuleName, 'E20-10')) then
  begin
    AbortProgram('Обнаруженный модуль не является E20-10!');
  end
	else
  begin
    //form1.mmo1.Lines.add(' The module is ''E20-10''');
  end;

	// попробуем получить скорость работы шины USB
	if not pModule.GetUsbSpeed(@UsbSpeed) then
  begin
    AbortProgram(' Не могу определить скорость работы шины USB');
  end
	else
  begin
    //form1.mmo1.Lines.add(' GetUsbSpeed() --> OK\n');
  end;


	// теперь отобразим скорость работы шины USB
	if UsbSpeed = USB11_LUSBAPI then
  begin
    Str := 'Full-Speed Mode (12 Mbit/s)'
  end
  else
  begin
    Str := 'High-Speed Mode (480 Mbit/s)';
  end;

  //form1.mmo1.Lines.add(Format('   USB is in %s', [Str]));

	// Образ для ПЛИС возьмём из соответствующего ресурса DLL библиотеки Lusbapi.dll
	if not pModule.LOAD_MODULE(nil) then
  begin
    AbortProgram('Не могу загрузить модуль E20-10!');
  end
	else
  begin
    //form1.mmo1.Lines.add(' LOAD_MODULE() --> OK');
  end;

	// проверим загрузку модуля
 	if not pModule.TEST_MODULE() then
  begin
    AbortProgram('Ошибка в загрузке модуля E20-10!');
  end
	else
  begin
    //form1.mmo1.Lines.add(' TEST_MODULE() --> OK');
  end;

	// теперь получим номер версии загруженного драйвера DSP
	if not pModule.GET_MODULE_DESCRIPTION(@ModuleDescription) then
  begin
    AbortProgram('Не могу получить информацию о модуле!')
  end
	else
  begin
    //form1.mmo1.Lines.add(' GET_MODULE_DESCRIPTION() --> OK');
  end;

	// попробуем прочитать содержимое пользовательского ППЗУ
	if not pModule.READ_FLASH_ARRAY(@UserFlash) then
  begin
    AbortProgram('Не могу прочитать пользовательское ППЗУ!');
  end
	else
  begin
    //form1.mmo1.Lines.add(' READ_FLASH_ARRAY() --> OK');
  end;

	// получим текущие параметры работы ввода данных
	if not pModule.GET_ADC_PARS(@ap) then
  begin
    AbortProgram('Не могу получить текущие параметры ввода данных!')
  end
	else
  begin
    //form1.mmo1.Lines.add(' GET_ADC_PARS --> OK');
  end;

	// установим желаемые параметры ввода данных с модуля E20-10
	if ModuleDescription.Module.Revision = BYTE(REVISIONS_E2010[REVISION_A_E2010]) then
  begin
    // запретим автоматическую корректировку данных на уровне модуля (для Rev.A)
    ap.IsAdcCorrectionEnabled := FALSE;
  end
	else
  begin
    // разрешим автоматическую корректировку данных на уровне модуля (для Rev.B и выше)
    ap.IsAdcCorrectionEnabled := TRUE;
    ap.SynchroPars.StartDelay := 0;
    ap.SynchroPars.StopAfterNKadrs := 0;
    ap.SynchroPars.SynchroAdMode := NO_ANALOG_SYNCHRO_E2010;
    //ap.SynchroPars.SynchroAdMode := ANALOG_SYNCHRO_ON_HIGH_LEVEL_E2010;
    ap.SynchroPars.SynchroAdChannel := $0;
    ap.SynchroPars.SynchroAdPorog := 0;
    ap.SynchroPars.IsBlockDataMarkerEnabled := $0;
  end;

  // внутренний старт сбора с АЦП
	ap.SynchroPars.StartSource := INT_ADC_START_E2010;
  // внешний старт сбора с АЦП
  //ap.SynchroPars.StartSource := EXT_ADC_START_ON_RISING_EDGE_E2010;
  // внутренние тактовые импульсы АЦП
	ap.SynchroPars.SynhroSource := INT_ADC_CLOCK_E2010;
  // фиксация факта перегрузки входных каналов при помощи маркеров в отсчёте АЦП (только для Rev.A)
  //ap.OverloadMode := MARKER_OVERLOAD_E2010;
  // обычная фиксация факта перегрузки входных каналов путём ограничения отсчёта АЦП (только для Rev.A)
	ap.OverloadMode := CLIPPING_OVERLOAD_E2010;
  // кол-во активных каналов
	ap.ChannelsQuantity := ChannelsQuantity;

	for i:=0 to (ap.ChannelsQuantity-1) do
  begin
    ap.ControlTable[i] := i;
  end;

	// частоту сбора будем устанавливать в зависимости от скорости USB
	ap.AdcRate := AdcRate;
  // частота АЦП данных в кГц
	if UsbSpeed = USB11_LUSBAPI then
  begin
    // межкадровая задержка в мс
    ap.InterKadrDelay := 0.01;
    // размер запроса
    DataStep := 256*1024;
  end
	else
  begin
    // межкадровая задержка в мс
    ap.InterKadrDelay := 0.0;
    // размер запроса
    DataStep := 1024*1024;
  end;

	// конфигурим входные каналы
	for i:=0 to (ADC_CHANNELS_QUANTITY_E2010-1) do
  begin
    // входной диапазон 3В
    ap.InputRange[i] := ADC_INPUT_RANGE_3000mV_E2010;
    // источник входа - сигнал
    ap.InputSwitch[i] := ADC_INPUT_SIGNAL_E2010;
  end;
	// передаём в структуру параметров работы АЦП корректировочные коэффициенты АЦП
	for i:=0 to (ADC_INPUT_RANGES_QUANTITY_E2010-1) do
  begin
    for j:=0 to (ADC_CHANNELS_QUANTITY_E2010-1) do
		begin
			// корректировка смещения
			ap.AdcOffsetCoefs[i][j] := ModuleDescription.Adc.OffsetCalibration[j + i*ADC_CHANNELS_QUANTITY_E2010];
			// корректировка масштаба
			ap.AdcScaleCoefs[i][j] := ModuleDescription.Adc.ScaleCalibration[j + i*ADC_CHANNELS_QUANTITY_E2010];
		end;
  end;


	// передадим в модуль требуемые параметры по вводу данных
	if not pModule.SET_ADC_PARS(@ap) then
  begin
    AbortProgram('Не могу установить параметры ввода данных!');
  end
	else
  begin
    //form1.mmo1.Lines.add(' SET_ADC_PARS --> OK');
  end;

	// попробуем выделить нужное кол-во памяти под буфера данных
	for i := 0 to 1 do
  begin
    SetLength(Buffer[i], DataStep);
    ZeroMemory(Buffer[i], DataStep*SizeOf(SHORT));
  end;
end;
//==============================================================================

//==============================================================================
//      фукция запускаемая в качестве отдельного потока
//             для сбора данных c модуля E20-10
//==============================================================================
function ReadThread(var param : pointer): DWORD;
var
	i : WORD ;
	RequestNumber : WORD;
	// массив OVERLAPPED структур из двух элементов
	ReadOv : array[0..1] of OVERLAPPED;
	// массив структур с параметрами запроса на ввод/вывод данных
	IoReq : array[0..1] of IO_REQUEST_LUSBAPI;

  //mm:Integer;
begin
	Result := 0;
	// остановим работу АЦП и одновременно сбросим USB-канал чтения данных
	if not pModule.STOP_ADC() then
  begin
    ReadThreadErrorNumber := 1;
    IsReadThreadComplete := true;
    exit;
  end;

	// формируем необходимые для сбора данных структуры
	for i := 0 to 1 do
  begin
    // инициализация структуры типа OVERLAPPED
    ZeroMemory(@ReadOv[i], sizeof(OVERLAPPED));
    // создаём событие для асинхронного запроса
    ReadOv[i].hEvent := CreateEvent(nil, FALSE , FALSE, nil);
    // формируем структуру IoReq
    IoReq[i].Buffer := Pointer(Buffer[i]);
    IoReq[i].NumberOfWordsToPass := DataStep;
    IoReq[i].NumberOfWordsPassed := 0;
    IoReq[i].Overlapped := @ReadOv[i];
    IoReq[i].TimeOut := Round(Int(DataStep/ap.KadrRate)) + 1000;
  end;

	// заранее закажем первый асинхронный сбор данных в Buffer
	RequestNumber := 0;
	if not pModule.ReadData(@IoReq[RequestNumber]) then
  begin
    CloseHandle(IoReq[0].Overlapped.hEvent);
    CloseHandle(IoReq[1].Overlapped.hEvent);
    ReadThreadErrorNumber := 2;
    IsReadThreadComplete := true;
    exit;
  end;

	// а теперь можно запускать сбор данных
	if pModule.START_ADC() then
  begin
    // цикл сбора данных
    //for i := 1 to (NBlockToRead-1) do
    while(true) do
    begin
      // Семафор обработки данных с АЦП
      RequestNumber := RequestNumber xor $1;
      // сделаем запрос на очередную порции вводимых данных
      if not pModule.ReadData(@IoReq[RequestNumber]) then
      begin
          ReadThreadErrorNumber := 2;
          break;
      end;
      if not WaitingForRequestCompleted(IoReq[RequestNumber xor $1].Overlapped^) then
      begin
          // ожидание выполнение очередного запроса на сбор данных
          break;
      end;
      // Буфер готов




      
      // Семафор обработки данных с АЦП
      if ReadThreadErrorNumber <> 0 then
      begin
          // были ли ошибки или пользователь прервал ввод данных?
          break;
      end;
      // увеличиваем счётчик полученных блоков данных
      Inc(Counter);

      form1.lbl1.Caption:=IntToStr(Counter);
    end
  end
	else
  begin
    ReadThreadErrorNumber := 6;
  end;

    // последняя порция данных АЦП
	if ReadThreadErrorNumber = 0 then
 	begin
    // ждём окончания операции сбора последней порции данных
		if WaitingForRequestCompleted(IoReq[RequestNumber].Overlapped^) then
		begin
      // увеличим счётчик полученных блоков данных
      Inc(Counter);
      ///////////////////////////////////

    end;
  end;

 	if not pModule.STOP_ADC() then
 	begin
    // остановим сбор данных
		ReadThreadErrorNumber := 1;
  end;
	if not CancelIo(ModuleHandle) then
  begin
    // если надо, то прервём незавершённый асинхронный запрос
    ReadThreadErrorNumber := 7;
  end;

  // освободим идентификаторы событий
	CloseHandle(IoReq[0].Overlapped.hEvent);
  CloseHandle(IoReq[1].Overlapped.hEvent);
  // установим флажок окончания потока сбора данных
  IsReadThreadComplete := true;
end;

//==============================================================================
//Старт сбора данных с АЦП
//==============================================================================
procedure AdcStart();
begin
  //form1.Memo1.Clear();
  pModule.STOP_ADC();
  // сбросим флаги ошибки потока ввода
  ReadThreadErrorNumber := 0;
  // сбросим флажок завершённости потока сбора данных
  IsReadThreadComplete := false;
  hReadThread := CreateThread(nil, $2000, @ReadThread, nil, 0, ReadTid);
end;
//==============================================================================

//==============================================================================
//Остановка сбора данных с АЦП
//==============================================================================
procedure AdcStop ();
begin
	ReadThreadErrorNumber:=4;
  //--------------------------------Закрываем поток-----------------------------
  WaitForSingleObject(hReadThread, 5500);    //INFINITE
  if hReadThread <> THANDLE(nil) then
  begin
    CloseHandle(hReadThread);
    Application.ProcessMessages;
    sleep(500);
    hReadThread:=THANDLE(nil);
  end;
  Counter:=0;
  //  halt;
end;
//==============================================================================





//==============================================================================
// отображение ошибок возникших во время работы потока сбора данных
//==============================================================================
{procedure ShowThreadErrorMessage;
begin
  case ReadThreadErrorNumber of
		$0 : ;
		$1 : form1.mmo1.Lines.add(' ADC Thread: STOP_ADC() --> Bad! :(((');
		$2 : form1.mmo1.Lines.add(' ADC Thread: ReadData() --> Bad :(((');
		$3 : form1.mmo1.Lines.add(' ADC Thread: Waiting data Error! :(((');
		// если программа была злобно прервана, предъявим ноту протеста
		$4 : form1.mmo1.Lines.add(' ADC Thread: The program was terminated! :(((');
		$5 : form1.mmo1.Lines.add(' ADC Thread: Writing data file error! :(((');
		$6 : form1.mmo1.Lines.add(' ADC Thread: START_ADC() --> Bad :(((');
		$7 : form1.mmo1.Lines.add(' ADC Thread: GET_DATA_STATE() --> Bad :(((');
		$8 : form1.mmo1.Lines.add(' ADC Thread: BUFFER OVERRUN --> Bad :(((');
		$9 : form1.mmo1.Lines.add(' ADC Thread: Can''t cancel pending input and output (I/O) operations! :(((');
		else form1.mmo1.Lines.add(' ADC Thread: Unknown error! :(((');
	end;
end;}
//==============================================================================

procedure TForm1.btn1Click(Sender: TObject);
//var
//i,j:Integer;
begin
  if form1.btn1.Caption='Старт' then
  begin
    //старт сбора данных с АЦП
    AdcStart;

    //DataHandlerPotoc:=DataHandler1.Create(false);
    //DataHandlerPotoc.Priority:=tpNormal{tpHigher};

    ProgramRun:=True;       // Программа была запущена
    //CompareCalibration_mV1:=StrToFloat(Form1.edt1.Text);
    //CompareCalibration_Omh1:=StrToFloat(Form1.edt2.Text);
    //Form1.tmr1.Enabled:=True;
    //Form1.tmr2.Enabled:=True;
    //Form1.tmr3.Enabled:=True;
    form1.btn1.Caption:='Стоп';
  end
  else
  begin
    AdcStop;
    //form1.diaTimer.Enabled:=false;
    //outToGist:=false;
    //Application.ProcessMessages;
    //sleep(50);
    //form1.Chart1.Series[0].Clear;
    //form1.Chart2.Series[0].Clear;
    if(ProgramRun=True)then
    begin
        //DataHandlerPotoc.Terminate;
        //CloseFile(Filehandle);
        //ProgramRun:=False;   // Программа была выключена
    end;
    //Form1.tmr1.Enabled:=False;
    //Form1.tmr2.Enabled:=False;
    //Form1.tmr3.Enabled:=False;
    //GetDatStr(m_instr_usbtmc[0],CurrentVolt);
    form1.btn1.Caption:='Старт';
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if(ProgramRun=True)then
  begin
      //DataHandlerPotoc.Terminate;
      //CloseFile(Filehandle);
      //ProgramRun:=False;
  end;
  //GetDatStr(m_instr_usbtmc[0],volt);
  //Form1.tmr3.Enabled:=False;
  AdcStop;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  AdcInit();
  //ReceiveActive:= True;  // Флаг следящий за тем что линии с Ацп приходят и 32 канала находятся программой
  //buf_wr_i:=0;            // Обнуляем индекс записи
  //buf_rd_i:=0;            // Обнуляем индекс чтения
  //buf_fill:=0;            // Обнуляем количество данных в буфере
  DecimalSeparator := '.';// Точка в качестве разделителя
  //OutEnable:=False  ;     // Вывод на диограмму / гистограмму запрещен
  //NextState:=0;           // Текущее состояние обработки каналов данных - 0
  ProgramRun:=false;      // Опрос АЦП не запускался


end;

end.
