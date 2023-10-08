-- MS SQL
DECLARE @Today DATE = GETDATE(), @Nth TINYINT = 3, @Day TINYINT = 6;
SELECT
   @Today AS Today,
   DATEPART(dw, @Today) AS Today_DoW_num,
   DATENAME(dw, @Today) AS Today_DoW,
   DATEADD(dd, @Nth*7 - (7 + DATEPART(dw, @Today) - @Day) % 7, @Today) AS Nth_DoW_Date,
   DATENAME( dw, DATEADD(dd, @Nth*7 - (7 + DATEPART(dw, @Today) - @Day) % 7, @Today) ) AS Nth_DoW;

-- 1 - 7 -> Monday - Sunday, DATEPART(dw, any_sunday_date) -> 1
SELECT @@LANGUAGE AS [Language], @@DATEFIRST AS [DateFirst]; 

-- It sets the first day of the week ( Default -> SET DATEFIRST 7; -> Sunday-Saturday as 1-7)
SET DATEFIRST 7;

-- Snowflake
SET (Nth, Day) = (3, 'friday');
SELECT
  CURRENT_DATE() AS today,
  DAYNAME(today) AS today_dow,
  DATEADD(day, ($Nth - 1) * 7, NEXT_DAY(today, $Day)) AS Nth_dow_date,
  DAYNAME(Nth_dow_date) AS Nth_dow;