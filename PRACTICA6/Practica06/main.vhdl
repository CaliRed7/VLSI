--MODULO MAIN
--Este módulo principal conecta el sensor de ultrasonido, el convertidor de números a BCD (bcd2ss7),
-- y los displays de 7 segmentos. Gestiona las señales de entrada y salida, activando el sensor, 
-- midiendo la distancia y mostrando los resultados en los displays.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Definición de la entidad principal main.
-- clk: Señal de reloj que controla todo el sistema.
-- reset: Señal que reinicia el sistema.
-- echo: Señal de entrada del eco desde el sensor de ultrasonido.
-- trigger: Señal de salida para activar el sensor de ultrasonido.
-- display1, display2, display3: Salidas para los displays de 7 segmentos que muestran las decenas, centenas y unidades.
-- led_out: Señal de salida en formato binario que muestra la distancia en LEDs (8 bits).
entity main is
  port (
    clk   : in std_logic; --Señal de reloj
    reset : in std_logic; --Señal de reinicio del sistema
    -- Parte sensor
    echo    : in std_logic; --! Entrada del echo del sensor
    trigger : out std_logic;-- Señal de activación del sensor (trigger).
    -- Displays
    display1 : out std_logic_vector(6 downto 0); --! Decenas
    display2 : out std_logic_vector(6 downto 0); --! Centenas
    display3 : out std_logic_vector(6 downto 0); --! Unidades
    led_out  : out std_logic_vector(7 downto 0) -- Señal de salida binaria que representa la distancia medida en LEDs.
  );
end entity main;


-- Arquitectura principal del sistema. Conecta las diferentes partes: sensor de ultrasonido, convertidor BCD y displays.
architecture arqmain of main is
  signal distance   : integer := 0; -- Señal interna para almacenar la distancia medida por el sensor.
  signal bin_digits : std_logic_vector(27 downto 0); -- Señal interna que almacena los dígitos BCD convertidos.

  -- En VHDL, se utiliza la declaración de "component" cuando queremos reutilizar un diseño previamente
  -- definido en otro módulo. Esta declaración nos permite instanciar dicho diseño (componente) 
  -- dentro de otro, como en este caso. Declaramos los componentes para modularizar nuestro sistema, 
  -- manteniendo cada funcionalidad separada y reutilizable.

  -- Declaración del componente del sensor de ultrasonido.
  -- Este componente mide la distancia y emite un eco.
  -- Utilizamos la declaración del "component" porque este sensor es un bloque de funcionalidad independiente,
  -- y nos permite reutilizar este módulo en diferentes partes del diseño sin tener que volver a escribir el código.
  component ultrasonic is
    port (
      clk      : in std_logic; -- Señal de reloj.
      reset    : in std_logic; -- Señal de reinicio.
      echo     : in std_logic; -- Señal de eco del sensor.
      trigger  : out std_logic; -- Señal de activación del sensor.
      distance : out integer -- Salida de la distancia medida en centímetros.
    );
  end component ultrasonic;

  -- Declaración del componente bcd2ss7, que convierte el número en formato binario
  -- a su representación en BCD para ser mostrada en los displays de 7 segmentos.
  -- Utilizamos este componente para separar la lógica de conversión de binario a BCD, lo que hace
  -- que el código sea más limpio y modular. Además, podemos reutilizar este componente en otros diseños
  -- que también requieran convertir números binarios a BCD.
  component bcd2ss7 is
    port (
      number : in integer; -- Número a convertir a BCD.
      digits : out std_logic_vector(27 downto 0) -- Salida en BCD (4 bits por dígito, hasta 7 dígitos).
    );
  end component bcd2ss7;

   -- Declaración del componente display, que convierte un dígito BCD
  -- en una representación de 7 segmentos.
  -- Aquí utilizamos el componente para manejar la lógica que convierte un dígito BCD 
  -- en la configuración de segmentos para un display de 7 segmentos. Esto nos permite reutilizar
  -- este módulo en cada display y mantener el diseño más organizado.
  component display is
    port (
      bcd : in std_logic_vector(3 downto 0); -- Entrada BCD (4 bits).
      hex : out std_logic_vector(6 downto 0) -- Salida para controlar un display de 7 segmentos.
    );
  end component display;

  begin
  -- Asigna la distancia medida (en formato binario) a la salida de LEDs, representando la distancia en formato binario.
  led_out <= std_logic_vector(to_unsigned(distance, 8));

  -- Instancia del sensor de ultrasonido:
  -- Aquí estamos creando una instancia del componente "ultrasonic".
  -- Al instanciarlo, conectamos las señales internas de la entidad principal
  -- a las entradas y salidas del componente.
  -- Utilizamos "component" aquí porque queremos reutilizar un bloque de diseño específico (el sensor de ultrasonido).
  -- Esto modulariza el diseño y permite una separación de responsabilidades, facilitando el mantenimiento.
  sensor    : ultrasonic port map(clk, reset, echo, trigger, distance);
  
   -- Instancia del convertidor de número binario a BCD:
  -- Al igual que con el sensor de ultrasonido, aquí estamos instanciando el componente "bcd2ss7".
  -- Esto convierte la distancia medida en formato binario a BCD, que será utilizado
  -- para mostrar la distancia en los displays de 7 segmentos.
  -- Utilizamos el componente aquí para reutilizar el módulo de conversión, lo que facilita la organización
  -- del código y permite que la lógica de conversión esté separada del resto del sistema.
  converter : bcd2ss7 port map(distance, bin_digits);
  
  -- Instancias de los displays de 7 segmentos:
  -- Ahora instanciamos el componente "display" tres veces para controlar los tres displays.
  -- Cada instancia toma una porción de los dígitos BCD y los convierte
  -- en la representación de 7 segmentos.

  -- Display para las unidades (primeros 4 bits del vector BCD).
  -- Aquí instanciamos el componente "display" para controlar un display de 7 segmentos.
  -- Utilizamos componentes porque el módulo de control del display puede ser reutilizado
  -- en diferentes partes del sistema sin duplicar la lógica.
  digit1    : display port map(bin_digits(3 downto 0), display1);
  
   -- Display para las decenas (siguientes 4 bits del vector BCD).
  digit2    : display port map(bin_digits(7 downto 4), display2);
  
  -- Display para las centenas (siguientes 4 bits del vector BCD).
  digit3    : display port map(bin_digits(11 downto 8), display3);
end architecture;