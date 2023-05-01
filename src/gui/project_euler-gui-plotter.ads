-------------------------------------------------------------------------------
--
--  ALICE - Adventures for Learning and Inspiring Coding Excellence
--  Copyright (c) 2023 Francesc Rocher <francesc.rocher@gmail.com>
--  SPDX-License-Identifier: MIT
--
-------------------------------------------------------------------------------

with Project_Euler.GUI.Plotter_Control; use Project_Euler.GUI.Plotter_Control;
with Project_Euler.GUI.Plotter_Drawing; use Project_Euler.GUI.Plotter_Drawing;

package Project_Euler.GUI.Plotter is

   type Plotter_Type is
     limited interface and Plotter_Control_IFace and Plotter_Drawing_IFace;

   type Pointer_To_Plotter_Class is access all Plotter_Type'Class;

end Project_Euler.GUI.Plotter;
