-- 1-
SELECT e.sobrenome, d.nm_departamento, e.salario
FROM tb_empregado e
JOIN tb_departamento d ON e.id_departamento = d.id_departamento
WHERE d.nm_departamento = 'Vendas' AND e.salario > 8000.00
ORDER BY 3 DESC;

-- 2 -
SELECT e.id_departamento, COUNT(e.id_funcionario) as "Qtd"
FROM tb_empregado e 
WHERE e.id_departamento IN(50,80)
GROUP BY e.id_departamento
ORDER BY "Qtd" DESC;

-- 3-
SELECT e.id_funcao as 'Função',
		COUNT(e.id_funcionario) as 'Qtd', 
	    AVG(e.salario) as 'Média', 
        MAX(e.salario), 
        MIN(e.salario)
    
FROM tb_empregado e 
GROUP BY e.id_funcao
ORDER BY 'Média' DESC;

-- 4-
SELECT d.id_departamento,
	   SUM(e.salario) as 'Folha',
	   COUNT(e.id_empregado) as 'Qtd'
FROM tb_departamento d, 
JOIN tb_empregado e 
ON d.id_empregado = e.id_empregado
WHERE 'Folha' > 40000.00
ORDER BY 'Folha' DESC;

-- 5-
SELECT e.id_funcao,
	   ROUND(AVG(e.salario),2) as media_funcao,
	   ROUND(AVG(e.salario) - (SELECT AVG(salario) FROM tb_empregado),2) as diferenca
FROM tb_empregado e
GROUP BY e.id_funcao
HAVING AVG(e.salario) > (SELECT AVG(salario) FROM tb_empregado)
ORDER BY 2 DESC;

-- 6-
SELECT e.sobrenome AS sobrenome,
	   d.nm_departamento as nome_dep,
	   e.salario as salario,
	   ROUND((SELECT AVG(f.salario)
			   FROM tb_empregado f
			   WHERE f.id_departamento = e.id_departamento), 2) as media_dep
FROM tb_empregado e
JOIN tb_departamento d
ON e.id_departamento = d.id_departamento
WHERE e.salario > (SELECT AVG(f.salario)
					FROM tb_empregado f
					WHERE f.id_departametno = e.id_departamento)
	ORDER BY d.nm_departamento ASC, e.salario DESC;

-- 7-
SELECT e.sobrenome,
		e.dt_admissao,
		e.salario
FROM tb_empregado e
WHERE e.dt_admissao > (SELECT f.dt_admissao
						FROM tb_empregado f
						WHERE f.id_empregado = 101)
	 AND e.salario > 5000.00
ORDER BY e.dt_admissao ASC;

-- 8-
SELECT d.nm_departamento,
		COUNT(e.id_empregado),
		ROUND(AVG(e.salario),2),
		MAX(e.salario)
FROM tb_empregado e
JOIN tb_departamento d ON d.id_departamento = e.id_departamento
WHERE E.dt_admissao >= TO_DATE('01/01/1997', 'DD/MM/YYYY') AND e.salario > 4000.00
GROUP BY d.nm_departamento
ORDER BY 3 DESC;

-- 9-
SELECT d.nm_departamento,
	  COUNT(e.id_empregado),
	  ROUND(AVG(e.salario),2)
FROM tb_empregado e
JOIN tb_departamento d ON e.id_departamento = d.id_departamento
HAVING COUNT(e.id_empregado) > 5 AND AVG(e.salario) > 6000.00
GROUP BY d.nm_departamento
ORDER BY 3 DESC;

-- 10-
SELECT v.id_funcao             AS "Funcao",
       v.qtd_comissionados     AS "Qtd Comissionados",
       ROUND(v.media_salarial, 2) AS "Media Salarial"
FROM  (SELECT e.id_funcao,
              COUNT(e.id_empregado) AS qtd_comissionados,
              AVG(e.salario)        AS media_salarial
       FROM   tb_empregado e
       WHERE  e.percentual_comissao > 0
       GROUP  BY e.id_funcao) v
WHERE  v.media_salarial > (SELECT AVG(g.salario) FROM tb_empregado g)
ORDER  BY 3 DESC;
