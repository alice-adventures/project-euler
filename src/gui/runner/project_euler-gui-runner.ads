-------------------------------------------------------------------------------
--
--  ALICE - Adventures for Learning and Inspiring Coding Excellence
--  Copyright (c) 2023 Francesc Rocher <francesc.rocher@gmail.com>
--  SPDX-License-Identifier: MIT
--
-------------------------------------------------------------------------------

with Project_Euler.GUI.Problem; use Project_Euler.GUI.Problem;

package Project_Euler.GUI.Runner is

   type GUI_Runner_Type is interface;

   procedure Run
     (Runner  : GUI_Runner_Type;
      Factory : Pointer_To_Problem_Factory_Function) is abstract;
   --  Main entry point of a program that interacts with a Problem that
   --  implements the GUI.

end Project_Euler.GUI.Runner;
