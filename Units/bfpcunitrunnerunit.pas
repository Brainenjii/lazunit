Unit BFPCUnitRunnerUnit;

{$mode objfpc}{$H+}

Interface

Uses
  Classes, SysUtils, IDECommands, LCLType, LCLProc, FileUtil, ProjectIntf,
    process, BTemplatesUnit, IniFiles, Forms;

Type

{ BTestProjectClass }

BTestProjectClass = Class
  Private
    bLog: TStringList;
    bIni: TIniFile;
    bProject: TLazProject;
    bTestCases: TStringList;
    bDir: String;
    bMainFileName: String;
    bMainProjectPath: String;
    Procedure CreateMainFiles;
    Function GetTestBinary: String;
    Function ProcessOtherUnitFiles(Const aOtherUnitFiles: String): String;
    Function GetTestIniFile: String;
    Function GetTestCases: String;
    Function GetTestFile: String;
    Function GetTestPath: String;
    Function GetTestInfoPath: String;
    Function GetTestProjectPath: String;
  Public
    Property Project: TLazProject Read bProject;
    Property MainFileName: String Read bMainFileName;
    Property MainProjectPath: String Read bMainProjectPath;
    // path to binary test file
    Property TestFile: String Read GetTestFile;
    // path to .lpr file
    Property TestProjectPath: String Read GetTestProjectPath;
    // path to .lpi file
    Property TestInfoName: String read GetTestInfoPath;
    // path to directory with tests
    Property TestPath: String Read GetTestPath;
    Property TestCases: String Read GetTestCases;
    Property TestIniFile: String Read GetTestIniFile;
    Property TestBinary: String Read GetTestBinary;
    Procedure DebugLine(Const aLine: String);
    Procedure Load(Const aProject: TLazProject);
    Function AddTestCase(Const aFileName: String; Out aEcho: String): Boolean;
    Function RunAllTests(Out aTestResult: TStringList): Boolean;
    Constructor Build;
    Destructor Burn;
End;

Var
  TestProject: BTestProjectClass = nil;

Implementation

{ BTestProjectClass }

Procedure BTestProjectClass.Load(Const aProject: TLazProject);
Begin
  If (bProject = nil) Or Not(bProject = aProject) Then
    Begin
      bProject := aProject;
      bTestCases.Clear;
      If (bProject = nil) Or (bProject.MainFile = nil) Then Exit;
      bMainFileName := Project.MainFile.Filename;
      bMainProjectPath := ExtractFilePath(MainFileName);
    End;
  CreateMainFiles;
End;

Function BTestProjectClass.AddTestCase(Const aFileName: String;
  Out aEcho: String): Boolean;
Var
  aUnit: String;
Begin
  Result := FALSE;
  aEcho := Format('%s is part of tests', [aUnit]);
  aUnit := ExtractFileNameOnly(aFileName);
  If bTestCases.IndexOf(aUnit) = -1 Then
    Begin
      bTestCases.Add(aUnit);
      bIni.WriteString('TestCases', aUnit, 'true');
      aEcho := Format('AddTestCase: %s', [aUnit]);
      Result := TRUE;
    End;
End;

Procedure BTestProjectClass.CreateMainFiles;
Var
  i: Integer;
  aStringList: TStringList;
Begin
  If Not(DirectoryExistsUTF8(TestPath)) Then
    CreateDirUTF8(TestPath);

  aStringList := TStringList.Create;
  aStringList.Text := Format(TEMPLATE_LPI,
    [ExtractFileNameOnly(MainFileName),
    TestBinary,
    ProcessOtherUnitFiles(Project.LazCompilerOptions.OtherUnitFiles),
    LineEnding + Project.LazCompilerOptions.CustomOptions]);
  aStringList.SaveToFile(TestInfoName);

  aStringList.Text := Format(TEMPLATE_LPR,
    [ExtractFileNameOnly(MainFileName), TestCases]);
  aStringList.SaveToFile(TestProjectPath);
  aStringList.Free;

  If Assigned(bIni) Then bIni.Free;
  bIni := TIniFile.Create(TestIniFile);
  bIni.ReadSection('TestCases', bTestCases);
End;

Function BTestProjectClass.GetTestBinary: String;
Begin
  {$IFDEF windows}
  Result := Format('%stest.exe',
  {$ELSE}
  Result := Format('%stest',
  {$ENDIF}
    [ExtractFileNameOnly(bProject.LazCompilerOptions.TargetFilename)]);
end;

Function BTestProjectClass.ProcessOtherUnitFiles(Const aOtherUnitFiles: String): String;
Var
  i: Integer;
  aPathes, aPath: String;
Begin
  aPathes := aOtherUnitFiles;
  While Not(aPathes = '') Do
    Begin
      If Pos(';', aPathes) > 0 Then
        Begin
          aPath := Copy(aPathes, 1, Pos(';',  aPathes) - 1);
          Delete(aPathes, 1, Pos(';', aPathes));
        End
      Else
        Begin
          aPath := aPathes;
          aPathes := '';
        End;

      If FilenameIsAbsolute(aPath) Or (UTF8Pos('$', aPath) = 1) Then
        Result := Result + aPath + ';'
      Else
        Result := Format('%s..%s%s;', [Result, PathDelim, aPath]);
    End;
End;

Function BTestProjectClass.GetTestIniFile: String;
Begin
  Result := Format('%stests.ini', [TestPath]);
end;

Procedure BTestProjectClass.DebugLine(Const aLine: String);
Begin
  bLog.Add(aLine);
  bLog.SaveToFile('/home/Brainenjii/.bdata/log.txt');
End;

Function BTestProjectClass.GetTestCases: String;
Var
  i: Integer;
  aTestCases: TStringList;
Begin
  Result := '';
  If Not(Assigned(bIni)) Then Exit;
  aTestCases := TStringList.Create;
  bIni.ReadSection('TestCases', aTestCases);
  For i := 0 To aTestCases.Count - 1 Do
    Result := Result + bTestCases[i] + #44;
  aTestCases.Free;
end;

Function BTestProjectClass.GetTestFile: String;
Begin
  Result := ExtractFileNameWithoutExt(TestProjectPath);
end;

Function BTestProjectClass.GetTestProjectPath: String;
Begin
  Result:=Format('%s%s',[TestPath,
    Format('%stest.lpr',[ExtractFileNameOnly(MainFileName)])]);
end;

Function BTestProjectClass.GetTestInfoPath: String;
Begin
  Result:=Format('%s%s',[TestPath,
    Format('%stest.lpi',[ExtractFileNameOnly(MainFileName)])]);
end;

Function BTestProjectClass.GetTestPath: String;
Begin
  Result := Format('%sTests%s', [MainProjectPath, PathDelim]);
end;

Function BTestProjectClass.RunAllTests(Out aTestResult: TStringList): Boolean;
Var
  i: Integer;
  FailAtCompile: Boolean;
  aLazBuilder, aTestExecutor: TProcess;
Begin
  Result := FALSE;
  aLazBuilder := TProcess.Create(nil);
  aLazBuilder.CommandLine := Format('%s%slazbuild %s', [bDir, PathDelim,
    TestProjectPath]);
  aLazBuilder.Options := aLazBuilder.Options + [poWaitOnExit, poUsePipes];
  aLazBuilder.Execute;
  aTestResult.LoadFromStream(aLazBuilder.Output);
  //TODO: Moar Parse Build Buffer
  FailAtCompile := FALSE;
  For i := 0 to aTestResult.Count - 1 Do
    If Pos('Fatal', aTestResult[i]) > 0 Then
        FailAtCompile := TRUE;
  aLazBuilder.Free;
  If FailAtCompile Then Exit;

  aTestExecutor := TProcess.Create(nil);
  aTestExecutor.CommandLine := Format('%s%s -a --format=plain',
    [TestPath, TestBinary]);
  aTestExecutor.Options := aTestExecutor.Options + [poWaitOnExit, poUsePipes];
  aTestExecutor.Execute;

  aTestResult.LoadFromStream(aTestExecutor.Output);
  //TODO: Parse Test Buffer
  If ((Pos('Number of errors:    0', aTestResult.Text) > 0) And
    (Pos('Number of failures:  0', aTestResult.Text) > 0)) Then
    Result := TRUE;
  aTestExecutor.Free;
End;

Constructor BTestProjectClass.Build;
Begin
  bTestCases := TStringList.Create;
  bLog := TStringList.Create;
  bDir := GetCurrentDirUTF8;
End;

Destructor BTestProjectClass.Burn;
Begin

End;

End.

