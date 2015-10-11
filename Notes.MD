I've learned this nice trick here. This other answer also says you can skip the options setting and use, for example, strptime(y, "%d.%m.%Y %H:%M:%OS3"), but it doesn't work for me. Henrik noted that the function's help page, ?strptime states that the %OS3 bit is OS-dependent. I'm using an updated Ubuntu 13.04 and using %OS3 yields NA.

When using strptime (or other POSIX-related functions such as as.Date), keep in mind some of the most common conversions used (edited for brevity, as suggested by DWin. Complete list at strptime):

%a Abbreviated weekday name in the current locale.
%A Full weekday name in the current locale.
%b Abbreviated month name in the current locale.
%B Full month name in the current locale.
%d Day of the month as decimal number (01-31).
%H Hours as decimal number (00-23). Times such as 24:00:00 are accepted for input.
%I Hours as decimal number (01-12).
%j Day of year as decimal number (001-366).
%m Month as decimal number (01-12).
%M Minute as decimal number (00-59).
%p AM/PM indicator in the locale. Used in conjunction with %I and not with %H.
`%S Second as decimal number (00-61), allowing for up to two leap-seconds (but POSIX-compliant implementations will ignore leap seconds).
%U Week of the year as decimal number (00-53) using Sunday as the first day 1 of the week (and typically with the first Sunday of the year as day 1 of week 1). The US convention.
%w Weekday as decimal number (0-6, Sunday is 0).
%W Week of the year as decimal number (00-53) using Monday as the first day of week (and typically with the first Monday of the year as day 1 of week 1). The UK convention.
%y Year without century (00-99). On input, values 00 to 68 are prefixed by 20 and 69 to 99 by 19
%Y Year with century. Note that whereas there was no zero in the original Gregorian calendar, ISO 8601:2004 defines it to be valid (interpreted as 1BC)

More Date Functions: (from my practice on Swirl?)
library(lubridate)
help(package="lubridate")
help(package=lubridate)
today()
this_day <- today()
this_day
year(this_day)
wday(this_day)
wday(this_day,label=TRUE)
this_moment <- now()
this_moment
minute(this_moment)
my_date <- ymd("1989-05-17")
my_date
class(my_date)
ymd("1989 May 17")
mdy("March 12, 1975")
dmy(25081985)
ymd(192012)
ymd("192012")
ymd("1920112")
ymd("1920/1/2")
install.packages("lubridate")
wday(today(),label=TRUE)  ## This returns TEXT day of the week abbr=TRUE

