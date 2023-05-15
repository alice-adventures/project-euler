-------------------------------------------------------------------------------
--
--  ALICE - Adventures for Learning and Inspiring Coding Excellence
--  Copyright (c) 2023 Francesc Rocher <francesc.rocher@gmail.com>
--  SPDX-License-Identifier: MIT
--
-------------------------------------------------------------------------------

with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

with Parse_Args;

package Project_Euler.CLI.Problems is

   type Problem_Interface is limited interface;

   function Number (Problem : Problem_Interface) return Natural is abstract;
   --  Return the number of the Project Euler problem begin solved.

   function Title (Problem : Problem_Interface) return String is abstract;
   --  Return the problem name exactly as is Project Euler.

   function Brief (Problem : Problem_Interface) return String is abstract;
   --  Return a brief description of the problem, usually the last sentence
   --  os the description found in Project Euler web site. Sometimes can
   --  include a reference to the description or key concepts to provide
   --  additional context.

   procedure Configure_Options
     (Problem :        Problem_Interface;
      Parser  : in out Parse_Args.Argument_Parser) is null;
   --  Allow problems to configure additional options, e.g. to modify
   --  algorithm behavior. Users can specify a particular value at program
   --  invocation.

   procedure Parse_Options
     (Problem : in out Problem_Interface;
      Parser  :        Parse_Args.Argument_Parser) is null;
   --  Parse and collect options specified by users.

   function Answer
     (Problem : Problem_Interface; Notes : in out Unbounded_String)
      return String is abstract;
   --  Return a string containing the solution to the problem as it was
   --  entered in the Project Euler web site. Optionally, additional details
   --  can be briefly described in Notes. Remember to trim leading and
   --  trailing white spaces.

end Project_Euler.CLI.Problems;
