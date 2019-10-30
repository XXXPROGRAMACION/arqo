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
    reg_dir_1          : in  std_logic_vector(4 downto 0);
    reg_dir_2          : in  std_logic_vector(4 downto 0);
    branch             : in  std_logic;
    reg_dst_dir_next_1 : in  std_logic_vector(4 downto 0);
    reg_dst_dir_next_2 : in  std_logic_vector(4 downto 0);
    mem_rd_en_next_1   : in  std_logic;
    mem_rd_en_next_2   : in  std_logic;
    pc_wr_en           : out std_logic;
    if_id_wr_en        : out std_logic;
    id_ex_reset        : out std_logic
  );
end hazard_detection_unit;

architecture rtl of hazard_detection_unit is
  signal hazard_detected_1 : std_logic;
  signal hazard_detected_2 : std_logic;
  signal hazard_detected   : std_logic;
begin

  hazard_detected_1 <= '1' when (reg_dir_1 = reg_dst_dir_next_1 or reg_dir_2 = reg_dst_dir_next_1) and mem_rd_en_next_1 = '1' else '0';
  hazard_detected_2 <= '1' when (reg_dir_1 = reg_dst_dir_next_2 or reg_dir_2 = reg_dst_dir_next_2) and mem_rd_en_next_2 = '1' and branch = '1' else '0';
  hazard_detected <= hazard_detected_1 or hazard_detected_2;

  pc_wr_en <= not hazard_detected;
  if_id_wr_en <= not hazard_detected;
  id_ex_reset <= hazard_detected;

end architecture;
