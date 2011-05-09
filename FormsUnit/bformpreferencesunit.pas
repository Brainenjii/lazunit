Unit BFormPreferencesUnit;

{$mode objfpc}{$H+}

Interface

Uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

Type

  { TLUnitPrefernces }

  TLUnitPrefernces = Class(TForm)
    LabelProjectFile: TLabel;
  Private
    { private declarations }
  Public
    { public declarations }
  End; 

Var
  LUnitPrefernces: TLUnitPrefernces;

Procedure Register;

Implementation

{$R *.lfm}

Procedure Register;
Begin

end;


End.

