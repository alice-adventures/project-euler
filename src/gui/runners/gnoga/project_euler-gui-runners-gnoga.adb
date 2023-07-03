-------------------------------------------------------------------------------
--
--  ALICE - Adventures for Learning and Inspiring Coding Excellence
--  Copyright (c) 2023 Francesc Rocher <francesc.rocher@gmail.com>
--  SPDX-License-Identifier: MIT
--
-------------------------------------------------------------------------------

with Text_IO;

with Gnoga.Application.Multi_Connect;
with Gnoga.Gui.Window;

with Project_Euler.GUI.Runners.Gnoga.View;
use Project_Euler.GUI.Runners.Gnoga.View;

package body Project_Euler.GUI.Runners.Gnoga is

   Arguments_Parsed : Boolean := False;

   procedure On_App_Connect
     (Main_Window : in out The_Gnoga.Gui.Window.Window_Type'Class;
      Connection  :        access The_Gnoga.Application.Multi_Connect
        .Connection_Holder_Type);

   ---------
   -- Run --
   ---------

   overriding procedure Run
     (Runner            : Runner_Gnoga_Type;
      Problem_Factory   : Problems.Pointer_To_Problem_Factory;
      Configure_Options : Pointer_To_Configure_Options)
   is
   begin

      --  Parse arguments
      if not Arguments_Parsed then
         Arguments_Parsed := True;

         Argument_Parser.Add_Option
           (Parse_Args.Make_Boolean_Option (False), "help", 'h', "help",
            "Display this text");

         if Configure_Options /= null then
            Configure_Options.all;
         end if;

         Argument_Parser.Parse_Command_Line;
         if Argument_Parser.Parse_Success then
            if Argument_Parser.Boolean_Value ("help") then
               Argument_Parser.Usage;
               return;
               --  The_Gnoga.Application.Multi_Connect.End_Application;
            end if;
         else
            Text_IO.Put_Line
              ("Error while parsing command-line arguments: " &
               Argument_Parser.Parse_Message);
            return;
            --  The_Gnoga.Application.Multi_Connect.End_Application;
         end if;
      end if;

      Runners.Gnoga.Problem_Factory := Problem_Factory;

      The_Gnoga.Application.Multi_Connect.Initialize
        (Event => On_App_Connect'Unrestricted_Access, Host => "0.0.0.0",
         Port  => 47_800);

      The_Gnoga.Application.HTML_On_Close (UXS (Close_App_HTML));
      The_Gnoga.Application.Multi_Connect.Message_Loop;
   end Run;

   --------------------
   -- On_App_Connect --
   --------------------

   procedure On_App_Connect
     (Main_Window : in out The_Gnoga.Gui.Window.Window_Type'Class;
      Connection  :        access The_Gnoga.Application.Multi_Connect
        .Connection_Holder_Type)
   is
      pragma Unreferenced (Connection);
      App : constant App_Data_Access := new App_Data_Type;
   begin
      App.Problem := Runners.Gnoga.Problem_Factory.all;

      Main_Window.Connection_Data (App);
      Create_View (Main_Window, App);
   end On_App_Connect;

end Project_Euler.GUI.Runners.Gnoga;
