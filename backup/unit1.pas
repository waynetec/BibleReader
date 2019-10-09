unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Menus,
  ExtCtrls, DividerBevel, IniFiles;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    FontDialog1: TFontDialog;
    ListBox1: TListBox;
    ListBox2: TListBox;
    ListBox3: TListBox;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    PopupMenu1: TPopupMenu;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    Splitter4: TSplitter;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox2Click(Sender: TObject);
    procedure ListBox3Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private

  public
    Ini : TIniFile;
    filename : String;
    testament : Integer;
    path : String;
  end;

var
  Form1: TForm1;

implementation
{Procedure to search through subdirectores and return directory list}
{@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@}
procedure GetSubDirectories(const directory : string; list : TStrings) ;
 var
   sr : TSearchRec;
 begin
   try
     if FindFirst(directory, faDirectory, sr) < 0 then
       Exit
     else
     repeat
       if ((sr.Attr and faDirectory <> 0) AND (sr.Name <> '.') AND (sr.Name <> '..')) then
         List.Add(sr.Name)
     until FindNext(sr) <> 0;
   finally
     SysUtils.FindClose(sr) ;
   end;
 end;
{@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@}
{Procedure to search a directory for files and return file list}
procedure GetSubFiles(const directory : string; list : TStrings) ;
 var
   sr : TSearchRec;
 begin
   try
     if FindFirst(directory, faAnyFile, sr) < 0 then
       Exit
     else
     repeat
       if ((sr.Attr and faAnyFile <> 0) AND (sr.Name <> '.') AND (sr.Name <> '..')) then
         List.Add(ChangeFileExt(sr.Name,''))
     until FindNext(sr) <> 0;
   finally
     SysUtils.FindClose(sr) ;
   end;
 end;
{@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@}
function MySortProc(List: TStringList; Index1, Index2: Integer): Integer;
var
  Value1, Value2: Integer;
begin
  Value1 := StrToInt(List[Index1]);
  Value2 := StrToInt(List[Index2]);
  if Value1 < Value2 then
    Result := -1
  else if Value2 < Value1 then
    Result := 1
  else
    Result := 0;
end;
{@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@}
{$R *.lfm}

{ TForm1 }
procedure TForm1.FormCreate(Sender: TObject);
var
  AByte : Byte;
  str : TStringList;
begin
   Ini := TIniFile.Create( ChangeFileExt( Application.ExeName, '.INI' ) );
   try
     filename := Ini.ReadString('LAST','FILE','');
     if filename <> '' then
     begin
      Memo1.Lines.LoadFromFile(filename);
     end;
     {
    AByte:=Integer(Memo1.Font.Style);
    Ini.WriteInteger('FONT','STYLE',AByte);
    }
     Memo1.Font.Name:= Ini.ReadString('FONT','NAME',Memo1.Font.Name);
     Memo1.Font.Size:= Ini.ReadInteger('FONT','SIZE',Memo1.Font.Size);
     AByte := Ini.ReadInteger('FONT','STYLE',Integer(Memo1.Font.Style));
     Memo1.Font.Style := TFontStyles(Integer(AByte));
     ListBox1.Font := Memo1.Font;
     ListBox2.Font := Memo1.Font;
     ListBox3.Font := Memo1.Font;
     {@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@}
      str := TStringList.Create;
      GetSubDirectories('KJV/01OT/*',str);
      ListBox1.Clear;
      ListBox1.Items.Assign(str);
      str.Clear;
      GetSubDirectories('KJV/02NT/*',str);
      ListBox2.Clear;
      ListBox2.Items.Assign(str);
      str.Free;
      ListBox1.ItemIndex:= 0;
     {@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@}


   finally
   end;
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
    AByte:Byte;
begin
  Ini := TIniFile.Create(ChangeFileExt(Application.ExeName, '.INI'));

  try
    Ini.WriteString('LAST','FILE',filename);
    Ini.WriteString('FONT','NAME',Memo1.Font.Name);
    Ini.WriteInteger('FONT','SIZE',Memo1.Font.Size);
    AByte:=Integer(Memo1.Font.Style);
    Ini.WriteInteger('FONT','STYLE',AByte);
    {Save AByte}

  finally
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  try
    Memo1.Font.Size:= Memo1.Font.Size + 1;
  finally
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
   try
    Memo1.Font.Size:= Memo1.Font.Size - 1;
  finally
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  if FontDialog1.Execute then
  begin
   Memo1.Font := FontDialog1.Font;
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  if Panel1.Visible then
  begin
   Panel1.Width:=1;
   Panel1.Visible:= false;
  end
  else
  begin
    Panel1.Width:=Memo1.Width div 2;
    Panel1.Visible:= true;
  end;
end;

procedure TForm1.FormPaint(Sender: TObject);
begin
     Width := (Screen.Width div 3) * 1;
     Height := (Screen.Height div 4) * 3;
     Memo1.Height := (Height div 10) * 9;
     Memo1.Top:= (Height div 20);
     Memo1.Width:= (Width div 4) * 3;
     Memo1.Left:= (Width div 2) - (Memo1.Width div 2);
     ListBox1.Height:= (Memo1.Height div 2);


end;

procedure TForm1.ListBox1Click(Sender: TObject);
var
  chapter : String;
  str : TStringList;
begin
     str := TStringList.Create;
     ListBox3.Clear;
     chapter:= ListBox1.Items.Strings[ListBox1.ItemIndex];
     GetSubFiles('KJV/01OT/'+chapter+'/*',str);
     ListBox3.Clear;
     str.CustomSort(@MySortProc);
     ListBox3.Items.Assign(str);
     str.Free;
     testament := 1;
end;

procedure TForm1.ListBox2Click(Sender: TObject);
var
  chapter : String;
  str : TStringList;
begin
       str := TStringList.Create;
       ListBox3.Clear;
       chapter:= ListBox2.Items.Strings[ListBox2.ItemIndex];
       GetSubFiles('KJV/02NT/'+chapter+'/*',str);
       ListBox3.Clear;
       str.CustomSort(@MySortProc);
       ListBox3.Items.Assign(str);
       str.Free;
       testament := 2;
end;

procedure TForm1.ListBox3Click(Sender: TObject);
begin
    path := '';

     if testament = 1 then
     begin
       path :=  GetCurrentDir + '/KJV/01OT/' + ListBox1.Items.Strings[ListBox1.ItemIndex] +'/'+ ListBox3.Items.Strings[ListBox3.ItemIndex] +'.txt';
       Memo1.Clear;
       Memo1.Lines.LoadFromFile(path);
       Caption := 'LazBible - ' + path;
       filename := path;

     end;
     if testament = 2 then
     begin
       path :=  GetCurrentDir + '/KJV/02NT/' + ListBox2.Items.Strings[ListBox2.ItemIndex] +'/'+ ListBox3.Items.Strings[ListBox3.ItemIndex] +'.txt';
       Memo1.Clear;
       Memo1.Lines.LoadFromFile(path);
       Caption := 'LazBible - ' + path;
       filename:=path;

       end;
end;

procedure TForm1.MenuItem1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    Memo1.Lines.LoadFromFile(OpenDialog1.FileName);
    filename := OpenDialog1.FileName;
  end;
end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin

end;

procedure TForm1.Panel1Click(Sender: TObject);
begin

end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  cap : String;
begin
  try
   cap := 'Reader : ' + filename;
   Caption := cap;
  finally
  end;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin

end;

end.

