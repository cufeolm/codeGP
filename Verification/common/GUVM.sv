
    typedef enum logic [2:0] {
        SB_HISTORY_MODE= 0 ,
        SB_VERIFICATION_MODE= 1 ,
        SB_RESET_MODE= 2,
        SB_IGNORE_MODE= 3
    } GUVM_TB_SOM;//score board operation mode

`include "GUVM_result_transaction.sv"

`include "GUVM_sequence_item.sv"
`include "GUVM_history_transaction.sv"
`include "target_sequence_item.sv"
//`include "GUVM_sequence.sv"
`include "GUVM_cmd_monitor.sv"
`include "GUVM_driver.sv"
`include "GUVM_result_monitor.sv"
`include "GUVM_scoreboard.sv"
`include "GUVM_agent.sv"
`include "GUVM_env.sv"
`include "GUVM_sequinces.svh"   
`include "GUVM_tests.svh"
