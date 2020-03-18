class GUVM_sequence extends uvm_sequence #(GUVM_sequence_item);
   
   `uvm_object_utils(generic_sequence);
   GUVM_sequence_item command ;

   function new(string name = "GUVM_sequence");
      super.new(name);
   endfunction : new
 
   task body();
      command = GUVM_sequence_item::type_id::create("command");
      //command.inst = 1;
      repeat(10) begin
         start_item(command);
         command.ran();
         finish_item(command);
         command = GUVM_sequence_item::type_id::create("command");
      end
   endtask : body

 endclass : GUVM_sequence   