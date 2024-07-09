unit AnnotateX_TLB;

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

// PASTLWTR : $Revision:   1.88.1.0.1.0  $
// File generated on 6/29/2002 9:35:35 PM from Type Library described below.

// ************************************************************************ //
// Type Lib: C:\Program Files\Common Files\Software FX Shared\AnnotateX.dll (1)
// IID\LCID: {EF600D63-358F-11D1-8FD4-00AA00BD091C}\0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINNT\System32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINNT\System32\STDVCL40.DLL)
//   (3) v1.0 SfxBar, (C:\Program Files\Common Files\Software FX Shared\SfxBar.dll)
// Errors:
//   Hint: Parameter 'var' of IAnnObject.Attach changed to 'var_'
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
interface

uses Windows, ActiveX, Classes, Graphics, OleServer, OleCtrls, StdVCL, 
  SfxBar_TLB;

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  AnnotateXMajorVersion = 1;
  AnnotateXMinorVersion = 0;

  LIBID_AnnotateX: TGUID = '{EF600D63-358F-11D1-8FD4-00AA00BD091C}';

  DIID__AnnotEvents: TGUID = '{4B6F58CF-365A-11D1-8FD4-00AA00BD091C}';
  IID_IAnnObject: TGUID = '{EF600D70-358F-11D1-8FD4-00AA00BD091C}';
  IID_IAnnList: TGUID = '{EF600D72-358F-11D1-8FD4-00AA00BD091C}';
  CLASS_AnnotationX: TGUID = '{EF600D71-358F-11D1-8FD4-00AA00BD091C}';
  IID_IAnnGroup: TGUID = '{EF600D8A-358F-11D1-8FD4-00AA00BD091C}';
  IID_IAnnObject2: TGUID = '{EF600D60-358F-11D1-8FD4-00AA00BD091C}';
  IID_IAnnRect: TGUID = '{EF600D75-358F-11D1-8FD4-00AA00BD091C}';
  IID_IAnnObjInternal: TGUID = '{EF600D73-358F-11D1-8FD4-00AA00BD091C}';
  CLASS_AnnRect: TGUID = '{EF600D74-358F-11D1-8FD4-00AA00BD091C}';
  IID_IAnnCircle: TGUID = '{EF600D78-358F-11D1-8FD4-00AA00BD091C}';
  CLASS_AnnCircle: TGUID = '{EF600D77-358F-11D1-8FD4-00AA00BD091C}';
  IID_IAnnArrow2: TGUID = '{EF600D6B-358F-11D1-8FD4-00AA00BD091C}';
  IID_IAnnArrow: TGUID = '{EF600D7B-358F-11D1-8FD4-00AA00BD091C}';
  CLASS_AnnArrow: TGUID = '{EF600D7A-358F-11D1-8FD4-00AA00BD091C}';
  IID_IAnnArc: TGUID = '{EF600D7E-358F-11D1-8FD4-00AA00BD091C}';
  CLASS_AnnArc: TGUID = '{EF600D7D-358F-11D1-8FD4-00AA00BD091C}';
  IID_IAnnText2: TGUID = '{EF600D61-358F-11D1-8FD4-00AA00BD091C}';
  IID_IAnnText: TGUID = '{EF600D81-358F-11D1-8FD4-00AA00BD091C}';
  CLASS_AnnText: TGUID = '{EF600D80-358F-11D1-8FD4-00AA00BD091C}';
  IID_IAnnBalloon2: TGUID = '{EF600D64-358F-11D1-8FD4-00AA00BD091C}';
  IID_IAnnBalloon: TGUID = '{EF600D84-358F-11D1-8FD4-00AA00BD091C}';
  CLASS_AnnBalloon: TGUID = '{EF600D83-358F-11D1-8FD4-00AA00BD091C}';
  IID_IAnnPicture2: TGUID = '{EF600D67-358F-11D1-8FD4-00AA00BD091C}';
  IID_IAnnPicture: TGUID = '{EF600D87-358F-11D1-8FD4-00AA00BD091C}';
  CLASS_AnnPicture: TGUID = '{EF600D86-358F-11D1-8FD4-00AA00BD091C}';
  CLASS_AnnGroup: TGUID = '{EF600D89-358F-11D1-8FD4-00AA00BD091C}';
  IID_IAnnPolygon2: TGUID = '{EF600D6E-358F-11D1-8FD4-00AA00BD091C}';
  IID_IAnnPolygon: TGUID = '{EF600D8E-358F-11D1-8FD4-00AA00BD091C}';
  CLASS_AnnPolygon: TGUID = '{EF600D8C-358F-11D1-8FD4-00AA00BD091C}';
  CLASS_AnnGeneralPage: TGUID = '{4B6F58C2-365A-11D1-8FD4-00AA00BD091C}';
  CLASS_AnnArrowPage: TGUID = '{4B6F58C3-365A-11D1-8FD4-00AA00BD091C}';
  CLASS_AnnPicturePage: TGUID = '{4B6F58C4-365A-11D1-8FD4-00AA00BD091C}';
  CLASS_AnnTextPage: TGUID = '{4B6F58C5-365A-11D1-8FD4-00AA00BD091C}';
  CLASS_AnnBalloonPage: TGUID = '{4B6F58C6-365A-11D1-8FD4-00AA00BD091C}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum AttachType
type
  AttachType = TOleEnum;
const
  ATTACH_NONE = $00000000;
  ATTACH_CENTER = $00000001;
  ATTACH_ELASTIC = $00000002;

// Constants for enum AnnotateCommand
type
  AnnotateCommand = TOleEnum;
const
  ID_TYPE_NONE = $00000000;
  ID_TYPE_RECT = $00000001;
  ID_TYPE_CIRCLE = $00000002;
  ID_TYPE_LINE = $00000003;
  ID_TYPE_ARC = $00000004;
  ID_TYPE_PICTURE = $00000005;
  ID_TYPE_TEXT = $00000006;
  ID_TYPE_BALLOON = $00000007;
  ID_TYPE_GROUP = $00000008;
  ID_TYPE_POLYGON = $00000009;
  ID_OBJECT_BACKCOLOR = $0000000A;
  ID_OBJECT_BORDERCOLOR = $0000000B;
  ID_OBJECT_CUT = $0000000C;
  ID_OBJECT_COPY = $0000000D;
  ID_OBJECT_BRINGTOFRONT = $0000000E;
  ID_OBJECT_SENDTOBACK = $0000000F;
  ID_OBJECT_FLIPHORIZONTAL = $00000010;
  ID_OBJECT_FLIPVERTICAL = $00000011;
  ID_OBJECT_ROTATERIGHT = $00000012;
  ID_OBJECT_ROTATELEFT = $00000013;
  ID_OBJECT_DELETE = $00000014;
  ID_OBJECT_ATTACHNONE = $00000015;
  ID_OBJECT_ATTACHCENTER = $00000016;
  ID_OBJECT_ATTACHELASTIC = $00000017;
  ID_OBJECT_PASTE = $00000018;
  ID_OBJECT_GROUP = $00000019;
  ID_OBJECT_UNGROUP = $0000001A;
  ID_OBJECT_PROPERTIES = $0000001B;
  ID_OBJECT_MENU = $0000001C;
  ID_OBJECT_ATTACH = $0000001D;
  ID_OBJECT_ROTATEFLIP = $0000001E;
  ID_OBJECT_LOCK = $0000001F;
  ID_OBJECT_ATTACHNONE2 = $00000020;
  ID_OBJECT_ATTACHCENTER2 = $00000021;
  ID_OBJECT_ATTACHELASTIC2 = $00000022;
  ID_DELETE_ALL = $00000023;

// Constants for enum LineStyle
type
  LineStyle = TOleEnum;
const
  LS_SOLID = $00000000;
  LS_DASH = $00000001;
  LS_DOT = $00000002;
  LS_DASHDOT = $00000003;
  LS_DASHDOTDOT = $00000004;
  LS_NONE = $00000005;

// Constants for enum ObjectType
type
  ObjectType = TOleEnum;
const
  OBJECT_TYPE_RECT = $00000001;
  OBJECT_TYPE_CIRCLE = $00000002;
  OBJECT_TYPE_ARROW = $00000003;
  OBJECT_TYPE_ARC = $00000004;
  OBJECT_TYPE_PICTURE = $00000005;
  OBJECT_TYPE_TEXT = $00000006;
  OBJECT_TYPE_BALLOON = $00000007;
  OBJECT_TYPE_GROUP = $00000008;
  OBJECT_TYPE_POLYGON = $00000009;

// Constants for enum ArrowStyle
type
  ArrowStyle = TOleEnum;
const
  ARROW_NONE = $00000000;
  ARROW_TRIANGLE = $00000001;
  ARROW_KILL = $00000002;

// Constants for enum TextOrient
type
  TextOrient = TOleEnum;
const
  TO_LEFT2RIGHT = $00000000;
  TO_BOTTOM2TOP = $00000001;
  TO_RIGHT2LEFT = $00000002;
  TO_TOP2BOTTOM = $00000003;

// Constants for enum BallonTail
type
  BallonTail = TOleEnum;
const
  BALLOON_LT = $00000000;
  BALLOON_RT = $00000001;
  BALLOON_LB = $00000002;
  BALLOON_RB = $00000003;

// Constants for enum PolyFillMode
type
  PolyFillMode = TOleEnum;
const
  FILLMODE_ALTERNATE = $00000001;
  FILLMODE_WINDING = $00000002;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  _AnnotEvents = dispinterface;
  IAnnObject = interface;
  IAnnObjectDisp = dispinterface;
  IAnnList = interface;
  IAnnListDisp = dispinterface;
  IAnnGroup = interface;
  IAnnGroupDisp = dispinterface;
  IAnnObject2 = interface;
  IAnnObject2Disp = dispinterface;
  IAnnRect = interface;
  IAnnRectDisp = dispinterface;
  IAnnObjInternal = interface;
  IAnnObjInternalDisp = dispinterface;
  IAnnCircle = interface;
  IAnnCircleDisp = dispinterface;
  IAnnArrow2 = interface;
  IAnnArrow2Disp = dispinterface;
  IAnnArrow = interface;
  IAnnArrowDisp = dispinterface;
  IAnnArc = interface;
  IAnnArcDisp = dispinterface;
  IAnnText2 = interface;
  IAnnText2Disp = dispinterface;
  IAnnText = interface;
  IAnnTextDisp = dispinterface;
  IAnnBalloon2 = interface;
  IAnnBalloon2Disp = dispinterface;
  IAnnBalloon = interface;
  IAnnBalloonDisp = dispinterface;
  IAnnPicture2 = interface;
  IAnnPicture2Disp = dispinterface;
  IAnnPicture = interface;
  IAnnPictureDisp = dispinterface;
  IAnnPolygon2 = interface;
  IAnnPolygon2Disp = dispinterface;
  IAnnPolygon = interface;
  IAnnPolygonDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  AnnotationX = IAnnList;
  AnnRect = IAnnRect;
  AnnCircle = IAnnCircle;
  AnnArrow = IAnnArrow2;
  AnnArc = IAnnArc;
  AnnText = IAnnText2;
  AnnBalloon = IAnnBalloon2;
  AnnPicture = IAnnPicture2;
  AnnGroup = IAnnGroup;
  AnnPolygon = IAnnPolygon2;
  AnnGeneralPage = IUnknown;
  AnnArrowPage = IUnknown;
  AnnPicturePage = IUnknown;
  AnnTextPage = IUnknown;
  AnnBalloonPage = IUnknown;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  PSmallint1 = ^Smallint; {*}
  POleVariant1 = ^OleVariant; {*}


// *********************************************************************//
// DispIntf:  _AnnotEvents
// Flags:     (4112) Hidden Dispatchable
// GUID:      {4B6F58CF-365A-11D1-8FD4-00AA00BD091C}
// *********************************************************************//
  _AnnotEvents = dispinterface
    ['{4B6F58CF-365A-11D1-8FD4-00AA00BD091C}']
    procedure LButtonDblClk(const pObj: IAnnObject; var nRes: Smallint); dispid 1;
    procedure ObjectCreated(const pObj: IAnnObject); dispid 2;
    procedure ExecuteCommand(nID: Smallint; var nRes: Smallint); dispid 3;
    procedure SelectionChanged; dispid 4;
    procedure StartMoving(Left: SYSINT; Top: SYSINT; right: SYSINT; bottom: SYSINT); dispid 5;
    procedure OnMoving; dispid 6;
    procedure EndMoving; dispid 7;
    procedure ObjectDeleted(const pObj: IAnnObject; var nRes: Smallint); dispid 8;
  end;

// *********************************************************************//
// Interface: IAnnObject
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EF600D70-358F-11D1-8FD4-00AA00BD091C}
// *********************************************************************//
  IAnnObject = interface(IDispatch)
    ['{EF600D70-358F-11D1-8FD4-00AA00BD091C}']
    function  Get_ObjectType: OleVariant; safecall;
    function  Get_Color: OLE_COLOR; safecall;
    procedure Set_Color(retval: OLE_COLOR); safecall;
    function  Get_BkColor: OLE_COLOR; safecall;
    procedure Set_BkColor(retval: OLE_COLOR); safecall;
    function  Get_BorderStyle: LineStyle; safecall;
    procedure Set_BorderStyle(retval: LineStyle); safecall;
    function  Get_BorderWidth: Smallint; safecall;
    procedure Set_BorderWidth(retval: Smallint); safecall;
    function  Get_Left: Smallint; safecall;
    procedure Set_Left(retval: Smallint); safecall;
    function  Get_Top: Smallint; safecall;
    procedure Set_Top(retval: Smallint); safecall;
    function  Get_Width: Smallint; safecall;
    procedure Set_Width(retval: Smallint); safecall;
    function  Get_Height: Smallint; safecall;
    procedure Set_Height(retval: Smallint); safecall;
    function  Get_Tag: Integer; safecall;
    procedure Set_Tag(retval: Integer); safecall;
    function  Get_AllowMove: WordBool; safecall;
    procedure Set_AllowMove(pVal: WordBool); safecall;
    function  Get_AllowModify: WordBool; safecall;
    procedure Set_AllowModify(pVal: WordBool); safecall;
    procedure Attach(nAttach: Smallint; var var_: OleVariant); safecall;
    procedure Refresh(bErase: WordBool); safecall;
    procedure Rotate(bClockWise: WordBool); safecall;
    procedure Flip(bHorizontal: WordBool); safecall;
    function  Get_URL: WideString; safecall;
    procedure Set_URL(const pVal: WideString); safecall;
    function  Get_URLTarget: WideString; safecall;
    procedure Set_URLTarget(const pVal: WideString); safecall;
    property ObjectType: OleVariant read Get_ObjectType;
    property Color: OLE_COLOR read Get_Color write Set_Color;
    property BkColor: OLE_COLOR read Get_BkColor write Set_BkColor;
    property BorderStyle: LineStyle read Get_BorderStyle write Set_BorderStyle;
    property BorderWidth: Smallint read Get_BorderWidth write Set_BorderWidth;
    property Left: Smallint read Get_Left write Set_Left;
    property Top: Smallint read Get_Top write Set_Top;
    property Width: Smallint read Get_Width write Set_Width;
    property Height: Smallint read Get_Height write Set_Height;
    property Tag: Integer read Get_Tag write Set_Tag;
    property AllowMove: WordBool read Get_AllowMove write Set_AllowMove;
    property AllowModify: WordBool read Get_AllowModify write Set_AllowModify;
    property URL: WideString read Get_URL write Set_URL;
    property URLTarget: WideString read Get_URLTarget write Set_URLTarget;
  end;

// *********************************************************************//
// DispIntf:  IAnnObjectDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EF600D70-358F-11D1-8FD4-00AA00BD091C}
// *********************************************************************//
  IAnnObjectDisp = dispinterface
    ['{EF600D70-358F-11D1-8FD4-00AA00BD091C}']
    property ObjectType: OleVariant readonly dispid 1;
    property Color: OLE_COLOR dispid 2;
    property BkColor: OLE_COLOR dispid 3;
    property BorderStyle: LineStyle dispid 4;
    property BorderWidth: Smallint dispid 5;
    property Left: Smallint dispid 6;
    property Top: Smallint dispid 7;
    property Width: Smallint dispid 8;
    property Height: Smallint dispid 9;
    property Tag: Integer dispid 10;
    property AllowMove: WordBool dispid 11;
    property AllowModify: WordBool dispid 12;
    procedure Attach(nAttach: Smallint; var var_: OleVariant); dispid 13;
    procedure Refresh(bErase: WordBool); dispid 14;
    procedure Rotate(bClockWise: WordBool); dispid 15;
    procedure Flip(bHorizontal: WordBool); dispid 16;
    property URL: WideString dispid 40;
    property URLTarget: WideString dispid 41;
  end;

// *********************************************************************//
// Interface: IAnnList
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EF600D72-358F-11D1-8FD4-00AA00BD091C}
// *********************************************************************//
  IAnnList = interface(IDispatch)
    ['{EF600D72-358F-11D1-8FD4-00AA00BD091C}']
    function  Get__NewEnum: IUnknown; safecall;
    function  Get_Count: Integer; safecall;
    function  Get_Enabled: WordBool; safecall;
    procedure Set_Enabled(val: WordBool); safecall;
    function  Item(vIndex: OleVariant): IAnnObject; safecall;
    function  Add(obj: OleVariant; vIndex: OleVariant): IAnnObject; safecall;
    procedure Remove(vIndex: OleVariant); safecall;
    function  Get_CurSel: IAnnGroup; safecall;
    function  Get_ToolBar: WordBool; safecall;
    procedure Set_ToolBar(pVal: WordBool); safecall;
    function  HitTest(x: Smallint; y: Smallint): IAnnObject; safecall;
    function  Get_ToolBarObj: IToolBar; safecall;
    function  Get_NewObjectType: ObjectType; safecall;
    procedure Set_NewObjectType(pVal: ObjectType); safecall;
    procedure ClearSelection; safecall;
    procedure AddToSelection(const pObj: IAnnObject); safecall;
    procedure SetPalette(hPal: SYSUINT); safecall;
    function  Locate(const pObj: IAnnObject): Integer; safecall;
    procedure GetBounds(out nLeft: Integer; out nTop: Integer; out nRight: Integer; 
                        out nBottom: Integer); safecall;
    procedure SetDirty(newVal: WordBool); safecall;
    procedure Copy; safecall;
    procedure Paste(bSelectObjects: WordBool); safecall;
    procedure RawPaint(hDC: SYSUINT; nLeft: Integer; nTop: Integer; nRight: Integer; 
                       nBottom: Integer; bPrint: WordBool); safecall;
    function  Insert(obj: OleVariant; vIndex: OleVariant): IAnnObject; safecall;
    procedure ClearActive; safecall;
    property _NewEnum: IUnknown read Get__NewEnum;
    property Count: Integer read Get_Count;
    property Enabled: WordBool read Get_Enabled write Set_Enabled;
    property CurSel: IAnnGroup read Get_CurSel;
    property ToolBar: WordBool read Get_ToolBar write Set_ToolBar;
    property ToolBarObj: IToolBar read Get_ToolBarObj;
    property NewObjectType: ObjectType read Get_NewObjectType write Set_NewObjectType;
  end;

// *********************************************************************//
// DispIntf:  IAnnListDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EF600D72-358F-11D1-8FD4-00AA00BD091C}
// *********************************************************************//
  IAnnListDisp = dispinterface
    ['{EF600D72-358F-11D1-8FD4-00AA00BD091C}']
    property _NewEnum: IUnknown readonly dispid -4;
    property Count: Integer readonly dispid 1;
    property Enabled: WordBool dispid -514;
    function  Item(vIndex: OleVariant): IAnnObject; dispid 2;
    function  Add(obj: OleVariant; vIndex: OleVariant): IAnnObject; dispid 3;
    procedure Remove(vIndex: OleVariant); dispid 4;
    property CurSel: IAnnGroup readonly dispid 5;
    property ToolBar: WordBool dispid 6;
    function  HitTest(x: Smallint; y: Smallint): IAnnObject; dispid 7;
    property ToolBarObj: IToolBar readonly dispid 8;
    property NewObjectType: ObjectType dispid 10;
    procedure ClearSelection; dispid 11;
    procedure AddToSelection(const pObj: IAnnObject); dispid 12;
    procedure SetPalette(hPal: SYSUINT); dispid 13;
    function  Locate(const pObj: IAnnObject): Integer; dispid 14;
    procedure GetBounds(out nLeft: Integer; out nTop: Integer; out nRight: Integer; 
                        out nBottom: Integer); dispid 15;
    procedure SetDirty(newVal: WordBool); dispid 16;
    procedure Copy; dispid 17;
    procedure Paste(bSelectObjects: WordBool); dispid 18;
    procedure RawPaint(hDC: SYSUINT; nLeft: Integer; nTop: Integer; nRight: Integer; 
                       nBottom: Integer; bPrint: WordBool); dispid 19;
    function  Insert(obj: OleVariant; vIndex: OleVariant): IAnnObject; dispid 20;
    procedure ClearActive; dispid 21;
  end;

// *********************************************************************//
// Interface: IAnnGroup
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EF600D8A-358F-11D1-8FD4-00AA00BD091C}
// *********************************************************************//
  IAnnGroup = interface(IAnnObject)
    ['{EF600D8A-358F-11D1-8FD4-00AA00BD091C}']
    function  Get__NewEnum: IUnknown; safecall;
    function  Get_Count: Integer; safecall;
    function  Item(vIndex: OleVariant): IAnnObject; safecall;
    function  Add(obj: OleVariant; vIndex: OleVariant): IAnnObject; safecall;
    procedure Remove(vIndex: OleVariant); safecall;
    procedure RecalcBounds; safecall;
    property _NewEnum: IUnknown read Get__NewEnum;
    property Count: Integer read Get_Count;
  end;

// *********************************************************************//
// DispIntf:  IAnnGroupDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EF600D8A-358F-11D1-8FD4-00AA00BD091C}
// *********************************************************************//
  IAnnGroupDisp = dispinterface
    ['{EF600D8A-358F-11D1-8FD4-00AA00BD091C}']
    property _NewEnum: IUnknown readonly dispid -4;
    property Count: Integer readonly dispid 17;
    function  Item(vIndex: OleVariant): IAnnObject; dispid 18;
    function  Add(obj: OleVariant; vIndex: OleVariant): IAnnObject; dispid 19;
    procedure Remove(vIndex: OleVariant); dispid 20;
    procedure RecalcBounds; dispid 21;
    property ObjectType: OleVariant readonly dispid 1;
    property Color: OLE_COLOR dispid 2;
    property BkColor: OLE_COLOR dispid 3;
    property BorderStyle: LineStyle dispid 4;
    property BorderWidth: Smallint dispid 5;
    property Left: Smallint dispid 6;
    property Top: Smallint dispid 7;
    property Width: Smallint dispid 8;
    property Height: Smallint dispid 9;
    property Tag: Integer dispid 10;
    property AllowMove: WordBool dispid 11;
    property AllowModify: WordBool dispid 12;
    procedure Attach(nAttach: Smallint; var var_: OleVariant); dispid 13;
    procedure Refresh(bErase: WordBool); dispid 14;
    procedure Rotate(bClockWise: WordBool); dispid 15;
    procedure Flip(bHorizontal: WordBool); dispid 16;
    property URL: WideString dispid 40;
    property URLTarget: WideString dispid 41;
  end;

// *********************************************************************//
// Interface: IAnnObject2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EF600D60-358F-11D1-8FD4-00AA00BD091C}
// *********************************************************************//
  IAnnObject2 = interface(IAnnObject)
    ['{EF600D60-358F-11D1-8FD4-00AA00BD091C}']
    function  Get_AnnObjInternal: IAnnObjInternal; safecall;
    property AnnObjInternal: IAnnObjInternal read Get_AnnObjInternal;
  end;

// *********************************************************************//
// DispIntf:  IAnnObject2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EF600D60-358F-11D1-8FD4-00AA00BD091C}
// *********************************************************************//
  IAnnObject2Disp = dispinterface
    ['{EF600D60-358F-11D1-8FD4-00AA00BD091C}']
    property AnnObjInternal: IAnnObjInternal readonly dispid 42;
    property ObjectType: OleVariant readonly dispid 1;
    property Color: OLE_COLOR dispid 2;
    property BkColor: OLE_COLOR dispid 3;
    property BorderStyle: LineStyle dispid 4;
    property BorderWidth: Smallint dispid 5;
    property Left: Smallint dispid 6;
    property Top: Smallint dispid 7;
    property Width: Smallint dispid 8;
    property Height: Smallint dispid 9;
    property Tag: Integer dispid 10;
    property AllowMove: WordBool dispid 11;
    property AllowModify: WordBool dispid 12;
    procedure Attach(nAttach: Smallint; var var_: OleVariant); dispid 13;
    procedure Refresh(bErase: WordBool); dispid 14;
    procedure Rotate(bClockWise: WordBool); dispid 15;
    procedure Flip(bHorizontal: WordBool); dispid 16;
    property URL: WideString dispid 40;
    property URLTarget: WideString dispid 41;
  end;

// *********************************************************************//
// Interface: IAnnRect
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EF600D75-358F-11D1-8FD4-00AA00BD091C}
// *********************************************************************//
  IAnnRect = interface(IAnnObject2)
    ['{EF600D75-358F-11D1-8FD4-00AA00BD091C}']
  end;

// *********************************************************************//
// DispIntf:  IAnnRectDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EF600D75-358F-11D1-8FD4-00AA00BD091C}
// *********************************************************************//
  IAnnRectDisp = dispinterface
    ['{EF600D75-358F-11D1-8FD4-00AA00BD091C}']
    property AnnObjInternal: IAnnObjInternal readonly dispid 42;
    property ObjectType: OleVariant readonly dispid 1;
    property Color: OLE_COLOR dispid 2;
    property BkColor: OLE_COLOR dispid 3;
    property BorderStyle: LineStyle dispid 4;
    property BorderWidth: Smallint dispid 5;
    property Left: Smallint dispid 6;
    property Top: Smallint dispid 7;
    property Width: Smallint dispid 8;
    property Height: Smallint dispid 9;
    property Tag: Integer dispid 10;
    property AllowMove: WordBool dispid 11;
    property AllowModify: WordBool dispid 12;
    procedure Attach(nAttach: Smallint; var var_: OleVariant); dispid 13;
    procedure Refresh(bErase: WordBool); dispid 14;
    procedure Rotate(bClockWise: WordBool); dispid 15;
    procedure Flip(bHorizontal: WordBool); dispid 16;
    property URL: WideString dispid 40;
    property URLTarget: WideString dispid 41;
  end;

// *********************************************************************//
// Interface: IAnnObjInternal
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EF600D73-358F-11D1-8FD4-00AA00BD091C}
// *********************************************************************//
  IAnnObjInternal = interface(IDispatch)
    ['{EF600D73-358F-11D1-8FD4-00AA00BD091C}']
    function  Get_ObjectLeft: Smallint; safecall;
    procedure Set_ObjectLeft(retval: Smallint); safecall;
    function  Get_ObjectTop: Smallint; safecall;
    procedure Set_ObjectTop(retval: Smallint); safecall;
    function  Get_ObjectRight: Smallint; safecall;
    procedure Set_ObjectRight(retval: Smallint); safecall;
    function  Get_ObjectBottom: Smallint; safecall;
    procedure Set_ObjectBottom(retval: Smallint); safecall;
    function  Get_ObjectAttachMode: Smallint; safecall;
    function  Get_ObjectAttachInfo: WideString; safecall;
    property ObjectLeft: Smallint read Get_ObjectLeft write Set_ObjectLeft;
    property ObjectTop: Smallint read Get_ObjectTop write Set_ObjectTop;
    property ObjectRight: Smallint read Get_ObjectRight write Set_ObjectRight;
    property ObjectBottom: Smallint read Get_ObjectBottom write Set_ObjectBottom;
    property ObjectAttachMode: Smallint read Get_ObjectAttachMode;
    property ObjectAttachInfo: WideString read Get_ObjectAttachInfo;
  end;

// *********************************************************************//
// DispIntf:  IAnnObjInternalDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EF600D73-358F-11D1-8FD4-00AA00BD091C}
// *********************************************************************//
  IAnnObjInternalDisp = dispinterface
    ['{EF600D73-358F-11D1-8FD4-00AA00BD091C}']
    property ObjectLeft: Smallint dispid 1;
    property ObjectTop: Smallint dispid 2;
    property ObjectRight: Smallint dispid 3;
    property ObjectBottom: Smallint dispid 4;
    property ObjectAttachMode: Smallint readonly dispid 5;
    property ObjectAttachInfo: WideString readonly dispid 6;
  end;

// *********************************************************************//
// Interface: IAnnCircle
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EF600D78-358F-11D1-8FD4-00AA00BD091C}
// *********************************************************************//
  IAnnCircle = interface(IAnnObject2)
    ['{EF600D78-358F-11D1-8FD4-00AA00BD091C}']
  end;

// *********************************************************************//
// DispIntf:  IAnnCircleDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EF600D78-358F-11D1-8FD4-00AA00BD091C}
// *********************************************************************//
  IAnnCircleDisp = dispinterface
    ['{EF600D78-358F-11D1-8FD4-00AA00BD091C}']
    property AnnObjInternal: IAnnObjInternal readonly dispid 42;
    property ObjectType: OleVariant readonly dispid 1;
    property Color: OLE_COLOR dispid 2;
    property BkColor: OLE_COLOR dispid 3;
    property BorderStyle: LineStyle dispid 4;
    property BorderWidth: Smallint dispid 5;
    property Left: Smallint dispid 6;
    property Top: Smallint dispid 7;
    property Width: Smallint dispid 8;
    property Height: Smallint dispid 9;
    property Tag: Integer dispid 10;
    property AllowMove: WordBool dispid 11;
    property AllowModify: WordBool dispid 12;
    procedure Attach(nAttach: Smallint; var var_: OleVariant); dispid 13;
    procedure Refresh(bErase: WordBool); dispid 14;
    procedure Rotate(bClockWise: WordBool); dispid 15;
    procedure Flip(bHorizontal: WordBool); dispid 16;
    property URL: WideString dispid 40;
    property URLTarget: WideString dispid 41;
  end;

// *********************************************************************//
// Interface: IAnnArrow2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EF600D6B-358F-11D1-8FD4-00AA00BD091C}
// *********************************************************************//
  IAnnArrow2 = interface(IAnnObject2)
    ['{EF600D6B-358F-11D1-8FD4-00AA00BD091C}']
    function  Get_HeadStyle: ArrowStyle; safecall;
    procedure Set_HeadStyle(retval: ArrowStyle); safecall;
    function  Get_HeadSize: Smallint; safecall;
    procedure Set_HeadSize(retval: Smallint); safecall;
    function  Get_HeadWidth: Smallint; safecall;
    procedure Set_HeadWidth(retval: Smallint); safecall;
    function  Get_TailStyle: ArrowStyle; safecall;
    procedure Set_TailStyle(retval: ArrowStyle); safecall;
    function  Get_TailSize: Smallint; safecall;
    procedure Set_TailSize(retval: Smallint); safecall;
    function  Get_TailWidth: Smallint; safecall;
    procedure Set_TailWidth(retval: Smallint); safecall;
    property HeadStyle: ArrowStyle read Get_HeadStyle write Set_HeadStyle;
    property HeadSize: Smallint read Get_HeadSize write Set_HeadSize;
    property HeadWidth: Smallint read Get_HeadWidth write Set_HeadWidth;
    property TailStyle: ArrowStyle read Get_TailStyle write Set_TailStyle;
    property TailSize: Smallint read Get_TailSize write Set_TailSize;
    property TailWidth: Smallint read Get_TailWidth write Set_TailWidth;
  end;

// *********************************************************************//
// DispIntf:  IAnnArrow2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EF600D6B-358F-11D1-8FD4-00AA00BD091C}
// *********************************************************************//
  IAnnArrow2Disp = dispinterface
    ['{EF600D6B-358F-11D1-8FD4-00AA00BD091C}']
    property HeadStyle: ArrowStyle dispid 17;
    property HeadSize: Smallint dispid 18;
    property HeadWidth: Smallint dispid 19;
    property TailStyle: ArrowStyle dispid 20;
    property TailSize: Smallint dispid 21;
    property TailWidth: Smallint dispid 22;
    property AnnObjInternal: IAnnObjInternal readonly dispid 42;
    property ObjectType: OleVariant readonly dispid 1;
    property Color: OLE_COLOR dispid 2;
    property BkColor: OLE_COLOR dispid 3;
    property BorderStyle: LineStyle dispid 4;
    property BorderWidth: Smallint dispid 5;
    property Left: Smallint dispid 6;
    property Top: Smallint dispid 7;
    property Width: Smallint dispid 8;
    property Height: Smallint dispid 9;
    property Tag: Integer dispid 10;
    property AllowMove: WordBool dispid 11;
    property AllowModify: WordBool dispid 12;
    procedure Attach(nAttach: Smallint; var var_: OleVariant); dispid 13;
    procedure Refresh(bErase: WordBool); dispid 14;
    procedure Rotate(bClockWise: WordBool); dispid 15;
    procedure Flip(bHorizontal: WordBool); dispid 16;
    property URL: WideString dispid 40;
    property URLTarget: WideString dispid 41;
  end;

// *********************************************************************//
// Interface: IAnnArrow
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EF600D7B-358F-11D1-8FD4-00AA00BD091C}
// *********************************************************************//
  IAnnArrow = interface(IAnnObject)
    ['{EF600D7B-358F-11D1-8FD4-00AA00BD091C}']
    function  Get_HeadStyle: ArrowStyle; safecall;
    procedure Set_HeadStyle(retval: ArrowStyle); safecall;
    function  Get_HeadSize: Smallint; safecall;
    procedure Set_HeadSize(retval: Smallint); safecall;
    function  Get_HeadWidth: Smallint; safecall;
    procedure Set_HeadWidth(retval: Smallint); safecall;
    function  Get_TailStyle: ArrowStyle; safecall;
    procedure Set_TailStyle(retval: ArrowStyle); safecall;
    function  Get_TailSize: Smallint; safecall;
    procedure Set_TailSize(retval: Smallint); safecall;
    function  Get_TailWidth: Smallint; safecall;
    procedure Set_TailWidth(retval: Smallint); safecall;
    property HeadStyle: ArrowStyle read Get_HeadStyle write Set_HeadStyle;
    property HeadSize: Smallint read Get_HeadSize write Set_HeadSize;
    property HeadWidth: Smallint read Get_HeadWidth write Set_HeadWidth;
    property TailStyle: ArrowStyle read Get_TailStyle write Set_TailStyle;
    property TailSize: Smallint read Get_TailSize write Set_TailSize;
    property TailWidth: Smallint read Get_TailWidth write Set_TailWidth;
  end;

// *********************************************************************//
// DispIntf:  IAnnArrowDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EF600D7B-358F-11D1-8FD4-00AA00BD091C}
// *********************************************************************//
  IAnnArrowDisp = dispinterface
    ['{EF600D7B-358F-11D1-8FD4-00AA00BD091C}']
    property HeadStyle: ArrowStyle dispid 17;
    property HeadSize: Smallint dispid 18;
    property HeadWidth: Smallint dispid 19;
    property TailStyle: ArrowStyle dispid 20;
    property TailSize: Smallint dispid 21;
    property TailWidth: Smallint dispid 22;
    property ObjectType: OleVariant readonly dispid 1;
    property Color: OLE_COLOR dispid 2;
    property BkColor: OLE_COLOR dispid 3;
    property BorderStyle: LineStyle dispid 4;
    property BorderWidth: Smallint dispid 5;
    property Left: Smallint dispid 6;
    property Top: Smallint dispid 7;
    property Width: Smallint dispid 8;
    property Height: Smallint dispid 9;
    property Tag: Integer dispid 10;
    property AllowMove: WordBool dispid 11;
    property AllowModify: WordBool dispid 12;
    procedure Attach(nAttach: Smallint; var var_: OleVariant); dispid 13;
    procedure Refresh(bErase: WordBool); dispid 14;
    procedure Rotate(bClockWise: WordBool); dispid 15;
    procedure Flip(bHorizontal: WordBool); dispid 16;
    property URL: WideString dispid 40;
    property URLTarget: WideString dispid 41;
  end;

// *********************************************************************//
// Interface: IAnnArc
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EF600D7E-358F-11D1-8FD4-00AA00BD091C}
// *********************************************************************//
  IAnnArc = interface(IAnnObject2)
    ['{EF600D7E-358F-11D1-8FD4-00AA00BD091C}']
  end;

// *********************************************************************//
// DispIntf:  IAnnArcDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EF600D7E-358F-11D1-8FD4-00AA00BD091C}
// *********************************************************************//
  IAnnArcDisp = dispinterface
    ['{EF600D7E-358F-11D1-8FD4-00AA00BD091C}']
    property AnnObjInternal: IAnnObjInternal readonly dispid 42;
    property ObjectType: OleVariant readonly dispid 1;
    property Color: OLE_COLOR dispid 2;
    property BkColor: OLE_COLOR dispid 3;
    property BorderStyle: LineStyle dispid 4;
    property BorderWidth: Smallint dispid 5;
    property Left: Smallint dispid 6;
    property Top: Smallint dispid 7;
    property Width: Smallint dispid 8;
    property Height: Smallint dispid 9;
    property Tag: Integer dispid 10;
    property AllowMove: WordBool dispid 11;
    property AllowModify: WordBool dispid 12;
    procedure Attach(nAttach: Smallint; var var_: OleVariant); dispid 13;
    procedure Refresh(bErase: WordBool); dispid 14;
    procedure Rotate(bClockWise: WordBool); dispid 15;
    procedure Flip(bHorizontal: WordBool); dispid 16;
    property URL: WideString dispid 40;
    property URLTarget: WideString dispid 41;
  end;

// *********************************************************************//
// Interface: IAnnText2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EF600D61-358F-11D1-8FD4-00AA00BD091C}
// *********************************************************************//
  IAnnText2 = interface(IAnnObject2)
    ['{EF600D61-358F-11D1-8FD4-00AA00BD091C}']
    function  Get_Text: WideString; safecall;
    procedure Set_Text(const retval: WideString); safecall;
    function  Get_Font: IFontDisp; safecall;
    procedure Set_Font(const val: IFontDisp); safecall;
    function  Get_Align: Smallint; safecall;
    procedure Set_Align(retval: Smallint); safecall;
    function  Get_Orientation: TextOrient; safecall;
    procedure Set_Orientation(retval: TextOrient); safecall;
    procedure SizeToFit; safecall;
    property Text: WideString read Get_Text write Set_Text;
    property Font: IFontDisp read Get_Font write Set_Font;
    property Align: Smallint read Get_Align write Set_Align;
    property Orientation: TextOrient read Get_Orientation write Set_Orientation;
  end;

// *********************************************************************//
// DispIntf:  IAnnText2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EF600D61-358F-11D1-8FD4-00AA00BD091C}
// *********************************************************************//
  IAnnText2Disp = dispinterface
    ['{EF600D61-358F-11D1-8FD4-00AA00BD091C}']
    property Text: WideString dispid 17;
    property Font: IFontDisp dispid 18;
    property Align: Smallint dispid 19;
    property Orientation: TextOrient dispid 20;
    procedure SizeToFit; dispid 21;
    property AnnObjInternal: IAnnObjInternal readonly dispid 42;
    property ObjectType: OleVariant readonly dispid 1;
    property Color: OLE_COLOR dispid 2;
    property BkColor: OLE_COLOR dispid 3;
    property BorderStyle: LineStyle dispid 4;
    property BorderWidth: Smallint dispid 5;
    property Left: Smallint dispid 6;
    property Top: Smallint dispid 7;
    property Width: Smallint dispid 8;
    property Height: Smallint dispid 9;
    property Tag: Integer dispid 10;
    property AllowMove: WordBool dispid 11;
    property AllowModify: WordBool dispid 12;
    procedure Attach(nAttach: Smallint; var var_: OleVariant); dispid 13;
    procedure Refresh(bErase: WordBool); dispid 14;
    procedure Rotate(bClockWise: WordBool); dispid 15;
    procedure Flip(bHorizontal: WordBool); dispid 16;
    property URL: WideString dispid 40;
    property URLTarget: WideString dispid 41;
  end;

// *********************************************************************//
// Interface: IAnnText
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EF600D81-358F-11D1-8FD4-00AA00BD091C}
// *********************************************************************//
  IAnnText = interface(IAnnObject)
    ['{EF600D81-358F-11D1-8FD4-00AA00BD091C}']
    function  Get_Text: WideString; safecall;
    procedure Set_Text(const retval: WideString); safecall;
    function  Get_Font: IFontDisp; safecall;
    procedure Set_Font(const val: IFontDisp); safecall;
    function  Get_Align: Smallint; safecall;
    procedure Set_Align(retval: Smallint); safecall;
    function  Get_Orientation: TextOrient; safecall;
    procedure Set_Orientation(retval: TextOrient); safecall;
    procedure SizeToFit; safecall;
    property Text: WideString read Get_Text write Set_Text;
    property Font: IFontDisp read Get_Font write Set_Font;
    property Align: Smallint read Get_Align write Set_Align;
    property Orientation: TextOrient read Get_Orientation write Set_Orientation;
  end;

// *********************************************************************//
// DispIntf:  IAnnTextDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EF600D81-358F-11D1-8FD4-00AA00BD091C}
// *********************************************************************//
  IAnnTextDisp = dispinterface
    ['{EF600D81-358F-11D1-8FD4-00AA00BD091C}']
    property Text: WideString dispid 17;
    property Font: IFontDisp dispid 18;
    property Align: Smallint dispid 19;
    property Orientation: TextOrient dispid 20;
    procedure SizeToFit; dispid 21;
    property ObjectType: OleVariant readonly dispid 1;
    property Color: OLE_COLOR dispid 2;
    property BkColor: OLE_COLOR dispid 3;
    property BorderStyle: LineStyle dispid 4;
    property BorderWidth: Smallint dispid 5;
    property Left: Smallint dispid 6;
    property Top: Smallint dispid 7;
    property Width: Smallint dispid 8;
    property Height: Smallint dispid 9;
    property Tag: Integer dispid 10;
    property AllowMove: WordBool dispid 11;
    property AllowModify: WordBool dispid 12;
    procedure Attach(nAttach: Smallint; var var_: OleVariant); dispid 13;
    procedure Refresh(bErase: WordBool); dispid 14;
    procedure Rotate(bClockWise: WordBool); dispid 15;
    procedure Flip(bHorizontal: WordBool); dispid 16;
    property URL: WideString dispid 40;
    property URLTarget: WideString dispid 41;
  end;

// *********************************************************************//
// Interface: IAnnBalloon2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EF600D64-358F-11D1-8FD4-00AA00BD091C}
// *********************************************************************//
  IAnnBalloon2 = interface(IAnnText2)
    ['{EF600D64-358F-11D1-8FD4-00AA00BD091C}']
    function  Get_ArrowFactor: Smallint; safecall;
    procedure Set_ArrowFactor(retval: Smallint); safecall;
    function  Get_Radius: Smallint; safecall;
    procedure Set_Radius(retval: Smallint); safecall;
    function  Get_Shadow: Smallint; safecall;
    procedure Set_Shadow(retval: Smallint); safecall;
    function  Get_ArrowX: Smallint; safecall;
    procedure Set_ArrowX(retval: Smallint); safecall;
    function  Get_ArrowY: Smallint; safecall;
    procedure Set_ArrowY(retval: Smallint); safecall;
    function  Get_TailCorner: BallonTail; safecall;
    procedure Set_TailCorner(retval: BallonTail); safecall;
    function  Get_HeadStyle: ArrowStyle; safecall;
    procedure Set_HeadStyle(retval: ArrowStyle); safecall;
    function  Get_HeadSize: Smallint; safecall;
    procedure Set_HeadSize(retval: Smallint); safecall;
    function  Get_HeadWidth: Smallint; safecall;
    procedure Set_HeadWidth(retval: Smallint); safecall;
    function  Get_UseArrow: WordBool; safecall;
    procedure Set_UseArrow(pVal: WordBool); safecall;
    property ArrowFactor: Smallint read Get_ArrowFactor write Set_ArrowFactor;
    property Radius: Smallint read Get_Radius write Set_Radius;
    property Shadow: Smallint read Get_Shadow write Set_Shadow;
    property ArrowX: Smallint read Get_ArrowX write Set_ArrowX;
    property ArrowY: Smallint read Get_ArrowY write Set_ArrowY;
    property TailCorner: BallonTail read Get_TailCorner write Set_TailCorner;
    property HeadStyle: ArrowStyle read Get_HeadStyle write Set_HeadStyle;
    property HeadSize: Smallint read Get_HeadSize write Set_HeadSize;
    property HeadWidth: Smallint read Get_HeadWidth write Set_HeadWidth;
    property UseArrow: WordBool read Get_UseArrow write Set_UseArrow;
  end;

// *********************************************************************//
// DispIntf:  IAnnBalloon2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EF600D64-358F-11D1-8FD4-00AA00BD091C}
// *********************************************************************//
  IAnnBalloon2Disp = dispinterface
    ['{EF600D64-358F-11D1-8FD4-00AA00BD091C}']
    property ArrowFactor: Smallint dispid 22;
    property Radius: Smallint dispid 23;
    property Shadow: Smallint dispid 24;
    property ArrowX: Smallint dispid 25;
    property ArrowY: Smallint dispid 26;
    property TailCorner: BallonTail dispid 27;
    property HeadStyle: ArrowStyle dispid 28;
    property HeadSize: Smallint dispid 29;
    property HeadWidth: Smallint dispid 30;
    property UseArrow: WordBool dispid 31;
    property Text: WideString dispid 17;
    property Font: IFontDisp dispid 18;
    property Align: Smallint dispid 19;
    property Orientation: TextOrient dispid 20;
    procedure SizeToFit; dispid 21;
    property AnnObjInternal: IAnnObjInternal readonly dispid 42;
    property ObjectType: OleVariant readonly dispid 1;
    property Color: OLE_COLOR dispid 2;
    property BkColor: OLE_COLOR dispid 3;
    property BorderStyle: LineStyle dispid 4;
    property BorderWidth: Smallint dispid 5;
    property Left: Smallint dispid 6;
    property Top: Smallint dispid 7;
    property Width: Smallint dispid 8;
    property Height: Smallint dispid 9;
    property Tag: Integer dispid 10;
    property AllowMove: WordBool dispid 11;
    property AllowModify: WordBool dispid 12;
    procedure Attach(nAttach: Smallint; var var_: OleVariant); dispid 13;
    procedure Refresh(bErase: WordBool); dispid 14;
    procedure Rotate(bClockWise: WordBool); dispid 15;
    procedure Flip(bHorizontal: WordBool); dispid 16;
    property URL: WideString dispid 40;
    property URLTarget: WideString dispid 41;
  end;

// *********************************************************************//
// Interface: IAnnBalloon
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EF600D84-358F-11D1-8FD4-00AA00BD091C}
// *********************************************************************//
  IAnnBalloon = interface(IAnnText)
    ['{EF600D84-358F-11D1-8FD4-00AA00BD091C}']
    function  Get_ArrowFactor: Smallint; safecall;
    procedure Set_ArrowFactor(retval: Smallint); safecall;
    function  Get_Radius: Smallint; safecall;
    procedure Set_Radius(retval: Smallint); safecall;
    function  Get_Shadow: Smallint; safecall;
    procedure Set_Shadow(retval: Smallint); safecall;
    function  Get_ArrowX: Smallint; safecall;
    procedure Set_ArrowX(retval: Smallint); safecall;
    function  Get_ArrowY: Smallint; safecall;
    procedure Set_ArrowY(retval: Smallint); safecall;
    function  Get_TailCorner: BallonTail; safecall;
    procedure Set_TailCorner(retval: BallonTail); safecall;
    function  Get_HeadStyle: ArrowStyle; safecall;
    procedure Set_HeadStyle(retval: ArrowStyle); safecall;
    function  Get_HeadSize: Smallint; safecall;
    procedure Set_HeadSize(retval: Smallint); safecall;
    function  Get_HeadWidth: Smallint; safecall;
    procedure Set_HeadWidth(retval: Smallint); safecall;
    function  Get_UseArrow: WordBool; safecall;
    procedure Set_UseArrow(pVal: WordBool); safecall;
    property ArrowFactor: Smallint read Get_ArrowFactor write Set_ArrowFactor;
    property Radius: Smallint read Get_Radius write Set_Radius;
    property Shadow: Smallint read Get_Shadow write Set_Shadow;
    property ArrowX: Smallint read Get_ArrowX write Set_ArrowX;
    property ArrowY: Smallint read Get_ArrowY write Set_ArrowY;
    property TailCorner: BallonTail read Get_TailCorner write Set_TailCorner;
    property HeadStyle: ArrowStyle read Get_HeadStyle write Set_HeadStyle;
    property HeadSize: Smallint read Get_HeadSize write Set_HeadSize;
    property HeadWidth: Smallint read Get_HeadWidth write Set_HeadWidth;
    property UseArrow: WordBool read Get_UseArrow write Set_UseArrow;
  end;

// *********************************************************************//
// DispIntf:  IAnnBalloonDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EF600D84-358F-11D1-8FD4-00AA00BD091C}
// *********************************************************************//
  IAnnBalloonDisp = dispinterface
    ['{EF600D84-358F-11D1-8FD4-00AA00BD091C}']
    property ArrowFactor: Smallint dispid 22;
    property Radius: Smallint dispid 23;
    property Shadow: Smallint dispid 24;
    property ArrowX: Smallint dispid 25;
    property ArrowY: Smallint dispid 26;
    property TailCorner: BallonTail dispid 27;
    property HeadStyle: ArrowStyle dispid 28;
    property HeadSize: Smallint dispid 29;
    property HeadWidth: Smallint dispid 30;
    property UseArrow: WordBool dispid 31;
    property Text: WideString dispid 17;
    property Font: IFontDisp dispid 18;
    property Align: Smallint dispid 19;
    property Orientation: TextOrient dispid 20;
    procedure SizeToFit; dispid 21;
    property ObjectType: OleVariant readonly dispid 1;
    property Color: OLE_COLOR dispid 2;
    property BkColor: OLE_COLOR dispid 3;
    property BorderStyle: LineStyle dispid 4;
    property BorderWidth: Smallint dispid 5;
    property Left: Smallint dispid 6;
    property Top: Smallint dispid 7;
    property Width: Smallint dispid 8;
    property Height: Smallint dispid 9;
    property Tag: Integer dispid 10;
    property AllowMove: WordBool dispid 11;
    property AllowModify: WordBool dispid 12;
    procedure Attach(nAttach: Smallint; var var_: OleVariant); dispid 13;
    procedure Refresh(bErase: WordBool); dispid 14;
    procedure Rotate(bClockWise: WordBool); dispid 15;
    procedure Flip(bHorizontal: WordBool); dispid 16;
    property URL: WideString dispid 40;
    property URLTarget: WideString dispid 41;
  end;

// *********************************************************************//
// Interface: IAnnPicture2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EF600D67-358F-11D1-8FD4-00AA00BD091C}
// *********************************************************************//
  IAnnPicture2 = interface(IAnnObject2)
    ['{EF600D67-358F-11D1-8FD4-00AA00BD091C}']
    function  Get_Mode: Smallint; safecall;
    procedure Set_Mode(pVal: Smallint); safecall;
    procedure LoadFromFile(s: PChar); safecall;
    function  Get_Picture: IPictureDisp; safecall;
    procedure Set_Picture(const pVal: IPictureDisp); safecall;
    procedure LoadPicture(const s: WideString); safecall;
    property Mode: Smallint read Get_Mode write Set_Mode;
    property Picture: IPictureDisp read Get_Picture write Set_Picture;
  end;

// *********************************************************************//
// DispIntf:  IAnnPicture2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EF600D67-358F-11D1-8FD4-00AA00BD091C}
// *********************************************************************//
  IAnnPicture2Disp = dispinterface
    ['{EF600D67-358F-11D1-8FD4-00AA00BD091C}']
    property Mode: Smallint dispid 17;
    procedure LoadFromFile(s: {??PChar} OleVariant); dispid 18;
    property Picture: IPictureDisp dispid 19;
    procedure LoadPicture(const s: WideString); dispid 20;
    property AnnObjInternal: IAnnObjInternal readonly dispid 42;
    property ObjectType: OleVariant readonly dispid 1;
    property Color: OLE_COLOR dispid 2;
    property BkColor: OLE_COLOR dispid 3;
    property BorderStyle: LineStyle dispid 4;
    property BorderWidth: Smallint dispid 5;
    property Left: Smallint dispid 6;
    property Top: Smallint dispid 7;
    property Width: Smallint dispid 8;
    property Height: Smallint dispid 9;
    property Tag: Integer dispid 10;
    property AllowMove: WordBool dispid 11;
    property AllowModify: WordBool dispid 12;
    procedure Attach(nAttach: Smallint; var var_: OleVariant); dispid 13;
    procedure Refresh(bErase: WordBool); dispid 14;
    procedure Rotate(bClockWise: WordBool); dispid 15;
    procedure Flip(bHorizontal: WordBool); dispid 16;
    property URL: WideString dispid 40;
    property URLTarget: WideString dispid 41;
  end;

// *********************************************************************//
// Interface: IAnnPicture
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EF600D87-358F-11D1-8FD4-00AA00BD091C}
// *********************************************************************//
  IAnnPicture = interface(IAnnObject)
    ['{EF600D87-358F-11D1-8FD4-00AA00BD091C}']
    function  Get_Mode: Smallint; safecall;
    procedure Set_Mode(pVal: Smallint); safecall;
    procedure LoadFromFile(s: PChar); safecall;
    function  Get_Picture: IPictureDisp; safecall;
    procedure Set_Picture(const pVal: IPictureDisp); safecall;
    procedure LoadPicture(const s: WideString); safecall;
    property Mode: Smallint read Get_Mode write Set_Mode;
    property Picture: IPictureDisp read Get_Picture write Set_Picture;
  end;

// *********************************************************************//
// DispIntf:  IAnnPictureDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EF600D87-358F-11D1-8FD4-00AA00BD091C}
// *********************************************************************//
  IAnnPictureDisp = dispinterface
    ['{EF600D87-358F-11D1-8FD4-00AA00BD091C}']
    property Mode: Smallint dispid 17;
    procedure LoadFromFile(s: {??PChar} OleVariant); dispid 18;
    property Picture: IPictureDisp dispid 19;
    procedure LoadPicture(const s: WideString); dispid 20;
    property ObjectType: OleVariant readonly dispid 1;
    property Color: OLE_COLOR dispid 2;
    property BkColor: OLE_COLOR dispid 3;
    property BorderStyle: LineStyle dispid 4;
    property BorderWidth: Smallint dispid 5;
    property Left: Smallint dispid 6;
    property Top: Smallint dispid 7;
    property Width: Smallint dispid 8;
    property Height: Smallint dispid 9;
    property Tag: Integer dispid 10;
    property AllowMove: WordBool dispid 11;
    property AllowModify: WordBool dispid 12;
    procedure Attach(nAttach: Smallint; var var_: OleVariant); dispid 13;
    procedure Refresh(bErase: WordBool); dispid 14;
    procedure Rotate(bClockWise: WordBool); dispid 15;
    procedure Flip(bHorizontal: WordBool); dispid 16;
    property URL: WideString dispid 40;
    property URLTarget: WideString dispid 41;
  end;

// *********************************************************************//
// Interface: IAnnPolygon2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EF600D6E-358F-11D1-8FD4-00AA00BD091C}
// *********************************************************************//
  IAnnPolygon2 = interface(IAnnObject2)
    ['{EF600D6E-358F-11D1-8FD4-00AA00BD091C}']
    function  Get_NumVertex: Smallint; safecall;
    function  Get_FillMode: PolyFillMode; safecall;
    procedure Set_FillMode(retval: PolyFillMode); safecall;
    procedure SetVertex(nIndex: Smallint; x: Smallint; y: Smallint); safecall;
    procedure GetVertex(nIndex: Smallint; out x: Smallint; out y: Smallint); safecall;
    procedure RecalcBounds; safecall;
    function  Get_Closed: WordBool; safecall;
    procedure Set_Closed(retval: WordBool); safecall;
    function  GetVertexX(nIndex: Smallint): Smallint; safecall;
    function  GetVertexY(nIndex: Smallint): Smallint; safecall;
    property NumVertex: Smallint read Get_NumVertex;
    property FillMode: PolyFillMode read Get_FillMode write Set_FillMode;
    property Closed: WordBool read Get_Closed write Set_Closed;
  end;

// *********************************************************************//
// DispIntf:  IAnnPolygon2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EF600D6E-358F-11D1-8FD4-00AA00BD091C}
// *********************************************************************//
  IAnnPolygon2Disp = dispinterface
    ['{EF600D6E-358F-11D1-8FD4-00AA00BD091C}']
    property NumVertex: Smallint readonly dispid 22;
    property FillMode: PolyFillMode dispid 23;
    procedure SetVertex(nIndex: Smallint; x: Smallint; y: Smallint); dispid 24;
    procedure GetVertex(nIndex: Smallint; out x: Smallint; out y: Smallint); dispid 25;
    procedure RecalcBounds; dispid 26;
    property Closed: WordBool dispid 27;
    function  GetVertexX(nIndex: Smallint): Smallint; dispid 28;
    function  GetVertexY(nIndex: Smallint): Smallint; dispid 29;
    property AnnObjInternal: IAnnObjInternal readonly dispid 42;
    property ObjectType: OleVariant readonly dispid 1;
    property Color: OLE_COLOR dispid 2;
    property BkColor: OLE_COLOR dispid 3;
    property BorderStyle: LineStyle dispid 4;
    property BorderWidth: Smallint dispid 5;
    property Left: Smallint dispid 6;
    property Top: Smallint dispid 7;
    property Width: Smallint dispid 8;
    property Height: Smallint dispid 9;
    property Tag: Integer dispid 10;
    property AllowMove: WordBool dispid 11;
    property AllowModify: WordBool dispid 12;
    procedure Attach(nAttach: Smallint; var var_: OleVariant); dispid 13;
    procedure Refresh(bErase: WordBool); dispid 14;
    procedure Rotate(bClockWise: WordBool); dispid 15;
    procedure Flip(bHorizontal: WordBool); dispid 16;
    property URL: WideString dispid 40;
    property URLTarget: WideString dispid 41;
  end;

// *********************************************************************//
// Interface: IAnnPolygon
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EF600D8E-358F-11D1-8FD4-00AA00BD091C}
// *********************************************************************//
  IAnnPolygon = interface(IAnnObject)
    ['{EF600D8E-358F-11D1-8FD4-00AA00BD091C}']
    function  Get_NumVertex: Smallint; safecall;
    function  Get_FillMode: PolyFillMode; safecall;
    procedure Set_FillMode(retval: PolyFillMode); safecall;
    procedure SetVertex(nIndex: Smallint; x: Smallint; y: Smallint); safecall;
    procedure GetVertex(nIndex: Smallint; out x: Smallint; out y: Smallint); safecall;
    procedure RecalcBounds; safecall;
    function  Get_Closed: WordBool; safecall;
    procedure Set_Closed(retval: WordBool); safecall;
    function  GetVertexX(nIndex: Smallint): Smallint; safecall;
    function  GetVertexY(nIndex: Smallint): Smallint; safecall;
    property NumVertex: Smallint read Get_NumVertex;
    property FillMode: PolyFillMode read Get_FillMode write Set_FillMode;
    property Closed: WordBool read Get_Closed write Set_Closed;
  end;

// *********************************************************************//
// DispIntf:  IAnnPolygonDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EF600D8E-358F-11D1-8FD4-00AA00BD091C}
// *********************************************************************//
  IAnnPolygonDisp = dispinterface
    ['{EF600D8E-358F-11D1-8FD4-00AA00BD091C}']
    property NumVertex: Smallint readonly dispid 22;
    property FillMode: PolyFillMode dispid 23;
    procedure SetVertex(nIndex: Smallint; x: Smallint; y: Smallint); dispid 24;
    procedure GetVertex(nIndex: Smallint; out x: Smallint; out y: Smallint); dispid 25;
    procedure RecalcBounds; dispid 26;
    property Closed: WordBool dispid 27;
    function  GetVertexX(nIndex: Smallint): Smallint; dispid 28;
    function  GetVertexY(nIndex: Smallint): Smallint; dispid 29;
    property ObjectType: OleVariant readonly dispid 1;
    property Color: OLE_COLOR dispid 2;
    property BkColor: OLE_COLOR dispid 3;
    property BorderStyle: LineStyle dispid 4;
    property BorderWidth: Smallint dispid 5;
    property Left: Smallint dispid 6;
    property Top: Smallint dispid 7;
    property Width: Smallint dispid 8;
    property Height: Smallint dispid 9;
    property Tag: Integer dispid 10;
    property AllowMove: WordBool dispid 11;
    property AllowModify: WordBool dispid 12;
    procedure Attach(nAttach: Smallint; var var_: OleVariant); dispid 13;
    procedure Refresh(bErase: WordBool); dispid 14;
    procedure Rotate(bClockWise: WordBool); dispid 15;
    procedure Flip(bHorizontal: WordBool); dispid 16;
    property URL: WideString dispid 40;
    property URLTarget: WideString dispid 41;
  end;

// *********************************************************************//
// The Class CoAnnotationX provides a Create and CreateRemote method to          
// create instances of the default interface IAnnList exposed by              
// the CoClass AnnotationX. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoAnnotationX = class
    class function Create: IAnnList;
    class function CreateRemote(const MachineName: string): IAnnList;
  end;

// *********************************************************************//
// The Class CoAnnRect provides a Create and CreateRemote method to          
// create instances of the default interface IAnnRect exposed by              
// the CoClass AnnRect. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoAnnRect = class
    class function Create: IAnnRect;
    class function CreateRemote(const MachineName: string): IAnnRect;
  end;

// *********************************************************************//
// The Class CoAnnCircle provides a Create and CreateRemote method to          
// create instances of the default interface IAnnCircle exposed by              
// the CoClass AnnCircle. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoAnnCircle = class
    class function Create: IAnnCircle;
    class function CreateRemote(const MachineName: string): IAnnCircle;
  end;

// *********************************************************************//
// The Class CoAnnArrow provides a Create and CreateRemote method to          
// create instances of the default interface IAnnArrow2 exposed by              
// the CoClass AnnArrow. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoAnnArrow = class
    class function Create: IAnnArrow2;
    class function CreateRemote(const MachineName: string): IAnnArrow2;
  end;

// *********************************************************************//
// The Class CoAnnArc provides a Create and CreateRemote method to          
// create instances of the default interface IAnnArc exposed by              
// the CoClass AnnArc. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoAnnArc = class
    class function Create: IAnnArc;
    class function CreateRemote(const MachineName: string): IAnnArc;
  end;

// *********************************************************************//
// The Class CoAnnText provides a Create and CreateRemote method to          
// create instances of the default interface IAnnText2 exposed by              
// the CoClass AnnText. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoAnnText = class
    class function Create: IAnnText2;
    class function CreateRemote(const MachineName: string): IAnnText2;
  end;

// *********************************************************************//
// The Class CoAnnBalloon provides a Create and CreateRemote method to          
// create instances of the default interface IAnnBalloon2 exposed by              
// the CoClass AnnBalloon. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoAnnBalloon = class
    class function Create: IAnnBalloon2;
    class function CreateRemote(const MachineName: string): IAnnBalloon2;
  end;

// *********************************************************************//
// The Class CoAnnPicture provides a Create and CreateRemote method to          
// create instances of the default interface IAnnPicture2 exposed by              
// the CoClass AnnPicture. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoAnnPicture = class
    class function Create: IAnnPicture2;
    class function CreateRemote(const MachineName: string): IAnnPicture2;
  end;

// *********************************************************************//
// The Class CoAnnGroup provides a Create and CreateRemote method to          
// create instances of the default interface IAnnGroup exposed by              
// the CoClass AnnGroup. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoAnnGroup = class
    class function Create: IAnnGroup;
    class function CreateRemote(const MachineName: string): IAnnGroup;
  end;

// *********************************************************************//
// The Class CoAnnPolygon provides a Create and CreateRemote method to          
// create instances of the default interface IAnnPolygon2 exposed by              
// the CoClass AnnPolygon. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoAnnPolygon = class
    class function Create: IAnnPolygon2;
    class function CreateRemote(const MachineName: string): IAnnPolygon2;
  end;

// *********************************************************************//
// The Class CoAnnGeneralPage provides a Create and CreateRemote method to          
// create instances of the default interface IUnknown exposed by              
// the CoClass AnnGeneralPage. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoAnnGeneralPage = class
    class function Create: IUnknown;
    class function CreateRemote(const MachineName: string): IUnknown;
  end;

// *********************************************************************//
// The Class CoAnnArrowPage provides a Create and CreateRemote method to          
// create instances of the default interface IUnknown exposed by              
// the CoClass AnnArrowPage. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoAnnArrowPage = class
    class function Create: IUnknown;
    class function CreateRemote(const MachineName: string): IUnknown;
  end;

// *********************************************************************//
// The Class CoAnnPicturePage provides a Create and CreateRemote method to          
// create instances of the default interface IUnknown exposed by              
// the CoClass AnnPicturePage. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoAnnPicturePage = class
    class function Create: IUnknown;
    class function CreateRemote(const MachineName: string): IUnknown;
  end;

// *********************************************************************//
// The Class CoAnnTextPage provides a Create and CreateRemote method to          
// create instances of the default interface IUnknown exposed by              
// the CoClass AnnTextPage. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoAnnTextPage = class
    class function Create: IUnknown;
    class function CreateRemote(const MachineName: string): IUnknown;
  end;

// *********************************************************************//
// The Class CoAnnBalloonPage provides a Create and CreateRemote method to          
// create instances of the default interface IUnknown exposed by              
// the CoClass AnnBalloonPage. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoAnnBalloonPage = class
    class function Create: IUnknown;
    class function CreateRemote(const MachineName: string): IUnknown;
  end;

implementation

uses ComObj;

class function CoAnnotationX.Create: IAnnList;
begin
  Result := CreateComObject(CLASS_AnnotationX) as IAnnList;
end;

class function CoAnnotationX.CreateRemote(const MachineName: string): IAnnList;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_AnnotationX) as IAnnList;
end;

class function CoAnnRect.Create: IAnnRect;
begin
  Result := CreateComObject(CLASS_AnnRect) as IAnnRect;
end;

class function CoAnnRect.CreateRemote(const MachineName: string): IAnnRect;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_AnnRect) as IAnnRect;
end;

class function CoAnnCircle.Create: IAnnCircle;
begin
  Result := CreateComObject(CLASS_AnnCircle) as IAnnCircle;
end;

class function CoAnnCircle.CreateRemote(const MachineName: string): IAnnCircle;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_AnnCircle) as IAnnCircle;
end;

class function CoAnnArrow.Create: IAnnArrow2;
begin
  Result := CreateComObject(CLASS_AnnArrow) as IAnnArrow2;
end;

class function CoAnnArrow.CreateRemote(const MachineName: string): IAnnArrow2;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_AnnArrow) as IAnnArrow2;
end;

class function CoAnnArc.Create: IAnnArc;
begin
  Result := CreateComObject(CLASS_AnnArc) as IAnnArc;
end;

class function CoAnnArc.CreateRemote(const MachineName: string): IAnnArc;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_AnnArc) as IAnnArc;
end;

class function CoAnnText.Create: IAnnText2;
begin
  Result := CreateComObject(CLASS_AnnText) as IAnnText2;
end;

class function CoAnnText.CreateRemote(const MachineName: string): IAnnText2;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_AnnText) as IAnnText2;
end;

class function CoAnnBalloon.Create: IAnnBalloon2;
begin
  Result := CreateComObject(CLASS_AnnBalloon) as IAnnBalloon2;
end;

class function CoAnnBalloon.CreateRemote(const MachineName: string): IAnnBalloon2;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_AnnBalloon) as IAnnBalloon2;
end;

class function CoAnnPicture.Create: IAnnPicture2;
begin
  Result := CreateComObject(CLASS_AnnPicture) as IAnnPicture2;
end;

class function CoAnnPicture.CreateRemote(const MachineName: string): IAnnPicture2;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_AnnPicture) as IAnnPicture2;
end;

class function CoAnnGroup.Create: IAnnGroup;
begin
  Result := CreateComObject(CLASS_AnnGroup) as IAnnGroup;
end;

class function CoAnnGroup.CreateRemote(const MachineName: string): IAnnGroup;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_AnnGroup) as IAnnGroup;
end;

class function CoAnnPolygon.Create: IAnnPolygon2;
begin
  Result := CreateComObject(CLASS_AnnPolygon) as IAnnPolygon2;
end;

class function CoAnnPolygon.CreateRemote(const MachineName: string): IAnnPolygon2;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_AnnPolygon) as IAnnPolygon2;
end;

class function CoAnnGeneralPage.Create: IUnknown;
begin
  Result := CreateComObject(CLASS_AnnGeneralPage) as IUnknown;
end;

class function CoAnnGeneralPage.CreateRemote(const MachineName: string): IUnknown;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_AnnGeneralPage) as IUnknown;
end;

class function CoAnnArrowPage.Create: IUnknown;
begin
  Result := CreateComObject(CLASS_AnnArrowPage) as IUnknown;
end;

class function CoAnnArrowPage.CreateRemote(const MachineName: string): IUnknown;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_AnnArrowPage) as IUnknown;
end;

class function CoAnnPicturePage.Create: IUnknown;
begin
  Result := CreateComObject(CLASS_AnnPicturePage) as IUnknown;
end;

class function CoAnnPicturePage.CreateRemote(const MachineName: string): IUnknown;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_AnnPicturePage) as IUnknown;
end;

class function CoAnnTextPage.Create: IUnknown;
begin
  Result := CreateComObject(CLASS_AnnTextPage) as IUnknown;
end;

class function CoAnnTextPage.CreateRemote(const MachineName: string): IUnknown;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_AnnTextPage) as IUnknown;
end;

class function CoAnnBalloonPage.Create: IUnknown;
begin
  Result := CreateComObject(CLASS_AnnBalloonPage) as IUnknown;
end;

class function CoAnnBalloonPage.CreateRemote(const MachineName: string): IUnknown;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_AnnBalloonPage) as IUnknown;
end;

end.
