--MODULO DIVF
-- Este bloque reduce la frecuencia de la señal de reloj de entrada, 
-- generando una señal de salida con una frecuencia más baja, útil para otros componentes del sistema.
-- La reducción de frecuencia se logra mediante un contador que cuenta hasta un valor predefinido.
library ieee;
use ieee.std_logic_1164.all;

-- Definición de la entidad divf.
-- num: Este parámetro define el número máximo de ciclos que el contador contará,
-- lo que determinará la división de frecuencia.
entity divf is
  generic (num : integer := 25000000);-- Divisor de frecuencia, en este caso 25 millones.
  port (
    clk  : in std_logic;--Señal de reloj de entrada, de alta frecuencia.
    clkl : buffer std_logic := '0' --Señal de reloj de salida, con frecuencia reducida.
  );
end entity;

-- Arquitectura del divisor de frecuencia.
-- Un contador incrementa en cada flanco de subida del reloj, y cuando llega a su valor máximo (num), 
-- invierte la señal de salida y reinicia el contador.
architecture arqdivf of divf is
  signal conteo : integer range 0 to num; -- Señal para contar el número de ciclos del reloj.
begin
-- Proceso que se activa en cada flanco de subida del reloj (clk).
  process (clk)
  begin
    if (rising_edge(clk)) then --Verifica si hay un flanco de subida en la señal de reloj
      if (conteo = num) then --Si el contador ha llegado al valor máximo
        conteo <= 0; --Reinicia el contador
        clkl   <= not clkl; --Invierte la señal de salida, generando una frecuencia más baja.
      else
        conteo <= conteo + 1; -- Incrementa el contador en cada ciclo de reloj.
      end if;
    end if;
  end process;
end architecture;