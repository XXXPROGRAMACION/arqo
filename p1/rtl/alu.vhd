--------------------------------------------------------------------------------
-- Universidad Autonoma de Madrid
-- Escuela Politecnica Superior
-- Laboratorio de ARQ 2019-2020
--
-- ALU simple.
-- * Soporta las operaciones: +, -, and, or, xor, not, slt, op_b<<16 (desplazamiento)
-- * Soporta el flag Zero (z_flag)
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity alu is
  port (
    op_a    : in  std_logic_vector(31 downto 0);
    op_b    : in  std_logic_vector(31 downto 0);
    control : in  std_logic_vector( 3 downto 0);
    res     : out std_logic_vector(31 downto 0);
    z_flag  : out std_logic
  );
end alu;

architecture rtl of alu is
  
  -- Codigos de control:
  constant ALU_OR  : std_logic_vector(3 downto 0) := "0111";   
  constant ALU_NOT : std_logic_vector(3 downto 0) := "0101";
  constant ALU_XOR : std_logic_vector(3 downto 0) := "0110";
  constant ALU_AND : std_logic_vector(3 downto 0) := "0100";
  constant ALU_ADD : std_logic_vector(3 downto 0) := "0000";
  constant ALU_SUB : std_logic_vector(3 downto 0) := "0001";
  constant ALU_SLT : std_logic_vector(3 downto 0) := "1010";
  constant ALU_LUI : std_logic_vector(3 downto 0) := "1101";

  -- Senales intermedias:
  signal sub_ext : std_logic_vector(32 downto 0); -- resta extendida a 33 bits
  signal res_aux : std_logic_vector(31 downto 0); -- alias interno de res

begin

  sub_ext <= (op_a(31) & op_a) - (op_b(31) & op_b);

  process (control, op_a, op_b, sub_ext)
  begin
    case control is
      when ALU_OR  => res_aux <= op_a or op_b;
      when ALU_NOT => res_aux <= not op_a;
      when ALU_XOR => res_aux <= op_a xor op_b;
      when ALU_AND => res_aux <= op_a and op_b;
      when ALU_SUB => res_aux <= sub_ext (31 downto 0);
      when ALU_ADD => res_aux <= op_a + op_b;
      when ALU_SLT => res_aux <= x"0000000" & "000" & sub_ext(32);
      when ALU_LUI => res_aux <= op_b (15 downto 0) & x"0000";
      when others => null;
    end case;
  end process;

   res <= res_aux;
   z_flag  <= '1' when res_aux = x"00000000" else '0';

end architecture;