#include "regs.hpp"
#include "utils.hpp"
#include "state/state.hpp"


extern State state;


ostream& operator<< (ostream &os, const Register &reg)
{
    os << reg.alias << ": " << reg.reg_val << endl;
    return os;
}


Register::Register(stringstream &ss)
{
    char aux0, aux1, aux2;
    int reg_num;

    // TODO: Better error management
    ss >> region >> reg_num
        >> aux0 >> fix.sign >> fix.bits >> fix.bin_point 
        >> aux1 >> alias >> aux2 >> reg_val;

    if (region == "AXI")
        address = 0x43C00000 + reg_num * 4;
    else if (region == "ADC")
        address = 0x43C10000 + reg_num * 4;
    else
        throw ERROR("Invalid parameter syntax");

    write(reg_val);
}

/*!
 * \brief Writes a value to a register
 * \param f Value to be written
 */
void Register::write(float f)
{
    float_cast fcast = { .value = f };
    int mantisa = 0;

    float max = 1<<(fix.bits - fix.bin_point - 1);
    float res = 1/((float) (1<<fix.bin_point));

    if (fcast.value < -max || fcast.value > max -res)
        throw ERROR("Register value out of range. Check fixed point sizing.");

    if (fcast.value == 0) reg_val = 0;
    else 
    {
        mantisa = (1 << 23) | fcast.parts.man;
        reg_val = mantisa >> (22 - fcast.parts.exp - fix.bin_point);

        // Two's complements
        if (fcast.parts.sig) 
            reg_val = (~reg_val + 1) & (0xFFFFFFFF >> (32-fix.bits));
    }

    throw ERROR("Write register not implemented");
    // XilOut32(address, reg_val);
}


/*!
 * \brief Reads a value from a register
 * \return Value read from the register
 */
float Register::read()
{
    throw ERROR("Read register not implemented");
    // reg_val = XilIn32(address);

    float_cast fcast;

    fcast.parts.sig = (reg_val & (1 << (fix.bits-1))) >> (fix.bits-1);

    int aux = reg_val;
    
    // Two's complement
    if (fcast.parts.sig) 
        aux = (~reg_val + 1) & (0xFFFFFFFF >> (32-fix.bits));
    
    if (reg_val == 0) fcast.value = 0;
    else 
    {
        int i = fix.bits-1;
        while (!(aux & (1 << i))) i--;
        fcast.parts.exp = 127 + i - fix.bin_point;
        fcast.parts.man = aux  << (22 - fcast.parts.exp - fix.bin_point);
    }
}


void Sensor::update()
{
    if (reg.read() > limit || reg.read() < -limit) state = State::STOP;
}

void loop(vector<Sensor> sensors)
{
    throw ERROR("Loop not implemented");
    /*
    while(true) 
    {
        for (auto &sensor: sensors) sensor.update();
        this_thread::sleep_for(chrono::milliseconds(10));
    }*/
}


void init_sensors()
{
    throw ERROR("Init sensors not implemented");
    /*
    vector<Sensor> sensors {
        Sensor(70, Register("Temp_Gate_Driver", ADDRESS_TEMP_GDRIVE, {16, 10, 0})),
        Sensor(70, Register("Temp_Motor", ADDRESS_TEMP_MOTOR, {16, 10, 0}))
    };

    thread sp_thread(loop, sensors);
    sp_thread.join();*/
}