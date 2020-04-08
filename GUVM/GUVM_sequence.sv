
//generates the sequence of instructions needed to test an add instruction 

class GUVM_sequence extends uvm_sequence #(GUVM_sequence_item);
    `uvm_object_utils(GUVM_sequence);
    target_seq_item command,load1,load2,store ;
    target_seq_item c;
    function new(string name = "GUVM_sequence");
        super.new(name);
    endfunction : new

    task body();
        repeat(10)
        begin
            load1 = target_seq_item::type_id::create("load1"); //load register x with data dx
            load2 = target_seq_item::type_id::create("load2"); //load register y with data dy
            command = target_seq_item::type_id::create("command");//send add instruction (or any other instruction under test)
            store = target_seq_item::type_id::create("store");//store the result from reg z to memory location (dont care)
            //opcode x=A ;
           // $display("hello , this is the sequence,%d",command.upper_bit);
            command.ran_constrained(A); // first randomize the instruction as an add (A is the enum code for add)

            command.setup();//set up the instruction format fields 
            load1.load(command.rs1);//specify regx address
            load2.load(command.rs2);//specify regy address
            store.store(command.rd);//specify regz address

			//specify regx and regy data
            command.operand1=load1.data;
            command.operand2=load2.data;

			//send the sequence
            start_item(load1);
            finish_item(load1);

            start_item(load2);
            finish_item(load2);

            start_item(command);
            finish_item(command);

            start_item(store);
            finish_item(store);
        end
    endtask : body


endclass : GUVM_sequence

