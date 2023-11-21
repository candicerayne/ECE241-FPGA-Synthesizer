module ALUcontroller(clk, reset, note_in, note, octave, wave_out);

    input clk;              // clock
    input reset;            // reset
    input note_in;          // tells whether note was input
    input [3:0] note;       // tells note value of input note (a,b,d#, etc)
    input [2:0] octave;     // tells octave of note
    output wave_out;        // output wave value

    // wires
    wire ld_note, ld_play;

    // connections to modules
    control c0(clk, reset, note_in, ld_note, ld_play);
    datapath d0(clk, reset, note, octave, ld_note, ld_play, wave_out);

endmodule

// make it so it can play multiple notes at once
module control(clk, reset, note_in, ld_note, ld_play); //  need outputs

    input clk;            // clock
    input reset;          // reset

    input note_in;           // when 1, plays loads in note, then plays

    output reg ld_note;   // when 1, datapath loads note
    output reg ld_play;   // tells ALU to play note

    reg [2:0]cur_state; 
    reg [2:0]next_state;

    // state params
    localparam start = 3'b000, load_note = 3'b001, play_note = 3'b010;

    always@(*)
    begin: state_table
        case ( cur_state )
            start: begin // starting state, when reset
                if (note_in) next_state = load_note;
                else next_state = start;
            end
            load_note: begin // state to load in note to waveform
                next_state = play_note;
            end
            play_note: begin // state to play note
                if (note_in) next_state = load_note;
                else next_state = play_note;
            end  
        endcase
    end // state_table


    always @(*)
    begin: enable_signals
        // By default make all our signals 0
        ld_note = 0;
        ld_play = 0;

        case (cur_state)
          load_note: begin
            ld_note = 1;
          end
          play_note: begin
            ld_play = 1;
          end
        endcase
    end // enable_signals

    always @(posedge clk)
    begin: state_FFs
        if(reset == 1'b0) begin
            cur_state <=  start; // Should set reset state to state A
        end
        else begin 
            // fill in
            cur_state <= next_state;
        end
    end // state_FFS

endmodule

module datapath(clk, reset, note, octave, ld_note, ld_play, wave_out);
    input clk;          // clock
    input reset;        // reset

    input [3:0] note;   // the note input (i.e. A, Bflat, Gsharp)
    input [2:0] octave; // the octave of the note (7 total octaves)
                        // octave 4 corresponds with middle C
    input ld_note;      // command to load in note
    input ld_play;      // command to play note

    output wave_out;    // the value of the output wave (currently only square wave so we can keep as single bit)

    // registers
    reg [15:0] freq_temp;   // holds current frequency, MAKE THIS AN ARRAY SO WE CAN PLAY MULTIPLE NOTES
    reg [15:0] freq_reg;    // holds register value of frequency, used to play note

    reg wave_reg;           // stores current value of wave

    // stores current frequency in frequency reg
    frequency_getter freq(note, octave, freq_temp);

    // puts current value of wave in wave_reg
    square_wave_generator wv(clk, reset, freq_reg, wave_reg);

    // load inputs to registers    
    always@(posedge clk) begin
        if(reset) begin
            freq_reg <= 0;
        end
        else begin
            if (ld_note) begin
                freq_reg <= freq_temp;
            end
        end
    end

    // load outputs
    always@(posedge clk) begin
        if(reset) begin
            wave_out <= 0;
        end
        else begin 
            if (ld_play) begin
                wave_out <= wave_reg;
            end
        end
    end

endmodule