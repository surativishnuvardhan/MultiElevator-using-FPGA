module elevatorwork(

//inputs
input clk,
input reset,
input [1:0] call_buttons_up,
input [1:0] call_buttons_down,
input [1:0] position_sensor,
input [1:0] input_floor,
input fire_alarm_sensors,
input power_outage_sensors,

//outputs
output reg [1:0] elevator_motor_control,//show elevator moving up or moving down
output reg door_control,//show destination reaches then door open, example (call_button = position) then door control 1 to depict that destination reached. or used in emergency modes
output reg [1:0] floor_display,
output reg emergency_mode_signals //glow when fire_alarm_sensors or power_outage_sensors operated.
);

//defining states
parameter IDLE = 3'b000;
parameter MOVING_UP = 3'b001;
parameter MOVING_DOWN = 3'b010;
parameter DOOR_OPENING = 3'b011;
parameter DOOR_CLOSING = 3'b100;
parameter EMERGENCY_MODE = 3'b101;

//current and next states
reg [2:0] current_state;
reg [2:0] next_state;

//defining reset
always @(posedge clk or posedge reset) begin
    if (reset)
        current_state <= IDLE;
    else
        current_state <= next_state;
end

//defining all the states
always @* begin
    // Default next state
    next_state = current_state;

    case (current_state)
        IDLE: begin
            if ((input_floor > position_sensor) || (call_buttons_up > position_sensor) || (call_buttons_down > position_sensor))
                next_state = MOVING_UP;
            else if ((input_floor < position_sensor) || (call_buttons_up < position_sensor) || (call_buttons_down < position_sensor))
                next_state = MOVING_DOWN;

            // Enter emergency mode on alarm or outage
            if (fire_alarm_sensors || power_outage_sensors)
                next_state = EMERGENCY_MODE; // Default emergency move direction is up
        end

        MOVING_UP, MOVING_DOWN: begin
            if ((position_sensor == call_buttons_up) || (input_floor == position_sensor))
                next_state = DOOR_OPENING;
            else if ((position_sensor == call_buttons_down) || (input_floor == position_sensor))
                next_state = DOOR_OPENING;

            // Enter emergency mode on alarm or outage
            if (fire_alarm_sensors || power_outage_sensors)
                next_state = EMERGENCY_MODE; // Adjust depending on desired emergency behavior
        end

        DOOR_OPENING: begin
            if ((call_buttons_up == position_sensor) || (call_buttons_down == position_sensor))
                next_state = DOOR_CLOSING;
            else if (fire_alarm_sensors || power_outage_sensors)
                next_state = EMERGENCY_MODE;
        end

        DOOR_CLOSING: begin
            if ((call_buttons_up == 2'b00) && (input_floor == 2'b00) && (call_buttons_down == 2'b00))
                next_state = IDLE;
            else if ((input_floor > position_sensor) || (call_buttons_up > position_sensor) || (call_buttons_down > position_sensor))
                next_state = MOVING_UP;
            else if ((input_floor < position_sensor) || (call_buttons_up < position_sensor) || (call_buttons_down < position_sensor))
                next_state = MOVING_DOWN;
            if (fire_alarm_sensors || power_outage_sensors)
                next_state = EMERGENCY_MODE;
        end

        EMERGENCY_MODE: begin
            if (~fire_alarm_sensors || ~power_outage_sensors)
                next_state = IDLE;
        end
    endcase
end

// Output logic
always @* begin
    case (current_state)
        IDLE: begin
            elevator_motor_control = 2'b00;
            door_control = 1'b0;
        end

        MOVING_UP: begin
            elevator_motor_control = 2'b01; //elevator is moving up
            door_control = 1'b0; //door_close
        end

        MOVING_DOWN: begin
            elevator_motor_control = 2'b10; //elevator is moving down
            door_control = 1'b0;
        end

        DOOR_OPENING: begin
            elevator_motor_control = 2'b00;
            door_control = 1'b1; //if destination reached show that door is opening
        end

        DOOR_CLOSING: begin
            elevator_motor_control = 2'b00;
            door_control = 1'b0;
        end

        EMERGENCY_MODE: begin
            elevator_motor_control = 2'b00;
            door_control = 1'b1;
        end
    endcase

    floor_display = position_sensor;
    emergency_mode_signals = (fire_alarm_sensors | power_outage_sensors);
end

endmodule