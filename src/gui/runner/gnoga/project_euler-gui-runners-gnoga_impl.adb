-------------------------------------------------------------------------------
--
--  ALICE - Adventures for Learning and Inspiring Coding Excellence
--  Copyright (c) 2023 Francesc Rocher <francesc.rocher@gmail.com>
--  SPDX-License-Identifier: MIT
--
-------------------------------------------------------------------------------

with Ada.Strings;
with Text_IO;

with Gnoga.Application.Multi_Connect;
with Gnoga.Gui.Base;
with Gnoga.Gui.Element;
with Gnoga.Gui.Element.Common;
with Gnoga.Gui.View.Grid;
with Gnoga.Gui.Window;
with UXStrings;

use all type Gnoga.Gui.View.Grid.Grid_Element_Type;

with Project_Euler.GUI.Problems;        use Project_Euler.GUI.Problems;
with Project_Euler.GUI.Plotters.Canvas; use Project_Euler.GUI.Plotters.Canvas;

use all type Gnoga.String;

package body Project_Euler.GUI.Runners.Gnoga_Impl is

   Window_Layout : constant Gnoga.Gui.View.Grid.Grid_Rows_Type :=
     [1 => [COL, COL, COL], 2 => [COL, COL, COL], 3 => [COL, COL, COL]];

   type Button_Bar_Type is record
      Panel    : Gnoga.Gui.View.Pointer_To_View_Base_Class;
      Start    : Gnoga.Gui.Element.Common.Button_Type;
      --  Step     : Gnoga.Gui.Element.Common.Button_Type;
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
      Problem      : Pointer_To_GUI_Problem_Class := null;
   end record;
   type App_Access is access all App_Data_Type;

   procedure Button_Start_On_Click
     (Object : in out Gnoga.Gui.Base.Base_Type'Class);
   --  procedure Button_Step_On_Click
   --    (Object : in out Gnoga.Gui.Base.Base_Type'Class);
   procedure Button_Continue_On_Click
     (Object : in out Gnoga.Gui.Base.Base_Type'Class);
   procedure Button_Stop_On_Click
     (Object : in out Gnoga.Gui.Base.Base_Type'Class);

   Problem_Factory :
     Project_Euler.GUI.Problems.Pointer_To_Problem_Factory_Function :=
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
      App.Button_Bar.Start.Class_Name ("btn btn-primary");
      App.Button_Bar.Start.Disabled (True);
      --  App.Button_Bar.Step.Class_Name ("btn btn-info");
      --  App.Button_Bar.Step.Disabled (False);
      App.Button_Bar.Stop.Class_Name ("btn btn-danger");
      App.Button_Bar.Stop.Disabled (False);
      App.Problem.Start;
   end Button_Start_On_Click;

   --------------------
   -- Pause_Callback --
   --------------------

   procedure Pause_Callback
     (App_Data : not null Gnoga.Types.Pointer_to_Connection_Data_Class)
   is
      App : constant App_Access := App_Access (App_Data);
   begin
      --  App.Problem.Step;
      App.Button_Bar.Continue.Class_Name ("btn btn-info");
      App.Button_Bar.Continue.Disabled (False);
   end Pause_Callback;

   --  procedure Button_Step_On_Click
   --    (Object : in out Gnoga.Gui.Base.Base_Type'Class)
   --  is
   --  begin
   --     Pause_Callback (Object.Connection_Data);
   --  end Button_Step_On_Click;

   ------------------------------
   -- Button_Continue_On_Click --
   ------------------------------

   procedure Button_Continue_On_Click
     (Object : in out Gnoga.Gui.Base.Base_Type'Class)
   is
      App : constant App_Access := App_Access (Object.Connection_Data);
   begin
      App.Button_Bar.Continue.Class_Name ("btn btn-info");
      App.Button_Bar.Continue.Disabled;
      App.Problem.Continue;
   end Button_Continue_On_Click;

   -------------------
   -- Stop_Callback --
   -------------------

   procedure Stop_Callback
     (App_Data : not null Gnoga.Types.Pointer_to_Connection_Data_Class)
   is
      App : constant App_Access := App_Access (App_Data);
   begin
      App.Button_Bar.Start.Class_Name ("btn btn-primary");
      App.Button_Bar.Start.Disabled (False);
      --  App.Button_Bar.Step.Class_Name ("btn btn-info");
      --  App.Button_Bar.Step.Disabled;
      App.Button_Bar.Continue.Class_Name ("btn btn-info");
      App.Button_Bar.Continue.Disabled;
      App.Button_Bar.Stop.Class_Name ("btn btn-danger");
      App.Button_Bar.Stop.Disabled;
   end Stop_Callback;

   --------------------------
   -- Button_Stop_On_Click --
   --------------------------

   procedure Button_Stop_On_Click
     (Object : in out Gnoga.Gui.Base.Base_Type'Class)
   is
      App : constant App_Access := App_Access (Object.Connection_Data);
   begin
      App.Problem.Stop;
      Stop_Callback (Object.Connection_Data);
   end Button_Stop_On_Click;

   procedure Answer_Callback
     (App_Data : not null Gnoga.Types.Pointer_to_Connection_Data_Class;
      Answer   : String)
   is
      App : constant App_Access := App_Access (App_Data);
   begin
      Text_IO.Put_Line ("-- ANSWER " & Answer);
      Text_IO.Put_Line
        ("--    Element " & App.Panel_Answer.Element ("answer-value")'Image);
      App.Panel_Answer.Element ("answer-value").Inner_HTML
        (UXS ("<h3>" & Answer & "</h3>"));
      App.Panel_Answer.Element ("answer-value").Visible;

      declare
         Correct        : Boolean;
         Known_Solution : Boolean;
         Check : constant Gnoga.Gui.Element.Pointer_To_Element_Class :=
           App.Panel_Answer.Element ("answer-check");
      begin
         Correct :=
           Check_Solution (App.Problem.Number, Answer, Known_Solution);

         Text_IO.Put_Line ("--    Check " & Check'Image);
         Text_IO.Put_Line ("--    Correct " & Correct'Image);

         if Known_Solution then
            if Correct then
               Check.Inner_HTML
                 ("<span class='badge text-bg-success fs-5'>success</span>");
            else
               Check.Inner_HTML
                 ("<span class='badge text-bg-danger fs-5'>error</span>");
            end if;
         else
            Check.Inner_HTML
              ("<span class='badge text-bg-warning fs-5'>unknown</span>");
         end if;
      end;
   end Answer_Callback;

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
      App.Problem := Project_Euler.GUI.Runners.Gnoga_Impl.Problem_Factory.all;
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

      --  App.Button_Bar.Step.Create
      --    (App.Button_Bar.Panel.all, "&nbsp;Step&nbsp;", "button_step");
      --  App.Button_Bar.Step.Class_Name ("btn btn-info");
      --  App.Button_Bar.Step.Access_Key ("t");
      --  App.Button_Bar.Step.Disabled;
      --  App.Button_Bar.Step.On_Click_Handler
      --    (Button_Step_On_Click'Unrestricted_Access);
      --  App.Button_Bar.Panel.Put_HTML (UXS ("<br>"));

      App.Button_Bar.Continue.Create
        (App.Button_Bar.Panel.all, "&nbsp;Continue&nbsp;", "button_continue");
      App.Button_Bar.Continue.Class_Name ("btn btn-info");
      App.Button_Bar.Continue.Access_Key ("c");
      App.Button_Bar.Continue.Disabled;
      App.Button_Bar.Continue.On_Click_Handler
        (Button_Continue_On_Click'Unrestricted_Access);
      App.Button_Bar.Panel.Put_HTML (UXS ("<br><br>"));

      App.Button_Bar.Stop.Create
        (App.Button_Bar.Panel.all, "&nbsp;Stop&nbsp;", "button_stop");
      App.Button_Bar.Stop.Class_Name ("btn btn-danger");
      App.Button_Bar.Stop.Access_Key ("p");
      App.Button_Bar.Stop.Disabled;
      App.Button_Bar.Stop.On_Click_Handler
        (Button_Stop_On_Click'Unrestricted_Access);

      App.Panel_Answer := App.Grid.Panel (3, 2);
      App.Panel_Answer.Class_Name ("answer");

      declare
         Answer_Title : Gnoga.Gui.Element.Pointer_To_Element_Class :=
           new Gnoga.Gui.Element.Element_Type;
         Answer_Value : Gnoga.Gui.Element.Pointer_To_Element_Class :=
           new Gnoga.Gui.Element.Element_Type;
         Answer_Check : Gnoga.Gui.Element.Pointer_To_Element_Class :=
           new Gnoga.Gui.Element.Element_Type;
      begin
         Answer_Title.Create_From_HTML
           (App.Panel_Answer.all, "<div><h3>Answer:</h3></div>",
            "answer-title");
         Answer_Title.Class_Name ("div_left");
         Answer_Title.Place_Inside_Top_Of (App.Panel_Answer.all);

         Answer_Value.Create_From_HTML
           (App.Panel_Answer.all, "<div><h3></h3></div>", "answer-value");
         Answer_Value.Class_Name ("div_left");
         App.Panel_Answer.Add_Element ("answer-value", Answer_Value);
         Answer_Value.Place_After (Answer_Title.all);

         Answer_Check.Create_From_HTML
           (App.Panel_Answer.all, "<div><span></span></div>", "answer-check");
         Answer_Check.Class_Name ("div_left");
         App.Panel_Answer.Add_Element ("answer-check", Answer_Check);
         Answer_Check.Place_After (Answer_Value.all);
      end;

      App.Plotter.Create
        (App.Grid.Panel (2, 2), Pause_Callback'Access, Stop_Callback'Access,
         Answer_Callback'Access, Main_Window.Connection_Data);
      App.Problem.Initialize (App.Plotter'Access);
   end On_App_Connect;

   ---------
   -- Run --
   ---------

   overriding procedure Run
     (Runner          : Gnoga_Runner_Type;
      Problem_Factory : Project_Euler.GUI.Problems
        .Pointer_To_Problem_Factory_Function)
   is
   begin
      Project_Euler.GUI.Runners.Gnoga_Impl.Problem_Factory := Problem_Factory;

      Gnoga.Application.HTML_On_Close
        ("<h3 style='margin:50px;'>Application closed.<h3>");

      Gnoga.Application.Multi_Connect.Initialize
        (Event => On_App_Connect'Unrestricted_Access, Host => "0.0.0.0");

      Gnoga.Application.Multi_Connect.Message_Loop;
   end Run;

end Project_Euler.GUI.Runners.Gnoga_Impl;
