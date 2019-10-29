--------------------------------------------------------------------------------
-- Unidad de gestión de adelantamiento de datos. Arq0 2019-2020
--
-- Alejandro Pascual Pozo (alejandro.pascualp@estudiante.uam.es)
-- Víctor Yrazusta Ibarra (victor.yrazusta@estudiante.uam.es)
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity forwarding_unit is
  port (
    reg_dir_1          : in  std_logic_vector(4 downto 0);
    reg_dir_2          : in  std_logic_vector(4 downto 0);
    reg_dst_dir_next_1 : in  std_logic_vector(4 downto 0);
    reg_wr_en_next_1   : in  std_logic;
    reg_dst_dir_next_2 : in  std_logic_vector(4 downto 0);
    reg_wr_en_next_2   : in  std_logic;
    op_a_control       : out std_logic_vector(1 downto 0);
    op_b_control       : out std_logic_vector(1 downto 0)
  );
end forwarding_unit;

architecture rtl of forwarding_unit is

begin
  
  op_a_control <=
    "00" when reg_dir_1 = "00000" else
    "01" when reg_dir_1 = reg_dst_dir_next_1 and reg_wr_en_next_1 = '1' else
    "10" when reg_dir_1 = reg_dst_dir_next_2 and reg_wr_en_next_2 = '1' else
    "00";

  op_b_control <= 
    "00" when reg_dir_2 = "00000" else
    "01" when reg_dir_2 = reg_dst_dir_next_1 and reg_wr_en_next_1 = '1' else 
    "10" when reg_dir_2 = reg_dst_dir_next_2 and reg_wr_en_next_2 = '1' else
    "00";

end architecture;
