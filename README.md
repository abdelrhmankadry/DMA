# Verilog DMA Project

This project consists of several Verilog modules that implement a DMA (Direct Memory Access) system. The modules included are:

1. **clock.v**: This module defines a clock signal generation module. It generates a clock signal with a period of 31.25 units.

2. **cpu.v**: The CPU module is responsible for controlling the DMA operations. It has various inputs and outputs, including clock signals, data and address lines, control signals, and flags. The module contains logic to execute different instructions and perform memory operations.

3. **dma.v**: The DMA module handles the data transfer between different devices. It has inputs for the clock signal, interrupt signal, data, address, control signals, and bus request line. The module implements a counter to control the data transfer and manages the source and target registers.

4. **memory.v**: The memory module represents the main memory of the system. It has inputs for clock signal, read and write signals, frame and ready signals, address lines, and data lines. The module contains a memory register array and performs read and write operations based on the control signals.


## Usage

To use this Verilog DMA project, you need a Verilog simulator or synthesis tool such as ModelSim. Follow these steps:

1. Compile all the Verilog files using the appropriate command for your simulator or synthesis tool.

2. Simulate or synthesize the design to obtain the desired results or to generate a bitstream for FPGA programming.

3. Verify the functionality of the DMA system by running test scenarios or connecting it to other modules in your project.