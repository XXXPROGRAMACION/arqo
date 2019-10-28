--------------------------------------------------------------------------------
-- Unidad de prevención de riesgos. Arq0 2019-2020
--
-- Alejandro Pascual Pozo (alejandro.pascualp@estudiante.uam.es)
-- Víctor Yrazusta Ibarra (victor.yrazusta@estudiante.uam.es)
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity hazard_detection_unit is
  port (
    reg_dir_1   : in  std_logic_vector(4 downto 0);
    reg_dir_2   : in  std_logic_vector(4 downto 0);
    reg_dst_dir : in  std_logic_vector(4 downto 0);
    mem_rd_en   : in  std_logic;
    pc_wr_en    : out std_logic;
    if_id_wr_en : out std_logic;
    id_ex_reset : out std_logic
  );
end hazard_detection_unit;

architecture rtl of hazard_detection_unit is
  signal hazard_detected : std_logic;
begin

  hazard_detected <= '1' when (reg_dir_1 = reg_dst_dir or reg_dir_2 = reg_dst_dir) and mem_rd_en = '1' else '0';
  
  pc_wr_en <= not hazard_detected;
  if_id_wr_en <= not hazard_detected;
  id_ex_reset <= hazard_detected;

end architecture;
