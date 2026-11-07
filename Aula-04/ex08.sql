--1
SELECT nome, sobrenome
FROM tb_clientes
WHERE nome LIKE "%li%";

--2
SELECT nome, 
	   sobrenome,
	   SUBSTR(nome,1,1) || SUBSTR(sobrenome,1,10) AS nome_formal
FROM tb_empregado
WHEN LENGTH(nome) + LENGTH(sobrenome) > 10;

--3
SELECT EXTRACT(YEAR FROM hd.data_termino) as ano,
	   hf.id_funcao,
	   COUNT(hf.id_empregado) 
FROM tb_historico_funcao hf
GROUP BY EXTRACT(YEAR FROM hf.data_termino), id_funcao
ORDER BY ano ASC;

--4
SELECT TO_CHAR(data_admissao, 'DAY'),
       COUNT(id_empregado)
FROM tb_empregado
GROUP BY TO_CHAR(data_admissao, 'DAY')
HAVING COUNT(id_empregado) >=20;

--5
/* primeiro criar a copia*/
CREATE TABLE tb_departamento_copia AS
SELECT * FROM tb_departamento;

CREATE OR REPLACE PROCEDURE sp_altera_nm_dep( 
    p_id_departamento IN tb_departamento_copia.id_departamento%TYPE
)
IS
v_nome tb_departamento_copia.nm_departamento%TYPE;
v_inicial CHAR(1);
BEGIN
	SELECT nm_departamento
	INTO v_nome
	FROM tb_departamento_copia
	WHERE p_id_departamento = id_departamento;
	
	v_inicial := UPPER(SUBSTR(v_nome,1,1));
	
	IF v_inicial IN ('A','E','I','O','U') THEN
		UPDATE tb_departamento_copia
		SET nm_departamento = UPPER(nm_departamento)
		WHERE id_departamento = p_id_departamento;
		
		DBMS_OUTPUT.PUT_LINE('Departamento '||v_nome||' alterado para maiusculo.');
	
	ELSE
		UPDATE tb_departamento_copia
		SET nm_departamento = LOWER(nm_departamento)
		WHERE id_departamento = p_id_departamento;
		
		DBMS_OUTPUT.PUT_LINE(
		'nome do departamento '||v_nome||' alterado para minusculo.');
		
	END IF;
	
	COMMIT;
	
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('Departamento com ID '||p_id_departamento|| ' não existe.');

END sp_altera_nm_dep;
/