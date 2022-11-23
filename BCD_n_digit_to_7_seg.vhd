library ieee;
use ieee.std_logic_1164.ALL;
use ieee.STD_LOGIC_ARITH.all;

entity BCD_n_digit_to_7_seg is
		Port ( 
				 start  : in  std_logic;
				 clk_i  : in  std_logic;	-- system clock
             rst_i  : in  std_logic; 	-- synchronous reset, active-high
				 --port result form calculator
				 result_addsub    : in std_logic_vector(9 downto 0) ;
				 result_mul   : in std_logic_vector(9 downto 0 );
				 result_div : in std_logic_vector(9 downto 0 );
				 result_rem : in std_logic_vector(7 downto 0 );
				 
				 AllDone : in std_logic;
				 Operation  : in std_logic_vector(1 downto 0):= (others => '0');

				 BCD_digit_1 : out STD_LOGIC_VECTOR (3 downto 0);
				 BCD_digit_2 : out STD_LOGIC_VECTOR (3 downto 0);
				 BCD_digit_3 : out STD_LOGIC_VECTOR (3 downto 0);
				
				 BCD_digit_R1 : out STD_LOGIC_VECTOR (3 downto 0);
				 BCD_digit_R2 : out STD_LOGIC_VECTOR (3 downto 0);
				 BCD_digit_R3 : out STD_LOGIC_VECTOR (3 downto 0)
				 );
					  
end BCD_n_digit_to_7_seg;

architecture Behavioral of BCD_n_digit_to_7_seg is

signal S_start : std_logic:= '1';
--Result
signal int_data_1 : integer := 0;
signal int_data_2 : integer:= 0;
signal int_data_3 : integer:= 0;
--Remainder
signal int_data_R1 : integer := 0;
signal int_data_R2 : integer:= 0;
signal int_data_R3 : integer:= 0;
--result
signal result_all : STD_LOGIC_VECTOR (9 downto 0) ;
signal remainder_all : STD_LOGIC_VECTOR (7 downto 0) ;

	begin
		process(clk_i,rst_i)
			begin
				if (rst_i='0' ) then  
					-- Result
					result_all <= (others => '0') ;
					remainder_all <=(others => '0');
					int_data_1 <= 0;
					int_data_2 <= 0;
					int_data_3 <= 0;
					-- Remainder
					int_data_R1 <= 0;
					int_data_R2 <= 0;
					int_data_R3 <= 0;
					
				 elsif (clk_i'event and clk_i='1' and AllDone = '1') then  
					--check use result
					case Operation is
                    when "00" =>
                        result_all   <= result_div;
                        remainder_all <= result_rem;
                    when "01" =>
                        result_all   <= result_mul;
                        remainder_all <= (others => '0');
                    when "10" =>
                        result_all   <= result_addsub;
                        remainder_all <= (others => '0');
                    when "11" =>
                        result_all   <= result_addsub;
                        remainder_all <= (others => '0');
                end case;
				
--					if AllDone = '1' then 
					
--					int_data_1 <= conv_integer(unsigned(result_all)) mod 10; -- 1st
--					int_data_2 <= ((conv_integer(unsigned(result_all)))/ 10) mod 10 ; -- 2nd
--					int_data_3 <= (conv_integer(unsigned(result_all))/ 100) ; -- 3rd
--
--						
--					int_data_R1 <= conv_integer(unsigned(remainder_all)) mod 10; -- 1st
--					int_data_R2 <= ((conv_integer(unsigned(remainder_all)))/ 10) mod 10 ; -- 2nd
--					int_data_R3 <= (conv_integer(unsigned(remainder_all))/ 100) ; -- 3rd

--					end if ;
				
				end if ;
				   
					int_data_1 <= conv_integer(unsigned(result_all)) mod 10; -- 1st
					int_data_2 <= ((conv_integer(unsigned(result_all)))/ 10) mod 10 ; -- 2nd
					int_data_3 <= (conv_integer(unsigned(result_all))/ 100) ; -- 3rd

						
					int_data_R1 <= conv_integer(unsigned(remainder_all)) mod 10; -- 1st
					int_data_R2 <= ((conv_integer(unsigned(remainder_all)))/ 10) mod 10 ; -- 2nd
					int_data_R3 <= (conv_integer(unsigned(remainder_all))/ 100) ; -- 3rd

						
					BCD_digit_1 <= conv_std_logic_vector(int_data_1, 4);
					BCD_digit_2 <= conv_std_logic_vector(int_data_2, 4);
					BCD_digit_3 <= conv_std_logic_vector(int_data_3, 4);
					
					BCD_digit_R1 <= conv_std_logic_vector(int_data_R1, 4);
					BCD_digit_R2 <= conv_std_logic_vector(int_data_R2, 4);
					BCD_digit_R3 <= conv_std_logic_vector(int_data_R3, 4);
	
		end process;

		
end Behavioral;