Class data.generator Extends %RegisteredObject
{

ClassMethod Generate(StartDate = "1970-01-01", EndDate, days = 1, months = 1, timeTable = 1) As %Status
{
    KILL ^data.DateClasess.DaysD, ^data.DateClasess.MonthsD

    // date in format: 2000-01-01 or 2000-01-01 00:00:00 
    set sc = $$$OK
    set StartTs = $ZDATETIME($ZDATETIMEH(StartDate, 3), 3)
    if 'EndDate set EndTs = $SYSTEM.SQL.Functions.DATEADD("year", 10, $ZDATETIMEH($ZDATETIME($NOW(), 3), 3))
    

    set DiffInMonths = $SYSTEM.SQL.Functions.DATEDIFF("month", StartTs, EndTs)
    set DiffInDays = $SYSTEM.SQL.Functions.DATEDIFF("day", StartTs, EndTs)

    if days{
        for i=1:1:DiffInMonths{
            set date = $SYSTEM.SQL.Functions.DATEADD("day", i, StartTs)
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
                obj.TimeStamp,
                obj.DayName,
                obj.DayOfMonth,
                obj.DayOfYear
                
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
                obj.MonthNumeric,
                obj.TimeStamp
                
            )
    
    }

    if timeTable{

        do ##class(data.generator).Populate24Hours()
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
    set obj.TimeStamp = $ZDATETIME($ZDATETIMEH(ts,3), 3)


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
    set obj.DayName = $SYSTEM.SQL.Functions.DAYNAME($ZDATETIME($ZDATETIMEH(ts,3), 3))
    set obj.DayOfMonth = $SYSTEM.SQL.Functions.DAYOFMONTH($ZDATETIME($ZDATETIMEH(ts,3), 3))
    set obj.DayOfYear = $SYSTEM.SQL.Functions.DAYOFYEAR($ZDATETIME($ZDATETIMEH(ts,3), 3))

    return obj
}

ClassMethod TimeTable(hours, minutes, seconds) As %Library.DynamicObject
{
    Set obj = ##class(%DynamicObject).%New()
    Set obj.hours = hours
    Set obj.minutes = minutes
    Set obj.seconds = seconds
    set timestamp = $ZDATETIME($HOROLOG, 3, 1) _ " " _ 
                         $EXTRACT("0"_hours, *-1, *) _ ":" _ 
                         $EXTRACT("0"_minutes, *-1, *) _ ":" _ 
                         $EXTRACT("0"_seconds, *-1, *)
    
    set obj.timestamp = $PIECE(timestamp, " ", 3)
    set obj.htimestamp = $ZTIMEH($PIECE(timestamp, " ", 3), 2)
    set obj.ampmtimestamp = $ZTIME($ZTIMEH($PIECE(timestamp, " ", 3), 2), 3)

    return obj
}

ClassMethod Populate24Hours() As %Status
{
    Set sc = $$$OK
    
    set timeClass = ##class(data.DateClasess.TimeTable).%New()
    
    For hour=0:1:23 {
        For min=0:1:59 {
            For sec=0:1:59 {
                Set obj = ..TimeTable(hour, min, sec)
                do timeClass.Insert(obj.hours, obj.minutes, obj.seconds, obj.timestamp, obj.htimestamp, obj.ampmtimestamp)
                
            }
        }
    }
    
    
    return sc
}

}
