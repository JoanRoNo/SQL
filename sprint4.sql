# Creamos la tabla transactions
CREATE TABLE IF NOT EXISTS transactions (
    id VARCHAR(255) PRIMARY KEY,
    card_id VARCHAR(50),
    business_id VARCHAR(50),
    timestamp DATETIME,
    amount DECIMAL(10,2),
    declined BOOLEAN,
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
    pin INT,
    cvv INT,
    track1 TEXT,
    track2 TEXT, 
    expiring_date VARCHAR (10)
    );
# pin mejor no en int pq hay algunos que empiezan x 0
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

select *
from t;

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

# Exercici 1
SELECT DISTINCT ua.name, ua.surname
FROM users_all ua
JOIN transactions t ON ua.id = t.user_id
WHERE t.user_id IN (
    SELECT user_id
    FROM transactions
    GROUP BY user_id
    HAVING COUNT(*) > 30);
    
CREATE TABLE estado_tarjetas AS 
SELECT 
    card_id,
    CASE
        WHEN SUM(CASE WHEN declined = 1 THEN 1 ELSE 0 END) = 3 THEN 0
        ELSE 1
    END AS tarjeta_activa
FROM 
    (SELECT card_id, declined,
        ROW_NUMBER() OVER (PARTITION BY card_id ORDER BY timestamp DESC) AS orden
    FROM transactions
    WHERE card_id IS NOT NULL
) AS ultimas_transacciones
WHERE orden <= 3
GROUP BY card_id; 

)
# Quantes targetes estan actives?
SELECT COUNT(*) AS tarjetas_activas
FROM estado_tarjetas
WHERE tarjeta_activa = 1;

    


	

 


    
    
    
    
