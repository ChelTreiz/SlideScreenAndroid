program SlideOK;

uses
  System.StartUpCopy,
  FMX.Forms,
  SlideOKPas in 'SlideOKPas.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
