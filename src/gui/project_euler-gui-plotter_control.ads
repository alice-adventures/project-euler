-------------------------------------------------------------------------------
--
--  ALICE - Adventures for Learning and Inspiring Coding Excellence
--  Copyright (c) 2023 Francesc Rocher <francesc.rocher@gmail.com>
--  SPDX-License-Identifier: MIT
--
-------------------------------------------------------------------------------

package Project_Euler.GUI.Plotter_Control is

   --  These are the operations that a Problem implementing a
   --  GUI_Problem_Type can invoke in other to control the Plotter. Please
   --  refer to the documentation for more information.

   type Control_Interface is limited interface;

   procedure Start (Plotter : in out Control_Interface) is abstract;
   --  Informs the Plotter that the computation starts: usually clears the
   --  plot and answer area.

   procedure Pause (Plotter : in out Control_Interface) is abstract;
   --  Informs the Plotter that the computation is paused: adjusts the
   --  graphical interface so that the user can understand what's going on.

   procedure Stop (Plotter : in out Control_Interface) is abstract;
   --  Informs the Plotter that the computation has ben stopped: adjusts the
   --  graphical interface so that the user can understand what's going on.

end Project_Euler.GUI.Plotter_Control;
