library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity Calculator is
	generic( N : integer := 5 );
	port(
		clock      : in std_logic;
		A, B       : in std_logic_vector(N-1 downto 0);
		Operation  : in std_logic_vector(1   downto 0);
		Start      : in std_logic := '1';
		reset      : in std_logic := '1';
		
		--Check start 
		
		Start_addsubout : out std_logic;
		Start_mulout : out std_logic;
		Start_divout : out std_logic;
		
		--Check done 
		
		Done_addsubout: out std_logic;
		Done_mulout: out std_logic;
		Done_divout: out std_logic;
		
		--Check M of addsub
		M_out : out std_logic;
		
		
		-- temp
		seven_seg_digit_1 : out STD_LOGIC_VECTOR (6 downto 0);
      seven_seg_digit_2 : out STD_LOGIC_VECTOR (6 downto 0);
      seven_seg_digit_3 : out STD_LOGIC_VECTOR (6 downto 0);

      seven_seg_digit_R1 : out STD_LOGIC_VECTOR (6 downto 0);
      seven_seg_digit_R2 : out STD_LOGIC_VECTOR (6 downto 0);
      seven_seg_digit_R3 : out STD_LOGIC_VECTOR (6 downto 0);
		
		r_addsub : out STD_LOGIC_VECTOR (N downto 0);
		r_rem   : out STD_LOGIC_VECTOR (2*N-1 downto 0);
		r_mul : out STD_LOGIC_VECTOR (2*N-1 downto 0);
		r_div : out STD_LOGIC_VECTOR (N-1 downto 0)
		
		
	);
	
end Calculator;
	
	

architecture Structural of Calculator is
	
	component ControlStart is
		port(
			CLK       : in std_logic;
			RST_N     : in std_logic;
			Operation : in std_logic_vector(1 downto 0) ;
			START		 : in std_logic := '1';
			start_addsub : out std_logic := '0'; 
			start_mul : out std_logic := '0';
			start_div : out std_logic := '0';
			M			 : out std_logic ;
			DONE      : out std_logic := '0'
		);
	end component;
	
	component division is
		port(
		  CLK  : in  std_logic;	-- system clock
        RST_N  : in  std_logic; 	-- synchronous reset, active-high
		  START	: in  std_logic := '1';
		  A,B		: in  std_logic_vector(N-1 downto 0) := (others => '0');
		  Q		: out std_logic_vector(N-1 downto 0) := (others => '0');  -- quotient
		  R		: out std_logic_vector(2*N-1 downto 0) := (others => '0');	-- remainer
		  DONE	: out std_logic := '0'
		);
	end component;
	
	component multiply is
		port (
			CLK   : in std_logic; 
			RST_N : in std_logic; 
			START	: in  std_logic := '1';
			A, B  : in std_logic_vector(N - 1 downto 0) := (others => '0');
			R     : out std_logic_vector(2 * N - 1 downto 0) := (others => '0');
			DONE  : out std_logic := '0'
			);
	end component;
	
	component addsub is
		port (
		   START	: in  std_logic := '1';
			CLK   : in std_logic; 
			RST_N : in std_logic; 
			A, B  : in std_logic_vector(N - 1 downto 0) := (others => '0');
			M 		: in std_logic;
			DONE_Control : in std_logic := '0' ;
			R     : out std_logic_vector(N downto 0) := (others => '0');
			DONE  : out std_logic := '0'
			);
	end component;
	
	
	
	
	-- SIGNALs	
	signal result_mul       : std_logic_vector(2*N-1 downto 0);
	signal done_mul         : std_logic;
	
	signal result_div       : std_logic_vector(N-1 downto 0);
	signal done_div         : std_logic;
	signal done_all         : std_logic;
	

	signal result_addsub    : std_logic_vector(9 downto 0);
	signal done_addsub      : std_logic;
	
	signal start_addsub    	: std_logic;
	signal start_mul        : std_logic;
	signal start_div        : std_logic;
	
	--Result and Remainder
	signal Result           : std_logic_vector(9 downto 0);
	signal Remainder           : std_logic_vector(7 downto 0);
	signal M                : std_logic;
	
	signal Done_Control : std_logic;
	
	
	
	begin 
	
			
			StartPoint : ControlStart 
				port map(
					CLK       => clock,
					RST_N     => reset,
					Operation => Operation,
					Start     => Start,
					start_addsub => start_addsub,
					start_mul => start_mul,
					start_div => start_div,
					M 			 => M,
					DONE  	 => Done_Control

				);
		
				
			Divide : division
				port map(
					CLK      => clock,
					RST_N      => reset,
					START      => start_div, 
					A          => A,
					B          => B,
					Q          => result_div,
					R(7 downto 0)          => Remainder,
					DONE       => done_div
				);
				
		
				
			Multi : multiply
				port map(
					CLK        => clock, 
					RST_N      => reset, 
					START      => start_mul,
					A          => A, 
					B          => B,
					R          => result_mul,
					DONE       => done_mul
				);
				
				
				
			AddandSub : addsub
				port map(
					START      => start_addsub,
					CLK        => clock, 
					RST_N      => reset, 
					A          => A, 
					B          => B,
					M 			  => M,
					DONE_Control => Done_Control,
					R          => result_addsub(N downto 0),
					DONE       => done_addsub
				);
				
		
				
			BCDndigit : entity work .BCDconvertBinary
				port map(
					
					start      => Start,
					clock      => clock, 
					reset      => reset,
					
					result_addsub_conv => result_addsub,
					result_mul_conv(2*N-1 downto 0) => result_mul,
					result_div_conv(N-1 downto 0) => result_div,
					result_rem_conv(7 downto 0) => Remainder,
					
					Done_addsub => done_addsub,
					Done_mul => done_mul,
					Done_div => done_div,
					Operation => Operation,

					seven_seg_digit_1 => seven_seg_digit_1,
					seven_seg_digit_2 => seven_seg_digit_2,
					seven_seg_digit_3 => seven_seg_digit_3,
					
					seven_seg_digit_R1 => seven_seg_digit_R1,
					seven_seg_digit_R2 => seven_seg_digit_R2,
					seven_seg_digit_R3 => seven_seg_digit_R3

				);
				
				
				--Start check in waveform
				
				Start_addsubout <= start_addsub  ;
				Start_mulout <= start_mul ;
				Start_divout <= start_div ;
				
				
				--Done check in waveform
				
				Done_addsubout <= done_addsub  ;
				Done_mulout <= done_mul ;
				Done_divout <= done_div ;
				
				--Result check in waveform
				
				r_rem(7 downto 0) <= Remainder ;
				r_addsub <= result_addsub(N downto 0) ;
				r_mul <= result_mul ;
				r_div <= result_div ;
				
				--M_out check
				
				M_out <= M ;
				
	

end Structural;