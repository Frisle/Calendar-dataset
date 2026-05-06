## Calendar-dataset

This is simple calendar dataset for analytics purposes.

The dataset consist of three persistent data classes:

- **Days.cls**
- **Month.cls**
- **TimeTable.cls**

And generator method that populates this classes

## Days set consists of various date formats:
- ShortMonthName: _Jan_
- LongMonthName: _January_
- MonthYearNum: _197001_
- MonthYear: _Jan-1970_
- MonthYearLong: _January-1970_
- WeekYearString: _1970-W1_
- WeekYearNumeric: _1970-01_ 
- Week: _01_ 
- Years: _1970_ 
- DayOfMonth: _1_ 
- DayOfYear: _1_
- DayName: _Thursday_ 
- MonthNumeric: _1_ 
- FullDate: _1970-01-01 00:00:00_ 
- MonthYearNumDay: _19700101_

## Month set consist of similar to days set dimensions except:
- Quarter: _1_
- QuarterYear: _Q1 1970_

## Time set consist of:
- FullTime: _00:00:00_
- Hours: _0-24_
- Munites: _0-59_
- Seconds: _0-53_
- HTimeStamp ($HOROLOG): _0-86399_
- AmPmTimeStamp: _00:00:00AM/PM_

How to use it: 

You can build it as standalone app with docker compose
```
docker compose build --no-cache --progress=plain
docker compose up -d
```

Or (intendent method) install it with your package with IPM:
```
zpm "install calendar-dataset"
```

After installation run:
```
do ##class(data.generator).Generate()
```

And thats it! Three tables with date dimensions is ready to go!

(For additional parameters, such as a custom date range or preferred data sets, see the ClassMethod documentation.)
