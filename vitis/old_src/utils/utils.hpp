#pragma once

#include <iostream>
#include <sstream>
#include <string>


using namespace std;

#define ERROR(x)    Log("\t[ERROR] ", x)
#define WARNING(x)  Log("\t[WARNING] ", x)
#define INFO(x)     Log("\t[INFO] ", x)


class Log { public: Log(const string &type, const string &msg); };


void exit_program(int signum);