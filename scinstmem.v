module scinstmem(pc, inst);
	input [31:0] pc;
	output [31:0] inst;

	reg [31:0] dataram [16:0];

	initial begin
		$readmemh("D:\\fib.txt", dataram, 0, 16);
	end
	
	assign inst = dataram[pc];
endmodule