-- Copyright (C) 2018  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details.

-- PROGRAM		"Quartus Prime"
-- VERSION		"Version 18.0.0 Build 614 04/24/2018 SJ Lite Edition"
-- CREATED		"Tue Jan 12 09:49:06 2021"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY CPU IS 
	PORT
	(
		MAX10_CLK1_50 :  IN  STD_LOGIC;
		SW :  IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
		HEX0 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		HEX1 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		HEX2 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		HEX3 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		HEX4 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		HEX5 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		LEDR :  OUT  STD_LOGIC_VECTOR(9 DOWNTO 0)
		
	);
END CPU;

ARCHITECTURE bdf_type OF CPU IS 

COMPONENT register4
	PORT( clk, clr, ld : IN STD_LOGIC;
						  d : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
						  q : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;
					

COMPONENT register8
	PORT( clk, clr, ld : IN STD_LOGIC;
						  d : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
						  q : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;


COMPONENT seg7_lut
	PORT(iDIG : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 oSEG : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END COMPONENT;

COMPONENT dig2dec
	PORT(vol : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 seg0 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 seg1 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 seg2 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 seg3 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 seg4 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;

COMPONENT ALU
	PORT( clk, rst : IN STD_LOGIC;
				  a,b : IN STD_LOGIC_VECTOR(3 downto 0);
      ALU_command : IN STD_LOGIC_VECTOR(3 downto 0);
		 ALU_output : OUT STD_LOGIC_VECTOR(3 downto 0)
	);
END COMPONENT;

COMPONENT Decoder 
   Port (clk, rst : IN STD_LOGIC;
           Ra, Rb : IN STD_LOGIC_VECTOR(3 downto 0);
			  opcode : IN STD_LOGIC_VECTOR(7 downto 0);
      ALU_command : OUT STD_LOGIC_VECTOR(3 downto 0);
			     a,b : OUT STD_LOGIC_VECTOR (3 downto 0)
	);
END COMPONENT;

COMPONENT Ram
   PORT (
      rw, en : IN STD_LOGIC;
      clk, rst : IN STD_LOGIC;
      Adress : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      Data_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      Data_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
   );
END COMPONENT;

COMPONENT ROM
   PORT (
      address : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      data_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
   );
END COMPONENT;

COMPONENT Fetch
  PORT(
    en        : IN STD_LOGIC;
    clk       : IN STD_LOGIC;
    rst       : IN STD_LOGIC;
    PC_load   : IN STD_LOGIC;
    PC_Jump   : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    PC_out    : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END COMPONENT;



SIGNAL	zero :  STD_LOGIC;
SIGNAL	one :  STD_LOGIC;
SIGNAL	HEX_out0 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	HEX_out1 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	HEX_out2 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	HEX_out3 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	HEX_out4 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	seg7_in0 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	seg7_in1 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	seg7_in2 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	seg7_in3 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	seg7_in4 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	seg7_in5 :  STD_LOGIC_VECTOR(7 DOWNTO 0);

--below are custom signals added 

SIGNAL ALU_command_signal : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL ALU_output_signal : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL Data_out : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL Data_in : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL rom_data_out : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL Adress : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL address : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL a_signal : STD_LOGIC_VECTOR (3 downto 0);
SIGNAL b_signal : STD_LOGIC_VECTOR (3 downto 0);




BEGIN 











b2v_inst : seg7_lut
PORT MAP(iDIG => seg7_in0,
		 oSEG => HEX_out4(6 DOWNTO 0));


b2v_inst1 : seg7_lut
PORT MAP(iDIG => seg7_in1,
		 oSEG => HEX_out3(6 DOWNTO 0));



b2v_inst2 : seg7_lut
PORT MAP(iDIG => seg7_in2,
		 oSEG => HEX_out2(6 DOWNTO 0));

		 

b2v_inst3 : seg7_lut
PORT MAP(iDIG => seg7_in3,
		 oSEG => HEX_out1(6 DOWNTO 0));


b2v_inst4 : seg7_lut
PORT MAP(iDIG => seg7_in4,
		 oSEG => HEX_out0(6 DOWNTO 0));


b2v_inst5 : dig2dec
PORT MAP(		 vol => "1101010110101010",
		 seg0 => seg7_in4,
		 seg1 => seg7_in3,
		 seg2 => seg7_in2,
		 seg3 => seg7_in1,
		 seg4 => seg7_in0;

--below are custom inst blocs added
		 
alu_inst : alu
PORT MAP(
        clk => MAX10_CLK1_50,
        rst => rst,
        a => decoder_signals.a,
        b => decoder_signals.b,
        ALU_command => ALU_command_signal,
        ALU_output => ALU_output_signal );

decoder_inst : decoder
PORT MAP (
        clk => clk,
        rst => rst,
        Ra => -- your signal or value here,
        Rb => -- your signal or value here,
        opcode => -- your signal or value here,
        ALU_command => ALU_command_signal,
        a => seg7_in0,
        b => seg7_in1);

		
RAM_inst : Ram
PORT MAP (
         rw => rw,
         en => en,
         clk => MAX10_CLK1_50,
         rst => rst,
         Adress => Adress,
         Data_in => Data_in,
         Data_out => Data_out);	

rom_inst : ROM
PORT MAP (
			address => adress,
			data_out => rom_data_out);
	
fetch_inst : Fetch
PORT MAP (
    en => en_signal,
    clk => MAX10_CLK1_50,
    rst => rst,
    PC_load => some_signal_for_PC_load,
    PC_Jump => some_signal_for_PC_jump,
    PC_out => Address);

register4a_inst : register4
PORT MAP (
	 d => Ra,
    ld =>,
    clr => ,
    clk => MAX10_CLK1_50,
    q=>,   ); -- peut etre la flèche est dans l'autre sens ici?
		 
register4b_inst : register4
PORT MAP (
	 d => Rb,
    ld =>,
    clr => ,
    clk => MAX10_CLK1_50,
    q=>,   ); -- peut etre la flèche est dans l'autre sens ici?

-- il faut selectionner pour chaque registre sa fonction spécifique nn?
	 
register8_1_inst : register8
PORT MAP (
	 d =>,
    ld =>,
    clr => ,
    clk => MAX10_CLK1_50,
    q=>,   ); -- peut etre la flèche est dans l'autre sens ici?

HEX0 <= HEX_out0;
HEX1 <= HEX_out1;
HEX2 <= HEX_out2;
HEX3 <= HEX_out3;
HEX4 <= HEX_out4;
HEX5(7) <= one;
HEX5(6) <= one;
HEX5(5) <= one;
HEX5(4) <= one;
HEX5(3) <= one;
HEX5(2) <= one;
HEX5(1) <= one;
HEX5(0) <= one;

zero <= '0';
one <= '1';
HEX_out0(7) <= '1';
HEX_out1(7) <= '1';
HEX_out2(7) <= '1';
HEX_out3(7) <= '1';
HEX_out4(7) <= '1';



LEDR <= SW;

END bdf_type;