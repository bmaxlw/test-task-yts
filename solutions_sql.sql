-- 1. Кількість листів на отримувача

SELECT s.user_id,
       COUNT(s.id) sends_by_user
FROM sends s
GROUP BY s.user_id
ORDER BY sends_by_user DESC;

-- 2. СTR кожного типу листів

SELECT s.type_id send_type,
       (COUNT(c.id) / COUNT(s.id)) * 100 CTR
FROM sends s
    LEFT JOIN clicks c
        ON s.id = c.mail_id
GROUP BY s.type_id
ORDER BY CTR DESC; 

-- 3. Проаналізувати дані по користувачам і листам, зробити висновки, дати рекомендації.
SET @users = (SELECT 
					COUNT(DISTINCT users.user_id) 
			  FROM users);
              
SET @sends = (SELECT 
					COUNT(id)  
			  FROM sends);

-- m = 65.01% / f = 34.98%
SELECT gender, 
	   COUNT(DISTINCT user_id) users, 
       COUNT(DISTINCT user_id) / @users gender_ratio 
FROM users 
GROUP BY gender;

-- TOP-5 countries: 192, 165, 234, 0, 231 = 20.42%, 20.40%, 19.51%, 15.73%, 5.15%
SELECT country_id, 
	   COUNT(DISTINCT user_id) users, 
       COUNT(DISTINCT user_id) / @users country_ratio 
FROM users 
GROUP BY country_id 
ORDER BY country_ratio DESC 
	LIMIT 6;

-- 10, 11 = 53.6%, 46.4%
SELECT CASE WHEN MONTH(registered_at) = 10 THEN "October" 
			WHEN MONTH(registered_at) = 11 THEN "November"
            ELSE "Undefined" END AS MM, 
	   COUNT(DISTINCT user_id) users,
       COUNT(DISTINCT user_id) / @users registered_at_month_ratio
FROM users 
GROUP BY MM;

-- TOP-3 days by registered_at: Sunday, Saturday, Tuesday = 15.61%, 15.39%, 14.88% 
SELECT DAYNAME(registered_at) DD,
	   COUNT(DISTINCT user_id) users_registered_at_day,
       (COUNT(DISTINCT user_id) / @users) * 100 users_registered_at_day_ratio
FROM users
GROUP BY DD
ORDER BY users_registered_at_day DESC; 
		 -- ,
         -- users_registered_at_day 
         DESC;

-- TOP-3 vendors: 1, 0, 4 = 58.58%, 15.94%, 11.62%
SELECT vendor_id, 
       COUNT(DISTINCT user_id) users,
       COUNT(DISTINCT user_id) / @users users_by_vendor_ratio
FROM users
WHERE gender = "f"
GROUP BY vendor_id
ORDER BY users DESC;

SET @october_users = (SELECT 
							COUNT(DISTINCT user_id) 
					  FROM users WHERE MONTH(registered_at) = 10);
                      
SET @november_users = (SELECT 
							COUNT(DISTINCT user_id) 
					  FROM users WHERE MONTH(registered_at) = 11);

SELECT trigger_group, 
	   COUNT(id) cnt, 
       COUNT(id) / (SELECT COUNT(id) FROM sends) ratio 
FROM sends
GROUP BY trigger_group
ORDER BY cnt DESC;

SELECT type_id, 
	   COUNT(id) cnt, 
       COUNT(id) / (SELECT COUNT(id) FROM sends) ratio 
FROM sends
GROUP BY type_id
ORDER BY cnt DESC;

SELECT trigger_id, 
	   COUNT(id) cnt, 
       COUNT(id) / (SELECT COUNT(id) FROM sends) ratio 
FROM sends
GROUP BY trigger_id
ORDER BY cnt DESC;

SELECT DAYNAME(created_at) sday, 
	   COUNT(id) cnt, 
       (COUNT(id) / (SELECT COUNT(id) FROM sends)) * 100 ratio
FROM sends
GROUP BY sday
ORDER BY cnt DESC;

SELECT DAYNAME(created_at) cday, 
	   COUNT(id) cnt, 
       (COUNT(id) / (SELECT COUNT(id) FROM clicks)) * 100 ratio
FROM clicks
GROUP BY cday
ORDER BY cnt DESC;

SELECT mail_id, 
	   COUNT(id) cnt, 
       (COUNT(id) / (SELECT COUNT(id) FROM clicks)) * 100 ratio
FROM clicks
GROUP BY mail_id
ORDER BY cnt DESC;

-- 10=2981 / 11=723
SELECT 
	 count(DISTINCT clicks.user_id) 
FROM clicks 
INNER JOIN users 
ON clicks.user_id = users.user_id
WHERE 
	 MONTH(clicks.created_at) = 11
     AND 
     MONTH(users.registered_at) = 10;

-- 10=0 / 11=2588
SELECT 
	 count(DISTINCT clicks.user_id) 
FROM clicks 
INNER JOIN users 
ON clicks.user_id = users.user_id
WHERE 
	 MONTH(clicks.created_at) = 11
     AND 
     MONTH(users.registered_at) = 11;
