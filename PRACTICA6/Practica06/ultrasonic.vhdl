--MODULO ULTRASONIC
-- Este módulo controla el sensor de ultrasonido HC-SR04 mediante una Máquina de Estados Finita (FSM).
-- El sensor de ultrasonido mide la distancia basándose en el tiempo que tarda el eco en volver tras el disparo del trigger.
-- La FSM se encarga de enviar el trigger, esperar el eco y calcular la distancia.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Definición de la entidad ultrasonic.Entidad para controlar el sensor HC-SR04 utilizando la FPGA DE10 Lite
-- clk: Señal de reloj del sistema, generalmente a 50 MHz.
-- reset: Señal de reinicio para restablecer el estado del sistema.
-- echo: Señal de entrada que proviene del sensor ultrasonido, indicando el tiempo del eco.
-- trigger: Señal de salida que activa el sensor (envía el pulso).
-- distance: Salida que contiene la distancia medida en centímetros[2].
entity ultrasonic is
  port (
    clk      : in std_logic; -- Reloj principal del sistema a 50[MHz]
    reset    : in std_logic; -- Señal de reset que reinicia el sistema.
    echo     : in std_logic; -- Señal de entrada del eco del sensor de ultrasonido.
    trigger  : out std_logic; -- Señal de salida que activa el sensor.
    distance : out integer := 0 -- Distancia medida en centímetros, calculada a partir del tiempo del eco (CM)
  );
end entity ultrasonic;

-- Arquitectura que implementa la FSM  para controlar el sensor de ultrasonido.
-- Se definen dos estados: Wait_state (espera) y Echo_state (medición del eco).
architecture archultrasonic of ultrasonic is
-- Definición de los posibles estados de la FSM.
  type state_type is (Wait_state, Echo_state); 
  signal PS                   : state_type := Wait_state;-- Estado presente (PS: Present State).
  signal NS                   : state_type := Wait_state;-- Próximo estado (NS: Next State).
  signal cuenta               : integer    := 0;-- Contador que se utiliza para medir el tiempo y la distancia.
  signal centimeters          : integer    := 0;-- Variable que almacena la distancia medida en centímetros.
  signal distance_out         : integer    := 0;-- Señal de salida que contiene la distancia calculada.
  signal past_echo, sync_echo : std_logic  := '0';-- Señales auxiliares para detectar cambios en el eco.
begin
  -- Proceso que controla la transición de estados de la FSM.
  -- En cada ciclo de reloj, se evalúa si la FSM debe cambiar de estado.
  state_machine : process (clk, reset)
  begin
    if reset = '0' then -- Si se recibe una señal de reset, se vuelve al estado de espera.
      PS <= Wait_state;
    elsif rising_edge(clk) then -- En cada flanco de subida del reloj, se evalúa el próximo estado.
      PS <= NS; -- El estado actual se actualiza al próximo estado.
    end if;
  end process;

  -- Proceso que maneja las señales de eco, sincronizando el eco con el reloj del sistema.
  echo_inputs : process (clk)
  begin
    if rising_edge(clk) then
      past_echo <= sync_echo;-- Guarda el valor anterior de la señal de eco.
      sync_echo <= echo; -- Sincroniza la señal de eco con el reloj.
    end if;
  end process;
  
  
-- Proceso principal de la FSM que controla el sensor de ultrasonido
  ultrasonic_sensor : process (clk, cuenta, past_echo, sync_echo, centimeters)
  begin
    if rising_edge(clk) then
      case PS is
		-- Estado de espera (Wait_state):
        -- En este estado, el sistema espera que el contador alcance un valor determinado 
        -- antes de enviar la señal de trigger.
        when Wait_state =>
          if cuenta >= 500 then -- Si el contador ha alcanzado el valor de espera (500 ciclos).
            trigger <= '0'; -- Desactiva la señal de trigger (el pulso de activación del sensor se ha enviado).
            NS      <= Echo_state; -- Cambia al estado de medición del eco.
            cuenta  <= 0; -- Reinicia el contador.
          else
            trigger <= '1'; -- Activa la señal de trigger, enviando el pulso al sensor.
            NS      <= Wait_state;-- Permanece en el estado de espera.
            cuenta  <= cuenta + 1; -- Incrementa el contador en cada ciclo de reloj.
          end if;

			 -- Estado de medición del eco (Echo_state):
        -- En este estado, el sistema mide el tiempo que tarda en llegar la señal de eco.
        when Echo_state =>
          if past_echo = '0' and sync_echo = '1' then --Detecta el flanco de subida del eco.
            cuenta      <= 0; -- Reinicia el contador al detectar el inicio del eco.
            centimeters <= 0; -- Reinicia el cálculo de la distancia.
          elsif past_echo = '1' and sync_echo = '0' then -- Detecta el flanco de bajada del eco.
            distance_out <= centimeters; -- Almacena la distancia medida cuando termina el eco.
            cuenta       <= 0;  -- Reinicia el contador.
          elsif cuenta >= 2900 then -- Cada 2900 ciclos equivalen a 1 cm (basado en la frecuencia del reloj de 50 MHz).
            if centimeters >= 3448 then -- Limita la distancia máxima a 3448 cm.
              NS     <= Wait_state; -- Si se supera la distancia máxima, vuelve al estado de espera.
              cuenta <= 0; -- Reinicia el contador.
            else
              centimeters <= centimeters + 1;-- Incrementa la distancia medida en 1 cm.
              cuenta      <= 0; -- Reinicia el contador.
            end if;
          else
            NS     <= Echo_state; -- Permanece en el estado de medición del eco.
            cuenta <= cuenta + 1; -- Desactiva la señal de trigger mientras se mide el eco.
          end if;
          trigger <= '0';
      end case;
    end if;
  end process;
  distance <= distance_out; -- Asigna la distancia medida a la señal de salida "distance".
end architecture;