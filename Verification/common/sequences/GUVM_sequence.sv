
//generates the sequence of instructions needed to test an add instruction 

class GUVM_sequence extends uvm_sequence #(GUVM_sequence_item);
    `uvm_object_utils(GUVM_sequence);
    //target_seq_item nop , temp ,reset;
    //target_seq_item c;
    string clp_inst ; // command line processor input iinstruction
    function new(string name = "GUVM_sequence");
        super.new(name);
    endfunction : new

    function clp(uvm_cmdline_processor cmdline_proc);
        string my_value = "NOP";
        int rc ; 
        rc = cmdline_proc.get_arg_value("+ARG_INST=", my_value);
        clp_inst = my_value;
    endfunction

    task genNop(integer i , logic[31:0] data );//sends i number of nop with data
        repeat(i) begin
            target_seq_item nop ;
            nop = target_seq_item::type_id::create("nop");
            nop.ran_constrained(NOP); 
            nop.data = data ; 
            start_item(nop);
            finish_item(nop);
        end
    endtask


    function target_seq_item copy(target_seq_item targ);//deep copy of a seq item
        target_seq_item x ;
        x = target_seq_item::type_id::create("x");
        x.do_copy(targ);
        return x ;
    endfunction
    
    
    task send(target_seq_item targ);//sends a seq item 
        start_item(targ);
        finish_item(targ);
    endtask

    task resetSeq();//sends reset sequence
        target_seq_item reset;
        reset=target_seq_item::type_id::create("reset");
        reset.SOM = SB_RESET_MODE;
        send(reset);
    endtask
    /*task body();
        $display("GUVM_seq");
    endtask*/


    

endclass : GUVM_sequence

