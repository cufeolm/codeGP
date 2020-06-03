
//this is an example of how to make a sequence

class child_sequence extends GUVM_sequence ;
    `uvm_object_utils(child_sequence);
    target_seq_item command,load1,load2,store,nop , temp ,reset;
    target_seq_item c;
    opcode tempOP;
    function new(string name = "child_sequence");
        super.new(name);
    endfunction : new



    task body();
        $display("child_seq");
        repeat(1)
        begin
           // reset=target_seq_item::type_id::create("reset");
            load1 = target_seq_item::type_id::create("load1"); //load register x with data dx
            load2 = target_seq_item::type_id::create("load2"); //load register y with data dy
            command = target_seq_item::type_id::create("command");//send add instruction (or any other instruction under test)
            store = target_seq_item::type_id::create("store");//store the result from reg z to memory location (dont care)
            //nop = target_seq_item::type_id::create("nop"); 
            //opcode x=A ;
           // $display("hello , this is the sequence,%d",command.upper_bit);
            //reset.SOM = SB_RESET_MODE;
            tempOP = findOP("A");
            command.ran_constrained(tempOP); // first randomize the instruction as an add (A is the enum code for add)
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
            store.store(command.rd);//specify regz address

            
			//send the sequence
            //load1.data=load1.data*4;
            //load2.data=load2.data*4;
            //send(reset);
            resetSeq();

            send(load1);
            
            genNop(5,load1.data);
            
            send(load2);
            
            genNop(5,load2.data);
            
            send(command);
            // temp=copy(command);
            // send(temp);
            
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


endclass : child_sequence

