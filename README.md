# Thurnreiter.MapFile

Delphi MAP File analyzer
========================
This is a simple MAP file analyzer for Delphi. Very often I had only the address of access violations, but could not find out where. 
For example:

  Access violation at address 005CDF76 in module 'DummyProject. exe'. Read address 00000000.

Now I can find out the line of code and methodname by using the MAP file. Developed with Delphi Toyko 10.2

#### Sample
```delphi
uses
  Nathan.MapFile.Core in '..\Nathan.MapFile.Core.pas';
...
var
  NMF: INathanMapFile;
begin
  NMF := TNathanMapFile.Create('.\DummyProject.map', TNathanMapFile.VAFromAddress($005CDF76));
  NMF.Scan;
  Writeln(NMF.MapReturn.ToString);
end;
```
Call
> NathanMapFile.exe -MapFilename:.\DummyProject.map -CrashAddress:$005CDF76

Output:
```
Offset: 6
Codeline:                        34
Startaddress from Module:        $001CCCA0
Name of procedure from address:  Unit1.TForm1.Button1Click
Sourcename from address:         Unit1.pas

Press [ENTER] to continue.
```
