module top_module(sum,cout,result,a,b,cin);
parameter N = 16;
parameter Q =4;
input [N-1:0]a;
input [N-1:0]b;
input cin;
output [N-1:0]sum;
output cout;
output [N:0]result;

wire [N-1:0]p;
wire [N-1:0]g;
wire [N:0]g_0;

assign g_0[0] = cin;

genvar i;
    generate
        for(i=0;i<N;i=i+1)
            begin:generate_nbit_Bitwise
                Bitwise_PG b0(p[i],g[i],a[i],b[i]);
            end
    endgenerate

genvar j;
    generate
        for(j=0;j<N/2;j=j+Q)
            begin:carry_generator
                carry_gen c0(g_0[j+Q:j+1],p[j+Q-1:j],g[j+Q-1:j]);
            end
    endgenerate
    
genvar l;
    generate
        for(l=N/2;l<N;l=l+Q)
            begin:carry_accurate
                carry_accurate c1(g_0[l+Q:l+1],p[l+Q-1:l],g[l+Q-1:l],g_0[l]);
            end
    endgenerate
    
genvar k;
    generate
        for(k=0;k<N;k=k+Q)
            begin:sum_generaator
                sum_gen s0(sum[k+Q-1:k],p[k+Q-1:k],g[k+Q-1:k],g_0[k+Q-1:k]);
            end
   endgenerate
  
assign cout = g_0[N];
assign result = {cout,sum};
endmodule

module sum_gen(sum,p,g,g_0);
parameter Q = 4;
input [Q-1:0]p;
input [Q-1:0]g;
input [Q-1:0]g_0;
output [Q-1:0]sum;

genvar i;
    generate
        for(i=0;i<Q;i=i+1)
            begin:sum_gen
                assign sum[i]=p[i]^g_0[i];
            end
    endgenerate

endmodule

module carry_gen(cout,p,g);
parameter Q = 4;
input [Q-1:0]p;
input [Q-1:0]g;
output [Q-1:0]cout;
wire [Q:0]g_0;
assign g_0[0] = 0;

genvar i;
    generate
        for(i=0;i<Q;i=i+1)
            begin:generate_nbit_Bitwise
                Groupwise_PG g0(g_0[i+1],g[i],p[i],g_0[i]);
            end
    endgenerate

assign cout = g_0[Q:1];
endmodule

module carry_accurate(cout,p,g,cin);
parameter Q = 4;
input [Q-1:0]p;
input [Q-1:0]g;
input cin;
output [Q-1:0]cout;
wire [Q:0]g_0;
assign g_0[0] = cin;

genvar i;
    generate
        for(i=0;i<Q;i=i+1)
            begin:generate_nbit_Bitwise
                Groupwise_PG g0(g_0[i+1],g[i],p[i],g_0[i]);
            end
    endgenerate

assign cout = g_0[Q:1];
endmodule

module Bitwise_PG(
	output p,
	output g,
	input a,
	input b
    );
	assign p = a ^ b;
	assign g = a & b;

endmodule

module Groupwise_PG(	
	output g_1,
	input g,
	input p,
	input g_0
	);
	
	wire inter;
	assign inter = p & g_0;
	assign g_1 = g | inter;
endmodule
