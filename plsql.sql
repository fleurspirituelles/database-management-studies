SET SERVEROUTPUT ON

DECLARE
    altura NUMBER := 3;
    base   NUMBER := 3;
    area   NUMBER;
BEGIN
    area := ( base * altura ) / 2;
    dbms_output.put_line('Área do triângulo: ' || area);
END;

DECLARE
    v_saldo   NUMBER := 500;
    v_limite  NUMBER := 100;
    v_message VARCHAR(30);
BEGIN
    IF v_saldo > 0 THEN
        v_message := 'Saldo positivo';
        IF v_limite > 0 THEN
            v_message := 'Saldo e limite positivos';
        END IF;
    ELSIF v_saldo = 0 THEN
        v_message := 'Saldo zero';
    ELSE
        v_message := 'Saldo negativo';
    END IF;

    dbms_output.put_line(v_message);
END;

DECLARE
    estado_civil CHAR(1) := 'D';
    v_estcivil   VARCHAR(20);
BEGIN
    CASE estado_civil
        WHEN 'C' THEN
            v_estcivil := 'Casada';
        WHEN 'S' THEN
            v_estcivil := 'Solteira';
        WHEN 'D' THEN
            v_estcivil := 'Divorciada';
        ELSE
            v_estcivil := 'Não informado';
    END CASE;

    dbms_output.put_line('Estado civil: ' || v_estcivil);
END;