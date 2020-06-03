
//generates the sequence of instructions needed to test an add instruction 

class store_sequence extends GUVM_sequence ;
    `uvm_object_utils(store_sequence);
    target_seq_item command,load1,load2,load3,temp,reset;
    target_seq_item c;
    function new(string name = "store_sequence");
        super.new(name);
    endfunction : new


    task body();
        repeat(10)
        begin
            
            load1 = target_seq_item::type_id::create("load1"); //load register rs1 with data dx
            load2 = target_seq_item::type_id::create("load2"); //load register rs2 with data dy
            load3 = target_seq_item::type_id::create("load3"); //load register rd with data dz
            command = target_seq_item::type_id::create("command");//send store instruction

            //command.ran_constrained(findOP("SB")); // first randomize the instruction as an load double (LDD is the enum code for load double)
            command.ran_constrained(findOP(clp_inst));
            //nop.ran_constrained(NOP);
            //$display("before the setup %d",command.data);
            command.setup();//set up the instruction format fields 
            //$display("after the setup %d",command.data);
            command.storeadd();
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
            begin
                load3.load(0);
            end
            else
            begin
                load3.load(command.rd);
                load3.rd=command.rd;
            end 

            $display("load1 in r[%d], load2 in r[%d], load3 in r[%d], data = %h and simm = %h",command.rs1,command.rs2,command.rd,command.data,command.simm);
            // load1.data = 32'd0;
            //load2.data = 32'd6;
            // command.data = ;
            resetSeq();
			//send the sequence
            
            send(load1);
            
            genNop(5,load1.data);
            
            send(load2);
            
            genNop(5,load2.data);

            send(load3);
            
            genNop(5,load3.data);
            
            send(command);
            temp = copy(command);
            temp.SOM = SB_IGNORE_MODE;
            send(temp);
        
            genNop(5,0);

            temp = copy(command);
            temp.SOM = SB_VERIFICATION_MODE ; 
            send(temp);

            //genNop(10);
            
        end
    endtask : body


endclass : store_sequence

