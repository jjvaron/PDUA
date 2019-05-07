-- multiplicador_IOM testebench
-- Autores: Jelitza Varón
--				Sebastián Parrado
-------------------------------------------------------
LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
-------------------------------------------------------
ENTITY multiplicador_IOM_tb IS
	GENERIC ( N		:	INTEGER	:= 8);
END ENTITY multiplicador_IOM_tb;
-------------------------------------------------------
ARCHITECTURE testbench OF multiplicador_IOM_tb IS
	SIGNAL clk_M_tb	:  STD_LOGIC	:=	'0';
	SIGNAL rst_M_tb	:	STD_LOGIC	:= '1';
	SIGNAL IOM_M_tb	:  STD_LOGIC	:=	'1';
	SIGNAL cs_M_tb		:  STD_LOGIC	:=	'0';
	SIGNAL A_M_tb    	:  STD_LOGIC_VECTOR(N-1 DOWNTO 0)	:="11111111";
	SIGNAL B_M_tb		:  STD_LOGIC_VECTOR(N-1 DOWNTO 0)	:="11111111";
	SIGNAL product_out_M_tb	:  STD_LOGIC_VECTOR((2*N)-1 DOWNTO 0);
-------------------------------------------------------
BEGIN
	DUT: ENTITY work.multiplicador_IOM
	PORT MAP(clk_M	=> clk_M_tb,
				IOM_M	=> IOM_M_tb,
				cs_M		=>	cs_M_tb,
				A_M		=> A_M_tb,
				B_M		=> B_M_tb,
				product_out_M	=>	product_out_M_tb);
	
	-- CLOCK GENERATION
	clk_M_tb <= NOT(clk_M_tb) AFTER 50 ns;
	-- TEST VECTORS
	IOM_M_tb <= '0'	AFTER 200 ns,
					'1'	AFTER 1200 ns,
					'0'  AFTER 1250 ns,
					'1'	AFTER 2400 ns,
					'0'  AFTER 2450 ns;
						
--	IOM_M_tb <= '0'	AFTER 200 ns;
	
	cs_M_tb	 <= '1'	AFTER 200 ns;
	
	A_M_tb	 <= 	"00000111" AFTER 200 ns,
						"00000100" AFTER 1200 ns,
						"01010000" AFTER 2400 ns;
				 
	B_M_tb	 <= 	"00011100" AFTER 200 ns,
						"00000100" AFTER 1200 ns,
						"11010000" AFTER 2400 ns;
END ARCHITECTURE;