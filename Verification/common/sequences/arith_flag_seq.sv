
//this is an example of how to make a sequence

class arith_flag_sequence extends GUVM_sequence ;
    `uvm_object_utils(arith_flag_sequence);
    target_seq_item addcc,command,load1,load2,load3,load4,store1,store2,rdpsr , temp,reset ;
    target_seq_item c;
    function new(string name = "arith_flag_sequence");
        super.new(name);
    endfunction : new


    task body();
        repeat(100)
        begin
            
            load1 = target_seq_item::type_id::create("load1"); //load register x with data dx
            load2 = target_seq_item::type_id::create("load2"); //load register y with data dy
            load3 = target_seq_item::type_id::create("load3"); //load register x with data dx
            load4 = target_seq_item::type_id::create("load4"); //load register y with data dy
            addcc = target_seq_item::type_id::create("addcc");
            command = target_seq_item::type_id::create("command");//send add instruction (or any other instruction under test)
            store1 = target_seq_item::type_id::create("store1");//store the result from reg z to memory location (dont care)
            store2 = target_seq_item::type_id::create("store2");
            rdpsr = target_seq_item::type_id::create("rdpsr");

            //nop = target_seq_item::type_id::create("nop"); 
            //opcode x=A ;
           // $display("hello , this is the sequence,%d",command.upper_bit);
            
            //command.ran_constrained(findOP("SUBCC")); // first randomize the instruction as an add (A is the enum code for add)
            //command.ran_constrained(findOP("ADDCC"));
            //command.ran_constrained(findOP("A"));
            addcc.ran_constrained(findOP("ADDCC"));

            //command.ran_constrained(findOP("ADDXCC"));
            //command.ran_constrained(findOP("ADDCC"));
            //command.ran_constrained(findOP("A"));
            //command.ran_constrained(findOP("ADDX"));
            command.ran_constrained(findOP(clp_inst));

            command.setup();//set up the instruction format fields 
            addcc.setup();
            
            do begin
                rdpsr.ran_constrained(findOP("RDPSR")); 
                if (rdpsr.inst==NOP) break ; 
                rdpsr.setup();
            end
            while(command.rd==rdpsr.rd || rdpsr.rd == 0);
            //$display(rdpsr.rd);

            //$display("after the setup %d",command.data);

            if ($isunknown(addcc.rs1))
            load1.load(0);
            else
            begin
                load1.load(addcc.rs1);//specify regx address
                load1.rd=addcc.rs1;
            end

            if ($isunknown(addcc.rs2))
                load2.load(0);
            else
            begin
                load2.load(addcc.rs2);//specify regx address  
                load2.rd=addcc.rs2;
            end 


            if ($isunknown(command.rs1))
                load3.load(0);
            else
            begin
                load3.load(command.rs1);//specify regx address
                load3.rd=command.rs1;
            end

            if ($isunknown(command.rs2))
                load4.load(0);
            else
            begin
                load4.load(command.rs2);//specify regx address  
                load4.rd=command.rs2;
            end 

            store1.store(command.rd);//specify regz address
            store2.store(rdpsr.rd);

            //forced input
            //$display("am i blind ------------------");
            //load1.data = 1;
            //load2.data = 1;

            resetSeq();
			//send the sequence
            
            send(load1);
            
            genNop(5,load1.data);
            
            send(load2);
            
            genNop(5,load2.data);

            send(addcc);
            genNop(5,0);
            //-----------------------------------

            send(load3);
            
            genNop(5,load3.data);
            
            send(load4);
            
            genNop(5,load4.data);
            
            send(command);
            
            genNop(5,0);

            send(rdpsr);
            
            genNop(5,0);
            
            send(store1);
            temp = copy(store1);
            send(temp);
            genNop(5,0);

            send(store2);
            temp = copy(store2);
            send(temp);
            genNop(5,0);



            genNop(5,0);

            temp = copy(command);
            temp.SOM = SB_VERIFICATION_MODE ; 
            send(temp);

            resetSeq();
            //genNop(10);
            
        end
    endtask : body


endclass : arith_flag_sequence

