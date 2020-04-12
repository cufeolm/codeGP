`uvm_analysis_imp_decl(_mon_trans)
`uvm_analysis_imp_decl(_drv_trans)

`include "GUVM_tb.sv"
class GUVM_scoreboard extends uvm_scoreboard;

	// register the scoreboard in the UVM factory
	`uvm_component_utils(GUVM_scoreboard);

	// analysis implementation ports
	uvm_analysis_imp_mon_trans #(GUVM_result_transaction, GUVM_scoreboard) Mon2Sb_port;
	uvm_analysis_imp_drv_trans #(target_seq_item, GUVM_scoreboard) Drv2Sb_port;

	// TLM FIFOs to store the drived transaction and result transaction values
	uvm_tlm_fifo #(target_seq_item) drv_fifo;
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
	function void write_drv_trans (target_seq_item input_trans);
		void'(drv_fifo.try_put(input_trans));
	endfunction: write_drv_trans

	// write_mon_trans will be called when the monitor broadcasts the DUT results to the scoreboard 
	function void write_mon_trans (GUVM_result_transaction trans);
		void'(mon_fifo.try_put(trans));
	endfunction: write_mon_trans

	task run_phase(uvm_phase phase);
		target_seq_item cmd_trans;	// stores drived transaction
		GUVM_result_transaction res_trans;	// stores result transaction 
		bit [31:0] expected1,operand1,operand2,imm,verified_inst;	// stores processed operands data
		integer i;	// index of for loop
		integer valid;	// stores instruction validity in the used core
		forever begin
			$display("Scoreboard started");
			drv_fifo.get(cmd_trans); // wait for driver to send drived transaction and get it
			mon_fifo.get(res_trans); // wait for monitor to send result transaction and get it
			operand1 = cmd_trans.operand1; 
			operand2 = cmd_trans.operand2;
			verified_inst = cmd_trans.inst;
			$display("Sb: inst is %b %b %b %b %b %b %b %b", verified_inst[31:28], verified_inst[27:24], verified_inst[23:20], verified_inst[19:16], verified_inst[15:12], verified_inst[11:8], verified_inst[7:4], verified_inst[3:0]);
			$display("Sb: op1=%0d ", operand1);
			$display("Sb: op2=%0d", operand2);
			valid = 0;
			// for loob to check that drived instruction is in opcodes array of the core
			for(i=0;i<supported_instructions;i++) // supported instruction is number of instructions in opcodes array of the core
				begin
					if (xis1(verified_inst,si_a[i])) begin // si_a is opcodes array of the verified core
						valid = 1;
						break;	// break when instruction found in array to save its index in i
 					end
				end
			if(valid == 0) begin // if valid still zero then instruction isn't found in opcodes array
				`uvm_fatal("instruction fail", $sformatf("Sb: instruction not in pkg and its %b %b %b %b %b %b %b %b", verified_inst[31:28], verified_inst[27:24], verified_inst[23:20], verified_inst[19:16], verified_inst[15:12], verified_inst[11:8], verified_inst[7:4], verified_inst[3:0]))
			end
			case (si_a[i].name) // determining which instuction we verify  
				"A":begin // add two registers
					verify_add(cmd_trans,res_trans);
				end
				"test":begin // temp instruction 
					verify_test(cmd_trans,res_trans);
				end
				default:`uvm_fatal("instruction fail", $sformatf("instruction is not add its %h", si_a[i]))
			endcase
		end
	endtask
endclass: GUVM_scoreboard
