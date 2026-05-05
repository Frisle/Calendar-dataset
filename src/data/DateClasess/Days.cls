Class data.DateClasess.Days Extends %Persistent
{

Property ShortMonthName As %String;

Property LongMonthName As %String;

Property MonthYearNum As %Integer;

Property MonthYear As %String;

Property MonthYearLong As %String;

Property WeekYearString As %String;

Property WeekYearNumeric As %Integer;

Property Week As %Integer;

Property Years As %Integer;

Property DayOfMonth As %Integer;

Property DayOfYear As %Integer;

Property DayName As %String;

Property MonthNumeric As %Integer;

Property TimeStamp As %TimeStamp;

ClassMethod Insert(ShortMonthName, LongMonthName, MonthYearNum, MonthYear, MonthYearLong, MonthNumeric, WeekYearString, WeekYearNumeric, Week, Year, TimeStamp, DayName, DayOfMonth, DayOfYear) As %Status
{
    set sc = $$$OK
    
    set daysClass = ..%New()

    set daysClass.ShortMonthName = ShortMonthName
    set daysClass.LongMonthName = LongMonthName
    set daysClass.MonthYearNum = MonthYearNum
    set daysClass.MonthYear = MonthYear
    set daysClass.MonthYearLong = MonthYearLong
    set daysClass.MonthNumeric = MonthNumeric
    set daysClass.WeekYearString = WeekYearString
    set daysClass.WeekYearNumeric = WeekYearNumeric
    set daysClass.Week = Week
    set daysClass.Years = Year
    set daysClass.TimeStamp = TimeStamp
    set daysClass.DayName = DayName
    set daysClass.DayOfMonth = DayOfMonth
    set daysClass.DayOfYear = DayOfYear

    set sc = daysClass.%Save()

    return sc
}

Storage Default
{
<Data name="DaysDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ShortMonthName</Value>
</Value>
<Value name="3">
<Value>LongMonthName</Value>
</Value>
<Value name="4">
<Value>MonthYearNum</Value>
</Value>
<Value name="5">
<Value>MonthYear</Value>
</Value>
<Value name="6">
<Value>MonthYearLong</Value>
</Value>
<Value name="7">
<Value>WeekYearString</Value>
</Value>
<Value name="8">
<Value>WeekYearNumeric</Value>
</Value>
<Value name="9">
<Value>Week</Value>
</Value>
<Value name="10">
<Value>Years</Value>
</Value>
<Value name="11">
<Value>DayOfMonth</Value>
</Value>
<Value name="12">
<Value>DayOfYear</Value>
</Value>
<Value name="13">
<Value>DayName</Value>
</Value>
<Value name="14">
<Value>MonthNumeric</Value>
</Value>
<Value name="15">
<Value>TimeStamp</Value>
</Value>
</Data>
<DataLocation>^data.DateClasess.DaysD</DataLocation>
<DefaultData>DaysDefaultData</DefaultData>
<IdLocation>^data.DateClasess.DaysD</IdLocation>
<IndexLocation>^data.DateClasess.DaysI</IndexLocation>
<StreamLocation>^data.DateClasess.DaysS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
