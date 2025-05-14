
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




# Identifica la companyia amb la mitjana més gran de vendes.
SELECT company.company_name, avg(transaction.amount) as media_ventas
FROM company
JOIN transaction
ON transaction.company_id = company.id
WHERE declined = 0
group by 1
order by media_ventas desc
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
        FROM transaction)
);


# Eliminaran del sistema les empreses que no tenen transaccions registrades, entrega el llistat d'aquestes empreses.
SELECT company_name
FROM company
WHERE id NOT IN (
	SELECT company_id
    FROM transaction);
    
    
# Nivell 2 
# Identifica els cinc dies que es va generar la quantitat més gran d'ingressos a l'empresa per vendes. Mostra la data de cada transacció juntament amb el total de les vendes.
SELECT DATE(timestamp) as dia, sum(amount) as ingresos 
FROM transaction
WHERE declined = 0
GROUP BY dia
ORDER BY ingresos desc
LIMIT 5;

# Quina és la mitjana de vendes per país? Presenta els resultats ordenats de major a menor mitjà.
select company.country, avg(amount) as ventas
from transaction
join company on transaction.company_id = company.id
where declined = 0
group by company.country
order by ventas desc;


# En la teva empresa, es planteja un nou projecte per a llançar algunes campanyes publicitàries per a fer competència a la companyia "Non Institute". Per a això, et demanen la llista de totes les transaccions realitzades per empreses que estan situades en el mateix país que aquesta companyia.
# fet amb joins i subqueries
SELECT * 
FROM transaction
JOIN company on 
transaction.company_id = company.id
WHERE declined = 0 and
	company.country in (
	SELECT country
	FROM company
	WHERE company_name = "Non Institute");
    
# fet amb subqueries:
SELECT *
FROM transaction
WHERE declined = 0 AND
company_id IN (
	SELECT id
    FROM company
    WHERE country = (
		SELECT country
        FROM company
        WHERE company_name = "Non Institute")
        );

# Nivell 3
# Presenta el nom, telèfon, país, data i amount, d'aquelles empreses que van realitzar transaccions amb un valor comprès entre 100 i 200 euros i en alguna d'aquestes dates: 29 d'abril del 2021, 20 de juliol del 2021 i 13 de març del 2022. Ordena els resultats de major a menor quantitat.
SELECT c.company_name, c.phone, c.country, date(t.timestamp) as fecha, t.amount
FROM company c
JOIN transaction t on c.id=t.company_id
WHERE amount between 100 and 200
and declined = 0
HAVING fecha = "2021-04-29"
or fecha = "2021-07-20"
or fecha = "2022-03-13"
ORDER BY amount desc;

# Necessitem optimitzar l'assignació dels recursos i dependrà de la capacitat operativa que es requereixi, per la qual cosa et demanen la informació sobre la quantitat de transaccions que realitzen les empreses, però el departament de recursos humans és exigent i vol un llistat de les empreses on especifiquis si tenen més de 4 transaccions o menys.
SELECT company_id, count(*) as num_transacciones, IF (count(*) >= 4, "mayor/igual a 4", "menor a 4") as transacciones
FROM transaction
WHERE declined = 0
GROUP BY company_id
ORDER BY num_transacciones desc; 





# CASE WHEN?

select *
from transaction;








	


