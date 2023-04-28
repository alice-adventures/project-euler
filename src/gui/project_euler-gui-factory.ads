-------------------------------------------------------------------------------
--
--  ALICE - Adventures for Learning and Inspiring Coding Excellence
--  Copyright (c) 2023 Francesc Rocher <francesc.rocher@gmail.com>
--  SPDX-License-Identifier: MIT
--
-------------------------------------------------------------------------------

with Project_Euler.GUI.Problem; use Project_Euler.GUI.Problem;

package Project_Euler.GUI.Factory is

   generic
      type Problem_Instance (<>) is new GUI_Problem_Type with private;
   function Problem_Factory return Pointer_To_GUI_Problem_Class;
   --  Instances of this function return a Problem object that implement the
   --  GUI.

   type Pointer_To_Factory_Function is
     access function return Pointer_To_GUI_Problem_Class;
   --  Function used to instantiated Problems of a given type. Runners use
   --  objects of this type to create Problem objects.

end Project_Euler.GUI.Factory;
