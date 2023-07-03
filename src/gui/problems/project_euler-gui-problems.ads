-------------------------------------------------------------------------------
--
--  ALICE - Adventures for Learning and Inspiring Coding Excellence
--  Copyright (c) 2023 Francesc Rocher <francesc.rocher@gmail.com>
--  SPDX-License-Identifier: MIT
--
-------------------------------------------------------------------------------

with Project_Euler.CLI.Problems;
with Project_Euler.GUI.Plotters;

package Project_Euler.GUI.Problems is

   type Problem_Task is task interface and CLI.Problems.Problem_Interface;

   type Pointer_To_Problem_Task is access all Problem_Task'Class;

   type Pointer_To_Problem_Factory is
     access function return Pointer_To_Problem_Task;

   type Pointer_To_Configure_Options is access procedure;

   --!pp off
   --  Entries used by GUI implementation
   procedure Initialize (
      Problem : in out Problem_Task;
      Plotter : not null GUI.Plotters.Pointer_To_Plotter_Class)
                                                 is abstract;
   procedure Start      (Problem : Problem_Task) is abstract;
   procedure Continue   (Problem : Problem_Task) is abstract;
   procedure Stop       (Problem : Problem_Task) is abstract;

   --  RFU, when GUI can display and set options
   --  procedure Options    (Problem : Problem_Task) is abstract;
   --!pp on

end Project_Euler.GUI.Problems;
