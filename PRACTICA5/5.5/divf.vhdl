--MODULO DIVF
--Reduce la frecuencia de una señal de reloj (clk)
--generando una señal más lenta(clkl). Y esto funciona para
--trabajar con señales PWL de menor frecuencia o controlar
--dispositivos que requieren tiempos especificos

library ieee;
use ieee.std_logic_1164.all;

--Se define la entidad divf
entity divf is
  generic (num : integer := 25000000);--Define un valor genérico 
         ---num que determina cuántos ciclos de clk se requieren 
			----para cambiar clkl. CLKL=1Hz
  port (
    clk  : in std_logic; --Señal de reloj de alta frecuencia.
    clkl : buffer std_logic := '0'--Señal de reloj reducida.
  );
end entity;

--Arquitectura "arqdivf"
architecture arqdivf of divf is
  signal conteo : integer range 0 to num;
begin
  process (clk)
  begin ---En cada flanco de subida de clk (rising_edge(clk)), 
			-----el contador conteo aumenta.
    if (rising_edge(clk)) then
      if (conteo = num) then--cuandoson iguales se resetea a 0
        conteo <= 0;
        clkl   <= not clkl;
      else --Se invierte la señal clkl (not clkl), cambiándola de 0 a 1 o viceversa.
        conteo <= conteo + 1;
      end if;
    end if;
  end process;
end architecture;