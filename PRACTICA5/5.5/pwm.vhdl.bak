library ieee;
use ieee.std_logic_1164.all;

entity pwm is
  port (
    clk, rst   : in std_logic; --! Entrada del reloj de la tarjeta y el reset
    dir        : in std_logic; --! Para seleccionar la dirección (0 izquierda, 1 derecha)
    enable_in  : in std_logic; --! Para habilitar el motor
    enable_out : out std_logic; --! Salida que va al enable del L293D
    pwm, npwm  : out std_logic --! Salidas para los inputs del L293D
  );
end entity;

architecture arqpwm of pwm is
  type state is (STP, LEFT, RIGHT); --! Estatos de la fsm
  signal PS, NS  : state; --! Estados actual y siguiente
  signal clkl    : std_logic; --! Reloj más lento
  signal pwm_out : std_logic; --! Salioa del pwm
begin
  dvfff : entity work.divf(arqdivf) generic map (2500) port map(clk, clkl);
  --! Entidad para el control del pwm, corresponde a 1/5 del ciclo de dvfff
  epwm : entity work.senal(arqsenal) port map(clkl, 500, pwm_out);

  --! Proceso para actualizar el estado actual
  fsm_update : process (rst, clkl)
  begin
    if rst = '0' then
      PS <= STP;
    elsif rising_edge(clkl) then
      PS <= NS;
    end if;
  end process;

  --! Proceso para la lógica del cambio de estado.
  fsm : process (PS, enable_in, dir, pwm_out)
  begin
    case PS is
        -- Estado STP (Stop), el motor no está encendido
        -- Si enable_in se habilita:
        --     Si dir es 1, gira a la derecha.
        --     Si dir es 0, gira a la izquierda.
      when STP =>
        if enable_in = '1' and dir = '1' then
          NS <= RIGHT;
        elsif enable_in = '1' and dir = '0' then
          NS <= LEFT;
        else
          NS <= STP;
        end if;
        pwm        <= '0';
        npwm       <= '0';
        enable_out <= '0';

        -- Estado LEFT, el motor gira a la izquierda
        -- Si cambia la dirección, para a RIGHT
        -- Si se deshabilita, regresa a STP
      when LEFT =>
        if enable_in = '0' then
          NS <= STP;
        elsif enable_in = '1' and dir = '1' then
          NS <= RIGHT;
        else
          NS <= LEFT;
        end if;

        pwm        <= '0';
        npwm       <= pwm_out;
        enable_out <= '1';

        -- Estado RIGHT, el motor gira a la derecha
        -- Si cambia la dirección, para a LEFT
        -- Si se deshabilita, regresa a STP
      when RIGHT =>
        if enable_in = '0' then
          NS <= STP;
        elsif enable_in = '1' and dir = '0' then
          NS <= LEFT;
        else
          NS <= RIGHT;
        end if;
        pwm        <= pwm_out;
        npwm       <= '0';
        enable_out <= '1';

      when others =>
        pwm        <= '0';
        npwm       <= '0';
        enable_out <= '0';
        NS         <= STP;
    end case;
  end process;
end architecture;