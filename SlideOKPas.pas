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
    Button1: TButton;
    ScrollBar1: TScrollBar;
    FloatAnimation1: TFloatAnimation;
    GridLayout3: TGridLayout;
    Rectangle1: TRectangle;
    procedure ScrollBar1Change(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure FloatAnimation1Finish(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { D�clarations priv�es }
  public
    { D�clarations publiques }
  end;

var
  Form3: TForm3;                //d�termine si c'est la premiere fois qu'on active la proc�dure OnMove,
  FirstTime:boolean=true;       //c'est a dire si c'est la premiere fois qu'on touche l'�cran (1er touch� du OnMove)
  PosX,IndexPage,               //PosX=position du premier touch�, IndexPage=Index page en cours (commence � 0)
  IndexMaxPage:integer;         //IndexMaxPage=Nbre de page Max
  La,Ha : integer;              //Largeur et hauteur de l'�cran

implementation

{$R *.fmx}

procedure TForm3.FloatAnimation1Finish(Sender: TObject);
begin
  FloatAnimation1.Enabled:=False;
  FirstTime:=True;              //Lorsque l'animation est termin�e on remet FirstTime � true pour relever la nouvelle posistion du 1er touch�
  PosX:=0;                      //remise � 0 du premier touch�
end;

procedure TForm3.FormCreate(Sender: TObject);   // � la cr�ation de la page et aussi quand on la ReSize pour prendre en compte la rotation du t�l
begin                                           // C'est pourquoi le Form.OnResize=Form.OnCreate
   La:=Screen.Width;          // releve la largeur de l'�cran
   Ha:=Screen.Height;         // releve la hauteur de l'�cran

   IndexPage:=0;              // Valeur initial de IndexPage
   IndexMaxPage:=2;           // Valeur Max de IndexPage. On a nbre de page = IndexMaxPage+1, car indexPage commence � 0

   ScrollBar1.Max:=           //Le curseur de la ScrollBox = (le nbre de page - 1) soit IndexMaxPage + 20 qui est la largeur du curseur
   La*(IndexMaxPage)+20;      // de cette mani�re quand on est sur la derni�re page le curseur sera a son max sur la droite

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
end;

procedure TForm3.FormMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Single);
  var
  XInt:integer;         //Xint pour convertir en entier la position X qui est en single (float)
begin
  If FirstTime then     // Si on vient de poser le doigt alors
  begin
    PosX:=Round(X) ;    // on repe�re le X de ce premier touch�
    FirstTime:=false
  end;
  Xint:=Round(X);       // on convertit X (single) en valeur enti�re dans Xint
  ScrollBar1.Value:=round(PosX-X)+IndexPage*La;
  // La valeur du ScrollBar.Value = l'�cart entre le 1er touch� et la position ectuelle du doigt
  // auquel on rajoute l'index de la page x la largeur de l'�cran. Sinon on se retrouverait chaque
  // fois en 1ere page !
  // Le fait de changer la valeur de ScrollBar.Value entraine l'activation de la proc�dure
  // ScrollBar.Onchange  (cf plus bas)
end;

procedure TForm3.FormMouseUp(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Single);
begin
  if ScrollBar1.Value > La*IndexPage + (La/2) then  // Si on deplace � droite le Layout de plus de la moiti� de l'�cran, alors on change de page
  begin
    inc(IndexPage);                //Pour �a on augmente l'index
    if IndexPage>IndexMaxPage then IndexPage:=IndexMaxPage; //On v�rirfie si on ne d�passe pas l'index Maximum
  end else
  if ScrollBar1.Value < La*IndexPage - (La/2) then  //Sinon si on d�place � gauche le Layout de plus de la moitie de l'�cran
  begin
    dec(IndexPage);               //on diminue l'index
    if IndexPage<0 then IndexPage:=0;    //on v�rifie qu'il n'est pas inf�rieur � 0
  end;
  FloatAnimation1.StartValue:=ScrollBar1.Value;  //On d�marre l'animation de la valeur de l� ou est le doigt
  FloatAnimation1.StopValue:=IndexPage*(La);     //On termine l'animation � la position X de l'�cran correspond � IndexPage
  FirstTime:=True;                               // Comme on a lever le doigt de l'�cran on remet FirstTime � 0
  PosX:=0;                                       // Pareil pour la position du 1er touch�
  FloatAnimation1.Enabled:=True;                 // On lance l'animation qui permet de mettre le Layout choisi � sa place
end;

procedure TForm3.ScrollBar1Change(Sender: TObject);
begin
                                         //Positionne la Layout1 selon la valeur de ScrollBar1.value pour faire "glisser" l'�cran
  Layout1.Position.X:=-ScrollBar1.Value; // Pour que l'�cran glisse dans le sens du doigt, il faut inverser les signes de Layout1.Position.x et de
                                         //ScrollBar1.value
end;

end.
