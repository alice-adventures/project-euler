-------------------------------------------------------------------------------
--
--  ALICE - Adventures for Learning and Inspiring Coding Excellence
--  Copyright (c) 2023 Francesc Rocher <francesc.rocher@gmail.com>
--  SPDX-License-Identifier: MIT
--
-------------------------------------------------------------------------------

with Gnoga.Gui.Base;
with Gnoga.Gui.Element;
with Gnoga.Gui.Element.Common;
with Gnoga.Gui.View.Grid;
with Gnoga.Gui.Window;

use all type Standard.Gnoga.String;
use all type Standard.Gnoga.Gui.View.Grid.Grid_Element_Type;

with Project_Euler.GUI.Plotters.Canvas; use Project_Euler.GUI.Plotters.Canvas;

package Project_Euler.GUI.Runners.Gnoga.View is

   type Button_Bar_Type is record
      Panel    : The_Gnoga.Gui.View.Pointer_To_View_Base_Class;
      Start    : The_Gnoga.Gui.Element.Common.Button_Type;
      Continue : The_Gnoga.Gui.Element.Common.Button_Type;
      Stop     : The_Gnoga.Gui.Element.Common.Button_Type;
   end record;

   type App_Data_Type is new The_Gnoga.Types.Connection_Data_Type with record
      Grid         : The_Gnoga.Gui.View.Grid.Grid_View_Type;
      Panel_Alice  : The_Gnoga.Gui.View.Pointer_To_View_Base_Class;
      Panel_Title  : The_Gnoga.Gui.View.Pointer_To_View_Base_Class;
      Button_Bar   : Button_Bar_Type;
      Panel_Answer : The_Gnoga.Gui.View.Pointer_To_View_Base_Class;
      Plotter      : aliased Plotter_Canvas_Type;
      Problem      : Pointer_To_Problem_Task := null;
   end record;

   type App_Data_Access is access all App_Data_Type;

   --!pp off
   Window_Layout : constant The_Gnoga.Gui.View.Grid.Grid_Rows_Type :=
     [1 => [COL, COL, COL],
      2 => [COL, COL, COL],
      3 => [COL, COL, COL]];

   --  Grid panels
   --  ┌──────────────────┬──────────────────────────────┬─────┐
   --  │                  │                              │     │
   --  │    "Alice"       │  "Title"                     │     │
   --  │    Logo          │  Problem description         │ RFU │
   --  │                  │                              │     │
   --  ├──────────────────┼──────────────────────────────┼─────┤
   --  │                  │                              │     │
   --  │   "Button_Bar"   │                              │     │
   --  │   Buttons        │   Plotter                    │ RFU │
   --  │                  │                              │     │
   --  │                  │                              │     │
   --  ├──────────────────┼──────────────────────────────┼─────┤
   --  │    empty         │  "Answer"                    │ RFU │
   --  └──────────────────┴──────────────────────────────┴─────┘

   Close_App_HTML : constant String :=
      "<div style=""margin:10%;text-align:center"">" &
         "<img src=" &
            """https://raw.githubusercontent.com/wiki/alice-adventures/" &
            "Alice/Alice_Adventures.png"" width=""25%"">" &
         "<br><br><br>" &
         "<h2>Application closed</h2>" &
         "Thank you for participating in Alice." &
         "<br>" &
         "For more information,please visit " &
         "<a href=""https://github.com/alice-adventures/Alice/wiki"">" &
            "Alice Wiki</a>" &
      "</div>";
   --!pp on

   procedure Create_View
     (Main_Window : in out The_Gnoga.Gui.Window.Window_Type'Class;
      App         :        App_Data_Access);

   procedure Button_Start_On_Click
     (Object : in out The_Gnoga.Gui.Base.Base_Type'Class);

   procedure Button_Continue_On_Click
     (Object : in out The_Gnoga.Gui.Base.Base_Type'Class);

   procedure Button_Stop_On_Click
     (Object : in out The_Gnoga.Gui.Base.Base_Type'Class);

   procedure Pause_Callback
     (App_Data : not null The_Gnoga.Types.Pointer_to_Connection_Data_Class);

   procedure Stop_Callback
     (App_Data : not null The_Gnoga.Types.Pointer_to_Connection_Data_Class);

   procedure Answer_Callback
     (App_Data : not null The_Gnoga.Types.Pointer_to_Connection_Data_Class;
      Answer   : String);

end Project_Euler.GUI.Runners.Gnoga.View;
