

class generic_sequence extends uvm_sequence #(cmd_sequence_item);
    `uvm_object_utils(generic_sequence);
    cmd_sequence_item command ;
    function new(string name = "generic_sequence");
       super.new(name);

    endfunction : new
 
    task body();
        command = cmd_sequence_item::type_id::create("command");
        
        //command.inst = 1;
        repeat(10) begin
            start_item(command);
            command.ran();
            finish_item(command);
            command = cmd_sequence_item::type_id::create("command");
        end
        
    endtask : body

    
 endclass : generic_sequence

      