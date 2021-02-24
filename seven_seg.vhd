library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

--! This is a description
--! of the entity.
entity seven_segment is port(
    clk: in std_logic; --20 MHz clock
    number : in std_logic_vector(15 downto 0);
    seven_segement : out std_logic_vector(6 downto 0); --drives the cathode 
    seven_anode : out std_logic_vector(3 downto 0) --drives the anode
);
end entity;

architecture  test of seven_segment is

constant refresh_count : integer := 100000;
signal refresh : unsigned(17 downto 0):=(others=>'0');
signal update : std_logic;
signal anode : std_logic_vector(3 downto 0) :="1110"; 
signal seven_seg : std_logic_vector(3 downto 0);
signal seven_seg_int :std_logic_vector(6 downto 0);
begin

seven_anode(3 downto 0) <= anode;

seven_segement <= not(seven_seg_int);
--seven_anode(4) <= '1'; 
process(clk)
begin 
    if rising_edge(clk) then
        if update = '1' then
            anode <= anode(anode'high-1 downto anode'low) & anode(anode'high);
        end if;
    end if;
end process;   

process(clk)
begin
    if rising_edge(clk) then
        case anode is 
            when "1110" =>
                seven_seg <= number(3 downto 0);
            when "1101" => 
                seven_seg <= number(7 downto 4);
            when "1011" =>
                seven_seg <= number(11 downto 8);
            when "0111" => 
                seven_seg <= number(15 downto 12);
            when others => null;
        end case;
    end if;
end process;

process(clk)
begin
    if rising_edge(clk) then 
        if (refresh = refresh_count) then 
            refresh <= (others =>'0');
            update <= '1';
        else
            refresh <= refresh + 1;
            update <= '0';
        end if;
    end if;
end process;

process(seven_seg)
begin
    case seven_seg is
    when "0000" => seven_seg_int <= "0111111"; -- "0"     
    when "0001" => seven_seg_int <= "0000110"; -- "1" 
    when "0010" => seven_seg_int <= "1011011"; -- "2" 
    when "0011" => seven_seg_int <= "1001111"; -- "3" 
    when "0100" => seven_seg_int <= "1100110"; -- "4" 
    when "0101" => seven_seg_int <= "1101101"; -- "5" 
    when "0110" => seven_seg_int <= "1111100"; -- "6" 
    when "0111" => seven_seg_int <= "0000111"; -- "7" 
    when "1000" => seven_seg_int <= "1111111"; -- "8"     
    when "1001" => seven_seg_int <= "1100111"; -- "9" 
    when "1010" => seven_seg_int <= "0000010"; -- a
    when "1011" => seven_seg_int <= "1100000"; -- b
    when "1100" => seven_seg_int <= "0110001"; -- C
    when "1101" => seven_seg_int <= "1000010"; -- d
    when "1110" => seven_seg_int <= "0110000"; -- E
    when others => seven_seg_int <= "0111000"; -- F
    end case;
end process;

end architecture; 