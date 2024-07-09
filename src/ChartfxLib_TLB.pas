unit ChartfxLib_TLB;

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
// File generated on 6/29/2002 9:35:02 PM from Type Library described below.

// ************************************************************************ //
// Type Lib: C:\Program Files\Common Files\Software FX Shared\Cfx4032.ocx (1)
// IID\LCID: {8996B0A4-D7BE-101B-8650-00AA003A5593}\0
// Helpfile: C:\Program Files\Common Files\Software FX Shared\ChartFX_API.chm
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINNT\System32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINNT\System32\STDVCL40.DLL)
//   (3) v1.0 SfxBar, (C:\Program Files\Common Files\Software FX Shared\SfxBar.dll)
// Errors:
//   Hint: Member 'Type' of 'IChartFX' changed to 'Type_'
//   Hint: Member 'Const' of 'IChartFX' changed to 'Const_'
//   Hint: Member 'Label' of 'ICfxAxis' changed to 'Label_'
//   Hint: Member 'Label' of 'ICfxConst' changed to 'Label_'
//   Hint: Member 'To' of 'ICfxStripe' changed to 'To_'
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
  ChartfxLibMajorVersion = 4;
  ChartfxLibMinorVersion = 0;

  LIBID_ChartfxLib: TGUID = '{8996B0A4-D7BE-101B-8650-00AA003A5593}';

  DIID__ChartFXEvents: TGUID = '{F3743560-454E-11D1-8FD4-00AA00BD091C}';
  IID_IChartFX: TGUID = '{608E8B10-3690-11D1-8FD4-00AA00BD091C}';
  CLASS_ChartFX: TGUID = '{608E8B11-3690-11D1-8FD4-00AA00BD091C}';
  IID_ICfxSeriesEnum: TGUID = '{1D3266D1-745C-11D0-9223-00A0244D2920}';
  IID_ICfxSeries: TGUID = '{1D3266C1-745C-11D0-9223-00A0244D2920}';
  IID_ICfxAxisEnum: TGUID = '{1D3266D2-745C-11D0-9223-00A0244D2920}';
  IID_ICfxAxis: TGUID = '{1D3266C2-745C-11D0-9223-00A0244D2920}';
  IID_ICfxConstEnum: TGUID = '{1D3266D3-745C-11D0-9223-00A0244D2920}';
  IID_ICfxConst: TGUID = '{1D3266C3-745C-11D0-9223-00A0244D2920}';
  IID_ICfxStripeEnum: TGUID = '{1D3266D4-745C-11D0-9223-00A0244D2920}';
  IID_ICfxStripe: TGUID = '{1D3266C4-745C-11D0-9223-00A0244D2920}';
  IID_ICfxLegendBox: TGUID = '{8A906AC2-BE4B-11D1-B134-00A0244D2920}';
  IID_ICfxPalette: TGUID = '{A24604BA-C27F-11D1-9C4E-00A0244D2920}';
  IID_ICfxDataEditor: TGUID = '{EDBC92F0-B34C-11D1-B134-00A0244D2920}';
  IID_ICfxPrinter: TGUID = '{D5688691-E6B0-11D1-89B0-00AA00BD091C}';
  IID_DataSource: TGUID = '{7C0FFAB3-CD84-11D0-949A-00A0C91110ED}';
  IID__VBDataSource: TGUID = '{9F6AA700-D188-11CD-AD48-00AA003C9CB6}';
  CLASS_GeneralPage: TGUID = '{179B6120-3BEA-11D1-8FD4-00AA00BD091C}';
  CLASS_SeriesPage: TGUID = '{179B6121-3BEA-11D1-8FD4-00AA00BD091C}';
  CLASS_AxesPage: TGUID = '{179B6122-3BEA-11D1-8FD4-00AA00BD091C}';
  CLASS_Page3D: TGUID = '{179B6123-3BEA-11D1-8FD4-00AA00BD091C}';
  CLASS_ScalePage: TGUID = '{179B6125-3BEA-11D1-8FD4-00AA00BD091C}';
  CLASS_LabelsPage: TGUID = '{179B6126-3BEA-11D1-8FD4-00AA00BD091C}';
  CLASS_GridLinesPage: TGUID = '{179B6127-3BEA-11D1-8FD4-00AA00BD091C}';
  CLASS_ConstantStripesPage: TGUID = '{179B6128-3BEA-11D1-8FD4-00AA00BD091C}';
  IID_ICfxEnum: TGUID = '{5DECA4E0-3B4F-11D1-8FD4-00AA00BD091C}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum CfxColors
type
  CfxColors = TOleEnum;
const
  CHART_PALETTECOLOR = $01000000;
  CHART_SYSCOLOR = $80000000;
  CHART_TRANSPARENT = $40000000;

// Constants for enum CfxReturnCodes
type
  CfxReturnCodes = TOleEnum;
const
  CR_SUCCESS = $00000000;
  CR_NEW = $00000001;
  CR_OUTRANGE = $FFFFFFFF;
  CR_NOOPEN = $FFFFFFFE;
  CR_FAIL = $FFFFFFFD;
  CR_INVALID = $FFFFFFFC;
  CR_BADCODE = $FFFFFFFB;
  CR_KEEPALL = $00000002;
  CR_LOSTLAST = $00000003;

// Constants for enum CfxHiLow
type
  CfxHiLow = TOleEnum;
const
  HLC_LOW = $00000000;
  HLC_CLOSE = $00000001;
  HLC_HIGH = $00000002;
  OHLC_LOW = $00000000;
  OHLC_OPEN = $00000001;
  OHLC_CLOSE = $00000002;
  OHLC_HIGH = $00000003;

// Constants for enum CfxFormat
type
  CfxFormat = TOleEnum;
const
  AF_NONE = $00000000;
  AF_NUMBER = $00000001;
  AF_CURRENCY = $00000002;
  AF_SCIENTIFIC = $00000003;
  AF_PERCENTAGE = $00000004;
  AF_DATE = $00000005;
  AF_LONGDATE = $00000006;
  AF_TIME = $00000007;
  AF_DATETIME = $00000008;
  AF_CUSTOM = $00008000;

// Constants for enum CfxGallery
type
  CfxGallery = TOleEnum;
const
  LINES = $00000001;
  BAR = $00000002;
  CURVE = $00000003;
  SCATTER = $00000004;
  PIE = $00000005;
  AREA = $00000006;
  PARETO = $00000007;
  STEP = $00000008;
  HILOWCLOSE = $00000009;
  SURFACE = $0000000A;
  RADAR = $0000000B;
  CUBE = $0000000C;
  DOUGHNUT = $0000000D;
  PYRAMID = $0000000E;
  BUBBLE = $0000000F;
  OPENHILOWCLOSE = $00000010;
  CANDLESTICK = $00000011;
  CONTOUR = $00000012;
  CURVEAREA = $00000013;
  GANTT = $00000014;
  SPLINE = $00000003;
  POLAR = $0000000B;

// Constants for enum CfxType
type
  CfxType = TOleEnum;
const
  CT_3D = $00000100;
  CT_HORZ = $00000200;
  CT_TOOL = $00000400;
  CT_PALETTE = $00000800;
  CT_LEGEND = $00001000;
  CT_HIDESERIES = $00002000;
  CT_EACHBAR = $00010000;
  CT_CLUSTER = $00020000;
  CT_EDITOR = $00040000;
  CT_SHOWDATA = $00040000;
  CT_DLGGRAY = $00080000;
  CT_PATTERN = $00100000;
  CT_POINTLABELS = $00200000;
  CT_SHOWVALUES = $00200000;
  CT_MENU = $00400000;
  CT_SHOWLINES = $00800000;
  CT_NOAREALINE = $02000000;
  CT_NOBORDERS = $04000000;
  CT_COLORLINE = $04000000;
  CT_PIEVALUES = $08000000;
  CT_TRACKMOUSE = $10000000;
  CT_EVENSPACING = $20000000;
  CT_SERLEGEND = $40000000;
  CT_PAINTMARKER = $80000000;

// Constants for enum CfxStyle
type
  CfxStyle = TOleEnum;
const
  CS_TIPS = $00000001;
  CS_MENUSONDEMAND = $00000002;
  CS_ALLOWDRAG = $00000004;
  CS_SCROLLBARS = $00000008;
  CS_CHANGESTEP = $00000100;
  CS_GALLERY = $00000400;
  CS_MULTITYPE = $00000800;
  CS_3D = $00002000;
  CS_SCALE = $00020000;
  CS_TITLES = $00040000;
  CS_FONTS = $00080000;
  CS_EDITABLE = $00100000;
  CS_FILEEXPORT = $00200000;
  CS_FILEIMPORT = $00400000;
  CS_SCROLLABLE = $00800000;
  CS_PRINTABLE = $01000000;
  CS_3DVIEW = $02000000;
  CS_GRID = $04000000;
  CS_RESIZEABLE = $08000000;
  CS_COPY = $20000000;
  CS_CLOSEABLE = $40000000;
  CS_LOGSCALE = $80000000;
  CS_ALL = $FFFFFFFF;

// Constants for enum CfxScheme
type
  CfxScheme = TOleEnum;
const
  CHART_CSSOLID = $00000000;
  CHART_CSBWPATTERN = $00000001;
  CHART_CSPATTERN = $00000002;
  CHART_CSBWHATCH = $00000003;
  CHART_CSHATCH = $00000004;

// Constants for enum CfxStacked
type
  CfxStacked = TOleEnum;
const
  CHART_NOSTACKED = $00000000;
  CHART_STACKED = $00000001;
  CHART_STACKED100 = $00000002;

// Constants for enum CfxGrid
type
  CfxGrid = TOleEnum;
const
  CHART_NOGRID = $00000000;
  CHART_HORZGRID = $00000001;
  CHART_VERTGRID = $00000002;
  CHART_BOTHGRID = $00000003;
  CHART_GRIDY2 = $00000004;

// Constants for enum CfxLineStyle
type
  CfxLineStyle = TOleEnum;
const
  CHART_SOLID = $00000000;
  CHART_DASH = $00000001;
  CHART_DOT = $00000002;
  CHART_DASHDOT = $00000003;
  CHART_DASHDOTDOT = $00000004;
  CHART_PS_TRANSPARENT = $00000000;

// Constants for enum CfxChartStatus
type
  CfxChartStatus = TOleEnum;
const
  CHART_GSVALUES = $00000001;
  CHART_GSLEGENDS = $00000002;
  CHART_GSCOLORS = $00000004;
  CHART_GSPATTERNS = $00000008;
  CHART_GSPALETTE = $00000010;
  CHART_GSPATTPAL = $00000020;
  CHART_GSREADTEMP = $00000040;
  CHART_GSREADFILE = $00000080;
  CHART_GSGALLERY = $00000100;
  CHART_GSOPTIONS = $00000200;

// Constants for enum CfxAxesStyle
type
  CfxAxesStyle = TOleEnum;
const
  CAS_NONE = $00000000;
  CAS_3DFRAME = $00000001;
  CAS_MATH = $00000002;
  CAS_FLATFRAME = $00000003;

// Constants for enum CfxFileMask
type
  CfxFileMask = TOleEnum;
const
  FMASK_GENERAL = $00000001;
  FMASK_FONTS = $00000002;
  FMASK_SCALE = $00000004;
  FMASK_TITLES = $00000008;
  FMASK_MULTI = $00000010;
  FMASK_COLORS = $00000020;
  FMASK_LABELS = $00000040;
  FMASK_SIZEDATA = $00000080;
  FMASK_DATA = $00000100;
  FMASK_ELEMENTS = $00000200;
  FMASK_TOOLS = $00000400;
  FMASK_EXTENSIONS = $00000800;
  FMASK_PRINTERINFO = $00001000;
  FMASK_PICTURES = $00002000;
  FMASK_TEMPLATE = $00000023;
  FMASK_ALL = $00003FFF;

// Constants for enum CfxPointType
type
  CfxPointType = TOleEnum;
const
  MK_NONE = $00000000;
  MK_RECT = $00000001;
  MK_CIRCLE = $00000002;
  MK_TRIANGLE = $00000003;
  MK_DIAMOND = $00000004;
  MK_MARBLE = $00000005;
  MK_HORZLINE = $00000006;
  MK_VERTLINE = $00000007;
  MK_CROSS = $00000008;
  MK_INVERTEDTRIANGLE = $00000009;
  MK_CUBE = $0000000A;
  MK_MANY = $0000000B;

// Constants for enum CfxBorderStyle
type
  CfxBorderStyle = TOleEnum;
const
  BORDER_NONE = $00000000;
  BORDER_SUNKENOUTER = $00000004;
  BORDER_SUNKENINNER = $00000005;
  BORDER_RAISEDOUTER = $00000006;
  BORDER_RAISEDINNER = $00000007;
  BORDER_FLAT = $00000008;
  BORDER_MONO = $00000009;
  BORDER_RAISED = $0000000A;
  BORDER_ETCHED = $0000000B;
  BORDER_BUMP = $0000000C;
  BORDER_SUNKEN = $0000000D;
  BORDER_SOFT = $00000200;

// Constants for enum CfxDataStyle
type
  CfxDataStyle = TOleEnum;
const
  CHART_DS_SERLEGEND = $00000001;
  CHART_DS_USETEXTASLEG = $00000002;
  CHART_DS_USEDATEASLEG = $00000004;
  CHART_DS_NOMINMAX = $00000008;
  CHART_DS_TRANSPOSE = $00000010;
  CHART_DS_USEBLOBTEXT = $00000020;
  CHART_DS_KEEPSERLEG = $00000040;
  CHART_DS_KEEPLEGEND = $00000080;
  CHART_DS_ALLOCHIDDEN = $00000100;

// Constants for enum CfxTypeEx
type
  CfxTypeEx = TOleEnum;
const
  CTE_SMOOTH = $00000002;
  CTE_SQUAREPIE = $00000004;
  CTE_NOLEGINVALIDATE = $00000008;
  CTE_ACTMINMAX = $00000010;
  CTE_NOTITLESHADOW = $00000020;
  CTE_CREATELEGENDS = $00000040;
  CTE_NOCROSS = $00000080;
  CTE_ONLYCHART = $00000200;
  CTE_PLAIN2DAXIS = $00000400;
  CTE_SIDEBYSIDE = $00000800;
  CTE_MONOCHROME = $00001000;
  CTE_USEPALETTE = $00002000;
  CTE_GETTIPDRAG = $00004000;
  CTE_MERGEPALETTE = $00008000;

// Constants for enum CfxStyleEx
type
  CfxStyleEx = TOleEnum;
const
  CSE_NOSEPARATE = $00000001;
  CSE_NOLASTPAGE = $00000002;
  CSE_WIN95TOP = $00000004;
  CSE_CHILDDESTROY = $00000008;
  CSE_EXPORTXVALUES = $00000010;
  CSE_FASTLEGENDS = $00000020;
  CSE_CONTEXTHELP = $00000040;

// Constants for enum CfxAlign
type
  CfxAlign = TOleEnum;
const
  LA_LEFT = $00000000;
  LA_RIGHT = $00000002;
  LA_CENTER = $00000006;
  LA_TOP = $00000000;
  LA_BOTTOM = $00000008;
  LA_BASELINE = $00000018;

// Constants for enum CfxRealTimeStyle
type
  CfxRealTimeStyle = TOleEnum;
const
  CRT_LOOPPOS = $00000001;
  CRT_NOWAITARROW = $00000002;

// Constants for enum CfxAxisIndex
type
  CfxAxisIndex = TOleEnum;
const
  AXIS_Y = $00000000;
  AXIS_Y2 = $00000001;
  AXIS_X = $00000002;
  AXIS_X2 = $00000003;
  AXIS_NUM = $00000004;

// Constants for enum CfxFontAttr
type
  CfxFontAttr = TOleEnum;
const
  CF_BOLD = $00000100;
  CF_ITALIC = $00000200;
  CF_UNDERLINE = $00000400;
  CF_STRIKEOUT = $00000800;
  CF_FDONTCARE = $00000000;
  CF_FROMAN = $00001000;
  CF_FSWISS = $00002000;
  CF_FMODERN = $00003000;
  CF_FSCRIPT = $00004000;
  CF_FDECORATIVE = $00005000;
  CF_ARIAL = $00000000;
  CF_COURIER = $00010000;
  CF_COURIERNEW = $00020000;
  CF_MSSANSERIF = $00030000;
  CF_MODERN = $00040000;
  CF_ROMAN = $00050000;
  CF_SCRIPT = $00060000;
  CF_SYMBOL = $00070000;
  CF_TIMES = $00080000;
  CF_TIMESNEWR = $00090000;
  CF_WINGDINGS = $000A0000;
  CF_SMALLFONTS = $000B0000;
  CF_TAHOMA = $000C0000;

// Constants for enum CfxAxisStyle
type
  CfxAxisStyle = TOleEnum;
const
  AS_HIDETEXT = $00000001;
  AS_NOTIFY = $00000002;
  AS_2LEVELS = $00000004;
  AS_SINGLELINE = $00000008;
  AS_BREAKZERO = $00000020;
  AS_HIDE = $00000040;
  AS_NOTCLIPPED = $00000080;
  AS_INTERLACED = $00000100;
  AS_CENTERED = $00000200;
  AS_ROTATETEXT = $00000400;
  AS_LONGTICK = $00000800;
  AS_AUTOSCALE = $00001000;
  AS_FORCEZERO = $00002000;
  AS_SHOWENDS = $00004000;
  AS_NOROUNDSTEP = $00008000;
  AS_IGNORELABELS = $00010000;
  AS_VISIBLERANGE = $00020000;
  AS_FORCEMLINE = $00040000;

// Constants for enum CfxTickStyle
type
  CfxTickStyle = TOleEnum;
const
  TS_NONE = $00000000;
  TS_OUTSIDE = $00000001;
  TS_INSIDE = $00000002;
  TS_CROSS = $00000003;
  TS_GRID = $00008000;

// Constants for enum CfxConstType
type
  CfxConstType = TOleEnum;
const
  CC_HIDETEXT = $00000001;
  CC_HIDE = $00000002;
  CC_RIGHTALIGNED = $00000004;
  CC_BACKONLY = $00000008;
  CC_COLORTEXT = $00000010;

// Constants for enum CfxLegendBoxFlag
type
  CfxLegendBoxFlag = TOleEnum;
const
  CHART_LWORDBREAK = $00000001;
  CHART_LSKIPEMPTY = $00000002;
  CHART_LSHOWMENU = $00000004;
  CHART_LOPTIONSDLG = $00000008;
  CHART_LRIGHTALIGN = $00000010;
  CHART_LNOCOLOR = $00000020;
  CHART_LINVERTED = $00000040;

// Constants for enum CfxScroll
type
  CfxScroll = TOleEnum;
const
  CSB_LINEUP = $00000000;
  CSB_LINELEFT = $00000000;
  CSB_LINEDOWN = $00000001;
  CSB_LINERIGHT = $00000001;
  CSB_PAGEUP = $00000002;
  CSB_PAGELEFT = $00000002;
  CSB_PAGEDOWN = $00000003;
  CSB_PAGERIGHT = $00000003;
  CSB_THUMBPOSITION = $00000004;
  CSB_THUMBTRACK = $00000005;
  CSB_TOP = $00000006;
  CSB_LEFT = $00000006;
  CSB_BOTTOM = $00000007;
  CSB_RIGHT = $00000007;
  CSB_ENDSCROLL = $00000008;

// Constants for enum CfxOrientation
type
  CfxOrientation = TOleEnum;
const
  ORIENTATION_DEFAULT = $00000000;
  ORIENTATION_PORTRAIT = $00000001;
  ORIENTATION_LANDSCAPE = $00000002;

// Constants for enum CfxPrintStyle
type
  CfxPrintStyle = TOleEnum;
const
  CHART_PRS_SCREENRESOLUTION = $00000001;
  CHART_PRS_FORCECOLORS = $00000002;
  CHART_PRS_SEPARATELEGENDS = $00000004;
  CHART_PRS_COMPRESS = $00000008;
  CHART_PRS_MONOCHROME = $00000010;
  CHART_PRS_BACKGROUND = $00000020;

// Constants for enum CfxTitle
type
  CfxTitle = TOleEnum;
const
  CHART_LEFTTIT = $00000000;
  CHART_RIGHTTIT = $00000001;
  CHART_TOPTIT = $00000002;
  CHART_BOTTOMTIT = $00000003;

// Constants for enum CfxFont
type
  CfxFont = TOleEnum;
const
  CHART_LEFTFT = $00000000;
  CHART_RIGHTFT = $00000001;
  CHART_TOPFT = $00000002;
  CHART_BOTTOMFT = $00000003;
  CHART_XLEGFT = $00000004;
  CHART_YLEGFT = $00000005;
  CHART_FIXEDFT = $00000006;
  CHART_LEGENDFT = $00000007;
  CHART_VALUESFT = $00000008;
  CHART_POINTFT = $00000009;
  CHART_Y2LEGFT = $0000000A;
  CHART_X2LEGFT = $0000000B;
  CHART_EDITORFT = $0000000C;

// Constants for enum CfxItem
type
  CfxItem = TOleEnum;
const
  CI_HORZGRID = $00000000;
  CI_VERTGRID = $00000001;
  CI_2DLINE = $00000002;
  CI_FIXED = $00000003;
  CI_LOOPPOS = $00000004;
  CI_HORZGRID2 = $00000005;

// Constants for enum CfxDataType
type
  CfxDataType = TOleEnum;
const
  CDT_DEFAULT = $00000000;
  CDT_LABEL = $00000001;
  CDT_VALUE = $00000002;
  CDT_XVALUE = $00000003;
  CDT_KEYLEGEND = $00000004;
  CDT_INIVALUE = $00000005;
  CDT_SERIES = $00000006;
  CDT_POINT = $00000007;
  CDT_NOTUSED = $FFFFFFFE;

// Constants for enum CfxCod
type
  CfxCod = TOleEnum;
const
  COD_VALUES = $00000001;
  COD_CONSTANTS = $00000002;
  COD_COLORS = $00000003;
  COD_STRIPES = $00000004;
  COD_INIVALUES = $00000005;
  COD_XVALUES = $00000006;
  COD_STATUSITEMS = $00000007;
  COD_SCROLLLEGEND = $00004000;
  COD_NOINVALIDATE = $00002000;
  COD_SMOOTH = $00001000;
  COD_REMOVE = $00000800;
  COD_ADDPOINTS = $00000400;
  COD_REALTIMESCROLL = $00000300;
  COD_REALTIME = $00000100;
  COD_RESETMINMAX = $00000080;
  COD_INSERTPOINTS = $00000040;
  COD_UNKNOWN = $FFFFFFFF;
  COD_UNCHANGE = $00000000;

// Constants for enum CfxClick
type
  CfxClick = TOleEnum;
const
  CHART_BALLOONCLK = $00000000;
  CHART_DIALOGCLK = $00000001;
  CHART_NONECLK = $00000002;
  CHART_MENUCLK = $00000003;
  CHART_PROPERTIESCLK = $00000004;

// Constants for enum CfxDialog
type
  CfxDialog = TOleEnum;
const
  CDIALOG_IMPORTFILE = $00007300;
  CDIALOG_EXPORTFILE = $00007301;
  CDIALOG_PRINT = $00007303;
  CDIALOG_PAGESETUP = $00007304;
  CDIALOG_ROTATE = $00007306;
  CDIALOG_OPTIONS = $0000730B;
  CDIALOG_ABOUT = $0000730E;
  CDIALOG_FONTS = $0000731A;
  CDIALOG_WRITETEMPLATE = $0000731D;
  CDIALOG_READTEMPLATE = $0000731E;
  CDIALOG_GENERAL = $00007401;
  CDIALOG_SERIES = $00007402;
  CDIALOG_SCALE = $00007403;
  CDIALOG_AXIS = $00007405;

// Constants for enum CfxLegend
type
  CfxLegend = TOleEnum;
const
  CHART_LEGEND = $00000000;
  CHART_SERLEG = $00000001;
  CHART_KEYLEG = $00000002;
  CHART_KEYSER = $00000003;
  CHART_FIXLEG = $00000004;
  CHART_YLEG = $00000005;

// Constants for enum CfxChartPaint
type
  CfxChartPaint = TOleEnum;
const
  CPAINT_BKGND = $00000002;
  CPAINT_PRINT = $00000001;

// Constants for enum CfxPaintInfo
type
  CfxPaintInfo = TOleEnum;
const
  CPI_GETDC = $00000000;
  CPI_RELEASEDC = $00000001;
  CPI_PIXELTOMARKER = $00000002;
  CPI_MARKERTOPIXEL = $00000003;
  CPI_VALUETOPIXEL = $00000004;
  CPI_PIXELTOVALUE = $00000005;
  CPI_POSITION = $00000006;
  CPI_DIMENSION = $00000007;
  CPI_PRINTINFO = $00000008;
  CPI_SCROLLINFO = $00000009;
  CPI_3DINFO = $0000000A;
  CPI_3DTO2D = $0000000B;
  CPI_SCREENTOCHART = $0000000C;

// Constants for enum CfxExport
type
  CfxExport = TOleEnum;
const
  CHART_DATA = $00000000;
  CHART_BITMAP = $00000001;
  CHART_METAFILE = $00000002;
  CHART_CFXFILE = $00000003;
  CHART_CFXTEMPLATE = $00000004;
  CHART_INTERNALFILE = $00000005;
  CHART_INTERNALTEMPLATE = $00000006;
  CHART_PALETTE = $00000007;
  CHART_CFXOLEFILE = $00000008;
  CHART_CFXOLETEMPLATE = $00000009;

// Constants for enum CfxDataMask
type
  CfxDataMask = TOleEnum;
const
  CD_VALUES = $00000001;
  CD_XVALUES = $00000002;
  CD_INIVALUES = $00000004;
  CD_DATA = $00000007;
  CD_STRIPES = $00000008;
  CD_CONSTANTLINES = $00000010;
  CD_COLORSANDPATTERNS = $00000020;
  CD_PERSERIESATTRIBUTES = $00000040;
  CD_LABELS = $00000080;
  CD_TITLES = $00000100;
  CD_STRINGS = $00000180;
  CD_TOOLS = $00000200;
  CD_EXTENSIONS = $00000400;
  CD_COMMANDS = $00000800;
  CD_FONTS = $00001000;
  CD_SERLABELS = $00002000;
  CD_AXISLABELS = $00004000;
  CD_OTHER = $08000000;
  CD_ALLDATA = $0FFFFFFF;

// Constants for enum CfxHitTest
type
  CfxHitTest = TOleEnum;
const
  HIT_BKGND = $00000000;
  HIT_2DBK = $00000001;
  HIT_3DBK = $00000002;
  HIT_BETWEEN = $00000003;
  HIT_POINT = $00000004;
  HIT_AXISY = $00000005;
  HIT_AXISY2 = $00000006;
  HIT_AXISX = $00000007;
  HIT_AXISX2 = $00000008;
  HIT_LEFTTITLE = $00000009;
  HIT_RIGHTTITLE = $0000000A;
  HIT_TOPTITLE = $0000000B;
  HIT_BOTTOMTITLE = $0000000C;
  HIT_DRAG = $0000000D;
  HIT_CROSSHAIR = $0000000E;

// Constants for enum CfxGalleryTool
type
  CfxGalleryTool = TOleEnum;
const
  CSG_LINE = $00000001;
  CSG_BAR = $00000002;
  CSG_SPLINE = $00000004;
  CSG_MARK = $00000008;
  CSG_PIE = $00000010;
  CSG_AREA = $00000020;
  CSG_PARETO = $00000040;
  CSG_SCATTER = $00000080;
  CSG_HILOW = $00000100;
  CSG_SURFACE = $00000200;
  CSG_POLAR = $00000400;
  CSG_CUBE = $00000800;
  CSG_DOUGHNUT = $00001000;
  CSG_BARHORZ = $00002000;
  CSG_ALL = $FFFFFFFF;

// Constants for enum CfxLegStyle
type
  CfxLegStyle = TOleEnum;
const
  CL_NOTCLIPPED = $00000001;
  CL_NOTCHANGECOLOR = $00000002;
  CL_HIDE = $00000004;
  CL_HIDEXLEG = $00000004;
  CL_FORCESERLEG = $00000008;
  CL_GETLEGEND = $00000010;
  CL_HIDEYLEG = $00000020;
  CL_2LEVELS = $00000040;
  CL_VERTXLEG = $00000080;
  CL_SHOWZLEG = $00000100;
  CL_PIELEGEND = $00000200;
  CL_SINGLELINE = $00000400;

// Constants for enum CfxCustomTool
type
  CfxCustomTool = TOleEnum;
const
  CST_IMPORT = $00000001;
  CST_EXPORT = $00000002;
  CST_FILE = $00000003;
  CST_COPYBITMAP = $00000004;
  CST_COPYDATA = $00000008;
  CST_COPY = $0000000C;
  CST_PRINT = $00000010;
  CST_FILEEDIT = $0000001F;
  CST_SPACE1 = $00000020;
  CST_GALLERY = $00000040;
  CST_SPACECOMBO = $00000080;
  CST_COLOR = $00000100;
  CST_SPACE2 = $00000200;
  CST_3D = $00000400;
  CST_ROTATE = $00000800;
  CST_CLUSTER = $00001000;
  CST_ZOOM = $00002000;
  CST_VIEW = $00003C00;
  CST_SPACE3 = $00004000;
  CST_LEGEND = $00008000;
  CST_SERLEGEND = $00010000;
  CST_VGRID = $00020000;
  CST_HGRID = $00040000;
  CST_LEGGRID = $00078000;
  CST_SPACE4 = $00080000;
  CST_TITLES = $00100000;
  CST_FONTS = $00200000;
  CST_TOOLS = $00400000;
  CST_OPTIONS = $00800000;
  CST_OTHER = $00F00000;

// Constants for enum CfxTool
type
  CfxTool = TOleEnum;
const
  CTOOL_LEGEND = $00000000;
  CTOOL_SERLEGEND = $00000001;
  CTOOL_TB = $00000002;
  CTOOL_EDITOR = $00000003;
  CTOOL_BKCOLOR = $00001000;
  CTOOL_OPTIONS = $00002000;
  CTOOL_MOVE = $00004000;

// Constants for enum CfxToolStyle
type
  CfxToolStyle = TOleEnum;
const
  CTS_HIDEFOCUS = $00008000;
  CTS_WHITELINE = $00010000;
  CTS_DELIMITER = $00020000;
  CTS_SIZEABLE = $00040000;
  CTS_HORZLAYER = $00080000;
  CTS_VERTLAYER = $00100000;
  CTS_SIZELAYER = $00200000;
  CTS_DBLCLKS = $00400000;
  CTS_DOCKABLE = $00800000;
  CTS_SPLITTER = $01000000;
  CTS_3DFRAME = $02000000;
  CTS_BORDERLAYER = $04000000;
  CTS_BORDERIFLAYER = $08000000;
  CHART_TBBALLOON = $00000001;
  CHART_TBSTANDARD = $00000002;
  CHART_TBNOTOOLTIPS = $00000004;

// Constants for enum CfxToolPos
type
  CfxToolPos = TOleEnum;
const
  CTP_TOP = $00000000;
  CTP_LEFT = $00000001;
  CTP_BOTTOM = $00000002;
  CTP_RIGHT = $00000003;
  CTP_FIXED = $00000004;
  CTP_FLOAT = $00007FFF;
  CTP_SWITCH = $00007FFE;

// Constants for enum CfxToolID
type
  CfxToolID = TOleEnum;
const
  CFX_ID_FIRST = $00007300;
  CFX_ID_LAST = $000074FF;
  CFX_ID_RESERVEDFIRST = $00007500;
  CFX_ID_RESERVEDLAST = $000077FF;
  CFX_ID_IMPORTFILE = $00007300;
  CFX_ID_EXPORTFILE = $00007301;
  CFX_ID_PRINT = $00007302;
  CFX_ID_DLGPRINT = $00007303;
  CFX_ID_PAGESETUP = $00007304;
  CFX_ID_3D = $00007305;
  CFX_ID_ROTATE = $00007306;
  CFX_ID_CLUSTER = $00007307;
  CFX_ID_ZOOM = $00007308;
  CFX_ID_VERTGRID = $00007309;
  CFX_ID_HORZGRID = $0000730A;
  CFX_ID_OPTIONS = $0000730B;
  CFX_ID_CM_EDITTITLE = $0000730C;
  CFX_ID_HELPSEARCH = $0000730D;
  CFX_ID_ABOUT = $0000730E;
  CFX_ID_LEGEND = $0000730F;
  CFX_ID_SERIESLEGEND = $00007310;
  CFX_ID_DATAEDITOR = $00007311;
  CFX_ID_TOOLBAR = $00007312;
  CFX_ID_MENUBAR = $00007313;
  CFX_ID_PALETTEBAR = $00007314;
  CFX_ID_PATTERNBAR = $00007315;
  CFX_ID_STATUSBAR = $00007316;
  CFX_ID_SMARTLEGENDBOX = $00007317;
  CFX_ID_EXPORTCLIPBOARD = $00007318;
  CFX_ID_TOOLS = $00007319;
  CFX_ID_FONTS = $0000731A;
  CFX_ID_COLORCOMBO = $0000731B;
  CFX_ID_SEPARATOR = $0000731C;
  CFX_ID_EXPORTTEMPLATE = $0000731D;
  CFX_ID_IMPORTTEMPLATE = $0000731E;
  CFX_ID_EXPORTBITMAP = $0000731F;
  CFX_ID_EXPORTMETAFILE = $00007320;
  CFX_ID_EXPORTDATA = $00007321;
  CFX_ID_EXPORTOBJECT = $00007322;
  CFX_ID_FONTLT = $00007323;
  CFX_ID_FONTRT = $00007324;
  CFX_ID_FONTTT = $00007325;
  CFX_ID_FONTBT = $00007326;
  CFX_ID_FONTXL = $00007327;
  CFX_ID_FONTYL = $00007328;
  CFX_ID_FONTFX = $00007329;
  CFX_ID_FONTLY = $0000732A;
  CFX_ID_FONTVAL = $0000732B;
  CFX_ID_FONTPT = $0000732C;
  CFX_ID_FONTEDITOR = $0000732D;
  CFX_ID_HELPCONTENTS = $0000732E;
  CFX_ID_EXIT = $0000732F;
  CFX_ID_CM_FONT = $00007330;
  CFX_ID_POINTLABELS = $00007331;
  CFX_ID_CMB_AUTOSIZE = $00007332;
  CFX_ID_CMB_FIXED = $00007333;
  CFX_ID_CMB_FLOAT = $00007334;
  CFX_ID_CMB_LEFT = $00007335;
  CFX_ID_CMB_TOP = $00007336;
  CFX_ID_CMB_RIGHT = $00007337;
  CFX_ID_CMB_BOTTOM = $00007338;
  CFX_ID_CMB_HIDE = $00007339;
  CFX_ID_GALLERY = $0000733A;
  CFX_ID_COLOR = $0000733B;
  CFX_ID_FILE = $0000733C;
  CFX_ID_EDIT = $0000733D;
  CFX_ID_VIEW = $0000733E;
  CFX_ID_HELP = $0000733F;
  CFX_ID_CM_SERIES = $00007340;
  CFX_ID_CM_BACKGROUND = $00007341;
  CFX_ID_CM_AXIS = $00007342;
  CFX_ID_CM_TITLE = $00007343;
  CFX_ID_CM_BAR = $00007344;
  CFX_ID_TOOLBARS = $00007345;
  CFX_ID_LINE = $00007346;
  CFX_ID_BAR = $00007347;
  CFX_ID_CURVE = $00007348;
  CFX_ID_SCATTER = $00007349;
  CFX_ID_PIE = $0000734A;
  CFX_ID_AREA = $0000734B;
  CFX_ID_PARETO = $0000734C;
  CFX_ID_STEP = $0000734D;
  CFX_ID_HILOWCLOSE = $0000734E;
  CFX_ID_SURFACE = $0000734F;
  CFX_ID_RADAR = $00007350;
  CFX_ID_CUBE = $00007351;
  CFX_ID_DOUGHNUT = $00007352;
  CFX_ID_PYRAMID = $00007353;
  CFX_ID_BUBBLE = $00007354;
  CFX_ID_OPENHILOWCLOSE = $00007355;
  CFX_ID_CANDLESTICK = $00007356;
  CFX_ID_CONTOUR = $00007357;
  CFX_ID_CURVEAREA = $00007358;
  CFX_ID_GANTT = $00007359;
  CFX_ID_PASTEDATA = $0000735A;
  CFX_ID_STACKED = $0000735B;
  CFX_ID_APPLY = $00007400;

// Constants for enum CfxAdm
type
  CfxAdm = TOleEnum;
const
  CSA_MIN = $00000000;
  CSA_MIN2 = $00000001;
  CSA_XMIN = $00000002;
  CSA_X2MIN = $00000003;
  CSA_MAX = $00000004;
  CSA_MAX2 = $00000005;
  CSA_XMAX = $00000006;
  CSA_X2MAX = $00000007;
  CSA_GAP = $00000008;
  CSA_GAP2 = $00000009;
  CSA_XGAP = $0000000A;
  CSA_X2STEP = $0000000B;
  CSA_SCALE = $0000000C;
  CSA_SCALE2 = $0000000D;
  CSA_XSCALE = $0000000E;
  CSA_X2SCALE = $0000000F;
  CSA_LOGBASE = $00000010;
  CSA_LOGBASE2 = $00000011;
  CSA_LOGBASEX = $00000012;
  CSA_LOGBASEX2 = $00000013;
  CSA_YLEGGAP = $00000014;
  CSA_PIXXVALUE = $00000015;

// Constants for enum CfxDecimal
type
  CfxDecimal = TOleEnum;
const
  CD_ALL = $00000000;
  CD_YLEG = $00000002;
  CD_YLEG2 = $00000003;
  CD_XLEG = $00000004;
  CD_XLEG2 = $00000005;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  _ChartFXEvents = dispinterface;
  IChartFX = interface;
  IChartFXDisp = dispinterface;
  ICfxSeriesEnum = interface;
  ICfxSeriesEnumDisp = dispinterface;
  ICfxSeries = interface;
  ICfxSeriesDisp = dispinterface;
  ICfxAxisEnum = interface;
  ICfxAxisEnumDisp = dispinterface;
  ICfxAxis = interface;
  ICfxAxisDisp = dispinterface;
  ICfxConstEnum = interface;
  ICfxConstEnumDisp = dispinterface;
  ICfxConst = interface;
  ICfxConstDisp = dispinterface;
  ICfxStripeEnum = interface;
  ICfxStripeEnumDisp = dispinterface;
  ICfxStripe = interface;
  ICfxStripeDisp = dispinterface;
  ICfxLegendBox = interface;
  ICfxLegendBoxDisp = dispinterface;
  ICfxPalette = interface;
  ICfxPaletteDisp = dispinterface;
  ICfxDataEditor = interface;
  ICfxDataEditorDisp = dispinterface;
  ICfxPrinter = interface;
  ICfxPrinterDisp = dispinterface;
  DataSource = interface;
  _VBDataSource = interface;
  _VBDataSourceDisp = dispinterface;
  ICfxEnum = interface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  ChartFX = IChartFX;
  GeneralPage = IUnknown;
  SeriesPage = IUnknown;
  AxesPage = IUnknown;
  Page3D = IUnknown;
  ScalePage = IUnknown;
  LabelsPage = IUnknown;
  GridLinesPage = IUnknown;
  ConstantStripesPage = IUnknown;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  PSmallint1 = ^Smallint; {*}
  POleVariant1 = ^OleVariant; {*}

  DataMember = WideString; 

// *********************************************************************//
// DispIntf:  _ChartFXEvents
// Flags:     (4112) Hidden Dispatchable
// GUID:      {F3743560-454E-11D1-8FD4-00AA00BD091C}
// *********************************************************************//
  _ChartFXEvents = dispinterface
    ['{F3743560-454E-11D1-8FD4-00AA00BD091C}']
    procedure LButtonDblClk(x: Smallint; y: Smallint; nSerie: Smallint; nPoint: Integer; 
                            var nRes: Smallint); dispid 1;
    procedure RButtonDown(x: Smallint; y: Smallint; nSerie: Smallint; nPoint: Integer; 
                          var nRes: Smallint); dispid 2;
    procedure ChangeValue(dValue: Double; nSerie: Smallint; nPoint: Integer; var nRes: Smallint); dispid 3;
    procedure ChangeString(nType: Smallint; nIndex: Integer; var nRes: Smallint); dispid 4;
    procedure ChangeColor(nType: Smallint; nIndex: Smallint; var nRes: Smallint); dispid 5;
    procedure Destroy; dispid 6;
    procedure ReadFile; dispid 7;
    procedure ChangePalette(nIndex: Smallint; var nRes: Smallint); dispid 8;
    procedure ChangeFont(nIndex: Smallint; var nRes: Smallint); dispid 9;
    procedure ReadTemplate; dispid 10;
    procedure ChangePattern(nType: Smallint; nIndex: Smallint; var nRes: Smallint); dispid 11;
    procedure Menu(wParam: Integer; nSerie: Smallint; nPoint: Integer; var nRes: Smallint); dispid 13;
    procedure ChangeType(nType: Smallint; var nRes: Smallint); dispid 14;
    procedure UserScroll(wScrollMsg: Integer; wScrollParam: Integer; var nRes: Smallint); dispid 15;
    procedure InternalCommand(wParam: Integer; lParam: Integer; var nRes: Smallint); dispid 17;
    procedure ShowToolBar(nType: Smallint; var nRes: Smallint); dispid 18;
    procedure PrePaint(w: Smallint; h: Smallint; lPaint: Integer; var nRes: Smallint); dispid 19;
    procedure PostPaint(w: Smallint; h: Smallint; lPaint: Integer; var nRes: Smallint); dispid 20;
    procedure PaintMarker(x: Smallint; y: Smallint; lPaint: Integer; nSerie: Smallint; 
                          nPoint: Integer; var nRes: Smallint); dispid 21;
    procedure LButtonDown(x: Smallint; y: Smallint; var nRes: Smallint); dispid 22;
    procedure LButtonUp(x: Smallint; y: Smallint; var nRes: Smallint); dispid 23;
    procedure RButtonUp(x: Smallint; y: Smallint; var nRes: Smallint); dispid 24;
    procedure MouseMoving(x: Smallint; y: Smallint; var nRes: Smallint); dispid 25;
    procedure RButtonDblClk(x: Smallint; y: Smallint; var nRes: Smallint); dispid 26;
    procedure UserCommand(wParam: Integer; lParam: Integer; var nRes: Smallint); dispid 27;
    procedure GetPointLabel(nSerie: Smallint; nPoint: Integer; var nRes: Smallint); dispid 28;
    procedure GetAxisLabel(nAxis: Smallint; var nRes: Smallint); dispid 29;
    procedure PrePaintMarker(nSerie: Smallint; nPoint: Integer; var nRes: Smallint); dispid 30;
    procedure GetTip(nHit: Smallint; nSerie: Smallint; nPoint: Integer; var nRes: Smallint); dispid 31;
    procedure ChangePattPal(nIndex: Smallint; var nRes: Smallint); dispid 12;
    procedure GetLegend(nIndex: Smallint; var nRes: Smallint); dispid 16;
  end;

// *********************************************************************//
// Interface: IChartFX
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {608E8B10-3690-11D1-8FD4-00AA00BD091C}
// *********************************************************************//
  IChartFX = interface(IDispatch)
    ['{608E8B10-3690-11D1-8FD4-00AA00BD091C}']
    procedure Refresh; safecall;
    procedure AboutBox; safecall;
    function  Get_hWnd: SYSUINT; safecall;
    function  Get_Enabled: WordBool; safecall;
    procedure Set_Enabled(val: WordBool); safecall;
    function  Get_Gallery: CfxGallery; safecall;
    procedure Set_Gallery(val: CfxGallery); safecall;
    function  Get_TypeMask: CfxType; safecall;
    procedure Set_TypeMask(val: CfxType); safecall;
    function  Get_Style: CfxStyle; safecall;
    procedure Set_Style(val: CfxStyle); safecall;
    function  Get_NSeries: Integer; safecall;
    procedure Set_NSeries(val: Integer); safecall;
    function  Get_LeftGap: Smallint; safecall;
    procedure Set_LeftGap(val: Smallint); safecall;
    function  Get_RightGap: Smallint; safecall;
    procedure Set_RightGap(val: Smallint); safecall;
    function  Get_TopGap: Smallint; safecall;
    procedure Set_TopGap(val: Smallint); safecall;
    function  Get_BottomGap: Smallint; safecall;
    procedure Set_BottomGap(val: Smallint); safecall;
    function  Get_MenuBar: WordBool; safecall;
    procedure Set_MenuBar(val: WordBool); safecall;
    function  Get_Scheme: CfxScheme; safecall;
    procedure Set_Scheme(val: CfxScheme); safecall;
    function  Get_Stacked: CfxStacked; safecall;
    procedure Set_Stacked(val: CfxStacked); safecall;
    function  Get_Grid: CfxGrid; safecall;
    procedure Set_Grid(val: CfxGrid); safecall;
    function  Get_WallWidth: Smallint; safecall;
    procedure Set_WallWidth(val: Smallint); safecall;
    function  Get_Border: WordBool; safecall;
    procedure Set_Border(val: WordBool); safecall;
    function  Get_BorderColor: OLE_COLOR; safecall;
    procedure Set_BorderColor(val: OLE_COLOR); safecall;
    function  Get_LineWidth: Smallint; safecall;
    procedure Set_LineWidth(val: Smallint); safecall;
    function  Get_LineStyle: CfxLineStyle; safecall;
    procedure Set_LineStyle(val: CfxLineStyle); safecall;
    function  Get_View3D: WordBool; safecall;
    procedure Set_View3D(val: WordBool); safecall;
    function  Get_AngleX: Smallint; safecall;
    procedure Set_AngleX(val: Smallint); safecall;
    function  Get_AngleY: Smallint; safecall;
    procedure Set_AngleY(val: Smallint); safecall;
    function  Get_RGBBk: OLE_COLOR; safecall;
    procedure Set_RGBBk(val: OLE_COLOR); safecall;
    function  Get_RGB2DBk: OLE_COLOR; safecall;
    procedure Set_RGB2DBk(val: OLE_COLOR); safecall;
    function  Get_RGB3DBk: OLE_COLOR; safecall;
    procedure Set_RGB3DBk(val: OLE_COLOR); safecall;
    function  Get_HText: WideString; safecall;
    procedure Set_HText(const pVal: WideString); safecall;
    function  Get_ChartStatus: CfxChartStatus; safecall;
    procedure Set_ChartStatus(val: CfxChartStatus); safecall;
    function  Get_AxesStyle: CfxAxesStyle; safecall;
    procedure Set_AxesStyle(pVal: CfxAxesStyle); safecall;
    function  Get_Chart3D: WordBool; safecall;
    procedure Set_Chart3D(val: WordBool); safecall;
    function  Get_ToolBar: WordBool; safecall;
    procedure Set_ToolBar(val: WordBool); safecall;
    function  Get_PaletteBar: WordBool; safecall;
    procedure Set_PaletteBar(val: WordBool); safecall;
    function  Get_PatternBar: WordBool; safecall;
    procedure Set_PatternBar(val: WordBool); safecall;
    function  Get_ReturnValue: Integer; safecall;
    procedure Set_ReturnValue(val: Integer); safecall;
    function  Get_FileMask: CfxFileMask; safecall;
    procedure Set_FileMask(val: CfxFileMask); safecall;
    function  Get_PropPageMask: Integer; safecall;
    procedure Set_PropPageMask(val: Integer); safecall;
    procedure Set_TipMask(const Param1: WideString); safecall;
    function  Get_MarkerStep: Smallint; safecall;
    procedure Set_MarkerStep(pVal: Smallint); safecall;
    function  Get_MarkerShape: CfxPointType; safecall;
    procedure Set_MarkerShape(val: CfxPointType); safecall;
    function  Get_MarkerSize: Smallint; safecall;
    procedure Set_MarkerSize(val: Smallint); safecall;
    function  Get_Volume: Smallint; safecall;
    procedure Set_Volume(val: Smallint); safecall;
    function  Get_View3DLight: Smallint; safecall;
    procedure Set_View3DLight(val: Smallint); safecall;
    function  Get_CylSides: Smallint; safecall;
    procedure Set_CylSides(val: Smallint); safecall;
    function  Get_BorderStyle: CfxBorderStyle; safecall;
    procedure Set_BorderStyle(val: CfxBorderStyle); safecall;
    function  Get_MaxValues: Integer; safecall;
    procedure Set_MaxValues(val: Integer); safecall;
    function  Get_Perspective: Smallint; safecall;
    procedure Set_Perspective(pVal: Smallint); safecall;
    function  Get_Zoom: WordBool; safecall;
    procedure Set_Zoom(val: WordBool); safecall;
    function  Get_DataStyle: CfxDataStyle; safecall;
    procedure Set_DataStyle(val: CfxDataStyle); safecall;
    function  Get_TypeEx: CfxTypeEx; safecall;
    procedure Set_TypeEx(val: CfxTypeEx); safecall;
    function  Get_StyleEx: CfxStyleEx; safecall;
    procedure Set_StyleEx(val: CfxStyleEx); safecall;
    function  Get_MouseCapture: WordBool; safecall;
    procedure Set_MouseCapture(val: WordBool); safecall;
    function  Get_PointLabels: WordBool; safecall;
    procedure Set_PointLabels(val: WordBool); safecall;
    function  Get_PointLabelAlign: CfxAlign; safecall;
    procedure Set_PointLabelAlign(pVal: CfxAlign); safecall;
    function  Get_PointLabelAngle: Smallint; safecall;
    procedure Set_PointLabelAngle(pVal: Smallint); safecall;
    function  Get_NValues: Integer; safecall;
    procedure Set_NValues(val: Integer); safecall;
    function  Get_BkPicture: IPictureDisp; safecall;
    procedure Set_BkPicture(const pVal: IPictureDisp); safecall;
    function  Get_LeftFont: IFontDisp; safecall;
    procedure Set_LeftFont(const val: IFontDisp); safecall;
    function  Get_RightFont: IFontDisp; safecall;
    procedure Set_RightFont(const val: IFontDisp); safecall;
    function  Get_TopFont: IFontDisp; safecall;
    procedure Set_TopFont(const val: IFontDisp); safecall;
    function  Get_BottomFont: IFontDisp; safecall;
    procedure Set_BottomFont(const val: IFontDisp); safecall;
    function  Get_XLegFont: IFontDisp; safecall;
    procedure Set_XLegFont(const val: IFontDisp); safecall;
    function  Get_YLegFont: IFontDisp; safecall;
    procedure Set_YLegFont(const val: IFontDisp); safecall;
    function  Get_FixedFont: IFontDisp; safecall;
    procedure Set_FixedFont(const val: IFontDisp); safecall;
    function  Get_LegendFont: IFontDisp; safecall;
    procedure Set_LegendFont(const val: IFontDisp); safecall;
    function  Get_PointLabelsFont: IFontDisp; safecall;
    procedure Set_PointLabelsFont(const val: IFontDisp); safecall;
    function  Get_PointFont: IFontDisp; safecall;
    procedure Set_PointFont(const val: IFontDisp); safecall;
    function  Get_View3DDepth: Smallint; safecall;
    procedure Set_View3DDepth(val: Smallint); safecall;
    function  Get_Scrollable: WordBool; safecall;
    procedure Set_Scrollable(pVal: WordBool); safecall;
    function  Get_RealTimeStyle: CfxRealTimeStyle; safecall;
    procedure Set_RealTimeStyle(val: CfxRealTimeStyle); safecall;
    function  Get_Series: ICfxSeriesEnum; safecall;
    function  Get_Axis: ICfxAxisEnum; safecall;
    function  Get_ConstantLine: ICfxConstEnum; safecall;
    function  Get_Stripe: ICfxStripeEnum; safecall;
    function  Get_Commands: ICommandBar; safecall;
    function  Get_ToolBarObj: IToolBar; safecall;
    function  Get_MenuBarObj: IToolBar; safecall;
    function  Get_LegendBoxObj: ICfxLegendBox; safecall;
    function  Get_SerLegBoxObj: ICfxLegendBox; safecall;
    function  Get_PaletteBarObj: ICfxPalette; safecall;
    function  Get_PatternBarObj: ICfxPalette; safecall;
    function  Get_DataEditorObj: ICfxDataEditor; safecall;
    function  Get_Printer: ICfxPrinter; safecall;
    function  Get_Cluster: WordBool; safecall;
    procedure Set_Cluster(pVal: WordBool); safecall;
    function  Get_Palette: WideString; safecall;
    procedure Set_Palette(const pVal: WideString); safecall;
    function  Get_LegendBox: WordBool; safecall;
    procedure Set_LegendBox(pVal: WordBool); safecall;
    function  Get_SerLegBox: WordBool; safecall;
    procedure Set_SerLegBox(pVal: WordBool); safecall;
    function  Get_DataEditor: WordBool; safecall;
    procedure Set_DataEditor(pVal: WordBool); safecall;
    function  Get_MultipleColors: WordBool; safecall;
    procedure Set_MultipleColors(pVal: WordBool); safecall;
    function  Get_AllowDrag: WordBool; safecall;
    procedure Set_AllowDrag(pVal: WordBool); safecall;
    function  Get_AllowResize: WordBool; safecall;
    procedure Set_AllowResize(pVal: WordBool); safecall;
    function  Get_AllowEdit: WordBool; safecall;
    procedure Set_AllowEdit(pVal: WordBool); safecall;
    function  Get_ShowTips: WordBool; safecall;
    procedure Set_ShowTips(pVal: WordBool); safecall;
    function  Get_ContextMenus: WordBool; safecall;
    procedure Set_ContextMenus(pVal: WordBool); safecall;
    function  Get_DataSourceAdo: DataSource; safecall;
    procedure Set_DataSourceAdo(const ppdp: DataSource); safecall;
    function  Get_DataMemberAdo: DataMember; safecall;
    procedure Set_DataMemberAdo(const pbstrDataMember: DataMember); safecall;
    function  Get_DataSource: _VBDataSource; safecall;
    procedure Set_DataSource(const val: _VBDataSource); safecall;
    function  Get_TypeProp(nGallery: Smallint): Integer; safecall;
    procedure Set_TypeProp(nGallery: Smallint; pVal: Integer); safecall;
    function  Get_ValueEx(nSerie: Smallint; nPoint: Integer): Double; safecall;
    procedure Set_ValueEx(nSerie: Smallint; nPoint: Integer; val: Double); safecall;
    function  Get_XValueEx(nSerie: Smallint; nPoint: Integer): Double; safecall;
    procedure Set_XValueEx(nSerie: Smallint; nPoint: Integer; val: Double); safecall;
    function  Get_IniValueEx(nSerie: Smallint; nPoint: Integer): Double; safecall;
    procedure Set_IniValueEx(nSerie: Smallint; nPoint: Integer; val: Double); safecall;
    function  Get_Pattern(index: Smallint): Smallint; safecall;
    procedure Set_Pattern(index: Smallint; val: Smallint); safecall;
    function  Get_Title(index: CfxTitle): WideString; safecall;
    procedure Set_Title(index: CfxTitle; const val: WideString); safecall;
    function  Get_Legend(index: Integer): WideString; safecall;
    procedure Set_Legend(index: Integer; const val: WideString); safecall;
    function  Get_KeyLeg(index: Integer): WideString; safecall;
    procedure Set_KeyLeg(index: Integer; const val: WideString); safecall;
    function  Get_YLeg(index: Integer): WideString; safecall;
    procedure Set_YLeg(index: Integer; const val: WideString); safecall;
    function  Get_Fonts(index: CfxFont): CfxFontAttr; safecall;
    procedure Set_Fonts(index: CfxFont; val: CfxFontAttr); safecall;
    function  Get_HFont(index: CfxFont): Integer; safecall;
    procedure Set_HFont(index: CfxFont; val: Integer); safecall;
    function  Get_RGBFont(index: CfxFont): OLE_COLOR; safecall;
    procedure Set_RGBFont(index: CfxFont; val: OLE_COLOR); safecall;
    function  Get_ItemWidth(index: CfxItem): Smallint; safecall;
    procedure Set_ItemWidth(index: CfxItem; val: Smallint); safecall;
    function  Get_ItemColor(index: CfxItem): OLE_COLOR; safecall;
    procedure Set_ItemColor(index: CfxItem; val: OLE_COLOR); safecall;
    function  Get_ItemStyle(index: CfxItem): Integer; safecall;
    procedure Set_ItemStyle(index: CfxItem; val: Integer); safecall;
    function  Get_ItemBkColor(index: CfxItem): OLE_COLOR; safecall;
    procedure Set_ItemBkColor(index: CfxItem; val: OLE_COLOR); safecall;
    function  Get_SeparateSlice(index: Smallint): Smallint; safecall;
    procedure Set_SeparateSlice(index: Smallint; val: Smallint); safecall;
    function  Get_DataType(index: Smallint): CfxDataType; safecall;
    procedure Set_DataType(index: Smallint; val: CfxDataType); safecall;
    function  Get_Color(index: Smallint): OLE_COLOR; safecall;
    procedure Set_Color(index: Smallint; val: OLE_COLOR); safecall;
    function  Get_BkColor(index: Smallint): OLE_COLOR; safecall;
    procedure Set_BkColor(index: Smallint; val: OLE_COLOR); safecall;
    function  Get_SerLeg(index: Smallint): WideString; safecall;
    procedure Set_SerLeg(index: Smallint; const val: WideString); safecall;
    function  Get_KeySer(index: Smallint): WideString; safecall;
    procedure Set_KeySer(index: Smallint; const val: WideString); safecall;
    function  OpenDataEx(nType: CfxCod; n1: Integer; n2: Integer): Integer; safecall;
    function  CloseData(nType: CfxCod): WordBool; safecall;
    function  DblClk(nType: CfxClick; lExtra: Integer): Integer; safecall;
    function  RigClk(nType: CfxClick; lExtra: Integer): Integer; safecall;
    function  ShowDialog(nDialog: CfxDialog; lExtra: Integer): Integer; safecall;
    function  ClearLegend(index: CfxLegend): Integer; safecall;
    function  PrintIt(nFrom: Smallint; nTo: Smallint): Integer; safecall;
    function  Scroll(wParam: CfxScroll; lParam: Integer): Integer; safecall;
    function  Paint(hDC: Integer; nLeft: Integer; nTop: Integer; nRight: Integer; nBottom: Integer; 
                    wAction: CfxChartPaint; lps: Integer): Integer; safecall;
    function  PaintInfo(index: CfxPaintInfo; vData: OleVariant): OleVariant; safecall;
    procedure PaintInfo2(nIndex: CfxPaintInfo; vData: OleVariant; var vResult: OleVariant); safecall;
    function  Export(nType: CfxExport; vData: OleVariant): Integer; safecall;
    function  Import(nType: CfxExport; vData: OleVariant): Integer; safecall;
    function  Language(const sResource: WideString): Integer; safecall;
    function  SendMsg(wMsg: Integer; wParam: Integer; lParam: Integer): Integer; safecall;
    procedure AddExtension(vExt: OleVariant); safecall;
    function  GetExtension(const sExtension: WideString): IUnknown; safecall;
    procedure RemoveExtension(const sExtension: WideString); safecall;
    function  GetPicture(nFormat: Smallint): IPictureDisp; safecall;
    procedure GetExternalData(vDataProvider: OleVariant; vPar: OleVariant); safecall;
    procedure RecalcScale; safecall;
    procedure SetContourLabels(STEP: Double); safecall;
    procedure AddBar(nID: Smallint; const pObj: IUnknown); safecall;
    function  GetBar(nID: Smallint): IUnknown; safecall;
    procedure RemoveBar(nID: Smallint); safecall;
    procedure ClearData(newVal: CfxDataMask); safecall;
    procedure ZoomIn(xMin: Double; yMin: Double; xMax: Double; yMax: Double); safecall;
    procedure _GetCChartFXPointer(out pChart: Integer); safecall;
    function  HitTest(x: Integer; y: Integer; out NSeries: Smallint; out nPoint: Integer): CfxHitTest; safecall;
    procedure ShowBalloon(const sText: WideString; x: Integer; y: Integer); safecall;
    procedure CreateWnd(hwndParent: Integer; nID: Smallint; x: Integer; y: Integer; cx: Integer; 
                        cy: Integer; dwStyle: Integer); safecall;
    function  SetEventHandler(const pObj: IUnknown): IUnknown; safecall;
    procedure ShowHelpTopic(const pszHelpDir: WideString; nTopic: Integer); safecall;
    function  Get_ChartType: CfxGallery; safecall;
    procedure Set_ChartType(val: CfxGallery); safecall;
    function  Get_MarkerVolume: Smallint; safecall;
    procedure Set_MarkerVolume(val: Smallint); safecall;
    function  Get_PointType: CfxPointType; safecall;
    procedure Set_PointType(val: CfxPointType); safecall;
    function  Get_Type_: CfxType; safecall;
    procedure Set_Type_(val: CfxType); safecall;
    function  Get_Shape: Smallint; safecall;
    procedure Set_Shape(val: Smallint); safecall;
    function  Get_PixFactor: Smallint; safecall;
    procedure Set_PixFactor(val: Smallint); safecall;
    function  Get_FixedGap: Smallint; safecall;
    procedure Set_FixedGap(val: Smallint); safecall;
    function  Get_BarHorzGap: Smallint; safecall;
    procedure Set_BarHorzGap(val: Smallint); safecall;
    function  Get_RGBBarHorz: OLE_COLOR; safecall;
    procedure Set_RGBBarHorz(val: OLE_COLOR); safecall;
    function  Get_VertGridGap: Smallint; safecall;
    procedure Set_VertGridGap(val: Smallint); safecall;
    function  Get_ConstType: CfxConstType; safecall;
    procedure Set_ConstType(val: CfxConstType); safecall;
    function  Get_GalleryTool: CfxGalleryTool; safecall;
    procedure Set_GalleryTool(val: CfxGalleryTool); safecall;
    function  Get_LegStyle: CfxLegStyle; safecall;
    procedure Set_LegStyle(val: CfxLegStyle); safecall;
    function  Get_CurrentAxis: CfxAxisIndex; safecall;
    procedure Set_CurrentAxis(val: CfxAxisIndex); safecall;
    function  Get_CustomTool: CfxCustomTool; safecall;
    procedure Set_CustomTool(val: CfxCustomTool); safecall;
    function  Get_TBBitmap: IPictureDisp; safecall;
    procedure Set_TBBitmap(const val: IPictureDisp); safecall;
    function  Get_Angles3D: Integer; safecall;
    procedure Set_Angles3D(val: Integer); safecall;
    function  Get_AutoIncrement: WordBool; safecall;
    procedure Set_AutoIncrement(val: WordBool); safecall;
    function  Get_ThisSerie: Smallint; safecall;
    procedure Set_ThisSerie(val: Smallint); safecall;
    function  Get_ThisValue: Double; safecall;
    procedure Set_ThisValue(val: Double); safecall;
    function  Get_ThisPoint: Integer; safecall;
    procedure Set_ThisPoint(val: Integer); safecall;
    function  Get_MultiType(index: Smallint): CfxType; safecall;
    procedure Set_MultiType(index: Smallint; val: CfxType); safecall;
    function  Get_MultiShape(index: Smallint): Smallint; safecall;
    procedure Set_MultiShape(index: Smallint; val: Smallint); safecall;
    function  Get_MultiLineStyle(index: Smallint): Integer; safecall;
    procedure Set_MultiLineStyle(index: Smallint; val: Integer); safecall;
    function  Get_MultiYAxis(index: Smallint): CfxAxisIndex; safecall;
    procedure Set_MultiYAxis(index: Smallint; val: CfxAxisIndex); safecall;
    function  Get_TBItemStyle(index: Smallint): Integer; safecall;
    procedure Set_TBItemStyle(index: Smallint; val: Integer); safecall;
    function  Get_EnableTBItem(index: Smallint): Smallint; safecall;
    procedure Set_EnableTBItem(index: Smallint; val: Smallint); safecall;
    function  Get_ToolStyle(index: CfxTool): CfxToolStyle; safecall;
    procedure Set_ToolStyle(index: CfxTool; val: CfxToolStyle); safecall;
    function  Get_ToolSize(index: CfxTool): Integer; safecall;
    procedure Set_ToolSize(index: CfxTool; val: Integer); safecall;
    function  Get_ToolPos(index: CfxTool): CfxToolPos; safecall;
    procedure Set_ToolPos(index: CfxTool; val: CfxToolPos); safecall;
    function  Get_Const_(index: Smallint): Double; safecall;
    procedure Set_Const_(index: Smallint; val: Double); safecall;
    function  Get_FixLeg(index: Smallint): WideString; safecall;
    procedure Set_FixLeg(index: Smallint; const val: WideString); safecall;
    function  Get_TBItemID(nIndex: Smallint): CfxToolID; safecall;
    procedure Set_TBItemID(nIndex: Smallint; val: CfxToolID); safecall;
    function  Get_MultiPoint(index: Smallint): CfxPointType; safecall;
    procedure Set_MultiPoint(index: Smallint; val: CfxPointType); safecall;
    function  Get_Adm(index: CfxAdm): Double; safecall;
    procedure Set_Adm(index: CfxAdm; val: Double); safecall;
    function  Get_DecimalsNum(index: CfxDecimal): Smallint; safecall;
    procedure Set_DecimalsNum(index: CfxDecimal; val: Smallint); safecall;
    function  Get_BarBitmap(index: Smallint): IPictureDisp; safecall;
    procedure Set_BarBitmap(index: Smallint; const val: IPictureDisp); safecall;
    function  Get_Value(index: Integer): Double; safecall;
    procedure Set_Value(index: Integer; val: Double); safecall;
    function  Get_Xvalue(index: Integer): Double; safecall;
    procedure Set_Xvalue(index: Integer; val: Double); safecall;
    function  Get_IniValue(index: Integer): Double; safecall;
    procedure Set_IniValue(index: Integer; val: Double); safecall;
    function  SetStripe(index: Smallint; dMin: Double; dMax: Double; rgb: OLE_COLOR): Integer; safecall;
    procedure ValueToPixel(Xvalue: Double; Yvalue: Double; out x: Integer; out y: Integer; 
                           nYAxis: CfxAxisIndex); safecall;
    procedure PixelToValue(x: Integer; y: Integer; out Xvalue: Double; out Yvalue: Double; 
                           nYAxis: CfxAxisIndex); safecall;
    procedure CompactSeriesAttributes(bGallery: WordBool); safecall;
    procedure UpdateSizeNow; safecall;
    function  Get_CrossHairs: WordBool; safecall;
    procedure Set_CrossHairs(val: WordBool); safecall;
    function  Get_PointLabelMask: WideString; safecall;
    procedure Set_PointLabelMask(const pVal: WideString); safecall;
    property hWnd: SYSUINT read Get_hWnd;
    property Enabled: WordBool read Get_Enabled write Set_Enabled;
    property Gallery: CfxGallery read Get_Gallery write Set_Gallery;
    property TypeMask: CfxType read Get_TypeMask write Set_TypeMask;
    property Style: CfxStyle read Get_Style write Set_Style;
    property NSeries: Integer read Get_NSeries write Set_NSeries;
    property LeftGap: Smallint read Get_LeftGap write Set_LeftGap;
    property RightGap: Smallint read Get_RightGap write Set_RightGap;
    property TopGap: Smallint read Get_TopGap write Set_TopGap;
    property BottomGap: Smallint read Get_BottomGap write Set_BottomGap;
    property MenuBar: WordBool read Get_MenuBar write Set_MenuBar;
    property Scheme: CfxScheme read Get_Scheme write Set_Scheme;
    property Stacked: CfxStacked read Get_Stacked write Set_Stacked;
    property Grid: CfxGrid read Get_Grid write Set_Grid;
    property WallWidth: Smallint read Get_WallWidth write Set_WallWidth;
    property Border: WordBool read Get_Border write Set_Border;
    property BorderColor: OLE_COLOR read Get_BorderColor write Set_BorderColor;
    property LineWidth: Smallint read Get_LineWidth write Set_LineWidth;
    property LineStyle: CfxLineStyle read Get_LineStyle write Set_LineStyle;
    property View3D: WordBool read Get_View3D write Set_View3D;
    property AngleX: Smallint read Get_AngleX write Set_AngleX;
    property AngleY: Smallint read Get_AngleY write Set_AngleY;
    property RGBBk: OLE_COLOR read Get_RGBBk write Set_RGBBk;
    property RGB2DBk: OLE_COLOR read Get_RGB2DBk write Set_RGB2DBk;
    property RGB3DBk: OLE_COLOR read Get_RGB3DBk write Set_RGB3DBk;
    property HText: WideString read Get_HText write Set_HText;
    property ChartStatus: CfxChartStatus read Get_ChartStatus write Set_ChartStatus;
    property AxesStyle: CfxAxesStyle read Get_AxesStyle write Set_AxesStyle;
    property Chart3D: WordBool read Get_Chart3D write Set_Chart3D;
    property ToolBar: WordBool read Get_ToolBar write Set_ToolBar;
    property PaletteBar: WordBool read Get_PaletteBar write Set_PaletteBar;
    property PatternBar: WordBool read Get_PatternBar write Set_PatternBar;
    property ReturnValue: Integer read Get_ReturnValue write Set_ReturnValue;
    property FileMask: CfxFileMask read Get_FileMask write Set_FileMask;
    property PropPageMask: Integer read Get_PropPageMask write Set_PropPageMask;
    property TipMask: WideString write Set_TipMask;
    property MarkerStep: Smallint read Get_MarkerStep write Set_MarkerStep;
    property MarkerShape: CfxPointType read Get_MarkerShape write Set_MarkerShape;
    property MarkerSize: Smallint read Get_MarkerSize write Set_MarkerSize;
    property Volume: Smallint read Get_Volume write Set_Volume;
    property View3DLight: Smallint read Get_View3DLight write Set_View3DLight;
    property CylSides: Smallint read Get_CylSides write Set_CylSides;
    property BorderStyle: CfxBorderStyle read Get_BorderStyle write Set_BorderStyle;
    property MaxValues: Integer read Get_MaxValues write Set_MaxValues;
    property Perspective: Smallint read Get_Perspective write Set_Perspective;
    property Zoom: WordBool read Get_Zoom write Set_Zoom;
    property DataStyle: CfxDataStyle read Get_DataStyle write Set_DataStyle;
    property TypeEx: CfxTypeEx read Get_TypeEx write Set_TypeEx;
    property StyleEx: CfxStyleEx read Get_StyleEx write Set_StyleEx;
    property MouseCapture: WordBool read Get_MouseCapture write Set_MouseCapture;
    property PointLabels: WordBool read Get_PointLabels write Set_PointLabels;
    property PointLabelAlign: CfxAlign read Get_PointLabelAlign write Set_PointLabelAlign;
    property PointLabelAngle: Smallint read Get_PointLabelAngle write Set_PointLabelAngle;
    property NValues: Integer read Get_NValues write Set_NValues;
    property BkPicture: IPictureDisp read Get_BkPicture write Set_BkPicture;
    property LeftFont: IFontDisp read Get_LeftFont write Set_LeftFont;
    property RightFont: IFontDisp read Get_RightFont write Set_RightFont;
    property TopFont: IFontDisp read Get_TopFont write Set_TopFont;
    property BottomFont: IFontDisp read Get_BottomFont write Set_BottomFont;
    property XLegFont: IFontDisp read Get_XLegFont write Set_XLegFont;
    property YLegFont: IFontDisp read Get_YLegFont write Set_YLegFont;
    property FixedFont: IFontDisp read Get_FixedFont write Set_FixedFont;
    property LegendFont: IFontDisp read Get_LegendFont write Set_LegendFont;
    property PointLabelsFont: IFontDisp read Get_PointLabelsFont write Set_PointLabelsFont;
    property PointFont: IFontDisp read Get_PointFont write Set_PointFont;
    property View3DDepth: Smallint read Get_View3DDepth write Set_View3DDepth;
    property Scrollable: WordBool read Get_Scrollable write Set_Scrollable;
    property RealTimeStyle: CfxRealTimeStyle read Get_RealTimeStyle write Set_RealTimeStyle;
    property Series: ICfxSeriesEnum read Get_Series;
    property Axis: ICfxAxisEnum read Get_Axis;
    property ConstantLine: ICfxConstEnum read Get_ConstantLine;
    property Stripe: ICfxStripeEnum read Get_Stripe;
    property Commands: ICommandBar read Get_Commands;
    property ToolBarObj: IToolBar read Get_ToolBarObj;
    property MenuBarObj: IToolBar read Get_MenuBarObj;
    property LegendBoxObj: ICfxLegendBox read Get_LegendBoxObj;
    property SerLegBoxObj: ICfxLegendBox read Get_SerLegBoxObj;
    property PaletteBarObj: ICfxPalette read Get_PaletteBarObj;
    property PatternBarObj: ICfxPalette read Get_PatternBarObj;
    property DataEditorObj: ICfxDataEditor read Get_DataEditorObj;
    property Printer: ICfxPrinter read Get_Printer;
    property Cluster: WordBool read Get_Cluster write Set_Cluster;
    property Palette: WideString read Get_Palette write Set_Palette;
    property LegendBox: WordBool read Get_LegendBox write Set_LegendBox;
    property SerLegBox: WordBool read Get_SerLegBox write Set_SerLegBox;
    property DataEditor: WordBool read Get_DataEditor write Set_DataEditor;
    property MultipleColors: WordBool read Get_MultipleColors write Set_MultipleColors;
    property AllowDrag: WordBool read Get_AllowDrag write Set_AllowDrag;
    property AllowResize: WordBool read Get_AllowResize write Set_AllowResize;
    property AllowEdit: WordBool read Get_AllowEdit write Set_AllowEdit;
    property ShowTips: WordBool read Get_ShowTips write Set_ShowTips;
    property ContextMenus: WordBool read Get_ContextMenus write Set_ContextMenus;
    property DataSourceAdo: DataSource read Get_DataSourceAdo write Set_DataSourceAdo;
    property DataMemberAdo: DataMember read Get_DataMemberAdo write Set_DataMemberAdo;
    property DataSource: _VBDataSource read Get_DataSource write Set_DataSource;
    property TypeProp[nGallery: Smallint]: Integer read Get_TypeProp write Set_TypeProp;
    property ValueEx[nSerie: Smallint; nPoint: Integer]: Double read Get_ValueEx write Set_ValueEx;
    property XValueEx[nSerie: Smallint; nPoint: Integer]: Double read Get_XValueEx write Set_XValueEx;
    property IniValueEx[nSerie: Smallint; nPoint: Integer]: Double read Get_IniValueEx write Set_IniValueEx;
    property Pattern[index: Smallint]: Smallint read Get_Pattern write Set_Pattern;
    property Title[index: CfxTitle]: WideString read Get_Title write Set_Title;
    property Legend[index: Integer]: WideString read Get_Legend write Set_Legend;
    property KeyLeg[index: Integer]: WideString read Get_KeyLeg write Set_KeyLeg;
    property YLeg[index: Integer]: WideString read Get_YLeg write Set_YLeg;
    property Fonts[index: CfxFont]: CfxFontAttr read Get_Fonts write Set_Fonts;
    property HFont[index: CfxFont]: Integer read Get_HFont write Set_HFont;
    property RGBFont[index: CfxFont]: OLE_COLOR read Get_RGBFont write Set_RGBFont;
    property ItemWidth[index: CfxItem]: Smallint read Get_ItemWidth write Set_ItemWidth;
    property ItemColor[index: CfxItem]: OLE_COLOR read Get_ItemColor write Set_ItemColor;
    property ItemStyle[index: CfxItem]: Integer read Get_ItemStyle write Set_ItemStyle;
    property ItemBkColor[index: CfxItem]: OLE_COLOR read Get_ItemBkColor write Set_ItemBkColor;
    property SeparateSlice[index: Smallint]: Smallint read Get_SeparateSlice write Set_SeparateSlice;
    property DataType[index: Smallint]: CfxDataType read Get_DataType write Set_DataType;
    property Color[index: Smallint]: OLE_COLOR read Get_Color write Set_Color;
    property BkColor[index: Smallint]: OLE_COLOR read Get_BkColor write Set_BkColor;
    property SerLeg[index: Smallint]: WideString read Get_SerLeg write Set_SerLeg;
    property KeySer[index: Smallint]: WideString read Get_KeySer write Set_KeySer;
    property ChartType: CfxGallery read Get_ChartType write Set_ChartType;
    property MarkerVolume: Smallint read Get_MarkerVolume write Set_MarkerVolume;
    property PointType: CfxPointType read Get_PointType write Set_PointType;
    property Type_: CfxType read Get_Type_ write Set_Type_;
    property Shape: Smallint read Get_Shape write Set_Shape;
    property PixFactor: Smallint read Get_PixFactor write Set_PixFactor;
    property FixedGap: Smallint read Get_FixedGap write Set_FixedGap;
    property BarHorzGap: Smallint read Get_BarHorzGap write Set_BarHorzGap;
    property RGBBarHorz: OLE_COLOR read Get_RGBBarHorz write Set_RGBBarHorz;
    property VertGridGap: Smallint read Get_VertGridGap write Set_VertGridGap;
    property ConstType: CfxConstType read Get_ConstType write Set_ConstType;
    property GalleryTool: CfxGalleryTool read Get_GalleryTool write Set_GalleryTool;
    property LegStyle: CfxLegStyle read Get_LegStyle write Set_LegStyle;
    property CurrentAxis: CfxAxisIndex read Get_CurrentAxis write Set_CurrentAxis;
    property CustomTool: CfxCustomTool read Get_CustomTool write Set_CustomTool;
    property TBBitmap: IPictureDisp read Get_TBBitmap write Set_TBBitmap;
    property Angles3D: Integer read Get_Angles3D write Set_Angles3D;
    property AutoIncrement: WordBool read Get_AutoIncrement write Set_AutoIncrement;
    property ThisSerie: Smallint read Get_ThisSerie write Set_ThisSerie;
    property ThisValue: Double read Get_ThisValue write Set_ThisValue;
    property ThisPoint: Integer read Get_ThisPoint write Set_ThisPoint;
    property MultiType[index: Smallint]: CfxType read Get_MultiType write Set_MultiType;
    property MultiShape[index: Smallint]: Smallint read Get_MultiShape write Set_MultiShape;
    property MultiLineStyle[index: Smallint]: Integer read Get_MultiLineStyle write Set_MultiLineStyle;
    property MultiYAxis[index: Smallint]: CfxAxisIndex read Get_MultiYAxis write Set_MultiYAxis;
    property TBItemStyle[index: Smallint]: Integer read Get_TBItemStyle write Set_TBItemStyle;
    property EnableTBItem[index: Smallint]: Smallint read Get_EnableTBItem write Set_EnableTBItem;
    property ToolStyle[index: CfxTool]: CfxToolStyle read Get_ToolStyle write Set_ToolStyle;
    property ToolSize[index: CfxTool]: Integer read Get_ToolSize write Set_ToolSize;
    property ToolPos[index: CfxTool]: CfxToolPos read Get_ToolPos write Set_ToolPos;
    property Const_[index: Smallint]: Double read Get_Const_ write Set_Const_;
    property FixLeg[index: Smallint]: WideString read Get_FixLeg write Set_FixLeg;
    property TBItemID[nIndex: Smallint]: CfxToolID read Get_TBItemID write Set_TBItemID;
    property MultiPoint[index: Smallint]: CfxPointType read Get_MultiPoint write Set_MultiPoint;
    property Adm[index: CfxAdm]: Double read Get_Adm write Set_Adm;
    property DecimalsNum[index: CfxDecimal]: Smallint read Get_DecimalsNum write Set_DecimalsNum;
    property BarBitmap[index: Smallint]: IPictureDisp read Get_BarBitmap write Set_BarBitmap;
    property Value[index: Integer]: Double read Get_Value write Set_Value;
    property Xvalue[index: Integer]: Double read Get_Xvalue write Set_Xvalue;
    property IniValue[index: Integer]: Double read Get_IniValue write Set_IniValue;
    property CrossHairs: WordBool read Get_CrossHairs write Set_CrossHairs;
    property PointLabelMask: WideString read Get_PointLabelMask write Set_PointLabelMask;
  end;

// *********************************************************************//
// DispIntf:  IChartFXDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {608E8B10-3690-11D1-8FD4-00AA00BD091C}
// *********************************************************************//
  IChartFXDisp = dispinterface
    ['{608E8B10-3690-11D1-8FD4-00AA00BD091C}']
    procedure Refresh; dispid -550;
    procedure AboutBox; dispid -552;
    property hWnd: SYSUINT readonly dispid -515;
    property Enabled: WordBool dispid -514;
    property Gallery: CfxGallery dispid 1;
    property TypeMask: CfxType dispid 2;
    property Style: CfxStyle dispid 3;
    property NSeries: Integer dispid 4;
    property LeftGap: Smallint dispid 5;
    property RightGap: Smallint dispid 6;
    property TopGap: Smallint dispid 7;
    property BottomGap: Smallint dispid 8;
    property MenuBar: WordBool dispid 9;
    property Scheme: CfxScheme dispid 10;
    property Stacked: CfxStacked dispid 11;
    property Grid: CfxGrid dispid 12;
    property WallWidth: Smallint dispid 13;
    property Border: WordBool dispid 14;
    property BorderColor: OLE_COLOR dispid 15;
    property LineWidth: Smallint dispid 16;
    property LineStyle: CfxLineStyle dispid 17;
    property View3D: WordBool dispid 18;
    property AngleX: Smallint dispid 19;
    property AngleY: Smallint dispid 20;
    property RGBBk: OLE_COLOR dispid 21;
    property RGB2DBk: OLE_COLOR dispid 22;
    property RGB3DBk: OLE_COLOR dispid 23;
    property HText: WideString dispid 24;
    property ChartStatus: CfxChartStatus dispid 25;
    property AxesStyle: CfxAxesStyle dispid 26;
    property Chart3D: WordBool dispid 27;
    property ToolBar: WordBool dispid 28;
    property PaletteBar: WordBool dispid 29;
    property PatternBar: WordBool dispid 30;
    property ReturnValue: Integer dispid 31;
    property FileMask: CfxFileMask dispid 32;
    property PropPageMask: Integer dispid 33;
    property TipMask: WideString writeonly dispid 34;
    property MarkerStep: Smallint dispid 35;
    property MarkerShape: CfxPointType dispid 36;
    property MarkerSize: Smallint dispid 37;
    property Volume: Smallint dispid 38;
    property View3DLight: Smallint dispid 39;
    property CylSides: Smallint dispid 40;
    property BorderStyle: CfxBorderStyle dispid 41;
    property MaxValues: Integer dispid 42;
    property Perspective: Smallint dispid 43;
    property Zoom: WordBool dispid 44;
    property DataStyle: CfxDataStyle dispid 45;
    property TypeEx: CfxTypeEx dispid 46;
    property StyleEx: CfxStyleEx dispid 47;
    property MouseCapture: WordBool dispid 48;
    property PointLabels: WordBool dispid 49;
    property PointLabelAlign: CfxAlign dispid 50;
    property PointLabelAngle: Smallint dispid 51;
    property NValues: Integer dispid 52;
    property BkPicture: IPictureDisp dispid 54;
    property LeftFont: IFontDisp dispid 55;
    property RightFont: IFontDisp dispid 56;
    property TopFont: IFontDisp dispid 57;
    property BottomFont: IFontDisp dispid 58;
    property XLegFont: IFontDisp dispid 59;
    property YLegFont: IFontDisp dispid 60;
    property FixedFont: IFontDisp dispid 61;
    property LegendFont: IFontDisp dispid 62;
    property PointLabelsFont: IFontDisp dispid 63;
    property PointFont: IFontDisp dispid 64;
    property View3DDepth: Smallint dispid 65;
    property Scrollable: WordBool dispid 66;
    property RealTimeStyle: CfxRealTimeStyle dispid 67;
    property Series: ICfxSeriesEnum readonly dispid 68;
    property Axis: ICfxAxisEnum readonly dispid 69;
    property ConstantLine: ICfxConstEnum readonly dispid 70;
    property Stripe: ICfxStripeEnum readonly dispid 71;
    property Commands: ICommandBar readonly dispid 72;
    property ToolBarObj: IToolBar readonly dispid 73;
    property MenuBarObj: IToolBar readonly dispid 74;
    property LegendBoxObj: ICfxLegendBox readonly dispid 75;
    property SerLegBoxObj: ICfxLegendBox readonly dispid 76;
    property PaletteBarObj: ICfxPalette readonly dispid 77;
    property PatternBarObj: ICfxPalette readonly dispid 78;
    property DataEditorObj: ICfxDataEditor readonly dispid 79;
    property Printer: ICfxPrinter readonly dispid 80;
    property Cluster: WordBool dispid 81;
    property Palette: WideString dispid 82;
    property LegendBox: WordBool dispid 83;
    property SerLegBox: WordBool dispid 84;
    property DataEditor: WordBool dispid 85;
    property MultipleColors: WordBool dispid 86;
    property AllowDrag: WordBool dispid 87;
    property AllowResize: WordBool dispid 88;
    property AllowEdit: WordBool dispid 89;
    property ShowTips: WordBool dispid 90;
    property ContextMenus: WordBool dispid 91;
    property DataSourceAdo: DataSource dispid 92;
    property DataMemberAdo: DataMember dispid 93;
    property DataSource: _VBDataSource dispid 94;
    property TypeProp[nGallery: Smallint]: Integer dispid 200;
    property ValueEx[nSerie: Smallint; nPoint: Integer]: Double dispid 201;
    property XValueEx[nSerie: Smallint; nPoint: Integer]: Double dispid 202;
    property IniValueEx[nSerie: Smallint; nPoint: Integer]: Double dispid 203;
    property Pattern[index: Smallint]: Smallint dispid 204;
    property Title[index: CfxTitle]: WideString dispid 205;
    property Legend[index: Integer]: WideString dispid 206;
    property KeyLeg[index: Integer]: WideString dispid 207;
    property YLeg[index: Integer]: WideString dispid 208;
    property Fonts[index: CfxFont]: CfxFontAttr dispid 209;
    property HFont[index: CfxFont]: Integer dispid 210;
    property RGBFont[index: CfxFont]: OLE_COLOR dispid 211;
    property ItemWidth[index: CfxItem]: Smallint dispid 212;
    property ItemColor[index: CfxItem]: OLE_COLOR dispid 213;
    property ItemStyle[index: CfxItem]: Integer dispid 214;
    property ItemBkColor[index: CfxItem]: OLE_COLOR dispid 215;
    property SeparateSlice[index: Smallint]: Smallint dispid 216;
    property DataType[index: Smallint]: CfxDataType dispid 217;
    property Color[index: Smallint]: OLE_COLOR dispid 218;
    property BkColor[index: Smallint]: OLE_COLOR dispid 219;
    property SerLeg[index: Smallint]: WideString dispid 220;
    property KeySer[index: Smallint]: WideString dispid 221;
    function  OpenDataEx(nType: CfxCod; n1: Integer; n2: Integer): Integer; dispid 300;
    function  CloseData(nType: CfxCod): WordBool; dispid 301;
    function  DblClk(nType: CfxClick; lExtra: Integer): Integer; dispid 302;
    function  RigClk(nType: CfxClick; lExtra: Integer): Integer; dispid 303;
    function  ShowDialog(nDialog: CfxDialog; lExtra: Integer): Integer; dispid 304;
    function  ClearLegend(index: CfxLegend): Integer; dispid 305;
    function  PrintIt(nFrom: Smallint; nTo: Smallint): Integer; dispid 306;
    function  Scroll(wParam: CfxScroll; lParam: Integer): Integer; dispid 307;
    function  Paint(hDC: Integer; nLeft: Integer; nTop: Integer; nRight: Integer; nBottom: Integer; 
                    wAction: CfxChartPaint; lps: Integer): Integer; dispid 308;
    function  PaintInfo(index: CfxPaintInfo; vData: OleVariant): OleVariant; dispid 309;
    procedure PaintInfo2(nIndex: CfxPaintInfo; vData: OleVariant; var vResult: OleVariant); dispid 310;
    function  Export(nType: CfxExport; vData: OleVariant): Integer; dispid 311;
    function  Import(nType: CfxExport; vData: OleVariant): Integer; dispid 312;
    function  Language(const sResource: WideString): Integer; dispid 313;
    function  SendMsg(wMsg: Integer; wParam: Integer; lParam: Integer): Integer; dispid 314;
    procedure AddExtension(vExt: OleVariant); dispid 315;
    function  GetExtension(const sExtension: WideString): IUnknown; dispid 316;
    procedure RemoveExtension(const sExtension: WideString); dispid 317;
    function  GetPicture(nFormat: Smallint): IPictureDisp; dispid 318;
    procedure GetExternalData(vDataProvider: OleVariant; vPar: OleVariant); dispid 319;
    procedure RecalcScale; dispid 320;
    procedure SetContourLabels(STEP: Double); dispid 321;
    procedure AddBar(nID: Smallint; const pObj: IUnknown); dispid 322;
    function  GetBar(nID: Smallint): IUnknown; dispid 323;
    procedure RemoveBar(nID: Smallint); dispid 324;
    procedure ClearData(newVal: CfxDataMask); dispid 325;
    procedure ZoomIn(xMin: Double; yMin: Double; xMax: Double; yMax: Double); dispid 326;
    procedure _GetCChartFXPointer(out pChart: Integer); dispid 327;
    function  HitTest(x: Integer; y: Integer; out NSeries: Smallint; out nPoint: Integer): CfxHitTest; dispid 328;
    procedure ShowBalloon(const sText: WideString; x: Integer; y: Integer); dispid 329;
    procedure CreateWnd(hwndParent: Integer; nID: Smallint; x: Integer; y: Integer; cx: Integer; 
                        cy: Integer; dwStyle: Integer); dispid 330;
    function  SetEventHandler(const pObj: IUnknown): IUnknown; dispid 331;
    procedure ShowHelpTopic(const pszHelpDir: WideString; nTopic: Integer); dispid 332;
    property ChartType: CfxGallery dispid 400;
    property MarkerVolume: Smallint dispid 401;
    property PointType: CfxPointType dispid 402;
    property Type_: CfxType dispid 403;
    property Shape: Smallint dispid 404;
    property PixFactor: Smallint dispid 405;
    property FixedGap: Smallint dispid 406;
    property BarHorzGap: Smallint dispid 407;
    property RGBBarHorz: OLE_COLOR dispid 408;
    property VertGridGap: Smallint dispid 409;
    property ConstType: CfxConstType dispid 410;
    property GalleryTool: CfxGalleryTool dispid 411;
    property LegStyle: CfxLegStyle dispid 412;
    property CurrentAxis: CfxAxisIndex dispid 413;
    property CustomTool: CfxCustomTool dispid 414;
    property TBBitmap: IPictureDisp dispid 415;
    property Angles3D: Integer dispid 416;
    property AutoIncrement: WordBool dispid 417;
    property ThisSerie: Smallint dispid 418;
    property ThisValue: Double dispid 419;
    property ThisPoint: Integer dispid 420;
    property MultiType[index: Smallint]: CfxType dispid 421;
    property MultiShape[index: Smallint]: Smallint dispid 422;
    property MultiLineStyle[index: Smallint]: Integer dispid 423;
    property MultiYAxis[index: Smallint]: CfxAxisIndex dispid 424;
    property TBItemStyle[index: Smallint]: Integer dispid 425;
    property EnableTBItem[index: Smallint]: Smallint dispid 426;
    property ToolStyle[index: CfxTool]: CfxToolStyle dispid 427;
    property ToolSize[index: CfxTool]: Integer dispid 428;
    property ToolPos[index: CfxTool]: CfxToolPos dispid 429;
    property Const_[index: Smallint]: Double dispid 430;
    property FixLeg[index: Smallint]: WideString dispid 431;
    property TBItemID[nIndex: Smallint]: CfxToolID dispid 432;
    property MultiPoint[index: Smallint]: CfxPointType dispid 433;
    property Adm[index: CfxAdm]: Double dispid 434;
    property DecimalsNum[index: CfxDecimal]: Smallint dispid 435;
    property BarBitmap[index: Smallint]: IPictureDisp dispid 436;
    property Value[index: Integer]: Double dispid 437;
    property Xvalue[index: Integer]: Double dispid 438;
    property IniValue[index: Integer]: Double dispid 439;
    function  SetStripe(index: Smallint; dMin: Double; dMax: Double; rgb: OLE_COLOR): Integer; dispid 440;
    procedure ValueToPixel(Xvalue: Double; Yvalue: Double; out x: Integer; out y: Integer; 
                           nYAxis: CfxAxisIndex); dispid 333;
    procedure PixelToValue(x: Integer; y: Integer; out Xvalue: Double; out Yvalue: Double; 
                           nYAxis: CfxAxisIndex); dispid 334;
    procedure CompactSeriesAttributes(bGallery: WordBool); dispid 335;
    procedure UpdateSizeNow; dispid 336;
    property CrossHairs: WordBool dispid 337;
    property PointLabelMask: WideString dispid 338;
  end;

// *********************************************************************//
// Interface: ICfxSeriesEnum
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1D3266D1-745C-11D0-9223-00A0244D2920}
// *********************************************************************//
  ICfxSeriesEnum = interface(IDispatch)
    ['{1D3266D1-745C-11D0-9223-00A0244D2920}']
    function  Get_Count: Integer; safecall;
    function  Get_Item(index: Smallint): ICfxSeries; safecall;
    property Count: Integer read Get_Count;
    property Item[index: Smallint]: ICfxSeries read Get_Item; default;
  end;

// *********************************************************************//
// DispIntf:  ICfxSeriesEnumDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1D3266D1-745C-11D0-9223-00A0244D2920}
// *********************************************************************//
  ICfxSeriesEnumDisp = dispinterface
    ['{1D3266D1-745C-11D0-9223-00A0244D2920}']
    property Count: Integer readonly dispid 1;
    property Item[index: Smallint]: ICfxSeries readonly dispid 0; default;
  end;

// *********************************************************************//
// Interface: ICfxSeries
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1D3266C1-745C-11D0-9223-00A0244D2920}
// *********************************************************************//
  ICfxSeries = interface(IDispatch)
    ['{1D3266C1-745C-11D0-9223-00A0244D2920}']
    function  Get_TypeMask: CfxType; safecall;
    procedure Set_TypeMask(val: CfxType); safecall;
    function  Get_CylSides: Smallint; safecall;
    procedure Set_CylSides(val: Smallint); safecall;
    function  Get_YAxis: CfxAxisIndex; safecall;
    procedure Set_YAxis(val: CfxAxisIndex); safecall;
    function  Get_Border: WordBool; safecall;
    procedure Set_Border(val: WordBool); safecall;
    function  Get_BorderColor: OLE_COLOR; safecall;
    procedure Set_BorderColor(val: OLE_COLOR); safecall;
    function  Get_LineWidth: Smallint; safecall;
    procedure Set_LineWidth(val: Smallint); safecall;
    function  Get_LineStyle: CfxLineStyle; safecall;
    procedure Set_LineStyle(val: CfxLineStyle); safecall;
    function  Get_MarkerShape: CfxPointType; safecall;
    procedure Set_MarkerShape(val: CfxPointType); safecall;
    function  Get_Stacked: WordBool; safecall;
    procedure Set_Stacked(val: WordBool); safecall;
    function  Get_Yvalue(index: Integer): Double; safecall;
    procedure Set_Yvalue(index: Integer; val: Double); safecall;
    function  Get_Xvalue(index: Integer): Double; safecall;
    procedure Set_Xvalue(index: Integer; val: Double); safecall;
    function  Get_Legend: WideString; safecall;
    procedure Set_Legend(const val: WideString); safecall;
    function  Get_Color: OLE_COLOR; safecall;
    procedure Set_Color(val: OLE_COLOR); safecall;
    function  Get_MarkerSize: Smallint; safecall;
    procedure Set_MarkerSize(val: Smallint); safecall;
    function  Get_XAxis: CfxAxisIndex; safecall;
    procedure Set_XAxis(val: CfxAxisIndex); safecall;
    function  Get_Gallery: CfxGallery; safecall;
    procedure Set_Gallery(val: CfxGallery); safecall;
    function  Get_Volume: Smallint; safecall;
    procedure Set_Volume(val: Smallint); safecall;
    function  Get_Picture: IPictureDisp; safecall;
    procedure Set_Picture(const val: IPictureDisp); safecall;
    function  Get_PointLabels: WordBool; safecall;
    procedure Set_PointLabels(val: WordBool); safecall;
    function  Get_YFrom(index: Integer): Double; safecall;
    procedure Set_YFrom(index: Integer; val: Double); safecall;
    function  Get_BkColor: OLE_COLOR; safecall;
    procedure Set_BkColor(val: OLE_COLOR); safecall;
    function  Get_Pattern: Smallint; safecall;
    procedure Set_Pattern(val: Smallint); safecall;
    function  Get_MarkerStep: Smallint; safecall;
    procedure Set_MarkerStep(pVal: Smallint); safecall;
    function  Get_PointLabelAlign: CfxAlign; safecall;
    procedure Set_PointLabelAlign(pVal: CfxAlign); safecall;
    function  Get_PointLabelAngle: Smallint; safecall;
    procedure Set_PointLabelAngle(pVal: Smallint); safecall;
    function  Get_Visible: WordBool; safecall;
    procedure Set_Visible(pVal: WordBool); safecall;
    property TypeMask: CfxType read Get_TypeMask write Set_TypeMask;
    property CylSides: Smallint read Get_CylSides write Set_CylSides;
    property YAxis: CfxAxisIndex read Get_YAxis write Set_YAxis;
    property Border: WordBool read Get_Border write Set_Border;
    property BorderColor: OLE_COLOR read Get_BorderColor write Set_BorderColor;
    property LineWidth: Smallint read Get_LineWidth write Set_LineWidth;
    property LineStyle: CfxLineStyle read Get_LineStyle write Set_LineStyle;
    property MarkerShape: CfxPointType read Get_MarkerShape write Set_MarkerShape;
    property Stacked: WordBool read Get_Stacked write Set_Stacked;
    property Yvalue[index: Integer]: Double read Get_Yvalue write Set_Yvalue;
    property Xvalue[index: Integer]: Double read Get_Xvalue write Set_Xvalue;
    property Legend: WideString read Get_Legend write Set_Legend;
    property Color: OLE_COLOR read Get_Color write Set_Color;
    property MarkerSize: Smallint read Get_MarkerSize write Set_MarkerSize;
    property XAxis: CfxAxisIndex read Get_XAxis write Set_XAxis;
    property Gallery: CfxGallery read Get_Gallery write Set_Gallery;
    property Volume: Smallint read Get_Volume write Set_Volume;
    property Picture: IPictureDisp read Get_Picture write Set_Picture;
    property PointLabels: WordBool read Get_PointLabels write Set_PointLabels;
    property YFrom[index: Integer]: Double read Get_YFrom write Set_YFrom;
    property BkColor: OLE_COLOR read Get_BkColor write Set_BkColor;
    property Pattern: Smallint read Get_Pattern write Set_Pattern;
    property MarkerStep: Smallint read Get_MarkerStep write Set_MarkerStep;
    property PointLabelAlign: CfxAlign read Get_PointLabelAlign write Set_PointLabelAlign;
    property PointLabelAngle: Smallint read Get_PointLabelAngle write Set_PointLabelAngle;
    property Visible: WordBool read Get_Visible write Set_Visible;
  end;

// *********************************************************************//
// DispIntf:  ICfxSeriesDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1D3266C1-745C-11D0-9223-00A0244D2920}
// *********************************************************************//
  ICfxSeriesDisp = dispinterface
    ['{1D3266C1-745C-11D0-9223-00A0244D2920}']
    property TypeMask: CfxType dispid 1;
    property CylSides: Smallint dispid 2;
    property YAxis: CfxAxisIndex dispid 3;
    property Border: WordBool dispid 4;
    property BorderColor: OLE_COLOR dispid 5;
    property LineWidth: Smallint dispid 6;
    property LineStyle: CfxLineStyle dispid 7;
    property MarkerShape: CfxPointType dispid 8;
    property Stacked: WordBool dispid 9;
    property Yvalue[index: Integer]: Double dispid 10;
    property Xvalue[index: Integer]: Double dispid 11;
    property Legend: WideString dispid 12;
    property Color: OLE_COLOR dispid 13;
    property MarkerSize: Smallint dispid 14;
    property XAxis: CfxAxisIndex dispid 15;
    property Gallery: CfxGallery dispid 16;
    property Volume: Smallint dispid 17;
    property Picture: IPictureDisp dispid 18;
    property PointLabels: WordBool dispid 19;
    property YFrom[index: Integer]: Double dispid 20;
    property BkColor: OLE_COLOR dispid 21;
    property Pattern: Smallint dispid 22;
    property MarkerStep: Smallint dispid 23;
    property PointLabelAlign: CfxAlign dispid 24;
    property PointLabelAngle: Smallint dispid 25;
    property Visible: WordBool dispid 26;
  end;

// *********************************************************************//
// Interface: ICfxAxisEnum
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1D3266D2-745C-11D0-9223-00A0244D2920}
// *********************************************************************//
  ICfxAxisEnum = interface(IDispatch)
    ['{1D3266D2-745C-11D0-9223-00A0244D2920}']
    function  Get_Count: Integer; safecall;
    function  Get_Item(index: CfxAxisIndex): ICfxAxis; safecall;
    property Count: Integer read Get_Count;
    property Item[index: CfxAxisIndex]: ICfxAxis read Get_Item; default;
  end;

// *********************************************************************//
// DispIntf:  ICfxAxisEnumDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1D3266D2-745C-11D0-9223-00A0244D2920}
// *********************************************************************//
  ICfxAxisEnumDisp = dispinterface
    ['{1D3266D2-745C-11D0-9223-00A0244D2920}']
    property Count: Integer readonly dispid 1;
    property Item[index: CfxAxisIndex]: ICfxAxis readonly dispid 0; default;
  end;

// *********************************************************************//
// Interface: ICfxAxis
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1D3266C2-745C-11D0-9223-00A0244D2920}
// *********************************************************************//
  ICfxAxis = interface(IDispatch)
    ['{1D3266C2-745C-11D0-9223-00A0244D2920}']
    function  Get_Min: Double; safecall;
    procedure Set_Min(val: Double); safecall;
    function  Get_Max: Double; safecall;
    procedure Set_Max(val: Double); safecall;
    function  Get_ScaleUnit: Double; safecall;
    procedure Set_ScaleUnit(val: Double); safecall;
    function  Get_STEP: Double; safecall;
    procedure Set_STEP(val: Double); safecall;
    function  Get_MinorStep: Double; safecall;
    procedure Set_MinorStep(val: Double); safecall;
    function  Get_LogBase: Double; safecall;
    procedure Set_LogBase(val: Double); safecall;
    function  Get_Decimals: Smallint; safecall;
    procedure Set_Decimals(val: Smallint); safecall;
    function  Get_FontMask: CfxFontAttr; safecall;
    procedure Set_FontMask(val: CfxFontAttr); safecall;
    function  Get_TextColor: OLE_COLOR; safecall;
    procedure Set_TextColor(val: OLE_COLOR); safecall;
    function  Get_Font: IFontDisp; safecall;
    procedure Set_Font(const val: IFontDisp); safecall;
    function  Get_Format: OleVariant; safecall;
    procedure Set_Format(val: OleVariant); safecall;
    function  Get_Style: CfxAxisStyle; safecall;
    procedure Set_Style(val: CfxAxisStyle); safecall;
    function  Get_TickMark: CfxTickStyle; safecall;
    procedure Set_TickMark(val: CfxTickStyle); safecall;
    function  Get_GridWidth: Smallint; safecall;
    procedure Set_GridWidth(val: Smallint); safecall;
    function  Get_GridStyle: CfxLineStyle; safecall;
    procedure Set_GridStyle(val: CfxLineStyle); safecall;
    function  Get_GridColor: OLE_COLOR; safecall;
    procedure Set_GridColor(val: OLE_COLOR); safecall;
    function  Get_PixPerUnit: Double; safecall;
    procedure Set_PixPerUnit(val: Double); safecall;
    function  Get_LabelValue: Double; safecall;
    procedure Set_LabelValue(val: Double); safecall;
    function  Get_Title: WideString; safecall;
    procedure Set_Title(const pVal: WideString); safecall;
    function  Get_TitleFontMask: CfxFontAttr; safecall;
    procedure Set_TitleFontMask(val: CfxFontAttr); safecall;
    function  Get_TitleColor: OLE_COLOR; safecall;
    procedure Set_TitleColor(val: OLE_COLOR); safecall;
    function  Get_TitleFont: IFontDisp; safecall;
    procedure Set_TitleFont(const val: IFontDisp); safecall;
    function  Get_Label_(nIndex: Integer): WideString; safecall;
    procedure Set_Label_(nIndex: Integer; const val: WideString); safecall;
    function  Get_AutoScale: WordBool; safecall;
    procedure Set_AutoScale(val: WordBool); safecall;
    function  Get_MinorTickMark: CfxTickStyle; safecall;
    procedure Set_MinorTickMark(val: CfxTickStyle); safecall;
    function  Get_MinorGridWidth: Smallint; safecall;
    procedure Set_MinorGridWidth(val: Smallint); safecall;
    function  Get_MinorGridStyle: CfxLineStyle; safecall;
    procedure Set_MinorGridStyle(val: CfxLineStyle); safecall;
    function  Get_MinorGridColor: OLE_COLOR; safecall;
    procedure Set_MinorGridColor(val: OLE_COLOR); safecall;
    function  Get_LabelAngle: Smallint; safecall;
    procedure Set_LabelAngle(pVal: Smallint); safecall;
    function  Get_Grid: WordBool; safecall;
    procedure Set_Grid(pVal: WordBool); safecall;
    function  Get_MinorGrid: WordBool; safecall;
    procedure Set_MinorGrid(pVal: WordBool); safecall;
    function  Get_Notify: WordBool; safecall;
    procedure Set_Notify(pVal: WordBool); safecall;
    function  Get_KeyLabel(nIndex: Integer): WideString; safecall;
    procedure Set_KeyLabel(nIndex: Integer; const pVal: WideString); safecall;
    function  Get_FirstLabel: Smallint; safecall;
    procedure Set_FirstLabel(pVal: Smallint); safecall;
    function  Get_Visible: WordBool; safecall;
    procedure Set_Visible(pVal: WordBool); safecall;
    function  Get_ForceZero: WordBool; safecall;
    procedure Set_ForceZero(pVal: WordBool); safecall;
    procedure ClearLabels; safecall;
    procedure ResetScale; safecall;
    procedure AdjustScale; safecall;
    procedure SetScrollView(Min: Double; Max: Double); safecall;
    procedure GetScrollView(out Min: Double; out Max: Double); safecall;
    function  Get_Locale: Integer; safecall;
    procedure Set_Locale(pVal: Integer); safecall;
    function  Get_CurrencySymbol: WideString; safecall;
    procedure Set_CurrencySymbol(const pVal: WideString); safecall;
    function  Get_VisibleMin: Double; safecall;
    procedure Set_VisibleMin(val: Double); safecall;
    function  Get_VisibleMax: Double; safecall;
    procedure Set_VisibleMax(val: Double); safecall;
    property Min: Double read Get_Min write Set_Min;
    property Max: Double read Get_Max write Set_Max;
    property ScaleUnit: Double read Get_ScaleUnit write Set_ScaleUnit;
    property STEP: Double read Get_STEP write Set_STEP;
    property MinorStep: Double read Get_MinorStep write Set_MinorStep;
    property LogBase: Double read Get_LogBase write Set_LogBase;
    property Decimals: Smallint read Get_Decimals write Set_Decimals;
    property FontMask: CfxFontAttr read Get_FontMask write Set_FontMask;
    property TextColor: OLE_COLOR read Get_TextColor write Set_TextColor;
    property Font: IFontDisp read Get_Font write Set_Font;
    property Format: OleVariant read Get_Format write Set_Format;
    property Style: CfxAxisStyle read Get_Style write Set_Style;
    property TickMark: CfxTickStyle read Get_TickMark write Set_TickMark;
    property GridWidth: Smallint read Get_GridWidth write Set_GridWidth;
    property GridStyle: CfxLineStyle read Get_GridStyle write Set_GridStyle;
    property GridColor: OLE_COLOR read Get_GridColor write Set_GridColor;
    property PixPerUnit: Double read Get_PixPerUnit write Set_PixPerUnit;
    property LabelValue: Double read Get_LabelValue write Set_LabelValue;
    property Title: WideString read Get_Title write Set_Title;
    property TitleFontMask: CfxFontAttr read Get_TitleFontMask write Set_TitleFontMask;
    property TitleColor: OLE_COLOR read Get_TitleColor write Set_TitleColor;
    property TitleFont: IFontDisp read Get_TitleFont write Set_TitleFont;
    property Label_[nIndex: Integer]: WideString read Get_Label_ write Set_Label_;
    property AutoScale: WordBool read Get_AutoScale write Set_AutoScale;
    property MinorTickMark: CfxTickStyle read Get_MinorTickMark write Set_MinorTickMark;
    property MinorGridWidth: Smallint read Get_MinorGridWidth write Set_MinorGridWidth;
    property MinorGridStyle: CfxLineStyle read Get_MinorGridStyle write Set_MinorGridStyle;
    property MinorGridColor: OLE_COLOR read Get_MinorGridColor write Set_MinorGridColor;
    property LabelAngle: Smallint read Get_LabelAngle write Set_LabelAngle;
    property Grid: WordBool read Get_Grid write Set_Grid;
    property MinorGrid: WordBool read Get_MinorGrid write Set_MinorGrid;
    property Notify: WordBool read Get_Notify write Set_Notify;
    property KeyLabel[nIndex: Integer]: WideString read Get_KeyLabel write Set_KeyLabel;
    property FirstLabel: Smallint read Get_FirstLabel write Set_FirstLabel;
    property Visible: WordBool read Get_Visible write Set_Visible;
    property ForceZero: WordBool read Get_ForceZero write Set_ForceZero;
    property Locale: Integer read Get_Locale write Set_Locale;
    property CurrencySymbol: WideString read Get_CurrencySymbol write Set_CurrencySymbol;
    property VisibleMin: Double read Get_VisibleMin write Set_VisibleMin;
    property VisibleMax: Double read Get_VisibleMax write Set_VisibleMax;
  end;

// *********************************************************************//
// DispIntf:  ICfxAxisDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1D3266C2-745C-11D0-9223-00A0244D2920}
// *********************************************************************//
  ICfxAxisDisp = dispinterface
    ['{1D3266C2-745C-11D0-9223-00A0244D2920}']
    property Min: Double dispid 1;
    property Max: Double dispid 2;
    property ScaleUnit: Double dispid 3;
    property STEP: Double dispid 4;
    property MinorStep: Double dispid 5;
    property LogBase: Double dispid 6;
    property Decimals: Smallint dispid 7;
    property FontMask: CfxFontAttr dispid 8;
    property TextColor: OLE_COLOR dispid 9;
    property Font: IFontDisp dispid 10;
    property Format: OleVariant dispid 11;
    property Style: CfxAxisStyle dispid 12;
    property TickMark: CfxTickStyle dispid 13;
    property GridWidth: Smallint dispid 14;
    property GridStyle: CfxLineStyle dispid 15;
    property GridColor: OLE_COLOR dispid 16;
    property PixPerUnit: Double dispid 17;
    property LabelValue: Double dispid 19;
    property Title: WideString dispid 20;
    property TitleFontMask: CfxFontAttr dispid 21;
    property TitleColor: OLE_COLOR dispid 22;
    property TitleFont: IFontDisp dispid 23;
    property Label_[nIndex: Integer]: WideString dispid 24;
    property AutoScale: WordBool dispid 25;
    property MinorTickMark: CfxTickStyle dispid 26;
    property MinorGridWidth: Smallint dispid 27;
    property MinorGridStyle: CfxLineStyle dispid 28;
    property MinorGridColor: OLE_COLOR dispid 29;
    property LabelAngle: Smallint dispid 30;
    property Grid: WordBool dispid 31;
    property MinorGrid: WordBool dispid 32;
    property Notify: WordBool dispid 33;
    property KeyLabel[nIndex: Integer]: WideString dispid 34;
    property FirstLabel: Smallint dispid 35;
    property Visible: WordBool dispid 36;
    property ForceZero: WordBool dispid 37;
    procedure ClearLabels; dispid 50;
    procedure ResetScale; dispid 51;
    procedure AdjustScale; dispid 52;
    procedure SetScrollView(Min: Double; Max: Double); dispid 53;
    procedure GetScrollView(out Min: Double; out Max: Double); dispid 54;
    property Locale: Integer dispid 55;
    property CurrencySymbol: WideString dispid 56;
    property VisibleMin: Double dispid 38;
    property VisibleMax: Double dispid 39;
  end;

// *********************************************************************//
// Interface: ICfxConstEnum
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1D3266D3-745C-11D0-9223-00A0244D2920}
// *********************************************************************//
  ICfxConstEnum = interface(IDispatch)
    ['{1D3266D3-745C-11D0-9223-00A0244D2920}']
    function  Get_Count: Integer; safecall;
    function  Get_Item(index: Smallint): ICfxConst; safecall;
    property Count: Integer read Get_Count;
    property Item[index: Smallint]: ICfxConst read Get_Item; default;
  end;

// *********************************************************************//
// DispIntf:  ICfxConstEnumDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1D3266D3-745C-11D0-9223-00A0244D2920}
// *********************************************************************//
  ICfxConstEnumDisp = dispinterface
    ['{1D3266D3-745C-11D0-9223-00A0244D2920}']
    property Count: Integer readonly dispid 1;
    property Item[index: Smallint]: ICfxConst readonly dispid 0; default;
  end;

// *********************************************************************//
// Interface: ICfxConst
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1D3266C3-745C-11D0-9223-00A0244D2920}
// *********************************************************************//
  ICfxConst = interface(IDispatch)
    ['{1D3266C3-745C-11D0-9223-00A0244D2920}']
    function  Get_LineWidth: Smallint; safecall;
    procedure Set_LineWidth(val: Smallint); safecall;
    function  Get_LineStyle: CfxLineStyle; safecall;
    procedure Set_LineStyle(val: CfxLineStyle); safecall;
    function  Get_LineColor: OLE_COLOR; safecall;
    procedure Set_LineColor(val: OLE_COLOR); safecall;
    function  Get_Axis: CfxAxisIndex; safecall;
    procedure Set_Axis(val: CfxAxisIndex); safecall;
    function  Get_Label_: WideString; safecall;
    procedure Set_Label_(const val: WideString); safecall;
    function  Get_Value: Double; safecall;
    procedure Set_Value(val: Double); safecall;
    function  Get_Style: CfxConstType; safecall;
    procedure Set_Style(val: CfxConstType); safecall;
    property LineWidth: Smallint read Get_LineWidth write Set_LineWidth;
    property LineStyle: CfxLineStyle read Get_LineStyle write Set_LineStyle;
    property LineColor: OLE_COLOR read Get_LineColor write Set_LineColor;
    property Axis: CfxAxisIndex read Get_Axis write Set_Axis;
    property Label_: WideString read Get_Label_ write Set_Label_;
    property Value: Double read Get_Value write Set_Value;
    property Style: CfxConstType read Get_Style write Set_Style;
  end;

// *********************************************************************//
// DispIntf:  ICfxConstDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1D3266C3-745C-11D0-9223-00A0244D2920}
// *********************************************************************//
  ICfxConstDisp = dispinterface
    ['{1D3266C3-745C-11D0-9223-00A0244D2920}']
    property LineWidth: Smallint dispid 1;
    property LineStyle: CfxLineStyle dispid 2;
    property LineColor: OLE_COLOR dispid 3;
    property Axis: CfxAxisIndex dispid 4;
    property Label_: WideString dispid 5;
    property Value: Double dispid 6;
    property Style: CfxConstType dispid 7;
  end;

// *********************************************************************//
// Interface: ICfxStripeEnum
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1D3266D4-745C-11D0-9223-00A0244D2920}
// *********************************************************************//
  ICfxStripeEnum = interface(IDispatch)
    ['{1D3266D4-745C-11D0-9223-00A0244D2920}']
    function  Get_Count: Integer; safecall;
    function  Get_Item(index: Smallint): ICfxStripe; safecall;
    property Count: Integer read Get_Count;
    property Item[index: Smallint]: ICfxStripe read Get_Item; default;
  end;

// *********************************************************************//
// DispIntf:  ICfxStripeEnumDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1D3266D4-745C-11D0-9223-00A0244D2920}
// *********************************************************************//
  ICfxStripeEnumDisp = dispinterface
    ['{1D3266D4-745C-11D0-9223-00A0244D2920}']
    property Count: Integer readonly dispid 1;
    property Item[index: Smallint]: ICfxStripe readonly dispid 0; default;
  end;

// *********************************************************************//
// Interface: ICfxStripe
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1D3266C4-745C-11D0-9223-00A0244D2920}
// *********************************************************************//
  ICfxStripe = interface(IDispatch)
    ['{1D3266C4-745C-11D0-9223-00A0244D2920}']
    function  Get_From: Double; safecall;
    procedure Set_From(val: Double); safecall;
    function  Get_To_: Double; safecall;
    procedure Set_To_(val: Double); safecall;
    function  Get_Color: OLE_COLOR; safecall;
    procedure Set_Color(val: OLE_COLOR); safecall;
    function  Get_Axis: CfxAxisIndex; safecall;
    procedure Set_Axis(val: CfxAxisIndex); safecall;
    property From: Double read Get_From write Set_From;
    property To_: Double read Get_To_ write Set_To_;
    property Color: OLE_COLOR read Get_Color write Set_Color;
    property Axis: CfxAxisIndex read Get_Axis write Set_Axis;
  end;

// *********************************************************************//
// DispIntf:  ICfxStripeDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1D3266C4-745C-11D0-9223-00A0244D2920}
// *********************************************************************//
  ICfxStripeDisp = dispinterface
    ['{1D3266C4-745C-11D0-9223-00A0244D2920}']
    property From: Double dispid 1;
    property To_: Double dispid 2;
    property Color: OLE_COLOR dispid 3;
    property Axis: CfxAxisIndex dispid 4;
  end;

// *********************************************************************//
// Interface: ICfxLegendBox
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8A906AC2-BE4B-11D1-B134-00A0244D2920}
// *********************************************************************//
  ICfxLegendBox = interface(IBarWndDisp)
    ['{8A906AC2-BE4B-11D1-B134-00A0244D2920}']
    function  Get_FontMask: CfxFontAttr; safecall;
    procedure Set_FontMask(val: CfxFontAttr); safecall;
    function  Get_TextColor: OLE_COLOR; safecall;
    procedure Set_TextColor(val: OLE_COLOR); safecall;
    function  Get_Font: IFontDisp; safecall;
    procedure Set_Font(const val: IFontDisp); safecall;
    function  Get_SkipEmpty: WordBool; safecall;
    procedure Set_SkipEmpty(val: WordBool); safecall;
    function  Get_MultiLine: WordBool; safecall;
    procedure Set_MultiLine(val: WordBool); safecall;
    function  Get_Flags: CfxLegendBoxFlag; safecall;
    procedure Set_Flags(pVal: CfxLegendBoxFlag); safecall;
    property FontMask: CfxFontAttr read Get_FontMask write Set_FontMask;
    property TextColor: OLE_COLOR read Get_TextColor write Set_TextColor;
    property Font: IFontDisp read Get_Font write Set_Font;
    property SkipEmpty: WordBool read Get_SkipEmpty write Set_SkipEmpty;
    property MultiLine: WordBool read Get_MultiLine write Set_MultiLine;
    property Flags: CfxLegendBoxFlag read Get_Flags write Set_Flags;
  end;

// *********************************************************************//
// DispIntf:  ICfxLegendBoxDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8A906AC2-BE4B-11D1-B134-00A0244D2920}
// *********************************************************************//
  ICfxLegendBoxDisp = dispinterface
    ['{8A906AC2-BE4B-11D1-B134-00A0244D2920}']
    property FontMask: CfxFontAttr dispid 30;
    property TextColor: OLE_COLOR dispid 31;
    property Font: IFontDisp dispid 32;
    property SkipEmpty: WordBool dispid 33;
    property MultiLine: WordBool dispid 34;
    property Flags: CfxLegendBoxFlag dispid 35;
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
// Interface: ICfxPalette
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A24604BA-C27F-11D1-9C4E-00A0244D2920}
// *********************************************************************//
  ICfxPalette = interface(IBarWndDisp)
    ['{A24604BA-C27F-11D1-9C4E-00A0244D2920}']
  end;

// *********************************************************************//
// DispIntf:  ICfxPaletteDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A24604BA-C27F-11D1-9C4E-00A0244D2920}
// *********************************************************************//
  ICfxPaletteDisp = dispinterface
    ['{A24604BA-C27F-11D1-9C4E-00A0244D2920}']
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
// Interface: ICfxDataEditor
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EDBC92F0-B34C-11D1-B134-00A0244D2920}
// *********************************************************************//
  ICfxDataEditor = interface(IBarWndDisp)
    ['{EDBC92F0-B34C-11D1-B134-00A0244D2920}']
    function  Get_FontMask: CfxFontAttr; safecall;
    procedure Set_FontMask(val: CfxFontAttr); safecall;
    function  Get_TextColor: OLE_COLOR; safecall;
    procedure Set_TextColor(val: OLE_COLOR); safecall;
    function  Get_Font: IFontDisp; safecall;
    procedure Set_Font(const val: IFontDisp); safecall;
    procedure Scroll(nScrollCode: CfxScroll; nPos: Smallint; bHorz: WordBool); safecall;
    property FontMask: CfxFontAttr read Get_FontMask write Set_FontMask;
    property TextColor: OLE_COLOR read Get_TextColor write Set_TextColor;
    property Font: IFontDisp read Get_Font write Set_Font;
  end;

// *********************************************************************//
// DispIntf:  ICfxDataEditorDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EDBC92F0-B34C-11D1-B134-00A0244D2920}
// *********************************************************************//
  ICfxDataEditorDisp = dispinterface
    ['{EDBC92F0-B34C-11D1-B134-00A0244D2920}']
    property FontMask: CfxFontAttr dispid 30;
    property TextColor: OLE_COLOR dispid 31;
    property Font: IFontDisp dispid 32;
    procedure Scroll(nScrollCode: CfxScroll; nPos: Smallint; bHorz: WordBool); dispid 33;
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
// Interface: ICfxPrinter
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D5688691-E6B0-11D1-89B0-00AA00BD091C}
// *********************************************************************//
  ICfxPrinter = interface(IDispatch)
    ['{D5688691-E6B0-11D1-89B0-00AA00BD091C}']
    function  Get_UsePrinterResolution: WordBool; safecall;
    procedure Set_UsePrinterResolution(val: WordBool); safecall;
    function  Get_LeftMargin: Double; safecall;
    procedure Set_LeftMargin(val: Double); safecall;
    function  Get_RightMargin: Double; safecall;
    procedure Set_RightMargin(val: Double); safecall;
    function  Get_TopMargin: Double; safecall;
    procedure Set_TopMargin(val: Double); safecall;
    function  Get_BottomMargin: Double; safecall;
    procedure Set_BottomMargin(val: Double); safecall;
    function  Get_SeparateLegend: WordBool; safecall;
    procedure Set_SeparateLegend(val: WordBool); safecall;
    function  Get_Orientation: CfxOrientation; safecall;
    procedure Set_Orientation(val: CfxOrientation); safecall;
    function  Get_ForceColors: WordBool; safecall;
    procedure Set_ForceColors(val: WordBool); safecall;
    function  Get_Compress: WordBool; safecall;
    procedure Set_Compress(val: WordBool); safecall;
    procedure Set_PrinterDriver(const Param1: WideString); safecall;
    procedure Set_hDC(Param1: Integer); safecall;
    function  Get_Style: CfxPrintStyle; safecall;
    procedure Set_Style(val: CfxPrintStyle); safecall;
    property UsePrinterResolution: WordBool read Get_UsePrinterResolution write Set_UsePrinterResolution;
    property LeftMargin: Double read Get_LeftMargin write Set_LeftMargin;
    property RightMargin: Double read Get_RightMargin write Set_RightMargin;
    property TopMargin: Double read Get_TopMargin write Set_TopMargin;
    property BottomMargin: Double read Get_BottomMargin write Set_BottomMargin;
    property SeparateLegend: WordBool read Get_SeparateLegend write Set_SeparateLegend;
    property Orientation: CfxOrientation read Get_Orientation write Set_Orientation;
    property ForceColors: WordBool read Get_ForceColors write Set_ForceColors;
    property Compress: WordBool read Get_Compress write Set_Compress;
    property PrinterDriver: WideString write Set_PrinterDriver;
    property hDC: Integer write Set_hDC;
    property Style: CfxPrintStyle read Get_Style write Set_Style;
  end;

// *********************************************************************//
// DispIntf:  ICfxPrinterDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D5688691-E6B0-11D1-89B0-00AA00BD091C}
// *********************************************************************//
  ICfxPrinterDisp = dispinterface
    ['{D5688691-E6B0-11D1-89B0-00AA00BD091C}']
    property UsePrinterResolution: WordBool dispid 1;
    property LeftMargin: Double dispid 2;
    property RightMargin: Double dispid 3;
    property TopMargin: Double dispid 4;
    property BottomMargin: Double dispid 5;
    property SeparateLegend: WordBool dispid 6;
    property Orientation: CfxOrientation dispid 7;
    property ForceColors: WordBool dispid 8;
    property Compress: WordBool dispid 9;
    property PrinterDriver: WideString writeonly dispid 10;
    property hDC: Integer writeonly dispid 11;
    property Style: CfxPrintStyle dispid 12;
  end;

// *********************************************************************//
// Interface: DataSource
// Flags:     (256) OleAutomation
// GUID:      {7C0FFAB3-CD84-11D0-949A-00A0C91110ED}
// *********************************************************************//
  DataSource = interface(IUnknown)
    ['{7C0FFAB3-CD84-11D0-949A-00A0C91110ED}']
  end;

// *********************************************************************//
// Interface: _VBDataSource
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9F6AA700-D188-11CD-AD48-00AA003C9CB6}
// *********************************************************************//
  _VBDataSource = interface(IDispatch)
    ['{9F6AA700-D188-11CD-AD48-00AA003C9CB6}']
  end;

// *********************************************************************//
// DispIntf:  _VBDataSourceDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9F6AA700-D188-11CD-AD48-00AA003C9CB6}
// *********************************************************************//
  _VBDataSourceDisp = dispinterface
    ['{9F6AA700-D188-11CD-AD48-00AA003C9CB6}']
  end;

// *********************************************************************//
// Interface: ICfxEnum
// Flags:     (4368) Hidden OleAutomation Dispatchable
// GUID:      {5DECA4E0-3B4F-11D1-8FD4-00AA00BD091C}
// *********************************************************************//
  ICfxEnum = interface(IDispatch)
    ['{5DECA4E0-3B4F-11D1-8FD4-00AA00BD091C}']
    function  Get_Count(out retval: Integer): HResult; stdcall;
    function  Get_Item(index: Integer; out retval: IDispatch): HResult; stdcall;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TChartFX
// Help String      : ChartFX Object
// Default Interface: IChartFX
// Def. Intf. DISP? : No
// Event   Interface: _ChartFXEvents
// TypeFlags        : (38) CanCreate Licensed Control
// *********************************************************************//
  TChartFXLButtonDblClk = procedure(Sender: TObject; x: Smallint; y: Smallint; nSerie: Smallint; 
                                                     nPoint: Integer; var nRes: Smallint) of object;
  TChartFXRButtonDown = procedure(Sender: TObject; x: Smallint; y: Smallint; nSerie: Smallint; 
                                                   nPoint: Integer; var nRes: Smallint) of object;
  TChartFXChangeValue = procedure(Sender: TObject; dValue: Double; nSerie: Smallint; 
                                                   nPoint: Integer; var nRes: Smallint) of object;
  TChartFXChangeString = procedure(Sender: TObject; nType: Smallint; nIndex: Integer; 
                                                    var nRes: Smallint) of object;
  TChartFXChangeColor = procedure(Sender: TObject; nType: Smallint; nIndex: Smallint; 
                                                   var nRes: Smallint) of object;
  TChartFXChangePalette = procedure(Sender: TObject; nIndex: Smallint; var nRes: Smallint) of object;
  TChartFXChangeFont = procedure(Sender: TObject; nIndex: Smallint; var nRes: Smallint) of object;
  TChartFXChangePattern = procedure(Sender: TObject; nType: Smallint; nIndex: Smallint; 
                                                     var nRes: Smallint) of object;
  TChartFXMenu = procedure(Sender: TObject; wParam: Integer; nSerie: Smallint; nPoint: Integer; 
                                            var nRes: Smallint) of object;
  TChartFXChangeType = procedure(Sender: TObject; nType: Smallint; var nRes: Smallint) of object;
  TChartFXUserScroll = procedure(Sender: TObject; wScrollMsg: Integer; wScrollParam: Integer; 
                                                  var nRes: Smallint) of object;
  TChartFXInternalCommand = procedure(Sender: TObject; wParam: Integer; lParam: Integer; 
                                                       var nRes: Smallint) of object;
  TChartFXShowToolBar = procedure(Sender: TObject; nType: Smallint; var nRes: Smallint) of object;
  TChartFXPrePaint = procedure(Sender: TObject; w: Smallint; h: Smallint; lPaint: Integer; 
                                                var nRes: Smallint) of object;
  TChartFXPostPaint = procedure(Sender: TObject; w: Smallint; h: Smallint; lPaint: Integer; 
                                                 var nRes: Smallint) of object;
  TChartFXPaintMarker = procedure(Sender: TObject; x: Smallint; y: Smallint; lPaint: Integer; 
                                                   nSerie: Smallint; nPoint: Integer; 
                                                   var nRes: Smallint) of object;
  TChartFXLButtonDown = procedure(Sender: TObject; x: Smallint; y: Smallint; var nRes: Smallint) of object;
  TChartFXLButtonUp = procedure(Sender: TObject; x: Smallint; y: Smallint; var nRes: Smallint) of object;
  TChartFXRButtonUp = procedure(Sender: TObject; x: Smallint; y: Smallint; var nRes: Smallint) of object;
  TChartFXMouseMoving = procedure(Sender: TObject; x: Smallint; y: Smallint; var nRes: Smallint) of object;
  TChartFXRButtonDblClk = procedure(Sender: TObject; x: Smallint; y: Smallint; var nRes: Smallint) of object;
  TChartFXUserCommand = procedure(Sender: TObject; wParam: Integer; lParam: Integer; 
                                                   var nRes: Smallint) of object;
  TChartFXGetPointLabel = procedure(Sender: TObject; nSerie: Smallint; nPoint: Integer; 
                                                     var nRes: Smallint) of object;
  TChartFXGetAxisLabel = procedure(Sender: TObject; nAxis: Smallint; var nRes: Smallint) of object;
  TChartFXPrePaintMarker = procedure(Sender: TObject; nSerie: Smallint; nPoint: Integer; 
                                                      var nRes: Smallint) of object;
  TChartFXGetTip = procedure(Sender: TObject; nHit: Smallint; nSerie: Smallint; nPoint: Integer; 
                                              var nRes: Smallint) of object;
  TChartFXChangePattPal = procedure(Sender: TObject; nIndex: Smallint; var nRes: Smallint) of object;
  TChartFXGetLegend = procedure(Sender: TObject; nIndex: Smallint; var nRes: Smallint) of object;

  TChartFX = class(TOleControl)
  private
    FOnLButtonDblClk: TChartFXLButtonDblClk;
    FOnRButtonDown: TChartFXRButtonDown;
    FOnChangeValue: TChartFXChangeValue;
    FOnChangeString: TChartFXChangeString;
    FOnChangeColor: TChartFXChangeColor;
    FOnDestroy: TNotifyEvent;
    FOnReadFile: TNotifyEvent;
    FOnChangePalette: TChartFXChangePalette;
    FOnChangeFont: TChartFXChangeFont;
    FOnReadTemplate: TNotifyEvent;
    FOnChangePattern: TChartFXChangePattern;
    FOnMenu: TChartFXMenu;
    FOnChangeType: TChartFXChangeType;
    FOnUserScroll: TChartFXUserScroll;
    FOnInternalCommand: TChartFXInternalCommand;
    FOnShowToolBar: TChartFXShowToolBar;
    FOnPrePaint: TChartFXPrePaint;
    FOnPostPaint: TChartFXPostPaint;
    FOnPaintMarker: TChartFXPaintMarker;
    FOnLButtonDown: TChartFXLButtonDown;
    FOnLButtonUp: TChartFXLButtonUp;
    FOnRButtonUp: TChartFXRButtonUp;
    FOnMouseMoving: TChartFXMouseMoving;
    FOnRButtonDblClk: TChartFXRButtonDblClk;
    FOnUserCommand: TChartFXUserCommand;
    FOnGetPointLabel: TChartFXGetPointLabel;
    FOnGetAxisLabel: TChartFXGetAxisLabel;
    FOnPrePaintMarker: TChartFXPrePaintMarker;
    FOnGetTip: TChartFXGetTip;
    FOnChangePattPal: TChartFXChangePattPal;
    FOnGetLegend: TChartFXGetLegend;
    FIntf: IChartFX;
    function  GetControlInterface: IChartFX;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
    function  Get_Series: ICfxSeriesEnum;
    function  Get_Axis: ICfxAxisEnum;
    function  Get_ConstantLine: ICfxConstEnum;
    function  Get_Stripe: ICfxStripeEnum;
    function  Get_Commands: ICommandBar;
    function  Get_ToolBarObj: IToolBar;
    function  Get_MenuBarObj: IToolBar;
    function  Get_LegendBoxObj: ICfxLegendBox;
    function  Get_SerLegBoxObj: ICfxLegendBox;
    function  Get_PaletteBarObj: ICfxPalette;
    function  Get_PatternBarObj: ICfxPalette;
    function  Get_DataEditorObj: ICfxDataEditor;
    function  Get_Printer: ICfxPrinter;
    function  Get_DataSourceAdo: DataSource;
    procedure Set_DataSourceAdo(const ppdp: DataSource);
    function  Get_DataSource: _VBDataSource;
    procedure Set_DataSource(const val: _VBDataSource);
    function  Get_TypeProp(nGallery: Smallint): Integer;
    procedure Set_TypeProp(nGallery: Smallint; pVal: Integer);
    function  Get_ValueEx(nSerie: Smallint; nPoint: Integer): Double;
    procedure Set_ValueEx(nSerie: Smallint; nPoint: Integer; val: Double);
    function  Get_XValueEx(nSerie: Smallint; nPoint: Integer): Double;
    procedure Set_XValueEx(nSerie: Smallint; nPoint: Integer; val: Double);
    function  Get_IniValueEx(nSerie: Smallint; nPoint: Integer): Double;
    procedure Set_IniValueEx(nSerie: Smallint; nPoint: Integer; val: Double);
    function  Get_Pattern(index: Smallint): Smallint;
    procedure Set_Pattern(index: Smallint; val: Smallint);
    function  Get_Title(index: CfxTitle): WideString;
    procedure Set_Title(index: CfxTitle; const val: WideString);
    function  Get_Legend(index: Integer): WideString;
    procedure Set_Legend(index: Integer; const val: WideString);
    function  Get_KeyLeg(index: Integer): WideString;
    procedure Set_KeyLeg(index: Integer; const val: WideString);
    function  Get_YLeg(index: Integer): WideString;
    procedure Set_YLeg(index: Integer; const val: WideString);
    function  Get_Fonts(index: CfxFont): CfxFontAttr;
    procedure Set_Fonts(index: CfxFont; val: CfxFontAttr);
    function  Get_HFont(index: CfxFont): Integer;
    procedure Set_HFont(index: CfxFont; val: Integer);
    function  Get_RGBFont(index: CfxFont): OLE_COLOR;
    procedure Set_RGBFont(index: CfxFont; val: OLE_COLOR);
    function  Get_ItemWidth(index: CfxItem): Smallint;
    procedure Set_ItemWidth(index: CfxItem; val: Smallint);
    function  Get_ItemColor(index: CfxItem): OLE_COLOR;
    procedure Set_ItemColor(index: CfxItem; val: OLE_COLOR);
    function  Get_ItemStyle(index: CfxItem): Integer;
    procedure Set_ItemStyle(index: CfxItem; val: Integer);
    function  Get_ItemBkColor(index: CfxItem): OLE_COLOR;
    procedure Set_ItemBkColor(index: CfxItem; val: OLE_COLOR);
    function  Get_SeparateSlice(index: Smallint): Smallint;
    procedure Set_SeparateSlice(index: Smallint; val: Smallint);
    function  Get_DataType(index: Smallint): CfxDataType;
    procedure Set_DataType(index: Smallint; val: CfxDataType);
    function  Get_Color(index: Smallint): OLE_COLOR;
    procedure Set_Color(index: Smallint; val: OLE_COLOR);
    function  Get_BkColor(index: Smallint): OLE_COLOR;
    procedure Set_BkColor(index: Smallint; val: OLE_COLOR);
    function  Get_SerLeg(index: Smallint): WideString;
    procedure Set_SerLeg(index: Smallint; const val: WideString);
    function  Get_KeySer(index: Smallint): WideString;
    procedure Set_KeySer(index: Smallint; const val: WideString);
    function  Get_MultiType(index: Smallint): CfxType;
    procedure Set_MultiType(index: Smallint; val: CfxType);
    function  Get_MultiShape(index: Smallint): Smallint;
    procedure Set_MultiShape(index: Smallint; val: Smallint);
    function  Get_MultiLineStyle(index: Smallint): Integer;
    procedure Set_MultiLineStyle(index: Smallint; val: Integer);
    function  Get_MultiYAxis(index: Smallint): CfxAxisIndex;
    procedure Set_MultiYAxis(index: Smallint; val: CfxAxisIndex);
    function  Get_TBItemStyle(index: Smallint): Integer;
    procedure Set_TBItemStyle(index: Smallint; val: Integer);
    function  Get_EnableTBItem(index: Smallint): Smallint;
    procedure Set_EnableTBItem(index: Smallint; val: Smallint);
    function  Get_ToolStyle(index: CfxTool): CfxToolStyle;
    procedure Set_ToolStyle(index: CfxTool; val: CfxToolStyle);
    function  Get_ToolSize(index: CfxTool): Integer;
    procedure Set_ToolSize(index: CfxTool; val: Integer);
    function  Get_ToolPos(index: CfxTool): CfxToolPos;
    procedure Set_ToolPos(index: CfxTool; val: CfxToolPos);
    function  Get_Const_(index: Smallint): Double;
    procedure Set_Const_(index: Smallint; val: Double);
    function  Get_FixLeg(index: Smallint): WideString;
    procedure Set_FixLeg(index: Smallint; const val: WideString);
    function  Get_TBItemID(nIndex: Smallint): CfxToolID;
    procedure Set_TBItemID(nIndex: Smallint; val: CfxToolID);
    function  Get_MultiPoint(index: Smallint): CfxPointType;
    procedure Set_MultiPoint(index: Smallint; val: CfxPointType);
    function  Get_Adm(index: CfxAdm): Double;
    procedure Set_Adm(index: CfxAdm; val: Double);
    function  Get_DecimalsNum(index: CfxDecimal): Smallint;
    procedure Set_DecimalsNum(index: CfxDecimal; val: Smallint);
    function  Get_BarBitmap(index: Smallint): IPictureDisp;
    procedure Set_BarBitmap(index: Smallint; const val: IPictureDisp);
    function  Get_Value(index: Integer): Double;
    procedure Set_Value(index: Integer; val: Double);
    function  Get_Xvalue(index: Integer): Double;
    procedure Set_Xvalue(index: Integer; val: Double);
    function  Get_IniValue(index: Integer): Double;
    procedure Set_IniValue(index: Integer; val: Double);
  public
    procedure Refresh;
    procedure AboutBox;
    function  OpenDataEx(nType: CfxCod; n1: Integer; n2: Integer): Integer;
    function  CloseData(nType: CfxCod): WordBool;
    function  DblClk(nType: CfxClick; lExtra: Integer): Integer;
    function  RigClk(nType: CfxClick; lExtra: Integer): Integer;
    function  ShowDialog(nDialog: CfxDialog; lExtra: Integer): Integer;
    function  ClearLegend(index: CfxLegend): Integer;
    function  PrintIt(nFrom: Smallint; nTo: Smallint): Integer;
    function  Scroll(wParam: CfxScroll; lParam: Integer): Integer;
    function  Paint(hDC: Integer; nLeft: Integer; nTop: Integer; nRight: Integer; nBottom: Integer; 
                    wAction: CfxChartPaint; lps: Integer): Integer;
    function  PaintInfo(index: CfxPaintInfo): OleVariant; overload;
    function  PaintInfo(index: CfxPaintInfo; vData: OleVariant): OleVariant; overload;
    procedure PaintInfo2(nIndex: CfxPaintInfo; vData: OleVariant; var vResult: OleVariant);
    function  Export(nType: CfxExport): Integer; overload;
    function  Export(nType: CfxExport; vData: OleVariant): Integer; overload;
    function  Import(nType: CfxExport): Integer; overload;
    function  Import(nType: CfxExport; vData: OleVariant): Integer; overload;
    function  Language(const sResource: WideString): Integer;
    function  SendMsg(wMsg: Integer; wParam: Integer; lParam: Integer): Integer;
    procedure AddExtension(vExt: OleVariant);
    function  GetExtension(const sExtension: WideString): IUnknown;
    procedure RemoveExtension(const sExtension: WideString);
    function  GetPicture(nFormat: Smallint): IPictureDisp;
    procedure GetExternalData(vDataProvider: OleVariant); overload;
    procedure GetExternalData(vDataProvider: OleVariant; vPar: OleVariant); overload;
    procedure RecalcScale;
    procedure SetContourLabels(STEP: Double);
    procedure AddBar(nID: Smallint; const pObj: IUnknown);
    function  GetBar(nID: Smallint): IUnknown;
    procedure RemoveBar(nID: Smallint);
    procedure ClearData(newVal: CfxDataMask);
    procedure ZoomIn(xMin: Double; yMin: Double; xMax: Double; yMax: Double);
    procedure _GetCChartFXPointer(out pChart: Integer);
    function  HitTest(x: Integer; y: Integer; out NSeries: Smallint; out nPoint: Integer): CfxHitTest;
    procedure ShowBalloon(const sText: WideString; x: Integer; y: Integer);
    procedure CreateWnd(hwndParent: Integer; nID: Smallint; x: Integer; y: Integer; cx: Integer; 
                        cy: Integer; dwStyle: Integer);
    function  SetEventHandler(const pObj: IUnknown): IUnknown;
    procedure ShowHelpTopic(const pszHelpDir: WideString; nTopic: Integer);
    function  SetStripe(index: Smallint; dMin: Double; dMax: Double; rgb: OLE_COLOR): Integer;
    procedure ValueToPixel(Xvalue: Double; Yvalue: Double; out x: Integer; out y: Integer; 
                           nYAxis: CfxAxisIndex);
    procedure PixelToValue(x: Integer; y: Integer; out Xvalue: Double; out Yvalue: Double; 
                           nYAxis: CfxAxisIndex);
    procedure CompactSeriesAttributes(bGallery: WordBool);
    procedure UpdateSizeNow;
    property  ControlInterface: IChartFX read GetControlInterface;
    property  DefaultInterface: IChartFX read GetControlInterface;
    property hWnd: Integer index -515 read GetIntegerProp;
    property TipMask: WideString index 34 write SetWideStringProp;
    property BkPicture: TPicture index 54 read GetTPictureProp write SetTPictureProp;
    property LeftFont: TFont index 55 read GetTFontProp write SetTFontProp;
    property RightFont: TFont index 56 read GetTFontProp write SetTFontProp;
    property TopFont: TFont index 57 read GetTFontProp write SetTFontProp;
    property BottomFont: TFont index 58 read GetTFontProp write SetTFontProp;
    property XLegFont: TFont index 59 read GetTFontProp write SetTFontProp;
    property YLegFont: TFont index 60 read GetTFontProp write SetTFontProp;
    property FixedFont: TFont index 61 read GetTFontProp write SetTFontProp;
    property LegendFont: TFont index 62 read GetTFontProp write SetTFontProp;
    property PointLabelsFont: TFont index 63 read GetTFontProp write SetTFontProp;
    property PointFont: TFont index 64 read GetTFontProp write SetTFontProp;
    property Series: ICfxSeriesEnum read Get_Series;
    property Axis: ICfxAxisEnum read Get_Axis;
    property ConstantLine: ICfxConstEnum read Get_ConstantLine;
    property Stripe: ICfxStripeEnum read Get_Stripe;
    property Commands: ICommandBar read Get_Commands;
    property ToolBarObj: IToolBar read Get_ToolBarObj;
    property MenuBarObj: IToolBar read Get_MenuBarObj;
    property LegendBoxObj: ICfxLegendBox read Get_LegendBoxObj;
    property SerLegBoxObj: ICfxLegendBox read Get_SerLegBoxObj;
    property PaletteBarObj: ICfxPalette read Get_PaletteBarObj;
    property PatternBarObj: ICfxPalette read Get_PatternBarObj;
    property DataEditorObj: ICfxDataEditor read Get_DataEditorObj;
    property Printer: ICfxPrinter read Get_Printer;
    property DataSourceAdo: DataSource read Get_DataSourceAdo write Set_DataSourceAdo;
    property DataSource: _VBDataSource read Get_DataSource write Set_DataSource;
    property TypeProp[nGallery: Smallint]: Integer read Get_TypeProp write Set_TypeProp;
    property ValueEx[nSerie: Smallint; nPoint: Integer]: Double read Get_ValueEx write Set_ValueEx;
    property XValueEx[nSerie: Smallint; nPoint: Integer]: Double read Get_XValueEx write Set_XValueEx;
    property IniValueEx[nSerie: Smallint; nPoint: Integer]: Double read Get_IniValueEx write Set_IniValueEx;
    property Pattern[index: Smallint]: Smallint read Get_Pattern write Set_Pattern;
    property Title[index: CfxTitle]: WideString read Get_Title write Set_Title;
    property Legend[index: Integer]: WideString read Get_Legend write Set_Legend;
    property KeyLeg[index: Integer]: WideString read Get_KeyLeg write Set_KeyLeg;
    property YLeg[index: Integer]: WideString read Get_YLeg write Set_YLeg;
    property Fonts[index: CfxFont]: CfxFontAttr read Get_Fonts write Set_Fonts;
    property HFont[index: CfxFont]: Integer read Get_HFont write Set_HFont;
    property RGBFont[index: CfxFont]: OLE_COLOR read Get_RGBFont write Set_RGBFont;
    property ItemWidth[index: CfxItem]: Smallint read Get_ItemWidth write Set_ItemWidth;
    property ItemColor[index: CfxItem]: OLE_COLOR read Get_ItemColor write Set_ItemColor;
    property ItemStyle[index: CfxItem]: Integer read Get_ItemStyle write Set_ItemStyle;
    property ItemBkColor[index: CfxItem]: OLE_COLOR read Get_ItemBkColor write Set_ItemBkColor;
    property SeparateSlice[index: Smallint]: Smallint read Get_SeparateSlice write Set_SeparateSlice;
    property DataType[index: Smallint]: CfxDataType read Get_DataType write Set_DataType;
    property Color[index: Smallint]: OLE_COLOR read Get_Color write Set_Color;
    property BkColor[index: Smallint]: OLE_COLOR read Get_BkColor write Set_BkColor;
    property SerLeg[index: Smallint]: WideString read Get_SerLeg write Set_SerLeg;
    property KeySer[index: Smallint]: WideString read Get_KeySer write Set_KeySer;
    property ChartType: TOleEnum index 400 read GetTOleEnumProp write SetTOleEnumProp;
    property MarkerVolume: Smallint index 401 read GetSmallintProp write SetSmallintProp;
    property PointType: TOleEnum index 402 read GetTOleEnumProp write SetTOleEnumProp;
    property Type_: TOleEnum index 403 read GetTOleEnumProp write SetTOleEnumProp;
    property Shape: Smallint index 404 read GetSmallintProp write SetSmallintProp;
    property PixFactor: Smallint index 405 read GetSmallintProp write SetSmallintProp;
    property FixedGap: Smallint index 406 read GetSmallintProp write SetSmallintProp;
    property BarHorzGap: Smallint index 407 read GetSmallintProp write SetSmallintProp;
    property RGBBarHorz: TColor index 408 read GetTColorProp write SetTColorProp;
    property VertGridGap: Smallint index 409 read GetSmallintProp write SetSmallintProp;
    property ConstType: TOleEnum index 410 read GetTOleEnumProp write SetTOleEnumProp;
    property GalleryTool: TOleEnum index 411 read GetTOleEnumProp write SetTOleEnumProp;
    property LegStyle: TOleEnum index 412 read GetTOleEnumProp write SetTOleEnumProp;
    property CustomTool: TOleEnum index 414 read GetTOleEnumProp write SetTOleEnumProp;
    property TBBitmap: TPicture index 415 read GetTPictureProp write SetTPictureProp;
    property Angles3D: Integer index 416 read GetIntegerProp write SetIntegerProp;
    property MultiType[index: Smallint]: CfxType read Get_MultiType write Set_MultiType;
    property MultiShape[index: Smallint]: Smallint read Get_MultiShape write Set_MultiShape;
    property MultiLineStyle[index: Smallint]: Integer read Get_MultiLineStyle write Set_MultiLineStyle;
    property MultiYAxis[index: Smallint]: CfxAxisIndex read Get_MultiYAxis write Set_MultiYAxis;
    property TBItemStyle[index: Smallint]: Integer read Get_TBItemStyle write Set_TBItemStyle;
    property EnableTBItem[index: Smallint]: Smallint read Get_EnableTBItem write Set_EnableTBItem;
    property ToolStyle[index: CfxTool]: CfxToolStyle read Get_ToolStyle write Set_ToolStyle;
    property ToolSize[index: CfxTool]: Integer read Get_ToolSize write Set_ToolSize;
    property ToolPos[index: CfxTool]: CfxToolPos read Get_ToolPos write Set_ToolPos;
    property Const_[index: Smallint]: Double read Get_Const_ write Set_Const_;
    property FixLeg[index: Smallint]: WideString read Get_FixLeg write Set_FixLeg;
    property TBItemID[nIndex: Smallint]: CfxToolID read Get_TBItemID write Set_TBItemID;
    property MultiPoint[index: Smallint]: CfxPointType read Get_MultiPoint write Set_MultiPoint;
    property Adm[index: CfxAdm]: Double read Get_Adm write Set_Adm;
    property DecimalsNum[index: CfxDecimal]: Smallint read Get_DecimalsNum write Set_DecimalsNum;
    property BarBitmap[index: Smallint]: IPictureDisp read Get_BarBitmap write Set_BarBitmap;
    property Value[index: Integer]: Double read Get_Value write Set_Value;
    property Xvalue[index: Integer]: Double read Get_Xvalue write Set_Xvalue;
    property IniValue[index: Integer]: Double read Get_IniValue write Set_IniValue;
  published
    property  TabStop;
    property  Align;
    property  DragCursor;
    property  DragMode;
    property  ParentShowHint;
    property  PopupMenu;
    property  ShowHint;
    property  TabOrder;
    property  Visible;
    property  OnDragDrop;
    property  OnDragOver;
    property  OnEndDrag;
    property  OnEnter;
    property  OnExit;
    property  OnStartDrag;
    property Enabled: WordBool index -514 read GetWordBoolProp write SetWordBoolProp stored False;
    property Gallery: TOleEnum index 1 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property TypeMask: TOleEnum index 2 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property Style: TOleEnum index 3 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property NSeries: Integer index 4 read GetIntegerProp write SetIntegerProp stored False;
    property LeftGap: Smallint index 5 read GetSmallintProp write SetSmallintProp stored False;
    property RightGap: Smallint index 6 read GetSmallintProp write SetSmallintProp stored False;
    property TopGap: Smallint index 7 read GetSmallintProp write SetSmallintProp stored False;
    property BottomGap: Smallint index 8 read GetSmallintProp write SetSmallintProp stored False;
    property MenuBar: WordBool index 9 read GetWordBoolProp write SetWordBoolProp stored False;
    property Scheme: TOleEnum index 10 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property Stacked: TOleEnum index 11 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property Grid: TOleEnum index 12 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property WallWidth: Smallint index 13 read GetSmallintProp write SetSmallintProp stored False;
    property Border: WordBool index 14 read GetWordBoolProp write SetWordBoolProp stored False;
    property BorderColor: TColor index 15 read GetTColorProp write SetTColorProp stored False;
    property LineWidth: Smallint index 16 read GetSmallintProp write SetSmallintProp stored False;
    property LineStyle: TOleEnum index 17 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property View3D: WordBool index 18 read GetWordBoolProp write SetWordBoolProp stored False;
    property AngleX: Smallint index 19 read GetSmallintProp write SetSmallintProp stored False;
    property AngleY: Smallint index 20 read GetSmallintProp write SetSmallintProp stored False;
    property RGBBk: TColor index 21 read GetTColorProp write SetTColorProp stored False;
    property RGB2DBk: TColor index 22 read GetTColorProp write SetTColorProp stored False;
    property RGB3DBk: TColor index 23 read GetTColorProp write SetTColorProp stored False;
    property HText: WideString index 24 read GetWideStringProp write SetWideStringProp stored False;
    property ChartStatus: TOleEnum index 25 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property AxesStyle: TOleEnum index 26 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property Chart3D: WordBool index 27 read GetWordBoolProp write SetWordBoolProp stored False;
    property ToolBar: WordBool index 28 read GetWordBoolProp write SetWordBoolProp stored False;
    property PaletteBar: WordBool index 29 read GetWordBoolProp write SetWordBoolProp stored False;
    property PatternBar: WordBool index 30 read GetWordBoolProp write SetWordBoolProp stored False;
    property ReturnValue: Integer index 31 read GetIntegerProp write SetIntegerProp stored False;
    property FileMask: TOleEnum index 32 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property PropPageMask: Integer index 33 read GetIntegerProp write SetIntegerProp stored False;
    property MarkerStep: Smallint index 35 read GetSmallintProp write SetSmallintProp stored False;
    property MarkerShape: TOleEnum index 36 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property MarkerSize: Smallint index 37 read GetSmallintProp write SetSmallintProp stored False;
    property Volume: Smallint index 38 read GetSmallintProp write SetSmallintProp stored False;
    property View3DLight: Smallint index 39 read GetSmallintProp write SetSmallintProp stored False;
    property CylSides: Smallint index 40 read GetSmallintProp write SetSmallintProp stored False;
    property BorderStyle: TOleEnum index 41 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property MaxValues: Integer index 42 read GetIntegerProp write SetIntegerProp stored False;
    property Perspective: Smallint index 43 read GetSmallintProp write SetSmallintProp stored False;
    property Zoom: WordBool index 44 read GetWordBoolProp write SetWordBoolProp stored False;
    property DataStyle: TOleEnum index 45 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property TypeEx: TOleEnum index 46 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property StyleEx: TOleEnum index 47 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property MouseCapture: WordBool index 48 read GetWordBoolProp write SetWordBoolProp stored False;
    property PointLabels: WordBool index 49 read GetWordBoolProp write SetWordBoolProp stored False;
    property PointLabelAlign: TOleEnum index 50 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property PointLabelAngle: Smallint index 51 read GetSmallintProp write SetSmallintProp stored False;
    property NValues: Integer index 52 read GetIntegerProp write SetIntegerProp stored False;
    property View3DDepth: Smallint index 65 read GetSmallintProp write SetSmallintProp stored False;
    property Scrollable: WordBool index 66 read GetWordBoolProp write SetWordBoolProp stored False;
    property RealTimeStyle: TOleEnum index 67 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property Cluster: WordBool index 81 read GetWordBoolProp write SetWordBoolProp stored False;
    property Palette: WideString index 82 read GetWideStringProp write SetWideStringProp stored False;
    property LegendBox: WordBool index 83 read GetWordBoolProp write SetWordBoolProp stored False;
    property SerLegBox: WordBool index 84 read GetWordBoolProp write SetWordBoolProp stored False;
    property DataEditor: WordBool index 85 read GetWordBoolProp write SetWordBoolProp stored False;
    property MultipleColors: WordBool index 86 read GetWordBoolProp write SetWordBoolProp stored False;
    property AllowDrag: WordBool index 87 read GetWordBoolProp write SetWordBoolProp stored False;
    property AllowResize: WordBool index 88 read GetWordBoolProp write SetWordBoolProp stored False;
    property AllowEdit: WordBool index 89 read GetWordBoolProp write SetWordBoolProp stored False;
    property ShowTips: WordBool index 90 read GetWordBoolProp write SetWordBoolProp stored False;
    property ContextMenus: WordBool index 91 read GetWordBoolProp write SetWordBoolProp stored False;
    property DataMemberAdo: WideString index 93 read GetWideStringProp write SetWideStringProp stored False;
    property CurrentAxis: TOleEnum index 413 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property AutoIncrement: WordBool index 417 read GetWordBoolProp write SetWordBoolProp stored False;
    property ThisSerie: Smallint index 418 read GetSmallintProp write SetSmallintProp stored False;
    property ThisValue: Double index 419 read GetDoubleProp write SetDoubleProp stored False;
    property ThisPoint: Integer index 420 read GetIntegerProp write SetIntegerProp stored False;
    property CrossHairs: WordBool index 337 read GetWordBoolProp write SetWordBoolProp stored False;
    property PointLabelMask: WideString index 338 read GetWideStringProp write SetWideStringProp stored False;
    property OnLButtonDblClk: TChartFXLButtonDblClk read FOnLButtonDblClk write FOnLButtonDblClk;
    property OnRButtonDown: TChartFXRButtonDown read FOnRButtonDown write FOnRButtonDown;
    property OnChangeValue: TChartFXChangeValue read FOnChangeValue write FOnChangeValue;
    property OnChangeString: TChartFXChangeString read FOnChangeString write FOnChangeString;
    property OnChangeColor: TChartFXChangeColor read FOnChangeColor write FOnChangeColor;
    property OnDestroy: TNotifyEvent read FOnDestroy write FOnDestroy;
    property OnReadFile: TNotifyEvent read FOnReadFile write FOnReadFile;
    property OnChangePalette: TChartFXChangePalette read FOnChangePalette write FOnChangePalette;
    property OnChangeFont: TChartFXChangeFont read FOnChangeFont write FOnChangeFont;
    property OnReadTemplate: TNotifyEvent read FOnReadTemplate write FOnReadTemplate;
    property OnChangePattern: TChartFXChangePattern read FOnChangePattern write FOnChangePattern;
    property OnMenu: TChartFXMenu read FOnMenu write FOnMenu;
    property OnChangeType: TChartFXChangeType read FOnChangeType write FOnChangeType;
    property OnUserScroll: TChartFXUserScroll read FOnUserScroll write FOnUserScroll;
    property OnInternalCommand: TChartFXInternalCommand read FOnInternalCommand write FOnInternalCommand;
    property OnShowToolBar: TChartFXShowToolBar read FOnShowToolBar write FOnShowToolBar;
    property OnPrePaint: TChartFXPrePaint read FOnPrePaint write FOnPrePaint;
    property OnPostPaint: TChartFXPostPaint read FOnPostPaint write FOnPostPaint;
    property OnPaintMarker: TChartFXPaintMarker read FOnPaintMarker write FOnPaintMarker;
    property OnLButtonDown: TChartFXLButtonDown read FOnLButtonDown write FOnLButtonDown;
    property OnLButtonUp: TChartFXLButtonUp read FOnLButtonUp write FOnLButtonUp;
    property OnRButtonUp: TChartFXRButtonUp read FOnRButtonUp write FOnRButtonUp;
    property OnMouseMoving: TChartFXMouseMoving read FOnMouseMoving write FOnMouseMoving;
    property OnRButtonDblClk: TChartFXRButtonDblClk read FOnRButtonDblClk write FOnRButtonDblClk;
    property OnUserCommand: TChartFXUserCommand read FOnUserCommand write FOnUserCommand;
    property OnGetPointLabel: TChartFXGetPointLabel read FOnGetPointLabel write FOnGetPointLabel;
    property OnGetAxisLabel: TChartFXGetAxisLabel read FOnGetAxisLabel write FOnGetAxisLabel;
    property OnPrePaintMarker: TChartFXPrePaintMarker read FOnPrePaintMarker write FOnPrePaintMarker;
    property OnGetTip: TChartFXGetTip read FOnGetTip write FOnGetTip;
    property OnChangePattPal: TChartFXChangePattPal read FOnChangePattPal write FOnChangePattPal;
    property OnGetLegend: TChartFXGetLegend read FOnGetLegend write FOnGetLegend;
  end;

// *********************************************************************//
// The Class CoGeneralPage provides a Create and CreateRemote method to          
// create instances of the default interface IUnknown exposed by              
// the CoClass GeneralPage. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoGeneralPage = class
    class function Create: IUnknown;
    class function CreateRemote(const MachineName: string): IUnknown;
  end;

// *********************************************************************//
// The Class CoSeriesPage provides a Create and CreateRemote method to          
// create instances of the default interface IUnknown exposed by              
// the CoClass SeriesPage. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSeriesPage = class
    class function Create: IUnknown;
    class function CreateRemote(const MachineName: string): IUnknown;
  end;

// *********************************************************************//
// The Class CoAxesPage provides a Create and CreateRemote method to          
// create instances of the default interface IUnknown exposed by              
// the CoClass AxesPage. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoAxesPage = class
    class function Create: IUnknown;
    class function CreateRemote(const MachineName: string): IUnknown;
  end;

// *********************************************************************//
// The Class CoPage3D provides a Create and CreateRemote method to          
// create instances of the default interface IUnknown exposed by              
// the CoClass Page3D. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoPage3D = class
    class function Create: IUnknown;
    class function CreateRemote(const MachineName: string): IUnknown;
  end;

// *********************************************************************//
// The Class CoScalePage provides a Create and CreateRemote method to          
// create instances of the default interface IUnknown exposed by              
// the CoClass ScalePage. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoScalePage = class
    class function Create: IUnknown;
    class function CreateRemote(const MachineName: string): IUnknown;
  end;

// *********************************************************************//
// The Class CoLabelsPage provides a Create and CreateRemote method to          
// create instances of the default interface IUnknown exposed by              
// the CoClass LabelsPage. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoLabelsPage = class
    class function Create: IUnknown;
    class function CreateRemote(const MachineName: string): IUnknown;
  end;

// *********************************************************************//
// The Class CoGridLinesPage provides a Create and CreateRemote method to          
// create instances of the default interface IUnknown exposed by              
// the CoClass GridLinesPage. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoGridLinesPage = class
    class function Create: IUnknown;
    class function CreateRemote(const MachineName: string): IUnknown;
  end;

// *********************************************************************//
// The Class CoConstantStripesPage provides a Create and CreateRemote method to          
// create instances of the default interface IUnknown exposed by              
// the CoClass ConstantStripesPage. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoConstantStripesPage = class
    class function Create: IUnknown;
    class function CreateRemote(const MachineName: string): IUnknown;
  end;

procedure Register;

implementation

uses ComObj;

procedure TChartFX.InitControlData;
const
  CEventDispIDs: array [0..30] of DWORD = (
    $00000001, $00000002, $00000003, $00000004, $00000005, $00000006,
    $00000007, $00000008, $00000009, $0000000A, $0000000B, $0000000D,
    $0000000E, $0000000F, $00000011, $00000012, $00000013, $00000014,
    $00000015, $00000016, $00000017, $00000018, $00000019, $0000001A,
    $0000001B, $0000001C, $0000001D, $0000001E, $0000001F, $0000000C,
    $00000010);
  CLicenseKey: array[0..53] of Word = ( $0061, $0061, $0061, $0061, $006B, $006F, $0063, $006F, $0061, $0070, $0068
    , $0066, $006E, $0074, $0078, $0077, $006E, $006A, $0078, $0072, $006B
    , $0071, $0074, $0077, $006B, $0075, $0073, $0077, $006D, $006B, $0071
    , $0072, $006E, $0074, $0077, $0077, $006C, $006C, $006C, $0078, $006E
    , $0074, $0076, $0072, $006E, $006B, $006F, $0078, $006B, $0068, $006D
    , $0079, $0000, $0000);
  CTFontIDs: array [0..9] of DWORD = (
    $00000037, $00000038, $00000039, $0000003A, $0000003B, $0000003C,
    $0000003D, $0000003E, $0000003F, $00000040);
  CTPictureIDs: array [0..1] of DWORD = (
    $00000036, $0000019F);
  CControlData: TControlData2 = (
    ClassID: '{608E8B11-3690-11D1-8FD4-00AA00BD091C}';
    EventIID: '{F3743560-454E-11D1-8FD4-00AA00BD091C}';
    EventCount: 31;
    EventDispIDs: @CEventDispIDs;
    LicenseKey: @CLicenseKey;
    Flags: $00000008;
    Version: 401;
    FontCount: 10;
    FontIDs: @CTFontIDs;
    PictureCount: 2;
    PictureIDs: @CTPictureIDs);
begin
  ControlData := @CControlData;
  TControlData2(CControlData).FirstEventOfs := Cardinal(@@FOnLButtonDblClk) - Cardinal(Self);
end;

procedure TChartFX.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as IChartFX;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TChartFX.GetControlInterface: IChartFX;
begin
  CreateControl;
  Result := FIntf;
end;

function  TChartFX.Get_Series: ICfxSeriesEnum;
begin
  Result := DefaultInterface.Get_Series;
end;

function  TChartFX.Get_Axis: ICfxAxisEnum;
begin
  Result := DefaultInterface.Get_Axis;
end;

function  TChartFX.Get_ConstantLine: ICfxConstEnum;
begin
  Result := DefaultInterface.Get_ConstantLine;
end;

function  TChartFX.Get_Stripe: ICfxStripeEnum;
begin
  Result := DefaultInterface.Get_Stripe;
end;

function  TChartFX.Get_Commands: ICommandBar;
begin
  Result := DefaultInterface.Get_Commands;
end;

function  TChartFX.Get_ToolBarObj: IToolBar;
begin
  Result := DefaultInterface.Get_ToolBarObj;
end;

function  TChartFX.Get_MenuBarObj: IToolBar;
begin
  Result := DefaultInterface.Get_MenuBarObj;
end;

function  TChartFX.Get_LegendBoxObj: ICfxLegendBox;
begin
  Result := DefaultInterface.Get_LegendBoxObj;
end;

function  TChartFX.Get_SerLegBoxObj: ICfxLegendBox;
begin
  Result := DefaultInterface.Get_SerLegBoxObj;
end;

function  TChartFX.Get_PaletteBarObj: ICfxPalette;
begin
  Result := DefaultInterface.Get_PaletteBarObj;
end;

function  TChartFX.Get_PatternBarObj: ICfxPalette;
begin
  Result := DefaultInterface.Get_PatternBarObj;
end;

function  TChartFX.Get_DataEditorObj: ICfxDataEditor;
begin
  Result := DefaultInterface.Get_DataEditorObj;
end;

function  TChartFX.Get_Printer: ICfxPrinter;
begin
  Result := DefaultInterface.Get_Printer;
end;

function  TChartFX.Get_DataSourceAdo: DataSource;
begin
  Result := DefaultInterface.Get_DataSourceAdo;
end;

procedure TChartFX.Set_DataSourceAdo(const ppdp: DataSource);
begin
  DefaultInterface.Set_DataSourceAdo(ppdp);
end;

function  TChartFX.Get_DataSource: _VBDataSource;
begin
  Result := DefaultInterface.Get_DataSource;
end;

procedure TChartFX.Set_DataSource(const val: _VBDataSource);
begin
  DefaultInterface.Set_DataSource(val);
end;

function  TChartFX.Get_TypeProp(nGallery: Smallint): Integer;
begin
  Result := DefaultInterface.Get_TypeProp(nGallery);
end;

procedure TChartFX.Set_TypeProp(nGallery: Smallint; pVal: Integer);
begin
  DefaultInterface.Set_TypeProp(nGallery, pVal);
end;

function  TChartFX.Get_ValueEx(nSerie: Smallint; nPoint: Integer): Double;
begin
  Result := DefaultInterface.Get_ValueEx(nSerie, nPoint);
end;

procedure TChartFX.Set_ValueEx(nSerie: Smallint; nPoint: Integer; val: Double);
begin
  DefaultInterface.Set_ValueEx(nSerie, nPoint, val);
end;

function  TChartFX.Get_XValueEx(nSerie: Smallint; nPoint: Integer): Double;
begin
  Result := DefaultInterface.Get_XValueEx(nSerie, nPoint);
end;

procedure TChartFX.Set_XValueEx(nSerie: Smallint; nPoint: Integer; val: Double);
begin
  DefaultInterface.Set_XValueEx(nSerie, nPoint, val);
end;

function  TChartFX.Get_IniValueEx(nSerie: Smallint; nPoint: Integer): Double;
begin
  Result := DefaultInterface.Get_IniValueEx(nSerie, nPoint);
end;

procedure TChartFX.Set_IniValueEx(nSerie: Smallint; nPoint: Integer; val: Double);
begin
  DefaultInterface.Set_IniValueEx(nSerie, nPoint, val);
end;

function  TChartFX.Get_Pattern(index: Smallint): Smallint;
begin
  Result := DefaultInterface.Get_Pattern(index);
end;

procedure TChartFX.Set_Pattern(index: Smallint; val: Smallint);
begin
  DefaultInterface.Set_Pattern(index, val);
end;

function  TChartFX.Get_Title(index: CfxTitle): WideString;
begin
  Result := DefaultInterface.Get_Title(index);
end;

procedure TChartFX.Set_Title(index: CfxTitle; const val: WideString);
begin
  DefaultInterface.Set_Title(index, val);
end;

function  TChartFX.Get_Legend(index: Integer): WideString;
begin
  Result := DefaultInterface.Get_Legend(index);
end;

procedure TChartFX.Set_Legend(index: Integer; const val: WideString);
begin
  DefaultInterface.Set_Legend(index, val);
end;

function  TChartFX.Get_KeyLeg(index: Integer): WideString;
begin
  Result := DefaultInterface.Get_KeyLeg(index);
end;

procedure TChartFX.Set_KeyLeg(index: Integer; const val: WideString);
begin
  DefaultInterface.Set_KeyLeg(index, val);
end;

function  TChartFX.Get_YLeg(index: Integer): WideString;
begin
  Result := DefaultInterface.Get_YLeg(index);
end;

procedure TChartFX.Set_YLeg(index: Integer; const val: WideString);
begin
  DefaultInterface.Set_YLeg(index, val);
end;

function  TChartFX.Get_Fonts(index: CfxFont): CfxFontAttr;
begin
  Result := DefaultInterface.Get_Fonts(index);
end;

procedure TChartFX.Set_Fonts(index: CfxFont; val: CfxFontAttr);
begin
  DefaultInterface.Set_Fonts(index, val);
end;

function  TChartFX.Get_HFont(index: CfxFont): Integer;
begin
  Result := DefaultInterface.Get_HFont(index);
end;

procedure TChartFX.Set_HFont(index: CfxFont; val: Integer);
begin
  DefaultInterface.Set_HFont(index, val);
end;

function  TChartFX.Get_RGBFont(index: CfxFont): OLE_COLOR;
begin
  Result := DefaultInterface.Get_RGBFont(index);
end;

procedure TChartFX.Set_RGBFont(index: CfxFont; val: OLE_COLOR);
begin
  DefaultInterface.Set_RGBFont(index, val);
end;

function  TChartFX.Get_ItemWidth(index: CfxItem): Smallint;
begin
  Result := DefaultInterface.Get_ItemWidth(index);
end;

procedure TChartFX.Set_ItemWidth(index: CfxItem; val: Smallint);
begin
  DefaultInterface.Set_ItemWidth(index, val);
end;

function  TChartFX.Get_ItemColor(index: CfxItem): OLE_COLOR;
begin
  Result := DefaultInterface.Get_ItemColor(index);
end;

procedure TChartFX.Set_ItemColor(index: CfxItem; val: OLE_COLOR);
begin
  DefaultInterface.Set_ItemColor(index, val);
end;

function  TChartFX.Get_ItemStyle(index: CfxItem): Integer;
begin
  Result := DefaultInterface.Get_ItemStyle(index);
end;

procedure TChartFX.Set_ItemStyle(index: CfxItem; val: Integer);
begin
  DefaultInterface.Set_ItemStyle(index, val);
end;

function  TChartFX.Get_ItemBkColor(index: CfxItem): OLE_COLOR;
begin
  Result := DefaultInterface.Get_ItemBkColor(index);
end;

procedure TChartFX.Set_ItemBkColor(index: CfxItem; val: OLE_COLOR);
begin
  DefaultInterface.Set_ItemBkColor(index, val);
end;

function  TChartFX.Get_SeparateSlice(index: Smallint): Smallint;
begin
  Result := DefaultInterface.Get_SeparateSlice(index);
end;

procedure TChartFX.Set_SeparateSlice(index: Smallint; val: Smallint);
begin
  DefaultInterface.Set_SeparateSlice(index, val);
end;

function  TChartFX.Get_DataType(index: Smallint): CfxDataType;
begin
  Result := DefaultInterface.Get_DataType(index);
end;

procedure TChartFX.Set_DataType(index: Smallint; val: CfxDataType);
begin
  DefaultInterface.Set_DataType(index, val);
end;

function  TChartFX.Get_Color(index: Smallint): OLE_COLOR;
begin
  Result := DefaultInterface.Get_Color(index);
end;

procedure TChartFX.Set_Color(index: Smallint; val: OLE_COLOR);
begin
  DefaultInterface.Set_Color(index, val);
end;

function  TChartFX.Get_BkColor(index: Smallint): OLE_COLOR;
begin
  Result := DefaultInterface.Get_BkColor(index);
end;

procedure TChartFX.Set_BkColor(index: Smallint; val: OLE_COLOR);
begin
  DefaultInterface.Set_BkColor(index, val);
end;

function  TChartFX.Get_SerLeg(index: Smallint): WideString;
begin
  Result := DefaultInterface.Get_SerLeg(index);
end;

procedure TChartFX.Set_SerLeg(index: Smallint; const val: WideString);
begin
  DefaultInterface.Set_SerLeg(index, val);
end;

function  TChartFX.Get_KeySer(index: Smallint): WideString;
begin
  Result := DefaultInterface.Get_KeySer(index);
end;

procedure TChartFX.Set_KeySer(index: Smallint; const val: WideString);
begin
  DefaultInterface.Set_KeySer(index, val);
end;

function  TChartFX.Get_MultiType(index: Smallint): CfxType;
begin
  Result := DefaultInterface.Get_MultiType(index);
end;

procedure TChartFX.Set_MultiType(index: Smallint; val: CfxType);
begin
  DefaultInterface.Set_MultiType(index, val);
end;

function  TChartFX.Get_MultiShape(index: Smallint): Smallint;
begin
  Result := DefaultInterface.Get_MultiShape(index);
end;

procedure TChartFX.Set_MultiShape(index: Smallint; val: Smallint);
begin
  DefaultInterface.Set_MultiShape(index, val);
end;

function  TChartFX.Get_MultiLineStyle(index: Smallint): Integer;
begin
  Result := DefaultInterface.Get_MultiLineStyle(index);
end;

procedure TChartFX.Set_MultiLineStyle(index: Smallint; val: Integer);
begin
  DefaultInterface.Set_MultiLineStyle(index, val);
end;

function  TChartFX.Get_MultiYAxis(index: Smallint): CfxAxisIndex;
begin
  Result := DefaultInterface.Get_MultiYAxis(index);
end;

procedure TChartFX.Set_MultiYAxis(index: Smallint; val: CfxAxisIndex);
begin
  DefaultInterface.Set_MultiYAxis(index, val);
end;

function  TChartFX.Get_TBItemStyle(index: Smallint): Integer;
begin
  Result := DefaultInterface.Get_TBItemStyle(index);
end;

procedure TChartFX.Set_TBItemStyle(index: Smallint; val: Integer);
begin
  DefaultInterface.Set_TBItemStyle(index, val);
end;

function  TChartFX.Get_EnableTBItem(index: Smallint): Smallint;
begin
  Result := DefaultInterface.Get_EnableTBItem(index);
end;

procedure TChartFX.Set_EnableTBItem(index: Smallint; val: Smallint);
begin
  DefaultInterface.Set_EnableTBItem(index, val);
end;

function  TChartFX.Get_ToolStyle(index: CfxTool): CfxToolStyle;
begin
  Result := DefaultInterface.Get_ToolStyle(index);
end;

procedure TChartFX.Set_ToolStyle(index: CfxTool; val: CfxToolStyle);
begin
  DefaultInterface.Set_ToolStyle(index, val);
end;

function  TChartFX.Get_ToolSize(index: CfxTool): Integer;
begin
  Result := DefaultInterface.Get_ToolSize(index);
end;

procedure TChartFX.Set_ToolSize(index: CfxTool; val: Integer);
begin
  DefaultInterface.Set_ToolSize(index, val);
end;

function  TChartFX.Get_ToolPos(index: CfxTool): CfxToolPos;
begin
  Result := DefaultInterface.Get_ToolPos(index);
end;

procedure TChartFX.Set_ToolPos(index: CfxTool; val: CfxToolPos);
begin
  DefaultInterface.Set_ToolPos(index, val);
end;

function  TChartFX.Get_Const_(index: Smallint): Double;
begin
  Result := DefaultInterface.Get_Const_(index);
end;

procedure TChartFX.Set_Const_(index: Smallint; val: Double);
begin
  DefaultInterface.Set_Const_(index, val);
end;

function  TChartFX.Get_FixLeg(index: Smallint): WideString;
begin
  Result := DefaultInterface.Get_FixLeg(index);
end;

procedure TChartFX.Set_FixLeg(index: Smallint; const val: WideString);
begin
  DefaultInterface.Set_FixLeg(index, val);
end;

function  TChartFX.Get_TBItemID(nIndex: Smallint): CfxToolID;
begin
  Result := DefaultInterface.Get_TBItemID(nIndex);
end;

procedure TChartFX.Set_TBItemID(nIndex: Smallint; val: CfxToolID);
begin
  DefaultInterface.Set_TBItemID(nIndex, val);
end;

function  TChartFX.Get_MultiPoint(index: Smallint): CfxPointType;
begin
  Result := DefaultInterface.Get_MultiPoint(index);
end;

procedure TChartFX.Set_MultiPoint(index: Smallint; val: CfxPointType);
begin
  DefaultInterface.Set_MultiPoint(index, val);
end;

function  TChartFX.Get_Adm(index: CfxAdm): Double;
begin
  Result := DefaultInterface.Get_Adm(index);
end;

procedure TChartFX.Set_Adm(index: CfxAdm; val: Double);
begin
  DefaultInterface.Set_Adm(index, val);
end;

function  TChartFX.Get_DecimalsNum(index: CfxDecimal): Smallint;
begin
  Result := DefaultInterface.Get_DecimalsNum(index);
end;

procedure TChartFX.Set_DecimalsNum(index: CfxDecimal; val: Smallint);
begin
  DefaultInterface.Set_DecimalsNum(index, val);
end;

function  TChartFX.Get_BarBitmap(index: Smallint): IPictureDisp;
begin
  Result := DefaultInterface.Get_BarBitmap(index);
end;

procedure TChartFX.Set_BarBitmap(index: Smallint; const val: IPictureDisp);
begin
  DefaultInterface.Set_BarBitmap(index, val);
end;

function  TChartFX.Get_Value(index: Integer): Double;
begin
  Result := DefaultInterface.Get_Value(index);
end;

procedure TChartFX.Set_Value(index: Integer; val: Double);
begin
  DefaultInterface.Set_Value(index, val);
end;

function  TChartFX.Get_Xvalue(index: Integer): Double;
begin
  Result := DefaultInterface.Get_Xvalue(index);
end;

procedure TChartFX.Set_Xvalue(index: Integer; val: Double);
begin
  DefaultInterface.Set_Xvalue(index, val);
end;

function  TChartFX.Get_IniValue(index: Integer): Double;
begin
  Result := DefaultInterface.Get_IniValue(index);
end;

procedure TChartFX.Set_IniValue(index: Integer; val: Double);
begin
  DefaultInterface.Set_IniValue(index, val);
end;

procedure TChartFX.Refresh;
begin
  DefaultInterface.Refresh;
end;

procedure TChartFX.AboutBox;
begin
  DefaultInterface.AboutBox;
end;

function  TChartFX.OpenDataEx(nType: CfxCod; n1: Integer; n2: Integer): Integer;
begin
  Result := DefaultInterface.OpenDataEx(nType, n1, n2);
end;

function  TChartFX.CloseData(nType: CfxCod): WordBool;
begin
  Result := DefaultInterface.CloseData(nType);
end;

function  TChartFX.DblClk(nType: CfxClick; lExtra: Integer): Integer;
begin
  Result := DefaultInterface.DblClk(nType, lExtra);
end;

function  TChartFX.RigClk(nType: CfxClick; lExtra: Integer): Integer;
begin
  Result := DefaultInterface.RigClk(nType, lExtra);
end;

function  TChartFX.ShowDialog(nDialog: CfxDialog; lExtra: Integer): Integer;
begin
  Result := DefaultInterface.ShowDialog(nDialog, lExtra);
end;

function  TChartFX.ClearLegend(index: CfxLegend): Integer;
begin
  Result := DefaultInterface.ClearLegend(index);
end;

function  TChartFX.PrintIt(nFrom: Smallint; nTo: Smallint): Integer;
begin
  Result := DefaultInterface.PrintIt(nFrom, nTo);
end;

function  TChartFX.Scroll(wParam: CfxScroll; lParam: Integer): Integer;
begin
  Result := DefaultInterface.Scroll(wParam, lParam);
end;

function  TChartFX.Paint(hDC: Integer; nLeft: Integer; nTop: Integer; nRight: Integer; 
                         nBottom: Integer; wAction: CfxChartPaint; lps: Integer): Integer;
begin
  Result := DefaultInterface.Paint(hDC, nLeft, nTop, nRight, nBottom, wAction, lps);
end;

function  TChartFX.PaintInfo(index: CfxPaintInfo): OleVariant;
begin
  Result := DefaultInterface.PaintInfo(index, EmptyParam);
end;

function  TChartFX.PaintInfo(index: CfxPaintInfo; vData: OleVariant): OleVariant;
begin
  Result := DefaultInterface.PaintInfo(index, vData);
end;

procedure TChartFX.PaintInfo2(nIndex: CfxPaintInfo; vData: OleVariant; var vResult: OleVariant);
begin
  DefaultInterface.PaintInfo2(nIndex, vData, vResult);
end;

function  TChartFX.Export(nType: CfxExport): Integer;
begin
  Result := DefaultInterface.Export(nType, EmptyParam);
end;

function  TChartFX.Export(nType: CfxExport; vData: OleVariant): Integer;
begin
  Result := DefaultInterface.Export(nType, vData);
end;

function  TChartFX.Import(nType: CfxExport): Integer;
begin
  Result := DefaultInterface.Import(nType, EmptyParam);
end;

function  TChartFX.Import(nType: CfxExport; vData: OleVariant): Integer;
begin
  Result := DefaultInterface.Import(nType, vData);
end;

function  TChartFX.Language(const sResource: WideString): Integer;
begin
  Result := DefaultInterface.Language(sResource);
end;

function  TChartFX.SendMsg(wMsg: Integer; wParam: Integer; lParam: Integer): Integer;
begin
  Result := DefaultInterface.SendMsg(wMsg, wParam, lParam);
end;

procedure TChartFX.AddExtension(vExt: OleVariant);
begin
  DefaultInterface.AddExtension(vExt);
end;

function  TChartFX.GetExtension(const sExtension: WideString): IUnknown;
begin
  Result := DefaultInterface.GetExtension(sExtension);
end;

procedure TChartFX.RemoveExtension(const sExtension: WideString);
begin
  DefaultInterface.RemoveExtension(sExtension);
end;

function  TChartFX.GetPicture(nFormat: Smallint): IPictureDisp;
begin
  Result := DefaultInterface.GetPicture(nFormat);
end;

procedure TChartFX.GetExternalData(vDataProvider: OleVariant);
begin
  DefaultInterface.GetExternalData(vDataProvider, EmptyParam);
end;

procedure TChartFX.GetExternalData(vDataProvider: OleVariant; vPar: OleVariant);
begin
  DefaultInterface.GetExternalData(vDataProvider, vPar);
end;

procedure TChartFX.RecalcScale;
begin
  DefaultInterface.RecalcScale;
end;

procedure TChartFX.SetContourLabels(STEP: Double);
begin
  DefaultInterface.SetContourLabels(STEP);
end;

procedure TChartFX.AddBar(nID: Smallint; const pObj: IUnknown);
begin
  DefaultInterface.AddBar(nID, pObj);
end;

function  TChartFX.GetBar(nID: Smallint): IUnknown;
begin
  Result := DefaultInterface.GetBar(nID);
end;

procedure TChartFX.RemoveBar(nID: Smallint);
begin
  DefaultInterface.RemoveBar(nID);
end;

procedure TChartFX.ClearData(newVal: CfxDataMask);
begin
  DefaultInterface.ClearData(newVal);
end;

procedure TChartFX.ZoomIn(xMin: Double; yMin: Double; xMax: Double; yMax: Double);
begin
  DefaultInterface.ZoomIn(xMin, yMin, xMax, yMax);
end;

procedure TChartFX._GetCChartFXPointer(out pChart: Integer);
begin
  DefaultInterface._GetCChartFXPointer(pChart);
end;

function  TChartFX.HitTest(x: Integer; y: Integer; out NSeries: Smallint; out nPoint: Integer): CfxHitTest;
begin
  Result := DefaultInterface.HitTest(x, y, NSeries, nPoint);
end;

procedure TChartFX.ShowBalloon(const sText: WideString; x: Integer; y: Integer);
begin
  DefaultInterface.ShowBalloon(sText, x, y);
end;

procedure TChartFX.CreateWnd(hwndParent: Integer; nID: Smallint; x: Integer; y: Integer; 
                             cx: Integer; cy: Integer; dwStyle: Integer);
begin
  DefaultInterface.CreateWnd(hwndParent, nID, x, y, cx, cy, dwStyle);
end;

function  TChartFX.SetEventHandler(const pObj: IUnknown): IUnknown;
begin
  Result := DefaultInterface.SetEventHandler(pObj);
end;

procedure TChartFX.ShowHelpTopic(const pszHelpDir: WideString; nTopic: Integer);
begin
  DefaultInterface.ShowHelpTopic(pszHelpDir, nTopic);
end;

function  TChartFX.SetStripe(index: Smallint; dMin: Double; dMax: Double; rgb: OLE_COLOR): Integer;
begin
  Result := DefaultInterface.SetStripe(index, dMin, dMax, rgb);
end;

procedure TChartFX.ValueToPixel(Xvalue: Double; Yvalue: Double; out x: Integer; out y: Integer; 
                                nYAxis: CfxAxisIndex);
begin
  DefaultInterface.ValueToPixel(Xvalue, Yvalue, x, y, nYAxis);
end;

procedure TChartFX.PixelToValue(x: Integer; y: Integer; out Xvalue: Double; out Yvalue: Double; 
                                nYAxis: CfxAxisIndex);
begin
  DefaultInterface.PixelToValue(x, y, Xvalue, Yvalue, nYAxis);
end;

procedure TChartFX.CompactSeriesAttributes(bGallery: WordBool);
begin
  DefaultInterface.CompactSeriesAttributes(bGallery);
end;

procedure TChartFX.UpdateSizeNow;
begin
  DefaultInterface.UpdateSizeNow;
end;

class function CoGeneralPage.Create: IUnknown;
begin
  Result := CreateComObject(CLASS_GeneralPage) as IUnknown;
end;

class function CoGeneralPage.CreateRemote(const MachineName: string): IUnknown;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_GeneralPage) as IUnknown;
end;

class function CoSeriesPage.Create: IUnknown;
begin
  Result := CreateComObject(CLASS_SeriesPage) as IUnknown;
end;

class function CoSeriesPage.CreateRemote(const MachineName: string): IUnknown;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SeriesPage) as IUnknown;
end;

class function CoAxesPage.Create: IUnknown;
begin
  Result := CreateComObject(CLASS_AxesPage) as IUnknown;
end;

class function CoAxesPage.CreateRemote(const MachineName: string): IUnknown;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_AxesPage) as IUnknown;
end;

class function CoPage3D.Create: IUnknown;
begin
  Result := CreateComObject(CLASS_Page3D) as IUnknown;
end;

class function CoPage3D.CreateRemote(const MachineName: string): IUnknown;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Page3D) as IUnknown;
end;

class function CoScalePage.Create: IUnknown;
begin
  Result := CreateComObject(CLASS_ScalePage) as IUnknown;
end;

class function CoScalePage.CreateRemote(const MachineName: string): IUnknown;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ScalePage) as IUnknown;
end;

class function CoLabelsPage.Create: IUnknown;
begin
  Result := CreateComObject(CLASS_LabelsPage) as IUnknown;
end;

class function CoLabelsPage.CreateRemote(const MachineName: string): IUnknown;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_LabelsPage) as IUnknown;
end;

class function CoGridLinesPage.Create: IUnknown;
begin
  Result := CreateComObject(CLASS_GridLinesPage) as IUnknown;
end;

class function CoGridLinesPage.CreateRemote(const MachineName: string): IUnknown;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_GridLinesPage) as IUnknown;
end;

class function CoConstantStripesPage.Create: IUnknown;
begin
  Result := CreateComObject(CLASS_ConstantStripesPage) as IUnknown;
end;

class function CoConstantStripesPage.CreateRemote(const MachineName: string): IUnknown;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ConstantStripesPage) as IUnknown;
end;

procedure Register;
begin
  RegisterComponents('ActiveX',[TChartFX]);
end;

end.
