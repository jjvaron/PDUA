-- ***********************************************
-- **  PROYECTO PDUA                            **
-- **  Modulo: 	RAM                           **
-- **  Creacion:	Julio 07								**
-- **  Revisi�n:	Marzo 08								**
-- **  Por :		MGH-DIMENDEZ-CMUA-UNIANDES 	**
-- ***********************************************
-- Descripcion:
-- RAM (Buses de datos independientes in-out)
--                       cs  
--                   _____|_
--            rw -->|       |
-- dir(direccion)-->|       |--> data_out
--       data_in -->|_______|   
--        
-- ***********************************************
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RAM is
    Port ( cs,rw	   : in std_logic;
           dir 	   : in std_logic_vector(2 downto 0);
           data_in 	: in std_logic_vector(7 downto 0);
			  data_out 	: out std_logic_vector(7 downto 0);
			  ---------------------------------------------
			  A_MULT_RAM		: out std_logic_vector(7 downto 0);
			  B_MULT_RAM		: out std_logic_vector(7 downto 0);
			  C_MULT_RAM		: in std_logic_vector(15 downto 0));
end RAM;

architecture Behavioral of RAM is

type memoria is array (7 downto 0) of std_logic_vector(7 downto 0);
signal mem: memoria;

begin
process(cs,rw,dir,data_in,mem)
begin
if cs = '1' then
   if rw = '0' then  -- Read
       case dir is
	    when "000" => data_out <= mem(0);
	    when "001" => data_out <= mem(1);
	    when "010" => data_out <= mem(2);		
	    when "011" => data_out <= mem(3);		
	    --when "100" => data_out <= mem(4);-- MULT A
	    --when "101" => data_out <= mem(5);-- MULT B
	    when "110" => data_out <= mem(6);	-- MULT C LSB
	    when "111" => data_out <= mem(7);	-- MULT C MSB 
	    when others => data_out <= (others => 'X'); 
       end case;
   else 					-- Write
       case dir is
	    when "000" => mem(0) <= Data_in;
	    when "001" => mem(1) <= Data_in;
	    when "010" => mem(2) <= Data_in;
	    when "011" => mem(3) <= Data_in;
	    when "100" => mem(4) <= Data_in;	-- MULT A
	    when "101" => mem(5) <= Data_in;	-- MULT B
	    --when "110" => mem(6) <= Data_in;	-- MULT C LSB
	    --when "111" => mem(7) <= Data_in;	-- MULT C MSB 
	    when others => mem(5) <= Data_in;	-- Cambiado, porque no puede accecer a mem(7)
       end case;
    end if;
else data_out <= (others => 'Z');
end if;  
end process;
mem(6) <= C_MULT_RAM (7 DOWNTO 0);
mem(7) <= C_MULT_RAM (15 DOWNTO 8);

A_MULT_RAM <= mem(4);
B_MULT_RAM <= mem(5);
end Behavioral;