-- *******************************************************
-- **                      PDUA                         **
-- **              PROCESADOR DIDACTICO                 **
-- **    Arquitectura y Diseno de Sistemas Digitales    **
-- **            UNIVERSIDAD DE LOS ANDES               **
-- **       CMUA: Centro de Microelectronica            **
-- *******************************************************
-- ** Version  0.0 Junio 2007                           **
-- ** Revision 0.1 Noviembre 2007                       **
-- ** Revision 0.2 Marzo 2008                           **
-- *******************************************************
-- Descripcion:                 
--               ______________________________________
--              |                ______   _____        |
--              |               | ROM  | | RAM |       |
--              |               |______| |_____|       |
--              |    _________                         |
--       CLK -->|-->|         |                        |
--     Rst_n -->|-->|  PDUA   |----------------> D_out | 
--       INT -->|-->|         |<---------------- D_in  |    
--              |   |         |----------------> Dir   |    
--              |   |         |----------------> Ctrl  |  
--              |   |_________|                        |
--              |                                      |
--              |______________________________________|  

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity sistema is
    Port ( clk 	: in 	std_logic;
           rst_n 	: in 	std_logic;
           int 	: in 	std_logic;
			  bus_data_out : out	std_logic_vector(7 downto 0));
end sistema;

architecture Behavioral of sistema is

component pdua is
    Port ( clk 	: in 	std_logic;
           rst_n 	: in 	std_logic;
           int 	: in 	std_logic;
           iom 	: out 	std_logic;
           rw 		: out 	std_logic;
           bus_dir 	: out 	std_logic_vector(7 downto 0);
           bus_data_in : in 	std_logic_vector(7 downto 0);
			  bus_data_out : out	std_logic_vector(7 downto 0));
end component;

component ROM is
    Port ( cs,rd	: in std_logic;
           dir 	: in std_logic_vector(4 downto 0);
           data 	: out std_logic_vector(7 downto 0));
end component;

component RAM is
    Port ( cs,rw 	: in 	std_logic;
           dir 	: in 	std_logic_vector(2 downto 0);
           data_in 	: in 	std_logic_vector(7 downto 0);
			  data_out 	: out std_logic_vector(7 downto 0));
end component;
-------------------------------------------------------
component multiplicador_IOM is
    Port ( clk_M, IOM_M, cs_M	: in	std_logic;
           A_M, B_M				: in	std_logic_vector(7 downto 0);
           product_out_M		: out std_logic_vector(15 downto 0));			  
end component;

signal rwi,cs_ROM,cs_RAM,iom	: std_logic;
signal datai,datao,diri			: std_logic_vector(7 downto 0);
-------------------------------------------------------
signal A_MULT_s, B_MULT_s			: std_logic_vector(7 downto 0);
signal C_MULT_s						: std_logic_vector(15 downto 0);
signal cs_MULT_s, iom_s				: std_logic;

begin

U1: pdua 	port map (clk,rst_n,int,iom,rwi,diri,datai,datao);
U2: ROM  	port map (cs_ROM,rwi,diri(4 downto 0),datai);
U3: RAM 		port map (cs_RAM,rwi,diri(2 downto 0),datao,datai);
-------------------------------------------------------
U4: multiplicador_IOM	port map (clk, iom_s, cs_MULT_s, A_MULT_s, B_MULT_s, C_MULT_s);

bus_data_out <= datao;
-- Decodificador
cs_ROM <= not diri(7);
cs_RAM <= diri(7); 
-------------------------------------------------------
cs_MULT_s <= diri(7) AND diri(6) AND diri(5) AND diri(4) AND diri(3) AND diri(2) AND diri(1) AND diri(0); -- Por tener solo un periferico

end Behavioral;