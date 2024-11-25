#include "terminal.hpp"
#include "state/state.hpp"
#include "utils.hpp"
#include "xilinx.hpp"


/*!
 * \brief Enumeration of commands
 */
map<string, Terminal::cmd_t> commands = {
    {"help\0",   Terminal::HELP},
    {"start\0",  Terminal::START},
    {"stop\0",   Terminal::STOP},
    {"edit\0",   Terminal::EDIT},
    {"speed\0",  Terminal::SPEED},
    {"torque\0", Terminal::TORQUE},
    {"exit\0",   Terminal::EXIT}
};


void Terminal::welcome()
{
    cout << endl
         << "   ___   ____  _  __      __  ___     __                             __" << endl
         << "  / _ ) / ___// |/ / ___ /  |/  /__  / /_ __  ___ ___ ___  ___  ____/ /_" << endl
         << " / _  // /__ /    / / -_) /|_/ / _ \\/ __/ _ \\/ __(_-</ _ \\/ _ \\/ __/ __/" << endl
         << "/____/ \\___//_/|_/  \\__/_/  /_/\\___/\\__/\\___/_/ /___/ .__/\\___/_/  \\__/" << endl
         << "                                                   /_/    \e[3mVersion 0.1\e[0m" << endl 
         << endl
         << "Francisco Marí Prats, 2022" << endl
         << "Type 'help' for a list of commands." << endl;
}


void check_value(const string &value) {
    if (value.empty()) throw WARNING("You must provide a value!");
}


void terminal_loop()
{
    string command, value;

    while (true)
    {
        this_thread::sleep_for(chrono::milliseconds(Terminal::LOOP_MS));
        if (!terminal.is_active) continue;

        cout << endl << state << "cmd>";
        cin >> command;

        switch (commands[command]) 
        {
            case Terminal::UNKNOWN:
                cerr << "\"" << command << "\" is not a valid command. ";
            
            case Terminal::HELP:
                cout << "Available commands:" << endl
                     << "   help\t\t- Shows this message" << endl
                     << "   edit\t\t- Opens the parameter list in the editor" << endl
                     << "   start\t\t- Starts the engine" << endl
                     << "   speed <val>\t- Sets speed while running" << endl
                     << "   torque <val>\t- Sets torque while running" << endl
                     << "   stop\t\t- Stops the engine smoothly" << endl
                     << "   exit\t\t- Exits the program" << endl;
                break;

            case Terminal::EDIT:
                system("vi /home/xicu/params/params.txt");
                INFO("Parameters file edited.");
                break;

            case Terminal::START:
                try 
                { 
                    state = State::START;
                    INFO("Starting engine...");
                }
                catch (Log log) {} 
                
                break;

            case Terminal::STOP:
                try 
                { 
                    state = State::STOP;
                    INFO("Stopping engine...");
                }
                catch (Log log) {} 
                break;

            case Terminal::SPEED:
                try 
                { 
                    cin >> value; check_value(value);
                    if (state == State::PROCESS) change_speed(stof(value));
                    else throw WARNING("Can't change speed if engine isn't running"); 
                }
                catch(Log log) {}
                break;

            case Terminal::TORQUE:
                try 
                { 
                    cin >> value; check_value(value);
                    if (state == State::PROCESS) change_torque(stof(value));
                    else throw WARNING("Can't change torque if engine isn't running"); 
                }
                catch(Log log) {}
                break;

            case Terminal::EXIT:
                exit_program(EXIT_SUCCESS);
                break;
        }

        cin.clear();
        command.clear();
    }
}

