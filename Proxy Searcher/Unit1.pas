unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Graphics, Forms, Dialogs, ComCtrls,
  StdCtrls, Classes, Controls, CheckLst, Menus, ExtCtrls, ImgList,
  IdTCPClient, IdHTTP, IdTCPConnection, IdComponent, IdBaseComponent,
  System.ImageList, Vcl.Samples.Spin, IniFiles, ShellApi, Registry,
  ClipBrd;

type
  TForm1 = class(TForm)
    IdHTTP1: TIdHTTP;
    Ligne1: TMenuItem;
    Add2: TMenuItem;
    Add1: TMenuItem;
    Modify2: TMenuItem;
    Modify1: TMenuItem;
    ListView1: TListView;
    MainMenu1: TMainMenu;
    Delete2: TMenuItem;
    Delete1: TMenuItem;
    DisableReg1: TMenuItem;
    DisableReg2: TMenuItem;
    PopupMenu1: TPopupMenu;
    ImageList1: TImageList;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    RefreshAll1: TMenuItem;
    EnableReg1: TMenuItem;
    EnableReg2: TMenuItem;
    Import: TMenuItem;
    Export: TMenuItem;
    Importerlisteproxy2: TMenuItem;
    Exporterlisteproxy2: TMenuItem;
    Timer1: TTimer;
    Refresh1: TMenuItem;
    Stop1: TMenuItem;
    EditProxy1: TMenuItem;
    EditProxy2: TMenuItem;
    StatusBar1: TStatusBar;
    Splitter1: TSplitter;
    Panel1: TPanel;
    Memo1: TMemo;
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    SpinEdit3: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox11: TCheckBox;
    CheckBox12: TCheckBox;
    CheckBox13: TCheckBox;
    ComboBox1: TComboBox;
    Label5: TLabel;
    Edit10: TEdit;
    Edit11: TEdit;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Button2: TButton;
    Button3: TButton;
    Edit4: TEdit;
    Label9: TLabel;
    Label8: TLabel;
    Edit3: TEdit;
    Edit2: TEdit;
    Edit1: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Label10: TLabel;
    SpinEdit4: TSpinEdit;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Button4: TButton;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Button1: TButton;
    Button5: TButton;
    Label17: TLabel;
    Label18: TLabel;
    Options1: TMenuItem;
    Backup1: TMenuItem;
    Panel2: TMenuItem;
    LoadBackup1: TMenuItem;
    N2: TMenuItem;
    LoadBackup2: TMenuItem;
    Edit9: TEdit;
    Label19: TLabel;
    Label20: TLabel;
    FontDialog1: TFontDialog;
    Font1: TMenuItem;
    N6: TMenuItem;
    CheckBox14: TCheckBox;
    Copy1: TMenuItem;
    procedure Modify2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
    procedure ListView1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ListView1Edited(Sender: TObject; Item: TListItem;
      var S: String);
    procedure Timer1Timer(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure ImportClick(Sender: TObject);
    procedure ExportClick(Sender: TObject);
    procedure EditProxy1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Add1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure Stop1Click(Sender: TObject);
    procedure Refresh1Click(Sender: TObject);
    procedure RefreshAll1Click(Sender: TObject);
    procedure EnableReg1Click(Sender: TObject);
    procedure DisableReg1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Memo1Change(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Backup1Click(Sender: TObject);
    procedure Panel2Click(Sender: TObject);
    procedure LoadBackup1Click(Sender: TObject);
    procedure LoadBackup2Click(Sender: TObject);
    procedure Font1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
  private
    { Private declarations }
    function ExtractIPAddress(S:string):string;
    function ExcerptPort(S:string):Integer;
    procedure LoadProxys();
    procedure SaveProxys();
    procedure AddAColumn(NewColumn: TListColumn; Title:string; Large:integer);
    procedure EditLine(ListItem: TListItem; Ligne:integer; ImageNum:integer = -1;
      Colone1: string = ''; Colone2: string = '');
    procedure SearchProxys();
    procedure RefreshProxies();
    procedure TestTheProxy(LigneATester:integer; Wait:integer);
    procedure StopAllTests();
    procedure WriteOptions;
    procedure ReadOptions;
  public
    { Public declarations }
  end;

  TTestProxy = class(TThread)
  protected
    procedure TestProxy(Ligne: integer);
    function TimeElapsed(ElipsedTime: extended):integer;
    function RequestToProxy(ProxyAdresse:string; ProxyPort:integer; URL:string;
      TextAFind:string):boolean;
    procedure Execute; override;
  public
    ProxyIndex: integer;
    WaitB4Test: integer;
    { Public declarations }
  end;

var
  Form1: TForm1;
  TestProxy: array of TTestProxy;
  IdHTTPArray: array of TIdHTTP;
  ClosureRequested: boolean;
  TIF : TIniFile;
  abort : Boolean;
  found : integer = 0;

const
  UNKNOWN      = 0;
  SLOW         = 1;
  EXTINCT      = 2;
  ACTIV        = 3;
  FORMATERROR  = 4;
  TESTPROGRESS = 5;
  TIMEOUT      = 6;
  StatusProxy: array[0..6] of string =  ('Unknown State..',
                                         'Slow',
                                         'Rejected',
                                         'Activ',
                                         'False address',
                                         'Queue in Process, ',
                                         'Off (Timeout)');

const
  PROXYLIST = 'Data\Proxys\ProxyList.ini';
  INTERNETSETTINGSREGPATH = '\Software\Microsoft\Windows\CurrentVersion\Internet Settings\';
  //This line is for the Internet Explorer use it when you want
  //LASTURLTYPEDPATH = 'Software\Microsoft\Internet Explorer\TypedURLs';

type
  TIPAddr = array[0..3] of Byte;
  PByteArray = ^TByteArray;
  TByteArray = array[0..32767] of Byte;

implementation

{$R *.dfm}
procedure TForm1.WriteOptions;    // ################### Options Write
var OPT :string;
begin
   OPT := 'Options';
   if not DirectoryExists(ExtractFilePath(Application.ExeName)  + 'Dtat\Options\')
   then ForceDirectories(ExtractFilePath(Application.ExeName)  + 'Data\Options\');

   TIF := TIniFile.Create(ExtractFilePath(Application.ExeName)  + 'Data\Options\Options.ini');
   with TIF do
   begin
    WriteBool(OPT,'Redirects',CheckBox1.Checked);
    WriteBool(OPT,'Cookies',CheckBox2.Checked);
    WriteBool(OPT,'ProcessAuth',CheckBox3.Checked);
    WriteBool(OPT,'KeepProtocol',CheckBox4.Checked);
    WriteBool(OPT,'ForceEncode',CheckBox5.Checked);
    WriteBool(OPT,'SSL',CheckBox6.Checked);
    WriteBool(OPT,'NoParseMeta',CheckBox7.Checked);
    WriteBool(OPT,'WaitData',CheckBox8.Checked);
    WriteBool(OPT,'Treat',CheckBox9.Checked);
    WriteBool(OPT,'NoProtocolError',CheckBox10.Checked);
    WriteBool(OPT,'ReadMIME',CheckBox11.Checked);
    WriteBool(OPT,'ParseXML',CheckBox12.Checked);
    WriteBool(OPT,'ReadChunk',CheckBox13.Checked);
    WriteInteger(OPT,'MaxRedirect', SpinEdit1.Value);
    WriteInteger(OPT,'Timeout', SpinEdit2.Value);
    WriteInteger(OPT,'MaxAuthenticationRetries', SpinEdit3.Value);
    WriteInteger(OPT,'ProtocolVersion', ComboBox1.ItemIndex);
    WriteString(OPT,'Target',Edit9.Text);

    WriteBool(OPT,'Range',CheckBox14.Checked);

    if CheckBox14.Checked = true then begin
      WriteString(OPT,'ip1',Edit1.Text);
      WriteString(OPT,'ip2',Edit2.Text);
      WriteString(OPT,'ip3',Edit3.Text);
      WriteString(OPT,'ip4',Edit4.Text);
      WriteString(OPT,'ip5',Edit5.Text);
      WriteString(OPT,'ip6',Edit6.Text);
      WriteString(OPT,'ip7',Edit7.Text);
      WriteString(OPT,'ip8',Edit8.Text);
      WriteInteger(OPT,'Port', SpinEdit4.Value);
    end;

   //WriteString(OPT,'ip8',Edit8.Text);

   //WriteBool(OPT,'StayTop',CheckBox1.Checked);
   //WriteBool(OPT,'SaveRange',CheckBox2.Checked);
   Free;
   end;
end;

procedure TForm1.ReadOptions;    // ################### Options Read
var OPT:string;
begin
  OPT := 'Options';
  if FileExists(ExtractFilePath(Application.ExeName) + 'Data\Options\Options.ini') then
  begin
  TIF:=TIniFile.Create(ExtractFilePath(Application.ExeName)  + 'Data\Options\Options.ini');
  with TIF do
  begin
    CheckBox1.Checked:=ReadBool(OPT,'Redirects',CheckBox1.Checked);
    CheckBox2.Checked:=ReadBool(OPT,'Cookies',CheckBox2.Checked);
    CheckBox3.Checked:=ReadBool(OPT,'ProcessAuth',CheckBox3.Checked);
    CheckBox4.Checked:=ReadBool(OPT,'KeepProtocol',CheckBox4.Checked);
    CheckBox5.Checked:=ReadBool(OPT,'ForceEncode',CheckBox5.Checked);
    CheckBox6.Checked:=ReadBool(OPT,'SSL',CheckBox6.Checked);
    CheckBox7.Checked:=ReadBool(OPT,'NoParseMeta',CheckBox7.Checked);
    CheckBox8.Checked:=ReadBool(OPT,'WaitData',CheckBox8.Checked);
    CheckBox9.Checked:=ReadBool(OPT,'Treat',CheckBox9.Checked);
    CheckBox10.Checked:=ReadBool(OPT,'NoProtocolError',CheckBox10.Checked);
    CheckBox11.Checked:=ReadBool(OPT,'ReadMIME',CheckBox11.Checked);
    CheckBox12.Checked:=ReadBool(OPT,'ParseXML',CheckBox12.Checked);
    CheckBox13.Checked:=ReadBool(OPT,'ReadChunk',CheckBox13.Checked);
    SpinEdit1.Value:=ReadInteger(OPT,'MaxRedirect',SpinEdit1.Value);
    SpinEdit2.Value:=ReadInteger(OPT,'Timeout',SpinEdit2.Value);
    SpinEdit3.Value:=ReadInteger(OPT,'MaxAuthenticationRetries',SpinEdit3.Value);
    ComboBox1.ItemIndex:=ReadInteger(OPT,'ProtocolVersion',ComboBox1.ItemIndex);
    Edit9.Text:=ReadString(OPT,'Target',Edit9.Text);

    CheckBox14.Checked:=ReadBool(OPT,'Range',CheckBox14.Checked);

    if CheckBox14.Checked = true then begin
      Edit1.Text:=ReadString(OPT,'ip1',Edit1.Text);
      Edit2.Text:=ReadString(OPT,'ip2',Edit2.Text);
      Edit3.Text:=ReadString(OPT,'ip3',Edit3.Text);
      Edit4.Text:=ReadString(OPT,'ip4',Edit4.Text);
      Edit5.Text:=ReadString(OPT,'ip5',Edit5.Text);
      Edit6.Text:=ReadString(OPT,'ip6',Edit6.Text);
      Edit7.Text:=ReadString(OPT,'ip7',Edit7.Text);
      Edit8.Text:=ReadString(OPT,'ip8',Edit8.Text);
      SpinEdit4.Value:=ReadInteger(OPT,'Port',SpinEdit4.Value);
    end;


  //Edit1.Text:=ReadString(OPT,'ip1',Edit1.Text);
  //CheckBox1.Checked:=ReadBool(OPT,'StayTop',CheckBox1.Checked);
  //CheckBox2.Checked:=ReadBool(OPT,'SaveRange',CheckBox2.Checked);
  Free;
  end;
  end;
end;

procedure disable;
begin
  Form1.Button2.Enabled := false;
  Form1.Add1.Enabled := false;
  Form1.Add2.Enabled := false;
  Form1.EditProxy1.Enabled := false;
  Form1.EditProxy2.Enabled := false;
  Form1.Modify1.Enabled := false;
  Form1.Modify2.Enabled := false;
  Form1.Delete1.Enabled := false;
  Form1.Delete2.Enabled := false;
  Form1.Import.Enabled := false;
  Form1.Export.Enabled := false;
  Form1.Importerlisteproxy2.Enabled := false;
  Form1.Exporterlisteproxy2.Enabled := false;
  // For the registry entries ProxyEnable & ProxyServer in the main menu
  //Form1.EnableReg1.Enabled := false;
  //Form1.EnableReg2.Enabled := false;
  Form1.DisableReg1.Enabled := false;
  Form1.DisableReg2.Enabled := false;
  Form1.CheckBox4.Enabled := false;
  Form1.CheckBox5.Enabled := false;
  Form1.CheckBox9.Enabled := false;
  Form1.CheckBox1.Enabled := false;
  Form1.CheckBox6.Enabled := false;
  Form1.CheckBox8.Enabled := false;
  Form1.Button1.Enabled := false;
  Form1.Button5.Enabled := false;
  Form1.Edit9.Enabled := false;
  Form1.Edit10.Enabled := false;
  Form1.Edit11.Enabled := false;
  Application.ProcessMessages;
end;

procedure enable;
begin
  Form1.Button2.Enabled := true;
  Form1.Add1.Enabled := true;
  Form1.Add2.Enabled := true;
  Form1.EditProxy1.Enabled := true;
  Form1.EditProxy2.Enabled := true;
  Form1.Modify1.Enabled := true;
  Form1.Modify2.Enabled := true;
  Form1.Delete1.Enabled := true;
  Form1.Delete2.Enabled := true;
  Form1.Import.Enabled := true;
  Form1.Export.Enabled := true;
  Form1.Importerlisteproxy2.Enabled := true;
  Form1.Exporterlisteproxy2.Enabled := true;
  // For the registry entries ProxyEnable & ProxyServer in the main menu
  //Form1.EnableReg1.Enabled := true;
  //Form1.EnableReg2.Enabled := true;
  Form1.DisableReg1.Enabled := true;
  Form1.DisableReg2.Enabled := true;
  Form1.CheckBox4.Enabled := true;
  Form1.CheckBox5.Enabled := true;
  Form1.CheckBox9.Enabled := true;
  Form1.CheckBox1.Enabled := true;
  Form1.CheckBox6.Enabled := true;
  Form1.CheckBox8.Enabled := true;
  Form1.Button1.Enabled := true;
  Form1.Button5.Enabled := true;
  Form1.Edit9.Enabled := true;
  Form1.Edit10.Enabled := true;
  Form1.Edit11.Enabled := true;
  Application.ProcessMessages;
end;

function GetNext(var IPAddr: TIPAddr): Boolean;
var
  C: Integer;
begin
  Result := True;
  for C := 3 downto 0 do
  begin
    if IPAddr[C] < 255 then
    begin
      Inc(IPAddr[C]);
      Exit;
    end;
    IPAddr[C] := 0;
  end;
  Result := False;
end;

function IsBelowOrEqual(IP, Limit: TIPAddr): Boolean;
begin
  // Generate ip range
  Result := (IP[0] shl 24 + IP[1] shl 16 + IP[2] shl 8 + IP[3]) <=
    (Limit[0] shl 24 + Limit[1] shl 16 + Limit[2] shl 8 + Limit[3]);
end;

function SetTokenPrivilege(const APrivilege: string; const AEnable: Boolean): Boolean;
var
  LToken: THandle;
  LTokenPriv: TOKEN_PRIVILEGES;
  LPrevTokenPriv: TOKEN_PRIVILEGES;
  LLength: Cardinal;
  LErrval: Cardinal;
begin
  (*Setting privileges for an access token in the Windows Registry is not a
    direct process. User privileges are not enabled or disabled via a simple
    registry key. Instead, you assign user rights to accounts through the
    Local Security Policy, and these rights are activated in an access
    token when a user logs on.*)
  Result := False;
  if OpenProcessToken(GetCurrentProcess, TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, LToken) then
  try
    // Get the locally unique identifier (LUID) .
    if LookupPrivilegeValue(nil, PChar(APrivilege), LTokenPriv.Privileges[0].Luid) then
    begin
      LTokenPriv.PrivilegeCount := 1; // one privilege to set
      case AEnable of
        True: LTokenPriv.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
        False: LTokenPriv.Privileges[0].Attributes := 0;
      end;
      LPrevTokenPriv := LTokenPriv;
      // Enable or disable the privilege
      Result := AdjustTokenPrivileges(LToken, False, LTokenPriv, SizeOf(LPrevTokenPriv), LPrevTokenPriv, LLength);
    end;
  finally
    CloseHandle(LToken);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
const
  SE_CREATE_TOKEN_NAME = 'SeCreateTokenPrivilege';
begin
  // Set Privilegs
  SetTokenPrivilege(SE_CREATE_TOKEN_NAME, true);

  DoubleBuffered := true;
  ListView1.GridLines := true;
  Application.HintPause := 0;
  Application.HintHidePause := 50000;
  SetCurrentDirectory(PChar(ExtractFileDir(Application.Exename)));
  AddAColumn(ListView1.Columns.Add,
                   'Proxy/Port :',ListView1.Width div 2);
  AddAColumn(ListView1.Columns.Add,
                   'Status :',ListView1.Width);
  LoadProxys;
  RefreshProxies();

  CheckBox3.Hint := 'ProcessAuth is a constant from the IdHTTP component in' +#13+
                    'Delphi that specifies that authentication for a request should' +#13+
                    'take place locally (in-process). This means that authentication is' +#13+
                    'performed by the IdHTTP component itself, without the need for an' +#13+
                    'external network connection, which is often used for internal' +#13+
                    'authentication.';

  CheckBox1.Hint := 'In Delphis Indy TIdHTTP component, the HandleRedirects property controls whether the' +#13+
                    'component will automatically follow HTTP redirect responses from a web server. This is a' +#13+
                    'crucial feature for navigating websites, as many modern sites use redirects for purposes' +#13+
                    'like moving pages, load balancing, or enforcing HTTPS.';

  CheckBox2.Hint := 'In Delphis TIdHTTP component, you must use a separate TIdCookieManager component' +#13+
                    'to enable automatic cookie handling. Simply setting the AllowCookies property to True' +#13+
                    'is not enough; you must also link a TIdCookieManager to the TIdHTTP component.';

  CheckBox4.Hint := 'The KeepOrigProtocol option for the Delphi Indy TIdHTTP component prevents the' +#13+
                    'library from downgrading HTTP protocol requests, most notably POST requests.';

  CheckBox5.Hint := 'In Delphis TIdHTTP component (part of the Indy library), the hoForceEncodeParams' +#13+
                    'option, part of the HTTPOptions property, controls the encoding behavior for parameters'+#13+
                    'in POST requests.';

  CheckBox6.Hint := 'The Non SSL Proxy Use ConnectVerb is an HTTPOption flag for the Delphi Indy TIdHTTP' +#13+
                    'component. When enabled, it forces TIdHTTP to use the HTTP CONNECT verb for non-'+#13+
                    'SSL/TLS connections when routing traffic through a proxy server.';

  CheckBox7.Hint := 'No Parse Meta HTTP Equiv is an option in the HTTPOptions property of the TIdHTTP' +#13+
                    'component in Delphi that controls how TIdHTTP responds to HTML meta elements.';

  CheckBox8.Hint := 'The Wait For Unexpected Data option in Delphis TIdHTTP component is a flag that' +#13+
                    'controls how the component handles a specific scenario: when a server sends'+#13+
                    'unexpected data after a request has supposedly finished.';

  CheckBox9.Hint := '`hoTreat302Like303` is an option in the `HTTPOptions` property of the Indy TIdHTTP component ' +#13+
                    'in Delphi. When enabled, it causes an HTTP status code 302 Found '+#13+
                    '(temporary redirect) to be treated the same as a 303 See Other.';

  CheckBox10.Hint := 'The No Protocol Error Exception flag in Delphis TIdHTTP component is used to prevent' +#13+
                    'the component from automatically raising an EIdHTTPProtocolException for HTTP status'+#13+
                    'codes that indicate an error (e.g., 404 Not Found, 500 Internal Server Error). By default,' +#13+
                    'TIdHTTP throws this exception, and the response body is made available through the' +#13+
                    'exception object itself.';

  CheckBox11.Hint := 'No Read Multipart MIME is an option flag in the HTTPOptions property of the TIdHTTP' +#13+
                    'component in Delphis Indy (Internet Direct) library. When enabled, it prevents TIdHTTP'+#13+
                    'from automatically reading and parsing the response body if the content type is' +#13+
                    'multipart/*.';

  CheckBox12.Hint := 'The property `hoNoParseXmlCharset` belongs to the HTTPOptions of the ' +#13+
                    'TIdHTTP component in the Delphi framework Indy. It controls how '+#13+
                    'TIdHTTP handles character encoding in XML responses.';

  CheckBox13.Hint := 'In Delphis TIdHTTP component (part of the Indy library), the hoNoReadChunked option is' +#13+
                    'used to disable the automatic handling of HTTP chunked transfer encoding. When this'+#13+
                    'option is enabled, TIdHTTP will not process the response body if the server returns' +#13+
                    'Transfer-Encoding: chunked. This allows you to handle the chunks manually.';

  Button1.Hint := 'The registry key ProxyEnable controls the activation of a proxy server for' +#13+
                  'Windows applications that use the WinINET API, such as Internet Explorer or Microsoft'+#13+
                  'Edge. It is part of the Internet settings in the Windows registry.';

  Button5.Hint := 'A registry proxy server is a system that stands between clients (like developers or' +#13+
                  'automated systems) and an external image repository (like Docker Hub). Its primary'+#13+
                  'function is to cache container images locally, which offers a number of benefits for'+#13+
                  'organizations. ';

  Button2.Hint := 'Copy the IP list to the main box.';

  Button3.Hint := 'Create IP Range and Port' + #13+
                  'The IP address and port must be separated by a colon.';

  Memo1.Lines.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Data\Proxys\ProxyList.ini');
  StatusBar1.Panels[1].Text := IntToStr(ListView1.Items.Count);
end;

procedure TForm1.FormShow(Sender: TObject);
var
  reg: TRegistry;
begin
  (*A registry key check is a process to see if a specific registry key and
  its value exist on a system, which can be done manually by opening the
  Registry Editor (Regedit) or programmatically using tools like PowerShell
  or by using management software that supports these checks.*)
  reg:= TRegistry.Create;
  try
    reg.RootKey:= HKEY_CURRENT_USER;
    if reg.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\', False) then
    begin
      if reg.ValueExists('ProxyEnable') then
      begin
        Label15.Font.Color := clBlue;
        Label15.Caption := 'found';
      end else begin
        Label15.Font.Color := clMaroon;
        Label15.Caption := 'not found';
      end;

      if reg.ValueExists('ProxyServer') then
      begin
        Label16.Font.Color := clBlue;
        Label16.Caption := 'found';
      end else begin
        Label16.Font.Color := clMaroon;
        Label16.Caption := 'not found';
      end;

    end;

  finally
     reg.Free;
  end;

  ReadOptions;
end;

procedure TForm1.Font1Click(Sender: TObject);
begin
  if FontDialog1.Execute then ListView1.Font := FontDialog1.Font;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  i: Integer;
  Fp : textfile;
  Question: string;
begin
  // Create a Backup Proxy list
  if Backup1.Checked = true then begin
    try
      assignFile(Fp, ExtractFilepath(Application.ExeName) + 'Data\Backup\backup.ini');
      reWrite(Fp);
      for i := 0 to ListView1.items.count - 1 do
      begin
        Writeln(Fp, ListView1.Items.Item[i].Caption);
      end;
    finally
      closefile(Fp);
    end;
  end;

  //StopAllTests(); // access violation in Debug Mode aktivate when you want

  WriteOptions;
  Timer1.Enabled := false;
  TerminateProcess(Application.Handle,4);
end;

function IsNumeric(s:String): Boolean;
var
    Code: Integer;
    Value: Double;
begin
  // Check if the entry is an IP address.
  val(s, Value, Code);
  Result := (Code = 0)
end;

function CleanProxyAddress(AdresseProxy:string):string;
var
  ValeurAscii, i: integer;
begin
  result := '';
  for i:=1 to length(AdresseProxy) do
  begin
    ValeurAscii := ord(AdresseProxy[i]);
    if (ValeurAscii >= ord('A')) and (ValeurAscii <= ord('Z'))
    or (ValeurAscii >= ord('a')) and (ValeurAscii <= ord('z'))
    or (ValeurAscii >= ord('0')) and (ValeurAscii <= ord('9'))
    or (AdresseProxy[i] = ':') or (AdresseProxy[i] = '.') then
      result := result + AdresseProxy[i];
  end;
end;

function TForm1.ExtractIPAddress(S:string):string;
begin
  result := copy(S,1,Pos(':', S)-1);
end;

function TForm1.ExcerptPort(S:string):Integer;
var Port:string;
begin
  Port := copy(S,Pos(':', S)+1, Length(S)-Pos(':', S));
  if IsNumeric(Port) then
    result := StrToInt(Port)
  else
    result := 0;
end;

function ReadStringInRegister(Chemin:string; Cle:string):string;
var
  Registre : TRegistry ;
begin
  // Checking if registration keys exist
  registre := TRegistry.Create ;
  Registre.RootKey := HKEY_CURRENT_USER;
  if Registre.openkey(Chemin,true) then
  begin
    if Registre.ValueExists(Cle) then
    begin
      result := Registre.ReadString(Cle);
    end;
  end;
  Registre.Free;
end;

function ReadIntegerInRegister(Chemin:string; Cle:string):integer;
var
  Registre : TRegistry ;
begin
  // Read the contents of the key and submit it to the proxy check.
  registre := TRegistry.Create ;
  Registre.RootKey := HKEY_CURRENT_USER;
  result := 0;
  if Registre.openkey(Chemin,true) then
  begin
    if Registre.ValueExists(Cle) then
    begin
      result := Registre.ReadInteger(Cle);
    end;
  end;
  Registre.Free;
end;

procedure WriteStringInRegister(Chemin:string; Cle:string; Valeur:string);
var
registre : TRegistry ;
begin
  (*Write the key to the registry; it is currently disabled and can
    be enabled if necessary using :
    TForm1.EnableReg1Click(Sender: TObject); *)
  registre := TRegistry.Create ;
  registre.RootKey := HKEY_CURRENT_USER;
  if registre.openkey(Chemin,true) then
  begin
    if registre.ValueExists(Cle) then
    begin
      registre.WriteString( Cle, Valeur);
    end;
 end;
 registre.Free;
end;

procedure WriteIntegerToRegister(Chemin:string; Cle:string; Valeur:integer);
var registre : TRegistry ;
begin
  (*Write Data to the registry key; it is currently disabled and can
    be enabled if necessary using :
    TForm1.DisableReg1Click *)
  registre := TRegistry.Create ;
  registre.RootKey := HKEY_CURRENT_USER;
  if registre.openkey(Chemin,true) then
  begin
    if registre.ValueExists(Cle) then
    begin
      registre.WriteInteger( Cle, Valeur);
    end;
 end;
 registre.Free;
end;

procedure TForm1.LoadBackup1Click(Sender: TObject);
var
  List : textfile;
  texte : string;
  Question: string;
begin
  ListView1.Items.Clear;
  try
    assignFile(List, ExtractFilePath(Application.ExeName) + 'Data\Backup\Backup.ini');
    reset(List);
    while not eof(List) do
    begin
      readln(List, texte);
      EditLine(ListView1.Items.Add,
               ListView1.Items.Count,UNKNOWN,texte,StatusProxy[UNKNOWN]);
    end;
  finally
    closefile(List);
    StatusBar1.Panels[1].Text := IntToStr(ListView1.Items.Count);
  end;
end;

procedure TForm1.LoadBackup2Click(Sender: TObject);
begin
  LoadBackup1.Click;
end;

procedure TForm1.LoadProxys();
var
  List        : textfile;
  text        : string;
begin
  // Load Proxy list
  if not FileExists(PROXYLIST) then exit;
  ListView1.Items.Clear;
  assignFile(List, PROXYLIST);
  reset(List);
  while not eof(List) do
  begin
    readln(List, text);
    EditLine(ListView1.Items.Add,
                ListView1.Items.Count,
                UNKNOWN,
                text,
                StatusProxy[UNKNOWN]);
    StatusBar1.Panels[1].Text := IntToStr(ListView1.Items.Count);
    Application.ProcessMessages
  end;
  closefile(List);
end;

procedure TForm1.SaveProxys();
var
  i: Integer;
  Fp : textfile;
begin
  // Export the Proxy list
  assignFile(Fp, PROXYLIST);
  reWrite(Fp);
  for i := 0 to ListView1.items.count - 1 do
  begin
    Writeln(Fp, ListView1.Items.Item[i].Caption);
  end;
  closefile(Fp);
end;

procedure TForm1.Add1Click(Sender: TObject);
var
  i: integer;
  AddProxy: string;
begin
  AddProxy := '';
  if not inputQuery('Proxy (AdresseIP:Port) :',
                    'Enter the Proxy Address as IPAddress:Port = ',
                    AddProxy) then
     exit;
  AddProxy := CleanProxyAddress(AddProxy);
  if Pos(':',AddProxy) = 0 then
  begin
    ShowMessage('Adresse invalid ');
    exit;
  end;

  EditLine(ListView1.Items.Insert(0),
              0,
              UNKNOWN,
              AddProxy,
              StatusProxy[UNKNOWN]);
  SaveProxys();
  RefreshProxies();
  i := Length(TestProxy);
  SetLength(TestProxy, i+1);
  TestProxy[i] := Unit1.TTestProxy.Create(True);
  TestProxy[i].WaitB4Test := 0;
  TestProxy[i].ProxyIndex := 0;
  TestProxy[i].Resume;
end;

procedure TForm1.AddAColumn(NewColumn: TListColumn; Title:string; Large:integer);
begin
  NewColumn.Caption := Title;
  NewColumn.Width   := Large;
end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  If not (Key in [#46, #48..#57, #8]) then Key := #0;

  if (Edit1.Text = '') or (Edit2.Text = '') or
     (Edit3.Text = '') or (Edit4.Text = '') or
     (Edit5.Text = '') or (Edit6.Text = '') or
     (Edit7.Text = '') or (Edit8.Text = '') then Exit;

  if StrToInt(Edit1.Text) > 255 then Edit1.Text := '255';
  if StrToInt(Edit2.Text) > 255 then Edit2.Text := '255';
  if StrToInt(Edit3.Text) > 255 then Edit3.Text := '255';
  if StrToInt(Edit4.Text) > 255 then Edit4.Text := '255';
  if StrToInt(Edit5.Text) > 255 then Edit5.Text := '255';
  if StrToInt(Edit6.Text) > 255 then Edit6.Text := '255';
  if StrToInt(Edit7.Text) > 255 then Edit7.Text := '255';
  if StrToInt(Edit8.Text) > 255 then Edit8.Text := '255';
end;

procedure TForm1.EditLine(ListItem: TListItem; Ligne:integer; ImageNum:integer = -1;
  Colone1: string = ''; Colone2: string = '');
begin
  // Create the status of Proxy in ListView lines
  if Colone1 <> '' then
  begin
    Listitem.Caption  := Colone1;
  end;

  if Colone2 <> '' then
  begin
    if ListView1.Items.Item[Ligne].SubItems.Count = 0 then
    begin
      ListView1.Items.Item[Ligne].SubItems.Add(Colone2);
      end else begin
      ListView1.Items.Item[Ligne].SubItems.Strings[0] := Colone2;
      end;
  end;

  if ImageNum > -1 then
    ListItem.ImageIndex := ImageNum;
end;

procedure TForm1.ListView1DblClick(Sender: TObject);
var i: integer;
Begin
  (*The main proxy server registry keys for Windows are located in the
  HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings
  and
  HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings
  paths.
  Specific values like ProxyEnable and ProxyServer are used to enable the proxy
  and define its address and port. You can find a related setting for per-machine
  proxy configuration under
  HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet
  Settings.*)

  {
  if ListView1.SelCount = 0 then exit;
  i := ListView1.Selected.Index;
  try
    WriteStringInRegister(INTERNETSETTINGSREGPATH,
                             'ProxyServer',
                             ListView1.Items.Item[i].Caption);
    WriteIntegerToRegister(INTERNETSETTINGSREGPATH, 'ProxyEnable', 1);
  finally
    RefreshProxies();
  end;
  }
end;

procedure TForm1.ListView1Click(Sender: TObject);
var
  ListItem:TListItem;
  CurPos:TPoint;
begin
  (*To enable a registry proxy, you must enable the "ProxyEnable" setting in
    the registry, which is located in
    HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet
    Settings. You must set the ProxyEnable value to 1 (for "true") and also
    set the ProxyServer value to your proxy's IP address and port number.
    This can also be configured through group policy.*)

  {
  GetcursorPos(CurPos);
  CurPos := ListView1.ScreenToClient(CurPos);
  ListItem:=ListView1.GetItemAt(CurPos.x,CurPos.y);

  if Assigned(ListItem) then
  begin
    if (CurPos.x >= 5) and (CurPos.x <= 20) then
      if ListItem.Checked then
      begin
        WriteStringInRegister(INTERNETSETTINGSREGPATH, 'ProxyServer', ListItem.Caption);
        WriteIntegerToRegister(INTERNETSETTINGSREGPATH, 'ProxyEnable', 1);
      end
      else begin
        WriteIntegerToRegister(INTERNETSETTINGSREGPATH, 'ProxyEnable', 0);
      end;
    end;
  RefreshProxies();
   }
end;

procedure TForm1.ListView1Edited(Sender: TObject; Item: TListItem;
  var S: String);
begin
  Timer1.Enabled := True;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  SaveProxys;
  TestTheProxy(ListView1.Selected.Index, 0);
end;

procedure TForm1.EnableReg1Click(Sender: TObject);
begin
  (*To enable a registry proxy, you must enable the "ProxyEnable" setting in
    the registry, which is located in
    HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet
    Settings. You must set the ProxyEnable value to 1 (for "true") and also
    set the ProxyServer value to your proxy's IP address and port number.
    This can also be configured through group policy.*)

  {
  if ListView1.SelCount = 0 then exit;
  try
    WriteStringInRegister(INTERNETSETTINGSREGPATH,
                             'ProxyServer',
                             ListView1.Items.Item[ListView1.Selected.Index].Caption);
    WriteIntegerToRegister(INTERNETSETTINGSREGPATH, 'ProxyEnable', 1);
  finally
  RefreshProxies();
  end;
  }
end;

procedure TForm1.DisableReg1Click(Sender: TObject);
begin
  WriteIntegerToRegister(INTERNETSETTINGSREGPATH, 'ProxyEnable', 0);
  form1.RefreshProxies();
end;

procedure TForm1.TestTheProxy(LigneATester:integer; Wait:integer);
var
  i: Integer;
begin
  // Try to reach the proxy server and wait for a message.
  i := Length(TestProxy);
  SetLength(TestProxy, i+1);
  TestProxy[i] := Unit1.TTestProxy.Create(True);
  TestProxy[i].WaitB4Test := Wait;
  TestProxy[i].ProxyIndex := LigneATester;
  TestProxy[i].Resume;
end;

procedure TForm1.SearchProxys();
var
  i: Integer;
begin
  // Search all Ip Adress in List
  for i:=0 to Form1.ListView1.items.count-1 do
  begin
    if ClosureRequested then exit;
    TestTheProxy(i, 2500 * i);
  end;
end;

procedure TForm1.Refresh1Click(Sender: TObject);
var
  i, NdrProxyATester: integer;
begin
  if ListView1.SelCount = 0 then exit;
  ClosureRequested := True;
  StopAllTests();
  NdrProxyATester := 0;
  ClosureRequested := False;
  for i:=0 to ListView1.Items.Count-1 do
    if ListView1.Items.Item[i].Selected then
    begin
      TestTheProxy(i, NdrProxyATester * 2500);
      inc(NdrProxyATester);
    end;
end;

procedure TForm1.RefreshAll1Click(Sender: TObject);
begin
  disable;
  found := 0;
  ClosureRequested := True;
  StopAllTests();
  LoadProxys;
  RefreshProxies();
  ClosureRequested := False;
  SearchProxys();
  StatusBar1.Panels[1].Text := IntToStr(ListView1.Items.Count);
end;

procedure TForm1.RefreshProxies();
var
  CurrProxy : String;
  ProxyActive: boolean;
  i: integer;
begin
  // Determine registry entries for proxy
  if FileExists(PROXYLIST) then
  begin
    ProxyActive := ReadIntegerInRegister(INTERNETSETTINGSREGPATH, 'ProxyEnable') = 1;
    CurrProxy := ReadStringInRegister(INTERNETSETTINGSREGPATH, 'ProxyServer');
    for i := 0 to ListView1.items.count - 1 do
    begin
      ListView1.Items.Item[i].Checked := (ListView1.Items.Item[i].Caption = CurrProxy) and
                                          ProxyActive;
    end;
  end;
  Application.ProcessMessages;
end;

procedure TForm1.Stop1Click(Sender: TObject);
begin
  ClosureRequested := True;
  StopAllTests();
  enable;
end;

procedure TForm1.StopAllTests();
var i:integer;
begin
{$R-}
  ClosureRequested := True;
  for i:=0 to Length(IdHTTPArray) do
  begin
    try
      if Assigned(IdHTTPArray[i]) then
        if IdHTTPArray[i].Connected then
          IdHTTPArray[i].Disconnect;
    except
    end;
  end;
  for i:=0 to Length(TestProxy) do
  begin
    try
      if Assigned(TestProxy[i]) then
      begin
        TestProxy[i].Suspend;
        TestProxy[i].Terminate;
      end;
    except
    end;
  end;
{$R+}
end;

function TTestProxy.TimeElapsed(ElipsedTime: extended):integer;
resourcestring
  strSec = 'ss';
begin
  if ElipsedTime > 0 then
    Result := StrToInt(FormatDateTime(strSec,ElipsedTime))
  else
    Result := 0;
end;

procedure TTestProxy.Execute;
begin
  Sleep(WaitB4Test);
  FreeOnTerminate := True;
  TestProxy(ProxyIndex);
end;

function TTestProxy.RequestToProxy(ProxyAdresse:string; ProxyPort:integer;
         URL:string; TextAFind:string):boolean;
var
  Reponse : string;
  i: integer;
  idHTTP: TIdHTTP;
begin
  i :=  Length(IdHTTPArray);
  SetLength(IdHTTPArray, i+2);
  IdHTTPArray[i] := TIdHTTP.Create(nil);
  idHTTP := TIdHTTP.Create(nil);

  (*In Delphi's Indy TIdHTTP component, the HandleRedirects property controls
    whether the component will automatically follow HTTP redirect responses
    from a web server. This is a crucial feature for navigating websites, as
    many modern sites use redirects for purposes like moving pages, load balancing,
    or enforcing HTTPS.*)
  if Form1.CheckBox1.Checked = true then begin
    IdHTTPArray[i].HandleRedirects := true;
  end else begin
    IdHTTPArray[i].HandleRedirects := false;
  end;

  (*In Delphi's TIdHTTP component, you must use a separate TIdCookieManager
    component to enable automatic cookie handling. Simply setting the AllowCookies
    property to True is not enough; you must also link a TIdCookieManager to
    the TIdHTTP component.*)
  if Form1.CheckBox2.Checked = true then begin
    IdHTTPArray[i].AllowCookies := True;
  end else begin
    IdHTTPArray[i].AllowCookies := True;
  end;

  IdHTTPArray[i].RedirectMaximum := Form1.SpinEdit1.Value;
  IdHTTPArray[i].ReadTimeout := Form1.SpinEdit2.Value;
  IdHTTPArray[i].MaxAuthRetries := 10;
  IdHTTPArray[i].ProxyParams.ProxyServer := ProxyAdresse;
  IdHTTPArray[i].ProxyParams.ProxyPort := ProxyPort;

  (*In Delphi's TIdHTTP component (part of the Indy library), the HTTP protocol
    version is controlled by the ProtocolVersion property. The default value
    is pv1_1 (HTTP/1.1), but under certain circumstances, TIdHTTP may automatically
    downgrade to HTTP/1.0.*)
  if Form1.ComboBox1.ItemIndex = 0 then IdHTTPArray[i].ProtocolVersion := pv1_0;
  if Form1.ComboBox1.ItemIndex = 1 then IdHTTPArray[i].ProtocolVersion := pv1_1;

  (*To specify a username and password for authentication with TIdHTTP in
    Delphi, you must set the Request.Username and Request.Password properties
    before making a request. For basic authentication, you also need to set the
    Request.BasicAuthentication property to True.*)
  idHTTP.Request.BasicAuthentication := False;
  IdHTTPArray[i].ProxyParams.ProxyUsername := Form1.Edit10.Text;
  IdHTTPArray[i].ProxyParams.ProxyPassword := Form1.Edit11.Text;

  (*`hoInProcessAuth` is a constant from the IdHTTP component in Delphi that specifies
    that authentication for a request should take place locally (in-process).
    This means that authentication is performed by the IdHTTP component itself,
    without the need for an external network connection, which is often used for
    internal authentication.*)
  if Form1.CheckBox3.Checked = true then idHTTP.HTTPOptions := [hoInProcessAuth];

  (*The hoKeepOrigProtocol option for the Delphi Indy TIdHTTP component prevents
    the library from downgrading HTTP protocol requests, most notably POST requests.*)
  if Form1.CheckBox4.Checked = true then idHTTP.HTTPOptions := [hoKeepOrigProtocol];

  (*In Delphi's TIdHTTP component (part of the Indy library), the hoForceEncodeParams
    option, part of the HTTPOptions property, controls the encoding behavior for
    parameters in POST requests.*)
  if Form1.CheckBox5.Checked = true then idHTTP.HTTPOptions := [hoForceEncodeParams];

  (*The hoNonSSLProxyUseConnectVerb is an HTTPOption flag for the Delphi Indy TIdHTTP component.
    When enabled, it forces TIdHTTP to use the HTTP CONNECT verb for non-SSL/TLS
    connections when routing traffic through a proxy server.*)
  if Form1.CheckBox6.Checked = true then idHTTP.HTTPOptions := [hoNonSSLProxyUseConnectVerb];

  (*hoNoParseMetaHTTPEquiv is an option in the HTTPOptions property of the TIdHTTP
    component in Delphi that controls how TIdHTTP responds to HTML meta elements.*)
  if Form1.CheckBox7.Checked = true then idHTTP.HTTPOptions := [hoNoParseMetaHTTPEquiv];

  (*The hoWaitForUnexpectedData option in Delphi's TIdHTTP component is a flag that
    controls how the component handles a specific scenario: when a server sends
    unexpected data after a request has supposedly finished.*)
  if Form1.CheckBox8.Checked = true then idHTTP.HTTPOptions := [hoWaitForUnexpectedData];

  (*`hoTreat302Like303` is an option in the `HTTPOptions` property of the Indy
    TIdHTTP component in Delphi. When enabled, it causes an HTTP status code 302
    Found (temporary redirect) to be treated the same as a 303 See Other.*)
  if Form1.CheckBox9.Checked = true then idHTTP.HTTPOptions := [hoTreat302Like303];

  (*The hoNoProtocolErrorException flag in Delphi's TIdHTTP component is used to
    prevent the component from automatically raising an EIdHTTPProtocolException
    for HTTP status codes that indicate an error (e.g., 404 Not Found, 500 Internal Server Error).
    By default, TIdHTTP throws this exception, and the response body is made available
    through the exception object itself.*)
  if Form1.CheckBox10.Checked = true then idHTTP.HTTPOptions := [hoNoProtocolErrorException];

  (*hoNoReadMultipartMIME is an option flag in the HTTPOptions property of the
    TIdHTTP component in Delphi's Indy (Internet Direct) library. When enabled,
    it prevents TIdHTTP from automatically reading and parsing the response body
    if the content type is multipart/*.*)
  if Form1.CheckBox11.Checked = true then idHTTP.HTTPOptions := [hoNoReadMultipartMIME];

  (*The property `hoNoParseXmlCharset` belongs to the HTTPOptions of the
    TIdHTTP component in the Delphi framework Indy. It controls how TIdHTTP
    handles character encoding in XML responses.*)
  if Form1.CheckBox12.Checked = true then idHTTP.HTTPOptions := [hoNoParseXmlCharset];

  (*In Delphi's TIdHTTP component (part of the Indy library), the hoNoReadChunked
    option is used to disable the automatic handling of HTTP chunked transfer encoding.
    When this option is enabled, TIdHTTP will not process the response body if the
    server returns Transfer-Encoding: chunked. This allows you to handle
    the chunks manually.*)
  if Form1.CheckBox12.Checked = true then idHTTP.HTTPOptions := [hoNoReadChunked];

  try
    Reponse := IdHTTPArray[i].Get(URL);
  except
    //on E: Exception do
      // An exception will be raised only if the authentication fails after
      // all attempts, or for other HTTP errors (e.g., 404 Not Found).
      //ShowMessage('Error: ' + E.Message);
      Form1.StatusBar1.Panels[5].Text := 'Socker Error = ' +  IntToStr(i);
  end;
  IdHTTPArray[i].Free;
  idHTTP.Free;
  result := Pos(TextAFind, Reponse) > 0;
end;

procedure TTestProxy.TestProxy(Ligne: integer);
var
  i, ProxPort: integer;
  ProxAddr, URL, Text: string;
  Start:TDateTime;
  Stop:TDateTime;
  Diff:extended;
begin
  With Form1 do
  begin
    (*Determine the status of the IP address to see if the proxy server is
      available and notify the form.*)
    i := Ligne;
    Form1.StatusBar1.Panels[5].Text := StatusProxy[TESTPROGRESS];
    EditLine(ListView1.Items.Item[i],
                i,SLOW,'',StatusProxy[TESTPROGRESS] + ' Target-Server : ' +
                            Edit9.Text + ', please wait..');

    ProxAddr := ExtractIPAddress(ListView1.Items.Item[i].Caption);
    ProxPort := ExcerptPort(ListView1.Items.Item[i].Caption);
    if ProxPort = 0 then
      EditLine(ListView1.Items.Item[i],
                  i,
                  FORMATERROR,
                  '',
                  StatusProxy[FORMATERROR]);

      Form1.StatusBar1.Panels[5].Text := StatusProxy[FORMATERROR];

    if ProxPort <> 0 then
    begin
      URL := Edit9.Text;
      //Text := '<title>Google</title>';
      Start := Now();
      if RequestToProxy(ProxAddr, ProxPort, URL, Text) then
      begin
        // Is available
        Stop := Now();
        Diff := Stop - Start;
        if TimeElapsed(Diff) <= 5 then
          EditLine(ListView1.Items.Item[i],
                      i,ACTIV,'',StatusProxy[ACTIV])
        else
        // Server is responding very slowly
          EditLine(ListView1.Items.Item[i],
                      i,SLOW,'',StatusProxy[SLOW]);
      end
      else begin
        Stop := Now();
        Diff := Stop - Start;
        if TimeElapsed(Diff) <= 5 then
        EditLine(ListView1.Items.Item[i],
                    i,ACTIV,'',StatusProxy[EXTINCT])
        else
        // Not available
        EditLine(ListView1.Items.Item[i],
                    i,EXTINCT,'',StatusProxy[TIMEOUT]);
        Form1.StatusBar1.Panels[5].Text := StatusProxy[TIMEOUT];
      end;
    end;
  end;

  if TimeElapsed(Diff) <= 5 then
  begin
    found := found + 1;
    Form1.StatusBar1.Panels[3].Text := IntToStr(found);
    Form1.StatusBar1.Panels[5].Text := StatusProxy[EXTINCT];
  end;
end;

procedure TForm1.Memo1Change(Sender: TObject);
begin
  StatusBar1.Panels[7].Text := 'Range : ' + IntToStr(Memo1.Lines.Count);
  Application.ProcessMessages;
end;

procedure TForm1.Modify2Click(Sender: TObject);
var
  ModifProxy: string;
  i: integer;
begin
  i := ListView1.Selected.Index;
  if i = -1 then exit;
  ModifProxy := ListView1.Items.Item[i].Caption;
  if not inputQuery('Proxy (AdresseIP:Port) :',
              'Enter the proxy address as IPAddress:Port =',
              ModifProxy) then
    exit;
  ModifProxy := CleanProxyAddress(ModifProxy);
  if Pos(':',ModifProxy) = 0 then
  begin
    ShowMessage('Adresse invalide '+ModifProxy);
    exit;
  end;
  ListView1.Items.Item[i].Caption := ModifProxy;
  SaveProxys();
  if  ListView1.Items.Item[i].Checked then
    WriteStringInRegister(INTERNETSETTINGSREGPATH, 'ProxyServer',
                           ListView1.Items.Item[i].Caption);
  TestTheProxy(0, 0);
end;

procedure TForm1.Panel2Click(Sender: TObject);
begin
  Panel1.Visible := Panel2.Checked;

  if Panel2.Checked = false then begin
  Splitter1.Visible := false;
  ListView1.Align := alClient;
  end;

  if Panel2.Checked = true then begin
  ListView1.Align := alLeft;
  ListView1.Width := 380;
  Splitter1.Visible := true;
  end;

end;

procedure TForm1.Delete1Click(Sender: TObject);
var
  i: integer;
  Question: string;
begin
  if ListView1.SelCount = 0 then exit;
  MessageBeep(MB_ICONQUESTION);
  Question := 'Are you sure you want to delete these '+
              IntToStr(ListView1.SelCount) + ' server Proxy?';
  if MessageDlg(Question, mtConfirmation, [mbYes, mbNo], 0) = IDYes then
  begin
    try
    for i:=0 to ListView1.Items.Count-1 do
      if ListView1.Items.Item[i].Selected then
      begin
        if ListView1.Items.Item[i].Checked then
          WriteIntegerToRegister(INTERNETSETTINGSREGPATH, 'ProxyEnable', 0);
        ListView1.Items.Item[i].Delete;
       SaveProxys;
     end;
     except
     end;
  end;
end;

procedure TForm1.Close1Click(Sender: TObject);
begin
  StopAllTests();
  Application.Terminate;
end;

procedure TForm1.Copy1Click(Sender: TObject);
var
  item: TListItem;
  s : string;
begin
  if ListView1.Items.Count = 0 then begin
  MessageBox(Application.Handle,'There are no IP addresses.',
          PChar(Application.Title),MB_OK or MB_ICONINFORMATION or MB_SYSTEMMODAL);
  Exit;
  end;

  item := ListView1.Selected;

  if item <> nil then
  begin
   s := item.Caption;
   Clipboard.AsText := s;
  end;
end;

procedure TForm1.ImportClick(Sender: TObject);
var
  List : textfile;
  texte : string;
  Question: string;
begin
  if not OpenDialog1.Execute then exit;
  MessageBeep(MB_ICONQUESTION);
  Question := 'Do you want to import this file at the end of the existing list?'+#13#10
             +'Click Yes to import the file to the end of the list.'+#13#10
             +'Click No to clear everything before importing.';

  if MessageDlg(Question, mtConfirmation, [mbYes, mbNo], 0) = IDNo then
    ListView1.Items.Clear;

  assignFile(List, OpenDialog1.FileName);
  reset(List);
  while not eof(List) do
  begin
    readln(List, texte);
    EditLine(ListView1.Items.Add,
             ListView1.Items.Count,UNKNOWN,texte,StatusProxy[UNKNOWN]);
  end;
  closefile(List);
  StatusBar1.Panels[1].Text := IntToStr(ListView1.Items.Count);
end;

procedure TForm1.ExportClick(Sender: TObject);
var
  i: Integer;
  Fp : textfile;
  Question: string;
begin
  if not SaveDialog1.Execute then exit;
  if FileExists(SaveDialog1.FileName) then
  begin
    MessageBeep(MB_ICONQUESTION);
    Question := 'The File "'+SaveDialog1.FileName+'" already exists.'#13#10
               +'Do you want to replace it?';
    if MessageDlg(Question, mtConfirmation, [mbYes, mbNo], 0) = IDNo then
      exit
  end;
  assignFile(Fp, SaveDialog1.FileName);
  reWrite(Fp);
  for i := 0 to ListView1.items.count - 1 do
  begin
    Writeln(Fp, ListView1.Items.Item[i].Caption);
  end;
  closefile(Fp);
end;

function LaunchAndWait(sFile: String; wShowWin: Word): Boolean;
var
  cExe: array [0..255] of Char;
  sExe: string;
  pcFile: PChar;
  StartInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
begin
  // Edit Proxy list from Notepad and update it
  Result:=True;
  FindExecutable(PChar(ExtractFileName(sFile)), PChar(ExtractFilePath(sFile)), cExe);
  sExe:= string(cExe);

  if UpperCase(ExtractFileName(sExe))<>UpperCase(ExtractFileName(sFile))
  then pcFile:=PChar(' "'+sFile+'"')
  else pcFile:=nil;

  ZeroMemory(@StartInfo, SizeOf(StartInfo));

  with StartInfo do begin
    cb:=SizeOf(StartInfo);
    dwFlags:=STARTF_USESHOWWINDOW;
    wShowWindow:=wShowWin;
  end;

  if CreateProcess(PChar(sExe), pcFile, nil, nil, True, 0, nil, nil, StartInfo, ProcessInfo)
  then WaitForSingleObject(ProcessInfo.hProcess, INFINITE)
  else Result:=False;
end;

procedure TForm1.EditProxy1Click(Sender: TObject);
begin
  Beep;
  ShowMessage('The list of Proxys will be reloaded automatically when closing the Notepad.');
  LaunchAndWait(ExtractFileDir(Application.Exename)+'\'+ PROXYLIST, SW_SHOWNORMAL);
  StopAllTests();
  LoadProxys();
  //RefreshProxies();
  //ClosureRequested := False;
  //SearchProxys();
end;

procedure TForm1.Backup1Click(Sender: TObject);
var
  i: Integer;
  Fp : textfile;
  Question: string;
begin
  // Create a Backup Proxy list
  try
    assignFile(Fp, ExtractFilepath(Application.ExeName) + 'Data\Backup\backup.ini');
    reWrite(Fp);
    for i := 0 to ListView1.items.count - 1 do
    begin
      Writeln(Fp, ListView1.Items.Item[i].Caption);
    end;
  finally
    closefile(Fp);
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  Reg: TRegistry;
begin
  StatusBar1.SetFocus;
  (*The registry key ProxyEnable controls the activation of a proxy server for
    Windows applications that use the WinINET API, such as Internet Explorer or
    Microsoft Edge. It is part of the Internet settings in the Windows registry.*)
  Beep;
   if MessageBox(Handle,'Create Registry Key ProxyEnable, continue?' + #13 +
                'HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings',
                 'Confirm',MB_YESNO) = IDYES then
   BEGIN
       try
         Reg:= TRegistry.Create;
         Reg.RootKey:= HKEY_CURRENT_USER;
         Reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings',True);
         Reg.WriteInteger('ProxyEnable',1);
       finally
        Reg.Free;
       end;
   END;

  reg:= TRegistry.Create;
  try
    reg.RootKey:= HKEY_CURRENT_USER;
    if reg.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\', False) then
    begin
      if reg.ValueExists('ProxyEnable') then
      begin
        Label15.Font.Color := clBlue;
        Label15.Caption := 'found';
      end else begin
        Label15.Font.Color := clMaroon;
        Label15.Caption := 'not found';
      end;
    end;
  finally
     reg.Free;
  end;
  Application.ProcessMessages;
end;


procedure TForm1.Button2Click(Sender: TObject);
begin
  Beep;
  if MessageBox(Handle,'Overwrite Proxy list? ','Confirm',MB_YESNO) = IDYES
  then
  BEGIN
    Memo1.Lines.SaveToFile(ExtractFilePath(Application.ExeName) +
                          'Data\Proxys\ProxyList.ini');
    StatusBar1.Panels[7].Text := 'List updated.';
    ListView1.Clear;
    LoadProxys();
    StatusBar1.Panels[1].Text := IntToStr(ListView1.Items.Count);
  END;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  Start, Stop: TIPAddr;
  i, t, b, g, k, l, m, n : Integer;

begin
  // Calculate the range of IP addresses
  abort := false;
  if RadioButton2.Checked = true then Memo1.Clear;

  i := StrToInt(Edit1.Text);
  t := StrToInt(Edit2.Text);
  b := StrToInt(Edit3.Text);
  g := StrToInt(Edit4.Text);

  k := StrToInt(Edit5.Text);
  l := StrToInt(Edit6.Text);
  m := StrToInt(Edit7.Text);
  n := StrToInt(Edit8.Text);

  Start[0] := i;
  Start[1] := t;
  Start[2] := b;
  start[3] := g;

  Stop[0] := k;
  Stop[1] := l;
  Stop[2] := m;
  Stop[3] := n;
  repeat
    Memo1.Lines.Add(IntToStr(Start[0]) + '.' + IntToStr(Start[1]) + '.' +
      IntToStr(Start[2]) + '.' + IntToStr(Start[3]) + ':' + IntToStr(SpinEdit4.Value)  );
    if abort = true then Exit;
    if not GetNext(Start) then Exit;
  until not
  IsBelowOrEqual(Start, Stop);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  abort := true;
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  reg: TRegistry;
begin
  StatusBar1.SetFocus;
  (*A registry proxy server is a system that stands between clients
    (like developers or automated systems) and an external image
    repository (like Docker Hub). Its primary function is to cache
    container images locally, which offers a number of benefits
    for organizations.*)
  Beep;
  if MessageBox(Handle,'Create a empty Registry Binary Key ProxyServer, continue?' + #13 +
                'HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings',
                 'Confirm',MB_YESNO) = IDYES then
  BEGIN
    // Creates a TRegistry Object, erzeugt ein a TRegistry Objekt
    reg := TRegistry.Create;
    try
        // set the the Mainkey, bestimmt den Hauptschlüssel
        reg.RootKey := HKEY_CURRENT_USER;
        // Open a key, den Schlüssel öffnen
        reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings', True);
        // Save a string value, speichert einen String-Wert
        reg.WriteString('ProxyServer', '');

        if reg.ValueExists('ProxyServer') then
        begin
          Label16.Font.Color := clBlue;
          Label16.Caption := 'found';
        end else begin
          Label16.Font.Color := clMaroon;
          Label16.Caption := 'not found';
        end;

      // Close the key, Schlüssel schliessen
        reg.CloseKey;
    finally
        // and free the TRegistry Object, das TRegistry Objekt freigeben
        reg.Free;
    end;
  END;
  Application.ProcessMessages;
end;

end.
