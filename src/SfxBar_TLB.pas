unit SfxBar_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : 1.2
// File generated on 8/3/2006 7:22:40 PM from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Program Files\Common Files\Software FX Shared\SfxBar.dll (1)
// LIBID: {9F37C430-98F3-11D1-9C3B-00A0244D2920}
// LCID: 0
// Helpfile: 
// HelpString: Software FX Bar Library 1.0 (SfxBar)
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
// Parent TypeLibrary:
//   (0) v4.0 ChartfxLib, (C:\Program Files\Common Files\Software FX Shared\Cfx4032.ocx)
// Errors:
//   Hint: Member 'Object' of 'IToolbarItem' changed to 'Object_'
// ************************************************************************ //
// *************************************************************************//
// NOTE:                                                                      
// Items guarded by $IFDEF_LIVE_SERVER_AT_DESIGN_TIME are used by properties  
// which return objects that may need to be explicitly created via a function 
// call prior to any access via the property. These items have been disabled  
// in order to prevent accidental use from within the object inspector. You   
// may enable them by defining LIVE_SERVER_AT_DESIGN_TIME or by selectively   
// removing them from the $IFDEF blocks. However, such items must still be    
// programmatically created via a method of the appropriate CoClass before    
// they can be used.                                                          
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, OleServer, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  SfxBarMajorVersion = 1;
  SfxBarMinorVersion = 0;

  LIBID_SfxBar: TGUID = '{9F37C430-98F3-11D1-9C3B-00A0244D2920}';

  IID_IBarWndDisp: TGUID = '{9F37C448-98F3-11D1-9C3B-00A0244D2920}';
  CLASS_BarWndDef: TGUID = '{9F37C431-98F3-11D1-9C3B-00A0244D2920}';
  CLASS_BarFrameDef: TGUID = '{9F37C432-98F3-11D1-9C3B-00A0244D2920}';
  IID_IToolBar: TGUID = '{9F37C44D-98F3-11D1-9C3B-00A0244D2920}';
  CLASS_ToolBar: TGUID = '{9F37C433-98F3-11D1-9C3B-00A0244D2920}';
  IID_ICommandBar: TGUID = '{9F37C449-98F3-11D1-9C3B-00A0244D2920}';
  IID_ICommandItem: TGUID = '{9F37C44C-98F3-11D1-9C3B-00A0244D2920}';
  IID_IToolbarItem: TGUID = '{9F37C44F-98F3-11D1-9C3B-00A0244D2920}';
  CLASS_ToolCombo: TGUID = '{9F37C434-98F3-11D1-9C3B-00A0244D2920}';
  CLASS_CommandBar: TGUID = '{9F37C435-98F3-11D1-9C3B-00A0244D2920}';
  CLASS_SfxBarApi: TGUID = '{9F37C436-98F3-11D1-9C3B-00A0244D2920}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum __MIDL___MIDL_itf_sfxbar_0000_0001
type
  __MIDL___MIDL_itf_sfxbar_0000_0001 = TOleEnum;
const
  TGFP_TOP = $00000100;
  TGFP_LEFT = $00000201;
  TGFP_BOTTOM = $00000102;
  TGFP_RIGHT = $00000203;
  TGFP_FIXED = $00000404;
  TGFP_FLOAT = $00000405;
  TGFP_SWITCH = $00000806;

// Constants for enum __MIDL___MIDL_itf_sfxbar_0000_0002
type
  __MIDL___MIDL_itf_sfxbar_0000_0002 = TOleEnum;
const
  BBS_NONE = $00000000;
  BBS_LINE = $00000001;
  BBS_FLATLINE = $00000002;
  BBS_MONOLINE = $00000003;
  BBS_SUNKENOUTER = $00000004;
  BBS_SUNKENINNER = $00000005;
  BBS_RAISEDOUTER = $00000006;
  BBS_RAISEDINNER = $00000007;
  BBS_FLAT = $00000008;
  BBS_MONO = $00000009;
  BBS_RAISED = $0000000A;
  BBS_ETCHED = $0000000B;
  BBS_BUMP = $0000000C;
  BBS_SUNKEN = $0000000D;
  BBS_SPLITTER = $00000100;
  BBS_SOFT = $00000200;

// Constants for enum __MIDL___MIDL_itf_sfxbar_0000_0003
type
  __MIDL___MIDL_itf_sfxbar_0000_0003 = TOleEnum;
const
  BAS_NORESIZE = $00000000;
  BAS_WHENDOCKED = $00000001;
  BAS_WHENFLOAT = $00000002;
  BAS_ALWAYS = $00000003;

// Constants for enum __MIDL___MIDL_itf_sfxbar_0000_0005
type
  __MIDL___MIDL_itf_sfxbar_0000_0005 = TOleEnum;
const
  CBIS_TWOSTATE = $00000001;
  CBIS_GROUP = $00000002;
  CBIS_GROUPHEAD = $00000006;
  CBIS_NOIMAGEIFTEXT = $00000008;
  CBIS_SELECTOR = $00000010;
  CBIS_NOIMAGE = $00000020;
  CBIS_PREFERIMAGE = $00000040;
  CBIS_OWNERDRAW = $00000080;
  CBIS_EVENTHANDLER = $00000100;
  CBIS_SMARTLIST = $00000200;
  CBIS_CONTEXT = $00000400;
  CBIS_ACCEL = $00000800;
  CBIS_CONTEXTHELPMODE = $00001000;
  TBIS_REPEAT = $00010000;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IBarWndDisp = interface;
  IBarWndDispDisp = dispinterface;
  IToolBar = interface;
  IToolBarDisp = dispinterface;
  ICommandBar = interface;
  ICommandBarDisp = dispinterface;
  ICommandItem = interface;
  ICommandItemDisp = dispinterface;
  IToolbarItem = interface;
  IToolbarItemDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  BarWndDef = IBarWndDisp;
  BarFrameDef = IUnknown;
  ToolBar = IToolBar;
  ToolCombo = IUnknown;
  CommandBar = ICommandBar;
  SfxBarApi = IUnknown;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//

  BarWndDockedPos = __MIDL___MIDL_itf_sfxbar_0000_0001; 
  BarWndBorderStyle = __MIDL___MIDL_itf_sfxbar_0000_0002; 
  BarWndSizeable = __MIDL___MIDL_itf_sfxbar_0000_0003; 
  CommandItemStyle = __MIDL___MIDL_itf_sfxbar_0000_0005; 

// *********************************************************************//
// Interface: IBarWndDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {9F37C448-98F3-11D1-9C3B-00A0244D2920}
// *********************************************************************//
  IBarWndDisp = interface(IDispatch)
    ['{9F37C448-98F3-11D1-9C3B-00A0244D2920}']
    function Get_Left: Smallint; safecall;
    procedure Set_Left(pVal: Smallint); safecall;
    function Get_Top: Smallint; safecall;
    procedure Set_Top(pVal: Smallint); safecall;
    function Get_Width: Smallint; safecall;
    procedure Set_Width(pVal: Smallint); safecall;
    function Get_Height: Smallint; safecall;
    procedure Set_Height(pVal: Smallint); safecall;
    function Get_Docked: BarWndDockedPos; safecall;
    procedure Set_Docked(pVal: BarWndDockedPos); safecall;
    function Get_Style: Integer; safecall;
    procedure Set_Style(pVal: Integer); safecall;
    function Get_BkColor: OLE_COLOR; safecall;
    procedure Set_BkColor(pVal: OLE_COLOR); safecall;
    function Get_BorderStyle: BarWndBorderStyle; safecall;
    procedure Set_BorderStyle(pVal: BarWndBorderStyle); safecall;
    function Get_Moveable: WordBool; safecall;
    procedure Set_Moveable(pVal: WordBool); safecall;
    function Get_ShowWhenInactive: WordBool; safecall;
    procedure Set_ShowWhenInactive(pVal: WordBool); safecall;
    function Get_Sizeable: BarWndSizeable; safecall;
    procedure Set_Sizeable(pVal: BarWndSizeable); safecall;
    function Get_Visible: WordBool; safecall;
    procedure Set_Visible(pVal: WordBool); safecall;
    function Get_AutoSize: WordBool; safecall;
    procedure Set_AutoSize(pVal: WordBool); safecall;
    procedure SizeToFit; safecall;
    property Left: Smallint read Get_Left write Set_Left;
    property Top: Smallint read Get_Top write Set_Top;
    property Width: Smallint read Get_Width write Set_Width;
    property Height: Smallint read Get_Height write Set_Height;
    property Docked: BarWndDockedPos read Get_Docked write Set_Docked;
    property Style: Integer read Get_Style write Set_Style;
    property BkColor: OLE_COLOR read Get_BkColor write Set_BkColor;
    property BorderStyle: BarWndBorderStyle read Get_BorderStyle write Set_BorderStyle;
    property Moveable: WordBool read Get_Moveable write Set_Moveable;
    property ShowWhenInactive: WordBool read Get_ShowWhenInactive write Set_ShowWhenInactive;
    property Sizeable: BarWndSizeable read Get_Sizeable write Set_Sizeable;
    property Visible: WordBool read Get_Visible write Set_Visible;
    property AutoSize: WordBool read Get_AutoSize write Set_AutoSize;
  end;

// *********************************************************************//
// DispIntf:  IBarWndDispDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {9F37C448-98F3-11D1-9C3B-00A0244D2920}
// *********************************************************************//
  IBarWndDispDisp = dispinterface
    ['{9F37C448-98F3-11D1-9C3B-00A0244D2920}']
    property Left: Smallint dispid 1;
    property Top: Smallint dispid 2;
    property Width: Smallint dispid 3;
    property Height: Smallint dispid 4;
    property Docked: BarWndDockedPos dispid 5;
    property Style: Integer dispid 6;
    property BkColor: OLE_COLOR dispid 7;
    property BorderStyle: BarWndBorderStyle dispid 8;
    property Moveable: WordBool dispid 9;
    property ShowWhenInactive: WordBool dispid 10;
    property Sizeable: BarWndSizeable dispid 11;
    property Visible: WordBool dispid 12;
    property AutoSize: WordBool dispid 13;
    procedure SizeToFit; dispid 14;
  end;

// *********************************************************************//
// Interface: IToolBar
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9F37C44D-98F3-11D1-9C3B-00A0244D2920}
// *********************************************************************//
  IToolBar = interface(IBarWndDisp)
    ['{9F37C44D-98F3-11D1-9C3B-00A0244D2920}']
    procedure InitInfo(lInfo: Integer); safecall;
    function Get_itemCommandID(nIndex: Smallint): Smallint; safecall;
    procedure Set_itemCommandID(nIndex: Smallint; pVal: Smallint); safecall;
    function Get_itemHandle(nIndex: Smallint): SYSUINT; safecall;
    procedure Set_itemHandle(nIndex: Smallint; hHandle: SYSUINT); safecall;
    function Get_itemObject(nIndex: Smallint): IUnknown; safecall;
    procedure Set_itemObject(nIndex: Smallint; const pObject: IUnknown); safecall;
    function Get_itemVisible(nIndex: Smallint): WordBool; safecall;
    procedure Set_itemVisible(nIndex: Smallint; bVisible: WordBool); safecall;
    function Get_ShowItemsMask: Integer; safecall;
    procedure Set_ShowItemsMask(pVal: Integer); safecall;
    function Get_Tooltips: WordBool; safecall;
    procedure Set_Tooltips(pVal: WordBool); safecall;
    function Get_RecalcMode: WordBool; safecall;
    procedure Set_RecalcMode(bRecalc: WordBool); safecall;
    function Get_Commands: ICommandBar; safecall;
    procedure Set_Commands(const pVal: ICommandBar); safecall;
    function FindID(nID: Smallint): Smallint; safecall;
    function Count: Smallint; safecall;
    procedure SetBorders(nLeft: Smallint; nTop: Smallint; nRight: Smallint; nBottom: Smallint); safecall;
    function Get_itemCommand(nIndex: Smallint): Smallint; safecall;
    procedure AddItems(nItems: Smallint; nIndex: Smallint); safecall;
    procedure RemoveItems(nItems: Smallint; nIndex: Smallint); safecall;
    function Get_Font: IFontDisp; safecall;
    procedure _Set_Font(const val: IFontDisp); safecall;
    function Get_Item(nIndex: Smallint): IToolbarItem; safecall;
    property itemCommandID[nIndex: Smallint]: Smallint read Get_itemCommandID write Set_itemCommandID;
    property itemHandle[nIndex: Smallint]: SYSUINT read Get_itemHandle write Set_itemHandle;
    property itemObject[nIndex: Smallint]: IUnknown read Get_itemObject write Set_itemObject;
    property itemVisible[nIndex: Smallint]: WordBool read Get_itemVisible write Set_itemVisible;
    property ShowItemsMask: Integer read Get_ShowItemsMask write Set_ShowItemsMask;
    property Tooltips: WordBool read Get_Tooltips write Set_Tooltips;
    property RecalcMode: WordBool read Get_RecalcMode write Set_RecalcMode;
    property Commands: ICommandBar read Get_Commands write Set_Commands;
    property itemCommand[nIndex: Smallint]: Smallint read Get_itemCommand;
    property Font: IFontDisp read Get_Font write _Set_Font;
    property Item[nIndex: Smallint]: IToolbarItem read Get_Item; default;
  end;

// *********************************************************************//
// DispIntf:  IToolBarDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9F37C44D-98F3-11D1-9C3B-00A0244D2920}
// *********************************************************************//
  IToolBarDisp = dispinterface
    ['{9F37C44D-98F3-11D1-9C3B-00A0244D2920}']
    procedure InitInfo(lInfo: Integer); dispid 30;
    property itemCommandID[nIndex: Smallint]: Smallint dispid 31;
    property itemHandle[nIndex: Smallint]: SYSUINT dispid 32;
    property itemObject[nIndex: Smallint]: IUnknown dispid 33;
    property itemVisible[nIndex: Smallint]: WordBool dispid 34;
    property ShowItemsMask: Integer dispid 35;
    property Tooltips: WordBool dispid 36;
    property RecalcMode: WordBool dispid 37;
    property Commands: ICommandBar dispid 38;
    function FindID(nID: Smallint): Smallint; dispid 39;
    function Count: Smallint; dispid 40;
    procedure SetBorders(nLeft: Smallint; nTop: Smallint; nRight: Smallint; nBottom: Smallint); dispid 41;
    property itemCommand[nIndex: Smallint]: Smallint readonly dispid 42;
    procedure AddItems(nItems: Smallint; nIndex: Smallint); dispid 43;
    procedure RemoveItems(nItems: Smallint; nIndex: Smallint); dispid 44;
    property Font: IFontDisp dispid 45;
    property Item[nIndex: Smallint]: IToolbarItem readonly dispid 0; default;
    property Left: Smallint dispid 1;
    property Top: Smallint dispid 2;
    property Width: Smallint dispid 3;
    property Height: Smallint dispid 4;
    property Docked: BarWndDockedPos dispid 5;
    property Style: Integer dispid 6;
    property BkColor: OLE_COLOR dispid 7;
    property BorderStyle: BarWndBorderStyle dispid 8;
    property Moveable: WordBool dispid 9;
    property ShowWhenInactive: WordBool dispid 10;
    property Sizeable: BarWndSizeable dispid 11;
    property Visible: WordBool dispid 12;
    property AutoSize: WordBool dispid 13;
    procedure SizeToFit; dispid 14;
  end;

// *********************************************************************//
// Interface: ICommandBar
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9F37C449-98F3-11D1-9C3B-00A0244D2920}
// *********************************************************************//
  ICommandBar = interface(IDispatch)
    ['{9F37C449-98F3-11D1-9C3B-00A0244D2920}']
    function Get_itemStyle(nIndex: Smallint): CommandItemStyle; safecall;
    procedure Set_itemStyle(nIndex: Smallint; pVal: CommandItemStyle); safecall;
    function Get_itemPicture(nIndex: Smallint): Smallint; safecall;
    procedure Set_itemPicture(nIndex: Smallint; pVal: Smallint); safecall;
    function Get_itemText(nIndex: Smallint): WideString; safecall;
    procedure Set_itemText(nIndex: Smallint; const pVal: WideString); safecall;
    function Get_itemTextID(nIndex: Smallint): Smallint; safecall;
    procedure Set_itemTextID(nIndex: Smallint; pVal: Smallint); safecall;
    function Get_itemChecked(nIndex: Smallint): WordBool; safecall;
    procedure Set_itemChecked(nIndex: Smallint; pVal: WordBool); safecall;
    function Get_itemEnabled(nIndex: Smallint): WordBool; safecall;
    procedure Set_itemEnabled(nIndex: Smallint; pVal: WordBool); safecall;
    function Get_itemEventHandler(nIndex: Smallint): IUnknown; safecall;
    procedure Set_itemEventHandler(nIndex: Smallint; const pVal: IUnknown); safecall;
    function Get_itemID(nIndex: Smallint): Smallint; safecall;
    procedure Set_itemID(nIndex: Smallint; pVal: Smallint); safecall;
    function Get_itemState(nIndex: Smallint): Smallint; safecall;
    procedure Set_itemState(nIndex: Smallint; pVal: Smallint); safecall;
    procedure Set_ResourceHandle(Param1: SYSUINT); safecall;
    procedure Set_hBitmap(Param1: SYSUINT); safecall;
    procedure InitInfo(lInfo: Integer); safecall;
    function AddCommand(nID: Smallint): ICommandItem; safecall;
    function AddPicture(const pPict: IPictureDisp): Smallint; safecall;
    procedure ChangePicture(nIndex: Smallint; const pPict: IPictureDisp); safecall;
    function Count: Smallint; safecall;
    function Get_Item(nIndex: Smallint): ICommandItem; safecall;
    property itemStyle[nIndex: Smallint]: CommandItemStyle read Get_itemStyle write Set_itemStyle;
    property itemPicture[nIndex: Smallint]: Smallint read Get_itemPicture write Set_itemPicture;
    property itemText[nIndex: Smallint]: WideString read Get_itemText write Set_itemText;
    property itemTextID[nIndex: Smallint]: Smallint read Get_itemTextID write Set_itemTextID;
    property itemChecked[nIndex: Smallint]: WordBool read Get_itemChecked write Set_itemChecked;
    property itemEnabled[nIndex: Smallint]: WordBool read Get_itemEnabled write Set_itemEnabled;
    property itemEventHandler[nIndex: Smallint]: IUnknown read Get_itemEventHandler write Set_itemEventHandler;
    property itemID[nIndex: Smallint]: Smallint read Get_itemID write Set_itemID;
    property itemState[nIndex: Smallint]: Smallint read Get_itemState write Set_itemState;
    property ResourceHandle: SYSUINT write Set_ResourceHandle;
    property hBitmap: SYSUINT write Set_hBitmap;
    property Item[nIndex: Smallint]: ICommandItem read Get_Item; default;
  end;

// *********************************************************************//
// DispIntf:  ICommandBarDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9F37C449-98F3-11D1-9C3B-00A0244D2920}
// *********************************************************************//
  ICommandBarDisp = dispinterface
    ['{9F37C449-98F3-11D1-9C3B-00A0244D2920}']
    property itemStyle[nIndex: Smallint]: CommandItemStyle dispid 1;
    property itemPicture[nIndex: Smallint]: Smallint dispid 2;
    property itemText[nIndex: Smallint]: WideString dispid 3;
    property itemTextID[nIndex: Smallint]: Smallint dispid 4;
    property itemChecked[nIndex: Smallint]: WordBool dispid 5;
    property itemEnabled[nIndex: Smallint]: WordBool dispid 6;
    property itemEventHandler[nIndex: Smallint]: IUnknown dispid 7;
    property itemID[nIndex: Smallint]: Smallint dispid 8;
    property itemState[nIndex: Smallint]: Smallint dispid 9;
    property ResourceHandle: SYSUINT writeonly dispid 10;
    property hBitmap: SYSUINT writeonly dispid 11;
    procedure InitInfo(lInfo: Integer); dispid 12;
    function AddCommand(nID: Smallint): ICommandItem; dispid 13;
    function AddPicture(const pPict: IPictureDisp): Smallint; dispid 14;
    procedure ChangePicture(nIndex: Smallint; const pPict: IPictureDisp); dispid 15;
    function Count: Smallint; dispid 16;
    property Item[nIndex: Smallint]: ICommandItem readonly dispid 0; default;
  end;

// *********************************************************************//
// Interface: ICommandItem
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9F37C44C-98F3-11D1-9C3B-00A0244D2920}
// *********************************************************************//
  ICommandItem = interface(IDispatch)
    ['{9F37C44C-98F3-11D1-9C3B-00A0244D2920}']
    function Get_Enabled: WordBool; safecall;
    procedure Set_Enabled(pVal: WordBool); safecall;
    function Get_ID: Smallint; safecall;
    procedure Set_ID(pVal: Smallint); safecall;
    function Get_Picture: Smallint; safecall;
    procedure Set_Picture(pVal: Smallint); safecall;
    function Get_Checked: WordBool; safecall;
    procedure Set_Checked(pVal: WordBool); safecall;
    function Get_Style: CommandItemStyle; safecall;
    procedure Set_Style(pVal: CommandItemStyle); safecall;
    function Get_Text: WideString; safecall;
    procedure Set_Text(const pVal: WideString); safecall;
    function Get_TextID: Smallint; safecall;
    procedure Set_TextID(pVal: Smallint); safecall;
    function Get_EventHandler: IUnknown; safecall;
    procedure Set_EventHandler(const pVal: IUnknown); safecall;
    function Count: Smallint; safecall;
    function Get_SubCommandID(nIndex: Smallint): Smallint; safecall;
    procedure Set_SubCommandID(nIndex: Smallint; pVal: Smallint); safecall;
    procedure RemoveSubCommand(nIndex: Smallint); safecall;
    procedure RemoveAllSubCommands; safecall;
    function FindSubCommandID(nID: Smallint): Smallint; safecall;
    procedure InsertSubCommands(nItems: Smallint; nIndex: Smallint); safecall;
    property Enabled: WordBool read Get_Enabled write Set_Enabled;
    property ID: Smallint read Get_ID write Set_ID;
    property Picture: Smallint read Get_Picture write Set_Picture;
    property Checked: WordBool read Get_Checked write Set_Checked;
    property Style: CommandItemStyle read Get_Style write Set_Style;
    property Text: WideString read Get_Text write Set_Text;
    property TextID: Smallint read Get_TextID write Set_TextID;
    property EventHandler: IUnknown read Get_EventHandler write Set_EventHandler;
    property SubCommandID[nIndex: Smallint]: Smallint read Get_SubCommandID write Set_SubCommandID;
  end;

// *********************************************************************//
// DispIntf:  ICommandItemDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9F37C44C-98F3-11D1-9C3B-00A0244D2920}
// *********************************************************************//
  ICommandItemDisp = dispinterface
    ['{9F37C44C-98F3-11D1-9C3B-00A0244D2920}']
    property Enabled: WordBool dispid 1;
    property ID: Smallint dispid 2;
    property Picture: Smallint dispid 3;
    property Checked: WordBool dispid 4;
    property Style: CommandItemStyle dispid 5;
    property Text: WideString dispid 6;
    property TextID: Smallint dispid 7;
    property EventHandler: IUnknown dispid 8;
    function Count: Smallint; dispid 9;
    property SubCommandID[nIndex: Smallint]: Smallint dispid 10;
    procedure RemoveSubCommand(nIndex: Smallint); dispid 11;
    procedure RemoveAllSubCommands; dispid 12;
    function FindSubCommandID(nID: Smallint): Smallint; dispid 13;
    procedure InsertSubCommands(nItems: Smallint; nIndex: Smallint); dispid 14;
  end;

// *********************************************************************//
// Interface: IToolbarItem
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9F37C44F-98F3-11D1-9C3B-00A0244D2920}
// *********************************************************************//
  IToolbarItem = interface(IDispatch)
    ['{9F37C44F-98F3-11D1-9C3B-00A0244D2920}']
    function Get_CommandID: Smallint; safecall;
    procedure Set_CommandID(pVal: Smallint); safecall;
    function Get_Handle: SYSUINT; safecall;
    procedure Set_Handle(pVal: SYSUINT); safecall;
    function Get_Object_: IUnknown; safecall;
    procedure Set_Object_(const pVal: IUnknown); safecall;
    function Get_Visible: WordBool; safecall;
    procedure Set_Visible(pVal: WordBool); safecall;
    property CommandID: Smallint read Get_CommandID write Set_CommandID;
    property Handle: SYSUINT read Get_Handle write Set_Handle;
    property Object_: IUnknown read Get_Object_ write Set_Object_;
    property Visible: WordBool read Get_Visible write Set_Visible;
  end;

// *********************************************************************//
// DispIntf:  IToolbarItemDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9F37C44F-98F3-11D1-9C3B-00A0244D2920}
// *********************************************************************//
  IToolbarItemDisp = dispinterface
    ['{9F37C44F-98F3-11D1-9C3B-00A0244D2920}']
    property CommandID: Smallint dispid 1;
    property Handle: SYSUINT dispid 2;
    property Object_: IUnknown dispid 3;
    property Visible: WordBool dispid 4;
  end;

// *********************************************************************//
// The Class CoBarWndDef provides a Create and CreateRemote method to          
// create instances of the default interface IBarWndDisp exposed by              
// the CoClass BarWndDef. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoBarWndDef = class
    class function Create: IBarWndDisp;
    class function CreateRemote(const MachineName: string): IBarWndDisp;
  end;

// *********************************************************************//
// The Class CoBarFrameDef provides a Create and CreateRemote method to          
// create instances of the default interface IUnknown exposed by              
// the CoClass BarFrameDef. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoBarFrameDef = class
    class function Create: IUnknown;
    class function CreateRemote(const MachineName: string): IUnknown;
  end;

// *********************************************************************//
// The Class CoToolBar provides a Create and CreateRemote method to          
// create instances of the default interface IToolBar exposed by              
// the CoClass ToolBar. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoToolBar = class
    class function Create: IToolBar;
    class function CreateRemote(const MachineName: string): IToolBar;
  end;

// *********************************************************************//
// The Class CoToolCombo provides a Create and CreateRemote method to          
// create instances of the default interface IUnknown exposed by              
// the CoClass ToolCombo. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoToolCombo = class
    class function Create: IUnknown;
    class function CreateRemote(const MachineName: string): IUnknown;
  end;

// *********************************************************************//
// The Class CoCommandBar provides a Create and CreateRemote method to          
// create instances of the default interface ICommandBar exposed by              
// the CoClass CommandBar. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCommandBar = class
    class function Create: ICommandBar;
    class function CreateRemote(const MachineName: string): ICommandBar;
  end;

// *********************************************************************//
// The Class CoSfxBarApi provides a Create and CreateRemote method to          
// create instances of the default interface IUnknown exposed by              
// the CoClass SfxBarApi. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSfxBarApi = class
    class function Create: IUnknown;
    class function CreateRemote(const MachineName: string): IUnknown;
  end;

implementation

uses ComObj;

class function CoBarWndDef.Create: IBarWndDisp;
begin
  Result := CreateComObject(CLASS_BarWndDef) as IBarWndDisp;
end;

class function CoBarWndDef.CreateRemote(const MachineName: string): IBarWndDisp;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_BarWndDef) as IBarWndDisp;
end;

class function CoBarFrameDef.Create: IUnknown;
begin
  Result := CreateComObject(CLASS_BarFrameDef) as IUnknown;
end;

class function CoBarFrameDef.CreateRemote(const MachineName: string): IUnknown;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_BarFrameDef) as IUnknown;
end;

class function CoToolBar.Create: IToolBar;
begin
  Result := CreateComObject(CLASS_ToolBar) as IToolBar;
end;

class function CoToolBar.CreateRemote(const MachineName: string): IToolBar;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ToolBar) as IToolBar;
end;

class function CoToolCombo.Create: IUnknown;
begin
  Result := CreateComObject(CLASS_ToolCombo) as IUnknown;
end;

class function CoToolCombo.CreateRemote(const MachineName: string): IUnknown;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ToolCombo) as IUnknown;
end;

class function CoCommandBar.Create: ICommandBar;
begin
  Result := CreateComObject(CLASS_CommandBar) as ICommandBar;
end;

class function CoCommandBar.CreateRemote(const MachineName: string): ICommandBar;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CommandBar) as ICommandBar;
end;

class function CoSfxBarApi.Create: IUnknown;
begin
  Result := CreateComObject(CLASS_SfxBarApi) as IUnknown;
end;

class function CoSfxBarApi.CreateRemote(const MachineName: string): IUnknown;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SfxBarApi) as IUnknown;
end;

end.
