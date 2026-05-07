library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pipeline_registers is
    Port (
        clk         : in  STD_LOGIC;
        reset       : in  STD_LOGIC;
        start_stall : in  STD_LOGIC;
        stall_counter : in integer;
      

        -- inputs from IF stage
        reg_write : in STD_LOGIC;
        alu_src : in STD_LOGIC;
        mem_read : in STD_LOGIC;
        mem_write : in STD_LOGIC;
        branch : in STD_LOGIC;
        jump : in STD_LOGIC;
        load_addr : in STD_LOGIC;
        instr : in  STD_LOGIC_VECTOR(31 downto 0);
        npc    : in  STD_LOGIC_VECTOR(31 downto 0);
        rd     : in  STD_LOGIC_VECTOR(4 downto 0);
        rs1     : in  STD_LOGIC_VECTOR(4 downto 0);
        rs2     : in  STD_LOGIC_VECTOR(4 downto 0);
        alu_op : in  STD_LOGIC_VECTOR(3 downto 0);
        alu_result : in  STD_LOGIC_VECTOR(31 downto 0);
        -- <add other IF registers?>
        
        -- IF/ID pipeline registers
        if_id_reg_write : inout STD_LOGIC;
        if_id_alu_src : inout STD_LOGIC;
        if_id_mem_read : inout STD_LOGIC;
        if_id_mem_write : inout STD_LOGIC;
        if_id_branch : inout STD_LOGIC;
        if_id_jump : inout STD_LOGIC;
        if_id_load_addr : inout STD_LOGIC;
        if_id_instr : inout  STD_LOGIC_VECTOR(31 downto 0);
        if_id_npc   : inout  STD_LOGIC_VECTOR(31 downto 0);
        if_id_rd    : inout  STD_LOGIC_VECTOR(4 downto 0);
        if_id_rs1    : inout  STD_LOGIC_VECTOR(4 downto 0);
        if_id_rs2    : inout  STD_LOGIC_VECTOR(4 downto 0);

        if_id_reg1_data  : in  STD_LOGIC_VECTOR(31 downto 0);
        if_id_reg2_data  : in  STD_LOGIC_VECTOR(31 downto 0);
        if_id_imm        : in  STD_LOGIC_VECTOR(31 downto 0);
        
        if_id_alu_op : inout STD_LOGIC_VECTOR(3 downto 0);
        -- <add other if_id registers>
        
        -- ID/EX pipeline registers
        id_ex_reg_write : inout STD_LOGIC;
        id_ex_alu_src : inout STD_LOGIC;
        id_ex_mem_read : inout STD_LOGIC;
        id_ex_mem_write : inout STD_LOGIC;
        id_ex_branch : inout STD_LOGIC;
        id_ex_jump : inout STD_LOGIC;
        id_ex_load_addr : inout STD_LOGIC;
        id_ex_instr     : inout STD_LOGIC_VECTOR(31 downto 0);
        id_ex_npc       : inout STD_LOGIC_VECTOR(31 downto 0);
        id_ex_rd        : inout STD_LOGIC_VECTOR(4 downto 0);
        id_ex_rs1    : inout  STD_LOGIC_VECTOR(4 downto 0);
        id_ex_rs2    : inout  STD_LOGIC_VECTOR(4 downto 0);
        id_ex_reg1_data : inout STD_LOGIC_VECTOR(31 downto 0);
        id_ex_reg2_data : inout STD_LOGIC_VECTOR(31 downto 0);
        id_ex_imm       : inout STD_LOGIC_VECTOR(31 downto 0);
        id_ex_alu_op    : inout STD_LOGIC_VECTOR(3 downto 0);
        -- <add other id_ex registers>
        
        -- EX/MEM pipeline registers        
        ex_mem_reg_write : inout STD_LOGIC;
        ex_mem_alu_src : inout STD_LOGIC;
        ex_mem_mem_read : inout STD_LOGIC;
        ex_mem_mem_write : inout STD_LOGIC;
        ex_mem_branch : inout STD_LOGIC;
        ex_mem_jump : inout STD_LOGIC;
        ex_mem_load_addr : inout STD_LOGIC;
        ex_mem_instr      : inout STD_LOGIC_VECTOR(31 downto 0);
        ex_mem_npc        : inout STD_LOGIC_VECTOR(31 downto 0);
        ex_mem_rd         : inout STD_LOGIC_VECTOR(4 downto 0);
        ex_mem_reg1_data  : inout STD_LOGIC_VECTOR(31 downto 0);
        ex_mem_reg2_data  : inout STD_LOGIC_VECTOR(31 downto 0);
        ex_mem_alu_result : inout STD_LOGIC_VECTOR(31 downto 0);
        ex_mem_imm       : inout STD_LOGIC_VECTOR(31 downto 0);
        -- <add other ex_mem registers>
        
        -- MEM/WB pipeline registers
        mem_wb_reg_write : out STD_LOGIC;
        mem_wb_alu_src : out STD_LOGIC;
        mem_wb_mem_read : out STD_LOGIC;
        mem_wb_mem_write : out STD_LOGIC;
        mem_wb_load_addr : out STD_LOGIC;
        mem_wb_instr      : out STD_LOGIC_VECTOR(31 downto 0);
        mem_wb_npc        : out STD_LOGIC_VECTOR(31 downto 0);
        mem_wb_rd         : out STD_LOGIC_VECTOR(4 downto 0);
        mem_wb_alu_result : out STD_LOGIC_VECTOR(31 downto 0)
        -- <add other mem_wb registers>
      
      
    );
end pipeline_registers;

architecture Behavioral of pipeline_registers is
begin
    process(clk, reset)
    begin
        if (reset = '1') then
            if_id_reg_write <= '0';
            if_id_alu_src <= '0';
            if_id_mem_read <= '0';
            if_id_mem_write <= '0';
            if_id_branch <= '0';
            if_id_jump <= '0';
            if_id_load_addr <= '0';
            if_id_instr <= (others => '0');
            if_id_npc    <= (others => '0');
            if_id_rd     <= (others => '0');
            if_id_rs1     <= (others => '0');
            if_id_rs2     <= (others => '0');
            if_id_alu_op <= (others => '0');
            
            id_ex_reg_write <= '0';
            id_ex_alu_src   <= '0';
            id_ex_mem_read  <= '0';
            id_ex_mem_write <= '0';
            id_ex_branch    <= '0';
            id_ex_jump      <= '0';
            id_ex_load_addr <= '0';
            id_ex_instr     <= (others => '0');
            id_ex_npc       <= (others => '0');
            id_ex_rd        <= (others => '0');
            id_ex_reg1_data <= (others => '0');
            id_ex_reg2_data <= (others => '0');
            id_ex_imm       <= (others => '0');
            id_ex_alu_op    <= (others => '0');

            ex_mem_reg_write  <= '0';
            ex_mem_alu_src    <= '0';
            ex_mem_mem_read   <= '0';
            ex_mem_mem_write  <= '0';
            ex_mem_branch     <= '0';
            ex_mem_jump       <= '0';
            ex_mem_load_addr  <= '0';
            ex_mem_instr      <= (others => '0');
            ex_mem_npc        <= (others => '0');
            ex_mem_rd         <= (others => '0');
            ex_mem_imm         <= (others => '0');
            ex_mem_reg1_data  <= (others => '0');
            ex_mem_reg2_data  <= (others => '0');
            ex_mem_alu_result <= (others => '0');

            mem_wb_reg_write  <= '0';
            mem_wb_alu_src    <= '0';
            mem_wb_mem_read   <= '0';
            mem_wb_mem_write  <= '0';
            mem_wb_load_addr  <= '0';
            mem_wb_instr      <= (others => '0');
            mem_wb_npc        <= (others => '0');
            mem_wb_rd         <= (others => '0');
            mem_wb_alu_result <= (others => '0');
            -- <add other registers>

        elsif rising_edge(clk) then
            if (start_stall = '1' or stall_counter = 3 or stall_counter = 2) then  -- if stall, then insert a NOP
                if_id_reg_write <= '0';
                if_id_alu_src <= '0';
                if_id_mem_read <= '0';
                if_id_mem_write <= '0';
                if_id_branch <= '0';
                if_id_jump <= '0';
                if_id_load_addr <= '0';
                if_id_instr <= (others => '0');
                if_id_npc    <= (others => '0');
                if_id_rd     <= (others => '0');
                if_id_rs1     <= (others => '0');
                if_id_rs2     <= (others => '0');
                if_id_alu_op <= (others => '0');

                -- <add other registers>

                                
            else               -- when stall resumes, the old fetched instruction should still be there
                if_id_reg_write <= reg_write;
                if_id_alu_src <= alu_src;
                if_id_mem_read <= mem_read;
                if_id_mem_write <= mem_write;
                if_id_branch <= branch;
                if_id_jump <= jump;
                if_id_load_addr <= load_addr;
                if_id_instr <= instr;
                if_id_npc <= npc;
                if_id_rd  <= rd;
                if_id_rs1  <= rs1;
                if_id_rs2  <= rs2;
                if_id_alu_op <= alu_op;

                -- <add other registers>

            end if;      
            -- let instructions prior to stall complete, or move to next state
            id_ex_reg_write <= if_id_reg_write;
            id_ex_alu_src   <= if_id_alu_src;
            id_ex_mem_read  <= if_id_mem_read;
            id_ex_mem_write <= if_id_mem_write;
            id_ex_branch    <= if_id_branch;
            id_ex_jump      <= if_id_jump;
            id_ex_load_addr <= if_id_load_addr;
            id_ex_instr     <= if_id_instr;
            id_ex_npc       <= if_id_npc;
            id_ex_rd        <= if_id_rd;
            id_ex_rs1        <= if_id_rs1;
            id_ex_rs2        <= if_id_rs2;
            id_ex_reg1_data <= if_id_reg1_data;
            id_ex_reg2_data <= if_id_reg2_data;
            id_ex_imm       <= if_id_imm;
            id_ex_alu_op    <= if_id_alu_op;
            -- <add other registers>
            ex_mem_reg_write  <= id_ex_reg_write;
            ex_mem_alu_src    <= id_ex_alu_src;
            ex_mem_mem_read   <= id_ex_mem_read;
            ex_mem_mem_write  <= id_ex_mem_write;
            ex_mem_branch     <= id_ex_branch;
            ex_mem_jump       <= id_ex_jump;
            ex_mem_load_addr  <= id_ex_load_addr;
            ex_mem_instr      <= id_ex_instr;
            ex_mem_npc        <= id_ex_npc;
            ex_mem_rd         <= id_ex_rd;
            ex_mem_imm         <= id_ex_imm;
            ex_mem_reg1_data  <= id_ex_reg1_data;
            ex_mem_reg2_data  <= id_ex_reg2_data;
            ex_mem_alu_result <= alu_result;
            -- <add other registers>
            mem_wb_reg_write  <= ex_mem_reg_write;
            mem_wb_alu_src    <= ex_mem_alu_src;
            mem_wb_mem_read   <= ex_mem_mem_read;
            mem_wb_mem_write  <= ex_mem_mem_write;
            mem_wb_load_addr  <= ex_mem_load_addr;
            mem_wb_instr      <= ex_mem_instr;
            mem_wb_npc        <= ex_mem_npc;
            mem_wb_rd         <= ex_mem_rd;
            mem_wb_alu_result <= ex_mem_alu_result;
            -- <add other registers>

        end if;
    end process;
end Behavioral;
