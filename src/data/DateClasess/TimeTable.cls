Class data.DateClasess.TimeTable Extends %Persistent
{

Property TimeStamp As %String;

Property Hours As %Integer;

Property Minutes As %Integer;

Property Seconds As %Integer;

Property HTimeStamp As %Integer;

Property AaPmTimeStamp As %String;

ClassMethod Insert(Hours, Minutes, Seconds, TimeStamp, HTimeStamp, AaPmTimeStamp) As %Status
{
    set sc = $$$OK

    set timeTable = ..%New()

    set timeTable.Hours = Hours
    set timeTable.Minutes = Minutes
    set timeTable.Seconds = Seconds
    set timeTable.TimeStamp = TimeStamp
    set timeTable.HTimeStamp = HTimeStamp
    set timeTable.AaPmTimeStamp = AaPmTimeStamp

    set sc = timeTable.%Save()
    return sc
}

Storage Default
{
<Data name="TimeTableDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TimeStamp</Value>
</Value>
<Value name="3">
<Value>Hours</Value>
</Value>
<Value name="4">
<Value>Minutes</Value>
</Value>
<Value name="5">
<Value>Seconds</Value>
</Value>
<Value name="6">
<Value>HTimeStamp</Value>
</Value>
<Value name="7">
<Value>AaPmTimeStamp</Value>
</Value>
</Data>
<DataLocation>^data.DateClasess.TimeTableD</DataLocation>
<DefaultData>TimeTableDefaultData</DefaultData>
<IdLocation>^data.DateClasess.TimeTableD</IdLocation>
<IndexLocation>^data.DateClasess.TimeTableI</IndexLocation>
<StreamLocation>^data.DateClasess.TimeTableS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
