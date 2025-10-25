

## 🚀 FPGA Implementation of Elevator System using Verilog HDL

This project simulates and implements a **real-time elevator control system** on an **FPGA** using **Verilog HDL**, modeled with a **Finite State Machine (FSM)**. It handles user inputs like floor requests and emergency events, and provides real-time motor, door, and display control—mimicking a modern multi-floor elevator.

---

## 📋 Features

* Floor call handling (Up/Down buttons)
* Elevator movement (Up/Down/Idle)
* Door control logic (Open/Close)
* Emergency handling (Fire, Power outage)
* Real-time floor display
* FSM-based operation
* Simulation using **ModelSim**
* Synthesis and RTL generation using **Quartus Prime**

---

## 📂 Tools Used

| Tool              | Purpose                           |
| ----------------- | --------------------------------- |
| **ModelSim**      | Functional Simulation             |
| **Quartus Prime** | Synthesis and RTL View Generation |
| **FPGA Board**    | Real-world Deployment (optional)  |

---

## 🛠️ System Architecture

### ➤ Inputs:

* `clk`, `reset`
* `call_buttons_up` \[1:0]
* `call_buttons_down` \[1:0]
* `position_sensor` \[1:0]
* `input_floor` \[1:0]
* `fire_alarm_sensors`
* `power_outage_sensors`

### ➤ Outputs:

* `elevator_motor_control` \[1:0]
* `door_control`
* `floor_display` \[1:0]
* `emergency_mode_signals`

---

## 🔄 FSM Overview

| State               | Description                    |
| ------------------- | ------------------------------ |
| **IDLE**            | Waits for requests             |
| **MOVING\_UP**      | Moves elevator up              |
| **MOVING\_DOWN**    | Moves elevator down            |
| **DOOR\_OPENING**   | Opens door at target           |
| **DOOR\_CLOSING**   | Closes door after delay        |
| **EMERGENCY\_MODE** | Activated on fire/power outage |

---

## 📄 Code Summary

```verilog
module elevatorwork(
  input clk, reset,
  input [1:0] call_buttons_up, call_buttons_down, position_sensor, input_floor,
  input fire_alarm_sensors, power_outage_sensors,
  output reg [1:0] elevator_motor_control, floor_display,
  output reg door_control, emergency_mode_signals
);
// FSM states, transitions, and output logic are defined here.
endmodule
```

FSM transitions are determined by input conditions such as:

* Requested floor relative to current floor
* Fire or power outage signals
* Position matching floor request → triggers door operations

---

## ✅ Simulation and Verification

Test cases include:

* **Normal Operations:** Floor requests, movement, door open/close
* **Emergency Scenarios:** Alarm or power loss → elevator halts, doors open
* **Idle State:** No requests = idle state

---

## 🧠 Synthesis and Hardware Deployment

* RTL and FSM views were generated after synthesis.
* Design ready for implementation on any compatible FPGA development board.
* Ideal for **real-time demo setups** in labs or projects.

---

## 🖼️ Visuals

> **State Machine View**
> ![State Machine View](images/state_machine.png)

> **RTL View**
> ![RTL View](images/rtl_view.png)


---

## 📌 Conclusion

This project provides a real-time, safe, and efficient elevator logic simulation using FPGA and Verilog HDL. It is ideal for academic projects, embedded system applications, and learning FSM-based hardware modeling.

