unit Nathan.MapFile.Core.Tests;

interface

uses
  DUnitX.TestFramework,
  Nathan.Resources.ResourceManager,
  Nathan.MapFile.Core;

type
  [TestFixture]
  TTestNathanMapFile = class(TObject)
  const
    DemoMap = '.\ExceptionStackTraceDemo.map';
  private
    FCut: INathanMapFile;
  public
    [Setup]
    procedure Setup;

    [TearDown]
    procedure TearDown;

    [Test]
    procedure Test_HasCreated;

    [Test]
    procedure Test_HasAllProperties;

    [Test]
    procedure Test_Scan_Ex;

    [TestCase('Scan_57_01', '$0020413C,0,$203DFC')]
    [TestCase('Scan_57_02', '$0020413D,1,$203DFC')]
    [TestCase('Scan_57_03', '$00204144,8,$203DFC')]
    procedure Test_Scan_Line57(CAValue, OffsetValue, StartAddrValue: Integer);

    [Test]
    procedure Test_Scan_Line57_TwoTimes;

    [Test]
    procedure Test_Scan_Line57_OverConstructor;

    [TestCase('VAFromAddress01', '$14E20B0,$10E10B0')]
    procedure Test_VAFromAddress(AddrValue, VAValue: Integer);
  end;

implementation

uses
  System.SysUtils,
  System.IOUtils;

procedure TTestNathanMapFile.Setup;
begin
  TResourceManager.SaveResource('ExDemoMap', DemoMap);
end;

procedure TTestNathanMapFile.TearDown;
begin
  FCut := nil;
  if TFile.Exists(DemoMap) then
    TFile.Delete(DemoMap);
end;

procedure TTestNathanMapFile.Test_HasCreated;
begin
  FCut := TNathanMapFile.Create();
  Assert.IsNotNull(FCut);
end;

procedure TTestNathanMapFile.Test_HasAllProperties;
begin
  FCut := TNathanMapFile.Create();
  FCut.MapFilename := 'MapFilename';
  FCut.CrashAddress := $2020;

  Assert.AreEqual('MapFilename', FCut.MapFilename);
  Assert.AreEqual($2020, FCut.CrashAddress);
end;

procedure TTestNathanMapFile.Test_Scan_Ex;
begin
  FCut := TNathanMapFile.Create();
  FCut.CrashAddress := $2020;
  Assert.WillRaiseWithMessage(
    procedure
    begin
      FCut.Scan;
    end,
    EArgumentException,
    'MapFilename "" or CrashAddress "8224" invalid!');
end;

procedure TTestNathanMapFile.Test_Scan_Line57(CAValue, OffsetValue, StartAddrValue: Integer);
begin
  FCut := TNathanMapFile.Create();
  FCut.MapFilename := DemoMap;
  FCut.CrashAddress := CAValue;
  Assert.WillNotRaiseAny(
    procedure
    begin
      FCut.Scan;
    end);

  Assert.AreEqual(OffsetValue, FCut.MapReturn.Offset);
  Assert.AreEqual(57, FCut.MapReturn.LineNumberFromAddr);
  Assert.AreEqual(StartAddrValue, FCut.MapReturn.ModuleStartFromAddr);
  Assert.AreEqual('Main', FCut.MapReturn.ModuleNameFromAddr);
  Assert.AreEqual('Main.TForm1.FormCreate', FCut.MapReturn.ProcNameFromAddr);
  Assert.AreEqual('Main.pas', FCut.MapReturn.SourceNameFromAddr);
  Assert.AreEqual(42, FCut.MapReturn.LineNumberErrors);
end;

procedure TTestNathanMapFile.Test_Scan_Line57_TwoTimes;
begin
  FCut := TNathanMapFile.Create();
  FCut.MapFilename := DemoMap;
  FCut.CrashAddress := $0020413C;
  Assert.WillNotRaiseAny(
    procedure
    begin
      FCut.Scan;
    end);

  Assert.AreEqual(0, FCut.MapReturn.Offset);
  Assert.AreEqual(57, FCut.MapReturn.LineNumberFromAddr);
  Assert.AreEqual($203DFC, FCut.MapReturn.ModuleStartFromAddr);
  Assert.AreEqual('Main', FCut.MapReturn.ModuleNameFromAddr);
  Assert.AreEqual('Main.TForm1.FormCreate', FCut.MapReturn.ProcNameFromAddr);
  Assert.AreEqual('Main.pas', FCut.MapReturn.SourceNameFromAddr);
  Assert.AreEqual(42, FCut.MapReturn.LineNumberErrors);

  FCut.MapFilename := DemoMap;
  FCut.CrashAddress := $0020413D;
  Assert.WillNotRaiseAny(
    procedure
    begin
      FCut.Scan;
    end);

  Assert.AreEqual(1, FCut.MapReturn.Offset);
  Assert.AreEqual(57, FCut.MapReturn.LineNumberFromAddr);
  Assert.AreEqual($203DFC, FCut.MapReturn.ModuleStartFromAddr);
  Assert.AreEqual('Main', FCut.MapReturn.ModuleNameFromAddr);
  Assert.AreEqual('Main.TForm1.FormCreate', FCut.MapReturn.ProcNameFromAddr);
  Assert.AreEqual('Main.pas', FCut.MapReturn.SourceNameFromAddr);
  Assert.AreEqual(42, FCut.MapReturn.LineNumberErrors);
end;

procedure TTestNathanMapFile.Test_Scan_Line57_OverConstructor;
begin
  FCut := TNathanMapFile.Create(DemoMap, $0020413C);
  Assert.WillNotRaiseAny(
    procedure
    begin
      FCut.Scan;
    end);

  Assert.AreEqual(0, FCut.MapReturn.Offset);
  Assert.AreEqual(57, FCut.MapReturn.LineNumberFromAddr);
  Assert.AreEqual($203DFC, FCut.MapReturn.ModuleStartFromAddr);
  Assert.AreEqual('Main', FCut.MapReturn.ModuleNameFromAddr);
  Assert.AreEqual('Main.TForm1.FormCreate', FCut.MapReturn.ProcNameFromAddr);
  Assert.AreEqual('Main.pas', FCut.MapReturn.SourceNameFromAddr);
  Assert.AreEqual(42, FCut.MapReturn.LineNumberErrors);
end;

procedure TTestNathanMapFile.Test_VAFromAddress(AddrValue, VAValue: Integer);
begin
  Assert.AreEqual(VAValue, TNathanMapFile.VAFromAddress(AddrValue));
end;

initialization
  TDUnitX.RegisterTestFixture(TTestNathanMapFile);

end.
