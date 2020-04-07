class GUVM_result_transaction extends uvm_transaction;

   logic [31:0]result; // stores logic and arithmetic instructions results

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
   
        

endclass : GUVM_result_transaction

      
        
