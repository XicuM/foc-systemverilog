`ifndef PARAMS_SV
`define PARAMS_SV

parameter real CLK_FREQ = 100e6;                // 100 MHz

// ---------------------------------------------------------------------
// Control parameters

// Modules
parameter bool MTPA_ACTIVE = 1;                 // MTPA controller active
parameter bool FW_ACTIVE = 0;                   // Field weakening active
parameter bool TORQUE_LIM_ACTIVE = 1;           // Torque limiter active
parameter bool VOLTAGE_LIM_ACTIVE = 1;          // Voltage limiter active
parameter bool SPEED_CTRL_ACTIVE = 1;           // Speed controller active
parameter bool TORQUE_CTRL_ACTIVE = 1;          // Torque controller active

// Timing parameters
parameter real TS = 6.25e-5;                    // Sampling time [s]
parameter real MAX_LATENCY = TS/100;            // Maximum tolerable latency [s]
parameter real DEADTIME = 1.0e-6;               // Dead time [s]

// TODO: mover a los tests únicamente

// Field weakening controller
parameter real TORQUE_KP = 0.1;                 // Proportional gain
parameter real TORQUE_KI = 0.01*TS;             // Integral gain
parameter real TORQUE_KAW = 0.0;                // Anti-windup gain

// Speed controller     
parameter real SPEED_KP = 0.1;                  // Proportional gain
parameter real SPEED_KI = 0.01*TS;              // Integral gain
parameter real SPEED_KAW = 0.0;                 // Anti-windup gain

// D-current controller     
parameter real DCURRENT_KP = 0.1;               // Proportional gain
parameter real DCURRENT_KI = 0.01*TS;           // Integral gain
parameter real DCURRENT_KAW = 0.0;              // Anti-windup gain

// Q-current controller     
parameter real QCURRENT_KP = 0.1;               // Proportional gain
parameter real QCURRENT_KI = 0.01*TS;           // Integral gain
parameter real QCURRENT_KAW = 0.0;              // Anti-windup gain

// ---------------------------------------------------------------------
// Physical magnitudes

// Maximum range
parameter real MAX_VOLTAGE = 1200.0/$sqrt(3);   // Maximum voltage [V]
parameter real MAX_CURRENT = 100.0;             // Maximum current [A]
parameter real MAX_SPEED = 3000.0;              // Maximum speed [min^-1]
parameter real MAX_TORQUE = 100.0;              // Maximum torque [Nm]
parameter real MAX_ANGLE = 6.283185;            // Maximum angle [rad]

// Resolution
parameter real RES_VOLTAGE = 0.1;               // Voltage resolution [V]
parameter real RES_CURRENT = 0.01;              // Current resolution [A]
parameter real RES_SPEED = 1.0;                 // Speed resolution [min^-1]
parameter real RES_TORQUE = 0.01;               // Torque resolution [Nm]
parameter real RES_ANGLE = 0.0001;              // Angle resolution [rad]

// Width of the fixed-point representation
parameter int WIDTH_VOLTAGE = $clog2((MAX_VOLTAGE / RES_VOLTAGE) + 1);
parameter int WIDTH_CURRENT = $clog2((MAX_CURRENT / RES_CURRENT) + 1);
parameter int WIDTH_SPEED = $clog2((MAX_SPEED / RES_SPEED) + 1);
parameter int WIDTH_TORQUE = $clog2((MAX_TORQUE / RES_TORQUE) + 1);
parameter int WIDTH_ANGLE = $clog2((MAX_ANGLE / RES_ANGLE) + 1);

// Width of the fractional part
parameter int FRACTIONAL_VOLTAGE = WIDTH_VOLTAGE - $clog2(1 / RES_VOLTAGE);
parameter int FRACTIONAL_CURRENT = WIDTH_CURRENT - $clog2(1 / RES_CURRENT);
parameter int FRACTIONAL_SPEED = WIDTH_SPEED - $clog2(1 / RES_SPEED);
parameter int FRACTIONAL_TORQUE = WIDTH_TORQUE - $clog2(1 / RES_TORQUE);
parameter int FRACTIONAL_ANGLE = WIDTH_ANGLE - $clog2(1 / RES_ANGLE);

// ---------------------------------------------------------------------
// Motor specifications

// Electrical data
parameter real RS = 0.5;                        // Stator resistance [Ohm]
parameter real LS = 0.001;                      // Stator inductance [H]
parameter real POLES = 4;                       // Number of poles
parameter real LAMBDA = 0.1;                    // Flux linkage [Wb]
parameter real J = 0.01;                        // Moment of inertia [kg*m^2]

// Mechanical data
parameter real B = 0.1;                         // Friction coefficient [Nm/(rad/s)]
parameter real T_L = 0.1;                       // Load torque [Nm]

// ---------------------------------------------------------------------
// Others

// Number of CORDIC iterations
parameter int ITERATIONS = 16;

`endif