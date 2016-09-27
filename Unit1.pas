//******************************************************************************
// ������ E20-10.
// ���������� ��������� � ������������ ���������� ����� ������ � ���
// � ������������� ������� ���������� ������ �� ���� � �������� �������� �������.
// ���� �������������� � ������ ������ ������� ��� �� ������� 5000 ���.
//******************************************************************************
unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Lusbapi, StdCtrls;

const
	// ������� ������ �� DataStep �������� ����� ������� � ����
	//NBlockToRead : WORD = 4*20;
	// ���-�� �������� �������
	ChannelsQuantity : WORD = $01{4};
	// ������� ����� ������
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
  // ������������� ������ �����
	hReadThread : THANDLE;
	ReadTid : DWORD;

	// ������������� ����� ������
	FileHandle: Integer;

	// ��������� ������ E20-10
	pModule : ILE2010;
	// ������ ���������� Lusbapi.dll
	DllVersion : DWORD;
	// ������������� ����������
	ModuleHandle : THandle;
	// �������� ������
	ModuleName: String;
	// �������� ������ ���� USB
	UsbSpeed : BYTE;
	// ��������� � ������ ����������� � ������
	ModuleDescription : MODULE_DESCRIPTION_E2010;
	// ��������� ���������� ������ ���
	ap : ADC_PARS_E2010;
	// ����� ����������������� ����
   UserFlash : USER_FLASH_E2010;
	// ��������� �������� ����� ������
	DataState : DATA_STATE_E2010;
	// ���-�� �������� � ������� ReadData
	DataStep : DWORD = 1024*1024;

	// �������� �������-���������
	Counter, OldCounter : WORD;
	// ��������� �� ����� ��� ������
	Buffer : TShortrArray;

	// ����� ������ ��� ���������� ������ ����� ������
	ReadThreadErrorNumber : WORD;
	// ������ ���������� ������� ����� ������
	IsReadThreadComplete : boolean;

	// *** ��������������� ���������� ***
	// ���������� ������������ ���������� ����� ���������� - ����������
	InputConsoleHandle : THandle;
	// ���������� ������������ ���������� ������ ���������� - �������
	OutputConsoleHandle : THandle;
	// ��� �������� ������������ �������� ����
	MaxX, MaxY : DWORD;
 	// ��������������� �������
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
// �������� ���������� ���������� ���������� ������� �� ���� ������
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
        // ������ �������� ����� ��������� ������ ������
        ReadThreadErrorNumber := 3;
        Result := false;
        break;
      end
    end;
  end;
end;


//==============================================================================
// ��������� ���������� ���������
//==============================================================================
procedure AbortProgram(ErrorString: string; AbortionFlag : bool = true);
{var
	i : WORD ;
begin
	// ��������� ��������� ������
	if pModule <> nil then
  begin
    // ��������� ��������� ������
    if not pModule.ReleaseLInstance() then
    begin
      //form1.mmo1.Lines.add(' ReleaseLInstance() --> Bad');
    end
    else
    begin
      //form1.mmo1.Lines.add(' ReleaseLInstance() --> OK');
    end;

    // ������� ��������� �� ��������� ������
    pModule := nil;
  end;

	// ��������� ������������� ������ ����� ������
	if hReadThread = THANDLE(nil) then
  begin
    CloseHandle(hReadThread);
  end;
	// ������� ���� ������
	if FileHandle <> -1 then
  begin
    FileClose(FileHandle);
  end;
	// ��������� ������ ��-��� ������� ������
	for i := 0 to 1 do
  begin
    Buffer[i] := nil;
  end;
	// ���� ����� - ������� ��������� � �������
	if ErrorString <> ' ' then
  begin
    MessageBox(HWND(nil), pCHAR(ErrorString), '������!!!', MB_OK + MB_ICONINFORMATION);
  end;
	// ���� ����� - �������� ��������� ���������
	if AbortionFlag = true then
  begin
    halt;
  end; }


var
	i : WORD ;
begin
  // ������� ��������� �� ��������� ������
  pModule := nil;
  // ��������� ������������� ������ ����� ������
	if hReadThread = THANDLE(nil) then CloseHandle(hReadThread);
  /////////////////////////////////
  // ��������� ������ ��-��� ������� ������
	for i := 0 to 1 do
  begin
    Buffer[i] := nil;
  end;
	if ErrorString <> ' ' then
  begin
    // ���� ����� - ������� ��������� � �������
    MessageBox(HWND(nil),pCHAR(ErrorString),'������!!!',
    MB_OK + MB_ICONINFORMATION);
  end;
	// ���� ����� - �������� ��������� ���������
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
  // ������� ����� ������ ������ �����
	ReadThreadErrorNumber := 0;
	// ������� ������ ������������� ������ ����� ������
	IsReadThreadComplete := false;
	// ���� �������� ����� ��� :(
	FileHandle := -1;
	// ������� ��������
	Counter := $0; OldCounter := $FFFF;

  // �������� ������ ������������ DLL ����������
	DllVersion := GetDllVersion;
	if DllVersion <> CURRENT_VERSION_LUSBAPI then
  begin
    Str := '�������� ������ DLL ���������� Lusbapi.dll! ' + #10#13 +
      '           �������: ' + IntToStr(DllVersion shr 16) +  '.'+
        IntToStr(DllVersion and $FFFF) + '.' +
          ' ���������: ' + IntToStr(CURRENT_VERSION_LUSBAPI shr 16) + '.' +
            IntToStr(CURRENT_VERSION_LUSBAPI and $FFFF) + '.';
    AbortProgram(Str);
  end
	else
  begin
    //form1.mmo1.Lines.add(' DLL Version --> OK');
  end;

	// ��������� �������� ��������� �� ��������� ��� ������ E20-10
	pModule := CreateLInstance(pCHAR('e2010'));
	if pModule = nil then
  begin
    AbortProgram('�� ���� ����� ��������� ������ E20-10!');
  end
	else
  begin
   //form1.mmo1.Lines.add(' Module Interface --> OK');
  end;

	// ��������� ���������� ������ E20-10 � ������ MAX_VIRTUAL_SLOTS_QUANTITY_LUSBAPI ����������� ������
	for i := 0 to MAX_VIRTUAL_SLOTS_QUANTITY_LUSBAPI-1 do
  begin
    if pModule.OpenLDevice(i) then
    begin
      break;
    end;
  end;

	// ���-������ ����������?
	if i = MAX_VIRTUAL_SLOTS_QUANTITY_LUSBAPI then
  begin
    AbortProgram('�� ������� ���������� ������ E20-10 � ������ 127 ����������� ������!');
  end
	else
  begin
    //form1.mmo1.Lines.add(Format(' OpenLDevice(%u) --> OK', [i]));
  end;

	// ������� ������������� ����������
	ModuleHandle := pModule.GetModuleHandle();

	// ��������� �������� ������ � ������� ����������� �����
	ModuleName := '0123456';
	if not pModule.GetModuleName(pCHAR(ModuleName)) then
  begin
    AbortProgram('�� ���� ��������� �������� ������!')
  end
	else
  begin
    //form1.mmo1.Lines.add(' GetModuleName() --> OK');
  end;

	// ��������, ��� ��� ������ E20-10
	if Boolean(AnsiCompareStr(ModuleName, 'E20-10')) then
  begin
    AbortProgram('������������ ������ �� �������� E20-10!');
  end
	else
  begin
    //form1.mmo1.Lines.add(' The module is ''E20-10''');
  end;

	// ��������� �������� �������� ������ ���� USB
	if not pModule.GetUsbSpeed(@UsbSpeed) then
  begin
    AbortProgram(' �� ���� ���������� �������� ������ ���� USB');
  end
	else
  begin
    //form1.mmo1.Lines.add(' GetUsbSpeed() --> OK\n');
  end;


	// ������ ��������� �������� ������ ���� USB
	if UsbSpeed = USB11_LUSBAPI then
  begin
    Str := 'Full-Speed Mode (12 Mbit/s)'
  end
  else
  begin
    Str := 'High-Speed Mode (480 Mbit/s)';
  end;

  //form1.mmo1.Lines.add(Format('   USB is in %s', [Str]));

	// ����� ��� ���� ������ �� ���������������� ������� DLL ���������� Lusbapi.dll
	if not pModule.LOAD_MODULE(nil) then
  begin
    AbortProgram('�� ���� ��������� ������ E20-10!');
  end
	else
  begin
    //form1.mmo1.Lines.add(' LOAD_MODULE() --> OK');
  end;

	// �������� �������� ������
 	if not pModule.TEST_MODULE() then
  begin
    AbortProgram('������ � �������� ������ E20-10!');
  end
	else
  begin
    //form1.mmo1.Lines.add(' TEST_MODULE() --> OK');
  end;

	// ������ ������� ����� ������ ������������ �������� DSP
	if not pModule.GET_MODULE_DESCRIPTION(@ModuleDescription) then
  begin
    AbortProgram('�� ���� �������� ���������� � ������!')
  end
	else
  begin
    //form1.mmo1.Lines.add(' GET_MODULE_DESCRIPTION() --> OK');
  end;

	// ��������� ��������� ���������� ����������������� ����
	if not pModule.READ_FLASH_ARRAY(@UserFlash) then
  begin
    AbortProgram('�� ���� ��������� ���������������� ����!');
  end
	else
  begin
    //form1.mmo1.Lines.add(' READ_FLASH_ARRAY() --> OK');
  end;

	// ������� ������� ��������� ������ ����� ������
	if not pModule.GET_ADC_PARS(@ap) then
  begin
    AbortProgram('�� ���� �������� ������� ��������� ����� ������!')
  end
	else
  begin
    //form1.mmo1.Lines.add(' GET_ADC_PARS --> OK');
  end;

	// ��������� �������� ��������� ����� ������ � ������ E20-10
	if ModuleDescription.Module.Revision = BYTE(REVISIONS_E2010[REVISION_A_E2010]) then
  begin
    // �������� �������������� ������������� ������ �� ������ ������ (��� Rev.A)
    ap.IsAdcCorrectionEnabled := FALSE;
  end
	else
  begin
    // �������� �������������� ������������� ������ �� ������ ������ (��� Rev.B � ����)
    ap.IsAdcCorrectionEnabled := TRUE;
    ap.SynchroPars.StartDelay := 0;
    ap.SynchroPars.StopAfterNKadrs := 0;
    ap.SynchroPars.SynchroAdMode := NO_ANALOG_SYNCHRO_E2010;
    //ap.SynchroPars.SynchroAdMode := ANALOG_SYNCHRO_ON_HIGH_LEVEL_E2010;
    ap.SynchroPars.SynchroAdChannel := $0;
    ap.SynchroPars.SynchroAdPorog := 0;
    ap.SynchroPars.IsBlockDataMarkerEnabled := $0;
  end;

  // ���������� ����� ����� � ���
	ap.SynchroPars.StartSource := INT_ADC_START_E2010;
  // ������� ����� ����� � ���
  //ap.SynchroPars.StartSource := EXT_ADC_START_ON_RISING_EDGE_E2010;
  // ���������� �������� �������� ���
	ap.SynchroPars.SynhroSource := INT_ADC_CLOCK_E2010;
  // �������� ����� ���������� ������� ������� ��� ������ �������� � ������� ��� (������ ��� Rev.A)
  //ap.OverloadMode := MARKER_OVERLOAD_E2010;
  // ������� �������� ����� ���������� ������� ������� ���� ����������� ������� ��� (������ ��� Rev.A)
	ap.OverloadMode := CLIPPING_OVERLOAD_E2010;
  // ���-�� �������� �������
	ap.ChannelsQuantity := ChannelsQuantity;

	for i:=0 to (ap.ChannelsQuantity-1) do
  begin
    ap.ControlTable[i] := i;
  end;

	// ������� ����� ����� ������������� � ����������� �� �������� USB
	ap.AdcRate := AdcRate;
  // ������� ��� ������ � ���
	if UsbSpeed = USB11_LUSBAPI then
  begin
    // ����������� �������� � ��
    ap.InterKadrDelay := 0.01;
    // ������ �������
    DataStep := 256*1024;
  end
	else
  begin
    // ����������� �������� � ��
    ap.InterKadrDelay := 0.0;
    // ������ �������
    DataStep := 1024*1024;
  end;

	// ���������� ������� ������
	for i:=0 to (ADC_CHANNELS_QUANTITY_E2010-1) do
  begin
    // ������� �������� 3�
    ap.InputRange[i] := ADC_INPUT_RANGE_3000mV_E2010;
    // �������� ����� - ������
    ap.InputSwitch[i] := ADC_INPUT_SIGNAL_E2010;
  end;
	// ������� � ��������� ���������� ������ ��� ���������������� ������������ ���
	for i:=0 to (ADC_INPUT_RANGES_QUANTITY_E2010-1) do
  begin
    for j:=0 to (ADC_CHANNELS_QUANTITY_E2010-1) do
		begin
			// ������������� ��������
			ap.AdcOffsetCoefs[i][j] := ModuleDescription.Adc.OffsetCalibration[j + i*ADC_CHANNELS_QUANTITY_E2010];
			// ������������� ��������
			ap.AdcScaleCoefs[i][j] := ModuleDescription.Adc.ScaleCalibration[j + i*ADC_CHANNELS_QUANTITY_E2010];
		end;
  end;


	// ��������� � ������ ��������� ��������� �� ����� ������
	if not pModule.SET_ADC_PARS(@ap) then
  begin
    AbortProgram('�� ���� ���������� ��������� ����� ������!');
  end
	else
  begin
    //form1.mmo1.Lines.add(' SET_ADC_PARS --> OK');
  end;

	// ��������� �������� ������ ���-�� ������ ��� ������ ������
	for i := 0 to 1 do
  begin
    SetLength(Buffer[i], DataStep);
    ZeroMemory(Buffer[i], DataStep*SizeOf(SHORT));
  end;
end;
//==============================================================================

//==============================================================================
//      ������ ����������� � �������� ���������� ������
//             ��� ����� ������ c ������ E20-10
//==============================================================================
function ReadThread(var param : pointer): DWORD;
var
	i : WORD ;
	RequestNumber : WORD;
	// ������ OVERLAPPED �������� �� ���� ���������
	ReadOv : array[0..1] of OVERLAPPED;
	// ������ �������� � ����������� ������� �� ����/����� ������
	IoReq : array[0..1] of IO_REQUEST_LUSBAPI;

  //mm:Integer;
begin
	Result := 0;
	// ��������� ������ ��� � ������������ ������� USB-����� ������ ������
	if not pModule.STOP_ADC() then
  begin
    ReadThreadErrorNumber := 1;
    IsReadThreadComplete := true;
    exit;
  end;

	// ��������� ����������� ��� ����� ������ ���������
	for i := 0 to 1 do
  begin
    // ������������� ��������� ���� OVERLAPPED
    ZeroMemory(@ReadOv[i], sizeof(OVERLAPPED));
    // ������ ������� ��� ������������ �������
    ReadOv[i].hEvent := CreateEvent(nil, FALSE , FALSE, nil);
    // ��������� ��������� IoReq
    IoReq[i].Buffer := Pointer(Buffer[i]);
    IoReq[i].NumberOfWordsToPass := DataStep;
    IoReq[i].NumberOfWordsPassed := 0;
    IoReq[i].Overlapped := @ReadOv[i];
    IoReq[i].TimeOut := Round(Int(DataStep/ap.KadrRate)) + 1000;
  end;

	// ������� ������� ������ ����������� ���� ������ � Buffer
	RequestNumber := 0;
	if not pModule.ReadData(@IoReq[RequestNumber]) then
  begin
    CloseHandle(IoReq[0].Overlapped.hEvent);
    CloseHandle(IoReq[1].Overlapped.hEvent);
    ReadThreadErrorNumber := 2;
    IsReadThreadComplete := true;
    exit;
  end;

	// � ������ ����� ��������� ���� ������
	if pModule.START_ADC() then
  begin
    // ���� ����� ������
    //for i := 1 to (NBlockToRead-1) do
    while(true) do
    begin
      // ������� ��������� ������ � ���
      RequestNumber := RequestNumber xor $1;
      // ������� ������ �� ��������� ������ �������� ������
      if not pModule.ReadData(@IoReq[RequestNumber]) then
      begin
          ReadThreadErrorNumber := 2;
          break;
      end;
      if not WaitingForRequestCompleted(IoReq[RequestNumber xor $1].Overlapped^) then
      begin
          // �������� ���������� ���������� ������� �� ���� ������
          break;
      end;
      // ����� �����




      
      // ������� ��������� ������ � ���
      if ReadThreadErrorNumber <> 0 then
      begin
          // ���� �� ������ ��� ������������ ������� ���� ������?
          break;
      end;
      // ����������� ������� ���������� ������ ������
      Inc(Counter);

      form1.lbl1.Caption:=IntToStr(Counter);
    end
  end
	else
  begin
    ReadThreadErrorNumber := 6;
  end;

    // ��������� ������ ������ ���
	if ReadThreadErrorNumber = 0 then
 	begin
    // ��� ��������� �������� ����� ��������� ������ ������
		if WaitingForRequestCompleted(IoReq[RequestNumber].Overlapped^) then
		begin
      // �������� ������� ���������� ������ ������
      Inc(Counter);
      ///////////////////////////////////

    end;
  end;

 	if not pModule.STOP_ADC() then
 	begin
    // ��������� ���� ������
		ReadThreadErrorNumber := 1;
  end;
	if not CancelIo(ModuleHandle) then
  begin
    // ���� ����, �� ������ ������������� ����������� ������
    ReadThreadErrorNumber := 7;
  end;

  // ��������� �������������� �������
	CloseHandle(IoReq[0].Overlapped.hEvent);
  CloseHandle(IoReq[1].Overlapped.hEvent);
  // ��������� ������ ��������� ������ ����� ������
  IsReadThreadComplete := true;
end;

//==============================================================================
//����� ����� ������ � ���
//==============================================================================
procedure AdcStart();
begin
  //form1.Memo1.Clear();
  pModule.STOP_ADC();
  // ������� ����� ������ ������ �����
  ReadThreadErrorNumber := 0;
  // ������� ������ ������������� ������ ����� ������
  IsReadThreadComplete := false;
  hReadThread := CreateThread(nil, $2000, @ReadThread, nil, 0, ReadTid);
end;
//==============================================================================

//==============================================================================
//��������� ����� ������ � ���
//==============================================================================
procedure AdcStop ();
begin
	ReadThreadErrorNumber:=4;
  //--------------------------------��������� �����-----------------------------
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
// ����������� ������ ��������� �� ����� ������ ������ ����� ������
//==============================================================================
{procedure ShowThreadErrorMessage;
begin
  case ReadThreadErrorNumber of
		$0 : ;
		$1 : form1.mmo1.Lines.add(' ADC Thread: STOP_ADC() --> Bad! :(((');
		$2 : form1.mmo1.Lines.add(' ADC Thread: ReadData() --> Bad :(((');
		$3 : form1.mmo1.Lines.add(' ADC Thread: Waiting data Error! :(((');
		// ���� ��������� ���� ������ ��������, ��������� ���� ��������
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
  if form1.btn1.Caption='�����' then
  begin
    //����� ����� ������ � ���
    AdcStart;

    //DataHandlerPotoc:=DataHandler1.Create(false);
    //DataHandlerPotoc.Priority:=tpNormal{tpHigher};

    ProgramRun:=True;       // ��������� ���� ��������
    //CompareCalibration_mV1:=StrToFloat(Form1.edt1.Text);
    //CompareCalibration_Omh1:=StrToFloat(Form1.edt2.Text);
    //Form1.tmr1.Enabled:=True;
    //Form1.tmr2.Enabled:=True;
    //Form1.tmr3.Enabled:=True;
    form1.btn1.Caption:='����';
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
        //ProgramRun:=False;   // ��������� ���� ���������
    end;
    //Form1.tmr1.Enabled:=False;
    //Form1.tmr2.Enabled:=False;
    //Form1.tmr3.Enabled:=False;
    //GetDatStr(m_instr_usbtmc[0],CurrentVolt);
    form1.btn1.Caption:='�����';
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
  //ReceiveActive:= True;  // ���� �������� �� ��� ��� ����� � ��� �������� � 32 ������ ��������� ����������
  //buf_wr_i:=0;            // �������� ������ ������
  //buf_rd_i:=0;            // �������� ������ ������
  //buf_fill:=0;            // �������� ���������� ������ � ������
  DecimalSeparator := '.';// ����� � �������� �����������
  //OutEnable:=False  ;     // ����� �� ��������� / ����������� ��������
  //NextState:=0;           // ������� ��������� ��������� ������� ������ - 0
  ProgramRun:=false;      // ����� ��� �� ����������


end;

end.
