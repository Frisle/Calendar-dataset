Class data.generator Extends %RegisteredObject
{

ClassMethod IsValidDateTime(DateTime As %String) As %Boolean
{
    Set Valid = 1
    
    Try {
        Set h = $ZDATETIMEH(DateTime, 3)
    } Catch er {
        Set Valid = 0
    }
    
    Quit Valid
}

/// Entry point <br>
/// fromTs = starting dataset date must be lower than toTimeStamp <br>
/// toTimeStamp = ending dataset date <br>
/// days = flag to trigger days date dataset building; default = 1 <br>
/// months = flag to trigger months date dataset building; default = 1 <br>
/// timeTable = flag to trigger time dataset building; default = 1 <br>
/// monthYearDelimeter = stands for symbol that separates month and year values: Jan-2026, Jan'2026, Jan`2026, Jan/2026 etc <br> 
/// typical usage = do ##class(data.generator).Generate(,"",1,1,1,"-")
/// <br>
/// This would generate:
/// <ul>
/// <li> A dataset with dates by days, starting from "1970-01-01" and up to the current date and time + 10 years.</li>
/// <li> A dataset with dates by month, starting from "1970-01-01" and up to the current date and time + 10 years.</li>
/// <li> 24 hour time series dataset by seconds</li>
/// <li> And the delimeter would be "Month-Year"</li>
/// <ul>
ClassMethod Generate(fromTs = "1970-01-01 00:00:00", toTs = "", days = 1, months = 1, timeTable = 1, monthYearDelimeter = "-") As %Status
{
    set sc = $$$OK
   

    set toTimeStamp = $SELECT(toTs'="": toTs, 1:$SYSTEM.SQL.Functions.DATEADD("year", 10, $ZDATETIMEH($ZDATETIME($NOW(), 3), 3)) )
    
    if '..IsValidDateTime(fromTs) || '..IsValidDateTime(toTimeStamp){
        write "Wrong datetime format!", !
        write "Required format: YYYY-MM-DD HH:MM:SS or YYYY-MM-DD"
        return sc
    }

    if $ZDATETIMEH(fromTs, 3) > $ZDATETIMEH(toTimeStamp, 3){
        write "First argument should be smaller that the second!", !
        write "Now, the first arg: ", fromTs, " and the second ", toTimeStamp
        return sc
    }

    
    write "Generating date time dataset from: ", fromTs," to ", toTimeStamp, !
    write "Configuration: ",!, 
        " Days table: ",$SELECT(days:"Yes;", 'days:"No;"),!,
        " Months table: ",$SELECT(months:"Yes;",'months:"No;"),!, 
        " Time table: ",$SELECT(timeTable:"Yes;",'timeTable:"No;"), !,!
    write $SELECT(days:"Population starts!", months:"Population starts!", timeTable:"Population starts!", 1:"Nothing to populate"), !
 
    set DiffInMonths = $SYSTEM.SQL.Functions.DATEDIFF("month", fromTs, toTimeStamp)
    set DiffInDays = $SYSTEM.SQL.Functions.DATEDIFF("day", fromTs, toTimeStamp)

    if days{
        KILL ^data.DateClasses.DaysD
        KILL ^data.DateClasses.DaysI
            for i=0:1:DiffInDays{
                set date = $SYSTEM.SQL.Functions.DATEADD("day", i, fromTs)
                set obj = ..Days(date, monthYearDelimeter)

                do ##class(data.DateClasses.Days).Insert(
                    obj.ShortMonthName,
                    obj.LongMonthName,
                    obj.MonthYearNum,
                    obj.MonthYear,
                    obj.MonthYearLong,
                    obj.MonthNumeric,
                    obj.WeekYearString,
                    obj.WeekYearNumeric,
                    obj.Week,
                    obj.Year,
                    obj.TimeStamp,
                    obj.DayName,
                    obj.DayOfMonth,
                    obj.DayOfYear,
                    obj.MonthYearNumDay
                    
                )
                        
            }
        write DiffInDays, " days successfully populated", !

    }

    if months{
        KILL ^data.DateClasses.MonthsD
        KILL ^data.DateClasses.MonthsI
            for i=0:1:DiffInMonths{
                set date = $SYSTEM.SQL.Functions.DATEADD("month", i, fromTs)
                set obj = ..Months(date, monthYearDelimeter)
                
                do ##class(data.DateClasses.Months).Insert(
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
        write DiffInMonths, " months successfully populated", !
        
    }

    if timeTable{
        KILL ^data.DateClasses.TimeTableD
        KILL ^data.DateClasses.TimeTableI
        set timeClass = ##class(data.DateClasses.TimeTable).%New()
    
        For hour=0:1:23 {
            For min=0:1:59 {
                For sec=0:1:59 {
                    Set obj = ..TimeTable(hour, min, sec)
                    do timeClass.Insert(obj.hours, obj.minutes, obj.seconds, obj.timestamp, obj.htimestamp, obj.ampmtimestamp)
                    
                }
            
            }
            
        }
        write "86400 seconds of time successfully populated"
        
    }
    
    
    return sc
}

ClassMethod Months(ts, delimeter) As %Library.DynamicObject
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

ClassMethod Days(ts, delimeter) As %Library.DynamicObject
{
    set obj = ##class(%Library.DynamicObject).%New()

    set ShortMonthName = $EXTRACT($PIECE($ZDATETIME($ZDATETIMEH(ts,3), 9), " ", 1), 1, 3) // ex: Jan.. Dec
    set LongMonthName = $PIECE($ZDATETIME($ZDATETIMEH(ts,3), 9), " ", 1) // ex: January.. December
    set Year = $PIECE($ZDATETIME($ZDATETIMEH(ts,3), 9), " ", 3) // ex: 1970.. 2030

    set MonthNumeric = $PIECE($PIECE($ZDATETIME($ZDATETIMEH(ts,3), 3), " ", 1), "-", 2) 
    set YearNumeric = $PIECE($PIECE($ZDATETIME($ZDATETIMEH(ts,3), 3), " ", 1), "-", 1)

    set MonthYearNumeric = YearNumeric_MonthNumeric // 197001, 197002.. 203001

    set MonthYearString = ShortMonthName_delimeter_Year // Jan-1970
    set MonthYearLongString = LongMonthName_delimeter_Year // January-1970

    set Week = $SYSTEM.SQL.Functions.WEEK($ZDATETIME($ZDATETIMEH(ts,3), 3))
    set WeekYearString = Year_"-"_"W"_Week // 1970-W01
    set WeekYearNumeric = Year_Week // 197001

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
    set obj.MonthYearNumDay = MonthYearNumeric_$PIECE($PIECE($ZDATETIME($ZDATETIMEH(ts,3), 3), " ", 1), "-", 3)

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

}
