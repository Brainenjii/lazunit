Unit BFormLUnitMain;

{$mode objfpc}{$H+}

Interface

Uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  ExtCtrls, Buttons, StdCtrls, Menus, ActnList, LazUnitIntf;

Type

  { TLUnitMain }

  TLUnitMain = Class(TForm)
    ActionList1: TActionList;
    ImageTests: TImage;
    MemoTests: TMemo;
    MenuItem1: TMenuItem;
    PanelToolBar: TPanel;
    ButtonActions: TSpeedButton;
    PopupMenuActions: TPopupMenu;
    Procedure SpeedButton1Click(Sender: TObject);
  Private
    { private declarations }
  Public
    { public declarations }
    Procedure ColorResultLine(Const aColor: Integer);
  End; 

Var
  LUnitMain: TLUnitMain = nil;

Implementation

{ TLUnitMain }

Procedure TLUnitMain.SpeedButton1Click(Sender: TObject);
Begin
  RunFPCUnitTests(Sender);
end;

Procedure TLUnitMain.ColorResultLine(Const aColor: Integer);
Begin
  With ImageTests.Canvas Do
    Begin
      Brush.Color := clBtnFace;
      FillRect(ImageTests.Canvas.ClipRect);
      Brush.Color := aColor;
      RoundRect(ImageTests.Canvas.ClipRect, 20, 20);
    End;
End;

{$R *.lfm}

End.

