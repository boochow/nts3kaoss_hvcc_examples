# hvcc NTS-3 kaoss pad Examples

This repository provides Pure Data patches for [hvcc_nts3kaoss](https://github.com/boochow/hvcc_nts3kaoss).

## How to Use

If you want to try the pre-built samples, download the binaries from the Releases page.

To build or modify patches yourself, follow these steps:

1. **Install Prerequisites:**  
   Install hvcc, the logue SDK, and [hvcc_nts3kaoss](https://github.com/boochow/hvcc_nts3kaoss).

2. **Clone the Repository:**  
   Copy this repository to your local machine:
   ```bash
   git clone https://github.com/boochow/nts3kaoss_hvcc_examples
   cd nts3kaoss_hvcc_examples
   ```

3. **Edit the Makefile:**  
   Edit the `Makefile` so that PLATFORMDIR points to your logue SDK installation:
   ```
   PLATFORMDIR ?= $(HOME)/logue-sdk/platform
   ```
4. **Build the Units:**  
   To build all units, run:
   
   ```bash
   make
   ```
   
5. **Build a specific unit (optional):**
   The Pure Data patches are located in the `pd/` directory. To build one, specify the patch name without its extension:
   
   ```bash
   make AutoWah
   ```

## Patch Descriptions

- **pd/bgfx/AutoWah.pd** 
  An envelope follower modulates the VCF cutoff. 
- **pd/genfx/GrnDly.pd** 
  Four grains delay. 
- **pd/oscfx/AMDrum.pd** 
  A sine oscillator modulates a square wave.
- **pd/genfx/CombResonator.pd** 
  Stereo comb filter.
