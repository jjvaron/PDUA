-- multiplicador_IOM
-- Autores: Sebastián Parrado
--				Jelitza Varón
-------------------------------------------------------
LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
-------------------------------------------------------
ENTITY multiplicador_IOM IS
	GENERIC( N		:	INTEGER	:= 8);
   PORT   (clk_M,cs_M,IOM_M:	IN		STD_LOGIC;
			  A_M					:	IN		STD_LOGIC_VECTOR(N-1 DOWNTO 0);
           B_M					:	IN		STD_LOGIC_VECTOR(N-1 DOWNTO 0);
           product_out_M	:	OUT	STD_LOGIC_VECTOR(N-1 DOWNTO 0));
END ENTITY multiplicador_IOM;
-------------------------------------------------------
ARCHITECTURE functional OF multiplicador_IOM IS
	SIGNAL  A_s				: STD_LOGIC_VECTOR(N-1 DOWNTO 0);
  	SIGNAL  B_s				: STD_LOGIC_VECTOR(N-1 DOWNTO 0);
	SIGNAL  product_s		: STD_LOGIC_VECTOR(N-1 DOWNTO 0);
	SIGNAL  ena_A, ena_B	: STD_LOGIC;
	SIGNAL  ena_A_NOT, ena_B_NOT	: STD_LOGIC;
-------------------------------------------------------
BEGIN
 
    ena_A     <= (A_M(N-1) OR (A_M(N-2)) OR (A_M(N-3)));
	 ena_A_NOT <= ((NOT(A_M(N-1))) AND (NOT(A_M(N-2))) AND (NOT(A_M(N-3))));
	 
    ena_B     <= ((B_M(N-1)) OR (B_M(N-2)) OR (B_M(N-3)));
    ena_B_NOT <= ((NOT(B_M(N-1))) AND (NOT(B_M(N-2))) AND (NOT(B_M(N-3))) AND (NOT(B_M(N-4))));
 
	PROCESS (clk_M,cs_M,A_M,B_M,A_s,B_s,product_s)
	BEGIN
		IF (cs_M = '1') THEN
			A_s <=  A_M;
			B_s <= B_M;
			product_s <= (OTHERS => '0');
		ELSIF ( (ena_A AND ena_B) = '0') THEN
			IF (rising_edge(clk_M)) THEN
			A_s <=  A_M;
			B_s <= B_M;
			
-------------------------------------------------------
--------- Bucle de repetición de la operación ---------

				looper: FOR i IN 0 TO N-1 LOOP
					IF (B_s(0) = '1') THEN			-- Si el LSB es 1
						product_s <= STD_LOGIC_VECTOR(unsigned(A_s)+unsigned(product_s)); -- C=A+C
						
					 
					    --  product_out_M <= "00000000";		
					  ELSIF ((IOM_M OR (A_s(N-1) OR B_s(0))) = '0') THEN
						   product_out_M <= product_s;
				  END IF;
				  
				
				A_s <= A_s(A_s'LEFT-1 DOWNTO 0) & '0';	-- Multiplicando A. Desplazamiento 1 bit a la izquierda
				B_s <= '0' & B_s(B_s'LEFT DOWNTO 1);	-- Multiplicador B. Desplzamiento 1 bit a la derecha
				END LOOP looper;
				
			END IF;
		END IF;
	END PROCESS;   
END ARCHITECTURE;