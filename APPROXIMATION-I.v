module top_module(a,b,cin,cout,sum);
parameter N=16;
input [N-1:0]a,b;
input cin;
output cout;
output [N-1:0]sum;
wire [N:0]c;
assign c[0] = cin;

genvar i;
    generate
        for(i=0;i<N/2;i=i+1)
            begin: adder_ibit
                adder_1bit a3(a[i],b[i],c[i],c[i+1],sum[i]);
            end
    endgenerate

genvar j;
        generate
            for(j=N/2;j<N;j=j+1)
                begin:full_adder
                    FA f1(sum[j],c[j+1],a[j],b[j],c[j]);
                end
         endgenerate
     
assign cout = c[N];

endmodule

//approximation1
module adder_1bit(a,b,c,cout,sum);
input a,b,c;
output sum,cout;
supply1 vdd;
supply0 gnd;
wire wp1,wp2;
wire wn1,wn2;
wire wp3,wn3;
wire wn4;
wire coutbar,sumbar;

//coutbar
pmos p1(wp1,vdd,b);   //(drain,soruce,gate)
pmos p2(wp2,vdd,b);
pmos p3(coutbar,wp2,a);
pmos p4(coutbar,wp1,c);

nmos n1(wn1,gnd,a);
nmos n2(coutbar,gnd,b);
nmos n3(coutbar,wn1,c);

//sumbar
pmos p5(wp3,vdd,a);
pmos p6(wp3,vdd,b);
pmos p7(sumbar,wp3,coutbar);

nmos n4(wn2,gnd,c);
nmos n5(sumbar,wn2,coutbar);

pmos p8(sumbar,vdd,c);

nmos n6(wn4,gnd,a);
nmos n7(wn3,wn4,b);
nmos n8(sumbar,wn3,c);

not a1(cout,coutbar);
not a2(sum,sumbar);

endmodule

module FA(sum,cout,a,b,cin);
input a,b,cin;
output sum,cout;

assign sum = a^b^cin;
assign cout = (a&b) | (b&cin) | (cin&a) ;
endmodule