# Self-made Inverter

This repository contains the source code for a self-made inverter.

## Test guidelines

Run the tests with the following command from the root directory:

```bash
pytest
```

## Planning

1. Planning
   1. Requirements
      - [ ] Search tool for tracking requirements
      - [ ] Define requirements
   2. Work Breakdown Structure
      - [ ] Search tool for tracking WBS
      - [ ] Define WBS
2. Design
   1. Control Architecture
      - [ ] Investigate control strategies
   2. General System Architecture
      - [ ] Document general system architecture
3. Implementation
   1. Unit tests
      - [ ] Torque Control
      - [ ] Speed Control
      - [ ] Current Control
      - [ ] Decoupling
   2. Hardware implementation
      - [ ] AXI interface
      - [ ] Processing System
   3. Software
      - [ ] Investigate State Machine implementations

## Developer notes

- [ ] Investigate how to implement two modules in the same testfile in cocotb
- [ ] Change test code so that all sources are included