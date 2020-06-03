class GUVM_history_transaction extends uvm_transaction;

    logic [31:0]result; // stores logic and arithmetic instructions results ; why ? 
    logic overflow,zero,neg,carry=0;
    typedef struct {
        logic [31:0] data;
        logic [4:0] add; // suggestion : logic [31:0] add;
    } reg_history;
    typedef struct {
        GUVM_sequence_item cmd_trans ;
        GUVM_result_transaction res_trans; // suggestion : logic [31:0] add;
    } item ;
    reg_history reg_file [];
    item item_history [] ;

    function void reset();
        reg_file.delete();
        item_history.delete();
        overflow=1'bx ;
        zero=1'bx ;
        neg=1'bx ;
        carry=1'bx ; 
        result = 32'dx;

        
        //printItems();
        //$display("done deleting");
    endfunction

    function void addItem(GUVM_sequence_item seq, GUVM_result_transaction res) ;
        item_history = new[item_history.size() + 1](item_history);
        item_history[item_history.size()-1].cmd_trans=seq;
        item_history[item_history.size()-1].res_trans=res;
    endfunction
    function void printItems() ; 
        $display("yay time to print my history");

        $display("--- reg_file Values are ---");
        foreach(reg_file[i])   $display("\treg_file[%0d] = %p %h",i, reg_file[i],reg_file[i].data);
        $display("---------------------------------");
        
        foreach(item_history[i])begin
            string m="" ;
            string s = "" ; 
            $sformat(m,"seq#%d",i);
            s={s ,m} ;
            $sformat(m," pc %d",item_history[i].cmd_trans.current_pc);
            s={s ,m} ;
            $sformat(m," inst %h",item_history[i].cmd_trans.inst);
            s={s ,m} ;
            $sformat(m," result:%h",item_history[i].res_trans.result);
            s={s ,m} ;
            $sformat(m," mem_add:%h",item_history[i].res_trans.mem_add);
            s={s ,m} ;
            $sformat(m," data_write_e:%b",item_history[i].res_trans.data_write_e);
            s={s ,m} ;
            //s = {s ,m };"result:%h",item_history[i].res_trans.result
            //$display("seq#",i," pc %d",item_history[i].seq_item.current_pc," inst %h ",item_history[i].seq_item.inst,"result:%h",item_history[i].res_trans.result);

            $display(s);
        end
    endfunction

    function void updateflags(logic [31:0]result);
        if (result == 0)
            zero = 1;
        if (result < 0) // logic 31 is not considered signed to sv (<0 is never true)
            neg = 1;
        $display("zero_flag=%0d negative_flag=%0d",zero,neg);
    endfunction : updateflags

    function void loadreg(logic [31:0]data,logic [4:0]add);
        reg_history temp;
        int id[];
        temp.data = data;
        temp.add = add;
        foreach(reg_file[i])
        begin 
            if (reg_file[i].add == add) // if register address alreeady in regfile we overwrite the data
            begin
                reg_file[i] = temp;
                /*
                $display("--- reg_file Values are ---");
                foreach(reg_file[i])   $display("\treg_file[%0d] = %p",i, reg_file[i]);
                $display("---------------------------------");
                */
                return;
            end
        end
        //this line will lose all previous data in reg file with each call reg_file = new[reg_file.size() + 1](reg_file); 
        reg_file = new[reg_file.size() + 1](reg_file); // after checking that address is empty in regfile
        reg_file[reg_file.size()-1]=temp; // we make new register 
        /*$display("--- reg_file Values are ---");
        foreach(reg_file[i])   $display("\treg_file[%0d] = %p",i, reg_file[i]);
        $display("---------------------------------");
        */
    endfunction : loadreg

    function logic[31:0] get_reg_data(logic [4:0]add);
        foreach(reg_file[i])
        begin
            if (reg_file[i].add == add)
                return reg_file[i].data;
        end
        `uvm_error("Histroy Fail", $sformatf("Register with address = %0b is not found in reg_file in history", add))
    endfunction

        

   function new(string name = "");
      super.new(name);
   endfunction : new


   function void do_copy(uvm_object rhs);
      GUVM_result_transaction copied_transaction_h;
      assert(rhs != null) else
        $fatal(1,"Tried to copy null transaction");
      super.do_copy(rhs);
      assert($cast(copied_transaction_h,rhs)) else
        $fatal(1,"Faied cast in do_copy");
      result = copied_transaction_h.result;
   endfunction : do_copy

   function string convert2string();
      string s;
      s = $sformatf("result: %4h",result);
      return s;
   endfunction : convert2string

   function bit do_compare(uvm_object rhs, uvm_comparer comparer);
      GUVM_result_transaction RHS;
      bit    same;
      assert(rhs != null) else
        $fatal(1,"Tried to copare null transaction");

      same = super.do_compare(rhs, comparer);

      $cast(RHS, rhs);
      same = (result == RHS.result) && same;
      return same;
   endfunction : do_compare
   
        

endclass : GUVM_history_transaction

      
        
