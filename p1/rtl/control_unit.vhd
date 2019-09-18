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
      -- Entrada = codigo de operacion en la instruccion:
      ins_code   : in  std_logic_vector (5 downto 0);
      -- Seniales para el PC
      branch     : out  std_logic; -- 1 = Ejecutandose instruccion branch
      -- Seniales relativas a la memoria
      mem_to_reg : out  std_logic; -- 1 = Escribir en registro la salida de la mem.
      mem_wr     : out  std_logic; -- Escribir la memoria
      mem_rd     : out  std_logic; -- Leer la memoria
      -- Seniales para la ALU
      alu_src    : out  std_logic;                     -- 0 = oper.B es registro, 1 = es valor inm.
      alu_op     : out  std_logic_vector (1 downto 0); -- Tipo operacion para control de la ALU
      -- Seniales para el GPR
      reg_wr     : out  std_logic; -- 1=Escribir registro
      reg_dst    : out  std_logic  -- 0=Reg. destino es rt, 1=rd
   );
end control_unit;

architecture rtl of control_unit is

   -- Tipo para los codigos de operacion:
   subtype t_ins_code is std_logic_vector (5 downto 0);

   -- Codigos de operacion para las diferentes instrucciones:
   constant OP_RTYPE : t_ins_code := "000000";
   constant OP_BEQ   : t_ins_code := "000100";
   constant OP_SW    : t_ins_code := "101011";
   constant OP_LW    : t_ins_code := "100011";
   constant OP_LUI   : t_ins_code := "001111";

begin

end architecture;
