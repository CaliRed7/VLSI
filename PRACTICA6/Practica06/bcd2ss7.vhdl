--MODULO BCD2SS7
-- Este módulo convierte un número entero en su representación binaria 
--en formato BCD (Binary-Coded Decimal).La salida es una cadena de 7 
--segmentos que se puede mostrar en un display de 7 segmentos.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
-- Toma un número, por ejemplo 154, y retorna los dígitos en binario
-- ["0001", "0101", "0100"] pero en un arreglo único: "000101010100"


--Definición de la entidad bcd2ss7.
entity bcd2ss7 is
  port (
    number : in integer;--Entrada que representa el número que se convertirá a BCD.
    digits : out std_logic_vector(27 downto 0)--Salida que contiene los dígitos BCD, con 4 bits por cada dígito.
  );
end entity bcd2ss7;

--Arquitetura "bcd2ss7arch"
-- Este proceso descompone el número de entrada en dígitos individuales BCD, 
-- que son convertidos y almacenados en la salida 
architecture bcd2ss7arch of bcd2ss7 is
  signal digits_sig : std_logic_vector(27 downto 0); -- Señal interna que almacena los dígitos convertidos.
begin
	-- Proceso que toma el número y los descompone en sus dígitos BCD
  process (number)
  variable temp, remaint : integer := 0; --Variables para manejar el número temporal y el dígito restante.
  begin
    digits_sig <= (others => '0');  -- Inicializa la salida en ceros.
    temp := number; -- Almacena el número en una variable temporal.
    for i in 0 to 6 loop -- Recorre hasta 7 dígitos (máximo 28 bits en BCD).
      
		-- Obtención del dígito
      remaint := temp mod 10; -- Obtiene el último dígito del número.
      temp    := temp / 10; -- Reduce el número eliminando el último dígito.
		
      -- Conversión a binario
		-- Asigna el dígito convertido a la señal de salida.
      digits_sig(i * 4 + 3 downto i * 4) <= std_logic_vector(to_unsigned(remaint, 4));
      exit when temp = 0;
    end loop;
  end process;
  digits <= digits_sig;
end architecture;