-------------------------------------------------------------------------------
--
--  ALICE - Adventures for Learning and Inspiring Coding Excellence
--  Copyright (c) 2023 Francesc Rocher <francesc.rocher@gmail.com>
--  SPDX-License-Identifier: MIT
--
-------------------------------------------------------------------------------

with Ada.Strings;

with Gnoga.Types;
with UXStrings;

with Project_Euler.GUI.Problems; use Project_Euler.GUI.Problems;

package Project_Euler.GUI.Runners.Gnoga is

   package The_Gnoga renames Standard.Gnoga; --  The GNU Omnificent GUI for Ada
   --  This renaming is necessary to avoid confusion with the current
   --  package, named Gnoga too.

   type Runner_Gnoga_Type is new Runner_Type with null record;
   --  Implementation of the GUI.Runner interface using Gnoga.

   overriding procedure Run
     (Runner            : Runner_Gnoga_Type;
      Problem_Factory   : Pointer_To_Problem_Factory;
      Configure_Options : Pointer_To_Configure_Options);
   --  Main procedure to run the Problem.

   type Runner_Control_Callback is
     access procedure
       (App_Data : not null The_Gnoga.Types.Pointer_to_Connection_Data_Class);
   --  Callback used by the Plotter when the user press some control button,
   --  mainly Continue or Stop.

   type Runner_Answer_Callback is
     access procedure
       (App_Data : not null The_Gnoga.Types.Pointer_to_Connection_Data_Class;
        Answer   : String);
   --  Callback used by the Plotter when the Problem sets the Answer.

private

   Problem_Factory : Problems.Pointer_To_Problem_Factory;

   function UXS
     (Item : UXStrings.ASCII_Character_Array) return UXStrings.UXString renames
     UXStrings.From_ASCII;

   function UXS (Value : Natural) return UXStrings.UXString is
     (UXStrings.Trim (UXS (Value'Image), Ada.Strings.Both));

end Project_Euler.GUI.Runners.Gnoga;
