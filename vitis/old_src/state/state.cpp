#include "state/state.hpp"

std::mutex mtx;
extern Terminal terminal;


// ---------------------------------------------------------------------
// OPERATOR << OVERLOAD

ostream& operator<< (ostream& os, const State& st)
{
    os << st.state_names[st._state];
    return os;
}


// ---------------------------------------------------------------------
// STATE MACHINE MAIN LOOP

void state_loop()
{
    while (true)
    { 
        switch (state)
        {
            case State::IDLE:
                break;
            
            case State::START:
                try 
                {
                    terminal.is_active = false;
                    mtx.lock();

                    //reset_pi_controllers();
                    //precharge();
                    //open_logic_IO();
                    state = State::PROCESS;

                    mtx.unlock();
                    terminal.is_active = true;
                }
                catch (Log log) { state = State::IDLE; }
                break;

            case State::PROCESS:
                try
                {
                    // sensors.update();
                }
                catch (Log log) { state = State::STOP; }
                break;
            
            case State::STOP:
                try 
                {
                    terminal.is_active = false;
                    mtx.lock();

                    //smooth_stop();
                    //close_logic_IO();
                    state = State::IDLE;

                    mtx.unlock();
                    terminal.is_active = true;
                }
                catch (Log log) { state = State::IDLE; }
                break;

            default:
                WARNING("Invalid state detected. Stopping engine...");
                state = State::STOP;
        }

        this_thread::sleep_for(chrono::microseconds(State::LOOP_US));
    }
}
