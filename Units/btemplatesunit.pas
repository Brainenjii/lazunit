Unit BTemplatesUnit;

{$mode objfpc}{$H+}

Interface

ResourceString
  TEMPLATE_LPI =
    '<?xml version="1.0"?> ' +
      '<CONFIG> ' +
        '<ProjectOptions> ' +
          '<Version Value="9"/> ' +
          '<General> ' +
            '<MainUnit Value="0"/> ' +
            '<ResourceType Value="res"/> ' +
            '<UseXPManifest Value="True"/> ' +
            '<Icon Value="0"/> ' +
            '<ActiveWindowIndexAtStart Value="0"/> ' +
          '</General> ' +
          '<i18n> ' +
            '<EnableI18N LFM="False"/> ' +
          '</i18n> ' +
          '<VersionInfo> ' +
            '<StringTable ProductVersion=""/> ' +
          '</VersionInfo> ' +
          '<BuildModes Count="1" Active="Default"> ' +
            '<Item1 Name="Default" Default="True"/> ' +
          '</BuildModes> ' +
          '<PublishOptions> ' +
            '<Version Value="2"/> ' +
            '<IncludeFileFilter Value="*.(pas|pp|inc|lfm|lpr|lrs|lpi|lpk|sh|xml)"/> ' +
            '<ExcludeFileFilter Value="*.(bak|ppu|o|so);*~;backup"/> ' +
          '</PublishOptions> ' +
          '<RunParams> ' +
            '<local> ' +
              '<FormatVersion Value="1"/> ' +
              '<LaunchingApplication PathPlusParams=""/> ' +
            '</local> ' +
          '</RunParams> ' +
          '<RequiredPackages Count="2"> ' +
            '<Item1> ' +
              '<PackageName Value="FPCUnitConsoleRunner"/> ' +
            '</Item1> ' +
            '<Item2> ' +
              '<PackageName Value="FCL"/> ' +
            '</Item2> ' +
          '</RequiredPackages> ' +
          '<Units Count="1"> ' +
            '<Unit0> ' +
              '<Filename Value="%stest.lpr"/> ' +
              '<IsPartOfProject Value="True"/> ' +
              '<UnitName Value="%0:s"/> ' +
              '<UsageCount Value="27"/> ' +
            '</Unit0> ' +
          '</Units> ' +
        '</ProjectOptions> ' +
        '<CompilerOptions> ' +
          '<Version Value="9"/> ' +
          '<Target> ' +
          '  <Filename Value="./%s"/> ' +
          '</Target> ' +
          '<SearchPaths> ' +
            '<IncludeFiles Value="$(ProjOutDir)"/> ' +
            '<UnitOutputDirectory Value="lib-tests/$(TargetCPU)-$(TargetOS)"/> ' +
            '<OtherUnitFiles Value="Mocks;TestCases;%s"/> ' +
          '</SearchPaths> ' +
          '<Other> ' +
            '<CompilerMessages> ' +
              '<UseMsgFile Value="True"/> ' +
            '</CompilerMessages> ' +
            '<CustomOptions Value="-dTestCase%s" /> ' +
            '<CompilerPath Value="$(CompPath)"/> ' +
          '</Other> ' +
        '</CompilerOptions> ' +
        '<Debugging> ' +
          '<Exceptions Count="3"> ' +
            '<Item1> ' +
              '<Name Value="EAbort"/> ' +
            '</Item1> ' +
            '<Item2> ' +
              '<Name Value="ECodetoolError"/> ' +
            '</Item2> ' +
            '<Item3> ' +
              '<Name Value="EFOpenError"/> ' +
            '</Item3> ' +
          '</Exceptions> ' +
        '</Debugging> ' +
      '</CONFIG> ';

  TEMPLATE_LPR =
    'program %stest; ' +
    ' ' +
    '{$mode objfpc}{$H+} ' +
    ' ' +
    'uses ' +
    '  %sClasses, consoletestrunner; ' +
    ' ' +
    'type ' +
    ' ' +
    '  { TLazTestRunner } ' +
    ' ' +
    '  TMyTestRunner = class(TTestRunner) ' +
    '  end; ' +
    ' ' +
    'var ' +
    '  Application: TMyTestRunner; ' +
    ' ' +
    '{$R *.res} ' +
    ' ' +
    'begin ' +
    '  Application := TMyTestRunner.Create(nil); ' +
    '  Application.Initialize; ' +
    '  Application.Run; ' +
    '  Application.Free; ' +
    'end.';



Implementation

End.

