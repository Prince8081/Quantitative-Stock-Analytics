create database Stocks_Analysis;
use stocks_Analysis;

select * from cleaned_market_data;

-- Top 5 Momentum Stocks --

create view  Momentum_Stocks as
SELECT 
    Date, symbol, close_price, 50_DMA, RSI
FROM
    cleaned_market_data
WHERE
    date = (SELECT 
            MAX(date)
        FROM
            cleaned_market_data)
        AND close_price > 50_DMA
        AND RSI > 60
ORDER BY RSI DESC
LIMIT 5;

-- Top 5 Volume Spike Stoks --

create view Volume_spike_Stoks as 
SELECT 
    Date, symbol, close_price, volume
FROM
    cleaned_market_data
WHERE
    date = (SELECT 
            MAX(date)
        FROM
            cleaned_market_data)
ORDER BY volume DESC
LIMIT 5;


-- RSI Oversold stocks -- 

create view RSI_Oversold_stocks as 
SELECT 
    Date, symbol, close_price, RSI
FROM
    cleaned_market_data
WHERE
    RSI < 35
        AND date = (SELECT 
            MAX(date)
        FROM
            cleaned_market_data)
ORDER BY RSI ASC;

-- Price Performance --

create view Price_Performance as
SELECT 
    symbol,
    ROUND(((close_price - 50_DMA) / 50_DMA) * 100,
            2) AS Percent_Above_Avg
FROM
    cleaned_market_data
WHERE
    Date = (SELECT 
            MAX(Date)
        FROM
            cleaned_market_data)
ORDER BY Percent_Above_Avg DESC;

-- Consolidation Phase --

create view Consolidation_Phase as
SELECT 
    symbol, close_price, 50_DMA
FROM
    cleaned_market_data
WHERE
    Date = (SELECT 
            MAX(Date)
        FROM
            cleaned_market_data)
        AND close_price BETWEEN (50_DMA * 0.99) AND (50_DMA * 1.01);
        

-- Overbought stocks --

create view Overbought_stocks as
SELECT 
    symbol, close_price, RSI
FROM
    cleaned_market_data
WHERE
    RSI > 80
        AND Date = (SELECT 
            MAX(Date)
        FROM
            cleaned_market_data);
            
-- Top Gainers -- 

create view Top_Gainers as 
SELECT * FROM (
    SELECT symbol, Date, close_price,
           RANK() OVER(PARTITION BY symbol ORDER BY close_price DESC) as Price_Rank
FROM cleaned_market_data
) t WHERE date = (SELECT 
            MAX(Date)
        FROM
            cleaned_market_data)  
order by Price_Rank desc;


-- Historical Trend -- 

create view Historical_Trend as 
SELECT Date, symbol, close_price,
       LAG(close_price) OVER(PARTITION BY symbol ORDER BY Date) as Prev_Price
FROM cleaned_market_data
WHERE symbol = 'RELIANCE.NS';


