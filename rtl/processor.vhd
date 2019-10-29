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
    clk      : in  std_logic;
    reset    : in  std_logic;
    -- Instruction memory
    iAddr    : out std_logic_vector(31 downto 0);
    iDataIn  : in  std_logic_vector(31 downto 0);
    -- Data memory
    dAddr    : out std_logic_vector(31 downto 0);
    dRdEn    : out std_logic;
    dWrEn    : out std_logic;
    dDataOut : out std_logic_vector(31 downto 0);
    dDataIn  : in  std_logic_vector(31 downto 0)
  );
end processor;

architecture rtl of processor is

  component control_unit
    port (
      ins_code   : in  std_logic_vector(5 downto 0);
      alu_src    : out std_logic;
      alu_op     : out std_logic_vector(1 downto 0);
      reg_dst    : out std_logic;
      branch     : out std_logic;
      mem_wr_en  : out std_logic;
      mem_rd_en  : out std_logic;
      mem_to_reg : out std_logic;
      reg_wr_en  : out std_logic;
      jmp        : out std_logic
    );
  end component;

  component reg_bank
    port (
      clk        : in  std_logic;
      reset      : in  std_logic;
      reg_dir_1  : in  std_logic_vector( 4 downto 0);
      reg_dir_2  : in  std_logic_vector( 4 downto 0);
      reg_wr_dir : in  std_logic_vector( 4 downto 0);
      reg_wr     : in  std_logic_vector(31 downto 0);
      wr_en      : in  std_logic;
      reg_1      : out std_logic_vector(31 downto 0);
      reg_2      : out std_logic_vector(31 downto 0)
    );
  end component;

  component alu_control
    port (
      alu_op  : in  std_logic_vector(1 downto 0);
      func    : in  std_logic_vector(5 downto 0);
      reg_dst : in  std_logic;
      control : out std_logic_vector(3 downto 0)
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
  
  component forwarding_unit
    port (
      reg_dir_1        : in  std_logic_vector(4 downto 0);
      reg_dir_2        : in  std_logic_vector(4 downto 0);
      reg_dst_dir_mem  : in  std_logic_vector(4 downto 0);
      reg_wr_en_mem    : in  std_logic;
      reg_dst_dir_wb   : in  std_logic_vector(4 downto 0);
      reg_wr_en_wb     : in  std_logic;
      alu_op_a_control : out std_logic_vector(1 downto 0);
      alu_op_b_control : out std_logic_vector(1 downto 0)
    );
  end component;

  component hazard_detection_unit
    port (
      reg_dir_1   : in  std_logic_vector(4 downto 0);
      reg_dir_2   : in  std_logic_vector(4 downto 0);
      reg_dst_dir : in  std_logic_vector(4 downto 0);
      mem_rd_en   : in  std_logic;
      pc_wr_en    : out std_logic;
      if_id_wr_en : out std_logic;
      id_ex_reset : out std_logic
    );
  end component;

  ---------- IF segment signals ----------
  signal pc_if    : std_logic_vector(31 downto 0);
  signal ins_if   : std_logic_vector(31 downto 0);
  signal pc_in    : std_logic_vector(31 downto 0);
  signal pc_out   : std_logic_vector(31 downto 0);
  signal pc_wr_en : std_logic;

  ---------- ID segment signals ----------
  signal pc_id            : std_logic_vector(31 downto 0);
  signal ins_id           : std_logic_vector(31 downto 0);
  signal reg_1_id         : std_logic_vector(31 downto 0);
  signal reg_2_id         : std_logic_vector(31 downto 0);
  signal reg_dir_1_id     : std_logic_vector( 4 downto 0);
  signal reg_dir_2_id     : std_logic_vector( 4 downto 0);
  signal reg_dst_dir_1_id : std_logic_vector( 4 downto 0);
  signal reg_dst_dir_2_id : std_logic_vector( 4 downto 0);
  signal sign_ext_id      : std_logic_vector(31 downto 0);
  signal pc_jmp           : std_logic_vector(31 downto 0);
  signal pc_branch        : std_logic_vector(31 downto 0);
  signal pc_src           : std_logic_vector( 1 downto 0);
  signal if_id_wr_en      : std_logic;
  signal branch           : std_logic;
  signal branch_effective : std_logic;
  -- Used in ID
  signal jmp : std_logic;
  -- Used in EX
  signal alu_src_id : std_logic;
  signal alu_op_id  : std_logic_vector(1 downto 0);
  signal reg_dst_id : std_logic;
  -- Used in MEM
  signal mem_wr_en_id : std_logic;
  signal mem_rd_en_id : std_logic;
  -- Used in WB
  signal mem_to_reg_id : std_logic;
  signal reg_wr_en_id  : std_logic;

  ---------- EX segment signals ----------
  signal pc_jmp_ex        : std_logic_vector(31 downto 0);
  signal reg_1_ex         : std_logic_vector(31 downto 0);
  signal reg_2_ex         : std_logic_vector(31 downto 0);
  signal alu_res_ex       : std_logic_vector(31 downto 0);
  signal reg_dir_1_ex     : std_logic_vector( 4 downto 0);
  signal reg_dir_2_ex     : std_logic_vector( 4 downto 0);
  signal reg_dst_dir_1_ex : std_logic_vector( 4 downto 0);
  signal reg_dst_dir_2_ex : std_logic_vector( 4 downto 0);
  signal reg_dst_dir_ex   : std_logic_vector( 4 downto 0);
  signal sign_ext_ex      : std_logic_vector(31 downto 0);
  signal alu_op_a         : std_logic_vector(31 downto 0);
  signal alu_op_b         : std_logic_vector(31 downto 0);
  signal alu_op_a_control : std_logic_vector( 1 downto 0);
  signal alu_op_b_control : std_logic_vector( 1 downto 0);
  signal control          : std_logic_vector( 3 downto 0);
  signal id_ex_reset      : std_logic;
  -- Used in EX
  signal alu_src_ex : std_logic;
  signal alu_op_ex  : std_logic_vector(1 downto 0);
  signal reg_dst_ex : std_logic;
  -- Used in MEM
  signal mem_wr_en_ex : std_logic;
  signal mem_rd_en_ex : std_logic;
  -- Used in WB
  signal mem_to_reg_ex : std_logic;
  signal reg_wr_en_ex  : std_logic;

  ---------- MEM segment signals ----------
  signal reg_2_mem       : std_logic_vector(31 downto 0);
  signal alu_res_mem     : std_logic_vector(31 downto 0);
  signal reg_dst_dir_mem : std_logic_vector( 4 downto 0);
  signal data_mem        : std_logic_vector(31 downto 0);
  -- Used in MEM
  signal mem_wr_en_mem : std_logic;
  signal mem_rd_en_mem : std_logic;
  -- Used in WB
  signal mem_to_reg_mem : std_logic;
  signal reg_wr_en_mem  : std_logic;

  ---------- WB segment signals ----------
  signal alu_res_wb     : std_logic_vector(31 downto 0);
  signal data_wb        : std_logic_vector(31 downto 0);
  signal reg_wr         : std_logic_vector(31 downto 0);
  signal reg_dst_dir_wb : std_logic_vector( 4 downto 0);
  -- Used in WB
  signal mem_to_reg_wb : std_logic;
  signal reg_wr_en_wb  : std_logic;

begin  

  ---------- IF segment connections ----------
  
  -- Instruction memory "portmap"
  iAddr <= pc_out;
  ins_if <= iDataIn;

  pc_in <= pc_if when pc_src = "00" else pc_jmp when pc_src = "01" else pc_branch when pc_src = "10";
  pc_if <= pc_out + 4;

  ---------- ID segment connections ----------

  control_unit_port_map: control_unit port map (
    ins_code   => ins_id(31 downto 26),
    alu_src    => alu_src_id,
    alu_op     => alu_op_id,
    reg_dst    => reg_dst_id,
    branch     => branch,
    mem_wr_en  => mem_wr_en_id,
    mem_rd_en  => mem_rd_en_id,
    mem_to_reg => mem_to_reg_id,
    reg_wr_en  => reg_wr_en_id,
    jmp        => jmp
  );

  reg_bank_port_map: reg_bank port map (
    clk        => clk,
    reset      => reset,
    reg_dir_1  => reg_dir_1_id,
    reg_dir_2  => reg_dir_2_id,
    reg_wr_dir => reg_dst_dir_wb,
    wr_en      => reg_wr_en_wb,
    reg_wr     => reg_wr,
    reg_1      => reg_1_id,
    reg_2      => reg_2_id
  );

  reg_dir_1_id <= ins_id(25 downto 21);
  reg_dir_2_id <= ins_id(20 downto 16);
  reg_dst_dir_1_id <= ins_id(20 downto 16);
  reg_dst_dir_2_id <= ins_id(15 downto 11);

  sign_ext_id <= "00000000000000000" & ins_id(14 downto 0) when ins_id(15) = '0' else "11111111111111111" & ins_id(14 downto 0);
  pc_jmp <= "0000" & ins_id(25 downto 0) & "00";
  branch_effective <= '1' when reg_1_id = reg_2_id else '0';
  pc_branch <= pc_id + (sign_ext_id(29 downto 0) & "00");
  pc_src <= "10" when branch = '1' and branch_effective = '1' else "01" when jmp = '1' else "00";

  ---------- EX segment connections ----------

  alu_control_port_map: alu_control port map (
    func    => sign_ext_ex(5 downto 0),
    alu_op  => alu_op_ex,
    reg_dst => reg_dst_ex,
    control => control
  );

  alu_port_map: alu port map (
    op_a    => alu_op_a,
    op_b    => alu_op_b,
    control => control,
    res     => alu_res_ex
  );

  forwarding_unit_port_map: forwarding_unit port map (
    reg_dir_1        => reg_dir_1_ex,
    reg_dir_2        => reg_dir_2_ex,
    reg_dst_dir_mem  => reg_dst_dir_mem,
    reg_wr_en_mem    => reg_wr_en_mem,
    reg_dst_dir_wb   => reg_dst_dir_wb,
    reg_wr_en_wb     => reg_wr_en_wb,
    alu_op_a_control => alu_op_a_control,
    alu_op_b_control => alu_op_b_control
  );

  hazard_detection_unit_port_map: hazard_detection_unit port map (
    reg_dir_1   => reg_dir_1_id,
    reg_dir_2   => reg_dir_2_id,
    reg_dst_dir => reg_dst_dir_1_ex,
    mem_rd_en   => mem_rd_en_ex,
    pc_wr_en    => pc_wr_en,
    if_id_wr_en => if_id_wr_en,
    id_ex_reset => id_ex_reset
  );

  alu_op_a <=
    reg_1_ex    when alu_op_a_control = "00" else
    alu_res_mem when alu_op_a_control = "01" else
    reg_wr;
  alu_op_b <=
    sign_ext_ex when alu_src_ex = '1' else
    reg_2_ex    when alu_op_b_control = "00" else
    alu_res_mem when alu_op_b_control = "01" else
    reg_wr;
  reg_dst_dir_ex <= reg_dst_dir_1_ex when reg_dst_ex = '0' else reg_dst_dir_2_ex;

  ---------- MEM segment connections ----------

  -- Data memory "portmap"
  dAddr <= alu_res_mem;
  dRdEn <= mem_rd_en_mem;
  dWrEn <= mem_wr_en_mem;
  dDataOut <= reg_2_mem;
  data_mem <= dDataIn;

  ---------- WB segment connections ----------

  reg_wr <= alu_res_wb when mem_to_reg_wb = '0' else data_wb;

  ---------- PC register ----------
  process (clk, reset)
  begin
    if reset = '1' then
      pc_out <= (others => '0');
    elsif rising_edge(clk) and clk = '1' and pc_wr_en = '1' then
      pc_out <= pc_in;
    end if;
  end process;

  ---------- IF/ID register ----------
  process (clk, reset)
  begin
    if reset = '1' then
      pc_id <= (others => '0');
      ins_id <= (others => '0');
    elsif rising_edge(clk) and clk = '1' and if_id_wr_en = '1' then
      pc_id <= pc_if;
      ins_id <= ins_if;
    end if;
  end process;

  ---------- ID/EX register ----------
  process (clk, reset)
  begin
    if reset = '1' or (rising_edge(clk) and clk = '1' and id_ex_reset = '1') then
      reg_1_ex <= (others => '0');
      reg_2_ex <= (others => '0');
      reg_dir_1_ex <= (others => '0');
      reg_dir_2_ex <= (others => '0');
      reg_dst_dir_1_ex <= (others => '0');
      reg_dst_dir_2_ex <= (others => '0');
      sign_ext_ex <= (others => '0');
      -- Used in EX
      alu_src_ex <= '0';
      alu_op_ex <= (others => '0');
      reg_dst_ex <= '0';
      -- Used in MEM
      mem_wr_en_ex <= '0';
      mem_rd_en_ex <= '0';
      -- Used in WB
      mem_to_reg_ex <= '0';
      reg_wr_en_ex <= '0';
    elsif rising_edge(clk) and clk = '1' then
      reg_1_ex <= reg_1_id;
      reg_2_ex <= reg_2_id;
      reg_dir_1_ex <= reg_dir_1_id;
      reg_dir_2_ex <= reg_dir_2_id;
      reg_dst_dir_1_ex <= reg_dst_dir_1_id;
      reg_dst_dir_2_ex <= reg_dst_dir_2_id;
      sign_ext_ex <= sign_ext_id;
      -- Used in EX
      alu_src_ex <= alu_src_id;
      alu_op_ex <= alu_op_id;
      reg_dst_ex <= reg_dst_id;
      -- Used in MEM
      mem_wr_en_ex <= mem_wr_en_id;
      mem_rd_en_ex <= mem_rd_en_id;
      -- Used in WB
      mem_to_reg_ex <= mem_to_reg_id;
      reg_wr_en_ex <= reg_wr_en_id;
    end if;
  end process;

  ---------- EX/MEM register ----------
  process (clk, reset)
  begin
    if reset = '1' then
      reg_2_mem <= (others => '0');
      alu_res_mem <= (others => '0');
      reg_dst_dir_mem <= (others => '0');
      -- Used in MEM
      mem_wr_en_mem <= '0';
      mem_rd_en_mem <= '0';
      -- Used in WB
      mem_to_reg_mem <= '0';
      reg_wr_en_mem <= '0';
    elsif rising_edge(clk) and clk = '1' then
      reg_2_mem <= reg_2_ex;
      alu_res_mem <= alu_res_ex;
      reg_dst_dir_mem <= reg_dst_dir_ex;
      -- Used in MEM
      mem_wr_en_mem <= mem_wr_en_ex;
      mem_rd_en_mem <= mem_rd_en_ex;
      -- Used in WB
      mem_to_reg_mem <= mem_to_reg_ex;
      reg_wr_en_mem <= reg_wr_en_ex;
    end if;
  end process;

  ---------- MEM/WB register ----------
  process (clk, reset)
  begin
    if reset = '1' then
      alu_res_wb <= (others => '0');
      data_wb <= (others => '0');
      alu_res_wb <= (others => '0');
      reg_dst_dir_wb <= (others => '0');
      -- Used in WB
      mem_to_reg_wb <= '0';
      reg_wr_en_wb <= '0';
    elsif rising_edge(clk) and clk = '1' then
      alu_res_wb <= alu_res_mem;
      data_wb <= data_mem;
      alu_res_wb <= alu_res_mem;
      reg_dst_dir_wb <= reg_dst_dir_mem;
      -- Used in WB
      mem_to_reg_wb <= mem_to_reg_mem;
      reg_wr_en_wb <= reg_wr_en_mem;
    end if;
  end process;

end architecture;
