#pragma once

#include <iostream>
#include <string>

using namespace std;

// ---------------------------------------------------------------------
// DEFINITIONS

#define SPEED_MAX 11600
#define TORQUE_MAX 22.1


// ---------------------------------------------------------------------
// FUNCTION PROTOTYPES

// State Idle
void init_AXI_registers();

// State Start
void reset_pi_controllers();
void precharge();
void open_logic_IO();

// State Process
void change_speed(float speed);
void change_torque(float torque);

// State Stop
void smooth_stop();
void close_logic_IO();