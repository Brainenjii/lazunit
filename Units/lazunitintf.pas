Unit LazUnitIntf;

{$mode objfpc}{$H+}

Interface

Uses
  Classes, SysUtils, Forms, Graphics, LCLType, IDECommands, LazIDEIntf,
    ProjectIntf, MenuIntf, IDEMsgIntf, SrcEditorIntf, IDEWindowIntf;

Procedure RunFPCUnitTests(Sender: TObject);

Procedure Register;

Implementation

Uses
  BFPCUnitRunnerUnit, BFormLUnitMain, BFormPreferencesUnit;

Procedure ActualChecking;
Var
  aProject: TLazProject;
Begin
  aProject := LazarusIDE.ActiveProject;
  If aProject = nil Then Exit;
  If Not(Assigned(TestProject)) Then TestProject := BTestProjectClass.Build;
  TestProject.Load(aProject);
End;

Procedure ShowFPCUnitWindow(Sender: TObject);
Begin
  If Not(Assigned(LUnitMain)) Then LUnitMain := TLUnitMain.Create(LazarusIDE);
  IDEWindowCreators.ShowForm(LUnitMain,TRUE);
End;

Procedure CreateFPCUnitWindow(Sender: TObject; aFormName: string;
  Var aForm: TCustomForm; DoDisableAutoSizing: boolean);
Begin
  //If CompareText(aFormName, LUnitMain.Name) <> 0 Then Exit;
  // create the form if not already done and disable autosizing
  IDEWindowCreators.CreateForm(LUnitMain, TLUnitMain, DoDisableAutoSizing,
    Application);
  aForm := LUnitMain;
End;

Procedure AddCurrentFileToTests(Sender: TObject);
Var
  aEcho: String;
  aEditor: TSourceEditorInterface;
Begin
  ActualChecking;
  aEditor := SourceEditorManagerIntf.ActiveEditor;
  If aEditor = nil Then Exit;
  TestProject.AddTestCase(aEditor.FileName, aEcho);
  IDEMessagesWindow.BeginBlock;
  IDEMessagesWindow.AddMsg(aEcho, GetCurrentDir, 0);
  IDEMessagesWindow.EndBlock;
End;

Procedure RunFPCUnitTests(Sender: TObject);
Var
  aStringList: TStringList;
Begin
  ActualChecking;
  aStringList := TStringList.Create;
  If Not(Assigned(LUnitMain)) Then Exit;
  If TestProject.RunAllTests(aStringList) Then
    LUnitMain.ColorResultLine(clGreen)
  Else
    LUnitMain.ColorResultLine(clRed);
  LUnitMain.MemoTests.Text := aStringList.Text;
  aStringList.Free;
End;

Procedure Register;
var
  aKey: TIDEShortCut;
  aCategory: TIDECommandCategory;
  aCmdRunLazUnit, aCmdAddCurrentFile: TIDECommand;
  aLazUnitRun, aLazUnitAdd, aLazUnitShow: TIDECommand;
  aLazUnitMain, aLazUnitSubMenu: TIDEMenuSection;
begin
  // register IDE shortcut and menu items
  aKey := IDEShortCut(VK_UNKNOWN,[], VK_UNKNOWN, []);
  aCategory := IDECommandList.CreateCategory(nil, 'LazUnit', 'LazUnit',
    IDECmdScopeSrcEditOnly);
  aLazUnitMain := RegisterIDEMenuSection(mnuTools, 'LazUnit');
  aLazUnitSubMenu := RegisterIDESubMenu(aLazUnitMain, 'LazUnit', 'LazUnit', nil,
    nil);
  // create IDE commands
  aCmdRunLazUnit := RegisterIDECommand(aCategory, 'LazUnitRun',
    'Run LazUnit tests', aKey, nil, @RunFPCUnitTests);
  aCmdAddCurrentFile := RegisterIDECommand(aCategory, 'LazUnitAdd',
    'Add editor file to Tests', aKey, nil, @AddCurrentFileToTests);
  // create IDE Menu commands
  RegisterIDEMenuCommand(aLazUnitSubMenu, 'LazUnitRun',
    'Run LazUnit tests', nil, nil, aCmdRunLazUnit);
  RegisterIDEMenuCommand(aLazUnitSubMenu, 'LazUnitAdd',
    'Add editor file to Tests', nil, nil, aCmdAddCurrentFile);
  // create forms
  IDEWindowCreators.Add('LUnitMain', @CreateFPCUnitWindow, nil,
    '100','50%', '+300', '+20%');
  RegisterIDEMenuCommand(aLazUnitSubMenu, 'ShowFPCUnit','Show FPCUnit Window',
    nil,@ShowFPCUnitWindow);
End;

End.

