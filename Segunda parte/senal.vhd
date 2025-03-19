library ieee;
use ieee.std_logic_1164.all;

entity senal is
    port (
        clk: in std_logic;    -- Entrada de reloj
        snl: out std_logic    -- Salida de la señal
    );
end entity;

architecture arqsenal of senal is
    signal conteo: integer range 0 to 25000000 := 0;  -- Declaración de la señal de conteo
begin
    process(clk)
    begin
        if(rising_edge(clk)) then  -- Detecta el flanco de subida del reloj
            if(conteo <= 500) then  -- Si el conteo es menor o igual a 500
                snl <= '1';  -- Se activa la señal de salida
            else
                snl <= '0';  -- De lo contrario, se desactiva la señal de salida
            end if;
            
            if(conteo = 25000000) then  -- Si el conteo alcanza su valor máximo
                conteo <= 0;  -- Se reinicia el conteo
            else
                conteo <= conteo + 1;  -- Se incrementa el conteo en cada ciclo
            end if;
        end if;
    end process;
end architecture;
