-------------------------------------------------------------------------------
--
--  ALICE - Adventures for Learning and Inspiring Coding Excellence
--  Copyright (c) 2023 Francesc Rocher <francesc.rocher@gmail.com>
--  SPDX-License-Identifier: MIT
--
-------------------------------------------------------------------------------

limited with Project_Euler.GUI.Problems;

package Project_Euler.GUI.Runners is

   type Runner_Type is interface;

   procedure Run
     (Runner  : Runner_Type;
      Factory : Problems.Pointer_To_Problem_Factory) is abstract;
   --  Main entry point of a program that interacts with a Problem that
   --  implements the GUI.

end Project_Euler.GUI.Runners;
