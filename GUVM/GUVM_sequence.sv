class GUVM_sequence extends uvm_sequence #(GUVM_sequence_item);
    `uvm_object_utils(GUVM_sequence);
    target_seq_item command,load1,load2,store ;
    target_seq_item c;
    function new(string name = "GUVM_sequence");
        super.new(name);
    endfunction : new

    task body();
            load1 = target_seq_item::type_id::create("load1");
            load2 = target_seq_item::type_id::create("load2");
            command = target_seq_item::type_id::create("command");
            store = target_seq_item::type_id::create("store");
            //opcode x=A ;
           // $display("hello , this is the sequence,%d",command.upper_bit);
            command.ran_constrained(A);

            command.setup();
            load1.load(command.rs1);
            load2.load(command.rs2);
            store.store(command.rd);

            command.op1=load1.data;
            command.op2=load2.data;


            start_item(load1);
            finish_item(load1);

            start_item(load2);
            finish_item(load2);

            start_item(command);
            finish_item(command);

            start_item(store);
            finish_item(store);
            
    endtask : body


endclass : GUVM_sequence

