library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

-- Toma un número, por ejemplo 154, y retorna los dígitos en binario
-- ["0001", "0101", "0100"] pero en un arreglo único: "000101010100"
entity bcd2ss7 is
  port (
    number : in integer;
    digits : out std_logic_vector(27 downto 0) -- Hasta un entero de 7 dígitos
  );
end entity bcd2ss7;

architecture bcd2ss7arch of bcd2ss7 is
  signal digits_sig : std_logic_vector(27 downto 0);
begin
  process (number)
  variable temp, remaint : integer := 0;
  begin
    digits_sig <= (others => '0');
    temp := number;
    for i in 0 to 6 loop
      -- Obtención del dígito
      remaint := temp mod 10;
      temp    := temp / 10;
      -- Conversión a binario
      digits_sig(i * 4 + 3 downto i * 4) <= std_logic_vector(to_unsigned(remaint, 4));
      exit when temp = 0;
    end loop;
  end process;
  digits <= digits_sig;
end architecture;