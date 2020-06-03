
//generates the sequence of instructions needed to test an add instruction 

class subcc_sequence extends GUVM_sequence ;
    `uvm_object_utils(subcc_sequence);
    target_seq_item command,load1,load2,store1,store2,rdpsr , temp,reset ;
    target_seq_item c;
    function new(string name = "subcc_sequence");
        super.new(name);
    endfunction : new


    task body();
        repeat(100)
        begin
            
            load1 = target_seq_item::type_id::create("load1"); //load register x with data dx
            load2 = target_seq_item::type_id::create("load2"); //load register y with data dy
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
            command.ran_constrained(findOP("A"));

            command.setup();//set up the instruction format fields 
            
            do begin
                rdpsr.ran_constrained(findOP("RDPSR")); 
                rdpsr.setup();
            end
            while(command.rd==rdpsr.rd || rdpsr.rd == 0);
            //$display(rdpsr.rd);

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


endclass : subcc_sequence


//generates the sequence of instructions needed to test an add instruction 

// class subcc_sequence extends GUVM_sequence ;
//     `uvm_object_utils(subcc_sequence);
//     target_seq_item command,load1,load2,store,b1,b2,b3,b4 , temp,reset ;
//     target_seq_item c;
//     function new(string name = "subcc_sequence");
//         super.new(name);
//     endfunction : new


//     task body();
//         repeat(1)
//         begin
            
//             load1 = target_seq_item::type_id::create("load1"); //load register x with data dx
//             load2 = target_seq_item::type_id::create("load2"); //load register y with data dy
//             command = target_seq_item::type_id::create("command");//send add instruction (or any other instruction under test)
//             store = target_seq_item::type_id::create("store");//store the result from reg z to memory location (dont care)
//             b1 = target_seq_item::type_id::create("store");
//             b2 = target_seq_item::type_id::create("store");
//             b3 = target_seq_item::type_id::create("store");
//             b4 = target_seq_item::type_id::create("store");
//             //nop = target_seq_item::type_id::create("nop"); 
//             //opcode x=A ;
//            // $display("hello , this is the sequence,%d",command.upper_bit);
//             command.ran_constrained(findOP("SUBCC")); // first randomize the instruction as an add (A is the enum code for add)
//             b1.ran_constrained(findOP("BIEF"));
//             b2.ran_constrained(findOP("BNEGF"));
//             b3.ran_constrained(findOP("BCSF"));
//             b4.ran_constrained(findOP("BVSF"));
//             //command.ran_constrained(findOP(clp_inst));
            
//             //nop.ran_constrained(NOP);
//             //$display("before the setup %d",command.data);
//             command.setup();//set up the instruction format fields 
//             b1.setup();
//             b2.setup();
//             b3.setup();
//             b4.setup();
//             //$display("after the setup %d",command.data);

//             if ($isunknown(command.rs1))
//                 load1.load(0);
//             else
//             begin
//                 load1.load(command.rs1);//specify regx address
//                 load1.rd=command.rs1;
//             end
//             if ($isunknown(command.rs2))
//                 load2.load(0);
//             else
//             begin
//                 load2.load(command.rs2);//specify regx address  
//                 load2.rd=command.rs2;
//             end 
//             store.store(command.rd);//specify regz address

//             //forced input
//             //$display("am i blind ------------------");
//             load1.data = 1;
//             load2.data = 1;

//             resetSeq();
// 			//send the sequence
            
//             send(load1);
            
//             genNop(5,load1.data);
            
//             send(load2);
            
//             genNop(5,load2.data);
            
//             send(command);
            
//             genNop(5,0);
            
//             send(store);
//             temp = copy(store);
//             send(temp);
//             genNop(5,0);

//             send(b1);
//             genNop(5,0);

//             send(b2);
//             genNop(5,0);

//             send(b3);
//             genNop(5,0);

//             send(b4);
//             genNop(5,0);


//             genNop(5,0);

//             temp = copy(command);
//             temp.SOM = SB_VERIFICATION_MODE ; 
//             send(temp);

//             resetSeq();
//             //genNop(10);
            
//         end
//     endtask : body


// endclass : subcc_sequence

