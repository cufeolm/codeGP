
//generates the sequence of instructions needed to test an add instruction 

class load_double_sequence extends GUVM_sequence ;
    `uvm_object_utils(load_double_sequence);
    target_seq_item command,load1,load2,store1,store2,temp,reset;
    target_seq_item c;
    function new(string name = "load_double_sequence");
        super.new(name);
    endfunction : new


    task body();
        repeat(10)
        begin
            
            load1 = target_seq_item::type_id::create("load1"); //load register x with data dx
            load2 = target_seq_item::type_id::create("load2"); //load register y with data dy
            command = target_seq_item::type_id::create("command");//send load double instruction (or any other instruction under test)
            store1 = target_seq_item::type_id::create("store1");//store the result from reg z to memory location (dont care)
            store2 = target_seq_item::type_id::create("store2");//store the result from reg z+4 to memory location (dont care)

            //command.ran_constrained(findOP("LDD")); // first randomize the instruction as an load double (LDD is the enum code for load double)
            command.ran_constrained(findOP(clp_inst));
            command.data2 = $random();
            //nop.ran_constrained(NOP);
            //$display("before the setup %d",command.data);
            command.setup();//set up the instruction format fields 
            //$display("after the setup %d",command.data);

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
                store1.store(0);
                store2.store(0);
            end
            else
            begin
                store1.store(command.rd);
                store2.store((command.rd+32'd1));
            end 

            $display("load1 in r[%d], load2 in r[%d], data = %h,data2 = %h, store from r[%d] and simm = %h",command.rs1,command.rs2,command.data,command.data2,command.rd,command.simm);
            load1.data = 32'd10;
            load2.data = 32'd6;
            // command.data = ;
            resetSeq();
			//send the sequence
            
            send(load1);
            
            genNop(5,load1.data);
            
            send(load2);
            
            genNop(5,load2.data);
            
            send(command);
            temp = copy(command);
            temp.SOM = SB_IGNORE_MODE;
            send(temp);
            
            genNop(2,command.data);
            genNop(1,command.data2);
            
            send(store1);
            temp = copy(store1);
            send(temp);
            genNop(5,0);

            send(store2);
            temp = copy(store2);
            send(temp);
            genNop(5,0);

            temp = copy(command);
            temp.SOM = SB_VERIFICATION_MODE ; 
            send(temp);

            resetSeq();
            //genNop(10);
            
        end
    endtask : body


endclass : load_double_sequence

