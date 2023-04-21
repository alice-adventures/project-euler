-------------------------------------------------------------------------------
--
--  ALICE - Adventures for Learning and Inspiring Coding Excellence
--  Copyright (c) 2023 Francesc Rocher <francesc.rocher@gmail.com>
--  SPDX-License-Identifier: MIT
--
-------------------------------------------------------------------------------

with Ada.Strings;

with Gnoga.Application.Multi_Connect;
with Gnoga.Gui.Base;
with Gnoga.Gui.Element;
with Gnoga.Gui.Element.Common;
with Gnoga.Gui.View.Grid;
with Gnoga.Gui.Window;
with UXStrings;

use all type Gnoga.Gui.View.Grid.Grid_Element_Type;

with Project_Euler.GUI;                use Project_Euler.GUI;
with Project_Euler.GUI_Plotter.Canvas; use Project_Euler.GUI_Plotter.Canvas;

use all type Gnoga.String;

package body Project_Euler.GUI_Runner_Gnoga is

   Window_Layout : constant Gnoga.Gui.View.Grid.Grid_Rows_Type :=
     [1 => [COL, COL, COL], 2 => [COL, COL, COL], 3 => [COL, COL, COL]];

   type Button_Bar_Type is record
      Panel    : Gnoga.Gui.View.Pointer_To_View_Base_Class;
      Start    : Gnoga.Gui.Element.Common.Button_Type;
      Step     : Gnoga.Gui.Element.Common.Button_Type;
      Continue : Gnoga.Gui.Element.Common.Button_Type;
      Stop     : Gnoga.Gui.Element.Common.Button_Type;
   end record;

   type App_Data_Type is new Gnoga.Types.Connection_Data_Type with record
      Grid         : Gnoga.Gui.View.Grid.Grid_View_Type;
      Panel_Alice  : Gnoga.Gui.View.Pointer_To_View_Base_Class;
      Panel_Title  : Gnoga.Gui.View.Pointer_To_View_Base_Class;
      Button_Bar   : Button_Bar_Type;
      Panel_Answer : Gnoga.Gui.View.Pointer_To_View_Base_Class;
      Plotter      : aliased Canvas_Type;
      Problem      : Pointer_To_GUI_Class := null;
   end record;
   type App_Access is access all App_Data_Type;

   procedure Button_Start_On_Click
     (Object : in out Gnoga.Gui.Base.Base_Type'Class);
   procedure Button_Step_On_Click
     (Object : in out Gnoga.Gui.Base.Base_Type'Class);
   procedure Button_Continue_On_Click
     (Object : in out Gnoga.Gui.Base.Base_Type'Class);
   procedure Button_Stop_On_Click
     (Object : in out Gnoga.Gui.Base.Base_Type'Class);

   Problem_Factory : Project_Euler.GUI_Factory.Pointer_To_Factory_Function :=
     null;

   ---------
   -- UXS --
   ---------

   function UXS
     (Item : UXStrings.ASCII_Character_Array) return UXStrings.UXString renames
     UXStrings.From_ASCII;

   ---------
   -- UXS --
   ---------

   function UXS (Value : Natural) return UXStrings.UXString is
     (UXStrings.Trim (UXS (Value'Image), Ada.Strings.Both));

   ---------------------------
   -- Button_Start_On_Click --
   ---------------------------

   procedure Button_Start_On_Click
     (Object : in out Gnoga.Gui.Base.Base_Type'Class)
   is
      App : constant App_Access := App_Access (Object.Connection_Data);
   begin
      App.Button_Bar.Start.Class_Name ("btn btn-outline-primary");
      App.Button_Bar.Start.Disabled (True);
      App.Button_Bar.Step.Class_Name ("btn btn-info");
      App.Button_Bar.Step.Disabled (False);
      App.Button_Bar.Stop.Class_Name ("btn btn-danger");
      App.Button_Bar.Stop.Disabled (False);
      App.Problem.On_Start (App.Plotter'Access);
   end Button_Start_On_Click;

   --------------------------
   -- Button_Step_On_Click --
   --------------------------

   procedure Pause_Callback
     (App_Data : not null Gnoga.Types.Pointer_to_Connection_Data_Class)
   is
      App : constant App_Access := App_Access (App_Data);
   begin
      App.Problem.On_Step;
      App.Button_Bar.Continue.Class_Name ("btn btn-light");
      App.Button_Bar.Continue.Disabled (False);
   end Pause_Callback;

   procedure Button_Step_On_Click
     (Object : in out Gnoga.Gui.Base.Base_Type'Class)
   is
   begin
      Pause_Callback (Object.Connection_Data);
   end Button_Step_On_Click;

   ------------------------------
   -- Button_Continue_On_Click --
   ------------------------------

   procedure Button_Continue_On_Click
     (Object : in out Gnoga.Gui.Base.Base_Type'Class)
   is
      App : constant App_Access := App_Access (Object.Connection_Data);
   begin
      App.Button_Bar.Continue.Class_Name ("btn btn-outline-light");
      App.Button_Bar.Continue.Disabled;
      App.Problem.On_Continue;
   end Button_Continue_On_Click;

   --------------------------
   -- Button_Stop_On_Click --
   --------------------------

   procedure Stop_Callback
     (App_Data : not null Gnoga.Types.Pointer_to_Connection_Data_Class)
   is
      App : constant App_Access := App_Access (App_Data);
   begin
      App.Problem.On_Stop;
      App.Button_Bar.Start.Class_Name ("btn btn-primary");
      App.Button_Bar.Start.Disabled (False);
      App.Button_Bar.Step.Class_Name ("btn btn-outline-info");
      App.Button_Bar.Step.Disabled;
      App.Button_Bar.Continue.Class_Name ("btn btn-outline-light");
      App.Button_Bar.Continue.Disabled;
      App.Button_Bar.Stop.Class_Name ("btn btn-outline-danger");
      App.Button_Bar.Stop.Disabled;
   end Stop_Callback;

   procedure Button_Stop_On_Click
     (Object : in out Gnoga.Gui.Base.Base_Type'Class)
   is
   begin
      Stop_Callback (Object.Connection_Data);
   end Button_Stop_On_Click;

   --------------------
   -- On_App_Connect --
   --------------------

   procedure On_App_Connect
     (Main_Window : in out Gnoga.Gui.Window.Window_Type'Class;
      Connection  :        access Gnoga.Application.Multi_Connect
        .Connection_Holder_Type)
   is
      pragma Unreferenced (Connection);
      App : constant App_Access := new App_Data_Type;
   begin

      Main_Window.Connection_Data (App);
      App.Problem := Project_Euler.GUI_Runner_Gnoga.Problem_Factory.all;
      Gnoga.Application.Title (UXS (App.Problem.Title));

      App.Grid.Create
        (Parent => Main_Window, Layout => Window_Layout, Fill_Parent => True,
         Set_Sizes => False, ID => "app_grid");
      App.Grid.Style ("position", "relative");

      App.Panel_Alice := App.Grid.Panel (1, 1);
      App.Panel_Alice.Class_Name ("alice top-row");

      App.Panel_Title := App.Grid.Panel (1, 2);
      App.Panel_Title.Class_Name ("title top-row");
      App.Panel_Title.Put_HTML
        (UXS ("<h2>Problem " & App.Problem.Number'Image & "</h2>"));
      App.Panel_Title.Put_HTML (UXS ("<h1>" & App.Problem.Title & "</h1>"));
      App.Panel_Title.Put_HTML
        (UXS ("<p class=""fs-4"">" & App.Problem.Brief & "</p>"));
      App.Panel_Title.Put_HTML
        (UXS
           ("<i class=""fs-5"">See <a target=""_new"" href=""https://projecteuler.net/problem=") &
         UXS (App.Problem.Number) & UXS (""">complete description.</a></i>"));
      App.Panel_Title.Horizontal_Rule;

      App.Button_Bar.Panel := App.Grid.Panel (2, 1);
      App.Button_Bar.Panel.Class_Name ("button_bar");

      App.Button_Bar.Start.Create
        (App.Button_Bar.Panel.all, "&nbsp;Start&nbsp;", "button_start");
      App.Button_Bar.Start.Class_Name ("btn btn-primary");
      App.Button_Bar.Start.Access_Key ("s");
      App.Button_Bar.Start.On_Click_Handler
        (Button_Start_On_Click'Unrestricted_Access);
      App.Button_Bar.Panel.Put_HTML (UXS ("<br>"));

      App.Button_Bar.Step.Create
        (App.Button_Bar.Panel.all, "&nbsp;Step&nbsp;", "button_step");
      App.Button_Bar.Step.Class_Name ("btn btn-outline-info");
      App.Button_Bar.Step.Access_Key ("t");
      App.Button_Bar.Step.Disabled;
      App.Button_Bar.Step.On_Click_Handler
        (Button_Step_On_Click'Unrestricted_Access);
      App.Button_Bar.Panel.Put_HTML (UXS ("<br>"));

      App.Button_Bar.Continue.Create
        (App.Button_Bar.Panel.all, "&nbsp;Continue&nbsp;", "button_continue");
      App.Button_Bar.Continue.Class_Name ("btn btn-outline-light");
      App.Button_Bar.Continue.Access_Key ("c");
      App.Button_Bar.Continue.Disabled;
      App.Button_Bar.Continue.On_Click_Handler
        (Button_Continue_On_Click'Unrestricted_Access);
      App.Button_Bar.Panel.Put_HTML (UXS ("<br>"));

      App.Button_Bar.Stop.Create
        (App.Button_Bar.Panel.all, "&nbsp;Stop&nbsp;", "button_stop");
      App.Button_Bar.Stop.Class_Name ("btn btn-outline-danger");
      App.Button_Bar.Stop.Access_Key ("p");
      App.Button_Bar.Stop.Disabled;
      App.Button_Bar.Stop.On_Click_Handler
        (Button_Stop_On_Click'Unrestricted_Access);

      App.Panel_Answer := App.Grid.Panel (3, 2);
      App.Panel_Answer.Class_Name ("answer");
      App.Panel_Answer.Put_HTML (UXS ("<h3>Answer:<h3>"));

      App.Plotter.Create
        (App.Grid.Panel (2, 2), Pause_Callback'Access, Stop_Callback'Access,
         Main_Window.Connection_Data);
      App.Problem.Plotter_Setup (App.Plotter'Access);
   end On_App_Connect;

   ----------
   -- Main --
   ----------

   overriding procedure Run
     (Runner  : Gnoga_Runner_Type;
      Factory : Project_Euler.GUI_Factory.Pointer_To_Factory_Function)
   is
   begin
      Project_Euler.GUI_Runner_Gnoga.Problem_Factory := Factory;

      Gnoga.Application.HTML_On_Close
        ("<h3 style='margin:50px;'>Application closed.<h3>");

      Gnoga.Application.Multi_Connect.Initialize
        (Event => On_App_Connect'Unrestricted_Access, Host => "localhost");

      Gnoga.Application.Multi_Connect.Message_Loop;
   end Run;

end Project_Euler.GUI_Runner_Gnoga;
