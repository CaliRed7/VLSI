library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity main is
  port (
    clk   : in std_logic; --! Reloj de la tarjeta
    reset : in std_logic; --! Entrada del reset
    -- Parte sensor
    echo    : in std_logic; --! Entrada del echo del sensor
    trigger : out std_logic; --! Salida del trigger del sensor
    -- Displays
    display1 : out std_logic_vector(6 downto 0); --! Decenas
    display2 : out std_logic_vector(6 downto 0); --! Centenas
    display3 : out std_logic_vector(6 downto 0); --! Unidades
    led_out  : out std_logic_vector(7 downto 0) --! Salida en binario
  );
end entity main;

architecture arqmain of main is
  signal distance   : integer := 0;
  signal bin_digits : std_logic_vector(27 downto 0);

  component ultrasonic is
    port (
      clk      : in std_logic;
      reset    : in std_logic;
      echo     : in std_logic;
      trigger  : out std_logic;
      distance : out integer
    );
  end component ultrasonic;

  component bcd2ss7 is
    port (
      number : in integer;
      digits : out std_logic_vector(27 downto 0)
    );
  end component bcd2ss7;

  component display is
    port (
      bcd : in std_logic_vector(3 downto 0);
      hex : out std_logic_vector(6 downto 0)
    );
  end component;
begin
  led_out <= std_logic_vector(to_unsigned(distance, 8));
  sensor    : ultrasonic port map(clk, reset, echo, trigger, distance);
  converter : bcd2ss7 port map(distance, bin_digits);
  digit1    : display port map(bin_digits(3 downto 0), display1);
  digit2    : display port map(bin_digits(7 downto 4), display2);
  digit3    : display port map(bin_digits(11 downto 8), display3);
end architecture;