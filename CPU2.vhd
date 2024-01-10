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
		clk :  IN  STD_LOGIC;
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


COMPONENT Decoder 
   Port (clk, rst : IN STD_LOGIC;
         Ra, Rb : IN STD_LOGIC_VECTOR(3 downto 0);
			opcode : IN STD_LOGIC_VECTOR(7 downto 0);
			decoder_enable_ra, decoder_enable_rb: OUT STD_LOGIC;
			ALU_command : OUT STD_LOGIC_VECTOR(3 downto 0);
			a,b : OUT STD_LOGIC_VECTOR (3 downto 0);
	
				  
	);
END COMPONENT;

COMPONENT ALU
	PORT( clk, rst : IN STD_LOGIC;
			ALU_enable_ra, ALU_enable_rb: in STD_LOGIC;
         a,b : IN STD_LOGIC_VECTOR(3 downto 0);
			ALU_command : IN STD_LOGIC_VECTOR(3 downto 0);
			ALU_enable_r : OUT STD_LOGIC;
			ALU_output_a, ALU_output_b : OUT STD_LOGIC_VECTOR(3 downto 0);
	  
	);
END COMPONENT;

COMPONENT register4
	PORT( clk, rst, en : IN STD_LOGIC;
						  d : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
						  q : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;
					

COMPONENT register8
	PORT( clk, rst, en : IN STD_LOGIC;
						  d : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
						  q : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
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
		rw, en : IN STD_LOGIC;
      clk, rst : IN STD_LOGIC;
      Adress : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      Data_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
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
SIGNAL rst : STD_LOGIC_VECTOR

SIGNAL decoder_opcode_signal : STD_LOGIC_VECTOR(7 downto 0);
SIGNAL decoder_enable_ra_signal: STD_LOGIC;
SIGNAL decoder_enable_rb_signal: STD_LOGIC;
SIGNAL decoder_a_signal : STD_LOGIC_VECTOR (3 downto 0);
SIGNAL decoder_b_signal : STD_LOGIC_VECTOR (3 downto 0);

SIGNAL ALU_command_signal : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL ALU_enable_rab_signal: STD_LOGIC;
SIGNAL ALU_output_a : STD_LOGIC_VECTOR(3 downto 0);
SIGNAL ALU_output_b : STD_LOGIC_VECTOR(3 downto 0);


SIGNAL Ra_input_signal : STD_LOGIC_VECTOR(3 DOWNTO 0);--alu outputb A
SIGNAL Rb_input_signal : STD_LOGIC_VECTOR(3 DOWNTO 0);--alu outputb B

SIGNAL Ra_output_signal : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL Ra_output_signal : STD_LOGIC_VECTOR(3 DOWNTO 0);

SIGNAL R1_input_signal : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL R1_out_signal : STD_LOGIC_VECTOR(7 DOWNTO 0);

SIGNAL ram_rw_signal :STD_LOGIC;
SIGNAL ram_en_signal :STD_LOGIC;
SIGNAL ram_Adress_signal :STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL ram_Data_in_signal: STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL ram_Data_out_signal : STD_LOGIC_VECTOR(7 DOWNTO 0);

SIGNAL rom_rw_signal :STD_LOGIC;
SIGNAL rom_en_signal :STD_LOGIC;
SIGNAL rom_Adress_signal :STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL rom_Data_out_signal : STD_LOGIC_VECTOR(7 DOWNTO 0);

SIGNAL fetch_en_signal :STD_LOGIC;
SIGNAL fetch_PC_load_signal :STD_LOGIC;
SIGNAL fetch_PC_Jump_signal :STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL fetch_PC_out_signal : STD_LOGIC_VECTOR(7 DOWNTO 0);





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
		 seg4 => seg7_in0);

--below are custom inst blocs added
		 


decoder_inst : decoder
PORT MAP (
        clk => clk,
        rst => rst,
		  decoder_enable_ra_signal
        Ra => Ra_output_signal,-- your signal or value here,
        Rb => Rb_output_signal, -- your signal or value here,
        opcode => decoder_opcode_signal, -- your signal or value here,
		  decoder_enable_ra => decoder_enable_ra_signal,
		  decoder_enable_rb => decoder_enable_rb_signal,
        ALU_command_signal => ALU_command,
        decoder_a_signal => a,
        decoder_b_signal => b);
		  
alu_inst : alu
PORT MAP(
        clk => clk,
        rst => rst,
        a => a_signal,
        b => b_signal,
		  ALU_enable_ra=> decoder_enable_ra_signal,
		  ALU_enable_rb=> decoder_enable_rb_signal,
        ALU_command => ALU_command_signal,
		  ALU_enable_rab_signal => ALU_enable_r,
        Ra_input_signal => ALU_output_a,
		  Rb_input_signal => ALU_output_b,
		  );

register4a_inst : register4
PORT MAP (
	 d => Ra_input_signal,
    en => ALU_enable_rab_signal,
    rst => rst,
    clk => clk,
    Ra_output_signal=>q,   ); -- peut etre la flèche est dans l'autre sens ici?
		 
register4b_inst : register4
PORT MAP (
	 d => Rb_input_signal,
    en => ALU_enable_rab_signal,
    rst => rst,
    clk => clk,
    Rb_output_signal=>q,   ); -- peut etre la flèche est dans l'autre sens ici?

-- il faut selectionner pour chaque registre sa fonction spécifique nn?
	 
register8_1_inst : register8
PORT MAP (
	 d =>,
    en =>,
    rst => rst,
    clk => clk,
    q=>,   ); -- peut etre la flèche est dans l'autre sens ici?		
		
RAM_inst : Ram
PORT MAP (
         rw => ram_rw_signal,
         en => ram_en_signal,
         clk => clk,
         rst => rst,
         Adress => ram_Adress_signal,
         Data_in => ram_Data_in_signal,
         ram_Data_out_signal => Data_out);	

rom_inst : ROM
PORT MAP (
			rw => rom_rw_signal,
			en => rom_en_signal,
			address => rom_Adress_signal,
			rom_Data_out_signal => data_out);
	
fetch_inst : Fetch
PORT MAP (
    en => fetch_en_signal,
    clk => clk,
    rst => rst,
    PC_load => fetch_PC_load_signal,
    PC_Jump => fetch_PC_Jump_signal,
    fetch_PC_out_signal => PC_out);


	 

	 


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