unit SlideOKPas;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.Ani;

type
  TForm3 = class(TForm)
    Layout1: TLayout;
    GridLayout2: TGridLayout;
    GridLayout1: TGridLayout;
    Rectangle2: TRectangle;
    FloatAnimation1: TFloatAnimation;
    GridLayout3: TGridLayout;
    Rectangle1: TRectangle;
    Rectangle3: TRectangle;
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure FloatAnimation1Finish(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
  private
    { D�clarations priv�es }
  public
    { D�clarations publiques }
  end;

var
  Form3: TForm3;                //d�termine si c'est la premiere fois qu'on active la proc�dure OnMove,
  FirstTime:boolean;            //c'est a dire si c'est la premiere fois qu'on touche l'�cran (1er touch� du OnMove)
  IndexPage,                    //IndexPage=Index page en cours (commence � 0)
  IndexMaxPage:integer;         //IndexMaxPage=Nbre de page Max
  La,Ha : integer;              //Largeur et hauteur de l'�cran
  PosX : Single;                //PosX=position du premier touch�,

implementation

{$R *.fmx}

procedure TForm3.FormCreate(Sender: TObject);   // � la cr�ation de la page et aussi quand on la ReSize pour prendre en compte la rotation du t�l
begin                                           // C'est pourquoi le Form.OnResize=Form.OnCreate
     La:=Screen.Width;          // releve la largeur de l'�cran
     Ha:=Screen.Height;         // releve la hauteur de l'�cran
     IndexPage:=0;              // Valeur initial de IndexPage
     IndexMaxPage:=2;           // Valeur Max de IndexPage. On a nbre de page = IndexMaxPage+1, car indexPage commence � 0
     Layout1.Width:=La*(IndexMaxPage+1);   // Le Layout 1 doit fait la largeur de l'�cran x le nbre de page
     Layout1.Height:=Ha;           // La hauteur de Layout1 est celle de l'�cran
     Layout1.Position.X:=0;        // La position X de Layout1 est 0
     Layout1.Position.Y:=0;        // La position Y de Layout1 est 0
     GridLayout1.Width:=La;        // Chaque sous-grille a la largeur de l'�cran
     GridLayout1.Height:=Ha;       // Chaque sous-grille a la heuteur de l'�cran
     GridLayout1.Position.X:=0;    // La 1ere sous grille est en position X=0
     GridLayout2.Width:=La;
     GridLayout2.Height:=Ha;
     GridLayout2.Position.X:=La;   // la 2eme sous-grille est en position X=La*1, la 3eme en positionX= La*2 etc..en fait La x son index
     GridLayout3.Width:=La;
     GridLayout3.Height:=Ha;
     GridLayout3.Position.X:=La*2;
     FirstTime:=False;
end;

procedure TForm3.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  PosX:=X;         //rep�re la position du premier touch�
  FirstTime:=True;
end;

procedure TForm3.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Single);
begin
  if FirstTime then
  begin
    if X-PosX-IndexPage*La<40 then            //bloque la premi�re page pour l'empecher de reculer
    Layout1.Position.X :=X-PosX-IndexPage*La; // La position du layout=position du doigt actuelle - celle de d�part
  end;                                        //en tenant compte de l'index de la page (Sinon on se retrouverait chaque fois en 1ere page !)
end;

procedure TForm3.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  if abs(Layout1.Position.X) > La*IndexPage + (La/3) then  //Si on deplace � droite le Layout de + de la moiti� de l'�cran,on change de page
  begin
    inc(IndexPage);                //Pour �a on augmente l'index
    if IndexPage>IndexMaxPage then IndexPage:=IndexMaxPage; //On v�rirfie si on ne d�passe pas l'index Maximum
  end else
  if abs(Layout1.Position.X) < La*IndexPage - (La/3) then  //Sinon si on d�place � gauche le Layout de plus de la moitie de l'�cran
  begin
    dec(IndexPage);                      //on diminue l'index
    if IndexPage<0 then IndexPage:=0;    //on v�rifie qu'il n'est pas inf�rieur � 0
  end;
  FirstTime:=False;                               // Comme on a lever le doigt de l'�cran on remet FirstTime � false
  FloatAnimation1.StartValue:=Layout1.Position.X; //On d�marre l'animation de la valeur de l� ou est le doigt
  FloatAnimation1.StopValue:=-IndexPage*(La);     //On termine l'animation � la position X de l'�cran correspond � IndexPage
  PosX:=0;                                        // Pareil pour la position du 1er touch�
  FloatAnimation1.Enabled:=True;                  // On lance l'animation qui permet de mettre le Layout choisi � sa place
end;

procedure TForm3.FloatAnimation1Finish(Sender: TObject);
begin
  FloatAnimation1.Enabled:=False;
  PosX:=0;    //remise � 0 du premier touch�
end;

end.
