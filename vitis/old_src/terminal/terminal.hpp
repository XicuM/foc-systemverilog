#pragma once

#include <atomic>
#include <iostream>
#include <map>
#include <sstream>
#include <string>
#include <thread>


/*!
 * \brief Class for handling command input
 */
class Terminal
{
    public:
        static const int LOOP_MS = 100;
        enum cmd_t { UNKNOWN, HELP, START, STOP, EDIT, SPEED, TORQUE, EXIT };
        std::atomic<bool> is_active {true};

        void welcome();
        void log_data();
};

// Class instance
extern Terminal terminal;

// Terminal loop function
void terminal_loop();