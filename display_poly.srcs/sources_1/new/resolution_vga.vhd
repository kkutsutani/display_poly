library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity resolution_vga is
    Port ( CLK   : in STD_LOGIC;
           RST   : in STD_LOGIC;
           VSYNC : out STD_LOGIC;
           HSYNC : out STD_LOGIC;
           P_TICK : out STD_LOGIC;
           VIDEO_EN : out STD_LOGIC;
           X : out STD_LOGIC_VECTOR (9 downto 0);
           Y : out STD_LOGIC_VECTOR (9 downto 0));
end resolution_vga;

architecture RTL of resolution_vga is
    -- horizontal
    constant H_DISPLAY  : integer := 640;
    constant H_L_BORDER : integer := 48;
    constant H_R_BORDER : integer := 16;
    constant H_RETRACE  : integer := 96;
    constant H_MAX : integer := H_DISPLAY + H_L_BORDER + H_R_BORDER + H_RETRACE - 1;
    constant START_H_RETRACE : integer := H_DISPLAY + H_R_BORDER;
    constant END_H_RETRACE : integer := H_DISPLAY + H_R_BORDER + H_RETRACE - 1;

    -- vertical
    constant V_DISPLAY  : integer := 480;
    constant V_T_BORDER : integer := 10;
    constant V_B_BORDER : integer := 33;
    constant V_RETRACE  : integer := 2;
    constant V_MAX : integer := V_DISPLAY + V_T_BORDER + V_B_BORDER + V_RETRACE - 1;
    constant START_V_RETRACE : integer := V_DISPLAY + V_B_BORDER;
    constant END_V_RETRACE : integer := V_DISPLAY + V_B_BORDER + V_RETRACE - 1;

    -- reg
    signal pixel_reg  : std_logic_vector(1 downto 0);       -- 1/4 CLK カウント用レジスタ
    signal pixel_tick : std_logic;                          -- 1/4 CLK有効フラグ

    signal v_count_reg  : std_logic_vector(9 downto 0);     -- カウンタ(垂直ピクセル) ※更新頻度:CLK
    signal v_count_next : std_logic_vector(9 downto 0);     -- 次カウンタ設定値(垂直ピクセル) ※更新頻度:組合せ回路
    signal h_count_reg  : std_logic_vector(9 downto 0);     -- カウンタ(水平ピクセル) ※更新頻度:CLK
    signal h_count_next : std_logic_vector(9 downto 0);     -- 次カウンタ設定値(水平ピクセル) ※更新頻度:組合せ回路

    signal vsync_reg  : std_logic;  -- VSYNC出力用レジスタ ※更新頻度:CLK
    signal vsync_next : std_logic;  -- 次回設定値(VSYNC) ※更新頻度:組合せ回路
    signal hsync_reg  : std_logic;  -- HSYNC出力用レジスタ ※更新頻度:CLK
    signal hsync_next : std_logic;  -- 次回設定値(HSYNC) ※更新頻度:組合せ回路

begin
    --------------------------------------------------
    -- 1/4 CLK make
    --------------------------------------------------
    process(CLK, RST)
    begin
        if(RST = '1') then
            pixel_reg <= "00";
        elsif( rising_edge(CLK) ) then
            pixel_reg <= pixel_reg + 1;
        end if;
    end process;

    pixel_tick <= '1' when pixel_reg = "00" else '0';

    --------------------------------------------------
    -- Update register value
    --------------------------------------------------
    process(CLK, RST)
    begin
        if(RST = '1') then
            v_count_reg <= (others => '0');
            h_count_reg <= (others => '0');
            vsync_reg <= '0';
            hsync_reg <= '0';
        elsif( rising_edge(CLK) ) then
            v_count_reg <= v_count_next;
            h_count_reg <= h_count_next;
            vsync_reg <= vsync_next;
            hsync_reg <= hsync_next;
        end if;
    end process;

    --------------------------------------------------
    -- Update h_count_next
    --------------------------------------------------
    process(pixel_tick, h_count_reg)
    begin
        if(pixel_tick = '1') then
            if(h_count_reg = H_MAX) then
                h_count_next <= (others => '0');
            else
                h_count_next <= h_count_reg + 1;
            end if;
        else
            h_count_next <= h_count_reg;
        end if;
    end process;

    --------------------------------------------------
    -- Update v_count_next
    --------------------------------------------------
    process(pixel_tick, v_count_reg, h_count_reg)
    begin
        if( (pixel_tick = '1') and (h_count_reg = H_MAX) ) then
            if(v_count_reg = V_MAX) then
                v_count_next <= (others => '0');
            else
                v_count_next <= v_count_reg + 1;
            end if;
        else
            v_count_next <= v_count_reg;
        end if;
    end process;

    --------------------------------------------------
    -- Update *sync_next
    --------------------------------------------------
    -- START_H_RETRACE(656) ≦ h_count_reg ≦ END_H_RETRACE(751)
    hsync_next <= '1' when h_count_reg >= START_H_RETRACE and h_count_reg <= END_H_RETRACE else '0';
    -- START_V_RETRACE(513) ≦ v_count_reg ≦ END_V_RETRACE(514)
    vsync_next <= '1' when v_count_reg >= START_V_RETRACE and v_count_reg <= END_V_RETRACE else '0';

    --------------------------------------------------
    -- output signals
    --------------------------------------------------
    -- h_count_reg(0～H_MAX(799)) < H_DISPLAY(640)  AND  v_count_reg(0～V_MAX(524)) < V_DISPLAY(480)
    -- 本来なら この↑条件で画面有効(VIDEO_EN=1)になるべき
--  VIDEO_EN <= '1' when (h_count_reg < H_DISPLAY) and (v_count_reg < V_DISPLAY) else '0';

    -- しかし 実際のモニタでは以下座標で表示していた。それに合わせておく
    -- 実際の表示座標 = X : 0～639、Y : 24～524
    VIDEO_EN <= '1' when (h_count_reg < H_DISPLAY) and (24 <= v_count_reg) and (v_count_reg <= V_MAX) else '0';

    HSYNC <= hsync_reg;
    VSYNC <= vsync_reg;
    X <= h_count_reg;
    Y <= v_count_reg;
    P_TICK <= pixel_tick;

end RTL;
