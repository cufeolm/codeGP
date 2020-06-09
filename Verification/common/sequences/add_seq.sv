
//generates the sequence of instructions needed to test an add instruction 

class add_sequence extends GUVM_sequence ;
    `uvm_object_utils(add_sequence);
    target_seq_item command,load1,load2,store,nop , temp,reset ;
    target_seq_item c;
    function new(string name = "add_sequence");
        super.new(name);
    endfunction : new


    task body();
        repeat(100)
        begin
            
            load1 = target_seq_item::type_id::create("load1"); //load register x with data dx
            load2 = target_seq_item::type_id::create("load2"); //load register y with data dy
            command = target_seq_item::type_id::create("command");//send add instruction (or any other instruction under test)
            store = target_seq_item::type_id::create("store");//store the result from reg z to memory location (dont care)
            //nop = target_seq_item::type_id::create("nop"); 
            //opcode x=A ;
           // $display("hello , this is the sequence,%d",command.upper_bit);
            //command.ran_constrained(findOP("A")); // first randomize the instruction as an add (A is the enum code for add)
            command.ran_constrained(findOP(clp_inst));
            
            //nop.ran_constrained(NOP);
            $display("before the setup %d",command.data);
            command.setup();//set up the instruction format fields 
            $display("after the setup %d",command.data);

            if ($isunknown(command.rs1))
                load1.load(0);
            else
            begin
                load1.load(command.rs1);//specify regx address
                load1.rd=command.rs1;
            end
            if ($isunknown(command.rs2))
                load2.inst=findOP("NOP");
            else
            begin
                load2.load(command.rs2);//specify regx address  
                load2.rd=command.rs2;
            end 
            store.store(command.rd);//specify regz address

            resetSeq();
			//send the sequence
            
            send(load1);
            
            genNop(5,load1.data);
            
            send(load2);
            
            genNop(5,load2.data);
            
            send(command);
            
            genNop(5,0);
            
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


endclass : add_sequence

