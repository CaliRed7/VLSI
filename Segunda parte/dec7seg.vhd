library ieee;
use ieee.std_logic_1164.all;

-- Definición de la entidad "dec7seg"
entity dec7seg is
    port (
        entrada: in integer;                       -- Entrada de tipo entero
        salida: out std_logic_vector(6 downto 0)  -- Salida de 7 segmentos
    );
end entity dec7seg;

-- Implementación de la arquitectura de "dec7seg"
architecture arqdec of dec7seg is
begin
    with entrada select
        -- Seleccionar la salida de acuerdo al valor de la entrada
        salida <=
            "1000000" when 0,
            "1111001" when 1,
            "0100100" when 2,
            "0110000" when 3,
            "0011001" when 4,
            "0010010" when 5,
            "0000010" when 6,
            "1111000" when 7,
            "0000000" when 8,
            "0011000" when 9,
            "1111111" when others;  -- Cuando la entrada no coincide con ningún caso

end architecture arqdec;
