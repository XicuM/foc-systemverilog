#pragma once

#include <string>
#include <iostream>
#include <sstream>
#include <vector>
#include <thread>

using namespace std;

#define BASE_ADDRESS_AXI 0x43C00000
#define BASE_ADDRESS_ADC 0x43C10000

#define ADDRESS_TEMP_GDRIVE 0x43C10010
#define ADDRESS_TEMP_MOTOR 0x43C10020


typedef union {
    float value;
    struct {
        unsigned int man : 23;
        unsigned int exp : 8;
        unsigned int sig : 1;
    } parts;
} float_cast;


typedef struct {
    unsigned int bits = 32;
    unsigned int bin_point = 0;
    unsigned int sign = 0;    
} fixed_point;


/*!
 * \class Register
 * \brief Class for fixed point registers
 */
class Register
{
    string region, alias;
    fixed_point fix;
    int address, reg_val;

    public:
        Register(string alias_, int address_, fixed_point fix_) 
            : alias(alias_), address(address_), fix(fix_) {}

        Register(stringstream &ss);

        bool operator== (string s) { return alias == s; }
        
        friend ostream& operator<< (ostream &os, const Register &reg);

        void write(float f);
        float read();
};


class Sensor
{
    Register reg;
    float limit;

    public:
        Sensor(float limit_, Register reg_)
            : reg(reg_), limit(limit_) {}
        void update();
};

void init_sensors();