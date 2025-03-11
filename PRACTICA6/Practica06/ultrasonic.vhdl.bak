library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--! Entidad para controlar el sensor HC-SR04 utilizando la FPGA DE10 Lite
entity ultrasonic is
  port (
    clk      : in std_logic; --! Entrada del reloj a 50[MHz]
    reset    : in std_logic; --! Entrada del reset
    echo     : in std_logic; --! Entrada del sensor echo
    trigger  : out std_logic; --! Salida del trigger
    distance : out integer := 0 --! Distancia en [cm]
  );
end entity ultrasonic;

architecture archultrasonic of ultrasonic is
  type state_type is (Wait_state, Echo_state); --! Estados del sensor
  signal PS                   : state_type := Wait_state; --! Estado actual de la FSM
  signal NS                   : state_type := Wait_state; --! Siguiente estado en la FSM
  signal cuenta               : integer    := 0; --! Contador de flancos de subida
  signal centimeters          : integer    := 0; --! Conteo de centímetros
  signal distance_out         : integer    := 0; --! Señal de salida para la distancia
  signal past_echo, sync_echo : std_logic  := '0'; --! Auxiliar para el sensor echo
begin
  --! Proceso para realizar el cambio del estado de la FSM en cada flanco de subida
  --! y su reinicio.
  state_machine : process (clk, reset)
  begin
    if reset = '0' then
      PS <= Wait_state;
    elsif rising_edge(clk) then
      PS <= NS;
    end if;
  end process;

  --! Control de las entradas del echo
  echo_inputs : process (clk)
  begin
    if rising_edge(clk) then
      past_echo <= sync_echo;
      sync_echo <= echo;
    end if;
  end process;

  --! Lógica de la máquina de estados del sensor
  ultrasonic_sensor : process (clk, cuenta, past_echo, sync_echo, centimeters)
  begin
    if rising_edge(clk) then
      case PS is
        when Wait_state =>
          if cuenta >= 500 then
            trigger <= '0';
            NS      <= Echo_state;
            cuenta  <= 0;
          else
            trigger <= '1';
            NS      <= Wait_state;
            cuenta  <= cuenta + 1;
          end if;

        when Echo_state =>
          if past_echo = '0' and sync_echo = '1' then
            cuenta      <= 0;
            centimeters <= 0;
          elsif past_echo = '1' and sync_echo = '0' then
            distance_out <= centimeters;
            cuenta       <= 0;
          elsif cuenta >= 2900 then -- Aprox 1cm usando un reloj de 50[MHz]
            if centimeters >= 3448 then
              NS     <= Wait_state;
              cuenta <= 0;
            else
              centimeters <= centimeters + 1;
              cuenta      <= 0;
            end if;
          else
            NS     <= Echo_state;
            cuenta <= cuenta + 1;
          end if;
          trigger <= '0';
      end case;
    end if;
  end process;
  distance <= distance_out;
end architecture;