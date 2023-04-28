-------------------------------------------------------------------------------
--
--  ALICE - Adventures for Learning and Inspiring Coding Excellence
--  Copyright (c) 2023 Francesc Rocher <francesc.rocher@gmail.com>
--  SPDX-License-Identifier: MIT
--
-------------------------------------------------------------------------------

package body Project_Euler.GUI.Factory is

   function Problem_Factory return Pointer_To_GUI_Problem_Class is
     (new Problem_Instance);

end Project_Euler.GUI.Factory;
