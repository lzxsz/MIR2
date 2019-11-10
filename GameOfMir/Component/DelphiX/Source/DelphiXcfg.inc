{$B-,J+,Q-,R-,T-,X+}

{$IFDEF VER100}
  // Delphi 3
  {$DEFINE DelphiX_Delphi3}
  {$Define D3UP}
{$ENDIF}

{$IFDEF VER120}
  // Delphi 4
  {$DEFINE DelphiX_Delphi4}
  {$Define D3UP}
  {$Define D4UP}
{$ENDIF}

{$IFDEF VER130}
  // Delphi 5
  {$DEFINE DelphiX_Delphi5}
  {$Define D3UP}
  {$Define D4UP}
  {$Define D5UP}
{$ENDIF}

{$IFDEF VER140}
  // Delphi 6
  {$DEFINE DelphiX_Delphi6}
  {$Define D3UP}
  {$Define D4UP}
  {$Define D5UP}
  {$Define D6UP}
{$ENDIF}

{$IFDEF VER150}
  // Delphi 7
  {$DEFINE DelphiX_Delphi6}
  {$DEFINE DelphiX_Delphi7}
  {$Define D3UP}
  {$Define D4UP}
  {$Define D5UP}
  {$Define D6UP}
  {$Define D7UP}
{$ENDIF}

{$IFDEF VER170}
  // Delphi 9 - 2005
  {$DEFINE DelphiX_Delphi6}
  {$DEFINE DelphiX_Delphi7}
  {$DEFINE DelphiX_Delphi9}
  {$Define D3UP}
  {$Define D4UP}
  {$Define D5UP}
  {$Define D6UP}
  {$Define D7UP}
  {$Define D9UP}
{$ENDIF}

{$IFDEF VER180}
  // Delphi 10 - 2006
  {$DEFINE DelphiX_Delphi6}
  {$DEFINE DelphiX_Delphi7}
  {$DEFINE DelphiX_Delphi9}
  {$DEFINE DelphiX_Delphi10}
  {$Define D3UP}
  {$Define D4UP}
  {$Define D5UP}
  {$Define D6UP}
  {$Define D7UP}
  {$Define D9UP}
  {$Define D10UP}
{$ENDIF}

{$IFDEF DelphiX_Delphi3}
  {$DEFINE DelphiX_Spt3}
{$ENDIF}

{$IFDEF DelphiX_Delphi4}
  {$DEFINE DelphiX_Spt3}
  {$DEFINE DelphiX_Spt4}
{$ENDIF}

{$IFDEF DelphiX_Delphi5}
  {$DEFINE DelphiX_Spt3}
  {$DEFINE DelphiX_Spt4}
  {$DEFINE DelphiX_Spt5}
{$ENDIF}

{$IFDEF DelphiX_Delphi6}
  {$DEFINE DelphiX_Spt3}
  {$DEFINE DelphiX_Spt4}
  {$DEFINE DelphiX_Spt5}
  {$DEFINE DelphiX_Spt6}
{$ENDIF}

{$IFDEF DelphiX_Delphi7}
  {$DEFINE DelphiX_Spt3}
  {$DEFINE DelphiX_Spt4}
  {$DEFINE DelphiX_Spt5}
  {$DEFINE DelphiX_Spt6}
  {$DEFINE DelphiX_Spt7}
{$ENDIF}

{$IFDEF DelphiX_Delphi9}
  {$DEFINE DelphiX_Spt3}
  {$DEFINE DelphiX_Spt4}
  {$DEFINE DelphiX_Spt5}
  {$DEFINE DelphiX_Spt6}
  {$DEFINE DelphiX_Spt7}
  {$DEFINE DelphiX_Spt9}
{$ENDIF}

{$IFDEF DelphiX_Delphi10}
  {$DEFINE DelphiX_Spt3}
  {$DEFINE DelphiX_Spt4}
  {$DEFINE DelphiX_Spt5}
  {$DEFINE DelphiX_Spt6}
  {$DEFINE DelphiX_Spt7}
  {$DEFINE DelphiX_Spt9}
  {$DEFINE DelphiX_Spt10}
{$ENDIF}

{this class is deprecated; when you can it use, change dot bellow}
{.$Define DX3D_deprecated}

{$Define DrawHWAcc}