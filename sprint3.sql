# Exercici 1
CREATE TABLE credit_card (
	id varchar(15) PRIMARY KEY,
    iban varchar(50),
    pan varchar(255),
    pin varchar(4),
    cvv int,
    expiring_date varchar(20)
    );
    
ALTER TABLE transaction 
ADD CONSTRAINT fk_transaction_credit_card
FOREIGN KEY (credit_card_id)
REFERENCES credit_card(id);

# Exercici 2
SELECT *
FROM credit_card
WHERE
id = "CcU-2938";

UPDATE credit_card
SET iban = "R323456312213576817699999"
WHERE id = "CcU-2938";

SELECT *
FROM credit_card
WHERE
id = "CcU-2938";

# Exercici 3
INSERT INTO credit_card (id)
VALUES ("CcU-9999");
INSERT INTO company (id)
VALUES ("b-9999");
INSERT INTO transaction (id, credit_card_id, company_id, user_id, lat, longitude, amount, declined)
VALUES( "108B1D1D-5B23-A76C-55EF-C568E49A99DD", "CcU-9999", "b-9999", 9999, 829.999, -117.999, 111.11, 0);
SELECT * 
FROM transaction
WHERE credit_card_id = "CcU-9999";

# Exercici 4
SELECT *
FROM credit_card;
ALTER table credit_card
DROP COLUMN pan;
SHOW COLUMNS
FROM credit_card;


# Nivell 2
# Exercici 1
SELECT * 
FROM transaction
WHERE id = "02C6201E-D90A-1859-B4EE-88D2986D3B02";
DELETE FROM transaction
WHERE id = "02C6201E-D90A-1859-B4EE-88D2986D3B02";
SELECT *
FROM transaction
WHERE id = "02C6201E-D90A-1859-B4EE-88D2986D3B02";

# Exercici 2
CREATE VIEW VistaMarketing as 
SELECT c.company_name, c.phone, c.country, avg(t.amount) as mitjana_compra
FROM company c
JOIN transaction t on c.id = t.company_id
WHERE declined = 0
GROUP BY c.id
ORDER BY mitjana_compra desc;
SELECT * 
FROM VistaMarketing;

# Exercici 3
SELECT *
FROM VistaMarketing
WHERE country = "Germany";

# Nivell 3
# Exercici 1
# añadimos el campo fecha_actual
ALTER TABLE credit_card
ADD COLUMN fecha_actual date;
SELECT * 
FROM credit_card;

#comprobamos el tipo de datos de la tabla credit_card
SHOW COLUMNS
FROM credit_card;

# cambiamos los tipos de datos de la tabla credit_card
ALTER TABLE credit_card
MODIFY id varchar(20);
SHOW COLUMNS
FROM credit_card; 

# creamos la tabla user
CREATE INDEX idx_user_id ON transaction(user_id);
CREATE TABLE IF NOT EXISTS user (
        id INT PRIMARY KEY,
        name VARCHAR(100),
        surname VARCHAR(100),
        phone VARCHAR(150),
        email VARCHAR(150),
        birth_date VARCHAR(100),
        country VARCHAR(150),
        city VARCHAR(150),
        postal_code VARCHAR(100),
        address VARCHAR(255),
        FOREIGN KEY(id) REFERENCES transaction(user_id)        
    );

# cambiamos el nombre
ALTER TABLE user 
RENAME TO data_user;

# eliminamos la foreign key existente
ALTER TABLE data_user 
DROP FOREIGN KEY data_user_ibfk_1;

# intentamos establecer una nueva foreign key
ALTER TABLE transaction
ADD CONSTRAINT fk_transaction_user
FOREIGN KEY (user_id) REFERENCES data_user(id);
# no podemos establecer la fk


# buscamos qué user_id falta en la tabla 
SELECT DISTINCT user_id
FROM transaction
WHERE user_id NOT IN (
	SELECT id FROM data_user);

# una vez encontrado, lo insertamos y ya podemos establecer la foreign key con un nombre conocido
INSERT INTO data_user (id)
VALUES (9999);
ALTER TABLE transaction
ADD CONSTRAINT fk_transaction_user
FOREIGN KEY (user_id) REFERENCES data_user(id);

# Exercici 2
CREATE VIEW InformeTecnico as
SELECT t.id as id_transaccio, du.name as nom_usuari, du.surname as cognom_usuari, cc.iban as iban_associat, c.company_name as nom_empresa_transaccio
FROM credit_card cc
JOIN transaction t on t.credit_card_id = cc.id
JOIN data_user du on du.id = t.user_id
JOIN company c on c.id = t.company_id
ORDER BY id_transaccio desc;
SELECT *
FROM InformeTecnico;









    
    
    
    
    
    
    
    
    
    
    
    
    




    
    


    