CREATE TABLE marketing_campaign (
	Campaign_ID VARCHAR (255),
	Company VARCHAR (255),
	Campaign_Type VARCHAR (255),
	Target_Audience VARCHAR (255),
	Duration VARCHAR (255),
	Channel_Used VARCHAR (255),
	Conversion_Rate DECIMAL (5, 2),
	Acquisition_Cost VARCHAR (255),
	ROI DECIMAL (5, 2),
	Location VARCHAR (255),
	Date VARCHAR (255),
	Clicks INT,
	Impressions INT,
	Engagement_Score INT,
	Customer_Segment VARCHAR (255)
);

ALTER TABLE marketing_campaign 
ALTER COLUMN Date TYPE DATE 
USING TO_DATE(Date, 'DD/MM/YYYY');

ALTER TABLE marketing_campaign 
ALTER COLUMN Acquisition_Cost TYPE DECIMAL(10,2) 
USING REPLACE(Acquisition_Cost, '$', '')::DECIMAL(10,2);

-- Threw back this error message
--ERROR:  invalid input syntax for type numeric: "16,174.00 " 

ALTER TABLE marketing_campaign 
ALTER COLUMN acquisition_cost TYPE DECIMAL(10,2) 
USING REPLACE(REPLACE(acquisition_cost, '$', ''), ',', '')::DECIMAL(10,2);

-- Calculate Total Impressions for Each Campaign
-- Expected Output: A table with campaign_id and total impressions

SELECT 
    campaign_id,
    SUM(impressions) AS total_impressions
FROM 
	marketing_campaign
GROUP BY 
	campaign_id
-- I needed to cast the campaign_id as integer so as to be able to order it in numerical order
ORDER BY 
CAST
	(campaign_id AS INT);

-- Identify the Campaign with the Highest ROI
-- Expected Output: A single row with campaign_id, company, and roi

SELECT 
    campaign_id, 
    company, 
    roi
FROM marketing_campaign
ORDER BY roi DESC
LIMIT 1;

-- Find the Top 3 Locations with the Most Impressions
-- Expected Output: A table with location and total impressions

SELECT
	location,
	SUM (impressions) AS total_impressionS
FROM
	marketing_campaign
GROUP BY
	location
ORDER BY
	total_impressions DESC
LIMIT 3;

-- Calculate Average Engagement Score by Target Audience
-- Expected Output: A table with target_audience and avgengagementscore

SELECT
	target_audience,
	AVG (engagement_score) AS average_enagagement_score
FROM
	marketing_campaign
GROUP BY 
	target_audience 
	
-- Calculate the Overall CTR (Click-Through Rate)
-- Expected Output: A single value for the overall CTR

SELECT 
	SUM(clicks) * 100.0 / SUM(impressions) AS overall_CTR
FROM marketing_campaign;

-- Find the Most Cost-Effective Campaign
-- Expected Output: A table with campaign_id, company, and costperconversion

SELECT 
    campaign_id, 
    company, 
    acquisition_cost/(conversion_rate * impressions) AS cost_per_conversion
FROM 
	marketing_campaign
ORDER BY 
	cost_per_conversion ASC;

-- Find Campaigns with CTR Above a Threshold
-- Expected Output: A table with campaign_id, company, and ctr

SELECT 
	campaign_id,
	company,
	ctr
FROM 
	(
SELECT
	campaign_id,
	company,
	SUM(clicks) * 100.0 / SUM(impressions) AS ctr
FROM 
	marketing_campaign
GROUP BY
	campaign_id,
	company
	)
WHERE
	ctr > 50
ORDER BY 
	ctr
DESC;

-- Rank Channels by Total Conversions
-- Expected Output: A table with channel_used and total conversions

SELECT
	channel_used,
	SUM (conversion_rate * impressions) AS total_conversions,
	RANK () OVER (ORDER BY SUM (conversion_rate * impressions) DESC) AS rank
FROM
	marketing_campaign
GROUP BY
	channel_used
	



SELECT * FROM marketing_campaign





















