library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processor is
generic (
    N : integer := 32; -- default value is 32, but it can be changed
    I : integer := 8;  -- default value is 8, but it can be changed
    J : integer := 24  -- default value is 24, but it can be changed
);
    port (clock, reset : in std_logic;
          Instruction : in std_logic_vector(N-1 downto 0);
          PSR_in : in std_logic_vector(N-1 downto 0);
          DATAIN : in std_logic_vector(31 downto 0);
          DATAOUT : out std_logic_vector(31 downto 0);
          WE : in std_logic
          );
end entity processor;

architecture arch_processor of processor is
    -- Les signaux de contrôle pour l'instruction decoder
    signal nPCsel, RegWr, ALUSrc, PSREn, MemWr, WrSrc, RegSel: std_logic;
    signal ALUCtr :  std_logic_vector(1 downto 0);
    signal OP: std_logic_vector(1 downto 0);
    signal Rn, Rd, Rm: std_logic_vector(3 downto 0);
    signal Imm: std_logic_vector(I-1 downto 0);
    signal Offset: std_logic_vector(J-1 downto 0);
    signal a, b : std_logic_vector(31 downto 0);
    signal s : std_logic_vector(31 downto 0);
    begin
        -- Instruction Decoder
    inst_dec: entity work.decodeur 
        port map (
                instruction => instruction,
        PSR_in => PSR_in,
        ALUCtr => ALUCtr,
        ALUSrc => ALUSrc,
        WrSrc => WrSrc,
        nPCSel => nPCSel,
        RegSel => RegSel,
        PSREn => PSREn,
        MemWr => MemWr,
        RegWr => RegWr,
        offset => offset,
        Rn => Rn,
        Rd => Rd,
        Rm => Rm,
        Imm => Imm
            );

        -- Unité de traitement (UAL)
        ALU: entity work.alu
            port map (
                OP => OP,
                a => a,
                b => b,
                s => s
            );

        -- Unité de contrôle (control_unit)
        UC: entity work.UC
            port map (
                DATAIN => DATAIN,
                RST => reset,
                CLK => clock,
                WE => WE,
                DATAOUT => DATAOUT
            );

end architecture arch_processor;
