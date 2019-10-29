--------------------------------------------------------------------------------
-- Unidad de control principal del micro. Arq0 2019-2020
--
-- Alejandro Pascual Pozo (alejandro.pascualp@estudiante.uam.es)
-- Víctor Yrazusta Ibarra (victor.yrazusta@estudiante.uam.es)
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
    reg_dst    : out std_logic;
    jmp        : out std_logic
  );
end control_unit;

architecture rtl of control_unit is

  -- Codigos de instruccion para las diferentes instrucciones:
  constant INS_RTYPE : std_logic_vector(5 downto 0) := "000000"; -- Operacion indicada en func
  constant INS_ADDI  : std_logic_vector(5 downto 0) := "001000"; -- Suma
  constant INS_BEQ   : std_logic_vector(5 downto 0) := "000100"; -- Resta
  constant INS_SW    : std_logic_vector(5 downto 0) := "101011"; -- Suma
  constant INS_LW    : std_logic_vector(5 downto 0) := "100011"; -- Suma
  constant INS_SLTI  : std_logic_vector(5 downto 0) := "001010"; -- Menor que
  constant INS_LUI   : std_logic_vector(5 downto 0) := "001111"; -- Operacion especial S16
  constant INS_JMP   : std_logic_vector(5 downto 0) := "000010"; -- Sin operación
  
  -- Codigos de operacion para la ALU:
  constant OP_ADD : std_logic_vector(1 downto 0) := "00";
  constant OP_SUB : std_logic_vector(1 downto 0) := "01";
  constant OP_SLT : std_logic_vector(1 downto 0) := "10";
  constant OP_LUI  : std_logic_vector(1 downto 0) := "11";

begin
  
  branch <= '1' when ins_code = INS_BEQ else '0';
  mem_to_reg <= '1' when ins_code = INS_LW else '0';
  mem_wr_en <= '1' when ins_code = INS_SW else '0';
  mem_rd_en <= '1' when ins_code = INS_LW else '0';
  alu_src <= '1' when ins_code /= INS_RTYPE else '0';
  alu_op <= OP_SLT when ins_code = INS_SLTI else OP_LUI when ins_code = INS_LUI else OP_ADD;
  reg_wr_en <= '1' when ins_code = INS_RTYPE or ins_code = INS_ADDI or ins_code = INS_LW or ins_code = INS_SLTI or ins_code = INS_LUI else '0';
  reg_dst <= '1' when ins_code = INS_RTYPE else '0';
  jmp <= '1' when ins_code = INS_JMP else '0';

end architecture;
