LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY spectrum_bar IS
  generic (
    SCREEN_W : integer := 800;
    SCREEN_H : integer := 600;
    BAR_W    : integer := 40;
    MAX_TONE : integer := 8190  
  );
  PORT (
    v_sync    : IN  STD_LOGIC;
    pixel_row : IN  STD_LOGIC_VECTOR(10 DOWNTO 0);
    pixel_col : IN  STD_LOGIC_VECTOR(10 DOWNTO 0);
    red       : OUT STD_LOGIC;
    green     : OUT STD_LOGIC;
    blue      : OUT STD_LOGIC;
    tone_size : IN  INTEGER       
  );
END ENTITY;

ARCHITECTURE Behavioral OF spectrum_bar IS
  SIGNAL bar_h  : integer range 0 to SCREEN_H := 0;
  SIGNAL bar_x  : integer range 0 to SCREEN_W := 0;
  SIGNAL bar_on : std_logic;
BEGIN

  -- update both X-position and height once per frame
  update_bar : PROCESS (v_sync)
    VARIABLE raw : integer;
    VARIABLE x   : integer;
  BEGIN
    IF rising_edge(v_sync) THEN

      -- clamp to [0..MAX_TONE]
      raw := tone_size;
      IF raw < 0         THEN raw := 0;
      ELSIF raw > MAX_TONE THEN raw := MAX_TONE;
      END IF;

      -- horizontal position 
      x := (raw * (SCREEN_W - BAR_W)) / MAX_TONE;
      bar_x <= x;

      -- vertical height 

        bar_h <= SCREEN_H;
     

    END IF;
  END PROCESS;

  -- draw at (bar_x … bar_x+BAR_W) and rising up from bottom
  draw_bar : PROCESS (pixel_col, pixel_row, bar_x, bar_h)
    VARIABLE pc, pr : integer;
  BEGIN
    pc := TO_INTEGER(unsigned(pixel_col));
    pr := TO_INTEGER(unsigned(pixel_row));

    IF (pc >= bar_x) AND (pc < bar_x + BAR_W) AND
       (pr >= SCREEN_H - bar_h) THEN
      bar_on <= '1';
    ELSE
      bar_on <= '0';
    END IF;
  END PROCESS;

  -- final color output: green bar on black
  red   <= '0';
  green <= bar_on;
  blue  <= '0';

END ARCHITECTURE;
