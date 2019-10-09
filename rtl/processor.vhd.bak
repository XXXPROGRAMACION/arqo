--------------------------------------------------------------------------------
-- Procesador MIPS con pipeline curso Arquitectura 2019-2020
--
-- (INCLUIR AQUI LA INFORMACION SOBRE LOS AUTORES)
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity processor is
   port(
      clk        : in  std_logic; -- Reloj activo en flanco subida
      reset      : in  std_logic; -- Reset asincrono activo nivel alto
      -- ins memory
      im_dir     : out std_logic_vector(31 downto 0); -- Direccion Instruccion
      im_ins     : in  std_logic_vector(31 downto 0); -- Instruccion leida
      -- Data memory
      dm_dir     : out std_logic_vector(31 downto 0); -- Direccion
      dm_rd_en   : out std_logic;                     -- Habilitacion lectura
      dm_wr_en   : out std_logic;                     -- Habilitacion escritura
      dm_data_wr : out std_logic_vector(31 downto 0); -- Dato escrito
      dm_data_rd : in  std_logic_vector(31 downto 0)  -- Dato leido
   );
end processor;

architecture rtl of processor is 

begin   
 
end architecture;
