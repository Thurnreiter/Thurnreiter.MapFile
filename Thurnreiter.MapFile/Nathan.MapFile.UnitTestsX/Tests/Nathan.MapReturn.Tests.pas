unit Nathan.MapReturn.Tests;

interface

uses
  DUnitX.TestFramework,
  Nathan.MapFile.Core;

type
  [TestFixture]
  TTestMapReturn = class(TObject)
  public
    [Test]
    procedure Test_ToString;
  end;

implementation

procedure TTestMapReturn.Test_ToString;
var
  Cut: TMapReturn;
  Actual: string;
begin
  //  Arrange...
  Cut.Offset := 0;
  Cut.LineNumberFromAddr := $0020413C;
  Cut.ModuleStartFromAddr := $0020413C;
  Cut.ModuleNameFromAddr := 'Main';
  Cut.ProcNameFromAddr := 'Main.TForm1.FormCreate';
  Cut.SourceNameFromAddr := 'Main.pas';
  Cut.LineNumberErrors := 1;

  //  Act...
  Actual := Cut.ToString;

  //  Assert...
  Assert.AreEqual('Offset: 0'#$D#$A'Codeline:                        2113852'#$D#$A'Startaddress from Module:        $0020413C'#$D#$A'Name of procedure from address:  Main.TForm1.FormCreate'#$D#$A'Sourcename from address:         Main.pas', Actual);
end;


initialization
  TDUnitX.RegisterTestFixture(TTestMapReturn);

end.
