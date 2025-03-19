library ieee;
use ieee.std_logic_1164.all;

-- Definición de la entidad "contador"
entity contador is
    port (
        echo, clkl1, rst: in std_logic;  -- Entradas
        salida0, salida1: out integer    -- Salidas
    );
end entity contador;

-- Implementación de la arquitectura de "contador"
architecture arqcontador of contador is
    signal conteo: integer range 0 to 12000;  -- Señal de conteo

begin
    process(echo, clkl1, rst)
    begin
        if rst = '1' then
            -- Si se recibe señal de reset, reiniciar el conteo
            conteo <= 0;
        elsif rising_edge(clkl1) then
            -- Si hay flanco de subida en la señal de reloj clkl1
            if echo = '1' then
                -- Si la señal echo está activa
                conteo <= conteo + 1;  -- Incrementar el conteo
					 
					 else

                -- Aquí se determina qué valores asignar a las salidas
                if conteo > 0 and conteo <= 58 then
                    salida0 <= 0;
                    salida1 <= 1;
                elsif conteo > 58 and conteo <= 118 then
                    salida0 <= 0;
                    salida1 <= 2;
                -- Se repite el mismo patrón para cada rango de conteo
                -- Estos rangos dividen el conteo en segmentos para controlar las salidas
						elsif(conteo>118 and conteo<=177) then -- 2 a 3
							salida0 <= 0;
							salida1 <= 3;
						elsif(conteo>177 and conteo<=236) then -- 3 a 4
							salida0 <= 0;
							salida1 <= 4;
						elsif(conteo>236 and conteo<=295) then -- 4 a 5
							salida0 <= 0;
							salida1 <= 5;
						elsif(conteo>295 and conteo<=353) then -- 5 a 6
							salida0 <= 0;
							salida1 <= 6;
						elsif(conteo>353 and conteo<=412) then -- 6 a 7
							salida0 <= 0;
							salida1 <= 7;
						elsif(conteo>412 and conteo<=471) then -- 7 a 8
							salida0 <= 0;
							salida1 <= 8;
						elsif(conteo>471 and conteo<=530) then -- 8 a 9
							salida0 <= 0;
							salida1 <= 9;
						elsif(conteo>530 and conteo<=589) then -- 9 a 10
							salida0 <= 1;
							salida1 <= 0;
						elsif(conteo>589 and conteo<=648) then -- 10 a 11
							salida0 <= 1;
							salida1 <= 1;
						elsif(conteo>648 and conteo<=706) then -- 11 a 12
							salida0 <= 1;
							salida1 <= 2;
						elsif(conteo>706 and conteo<=765) then -- 12 a 13
							salida0 <= 1;
							salida1 <= 3;
						elsif(conteo>765 and conteo<=824) then -- 13 a 14
							salida0 <= 1;
							salida1 <= 4;
						elsif(conteo>824 and conteo<=883) then -- 14 a 15
							salida0 <= 1;
							salida1 <= 5;
						elsif(conteo>883 and conteo<=942) then -- 15 a 16
							salida0 <= 1;
							salida1 <= 6;
						elsif(conteo>942 and conteo<=1000) then -- 16 a 17
							salida0 <= 1;
							salida1 <= 7;
						elsif(conteo>1000 and conteo<=1059) then -- 17 a 18
							salida0 <= 1;
							salida1 <= 8;
						elsif(conteo>1059 and conteo<=1118) then -- 18 a 19
							salida0 <= 1;
							salida1 <= 9;
						elsif(conteo>1118 and conteo<=1177) then -- 19 a 20
							salida0 <= 2;
							salida1 <= 0;
						end if;
				end if;
			end if;
		end process;
end architecture;