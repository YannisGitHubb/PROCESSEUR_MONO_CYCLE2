library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
---------------------------------------------------------
entity memoire2 is
port (
CLK : in std_logic;
Addr : in std_logic_vector(5 downto 0);
DataOut : out std_logic_vector(31 downto 0));
end memoire2;
---------------------------------------------------------
architecture Arch of memoire2 is 
-- Declaration Type Tableau Memoire 
	type table is array(63 downto 0) of 
	std_logic_vector(31 downto 0); 
	-- Fonction d'Initialisation du Banc de Registres 
	function init_memoire return table is 
	variable result : table; 
	begin 
	for i in 63 downto 0 loop 
	result(i) := (others=>'0'); 
	end loop;  
	result(15):=X"00000030"; 
	return result; 
	end init_memoire; -- D?claration et Initialisation du Banc de Registres 16x32 bits
	signal instru: table:=init_memoire; 
begin 
-- Lecture de la memoire 
DataOut <= instru(to_integer(unsigned(Addr)));
end arch;
