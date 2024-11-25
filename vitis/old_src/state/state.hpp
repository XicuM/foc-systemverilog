#pragma once

#include <atomic>
#include <iostream>
#include <mutex>
#include <string>
#include <thread>
#include <unistd.h>

#include "../xilinx.hpp"
#include "../terminal.hpp"
#include "../utils.hpp"

using namespace std;

// Number of states
#define N_STATES 4

class State
{
    public:
        static const int LOOP_US = 100 ;
        enum state_t { IDLE, START, PROCESS, STOP };

        operator state_t() const { return _state; }
        bool operator== (state_t st) { return _state == st; }
        void operator= (state_t new_state)
        {
            if (valid_transition[_state][new_state]) _state = new_state;
            else throw WARNING(
                (string) "Invalid transition from " +
                (string) state_names[_state] + 
                (string) "to " + 
                (string) state_names[new_state]
            );
        }
        friend ostream& operator<< (ostream &os, const State &st);

    private:
        atomic<state_t> _state {IDLE};

        const char *state_names[N_STATES] = {
            "(ST_IDLE) ",
            "(ST_STRT) ",
            "(ST_PROC) ",
            "(ST_STOP) "
        };

        // [Origin state] -> [Destination state]
        const int valid_transition[N_STATES][N_STATES] = {
            // {ST_IDLE, ST_STRT, ST_PROC, ST_STOP}
            {0, 1, 0, 0},  // ST_IDLE -> ST_X
            {1, 0, 1, 1},  // ST_STRT -> ST_X
            {0, 0, 0, 1},  // ST_PROC -> ST_X
            {1, 1, 0, 0}   // ST_STOP -> ST_X
        };
};

// Class instance
extern State state;

// States machine loop function
void state_loop();