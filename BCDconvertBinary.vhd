library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity BCDconvertBinary is
generic (N : integer := 5);
		Port ( 
				 start  : in std_logic; 
				 clock  : in  std_logic;	-- system clock
             reset  : in  std_logic; 	-- synchronous reset, active-high
				 
				 result_addsub_conv    : in std_logic_vector(9 downto 0) := (others => '0') ;
				 result_mul_conv    : in std_logic_vector(9 downto 0 ):= (others => '0');
				 result_div_conv : in std_logic_vector(9 downto 0 ):= (others => '0');
				 result_rem_conv  : in std_logic_vector(7 downto 0 ):= (others => '0');
				 
				 Done_addsub      : in std_logic  ;
				 Done_mul    : in std_logic ;
				 Done_div     : in std_logic ;
				 Operation  : in std_logic_vector(1 downto 0);
--
--				 --Result
--				 Result 	: in  STD_LOGIC_VECTOR (9 downto 0); -- 0 to 999
--				 Remainder 	: in  STD_LOGIC_VECTOR (7 downto 0); -- 0 to 255
				 -- seven_segment_ 3 digit Result
				 seven_seg_digit_1 : out STD_LOGIC_VECTOR (6 downto 0);
				 seven_seg_digit_2 : out STD_LOGIC_VECTOR (6 downto 0);
				 seven_seg_digit_3 : out STD_LOGIC_VECTOR (6 downto 0);
				 -- seven_segment_ 3 digit Remainder
				 seven_seg_digit_R1 : out STD_LOGIC_VECTOR (6 downto 0);
				 seven_seg_digit_R2 : out STD_LOGIC_VECTOR (6 downto 0);
				 seven_seg_digit_R3 : out STD_LOGIC_VECTOR (6 downto 0));

				 end BCDconvertBinary;

architecture converter of BCDconvertBinary is

--Result
 signal BCD_data_digit_1 : STD_LOGIC_VECTOR (3 downto 0);
 signal BCD_data_digit_2 : STD_LOGIC_VECTOR (3 downto 0);
 signal BCD_data_digit_3 : STD_LOGIC_VECTOR (3 downto 0);
 --Remainder
 signal BCD_data_digit_R1 : STD_LOGIC_VECTOR (3 downto 0);
 signal BCD_data_digit_R2 : STD_LOGIC_VECTOR (3 downto 0);
 signal BCD_data_digit_R3 : STD_LOGIC_VECTOR (3 downto 0);
 signal Alldone: STD_LOGIC := '0' ;
 
	begin
	
	Alldone <= Done_addsub or Done_mul or Done_div ;
	

				convert_binary_result : entity work .BCD_n_digit_to_7_seg(Behavioral)
											port map(
												start => start,
												clk_i => clock,
												rst_i => reset,
												
												result_addsub => result_addsub_conv,
												result_mul => result_mul_conv,
												result_div => result_div_conv,
												result_rem => result_rem_conv,
												
												AllDone => Alldone,
												Operation => Operation,
												
		
												BCD_digit_1 => BCD_data_digit_1,
												BCD_digit_2 => BCD_data_digit_2,
												BCD_digit_3 => BCD_data_digit_3);
					
				convert_binary_rem :	entity work .BCD_n_digit_to_7_seg(Behavioral)
											port map(
												start => start,
												clk_i => clock,
												rst_i => reset,
												
												result_addsub => result_addsub_conv,
												result_mul => result_mul_conv,
												result_div => result_div_conv,
												result_rem => result_rem_conv,
												
												AllDone => Alldone,
												Operation => Operation,
					
												BCD_digit_R1 => BCD_data_digit_R1,
												BCD_digit_R2 => BCD_data_digit_R2,
												BCD_digit_R3 => BCD_data_digit_R3);						
												

			
		--Display result 3 digit form 0 to 999										
												
		seven_seg_display_1: entity work .BDC_to_7_segmen(data_process)
									port map(
										clk_i => clock,
										BCD_i  => BCD_data_digit_1,
										seven_seg  =>seven_seg_digit_1 );
		seven_seg_display_2: entity work .BDC_to_7_segmen(data_process)
									port map(
										clk_i => clock,
										BCD_i  => BCD_data_digit_2,
										seven_seg  =>seven_seg_digit_2 );
		seven_seg_display_3: entity work .BDC_to_7_segmen(data_process)
									port map(
										clk_i => clock,
										BCD_i  => BCD_data_digit_3,
										seven_seg  =>seven_seg_digit_3 );
										
		--Display Remainder 3 digit form 0 to 255									
												
		seven_seg_display_R1: entity work .BDC_to_7_segmen(data_process)
									port map(
										clk_i => clock,
										BCD_i  => BCD_data_digit_R1,
										seven_seg  =>seven_seg_digit_R1 );
		seven_seg_display_R2: entity work .BDC_to_7_segmen(data_process)
									port map(
										clk_i => clock,
										BCD_i  => BCD_data_digit_R2,
										seven_seg  =>seven_seg_digit_R2 );
		seven_seg_display_R3: entity work .BDC_to_7_segmen(data_process)
									port map(
										clk_i => clock,
										BCD_i  => BCD_data_digit_R3,
										seven_seg  =>seven_seg_digit_R3 );
						
end converter;