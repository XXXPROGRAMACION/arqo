--------------------------------------------------------------------------------
-- Universidad Autonoma de Madrid
-- Escuela Politecnica Superior
-- Laboratorio de Arq0 2019-2020
--
-- Banco completo de registros del microprocesador MIPS
----------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity reg_bank is
  port (
    clk        : in  std_logic;
    reset      : in  std_logic;
    reg_dir_1  : in  std_logic_vector( 4 downto 0);
    reg_dir_2  : in  std_logic_vector( 4 downto 0);
    reg_wr_dir : in  std_logic_vector( 4 downto 0);
    reg_wr     : in  std_logic_vector(31 downto 0);
    wr_en      : in  std_logic;
    reg_1      : out std_logic_vector(31 downto 0);
    reg_2      : out std_logic_vector(31 downto 0)
  ); 
end reg_bank;

architecture rtl of reg_bank is

  -- Tipo y senial para almacenar los registros
  type regs_type is array (0 to 31) of std_logic_vector(31 downto 0);

  signal regs : regs_type;

begin

  ------------------------------------------------------
  -- Escritura de registro
  ------------------------------------------------------

  process(clk, reset)
  begin
    if reset = '1' then
      for i in 0 to 31 loop
        regs(i) <= (others => '0');
      end loop;
    elsif rising_edge(clk) then
      if wr_en = '1' then
        if reg_wr_dir /= "00000" then -- El R0 siempre es cero
          regs(conv_integer(reg_wr_dir)) <= reg_wr;
        end if;
      end if;
    end if;
  end process;

  ------------------------------------------------------
  -- Lectura de registros
  ------------------------------------------------------
  reg_1 <= regs(conv_integer(reg_dir_1));
  reg_2 <= regs(conv_integer(reg_dir_2));

end architecture;