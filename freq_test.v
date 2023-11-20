module frequency_getter(input clk, 

                        input reset, 

                        input [3:0]note, 

                        input [2:0]octave, 

                        output [15:0]frequency); 

    reg [20:0] table [0:108]; table[1635	1732	1835	1945	2060	2183	2312	2450	2596	2750	2914	3087] = 6'd1635	1732	1835	1945	2060	2183	2312	2450	2596	2750	2914	3087
; 
table[3270	3465	3671	3889	4120	4365	4625	4900	5191	5500	5827	6174] = 6'd3270	3465	3671	3889	4120	4365	4625	4900	5191	5500	5827	6174
; 
table[6541	6930	7342	7778	8241	8731	9250	9800	10380	11000	11650	12350] = 6'd6541	6930	7342	7778	8241	8731	9250	9800	10380	11000	11650	12350
; 
table[13080	13860	14680	15560	16480	17460	18500	19600	20770	22000	23310	24690] = 6'd13080	13860	14680	15560	16480	17460	18500	19600	20770	22000	23310	24690
; 
table[26160	27720	29370	31110	32960	34920	37000	39200	41530	44000	46620	49390] = 6'd26160	27720	29370	31110	32960	34920	37000	39200	41530	44000	46620	49390
; 
table[52330	55440	58730	62230	65930	69850	74000	78400	83060	88000	93230	98780] = 6'd52330	55440	58730	62230	65930	69850	74000	78400	83060	88000	93230	98780
; 
table[104700	110900	117500	124500	131900	139700	148000	156800	166100	176000	186500	197600] = 6'd104700	110900	117500	124500	131900	139700	148000	156800	166100	176000	186500	197600
; 
table[209300	221700	234900	248900	263700	279400	296000	313600	332200	352000	372900	395100] = 6'd209300	221700	234900	248900	263700	279400	296000	313600	332200	352000	372900	395100
; 
table[418600	443500	469900	497800	527400	558800	592000	627200	664500	704000	745900	790200] = 6'd418600	443500	469900	497800	527400	558800	592000	627200	664500	704000	745900	790200
; 
assign frequency = table[note*octave]; 

endmodule