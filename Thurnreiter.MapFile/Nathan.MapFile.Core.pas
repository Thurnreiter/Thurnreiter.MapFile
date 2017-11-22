unit Nathan.MapFile.Core;

interface

uses
  System.Classes,
  System.SysUtils;

{$M+}

type
  TMapReturn = record
    //    Segment: Word;
    Offset: Integer;
    LineNumberFromAddr: Integer;
    ModuleStartFromAddr: Integer;
    ModuleNameFromAddr: string;
    ProcNameFromAddr: string;
    SourceNameFromAddr: string;
    LineNumberErrors: Integer;
    function ToString(): string;
  end;


  INathanMapFile = interface
    ['{09B391E3-9D2F-486D-A349-F1E34BE9071F}']
    function GetMapFilename(): string;
    procedure SetMapFilename(const Value: string);

    function GetCrashAddress(): Integer;
    procedure SetCrashAddress(Value: Integer);

    function GetMapReturn(): TMapReturn;

    procedure Scan();

    property MapFilename: string read GetMapFilename write SetMapFilename;
    property CrashAddress: Integer read GetCrashAddress write SetCrashAddress;
    property MapReturn: TMapReturn read GetMapReturn;
  end;

  TNathanMapFile = class(TInterfacedObject, INathanMapFile)
  strict private
    FMapFilename: string;
    FCrashAddress: Integer;
    FMapReturn: TMapReturn;
  private
    function GetMapFilename(): string;
    procedure SetMapFilename(const Value: string);

    function GetCrashAddress(): Integer;
    procedure SetCrashAddress(Value: Integer);

    function GetMapReturn(): TMapReturn;

    procedure CheckStart();
  public
    constructor Create(const AMapFilename: string; ACrashAddress: Integer); overload;

    class function VAFromAddress(const AAddr: Integer): Integer; inline;

    procedure Scan();
  end;

{$M-}

implementation

uses
  System.IOUtils,
  JclDebug;

{ **************************************************************************** }

{ TMapReturn }

function TMapReturn.ToString: string;
const
  //  Format('%p -> %p -> %d', [@iptrValue, iptrValue, iptrValue^]);
  //  function GetAddressOf(var X): string;
  //  begin
  //    Result := IntToHex(Integer(Pointer(@X)), 8);
  //  end;
  //  p := System.ReturnAddress;
  //  Caption := GetAddressOf(P);

  ToStringMsg = 'Offset: %d%s'
    + 'Codeline:                        %d%s'
    + 'Startaddress from Module:        $%p%s'
    + 'Name of procedure from address:  %s%s'
    + 'Sourcename from address:         %s';
begin
  Result := string.Format(ToStringMsg,
    [Offset,
    sLinebreak,
    LineNumberFromAddr,
    sLinebreak,
    Pointer(ModuleStartFromAddr),
    sLinebreak,
    ProcNameFromAddr,
    sLinebreak,
    SourceNameFromAddr]);
end;

{ **************************************************************************** }

{ TNathanMapFile }

constructor TNathanMapFile.Create(const AMapFilename: string; ACrashAddress: Integer);
begin
  inherited Create();
  SetMapFilename(AMapFilename);
  SetCrashAddress(ACrashAddress);
end;

function TNathanMapFile.GetCrashAddress: Integer;
begin
  Result := FCrashAddress;
end;

function TNathanMapFile.GetMapFilename: string;
begin
  Result := FMapFilename;
end;

function TNathanMapFile.GetMapReturn: TMapReturn;
begin
  Result := FMapReturn;
end;

procedure TNathanMapFile.SetCrashAddress(Value: Integer);
begin
  FCrashAddress := Value;
end;

procedure TNathanMapFile.SetMapFilename(const Value: string);
begin
  FMapFilename := Value;
end;

procedure TNathanMapFile.CheckStart();
const
  OutMsgAll = 'MapFilename "%s" or CrashAddress "%d" invalid!';
  OutMsgFN = 'MapFilename "%s" not found!';
begin
  if (FMapFilename.IsEmpty) or (FCrashAddress = 0) then
    raise EArgumentException.CreateFmt(OutMsgAll, [FMapFilename, FCrashAddress]);

  if (not TFile.Exists(FMapFilename)) then
    raise EFileNotFoundException.CreateFmt(OutMsgFN, [FMapFilename]);
end;

class function TNathanMapFile.VAFromAddress(const AAddr: Integer): Integer;
begin
  //  Result := Pointer(AAddr) - $400000 - $1000;
  //  In the moment are fix...
  Result := AAddr - $400000 - $1000;
end;

procedure TNathanMapFile.Scan();
var
  MapScanner: TJclMapScanner;
  DummyOffset: Integer;
begin
  CheckStart();

  MapScanner := TJclMapScanner.Create(FMapFilename);
  try
    FMapReturn.LineNumberFromAddr := MapScanner.LineNumberFromAddr(FCrashAddress, DummyOffset);
    FMapReturn.Offset := DummyOffset;
    FMapReturn.ModuleStartFromAddr := MapScanner.ModuleStartFromAddr(FCrashAddress);
    FMapReturn.ModuleNameFromAddr := MapScanner.ModuleNameFromAddr(FCrashAddress);
    FMapReturn.ProcNameFromAddr := MapScanner.ProcNameFromAddr(FCrashAddress);
    FMapReturn.SourceNameFromAddr := MapScanner.SourceNameFromAddr(FCrashAddress);
    FMapReturn.LineNumberErrors := MapScanner.LineNumberErrors;
  finally
    MapScanner.Free;
  end;
end;

end.
