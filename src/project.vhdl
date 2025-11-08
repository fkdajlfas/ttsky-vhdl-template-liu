library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tt_um_example is
    port (
        ui_in   : in  std_logic_vector(7 downto 0);
        uo_out  : out std_logic_vector(7 downto 0);
        uio_in  : in  std_logic_vector(7 downto 0);
        uio_out : out std_logic_vector(7 downto 0);
        uio_oe  : out std_logic_vector(7 downto 0);
        ena     : in  std_logic;
        clk     : in  std_logic;
        rst_n   : in  std_logic
    );
end tt_um_example;

architecture Behavioral of tt_um_example is
	signal counter : unsigned(7 downto 0) := "00000000";
	signal state : std_logic_vector(7 downto 0) := "00000000";
	signal previous_state : std_logic_vector(7 downto 0) := "00000000";

	signal a : std_logic_vector(7 downto 0);
	signal b : std_logic_vector(7 downto 0);
	signal c : std_logic_vector(7 downto 0);
begin

	process(rst_n, clk) begin
		--if not rising_edge(rst_n) then 
		if rst_n = '0' then
			counter <= "00000000";
			state <= "00000000";
			previous_state <= "00000000";
		elsif rising_edge(clk) then
			state <= c;

			if ui_in = previous_state then
				counter <= counter + 1;
			else 
				previous_state <= ui_in;
				state <= ui_in;
				counter <= "00000000";
			end if;
		end if;
	end process;

	--a <= ui_in xor ("000" & ui_in(ui_in'high downto 3));
	--b <= a xor (a(a'high-5 downto 0) & "00000");
	--c <= b xor std_logic_vector(counter(counter'high-2 downto 0) & "00");

	a <= state xor (state(state'high-3 downto 0) & "000");
	b <= a xor ("00000"& a(a'high downto 5));
	c <= b xor std_logic_vector("00" & counter(counter'high downto 2));

	-- uo_out <= std_logic_vector(unsigned(ui_in) + unsigned(uio_in));
	uo_out <= c;
	-- state <= c;

	uio_out <= "00000000";
	uio_oe <= "00000000";

end Behavioral;

