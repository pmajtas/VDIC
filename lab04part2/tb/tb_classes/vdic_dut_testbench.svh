/*
 Copyright 2013 Ray Salemi

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */
class vdic_dut_testbench;

    virtual vdic_dut_bfm bfm;

    function new (virtual vdic_dut_bfm b);
        bfm = b;
    endfunction : new

    vdic_dut_tester tester_h;
    vdic_dut_coverage coverage_h;
    vdic_dut_scoreboard scoreboard_h;

    task execute();

// the tesbench components can be declared locally in the task, but this
// task will not exist later, when using UVM
//        tester tester_h;
//        coverage coverage_h;
//        scoreboard scoreboard_h;

        tester_h     = new(bfm);
        coverage_h   = new(bfm);
        scoreboard_h = new(bfm);

        fork
            coverage_h.execute();
            scoreboard_h.execute();
            tester_h.execute();
        join_none

    endtask : execute
endclass : vdic_dut_testbench


