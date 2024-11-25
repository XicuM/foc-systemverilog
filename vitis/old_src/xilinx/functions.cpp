#include "xilinx.hpp"
#include "utils.hpp"
#include "state/state.hpp"


State state;


void init_AXI_registers()
{
    throw ERROR("Init AXI registers not implemented!");

    INFO("AXI registers initialized.");
}


/*!
 * Reset PI controllers on FPGA
 */
void reset_pi_controllers()
{
    // Write reset to PI controller registers
    // Wait
    // Reset reset signal
    
    throw ERROR("Reset PI controllers not implemented!");

    INFO("Reset PI controllers.");
}


/*!
 * Waits until it receives precharge OK by CAN bus
 */
void precharge()
{
    // Implement CAN libraries
    
    throw ERROR("Precharge not implemented!");

    INFO("Precharge completed.");
}


/*!
 * Opens logic IO
 */
void open_logic_IO()
{
    throw ERROR("Open logic IO not implemented!");

    INFO("Logic IO opened.");
}

/*!
 * \brief Changes speed reference
 */
void change_speed(float speed)
{
    if (speed > SPEED_MAX || speed < -SPEED_MAX)
        throw ERROR("Requested speed out of range.");
    
    throw ERROR("Change speed not implemented!");

    INFO("Speed changed to " + to_string(speed) + " rpm");
}

/*!
 * \brief Changes torque reference
 */
void change_torque(float torque)
{
    if (torque > TORQUE_MAX || torque < -TORQUE_MAX)
        throw ERROR("Requested speed out of range.");

    throw ERROR("Change torque not implemented!");

    INFO("Torque changed to " + to_string(torque) + " Nm");
}


/*!
 * \brief Smoothly stops the engine
 */
void smooth_stop()
{
    throw ERROR("Smooth stop not implemented!");

    INFO("Smooth stop completed.");
}


/*!
 * Closes logic IO
 */
void close_logic_IO()
{
    throw ERROR("Close logic IO not implemented!");

    INFO("Logic IO closed.");
}