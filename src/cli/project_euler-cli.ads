-------------------------------------------------------------------------------
--
--  ALICE - Adventures for Learning and Inspiring Coding Excellence
--  Copyright (c) 2023 Francesc Rocher <francesc.rocher@gmail.com>
--  SPDX-License-Identifier: MIT
--
-------------------------------------------------------------------------------

limited with Project_Euler.CLI.Problems;

package Project_Euler.CLI is

   procedure Run (Problem : in out Problems.Problem_Interface'Class);
   --  Run the given problem.

end Project_Euler.CLI;
