--MODULO SENAL
--Genera una señal pwm con un ciclo de trabajo duty cycle
--configurable, este modulo es fundamental para controlar
--el movimiento de un servomotor de corriente continua
library ieee;
use ieee.std_logic_1164.all;
--Se declara la entidad senal
entity senal is
  port (
    clk  : in std_logic;  -- Entrada del reloj
    duty : in integer;--ciclo de trabajo de 0-1000
    snl  : out std_logic);-- Salida de la señal PWM
end entity;
--Arquitectura "arqsenal"
architecture arqsenal of senal is
  signal conteo : integer range 0 to 1000;--define la resolución de pwm
begin
  process (clk)--GENERACIÓN DE LA SEÑAL PWM
  begin
    if (rising_edge(clk)) then--flaco de de subida
      if (conteo <= duty) then--se comparan
        snl        <= '1';--Si conteo ≤ duty, la salida snl es 1 (pulso alto).
      else
        snl <= '0';--Si conteo > duty, la salida snl es 0 (pulso bajo).
      end if;
      --Esto genera una señal cuadrada donde duty define la proporción del tiempo en alto.
		
		
      if (conteo = 1000) then--cuando conteo llega a 1000 se reinicia a 0 completando 1 ciclo
        conteo <= 0;
      else
        conteo <= conteo + 1;--en cada ciclo conteo se incrementa en 1 asegurando la frecuencia estable
      end if;
    end if;
  end process;
end architecture;