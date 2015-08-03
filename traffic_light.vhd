-----------------------------------------------------------------
--traffice light
-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity traffic_light is
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
end entity traffic_light;

architecture behavioral of traffic_light is
signal restart_cnt   : std_logic;
type traffic_status is (IDLE, EAST_WEST_LIGHT_GREEN, EAST_WEST_LIGHT_YELLOW, EAST_WEST_ARROW, NORTH_SOUTH_ARROW, NORTH_SOUTH_LIGHT_GREEN, NORTH_SOUTH_LIGHT_YELLOW);
signal status        : traffic_status;
signal status_nxt    : traffic_status;
signal status_ff1    : traffic_status;
--constant ONE_SEC_CNT : integer := 50000000;
signal one_sec_count : integer range 0 to ONE_SEC_CNT;
signal seconds_count : integer range 0 to SEC_CNT;

--function to convert boolean to std_logic
function to_stdulogic(V: Boolean) return std_ulogic is 
begin 
    if V then 
        return '1'; 
    else 
        return '0'; 
    end if;
end to_stdulogic; 

begin

process(clk, rst_n)
begin
    if(rst_n = '0') then
        one_sec_count <= 0;
    elsif(rising_edge(clk)) then
        if(restart_cnt = '1') then
            one_sec_count <= 0;
        elsif(one_sec_count = ONE_SEC_CNT) then
            one_sec_count <= 0;
        else
            one_sec_count <= one_sec_count + 1;
        end if;
    end if;
end process;

process(clk, rst_n)
begin
    if(rst_n = '0') then
        seconds_count <= 0;
    elsif(rising_edge(clk)) then
        if(restart_cnt = '1') then
            seconds_count <= 0;
        elsif(one_sec_count = ONE_SEC_CNT) then
            if(seconds_count = SEC_CNT) then
                seconds_count <= 0;
            else
                seconds_count <= seconds_count + 1;
            end if;
        end if;
    end if;
end process;

process(status, seconds_count, status_ff1)
begin
    if(status /= status_ff1) then
        status_nxt <= status;
    else
        case status is
            when IDLE                    => 
                status_nxt <= EAST_WEST_LIGHT_GREEN ;
            when EAST_WEST_LIGHT_GREEN   => 
                if(seconds_count = SEC_CNT) then
                    status_nxt <= EAST_WEST_LIGHT_YELLOW;
                else
                    status_nxt <= EAST_WEST_LIGHT_GREEN ;
                end if;
            when EAST_WEST_LIGHT_YELLOW  => 
                if(seconds_count = SEC_CNT) then
                    status_nxt <= EAST_WEST_ARROW;
                else
                    status_nxt <= EAST_WEST_LIGHT_YELLOW;
                end if;
            when EAST_WEST_ARROW         => 
                if(seconds_count = SEC_CNT) then
                    status_nxt <= NORTH_SOUTH_ARROW;
                else
                    status_nxt <= EAST_WEST_ARROW;
                end if;
            when NORTH_SOUTH_ARROW        => 
                if(seconds_count = SEC_CNT) then
                    status_nxt <= NORTH_SOUTH_LIGHT_GREEN;
                else
                    status_nxt <= NORTH_SOUTH_ARROW;
                end if;
            when NORTH_SOUTH_LIGHT_GREEN  => 
                if(seconds_count = SEC_CNT) then
                    status_nxt <= NORTH_SOUTH_LIGHT_YELLOW;
                else
                    status_nxt <= NORTH_SOUTH_LIGHT_GREEN;
                end if;
            when NORTH_SOUTH_LIGHT_YELLOW => 
                if(seconds_count = SEC_CNT) then
                    status_nxt <= EAST_WEST_LIGHT_GREEN;
                else
                    status_nxt <= NORTH_SOUTH_LIGHT_YELLOW;
                end if;
            when others                  => 
                status_nxt <= IDLE;
        end case;
    end if;
end process;

process(clk, rst_n)
begin
    if(rst_n = '0') then
        status <= IDLE;
    elsif(rising_edge(clk)) then
        status <= status_nxt;
    end if;
end process;

process(clk, rst_n)
begin
    if(rst_n = '0') then
        status_ff1 <= IDLE;
    elsif(rising_edge(clk)) then
        status_ff1 <= status;
    end if;
end process;

restart_cnt <= to_stdulogic(status /= status_ff1);

process(clk, rst_n)
begin
    if(rst_n = '0') then
        traffic_east_west_light_green <= '0';
    elsif(clk'event and clk = '1') then
        if(status = EAST_WEST_LIGHT_GREEN) then
            traffic_east_west_light_green <= '1';
        else
            traffic_east_west_light_green <= '0';
        end if;
    end if;
end process;

process(clk, rst_n)
begin
    if(rst_n = '0') then
        traffic_east_west_light_yellow <= '0';
    elsif(clk'event and clk = '1') then
        if(status = EAST_WEST_LIGHT_YELLOW) then
            traffic_east_west_light_yellow <= '1';
        else
            traffic_east_west_light_yellow <= '0';
        end if;
    end if;
end process;

process(clk, rst_n)
begin
    if(rst_n = '0') then
        traffic_east_west_light_red <= '1';
    elsif(clk'event and clk = '1') then
        if((status = EAST_WEST_LIGHT_GREEN) or (status = EAST_WEST_LIGHT_YELLOW)) then
            traffic_east_west_light_red <= '0';
        else
            traffic_east_west_light_red <= '1';
        end if;
    end if;
end process;

process(clk, rst_n)
begin
    if(rst_n = '0') then
        traffic_east_west_arrow_green <= '0';
        traffic_east_west_arrow_red <= '1';
    elsif(clk'event and clk = '1') then
        if(status = EAST_WEST_ARROW) then
            traffic_east_west_arrow_green <= '1';
            traffic_east_west_arrow_red <= '0';
        else
            traffic_east_west_arrow_green <= '0';
            traffic_east_west_arrow_red <= '1';
        end if;
    end if;
end process;

process(clk, rst_n)
begin
    if(rst_n = '0') then
        traffic_north_south_light_green <= '0';
    elsif(clk'event and clk = '1') then
        if(status = NORTH_SOUTH_LIGHT_GREEN) then
            traffic_north_south_light_green <= '1';
        else
            traffic_north_south_light_green <= '0';
        end if;
    end if;
end process;

process(clk, rst_n)
begin
    if(rst_n = '0') then
        traffic_north_south_light_yellow <= '0';
    elsif(clk'event and clk = '1') then
        if(status = NORTH_SOUTH_LIGHT_YELLOW) then
            traffic_north_south_light_yellow <= '1';
        else
            traffic_north_south_light_yellow <= '0';
        end if;
    end if;
end process;

process(clk, rst_n)
begin
    if(rst_n = '0') then
        traffic_north_south_light_red <= '1';
    elsif(clk'event and clk = '1') then
        if((status = NORTH_SOUTH_LIGHT_GREEN) or (status = NORTH_SOUTH_LIGHT_YELLOW)) then
            traffic_north_south_light_red <= '0';
        else
            traffic_north_south_light_red <= '1';
        end if;
    end if;
end process;

process(clk, rst_n)
begin
    if(rst_n = '0') then
        traffic_north_south_arrow_green <= '0';
        traffic_north_south_arrow_red <= '1';
    elsif(clk'event and clk = '1') then
        if(status = NORTH_SOUTH_ARROW) then
            traffic_north_south_arrow_green <= '1';
            traffic_north_south_arrow_red <= '0';
        else
            traffic_north_south_arrow_green <= '0';
            traffic_north_south_arrow_red <= '1';
        end if;
    end if;
end process;

end behavioral;

