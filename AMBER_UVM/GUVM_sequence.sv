class GUVM_sequence extends uvm_sequence #(GUVM_sequence_item);
    `uvm_object_utils(GUVM_sequence);
    target_seq_item command, load1, load2, store;
    target_seq_item c;

    function new(string name = "GUVM_sequence");
        super.new(name);
    endfunction : new

    task body();
        repeat(1) begin
            load1 = target_seq_item::type_id::create("load1");
            load2 = target_seq_item::type_id::create("load2");
            command = target_seq_item::type_id::create("command");
            store =target_seq_item::type_id::create("store");

            command.ran_constrained(A);
            load1.ran_constrained(LW);
            load2.ran_constrained(LW);
            store.ran_constrained(SW);

            command.setup();
            load1.setup();
            load2.setup();
            store.setup();

            load1.rd = command.rs1;
            load2.rd = command.rs2;

            load1.update_rd();
            load2.update_rd();

            command.op1 = load1.data;
            command.op2 = load2.data;

            store.rd = command.rd;
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
        end
    endtask : body


endclass : GUVM_sequence

