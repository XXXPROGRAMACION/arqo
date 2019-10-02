--------------------------------------------------------------------------------
-- Procesador MIPS con pipeline curso Arquitectura 2019-2020
--
-- Alejandro Pascual Pozo (alejandro.pascualp@estudiante.uam.es)
-- Víctor Yrazusta Ibarra (victor.yrazusta@estudiante.uam.es)
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity processor is
  port (    
    clk         : in  std_logic;
    reset       : in  std_logic;
    -- Instruction memory
    iAddr      : out std_logic_vector(31 downto 0);
    iDataIn    : in  std_logic_vector(31 downto 0);
    -- Data memory
    dAddr      : out std_logic_vector(31 downto 0);
    dRdEn      : out std_logic;
    dWrEn      : out std_logic;
    dDataOut   : out std_logic_vector(31 downto 0);
    dDataIn    : in  std_logic_vector(31 downto 0)
  );
end processor;

architecture rtl of processor is

  -- Naming convention interface
  signal im_dir     : std_logic_vector(31 downto 0);
  signal im_ins     : std_logic_vector(31 downto 0);
  signal dm_dir     : std_logic_vector(31 downto 0);
  signal dm_rd_en   : std_logic;
  signal dm_wr_en   : std_logic;
  signal dm_data_wr : std_logic_vector(31 downto 0);
  signal dm_data    : std_logic_vector(31 downto 0);

  component control_unit
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
  end component;

  component alu
    port (
      op_a    : in  std_logic_vector(31 downto 0);
      op_b    : in  std_logic_vector(31 downto 0);
      control : in  std_logic_vector( 3 downto 0);
      res     : out std_logic_vector(31 downto 0);
      z_flag  : out std_logic
    );
  end component;

  component alu_control
    port (
      alu_op  : in  std_logic_vector(1 downto 0);
      func    : in  std_logic_vector(5 downto 0);
      control : out std_logic_vector(3 downto 0)
    );
  end component;

  component reg_bank
    port (
      clk        : in  std_logic;
      reset      : in  std_logic;
      reg_1_dir  : in  std_logic_vector( 4 downto 0);
      reg_2_dir  : in  std_logic_vector( 4 downto 0);
      reg_wr_dir : in  std_logic_vector( 4 downto 0);
      reg_wr     : in  std_logic_vector(31 downto 0);
      wr_en      : in  std_logic;
      reg_1      : out std_logic_vector(31 downto 0);
      reg_2      : out std_logic_vector(31 downto 0)
    );
  end component;
  
  -- Sign extend signal
  signal sign_ext : std_logic_vector(31 downto 0);

  -- Control unit signals
  signal branch     : std_logic;
  signal mem_to_reg : std_logic;
  signal mem_wr_en  : std_logic;
  signal mem_rd_en  : std_logic;
  signal alu_src    : std_logic;
  signal alu_op     : std_logic_vector(1 downto 0);
  signal reg_wr_en  : std_logic;
  signal reg_dst    : std_logic;

  -- ALU signals
  signal op_b    : std_logic_vector(31 downto 0);
  signal alu_res : std_logic_vector(31 downto 0);
  signal z_flag  : std_logic;

  -- ALU control signal
  signal control : std_logic_vector(3 downto 0);

  -- Register bank signals
  signal reg_1      : std_logic_vector(31 downto 0);
  signal reg_2      : std_logic_vector(31 downto 0);
  signal reg_wr_dir : std_logic_vector( 4 downto 0);
  signal reg_wr     : std_logic_vector(31 downto 0);

  -- Instruction memory signals
  signal ins_dir : std_logic_vector(31 downto 0);

begin

  -- Naming convention interface
  iAddr <= im_dir;
  im_ins <= iDataIn;
  dAddr <= dm_dir;
  dRdEn <= dm_rd_en;
  dWrEn <= dm_wr_en;
  dDataOut <= dm_data_wr;
  dm_data <= dDataIn;

  sign_ext <= "00000000000000000" & im_ins(14 downto 0) when im_ins(15) = '0' else "11111111111111111" & im_ins(14 downto 0);
  im_dir <= ins_dir;

  control_unit_port_map: control_unit port map (
    ins_code   => im_ins(31 downto 26),
    branch     => branch,
    mem_to_reg => mem_to_reg,
    mem_wr_en  => mem_wr_en,
    mem_rd_en  => mem_rd_en,
    alu_src    => alu_src,
    alu_op     => alu_op,
    reg_wr_en  => reg_wr_en,
    reg_dst    => reg_dst
  );

  op_b <= reg_2 when alu_src = '0' else sign_ext;

  alu_port_map: alu port map (
    op_a    => reg_1,
    op_b    => op_b,
    control => control,
    res     => alu_res,
    z_flag  => z_flag
  );

  alu_control_port_map: alu_control port map (
    func    => im_ins(5 downto 0),
    alu_op  => alu_op,
    control => control
  );

  reg_wr_dir <= im_ins(20 downto 16) when reg_dst = '0' else im_ins(15 downto 11);
  reg_wr <= alu_res when mem_to_reg = '0' else dm_data;

  reg_bank_port_map: reg_bank port map (
    clk        => clk,
    reset      => reset,
    reg_1_dir  => im_ins(25 downto 21),
    reg_2_dir  => im_ins(20 downto 16),
    reg_wr_dir => reg_wr_dir,
    wr_en      => reg_wr_en,
    reg_wr     => reg_wr,
    reg_1      => reg_1,
    reg_2      => reg_2
  );

  process (clk)
  begin
    if rising_edge(clk) and clk = '1' then
      if branch = '1' and z_flag = '1' then
        ins_dir <= ins_dir + 4 + (sign_ext(28 downto 0) & "00");
      else
        ins_dir <= ins_dir + 4;
      end if;
    end if;
  end process;

  dm_dir <= alu_res;
  dm_rd_en <= mem_rd_en;
  dm_wr_en <= mem_wr_en;
  dm_data_wr <= reg_2;
  
end architecture;
