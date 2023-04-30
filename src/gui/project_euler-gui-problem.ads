-------------------------------------------------------------------------------
--
--  ALICE - Adventures for Learning and Inspiring Coding Excellence
--  Copyright (c) 2023 Francesc Rocher <francesc.rocher@gmail.com>
--  SPDX-License-Identifier: MIT
--
-------------------------------------------------------------------------------

with Project_Euler.CLI.Problem; use Project_Euler.CLI.Problem;
with Project_Euler.GUI.Plotter; use Project_Euler.GUI.Plotter;

with Parse_Args;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package Project_Euler.GUI.Problem is

   type GUI_Problem_Task is task interface and CLI_Problem_Type;

   type Pointer_To_GUI_Problem_Class is access all GUI_Problem_Task'Class;

   type Pointer_To_Problem_Factory_Function is
     access function return Pointer_To_GUI_Problem_Class;

   --!pp off
   procedure Initialize (Problem : GUI_Problem_Task;
                         Plotter : not null Pointer_To_Plotter_Class)
                         is abstract;
   procedure Start      (Problem : GUI_Problem_Task) is abstract;
   procedure Continue   (Problem : GUI_Problem_Task) is abstract;
   procedure Stop       (Problem : GUI_Problem_Task) is abstract;
   --!pp on

end Project_Euler.GUI.Problem;
