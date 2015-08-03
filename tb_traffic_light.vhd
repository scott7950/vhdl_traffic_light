library ieee;
use ieee.std_logic_1164.all;
use std.env.all;
use ieee.math_real.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity tb_traffic_light is
generic (
    CNT : integer := 10 
);
end entity tb_traffic_light;

architecture behavioral of tb_traffic_light is
component traffic_light is
generic (
    ONE_SEC_CNT : integer := 50000000;
    SEC_CNT : integer := 20
);
port (
    clk                              : in  std_logic ;
    rst_n                            : in  std_logic ;
    traffic_east_west_light_green    : out std_logic ;
    traffic_east_west_light_yellow   : out std_logic ;
    traffic_east_west_light_red      : out std_logic ;
    traffic_east_west_arrow_green    : out std_logic ;
    traffic_east_west_arrow_red      : out std_logic ;
    traffic_north_south_light_green  : out std_logic ;
    traffic_north_south_light_yellow : out std_logic ;
    traffic_north_south_light_red    : out std_logic ;
    traffic_north_south_arrow_green  : out std_logic ;
    traffic_north_south_arrow_red    : out std_logic 
);
end component;

signal clk                              : std_logic := '0' ;
signal rst_n                            : std_logic ;
signal traffic_east_west_light_green    : std_logic ;
signal traffic_east_west_light_yellow   : std_logic ;
signal traffic_east_west_light_red      : std_logic ;
signal traffic_east_west_arrow_green    : std_logic ;
signal traffic_east_west_arrow_red      : std_logic ;
signal traffic_north_south_light_green  : std_logic ;
signal traffic_north_south_light_yellow : std_logic ;
signal traffic_north_south_light_red    : std_logic ;
signal traffic_north_south_arrow_green  : std_logic ;
signal traffic_north_south_arrow_red    : std_logic ;

begin
u_traffic_light: traffic_light generic map (
    ONE_SEC_CNT => 10,
    SEC_CNT => CNT
) port map (
    clk                              => clk                              ,
    rst_n                            => rst_n                            ,
    traffic_east_west_light_green    => traffic_east_west_light_green    ,
    traffic_east_west_light_yellow   => traffic_east_west_light_yellow   ,
    traffic_east_west_light_red      => traffic_east_west_light_red      ,
    traffic_east_west_arrow_green    => traffic_east_west_arrow_green    ,
    traffic_east_west_arrow_red      => traffic_east_west_arrow_red      ,
    traffic_north_south_light_green  => traffic_north_south_light_green  ,
    traffic_north_south_light_yellow => traffic_north_south_light_yellow ,
    traffic_north_south_light_red    => traffic_north_south_light_red    ,
    traffic_north_south_arrow_green  => traffic_north_south_arrow_green  ,
    traffic_north_south_arrow_red    => traffic_north_south_arrow_red    
);

clk <= not clk after 10 ns;

process
begin
    rst_n <= '1';
    wait for 100 ns;
    rst_n <= '0';
    wait for 100 ns;
    rst_n <= '1';
    wait;
end process;

process
begin
    wait for 20 us;
    finish(0);
end process;

end behavioral;

