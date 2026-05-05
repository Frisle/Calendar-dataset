Class data.DateClasess.Months Extends %Persistent
{

Property ShortMonthName As %String;

Property LongMonthName As %String;

Property QuarterYear As %String;

Property MonthYearNum As %Integer;

Property MonthYear As %String;

Property MonthYearLong As %String;

Property Years As %Integer;

Property Quarter As %Integer;

Property MonthNumeric As %Integer;

Property TimeStamp As %TimeStamp;

ClassMethod Insert(ShortMonthName, LongMonthName, QuarterYear, MonthYearNum, MonthYear, MonthYearLong, Year, Quarter, MonthNumeric, TimeStamp) As %Status
{
    set sc = $$$OK
    
    set monthClass = ..%New()

    set monthClass.ShortMonthName = ShortMonthName
    set monthClass.LongMonthName = LongMonthName
    set monthClass.QuarterYear = QuarterYear
    set monthClass.MonthYearNum = MonthYearNum
    set monthClass.MonthYear = MonthYear
    set monthClass.MonthYearLong = MonthYearLong
    set monthClass.Years = Year
    set monthClass.Quarter = Quarter
    set monthClass.MonthNumeric = MonthNumeric
    set monthClass.TimeStamp = TimeStamp

    set sc = monthClass.%Save()
    return sc
}

Storage Default
{
<Data name="MonthsDefaultData">
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
<Value>QuarterYear</Value>
</Value>
<Value name="5">
<Value>MonthYearNum</Value>
</Value>
<Value name="6">
<Value>MonthYear</Value>
</Value>
<Value name="7">
<Value>MonthYearLong</Value>
</Value>
<Value name="8">
<Value>YearI</Value>
</Value>
<Value name="9">
<Value>Quarter</Value>
</Value>
<Value name="10">
<Value>MonthNumeric</Value>
</Value>
<Value name="11">
<Value>Years</Value>
</Value>
<Value name="12">
<Value>TimeStamp</Value>
</Value>
</Data>
<DataLocation>^data.DateClasess.MonthsD</DataLocation>
<DefaultData>MonthsDefaultData</DefaultData>
<IdLocation>^data.DateClasess.MonthsD</IdLocation>
<IndexLocation>^data.DateClasess.MonthsI</IndexLocation>
<StreamLocation>^data.DateClasess.MonthsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
