# State machine
By [Xicu Marí](hello@xicu.info)

## Table of contents
1. [Table of contents](#table-of-contents)
2. [Some To Do's](#some-to-dos)
3. [Block diagram](#block-diagram)
4. [Classes](#classes)
   1. [State](#state)
   2. [Terminal](#terminal)
   3. [Log](#log)
   4. [Register](#register)

## Some To Do's

- [ ] Specify the state machine standard.
- [ ] Get rid of old code.
- [ ] Perform tests.

## Block diagram

```mermaid
stateDiagram
    StateIDLE --> StateSTART: state <- StateSTART
    StateSTART --> StatePROCESS: state <- StatePROCESS
    StatePROCESS --> StateSTOP: state <- StateSTOP
    StateSTOP --> StateIDLE: state <- StateIDLE
    StateSTART --> StateSTOP: state <- StateSTOP

    state StateIDLE {
        terminal.activate()
    }

    state StateSTART {
        terminal.deactivate() --> reset_pi_controllers()
        reset_pi_controllers() --> precharge()
        precharge() --> open_logic_IO()
    }

    state StatePROCESS {
        terminal.activate(); --> sensors.update()
        sensors.update() --> terminal.log()
    }

    state StateSTOP {
        terminal.deactivate(); --> smoth_stop()
        smoth_stop() --> close_logic_IO()
        close_logic_IO() --> discharge()
    }
```


```mermaid
stateDiagram
    [*] --> init
    config --> config_fault: config failed
    init --> config_fault: init failed
    init --> config: init done
    config --> operation: config done
    operation --> operation_fault: fault
    operation_fault --> switch_off: ~enable
    operation_fault --> operation: fault reset
    operation --> switch_off: ~enable
    switch_off --> store_data: switch off done
    switch_off --> operation: enable
    store_data --> shutdown: store data done
    config_fault --> shutdown: ~enable
    init --> shutdown: ~enable
    shutdown --> [*] 
```

```mermaid
stateDiagram
    [*] --> start
    start --> not_ready
    not_ready --> switching_disabled
    switching_disabled --> ready_to_switch
    
    ready_to_switch --> switching_enabled
    ready_to_switch --> switching_disabled
    
    switching_enabled --> switching_disabled
    switching_enabled --> operation_enabled
    switching_enabled --> ready_to_switch

    operation_enabled --> quick_stop
    operation_enabled --> switching_enabled
    operation_enabled --> ready_to_switch
    operation_enabled --> switching_disabled

    fault_detected --> fault
    fault --> switching_disabled

    quick_stop --> ready_to_switch
    quick_stop --> switching_disabled
```

## Classes

### State

```mermaid
classDiagram
    State ..> CFriend: Use
    State ..> CEnumeration: Use

    class State {
        +int LOOP_US = 10
        -std::atomic<state_t> _state
        -char* state_names
        -const int[][] valid_transition

        +state_t operator state_t()
        +void operator=()
        +bool operator==()
    }

    class CFriend {
        +std::ostream operator<<()
    }

    class CFunction {
        state_loop(): void
    }

    class CEnumeration {
        +State::state_t IDLE
        +State::state_t START
        +State::state_t PROCESS
        +State::state_t STOP
    }
```

### Terminal

```mermaid
classDiagram
    Terminal ..> CEnumeration: Use

    class Terminal {
        +LOOP_MS
        +std::atomic<bool> is_active
        +void welcome()
        +void log_data()
    }

    class CFunction {
        +void terminal_loop()
    }

    class CEnumeration {
        +Terminal::cmd_t UNKNOWN
        +Terminal::cmd_t HELP
        +Terminal::cmd_t START
        +Terminal::cmd_t STOP
        +Terminal::cmd_t EDIT
        +Terminal::cmd_t SPEED
        +Terminal::cmd_t TORQUE
        +Terminal::cmd_t EXIT
    }
```

### Log

```mermaid
classDiagram
    class Log {
        +Log Log()
    }
```

### Register

```mermaid
classDiagram
    Register ..> float_cast: Use
    Register ..> fixed_point: Use
    Register ..> CFriend: Use 
    Sensor ..> Register: Use

    class Register {
        -std::string region
        -std::string alias
        -fixed_point fix
        +Register Register()
        +Register operator==()
        +void operator=()
        +float operator float()
    }

    class Sensor {
        +regs: Register
        +Sensor Sensor()
        +void update()
    }

    class float_cast {
        +float value
        +struct parts:
            +unsigned int sig
            +unsigned int exp
            +unsigned int man
    }

    class fixed_point {
        +unsigned int bits = 32
        +unsigned int bin_point = 0
        +unsigned int = 0
    }

    class CFriend {
        +std::ostream operator<<()
    }
```