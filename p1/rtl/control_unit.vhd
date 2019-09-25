--------------------------------------------------------------------------------
-- Unidad de control principal del micro. Arq0 2019-2020
--
-- (INCLUIR AQUI LA INFORMACION SOBRE LOS AUTORES)
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity control_unit is
  port (
    ins_code   : in  std_logic_vector(5 downto 0);
    branch     : out std_logic;
    mem_to_reg : out std_logic;
    mem_wr_en  : out std_logic;
    mem_rd_en  : out std_logic;
    alu_src    : out std_logic;
    alu_op     : out std_logic_vector(1 downto 0);
    reg_wr_en  : out std_logic;
    reg_dst    : out std_logic
  );
end control_unit;

architecture rtl of control_unit is

  -- Codigos de instruccion para las diferentes instrucciones:
  constant INS_RTYPE : std_logic_vector(5 downto 0) := "000000"; -- Operacion indicada en func (00)
  constant INS_BEQ   : std_logic_vector(5 downto 0) := "000100"; -- Resta (10)
  constant INS_SW    : std_logic_vector(5 downto 0) := "101011"; -- Suma (01)
  constant INS_LW    : std_logic_vector(5 downto 0) := "100011"; -- Suma (01)
  constant INS_LUI   : std_logic_vector(5 downto 0) := "001111"; -- Suma (01)
  
  -- Codigos de operacion para la ALU:
  constant OP_FUNC : std_logic_vector(1 downto 0) := "00";
  constant OP_ADD  : std_logic_vector(1 downto 0) := "01";
  constant OP_SUB  : std_logic_vector(1 downto 0) := "10";

begin
  
  branch <= '1' when ins_code = INS_BEQ else '0';
  mem_to_reg <= '1' when ins_code = INS_LW else '0';
  mem_wr_en <= '1' when ins_code = INS_SW else '0';
  mem_rd_en <= '1' when ins_code = INS_LW else '0';
  alu_src <= '1' when ins_code /= INS_RTYPE and ins_code /= INS_BEQ else '0';
  alu_op <= OP_FUNC when ins_code = INS_RTYPE else OP_SUB when ins_code = INS_BEQ else OP_ADD;
  reg_wr_en <= '1' when ins_code /= INS_BEQ and ins_code /= INS_SW else '0';
  reg_dst <= '1' when ins_code = INS_RTYPE else '0';

end architecture;
