#include "utils.hpp"
#include "state/state.hpp"


extern State state;


Log::Log(const string &type, const string &msg) 
{ 
    cerr << state << type << msg << endl;
}


/*!
 * \brief Exits the program if state is idle, otherwise it stops the engine.
 */
void exit_program(int signum)
{
    if (state == State::IDLE) 
    {
        INFO("Exiting...");
        exit(EXIT_SUCCESS);
    }
    else { cerr << endl; WARNING("You must stop the engine first."); }
}