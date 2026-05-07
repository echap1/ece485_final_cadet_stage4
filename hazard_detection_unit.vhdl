library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity hazard_detection_unit is
    Port (
        reset :          in STD_LOGIC;
        if_id_mem_read : in STD_LOGIC;                      -- previous instr mem read
        if_id_load_addr : in STD_LOGIC;                     -- previous instr load addr
        instr    : in STD_LOGIC_VECTOR(31 downto 0);        -- current  instr
        if_id_instr    : in STD_LOGIC_VECTOR(31 downto 0);  -- previous instr
        if_id_rd       : in STD_LOGIC_VECTOR(4 downto 0);   -- previous instr destination register
        rs1      : in STD_LOGIC_VECTOR(4 downto 0);         -- current  instr source register
        rs2      : in STD_LOGIC_VECTOR(4 downto 0);         -- current  instr source register
        -- need any other input registers?
        stall_counter  : in integer range 0 to 3 := 0;
        start_stall    : out STD_LOGIC;
        double_stall   : out STD_LOGIC
    );
end hazard_detection_unit;

-- NOTE: only looks one instruction before dependency (not two or three before)
architecture Behavioral of hazard_detection_unit is
    -- internal signals: opcodes of the current and previous instructions
    signal opcode       : STD_LOGIC_VECTOR(6 downto 0);
    signal if_id_opcode : STD_LOGIC_VECTOR(6 downto 0);

    -- opcode constants (match control_unit.vhdl)
    constant OPCODE_ADD       : STD_LOGIC_VECTOR(6 downto 0) := "0110011";
    constant OPCODE_ADDI      : STD_LOGIC_VECTOR(6 downto 0) := "0010011"; -- ADDI / SUBI
    constant OPCODE_LOAD_ADDR : STD_LOGIC_VECTOR(6 downto 0) := "0010111";
    constant OPCODE_LW        : STD_LOGIC_VECTOR(6 downto 0) := "0000011";
    constant OPCODE_SW        : STD_LOGIC_VECTOR(6 downto 0) := "0100011";
    constant OPCODE_BNE       : STD_LOGIC_VECTOR(6 downto 0) := "1100011";
    constant OPCODE_J         : STD_LOGIC_VECTOR(6 downto 0) := "1101111";
begin
    opcode       <= instr(6 downto 0);
    if_id_opcode <= if_id_instr(6 downto 0);

    process(if_id_mem_read, if_id_rd, rs1, rs2, if_id_opcode, opcode, stall_counter) -- any others?)
    begin      
        if (reset = '1') then
            start_stall <= '0';
            double_stall <= '0';
        -- stall cases, dependency on a (1)load from memory, (2) load_addr
        elsif (if_id_opcode = OPCODE_LW or         -- LW
               if_id_opcode = OPCODE_LOAD_ADDR)    -- load_addr
              and (
                if_id_rd /= "00000" and
                (rs1 = if_id_rd or rs2 = if_id_rd)
              ) then -- single stall data dependency case
                start_stall <= '1';
                double_stall <= '0';
        elsif (
            if_id_opcode = OPCODE_ADD or
            if_id_opcode = OPCODE_ADDI
        ) --(3) add, (4) addi/subi
              and (if_id_rd /= "00000" and (rs1 = if_id_rd or rs2 = if_id_rd))  -- stall data dependency case
              and (opcode = OPCODE_BNE) then --BNE double stall
                    start_stall <= '1';
                    double_stall <= '0';
        elsif -- stall cases for branch or jump, needing time to calulate branch address, etc
              (if_id_opcode = OPCODE_BNE or if_id_opcode = OPCODE_J) and stall_counter = 0 then
                start_stall <= '1';
                double_stall <= '1';
        else
                start_stall <= '0';
                double_stall <= '0';
        end if;

    end process;
end Behavioral;
