
//generates the sequence of instructions needed to test an add instruction 

class GUVM_sequence extends uvm_sequence #(GUVM_sequence_item);
    `uvm_object_utils(GUVM_sequence);
    target_seq_item command,load1,load2,branch,nop , temp ;
    target_seq_item c;
    function new(string name = "GUVM_sequence");
        super.new(name);
    endfunction : new

    task genNop(integer i , logic[31:0] data );
        repeat(i) begin
            nop = target_seq_item::type_id::create("nop");
            nop.ran_constrained(NOP); 
            nop.data = data ; 
            start_item(nop);
            finish_item(nop);
        end
    endtask
    /*
    function  copy(target_seq_item targ);
        temp = target_seq_item::type_id::create("temp");
        temp.do_copy(targ);
    endfunction
    */
    function target_seq_item copy(target_seq_item targ);
        target_seq_item x ;
        x = target_seq_item::type_id::create("x");
        x.do_copy(targ);
        return x ;
    endfunction
    
    
    task send(target_seq_item targ);
        start_item(targ);
        finish_item(targ);
    endtask

    task body();
        repeat(1)
        begin
            load1 = target_seq_item::type_id::create("load1"); //load register x with data dx
            load2 = target_seq_item::type_id::create("load2"); //load register y with data dy
            command = target_seq_item::type_id::create("command");//send add instruction (or any other instruction under test)
            branch = target_seq_item::type_id::create("branch");//store the result from reg z to memory location (dont care)
            //nop = target_seq_item::type_id::create("nop"); 
            //opcode x=A ;
           // $display("hello , this is the sequence,%d",command.upper_bit);
            command.ran_constrained(ADDCC); // first randomize the instruction as an add (A is the enum code for add)
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
            //store.store(command.rd);//specify regz address
            branch.ran_constrained(BIEF);
            load1.data = 32'hFFFFFFFF;
            load2.data = 32'h1;


            
			//send the sequence
            
            send(load1);
            
            genNop(5,load1.data);
            
            send(load2);
            
            genNop(5,load2.data);
            
            send(command);
            
            genNop(5,0);
            
            send(branch);
            genNop(10,0);
            

            genNop(5,0);
            temp = copy(branch);
            temp.SOM = SB_VERIFICATION_MODE ; 
            send(temp);
            
            //genNop(10);
            
        end
    endtask : body


endclass : GUVM_sequence

