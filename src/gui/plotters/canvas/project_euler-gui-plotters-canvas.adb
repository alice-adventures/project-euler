-------------------------------------------------------------------------------
--
--  ALICE - Adventures for Learning and Inspiring Coding Excellence
--  Copyright (c) 2023 Francesc Rocher <francesc.rocher@gmail.com>
--  SPDX-License-Identifier: MIT
--
-------------------------------------------------------------------------------

with Ada.Float_Text_IO;

with Gnoga.Gui.Element; use Gnoga.Gui.Element;
with Gnoga.Gui.Element.Canvas.Context_2D;
with UXStrings;

use Gnoga.Gui.Element.Canvas;
use Gnoga.Gui.Element.Canvas.Context_2D;

package body Project_Euler.GUI.Plotters.Canvas is

   Font_Family_Axis   : constant String  := "Arial";
   Font_Height_Small  : constant String  := "12px";
   Font_Height_Medium : constant String  := "14px";
   Font_Height_Big    : constant String  := "16px";
   Font_Size_Small    : constant Natural := 12;
   Font_Size_Medium   : constant Natural := 14;
   Font_Size_Big      : constant Natural := 16;

   --  keep definitions although not used (yet)
   pragma Unreferenced (Font_Height_Medium);
   pragma Unreferenced (Font_Size_Medium);

   -----------------
   -- Get_Context --
   -----------------

   procedure Get_Context
     (Context : in out Context_2D_Type; Plotter : in out Canvas_Type) with
     Inline
   is
   begin
      if Plotter.Current_Layer = Draw then
         Context.Get_Drawing_Context_2D (Plotter.Drawing);
      else
         Context.Get_Drawing_Context_2D (Plotter.Information);
      end if;
   end Get_Context;

   --------------
   -- Screen_X --
   --------------

   function Screen_X (Plotter : in out Canvas_Type; Px : Float) return Natural
   is
      Sx : constant Float :=
        (Px - Plotter.X.Min) / (Plotter.X.Max - Plotter.X.Min);
   begin
      return
        Natural
          (Float (Plotter.X.Margin) +
           Float'Rounding
             ((Float (Plotter.X.Width) - 2.0 * Float (Plotter.X.Margin)) *
              Sx));
   end Screen_X;

   --------
   -- Sx --
   --------

   function Sx
     (Plotter : in out Canvas_Type; Px : Float) return Natural renames
     Screen_X;

   --------------
   -- Screen_Y --
   --------------

   function Screen_Y (Plotter : in out Canvas_Type; Py : Float) return Natural
   is
      Sy : constant Float :=
        (Py - Plotter.Y.Min) / (Plotter.Y.Max - Plotter.Y.Min);
   begin
      return
        Natural
          (Float (Plotter.Y.Width - Plotter.Y.Margin) -
           Float'Rounding
             ((Float (Plotter.Y.Width) - 2.0 * Float (Plotter.Y.Margin)) *
              Sy));
   end Screen_Y;

   --------
   -- Sy --
   --------

   function Sy
     (Plotter : in out Canvas_Type; Py : Float) return Natural renames
     Screen_Y;

   ---------
   -- UXS --
   ---------

   function UXS
     (Item : UXStrings.ASCII_Character_Array) return UXStrings.UXString renames
     UXStrings.From_ASCII;

   ------------
   -- Create --
   ------------

   procedure Create
     (Plotter         : in out Canvas_Type;
      View            :        Gnoga.Gui.View.Pointer_To_View_Base_Class;
      Pause_Callback  :        not null Runner_Control_Callback;
      Stop_Callback   :        not null Runner_Control_Callback;
      Answer_Callback :        not null Runner_Answer_Callback;
      App_Data        : not null Gnoga.Types.Pointer_to_Connection_Data_Class)
   is
      Context : Context_2D_Type;
   begin
      Plotter.Current_Layer   := Draw;
      Plotter.Pause_Callback  := Pause_Callback;
      Plotter.Stop_Callback   := Stop_Callback;
      Plotter.Answer_Callback := Answer_Callback;
      Plotter.App_Data        := App_Data;

      Plotter.Background.Create
        (Parent => View.all, Width => View.Width, Height => View.Height,
         ID     => "Canvas.Back");
      Plotter.Background.Style ("position", "absolute");
      Plotter.Background.Style ("left", 0);
      Plotter.Background.Style ("top", 0);

      Context.Get_Drawing_Context_2D (Plotter.Background);
      Context.Fill_Color ("#fff");
      Context.Fill_Rectangle
        ((0, 0, Plotter.Background.Width, Plotter.Background.Height));

      Plotter.Drawing.Create
        (Parent => View.all, Width => View.Width, Height => View.Height,
         ID     => "Canvas.Draw");
      Plotter.Drawing.Style ("position", "absolute");
      Plotter.Drawing.Style ("left", 0);
      Plotter.Drawing.Style ("top", 0);

      Plotter.Information.Create
        (Parent => View.all, Width => View.Width, Height => View.Height,
         ID     => "Canvas.Info");
      Plotter.Information.Style ("position", "absolute");
      Plotter.Information.Style ("left", 0);
      Plotter.Information.Style ("top", 0);
   end Create;

   -----------
   -- Start --
   -----------

   overriding procedure Start (Plotter : in out Canvas_Type) is
   begin
      Plotter.Current_Layer := Info;
      Plotter.Clear_Plot;
      Plotter.Current_Layer := Draw;
      Plotter.Clear_Plot;
   end Start;

   -----------
   -- Pause --
   -----------

   overriding procedure Pause (Plotter : in out Canvas_Type) is
   begin
      Plotter.Pause_Callback.all (Plotter.App_Data);
   end Pause;

   ----------
   -- Stop --
   ----------

   overriding procedure Stop (Plotter : in out Canvas_Type) is
   begin
      Plotter.Stop_Callback.all (Plotter.App_Data);
   end Stop;

   ----------------
   -- Clear_Plot --
   ----------------

   overriding procedure Clear_Plot (Plotter : in out Canvas_Type) is
      Context : Context_2D_Type;
   begin
      Get_Context (Context, Plotter);

      Context.Begin_Path;
      Context.Clear_Rectangle
        ([0, 0, Plotter.Drawing.Width, Plotter.Drawing.Height]);
   end Clear_Plot;

   -----------------------
   -- Set_Layer_Drawing --
   -----------------------

   overriding procedure Set_Layer_Drawing (Plotter : in out Canvas_Type) is
   begin
      Plotter.Current_Layer := Draw;
   end Set_Layer_Drawing;

   ---------------------------
   -- Set_Layer_Information --
   ---------------------------

   overriding procedure Set_Layer_Information (Plotter : in out Canvas_Type) is
   begin
      Plotter.Current_Layer := Info;
   end Set_Layer_Information;

   --------------
   -- Set_Axes --
   --------------

   overriding procedure Set_Axes
     (Plotter : in out Canvas_Type; Min, Max : Float)
   is
      Margin_Ratio : constant Natural := 5; -- in %
      Margin       : constant Natural :=
        Natural'Max (Plotter.Background.Width, Plotter.Background.Height) *
        Margin_Ratio / 100;
      Length       : Float;
   begin
      Plotter.X.Width  := Plotter.Background.Width;
      Plotter.X.Margin := Margin;

      Plotter.Y.Width  := Plotter.Background.Height;
      Plotter.Y.Margin := Margin;

      if Plotter.X.Width <= Plotter.Y.Width then
         Plotter.X.Min := Min;
         Plotter.X.Max := Max;
         Length        :=
           (Max - Min) * Float (Plotter.Y.Width - 2 * Plotter.Y.Margin) /
           Float (Plotter.X.Width - 2 * Plotter.X.Margin);
         Plotter.Y.Min := -Length / 2.0;
         Plotter.Y.Max := Length / 2.0;
      else
         Plotter.Y.Min := Min;
         Plotter.Y.Max := Max;
         Length        :=
           (Max - Min) * Float (Plotter.X.Width - 2 * Plotter.X.Margin) /
           Float (Plotter.Y.Width - 2 * Plotter.Y.Margin);
         Plotter.X.Min := (-Length + Max - Min) / 2.0;
         Plotter.X.Max := (Length + Max - Min) / 2.0;
      end if;
   end Set_Axes;

   --------------
   -- Set_Axes --
   --------------

   overriding procedure Set_Axes
     (Plotter : in out Canvas_Type; X_Min, X_Max, Y_Min, Y_Max : Float)
   is
      Margin_Ratio : constant Natural := 5; -- in %
      Margin       : constant Natural :=
        Natural'Max (Plotter.Background.Width, Plotter.Background.Height) *
        Margin_Ratio / 100;
   begin
      Plotter.X.Min    := X_Min;
      Plotter.X.Max    := X_Max;
      Plotter.X.Width  := Plotter.Background.Width;
      Plotter.X.Margin := Margin;

      Plotter.Y.Min    := Y_Min;
      Plotter.Y.Max    := Y_Max;
      Plotter.Y.Width  := Plotter.Background.Height;
      Plotter.Y.Margin := Margin;
   end Set_Axes;

   ---------------
   -- Draw_Grid --
   ---------------

   overriding procedure Draw_Grid
     (Plotter : in out Canvas_Type; X_Major, X_Minor, Y_Major, Y_Minor : Float)
   is
      subtype Label_Type is String (1 .. 12);

      Context : Context_2D_Type;
      Px, Py  : Float;
      Length  : Natural;
      Count   : Natural;
      Label   : Label_Type;

      --  #region Internal procedures
      procedure Draw_X (Δx : Float; Is_Major : Boolean) is
      begin
         if Δx = 0.0 then
            return;
         end if;

         if Is_Major then
            Plotter.X.Has_Ticks := True;
         end if;

         Px    := 0.0;
         Count := 0;
         loop
            Context.Move_To (Sx (Plotter, Px), Sy (Plotter, Plotter.Y.Min));
            Context.Line_To (Sx (Plotter, Px), Sy (Plotter, Plotter.Y.Max));
            Px    := @ - Δx;
            Count := @ + 1;
            exit when Px < Plotter.X.Min;
         end loop;
         if Is_Major and then (Count = 0 or else Px - Plotter.X.Min < Δx / 3.0)
         then
            Context.Move_To
              (Sx (Plotter, Plotter.X.Min), Sy (Plotter, Plotter.Y.Min));
            Context.Line_To
              (Sx (Plotter, Plotter.X.Min), Sy (Plotter, Plotter.Y.Max));
         end if;

         Px    := 0.0;
         Count := 0;
         loop
            Context.Move_To (Sx (Plotter, Px), Sy (Plotter, Plotter.Y.Min));
            Context.Line_To (Sx (Plotter, Px), Sy (Plotter, Plotter.Y.Max));
            Px    := @ + Δx;
            Count := @ + 1;
            exit when Px > Plotter.X.Max;
         end loop;
         if Is_Major and then (Count = 0 or else Plotter.X.Max - Px < Δx / 3.0)
         then
            Context.Move_To
              (Sx (Plotter, Plotter.X.Max), Sy (Plotter, Plotter.Y.Min));
            Context.Line_To
              (Sx (Plotter, Plotter.X.Max), Sy (Plotter, Plotter.Y.Max));
         end if;
      end Draw_X;

      procedure Draw_Y (Δy : Float; Is_Major : Boolean) is
      begin
         if Δy = 0.0 then
            return;
         end if;

         if Is_Major then
            Plotter.Y.Has_Ticks := True;
         end if;

         Py    := 0.0;
         Count := 0;
         loop
            Context.Move_To (Sx (Plotter, Plotter.X.Min), Sy (Plotter, Py));
            Context.Line_To (Sx (Plotter, Plotter.X.Max), Sy (Plotter, Py));
            Py    := @ - Δy;
            Count := @ + 1;
            exit when Py < Plotter.Y.Min;
         end loop;
         if Is_Major and then (Count = 0 or else Py - Plotter.Y.Min < Δy / 3.0)
         then
            Context.Move_To
              (Sx (Plotter, Plotter.X.Min), Sy (Plotter, Plotter.Y.Min));
            Context.Line_To
              (Sx (Plotter, Plotter.X.Max), Sy (Plotter, Plotter.Y.Min));
         end if;

         Py    := 0.0;
         Count := 0;
         loop
            Context.Move_To (Sx (Plotter, Plotter.X.Min), Sy (Plotter, Py));
            Context.Line_To (Sx (Plotter, Plotter.X.Max), Sy (Plotter, Py));
            Py    := @ + Δy;
            Count := @ + 1;
            exit when Py > Plotter.Y.Max;
         end loop;
         if Is_Major and then (Count = 0 or else Plotter.Y.Max - Py < Δy / 3.0)
         then
            Context.Move_To
              (Sx (Plotter, Plotter.X.Min), Sy (Plotter, Plotter.Y.Max));
            Context.Line_To
              (Sx (Plotter, Plotter.X.Max), Sy (Plotter, Plotter.Y.Max));
         end if;
      end Draw_Y;

      procedure Set_Label (Label : in out Label_Type; Value : Float) is
      begin
         if Value < 1_000_000.0 then
            Ada.Float_Text_IO.Put
              (To => Label, Item => Value, Aft => 0, Exp => 0);
         else
            Ada.Float_Text_IO.Put (To => Label, Item => Value, Aft => 3);
         end if;
      end Set_Label;

      --  #end region

   begin
      Context.Get_Drawing_Context_2D (Plotter.Background);

      --  minor ticks
      Context.Stroke_Color ("#ccc");
      Context.Line_Width (1);
      Context.Set_Line_Dash (Center_Dash_List);

      Context.Begin_Path;
      Draw_X (X_Minor, False);
      Draw_Y (Y_Minor, False);
      Context.Stroke;

      --  major ticks
      Context.Stroke_Color ("#999");
      Context.Line_Width (1);
      Context.Set_Line_Dash (Empty_Dash_List);

      Context.Begin_Path;
      Draw_X (X_Major, True);
      Draw_Y (Y_Major, True);
      Context.Stroke;

      --  labels
      Context.Font
        (Family => UXS (Font_Family_Axis), Height => UXS (Font_Height_Small));
      Context.Fill_Color ("#000");

      if X_Major > 0.0 then
         Context.Text_Baseline (Top);
         Context.Text_Alignment (Center);
         Px    := -X_Major;
         Count := 0;
         loop
            exit when Px < Plotter.X.Min;
            Set_Label (Label, Px);
            Length := Font_Size_Small / 2 * UXStrings.Length (UXS (Label));
            Context.Fill_Text
              (UXS (Label), Sx (Plotter, Px) - Length / 2,
               Sy (Plotter, 0.0) + Font_Size_Small + 2, Length);
            Px := @ - X_Major;
         end loop;

         Px    := X_Major;
         Count := 0;
         loop
            exit when Px > Plotter.X.Max;
            Set_Label (Label, Px);
            Length := Font_Size_Small / 2 * UXStrings.Length (UXS (Label));
            Context.Fill_Text
              (UXS (Label), Sx (Plotter, Px) - Length / 2,
               Sy (Plotter, 0.0) + Font_Size_Small + 2, Length);
            Px := @ + X_Major;
         end loop;
      end if;

      if Y_Major > 0.0 then
         Context.Text_Baseline (Bottom);
         Context.Text_Alignment (Right);
         Py    := -Y_Major;
         Count := 0;
         loop
            exit when Py < Plotter.Y.Min;
            Set_Label (Label, Py);
            Length := Font_Size_Small / 2 * UXStrings.Length (UXS (Label));
            Context.Fill_Text
              (UXS (Label), Sx (Plotter, 0.0) - Length - 3,
               Sy (Plotter, Py) - 2, Length);
            Py := @ - Y_Major;
         end loop;

         Py    := Y_Major;
         Count := 0;
         loop
            exit when Py > Plotter.Y.Max;
            if Count < 1_000_000 then
               Ada.Float_Text_IO.Put (To => Label, Item => Py);
            else
               Ada.Float_Text_IO.Put
                 (To => Label, Item => Py, Aft => 0, Exp => 0);
            end if;
            Set_Label (Label, Py);
            Length := Font_Size_Small / 2 * UXStrings.Length (UXS (Label));
            Context.Fill_Text
              (UXS (Label), Sx (Plotter, 0.0) - Length - 3,
               Sy (Plotter, Py) - 2, Length);
            Py := @ + Y_Major;
         end loop;
      end if;
   end Draw_Grid;

   ---------------
   -- Draw_Axes --
   ---------------

   overriding procedure Draw_Axes
     (Plotter : in out Canvas_Type; X_Label, Y_Label : String)
   is
      Context : Context_2D_Type;
      Length  : Natural;
   begin
      Context.Get_Drawing_Context_2D (Plotter.Background);

      Context.Stroke_Color ("#000");
      Context.Line_Width (2);
      Context.Begin_Path;

      Context.Move_To (Sx (Plotter, Plotter.X.Min), Sy (Plotter, 0.0));
      Context.Line_To (Sx (Plotter, Plotter.X.Max), Sy (Plotter, 0.0));

      Context.Move_To (Sx (Plotter, 0.0), Sy (Plotter, Plotter.Y.Min));
      Context.Line_To (Sx (Plotter, 0.0), Sy (Plotter, Plotter.Y.Max));

      Context.Font (UXS (Font_Family_Axis), UXS (Font_Height_Big));
      Context.Fill_Color ("#000");

      Context.Text_Alignment (Left);
      Context.Text_Baseline (Top);
      Length := 6 * UXStrings.Length (UXS (X_Label));
      Context.Fill_Text
        (UXS (X_Label), Sx (Plotter, Plotter.X.Max) - Length / 2,
         Sy (Plotter, 0.0) + 2 +
         (if Plotter.X.Has_Ticks then Font_Size_Big * 2 else Font_Size_Big),
         Length);

      Context.Text_Alignment (Center);
      Context.Text_Baseline (Bottom);
      Length := 6 * UXStrings.Length (UXS (Y_Label));
      Context.Fill_Text
        (UXS (Y_Label), Sx (Plotter, 0.0) - Length / 2,
         Sy (Plotter, Plotter.Y.Max) -
         (if Plotter.Y.Has_Ticks then Font_Size_Big * 2 else Font_Size_Big),
         Length);

      Context.Stroke;
   end Draw_Axes;

   ----------------------
   -- Draw_Axes_Square --
   ----------------------

   overriding procedure Draw_Axes_Rectangle (Plotter : in out Canvas_Type) is
      Context : Context_2D_Type;
      X_Min   : constant Float := Plotter.X.Min;
      Y_Min   : constant Float := Plotter.Y.Min;
      X_Max   : constant Float := Plotter.X.Max;
      Y_Max   : constant Float := Plotter.Y.Max;
   begin
      Context.Get_Drawing_Context_2D (Plotter.Background);

      Context.Begin_Path;
      Context.Stroke_Color ("#000000");
      Context.Line_Width (2);
      Context.Line_Join (Value => Round);
      Context.Rectangle
        ([Sx (Plotter, X_Min), Sy (Plotter, Y_Min),
         Sx (Plotter, X_Max) - Sx (Plotter, X_Min),
         Sy (Plotter, Y_Max) - Sy (Plotter, Y_Min)]);
      Context.Stroke;
   end Draw_Axes_Rectangle;

   ----------
   -- Plot --
   ----------

   overriding procedure Plot
     (Plotter : in out Canvas_Type; Points : Point_List; Color : String)
   is
      Context : Context_2D_Type;
      Point   : Math_Point;
   begin
      Context.Get_Drawing_Context_2D (Plotter.Drawing);

      Context.Begin_Path;
      Context.Stroke_Color (UXS (Color));
      Context.Line_Width (2);
      Context.Line_Join (Value => Miter);

      Point := Points.First_Element;
      Context.Move_To (Sx (Plotter, Point.X), Sy (Plotter, Point.Y));
      for Point of Points loop
         Context.Line_To (Sx (Plotter, Point.X), Sy (Plotter, Point.Y));
      end loop;
      Context.Stroke;
   end Plot;

   ----------------
   -- Line_Width --
   ----------------

   overriding procedure Line_Width
     (Plotter : in out Canvas_Type; Width : Natural)
   is
      Context : Context_2D_Type;
   begin
      Get_Context (Context, Plotter);
      Context.Line_Width (Width);
   end Line_Width;

   ---------------
   -- Line_Dash --
   ---------------

   overriding procedure Line_Dash
     (Plotter : in out Canvas_Type; Length : Natural; Gap : Natural)
   is
      Context : Context_2D_Type;
   begin
      Get_Context (Context, Plotter);
      Context.Set_Line_Dash ([Length, Gap]);
   end Line_Dash;

   ------------------
   -- Stroke_Color --
   ------------------

   overriding procedure Stroke_Color
     (Plotter : in out Canvas_Type; Color : String)
   is
      Context : Context_2D_Type;
   begin
      Get_Context (Context, Plotter);
      Context.Stroke_Color (UXS (Color));
   end Stroke_Color;

   ----------------
   -- Fill_Color --
   ----------------

   overriding procedure Fill_Color
     (Plotter : in out Canvas_Type; Color : String)
   is
      Context : Context_2D_Type;
   begin
      Get_Context (Context, Plotter);
      Context.Fill_Color (UXS (Color));
   end Fill_Color;

   ----------
   -- Line --
   ----------

   overriding procedure Line
     (Plotter : in out Canvas_Type; X0, Y0, X1, Y1 : Float)
   is
      Context : Context_2D_Type;
   begin
      Get_Context (Context, Plotter);

      Context.Begin_Path;
      Context.Move_To (Sx (Plotter, X0), Sy (Plotter, Y0));
      Context.Line_To (Sx (Plotter, X1), Sy (Plotter, Y1));
      Context.Stroke;
   end Line;

   ---------------
   -- Rectangle --
   ---------------

   overriding procedure Rectangle
     (Plotter : in out Canvas_Type; X0, Y0, X1, Y1 : Float)
   is
      Context : Context_2D_Type;
      X : constant Natural := Natural'Min (Sx (Plotter, X0), Sx (Plotter, X1));
      Y : constant Natural := Natural'Min (Sy (Plotter, Y0), Sy (Plotter, Y1));
      Width   : constant Natural :=
        Natural (abs (Sx (Plotter, X1) - Sx (Plotter, X0)));
      Height  : constant Natural :=
        Natural (abs (Sy (Plotter, Y1) - Sy (Plotter, Y0)));
   begin
      Get_Context (Context, Plotter);

      Context.Begin_Path;
      Context.Rectangle (Rectangle => [X, Y, Width, Height]);
      Context.Stroke;
   end Rectangle;

   --------------------
   -- Fill_Rectangle --
   --------------------

   overriding procedure Fill_Rectangle
     (Plotter : in out Canvas_Type; X0, Y0, X1, Y1 : Float)
   is
      Context : Context_2D_Type;
      X : constant Natural := Natural'Min (Sx (Plotter, X0), Sx (Plotter, X1));
      Y : constant Natural := Natural'Min (Sy (Plotter, Y0), Sy (Plotter, Y1));
      Width   : constant Natural :=
        Natural (abs (Sx (Plotter, X1) - Sx (Plotter, X0)));
      Height  : constant Natural :=
        Natural (abs (Sy (Plotter, Y1) - Sy (Plotter, Y0)));
   begin
      Get_Context (Context, Plotter);

      Context.Begin_Path;
      Context.Rectangle (Rectangle => [X, Y, Width, Height]);
      Context.Fill;
   end Fill_Rectangle;

   ---------
   -- Arc --
   ---------

   overriding procedure Arc
     (Plotter                                : in out Canvas_Type;
      X0, Y0, Radius, Start_Angle, End_Angle :        Float; Color : String)
   is
      Context : Context_2D_Type;
   begin
      Get_Context (Context, Plotter);

      Context.Begin_Path;
      Context.Stroke_Color (UXS (Color));
      Context.Line_Width (1);
      --  Context.Move_To (Sx (Plotter, X0), Sy (Plotter, Y0));
      Context.Arc_Degrees
        (Sx (Plotter, X0), Sy (Plotter, Y0),
         Sx (Plotter, Radius) - Sx (Plotter, 0.0), 360.0 - Start_Angle,
         360.0 - End_Angle);
      Context.Stroke;
   end Arc;

   ----------
   -- Font --
   ----------

   overriding procedure Font
     (Plotter : in out Canvas_Type; Font : String; Height : String)
   is
      Context : Context_2D_Type;
   begin
      Get_Context (Context, Plotter);
      Context.Font (UXS (Font), UXS (Height));
   end Font;

   ----------------
   -- Text_Align --
   ----------------

   overriding procedure Text_Align
     (Plotter : in out Canvas_Type; Align : String)
   is
   begin
      null;
   end Text_Align;

   -------------------
   -- Text_Baseline --
   -------------------

   overriding procedure Text_Baseline
     (Plotter : in out Canvas_Type; Baseline : String)
   is
   begin
      null;
   end Text_Baseline;

   ----------
   -- Text --
   ----------

   overriding procedure Text
     (Plotter : in out Canvas_Type; X, Y : Float; Text : String)
   is
      Context : Context_2D_Type;
   begin
      Get_Context (Context, Plotter);
      Context.Fill_Text (UXS (Text), Sx (Plotter, X), Sy (Plotter, Y));
   end Text;

   ------------
   -- Answer --
   ------------

   overriding procedure Answer (Plotter : in out Canvas_Type; Answer : String)
   is
   begin
      Plotter.Answer_Callback.all (Plotter.App_Data, Answer);
   end Answer;

end Project_Euler.GUI.Plotters.Canvas;
