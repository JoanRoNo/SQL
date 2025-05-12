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

