library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.all;


entity addsub is 
generic (N : integer := 5);
port( START,CLK,RST_N : in std_logic ;
		A,B       : in std_logic_vector(N-1 downto 0) ;
		M				 : in std_logic := '0' ;
		DONE_Control : in std_logic := '0' ;
		R				 : out std_logic_vector(N downto 0);
		DONE 			 : out std_logic 

);

end addsub ;



architecture behave of addsub is


type statetype is (s0,s1);
signal data_A,data_B : std_logic_vector(N downto 0) := (others => '0');
signal data_R : std_logic_vector(N downto 0) := (others => '0');
signal state : statetype := s0 ;
signal S_start : std_logic := '0' ;
signal c : STD_LOGIC_VECTOR(N downto 0);
signal i : integer := 0;



begin
	S_start <= START ; 
	
	
	process (CLK,RST_N,S_start)
	begin
		
		if RST_N = '0' then --async reset
			-- set data to zero
			data_A <= (others => '0');
			data_B <= (others => '0');
			R <= (others => '0');
			state  <= s0 ;
			
		elsif rising_edge(CLK) then
			
			case state is			
			
				when s0 =>
					DONE <= '0' ;
					if S_start = '0'  then
						if A < B and M = '1' then
							data_A <= (others => '0');
							data_B <= (others => '0');
							R <= (others => '0');
							DONE <= '1' ;

						
						else
							c(0) <= M ;
							data_A(N-1 downto 0) <= A ;
							data_B(N-1 downto 0) <= B ;
							state <= s1 ;
							
						end if;
					end if ;
				when s1 =>
				
						if i < N+1 then
						

							data_R(i) <= (data_A(i) xor (data_B(i) xor M)) xor c(i);  -- SUB m=1 / ADD m=0
							c(i+1) <= ((data_A(i) xor(data_B(i) xor M)) and c(i)) or (data_A(i) and (data_B(i) xor M));
							

							i <= i + 1 ; 
							
							state <= s1 ;
						
						else 
							i <= 0;
							R <= data_R ; --Result 
							DONE <= '1' ;
							state <= s0;
						
						end if ;
						
				end case ;
			end if;
		end process ;
end behave ;