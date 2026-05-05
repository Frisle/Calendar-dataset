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

ClassMethod Generate(fromTs = "1970-01-01 00:00:00", toTs, days = 1, months = 1, timeTable = 1) As %Status
{
    set sc = $$$OK

    if '..IsValidDateTime(fromTs) || '..IsValidDateTime(toTs){
        write "Wrong datetime format!", !
        write "Required format: YYYY-MM-DD HH:MM:SS or YYYY-MM-DD"
        return sc
    }

    if $ZDATETIMEH(fromTs, 3) > $ZDATETIMEH(toTs, 3){
        write "First argument should be smaller that the second!", !
        write "Now, the first arg: ", fromTs, " and the second ", toTs
        return sc
    }

    
    write "Generating date time dataset from: ", fromTs," to ", $SELECT(toTs:toTs, 'toTs:$SYSTEM.SQL.Functions.DATEADD("year", 10, $ZDATETIMEH($ZDATETIME($NOW(), 3), 3))), !
    write "Configuration: ",!, 
        " Days table: ",$SELECT(days:"Yes;", 'days:"No;"),!,
        " Months table: ",$SELECT(months:"Yes;",'months:"No;"),!, 
        " Time table: ",$SELECT(timeTable:"Yes;",'timeTable:"No;"), !,!
    write $SELECT(days:"Population starts!", months:"Population starts!", timeTable:"Population starts!", 1:"Nothing to populate"), !

    set sc = $$$OK
    set StartTs = $ZDATETIME($ZDATETIMEH(fromTs, 3), 3)

    if 'toTs{
        set EndTs = $SYSTEM.SQL.Functions.DATEADD("year", 10, $ZDATETIMEH($ZDATETIME($NOW(), 3), 3))
    } 
    else{
        set EndTs = toTs
    }
    

    set DiffInMonths = $SYSTEM.SQL.Functions.DATEDIFF("month", StartTs, EndTs)
    set DiffInDays = $SYSTEM.SQL.Functions.DATEDIFF("day", StartTs, EndTs)

    if days{
        KILL ^data.DateClasess.DaysD
        for i=1:1:DiffInDays{
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
        write DiffInDays, " days successfully populated", !
    }

    if months{
        KILL ^data.DateClasess.MonthsD
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
        write DiffInMonths, " months successfully populated", !
    }

    if timeTable{
        KILL ^data.DateClasess.TimeTableD
        set timeClass = ##class(data.DateClasess.TimeTable).%New()
    
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
    
    
    
    
    return sc
}

}
