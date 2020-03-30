`uvm_analysis_imp_decl(_mon_trans)
`uvm_analysis_imp_decl(_drv_trans)

class GUVM_scoreboard extends uvm_scoreboard;

	// register the scoreboard in the UVM factory
	`uvm_component_utils(GUVM_scoreboard);

	// analysis implementation ports
	uvm_analysis_imp_mon_trans #(GUVM_result_transaction, GUVM_scoreboard) Mon2Sb_port;
	uvm_analysis_imp_drv_trans #(GUVM_sequence_item, GUVM_scoreboard) Drv2Sb_port;

	// TLM FIFOs to store the actual and expected transaction values
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
		drv_fifo     = new("drv_fifo", this);  //BY DEFAULT ITS SIZE IS 1 BUT CAN BE UNBOUNDED by putting 0
		mon_fifo     = new("mon_fifo", this);
	endfunction : build_phase

	// write_drv_trans will be called when the driver broadcasts a transaction
	// to the scoreboard
	function void write_drv_trans (GUVM_sequence_item input_trans);
		void'(drv_fifo.try_put(input_trans));
	endfunction: write_drv_trans

	// write_mon_trans will be called when the monitor broadcasts the DUT results
	// to the scoreboard
	function void write_mon_trans (GUVM_result_transaction trans);
		void'(mon_fifo.try_put(trans));
	endfunction: write_mon_trans

	task run_phase(uvm_phase phase);
		GUVM_sequence_item cmd_trans;
		GUVM_result_transaction res_trans;
		bit [31:0] h1,i1,i2,imm,registered_inst;
		integer i;
		integer valid;
		// bit [19:0] sign;
		forever begin
			$display("Scoreboard started");
			drv_fifo.get(cmd_trans);
			mon_fifo.get(res_trans);
			// `uvm_info ("READ_INSTRUCTION ", $sformatf("Expected Instruction=%h \n", exp_trans.inst), UVM_LOW)
			// mon_fifo.get(out_trans);
			i1=cmd_trans.operand1;
			i2=cmd_trans.operand2;
			registered_inst=cmd_trans.inst;
			$display("Sb: inst is %b %b %b %b %b %b %b %b", cmd_trans.inst[31:28], cmd_trans.inst[27:24], cmd_trans.inst[23:20], cmd_trans.inst[19:16], cmd_trans.inst[15:12], cmd_trans.inst[11:8], cmd_trans.inst[7:4], cmd_trans.inst[3:0]);
			$display("Sb: op1=%0d ", i1);
			$display("Sb: op2=%0d", i2);
			// opcode reg_instruction;
			// `uvm_info ("SCOREBOARD ENTERED ", $sformatf("HELLO IN SCOREBOARD"), UVM_LOW);
			// target_package::reg_instruction = target_package::reg_instruction.first;
			valid = 0;
			for(i=0;i<supported_instructions;i++)
				begin
					if (xis1(cmd_trans.inst,si_a[i])) begin
						valid = 1;
					end
					// $display("LOOP ENTERED");
					// $display("reg_instruction  ::  Value of  %0s is = %0d",target_package::reg_instruction.name(),target_package::reg_instruction);
				end
			if(valid == 0) begin
				`uvm_fatal("instruction fail", $sformatf("Sb: instruction not in pkg and its %b %b %b %b %b %b %b %b", cmd_trans.inst[31:28], cmd_trans.inst[27:24], cmd_trans.inst[23:20], cmd_trans.inst[19:16], cmd_trans.inst[15:12], cmd_trans.inst[11:8], cmd_trans.inst[7:4], cmd_trans.inst[3:0]))
			end
			casex (si_a[i])
				A:begin
					h1 = i1+i2;
					if((h1) == (res_trans.result))
						begin
							`uvm_info ("ADDITION_PASS ", $sformatf("Actual Calculation=%d Expected Calculation=%d ", res_trans.result, h1), UVM_LOW)
						end
					else
						begin
							`uvm_error("ADDITION_FAIL", $sformatf("Actual Calculation=%d Expected Calculation=%d ", res_trans.result, h1))
						end
				end
				default:`uvm_fatal("instruction fail", $sformatf("instruction is not add its %h", si_a[i]))
			endcase
		end
	endtask
endclass: GUVM_scoreboard
