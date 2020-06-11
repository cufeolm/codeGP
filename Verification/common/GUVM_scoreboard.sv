`uvm_analysis_imp_decl(_mon_trans)
`uvm_analysis_imp_decl(_drv_trans)

`include "GUVM_tb.sv"
class GUVM_scoreboard extends uvm_scoreboard;

	// register the scoreboard in the UVM factory
	`uvm_component_utils(GUVM_scoreboard);

	// analysis implementation ports
	uvm_analysis_imp_mon_trans #(GUVM_result_transaction, GUVM_scoreboard) Mon2Sb_port;
	uvm_analysis_imp_drv_trans #(GUVM_sequence_item, GUVM_scoreboard) Drv2Sb_port;

	// TLM FIFOs to store the drived transaction and result transaction values
	uvm_tlm_fifo #(GUVM_sequence_item) drv_fifo;
	uvm_tlm_fifo #(GUVM_result_transaction) mon_fifo;

	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		//Instantiate the analysis ports and Fifo
		Mon2Sb_port = new("Mon2Sb", this);
		Drv2Sb_port = new("Drv2Sb", this);
		drv_fifo     = new("drv_fifo", this); 
		mon_fifo     = new("mon_fifo", this);
	endfunction : build_phase
	
	// write_drv_trans will be called when the driver broadcasts a transaction to the scoreboard
	function void write_drv_trans (GUVM_sequence_item input_trans);
		void'(drv_fifo.try_put(input_trans));
	endfunction: write_drv_trans

	// write_mon_trans will be called when the monitor broadcasts the DUT results to the scoreboard 
	function void write_mon_trans (GUVM_result_transaction trans);
		void'(mon_fifo.try_put(trans));
	endfunction: write_mon_trans
	
	task run_phase(uvm_phase phase);
		GUVM_sequence_item cmd_trans;	// stores drived transaction
		GUVM_result_transaction res_trans;	// stores result transaction
		GUVM_history_transaction hist_trans;
		bit [31:0] expected1,operand1,operand2,imm,verified_inst;	// stores processed operands data
		integer i;	// index of for loop
		integer valid;	// stores instruction validity in the used core
		hist_trans = new("hist_trans"); 
		forever begin
			//$display("-------------------------------");
			//$display("Scoreboard started");
			drv_fifo.get(cmd_trans); // wait for driver to send drived transaction and get it
			mon_fifo.get(res_trans);
			hist_trans.addItem(cmd_trans,res_trans);

			//if (cmd_trans.v == 1)
			//	mon_fifo.get(res_trans); // wait for monitor to send result transaction and get it
			//$display("Sc********************rd= %0d",cmd_trans.rd);
			//operand1 = cmd_trans.operand1; 
			//operand2 = cmd_trans.operand2;
			verified_inst = cmd_trans.inst;
			//$display("Sb: inst is %b %b %b %b %b %b %b %b", verified_inst[31:28], verified_inst[27:24], verified_inst[23:20], verified_inst[19:16], verified_inst[15:12], verified_inst[11:8], verified_inst[7:4], verified_inst[3:0]);
			//$display("Sb: op1=%0d ", operand1);
			//$display("Sb: op2=%0d", operand2);
			valid = 0;
			if (cmd_trans.SOM==SB_RESET_MODE)begin
                hist_trans.reset(); // resetting core 
			end
			else begin
			// for loob to check that drived instruction is in opcodes array of the core
			for(i=0;i<supported_instructions;i++) // supported instruction is number of instructions in opcodes array of the core
				begin
					//$display("xis1:                 a=%h,b=%h",verified_inst,si_a[i]);
					if (xis1(verified_inst,si_a[i])) begin // si_a is opcodes array of the verified core
						valid = 1;
						break;	// break when instruction found in array to save its index in i
 					end
				end
			if(valid == 0) begin // if valid still zero then instruction isn't found in opcodes array
				if (cmd_trans.inst == cmd_trans.data);
				else`uvm_fatal("instruction fail", $sformatf("Sb: instruction not in pkg and its %b %b %b %b %b %b %b %b", verified_inst[31:28], verified_inst[27:24], verified_inst[23:20], verified_inst[19:16], verified_inst[15:12], verified_inst[11:8], verified_inst[7:4], verified_inst[3:0]))
			end
			//$display("si_a[i] is %s in index %0d",si_a[i].name,i);





			case (si_a[i].name) // determining which instuction we verify  
				"A":begin // add two registers
					verify_add(cmd_trans,res_trans,hist_trans);
				end
				"test":begin // temp instruction 
					verify_test(cmd_trans,res_trans,hist_trans);
				end
				"Jal":begin 
					verify_JumpAndLink(cmd_trans,res_trans,hist_trans);
				end
				"Load":begin 
					verify_load(cmd_trans,res_trans,hist_trans);
				end
				"LSBMA":begin 
					verify_load_s_byte_misaligned(cmd_trans,res_trans,hist_trans);
				end
				"LSHMA":begin 
					verify_load_s_half_word_misaligned(cmd_trans,res_trans,hist_trans);
				end
				"LUBMA":begin 
					verify_load_u_byte_misaligned(cmd_trans,res_trans,hist_trans);
				end
				"LUHMA":begin 
					verify_load_u_half_word_misaligned(cmd_trans,res_trans,hist_trans);
				end
				"LWMA":begin 
					verify_load_word_misaligned(cmd_trans,res_trans,hist_trans);
				end
				"LW":begin 
					verify_load_word(cmd_trans,res_trans,hist_trans);
				end
				"LWMAZE":begin 
					verify_load_word_misaligned_zero_extend(cmd_trans,res_trans,hist_trans);
				end
				"LWMAZERR":begin 
					verify_load_word_misaligned_zero_extend_reg_reg(cmd_trans,res_trans,hist_trans);
				end
				"LBMAZE":begin 
					verify_load_byte_misaligned_zero_extend(cmd_trans,res_trans,hist_trans);
				end
				"LBMAZERR":begin 
					verify_load_byte_misaligned_zero_extend_reg_reg(cmd_trans,res_trans,hist_trans);
				end
				"LWRR":begin 
					verify_load_word_reg_reg(cmd_trans,res_trans,hist_trans);
				end
				"LSBMARR":begin 
					verify_load_s_byte_misaligned_reg_reg(cmd_trans,res_trans,hist_trans);
				end
				"LSHMARR":begin 
					verify_load_s_half_word_misaligned_reg_reg(cmd_trans,res_trans,hist_trans);
				end
				"LUBMARR":begin 
					verify_load_u_byte_misaligned_reg_reg(cmd_trans,res_trans,hist_trans);
				end
				"LUHMARR":begin 
					verify_load_u_half_word_misaligned_reg_reg(cmd_trans,res_trans,hist_trans);
				end
				"LWMARR":begin 
					verify_load_word_misaligned_reg_reg(cmd_trans,res_trans,hist_trans);
				end
				"LDD":begin 
					verify_load_double_word(cmd_trans,res_trans,hist_trans);
				end
				"LDDRR":begin 
					verify_load_double_word_reg_reg(cmd_trans,res_trans,hist_trans);
				end
				"Store":begin
					verify_store(cmd_trans,res_trans,hist_trans);
				end
				"SBMA":begin
					verify_store_byte_misaligned(cmd_trans,res_trans,hist_trans);
				end
				"SHMA":begin
					verify_store_half_word_misaligned(cmd_trans,res_trans,hist_trans);
				end
				"SWMA":begin
					verify_store_word_misaligned(cmd_trans,res_trans,hist_trans);
				end
				"SB":begin
					verify_store_byte(cmd_trans,res_trans,hist_trans);
				end
				"SH":begin
					verify_store_half_word(cmd_trans,res_trans,hist_trans);
				end
				"SW":begin
					verify_store_word(cmd_trans,res_trans,hist_trans);
				end
				"SWZE":begin
					verify_store_word_zero_extend(cmd_trans,res_trans,hist_trans);
				end
				"SWZERR":begin
					verify_store_word_zero_extend_reg_reg(cmd_trans,res_trans,hist_trans);
				end
				"SBZE":begin
					verify_store_byte_zero_extend(cmd_trans,res_trans,hist_trans);
				end
				"SBZERR":begin
					verify_store_byte_zero_extend_reg_reg(cmd_trans,res_trans,hist_trans);
				end
				"SBRR":begin
					verify_store_byte_reg_reg(cmd_trans,res_trans,hist_trans);
				end
				"SHRR":begin
					verify_store_half_word_reg_reg(cmd_trans,res_trans,hist_trans);
				end
				"SWRR":begin
					verify_store_word_reg_reg(cmd_trans,res_trans,hist_trans);
				end
				"NOP":begin
					verify_nop(cmd_trans,res_trans,hist_trans);
				end
				"ADDCC":begin
					verify_addcc(cmd_trans,res_trans,hist_trans);
				end
				"ADDX":begin
					verify_addx(cmd_trans,res_trans,hist_trans);
				end
				"BIEF":begin
					verify_bief(cmd_trans,res_trans,hist_trans);
				end
				"BIGTOER":begin
					verify_bigtoer(cmd_trans,res_trans,hist_trans);
				end
				"BILTR":begin
					verify_biltr(cmd_trans,res_trans,hist_trans);
				end
				"BIGTOERU":begin
					verify_bigtoeru(cmd_trans,res_trans,hist_trans);
				end
				"BILTRU":begin
					verify_biltru(cmd_trans,res_trans,hist_trans);
				end
				"BVSF":begin
					verify_bvsf(cmd_trans,res_trans,hist_trans);
				end
				"BCSF":begin
					verify_bcsf(cmd_trans,res_trans,hist_trans);
				end
				"BNEGF":begin
					verify_bnegf(cmd_trans,res_trans,hist_trans);
				end
				"BIER":begin
					verify_bier(cmd_trans,res_trans,hist_trans);
				end
				"BA":begin
					verify_ba(cmd_trans,res_trans,hist_trans);
				end
				"Jalr":begin
					verify_JumpAndLinkRegImm(cmd_trans,res_trans,hist_trans);
				end
				"Jalr_cpc":begin
					verify_JumpAndLinkRegImm_cpc(cmd_trans,res_trans,hist_trans);
				end
				"Jalrr":begin
					verify_JumpAndLinkRegReg(cmd_trans,res_trans,hist_trans);
				end
				"SUB":begin
					verify_sub(cmd_trans,res_trans,hist_trans);
				end
				"SUBX":begin
					verify_subx(cmd_trans,res_trans,hist_trans);
				end
				"SUBXCC":begin
					verify_subxcc(cmd_trans,res_trans,hist_trans);
				end
				"SUBCC":begin
					verify_subcc(cmd_trans,res_trans,hist_trans);
				end
				"RDPSR":begin
					verify_rdpsr(cmd_trans,res_trans,hist_trans);
				end
				"ADDXCC":begin
					verify_addxcc(cmd_trans,res_trans,hist_trans);
				end
				"UMULR":begin
					verify_umulr(cmd_trans,res_trans,hist_trans);
				end
				"MHSR":begin
					verify_multiply_high_signed_reg_reg(cmd_trans,res_trans,hist_trans);
				end
				"MHSUR":begin
					verify_multiply_high_signed_unsigned_reg_reg(cmd_trans,res_trans,hist_trans);
				end
				"MHUR":begin
					verify_multiply_high_unsigned_reg_reg(cmd_trans,res_trans,hist_trans);
				end
				"UDIVR":begin
					verify_umulr(cmd_trans,res_trans,hist_trans);
				end
					"C":begin
					verify_compare(cmd_trans,res_trans,hist_trans);
				end
				"CN":begin
					verify_compare_not(cmd_trans,res_trans,hist_trans);
				end
				
				"SRwMas":begin
					verify_swap_ans(cmd_trans,res_trans,hist_trans);
				end
				"SRwM":begin
					verify_swap(cmd_trans,res_trans,hist_trans);
				end
				"Sabbram":begin
					verify_swap_byte(cmd_trans,res_trans,hist_trans);
				end
				"SRwMw":begin
					verify_swap_word(cmd_trans,res_trans,hist_trans);
				end
				"Mov":begin
					verify_move(cmd_trans,res_trans,hist_trans);
				end
				"Mn":begin
					verify_move_not(cmd_trans,res_trans,hist_trans);
				end
				default:begin
				if (cmd_trans.inst == cmd_trans.data);
				else `uvm_fatal("instruction fail", $sformatf("instruction is not found and its %h %s", si_a[i],si_a[i].name))
				end
			endcase
			if(cmd_trans.SOM==SB_VERIFICATION_MODE)hist_trans.printItems();
			$display("-------------------------------");
			end
	end
		//hist_trans.printItems();

	endtask
endclass: GUVM_scoreboard
