

class generic_sequence extends uvm_sequence #(GUVM_sequence_item);
    `uvm_object_utils(generic_sequence);
    target_seq_item command,load1,load2,store ;
    target_seq_item c;
    function new(string name = "generic_sequence");
       super.new(name);
    endfunction : new
 
    task body();
        load1 = target_seq_item::type_id::create("load1");
        load2 = target_seq_item::type_id::create("load2");
        command = target_seq_item::type_id::create("command");
        store = target_seq_item::type_id::create("store");
        //opcode x=A ;
        command.ran_constrained(A);
        load1.ran_constrained(Load);
        load2.ran_constrained(Load);
        store.ran_constrained(Store);

        command.setup();
        load1.setup();
        load2.setup();
        store.setup();

        load1.rd=command.rs1;
        load2.rd=command.rs2;
                
        load1.update_rd();
        load2.update_rd();

        command.op1=load1.data;
        command.op2=load2.data;

        store.rd = command.rd ; 
        store.update_rd();

        start_item(load1);
        finish_item(load1);

        start_item(load2);
        finish_item(load2);

        start_item(command);
        finish_item(command);

        start_item(store);
        finish_item(store);
        $display(command.convert2string());

        //c = target_seq_item::type_id::create("c");
        //command.inst = 1;
        //repeat(10) begin

        //command.ran();
        //command.convert2string();
        //load1.rf_load();


        //start_item(load1);
        //finish_item(load1);

        //start_item(command);
        //finish_item(command);
        //c.ran();
        //c.setup();
        //c.op = 1;
       // start_item(c);
        //finish_item(c);
        //$display(c.convert2string());

        //command = GUVM_sequence_item::type_id::create("command");
        //end
        
    endtask : body

    
 endclass : generic_sequence

      