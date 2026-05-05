Class data.DateClasess.TimeTable Extends %Persistent
{

Property TimeStamp As %TimeStamp;

Property TwelfthFormatTimeStamp As %TimeStamp;

Property Hours As %Integer;

Property TwelfthFormatHour As %Integer;

Property Minutes As %Integer;

Property Seconds As %Integer;

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
<Value>TwelfthFormatTimeStamp</Value>
</Value>
<Value name="4">
<Value>Hours</Value>
</Value>
<Value name="5">
<Value>TwelfthFormatHour</Value>
</Value>
<Value name="6">
<Value>Minutes</Value>
</Value>
<Value name="7">
<Value>Seconds</Value>
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
