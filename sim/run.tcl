# clean previous simulation data
file delete -force xsim.covdb
file delete -force xsim.dir
file delete -force coverage_report

# analyze source files
exec xvlog -sv ../rtl/fifo_pkg.sv
exec xvlog -sv ../rtl/sync_fifo.sv

exec xvlog -sv -L uvm ../tb/fifo_tb_pkg.sv
exec xvlog -sv -L uvm ../tb/agent/fifo_if.sv
exec xvlog -sv -L uvm ../tb/top/tb_top.sv

# elaborate design
exec xelab -top tb_top -snapshot tb_top_snapshot \
    -L uvm \
    -timescale 1ns/1ps \
    -debug typical

# run simulation
foreach test {
    fifo_full_cycle_test
    fifo_concurrent_test
    fifo_reset_test
    fifo_partial_fill_test
} {
    exec xsim tb_top_snapshot \
        -testplusarg UVM_TESTNAME=$test \
        -testplusarg UVM_VERBOSITY=UVM_LOW \
        -cov_db_name $test \
        -runall \
        -log ${test}.log
}

# generate coverage report (change -report_format to text if preferred)
exec xcrg -cov_db_name fifo_full_cycle_test \
          -cov_db_name fifo_concurrent_test \
          -cov_db_name fifo_reset_test \
          -cov_db_name fifo_partial_fill_test \
          -report_format html \
          -report_dir coverage_report \

exit