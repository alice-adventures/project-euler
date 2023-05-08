-------------------------------------------------------------------------------
--
--  ALICE - Adventures for Learning and Inspiring Coding Excellence
--  Copyright (c) 2023 Francesc Rocher <francesc.rocher@gmail.com>
--  SPDX-License-Identifier: MIT
--
-------------------------------------------------------------------------------

with Text_IO;

with Gnoga.Application;

package body Project_Euler.GUI.Runners.Gnoga.View is

   -----------------
   -- Create_View --
   -----------------

   procedure Create_View
     (Main_Window : in out The_Gnoga.Gui.Window.Window_Type'Class;
      App         :        App_Data_Access)
   is
   begin
      The_Gnoga.Application.Title (UXS (App.Problem.Title));

      App.Grid.Create
        (Parent => Main_Window, Layout => Window_Layout, Fill_Parent => True,
         Set_Sizes => False, ID => "app_grid");
      App.Grid.Style ("position", "relative");

      App.Panel_Alice := App.Grid.Panel (1, 1);
      App.Panel_Alice.Class_Name ("panel-alice");

      App.Panel_Title := App.Grid.Panel (1, 2);
      App.Panel_Title.Class_Name ("panel-title");
      App.Panel_Title.Put_HTML
        (UXS
           ("<h2>Project Euler &ndash; Problem " & App.Problem.Number'Image &
            "</h2>"));
      App.Panel_Title.Put_HTML (UXS ("<h1>" & App.Problem.Title & "</h1>"));
      App.Panel_Title.Put_HTML
        (UXS ("<p class=""fs-4"">" & App.Problem.Brief & "</p>"));
      App.Panel_Title.Put_HTML
        (UXS
           ("<i class=""fs-5"">See <a target=""_new"" " &
            "href=""https://projecteuler.net/problem=") &
         UXS (App.Problem.Number) & UXS (""">complete description.</a></i>"));
      App.Panel_Title.Horizontal_Rule;

      App.Button_Bar.Panel := App.Grid.Panel (2, 1);
      App.Button_Bar.Panel.Class_Name ("panel-button_bar");

      App.Button_Bar.Start.Create
        (App.Button_Bar.Panel.all, "&nbsp;Start&nbsp;", "button_start");
      App.Button_Bar.Start.Class_Name ("btn btn-primary");
      App.Button_Bar.Start.Access_Key ("s");
      App.Button_Bar.Start.On_Click_Handler
        (Button_Start_On_Click'Unrestricted_Access);
      App.Button_Bar.Panel.Put_HTML (UXS ("<br>"));

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
      App.Panel_Answer.Class_Name ("panel-answer");

      declare
         Answer_Title :
           constant The_Gnoga.Gui.Element.Pointer_To_Element_Class :=
           new The_Gnoga.Gui.Element.Element_Type;
         Answer_Value :
           constant The_Gnoga.Gui.Element.Pointer_To_Element_Class :=
           new The_Gnoga.Gui.Element.Element_Type;
         Answer_Check :
           constant The_Gnoga.Gui.Element.Pointer_To_Element_Class :=
           new The_Gnoga.Gui.Element.Element_Type;
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
   end Create_View;

   ---------------------------
   -- Button_Start_On_Click --
   ---------------------------

   procedure Button_Start_On_Click
     (Object : in out The_Gnoga.Gui.Base.Base_Type'Class)
   is
      App : constant App_Data_Access :=
        App_Data_Access (Object.Connection_Data);
   begin
      App.Button_Bar.Start.Class_Name ("btn btn-primary");
      App.Button_Bar.Start.Disabled (True);
      App.Button_Bar.Stop.Class_Name ("btn btn-danger");
      App.Button_Bar.Stop.Disabled (False);
      App.Problem.Start;
   end Button_Start_On_Click;

   ------------------------------
   -- Button_Continue_On_Click --
   ------------------------------

   procedure Button_Continue_On_Click
     (Object : in out The_Gnoga.Gui.Base.Base_Type'Class)
   is
      App : constant App_Data_Access :=
        App_Data_Access (Object.Connection_Data);
   begin
      App.Button_Bar.Continue.Class_Name ("btn btn-info");
      App.Button_Bar.Continue.Disabled;
      App.Problem.Continue;
   end Button_Continue_On_Click;

   --------------------------
   -- Button_Stop_On_Click --
   --------------------------

   procedure Button_Stop_On_Click
     (Object : in out The_Gnoga.Gui.Base.Base_Type'Class)
   is
      App : constant App_Data_Access :=
        App_Data_Access (Object.Connection_Data);
   begin
      App.Problem.Stop;
      Stop_Callback (Object.Connection_Data);
   end Button_Stop_On_Click;

   --------------------
   -- Pause_Callback --
   --------------------

   procedure Pause_Callback
     (App_Data : not null The_Gnoga.Types.Pointer_to_Connection_Data_Class)
   is
      App : constant App_Data_Access := App_Data_Access (App_Data);
   begin
      --  App.Problem.Step;
      App.Button_Bar.Continue.Class_Name ("btn btn-info");
      App.Button_Bar.Continue.Disabled (False);
   end Pause_Callback;

   -------------------
   -- Stop_Callback --
   -------------------

   procedure Stop_Callback
     (App_Data : not null The_Gnoga.Types.Pointer_to_Connection_Data_Class)
   is
      App : constant App_Data_Access := App_Data_Access (App_Data);
   begin
      App.Button_Bar.Start.Class_Name ("btn btn-primary");
      App.Button_Bar.Start.Disabled (False);
      App.Button_Bar.Continue.Class_Name ("btn btn-info");
      App.Button_Bar.Continue.Disabled;
      App.Button_Bar.Stop.Class_Name ("btn btn-danger");
      App.Button_Bar.Stop.Disabled;
   end Stop_Callback;

   ---------------------
   -- Answer_Callback --
   ---------------------

   procedure Answer_Callback
     (App_Data : not null The_Gnoga.Types.Pointer_to_Connection_Data_Class;
      Answer   : String)
   is
      App : constant App_Data_Access := App_Data_Access (App_Data);
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
         Check : constant The_Gnoga.Gui.Element.Pointer_To_Element_Class :=
           App.Panel_Answer.Element ("answer-check");
      begin
         Correct :=
           Check_Solution (App.Problem.Number, Answer, Known_Solution);

         Text_IO.Put_Line ("--    Check " & Check'Image);
         Text_IO.Put_Line ("--    Correct " & Correct'Image);

         if Known_Solution then
            if Correct then
               Check.Inner_HTML
                 ("<span class='badge text-bg-success fs-5'>correct</span>");
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

end Project_Euler.GUI.Runners.Gnoga.View;
