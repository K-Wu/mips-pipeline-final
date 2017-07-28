module HazardDetection(EX_PCSrc, ALUOut_0, ID_PCSrc, ID_EX_MEMRd, ID_EX_Rt,IF_ID_Rs,IF_ID_Rt, bubble,ID_EX_Flush,IF_ID_Flush,EX_MEM_FORWARD);
input ID_EX_MEMRd;
input [2:0] EX_PCSrc, ID_PCSrc;//wk79upd:宽度忘加�?
input ALUOut_0;
input [4:0] ID_EX_Rt,IF_ID_Rs,IF_ID_Rt;
output bubble,ID_EX_Flush,IF_ID_Flush,EX_MEM_FORWARD;
wire jIF_ID_Flush,bIF_ID_Flush,bID_EX_Flush,jrIF_ID_Flush,jrID_EX_Flush;
wire int_expt_Flush;
assign int_expt_Flush = ID_PCSrc==4||ID_PCSrc==5;//我们用control输出的PCSrc来推断是否发生异常或中断
//异常、中断发生时，将EX/MEM及其之前的寄存器全部清空�?遍，下一周期PC即进入中断，8000000x指令在下�?周期结束出现在IF/ID
assign bubble = (~ID_EX_Flush || ~IF_ID_Flush) && ID_EX_MEMRd && ((ID_EX_Rt==IF_ID_Rs && ID_EX_Rt!=0) || ((ID_EX_Rt==IF_ID_Rt)&&(ID_EX_Rt!=0)));//load-use hazard
assign bID_EX_Flush = (EX_PCSrc==3'b001) && (ALUOut_0==1);

assign jIF_ID_Flush = ID_PCSrc==3'b010;
assign jrIF_ID_Flush = EX_PCSrc==3'b011;
assign jrID_EX_Flush = jrIF_ID_Flush;
assign IF_ID_Flush = jIF_ID_Flush|jrIF_ID_Flush|bIF_ID_Flush|int_expt_Flush;//清零针对下一个周期，因此always块时钟上升沿清零
assign bIF_ID_Flush = bID_EX_Flush;
assign ID_EX_Flush = bID_EX_Flush|jrID_EX_Flush|int_expt_Flush;
assign EX_MEM_FORWARD =int_expt_Flush;

endmodule