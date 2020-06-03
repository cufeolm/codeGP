
//generates the sequence of instructions needed to test an add instruction 

class bief_sequence extends GUVM_sequence;
    `uvm_object_utils(bief_sequence);
    target_seq_item subc,load1,load2,branch,temp,adda,store ;
    function new(string name = "bief_sequence");
        super.new(name);
    endfunction : new

    task body();
        repeat(100)
        begin
            
            load1 = target_seq_item::type_id::create("load1"); //load register x with data dx
            load2 = target_seq_item::type_id::create("load2"); //load register y with data dy
            subc = target_seq_item::type_id::create("subc");//send add instruction (or any other instruction under test)
            branch = target_seq_item::type_id::create("branch");//store the result from reg z to memory location (dont care)
            adda = target_seq_item::type_id::create("adda");//add to be annuled
            temp = target_seq_item::type_id::create("temp");
            store = target_seq_item::type_id::create("store");
            //nop = target_seq_item::type_id::create("nop"); 
            //opcode x=A ;
           // $display("hello , this is the sequence,%d",subc.upper_bit);
           
            subc.ran_constrained(findOP("SUBCC")); // first randomize the instruction as an add (A is the enum code for add)
            subc.setup();//set up the instruction format fields 


            if ($isunknown(subc.rs1))
                load1.load(0);
            else
            begin
                load1.load(subc.rs1);//specify regx address
                load1.rd=subc.rs1;
            end
            if ($isunknown(subc.rs2))
                load2.load(0);
            else
            begin
                load2.load(subc.rs2);//specify regx address  
                load2.rd=subc.rs2;
            end 
            //store.store(subc.rd);//specify regz address
            //load1.data = 32'h2;
            //load2.data = 32'h2;

            store.store(subc.rd);

            //branch.ran_constrained(findOP("BIEF"));
            //branch.ran_constrained(findOP("BCSF"));
            //branch.ran_constrained(findOP("BNEGF"));
            //branch.ran_constrained(findOP("BVSF"));
            branch.ran_constrained(findOP(clp_inst));
            branch.setup();

            adda.ran_constrained(findOP("A"));
            adda.inst[RS1U:RS1L]=subc.rs1;
            adda.inst[RS2U:RS2L]=subc.rs2;
            adda.inst[RDU:RDL]=subc.rd;
            adda.setup();


            //start of sequence


            resetSeq();
			//send the sequence
            
            send(load1);
            
            genNop(5,load1.data);
            
            send(load2);
            
            genNop(5,load2.data);
            
            send(subc);
            
            genNop(5,0);
            
            send(branch);
            
            

            send(adda);

            genNop(10,0);

            send(store);
            send(copy(store));
            

            genNop(5,0);
            
            temp = copy(branch);
            temp.SOM = SB_VERIFICATION_MODE ; 
            send(temp);
            resetSeq();
            
            //genNop(10);
            
        end
    endtask : body


endclass : bief_sequence

