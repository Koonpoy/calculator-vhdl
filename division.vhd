Library ieee;
Use ieee.std_logic_1164.All;
Use ieee.numeric_std.All;
Use IEEE.STD_LOGIC_UNSIGNED.All;


entity division is
	generic ( N : natural := 5);
	port(
			CLK: in std_logic ;
			RST_N : in std_logic ;
			START : in std_logic ;
			A				: in  std_logic_vector(N-1 downto 0) := (others => '0') ;
			B				: in  std_logic_vector(N-1 downto 0) := (others => '0') ; 
			Q  				: out std_logic_vector(N-1 downto 0) := (others => '0') ; -- Result is Quotient and Remainder
			R					: out std_logic_vector(2*N-1 downto 0) := (others => '0') ;
			DONE				: out std_logic := '0' );

end division ; 

architecture behave of division is
	
	type state_type is (s0,s1) ;
	signal data_remainder : std_logic_vector (2 * N  downto 0) ; -- data_Q and data_R is Result of Q and R
	signal data_divisor : std_logic_vector (2 * N - 1 downto 0) ;
	signal data_Q : std_logic_vector (N-1 downto 0) ; 
	signal state : state_type := s0 ; 
	signal bitcounter : integer := 0 ; 
	signal P_done : std_logic := '0' ; 
	signal S_start : std_logic := '1' ; 
	
	begin 
	S_start <= START ;
	
	process(CLK,RST_N,START)
	
	begin
		
		if RST_N = '0' then
			state <= s0 ; 
			bitcounter <= 0 ; 
			R <= (others => '0') ; 
			data_remainder <= (others => '0') ; 
			data_divisor <= (others => '0') ;  
			Q <= (others => '0') ; 
		
		elsif rising_edge(CLK) then
			case state is 
			
				when s0 =>
					-- start = 1
					if S_start = '0' then
					
						if (A = 0) or (B = 0) then
						
							data_remainder <= (others => '0') ; 
							data_divisor <= (others => '0') ; 
							Q <= (others => '0')  ;
							DONE <= '1' ;
							
						
						else
						
							data_remainder (N-1 downto 0) <= A ; -- Dividend
							data_divisor (2*N-1 downto N) <= B ; -- Divisor
							state <= s1 ; 
						 
						end if;
					
					else 
					state <= s0;
					DONE <= '0' ; 
					
					end if ;
					
				when s1 =>
				
					if bitcounter <= (N + 1) then 
				
					-- Subtract Divisor and Dividend
					
						data_remainder <= data_remainder - data_divisor ; 
					  
					  if signed(data_remainder) < 0   then
					--if data_remainder(2*N-1) = '1'  then   --negative 
						
						data_remainder <= data_remainder + data_divisor ;
						
						--shift left Quotient
						data_Q <= std_logic_vector(shift_left(unsigned(data_Q),1)) ;
						
						--shift right Divisor
						data_divisor <= std_logic_vector(shift_right(unsigned(data_divisor),1)) ;
							
								
					
						bitcounter <= (bitcounter + 1) ;
						
						state <= s1 ; 
						
					else
					
						R <= data_remainder(2*N-1 downto 0) ;
					
						data_Q <= std_logic_vector(shift_left(unsigned(data_Q),1)) ;
					
						data_Q(0) <= '1' ;
						
						data_divisor <= std_logic_vector(shift_right(unsigned(data_divisor),1)) ;
							
						bitcounter <= (bitcounter + 1) ;
						
						state <= s1 ;
						
					
					end if;
					
					else 
						
						Q <= data_Q ; --Quotient

						data_remainder <= (others => '0') ;
						data_divisor <= (others => '0') ;
						data_Q <= (others => '0') ;
						bitcounter <= 0 ;
						DONE <= '1' ;
						state <= s0 ;
						
						
					end if;
		
				
				
			end case ; 	
			
		end if ;	

	end process ; 			
			
end behave ; 			

		
		
		
		
	
	
	
