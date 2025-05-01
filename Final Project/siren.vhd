library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY siren IS
	PORT (
		clk_50MHz : IN STD_LOGIC; -- system clock (50 MHz)
		dac_MCLK : OUT STD_LOGIC; -- outputs to PMODI2L DAC
		dac_LRCK : OUT STD_LOGIC;
		dac_SCLK : OUT STD_LOGIC;
		dac_SDIN : OUT STD_LOGIC;
		bt_clr : IN STD_LOGIC; -- calculator "clear" button
	    bt_plus : IN STD_LOGIC; -- calculator "+" button
	    bt_eq : IN STD_LOGIC; -- calculator "=" button
	    KB_row : IN STD_LOGIC_VECTOR (4 DOWNTO 1); -- keypad row pins
	    SEG7_seg : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
	    SEG7_anode : IN STD_LOGIC_VECTOR (7 DOWNTO 0)
	    
	    
	);
END siren;

ARCHITECTURE Behavioral OF siren IS
	CONSTANT lo_tone : UNSIGNED (13 DOWNTO 0) := to_unsigned (344, 14); -- lower limit of siren = 256 Hz
	CONSTANT hi_tone : UNSIGNED (13 DOWNTO 0) := to_unsigned (687, 14); -- upper limit of siren = 512 Hz
	CONSTANT wail_speed : UNSIGNED (7 DOWNTO 0) := to_unsigned (8, 8); -- sets wailing speed
	COMPONENT dac_if IS
		PORT (
			SCLK : IN STD_LOGIC;
			L_start : IN STD_LOGIC;
			R_start : IN STD_LOGIC;
			L_data : IN signed (15 DOWNTO 0);
			R_data : IN signed (15 DOWNTO 0);
			SDATA : OUT STD_LOGIC
		);
	END COMPONENT;
	COMPONENT hexcalc IS
	   PORT (
	       clk_50MHz : IN STD_LOGIC; -- system clock (50 MHz)
	       SEG7_anode : OUT STD_LOGIC_VECTOR (7 DOWNTO 0); -- anodes of eight 7-seg displays
	       SEG7_seg : OUT STD_LOGIC_VECTOR (6 DOWNTO 0); -- common segments of 7-seg displays
	       bt_clr : IN STD_LOGIC; -- calculator "clear" button
	       bt_plus : IN STD_LOGIC; -- calculator "+" button
	       bt_eq : IN STD_LOGIC; -- calculator "=" button
	       KB_col : OUT STD_LOGIC_VECTOR (4 DOWNTO 1); -- keypad column pins
	       KB_row : IN STD_LOGIC_VECTOR (4 DOWNTO 1); -- keypad row pins
	       tone_val : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	    );
	END COMPONENT;
	COMPONENT tone IS
		PORT (
			clk : IN STD_LOGIC; -- 48.8 kHz audio sampling clock
		    pitch : IN UNSIGNED (13 DOWNTO 0); -- frequency (in units of 0.745 Hz)
	        data : OUT SIGNED (15 DOWNTO 0) -- signed triangle wave out
		);
	END COMPONENT;
	SIGNAL tcount : unsigned (19 DOWNTO 0) := (OTHERS => '0'); -- timing counter
	signal tone_val : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL data_L, data_R : SIGNED (15 DOWNTO 0); -- 16-bit signed audio data
	SIGNAL dac_load_L, dac_load_R : STD_LOGIC; -- timing pulses to load DAC shift reg.
	SIGNAL slo_clk, sclk, audio_CLK : STD_LOGIC;
BEGIN
	-- this process sets up a 20 bit binary counter clocked at 50MHz. This is used
	-- to generate all necessary timing signals. dac_load_L and dac_load_R are pulses
	-- sent to dac_if to load parallel data into shift register for serial clocking
	-- out to DAC
	tim_pr : PROCESS
	BEGIN
		WAIT UNTIL rising_edge(clk_50MHz);
		IF (tcount(9 DOWNTO 0) >= X"00F") AND (tcount(9 DOWNTO 0) < X"02E") THEN
			dac_load_L <= '1';
		ELSE
			dac_load_L <= '0';
		END IF;
		IF (tcount(9 DOWNTO 0) >= X"20F") AND (tcount(9 DOWNTO 0) < X"22E") THEN
			dac_load_R <= '1';
		ELSE dac_load_R <= '0';
		END IF;
		tcount <= tcount + 1;
	END PROCESS;
	dac_MCLK <= NOT tcount(1); -- DAC master clock (12.5 MHz)
	audio_CLK <= tcount(9); -- audio sampling rate (48.8 kHz)
	dac_LRCK <= audio_CLK; -- also sent to DAC as left/right clock
	sclk <= tcount(4); -- serial data clock (1.56 MHz)
	dac_SCLK <= sclk; -- also sent to DAC as SCLK
	slo_clk <= tcount(19); -- clock to control wailing of tone (47.6 Hz)
	h1 : hexcalc
  PORT MAP(
    clk_50MHz  => clk_50MHz,
    SEG7_anode => SEG7_anode,
    SEG7_seg   => SEG7_seg,
    bt_clr     => bt_clr,
    bt_plus    => bt_plus,
    bt_eq      => bt_eq,
    KB_col     => KB_col,
    KB_row     => KB_row,
    tone_val   => tone_val        -- now this matches your signal
  );
	dac : dac_if
	PORT MAP(
		SCLK => sclk, -- instantiate parallel to serial DAC interface
		L_start => dac_load_L, 
		R_start => dac_load_R, 
		L_data => data_L, 
		R_data => data_R, 
		SDATA => dac_SDIN 
		);
		t1 : tone
		PORT MAP( 
			clk => audio_clk, 
			pitch => to_unsigned(val_tone)
			
		);
		data_R <= data_L; -- duplicate data on right channel
END Behavioral;

