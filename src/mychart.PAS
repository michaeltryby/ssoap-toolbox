unit MyChart;

interface

uses
  ChartfxLib_TLB, AnnotateX_TLB;

type
  MyTChartFX = class(TChartFX)
    private
      FAnnotation: AnnotationX;
    public
      property Anno: AnnotationX
        read FAnnotation write FAnnotation;
  end;

implementation

end.

