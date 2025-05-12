SELECT *
FROM transaction;

# Exercici 2, Llistat dels països que estan fent compres.
SELECT DISTINCT country
FROM company
JOIN transaction
ON transaction.company_id = company.id;

# Des de quants països es realitzen les compres.
SELECT count(distinct country) as países_distintos
FROM company
JOIN transaction
ON transaction.company_id = company.id;

# Identifica la companyia amb la mitjana més gran de vendes. este script sirve para ver qué company ha hecho mas transacciones, no va por amount
SELECT company.company_name, count(transaction.id) as veces_tramite
FROM company
JOIN transaction
ON transaction.company_id = company.id
WHERE declined = 0
group by 1
order by veces_tramite desc
limit 1;


# EXERCICI 3
# Mostra totes les transaccions realitzades per empreses d'Alemanya.
SELECT * 
FROM transaction
WHERE 
    company_id IN (
	SELECT id
	FROM company
	WHERE country = "Germany");

# Llista les empreses que han realitzat transaccions per un amount superior a la mitjana de totes les transaccions.
			
SELECT company_name
FROM company
WHERE id IN (
    SELECT company_id
    FROM transaction
    WHERE amount > (
        SELECT AVG(amount)
        FROM transaction
    )
);

# Eliminaran del sistema les empreses que no tenen transaccions registrades, entrega el llistat d'aquestes empreses.
SELECT company_name
FROM company
WHERE id NOT IN (
	SELECT company_id
    FROM transaction
    WHERE company_id IS NOT NULL);
    
    
    
    
