library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity display_top is
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           VSYNC : out STD_LOGIC;
           HSYNC : out STD_LOGIC;
           RGB : out STD_LOGIC_VECTOR (11 downto 0));
end display_top;

architecture RTL of display_top is

    -- resolution_vga
    component resolution_vga
        Port ( CLK   : in STD_LOGIC;
               RST   : in STD_LOGIC;
               VSYNC : out STD_LOGIC;
               HSYNC : out STD_LOGIC;
               P_TICK : out STD_LOGIC;
               VIDEO_EN : out STD_LOGIC;
               X : out STD_LOGIC_VECTOR (9 downto 0);
               Y : out STD_LOGIC_VECTOR (9 downto 0));
    end component;

    -- rom_bg_poly
    component rom_bg_poly is
        Port ( CLK : in STD_LOGIC;
               X : in STD_LOGIC_VECTOR (9 downto 0);
               Y : in STD_LOGIC_VECTOR (9 downto 0);
               Data : out STD_LOGIC_VECTOR (11 downto 0));
    end component;

    -- signal
    signal x_w   : std_logic_vector(9 downto 0);
    signal y_w   : std_logic_vector(9 downto 0);
    signal vsync_w : std_logic;
    signal hsync_w : std_logic;
    signal video_en_w : std_logic;
    signal p_tice_w : std_logic;
    signal data_w   : std_logic_vector(11 downto 0);
    signal rgb_next : std_logic_vector(11 downto 0);

begin
    U1 : resolution_vga
        port map(CLK => CLK, RST => RST, VSYNC => VSYNC, HSYNC => HSYNC, P_TICK => p_tice_w, VIDEO_EN => video_en_w, X => x_w, Y => y_w);

    U2 : rom_bg_poly
        port map(CLK => CLK, X => x_w, Y => y_w, Data => data_w);

    process(CLK)
    begin
        if(video_en_w = '1') then
            rgb_next <= data_w;
        else
            rgb_next <= X"000";
        end if;
    end process;

    process(CLK)
    begin
        if(rising_edge(CLK)) then
            if(p_tice_w = '1') then
                RGB <= rgb_next;
            end if;
        end if;
    end process;

end RTL;
