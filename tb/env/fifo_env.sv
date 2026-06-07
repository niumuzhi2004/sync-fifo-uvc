class fifo_env extends uvm_env;
    `uvm_component_utils(fifo_env)

    fifo_wr_agent   wr_agent;
    fifo_rd_agent   rd_agent;
    fifo_coverage   cover_inst;
    fifo_scoreboard scoreboard;

    fifo_virtual_sequencer vseqr;

    function new(string name = "fifo_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        wr_agent   = fifo_wr_agent::type_id::create("wr_agent", this);
        rd_agent   = fifo_rd_agent::type_id::create("rd_agent", this);
        cover_inst = fifo_coverage::type_id::create("cover_inst", this);
        scoreboard = fifo_scoreboard::type_id::create("scoreboard", this);
        vseqr      = fifo_virtual_sequencer::type_id::create("vseqr", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        wr_agent.fifo_wr_ap.connect(cover_inst.wr_imp);
        rd_agent.fifo_rd_ap.connect(cover_inst.rd_imp);
        wr_agent.fifo_wr_ap.connect(scoreboard.wr_imp);
        rd_agent.fifo_rd_ap.connect(scoreboard.rd_imp);

        vseqr.wr_sequencer = wr_agent.sequencer;
        vseqr.rd_sequencer = rd_agent.sequencer;
    endfunction

endclass