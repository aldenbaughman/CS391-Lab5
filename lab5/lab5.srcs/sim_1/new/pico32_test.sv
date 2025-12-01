`timescale 1ns / 1ps

module pico32_test();

bit clk;
bit rst;

wire      awready;
bit       awvalid;
bit[19:0] awaddr;

wire      wready;
bit       wvalid;
bit[31:0] wdata;

bit       bready;
wire      bvalid;
wire[1:0] bresp;

wire       arready;
wire       arvalid;
wire[19:0] araddr;

wire       rready;
wire       rvalid;
wire[31:0] rdata;

reg _rst;

reg       _awvalid;
reg[19:0] _awaddr;
reg       _wvalid;
reg[31:0] _wdata;
reg       _bready;

wire[2:0] cpu_arprot;
wire[2:0] cpu_awprot;

wire       cpu_awvalid;
wire[19:0] cpu_awaddr;
wire       cpu_wvalid;
wire[31:0] cpu_wdata;
wire       cpu_wstrb;
wire       cpu_bready;

always #5ns begin
    clk = ~clk;
end

always @ (posedge clk) begin
    _rst <= rst;
    _awvalid <= awvalid;
    _awaddr <= awaddr;
    _wvalid <= wvalid;
    _wdata <= wdata;
    _bready <= bready;
end

bit started_pico;

axi_bram_ctrl_0 my_bram(
    .s_axi_aclk(clk),
    .s_axi_aresetn(~_rst),
    .s_axi_araddr(araddr),
    .s_axi_arprot(!started_pico ? 0 : cpu_arprot),
    .s_axi_arready(arready),
    .s_axi_arvalid(arvalid),
    .s_axi_awaddr(!started_pico ? _awaddr : cpu_awaddr),
    .s_axi_awprot(!started_pico ? 0 : cpu_awprot),
    .s_axi_awready(awready),
    .s_axi_awvalid(!started_pico ? _awvalid : cpu_awvalid),
    .s_axi_bready(!started_pico ? _bready : cpu_bready),
    .s_axi_bresp(bresp),
    .s_axi_bvalid(bvalid),
    .s_axi_rdata(rdata),
    .s_axi_rready(rready),
    .s_axi_rvalid(rvalid),
    .s_axi_wdata(!started_pico ? _wdata : cpu_wdata),
    .s_axi_wready(wready),
    .s_axi_wstrb(!started_pico ? 4'b1111 : cpu_wstrb),
    .s_axi_wvalid(!started_pico ? _wvalid : cpu_wvalid) 
);

wire trap;
wire[31:0] irq;
wire[31:0] eoi;
wire       trace_valid;
wire[35:0] trace_data;

bit rst_pico;

picorv32_axi pico_core(
    .clk(clk & started_pico),
    .resetn(~rst_pico),
    
    .trap(trap),
    
    .mem_axi_awvalid(cpu_awvalid),
    .mem_axi_awready(awready),
    .mem_axi_awaddr (cpu_awaddr ),
    .mem_axi_awprot (cpu_awprot ),
    
    .mem_axi_wvalid (cpu_wvalid ),
    .mem_axi_wready (wready ),
    .mem_axi_wdata  (cpu_wdata  ),
    .mem_axi_wstrb  (cpu_wstrb  ),
    
    .mem_axi_bvalid (bvalid ),
    .mem_axi_bready (cpu_bready ),
    
    .mem_axi_arvalid(arvalid),
    .mem_axi_arready(arready),
    .mem_axi_araddr (araddr ),
    .mem_axi_arprot (cpu_arprot ),
    
    .mem_axi_rvalid (rvalid ),
    .mem_axi_rready (rready ),
    .mem_axi_rdata  (rdata  ),
    
    .irq(irq),
    .eoi(eoi),
    .trace_valid(trace_valid),
    .trace_data(trace_data)
);

reg [7:0] my_memory[1023:0];

initial begin

    started_pico = 0;
    rst = 1;
    
    #20ns;
    
    rst = 0;
    
    #20ns;

    $readmemh("/home/ugrad/aldenb/CS391-Lab5/lab5/lab5_binary.hex", my_memory);

    #40ns;

    for (int i = 0; i < 1024; i+=4) begin
        awvalid = 1;
        wvalid = 1;
        awaddr = i;
        wdata = {my_memory[i+3], my_memory[i+2], my_memory[i+1], my_memory[i+0]}; // Notice: difference endian compared to lab3-4 test-bench
        #40ns;
        awvalid = 0;
        wvalid = 0;
        bready = 1;
        #20ns;
        bready = 0;
        #20ns;
    end

    #20ns;
    
    awvalid <= 0;
    wvalid <= 0;
    awaddr <= 0;
    wdata <= 0;
    bready <= 0;
    
    #40ns;
    
    started_pico = 1;
    rst_pico = 1;
    
    #20ns;
    
    rst_pico = 0;

    // Pico starts running here...
    #10000ns; // Skip some time or rely on 'trap' wire.

    $finish;
end

endmodule