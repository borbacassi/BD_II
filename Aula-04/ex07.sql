-- 1-
SELECT e.nome ||' '|| e.sobrenome as empregado,
        f.ds_funcao as funcao,
        e.data_admissao
FROM empregado e
JOIN funcao f ON f.id_funcao = e.id_funcao
WHERE e.data_admissao BETWEEN TO_DATE('20/02/1987','DD/MM/YYYY') AND
                            TO_DATE('01/05/1989', 'DD/MM/YYYY')
ORDER BY 3 ASC;

-- 2-
SELECT UPPER(e.nome) as nome ,
        LENGTH(e.sobrenome) as qtd, 
        d.nm_dep as departamento,
        p.nm_pais as Pais
FROM empregado e
JOIN departamento d ON e.id_departamento = d.id_dep
JOIN localizacao l ON l.id_localizacao = d.id_localizacao
JOIN pais p ON p.id_pais = l.id_pais
WHERE SUBSTR(e.nome,1,1) IN ('B','L','A');


--3 
SELECT e.nome as nome, d.nm_dep as departamento, l.cidade as cidade, l.estado as estado
FROM empregado e
JOIN departamento d ON e.id_departamento = d.id_dep
JOIN localizacao l ON l.id_localizacao = d.id_localizacao
WHERE e.percentual_comissao  > 0;

--4-
SELECT e.nome as "Empregados",
NVL(g.nome, 'Os acionistas') as "Gerentes"
FROM empregado e
LEFT JOIN empregado g ON e.id_gerente = g.id_empregado   
ORDER BY g.nome DESC

-- 5
-- Criando Procedure
CREATE OR REPLACE PROCEDURE sp_get_emp(
p_id_empregado IN empregado.id_empregado%TYPE
)
IS
    v_nome empregado.nome%TYPE;
    v_sobrenome empregado.sobrenome%TYPE;
    v_ds_funcao funcao.ds_funcao%TYPE;
    
BEGIN
    SELECT e.nome, e.sobrenome,f.ds_funcao
    INTO v_nome, v_sobrenome, v_ds_funcao
    FROM empregado e 
    JOIN funcao f ON e.id_funcao = f.id_funcao
    WHERE e.id_empregado = p_id_empregado;

    DBMS_OUTPUT.PUT_LINE    ('Nome:' || v_nome || ' ' || v_sobrenome || ' Função:' || v_ds_funcao);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Empregado ' || p_id_empregado || ' não encontrado.');
END sp_get_emp;
/

EXEC sp_get_emp(105);
                