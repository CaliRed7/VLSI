--MODULO DISPLAY 
-- Este módulo convierte un número en formato BCD a la representación 
--binaria necesaria para controlar un display de 7 segmentos. La salida 
--es un vector de 7 bits que representa el estado de los segmentos (a-g) en el display.
library ieee;
use ieee.std_logic_1164.all;

-- Definición de la entidad display.
-- bcd: Entrada que representa el dígito en formato BCD (de 0 a 9).
-- hex: Salida que contiene la representación binaria de los segmentos del display de 7 segmentos.
entity display is
  port (
    bcd : in std_logic_vector(3 downto 0);--Entrada BCD, que representa un dígito en binario (4 bits).
    hex : out std_logic_vector(6 downto 0)--Salida para el display de 7 segmentos (7 bits, para los segmentos a-g).
  );
end entity;

--Arquitectura "arqdisplay"
-- Se utiliza una sentencia "with select" para mapear el valor BCD de entrada a la configuración
-- correspondiente de los segmentos del display.
architecture arqdisplay of display is
begin
-- Proceso de conversión BCD a 7 segmentos.
  -- Dependiendo del valor de la entrada BCD, se asignan los valores binarios correspondientes
  -- a la salida "hex", que representa el estado de cada uno de los 7 segmentos.
  -- El display está representado por los bits hex(6 downto 0), que corresponden a los segmentos a, b, c, d, e, f, g.
  with bcd select
    hex <=
    "1000000" when "0000", -- 0 
    "1111001" when "0001", -- 1
    "0100100" when "0010", -- 2
    "0110000" when "0011", -- 3
    "0011001" when "0100", -- 4
    "0010010" when "0101", -- 5
    "0000010" when "0110", -- 6
    "1111000" when "0111", -- 7
    "0000000" when "1000", -- 8
    "0011000" when "1001", -- 9
    "1111111" when others;
end architecture;