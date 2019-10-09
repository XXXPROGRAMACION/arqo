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
    reg_dir_1        : in  std_logic_vector(5 downto 0);
    reg_dir_2        : in  std_logic_vector(5 downto 0);
    reg_dst_dir_mem  : in  std_logic_vector(5 downto 0);
    reg_dst_dir_wb   : in  std_logic_vector(5 downto 0);
    alu_op_a_control : out std_logic_vector(1 downto 0);
    alu_op_b_control : out std_logic_vector(1 downto 0)
  );
end forwarding_unit;

architecture rtl of forwarding_unit is

begin
  
  alu_op_a_control <= 
    "01" when reg_dir_1 = reg_dst_dir_mem else
    "10" when reg_dir_1 = reg_dst_dir_wb else
    "00";

  alu_op_b_control <= 
    "01" when reg_dir_2 = reg_dst_dir_mem else 
    "10" when reg_dir_2 = reg_dst_dir_wb else
    "00";

end architecture;
