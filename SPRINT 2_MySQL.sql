USE transactions;

#EJERCICIO 1-----------------------------------------------------
  -- Creamos la base de datos
    CREATE DATABASE IF NOT EXISTS transactions;
    USE transactions;

    -- Creamos la tabla company
    CREATE TABLE IF NOT EXISTS company (
        id VARCHAR(15) PRIMARY KEY,
        company_name VARCHAR(255),
        phone VARCHAR(15),
        email VARCHAR(100),
        country VARCHAR(100),
        website VARCHAR(255)
    );


    -- Creamos la tabla transaction
    CREATE TABLE IF NOT EXISTS transaction (
        id VARCHAR(255) PRIMARY KEY,
        credit_card_id VARCHAR(15) REFERENCES credit_card(id),
        company_id VARCHAR(20), 
        user_id INT REFERENCES user(id),
        lat FLOAT,
        longitude FLOAT,
        timestamp TIMESTAMP,
        amount DECIMAL(10, 2),
        declined BOOLEAN,
        FOREIGN KEY (company_id) REFERENCES company(id) 
    );
    
#EJERCICIO 2----------------------------------------------------------------

SELECT DISTINCT c.country
FROM company c
INNER JOIN transaction t
ON c.id = t.company_id
WHERE declined = 0
Order by  c.country ;


SELECT COUNT(DISTINCT c.country) AS paises_con_ventas
FROM company c
INNER JOIN transaction t
ON c.id = t.company_id
WHERE declined = 0;

SELECT 
	c.company_name,
    c.country,
	AVG(t.amount) AS media_amount
 FROM company c
INNER JOIN transaction t
 ON c.id = t.company_id
 GROUP BY c.id, c.company_name
  ORDER BY media_amount DESC	
 LIMIT 1;
 
 #EJERCICIO 3----------------------------------------------------------------

 SELECT t.company_id, t.amount
FROM transaction t
WHERE declined  = 0
AND EXISTS
	(SELECT id
	FROM company c
    WHERE c.id = t.company_id  
	AND c.country = 'GERMANY'
	);
    

SELECT *
FROM company  c
WHERE  EXISTS  
(
	SELECT t. company_id 
	FROM transaction t
	WHERE t.declined = 0
	AND t.amount > (
		SELECT AVG (amount) 
		FROM`transaction`
WHERE declined = 0)
    );
    

-- 1. Ver las empresas sin transacciones

USE transactions;    

SELECT *
FROM company c
WHERE NOT EXISTS (
    SELECT t.id
    FROM `transaction` t
    WHERE t.company_id = c.id
);

#EJERCICIO 4-------------------------------------

CREATE TABLE IF NOT EXISTS credit_card

(id VARCHAR (100),
 iban VARCHAR (100),
 pan VARCHAR (6),
 pin VARCHAR (6),
 cvv VARCHAR (4),
 expiring_date VARCHAR (8)
 );
 
 USE transactions;
 ALTER TABLE credit_card
 MODIFY pan  VARCHAR (50);
 
 DESCRIBE credit_card;
 
ALTER TABLE credit_card
ADD PRIMARY KEY (id);
 
DESCRIBE credit_card;
USE transactions;
  
ALTER TABLE `transaction`
ADD CONSTRAINT fk_credit_card
FOREIGN KEY (credit_card_id)
REFERENCES credit_card(id);

#EJERCICIO 5-------------------------------------
# encontrmos el regisro a eliminar
SELECT *
FROM credit_card
WHERE  id = "CcU-2938";

#cambiamos registro en iban

UPDATE credit_card
SET iban = 'TR323456312213576817699999'
WHERE id = "CcU-2938";

#Volvemos a buscar id para ver el cambio

SELECT *
FROM credit_card
WHERE  id = "CcU-2938";

#ejercicio 6-----------------------------------------------------# 1- Insertamos datos en  company
USE transactions;
INSERT INTO company
(id, company_name, phone, email, country, website)
VALUES
('b-9999',
 'Empresa Prueba S.L.',
 '+34 931234567',
 'info@empresaprueba.com',
 'SPAIN',
 'www.empresaprueba.com');
 
 SELECT *
FROM company;

# 2- Insertar datos en credit card

SELECT *
 FROM credit_card
 WHERE id = 'CcU-9999';
 

INSERT INTO credit_card
(id, iban, pan, pin, cvv, expiring_date)
VALUES
('CcU-9999',
 'ES1234567890123456789012',
 '4532123456789012',
 '1234',
 '456',
 '12/28');

#3- Insertar datos en trnasaction

INSERT INTO `transaction` (id, credit_card_id, company_id, user_id, lat, longitude, timestamp, amount, declined)
VALUES ('108B1D1D-5B23-A76C-55EF-C568E49A99DD','CcU-9999','b-9999','9999','829.999','-117.999', NOW(), '111.11','0');

Select *
FROM transaction
WHERE credit_card_id = 'CcU-9999';


#EJERCICO 7--------------------------------------

DESCRIBE credit_card;

ALTER TABLE credit_card
DROP COLUMN pan;

#EJERCICIO 8------------------------------------------
CREATE TABLE IF NOT EXISTS  american_users
(
id VARCHAR (15) PRIMARY KEY,
name VARCHAR (20),
surname VARCHAR (20),
phone VARCHAR (20),
email VARCHAR (50),
birth_date VARCHAR (50),
country VARCHAR (20),
city VARCHAR (20),
postal_code VARCHAR (20),
address VARCHAR (100),
signup_date VARCHAR (50),
user_segment VARCHAR (20),
income_band VARCHAR (20)
);

USE transactions;
CREATE TABLE IF NOT EXISTS companies
(
company_id VARCHAR (20) PRIMARY KEY,
company_name VARCHAR (20),
phone VARCHAR (20),
email VARCHAR (100),
country VARCHAR (20),
website VARCHAR (150),
merchant_category VARCHAR (20),
merchant_price_position VARCHAR (20)
);

USE transactions;
CREATE TABLE IF NOT EXISTS credit_cards
( 
id VARCHAR (20) PRIMARY KEY,
user_id VARCHAR (20),
iban VARCHAR (50),
pan VARCHAR (50) ,
pin VARCHAR (50) ,
cvv VARCHAR (50),
track1 VARCHAR (150),
track2 VARCHAR (150),
expiring_date VARCHAR (20) ,
card_type VARCHAR (20),
Card_renewal_flag VARCHAR (20)
);

USE transactions;
CREATE TABLE IF NOT EXISTS european_users
(
id VARCHAR (20) PRIMARY KEY,
name VARCHAR (20),
surname VARCHAR (20),
phone VARCHAR (20),
email VARCHAR (50),
birth_date VARCHAR (20),
country VARCHAR (20),
city VARCHAR (20),
postal_code VARCHAR (20),
address VARCHAR (50),
signup_date VARCHAR (20),
user_segment VARCHAR (50),
income_band VARCHAR (20)
);

USE transactions;
CREATE TABLE IF NOT EXISTS products
(
id VARCHAR (20) PRIMARY KEY,
product_name VARCHAR (50),
price VARCHAR (20),
colour VARCHAR (20),
weight VARCHAR (20),
warehouse_id VARCHAR (20),
category VARCHAR (20),
brand VARCHAR (20),
cost VARCHAR (20),
launch_date VARCHAR (20)
);

USE transactions;
CREATE TABLE IF NOT EXISTS transactions
(
id VARCHAR (50) PRIMARY KEY,
card_id VARCHAR (50),
business_id VARCHAR (50) ,
timestamp VARCHAR (20),
amount DECIMAL(10,2),
declined BOOLEAN,
product_ids VARCHAR (50) ,
user_id VARCHAR (50) ,
lat VARCHAR (50),
longitude VARCHAR (50),
discount_amount DECIMAL (10,2),
tax_amount DECIMAL  (10,2),
shipping_amount DECIMAL (10,2),
channel  VARCHAR (50),
campaign_id VARCHAR (50),
device_type VARCHAR (50) ,
is_international BOOLEAN,
decline_reason VARCHAR (50) ,
distance_km DECIMAL(10,2)

);


USE transactions;
CREATE TABLE users (
    id VARCHAR(20) PRIMARY KEY,
    name VARCHAR(20),
    surname VARCHAR(20),
    phone VARCHAR(20),
    email VARCHAR(50),
    birth_date VARCHAR(20),
    country VARCHAR(20),
    city VARCHAR(20),
    postal_code VARCHAR(20),
    address VARCHAR(100),
    signup_date VARCHAR(20),
    user_segment VARCHAR(50),
    income_band VARCHAR(20)
);
# Modificamos varchar
ALTER TABLE companies
  MODIFY COLUMN company_id VARCHAR(100);

ALTER TABLE users 
  MODIFY COLUMN id VARCHAR(100);
  
  ALTER TABLE companies 
  MODIFY COLUMN company_name VARCHAR(200);

----
ALTER TABLE transactions
ADD CONSTRAINT fk_credit_cards
FOREIGN KEY (card_id)
REFERENCES credit_cards(id);


ALTER TABLE transactions
ADD CONSTRAINT fk_companies
FOREIGN KEY (business_id)
REFERENCES companies(company_id);


ALTER TABLE transactions
ADD CONSTRAINT fk_transactions_users
FOREIGN KEY (user_id)
REFERENCES users(id);

#EJERCICIO  9 --------------------------------

SELECT *
FROM users u
WHERE EXISTS (
    SELECT user_id
    FROM transactions t
    WHERE t.user_id = u.id
    GROUP BY t.user_id
    HAVING COUNT(*) > 80
);

#EJERCICO 10---------------------------------------------
SELECT 
    cc.iban,
    ROUND(AVG(t.amount), 2) AS media_amount
FROM transactions t

JOIN credit_cards cc 
    ON t.card_id = cc.id
    
JOIN companies c 
    ON t.business_id = c.company_id
    
WHERE c.company_name = 'Donec Ltd'
GROUP BY cc.iban;

#NIVEL 2-----------------------------------------------------------------------------------------------------------------
#EJERCICIO 1-----------------------------------------------------
#Identifica els cinc dies que es va generar la quantitat més gran d'ingressos a l'empresa per vendes. 
#Mostra la data de cada transacció juntament amb el total de les vendes.
USE TRANSACTIONS;

SELECT
	DATE (TIMESTAMP) AS fecha,
	ROUND(SUM(t.amount),2) AS total_amount
FROM transactions t
WHERE declined = 0
GROUP BY date(timestamp)
ORDER BY  total_amount desc
Limit 5;

#Exercici 2----------------------------------------------------------------------------------------
#Presenta el nom, telèfon, país, data i amount, d'aquelles empreses que van realitzar (JOIN)
#transaccions amb un valor comprès entre 350 i 400 euros (AND t.amount  BETWEEN 350 AND 450)
#i en alguna d'aquestes dates: 29 d'abril del 2015, 20 de juliol del 2018 i 13 de març del 2024. WHERE  (2015-04-29, 2018-07-20, 2024-03-13)
#Ordena els resultats de major a menor quantitat. 

SELECT  
c.company_name, 
c.phone, 
c.country, 
DATE (t.timestamp) AS date, 
Round(t.amount,2) As amount
FROM transactions t
JOIN company  c 
ON  t.business_id = C.id
WHERE DATE(t.timestamp) IN ('2015-04-29', '2018-07-20','2024-03-13')
AND declined = 0
AND t.amount BETWEEN 350 AND 450;
    
    
#Exercici 3-------------------------------------------------------------------------------------------------
#Necessitem optimitzar l'assignació dels recursos i dependrà de la capacitat operativa que es requereixi, 
#per la qual cosa et demanen la informació sobre la quantitat de transaccions que realitzen les empreses, (COUNT)
#però el departament de recursos humans és exigent i 
#vol un llistat de les empreses on especifiquis si tenen igual o més de 400 transaccions o menys. (WHERE transactions => 400)


SELECT  
	c.company_name,
	COUNT(t.id) AS Cantidad_transacciones,
    
    CASE 
			WHEN COUNT(t.id) >= 400 then '400 o más transacciones'
            ELSE 'MENOS DE 400 transacciones'
	END AS capacidad_operativa
    
FROM transactions t
JOIN company c
ON c.id = t.business_id
GROUP BY c.company_name;

#Exercici 4-------------------------------------------------------------------------------------
#Elimina de la taula transaction el registre amb ID 000447FE-B650-4DCF-85DE-C7ED0EE1CAAD de la base de dades.

DELETE FROM transaction
WHERE id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';


#EJERCICIO 5-----------------------------------------------------------------------------------
#S'ha sol·licitat crear una vista que proporcioni detalls clau sobre les companyies i les seves transaccions.(COMPANY_NAME + TRANSACIONS)
#Serà necessària que creïs una vista anomenada VistaMarketing que contingui la següent informació: (create view ---.as)
#Nom de la companyia, Telèfon de contacte. País de residència. 
#Mitjana de compra realitzat per cada companyia.  AVG (amount)
#Presenta la vista creada, ordenant les dades de major a menor mitjana de compra. ( order by -desc)
USE  transactions;

DROP VIEW IF EXISTS VistaMarketing;
CREATE VIEW VistaMarketing AS
SELECT 
	c.company_name,
	c.phone,
	c.country,
	ROUND(AVG (t.amount),2) AS media_compra
FROM transactionS t
JOIN company c
ON c.id = t.business_id
WHERE declined= 0
GROUP BY 
	c.id
ORDER BY media_compra DESC;

SELECT * 
FROM VistaMarketing 
ORDER BY media_compra DESC;

SELECT *
FROM transaction
WHERE id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';

#NIVEL 3----------------------------------------------------------
#Exercici 1-----------------------------------
#Crea una nova taula que reflecteixi l'estat de les targetes de crèdit  (CREATE VIEW .--AS)basat en si les tres últimes transaccions han estat declinades aleshores és inactiu, case / gropu  by-order  by
#si almenys una no és rebutjada aleshores és actiu. Partint d’aquesta taula respon: Quantes targetes estan actives? Count(cards_id)  

DROP VIEW IF EXISTS Estado_Tarjetas;
CREATE VIEW Estado_Tarjetas AS
WITH ultimas_transacciones AS (
    SELECT 
        t.card_id, 
        t.declined, 
        t.timestamp, 
        ROW_NUMBER() OVER (
            PARTITION BY t.card_id 
            ORDER BY t.timestamp DESC
        ) AS numero_transacciones
    FROM transactions t
)
SELECT 
    cc.id,
    cc.user_id,
    cc.iban,
    CASE 
        WHEN COUNT(ut.card_id) = 3 AND SUM(ut.declined) = 3 THEN 'Inactiva'
        ELSE 'Activa'
    END AS estado_tarjeta
FROM credit_cards cc
LEFT JOIN ultimas_transacciones ut
    ON cc.id = ut.card_id 
   AND ut.numero_transacciones <= 3
GROUP BY 
    cc.id,
    cc.user_id,
    cc.iban;

SELECT COUNT(*) AS tarjetas_activas
FROM Estado_Tarjetas 
WHERE estado_tarjeta = 'Activa';
