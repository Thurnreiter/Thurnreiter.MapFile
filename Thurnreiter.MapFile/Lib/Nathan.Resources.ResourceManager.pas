unit Nathan.Resources.ResourceManager;

interface

uses
  System.Classes,
  System.Types;

type
  /// <summary>
  ///   https://msdn.microsoft.com/de-de/library/system.resources.resourcemanager(v=vs.110).aspx
  ///   https://msdn.microsoft.com/en-us/library/system.resources(v=vs.110).aspx
  ///   https://msdn.microsoft.com/en-us/library/system.resources.resourcemanager(v=vs.110).aspx
  /// </summary>
  TResourceManager = record
  public
    class function GetStream(const Name: string): TStream; overload; static;
    class function GetStream(const Name: string; const ResType: PChar): TStream; overload; static;

    class function GetString(const Name: string): string; overload; static;
    class function GetString(const Name: string; const ResType: PChar): string; overload; static;

    class procedure SaveResource(const ResName, SaveToFilename: string; const ResType: PChar = RT_RCDATA); static;
    class procedure SaveToFile(const ResName, SaveToFilename: string; const ResType: PChar = RT_RCDATA); static;
  end;

  ResourceManager = TResourceManager;

implementation

uses
  System.SysUtils,
  System.IOUtils;

{ TResourceManager }

class function TResourceManager.GetStream(const Name: string): TStream;
begin
  Result := GetStream(Name, RT_RCDATA);
end;

class function TResourceManager.GetStream(const Name: string; const ResType: PChar): TStream;
begin
  Result := TResourceStream.Create(HInstance, Name, ResType);
end;

class function TResourceManager.GetString(const Name: string): string;
begin
  Result := GetString(Name, RT_RCDATA);
end;

class function TResourceManager.GetString(const Name: string; const ResType: PChar): string;
var
  RawStream: TResourceStream;
  StringStream: TStringStream;
begin
  RawStream := TResourceStream.Create(HInstance, Name, ResType);
  try
    StringStream := TStringStream.Create('');
    try
      RawStream.SaveToStream(StringStream);
      StringStream.Position := 0;
      Result := StringStream.DataString;
    finally
      StringStream.Free();
    end;
  finally
    RawStream.Free();
  end;
end;

class procedure TResourceManager.SaveResource(const ResName, SaveToFilename: string; const ResType: PChar);
var
  RS: TResourceStream;
begin
  if TDirectory.Exists(TPath.GetFileName(SaveToFilename)) then
    TDirectory.CreateDirectory(TPath.GetFileName(SaveToFilename));

  RS := nil;
  try
    RS := TResourceStream.Create(HInstance, ResName, ResType);
    RS.SaveToFile(SaveToFileName);
  finally
    FreeAndNil(RS);
  end;
end;

class procedure TResourceManager.SaveToFile(const ResName, SaveToFilename: string; const ResType: PChar);
begin
  TResourceManager.SaveResource(ResName, SaveToFilename, ResType);
end;

end.
