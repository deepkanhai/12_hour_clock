module top_module(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss); 

    //DECLARATION OF THE BITS OF HOURS, MINUTES AND SECONDS
    reg[3:0]ss1;			
    reg[3:0]ss2;
    reg[3:0]mm1;
    reg[3:0]mm2;
    reg[3:0]hh1;
    reg[3:0]hh2;
      
    //ASSIGNING REGS TO THE OUTPUTS IN THE PROPER FORMAT
    assign ss = {ss2,ss1};
    assign mm = {mm2,mm1};
    assign hh = {hh2,hh1};
    
    //DEFINING THE WORKING OF PM...
    always @ (posedge clk) begin
        if (reset)
            pm = 1'b0; // PM RESETS TO 0(AM) IF RESET IS 1
        else if ((hh2 == 1) && (hh1 == 1) && (mm2 == 5) && (mm1 == 9) && (ss2 == 5) && (ss1 == 9))
            pm <= ~pm;
        // ELSE PM CHANGES STATE AT 11:59:59
    end
    
    //DEFINING THE WORKING OF SECONDS BIT 1
    always @ (posedge clk) begin
        if (reset)
            ss1 <= 4'b0;
        else if (ena) begin
			if(ss1 == 9)
            	ss1 <= 0;
        	else 
           	 	ss1 <= ss1 +1;
        end
    end  
    
    //DEFINING THE WORKING OF SECONDS BIT 2
    always @ (posedge clk) begin
        if (reset)
            ss2 <= 4'b0;
        else if (ena) begin
            if ((ss2 == 5) && (ss1 == 9))
            	ss2 <= 0;
    //RESETS AT 59 SECONDS
        	else if (ss1 == 9)
            	ss2 <= ss2 +1;
        end
    end  
    
    //DEFINING WORKING OF MINUTES BIT 1
    always @ (posedge clk) begin
        if (reset)
            mm1 <= 4'b0;
        else if (ena) begin
            if ((mm1 == 9) && (ss2 == 5) && (ss1 == 9))
            	mm1 <= 0;
     //RESETS AT 9:59 MINUTES
            else if ((ss2 == 5) && (ss1 == 9))
            	mm1 <= mm1 +1;
     //INCREMENTS AT 59 SECONDS
         end
    end   
    
     //DEFINING WORKING OF MINUTES BIT 2
    always @ (posedge clk) begin
        if (reset)
            mm2 <= 4'b0;
        else if (ena) begin
            if ((mm2 == 5) && (mm1 == 9) && (ss2 == 5) && (ss1 == 9))
            	mm2 <= 0;
      //RESETS AT 59:59 MINUTES 
            else if ((mm1 == 9) && (ss2 == 5) && (ss1 == 9))
            	mm2 <= mm2 +1;
      //INCREMENTS AT 9:59 MINUTES
        end
    end    

    //DEFINING WORKING OF HOURS BIT 1 
    always @ (posedge clk) begin
        if (reset)
            hh1 <= 2;
        else if (ena) begin
            if ((mm2 == 5) && (mm1 == 9) && (ss2 == 5) && (ss1 == 9))
                if (hh1 == 9)
                	hh1 <= 0;
        //RESETS AT 9:59:59 HOURS
            else if ((hh2 == 1) && (hh1 == 2))
                	hh1 <= 1;
        //GOES TO 1 AT 12:59:59 HOURS
         		else
            		hh1 <= hh1 +1;
         end
    end
    
    //DEFINING WORKING OF HOURS BIT 2
    always @ (posedge clk) begin
        if (reset)
            hh2 <= 1;
        else if (ena) begin
            if ((hh2 == 1) && (hh1 == 2) && (mm2 == 5) && (mm1 == 9) && (ss2 == 5) && (ss1 == 9))
            	hh2 <= 0;
    //RESETS AT 12:59:59 HOURS
            else if ((hh1 == 9) && (mm2 == 5) && (mm1 == 9) && (ss2 == 5) && (ss1 == 9)) 
            	hh2 <= hh2 +1;
        end
    end
endmodule
