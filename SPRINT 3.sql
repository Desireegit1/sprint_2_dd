--EJERCICO 2
-- =========================================================
-- 1. TRANSACTIONS_RAW
-- Delimitador especial: punto y coma
-- =========================================================

CREATE OR REPLACE EXTERNAL TABLE
  `sprint3-analytics-desiree-diaz.sprint3_bronze.transactions_raw`
(
  id STRING,
  card_id STRING,
  business_id STRING,
  timestamp STRING,
  amount STRING,
  declined STRING,
  product_ids STRING,
  user_id STRING,
  lat STRING,
  longitude STRING,
  discount_amount STRING,
  tax_amount STRING,
  shipping_amount STRING,
  channel STRING,
  campaign_id STRING,
  device_type STRING,
  is_international STRING,
  decline_reason STRING,
  distance_km STRING
)
OPTIONS (
  format = 'CSV',
  uris = [
    'gs://bootcamp-data-analytics-public/ERP/transactions.csv'
  ],
  skip_leading_rows = 1,
  field_delimiter = ';',
  quote = '"'
);


-- =========================================================
-- 2. COMPANIES_RAW
-- Esquema manual y todas las columnas como texto
-- =========================================================

CREATE OR REPLACE EXTERNAL TABLE
  `sprint3-analytics-desiree-diaz.sprint3_bronze.companies_raw`
(
  employbl_company_id STRING,
  company_name STRING,
  website STRING,
  address_1 STRING,
  city STRING,
  state STRING,
  zip STRING,
  latitude STRING,
  longitude STRING,
  company_description STRING,
  thumbnail_url STRING
)
OPTIONS (
  format = 'CSV',
  uris = [
    'gs://bootcamp-data-analytics-public/ERP/companies.csv'
  ],
  skip_leading_rows = 1,
  field_delimiter = ',',
  quote = '"'
);


-- =========================================================
-- 3. AMERICAN_USERS_RAW
-- =========================================================

CREATE OR REPLACE EXTERNAL TABLE
  `sprint3-analytics-desiree-diaz.sprint3_bronze.american_users_raw`
(
  id STRING,
  name STRING,
  surname STRING,
  phone STRING,
  email STRING,
  birth_date STRING,
  country STRING,
  city STRING,
  postal_code STRING,
  address STRING
)
OPTIONS (
  format = 'CSV',
  uris = [
    'gs://bootcamp-data-analytics-public/CRM/american_users.csv'
  ],
  skip_leading_rows = 1,
  field_delimiter = ',',
  quote = '"'
);


-- =========================================================
-- 4. EUROPEAN_USERS_RAW
-- =========================================================

CREATE OR REPLACE EXTERNAL TABLE
  `sprint3-analytics-desiree-diaz.sprint3_bronze.european_users_raw`
(
  id STRING,
  name STRING,
  surname STRING,
  phone STRING,
  email STRING,
  birth_date STRING,
  country STRING,
  city STRING,
  postal_code STRING,
  address STRING
)
OPTIONS (
  format = 'CSV',
  uris = [
    'gs://bootcamp-data-analytics-public/CRM/european_users.csv'
  ],
  skip_leading_rows = 1,
  field_delimiter = ',',
  quote = '"'
);


-- =========================================================
-- 5. CREDIT_CARDS_RAW
-- =========================================================

CREATE OR REPLACE EXTERNAL TABLE
  `sprint3-analytics-desiree-diaz.sprint3_bronze.credit_cards_raw`
(
  id STRING,
  user_id STRING,
  iban STRING,
  pan STRING,
  pin STRING,
  cvv STRING,
  track1 STRING,
  track2 STRING,
  expiring_date STRING
)
OPTIONS (
  format = 'CSV',
  uris = [
    'gs://bootcamp-data-analytics-public/CRM/credit_cards.csv'
  ],
  skip_leading_rows = 1,
  field_delimiter = ',',
  quote = '"'
);

CREATE OR REPLACE EXTERNAL TABLE
  `sprint3-analytics-desiree-diaz.sprint3_bronze.companies_raw`
(
  company_id STRING,
  company_name STRING,
  phone STRING,
  email STRING,
  country STRING,
  website STRING
)
OPTIONS (
  format = 'CSV',
  uris = ['gs://bootcamp-data-analytics-public/ERP/companies.csv'],
  skip_leading_rows = 1,
  field_delimiter = ',',
  quote = '"'
);

SELECT *
FROM `sprint3-analytics-desiree-diaz.sprint3_bronze.companies_raw`
LIMIT 10;

---------------------------------------------
--EJERCICO 4
CREATE OR REPLACE TABLE
  `sprint3-analytics-desiree-diaz.sprint3_bronze.transactions_raw_native`
AS
SELECT *
FROM
  `sprint3-analytics-desiree-diaz.sprint3_bronze.transactions_raw`;

  CREATE OR REPLACE EXTERNAL TABLE
  `sprint3-analytics-desiree-diaz.sprint3_bronze.transactions_raw`
(
  id STRING,
  card_id STRING,
  business_id STRING,
  timestamp STRING,
  amount STRING,
  declined STRING,
  product_ids STRING,
  user_id STRING,
  lat STRING,
  longitude STRING
)
OPTIONS (
  format = 'CSV',
  uris = ['gs://bootcamp-data-analytics-public/ERP/transactions.csv'],
  skip_leading_rows = 1,
  field_delimiter = ';',
  quote = '"'
);

SELECT *
FROM `sprint3-analytics-desiree-diaz.sprint3_bronze.transactions_raw`
LIMIT 10;

--------
SELECT id
FROM `sprint3-analytics-desiree-diaz.sprint3_bronze.transactions_raw`;


SELECT id
FROM `sprint3-analytics-desiree-diaz.sprint3_bronze.transactions_raw_native`;

SELECT *
FROM `sprint3-analytics-desiree-diaz.sprint3_bronze.transactions_raw_native`
LIMIT 10;

SELECT *
FROM `sprint3-analytics-desiree-diaz.sprint3_bronze.transactions_raw`;

SELECT *
FROM `sprint3-analytics-desiree-diaz.sprint3_bronze.transactions_raw`
LIMIT 10;
-----------------------------------------------

---EJERCICO 5

-- compruebo formato real del timesamp
SELECT
  `timestamp`,
  amount,
  declined
FROM
  `sprint3-analytics-desiree-diaz.sprint3_bronze.transactions_raw_native`
LIMIT 10;


--convertir STRING en timestamp y amount
WITH transactions_clean AS (
  SELECT
    DATE(CAST(`timestamp` AS TIMESTAMP)) AS transaction_date,
    SAFE_CAST(amount AS NUMERIC) AS amount_numeric,
    declined
  FROM
    `sprint3-analytics-desiree-diaz.sprint3_bronze.transactions_raw_native`
)

SELECT
  transaction_date,
  ROUND(SUM(amount_numeric), 2) AS total_income
FROM
  transactions_clean
WHERE
  EXTRACT(YEAR FROM transaction_date) = 2021
  AND declined = '0'
GROUP BY
  transaction_date
ORDER BY
  total_income DESC
LIMIT 5;


----------------------------------
---EJERCICO 6

--Llista el nom, país i data de les transaccions realitzades per empreses que van fer operacions entre 100 i 200 euros en alguna d'aquestes --dates: 29-04-2015, 20-07-2018 o 13-03-2024.

SELECT
  c.company_name AS nombre_empresa,
  c.country AS pais,
  DATE(CAST(t.timestamp AS TIMESTAMP)) AS fecha_transaccion
FROM
  `sprint3-analytics-desiree-diaz.sprint3_bronze.transactions_raw_native` AS t
INNER JOIN
  `sprint3-analytics-desiree-diaz.sprint3_bronze.companies_raw` AS c
  ON t.business_id = c.company_id
WHERE
  SAFE_CAST(t.amount AS NUMERIC) BETWEEN 100 AND 200
  AND DATE(CAST(t.timestamp AS TIMESTAMP)) IN (
    DATE '2015-04-29',
    DATE '2018-07-20',
    DATE '2024-03-13'
  )
ORDER BY
  fecha_transaccion,
  nombre_empresa;


---------------------------------------------

---EJERCICO 1 nivel 2

--comprobamos tipo de coluna que es cada uno
SELECT
  column_name,
  data_type
FROM
  `sprint3-analytics-desiree-diaz.sprint3_bronze.INFORMATION_SCHEMA.COLUMNS`
WHERE
  table_name = 'products_raw'
ORDER BY
  ordinal_position;


--crear una taula de productes neta a sprint3_silver.products_clean

CREATE OR REPLACE TABLE
  `sprint3-analytics-desiree-diaz.sprint3_silver.products_clean`
AS
SELECT
  id AS product_id,
  product_name AS name,

  SAFE_CAST(
    REPLACE(warehouse_id, 'WH-', '')
    AS INT64
  ) AS warehouse_id,

  CAST(price AS FLOAT64) AS price,

  weight
FROM
  `sprint3-analytics-desiree-diaz.sprint3_bronze.products_raw`;

  ---validamos datos
  
SELECT *
FROM `sprint3-analytics-desiree-diaz.sprint3_silver.products_clean`
LIMIT 20;

---------------------------------
--EJERCICO 2 nivel 2

--creamos nueva tabla 

CREATE OR REPLACE TABLE
  `sprint3-analytics-desiree-diaz.sprint3_silver.transactions_clean`
AS
SELECT
  id AS transaction_id,

  card_id,
  business_id,

  SAFE_CAST(`timestamp` AS TIMESTAMP) AS transaction_timestamp,

  IFNULL(
    SAFE_CAST(amount AS FLOAT64),
    0
  ) AS amount,

  declined,

  ARRAY(
    SELECT SAFE_CAST(TRIM(product_id) AS INT64)
    FROM UNNEST(SPLIT(product_ids, ',')) AS product_id
    WHERE SAFE_CAST(TRIM(product_id) AS INT64) IS NOT NULL
  ) AS product_ids,

  user_id,

  SAFE_CAST(lat AS FLOAT64) AS lat,
  SAFE_CAST(longitude AS FLOAT64) AS longitude

FROM
  `sprint3-analytics-desiree-diaz.sprint3_bronze.transactions_raw_native`;


  -----comprobamos:

SELECT *
FROM
  `sprint3-analytics-desiree-diaz.sprint3_silver.transactions_clean`
LIMIT 20;



----------------------------

--EJERCICO 3_NIVEL 2

--comprobar si son tablas nativas
SELECT
  table_name,
  table_type
FROM
  `sprint3-analytics-desiree-diaz.sprint3_silver.INFORMATION_SCHEMA.TABLES`
WHERE
  table_name IN ('companies_clean', 'credit_cards_clean');


--Crear companies_clean

--Como el identificador ya se llama company_id, puede conservarse:

CREATE OR REPLACE TABLE
  `sprint3-analytics-desiree-diaz.sprint3_silver.companies_clean`
AS
SELECT
  company_id,
  company_name,
  phone,
  email,
  country,
  website
FROM
  `sprint3-analytics-desiree-diaz.sprint3_bronze.companies_raw`;

  ---2. Crear credit_cards_clean

--En este caso conviene renombrar el id ambiguo como card_id:

CREATE OR REPLACE TABLE
  `sprint3-analytics-desiree-diaz.sprint3_silver.credit_cards_clean`
AS
SELECT
  id AS card_id,
  user_id,
  iban,
  pan,
  pin,
  cvv,
  track1,
  track2,
  expiring_date
FROM
  `sprint3-analytics-desiree-diaz.sprint3_bronze.credit_cards_raw`;


-------------------------------------
--EJERCICO 1 NIVEL  3

--crear vista- unieond tablas companies y transactions mediant id
--agrupamos por empresas , calciulamos el AVG(amount) y aplicamos un case

CREATE OR REPLACE VIEW
  `sprint3-analytics-desiree-diaz.sprint3_gold.v_marketing_kpis`
AS
SELECT
  c.company_name,
  c.phone,
  c.country,
  ROUND(AVG(t.amount), 2) AS average_purchase,
  CASE
    WHEN AVG(t.amount) > 260 THEN 'Premium'
    ELSE 'Standard'
  END AS client_tier
FROM
  `sprint3-analytics-desiree-diaz.sprint3_silver.companies_clean` AS c
INNER JOIN
  `sprint3-analytics-desiree-diaz.sprint3_silver.transactions_clean` AS t
  ON c.company_id = t.business_id
GROUP BY
  c.company_id,
  c.company_name,
  c.phone,
  c.country;

---Consultamos vista


  SELECT *
FROM
  `sprint3-analytics-desiree-diaz.sprint3_gold.v_marketing_kpis`
ORDER BY
  CASE
    WHEN client_tier = 'Premium' THEN 1
    ELSE 2
  END,
  average_purchase DESC;


----------------------

---EJERCICO 2 NIVEL 3


- comprobamos que products_clean contiene realmente la columna color: ( y no la tiene)

SELECT
  column_name,
  data_type
FROM
  `sprint3-analytics-desiree-diaz.sprint3_silver.INFORMATION_SCHEMA.COLUMNS`
WHERE
  table_name = 'products_clean'
ORDER BY
  ordinal_position;

---creamos de nuevo la tabla porducts.clean con la columna color

CREATE OR REPLACE TABLE
  `sprint3-analytics-desiree-diaz.sprint3_silver.products_clean`
AS
SELECT
  id AS product_id,
  product_name AS name,

  SAFE_CAST(
    REPLACE(warehouse_id, 'WH-', '')
    AS INT64
  ) AS warehouse_id,

  price,
  colour AS color,
  `weight`
FROM
  `sprint3-analytics-desiree-diaz.sprint3_bronze.products_raw`;

  --comprobamos columnas
 SELECT
  column_name,
  data_type
FROM
  `sprint3-analytics-desiree-diaz.sprint3_silver.INFORMATION_SCHEMA.COLUMNS`
WHERE
  table_name = 'products_clean'
ORDER BY
  ordinal_position;

  --creamos tabla gold

  CREATE OR REPLACE TABLE
  `sprint3-analytics-desiree-diaz.sprint3_gold.product_sales_ranking`
AS

WITH products_sold AS (
  SELECT
    product_id
  FROM
    `sprint3-analytics-desiree-diaz.sprint3_silver.transactions_clean`,
    UNNEST(product_ids) AS product_id ---aplandao la tabla
)

SELECT
  p.product_id,
  p.name,
  p.price,
  p.color,
  COUNT(ps.product_id) AS total_sold
FROM
  `sprint3-analytics-desiree-diaz.sprint3_silver.products_clean` AS p
LEFT JOIN    -------per no perdre aquells que no s'han venut mai.
  products_sold AS ps
  ON p.product_id = ps.product_id
GROUP BY
  p.product_id,
  p.name,
  p.price,
  p.color
ORDER BY
  total_sold DESC,
  p.product_id;


---------------------

---EJERCICO 3 Y  4 NIVLE 3 

--Crea la taula sprint3_silver.users_combined. 
--Utilitza UNION ALL per unificar els usuaris dels EUA i Europa en una única llista mestra. 
--Afegeix una columna calculada origin per saber d'on venen.

CREATE OR REPLACE TABLE
  `sprint3-analytics-desiree-diaz.sprint3_silver.users_combined`
AS

SELECT
  id AS user_id,
  name,
  surname,
  phone,
  email,
  birth_date,
  country,
  city,
  postal_code,
  address,
  'USA' AS origin
FROM
  `sprint3-analytics-desiree-diaz.sprint3_bronze.american_users_raw`

  UNION ALL

SELECT
  id AS user_id,
  name,
  surname,
  phone,
  email,
  birth_date,
  country,
  city,
  postal_code,
  address,
  'EUROPE' AS origin
FROM
  `sprint3-analytics-desiree-diaz.sprint3_bronze.european_users_raw`;


  ----contamos usuarios por origen
  SELECT
  origin,
  COUNT(*) AS total_users
FROM
  `sprint3-analytics-desiree-diaz.sprint3_silver.users_combined`
GROUP BY
  origin;


  ----- 
  --EJER 4

  SELECT
  product_id,
  name,
  price,
  color,
  total_sold
FROM
  `sprint3-analytics-desiree-diaz.sprint3_gold.product_sales_ranking`
ORDER BY
  total_sold DESC,
  product_id;




