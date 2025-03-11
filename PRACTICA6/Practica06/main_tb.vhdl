library ieee;
use ieee.std_logic_1164.all;

entity main_tb is
end entity main_tb;

architecture tb_arch of main_tb is
  -- Component declaration
  component main is
    port (
      clk     : in std_logic;
      reset   : in std_logic;
      echo    : in std_logic;
      trigger : out std_logic;
      led_out : out std_logic_vector(7 downto 0)
    );
  end component main;

  component ultrasonic is
    port (
      clk       : in std_logic;
      reset     : in std_logic;
      echo      : in std_logic;
      trigger   : out std_logic;
      echo_time : out integer
    );
  end component ultrasonic;

  -- Signal declarations
  signal clk     : std_logic := '0';
  signal reset   : std_logic := '0';
  signal echo    : std_logic := '0';
  signal trigger : std_logic;
  signal led_out : std_logic_vector(7 downto 0);
begin
  reset <= '1';
  -- Clock process
  process
  begin
    while now < 500 ms loop
      clk <= '0';
      wait for 20 ns;
      clk <= '1';
      wait for 20 ns;
    end loop;
    wait;
  end process;

  -- Stimulus process
  process
  begin
    echo <= '0';
    wait for 1 ms;
    echo <= '1';
    wait for 15 ms;

    echo <= '0';
    wait for 120 ms;
    echo <= '1';
    wait for 5 ms;

    echo <= '0';

    wait;
  end process;

  -- Instantiate the main entity
  uut : main
    port map (
      clk     => clk,
      reset   => reset,
      echo    => echo,
      trigger => trigger,
      led_out => led_out
    );
end architecture tb_arch;