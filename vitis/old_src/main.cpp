#include "regs.hpp"
#include "state/state.hpp"
#include "terminal.hpp"
#include "utils.hpp"
#include "xilinx.hpp"
#include <signal.h>

Terminal terminal;

int main()
{  
    // Signal override
    signal(SIGINT, exit_program);
    signal(SIGTERM, exit_program);
    
    // Welcome message
    terminal.welcome();

    // Initialization
    bool program_ok = true;
    try { 
        
        //init_AXI_registers(); 
        //init_sensors();
    } catch (Log log) { program_ok = false; }

    // Generate threads
    if (program_ok) { 
        thread terminal_thread (terminal_loop);
        thread state_thread (state_loop);
        terminal_thread.join();
        state_thread.join();
    }

    return EXIT_SUCCESS;
}