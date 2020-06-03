
//this is an example of how to make a sequence

class A_type_sequence extends GUVM_sequence ;
    `uvm_object_utils(A_type_sequence);
    
    function new(string name = "A_type_sequence");
        super.new(name);
    endfunction : new
    

    target_seq_item command,load1,load2,store,nop , temp,reset ;
    target_seq_item c;
    
    //int my_int_value,rc ; 
    //uvm_cmdline_processor cmdline_proc;
    //cmdline_proc = uvm_cmdline_processor::get_inst();

    

    task body();
    repeat(10)
    begin
        $display("child_seq,%s",clp_inst);
        load1 = target_seq_item::type_id::create("load1"); //load register x with data dx
        load2 = target_seq_item::type_id::create("load2"); //load register y with data dy
        command = target_seq_item::type_id::create("command");//send add instruction (or any other instruction under test)
        store = target_seq_item::type_id::create("store");//store the result from reg z to memory location (dont care)
        //nop = target_seq_item::type_id::create("nop"); 
        //opcode x=A ;
        // $display("hello , this is the sequence,%d",command.upper_bit);
        command.ran_constrained(findOP(clp_inst)); // first randomize the instruction as an add (A is the enum code for add)
        
        //nop.ran_constrained(NOP);
        command.setup();//set up the instruction format fields 
        if ($isunknown(command.rs1))
            load1.load(0);
        else
        begin
            load1.load(command.rs1);//specify regx address
            load1.rd=command.rs1;
        end
        if ($isunknown(command.rs2))
            load2.load(0);
        else
        begin
            load2.load(command.rs2);//specify regx address
            load2.rd=command.rs2;  
        end 
        if ($isunknown(command.rd))
            store.store(0);
        else
        begin
            store.store(command.rd);//specify regz address  
        end 
        resetSeq();
        //load1.data=32'h00000004;
        // load2.data=32'h000000002;
        // command.data= {{24{1'bx}},{command.data[7:0]}} ;
        //send the sequence
        send(load1);
        
        genNop(5,load1.data);
        
        send(load2);
        
        genNop(5,load2.data);

        send(command);
        
        genNop(5,command.data);
        
        send(store);
        temp = copy(store);
        send(temp);

        genNop(5,0);
        temp = copy(command);
        temp.SOM = SB_VERIFICATION_MODE ; 
        send(temp);

        resetSeq();
        //genNop(10);
    end    
    endtask : body


endclass : A_type_sequence

