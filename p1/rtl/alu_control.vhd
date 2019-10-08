--------------------------------------------------------------------------------
-- Bloque de control para la ALU. Arq0 2019-2020.
--
-- Alejandro Pascual Pozo (alejandro.pascualp@estudiante.uam.es)
-- Víctor Yrazusta Ibarra (victor.yrazusta@estudiante.uam.es)
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity alu_control is
  port (
    alu_op  : in  std_logic_vector(1 downto 0);
    func    : in  std_logic_vector(5 downto 0);
    reg_dst : in  std_logic;
    control : out std_logic_vector(3 downto 0)
  );
end alu_control;

architecture rtl of alu_control is

  -- Codigos de operacion para la ALU:
  constant OP_ADD : std_logic_vector(1 downto 0) := "00";
  constant OP_SUB : std_logic_vector(1 downto 0) := "01";
  constant OP_SLT : std_logic_vector(1 downto 0) := "10";
  constant OP_LUI : std_logic_vector(1 downto 0) := "11";
  
  -- Codigos de control de func:
  constant FUNC_NOP : std_logic_vector(5 downto 0) := "000000";
  constant FUNC_OR  : std_logic_vector(5 downto 0) := "100101";
  constant FUNC_XOR : std_logic_vector(5 downto 0) := "100110";
  constant FUNC_AND : std_logic_vector(5 downto 0) := "100100";  
  constant FUNC_ADD : std_logic_vector(5 downto 0) := "100000";
  constant FUNC_SUB : std_logic_vector(5 downto 0) := "100010";
  constant FUNC_SLT : std_logic_vector(5 downto 0) := "101010";
  
  -- Codigos de control de la ALU:
  constant ALU_OR  : std_logic_vector(3 downto 0) := "0111";   
  constant ALU_NOT : std_logic_vector(3 downto 0) := "0101";
  constant ALU_XOR : std_logic_vector(3 downto 0) := "0110";
  constant ALU_AND : std_logic_vector(3 downto 0) := "0100";
  constant ALU_ADD : std_logic_vector(3 downto 0) := "0000";
  constant ALU_SUB : std_logic_vector(3 downto 0) := "0001";
  constant ALU_SLT : std_logic_vector(3 downto 0) := "1010";
  constant ALU_LUI : std_logic_vector(3 downto 0) := "1101";
   
begin  

  process (alu_op, func)
  begin
    if reg_dst = '1' then
      case func is
        when FUNC_NOP => control <= ALU_ADD;
        when FUNC_OR  => control <= ALU_OR;
        when FUNC_XOR => control <= ALU_XOR;
        when FUNC_AND => control <= ALU_AND;
        when FUNC_ADD => control <= ALU_ADD;
        when FUNC_SUB => control <= ALU_SUB;
        when FUNC_SLT => control <= ALU_SLT;
        when others => null;
      end case;
    else
      case alu_op is
        when OP_ADD => control <= ALU_ADD;
        when OP_SUB => control <= ALU_SUB;
        when OP_SLT => control <= ALU_SLT;
        when OP_LUI => control <= ALU_LUI;
        when others => null;
      end case;
    end if;
  end process;
  
end architecture;