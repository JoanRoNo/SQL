# Creamos la tabla transactions
CREATE TABLE IF NOT EXISTS transactions (
    id VARCHAR(255) PRIMARY KEY,
    card_id VARCHAR(20),
    business_id VARCHAR(10),
    timestamp DATETIME,
    amount DECIMAL(10,2),
    declined TINYINT,
    product_ids VARCHAR(255),
    user_id INT,
    lat FLOAT,
    longitude FLOAT
);

LOAD DATA infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/transactions.csv" 
INTO TABLE transactions
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

# creamos tabla products
CREATE TABLE IF NOT EXISTS products (
	id INT PRIMARY KEY,
    product_name VARCHAR (255),
    price VARCHAR (10),
    colour VARCHAR (10),
    weight FLOAT,
    warehouse_id VARCHAR (10)
    );  
    
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/products.csv"
INTO TABLE products
FIELDS TERMINATED BY ","
ENCLOSED BY '"'
LINES TERMINATED BY "\n"
IGNORE 1 ROWS;

# Creamos la tabla credit_cards
CREATE TABLE IF NOT EXISTS credit_cards (
	id VARCHAR (20) PRIMARY KEY,
    user_id INT,
    iban VARCHAR (50),
    pan VARCHAR (30),
    pin VARCHAR(4),
    cvv VARCHAR(4),
    track1 TEXT,
    track2 TEXT, 
    expiring_date VARCHAR (10)
    );
    
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/credit_cards.csv"
INTO TABLE credit_cards
FIELDS TERMINATED BY ","
ENCLOSED BY '"'
LINES TERMINATED BY "\n"
IGNORE 1 ROWS;

CREATE TABLE IF NOT EXISTS companies (
	company_id VARCHAR (10) PRIMARY KEY, 
    company_name VARCHAR (50),
    phone VARCHAR (20),
    email VARCHAR (50),
    country VARCHAR (20),
    website VARCHAR (50)
    );
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/companies.csv"
INTO TABLE companies
FIELDS TERMINATED BY ","
ENCLOSED BY '"'
LINES TERMINATED BY "\n"
IGNORE 1 ROWS;

CREATE TABLE IF NOT EXISTS users_all (
	id INT PRIMARY KEY,
    name VARCHAR (20),
    surname VARCHAR (20),
    phone VARCHAR (20),
    email VARCHAR (50),
    birth_date VARCHAR (20),
    country VARCHAR (20),
    city VARCHAR (50),
    postal_code VARCHAR (10),
    adress VARCHAR (255)
    );
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users_uk.csv"
INTO TABLE users_all
FIELDS TERMINATED BY ","
ENCLOSED BY '"' 
LINES TERMINATED BY "\r\n"
IGNORE 1 ROWS;

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users_ca.csv"
INTO TABLE users_all
FIELDS TERMINATED BY ","
ENCLOSED BY '"' 
LINES TERMINATED BY "\r\n"
IGNORE 1 ROWS;

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users_usa.csv"
INTO TABLE users_all
FIELDS TERMINATED BY ","
ENCLOSED BY '"' 
LINES TERMINATED BY "\r\n"
IGNORE 1 ROWS;

# Añadimos las foreign keys a la tabla transactions para crear nuestro esquema
ALTER TABLE transactions
ADD CONSTRAINT fk_transactions_companies
FOREIGN KEY (business_id)
REFERENCES companies(company_id);

ALTER TABLE transactions
ADD CONSTRAINT fk_transactions_credit_cards
FOREIGN KEY (card_id)
REFERENCES credit_cards(id);

ALTER TABLE transactions
ADD CONSTRAINT fk_transactions_users
FOREIGN KEY (user_id)
REFERENCES users_all(id);

ALTER TABLE transactions
ADD CONSTRAINT fk_transactions_products
FOREIGN KEY (product_ids)
REFERENCES products(id);
# no podemos establecer esta relación de momento (los campos no coinciden)

# Exercici 1
SELECT DISTINCT ua.id, ua.name, ua.surname
FROM users_all ua
JOIN transactions t ON ua.id = t.user_id
WHERE t.user_id IN (
    SELECT user_id
    FROM transactions
    GROUP BY user_id	
    HAVING COUNT(*) > 30);
    
# Exercici 2
# Mostra la mitjana d'amount per IBAN de les targetes de crèdit a la companyia Donec Ltd, utilitza almenys 2 taules.
SELECT round(avg(t.amount),2) as mitjana_quantitat, cc.iban
FROM transactions t
JOIN credit_cards cc ON t.card_id = cc.id
JOIN companies cp ON t.business_id = cp.company_id
WHERE company_name = "Donec Ltd"
GROUP BY cc.iban;
	
# Nivell 2
# Creamos la tabla
CREATE TABLE estado_tarjetas AS
SELECT 
	card_id,
    CASE
		WHEN SUM(CASE WHEN declined = 1 THEN 1 ELSE 0 END) = 3 THEN 0
        ELSE 1
	END AS tarjeta_activa
FROM (
	SELECT card_id, declined,
		ROW_NUMBER() OVER (PARTITION BY card_id ORDER BY timestamp DESC) AS orden
	FROM transactions) AS ultimas_transacciones
WHERE orden <= 3
GROUP BY card_id;

# Exercici 1
SELECT COUNT(*) as tarjetas_activas
FROM estado_tarjetas
WHERE tarjeta_activa = 1;

# Nivel 3
# Creamos la tabla
CREATE TABLE transaction_product (
    transaction_id VARCHAR(255),
    product_id INT,
    PRIMARY KEY (transaction_id, product_id),
    FOREIGN KEY (transaction_id) REFERENCES transactions(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

# Insertamos datos a la tabla des de una CTE
INSERT INTO transaction_product (transaction_id, product_id)
SELECT transaction_id, CAST(product_id AS UNSIGNED)
FROM (
    WITH RECURSIVE numbers AS (
      SELECT 0 AS n
      UNION ALL
      SELECT n + 1 FROM numbers WHERE n < 20
    ),
    cortar AS (
      SELECT
        t.id AS transaction_id,
        TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(t.product_ids, ',', n + 1), ',', -1)) AS product_id
      FROM transactions t
      JOIN numbers 
        ON n <= CHAR_LENGTH(t.product_ids) - CHAR_LENGTH(REPLACE(t.product_ids, ',', ''))
    )
    SELECT * FROM cortar
) AS resultado;

SELECT product_id, COUNT(*) as veces_vendido
FROM transaction_product
GROUP BY 1
ORDER BY veces_vendido desc;

