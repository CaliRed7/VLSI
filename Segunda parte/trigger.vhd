library ieee;
use ieee.std_logic_1164.all;
--u3: entity work.trigger(arqtrg) port map(clkl2, rst, echo, tr);
entity trigger is
    port (
        clk, rst, echo: in std_logic;  -- Puertos de entrada: reloj, señal de reset y señal de eco
        salida: out std_logic  -- Puerto de salida: señal de salida
    );
end entity;

architecture arqtrigger of trigger is
begin
    process(clk)
    begin
        if(rst = '1') then  -- Si la señal de reset está activa
            salida <= '0';  -- La salida se establece en '0'
        elsif(echo = '0') then  -- Si la señal de eco está en bajo
            salida <= clk;  -- La salida sigue al reloj
        end if;
    end process;
end architecture;
