program NathanMapFile;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Nathan.MapFile.Core in '..\Nathan.MapFile.Core.pas';

const
  HelpMsg = 'The following start parameters are available:' + sLineBreak + sLineBreak
    + '  MapFilename ' + #9 + 'Name of MAP file, for example: "c:\AnyFolder\ExceptionStackTraceDemo.map"' + sLineBreak
    + '  CrashAddress' + #9 + 'Crash address in  hexadecimal for example: "$0020413C"' + sLineBreak
    + '  Call [ ]';
var
  NMF: INathanMapFile;
  ParamMapFilename: string;
  ParamCrashAddress: string;
begin
  try
    //https://github.com/magicmonty/delphi-code-coverage
    //  -MapFilename:..\..\..\Nathan.MapFile.UnitTestsX\ExceptionStackTraceDemo.map -CrashAddress:$0020413C

    //  -MapFilename:D:\Dev\WSCAR-Trunk\lib\XE\Thurnreiter.MapFile\DummyProject\Win32\Debug\DummyProject.map -CrashAddress:$005CDF76
    //---------------------------
    //Dummyproject
    //---------------------------
    //Zugriffsverletzung bei Adresse 005CDF76 in Modul 'DummyProject.exe'. Lesen von Adresse 00000000.
    //---------------------------
    //OK
    //---------------------------
    //  Return Line 34 in Unit1.pas

    if (not FindCmdLineSwitch('MapFilename', ParamMapFilename))
    or (not FindCmdLineSwitch('CrashAddress', ParamCrashAddress)) then
    begin
      Writeln(HelpMsg);
      Exit;
    end;

    NMF := TNathanMapFile.Create(ParamMapFilename.Trim, TNathanMapFile.VAFromAddress(ParamCrashAddress.Trim.ToInteger));
    NMF.Scan;
    Writeln(NMF.MapReturn.ToString + sLineBreak);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

  Writeln('Press [ENTER] to continue.');
  Readln;
end.
