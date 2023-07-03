-------------------------------------------------------------------------------
--
--  ALICE - Adventures for Learning and Inspiring Coding Excellence
--  Copyright (c) 2023 Francesc Rocher <francesc.rocher@gmail.com>
--  SPDX-License-Identifier: MIT
--
-------------------------------------------------------------------------------

with Gnoga.Gui.Element.Canvas;
with Gnoga.Gui.View;
with Gnoga.Types;

with Project_Euler.GUI.Runners.Gnoga; use Project_Euler.GUI.Runners.Gnoga;

package Project_Euler.GUI.Plotters.Canvas is

   type Plotter_Canvas_Type is limited new Plotter_Interface with private;

   procedure Create
     (Plotter         : in out Plotter_Canvas_Type;
      View            :        Gnoga.Gui.View.Pointer_To_View_Base_Class;
      Pause_Callback  :        not null Runner_Control_Callback;
      Stop_Callback   :        not null Runner_Control_Callback;
      Answer_Callback :        not null Runner_Answer_Callback;
      App_Data        : not null Gnoga.Types.Pointer_to_Connection_Data_Class);

   --  Plotter_Control_Interface

   overriding procedure Start (Plotter : in out Plotter_Canvas_Type);

   overriding procedure Pause (Plotter : in out Plotter_Canvas_Type);

   overriding procedure Stop (Plotter : in out Plotter_Canvas_Type);

   --  Plotter_Drawing_Interface

   overriding procedure Clear_Plot (Plotter : in out Plotter_Canvas_Type);

   overriding procedure Set_Layer_Drawing
     (Plotter : in out Plotter_Canvas_Type);

   overriding procedure Set_Layer_Information
     (Plotter : in out Plotter_Canvas_Type);

   overriding procedure Set_Axes
     (Plotter : in out Plotter_Canvas_Type; Min, Max : Float);

   overriding procedure Set_Axes
     (Plotter                    : in out Plotter_Canvas_Type;
      X_Min, X_Max, Y_Min, Y_Max :        Float);

   overriding procedure Draw_Grid
     (Plotter                            : in out Plotter_Canvas_Type;
      X_Major, X_Minor, Y_Major, Y_Minor :        Float);

   overriding procedure Draw_Axes
     (Plotter : in out Plotter_Canvas_Type; X_Label, Y_Label : String);

   overriding procedure Draw_Axes_Rectangle
     (Plotter : in out Plotter_Canvas_Type);

   overriding procedure Plot
     (Plotter : in out Plotter_Canvas_Type; Points : Point_List;
      Color   :        String);

   overriding procedure Line_Width
     (Plotter : in out Plotter_Canvas_Type; Width : Natural);

   overriding procedure Line_Dash
     (Plotter : in out Plotter_Canvas_Type; Length : Natural; Gap : Natural);

   overriding procedure Stroke_Color
     (Plotter : in out Plotter_Canvas_Type; Color : String);

   overriding procedure Fill_Color
     (Plotter : in out Plotter_Canvas_Type; Color : String);

   overriding procedure Line
     (Plotter : in out Plotter_Canvas_Type; X0, Y0, X1, Y1 : Float);

   overriding procedure Rectangle
     (Plotter : in out Plotter_Canvas_Type; X0, Y0, X1, Y1 : Float);

   overriding procedure Fill_Rectangle
     (Plotter : in out Plotter_Canvas_Type; X0, Y0, X1, Y1 : Float);

   overriding procedure Arc
     (Plotter                                : in out Plotter_Canvas_Type;
      X0, Y0, Radius, Start_Angle, End_Angle :        Float; Color : String);

   overriding procedure Font
     (Plotter : in out Plotter_Canvas_Type; Font : String; Height : String);

   overriding procedure Text_Align
     (Plotter : in out Plotter_Canvas_Type; Align : String);
   --  Align text to "left", "right", "center", "start" or "end".

   overriding procedure Text_Baseline
     (Plotter : in out Plotter_Canvas_Type; Baseline : String);

   overriding procedure Text
     (Plotter : in out Plotter_Canvas_Type; X, Y : Float; Text : String);

   overriding procedure Answer
     (Plotter : in out Plotter_Canvas_Type; Answer : String);
   --  Tells the plotter to show the answer: optionally, it can show,  if the
   --  solution is known, whether it is correct or not.

private

   type Layer_Name is (Back, Draw, Info);

   type Axis_Type is record
      Min       : Float;   -- math x min
      Max       : Float;   -- math x max
      Width     : Natural; -- screen width, pixels
      Margin    : Natural; -- screen margin, pixels
      Has_Ticks : Boolean := False;
   end record;

   type Plotter_Canvas_Type is limited new Plotter_Interface with record
      Background      : Gnoga.Gui.Element.Canvas.Canvas_Type;
      Drawing         : Gnoga.Gui.Element.Canvas.Canvas_Type;
      Information     : Gnoga.Gui.Element.Canvas.Canvas_Type;
      Current_Layer   : Layer_Name                                   := Draw;
      Pause_Callback  : Runner_Control_Callback                      := null;
      Stop_Callback   : Runner_Control_Callback                      := null;
      Answer_Callback : Runner_Answer_Callback                       := null;
      App_Data        : Gnoga.Types.Pointer_to_Connection_Data_Class := null;
      X, Y            : Axis_Type;
   end record;

end Project_Euler.GUI.Plotters.Canvas;
