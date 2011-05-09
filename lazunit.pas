{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

Unit lazunit; 

Interface

uses
    BFormLUnitMain, BFPCUnitRunnerUnit, BFormPreferencesUnit, BTemplatesUnit, 
  LazUnitIntf, LazarusPackageIntf;

Implementation

Procedure Register; 
Begin
  RegisterUnit('LazUnitIntf', @LazUnitIntf.Register); 
End; 

Initialization
  RegisterPackage('lazunit', @Register); 
End.
