library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity ControlStart is 
port( 
		CLK       : in std_logic;
		RST_N     : in std_logic;
		Operation : in std_logic_vector(1 downto 0) ;
		START		 : in std_logic := '1';
		start_addsub : out std_logic := '1' ; 
		start_mul : out std_logic := '1';
		start_div : out std_logic := '1';
		M			 : out std_logic ;
		DONE      : out std_logic := '0'
);


end ControlStart ;

architecture behave of ControlStart is

--Signal
signal S_start : std_logic := '1' ;
signal mControl : std_logic := '0';


begin
S_start <= START ; 
process(RST_N,CLK,S_start)
begin

	if RST_N = '0' then
		--Reset
		start_div <=  '1';
		start_mul <=  '1';
		start_addsub <=  '1';
		mControl  <=  '0';
		
	elsif rising_edge(CLK) then
		
		if Operation = "10" then --sub
			mControl <= '1' ;
			M <= mControl ;
			
		elsif Operation = "11" then --add
			mControl <= '0' ;
			M <= mControl ;
		
		end if ;
			
	
		if S_start = '0' then			
		
			if Operation = "00" then --division
				start_div <= '0' ;
				M <= mControl ;
				 
				
			elsif Operation = "01" then --multi
				start_mul <= '0';
				M <= mControl ;
				 
				
			elsif Operation = "10" then --sub
				start_addsub <= '0';

				
			else 
				
				start_addsub <= '0'; --add
	
			end if ;
		
		else 
				start_div <=  '1';
				start_mul <=  '1';
				start_addsub <=  '1';
			
		end if;
	
		end if;
	end process;
end behave ;