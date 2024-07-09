unit rainfallIntensityStatistics;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmRainfallIntensityStatistics = class(TForm)
    AnalysisLabel: TLabel;
    Filename: TLabel;
    AnalysisNameComboBox: TComboBox;
    FilenameEdit: TEdit;
    BrowseButton: TButton;
    okButton: TButton;
    helpButton: TButton;
    cancelButton: TButton;
    SaveDialog1: TSaveDialog;
    Label3: TLabel;
    MinimumIntereventDurationEdit: TEdit;
    MinimumRainfallVolumeLabel: TLabel;
    MinimumRainfallVolumeEdit: TEdit;
    procedure cancelButtonClick(Sender: TObject);
    procedure BrowseButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure okButtonClick(Sender: TObject);
    procedure helpButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmRainfallIntensityStatistics: TfrmRainfallIntensityStatistics;

implementation

uses modDatabase, rdiiutils, stormEventCollection, stormEvent, ADODB_TLB,
  mainform;

{$R *.DFM}

procedure TfrmRainfallIntensityStatistics.cancelButtonClick(
  Sender: TObject);
begin
//  Close;
  modalresult := mrCancel;
end;

procedure TfrmRainfallIntensityStatistics.BrowseButtonClick(
  Sender: TObject);
begin
  if (SaveDialog1.Execute) then FilenameEdit.Text := SaveDialog1.Filename;
end;

procedure TfrmRainfallIntensityStatistics.FormShow(Sender: TObject);
begin
  AnalysisNameComboBox.Items := DatabaseModule.GetAnalysisNames;
  AnalysisNameComboBox.ItemIndex := 0;
end;

procedure TfrmRainfallIntensityStatistics.helpButtonClick(Sender: TObject);
begin
  frmMain.HelpHandler_Universal(Self);
end;

procedure TfrmRainfallIntensityStatistics.okButtonClick(Sender: TObject);
var
  filename, analysisName, raingaugeName: string;
  F: textFile;
  analysisID, raingaugeID, timestep, iEvent : integer;
  events: TStormEventCollection;
  iiEvent, thisRain, prevRain, bigRain, lastEvent: TStormEvent;
  recSet: _RecordSet;
  timestamp: TDateTime;
  rainfall, thisVolume, thisDuration, prevVolume, prevDuration: real;
  bigVolume, bigDuration, lastVolume, lastDuration, minDry, minVol: real;
  inEvent: boolean;
  day, month, year, hour, minute, second, ms: word;
  queryStr: string;
begin
  filename := FilenameEdit.Text;
  if fileCanBeWritten(filename) then begin
    if (Length(MinimumIntereventDurationEdit.Text) > 0)
      then minDry := strToFloat(MinimumIntereventDurationEdit.Text)
      else minDry := 0.0;
    if (Length(MinimumRainfallVolumeEdit.Text) > 0)
      then minvol := strToFloat(MinimumRainfallVolumeEdit.Text)
      else minvol := 0.0;
    analysisName := AnalysisNameComboBox.Items.Strings[AnalysisNameComboBox.ItemIndex];
    analysisID := DatabaseModule.GetAnalysisIDForName(analysisName);
    events := DatabaseModule.GetEvents(analysisID);
    raingaugeName := DatabaseModule.GetRaingaugeNameForAnalysis(analysisName);
    raingaugeID := DatabaseModule.GetRaingaugeIDForName(raingaugeName);
    timestep := DatabaseModule.GetRainfallTimestep(raingaugeID);
    AssignFile(F,filename);
    Rewrite(F);
    try
    writeln(F,'"First is number and starting and ending day of defined I/I event."');
    writeln(F,'"Then stats for first event within this defined I/I event."');
    writeln(F,'"Then stats for previous rainfall event."');
    writeln(F,'"Then stats for previous rainfall event with rain greater than minimum volume."');
    writeln(F,'"Then stats for previous rainfall event that is within a defined I/I event."');
    writeln(F,'"Following stats are given for each rainfall event:"');
    writeln(F,'"   - rainfall start month day year hour (first period with rain)."');
    writeln(F,'"   - rainfall end month day year hour (last period with rain)."');
    writeln(F,'"   - total rainfall event rainfall volume in inches."');
    writeln(F,'"   - rainfall event rainfall duration in hours (only periods with rain)."');
    writeln(F,'"   - total rainfall event event duration hour (includes imbedded dry periods)."');
    writeln(F,'"   - hours between this rainfall event and first rainfall event in this I/I event."');
    writeln(F,'event month day year hour month day year hour ',
              'month day year hour month day year hour rvol rdur edur ',
              'month day year hour month day year hour rvol rdur edur dryhrs ',
              'month day year hour month day year hour rvol rdur edur dryhrs ',
              'month day year hour month day year hour rvol rdur edur dryhrs');


    queryStr := 'SELECT DateTime, Volume From Rainfall WHERE ' +
                '(RaingaugeID = ' + inttostr(raingaugeID) + ') order by datetime;';
    recSet := CoRecordSet.Create;
    recSet.Open(queryStr,frmMain.connection,adOpenDynamic,adLockOptimistic,adCmdText);
    //rm 2007-10-18 - prevent crash from empty recordset
    if recSet.EOF then
    else
      recSet.MoveFirst;

    inEvent := false;
    iEvent := 0;
    while (not recSet.EOF) and (not (ievent >= events.count)) do begin
      iiEvent := events[iEvent];
      timestamp := recSet.Fields.Item[0].Value;
      rainfall := recSet.Fields.Item[1].Value;
{      writeln(F,datetimetostr(timestamp),' ',rainfall,' ',inEvent,' ',
              floattostrF((timestamp - thisRain.EndDate)* 24,ffFixed,8,4),' ',minDry
              );                                      }
      if (inEvent) then begin
        if ((timestamp - thisRain.EndDate)* 24 > minDry) then begin
{          writeln(F,'****END****');   }
          inevent := false;

          if (ievent > 1) then
            if (thisRain.overlaps(events[ievent-1])) then begin
              lastEvent := thisRain;
              lastDuration := thisDuration;
              lastVolume := thisVolume;
            end;

          if thisRain.overlaps(iiEvent) then begin
            decodeDate(iiEvent.startDate,year,month,day);
            decodeTime(iiEvent.startDate,hour,minute,second,ms);
            write(F,ievent+1,' ',month,' ',day,' ',year,' ',floattostrF(hour + minute/60,ffFixed,8,2),' ');
            decodeDate(iiEvent.endDate,year,month,day);
            decodeTime(iiEvent.endDate,hour,minute,second,ms);
            write(F,month,' ',day,' ',year,' ',floattostrF(hour + minute/60,ffFixed,8,2),' ');

            decodeDate(thisRain.startDate,year,month,day);
            decodeTime(thisRain.startDate,hour,minute,second,ms);
            write(F,month,' ',day,' ',year,' ',floattostrF(hour + minute/60,ffFixed,8,2),' ');
            decodeDate(thisRain.endDate,year,month,day);
            decodeTime(thisRain.endDate,hour,minute,second,ms);
            write(F,month,' ',day,' ',year,' ',floattostrF(hour + minute/60,ffFixed,8,2),' ');
            write(F,floattostrF(thisVolume,ffFixed,8,2),' ');
            write(F,floattostrF(thisDuration,ffFixed,8,2),' ');
            write(F,floattostrF(thisRain.duration*24+timestep/60.0,ffFixed,8,2),' ');
//rm 2007-11-02 prevRain is being used before being initialized if overlap first time through
if Assigned(prevRain) then begin
            decodeDate(prevRain.startDate,year,month,day);
            decodeTime(prevRain.startDate,hour,minute,second,ms);
            write(F,month,' ',day,' ',year,' ',floattostrF(hour + minute/60,ffFixed,8,2),' ');
            decodeDate(prevRain.endDate,year,month,day);
            decodeTime(prevRain.endDate,hour,minute,second,ms);
            write(F,month,' ',day,' ',year,' ',floattostrF(hour + minute/60,ffFixed,8,2),' ');
            write(F,floattostrF(prevVolume,ffFixed,8,2),' ');
            write(F,floattostrF(prevDuration,ffFixed,8,2),' ');
            write(F,floattostrF(prevRain.duration*24+timestep/60.0,ffFixed,8,2),' ');
            write(F,floattostrF((thisRain.startDate-prevRain.endDate)*24.0-timestep/60.0,ffFixed,8,2),' ');
end else begin
            write(F,'no previous rainfall');
end;
//rm 2007-11-02 same thing - bigRain is being used before begin initialized
if Assigned(bigRain) then begin
            decodeDate(bigRain.startDate,year,month,day);
            decodeTime(bigRain.startDate,hour,minute,second,ms);
            write(F,month,' ',day,' ',year,' ',floattostrF(hour + minute/60,ffFixed,8,2),' ');
            decodeDate(bigRain.endDate,year,month,day);
            decodeTime(bigRain.endDate,hour,minute,second,ms);
            write(F,month,' ',day,' ',year,' ',floattostrF(hour + minute/60,ffFixed,8,2),' ');
            write(F,floattostrF(bigVolume,ffFixed,8,2),' ');
            write(F,floattostrF(bigDuration,ffFixed,8,2),' ');
            write(F,floattostrF(bigRain.duration*24+timestep/60.0,ffFixed,8,2),' ');
            write(F,floattostrF((thisRain.startDate-bigRain.endDate)*24.0-timestep/60.0,ffFixed,8,2),' ');
end else begin
            write(F,'no previous max rainfall');
end;

            if (lastEvent <> nil) then begin
              decodeDate(lastEvent.startDate,year,month,day);
              decodeTime(lastEvent.startDate,hour,minute,second,ms);
              write(F,month,' ',day,' ',year,' ',floattostrF(hour + minute/60,ffFixed,8,2),' ');
              decodeDate(lastEvent.endDate,year,month,day);
              decodeTime(lastEvent.endDate,hour,minute,second,ms);
              write(F,month,' ',day,' ',year,' ',floattostrF(hour + minute/60,ffFixed,8,2),' ');
              write(F,floattostrF(lastVolume,ffFixed,8,2),' ');
              write(F,floattostrF(lastDuration,ffFixed,8,2),' ');
              write(F,floattostrF(lastEvent.duration*24+timestep/60.0,ffFixed,8,2),' ');
              write(F,floattostrF((thisRain.startDate-lastEvent.endDate)*24.0-timestep/60.0,ffFixed,8,2),' ');
            end
            else write(F,'0 0 0 0.00 0 0 0 0.00 0.00 0.00 0 0 ');
            writeln(F);
            inc(ievent);

            lastEvent := thisRain;
            lastDuration := thisDuration;
            lastVolume := thisVolume;

          end;

          prevRain := thisRain;
          prevVolume := thisVolume;
          prevDuration := thisDuration;

          if (thisVolume > minvol) then begin
            bigRain := thisRain;
            bigVolume := thisVolume;
            bigDuration := thisDuration;
          end;

          thisRain := TStormEvent.Create(timestamp,timestamp,analysisID);
          thisVolume := rainfall;
          thisDuration := timestep / 60;
          inEvent := true;

        end
        else begin
          thisVolume := thisVolume + rainfall;
          thisRain.EndDate := timestamp;
          thisDuration := thisDuration + timestep / 60;
        end;
      end
      else begin
        thisRain := TStormEvent.Create(timestamp,timestamp,analysisID);
        thisVolume := rainfall;
        thisDuration := timestep / 60;
        inEvent := true;
      end;
      recSet.MoveNext;
    end;
    finally
      //rm 2007-11-02 - a little feedback to user:
      //Messagedlg('Done.',mtInformation,[mbok],0);
      Closefile(F);
      if (recSet.State <> adStateClosed) then recSet.Close;
    end;
    //recSet.Close;
    MessageDlg('Done exporting to ' + filename + '.',
      mtInformation, [mbok],0);
//    Close;
  end;

end;

end.
