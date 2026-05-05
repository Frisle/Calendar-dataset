Class data.generator Extends %RegisteredObject
{

ClassMethod Generate(StartDate, EndDate, days = 1, months = 1) As %Status
{
    // date in format: 2000-01-01 or 2000-01-01 00:00:00 
    set sc = $$$OK
    if 'StartDate set StartTs = $ZDATETIME($ZDATETIMEH("1970-01-01", 3), 3)
    if 'EndDate set EndTs = $SYSTEM.SQL.Functions.DATEADD("year", 10, $ZDATETIMEH($ZDATETIME($NOW(), 3), 3))
    

    set DiffInMonths = $SYSTEM.SQL.Functions.DATEDIFF("month", StartTs, EndTs)
    set DiffInDays = $SYSTEM.SQL.Functions.DATEDIFF("day", StartTs, EndTs)

    if days{
        for i=1:1:DiffInMonths{
            set date = $SYSTEM.SQL.Functions.DATEADD("month", i, StartTs)
            set obj = ..Days(date)

            do ##class(data.DateClasess.Days).Insert(
                obj.ShortMonthName,
                obj.LongMonthName,
                obj.MonthYearNum,
                obj.MonthYear,
                obj.MonthYearLong,
                obj.MonthNumeric,
                obj.WeekYearNumeric,
                obj.WeekYearNumeric,
                obj.Week,
                obj.Year,
                obj.TimeStamp
                
            )
        }
    }

    if months{
        for i=1:1:DiffInMonths{
            set date = $SYSTEM.SQL.Functions.DATEADD("month", i, StartTs)
            set obj = ..Months(date)
       
            do ##class(data.DateClasess.Months).Insert(
                obj.ShortMonthName,
                obj.LongMonthName,
                obj.QuarterYear,
                obj.MonthYearNum,
                obj.MonthYear,
                obj.MonthYearLong,
                obj.Year,
                obj.Quarter,
                obj.MonthNumeric
            )
    
    }
    }

    return sc
}

ClassMethod Months(ts, delimeter = "-") As %Library.DynamicObject
{
 
    set obj = ##class(%Library.DynamicObject).%New()

    set ShortMonthName = $EXTRACT($PIECE($ZDATETIME($ZDATETIMEH(ts,3), 9), " ", 1), 1, 3) // ex: Jan.. Dec
    set LongMonthName = $PIECE($ZDATETIME($ZDATETIMEH(ts,3), 9), " ", 1) // ex: January.. December
    set Year = $PIECE($ZDATETIME($ZDATETIMEH(ts,3), 9), " ", 3) // ex: 1970.. 2030
    set Quarter = $SYSTEM.SQL.Functions.QUARTER($ZDATETIME($ZDATETIMEH(ts,3), 3))
    Set QuarterYear = "Q"_Quarter_" "_Year // ex: "Q1 1970"
    
    set MonthNumeric = $PIECE($PIECE($ZDATETIME($ZDATETIMEH(ts,3), 3), " ", 1), "-", 2) // ex: 01,02,03...12

    set MonthYearNumeric = Year_MonthNumeric // 197001, 197002.. 203001

    set MonthYearString = ShortMonthName_delimeter_Year // Jan-1970
    set MonthYearLongString = LongMonthName_delimeter_Year // January-1970

    set obj.ShortMonthName = ShortMonthName
    set obj.LongMonthName = LongMonthName
    set obj.QuarterYear = QuarterYear
    set obj.MonthYearNum = MonthYearNumeric
    set obj.MonthYear = MonthYearString
    set obj.MonthYearLong = MonthYearLongString
    set obj.Year = Year
    set obj.Quarter = Quarter
    set obj.MonthNumeric = MonthNumeric


    return obj
}

ClassMethod Days(ts, delimeter = "-") As %Library.DynamicObject
{
    set obj = ##class(%Library.DynamicObject).%New()

    set ShortMonthName = $EXTRACT($PIECE($ZDATETIME($ZDATETIMEH(ts,3), 9), " ", 1), 1, 3) // ex: Jan.. Dec
    set LongMonthName = $PIECE($ZDATETIME($ZDATETIMEH(ts,3), 9), " ", 1) // ex: January.. December
    set Year = $PIECE($ZDATETIME($ZDATETIMEH(ts,3), 9), " ", 3) // ex: 1970.. 2030

    set MonthNumeric = $PIECE($PIECE($ZDATETIME($ZDATETIMEH(ts,3), 3), " ", 1), "-", 2) 
    set YearNumeric = $PIECE($PIECE($ZDATETIME($ZDATETIMEH(ts,3), 3), " ", 1), "-", 1)

    set MonthYearNumeric = YearNumeric_MonthNumeric // 197001, 197002.. 203001

    set MonthYearString = ShortMonthName_delimeter_Year
    set MonthYearLongString = LongMonthName_delimeter_Year

    set Week = $SYSTEM.SQL.Functions.WEEK($ZDATETIME($ZDATETIMEH(ts,3), 3))
    set WeekYearString = Year_"-"_"W"_Week
    set WeekYearNumeric = Year_Week

    set obj.ShortMonthName = ShortMonthName
    set obj.LongMonthName = LongMonthName
    set obj.MonthYearNum = MonthYearNumeric
    set obj.MonthYear = MonthYearString
    set obj.MonthYearLong = MonthYearLongString
    set obj.WeekYearString = WeekYearString
    set obj.WeekYearNumeric = WeekYearNumeric
    set obj.Week = Week
    set obj.Year = Year
    set obj.MonthNumeric = MonthNumeric
    set obj.TimeStamp = $ZDATETIME($ZDATETIMEH(ts,3), 3)

    return obj
}

}
