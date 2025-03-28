# README 

This project is intended to serve a the base design for the CASB, which is the replacement for the MTC/A and MTC/A+. This respository was designed by B. Harris and is based off the previous work of A. Nikola on QPIX and N. Barros on the CTB. 

# Things to update and commit when version controlling
- `../petalinux/casb_tester/casb_tester.bit`
- `../petalinux/casb_tester/casb_tester.xsa`
- `Changelog.md`
- `create_project.tcl`






# Copy of Nuno Readme


## Vivado environment

This project automates the workflow through the use of the tcl interface from Vivado, so you should beforehand have it set up. 

Unless you have some other wrapper script, the command below should be what you need (adjust for the installation location):

```bash
source /opt/Xilinx/Vivado/2016.4/settings64.sh
```

- Or add alias to bashrc

## How to build the project

1. Go into the directory where this file is located.
2. Switch to the appropriate branch (there should be one for each version of the design). As a stable condition is reached in a particular branch, it is expected that the branch is merged into master.
3. Create a file called `setup.tcl` in the same directory as the project (a template called `setup_template.tcl` is provided), and define the following variables:

    * `project_name` : The name you want to give to your project. The name does not matter much, since it is local. You might want to make sure that the name does not clash with another existing project
    * `design_name` : The name you want to give to your board design. For simplicity keep it as `ctb`, unless you know what you are doing. It should match a tcl file under `srcs/bd`
    * `ip_repo_dirs` : space separated list of locations for IP definition. Usually you would only have 1 entry, but if you have more, define it here. The paths should be absolute.

    The contents of `ip_repo_dirs` should __at least__ include the location where you closed the `ptb_ip_repository` project (and any other ip repositories you might want to include).

3. Execute the provided `ctb_firmware.tcl` script. You can do this 2 ways:
   1. Source directly from command line:
   ```bash
   vivado -mode batch -source ctb_firmware.tcl
   ```
   2. Open Vivado __from this directory__ and from the tcl console (you usually have one on the bottom of the Vivado window) and source the script:
   ```tcl
   source ./ctb_firmware.tcl
   ```

    If nothing was messed up (I __did__ try this flow), the project will set itself up. Enjoy the view of watching the board design assembling itself incrementally.

4. Once the project is set up you can start working. 

__IMPORTANT__: The project will not be synthesized nor implemented at this stage, as it is assumed that you might want to make changes at this point. It is your responsibility to synthesize and then implement the design.

## How to make changes (development flow)

The basic idea is that the latest stable version of the design (the one used to generate the firmware that is uploaded to the CTB at CERN) is always in sync with master. So, the flow should be:

1. Start from `master` branch and create a new branch with the version name. (You can use `git branch -r` to see the available versions).
```bash
git checkout -b v3 # for example
```

2. Build the project as described above.
3. Make the changes you deem necessary. Synthesize. Implement. Generate the bitstream. Produce the firmware, BOOT.bin, devicetree and everything else.
4. Test the firmware on whatever system suits you best.
5. Edit the `Changelog.md` file and write down the name of the branch and whatever information you think is important for the other developers to know what is in the branch that is not on the master. 
6. __Regenerate the board design tcl file.__ For this open the block design and then click File->Export->Export Block Design...
   1. Alternatively you can use the tcl console (again):
   ```tcl
   write_bd_tcl ctb.tcl
   ```
7. Copy the generated tcl file to `src/bd/ctb.tcl` (replace the existing...)
   * __DO NOT DO THIS IN THE MASTER BRANCH__ (I will have your hide if you do so)
8. If you added or updated constraint files, add them (replace if necessary) to `src/constrs`
   * Keep in mind that all files in that directory are imported into the project when building.
9. Add these files to the repository:
   ```bash
    git add <board design file> <constraints files>
    git commit -m "Some meaningful message"
    git push --set-upstream origin <name of the branch>
    ```

10. Once the whole flow is agreed by the developers, this branch may eventually be merged into `master`
   * Again, __do not do this on your own__ (yep, I will have your hide)


## Additional notes and recomendations

* The idea behind leaving the project name as a configuration parameter is to allow one to have multiple projects derived from this repository. If you cange the `project_name` variable, an appropriately named project will be created, while everything else will continue to run fine. This allows you to keep track of the different implamentations locally (for example, to do parallel development)

* If you use the batch mode (executing the script without opening vivado first) the GUI will not show up. Then, you should open vivado and open the generated project, which will be located in a subdirectory named the same as `project_name`

* If there is already a project with the same name, the script will abort without touching the existing project. This is to avoid accidental overrides.

* Please do __not create local ips__. This makes it hard to synchronize things between different developpers. New IPs should be created (and maintained) in the IP repository.

