library ieee;
use ieee.std_logic_1164.all;

entity sensor is
    port (
        clk, rst, echo: in std_logic;  -- Entradas del sistema: reloj, señal de reset y señal de eco del sensor
        trig: out std_logic;  -- Salida del sistema: señal de trigger
        ss0, ss1: out std_logic_vector(6 downto 0)  -- Salidas del sistema: segmentos de display de 7 segmentos
    );
end entity;

architecture arqsns of sensor is
    signal clkl1, clkl2, tr: std_logic;  -- Señales internas del sistema
    signal salida0, salida1: integer;  -- Señales internas para el contador de salida
begin
    u1: entity work.divf(arqdivf) generic map(25) port map(clk, clkl1); -- Generador de frecuencia dividida
    u2: entity work.senal(arqsenal) port map(clk, clkl2); -- Generador de señal PWM
    u3: entity work.trigger(arqtrigger) port map(clkl2, rst, echo, tr); -- Controlador de trigger
    trig <= tr;  -- Asignación de la señal de trigger
    
    u4: entity work.contador(arqcontador) port map(echo, clkl1, tr, salida0, salida1); -- Contador de salida
    u5: entity work.dec7seg(arqdec) port map(salida0, ss0); -- Conversor de decimal a display de 7 segmentos para la salida0
    u6: entity work.dec7seg(arqdec) port map(salida1, ss1); -- Conversor de decimal a display de 7 segmentos para la salida1
end architecture;
