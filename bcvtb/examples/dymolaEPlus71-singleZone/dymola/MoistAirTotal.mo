package Modelica "Modelica Standard Library (Version 3.2)"
extends Modelica.Icons.Package;
  package Blocks
  "Library of basic input/output control blocks (continuous, discrete, logical, table blocks)"
  import SI = Modelica.SIunits;
  extends Modelica.Icons.Package;

    package Continuous
    "Library of continuous control blocks with internal states"
      import Modelica.Blocks.Interfaces;
      import Modelica.SIunits;
      extends Modelica.Icons.Package;

      block Integrator "Output the integral of the input signal"
        import Modelica.Blocks.Types.Init;
        parameter Real k(unit="1")=1 "Integrator gain";

        /* InitialState is the default, because it was the default in Modelica 2.2
     and therefore this setting is backward compatible
  */
        parameter Modelica.Blocks.Types.Init initType=Modelica.Blocks.Types.Init.InitialState
        "Type of initialization (1: no init, 2: steady state, 3,4: initial output)"
                                                                                          annotation(Evaluate=true,
            Dialog(group="Initialization"));
        parameter Real y_start=0 "Initial or guess value of output (= state)"
          annotation (Dialog(group="Initialization"));
        extends Interfaces.SISO(y(start=y_start));

      initial equation
        if initType == Init.SteadyState then
           der(y) = 0;
        elseif initType == Init.InitialState or
               initType == Init.InitialOutput then
          y = y_start;
        end if;
      equation
        der(y) = k*u;
        annotation (
          Documentation(info="<html>
<p>
This blocks computes output <b>y</b> (element-wise) as
<i>integral</i> of the input <b>u</b> multiplied with
the gain <i>k</i>:
</p>
<pre>
         k
     y = - u
         s
</pre>

<p>
It might be difficult to initialize the integrator in steady state.
This is discussed in the description of package
<a href=\"modelica://Modelica.Blocks.Continuous#info\">Continuous</a>.
</p>

</html>
"),       Icon(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={
              Line(points={{-80,78},{-80,-90}}, color={192,192,192}),
              Polygon(
                points={{-80,90},{-88,68},{-72,68},{-80,90}},
                lineColor={192,192,192},
                fillColor={192,192,192},
                fillPattern=FillPattern.Solid),
              Line(points={{-90,-80},{82,-80}}, color={192,192,192}),
              Polygon(
                points={{90,-80},{68,-72},{68,-88},{90,-80}},
                lineColor={192,192,192},
                fillColor={192,192,192},
                fillPattern=FillPattern.Solid),
              Text(
                extent={{0,-10},{60,-70}},
                lineColor={192,192,192},
                textString="I"),
              Text(
                extent={{-150,-150},{150,-110}},
                lineColor={0,0,0},
                textString="k=%k"),
              Line(points={{-80,-80},{80,80}}, color={0,0,127})}),
          Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={
              Rectangle(extent={{-60,60},{60,-60}}, lineColor={0,0,255}),
              Line(points={{-100,0},{-60,0}}, color={0,0,255}),
              Line(points={{60,0},{100,0}}, color={0,0,255}),
              Text(
                extent={{-36,60},{32,2}},
                lineColor={0,0,0},
                textString="k"),
              Text(
                extent={{-32,0},{36,-58}},
                lineColor={0,0,0},
                textString="s"),
              Line(points={{-46,0},{46,0}}, color={0,0,0})}));
      end Integrator;

      block Derivative "Approximated derivative block"
        import Modelica.Blocks.Types.Init;
        parameter Real k(unit="1")=1 "Gains";
        parameter SIunits.Time T(min=Modelica.Constants.small) = 0.01
        "Time constants (T>0 required; T=0 is ideal derivative block)";
        parameter Modelica.Blocks.Types.Init initType=Modelica.Blocks.Types.Init.NoInit
        "Type of initialization (1: no init, 2: steady state, 3: initial state, 4: initial output)"
                                                                                          annotation(Evaluate=true,
            Dialog(group="Initialization"));
        parameter Real x_start=0 "Initial or guess value of state"
          annotation (Dialog(group="Initialization"));
        parameter Real y_start=0 "Initial value of output (= state)"
          annotation(Dialog(enable=initType == Init.InitialOutput, group=
                "Initialization"));
        extends Interfaces.SISO;

        output Real x(start=x_start) "State of block";

    protected
        parameter Boolean zeroGain = abs(k) < Modelica.Constants.eps;
      initial equation
        if initType == Init.SteadyState then
          der(x) = 0;
        elseif initType == Init.InitialState then
          x = x_start;
        elseif initType == Init.InitialOutput then
          if zeroGain then
             x = u;
          else
             y = y_start;
          end if;
        end if;
      equation
        der(x) = if zeroGain then 0 else (u - x)/T;
        y = if zeroGain then 0 else (k/T)*(u - x);
        annotation (
          Documentation(info="
<HTML>
<p>
This blocks defines the transfer function between the
input u and the output y
(element-wise) as <i>approximated derivative</i>:
</p>
<pre>
             k * s
     y = ------------ * u
            T * s + 1
</pre>
<p>
If you would like to be able to change easily between different
transfer functions (FirstOrder, SecondOrder, ... ) by changing
parameters, use the general block <b>TransferFunction</b> instead
and model a derivative block with parameters<br>
b = {k,0}, a = {T, 1}.
</p>

<p>
If k=0, the block reduces to y=0.
</p>
</HTML>
"),       Icon(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={
              Line(points={{-80,78},{-80,-90}}, color={192,192,192}),
              Polygon(
                points={{-80,90},{-88,68},{-72,68},{-80,90}},
                lineColor={192,192,192},
                fillColor={192,192,192},
                fillPattern=FillPattern.Solid),
              Line(points={{-90,-80},{82,-80}}, color={192,192,192}),
              Polygon(
                points={{90,-80},{68,-72},{68,-88},{90,-80}},
                lineColor={192,192,192},
                fillColor={192,192,192},
                fillPattern=FillPattern.Solid),
              Line(points={{-80,-80},{-80,60},{-70,17.95},{-60,-11.46},{-50,-32.05},
                    {-40,-46.45},{-30,-56.53},{-20,-63.58},{-10,-68.51},{0,-71.96},
                    {10,-74.37},{20,-76.06},{30,-77.25},{40,-78.07},{50,-78.65},{60,
                    -79.06}}, color={0,0,127}),
              Text(
                extent={{-30,14},{86,60}},
                lineColor={192,192,192},
                textString="DT1"),
              Text(
                extent={{-150,-150},{150,-110}},
                lineColor={0,0,0},
                textString="k=%k")}),
          Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={
              Text(
                extent={{-54,52},{50,10}},
                lineColor={0,0,0},
                textString="k s"),
              Text(
                extent={{-54,-6},{52,-52}},
                lineColor={0,0,0},
                textString="T s + 1"),
              Line(points={{-50,0},{50,0}}, color={0,0,0}),
              Rectangle(extent={{-60,60},{60,-60}}, lineColor={0,0,255}),
              Line(points={{-100,0},{-60,0}}, color={0,0,255}),
              Line(points={{60,0},{100,0}}, color={0,0,255})}));
      end Derivative;

      block LimPID
      "P, PI, PD, and PID controller with limited output, anti-windup compensation and setpoint weighting"
        import Modelica.Blocks.Types.InitPID;
        import Modelica.Blocks.Types.SimpleController;
        extends Interfaces.SVcontrol;
        output Real controlError = u_s - u_m
        "Control error (set point - measurement)";

        parameter Modelica.Blocks.Types.SimpleController controllerType=
               Modelica.Blocks.Types.SimpleController.PID "Type of controller";
        parameter Real k(min=0, unit="1") = 1 "Gain of controller";
        parameter SIunits.Time Ti(min=Modelica.Constants.small, start=0.5)
        "Time constant of Integrator block"
           annotation(Dialog(enable=controllerType==SimpleController.PI or
                                    controllerType==SimpleController.PID));
        parameter SIunits.Time Td(min=0, start= 0.1)
        "Time constant of Derivative block"
             annotation(Dialog(enable=controllerType==SimpleController.PD or
                                      controllerType==SimpleController.PID));
        parameter Real yMax(start=1) "Upper limit of output";
        parameter Real yMin=-yMax "Lower limit of output";
        parameter Real wp(min=0) = 1
        "Set-point weight for Proportional block (0..1)";
        parameter Real wd(min=0) = 0
        "Set-point weight for Derivative block (0..1)"
             annotation(Dialog(enable=controllerType==SimpleController.PD or
                                      controllerType==SimpleController.PID));
        parameter Real Ni(min=100*Modelica.Constants.eps) = 0.9
        "Ni*Ti is time constant of anti-windup compensation"
           annotation(Dialog(enable=controllerType==SimpleController.PI or
                                    controllerType==SimpleController.PID));
        parameter Real Nd(min=100*Modelica.Constants.eps) = 10
        "The higher Nd, the more ideal the derivative block"
             annotation(Dialog(enable=controllerType==SimpleController.PD or
                                      controllerType==SimpleController.PID));
        parameter Modelica.Blocks.Types.InitPID initType= Modelica.Blocks.Types.InitPID.DoNotUse_InitialIntegratorState
        "Type of initialization (1: no init, 2: steady state, 3: initial state, 4: initial output)"
                                           annotation(Evaluate=true,
            Dialog(group="Initialization"));
        parameter Boolean limitsAtInit = true
        "= false, if limits are ignored during initializiation"
          annotation(Evaluate=true, Dialog(group="Initialization",
                             enable=controllerType==SimpleController.PI or
                                    controllerType==SimpleController.PID));
        parameter Real xi_start=0
        "Initial or guess value value for integrator output (= integrator state)"
          annotation (Dialog(group="Initialization",
                      enable=controllerType==SimpleController.PI or
                             controllerType==SimpleController.PID));
        parameter Real xd_start=0
        "Initial or guess value for state of derivative block"
          annotation (Dialog(group="Initialization",
                               enable=controllerType==SimpleController.PD or
                                      controllerType==SimpleController.PID));
        parameter Real y_start=0 "Initial value of output"
          annotation(Dialog(enable=initType == InitPID.InitialOutput, group=
                "Initialization"));

        Blocks.Math.Add addP(k1=wp, k2=-1)
          annotation (Placement(transformation(extent={{-80,40},{-60,60}}, rotation=
                 0)));
        Blocks.Math.Add addD(k1=wd, k2=-1) if with_D
          annotation (Placement(transformation(extent={{-80,-10},{-60,10}},
                rotation=0)));
        Blocks.Math.Gain P(k=1)
                           annotation (Placement(transformation(extent={{-40,40},{
                  -20,60}}, rotation=0)));
        Blocks.Continuous.Integrator I(k=1/Ti, y_start=xi_start,
          initType=if initType==InitPID.SteadyState then
                      InitPID.SteadyState else
                   if initType==InitPID.InitialState or
                      initType==InitPID.DoNotUse_InitialIntegratorState then
                      InitPID.InitialState else InitPID.NoInit) if with_I
          annotation (Placement(transformation(extent={{-40,-60},{-20,-40}},
                rotation=0)));
        Blocks.Continuous.Derivative D(k=Td, T=max([Td/Nd, 1.e-14]), x_start=xd_start,
          initType=if initType==InitPID.SteadyState or
                      initType==InitPID.InitialOutput then InitPID.SteadyState else
                   if initType==InitPID.InitialState then InitPID.InitialState else
                      InitPID.NoInit) if with_D
          annotation (Placement(transformation(extent={{-40,-10},{-20,10}},
                rotation=0)));
        Blocks.Math.Gain gainPID(k=k) annotation (Placement(transformation(extent={
                  {30,-10},{50,10}}, rotation=0)));
        Blocks.Math.Add3 addPID annotation (Placement(transformation(
                extent={{0,-10},{20,10}}, rotation=0)));
        Blocks.Math.Add3 addI(k2=-1) if with_I annotation (Placement(
              transformation(extent={{-80,-60},{-60,-40}}, rotation=0)));
        Blocks.Math.Add addSat(k1=+1, k2=-1) if
                                         with_I
          annotation (Placement(transformation(
              origin={80,-50},
              extent={{-10,-10},{10,10}},
              rotation=270)));
        Blocks.Math.Gain gainTrack(k=1/(k*Ni)) if with_I
          annotation (Placement(transformation(extent={{40,-80},{20,-60}}, rotation=
                 0)));
        Blocks.Nonlinear.Limiter limiter(uMax=yMax, uMin=yMin, limitsAtInit=limitsAtInit)
          annotation (Placement(transformation(extent={{70,-10},{90,10}}, rotation=
                  0)));
    protected
        parameter Boolean with_I = controllerType==SimpleController.PI or
                                   controllerType==SimpleController.PID annotation(Evaluate=true, HideResult=true);
        parameter Boolean with_D = controllerType==SimpleController.PD or
                                   controllerType==SimpleController.PID annotation(Evaluate=true, HideResult=true);
    public
        Sources.Constant Dzero(k=0) if not with_D
          annotation (Placement(transformation(extent={{-30,20},{-20,30}}, rotation=
                 0)));
        Sources.Constant Izero(k=0) if not with_I
          annotation (Placement(transformation(extent={{10,-55},{0,-45}}, rotation=
                  0)));
      initial equation
        if initType==InitPID.InitialOutput then
           y = y_start;
        end if;
      equation
        assert(yMax >= yMin, "LimPID: Limits must be consistent. However, yMax (=" + String(yMax) +
                             ") < yMin (=" + String(yMin) + ")");
        if initType == InitPID.InitialOutput and (y_start < yMin or y_start > yMax) then
            Modelica.Utilities.Streams.error("LimPID: Start value y_start (=" + String(y_start) +
               ") is outside of the limits of yMin (=" + String(yMin) +") and yMax (=" + String(yMax) + ")");
        end if;
        assert(limitsAtInit or not limitsAtInit and y >= yMin and y <= yMax,
               "LimPID: During initialization the limits have been switched off.\n" +
               "After initialization, the output y (=" + String(y) +
               ") is outside of the limits of yMin (=" + String(yMin) +") and yMax (=" + String(yMax) + ")");

        connect(u_s, addP.u1) annotation (Line(points={{-120,0},{-96,0},{-96,56},{
                -82,56}}, color={0,0,127}));
        connect(u_s, addD.u1) annotation (Line(points={{-120,0},{-96,0},{-96,6},{
                -82,6}}, color={0,0,127}));
        connect(u_s, addI.u1) annotation (Line(points={{-120,0},{-96,0},{-96,-42},{
                -82,-42}}, color={0,0,127}));
        connect(addP.y, P.u) annotation (Line(points={{-59,50},{-42,50}}, color={0,
                0,127}));
        connect(addD.y, D.u)
          annotation (Line(points={{-59,0},{-42,0}}, color={0,0,127}));
        connect(addI.y, I.u) annotation (Line(points={{-59,-50},{-42,-50}}, color={
                0,0,127}));
        connect(P.y, addPID.u1) annotation (Line(points={{-19,50},{-10,50},{-10,8},
                {-2,8}}, color={0,0,127}));
        connect(D.y, addPID.u2)
          annotation (Line(points={{-19,0},{-2,0}}, color={0,0,127}));
        connect(I.y, addPID.u3) annotation (Line(points={{-19,-50},{-10,-50},{-10,
                -8},{-2,-8}}, color={0,0,127}));
        connect(addPID.y, gainPID.u)
          annotation (Line(points={{21,0},{28,0}}, color={0,0,127}));
        connect(gainPID.y, addSat.u2) annotation (Line(points={{51,0},{60,0},{60,
                -20},{74,-20},{74,-38}}, color={0,0,127}));
        connect(gainPID.y, limiter.u)
          annotation (Line(points={{51,0},{68,0}}, color={0,0,127}));
        connect(limiter.y, addSat.u1) annotation (Line(points={{91,0},{94,0},{94,
                -20},{86,-20},{86,-38}}, color={0,0,127}));
        connect(limiter.y, y)
          annotation (Line(points={{91,0},{110,0}}, color={0,0,127}));
        connect(addSat.y, gainTrack.u) annotation (Line(points={{80,-61},{80,-70},{
                42,-70}}, color={0,0,127}));
        connect(gainTrack.y, addI.u3) annotation (Line(points={{19,-70},{-88,-70},{
                -88,-58},{-82,-58}}, color={0,0,127}));
        connect(u_m, addP.u2) annotation (Line(
            points={{0,-120},{0,-92},{-92,-92},{-92,44},{-82,44}},
            color={0,0,127},
            thickness=0.5));
        connect(u_m, addD.u2) annotation (Line(
            points={{0,-120},{0,-92},{-92,-92},{-92,-6},{-82,-6}},
            color={0,0,127},
            thickness=0.5));
        connect(u_m, addI.u2) annotation (Line(
            points={{0,-120},{0,-92},{-92,-92},{-92,-50},{-82,-50}},
            color={0,0,127},
            thickness=0.5));
        connect(Dzero.y, addPID.u2) annotation (Line(points={{-19.5,25},{-14,25},{
                -14,0},{-2,0}}, color={0,0,127}));
        connect(Izero.y, addPID.u3) annotation (Line(points={{-0.5,-50},{-10,-50},{
                -10,-8},{-2,-8}}, color={0,0,127}));
        annotation (defaultComponentName="PID",
          Icon(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={1,1}), graphics={
              Line(points={{-80,78},{-80,-90}}, color={192,192,192}),
              Polygon(
                points={{-80,90},{-88,68},{-72,68},{-80,90}},
                lineColor={192,192,192},
                fillColor={192,192,192},
                fillPattern=FillPattern.Solid),
              Line(points={{-90,-80},{82,-80}}, color={192,192,192}),
              Polygon(
                points={{90,-80},{68,-72},{68,-88},{90,-80}},
                lineColor={192,192,192},
                fillColor={192,192,192},
                fillPattern=FillPattern.Solid),
              Line(points={{-80,-80},{-80,50},{-80,-20},{30,60},{80,60}}, color={0,
                    0,127}),
              Text(
                extent={{-20,-20},{80,-60}},
                lineColor={192,192,192},
                textString="PID")}),
          Documentation(info="<HTML>
<p>
Via parameter <b>controllerType</b> either <b>P</b>, <b>PI</b>, <b>PD</b>,
or <b>PID</b> can be selected. If, e.g., PI is selected, all components belonging to the
D-part are removed from the block (via conditional declarations).
The example model
<a href=\"modelica://Modelica.Blocks.Examples.PID_Controller\">Modelica.Blocks.Examples.PID_Controller</a>
demonstrates the usage of this controller.
Several practical aspects of PID controller design are incorporated
according to chapter 3 of the book:
</p>

<dl>
<dt>&Aring;str&ouml;m K.J., and H&auml;gglund T.:</dt>
<dd> <b>PID Controllers: Theory, Design, and Tuning</b>.
     Instrument Society of America, 2nd edition, 1995.
</dd>
</dl>

<p>
Besides the additive <b>proportional, integral</b> and <b>derivative</b>
part of this controller, the following features are present:
</p>
<ul>
<li> The output of this controller is limited. If the controller is
     in its limits, anti-windup compensation is activated to drive
     the integrator state to zero. </li>
<li> The high-frequency gain of the derivative part is limited
     to avoid excessive amplification of measurement noise.</li>
<li> Setpoint weighting is present, which allows to weight
     the setpoint in the proportional and the derivative part
     independantly from the measurement. The controller will respond
     to load disturbances and measurement noise independantly of this setting
     (parameters wp, wd). However, setpoint changes will depend on this
     setting. For example, it is useful to set the setpoint weight wd
     for the derivative part to zero, if steps may occur in the
     setpoint signal.</li>
</ul>

<p>
The parameters of the controller can be manually adjusted by performing
simulations of the closed loop system (= controller + plant connected
together) and using the following strategy:
</p>

<ol>
<li> Set very large limits, e.g., yMax = Modelica.Constants.inf</li>
<li> Select a <b>P</b>-controller and manually enlarge parameter <b>k</b>
     (the total gain of the controller) until the closed-loop response
     cannot be improved any more.</li>
<li> Select a <b>PI</b>-controller and manually adjust parameters
     <b>k</b> and <b>Ti</b> (the time constant of the integrator).
     The first value of Ti can be selected, such that it is in the
     order of the time constant of the oscillations occuring with
     the P-controller. If, e.g., vibrations in the order of T=10 ms
     occur in the previous step, start with Ti=0.01 s.</li>
<li> If you want to make the reaction of the control loop faster
     (but probably less robust against disturbances and measurement noise)
     select a <b>PID</b>-Controller and manually adjust parameters
     <b>k</b>, <b>Ti</b>, <b>Td</b> (time constant of derivative block).</li>
<li> Set the limits yMax and yMin according to your specification.</li>
<li> Perform simulations such that the output of the PID controller
     goes in its limits. Tune <b>Ni</b> (Ni*Ti is the time constant of
     the anti-windup compensation) such that the input to the limiter
     block (= limiter.u) goes quickly enough back to its limits.
     If Ni is decreased, this happens faster. If Ni=infinity, the
     anti-windup compensation is switched off and the controller works bad.</li>
</ol>

<p>
<b>Initialization</b>
</p>

<p>
This block can be initialized in different
ways controlled by parameter <b>initType</b>. The possible
values of initType are defined in
<a href=\"modelica://Modelica.Blocks.Types.InitPID\">Modelica.Blocks.Types.InitPID</a>.
This type is identical to
<a href=\"modelica://Modelica.Blocks.Types.Init\">Types.Init</a>,
with the only exception that the additional option
<b>DoNotUse_InitialIntegratorState</b> is added for
backward compatibility reasons (= integrator is initialized with
InitialState whereas differential part is initialized with
NoInit which was the initialization in version 2.2 of the Modelica
standard library).
</p>

<p>
Based on the setting of initType, the integrator (I) and derivative (D)
blocks inside the PID controller are initialized according to the following table:
</p>

<table border=1 cellspacing=0 cellpadding=2>
  <tr><td valign=\"top\"><b>initType</b></td>
      <td valign=\"top\"><b>I.initType</b></td>
      <td valign=\"top\"><b>D.initType</b></td></tr>

  <tr><td valign=\"top\"><b>NoInit</b></td>
      <td valign=\"top\">NoInit</td>
      <td valign=\"top\">NoInit</td></tr>

  <tr><td valign=\"top\"><b>SteadyState</b></td>
      <td valign=\"top\">SteadyState</td>
      <td valign=\"top\">SteadyState</td></tr>

  <tr><td valign=\"top\"><b>InitialState</b></td>
      <td valign=\"top\">InitialState</td>
      <td valign=\"top\">InitialState</td></tr>

  <tr><td valign=\"top\"><b>InitialOutput</b><br>
          and initial equation: y = y_start</td>
      <td valign=\"top\">NoInit</td>
      <td valign=\"top\">SteadyState</td></tr>

  <tr><td valign=\"top\"><b>DoNotUse_InitialIntegratorState</b></td>
      <td valign=\"top\">InitialState</td>
      <td valign=\"top\">NoInit</td></tr>
</table>

<p>
In many cases, the most useful initial condition is
<b>SteadyState</b> because initial transients are then no longer
present. If initType = InitPID.SteadyState, then in some
cases difficulties might occur. The reason is the
equation of the integrator:
</p>

<pre>
   <b>der</b>(y) = k*u;
</pre>

<p>
The steady state equation \"der(x)=0\" leads to the condition that the input u to the
integrator is zero. If the input u is already (directly or indirectly) defined
by another initial condition, then the initialization problem is <b>singular</b>
(has none or infinitely many solutions). This situation occurs often
for mechanical systems, where, e.g., u = desiredSpeed - measuredSpeed and
since speed is both a state and a derivative, it is natural to
initialize it with zero. As sketched this is, however, not possible.
The solution is to not initialize u_m or the variable that is used
to compute u_m by an algebraic equation.
</p>

<p>
If parameter <b>limitAtInit</b> = <b>false</b>, the limits at the
output of this controller block are removed from the initialization problem which
leads to a much simpler equation system. After initialization has been
performed, it is checked via an assert whether the output is in the
defined limits. For backward compatibility reasons
<b>limitAtInit</b> = <b>true</b>. In most cases it is best
to use <b>limitAtInit</b> = <b>false</b>.
</p>
</HTML>
"),       Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={1,1}), graphics));
      end LimPID;

      block Filter
      "Continuous low pass, high pass, band pass or band stop IIR-filter of type CriticalDamping, Bessel, Butterworth or ChebyshevI"
        import Modelica.Blocks.Continuous.Internal;

        extends Modelica.Blocks.Interfaces.SISO;

        parameter Modelica.Blocks.Types.AnalogFilter analogFilter=Modelica.Blocks.Types.AnalogFilter.CriticalDamping
        "Analog filter characteristics (CriticalDamping/Bessel/Butterworth/ChebyshevI)";
        parameter Modelica.Blocks.Types.FilterType filterType=Modelica.Blocks.Types.FilterType.LowPass
        "Type of filter (LowPass/HighPass/BandPass/BandStop)";
        parameter Integer order(min=1) = 2 "Order of filter";
        parameter Modelica.SIunits.Frequency f_cut "Cut-off frequency";
        parameter Real gain=1.0
        "Gain (= amplitude of frequency response at zero frequency)";
        parameter Real A_ripple(unit="dB") = 0.5
        "Pass band ripple for Chebyshev filter (otherwise not used); > 0 required"
          annotation(Dialog(enable=analogFilter==Modelica.Blocks.Types.AnalogFilter.ChebyshevI));
        parameter Modelica.SIunits.Frequency f_min=0
        "Band of band pass/stop filter is f_min (A=-3db*gain) .. f_cut (A=-3db*gain)"
          annotation(Dialog(enable=filterType == Modelica.Blocks.Types.FilterType.BandPass or
                                   filterType == Modelica.Blocks.Types.FilterType.BandStop));
        parameter Boolean normalized=true
        "= true, if amplitude at f_cut = -3db, otherwise unmodified filter";
        parameter Modelica.Blocks.Types.Init init=Modelica.Blocks.Types.Init.SteadyState
        "Type of initialization (no init/steady state/initial state/initial output)"
          annotation(Evaluate=true, Dialog(tab="Advanced"));
        final parameter Integer nx = if filterType == Modelica.Blocks.Types.FilterType.LowPass or
                                        filterType == Modelica.Blocks.Types.FilterType.HighPass then
                                        order else 2*order;
        parameter Real x_start[nx] = zeros(nx)
        "Initial or guess values of states"
          annotation(Dialog(tab="Advanced"));
        parameter Real y_start = 0 "Initial value of output"
          annotation(Dialog(tab="Advanced"));
        parameter Real u_nominal = 1.0
        "Nominal value of input (used for scaling the states)"
        annotation(Dialog(tab="Advanced"));
        Modelica.Blocks.Interfaces.RealOutput x[nx] "Filter states";

    protected
        parameter Integer ncr = if analogFilter == Modelica.Blocks.Types.AnalogFilter.CriticalDamping then
                                   order else mod(order,2);
        parameter Integer nc0 = if analogFilter == Modelica.Blocks.Types.AnalogFilter.CriticalDamping then
                                   0 else integer(order/2);
        parameter Integer na = if filterType == Modelica.Blocks.Types.FilterType.BandPass or
                                  filterType == Modelica.Blocks.Types.FilterType.BandStop then order else
                               if analogFilter == Modelica.Blocks.Types.AnalogFilter.CriticalDamping then
                                  0 else integer(order/2);
        parameter Integer nr = if filterType == Modelica.Blocks.Types.FilterType.BandPass or
                                  filterType == Modelica.Blocks.Types.FilterType.BandStop then 0 else
                               if analogFilter == Modelica.Blocks.Types.AnalogFilter.CriticalDamping then
                                  order else mod(order,2);

        // Coefficients of prototype base filter (low pass filter with w_cut = 1 rad/s)
        parameter Real cr[ncr](each fixed=false);
        parameter Real c0[nc0](each fixed=false);
        parameter Real c1[nc0](each fixed=false);

        // Coefficients for differential equations.
        parameter Real r[nr](each fixed=false);
        parameter Real a[na](each fixed=false);
        parameter Real b[na](each fixed=false);
        parameter Real ku[na](each fixed=false);
        parameter Real k1[if filterType == Modelica.Blocks.Types.FilterType.LowPass then 0 else na](
                       each fixed = false);
        parameter Real k2[if filterType == Modelica.Blocks.Types.FilterType.LowPass then 0 else na](
                       each fixed = false);

        // Auxiliary variables
        Real uu[na+nr+1];

      initial equation
         if analogFilter == Modelica.Blocks.Types.AnalogFilter.CriticalDamping then
            cr = Internal.Filter.base.CriticalDamping(order, normalized);
         elseif analogFilter == Modelica.Blocks.Types.AnalogFilter.Bessel then
            (cr,c0,c1) = Internal.Filter.base.Bessel(order, normalized);
         elseif analogFilter == Modelica.Blocks.Types.AnalogFilter.Butterworth then
            (cr,c0,c1) = Internal.Filter.base.Butterworth(order, normalized);
         elseif analogFilter == Modelica.Blocks.Types.AnalogFilter.ChebyshevI then
            (cr,c0,c1) = Internal.Filter.base.ChebyshevI(order, A_ripple, normalized);
         end if;

         if filterType == Modelica.Blocks.Types.FilterType.LowPass then
            (r,a,b,ku) = Internal.Filter.roots.lowPass(cr,c0,c1,f_cut);
         elseif filterType == Modelica.Blocks.Types.FilterType.HighPass then
            (r,a,b,ku,k1,k2) = Internal.Filter.roots.highPass(cr,c0,c1,f_cut);
         elseif filterType == Modelica.Blocks.Types.FilterType.BandPass then
            (a,b,ku,k1,k2) = Internal.Filter.roots.bandPass(cr,c0,c1,f_min,f_cut);
         elseif filterType == Modelica.Blocks.Types.FilterType.BandStop then
            (a,b,ku,k1,k2) = Internal.Filter.roots.bandStop(cr,c0,c1,f_min,f_cut);
         end if;

         if init == Modelica.Blocks.Types.Init.InitialState then
            x = x_start;
         elseif init == Modelica.Blocks.Types.Init.SteadyState then
            der(x) = zeros(nx);
         elseif init == Modelica.Blocks.Types.Init.InitialOutput then
            y = y_start;
            if nx > 1 then
               der(x[1:nx-1]) = zeros(nx-1);
            end if;
         end if;

      equation
         assert(u_nominal > 0, "u_nominal > 0 required");
         assert(filterType == Modelica.Blocks.Types.FilterType.LowPass or
                filterType == Modelica.Blocks.Types.FilterType.HighPass or
                f_min > 0, "f_min > 0 required for band pass and band stop filter");
         assert(A_ripple > 0, "A_ripple > 0 required");
         assert(f_cut > 0, "f_cut > 0  required");

         /* All filters have the same basic differential equations:
        Real poles:
           der(x) = r*x - r*u
        Complex conjugate poles:
           der(x1) = a*x1 - b*x2 + ku*u;
           der(x2) = b*x1 + a*x2;
   */
         uu[1] = u/u_nominal;
         for i in 1:nr loop
            der(x[i]) = r[i]*(x[i] - uu[i]);
         end for;
         for i in 1:na loop
            der(x[nr+2*i-1]) = a[i]*x[nr+2*i-1] - b[i]*x[nr+2*i] + ku[i]*uu[nr+i];
            der(x[nr+2*i])   = b[i]*x[nr+2*i-1] + a[i]*x[nr+2*i];
         end for;

         // The output equation is different for the different filter types
         if filterType == Modelica.Blocks.Types.FilterType.LowPass then
            /* Low pass filter
           Real poles             :  y = x
           Complex conjugate poles:  y = x2
      */
            for i in 1:nr loop
               uu[i+1] = x[i];
            end for;
            for i in 1:na loop
               uu[nr+i+1] = x[nr+2*i];
            end for;

         elseif filterType == Modelica.Blocks.Types.FilterType.HighPass then
            /* High pass filter
           Real poles             :  y = -x + u;
           Complex conjugate poles:  y = k1*x1 + k2*x2 + u;
      */
            for i in 1:nr loop
               uu[i+1] = -x[i] + uu[i];
            end for;
            for i in 1:na loop
               uu[nr+i+1] = k1[i]*x[nr+2*i-1] + k2[i]*x[nr+2*i] + uu[nr+i];
            end for;

         elseif filterType == Modelica.Blocks.Types.FilterType.BandPass then
            /* Band pass filter
           Complex conjugate poles:  y = k1*x1 + k2*x2;
      */
            for i in 1:na loop
               uu[nr+i+1] = k1[i]*x[nr+2*i-1] + k2[i]*x[nr+2*i];
            end for;

         elseif filterType == Modelica.Blocks.Types.FilterType.BandStop then
            /* Band pass filter
           Complex conjugate poles:  y = k1*x1 + k2*x2 + u;
      */
            for i in 1:na loop
               uu[nr+i+1] = k1[i]*x[nr+2*i-1] + k2[i]*x[nr+2*i] + uu[nr+i];
            end for;

         else
            assert(false, "filterType (= " + String(filterType) + ") is unknown");
            uu = zeros(na+nr+1);
         end if;

         y = (gain*u_nominal)*uu[nr+na+1];

        annotation (
          Window(
            x=0.27,
            y=0.1,
            width=0.57,
            height=0.75),
          Icon(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={
              Line(points={{-80,80},{-80,-88}}, color={192,192,192}),
              Polygon(
                points={{-80,92},{-88,70},{-72,70},{-80,90},{-80,92}},
                lineColor={192,192,192},
                fillColor={192,192,192},
                fillPattern=FillPattern.Solid),
              Line(points={{-90,-78},{82,-78}}, color={192,192,192}),
              Polygon(
                points={{90,-78},{68,-70},{68,-86},{90,-78}},
                lineColor={192,192,192},
                fillColor={192,192,192},
                fillPattern=FillPattern.Solid),
              Text(
                extent={{-66,90},{88,52}},
                lineColor={192,192,192},
                textString="%order"),
              Text(
                extent={{-138,-110},{162,-140}},
                lineColor={0,0,0},
                fillColor={0,0,0},
                fillPattern=FillPattern.Solid,
                textString="f_cut=%f_cut"),
              Line(points={{22,10},{14,18},{6,22},{-12,28},{-80,28}}, color={0,0,127}),
              Rectangle(
                extent={{-80,-78},{22,10}},
                lineColor={160,160,164},
                fillColor={255,255,255},
                fillPattern=FillPattern.Backward),
              Line(points={{22,10},{30,-2},{36,-20},{40,-32},{44,-58},{46,-78}})}),
          Diagram(coordinateSystem(
              preserveAspectRatio=false,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics),
          Documentation(info="<html>

<p>
This blocks models various types of filters:
</p>

<blockquote>
<b>low pass, high pass, band pass, and band stop filters</b>
</blockquote>

<p>
using various filter characteristics:
</p>

<blockquote>
<b>CriticalDamping, Bessel, Butterworth, Chebyshev Type I filters</b>
</blockquote>

<p>
By default, a filter block is initialized in <b>steady-state</b>, in order to
avoid unwanted osciallations at the beginning. In special cases, it might be
useful to select one of the other initialization options under tab
\"Advanced\".
</p>

<p>
Typical frequency responses for the 4 supported low pass filter types
are shown in the next figure:
</p>

<blockquote>
<img src=\"modelica://Modelica/Resources/Images/Blocks/LowPassOrder4Filters.png\">
</blockquote>

<p>
The step responses of the same low pass filters are shown in the next figure,
starting from a steady state initial filter with initial input = 0.2:
</p>

<blockquote>
<img src=\"modelica://Modelica/Resources/Images/Blocks/LowPassOrder4FiltersStepResponse.png\">
</blockquote>

<p>
Obviously, the frequency responses give a somewhat wrong impression
of the filter characteristics: Although Butterworth and Chebyshev
filters have a significantly steeper magnitude as the
CriticalDamping and Bessel filters, the step responses of
the latter ones are much better. This means for example, that
a CriticalDamping or a Bessel filter should be selected,
if a filter is mainly used to make a non-linear inverse model
realizable.
</p>

<p>
Typical frequency responses for the 4 supported high pass filter types
are shown in the next figure:
</p>

<blockquote>
<img src=\"modelica://Modelica/Resources/Images/Blocks/HighPassOrder4Filters.png\">
</blockquote>

<p>
The corresponding step responses of these high pass filters are
shown in the next figure:
</p>
<blockquote>
<img src=\"modelica://Modelica/Resources/Images/Blocks/HighPassOrder4FiltersStepResponse.png\">
</blockquote>

<p>
All filters are available in <b>normalized</b> (default) and non-normalized form.
In the normalized form, the amplitude of the filter transfer function
at the cut-off frequency f_cut is -3 dB (= 10^(-3/20) = 0.70794..).
Note, when comparing the filters of this function with other software systems,
the setting of \"normalized\" has to be selected appropriately. For example, the signal processing
toolbox of Matlab provides the filters in non-normalized form and
therefore a comparision makes only sense, if normalized = <b>false</b>
is set. A normalized filter is usually better suited for applications,
since filters of different orders are \"comparable\",
whereas non-normalized filters usually require to adapt the
cut-off frequency, when the order of the filter is changed.
See a comparision of \"normalized\" and \"non-normalized\" filters at hand of
CriticalDamping filters of order 1,2,3:
</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/Blocks/CriticalDampingNormalized.png\">
</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/Blocks/CriticalDampingNonNormalized.png\">
</p>

<h4>Implementation</h4>

<p>
The filters are implemented in the following, reliable way:
</p>

<ol>
<li> A prototype low pass filter with a cut-off angular frequency of 1 rad/s is constructed
     from the desired analogFilter and the desired normalization.</li>

<li> This prototype low pass filter is transformed to the desired filterType and the
     desired cut-off frequency f_cut using a transformation on the Laplace variable \"s\".</li>

<li> The resulting first and second order transfer functions are implemented in
     state space form, using the \"eigen value\" representation of a transfer function:
     <pre>

  // second order block with eigen values: a +/- jb
  <b>der</b>(x1) = a*x1 - b*x2 + (a^2 + b^2)/b*u;
  <b>der</b>(x2) = b*x1 + a*x2;
       y  = x2;
     </pre>
     The dc-gain from the input to the output of this block is one and the selected
     states are in the order of the input (if \"u\" is in the order of \"one\", then the
     states are also in the order of \"one\"). In the \"Advanced\" tab, a \"nominal\" value for
     the input \"u\" can be given. If appropriately selected, the states are in the order of \"one\" and
     then step-size control is always appropriate.</li>
</ol>

<h4>References</h4>

<dl>
<dt>Tietze U., and Schenk C. (2002):</dt>
<dd> <b>Halbleiter-Schaltungstechnik</b>.
     Springer Verlag, 12. Auflage, pp. 815-852.</dd>
</dl>

</html>
",     revisions="<html>
<dl>
  <dt><b>Main Author:</b></dt>
  <dd><a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>,
      DLR Oberpfaffenhofen.</dd>
  </dt>
</dl>

<h4>Acknowledgement</h4>

<p>
The development of this block was partially funded by BMBF within the
     <a href=\"http://www.eurosyslib.com/\">ITEA2 EUROSYSLIB</a>
      project.
</p>

</html>"));
      end Filter;

      package Internal
      "Internal utility functions and blocks that should not be directly utilized by the user"
          extends Modelica.Icons.Package;

        package Filter
        "Internal utility functions for filters that should not be directly used"
            extends Modelica.Icons.Package;

          package base
          "Prototype low pass filters with cut-off frequency of 1 rad/s (other filters are derived by transformation from these base filters)"
              extends Modelica.Icons.Package;

          function CriticalDamping
            "Return base filter coefficients of CriticalDamping filter (= low pass filter with w_cut = 1 rad/s)"

            input Integer order(min=1) "Order of filter";
            input Boolean normalized=true
              "= true, if amplitude at f_cut = -3db, otherwise unmodified filter";

            output Real cr[order] "Coefficients of real poles";
          protected
            Real alpha=1.0 "Frequency correction factor";
            Real alpha2 "= alpha*alpha";
            Real den1[order]
              "[p] coefficients of denominator first order polynomials (a*p + 1)";
            Real den2[0,2]
              "[p^2, p] coefficients of denominator second order polynomials (b*p^2 + a*p + 1)";
            Real c0[0] "Coefficients of s^0 term if conjugate complex pole";
            Real c1[0] "Coefficients of s^1 term if conjugate complex pole";
          algorithm
            if normalized then
               // alpha := sqrt(2^(1/order) - 1);
               alpha := sqrt(10^(3/10/order)-1);
            else
               alpha := 1.0;
            end if;

            for i in 1:order loop
               den1[i] := alpha;
            end for;

            // Determine polynomials with highest power of s equal to one
              (cr,c0,c1) :=
                Modelica.Blocks.Continuous.Internal.Filter.Utilities.toHighestPowerOne(
                den1, den2);

            annotation (Documentation(info="<html>

</html> "));
          end CriticalDamping;

          function Bessel
            "Return base filter coefficients of Bessel filter (= low pass filter with w_cut = 1 rad/s)"

            input Integer order(min=1) "Order of filter";
            input Boolean normalized=true
              "= true, if amplitude at f_cut = -3db, otherwise unmodified filter";

            output Real cr[mod(order, 2)] "Coefficient of real pole";
            output Real c0[integer(order/2)]
              "Coefficients of s^0 term if conjugate complex pole";
            output Real c1[integer(order/2)]
              "Coefficients of s^1 term if conjugate complex pole";
          protected
            Integer n_den2=size(c0, 1);
            Real alpha=1.0 "Frequency correction factor";
            Real alpha2 "= alpha*alpha";
            Real den1[size(cr,1)]
              "[p] coefficients of denominator first order polynomials (a*p + 1)";
            Real den2[n_den2,2]
              "[p^2, p] coefficients of denominator second order polynomials (b*p^2 + a*p + 1)";
          algorithm
              (den1,den2,alpha) :=
                Modelica.Blocks.Continuous.Internal.Filter.Utilities.BesselBaseCoefficients(
                order);
            if not normalized then
               alpha2 := alpha*alpha;
               for i in 1:n_den2 loop
                 den2[i, 1] := den2[i, 1]*alpha2;
                 den2[i, 2] := den2[i, 2]*alpha;
               end for;
               if size(cr,1) == 1 then
                 den1[1] := den1[1]*alpha;
               end if;
               end if;

            // Determine polynomials with highest power of s equal to one
              (cr,c0,c1) :=
                Modelica.Blocks.Continuous.Internal.Filter.Utilities.toHighestPowerOne(
                den1, den2);

            annotation (Documentation(info="<html>

</html> "));
          end Bessel;

          function Butterworth
            "Return base filter coefficients of Butterwort filter (= low pass filter with w_cut = 1 rad/s)"

            input Integer order(min=1) "Order of filter";
            input Boolean normalized=true
              "= true, if amplitude at f_cut = -3db, otherwise unmodified filter";

            output Real cr[mod(order, 2)] "Coefficient of real pole";
            output Real c0[integer(order/2)]
              "Coefficients of s^0 term if conjugate complex pole";
            output Real c1[integer(order/2)]
              "Coefficients of s^1 term if conjugate complex pole";
          protected
            Integer n_den2=size(c0, 1);
            Real alpha=1.0 "Frequency correction factor";
            Real alpha2 "= alpha*alpha";
            Real den1[size(cr,1)]
              "[p] coefficients of denominator first order polynomials (a*p + 1)";
            Real den2[n_den2,2]
              "[p^2, p] coefficients of denominator second order polynomials (b*p^2 + a*p + 1)";
            constant Real pi=Modelica.Constants.pi;
          algorithm
            for i in 1:n_den2 loop
              den2[i, 1] := 1.0;
              den2[i, 2] := -2*Modelica.Math.cos(pi*(0.5 + (i - 0.5)/order));
            end for;
            if size(cr,1) == 1 then
              den1[1] := 1.0;
            end if;

            /* Transformation of filter transfer function with "new(p) = alpha*p"
     in order that the filter transfer function has an amplitude of
     -3 db at the cutoff frequency
  */
            /*
    if normalized then
      alpha := Internal.normalizationFactor(den1, den2);
      alpha2 := alpha*alpha;
      for i in 1:n_den2 loop
        den2[i, 1] := den2[i, 1]*alpha2;
        den2[i, 2] := den2[i, 2]*alpha;
      end for;
      if size(cr,1) == 1 then
        den1[1] := den1[1]*alpha;
      end if;
    end if;
  */

            // Determine polynomials with highest power of s equal to one
              (cr,c0,c1) :=
                Modelica.Blocks.Continuous.Internal.Filter.Utilities.toHighestPowerOne(
                den1, den2);

            annotation (Documentation(info="<html>

</html> "));
          end Butterworth;

          function ChebyshevI
            "Return base filter coefficients of Chebyshev I filter (= low pass filter with w_cut = 1 rad/s)"
              import Modelica.Math.*;

            input Integer order(min=1) "Order of filter";
            input Real A_ripple = 0.5 "Pass band ripple in [dB]";
            input Boolean normalized=true
              "= true, if amplitude at f_cut = -3db, otherwise unmodified filter";

            output Real cr[mod(order, 2)] "Coefficient of real pole";
            output Real c0[integer(order/2)]
              "Coefficients of s^0 term if conjugate complex pole";
            output Real c1[integer(order/2)]
              "Coefficients of s^1 term if conjugate complex pole";
          protected
            Real epsilon;
            Real fac;
            Integer n_den2=size(c0, 1);
            Real alpha=1.0 "Frequency correction factor";
            Real alpha2 "= alpha*alpha";
            Real den1[size(cr,1)]
              "[p] coefficients of denominator first order polynomials (a*p + 1)";
            Real den2[n_den2,2]
              "[p^2, p] coefficients of denominator second order polynomials (b*p^2 + a*p + 1)";
            constant Real pi=Modelica.Constants.pi;
          algorithm
              epsilon := sqrt(10^(A_ripple/10) - 1);
              fac := asinh(1/epsilon)/order;

              if size(cr,1) == 0 then
                 for i in 1:n_den2 loop
                    den2[i,1] :=1/(cosh(fac)^2 - cos((2*i - 1)*pi/(2*order))^2);
                    den2[i,2] :=2*den2[i, 1]*sinh(fac)*cos((2*i - 1)*pi/(2*order));
                 end for;
              else
                 den1[1] := 1/sinh(fac);
                 for i in 1:n_den2 loop
                    den2[i,1] :=1/(cosh(fac)^2 - cos(i*pi/order)^2);
                    den2[i,2] :=2*den2[i, 1]*sinh(fac)*cos(i*pi/order);
                 end for;
              end if;

              /* Transformation of filter transfer function with "new(p) = alpha*p"
       in order that the filter transfer function has an amplitude of
       -3 db at the cutoff frequency
    */
              if normalized then
                alpha :=
                  Modelica.Blocks.Continuous.Internal.Filter.Utilities.normalizationFactor(
                  den1, den2);
                alpha2 := alpha*alpha;
                for i in 1:n_den2 loop
                  den2[i, 1] := den2[i, 1]*alpha2;
                  den2[i, 2] := den2[i, 2]*alpha;
                end for;
                if size(cr,1) == 1 then
                  den1[1] := den1[1]*alpha;
                end if;
              end if;

            // Determine polynomials with highest power of s equal to one
              (cr,c0,c1) :=
                Modelica.Blocks.Continuous.Internal.Filter.Utilities.toHighestPowerOne(
                den1, den2);

            annotation (Documentation(info="<html>

</html> "));
          end ChebyshevI;
          end base;

          package coefficients "Filter coefficients"
              extends Modelica.Icons.Package;

          function lowPass
            "Return low pass filter coefficients at given cut-off frequency"

            input Real cr_in[:] "Coefficients of real poles";
            input Real c0_in[:]
              "Coefficients of s^0 term if conjugate complex pole";
            input Real c1_in[size(c0_in,1)]
              "Coefficients of s^1 term if conjugate complex pole";
            input Modelica.SIunits.Frequency f_cut "Cut-off frequency";

            output Real cr[size(cr_in,1)] "Coefficient of real pole";
            output Real c0[size(c0_in,1)]
              "Coefficients of s^0 term if conjugate complex pole";
            output Real c1[size(c0_in,1)]
              "Coefficients of s^1 term if conjugate complex pole";

          protected
            constant Real pi=Modelica.Constants.pi;
            Modelica.SIunits.AngularVelocity w_cut=2*pi*f_cut
              "Cut-off angular frequency";
            Real w_cut2=w_cut*w_cut;

          algorithm
            assert(f_cut > 0, "Cut-off frequency f_cut must be positive");

            /* Change filter coefficients according to transformation new(s) = s/w_cut
     s + cr           -> (s/w) + cr              = (s + w*cr)/w
     s^2 + c1*s + c0  -> (s/w)^2 + c1*(s/w) + c0 = (s^2 + (c1*w)*s + (c0*w^2))/w^2
  */
            cr := w_cut*cr_in;
            c1 := w_cut*c1_in;
            c0 := w_cut2*c0_in;

            annotation (Documentation(info="<html>

</html> "));
          end lowPass;

          function highPass
            "Return high pass filter coefficients at given cut-off frequency"

            input Real cr_in[:] "Coefficients of real poles";
            input Real c0_in[:]
              "Coefficients of s^0 term if conjugate complex pole";
            input Real c1_in[size(c0_in,1)]
              "Coefficients of s^1 term if conjugate complex pole";
            input Modelica.SIunits.Frequency f_cut "Cut-off frequency";

            output Real cr[size(cr_in,1)] "Coefficient of real pole";
            output Real c0[size(c0_in,1)]
              "Coefficients of s^0 term if conjugate complex pole";
            output Real c1[size(c0_in,1)]
              "Coefficients of s^1 term if conjugate complex pole";

          protected
            constant Real pi=Modelica.Constants.pi;
            Modelica.SIunits.AngularVelocity w_cut=2*pi*f_cut
              "Cut-off angular frequency";
            Real w_cut2=w_cut*w_cut;

          algorithm
            assert(f_cut > 0, "Cut-off frequency f_cut must be positive");

            /* Change filter coefficients according to transformation: new(s) = 1/s
        1/(s + cr)          -> 1/(1/s + cr)                = (1/cr)*s / (s + (1/cr))
        1/(s^2 + c1*s + c0) -> 1/((1/s)^2 + c1*(1/s) + c0) = (1/c0)*s^2 / (s^2 + (c1/c0)*s + 1/c0)

     Check whether transformed roots are also conjugate complex:
        c0 - c1^2/4 > 0  -> (1/c0) - (c1/c0)^2 / 4
                            = (c0 - c1^2/4) / c0^2 > 0
        It is therefore guaranteed that the roots remain conjugate complex

     Change filter coefficients according to transformation new(s) = s/w_cut
        s + 1/cr                -> (s/w) + 1/cr                   = (s + w/cr)/w
        s^2 + (c1/c0)*s + 1/c0  -> (s/w)^2 + (c1/c0)*(s/w) + 1/c0 = (s^2 + (w*c1/c0)*s + (w^2/c0))/w^2
  */
            for i in 1:size(cr_in,1) loop
               cr[i] := w_cut/cr_in[i];
            end for;

            for i in 1:size(c0_in,1) loop
               c0[i] := w_cut2/c0_in[i];
               c1[i] := w_cut*c1_in[i]/c0_in[i];
            end for;

            annotation (Documentation(info="<html>

</html> "));
          end highPass;

          function bandPass
            "Return band pass filter coefficients at given cut-off frequency"

            input Real cr_in[:] "Coefficients of real poles";
            input Real c0_in[:]
              "Coefficients of s^0 term if conjugate complex pole";
            input Real c1_in[size(c0_in,1)]
              "Coefficients of s^1 term if conjugate complex pole";
            input Modelica.SIunits.Frequency f_min
              "Band of band pass filter is f_min (A=-3db) .. f_max (A=-3db)";
            input Modelica.SIunits.Frequency f_max "Upper band frequency";

            output Real cr[0] "Coefficient of real pole";
            output Real c0[size(cr_in,1) + 2*size(c0_in,1)]
              "Coefficients of s^0 term if conjugate complex pole";
            output Real c1[size(cr_in,1) + 2*size(c0_in,1)]
              "Coefficients of s^1 term if conjugate complex pole";
            output Real cn "Numerator coefficient of the PT2 terms";
          protected
            constant Real pi=Modelica.Constants.pi;
            Modelica.SIunits.Frequency f0 = sqrt(f_min*f_max);
            Modelica.SIunits.AngularVelocity w_cut=2*pi*f0
              "Cut-off angular frequency";
            Modelica.SIunits.AngularVelocity w_band = (f_max - f_min) / f0;
            Real w_cut2=w_cut*w_cut;
            Real c;
            Real alpha;
            Integer j;
          algorithm
            assert(f_min > 0 and f_min < f_max, "Band frequencies f_min and f_max are wrong");

              /* The band pass filter is derived from the low pass filter by
       the transformation new(s) = (s + 1/s)/w   (w = w_band = (f_max - f_min)/sqrt(f_max*f_min) )

       1/(s + cr)         -> 1/(s/w + 1/s/w) + cr)
                             = w*s / (s^2 + cr*w*s + 1)

       1/(s^2 + c1*s + c0) -> 1/( (s+1/s)^2/w^2 + c1*(s + 1/s)/w + c0 )
                              = 1 / ( s^2 + 1/s^2 + 2)/w^2 + (s + 1/s)*c1/w + c0 )
                              = w^2*s^2 / (s^4 + 2*s^2 + 1 + (s^3 + s)*c1*w + c0*w^2*s^2)
                              = w^2*s^2 / (s^4 + c1*w*s^3 + (2+c0*w^2)*s^2 + c1*w*s + 1)

                              Assume the following description with PT2:
                              = w^2*s^2 /( (s^2 + s*(c/alpha) + 1/alpha^2)*
                                           (s^2 + s*(c*alpha) + alpha^2) )
                              = w^2*s^2 / ( s^4 + c*(alpha + 1/alpha)*s^3
                                                + (alpha^2 + 1/alpha^2 + c^2)*s^2
                                                + c*(alpha + 1/alpha)*s + 1 )

                              and therefore:
                                c*(alpha + 1/alpha) = c1*w       -> c = c1*w / (alpha + 1/alpha)
                                                                      = c1*w*alpha/(1+alpha^2)
                                alpha^2 + 1/alpha^2 + c^2 = 2+c0*w^2 -> equation to determine alpha
                                alpha^4 + 1 + c1^2*w^2*alpha^4/(1+alpha^2)^2 = (2+c0*w^2)*alpha^2
                                or z = alpha^2
                                z^2 + c^1^2*w^2*z^2/(1+z)^2 - (2+c0*w^2)*z + 1 = 0

     Check whether roots remain conjugate complex
        c0 - (c1/2)^2 > 0:    1/alpha^2 - (c/alpha)^2/4
                              = 1/alpha^2*(1 - c^2/4)    -> not possible to figure this out

     Afterwards, change filter coefficients according to transformation new(s) = s/w_cut
        w_band*s/(s^2 + c1*s + c0)  -> w_band*(s/w)/((s/w)^2 + c1*(s/w) + c0 =
                                       (w_band/w)*s/(s^2 + (c1*w)*s + (c0*w^2))/w^2) =
                                       (w_band*w)*s/(s^2 + (c1*w)*s + (c0*w^2))
    */
              for i in 1:size(cr_in,1) loop
                 c1[i] := w_cut*cr_in[i]*w_band;
                 c0[i] := w_cut2;
              end for;

              for i in 1:size(c1_in,1) loop
                alpha :=
                  Modelica.Blocks.Continuous.Internal.Filter.Utilities.bandPassAlpha(
                        c1_in[i],
                        c0_in[i],
                        w_band);
                 c       := c1_in[i]*w_band / (alpha + 1/alpha);
                 j       := size(cr_in,1) + 2*i - 1;
                 c1[j]   := w_cut*c/alpha;
                 c1[j+1] := w_cut*c*alpha;
                 c0[j]   := w_cut2/alpha^2;
                 c0[j+1] := w_cut2*alpha^2;
              end for;

              cn :=w_band*w_cut;

            annotation (Documentation(info="<html>

</html> "));
          end bandPass;

          function bandStop
            "Return band stop filter coefficients at given cut-off frequency"

            input Real cr_in[:] "Coefficients of real poles";
            input Real c0_in[:]
              "Coefficients of s^0 term if conjugate complex pole";
            input Real c1_in[size(c0_in,1)]
              "Coefficients of s^1 term if conjugate complex pole";
            input Modelica.SIunits.Frequency f_min
              "Band of band stop filter is f_min (A=-3db) .. f_max (A=-3db)";
            input Modelica.SIunits.Frequency f_max "Upper band frequency";

            output Real cr[0] "Coefficient of real pole";
            output Real c0[size(cr_in,1) + 2*size(c0_in,1)]
              "Coefficients of s^0 term if conjugate complex pole";
            output Real c1[size(cr_in,1) + 2*size(c0_in,1)]
              "Coefficients of s^1 term if conjugate complex pole";
          protected
            constant Real pi=Modelica.Constants.pi;
            Modelica.SIunits.Frequency f0 = sqrt(f_min*f_max);
            Modelica.SIunits.AngularVelocity w_cut=2*pi*f0
              "Cut-off angular frequency";
            Modelica.SIunits.AngularVelocity w_band = (f_max - f_min) / f0;
            Real w_cut2=w_cut*w_cut;
            Real c;
            Real ww;
            Real alpha;
            Integer j;
          algorithm
            assert(f_min > 0 and f_min < f_max, "Band frequencies f_min and f_max are wrong");

              /* The band pass filter is derived from the low pass filter by
       the transformation new(s) = (s + 1/s)/w   (w = w_band = (f_max - f_min)/sqrt(f_max*f_min) )

       1/(s + cr)         -> 1/(s/w + 1/s/w) + cr)
                             = w*s / (s^2 + cr*w*s + 1)

       1/(s^2 + c1*s + c0) -> 1/( (s+1/s)^2/w^2 + c1*(s + 1/s)/w + c0 )
                              = 1 / ( s^2 + 1/s^2 + 2)/w^2 + (s + 1/s)*c1/w + c0 )
                              = w^2*s^2 / (s^4 + 2*s^2 + 1 + (s^3 + s)*c1*w + c0*w^2*s^2)
                              = w^2*s^2 / (s^4 + c1*w*s^3 + (2+c0*w^2)*s^2 + c1*w*s + 1)

                              Assume the following description with PT2:
                              = w^2*s^2 /( (s^2 + s*(c/alpha) + 1/alpha^2)*
                                           (s^2 + s*(c*alpha) + alpha^2) )
                              = w^2*s^2 / ( s^4 + c*(alpha + 1/alpha)*s^3
                                                + (alpha^2 + 1/alpha^2 + c^2)*s^2
                                                + c*(alpha + 1/alpha)*s + 1 )

                              and therefore:
                                c*(alpha + 1/alpha) = c1*w       -> c = c1*w / (alpha + 1/alpha)
                                                                      = c1*w*alpha/(1+alpha^2)
                                alpha^2 + 1/alpha^2 + c^2 = 2+c0*w^2 -> equation to determine alpha
                                alpha^4 + 1 + c1^2*w^2*alpha^4/(1+alpha^2)^2 = (2+c0*w^2)*alpha^2
                                or z = alpha^2
                                z^2 + c^1^2*w^2*z^2/(1+z)^2 - (2+c0*w^2)*z + 1 = 0

       The band stop filter is derived from the low pass filter by
       the transformation new(s) = w/( (s + 1/s) )   (w = w_band = (f_max - f_min)/sqrt(f_max*f_min) )

       cr/(s + cr)         -> 1/( w/(s + 1/s) ) + cr)
                              = (s^2 + 1) / (s^2 + (w/cr)*s + 1)

       c0/(s^2 + c1*s + c0) -> c0/( w^2/(s + 1/s)^2 + c1*w/(s + 1/s) + c0 )
                               = c0*(s^2 + 1)^2 / (s^4 + c1*w*s^3/c0 + (2+w^2/b)*s^2 + c1*w*s/c0 + 1)

                               Assume the following description with PT2:
                               = c0*(s^2 + 1)^2 / ( (s^2 + s*(c/alpha) + 1/alpha^2)*
                                                    (s^2 + s*(c*alpha) + alpha^2) )
                               = c0*(s^2 + 1)^2 / (  s^4 + c*(alpha + 1/alpha)*s^3
                                                         + (alpha^2 + 1/alpha^2 + c^2)*s^2
                                                         + c*(alpha + 1/alpha)*p + 1 )

                            and therefore:
                              c*(alpha + 1/alpha) = c1*w/b         -> c = c1*w/(c0*(alpha + 1/alpha))
                              alpha^2 + 1/alpha^2 + c^2 = 2+w^2/c0 -> equation to determine alpha
                              alpha^4 + 1 + (c1*w/c0*alpha^2)^2/(1+alpha^2)^2 = (2+w^2/c0)*alpha^2
                              or z = alpha^2
                              z^2 + (c1*w/c0*z)^2/(1+z)^2 - (2+w^2/c0)*z + 1 = 0

                            same as:  ww = w/c0
                              z^2 + (c1*ww*z)^2/(1+z)^2 - (2+c0*ww)*z + 1 = 0  -> same equation as for BandPass

     Afterwards, change filter coefficients according to transformation new(s) = s/w_cut
        c0*(s^2+1)(s^2 + c1*s + c0)  -> c0*((s/w)^2 + 1) / ((s/w)^2 + c1*(s/w) + c0 =
                                        c0/w^2*(s^2 + w^2) / (s^2 + (c1*w)*s + (c0*w^2))/w^2) =
                                        (s^2 + c0*w^2) / (s^2 + (c1*w)*s + (c0*w^2))
    */
              for i in 1:size(cr_in,1) loop
                 c1[i] := w_cut*w_band/cr_in[i];
                 c0[i] := w_cut2;
              end for;

              for i in 1:size(c1_in,1) loop
                 ww      := w_band/c0_in[i];
                alpha :=
                  Modelica.Blocks.Continuous.Internal.Filter.Utilities.bandPassAlpha(
                        c1_in[i],
                        c0_in[i],
                        ww);
                 c       := c1_in[i]*ww / (alpha + 1/alpha);
                 j       := size(cr_in,1) + 2*i - 1;
                 c1[j]   := w_cut*c/alpha;
                 c1[j+1] := w_cut*c*alpha;
                 c0[j]   := w_cut2/alpha^2;
                 c0[j+1] := w_cut2*alpha^2;
              end for;

            annotation (Documentation(info="<html>

</html> "));
          end bandStop;
          end coefficients;

          package roots
          "Filter roots and gain as needed for block implementations"
              extends Modelica.Icons.Package;

          function lowPass
            "Return low pass filter roots as needed for block for given cut-off frequency"

            input Real cr_in[:] "Coefficients of real poles of base filter";
            input Real c0_in[:]
              "Coefficients of s^0 term of base filter if conjugate complex pole";
            input Real c1_in[size(c0_in,1)]
              "Coefficients of s^1 term of base filter if conjugate complex pole";
            input Modelica.SIunits.Frequency f_cut "Cut-off frequency";

            output Real r[size(cr_in,1)] "Real eigenvalues";
            output Real a[size(c0_in,1)]
              "Real parts of complex conjugate eigenvalues";
            output Real b[size(c0_in,1)]
              "Imaginary parts of complex conjugate eigenvalues";
            output Real ku[size(c0_in,1)] "Input gain";
          protected
            Real c0[size(c0_in,1)];
            Real c1[size(c0_in,1)];
            Real cr[size(cr_in,1)];
          algorithm
            // Get coefficients of low pass filter at f_cut
            (cr, c0, c1) :=coefficients.lowPass(cr_in, c0_in, c1_in, f_cut);

            // Transform coefficients in to root
            for i in 1:size(cr_in,1) loop
              r[i] :=-cr[i];
            end for;

            for i in 1:size(c0_in,1) loop
              a [i] :=-c1[i]/2;
              b [i] :=sqrt(c0[i] - a[i]*a[i]);
              ku[i] :=c0[i]/b[i];
            end for;

            annotation (Documentation(info="<html>

<p>
The goal is to implement the filter in the following form:
</p>

<pre>
  // real pole:
   der(x) = r*x - r*u
       y  = x

  // complex conjugate poles:
  der(x1) = a*x1 - b*x2 + ku*u;
  der(x2) = b*x1 + a*x2;
       y  = x2;

            ku = (a^2 + b^2)/b
</pre>
<p>
This representation has the following transfer function:
</p>
<pre>
// real pole:
    s*y = r*y - r*u
  or
    (s-r)*y = -r*u
  or
    y = -r/(s-r)*u

  comparing coefficients with
    y = cr/(s + cr)*u  ->  r = -cr      // r is the real eigenvalue

// complex conjugate poles
    s*x2 =  a*x2 + b*x1
    s*x1 = -b*x2 + a*x1 + ku*u
  or
    (s-a)*x2               = b*x1  ->  x2 = b/(s-a)*x1
    (s + b^2/(s-a) - a)*x1 = ku*u  ->  (s(s-a) + b^2 - a*(s-a))*x1  = ku*(s-a)*u
                                   ->  (s^2 - 2*a*s + a^2 + b^2)*x1 = ku*(s-a)*u
  or
    x1 = ku*(s-a)/(s^2 - 2*a*s + a^2 + b^2)*u
    x2 = b/(s-a)*ku*(s-a)/(s^2 - 2*a*s + a^2 + b^2)*u
       = b*ku/(s^2 - 2*a*s + a^2 + b^2)*u
    y  = x2

  comparing coefficients with
    y = c0/(s^2 + c1*s + c0)*u  ->  a  = -c1/2
                                    b  = sqrt(c0 - a^2)
                                    ku = c0/b
                                       = (a^2 + b^2)/b

  comparing with eigenvalue representation:
    (s - (a+jb))*(s - (a-jb)) = s^2 -2*a*s + a^2 + b^2
  shows that:
    a: real part of eigenvalue
    b: imaginary part of eigenvalue

  time -> infinity:
    y(s=0) = x2(s=0) = 1
             x1(s=0) = -ku*a/(a^2 + b^2)*u
                     = -(a/b)*u
</pre>

</html> "));
          end lowPass;

          function highPass
            "Return high pass filter roots as needed for block for given cut-off frequency"

            input Real cr_in[:] "Coefficients of real poles of base filter";
            input Real c0_in[:]
              "Coefficients of s^0 term of base filter if conjugate complex pole";
            input Real c1_in[size(c0_in,1)]
              "Coefficients of s^1 term of base filter if conjugate complex pole";
            input Modelica.SIunits.Frequency f_cut "Cut-off frequency";

            output Real r[size(cr_in,1)] "Real eigenvalues";
            output Real a[size(c0_in,1)]
              "Real parts of complex conjugate eigenvalues";
            output Real b[size(c0_in,1)]
              "Imaginary parts of complex conjugate eigenvalues";
            output Real ku[size(c0_in,1)] "Gains of input terms";
            output Real k1[size(c0_in,1)] "Gains of y = k1*x1 + k2*x + u";
            output Real k2[size(c0_in,1)] "Gains of y = k1*x1 + k2*x + u";
          protected
            Real c0[size(c0_in,1)];
            Real c1[size(c0_in,1)];
            Real cr[size(cr_in,1)];
            Real ba2;
          algorithm
            // Get coefficients of high pass filter at f_cut
            (cr, c0, c1) :=coefficients.highPass(cr_in, c0_in, c1_in, f_cut);

            // Transform coefficients in to roots
            for i in 1:size(cr_in,1) loop
              r[i] :=-cr[i];
            end for;

            for i in 1:size(c0_in,1) loop
              a[i]  := -c1[i]/2;
              b[i]  := sqrt(c0[i] - a[i]*a[i]);
              ku[i] := c0[i]/b[i];
              k1[i] := 2*a[i]/ku[i];
              ba2   := (b[i]/a[i])^2;
              k2[i] := (1-ba2)/(1+ba2);
            end for;

            annotation (Documentation(info="<html>

<p>
The goal is to implement the filter in the following form:
</p>

<pre>
  // real pole:
   der(x) = r*x - r*u
       y  = -x + u

  // complex conjugate poles:
  der(x1) = a*x1 - b*x2 + ku*u;
  der(x2) = b*x1 + a*x2;
       y  = k1*x1 + k2*x2 + u;

            ku = (a^2 + b^2)/b
            k1 = 2*a/ku
            k2 = (a^2 - b^2) / (b*ku)
               = (a^2 - b^2) / (a^2 + b^2)
               = (1 - (b/a)^2) / (1 + (b/a)^2)

</pre>
<p>
This representation has the following transfer function:
</p>
<pre>
// real pole:
    s*x = r*x - r*u
  or
    (s-r)*x = -r*u   -> x = -r/(s-r)*u
  or
    y = r/(s-r)*u + (s-r)/(s-r)*u
      = (r+s-r)/(s-r)*u
      = s/(s-r)*u

  comparing coefficients with
    y = s/(s + cr)*u  ->  r = -cr      // r is the real eigenvalue

// complex conjugate poles
    s*x2 =  a*x2 + b*x1
    s*x1 = -b*x2 + a*x1 + ku*u
  or
    (s-a)*x2               = b*x1  ->  x2 = b/(s-a)*x1
    (s + b^2/(s-a) - a)*x1 = ku*u  ->  (s(s-a) + b^2 - a*(s-a))*x1  = ku*(s-a)*u
                                   ->  (s^2 - 2*a*s + a^2 + b^2)*x1 = ku*(s-a)*u
  or
    x1 = ku*(s-a)/(s^2 - 2*a*s + a^2 + b^2)*u
    x2 = b/(s-a)*ku*(s-a)/(s^2 - 2*a*s + a^2 + b^2)*u
       = b*ku/(s^2 - 2*a*s + a^2 + b^2)*u
    y  = k1*x1 + k2*x2 + u
       = (k1*ku*(s-a) + k2*b*ku +  s^2 - 2*a*s + a^2 + b^2) /
         (s^2 - 2*a*s + a^2 + b^2)*u
       = (s^2 + (k1*ku - 2*a)*s + k2*b*ku - k1*ku*a + a^2 + b^2) /
         (s^2 - 2*a*s + a^2 + b^2)*u
       = (s^2 + (2*a-2*a)*s + a^2 - b^2 - 2*a^2 + a^2 + b^2) /
         (s^2 - 2*a*s + a^2 + b^2)*u
       = s^2 / (s^2 - 2*a*s + a^2 + b^2)*u

  comparing coefficients with
    y = s^2/(s^2 + c1*s + c0)*u  ->  a = -c1/2
                                     b = sqrt(c0 - a^2)

  comparing with eigenvalue representation:
    (s - (a+jb))*(s - (a-jb)) = s^2 -2*a*s + a^2 + b^2
  shows that:
    a: real part of eigenvalue
    b: imaginary part of eigenvalue
</pre>

</html> "));
          end highPass;

          function bandPass
            "Return band pass filter roots as needed for block for given cut-off frequency"
            input Real cr_in[:] "Coefficients of real poles of base filter";
            input Real c0_in[:]
              "Coefficients of s^0 term of base filter if conjugate complex pole";
            input Real c1_in[size(c0_in,1)]
              "Coefficients of s^1 term of base filter if conjugate complex pole";
            input Modelica.SIunits.Frequency f_min
              "Band of band pass filter is f_min (A=-3db) .. f_max (A=-3db)";
            input Modelica.SIunits.Frequency f_max "Upper band frequency";

            output Real a[size(cr_in,1) + 2*size(c0_in,1)]
              "Real parts of complex conjugate eigenvalues";
            output Real b[size(cr_in,1) + 2*size(c0_in,1)]
              "Imaginary parts of complex conjugate eigenvalues";
            output Real ku[size(cr_in,1) + 2*size(c0_in,1)]
              "Gains of input terms";
            output Real k1[size(cr_in,1) + 2*size(c0_in,1)]
              "Gains of y = k1*x1 + k2*x";
            output Real k2[size(cr_in,1) + 2*size(c0_in,1)]
              "Gains of y = k1*x1 + k2*x";
          protected
            Real cr[0];
            Real c0[size(a,1)];
            Real c1[size(a,1)];
            Real cn;
            Real bb;
          algorithm
            // Get coefficients of band pass filter at f_cut
            (cr, c0, c1, cn) :=coefficients.bandPass(cr_in, c0_in, c1_in, f_min, f_max);

            // Transform coefficients in to roots
            for i in 1:size(a,1) loop
              a[i]  := -c1[i]/2;
              bb    := c0[i] - a[i]*a[i];
              assert(bb >= 0, "\nNot possible to use band pass filter, since transformation results in\n"+
                              "system that does not have conjugate complex poles.\n" +
                              "Try to use another analog filter for the band pass.\n");
              b[i]  := sqrt(bb);
              ku[i] := c0[i]/b[i];
              k1[i] := cn/ku[i];
              k2[i] := cn*a[i]/(b[i]*ku[i]);
            end for;

            annotation (Documentation(info="<html>

<p>
The goal is to implement the filter in the following form:
</p>

<pre>
  // complex conjugate poles:
  der(x1) = a*x1 - b*x2 + ku*u;
  der(x2) = b*x1 + a*x2;
       y  = k1*x1 + k2*x2;

            ku = (a^2 + b^2)/b
            k1 = cn/ku
            k2 = cn*a/(b*ku)
</pre>
<p>
This representation has the following transfer function:
</p>
<pre>
// complex conjugate poles
    s*x2 =  a*x2 + b*x1
    s*x1 = -b*x2 + a*x1 + ku*u
  or
    (s-a)*x2               = b*x1  ->  x2 = b/(s-a)*x1
    (s + b^2/(s-a) - a)*x1 = ku*u  ->  (s(s-a) + b^2 - a*(s-a))*x1  = ku*(s-a)*u
                                   ->  (s^2 - 2*a*s + a^2 + b^2)*x1 = ku*(s-a)*u
  or
    x1 = ku*(s-a)/(s^2 - 2*a*s + a^2 + b^2)*u
    x2 = b/(s-a)*ku*(s-a)/(s^2 - 2*a*s + a^2 + b^2)*u
       = b*ku/(s^2 - 2*a*s + a^2 + b^2)*u
    y  = k1*x1 + k2*x2
       = (k1*ku*(s-a) + k2*b*ku) / (s^2 - 2*a*s + a^2 + b^2)*u
       = (k1*ku*s + k2*b*ku - k1*ku*a) / (s^2 - 2*a*s + a^2 + b^2)*u
       = (cn*s + cn*a - cn*a) / (s^2 - 2*a*s + a^2 + b^2)*u
       = cn*s / (s^2 - 2*a*s + a^2 + b^2)*u

  comparing coefficients with
    y = cn*s / (s^2 + c1*s + c0)*u  ->  a = -c1/2
                                        b = sqrt(c0 - a^2)

  comparing with eigenvalue representation:
    (s - (a+jb))*(s - (a-jb)) = s^2 -2*a*s + a^2 + b^2
  shows that:
    a: real part of eigenvalue
    b: imaginary part of eigenvalue
</pre>

</html> "));
          end bandPass;

          function bandStop
            "Return band stop filter roots as needed for block for given cut-off frequency"

            input Real cr_in[:] "Coefficients of real poles of base filter";
            input Real c0_in[:]
              "Coefficients of s^0 term of base filter if conjugate complex pole";
            input Real c1_in[size(c0_in,1)]
              "Coefficients of s^1 term of base filter if conjugate complex pole";
            input Modelica.SIunits.Frequency f_min
              "Band of band stop filter is f_min (A=-3db) .. f_max (A=-3db)";
            input Modelica.SIunits.Frequency f_max "Upper band frequency";

            output Real a[size(cr_in,1) + 2*size(c0_in,1)]
              "Real parts of complex conjugate eigenvalues";
            output Real b[size(cr_in,1) + 2*size(c0_in,1)]
              "Imaginary parts of complex conjugate eigenvalues";
            output Real ku[size(cr_in,1) + 2*size(c0_in,1)]
              "Gains of input terms";
            output Real k1[size(cr_in,1) + 2*size(c0_in,1)]
              "Gains of y = k1*x1 + k2*x";
            output Real k2[size(cr_in,1) + 2*size(c0_in,1)]
              "Gains of y = k1*x1 + k2*x";
          protected
            Real cr[0];
            Real c0[size(a,1)];
            Real c1[size(a,1)];
            Real cn;
            Real bb;
          algorithm
            // Get coefficients of band stop filter at f_cut
            (cr, c0, c1) :=coefficients.bandStop(cr_in, c0_in, c1_in, f_min, f_max);

            // Transform coefficients in to roots
            for i in 1:size(a,1) loop
              a[i]  := -c1[i]/2;
              bb    := c0[i] - a[i]*a[i];
              assert(bb >= 0, "\nNot possible to use band stop filter, since transformation results in\n"+
                              "system that does not have conjugate complex poles.\n" +
                              "Try to use another analog filter for the band stop filter.\n");
              b[i]  := sqrt(bb);
              ku[i] := c0[i]/b[i];
              k1[i] := 2*a[i]/ku[i];
              k2[i] := (c0[i] + a[i]^2 - b[i]^2)/(b[i]*ku[i]);
            end for;

            annotation (Documentation(info="<html>

<p>
The goal is to implement the filter in the following form:
</p>

<pre>
  // complex conjugate poles:
  der(x1) = a*x1 - b*x2 + ku*u;
  der(x2) = b*x1 + a*x2;
       y  = k1*x1 + k2*x2 + u;

            ku = (a^2 + b^2)/b
            k1 = 2*a/ku
            k2 = (c0 + a^2 - b^2)/(b*ku)
</pre>
<p>
This representation has the following transfer function:
</p>
<pre>
// complex conjugate poles
    s*x2 =  a*x2 + b*x1
    s*x1 = -b*x2 + a*x1 + ku*u
  or
    (s-a)*x2               = b*x1  ->  x2 = b/(s-a)*x1
    (s + b^2/(s-a) - a)*x1 = ku*u  ->  (s(s-a) + b^2 - a*(s-a))*x1  = ku*(s-a)*u
                                   ->  (s^2 - 2*a*s + a^2 + b^2)*x1 = ku*(s-a)*u
  or
    x1 = ku*(s-a)/(s^2 - 2*a*s + a^2 + b^2)*u
    x2 = b/(s-a)*ku*(s-a)/(s^2 - 2*a*s + a^2 + b^2)*u
       = b*ku/(s^2 - 2*a*s + a^2 + b^2)*u
    y  = k1*x1 + k2*x2 + u
       = (k1*ku*(s-a) + k2*b*ku + s^2 - 2*a*s + a^2 + b^2) / (s^2 - 2*a*s + a^2 + b^2)*u
       = (s^2 + (k1*ku-2*a)*s + k2*b*ku - k1*ku*a + a^2 + b^2) / (s^2 - 2*a*s + a^2 + b^2)*u
       = (s^2 + c0 + a^2 - b^2 - 2*a^2 + a^2 + b^2) / (s^2 - 2*a*s + a^2 + b^2)*u
       = (s^2 + c0) / (s^2 - 2*a*s + a^2 + b^2)*u

  comparing coefficients with
    y = (s^2 + c0) / (s^2 + c1*s + c0)*u  ->  a = -c1/2
                                              b = sqrt(c0 - a^2)

  comparing with eigenvalue representation:
    (s - (a+jb))*(s - (a-jb)) = s^2 -2*a*s + a^2 + b^2
  shows that:
    a: real part of eigenvalue
    b: imaginary part of eigenvalue
</pre>

</html> "));
          end bandStop;
          end roots;

          package Utilities "Utility functions for filter computations"
              extends Modelica.Icons.Package;

            function BesselBaseCoefficients
            "Return coefficients of normalized low pass Bessel filter (= gain at cut-off frequency 1 rad/s is decreased 3dB"

              import Modelica.Utilities.Streams;
              input Integer order "Order of filter in the range 1..41";
              output Real c1[mod(order, 2)]
              "[p] coefficients of Bessel denominator polynomials (a*p + 1)";
              output Real c2[integer(order/2),2]
              "[p^2, p] coefficients of Bessel denominator polynomials (b2*p^2 + b1*p + 1)";
              output Real alpha "Normalization factor";
            algorithm
              if order == 1 then
                alpha := 1.002377293007601;
                c1[1] := 0.9976283451109835;
              elseif order == 2 then
                alpha := 0.7356641785819585;
                c2[1, 1] := 0.6159132201783791;
                c2[1, 2] := 1.359315879600889;
              elseif order == 3 then
                alpha := 0.5704770156982642;
                c1[1] := 0.7548574865985343;
                c2[1, 1] := 0.4756958028827457;
                c2[1, 2] := 0.9980615136104388;
              elseif order == 4 then
                alpha := 0.4737978580281427;
                c2[1, 1] := 0.4873729247240677;
                c2[1, 2] := 1.337564170455762;
                c2[2, 1] := 0.3877724315741958;
                c2[2, 2] := 0.7730405590839861;
              elseif order == 5 then
                alpha := 0.4126226974763408;
                c1[1] := 0.6645723262620757;
                c2[1, 1] := 0.4115231900614016;
                c2[1, 2] := 1.138349926728708;
                c2[2, 1] := 0.3234938702877912;
                c2[2, 2] := 0.6205992985771313;
              elseif order == 6 then
                alpha := 0.3705098000736233;
                c2[1, 1] := 0.3874508649098960;
                c2[1, 2] := 1.219740879520741;
                c2[2, 1] := 0.3493298843155746;
                c2[2, 2] := 0.9670265529381365;
                c2[3, 1] := 0.2747419229514599;
                c2[3, 2] := 0.5122165075105700;
              elseif order == 7 then
                alpha := 0.3393452623586350;
                c1[1] := 0.5927147125821412;
                c2[1, 1] := 0.3383379423919174;
                c2[1, 2] := 1.092630816438030;
                c2[2, 1] := 0.3001025788696046;
                c2[2, 2] := 0.8289928256598656;
                c2[3, 1] := 0.2372867471539579;
                c2[3, 2] := 0.4325128641920154;
              elseif order == 8 then
                alpha := 0.3150267393795002;
                c2[1, 1] := 0.3151115975207653;
                c2[1, 2] := 1.109403015460190;
                c2[2, 1] := 0.2969344839572762;
                c2[2, 2] := 0.9737455812222699;
                c2[3, 1] := 0.2612545921889538;
                c2[3, 2] := 0.7190394712068573;
                c2[4, 1] := 0.2080523342974281;
                c2[4, 2] := 0.3721456473047434;
              elseif order == 9 then
                alpha := 0.2953310177184124;
                c1[1] := 0.5377196679501422;
                c2[1, 1] := 0.2824689124281034;
                c2[1, 2] := 1.022646191567475;
                c2[2, 1] := 0.2626824161383468;
                c2[2, 2] := 0.8695626454762596;
                c2[3, 1] := 0.2302781917677917;
                c2[3, 2] := 0.6309047553448520;
                c2[4, 1] := 0.1847991729757028;
                c2[4, 2] := 0.3251978031287202;
              elseif order == 10 then
                alpha := 0.2789426890619463;
                c2[1, 1] := 0.2640769908255582;
                c2[1, 2] := 1.019788132875305;
                c2[2, 1] := 0.2540802639216947;
                c2[2, 2] := 0.9377020417760623;
                c2[3, 1] := 0.2343577229427963;
                c2[3, 2] := 0.7802229808216112;
                c2[4, 1] := 0.2052193139338624;
                c2[4, 2] := 0.5594176813008133;
                c2[5, 1] := 0.1659546953748916;
                c2[5, 2] := 0.2878349616233292;
              elseif order == 11 then
                alpha := 0.2650227766037203;
                c1[1] := 0.4950265498954191;
                c2[1, 1] := 0.2411858478546218;
                c2[1, 2] := 0.9567800996387417;
                c2[2, 1] := 0.2296849355380925;
                c2[2, 2] := 0.8592523717113126;
                c2[3, 1] := 0.2107851705677406;
                c2[3, 2] := 0.7040216048898129;
                c2[4, 1] := 0.1846461385164021;
                c2[4, 2] := 0.5006729207276717;
                c2[5, 1] := 0.1504217970817433;
                c2[5, 2] := 0.2575070491320295;
              elseif order == 12 then
                alpha := 0.2530051198547209;
                c2[1, 1] := 0.2268294941204543;
                c2[1, 2] := 0.9473116570034053;
                c2[2, 1] := 0.2207657387793729;
                c2[2, 2] := 0.8933728946287606;
                c2[3, 1] := 0.2087600700376653;
                c2[3, 2] := 0.7886236252756229;
                c2[4, 1] := 0.1909959101492760;
                c2[4, 2] := 0.6389263649257017;
                c2[5, 1] := 0.1675208146048472;
                c2[5, 2] := 0.4517847275162215;
                c2[6, 1] := 0.1374257286372761;
                c2[6, 2] := 0.2324699157474680;
              elseif order == 13 then
                alpha := 0.2424910397561007;
                c1[1] := 0.4608848369928040;
                c2[1, 1] := 0.2099813050274780;
                c2[1, 2] := 0.8992478823790660;
                c2[2, 1] := 0.2027250423101359;
                c2[2, 2] := 0.8328117484224146;
                c2[3, 1] := 0.1907635894058731;
                c2[3, 2] := 0.7257379204691213;
                c2[4, 1] := 0.1742280397887686;
                c2[4, 2] := 0.5830640944868014;
                c2[5, 1] := 0.1530858190490478;
                c2[5, 2] := 0.4106192089751885;
                c2[6, 1] := 0.1264090712880446;
                c2[6, 2] := 0.2114980230156001;
              elseif order == 14 then
                alpha := 0.2331902368695848;
                c2[1, 1] := 0.1986162311411235;
                c2[1, 2] := 0.8876961808055535;
                c2[2, 1] := 0.1946683341271615;
                c2[2, 2] := 0.8500754229171967;
                c2[3, 1] := 0.1868331332895056;
                c2[3, 2] := 0.7764629313723603;
                c2[4, 1] := 0.1752118757862992;
                c2[4, 2] := 0.6699720402924552;
                c2[5, 1] := 0.1598906457908402;
                c2[5, 2] := 0.5348446712848934;
                c2[6, 1] := 0.1407810153019944;
                c2[6, 2] := 0.3755841316563539;
                c2[7, 1] := 0.1169627966707339;
                c2[7, 2] := 0.1937088226304455;
              elseif order == 15 then
                alpha := 0.2248854870552422;
                c1[1] := 0.4328492272335646;
                c2[1, 1] := 0.1857292591004588;
                c2[1, 2] := 0.8496337061962563;
                c2[2, 1] := 0.1808644178280136;
                c2[2, 2] := 0.8020517898136011;
                c2[3, 1] := 0.1728264404199081;
                c2[3, 2] := 0.7247449729331105;
                c2[4, 1] := 0.1616970125901954;
                c2[4, 2] := 0.6205369315943097;
                c2[5, 1] := 0.1475257264578426;
                c2[5, 2] := 0.4929612162355906;
                c2[6, 1] := 0.1301861023357119;
                c2[6, 2] := 0.3454770708040735;
                c2[7, 1] := 0.1087810777120188;
                c2[7, 2] := 0.1784526655428406;
              elseif order == 16 then
                alpha := 0.2174105053474761;
                c2[1, 1] := 0.1765637967473151;
                c2[1, 2] := 0.8377453068635511;
                c2[2, 1] := 0.1738525357503125;
                c2[2, 2] := 0.8102988957433199;
                c2[3, 1] := 0.1684627004613343;
                c2[3, 2] := 0.7563265923413258;
                c2[4, 1] := 0.1604519074815815;
                c2[4, 2] := 0.6776082294687619;
                c2[5, 1] := 0.1498828607802206;
                c2[5, 2] := 0.5766417034027680;
                c2[6, 1] := 0.1367764717792823;
                c2[6, 2] := 0.4563528264410489;
                c2[7, 1] := 0.1209810465419295;
                c2[7, 2] := 0.3193782657322374;
                c2[8, 1] := 0.1016312648007554;
                c2[8, 2] := 0.1652419227369036;
              elseif order == 17 then
                alpha := 0.2106355148193306;
                c1[1] := 0.4093223608497299;
                c2[1, 1] := 0.1664014345826274;
                c2[1, 2] := 0.8067173752345952;
                c2[2, 1] := 0.1629839591538256;
                c2[2, 2] := 0.7712924931447541;
                c2[3, 1] := 0.1573277802512491;
                c2[3, 2] := 0.7134213666303411;
                c2[4, 1] := 0.1494828185148637;
                c2[4, 2] := 0.6347841731714884;
                c2[5, 1] := 0.1394948812681826;
                c2[5, 2] := 0.5375594414619047;
                c2[6, 1] := 0.1273627583380806;
                c2[6, 2] := 0.4241608926375478;
                c2[7, 1] := 0.1129187258461290;
                c2[7, 2] := 0.2965752009703245;
                c2[8, 1] := 0.9533357359908857e-1;
                c2[8, 2] := 0.1537041700889585;
              elseif order == 18 then
                alpha := 0.2044575288651841;
                c2[1, 1] := 0.1588768571976356;
                c2[1, 2] := 0.7951914263212913;
                c2[2, 1] := 0.1569357024981854;
                c2[2, 2] := 0.7744529690772538;
                c2[3, 1] := 0.1530722206358810;
                c2[3, 2] := 0.7335304425992080;
                c2[4, 1] := 0.1473206710524167;
                c2[4, 2] := 0.6735038935387268;
                c2[5, 1] := 0.1397225420331520;
                c2[5, 2] := 0.5959151542621590;
                c2[6, 1] := 0.1303092459809849;
                c2[6, 2] := 0.5026483447894845;
                c2[7, 1] := 0.1190627367060072;
                c2[7, 2] := 0.3956893824587150;
                c2[8, 1] := 0.1058058030798994;
                c2[8, 2] := 0.2765091830730650;
                c2[9, 1] := 0.8974708108800873e-1;
                c2[9, 2] := 0.1435505288284833;
              elseif order == 19 then
                alpha := 0.1987936248083529;
                c1[1] := 0.3892259966869526;
                c2[1, 1] := 0.1506640012172225;
                c2[1, 2] := 0.7693121733774260;
                c2[2, 1] := 0.1481728062796673;
                c2[2, 2] := 0.7421133586741549;
                c2[3, 1] := 0.1440444668388838;
                c2[3, 2] := 0.6975075386214800;
                c2[4, 1] := 0.1383101628540374;
                c2[4, 2] := 0.6365464378910025;
                c2[5, 1] := 0.1310032283190998;
                c2[5, 2] := 0.5606211948462122;
                c2[6, 1] := 0.1221431166405330;
                c2[6, 2] := 0.4713530424221445;
                c2[7, 1] := 0.1116991161103884;
                c2[7, 2] := 0.3703717538617073;
                c2[8, 1] := 0.9948917351196349e-1;
                c2[8, 2] := 0.2587371155559744;
                c2[9, 1] := 0.8475989238107367e-1;
                c2[9, 2] := 0.1345537894555993;
              elseif order == 20 then
                alpha := 0.1935761760416219;
                c2[1, 1] := 0.1443871348337404;
                c2[1, 2] := 0.7584165598446141;
                c2[2, 1] := 0.1429501891353184;
                c2[2, 2] := 0.7423000962318863;
                c2[3, 1] := 0.1400877384920004;
                c2[3, 2] := 0.7104185332215555;
                c2[4, 1] := 0.1358210369491446;
                c2[4, 2] := 0.6634599783272630;
                c2[5, 1] := 0.1301773703034290;
                c2[5, 2] := 0.6024175491895959;
                c2[6, 1] := 0.1231826501439148;
                c2[6, 2] := 0.5285332736326852;
                c2[7, 1] := 0.1148465498575254;
                c2[7, 2] := 0.4431977385498628;
                c2[8, 1] := 0.1051289462376788;
                c2[8, 2] := 0.3477444062821162;
                c2[9, 1] := 0.9384622797485121e-1;
                c2[9, 2] := 0.2429038300327729;
                c2[10, 1] := 0.8028211612831444e-1;
                c2[10, 2] := 0.1265329974009533;
              elseif order == 21 then
                alpha := 0.1887494014766075;
                c1[1] := 0.3718070668941645;
                c2[1, 1] := 0.1376151928386445;
                c2[1, 2] := 0.7364290859445481;
                c2[2, 1] := 0.1357438914390695;
                c2[2, 2] := 0.7150167318935022;
                c2[3, 1] := 0.1326398453462415;
                c2[3, 2] := 0.6798001808470175;
                c2[4, 1] := 0.1283231214897678;
                c2[4, 2] := 0.6314663440439816;
                c2[5, 1] := 0.1228169159777534;
                c2[5, 2] := 0.5709353626166905;
                c2[6, 1] := 0.1161406100773184;
                c2[6, 2] := 0.4993087153571335;
                c2[7, 1] := 0.1082959649233524;
                c2[7, 2] := 0.4177766148584385;
                c2[8, 1] := 0.9923596957485723e-1;
                c2[8, 2] := 0.3274257287232124;
                c2[9, 1] := 0.8877776108724853e-1;
                c2[9, 2] := 0.2287218166767916;
                c2[10, 1] := 0.7624076527736326e-1;
                c2[10, 2] := 0.1193423971506988;
              elseif order == 22 then
                alpha := 0.1842668221199706;
                c2[1, 1] := 0.1323053462701543;
                c2[1, 2] := 0.7262446126765204;
                c2[2, 1] := 0.1312121721769772;
                c2[2, 2] := 0.7134286088450949;
                c2[3, 1] := 0.1290330911166814;
                c2[3, 2] := 0.6880287870435514;
                c2[4, 1] := 0.1257817990372067;
                c2[4, 2] := 0.6505015800059301;
                c2[5, 1] := 0.1214765261983008;
                c2[5, 2] := 0.6015107185211451;
                c2[6, 1] := 0.1161365140967959;
                c2[6, 2] := 0.5418983553698413;
                c2[7, 1] := 0.1097755171533100;
                c2[7, 2] := 0.4726370779831614;
                c2[8, 1] := 0.1023889478519956;
                c2[8, 2] := 0.3947439506537486;
                c2[9, 1] := 0.9392485861253800e-1;
                c2[9, 2] := 0.3090996703083202;
                c2[10, 1] := 0.8420273775456455e-1;
                c2[10, 2] := 0.2159561978556017;
                c2[11, 1] := 0.7257600023938262e-1;
                c2[11, 2] := 0.1128633732721116;
              elseif order == 23 then
                alpha := 0.1800893554453722;
                c1[1] := 0.3565232673929280;
                c2[1, 1] := 0.1266275171652706;
                c2[1, 2] := 0.7072778066734162;
                c2[2, 1] := 0.1251865227648538;
                c2[2, 2] := 0.6900676345785905;
                c2[3, 1] := 0.1227944815236645;
                c2[3, 2] := 0.6617011100576023;
                c2[4, 1] := 0.1194647013077667;
                c2[4, 2] := 0.6226432315773119;
                c2[5, 1] := 0.1152132989252356;
                c2[5, 2] := 0.5735222810625359;
                c2[6, 1] := 0.1100558598478487;
                c2[6, 2] := 0.5151027978024605;
                c2[7, 1] := 0.1040013558214886;
                c2[7, 2] := 0.4482410942032739;
                c2[8, 1] := 0.9704014176512626e-1;
                c2[8, 2] := 0.3738049984631116;
                c2[9, 1] := 0.8911683905758054e-1;
                c2[9, 2] := 0.2925028692588410;
                c2[10, 1] := 0.8005438265072295e-1;
                c2[10, 2] := 0.2044134600278901;
                c2[11, 1] := 0.6923832296800832e-1;
                c2[11, 2] := 0.1069984887283394;
              elseif order == 24 then
                alpha := 0.1761838665838427;
                c2[1, 1] := 0.1220804912720132;
                c2[1, 2] := 0.6978026874156063;
                c2[2, 1] := 0.1212296762358897;
                c2[2, 2] := 0.6874139794926736;
                c2[3, 1] := 0.1195328372961027;
                c2[3, 2] := 0.6667954259551859;
                c2[4, 1] := 0.1169990987333593;
                c2[4, 2] := 0.6362602049901176;
                c2[5, 1] := 0.1136409040480130;
                c2[5, 2] := 0.5962662188435553;
                c2[6, 1] := 0.1094722001757955;
                c2[6, 2] := 0.5474001634109253;
                c2[7, 1] := 0.1045052832229087;
                c2[7, 2] := 0.4903523180249535;
                c2[8, 1] := 0.9874509806025907e-1;
                c2[8, 2] := 0.4258751523524645;
                c2[9, 1] := 0.9217799943472177e-1;
                c2[9, 2] := 0.3547079765396403;
                c2[10, 1] := 0.8474633796250476e-1;
                c2[10, 2] := 0.2774145482392767;
                c2[11, 1] := 0.7627722381240495e-1;
                c2[11, 2] := 0.1939329108084139;
                c2[12, 1] := 0.6618645465422745e-1;
                c2[12, 2] := 0.1016670147947242;
              elseif order == 25 then
                alpha := 0.1725220521949266;
                c1[1] := 0.3429735385896000;
                c2[1, 1] := 0.1172525033170618;
                c2[1, 2] := 0.6812327932576614;
                c2[2, 1] := 0.1161194585333535;
                c2[2, 2] := 0.6671566071153211;
                c2[3, 1] := 0.1142375145794466;
                c2[3, 2] := 0.6439167855053158;
                c2[4, 1] := 0.1116157454252308;
                c2[4, 2] := 0.6118378416180135;
                c2[5, 1] := 0.1082654809459177;
                c2[5, 2] := 0.5713609763370088;
                c2[6, 1] := 0.1041985674230918;
                c2[6, 2] := 0.5230289949762722;
                c2[7, 1] := 0.9942439308123559e-1;
                c2[7, 2] := 0.4674627926041906;
                c2[8, 1] := 0.9394453593830893e-1;
                c2[8, 2] := 0.4053226688298811;
                c2[9, 1] := 0.8774221237222533e-1;
                c2[9, 2] := 0.3372372276379071;
                c2[10, 1] := 0.8075839512216483e-1;
                c2[10, 2] := 0.2636485508005428;
                c2[11, 1] := 0.7282483286646764e-1;
                c2[11, 2] := 0.1843801345273085;
                c2[12, 1] := 0.6338571166846652e-1;
                c2[12, 2] := 0.9680153764737715e-1;
              elseif order == 26 then
                alpha := 0.1690795702796737;
                c2[1, 1] := 0.1133168695796030;
                c2[1, 2] := 0.6724297955493932;
                c2[2, 1] := 0.1126417845769961;
                c2[2, 2] := 0.6638709519790540;
                c2[3, 1] := 0.1112948749545606;
                c2[3, 2] := 0.6468652038763624;
                c2[4, 1] := 0.1092823986944244;
                c2[4, 2] := 0.6216337070799265;
                c2[5, 1] := 0.1066130386697976;
                c2[5, 2] := 0.5885011413992190;
                c2[6, 1] := 0.1032969057045413;
                c2[6, 2] := 0.5478864278297548;
                c2[7, 1] := 0.9934388184210715e-1;
                c2[7, 2] := 0.5002885306054287;
                c2[8, 1] := 0.9476081523436283e-1;
                c2[8, 2] := 0.4462644847551711;
                c2[9, 1] := 0.8954648464575577e-1;
                c2[9, 2] := 0.3863930785049522;
                c2[10, 1] := 0.8368166847159917e-1;
                c2[10, 2] := 0.3212074592527143;
                c2[11, 1] := 0.7710664731701103e-1;
                c2[11, 2] := 0.2510470347119383;
                c2[12, 1] := 0.6965807988411425e-1;
                c2[12, 2] := 0.1756419294111342;
                c2[13, 1] := 0.6080674930548766e-1;
                c2[13, 2] := 0.9234535279274277e-1;
              elseif order == 27 then
                alpha := 0.1658353543067995;
                c1[1] := 0.3308543720638957;
                c2[1, 1] := 0.1091618578712746;
                c2[1, 2] := 0.6577977071169651;
                c2[2, 1] := 0.1082549561495043;
                c2[2, 2] := 0.6461121666520275;
                c2[3, 1] := 0.1067479247890451;
                c2[3, 2] := 0.6267937760991321;
                c2[4, 1] := 0.1046471079537577;
                c2[4, 2] := 0.6000750116745808;
                c2[5, 1] := 0.1019605976654259;
                c2[5, 2] := 0.5662734183049320;
                c2[6, 1] := 0.9869726954433709e-1;
                c2[6, 2] := 0.5257827234948534;
                c2[7, 1] := 0.9486520934132483e-1;
                c2[7, 2] := 0.4790595019077763;
                c2[8, 1] := 0.9046906518775348e-1;
                c2[8, 2] := 0.4266025862147336;
                c2[9, 1] := 0.8550529998276152e-1;
                c2[9, 2] := 0.3689188223512328;
                c2[10, 1] := 0.7995282239306020e-1;
                c2[10, 2] := 0.3064589322702932;
                c2[11, 1] := 0.7375174596252882e-1;
                c2[11, 2] := 0.2394754504667310;
                c2[12, 1] := 0.6674377263329041e-1;
                c2[12, 2] := 0.1676223546666024;
                c2[13, 1] := 0.5842458027529246e-1;
                c2[13, 2] := 0.8825044329219431e-1;
              elseif order == 28 then
                alpha := 0.1627710671942929;
                c2[1, 1] := 0.1057232656113488;
                c2[1, 2] := 0.6496161226860832;
                c2[2, 1] := 0.1051786825724864;
                c2[2, 2] := 0.6424661279909941;
                c2[3, 1] := 0.1040917964935006;
                c2[3, 2] := 0.6282470268918791;
                c2[4, 1] := 0.1024670101953951;
                c2[4, 2] := 0.6071189030701136;
                c2[5, 1] := 0.1003105109519892;
                c2[5, 2] := 0.5793175191747016;
                c2[6, 1] := 0.9762969425430802e-1;
                c2[6, 2] := 0.5451486608855443;
                c2[7, 1] := 0.9443223803058400e-1;
                c2[7, 2] := 0.5049796971628137;
                c2[8, 1] := 0.9072460982036488e-1;
                c2[8, 2] := 0.4592270546572523;
                c2[9, 1] := 0.8650956423253280e-1;
                c2[9, 2] := 0.4083368605952977;
                c2[10, 1] := 0.8178165740374893e-1;
                c2[10, 2] := 0.3527525188880655;
                c2[11, 1] := 0.7651838885868020e-1;
                c2[11, 2] := 0.2928534570013572;
                c2[12, 1] := 0.7066010532447490e-1;
                c2[12, 2] := 0.2288185204390681;
                c2[13, 1] := 0.6405358596145789e-1;
                c2[13, 2] := 0.1602396172588190;
                c2[14, 1] := 0.5621780070227172e-1;
                c2[14, 2] := 0.8447589564915071e-1;
              elseif order == 29 then
                alpha := 0.1598706626277596;
                c1[1] := 0.3199314513011623;
                c2[1, 1] := 0.1021101032532951;
                c2[1, 2] := 0.6365758882240111;
                c2[2, 1] := 0.1013729819392774;
                c2[2, 2] := 0.6267495975736321;
                c2[3, 1] := 0.1001476175660628;
                c2[3, 2] := 0.6104876178266819;
                c2[4, 1] := 0.9843854640428316e-1;
                c2[4, 2] := 0.5879603139195113;
                c2[5, 1] := 0.9625164534591696e-1;
                c2[5, 2] := 0.5594012291050210;
                c2[6, 1] := 0.9359356960417668e-1;
                c2[6, 2] := 0.5251016150410664;
                c2[7, 1] := 0.9047086748649986e-1;
                c2[7, 2] := 0.4854024475590397;
                c2[8, 1] := 0.8688856407189167e-1;
                c2[8, 2] := 0.4406826457109709;
                c2[9, 1] := 0.8284779224069856e-1;
                c2[9, 2] := 0.3913408089298914;
                c2[10, 1] := 0.7834154620997181e-1;
                c2[10, 2] := 0.3377643999400627;
                c2[11, 1] := 0.7334628941928766e-1;
                c2[11, 2] := 0.2802710651919946;
                c2[12, 1] := 0.6780290487362146e-1;
                c2[12, 2] := 0.2189770008083379;
                c2[13, 1] := 0.6156321231528423e-1;
                c2[13, 2] := 0.1534235999306070;
                c2[14, 1] := 0.5416797446761512e-1;
                c2[14, 2] := 0.8098664736760292e-1;
              elseif order == 30 then
                alpha := 0.1571200296252450;
                c2[1, 1] := 0.9908074847842124e-1;
                c2[1, 2] := 0.6289618807831557;
                c2[2, 1] := 0.9863509708328196e-1;
                c2[2, 2] := 0.6229164525571278;
                c2[3, 1] := 0.9774542692037148e-1;
                c2[3, 2] := 0.6108853364240036;
                c2[4, 1] := 0.9641490581986484e-1;
                c2[4, 2] := 0.5929869253412513;
                c2[5, 1] := 0.9464802912225441e-1;
                c2[5, 2] := 0.5693960175547550;
                c2[6, 1] := 0.9245027206218041e-1;
                c2[6, 2] := 0.5403402396359503;
                c2[7, 1] := 0.8982754584112941e-1;
                c2[7, 2] := 0.5060948065875106;
                c2[8, 1] := 0.8678535291732599e-1;
                c2[8, 2] := 0.4669749797983789;
                c2[9, 1] := 0.8332744242052199e-1;
                c2[9, 2] := 0.4233249626334694;
                c2[10, 1] := 0.7945356393775309e-1;
                c2[10, 2] := 0.3755006094498054;
                c2[11, 1] := 0.7515543969833788e-1;
                c2[11, 2] := 0.3238400339292700;
                c2[12, 1] := 0.7040879901685638e-1;
                c2[12, 2] := 0.2686072427439079;
                c2[13, 1] := 0.6515528854010540e-1;
                c2[13, 2] := 0.2098650589782619;
                c2[14, 1] := 0.5925168237177876e-1;
                c2[14, 2] := 0.1471138832654873;
                c2[15, 1] := 0.5225913954211672e-1;
                c2[15, 2] := 0.7775248839507864e-1;
              elseif order == 31 then
                alpha := 0.1545067022920929;
                c1[1] := 0.3100206996451866;
                c2[1, 1] := 0.9591020358831668e-1;
                c2[1, 2] := 0.6172474793293396;
                c2[2, 1] := 0.9530301275601203e-1;
                c2[2, 2] := 0.6088916323460413;
                c2[3, 1] := 0.9429332655402368e-1;
                c2[3, 2] := 0.5950511595503025;
                c2[4, 1] := 0.9288445429894548e-1;
                c2[4, 2] := 0.5758534119053522;
                c2[5, 1] := 0.9108073420087422e-1;
                c2[5, 2] := 0.5514734636081183;
                c2[6, 1] := 0.8888719137536870e-1;
                c2[6, 2] := 0.5221306199481831;
                c2[7, 1] := 0.8630901440239650e-1;
                c2[7, 2] := 0.4880834248148061;
                c2[8, 1] := 0.8335074993373294e-1;
                c2[8, 2] := 0.4496225358496770;
                c2[9, 1] := 0.8001502494376102e-1;
                c2[9, 2] := 0.4070602306679052;
                c2[10, 1] := 0.7630041338037624e-1;
                c2[10, 2] := 0.3607139804818122;
                c2[11, 1] := 0.7219760885744920e-1;
                c2[11, 2] := 0.3108783301229550;
                c2[12, 1] := 0.6768185077153345e-1;
                c2[12, 2] := 0.2577706252514497;
                c2[13, 1] := 0.6269571766328638e-1;
                c2[13, 2] := 0.2014081375889921;
                c2[14, 1] := 0.5710081766945065e-1;
                c2[14, 2] := 0.1412581515841926;
                c2[15, 1] := 0.5047740914807019e-1;
                c2[15, 2] := 0.7474725873250158e-1;
              elseif order == 32 then
                alpha := 0.1520196210848210;
                c2[1, 1] := 0.9322163554339406e-1;
                c2[1, 2] := 0.6101488690506050;
                c2[2, 1] := 0.9285233997694042e-1;
                c2[2, 2] := 0.6049832320721264;
                c2[3, 1] := 0.9211494244473163e-1;
                c2[3, 2] := 0.5946969295569034;
                c2[4, 1] := 0.9101176786042449e-1;
                c2[4, 2] := 0.5793791854364477;
                c2[5, 1] := 0.8954614071360517e-1;
                c2[5, 2] := 0.5591619969234026;
                c2[6, 1] := 0.8772216763680164e-1;
                c2[6, 2] := 0.5342177994699602;
                c2[7, 1] := 0.8554440426912734e-1;
                c2[7, 2] := 0.5047560942986598;
                c2[8, 1] := 0.8301735302045588e-1;
                c2[8, 2] := 0.4710187048140929;
                c2[9, 1] := 0.8014469519188161e-1;
                c2[9, 2] := 0.4332730387207936;
                c2[10, 1] := 0.7692807528893225e-1;
                c2[10, 2] := 0.3918021436411035;
                c2[11, 1] := 0.7336507157284898e-1;
                c2[11, 2] := 0.3468890521471250;
                c2[12, 1] := 0.6944555312763458e-1;
                c2[12, 2] := 0.2987898029050460;
                c2[13, 1] := 0.6514446669420571e-1;
                c2[13, 2] := 0.2476810747407199;
                c2[14, 1] := 0.6040544477732702e-1;
                c2[14, 2] := 0.1935412053397663;
                c2[15, 1] := 0.5509478650672775e-1;
                c2[15, 2] := 0.1358108994174911;
                c2[16, 1] := 0.4881064725720192e-1;
                c2[16, 2] := 0.7194819894416505e-1;
              elseif order == 33 then
                alpha := 0.1496489351138032;
                c1[1] := 0.3009752799176432;
                c2[1, 1] := 0.9041725460994505e-1;
                c2[1, 2] := 0.5995521047364046;
                c2[2, 1] := 0.8991117804113002e-1;
                c2[2, 2] := 0.5923764112099496;
                c2[3, 1] := 0.8906941547422532e-1;
                c2[3, 2] := 0.5804822013853129;
                c2[4, 1] := 0.8789442491445575e-1;
                c2[4, 2] := 0.5639663528946501;
                c2[5, 1] := 0.8638945831033775e-1;
                c2[5, 2] := 0.5429623519607796;
                c2[6, 1] := 0.8455834602616358e-1;
                c2[6, 2] := 0.5176379938389326;
                c2[7, 1] := 0.8240517431382334e-1;
                c2[7, 2] := 0.4881921474066189;
                c2[8, 1] := 0.7993380417355076e-1;
                c2[8, 2] := 0.4548502528082586;
                c2[9, 1] := 0.7714713890732801e-1;
                c2[9, 2] := 0.4178579388038483;
                c2[10, 1] := 0.7404596598181127e-1;
                c2[10, 2] := 0.3774715722484659;
                c2[11, 1] := 0.7062702339160462e-1;
                c2[11, 2] := 0.3339432938810453;
                c2[12, 1] := 0.6687952672391507e-1;
                c2[12, 2] := 0.2874950693388235;
                c2[13, 1] := 0.6277828912909767e-1;
                c2[13, 2] := 0.2382680702894708;
                c2[14, 1] := 0.5826808305383988e-1;
                c2[14, 2] := 0.1862073169968455;
                c2[15, 1] := 0.5321974125363517e-1;
                c2[15, 2] := 0.1307323751236313;
                c2[16, 1] := 0.4724820282032780e-1;
                c2[16, 2] := 0.6933542082177094e-1;
              elseif order == 34 then
                alpha := 0.1473858373968463;
                c2[1, 1] := 0.8801537152275983e-1;
                c2[1, 2] := 0.5929204288972172;
                c2[2, 1] := 0.8770594341007476e-1;
                c2[2, 2] := 0.5884653382247518;
                c2[3, 1] := 0.8708797598072095e-1;
                c2[3, 2] := 0.5795895850253119;
                c2[4, 1] := 0.8616320590689187e-1;
                c2[4, 2] := 0.5663615383647170;
                c2[5, 1] := 0.8493413175570858e-1;
                c2[5, 2] := 0.5488825092350877;
                c2[6, 1] := 0.8340387368687513e-1;
                c2[6, 2] := 0.5272851839324592;
                c2[7, 1] := 0.8157596213131521e-1;
                c2[7, 2] := 0.5017313864372913;
                c2[8, 1] := 0.7945402670834270e-1;
                c2[8, 2] := 0.4724089864574216;
                c2[9, 1] := 0.7704133559556429e-1;
                c2[9, 2] := 0.4395276256463053;
                c2[10, 1] := 0.7434009635219704e-1;
                c2[10, 2] := 0.4033126590648964;
                c2[11, 1] := 0.7135035113853376e-1;
                c2[11, 2] := 0.3639961488919042;
                c2[12, 1] := 0.6806813160738834e-1;
                c2[12, 2] := 0.3218025212900124;
                c2[13, 1] := 0.6448214312000864e-1;
                c2[13, 2] := 0.2769235521088158;
                c2[14, 1] := 0.6056719318430530e-1;
                c2[14, 2] := 0.2294693573271038;
                c2[15, 1] := 0.5626925196925040e-1;
                c2[15, 2] := 0.1793564218840015;
                c2[16, 1] := 0.5146352031547277e-1;
                c2[16, 2] := 0.1259877129326412;
                c2[17, 1] := 0.4578069074410591e-1;
                c2[17, 2] := 0.6689147319568768e-1;
              elseif order == 35 then
                alpha := 0.1452224267615486;
                c1[1] := 0.2926764667564367;
                c2[1, 1] := 0.8551731299267280e-1;
                c2[1, 2] := 0.5832758214629523;
                c2[2, 1] := 0.8509109732853060e-1;
                c2[2, 2] := 0.5770596582643844;
                c2[3, 1] := 0.8438201446671953e-1;
                c2[3, 2] := 0.5667497616665494;
                c2[4, 1] := 0.8339191981579831e-1;
                c2[4, 2] := 0.5524209816238369;
                c2[5, 1] := 0.8212328610083385e-1;
                c2[5, 2] := 0.5341766459916322;
                c2[6, 1] := 0.8057906332198853e-1;
                c2[6, 2] := 0.5121470053512750;
                c2[7, 1] := 0.7876247299954955e-1;
                c2[7, 2] := 0.4864870722254752;
                c2[8, 1] := 0.7667670879950268e-1;
                c2[8, 2] := 0.4573736721705665;
                c2[9, 1] := 0.7432449556218945e-1;
                c2[9, 2] := 0.4250013835198991;
                c2[10, 1] := 0.7170742126011575e-1;
                c2[10, 2] := 0.3895767735915445;
                c2[11, 1] := 0.6882488171701314e-1;
                c2[11, 2] := 0.3513097926737368;
                c2[12, 1] := 0.6567231746957568e-1;
                c2[12, 2] := 0.3103999917596611;
                c2[13, 1] := 0.6223804362223595e-1;
                c2[13, 2] := 0.2670123611280899;
                c2[14, 1] := 0.5849696460782910e-1;
                c2[14, 2] := 0.2212298104867592;
                c2[15, 1] := 0.5439628409499822e-1;
                c2[15, 2] := 0.1729443731341637;
                c2[16, 1] := 0.4981540179136920e-1;
                c2[16, 2] := 0.1215462157134930;
                c2[17, 1] := 0.4439981033536435e-1;
                c2[17, 2] := 0.6460098363520967e-1;
              elseif order == 36 then
                alpha := 0.1431515914458580;
                c2[1, 1] := 0.8335881847130301e-1;
                c2[1, 2] := 0.5770670512160201;
                c2[2, 1] := 0.8309698922852212e-1;
                c2[2, 2] := 0.5731929100172432;
                c2[3, 1] := 0.8257400347039723e-1;
                c2[3, 2] := 0.5654713811993058;
                c2[4, 1] := 0.8179117911600136e-1;
                c2[4, 2] := 0.5539556343603020;
                c2[5, 1] := 0.8075042173126963e-1;
                c2[5, 2] := 0.5387245649546684;
                c2[6, 1] := 0.7945413151258206e-1;
                c2[6, 2] := 0.5198817177723069;
                c2[7, 1] := 0.7790506514288866e-1;
                c2[7, 2] := 0.4975537629595409;
                c2[8, 1] := 0.7610613635339480e-1;
                c2[8, 2] := 0.4718884193866789;
                c2[9, 1] := 0.7406012816626425e-1;
                c2[9, 2] := 0.4430516443136726;
                c2[10, 1] := 0.7176927060205631e-1;
                c2[10, 2] := 0.4112237708115829;
                c2[11, 1] := 0.6923460172504251e-1;
                c2[11, 2] := 0.3765940116389730;
                c2[12, 1] := 0.6645495833489556e-1;
                c2[12, 2] := 0.3393522147815403;
                c2[13, 1] := 0.6342528888937094e-1;
                c2[13, 2] := 0.2996755899575573;
                c2[14, 1] := 0.6013361864949449e-1;
                c2[14, 2] := 0.2577053294053830;
                c2[15, 1] := 0.5655503081322404e-1;
                c2[15, 2] := 0.2135004731531631;
                c2[16, 1] := 0.5263798119559069e-1;
                c2[16, 2] := 0.1669320999865636;
                c2[17, 1] := 0.4826589873626196e-1;
                c2[17, 2] := 0.1173807590715484;
                c2[18, 1] := 0.4309819397289806e-1;
                c2[18, 2] := 0.6245036108880222e-1;
              elseif order == 37 then
                alpha := 0.1411669104782917;
                c1[1] := 0.2850271036215707;
                c2[1, 1] := 0.8111958235023328e-1;
                c2[1, 2] := 0.5682412610563970;
                c2[2, 1] := 0.8075727567979578e-1;
                c2[2, 2] := 0.5628142923227016;
                c2[3, 1] := 0.8015440554413301e-1;
                c2[3, 2] := 0.5538087696879930;
                c2[4, 1] := 0.7931239302677386e-1;
                c2[4, 2] := 0.5412833323304460;
                c2[5, 1] := 0.7823314328639347e-1;
                c2[5, 2] := 0.5253190555393968;
                c2[6, 1] := 0.7691895211595101e-1;
                c2[6, 2] := 0.5060183741977191;
                c2[7, 1] := 0.7537237072011853e-1;
                c2[7, 2] := 0.4835036020049034;
                c2[8, 1] := 0.7359601294804538e-1;
                c2[8, 2] := 0.4579149413954837;
                c2[9, 1] := 0.7159227884849299e-1;
                c2[9, 2] := 0.4294078049978829;
                c2[10, 1] := 0.6936295002846032e-1;
                c2[10, 2] := 0.3981491350382047;
                c2[11, 1] := 0.6690857785828917e-1;
                c2[11, 2] := 0.3643121502867948;
                c2[12, 1] := 0.6422751692085542e-1;
                c2[12, 2] := 0.3280684291406284;
                c2[13, 1] := 0.6131430866206096e-1;
                c2[13, 2] := 0.2895750997170303;
                c2[14, 1] := 0.5815677249570920e-1;
                c2[14, 2] := 0.2489521814805720;
                c2[15, 1] := 0.5473023527947980e-1;
                c2[15, 2] := 0.2062377435955363;
                c2[16, 1] := 0.5098441033167034e-1;
                c2[16, 2] := 0.1612849131645336;
                c2[17, 1] := 0.4680658811093562e-1;
                c2[17, 2] := 0.1134672937045305;
                c2[18, 1] := 0.4186928031694695e-1;
                c2[18, 2] := 0.6042754777339966e-1;
              elseif order == 38 then
                alpha := 0.1392625697140030;
                c2[1, 1] := 0.7916943373658329e-1;
                c2[1, 2] := 0.5624158631591745;
                c2[2, 1] := 0.7894592250257840e-1;
                c2[2, 2] := 0.5590219398777304;
                c2[3, 1] := 0.7849941672384930e-1;
                c2[3, 2] := 0.5522551628416841;
                c2[4, 1] := 0.7783093084875645e-1;
                c2[4, 2] := 0.5421574325808380;
                c2[5, 1] := 0.7694193770482690e-1;
                c2[5, 2] := 0.5287909941093643;
                c2[6, 1] := 0.7583430534712885e-1;
                c2[6, 2] := 0.5122376814029880;
                c2[7, 1] := 0.7451020436122948e-1;
                c2[7, 2] := 0.4925978555548549;
                c2[8, 1] := 0.7297197617673508e-1;
                c2[8, 2] := 0.4699889739625235;
                c2[9, 1] := 0.7122194706992953e-1;
                c2[9, 2] := 0.4445436860615774;
                c2[10, 1] := 0.6926216260386816e-1;
                c2[10, 2] := 0.4164072786327193;
                c2[11, 1] := 0.6709399961255503e-1;
                c2[11, 2] := 0.3857341621868851;
                c2[12, 1] := 0.6471757977022456e-1;
                c2[12, 2] := 0.3526828388476838;
                c2[13, 1] := 0.6213084287116965e-1;
                c2[13, 2] := 0.3174082831364342;
                c2[14, 1] := 0.5932799638550641e-1;
                c2[14, 2] := 0.2800495563550299;
                c2[15, 1] := 0.5629672408524944e-1;
                c2[15, 2] := 0.2407078154782509;
                c2[16, 1] := 0.5301264751544952e-1;
                c2[16, 2] := 0.1994026830553859;
                c2[17, 1] := 0.4942673259817896e-1;
                c2[17, 2] := 0.1559719194038917;
                c2[18, 1] := 0.4542996716979947e-1;
                c2[18, 2] := 0.1097844277878470;
                c2[19, 1] := 0.4070720755433961e-1;
                c2[19, 2] := 0.5852181110523043e-1;
              elseif order == 39 then
                alpha := 0.1374332900196804;
                c1[1] := 0.2779468246419593;
                c2[1, 1] := 0.7715084161825772e-1;
                c2[1, 2] := 0.5543001331300056;
                c2[2, 1] := 0.7684028301163326e-1;
                c2[2, 2] := 0.5495289890712267;
                c2[3, 1] := 0.7632343924866024e-1;
                c2[3, 2] := 0.5416083298429741;
                c2[4, 1] := 0.7560141319808483e-1;
                c2[4, 2] := 0.5305846713929198;
                c2[5, 1] := 0.7467569064745969e-1;
                c2[5, 2] := 0.5165224112570647;
                c2[6, 1] := 0.7354807648551346e-1;
                c2[6, 2] := 0.4995030679271456;
                c2[7, 1] := 0.7222060351121389e-1;
                c2[7, 2] := 0.4796242430956156;
                c2[8, 1] := 0.7069540462458585e-1;
                c2[8, 2] := 0.4569982440368368;
                c2[9, 1] := 0.6897453353492381e-1;
                c2[9, 2] := 0.4317502624832354;
                c2[10, 1] := 0.6705970959388781e-1;
                c2[10, 2] := 0.4040159353969854;
                c2[11, 1] := 0.6495194541066725e-1;
                c2[11, 2] := 0.3739379843169939;
                c2[12, 1] := 0.6265098412417610e-1;
                c2[12, 2] := 0.3416613843816217;
                c2[13, 1] := 0.6015440984955930e-1;
                c2[13, 2] := 0.3073260166338746;
                c2[14, 1] := 0.5745615876877304e-1;
                c2[14, 2] := 0.2710546723961181;
                c2[15, 1] := 0.5454383762391338e-1;
                c2[15, 2] := 0.2329316824061170;
                c2[16, 1] := 0.5139340231935751e-1;
                c2[16, 2] := 0.1929604256043231;
                c2[17, 1] := 0.4795705862458131e-1;
                c2[17, 2] := 0.1509655259246037;
                c2[18, 1] := 0.4412933231935506e-1;
                c2[18, 2] := 0.1063130748962878;
                c2[19, 1] := 0.3960672309405603e-1;
                c2[19, 2] := 0.5672356837211527e-1;
              elseif order == 40 then
                alpha := 0.1356742655825434;
                c2[1, 1] := 0.7538038374294594e-1;
                c2[1, 2] := 0.5488228264329617;
                c2[2, 1] := 0.7518806529402738e-1;
                c2[2, 2] := 0.5458297722483311;
                c2[3, 1] := 0.7480383050347119e-1;
                c2[3, 2] := 0.5398604576730540;
                c2[4, 1] := 0.7422847031965465e-1;
                c2[4, 2] := 0.5309482987446206;
                c2[5, 1] := 0.7346313704205006e-1;
                c2[5, 2] := 0.5191429845322307;
                c2[6, 1] := 0.7250930053201402e-1;
                c2[6, 2] := 0.5045099368431007;
                c2[7, 1] := 0.7136868456879621e-1;
                c2[7, 2] := 0.4871295553902607;
                c2[8, 1] := 0.7004317764946634e-1;
                c2[8, 2] := 0.4670962098860498;
                c2[9, 1] := 0.6853470921527828e-1;
                c2[9, 2] := 0.4445169164956202;
                c2[10, 1] := 0.6684507689945471e-1;
                c2[10, 2] := 0.4195095960479698;
                c2[11, 1] := 0.6497570123412630e-1;
                c2[11, 2] := 0.3922007419030645;
                c2[12, 1] := 0.6292726794917847e-1;
                c2[12, 2] := 0.3627221993494397;
                c2[13, 1] := 0.6069918741663154e-1;
                c2[13, 2] := 0.3312065181294388;
                c2[14, 1] := 0.5828873983769410e-1;
                c2[14, 2] := 0.2977798532686911;
                c2[15, 1] := 0.5568964389813015e-1;
                c2[15, 2] := 0.2625503293999835;
                c2[16, 1] := 0.5288947816690705e-1;
                c2[16, 2] := 0.2255872486520188;
                c2[17, 1] := 0.4986456327645859e-1;
                c2[17, 2] := 0.1868796731919594;
                c2[18, 1] := 0.4656832613054458e-1;
                c2[18, 2] := 0.1462410193532463;
                c2[19, 1] := 0.4289867647614935e-1;
                c2[19, 2] := 0.1030361558710747;
                c2[20, 1] := 0.3856310684054106e-1;
                c2[20, 2] := 0.5502423832293889e-1;
              elseif order == 41 then
                alpha := 0.1339811106984253;
                c1[1] := 0.2713685065531391;
                c2[1, 1] := 0.7355140275160984e-1;
                c2[1, 2] := 0.5413274778282860;
                c2[2, 1] := 0.7328319082267173e-1;
                c2[2, 2] := 0.5371064088294270;
                c2[3, 1] := 0.7283676160772547e-1;
                c2[3, 2] := 0.5300963437270770;
                c2[4, 1] := 0.7221298133014343e-1;
                c2[4, 2] := 0.5203345998371490;
                c2[5, 1] := 0.7141302173623395e-1;
                c2[5, 2] := 0.5078728971879841;
                c2[6, 1] := 0.7043831559982149e-1;
                c2[6, 2] := 0.4927768111819803;
                c2[7, 1] := 0.6929049381827268e-1;
                c2[7, 2] := 0.4751250308594139;
                c2[8, 1] := 0.6797129849758392e-1;
                c2[8, 2] := 0.4550083840638406;
                c2[9, 1] := 0.6648246325101609e-1;
                c2[9, 2] := 0.4325285673076087;
                c2[10, 1] := 0.6482554675958526e-1;
                c2[10, 2] := 0.4077964789091151;
                c2[11, 1] := 0.6300169683004558e-1;
                c2[11, 2] := 0.3809299858742483;
                c2[12, 1] := 0.6101130648543355e-1;
                c2[12, 2] := 0.3520508315700898;
                c2[13, 1] := 0.5885349417435808e-1;
                c2[13, 2] := 0.3212801560701271;
                c2[14, 1] := 0.5652528148656809e-1;
                c2[14, 2] := 0.2887316252774887;
                c2[15, 1] := 0.5402021575818373e-1;
                c2[15, 2] := 0.2545001287790888;
                c2[16, 1] := 0.5132588802608274e-1;
                c2[16, 2] := 0.2186415296842951;
                c2[17, 1] := 0.4841900639702602e-1;
                c2[17, 2] := 0.1811322622296060;
                c2[18, 1] := 0.4525419574485134e-1;
                c2[18, 2] := 0.1417762065404688;
                c2[19, 1] := 0.4173260173087802e-1;
                c2[19, 2] := 0.9993834530966510e-1;
                c2[20, 1] := 0.3757210572966463e-1;
                c2[20, 2] := 0.5341611499960143e-1;
              else
                Streams.error("Input argument order (= " + String(order) +
                  ") of Bessel filter is not in the range 1..41");
              end if;

              annotation (Documentation(info="<html> The transfer function H(p) of a <i>n</i> 'th order Bessel filter is given by

<blockquote><pre>
         Bn(0)
 H(p) = -------
         Bn(p)
 </pre>
</blockquote> with the denominator polynomial

<blockquote><pre>
          n             n  (2n - k)!       p^k
 Bn(p) = sum c_k*p^k = sum ----------- * -------   (1)
         k=0           k=0 (n - k)!k!    2^(n-k)
</pre></blockquote>

and the numerator

<blockquote><pre>
               (2n)!     1
Bn(0) = c_0 = ------- * ---- .                     (2)
                n!      2^n
 </pre></blockquote>

Although the coefficients c_k are integer numbers, it is not advisable to use the
polynomials in an unfactorized form because the coefficients are fast growing with order
n (c_0 is approximately 0.3e24 and 0.8e59 for order n=20 and order n=40
respectively).<br>

Therefore, the polynomial Bn(p) is factorized to first and second order polynomials with
real coefficients corresponding to zeros and poles representation that is used in this library.
<p>
The function returns the coefficients which resulted from factorization of the normalized transfer function

<blockquote><pre>
H'(p') = H(p),  p' = p/w0
</pre></blockquote>
as well as
<blockquote><pre>
alpha = 1/w0
</pre></blockquote>
the reciprocal of the cut of frequency w0 where the gain of the transfer function is
decreased 3dB.<p>

Both, coefficients and cut off frequency were calculated symbolically and were eventually evaluated
with high precision calculation. The results were stored in this function as real
numbers.<p>

<br><br><b>Calculation of normalized Bessel filter coefficients</b><br><br>

Equation <blockquote><pre>
   abs(H(j*w0)) = abs(Bn(0)/Bn(j*w0)) = 10^(-3/20)
 </pre></blockquote>
which must be fulfilled for cut off frequency w = w0 leads to
<blockquote><pre>
   [Re(Bn(j*w0))]^2 + [Im(Bn(j*w0))]^2 - (Bn(0)^2)*10^(3/10) = 0
</pre></blockquote>
which has exactly one real solution w0 for each order n. This solutions of w0 are
calculated symbolically first and evaluated by using high precise values of the
coefficients c_k calculated by following (1) and (2). <br>

With w0, the coefficients of the factorized polynomial can be computed by calculating the
zeros of the denominator polynomial

<blockquote><pre>
         n
 Bn(p) = sum w0^k*c_k*(p/w0)^k
         k=0
</pre></blockquote>

of the normalized transfer function H'(p'). There exist n/2 of conjugate complex
pairs of zeros (beta +-j*gamma) if n is even and one additional real zero (alpha) if n is
odd. Finally, the coefficients a, b1_k, b2_k of the polynomials

<blockquote><pre> a*p + 1,  n is odd </pre></blockquote> and

<blockquote><pre> b2_k*p^2 + b1_k*p + 1,   k = 1,... div(n,2) </pre></blockquote>

results from <blockquote><pre> a = -1/alpha </pre></blockquote> and
<blockquote><pre> b2_k = 1/(beta_k^2 + gamma_k^2) b1_k = -2*beta_k/(beta_k^2 + gamma_k^2)
</pre></blockquote>
</p>

</html>
"));
            end BesselBaseCoefficients;

            function toHighestPowerOne
            "Transform filter to form with highest power of s equal 1"

              input Real den1[:]
              "[s] coefficients of polynomials (den1[i]*s + 1)";
              input Real den2[:,2]
              "[s^2, s] coefficients of polynomials (den2[i,1]*s^2 + den2[i,2]*s + 1)";
              output Real cr[size(den1, 1)]
              "[s^0] coefficients of polynomials cr[i]*(s+1/cr[i])";
              output Real c0[size(den2, 1)]
              "[s^0] coefficients of polynomials (s^2 + (den2[i,2]/den2[i,1])*s + (1/den2[i,1]))";
              output Real c1[size(den2, 1)]
              "[s^1] coefficients of polynomials (s^2 + (den2[i,2]/den2[i,1])*s + (1/den2[i,1]))";
            algorithm
              for i in 1:size(den1, 1) loop
                cr[i] := 1/den1[i];
              end for;

              for i in 1:size(den2, 1) loop
                c1[i] := den2[i, 2]/den2[i, 1];
                c0[i] := 1/den2[i, 1];
              end for;
            end toHighestPowerOne;

            function normalizationFactor
            "Compute correction factor of low pass filter such that amplitude at cut-off frequency is -3db (=10^(-3/20) = 0.70794...)"
              import Modelica;
              import Modelica.Utilities.Streams;

              input Real c1[:]
              "[p] coefficients of denominator polynomials (c1[i}*p + 1)";
              input Real c2[:,2]
              "[p^2, p] coefficients of denominator polynomials (c2[i,1]*p^2 + c2[i,2]*p + 1)";
              output Real alpha "Correction factor (replace p by alpha*p)";
          protected
              Real alpha_min;
              Real alpha_max;

              function normalizationResidue
              "Residue of correction factor computation"
                input Real c1[:]
                "[p] coefficients of denominator polynomials (c1[i]*p + 1)";
                input Real c2[:,2]
                "[p^2, p] coefficients of denominator polynomials (c2[i,1]*p^2 + c2[i,2]*p + 1)";
                input Real alpha;
                output Real residue;
            protected
                constant Real beta= 10^(-3/20)
                "Amplitude of -3db required, i.e., -3db = 20*log(beta)";
                Real cc1;
                Real cc2;
                Real p;
                Real alpha2=alpha*alpha;
                Real alpha4=alpha2*alpha2;
                Real A2=1.0;
              algorithm
                assert(size(c1,1) <= 1, "Internal error 2 (should not occur)");
                if size(c1, 1) == 1 then
                  cc1 := c1[1]*c1[1];
                  p := 1 + cc1*alpha2;
                  A2 := A2*p;
                end if;
                for i in 1:size(c2, 1) loop
                  cc1 := c2[i, 2]*c2[i, 2] - 2*c2[i, 1];
                  cc2 := c2[i, 1]*c2[i, 1];
                  p := 1 + cc1*alpha2 + cc2*alpha4;
                  A2 := A2*p;
                end for;
                residue := 1/sqrt(A2) - beta;
              end normalizationResidue;

              function findInterval "Find interval for the root"
                input Real c1[:]
                "[p] coefficients of denominator polynomials (a*p + 1)";
                input Real c2[:,2]
                "[p^2, p] coefficients of denominator polynomials (b*p^2 + a*p + 1)";
                output Real alpha_min;
                output Real alpha_max;
            protected
                Real alpha = 1.0;
                Real residue;
              algorithm
                alpha_min :=0;
                residue := normalizationResidue(c1, c2, alpha);
                if residue < 0 then
                   alpha_max :=alpha;
                else
                   while residue >= 0 loop
                      alpha := 1.1*alpha;
                      residue := normalizationResidue(c1, c2, alpha);
                   end while;
                   alpha_max :=alpha;
                end if;
              end findInterval;

            function solveOneNonlinearEquation
              "Solve f(u) = 0; f(u_min) and f(u_max) must have different signs"
                import Modelica.Utilities.Streams.error;

              input Real c1[:]
                "[p] coefficients of denominator polynomials (c1[i]*p + 1)";
              input Real c2[:,2]
                "[p^2, p] coefficients of denominator polynomials (c2[i,1]*p^2 + c2[i,2]*p + 1)";
              input Real u_min "Lower bound of search intervall";
              input Real u_max "Upper bound of search intervall";
              input Real tolerance=100*Modelica.Constants.eps
                "Relative tolerance of solution u";
              output Real u "Value of independent variable so that f(u) = 0";

            protected
              constant Real eps=Modelica.Constants.eps "machine epsilon";
              Real a=u_min "Current best minimum interval value";
              Real b=u_max "Current best maximum interval value";
              Real c "Intermediate point a <= c <= b";
              Real d;
              Real e "b - a";
              Real m;
              Real s;
              Real p;
              Real q;
              Real r;
              Real tol;
              Real fa "= f(a)";
              Real fb "= f(b)";
              Real fc;
              Boolean found=false;
            algorithm
              // Check that f(u_min) and f(u_max) have different sign
              fa := normalizationResidue(c1,c2,u_min);
              fb := normalizationResidue(c1,c2,u_max);
              fc := fb;
              if fa > 0.0 and fb > 0.0 or fa < 0.0 and fb < 0.0 then
                error(
                  "The arguments u_min and u_max to solveOneNonlinearEquation(..)\n" +
                  "do not bracket the root of the single non-linear equation:\n" +
                  "  u_min  = " + String(u_min) + "\n" + "  u_max  = " + String(u_max)
                   + "\n" + "  fa = f(u_min) = " + String(fa) + "\n" +
                  "  fb = f(u_max) = " + String(fb) + "\n" +
                  "fa and fb must have opposite sign which is not the case");
              end if;

              // Initialize variables
              c := a;
              fc := fa;
              e := b - a;
              d := e;

              // Search loop
              while not found loop
                if abs(fc) < abs(fb) then
                  a := b;
                  b := c;
                  c := a;
                  fa := fb;
                  fb := fc;
                  fc := fa;
                end if;

                tol := 2*eps*abs(b) + tolerance;
                m := (c - b)/2;

                if abs(m) <= tol or fb == 0.0 then
                  // root found (interval is small enough)
                  found := true;
                  u := b;
                else
                  // Determine if a bisection is needed
                  if abs(e) < tol or abs(fa) <= abs(fb) then
                    e := m;
                    d := e;
                  else
                    s := fb/fa;
                    if a == c then
                      // linear interpolation
                      p := 2*m*s;
                      q := 1 - s;
                    else
                      // inverse quadratic interpolation
                      q := fa/fc;
                      r := fb/fc;
                      p := s*(2*m*q*(q - r) - (b - a)*(r - 1));
                      q := (q - 1)*(r - 1)*(s - 1);
                    end if;

                    if p > 0 then
                      q := -q;
                    else
                      p := -p;
                    end if;

                    s := e;
                    e := d;
                    if 2*p < 3*m*q - abs(tol*q) and p < abs(0.5*s*q) then
                      // interpolation successful
                      d := p/q;
                    else
                      // use bi-section
                      e := m;
                      d := e;
                    end if;
                  end if;

                  // Best guess value is defined as "a"
                  a := b;
                  fa := fb;
                  b := b + (if abs(d) > tol then d else if m > 0 then tol else -tol);
                  fb := normalizationResidue(c1,c2,b);

                  if fb > 0 and fc > 0 or fb < 0 and fc < 0 then
                    // initialize variables
                    c := a;
                    fc := fa;
                    e := b - a;
                    d := e;
                  end if;
                end if;
              end while;

              annotation (Documentation(info="<html>

<p>
This function determines the solution of <b>one non-linear algebraic equation</b> \"y=f(u)\"
in <b>one unknown</b> \"u\" in a reliable way. It is one of the best numerical
algorithms for this purpose. As input, the nonlinear function f(u)
has to be given, as well as an interval u_min, u_max that
contains the solution, i.e., \"f(u_min)\" and \"f(u_max)\" must
have a different sign. If possible, a smaller interval is computed by
inverse quadratic interpolation (interpolating with a quadratic polynomial
through the last 3 points and computing the zero). If this fails,
bisection is used, which always reduces the interval by a factor of 2.
The inverse quadratic interpolation method has superlinear convergence.
This is roughly the same convergence rate as a globally convergent Newton
method, but without the need to compute derivatives of the non-linear
function. The solver function is a direct mapping of the Algol 60 procedure
\"zero\" to Modelica, from:
</p>

<dl>
<dt> Brent R.P.:</dt>
<dd> <b>Algorithms for Minimization without derivatives</b>.
     Prentice Hall, 1973, pp. 58-59.</dd>
</dl>

</html>"));
            end solveOneNonlinearEquation;

            algorithm
               // Find interval for alpha
               (alpha_min, alpha_max) :=findInterval(c1, c2);

               // Compute alpha, so that abs(G(p)) = -3db
               alpha :=solveOneNonlinearEquation(
                c1,
                c2,
                alpha_min,
                alpha_max);
            end normalizationFactor;

            encapsulated function bandPassAlpha "Return alpha for band pass"
              import Modelica;
               input Real a "Coefficient of s^1";
               input Real b "Coefficient of s^0";
               input Modelica.SIunits.AngularVelocity w
              "Bandwidth angular frequency";
               output Real alpha "Alpha factor to build up band pass";

          protected
              Real alpha_min;
              Real alpha_max;
              Real z_min;
              Real z_max;
              Real z;

              function residue "Residue of non-linear equation"
                input Real a;
                input Real b;
                input Real w;
                input Real z;
                output Real res;
              algorithm
                res := z^2 + (a*w*z/(1+z))^2 - (2+b*w^2)*z + 1;
              end residue;

            function solveOneNonlinearEquation
              "Solve f(u) = 0; f(u_min) and f(u_max) must have different signs"
                import Modelica.Utilities.Streams.error;

              input Real aa;
              input Real bb;
              input Real ww;
              input Real u_min "Lower bound of search intervall";
              input Real u_max "Upper bound of search intervall";
              input Real tolerance=100*Modelica.Constants.eps
                "Relative tolerance of solution u";
              output Real u "Value of independent variable so that f(u) = 0";

            protected
              constant Real eps=Modelica.Constants.eps "machine epsilon";
              Real a=u_min "Current best minimum interval value";
              Real b=u_max "Current best maximum interval value";
              Real c "Intermediate point a <= c <= b";
              Real d;
              Real e "b - a";
              Real m;
              Real s;
              Real p;
              Real q;
              Real r;
              Real tol;
              Real fa "= f(a)";
              Real fb "= f(b)";
              Real fc;
              Boolean found=false;
            algorithm
              // Check that f(u_min) and f(u_max) have different sign
              fa := residue(aa,bb,ww,u_min);
              fb := residue(aa,bb,ww,u_max);
              fc := fb;
              if fa > 0.0 and fb > 0.0 or fa < 0.0 and fb < 0.0 then
                error(
                  "The arguments u_min and u_max to solveOneNonlinearEquation(..)\n" +
                  "do not bracket the root of the single non-linear equation:\n" +
                  "  u_min  = " + String(u_min) + "\n" + "  u_max  = " + String(u_max)
                   + "\n" + "  fa = f(u_min) = " + String(fa) + "\n" +
                  "  fb = f(u_max) = " + String(fb) + "\n" +
                  "fa and fb must have opposite sign which is not the case");
              end if;

              // Initialize variables
              c := a;
              fc := fa;
              e := b - a;
              d := e;

              // Search loop
              while not found loop
                if abs(fc) < abs(fb) then
                  a := b;
                  b := c;
                  c := a;
                  fa := fb;
                  fb := fc;
                  fc := fa;
                end if;

                tol := 2*eps*abs(b) + tolerance;
                m := (c - b)/2;

                if abs(m) <= tol or fb == 0.0 then
                  // root found (interval is small enough)
                  found := true;
                  u := b;
                else
                  // Determine if a bisection is needed
                  if abs(e) < tol or abs(fa) <= abs(fb) then
                    e := m;
                    d := e;
                  else
                    s := fb/fa;
                    if a == c then
                      // linear interpolation
                      p := 2*m*s;
                      q := 1 - s;
                    else
                      // inverse quadratic interpolation
                      q := fa/fc;
                      r := fb/fc;
                      p := s*(2*m*q*(q - r) - (b - a)*(r - 1));
                      q := (q - 1)*(r - 1)*(s - 1);
                    end if;

                    if p > 0 then
                      q := -q;
                    else
                      p := -p;
                    end if;

                    s := e;
                    e := d;
                    if 2*p < 3*m*q - abs(tol*q) and p < abs(0.5*s*q) then
                      // interpolation successful
                      d := p/q;
                    else
                      // use bi-section
                      e := m;
                      d := e;
                    end if;
                  end if;

                  // Best guess value is defined as "a"
                  a := b;
                  fa := fb;
                  b := b + (if abs(d) > tol then d else if m > 0 then tol else -tol);
                  fb := residue(aa,bb,ww,b);

                  if fb > 0 and fc > 0 or fb < 0 and fc < 0 then
                    // initialize variables
                    c := a;
                    fc := fa;
                    e := b - a;
                    d := e;
                  end if;
                end if;
              end while;

              annotation (Documentation(info="<html>

<p>
This function determines the solution of <b>one non-linear algebraic equation</b> \"y=f(u)\"
in <b>one unknown</b> \"u\" in a reliable way. It is one of the best numerical
algorithms for this purpose. As input, the nonlinear function f(u)
has to be given, as well as an interval u_min, u_max that
contains the solution, i.e., \"f(u_min)\" and \"f(u_max)\" must
have a different sign. If possible, a smaller interval is computed by
inverse quadratic interpolation (interpolating with a quadratic polynomial
through the last 3 points and computing the zero). If this fails,
bisection is used, which always reduces the interval by a factor of 2.
The inverse quadratic interpolation method has superlinear convergence.
This is roughly the same convergence rate as a globally convergent Newton
method, but without the need to compute derivatives of the non-linear
function. The solver function is a direct mapping of the Algol 60 procedure
\"zero\" to Modelica, from:
</p>

<dl>
<dt> Brent R.P.:</dt>
<dd> <b>Algorithms for Minimization without derivatives</b>.
     Prentice Hall, 1973, pp. 58-59.</dd>
</dl>

</html>"));
            end solveOneNonlinearEquation;

            algorithm
              assert( a^2/4 - b <= 0,  "Band pass transformation cannot be computed");
              z :=solveOneNonlinearEquation(a, b, w, 0, 1);
              alpha := sqrt(z);

              annotation (Documentation(info="<html>
<p>
A band pass with bandwidth \"w\" is determined from a low pass
</p>

<pre>
  1/(p^2 + a*p + b)
</pre>

<p>
with the transformation
</p>

<pre>
  new(p) = (p + 1/p)/w
</pre>

<p>
This results in the following derivation:
</p>

<pre>
  1/(p^2 + a*p + b) -> 1/( (p+1/p)^2/w^2 + a*(p + 1/p)/w + b )
                     = 1 / ( p^2 + 1/p^2 + 2)/w^2 + (p + 1/p)*a/w + b )
                     = w^2*p^2 / (p^4 + 2*p^2 + 1 + (p^3 + p)a*w + b*w^2*p^2)
                     = w^2*p^2 / (p^4 + a*w*p^3 + (2+b*w^2)*p^2 + a*w*p + 1)
</pre>

<p>
This 4th order transfer function shall be split in to two transfer functions of order 2 each
for numerical reasons. With the following formulation, the fourth order
polynomial can be represented (with the unknowns \"c\" and \"alpha\"):
</p>

<pre>
  g(p) = w^2*p^2 / ( (p*alpha)^2 + c*(p*alpha) + 1) * (p/alpha)^2 + c*(p/alpha) + 1)
       = w^2*p^2 / ( p^4 + c*(alpha + 1/alpha)*p^3 + (alpha^2 + 1/alpha^2 + c^2)*p^2
                                                   + c*(alpha + 1/alpha)*p + 1 )
</pre>

<p>
Comparison of coefficients:
</p>

<pre>
  c*(alpha + 1/alpha) = a*w           -> c = a*w / (alpha + 1/alpha)
  alpha^2 + 1/alpha^2 + c^2 = 2+b*w^2 -> equation to determine alpha

  alpha^4 + 1 + a^2*w^2*alpha^4/(1+alpha^2)^2 = (2+b*w^2)*alpha^2
    or z = alpha^2
  z^2 + a^2*w^2*z^2/(1+z)^2 - (2+b*w^2)*z + 1 = 0
</pre>

<p>
Therefore the last equation has to be solved for \"z\" (basically, this means to compute
a real zero of a fourth order polynomal):
</p>

<pre>
   solve: 0 = f(z)  = z^2 + a^2*w^2*z^2/(1+z)^2 - (2+b*w^2)*z + 1  for \"z\"
              f(0)  = 1  &gt; 0
              f(1)  = 1 + a^2*w^2/4 - (2+b*w^2) + 1
                    = (a^2/4 - b)*w^2  &lt; 0
                    // since b - a^2/4 > 0 requirement for complex conjugate poles
   -> 0 &lt; z &lt; 1
</pre>

<p>
This function computes the solution of this equation and returns \"alpha = sqrt(z)\";
</p>

</html>"));
            end bandPassAlpha;
          end Utilities;
        end Filter;
      end Internal;
      annotation (
        Documentation(info="<html>
<p>
This package contains basic <b>continuous</b> input/output blocks
described by differential equations.
</p>

<p>
All blocks of this package can be initialized in different
ways controlled by parameter <b>initType</b>. The possible
values of initType are defined in
<a href=\"modelica://Modelica.Blocks.Types.Init\">Modelica.Blocks.Types.Init</a>:
</p>

<table border=1 cellspacing=0 cellpadding=2>
  <tr><td valign=\"top\"><b>Name</b></td>
      <td valign=\"top\"><b>Description</b></td></tr>

  <tr><td valign=\"top\"><b>Init.NoInit</b></td>
      <td valign=\"top\">no initialization (start values are used as guess values with fixed=false)</td></tr>

  <tr><td valign=\"top\"><b>Init.SteadyState</b></td>
      <td valign=\"top\">steady state initialization (derivatives of states are zero)</td></tr>

  <tr><td valign=\"top\"><b>Init.InitialState</b></td>
      <td valign=\"top\">Initialization with initial states</td></tr>

  <tr><td valign=\"top\"><b>Init.InitialOutput</b></td>
      <td valign=\"top\">Initialization with initial outputs (and steady state of the states if possibles)</td></tr>
</table>

<p>
For backward compatibility reasons the default of all blocks is
<b>Init.NoInit</b>, with the exception of Integrator and LimIntegrator
where the default is <b>Init.InitialState</b> (this was the initialization
defined in version 2.2 of the Modelica standard library).
</p>

<p>
In many cases, the most useful initial condition is
<b>Init.SteadyState</b> because initial transients are then no longer
present. The drawback is that in combination with a non-linear
plant, non-linear algebraic equations occur that might be
difficult to solve if appropriate guess values for the
iteration variables are not provided (i.e., start values with fixed=false).
However, it is often already useful to just initialize
the linear blocks from the Continuous blocks library in SteadyState.
This is uncritical, because only linear algebraic equations occur.
If Init.NoInit is set, then the start values for the states are
interpreted as <b>guess</b> values and are propagated to the
states with fixed=<b>false</b>.
</p>

<p>
Note, initialization with Init.SteadyState is usually difficult
for a block that contains an integrator
(Integrator, LimIntegrator, PI, PID, LimPID).
This is due to the basic equation of an integrator:
</p>

<pre>
  <b>initial equation</b>
     <b>der</b>(y) = 0;   // Init.SteadyState
  <b>equation</b>
     <b>der</b>(y) = k*u;
</pre>

<p>
The steady state equation leads to the condition that the input to the
integrator is zero. If the input u is already (directly or indirectly) defined
by another initial condition, then the initialization problem is <b>singular</b>
(has none or infinitely many solutions). This situation occurs often
for mechanical systems, where, e.g., u = desiredSpeed - measuredSpeed and
since speed is both a state and a derivative, it is always defined by
Init.InitialState or Init.SteadyState initializtion.
</p>

<p>
In such a case, <b>Init.NoInit</b> has to be selected for the integrator
and an additional initial equation has to be added to the system
to which the integrator is connected. E.g., useful initial conditions
for a 1-dim. rotational inertia controlled by a PI controller are that
<b>angle</b>, <b>speed</b>, and <b>acceleration</b> of the inertia are zero.
</p>

</html>
"));
    end Continuous;

    package Interfaces
    "Library of connectors and partial models for input/output blocks"
      import Modelica.SIunits;
        extends Modelica.Icons.InterfacesPackage;

    connector RealInput = input Real "'input Real' as connector"
      annotation (defaultComponentName="u",
      Icon(graphics={Polygon(
              points={{-100,100},{100,0},{-100,-100},{-100,100}},
              lineColor={0,0,127},
              fillColor={0,0,127},
              fillPattern=FillPattern.Solid)},
           coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true, initialScale=0.2)),
      Diagram(coordinateSystem(
            preserveAspectRatio=true, initialScale=0.2,
            extent={{-100,-100},{100,100}},
            grid={1,1}), graphics={Polygon(
              points={{0,50},{100,0},{0,-50},{0,50}},
              lineColor={0,0,127},
              fillColor={0,0,127},
              fillPattern=FillPattern.Solid), Text(
              extent={{-10,85},{-10,60}},
              lineColor={0,0,127},
              textString="%name")}),
        Documentation(info="<html>
<p>
Connector with one input signal of type Real.
</p>
</html>"));

    connector RealOutput = output Real "'output Real' as connector"
      annotation (defaultComponentName="y",
      Icon(coordinateSystem(
            preserveAspectRatio=true,
            extent={{-100,-100},{100,100}},
            grid={1,1}), graphics={Polygon(
              points={{-100,100},{100,0},{-100,-100},{-100,100}},
              lineColor={0,0,127},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid)}),
      Diagram(coordinateSystem(
            preserveAspectRatio=true,
            extent={{-100,-100},{100,100}},
            grid={1,1}), graphics={Polygon(
              points={{-100,50},{0,0},{-100,-50},{-100,50}},
              lineColor={0,0,127},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid), Text(
              extent={{30,110},{30,60}},
              lineColor={0,0,127},
              textString="%name")}),
        Documentation(info="<html>
<p>
Connector with one output signal of type Real.
</p>
</html>"));

    connector BooleanInput = input Boolean "'input Boolean' as connector"
      annotation (defaultComponentName="u",
           Icon(graphics={Polygon(
              points={{-100,100},{100,0},{-100,-100},{-100,100}},
              lineColor={255,0,255},
              fillColor={255,0,255},
              fillPattern=FillPattern.Solid)},
                coordinateSystem(extent={{-100,-100},{100,100}},
            preserveAspectRatio=true, initialScale=0.2)),    Diagram(coordinateSystem(
            preserveAspectRatio=true, initialScale=0.2,
            extent={{-100,-100},{100,100}},
            grid={1,1}), graphics={Polygon(
              points={{0,50},{100,0},{0,-50},{0,50}},
              lineColor={255,0,255},
              fillColor={255,0,255},
              fillPattern=FillPattern.Solid), Text(
              extent={{-10,85},{-10,60}},
              lineColor={255,0,255},
              textString="%name")}),
        Documentation(info="<html>
<p>
Connector with one input signal of type Boolean.
</p>
</html>"));

    connector BooleanOutput = output Boolean "'output Boolean' as connector"
                                      annotation (defaultComponentName="y",
      Icon(coordinateSystem(
            preserveAspectRatio=true,
            extent={{-100,-100},{100,100}},
            grid={1,1}), graphics={Polygon(
              points={{-100,100},{100,0},{-100,-100},{-100,100}},
              lineColor={255,0,255},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid)}),
      Diagram(coordinateSystem(
            preserveAspectRatio=true,
            extent={{-100,-100},{100,100}},
            grid={1,1}), graphics={Polygon(
              points={{-100,50},{0,0},{-100,-50},{-100,50}},
              lineColor={255,0,255},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid), Text(
              extent={{30,110},{30,60}},
              lineColor={255,0,255},
              textString="%name")}),
        Documentation(info="<html>
<p>
Connector with one output signal of type Boolean.
</p>
</html>"));

        partial block BlockIcon "Basic graphical layout of input/output block"

          annotation (
            Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                  100,100}}), graphics={Rectangle(
                extent={{-100,-100},{100,100}},
                lineColor={0,0,127},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid), Text(
                extent={{-150,150},{150,110}},
                textString="%name",
                lineColor={0,0,255})}),
          Documentation(info="<html>
<p>
Block that has only the basic icon for an input/output
block (no declarations, no equations). Most blocks
of package Modelica.Blocks inherit directly or indirectly
from this block.
</p>
</html>"));

        end BlockIcon;

        partial block SO "Single Output continuous control block"
          extends BlockIcon;

          RealOutput y "Connector of Real output signal"
            annotation (Placement(transformation(extent={{100,-10},{120,10}},
                rotation=0)));
          annotation (
            Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics),
          Documentation(info="<html>
<p>
Block has one continuous Real output signal.
</p>
</html>"));

        end SO;

        partial block SISO
      "Single Input Single Output continuous control block"
          extends BlockIcon;

          RealInput u "Connector of Real input signal"
            annotation (Placement(transformation(extent={{-140,-20},{-100,20}},
                rotation=0)));
          RealOutput y "Connector of Real output signal"
            annotation (Placement(transformation(extent={{100,-10},{120,10}},
                rotation=0)));
          annotation (
          Documentation(info="<html>
<p>
Block has one continuous Real input and one continuous Real output signal.
</p>
</html>"));
        end SISO;

        partial block SI2SO
      "2 Single Input / 1 Single Output continuous control block"
          extends BlockIcon;

          RealInput u1 "Connector of Real input signal 1"
            annotation (Placement(transformation(extent={{-140,40},{-100,80}},
                rotation=0)));
          RealInput u2 "Connector of Real input signal 2"
            annotation (Placement(transformation(extent={{-140,-80},{-100,-40}},
                rotation=0)));
          RealOutput y "Connector of Real output signal"
            annotation (Placement(transformation(extent={{100,-10},{120,10}},
                rotation=0)));

          annotation (
            Documentation(info="<html>
<p>
Block has two continuous Real input signals u1 and u2 and one
continuous Real output signal y.
</p>
</html>"),  Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics));

        end SI2SO;

        partial block MISO
      "Multiple Input Single Output continuous control block"

          extends BlockIcon;
          parameter Integer nin=1 "Number of inputs";
          RealInput u[nin] "Connector of Real input signals"
            annotation (Placement(transformation(extent={{-140,-20},{-100,20}},
                rotation=0)));
          RealOutput y "Connector of Real output signal"
            annotation (Placement(transformation(extent={{100,-10},{120,10}},
                rotation=0)));
          annotation (Documentation(info="<HTML>
<p>
Block has a vector of continuous Real input signals and
one continuous Real output signal.
</p>
</HTML>
"));
        end MISO;

        partial block SVcontrol "Single-Variable continuous controller"
          extends BlockIcon;

          RealInput u_s "Connector of setpoint input signal"
            annotation (Placement(transformation(extent={{-140,-20},{-100,20}},
                rotation=0)));
          RealInput u_m "Connector of measurement input signal"
            annotation (Placement(transformation(
              origin={0,-120},
              extent={{20,-20},{-20,20}},
              rotation=270)));
          RealOutput y "Connector of actuator output signal"
            annotation (Placement(transformation(extent={{100,-10},{120,10}},
                rotation=0)));
          annotation (
            Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={
              Text(
                extent={{-102,34},{-142,24}},
                textString="(setpoint)",
                lineColor={0,0,255}),
              Text(
                extent={{100,24},{140,14}},
                textString="(actuator)",
                lineColor={0,0,255}),
              Text(
                extent={{-83,-112},{-33,-102}},
                textString=" (measurement)",
                lineColor={0,0,255})}),
          Documentation(info="<html>
<p>
Block has two continuous Real input signals and one
continuous Real output signal. The block is designed
to be used as base class for a corresponding controller.
</p>
</html>"));
        end SVcontrol;

        partial block DiscreteBlockIcon
      "Graphical layout of discrete block component icon"

          annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}), graphics={Rectangle(
                extent={{-100,-100},{100,100}},
                lineColor={0,0,127},
                fillColor={223,223,159},
                fillPattern=FillPattern.Solid), Text(
                extent={{-150,150},{150,110}},
                textString="%name",
                lineColor={0,0,255})}),
                               Documentation(info="<html>
<p>
Block that has only the basic icon for an input/output,
discrete block (no declarations, no equations), e.g.,
from Blocks.Discrete.
</p>
</html>"));
        end DiscreteBlockIcon;

        partial block DiscreteBlock "Base class of discrete control blocks"
          extends DiscreteBlockIcon;

          parameter SI.Time samplePeriod(min=100*Modelica.Constants.eps, start = 0.1)
        "Sample period of component";
          parameter SI.Time startTime=0 "First sample time instant";
    protected
          output Boolean sampleTrigger "True, if sample time instant";
          output Boolean firstTrigger
        "Rising edge signals first sample instant";
        equation
          sampleTrigger = sample(startTime, samplePeriod);
          when sampleTrigger then
            firstTrigger = time <= startTime + samplePeriod/2;
          end when;
        annotation (Documentation(info="<html>
<p>
Basic definitions of a discrete block of library
Blocks.Discrete.
</p>
</html>"));
        end DiscreteBlock;

      partial block partialBooleanBlockIcon
      "Basic graphical layout of logical block"

        annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}), graphics={Rectangle(
                extent={{-100,100},{100,-100}},
                lineColor={0,0,0},
                fillColor={210,210,210},
                fillPattern=FillPattern.Solid,
                borderPattern=BorderPattern.Raised), Text(
                extent={{-150,150},{150,110}},
                textString="%name",
                lineColor={0,0,255})}),                        Documentation(info="<html>
<p>
Block that has only the basic icon for an input/output,
Boolean block (no declarations, no equations) used especially
in the Blocks.Logical library.
</p>
</html>"));
      end partialBooleanBlockIcon;
        annotation (
          Documentation(info="<HTML>
<p>
This package contains interface definitions for
<b>continuous</b> input/output blocks with Real,
Integer and Boolean signals. Furthermore, it contains
partial models for continuous and discrete blocks.
</p>

</HTML>
",     revisions="<html>
<ul>
<li><i>Oct. 21, 2002</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>
       and <a href=\"http://www.robotic.dlr.de/Christian.Schweiger/\">Christian Schweiger</a>:<br>
       Added several new interfaces. <a href=\"modelica://Modelica/Documentation/ChangeNotes1.5.html\">Detailed description</a> available.
<li><i>Oct. 24, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       RealInputSignal renamed to RealInput. RealOutputSignal renamed to
       output RealOutput. GraphBlock renamed to BlockIcon. SISOreal renamed to
       SISO. SOreal renamed to SO. I2SOreal renamed to M2SO.
       SignalGenerator renamed to SignalSource. Introduced the following
       new models: MIMO, MIMOs, SVcontrol, MVcontrol, DiscreteBlockIcon,
       DiscreteBlock, DiscreteSISO, DiscreteMIMO, DiscreteMIMOs,
       BooleanBlockIcon, BooleanSISO, BooleanSignalSource, MI2BooleanMOs.</li>
<li><i>June 30, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Realized a first version, based on an existing Dymola library
       of Dieter Moormann and Hilding Elmqvist.</li>
</ul>
</html>
"));
    end Interfaces;

    package Logical
    "Library of components with Boolean input and output signals"
        extends Modelica.Icons.Package;

      block Switch "Switch between two Real signals"
        extends Blocks.Interfaces.partialBooleanBlockIcon;
        Blocks.Interfaces.RealInput u1 "Connector of first Real input signal"
                                       annotation (Placement(transformation(extent=
                  {{-140,60},{-100,100}}, rotation=0)));
        Blocks.Interfaces.BooleanInput u2 "Connector of Boolean input signal"
                                          annotation (Placement(transformation(
                extent={{-140,-20},{-100,20}}, rotation=0)));
        Blocks.Interfaces.RealInput u3 "Connector of second Real input signal"
                                       annotation (Placement(transformation(extent=
                  {{-140,-100},{-100,-60}}, rotation=0)));
        Blocks.Interfaces.RealOutput y "Connector of Real output signal"
                                       annotation (Placement(transformation(extent=
                  {{100,-10},{120,10}}, rotation=0)));

      equation
        y = if u2 then u1 else u3;
        annotation (defaultComponentName="switch1",
          Documentation(info="<html>
<p>The Logical.Switch switches, depending on the
logical connector u2 (the middle connector)
between the two possible input signals
u1 (upper connector) and u3 (lower connector).</p>
<p>If u2 is <b>true</b>, the output signal y is set equal to
u1, else it is set equal to u3.</p>
</html>
"),       Icon(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={
              Line(
                points={{12,0},{100,0}},
                pattern=LinePattern.Solid,
                thickness=0.25,
                arrow={Arrow.None,Arrow.None},
                color={0,0,255}),
              Line(
                points={{-100,0},{-40,0}},
                color={255,0,127},
                pattern=LinePattern.Solid,
                thickness=0.25,
                arrow={Arrow.None,Arrow.None}),
              Line(
                points={{-100,-80},{-40,-80},{-40,-80}},
                pattern=LinePattern.Solid,
                thickness=0.25,
                arrow={Arrow.None,Arrow.None},
                color={0,0,255}),
              Line(points={{-40,12},{-40,-12}}, color={255,0,127}),
              Line(points={{-100,80},{-38,80}}, color={0,0,255}),
              Line(
                points={{-38,80},{6,2}},
                thickness=1,
                color={0,0,255}),
              Ellipse(
                extent={{2,8},{18,-6}},
                fillColor={0,0,0},
                fillPattern=FillPattern.Solid,
                lineColor={0,0,255})}),
          Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics));
      end Switch;
      annotation(Documentation(info="<html>
<p>
This package provides blocks with Boolean input and output signals
to describe logical networks. A typical example for a logical
network built with package Logical is shown in the next figure:
</p>

<img src=\"modelica://Modelica/Resources/Images/Blocks/LogicalNetwork1.png\">

<p>
The actual value of Boolean input and/or output signals is displayed
in the respective block icon as \"circle\", where \"white\" color means
value <b>false</b> and \"green\" color means value <b>true</b>. These
values are visualized in a diagram animation.
</p>
</html>"));
    end Logical;

    package Math
    "Library of Real mathematical functions as input/output blocks"
      import Modelica.SIunits;
      import Modelica.Blocks.Interfaces;
      extends Modelica.Icons.Package;

          block Gain "Output the product of a gain value with the input signal"

            parameter Real k(start=1, unit="1")
        "Gain value multiplied with input signal";
    public
            Interfaces.RealInput u "Input signal connector"
              annotation (Placement(transformation(extent={{-140,-20},{-100,20}},
                rotation=0)));
            Interfaces.RealOutput y "Output signal connector"
              annotation (Placement(transformation(extent={{100,-10},{120,10}},
                rotation=0)));

          equation
            y = k*u;
            annotation (
              Documentation(info="
<HTML>
<p>
This block computes output <i>y</i> as
<i>product</i> of gain <i>k</i> with the
input <i>u</i>:
</p>
<pre>
    y = k * u;
</pre>

</HTML>
"),           Icon(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={
              Polygon(
                points={{-100,-100},{-100,100},{100,0},{-100,-100}},
                lineColor={0,0,127},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Text(
                extent={{-150,-140},{150,-100}},
                lineColor={0,0,0},
                textString="k=%k"),
              Text(
                extent={{-150,140},{150,100}},
                textString="%name",
                lineColor={0,0,255})}),
              Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={Polygon(
                points={{-100,-100},{-100,100},{100,0},{-100,-100}},
                lineColor={0,0,127},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid), Text(
                extent={{-76,38},{0,-34}},
                textString="k",
                lineColor={0,0,255})}));
          end Gain;

          block Sum "Output the sum of the elements of the input vector"
            extends Interfaces.MISO;
            parameter Real k[nin]=ones(nin) "Optional: sum coefficients";
          equation
            y = k*u;
            annotation (defaultComponentName="sum1",
              Documentation(info="
<HTML>
<p>
This blocks computes output <b>y</b> as
<i>sum</i> of the elements of the input signal vector
<b>u</b>:
</p>
<pre>
    <b>y</b> = <b>u</b>[1] + <b>u</b>[2] + ...;
</pre>
<p>
Example:
</p>
<pre>
     parameter:   nin = 3;

  results in the following equations:

     y = u[1] + u[2] + u[3];
</pre>

</HTML>
"),           Icon(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={Line(
                points={{26,42},{-34,42},{6,2},{-34,-38},{26,-38}},
                color={0,0,0},
                thickness=0.25), Text(
                extent={{-150,150},{150,110}},
                textString="%name",
                lineColor={0,0,255})}),
              Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={Rectangle(
                extent={{-100,-100},{100,100}},
                lineColor={0,0,255},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid), Line(
                points={{26,42},{-34,42},{6,2},{-34,-38},{26,-38}},
                color={0,0,0},
                thickness=0.25)}));
          end Sum;

          block Feedback
      "Output difference between commanded and feedback input"

            input Interfaces.RealInput u1 annotation (Placement(transformation(
                extent={{-100,-20},{-60,20}}, rotation=0)));
            input Interfaces.RealInput u2
              annotation (Placement(transformation(
              origin={0,-80},
              extent={{-20,-20},{20,20}},
              rotation=90)));
            output Interfaces.RealOutput y annotation (Placement(transformation(
                extent={{80,-10},{100,10}}, rotation=0)));

          equation
            y = u1 - u2;
            annotation (
              Documentation(info="
<HTML>
<p>
This blocks computes output <b>y</b> as <i>difference</i> of the
commanded input <b>u1</b> and the feedback
input <b>u2</b>:
</p>
<pre>
    <b>y</b> = <b>u1</b> - <b>u2</b>;
</pre>
<p>
Example:
</p>
<pre>
     parameter:   n = 2

  results in the following equations:

     y = u1 - u2
</pre>

</HTML>
"),           Icon(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={
              Ellipse(
                extent={{-20,20},{20,-20}},
                lineColor={0,0,127},
                fillColor={235,235,235},
                fillPattern=FillPattern.Solid),
              Line(points={{-60,0},{-20,0}}, color={0,0,127}),
              Line(points={{20,0},{80,0}}, color={0,0,127}),
              Line(points={{0,-20},{0,-60}}, color={0,0,127}),
              Text(
                extent={{-14,0},{82,-94}},
                lineColor={0,0,0},
                textString="-"),
              Text(
                extent={{-150,94},{150,44}},
                textString="%name",
                lineColor={0,0,255})}),
              Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={
              Ellipse(
                extent={{-20,20},{20,-20}},
                pattern=LinePattern.Solid,
                lineThickness=0.25,
                fillColor={235,235,235},
                fillPattern=FillPattern.Solid,
                lineColor={0,0,255}),
              Line(points={{-60,0},{-20,0}}, color={0,0,255}),
              Line(points={{20,0},{80,0}}, color={0,0,255}),
              Line(points={{0,-20},{0,-60}}, color={0,0,255}),
              Text(
                extent={{-12,10},{84,-84}},
                lineColor={0,0,0},
                textString="-")}));
          end Feedback;

          block Add
      "Output the sum of the two inputs (this is an obsolet block. Use instead MultiSum)"
            extends Interfaces.SI2SO;
            parameter Real k1=+1 "Gain of upper input";
            parameter Real k2=+1 "Gain of lower input";

          equation
            y = k1*u1 + k2*u2;
            annotation (
              Documentation(info="
<HTML>
<p>
This blocks computes output <b>y</b> as <i>sum</i> of the
two input signals <b>u1</b> and <b>u2</b>:
</p>
<pre>
    <b>y</b> = k1*<b>u1</b> + k2*<b>u2</b>;
</pre>
<p>
Example:
</p>
<pre>
     parameter:   k1= +2, k2= -3

  results in the following equations:

     y = 2 * u1 - 3 * u2
</pre>

</HTML>
"),           Icon(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={
              Text(
                extent={{-98,-52},{7,-92}},
                lineColor={0,0,0},
                textString="%k2"),
              Text(
                extent={{-100,90},{5,50}},
                lineColor={0,0,0},
                textString="%k1"),
              Text(
                extent={{-150,150},{150,110}},
                textString="%name",
                lineColor={0,0,255}),
              Line(points={{-100,60},{-40,60},{-30,40}}, color={0,0,255}),
              Ellipse(extent={{-50,50},{50,-50}}, lineColor={0,0,255}),
              Line(points={{-100,-60},{-40,-60},{-30,-40}}, color={0,0,255}),
              Line(points={{-15,-25.99},{15,25.99}}, color={0,0,0}),
              Rectangle(
                extent={{-100,-100},{100,100}},
                lineColor={0,0,127},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Line(points={{50,0},{100,0}}, color={0,0,255}),
              Line(points={{-100,60},{-74,24},{-44,24}}, color={0,0,127}),
              Line(points={{-100,-60},{-74,-28},{-42,-28}}, color={0,0,127}),
              Ellipse(extent={{-50,50},{50,-50}}, lineColor={0,0,127}),
              Line(points={{50,0},{100,0}}, color={0,0,127}),
              Text(
                extent={{-38,34},{38,-34}},
                lineColor={0,0,0},
                textString="+"),
              Text(
                extent={{-100,52},{5,92}},
                lineColor={0,0,0},
                textString="%k1"),
              Text(
                extent={{-100,-52},{5,-92}},
                lineColor={0,0,0},
                textString="%k2")}),
              Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={
              Rectangle(
                extent={{-100,-100},{100,100}},
                lineColor={0,0,255},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Text(
                extent={{-98,-52},{7,-92}},
                lineColor={0,0,0},
                textString="%k2"),
              Text(
                extent={{-100,90},{5,50}},
                lineColor={0,0,0},
                textString="%k1"),
              Line(points={{-100,60},{-40,60},{-30,40}}, color={0,0,255}),
              Ellipse(extent={{-50,50},{50,-50}}, lineColor={0,0,255}),
              Line(points={{-100,-60},{-40,-60},{-30,-40}}, color={0,0,255}),
              Line(points={{-15,-25.99},{15,25.99}}, color={0,0,0}),
              Rectangle(
                extent={{-100,-100},{100,100}},
                lineColor={0,0,127},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Line(points={{50,0},{100,0}}, color={0,0,255}),
              Line(points={{-100,60},{-74,24},{-44,24}}, color={0,0,127}),
              Line(points={{-100,-60},{-74,-28},{-42,-28}}, color={0,0,127}),
              Ellipse(extent={{-50,50},{50,-50}}, lineColor={0,0,127}),
              Line(points={{50,0},{100,0}}, color={0,0,127}),
              Text(
                extent={{-38,34},{38,-34}},
                lineColor={0,0,0},
                textString="+"),
              Text(
                extent={{-100,52},{5,92}},
                lineColor={0,0,0},
                textString="k1"),
              Text(
                extent={{-100,-52},{5,-92}},
                lineColor={0,0,0},
                textString="k2")}));
          end Add;

          block Add3
      "Output the sum of the three inputs (this is an obsolet block. Use instead MultiSum)"
            extends Interfaces.BlockIcon;

            parameter Real k1=+1 "Gain of upper input";
            parameter Real k2=+1 "Gain of middle input";
            parameter Real k3=+1 "Gain of lower input";
            input Interfaces.RealInput u1 "Connector 1 of Real input signals"
              annotation (Placement(transformation(extent={{-140,60},{-100,100}},
                rotation=0)));
            input Interfaces.RealInput u2 "Connector 2 of Real input signals"
              annotation (Placement(transformation(extent={{-140,-20},{-100,20}},
                rotation=0)));
            input Interfaces.RealInput u3 "Connector 3 of Real input signals"
              annotation (Placement(transformation(extent={{-140,-100},{-100,-60}},
                rotation=0)));
            output Interfaces.RealOutput y "Connector of Real output signals"
              annotation (Placement(transformation(extent={{100,-10},{120,10}},
                rotation=0)));

          equation
            y = k1*u1 + k2*u2 + k3*u3;
            annotation (
              Documentation(info="
<HTML>
<p>
This blocks computes output <b>y</b> as <i>sum</i> of the
three input signals <b>u1</b>, <b>u2</b> and <b>u3</b>:
</p>
<pre>
    <b>y</b> = k1*<b>u1</b> + k2*<b>u2</b> + k3*<b>u3</b>;
</pre>
<p>
Example:
</p>
<pre>
     parameter:   k1= +2, k2= -3, k3=1;

  results in the following equations:

     y = 2 * u1 - 3 * u2 + u3;
</pre>

</HTML>
"),           Icon(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={
              Text(
                extent={{-100,50},{5,90}},
                lineColor={0,0,0},
                textString="%k1"),
              Text(
                extent={{-100,-20},{5,20}},
                lineColor={0,0,0},
                textString="%k2"),
              Text(
                extent={{-100,-50},{5,-90}},
                lineColor={0,0,0},
                textString="%k3"),
              Text(
                extent={{2,36},{100,-44}},
                lineColor={0,0,0},
                textString="+")}),
              Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={
              Rectangle(
                extent={{-100,-100},{100,100}},
                lineColor={0,0,255},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Text(
                extent={{-100,50},{5,90}},
                lineColor={0,0,0},
                textString="%k1"),
              Text(
                extent={{-100,-20},{5,20}},
                lineColor={0,0,0},
                textString="%k2"),
              Text(
                extent={{-100,-50},{5,-90}},
                lineColor={0,0,0},
                textString="%k3"),
              Text(
                extent={{2,36},{100,-44}},
                lineColor={0,0,0},
                textString="+"),
              Rectangle(
                extent={{-100,-100},{100,100}},
                lineColor={0,0,255},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Text(
                extent={{-100,50},{5,90}},
                lineColor={0,0,0},
                textString="k1"),
              Text(
                extent={{-100,-20},{5,20}},
                lineColor={0,0,0},
                textString="k2"),
              Text(
                extent={{-100,-50},{5,-90}},
                lineColor={0,0,0},
                textString="k3"),
              Text(
                extent={{2,36},{100,-44}},
                lineColor={0,0,0},
                textString="+")}));
          end Add3;

          block Product
      "Output product of the two inputs (this is an obsolet block. Use instead MultiProduct)"
            extends Interfaces.SI2SO;

          equation
            y = u1*u2;
            annotation (defaultComponentName="product1",
              Documentation(info="
<HTML>
<p>
This blocks computes the output <b>y</b> (element-wise)
as <i>product</i> of the corresponding elements of
the two inputs <b>u1</b> and <b>u2</b>:
</p>
<pre>
    y = u1 * u2;
</pre>

</HTML>
"),           Icon(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={
              Line(points={{-100,60},{-40,60},{-30,40}}, color={0,0,127}),
              Line(points={{-100,-60},{-40,-60},{-30,-40}}, color={0,0,127}),
              Line(points={{50,0},{100,0}}, color={0,0,127}),
              Line(points={{-30,0},{30,0}}, color={0,0,0}),
              Line(points={{-15,25.99},{15,-25.99}}, color={0,0,0}),
              Line(points={{-15,-25.99},{15,25.99}}, color={0,0,0}),
              Ellipse(extent={{-50,50},{50,-50}}, lineColor={0,0,127})}),
              Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={
              Rectangle(
                extent={{-100,-100},{100,100}},
                lineColor={0,0,255},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Line(points={{-100,60},{-40,60},{-30,40}}, color={0,0,255}),
              Line(points={{-100,-60},{-40,-60},{-30,-40}}, color={0,0,255}),
              Line(points={{50,0},{100,0}}, color={0,0,255}),
              Line(points={{-30,0},{30,0}}, color={0,0,0}),
              Line(points={{-15,25.99},{15,-25.99}}, color={0,0,0}),
              Line(points={{-15,-25.99},{15,25.99}}, color={0,0,0}),
              Ellipse(extent={{-50,50},{50,-50}}, lineColor={0,0,255})}));
          end Product;
      annotation (
        Documentation(info="
<HTML>
<p>
This package contains basic <b>mathematical operations</b>,
such as summation and multiplication, and basic <b>mathematical
functions</b>, such as <b>sqrt</b> and <b>sin</b>, as
input/output blocks. All blocks of this library can be either
connected with continuous blocks or with sampled-data blocks.
</p>
</HTML>
",     revisions="<html>
<ul>
<li><i>October 21, 2002</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>
       and <a href=\"http://www.robotic.dlr.de/Christian.Schweiger/\">Christian Schweiger</a>:<br>
       New blocks added: RealToInteger, IntegerToReal, Max, Min, Edge, BooleanChange, IntegerChange.</li>
<li><i>August 7, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Realized (partly based on an existing Dymola library
       of Dieter Moormann and Hilding Elmqvist).
</li>
</ul>
</html>"));
    end Math;

    package Nonlinear
    "Library of discontinuous or non-differentiable algebraic control blocks"
      import Modelica.Blocks.Interfaces;
      extends Modelica.Icons.Package;

          block Limiter "Limit the range of a signal"
            parameter Real uMax(start=1) "Upper limits of input signals";
            parameter Real uMin= -uMax "Lower limits of input signals";
            parameter Boolean limitsAtInit = true
        "= false, if limits are ignored during initializiation (i.e., y=u)";
            extends Interfaces.SISO;

          equation
            assert(uMax >= uMin, "Limiter: Limits must be consistent. However, uMax (=" + String(uMax) +
                                 ") < uMin (=" + String(uMin) + ")");
            if initial() and not limitsAtInit then
               y = u;
               assert(u >= uMin - 0.01*abs(uMin) and
                      u <= uMax + 0.01*abs(uMax),
                     "Limiter: During initialization the limits have been ignored.\n"+
                     "However, the result is that the input u is not within the required limits:\n"+
                     "  u = " + String(u) + ", uMin = " + String(uMin) + ", uMax = " + String(uMax));
            else
               y = smooth(0,if u > uMax then uMax else if u < uMin then uMin else u);
            end if;
            annotation (
              Documentation(info="
<HTML>
<p>
The Limiter block passes its input signal as output signal
as long as the input is within the specified upper and lower
limits. If this is not the case, the corresponding limits are passed
as output.
</p>
</HTML>
"),           Icon(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={
              Line(points={{0,-90},{0,68}}, color={192,192,192}),
              Polygon(
                points={{0,90},{-8,68},{8,68},{0,90}},
                lineColor={192,192,192},
                fillColor={192,192,192},
                fillPattern=FillPattern.Solid),
              Line(points={{-90,0},{68,0}}, color={192,192,192}),
              Polygon(
                points={{90,0},{68,-8},{68,8},{90,0}},
                lineColor={192,192,192},
                fillColor={192,192,192},
                fillPattern=FillPattern.Solid),
              Line(points={{-80,-70},{-50,-70},{50,70},{80,70}}, color={0,0,0}),
              Text(
                extent={{-150,-150},{150,-110}},
                lineColor={0,0,0},
                textString="uMax=%uMax"),
              Text(
                extent={{-150,150},{150,110}},
                textString="%name",
                lineColor={0,0,255})}),
              Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={
              Line(points={{0,-60},{0,50}}, color={192,192,192}),
              Polygon(
                points={{0,60},{-5,50},{5,50},{0,60}},
                lineColor={192,192,192},
                fillColor={192,192,192},
                fillPattern=FillPattern.Solid),
              Line(points={{-60,0},{50,0}}, color={192,192,192}),
              Polygon(
                points={{60,0},{50,-5},{50,5},{60,0}},
                lineColor={192,192,192},
                fillColor={192,192,192},
                fillPattern=FillPattern.Solid),
              Line(points={{-50,-40},{-30,-40},{30,40},{50,40}}, color={0,0,0}),
              Text(
                extent={{46,-6},{68,-18}},
                lineColor={128,128,128},
                textString="u"),
              Text(
                extent={{-30,70},{-5,50}},
                lineColor={128,128,128},
                textString="y"),
              Text(
                extent={{-58,-54},{-28,-42}},
                lineColor={128,128,128},
                textString="uMin"),
              Text(
                extent={{26,40},{66,56}},
                lineColor={128,128,128},
                textString="uMax")}));
          end Limiter;
          annotation (
            Documentation(info="
<HTML>
<p>
This package contains <b>discontinuous</b> and
<b>non-differentiable, algebraic</b> input/output blocks.
</p>
</HTML>
",     revisions="<html>
<ul>
<li><i>October 21, 2002</i>
       by <a href=\"http://www.robotic.dlr.de/Christian.Schweiger/\">Christian Schweiger</a>:<br>
       New block VariableLimiter added.
<li><i>August 22, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Realized, based on an existing Dymola library
       of Dieter Moormann and Hilding Elmqvist.
</li>
</ul>
</html>
"));
    end Nonlinear;

    package Routing "Library of blocks to combine and extract signals"
      extends Modelica.Icons.Package;

      block Multiplex5 "Multiplexer block for five input connectors"
        extends Modelica.Blocks.Interfaces.BlockIcon;
        parameter Integer n1=1 "dimension of input signal connector 1";
        parameter Integer n2=1 "dimension of input signal connector 2";
        parameter Integer n3=1 "dimension of input signal connector 3";
        parameter Integer n4=1 "dimension of input signal connector 4";
        parameter Integer n5=1 "dimension of input signal connector 5";
        Modelica.Blocks.Interfaces.RealInput u1[n1]
        "Connector of Real input signals 1"   annotation (Placement(transformation(
                extent={{-140,80},{-100,120}}, rotation=0)));
        Modelica.Blocks.Interfaces.RealInput u2[n2]
        "Connector of Real input signals 2"   annotation (Placement(transformation(
                extent={{-140,30},{-100,70}}, rotation=0)));
        Modelica.Blocks.Interfaces.RealInput u3[n3]
        "Connector of Real input signals 3"   annotation (Placement(transformation(
                extent={{-140,-20},{-100,20}}, rotation=0)));
        Modelica.Blocks.Interfaces.RealInput u4[n4]
        "Connector of Real input signals 4"   annotation (Placement(transformation(
                extent={{-140,-70},{-100,-30}}, rotation=0)));
        Modelica.Blocks.Interfaces.RealInput u5[n5]
        "Connector of Real input signals 5"   annotation (Placement(transformation(
                extent={{-140,-120},{-100,-80}}, rotation=0)));
        Modelica.Blocks.Interfaces.RealOutput y[n1 + n2 + n3 + n4 + n5]
        "Connector of Real output signals"   annotation (Placement(transformation(
                extent={{100,-10},{120,10}}, rotation=0)));

      equation
        [y] = [u1; u2; u3; u4; u5];
        annotation (
          Documentation(info="<HTML>
<p>
The output connector is the <b>concatenation</b> of the five input connectors.
Note, that the dimensions of the input connector signals have to be
explicitly defined via parameters n1, n2, n3, n4 and n5.
</p>
</HTML>
"),       Icon(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={1,1}), graphics={
              Line(points={{8,0},{102,0}}, color={0,0,255}),
              Line(points={{-100,100},{-60,100},{-4,6}}, color={0,0,127}),
              Line(points={{-99,50},{-60,50},{-8,5}}, color={0,0,127}),
              Line(points={{-100,0},{-7,0}}, color={0,0,127}),
              Line(points={{-99,-50},{-60,-50},{-9,-6}}, color={0,0,127}),
              Line(points={{-100,-100},{-60,-100},{-4,-4}}, color={0,0,127}),
              Ellipse(
                extent={{-15,15},{15,-15}},
                fillColor={0,0,127},
                fillPattern=FillPattern.Solid,
                lineColor={0,0,127})}),
          Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={1,1}), graphics={
              Line(points={{-100,100},{-60,100},{-4,6}}, color={0,0,255}),
              Line(points={{-100,-100},{-60,-100},{-4,-4}}, color={0,0,255}),
              Line(points={{8,0},{102,0}}, color={0,0,255}),
              Ellipse(
                extent={{-15,15},{15,-15}},
                fillColor={0,0,255},
                fillPattern=FillPattern.Solid,
                lineColor={0,0,255}),
              Line(points={{-99,50},{-60,50},{-8,5}}, color={0,0,255}),
              Line(points={{-100,0},{-7,0}}, color={0,0,255}),
              Line(points={{-99,-50},{-60,-50},{-9,-6}}, color={0,0,255})}));
      end Multiplex5;

      block DeMultiplex4 "DeMultiplexer block for four output connectors"

        extends Modelica.Blocks.Interfaces.BlockIcon;
        parameter Integer n1=1 "dimension of output signal connector 1";
        parameter Integer n2=1 "dimension of output signal connector 2";
        parameter Integer n3=1 "dimension of output signal connector 3";
        parameter Integer n4=1 "dimension of output signal connector 4";
        Modelica.Blocks.Interfaces.RealInput u[n1 + n2 + n3 + n4]
        "Connector of Real input signals"   annotation (Placement(transformation(
                extent={{-140,-20},{-100,20}}, rotation=0)));
        Modelica.Blocks.Interfaces.RealOutput y1[n1]
        "Connector of Real output signals 1"   annotation (Placement(transformation(
                extent={{100,80},{120,100}}, rotation=0)));
        Modelica.Blocks.Interfaces.RealOutput y2[n2]
        "Connector of Real output signals 2"   annotation (Placement(transformation(
                extent={{100,20},{120,40}}, rotation=0)));
        Modelica.Blocks.Interfaces.RealOutput y3[n3]
        "Connector of Real output signals 3"   annotation (Placement(transformation(
                extent={{100,-40},{120,-20}}, rotation=0)));
        Modelica.Blocks.Interfaces.RealOutput y4[n4]
        "Connector of Real output signals 4"   annotation (Placement(transformation(
                extent={{100,-100},{120,-80}}, rotation=0)));

      equation
        [u] = [y1; y2; y3; y4];
        annotation (
          Documentation(info="<HTML>
<p>
The input connector is <b>splitted</b> up into four output connectors.
Note, that the dimensions of the output connector signals have to be
explicitly defined via parameters n1, n2, n3 and n4.
</HTML>
"),       Icon(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={1,1}), graphics={
              Ellipse(
                extent={{-14,16},{16,-14}},
                fillColor={0,0,127},
                fillPattern=FillPattern.Solid,
                lineColor={0,0,127}),
              Line(points={{-100,0},{-6,0}}, color={0,0,127}),
              Line(points={{100,90},{60,90},{6,5}}, color={0,0,127}),
              Line(points={{100,30},{60,30},{9,2}}, color={0,0,127}),
              Line(points={{100,-30},{60,-30},{8,-4}}, color={0,0,127}),
              Line(points={{99,-90},{60,-90},{6,-6}}, color={0,0,127})}),
          Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={1,1}), graphics={
              Line(points={{100,90},{60,90},{6,5}}, color={0,0,255}),
              Line(points={{99,-90},{60,-90},{6,-6}}, color={0,0,255}),
              Line(points={{-100,0},{-6,0}}, color={0,0,255}),
              Line(points={{100,30},{60,30},{9,2}}, color={0,0,255}),
              Line(points={{100,-30},{60,-30},{8,-4}}, color={0,0,255}),
              Ellipse(
                extent={{-16,15},{14,-15}},
                fillColor={0,0,255},
                fillPattern=FillPattern.Solid,
                lineColor={0,0,255})}));
      end DeMultiplex4;
      annotation (Documentation(info="<html>
<p>
This package contains blocks to combine and extract signals.
</p>
</html>"));
    end Routing;

    package Sources
    "Library of signal source blocks generating Real and Boolean signals"
      import Modelica.Blocks.Interfaces;
      import Modelica.SIunits;
      extends Modelica.Icons.SourcesPackage;

      block RealExpression
      "Set output signal to a time varying Real expression"

        Modelica.Blocks.Interfaces.RealOutput y=0.0 "Value of Real output"
          annotation (                            Dialog(group=
                "Time varying output signal"), Placement(transformation(extent={{
                  100,-10},{120,10}}, rotation=0)));

        annotation (
          Icon(coordinateSystem(
              preserveAspectRatio=false,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={
              Rectangle(
                extent={{-100,40},{100,-40}},
                lineColor={0,0,0},
                fillColor={235,235,235},
                fillPattern=FillPattern.Solid,
                borderPattern=BorderPattern.Raised),
              Text(
                extent={{-96,15},{96,-15}},
                lineColor={0,0,0},
                textString="%y"),
              Text(
                extent={{-150,90},{140,50}},
                textString="%name",
                lineColor={0,0,255})}),
          Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics),
          Documentation(info="<html>
<p>
The (time varying) Real output signal of this block can be defined in its
parameter menu via variable <b>y</b>. The purpose is to support the
easy definition of Real expressions in a block diagram. For example,
in the y-menu the definition \"if time &lt; 1 then 0 else 1\" can be given in order
to define that the output signal is one, if time &ge; 1 and otherwise
it is zero. Note, that \"time\" is a built-in variable that is always
accessible and represents the \"model time\" and that
Variable <b>y</b> is both a variable and a connector.
</p>
</html>"));

      end RealExpression;

          block Constant "Generate constant signal of type Real"
            parameter Real k(start=1) "Constant output value";
            extends Interfaces.SO;

          equation
            y = k;
            annotation (defaultComponentName="const",
              Icon(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={
              Line(points={{-80,68},{-80,-80}}, color={192,192,192}),
              Polygon(
                points={{-80,90},{-88,68},{-72,68},{-80,90}},
                lineColor={192,192,192},
                fillColor={192,192,192},
                fillPattern=FillPattern.Solid),
              Line(points={{-90,-70},{82,-70}}, color={192,192,192}),
              Polygon(
                points={{90,-70},{68,-62},{68,-78},{90,-70}},
                lineColor={192,192,192},
                fillColor={192,192,192},
                fillPattern=FillPattern.Solid),
              Line(points={{-80,0},{80,0}}, color={0,0,0}),
              Text(
                extent={{-150,-150},{150,-110}},
                lineColor={0,0,0},
                textString="k=%k")}),
              Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={
              Polygon(
                points={{-80,90},{-86,68},{-74,68},{-80,90}},
                lineColor={95,95,95},
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid),
              Line(points={{-80,68},{-80,-80}}, color={95,95,95}),
              Line(
                points={{-80,0},{80,0}},
                color={0,0,255},
                thickness=0.5),
              Line(points={{-90,-70},{82,-70}}, color={95,95,95}),
              Polygon(
                points={{90,-70},{68,-64},{68,-76},{90,-70}},
                lineColor={95,95,95},
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid),
              Text(
                extent={{-83,92},{-30,74}},
                lineColor={0,0,0},
                textString="y"),
              Text(
                extent={{70,-80},{94,-100}},
                lineColor={0,0,0},
                textString="time"),
              Text(
                extent={{-101,8},{-81,-12}},
                lineColor={0,0,0},
                textString="k")}),
          Documentation(info="<html>
<p>
The Real output y is a constant signal:
</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/Blocks/Sources/Constant.png\">
</p>
</html>"));
          end Constant;
          annotation (
            Documentation(info="<HTML>
<p>
This package contains <b>source</b> components, i.e., blocks which
have only output signals. These blocks are used as signal generators
for Real, Integer and Boolean signals.
</p>

<p>
All Real source signals (with the exception of the Constant source)
have at least the following two parameters:
</p>

<table border=1 cellspacing=0 cellpadding=2>
  <tr><td valign=\"top\"><b>offset</b></td>
      <td valign=\"top\">Value which is added to the signal</td>
  </tr>
  <tr><td valign=\"top\"><b>startTime</b></td>
      <td valign=\"top\">Start time of signal. For time &lt; startTime,
                the output y is set to offset.</td>
  </tr>
</table>

<p>
The <b>offset</b> parameter is especially useful in order to shift
the corresponding source, such that at initial time the system
is stationary. To determine the corresponding value of offset,
usually requires a trimming calculation.
</p>
</HTML>
",     revisions="<html>
<ul>
<li><i>October 21, 2002</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>
       and <a href=\"http://www.robotic.dlr.de/Christian.Schweiger/\">Christian Schweiger</a>:<br>
       Integer sources added. Step, TimeTable and BooleanStep slightly changed.</li>
<li><i>Nov. 8, 1999</i>
       by <a href=\"mailto:clauss@eas.iis.fhg.de\">Christoph Clau&szlig;</a>,
       <a href=\"mailto:Andre.Schneider@eas.iis.fraunhofer.de\">Andre.Schneider@eas.iis.fraunhofer.de</a>,
       <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       New sources: Exponentials, TimeTable. Trapezoid slightly enhanced
       (nperiod=-1 is an infinite number of periods).</li>
<li><i>Oct. 31, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       <a href=\"mailto:clauss@eas.iis.fhg.de\">Christoph Clau&szlig;</a>,
       <a href=\"mailto:Andre.Schneider@eas.iis.fraunhofer.de\">Andre.Schneider@eas.iis.fraunhofer.de</a>,
       All sources vectorized. New sources: ExpSine, Trapezoid,
       BooleanConstant, BooleanStep, BooleanPulse, SampleTrigger.
       Improved documentation, especially detailed description of
       signals in diagram layer.</li>
<li><i>June 29, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Realized a first version, based on an existing Dymola library
       of Dieter Moormann and Hilding Elmqvist.</li>
</ul>
</html>"));
    end Sources;

    package Types
    "Library of constants and types with choices, especially to build menus"
      extends Modelica.Icons.Package;

      type Init = enumeration(
        NoInit
          "No initialization (start values are used as guess values with fixed=false)",

        SteadyState
          "Steady state initialization (derivatives of states are zero)",
        InitialState "Initialization with initial states",
        InitialOutput
          "Initialization with initial outputs (and steady state of the states if possibles)")
      "Enumeration defining initialization of a block"
          annotation (Evaluate=true);

      type InitPID = enumeration(
        NoInit
          "No initialization (start values are used as guess values with fixed=false)",

        SteadyState
          "Steady state initialization (derivatives of states are zero)",
        InitialState "Initialization with initial states",
        InitialOutput
          "Initialization with initial outputs (and steady state of the states if possibles)",

        DoNotUse_InitialIntegratorState
          "Don't use, only for backward compatibility (initialize only integrator state)")
      "Enumeration defining initialization of PID and LimPID blocks"
        annotation (Documentation(info="<html>
<p>
This initialization type is identical to Types.Init and has just one
additional option <b>DoNotUse_InitialIntegratorState</b>. This option
is introduced in order that the default initialization for the
Continuous.PID and Continuous.LimPID blocks are backward
compatible. In Modelica 2.2, the integrators have been initialized
with their given states where as the D-part has not been initialized.
The option \"DoNotUse_InitialIntegratorState\" leads to this
initialization definition.
</p>

</html>"),       Evaluate=true);

      type SimpleController = enumeration(
        P "P controller",
        PI "PI controller",
        PD "PD controller",
        PID "PID controller")
      "Enumeration defining P, PI, PD, or PID simple controller type"
          annotation (Evaluate=true);

    type AnalogFilter = enumeration(
        CriticalDamping "Filter with critical damping",
        Bessel "Bessel filter",
        Butterworth "Butterworth filter",
        ChebyshevI "Chebyshev I filter")
      "Enumeration defining the method of filtering"
          annotation (Evaluate=true);

    type FilterType = enumeration(
        LowPass "Low pass filter",
        HighPass "High pass filter",
        BandPass "Band pass filter",
        BandStop "Band stop / notch filter")
      "Enumeration of analog filter types (low, high, band pass or band stop filter"
        annotation (Evaluate=true);
      annotation ( Documentation(info="<HTML>
<p>
In this package <b>types</b> and <b>constants</b> are defined that are used
in library Modelica.Blocks. The types have additional annotation choices
definitions that define the menus to be built up in the graphical
user interface when the type is used as parameter in a declaration.
</p>
</HTML>"));
    end Types;
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(extent={{-32,-6},{16,-35}}, lineColor={0,0,0}),
        Rectangle(extent={{-32,-56},{16,-85}}, lineColor={0,0,0}),
        Line(points={{16,-20},{49,-20},{49,-71},{16,-71}}, color={0,0,0}),
        Line(points={{-32,-72},{-64,-72},{-64,-21},{-32,-21}}, color={0,0,0}),
        Polygon(
          points={{16,-71},{29,-67},{29,-74},{16,-71}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-32,-21},{-46,-17},{-46,-25},{-32,-21}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
                            Documentation(info="<html>
<p>
This library contains input/output blocks to build up block diagrams.
</p>

<dl>
<dt><b>Main Author:</b>
<dd><a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a><br>
    Deutsches Zentrum f&uuml;r Luft und Raumfahrt e. V. (DLR)<br>
    Oberpfaffenhofen<br>
    Postfach 1116<br>
    D-82230 Wessling<br>
    email: <A HREF=\"mailto:Martin.Otter@dlr.de\">Martin.Otter@dlr.de</A><br>
</dl>
<p>
Copyright &copy; 1998-2010, Modelica Association and DLR.
</p>
<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"http://www.modelica.org/licenses/ModelicaLicense2\"> http://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>
</HTML>
",   revisions="<html>
<ul>
<li><i>June 23, 2004</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Introduced new block connectors and adapated all blocks to the new connectors.
       Included subpackages Continuous, Discrete, Logical, Nonlinear from
       package ModelicaAdditions.Blocks.
       Included subpackage ModelicaAdditions.Table in Modelica.Blocks.Sources
       and in the new package Modelica.Blocks.Tables.
       Added new blocks to Blocks.Sources and Blocks.Logical.
       </li>
<li><i>October 21, 2002</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>
       and <a href=\"http://www.robotic.dlr.de/Christian.Schweiger/\">Christian Schweiger</a>:<br>
       New subpackage Examples, additional components.
       </li>
<li><i>June 20, 2000</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a> and
       Michael Tiller:<br>
       Introduced a replaceable signal type into
       Blocks.Interfaces.RealInput/RealOutput:
<pre>
   replaceable type SignalType = Real
</pre>
       in order that the type of the signal of an input/output block
       can be changed to a physical type, for example:
<pre>
   Sine sin1(outPort(redeclare type SignalType=Modelica.SIunits.Torque))
</pre>
      </li>
<li><i>Sept. 18, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Renamed to Blocks. New subpackages Math, Nonlinear.
       Additional components in subpackages Interfaces, Continuous
       and Sources. </li>
<li><i>June 30, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Realized a first version, based on an existing Dymola library
       of Dieter Moormann and Hilding Elmqvist.</li>
</ul>
</html>"));
  end Blocks;

  package Fluid
  "Library of 1-dim. thermo-fluid flow models using the Modelica.Media media description"
    extends Modelica.Icons.Package;
    import SI = Modelica.SIunits;

    model System
    "System properties and default values (ambient, flow direction, initialization)"

      package Medium = Modelica.Media.Interfaces.PartialMedium
      "Medium model for default start values"
          annotation (choicesAllMatching = true);
      parameter Modelica.SIunits.AbsolutePressure p_ambient=101325
      "Default ambient pressure"
        annotation(Dialog(group="Environment"));
      parameter Modelica.SIunits.Temperature T_ambient=293.15
      "Default ambient temperature"
        annotation(Dialog(group="Environment"));
      parameter Modelica.SIunits.Acceleration g=Modelica.Constants.g_n
      "Constant gravity acceleration"
        annotation(Dialog(group="Environment"));

      // Assumptions
      parameter Boolean allowFlowReversal = true
      "= false to restrict to design flow direction (port_a -> port_b)"
        annotation(Dialog(tab="Assumptions"), Evaluate=true);
      parameter Modelica.Fluid.Types.Dynamics energyDynamics=
        Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
      "Default formulation of energy balances"
        annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics"));
      parameter Modelica.Fluid.Types.Dynamics massDynamics=
        energyDynamics "Default formulation of mass balances"
        annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics"));
      final parameter Modelica.Fluid.Types.Dynamics substanceDynamics=
        massDynamics "Default formulation of substance balances"
        annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics"));
      final parameter Modelica.Fluid.Types.Dynamics traceDynamics=
        massDynamics "Default formulation of trace substance balances"
        annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics"));
      parameter Modelica.Fluid.Types.Dynamics momentumDynamics=
        Modelica.Fluid.Types.Dynamics.SteadyState
      "Default formulation of momentum balances, if options available"
        annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics"));

      // Initialization
      parameter Modelica.SIunits.MassFlowRate m_flow_start = 0
      "Default start value for mass flow rates"
        annotation(Dialog(tab = "Initialization"));
      parameter Modelica.SIunits.AbsolutePressure p_start = p_ambient
      "Default start value for pressures"
        annotation(Dialog(tab = "Initialization"));
      parameter Modelica.SIunits.Temperature T_start = T_ambient
      "Default start value for temperatures"
        annotation(Dialog(tab = "Initialization"));

      // Advanced
      parameter Modelica.SIunits.MassFlowRate m_flow_small(min=0) = 0.01
      "Default small laminar mass flow rate for regularization of zero flow"
        annotation(Dialog(tab = "Advanced"));
      parameter Modelica.SIunits.AbsolutePressure dp_small(min=0) = 1
      "Default small pressure drop for regularization of laminar and zero flow"
        annotation(Dialog(tab="Advanced"));

      annotation (
        defaultComponentName="system",
        defaultComponentPrefixes="inner",
        missingInnerMessage="
Your model is using an outer \"system\" component but
an inner \"system\" component is not defined.
For simulation drag Modelica.Fluid.System into your model
to specify system properties. The default System setting
is used for the current simulation.
",      Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
                100}}), graphics={
            Rectangle(
              extent={{-100,100},{100,-100}},
              lineColor={0,0,255},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Text(
              extent={{-150,150},{150,110}},
              lineColor={0,0,255},
              textString="%name"),
            Line(points={{-86,-30},{82,-30}}, color={0,0,0}),
            Line(points={{-82,-68},{-52,-30}}, color={0,0,0}),
            Line(points={{-48,-68},{-18,-30}}, color={0,0,0}),
            Line(points={{-14,-68},{16,-30}}, color={0,0,0}),
            Line(points={{22,-68},{52,-30}}, color={0,0,0}),
            Line(points={{74,84},{74,14}}, color={0,0,0}),
            Polygon(
              points={{60,14},{88,14},{74,-18},{60,14}},
              lineColor={0,0,0},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid),
            Text(
              extent={{16,20},{60,-18}},
              lineColor={0,0,0},
              textString="g"),
            Text(
              extent={{-90,82},{74,50}},
              lineColor={0,0,0},
              textString="defaults"),
            Line(
              points={{-82,14},{-42,-20},{2,30}},
              color={0,0,0},
              thickness=0.5),
            Ellipse(
              extent={{-10,40},{12,18}},
              pattern=LinePattern.None,
              lineColor={0,0,0},
              fillColor={255,0,0},
              fillPattern=FillPattern.Solid)}),
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
                100,100}}),
                graphics),
        Documentation(info="<html>
<p>
 A system component is needed in each fluid model to provide system-wide settings, such as ambient conditions and overall modeling assumptions.
 The system settings are propagated to the fluid models using the inner/outer mechanism.
</p>
<p>
 A model should never directly use system parameters.
 Instead a local parameter should be declared, which uses the global setting as default.
 The only exception currently made is the gravity system.g.
</p>
</html>"));

    end System;

    package Vessels "Devices for storing fluid"
       extends Modelica.Icons.VariantsPackage;

      package BaseClasses
      "Base classes used in the Vessels package (only of interest to build new component models)"
        extends Modelica.Icons.BasesPackage;

        connector VesselFluidPorts_b
        "Fluid connector with outlined, large icon to be used for horizontally aligned vectors of FluidPorts (vector dimensions must be added after dragging)"
          extends Interfaces.FluidPort;
          annotation (defaultComponentName="ports_b",
                      Diagram(coordinateSystem(
                preserveAspectRatio=false,
                extent={{-50,-200},{50,200}},
                grid={1,1},
                initialScale=0.2), graphics={
                Text(extent={{-75,130},{75,100}}, textString="%name"),
                Rectangle(
                  extent={{-25,100},{25,-100}},
                  lineColor={0,0,0}),
                Ellipse(
                  extent={{-22,100},{-10,-100}},
                  lineColor={0,0,0},
                  fillColor={0,127,255},
                  fillPattern=FillPattern.Solid),
                Ellipse(
                  extent={{-20,-69},{-12,69}},
                  lineColor={0,127,255},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Ellipse(
                  extent={{-6,100},{6,-100}},
                  lineColor={0,0,0},
                  fillColor={0,127,255},
                  fillPattern=FillPattern.Solid),
                Ellipse(
                  extent={{10,100},{22,-100}},
                  lineColor={0,0,0},
                  fillColor={0,127,255},
                  fillPattern=FillPattern.Solid),
                Ellipse(
                  extent={{-4,-69},{4,69}},
                  lineColor={0,127,255},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Ellipse(
                  extent={{12,-69},{20,69}},
                  lineColor={0,127,255},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid)}),
               Icon(coordinateSystem(
                preserveAspectRatio=false,
                extent={{-50,-200},{50,200}},
                grid={1,1},
                initialScale=0.2), graphics={
                Rectangle(
                  extent={{-50,200},{50,-200}},
                  lineColor={0,127,255},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Ellipse(
                  extent={{-44,200},{-20,-200}},
                  lineColor={0,0,0},
                  fillColor={0,127,255},
                  fillPattern=FillPattern.Solid),
                Ellipse(
                  extent={{-12,200},{12,-200}},
                  lineColor={0,0,0},
                  fillColor={0,127,255},
                  fillPattern=FillPattern.Solid),
                Ellipse(
                  extent={{20,200},{44,-200}},
                  lineColor={0,0,0},
                  fillColor={0,127,255},
                  fillPattern=FillPattern.Solid),
                Ellipse(
                  extent={{-39,-118.5},{-25,113}},
                  lineColor={0,127,255},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Ellipse(
                  extent={{-7,-118.5},{7,113}},
                  lineColor={0,127,255},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Ellipse(
                  extent={{25,-117.5},{39,114}},
                  lineColor={0,127,255},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid)}));
        end VesselFluidPorts_b;
      end BaseClasses;
      annotation (Documentation(info="<html>

</html>"));
    end Vessels;

    package Sources "Define fixed or prescribed boundary conditions"
      extends Modelica.Icons.SourcesPackage;

      package BaseClasses
      "Base classes used in the Sources package (only of interest to build new component models)"
        extends Modelica.Icons.BasesPackage;

      partial model PartialSource
        "Partial component source with one fluid connector"
          import Modelica.Constants;

        parameter Integer nPorts=0 "Number of ports" annotation(Dialog(connectorSizing=true));

        replaceable package Medium =
            Modelica.Media.Interfaces.PartialMedium
          "Medium model within the source"
           annotation (choicesAllMatching=true);

        Medium.BaseProperties medium "Medium in the source";

        Interfaces.FluidPorts_b ports[nPorts](
                           redeclare each package Medium = Medium,
                           m_flow(each max=if flowDirection==Types.PortFlowDirection.Leaving then 0 else
                                           +Constants.inf,
                                  each min=if flowDirection==Types.PortFlowDirection.Entering then 0 else
                                           -Constants.inf))
          annotation (Placement(transformation(extent={{90,40},{110,-40}})));
      protected
        parameter Types.PortFlowDirection flowDirection=
                         Types.PortFlowDirection.Bidirectional
          "Allowed flow direction"               annotation(Evaluate=true, Dialog(tab="Advanced"));
      equation
        // Only one connection allowed to a port to avoid unwanted ideal mixing
        for i in 1:nPorts loop
          assert(cardinality(ports[i]) <= 1,"
each ports[i] of boundary shall at most be connected to one component.
If two or more connections are present, ideal mixing takes
place with these connections, which is usually not the intention
of the modeller. Increase nPorts to add an additional port.
");

           ports[i].p          = medium.p;
           ports[i].h_outflow  = medium.h;
           ports[i].Xi_outflow = medium.Xi;
        end for;

        annotation (defaultComponentName="boundary", Documentation(info="<html>
<p>
Partial component to model the <b>volume interface</b> of a <b>source</b>
component, such as a mass flow source. The essential
features are:
</p>
<ul>
<li> The pressure in the connection port (= ports.p) is identical to the
     pressure in the volume.</li>
<li> The outflow enthalpy rate (= port.h_outflow) and the composition of the
     substances (= port.Xi_outflow) are identical to the respective values in the volume.</li>
</ul>
</html>"),       Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
                    -100},{100,100}}),
                               graphics),
            Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
                    {100,100}}), graphics));
      end PartialSource;
      end BaseClasses;
      annotation (Documentation(info="<html>
<p>
Package <b>Sources</b> contains generic sources for fluid connectors
to define fixed or prescribed ambient conditions.
</p>
</html>"));
    end Sources;

    package Interfaces
    "Interfaces for steady state and unsteady, mixed-phase, multi-substance, incompressible and compressible flow"
      extends Modelica.Icons.InterfacesPackage;

      connector FluidPort
      "Interface for quasi one-dimensional fluid flow in a piping network (incompressible or compressible, one or more phases, one or more substances)"

        replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
        "Medium model"   annotation (choicesAllMatching=true);

        flow Medium.MassFlowRate m_flow
        "Mass flow rate from the connection point into the component";
        Medium.AbsolutePressure p
        "Thermodynamic pressure in the connection point";
        stream Medium.SpecificEnthalpy h_outflow
        "Specific thermodynamic enthalpy close to the connection point if m_flow < 0";
        stream Medium.MassFraction Xi_outflow[Medium.nXi]
        "Independent mixture mass fractions m_i/m close to the connection point if m_flow < 0";
        stream Medium.ExtraProperty C_outflow[Medium.nC]
        "Properties c_i/m close to the connection point if m_flow < 0";
      end FluidPort;

      connector FluidPort_a "Generic fluid connector at design inlet"
        extends FluidPort;
        annotation (defaultComponentName="port_a",
                    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                  -100},{100,100}}), graphics={Ellipse(
                extent={{-40,40},{40,-40}},
                lineColor={0,0,0},
                fillColor={0,127,255},
                fillPattern=FillPattern.Solid), Text(extent={{-150,110},{150,50}},
                  textString="%name")}),
             Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
                  100,100}}), graphics={Ellipse(
                extent={{-100,100},{100,-100}},
                lineColor={0,127,255},
                fillColor={0,127,255},
                fillPattern=FillPattern.Solid), Ellipse(
                extent={{-100,100},{100,-100}},
                lineColor={0,0,0},
                fillColor={0,127,255},
                fillPattern=FillPattern.Solid)}));
      end FluidPort_a;

      connector FluidPort_b "Generic fluid connector at design outlet"
        extends FluidPort;
        annotation (defaultComponentName="port_b",
                    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                  -100},{100,100}}), graphics={
              Ellipse(
                extent={{-40,40},{40,-40}},
                lineColor={0,0,0},
                fillColor={0,127,255},
                fillPattern=FillPattern.Solid),
              Ellipse(
                extent={{-30,30},{30,-30}},
                lineColor={0,127,255},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Text(extent={{-150,110},{150,50}}, textString="%name")}),
             Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
                  100,100}}), graphics={
              Ellipse(
                extent={{-100,100},{100,-100}},
                lineColor={0,127,255},
                fillColor={0,127,255},
                fillPattern=FillPattern.Solid),
              Ellipse(
                extent={{-100,100},{100,-100}},
                lineColor={0,0,0},
                fillColor={0,127,255},
                fillPattern=FillPattern.Solid),
              Ellipse(
                extent={{-80,80},{80,-80}},
                lineColor={0,127,255},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid)}));
      end FluidPort_b;

      connector FluidPorts_b
      "Fluid connector with outlined, large icon to be used for vectors of FluidPorts (vector dimensions must be added after dragging)"
        extends FluidPort;
        annotation (defaultComponentName="ports_b",
                    Diagram(coordinateSystem(
              preserveAspectRatio=false,
              extent={{-50,-200},{50,200}},
              grid={1,1},
              initialScale=0.2), graphics={
              Text(extent={{-75,130},{75,100}}, textString="%name"),
              Rectangle(
                extent={{-25,100},{25,-100}},
                lineColor={0,0,0}),
              Ellipse(
                extent={{-25,90},{25,40}},
                lineColor={0,0,0},
                fillColor={0,127,255},
                fillPattern=FillPattern.Solid),
              Ellipse(
                extent={{-25,25},{25,-25}},
                lineColor={0,0,0},
                fillColor={0,127,255},
                fillPattern=FillPattern.Solid),
              Ellipse(
                extent={{-25,-40},{25,-90}},
                lineColor={0,0,0},
                fillColor={0,127,255},
                fillPattern=FillPattern.Solid),
              Ellipse(
                extent={{-15,-50},{15,-80}},
                lineColor={0,127,255},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Ellipse(
                extent={{-15,15},{15,-15}},
                lineColor={0,127,255},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Ellipse(
                extent={{-15,50},{15,80}},
                lineColor={0,127,255},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid)}),
             Icon(coordinateSystem(
              preserveAspectRatio=false,
              extent={{-50,-200},{50,200}},
              grid={1,1},
              initialScale=0.2), graphics={
              Rectangle(
                extent={{-50,200},{50,-200}},
                lineColor={0,127,255},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Ellipse(
                extent={{-50,180},{50,80}},
                lineColor={0,0,0},
                fillColor={0,127,255},
                fillPattern=FillPattern.Solid),
              Ellipse(
                extent={{-50,50},{50,-50}},
                lineColor={0,0,0},
                fillColor={0,127,255},
                fillPattern=FillPattern.Solid),
              Ellipse(
                extent={{-50,-80},{50,-180}},
                lineColor={0,0,0},
                fillColor={0,127,255},
                fillPattern=FillPattern.Solid),
              Ellipse(
                extent={{-30,30},{30,-30}},
                lineColor={0,127,255},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Ellipse(
                extent={{-30,100},{30,160}},
                lineColor={0,127,255},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Ellipse(
                extent={{-30,-100},{30,-160}},
                lineColor={0,127,255},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid)}));
      end FluidPorts_b;

      partial model PartialTwoPort "Partial component with two ports"
        import Modelica.Constants;
        outer Modelica.Fluid.System system "System wide properties";

        replaceable package Medium =
            Modelica.Media.Interfaces.PartialMedium "Medium in the component"
            annotation (choicesAllMatching = true);

        parameter Boolean allowFlowReversal = system.allowFlowReversal
        "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
          annotation(Dialog(tab="Assumptions"), Evaluate=true);

        Modelica.Fluid.Interfaces.FluidPort_a port_a(
                                      redeclare package Medium = Medium,
                           m_flow(min=if allowFlowReversal then -Constants.inf else 0))
        "Fluid connector a (positive design flow direction is from port_a to port_b)"
          annotation (Placement(transformation(extent={{-110,-10},{-90,10}},
                  rotation=0)));
        Modelica.Fluid.Interfaces.FluidPort_b port_b(
                                      redeclare package Medium = Medium,
                           m_flow(max=if allowFlowReversal then +Constants.inf else 0))
        "Fluid connector b (positive design flow direction is from port_a to port_b)"
          annotation (Placement(transformation(extent={{110,-10},{90,10}}, rotation=
                   0), iconTransformation(extent={{110,-10},{90,10}})));
        // Model structure, e.g., used for visualization
    protected
        parameter Boolean port_a_exposesState = false
        "= true if port_a exposes the state of a fluid volume";
        parameter Boolean port_b_exposesState = false
        "= true if port_b.p exposes the state of a fluid volume";
        parameter Boolean showDesignFlowDirection = true
        "= false to hide the arrow in the model icon";

        annotation (
          Diagram(coordinateSystem(
                preserveAspectRatio=false,
                extent={{-100,-100},{100,100}},
                grid={1,1}), graphics),
          Documentation(info="<html>
<p>
This partial model defines an interface for components with two ports.
The treatment of the design flow direction and of flow reversal are predefined based on the parameter <code><b>allowFlowReversal</b></code>.
The component may transport fluid and may have internal storage for a given fluid <code><b>Medium</b></code>.
</p>
<p>
An extending model providing direct access to internal storage of mass or energy through port_a or port_b
should redefine the protected parameters <code><b>port_a_exposesState</b></code> and <code><b>port_b_exposesState</b></code> appropriately.
This will be visualized at the port icons, in order to improve the understanding of fluid model diagrams.
</p>
</html>"),Icon(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={1,1}), graphics={
              Polygon(
                points={{20,-70},{60,-85},{20,-100},{20,-70}},
                lineColor={0,128,255},
                smooth=Smooth.None,
                fillColor={0,128,255},
                fillPattern=FillPattern.Solid,
                visible=showDesignFlowDirection),
              Polygon(
                points={{20,-75},{50,-85},{20,-95},{20,-75}},
                lineColor={255,255,255},
                smooth=Smooth.None,
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid,
                visible=allowFlowReversal),
              Line(
                points={{55,-85},{-60,-85}},
                color={0,128,255},
                smooth=Smooth.None,
                visible=showDesignFlowDirection),
              Text(
                extent={{-149,-114},{151,-154}},
                lineColor={0,0,255},
                textString="%name"),
              Ellipse(
                extent={{-110,26},{-90,-24}},
                lineColor={0,0,0},
                fillColor={0,0,0},
                fillPattern=FillPattern.Solid,
                visible=port_a_exposesState),
              Ellipse(
                extent={{90,25},{110,-25}},
                lineColor={0,0,0},
                fillColor={0,0,0},
                fillPattern=FillPattern.Solid,
                visible=port_b_exposesState)}));
      end PartialTwoPort;

    partial model PartialTwoPortTransport
      "Partial element transporting fluid between two ports without storage of mass or energy"

      extends PartialTwoPort(
        final port_a_exposesState=false,
        final port_b_exposesState=false);

      // Advanced
      parameter Medium.AbsolutePressure dp_start = 0.01*system.p_start
        "Guess value of dp = port_a.p - port_b.p"
        annotation(Dialog(tab = "Advanced"));
      parameter Medium.MassFlowRate m_flow_start = system.m_flow_start
        "Guess value of m_flow = port_a.m_flow"
        annotation(Dialog(tab = "Advanced"));
      parameter Medium.MassFlowRate m_flow_small = system.m_flow_small
        "Small mass flow rate for regularization of zero flow"
        annotation(Dialog(tab = "Advanced"));

      // Diagnostics
      parameter Boolean show_T = true
        "= true, if temperatures at port_a and port_b are computed"
        annotation(Dialog(tab="Advanced",group="Diagnostics"));
      parameter Boolean show_V_flow = true
        "= true, if volume flow rate at inflowing port is computed"
        annotation(Dialog(tab="Advanced",group="Diagnostics"));

      // Variables
      Medium.MassFlowRate m_flow(
         min=if allowFlowReversal then -Modelica.Constants.inf else 0,
         start = m_flow_start) "Mass flow rate in design flow direction";
      Modelica.SIunits.Pressure dp(start=dp_start)
        "Pressure difference between port_a and port_b (= port_a.p - port_b.p)";

      Modelica.SIunits.VolumeFlowRate V_flow=
          m_flow/Modelica.Fluid.Utilities.regStep(m_flow,
                      Medium.density(state_a),
                      Medium.density(state_b),
                      m_flow_small) if show_V_flow
        "Volume flow rate at inflowing port (positive when flow from port_a to port_b)";

      Medium.Temperature port_a_T=
          Modelica.Fluid.Utilities.regStep(port_a.m_flow,
                      Medium.temperature(state_a),
                      Medium.temperature(Medium.setState_phX(port_a.p, port_a.h_outflow, port_a.Xi_outflow)),
                      m_flow_small) if show_T
        "Temperature close to port_a, if show_T = true";
      Medium.Temperature port_b_T=
          Modelica.Fluid.Utilities.regStep(port_b.m_flow,
                      Medium.temperature(state_b),
                      Medium.temperature(Medium.setState_phX(port_b.p, port_b.h_outflow, port_b.Xi_outflow)),
                      m_flow_small) if show_T
        "Temperature close to port_b, if show_T = true";
    protected
      Medium.ThermodynamicState state_a
        "state for medium inflowing through port_a";
      Medium.ThermodynamicState state_b
        "state for medium inflowing through port_b";
    equation
      // medium states
      state_a = Medium.setState_phX(port_a.p, inStream(port_a.h_outflow), inStream(port_a.Xi_outflow));
      state_b = Medium.setState_phX(port_b.p, inStream(port_b.h_outflow), inStream(port_b.Xi_outflow));

      // Pressure drop in design flow direction
      dp = port_a.p - port_b.p;

      // Design direction of mass flow rate
      m_flow = port_a.m_flow;
      assert(m_flow > -m_flow_small or allowFlowReversal, "Reverting flow occurs even though allowFlowReversal is false");

      // Mass balance (no storage)
      port_a.m_flow + port_b.m_flow = 0;

      // Transport of substances
      port_a.Xi_outflow = inStream(port_b.Xi_outflow);
      port_b.Xi_outflow = inStream(port_a.Xi_outflow);

      port_a.C_outflow = inStream(port_b.C_outflow);
      port_b.C_outflow = inStream(port_a.C_outflow);

      annotation (
        Diagram(coordinateSystem(
              preserveAspectRatio=false,
              extent={{-100,-100},{100,100}},
              grid={1,1}), graphics),
        Documentation(info="<html>
<p>
This component transports fluid between its two ports, without storing mass or energy.
Energy may be exchanged with the environment though, e.g., in the form of work.
<code>PartialTwoPortTransport</code> is intended as base class for devices like orifices, valves and simple fluid machines.
<p>
Three equations need to be added by an extending class using this component:
</p>
<ul>
<li>the momentum balance specifying the relationship between the pressure drop <code>dp</code> and the mass flow rate <code>m_flow</code></li>,
<li><code>port_b.h_outflow</code> for flow in design direction, and</li>
<li><code>port_a.h_outflow</code> for flow in reverse direction.</li>
</ul>
</html>"),
        Icon(coordinateSystem(
              preserveAspectRatio=false,
              extent={{-100,-100},{100,100}},
              grid={1,1})));
    end PartialTwoPortTransport;
      annotation (Documentation(info="<html>

</html>",     revisions="<html>
<ul>
<li><i>June 9th, 2008</i>
       by Michael Sielemann: Introduced stream keyword after decision at 57th Design Meeting (Lund).</li>
<li><i>May 30, 2007</i>
       by Christoph Richter: moved everything back to its original position in Modelica.Fluid.</li>
<li><i>Apr. 20, 2007</i>
       by Christoph Richter: moved parts of the original package from Modelica.Fluid
       to the development branch of Modelica 2.2.2.</li>
<li><i>Nov. 2, 2005</i>
       by Francesco Casella: restructured after 45th Design Meeting.</li>
<li><i>Nov. 20-21, 2002</i>
       by Hilding Elmqvist, Mike Tiller, Allan Watson, John Batteh, Chuck Newman,
       Jonas Eborn: Improved at the 32nd Modelica Design Meeting.
<li><i>Nov. 11, 2002</i>
       by Hilding Elmqvist, Martin Otter: improved version.</li>
<li><i>Nov. 6, 2002</i>
       by Hilding Elmqvist: first version.</li>
<li><i>Aug. 11, 2002</i>
       by Martin Otter: Improved according to discussion with Hilding
       Elmqvist and Hubertus Tummescheit.<br>
       The PortVicinity model is manually
       expanded in the base models.<br>
       The Volume used for components is renamed
       PartialComponentVolume.<br>
       A new volume model \"Fluid.Components.PortVolume\"
       introduced that has the medium properties of the port to which it is
       connected.<br>
       Fluid.Interfaces.PartialTwoPortTransport is a component
       for elementary two port transport elements, whereas PartialTwoPort
       is a component for a container component.</li>
</li>
</ul>
</html>"));
    end Interfaces;

    package Types "Common types for fluid models"
      extends Modelica.Icons.Package;

      type Dynamics = enumeration(
        DynamicFreeInitial
          "DynamicFreeInitial -- Dynamic balance, Initial guess value",
        FixedInitial "FixedInitial -- Dynamic balance, Initial value fixed",
        SteadyStateInitial
          "SteadyStateInitial -- Dynamic balance, Steady state initial with guess value",

        SteadyState "SteadyState -- Steady state balance, Initial guess value")
      "Enumeration to define definition of balance equations"
      annotation (Documentation(info="<html>
<p>
Enumeration to define the formulation of balance equations
(to be selected via choices menu):
</p>

<table border=1 cellspacing=0 cellpadding=2>
<tr><th><b>Dynamics.</b></th><th><b>Meaning</b></th></tr>
<tr><td>DynamicFreeInitial</td><td>Dynamic balance, Initial guess value</td></tr>

<tr><td>FixedInitial</td><td>Dynamic balance, Initial value fixed</td></tr>

<tr><td>SteadyStateInitial</td><td>Dynamic balance, Steady state initial with guess value</td></tr>

<tr><td>SteadyState</td><td>Steady state balance, Initial guess value</td></tr>
</table>

<p>
The enumeration \"Dynamics\" is used for the mass, energy and momentum balance equations
respectively. The exact meaning for the three balance equations is stated in the following
tables:
</p>

<table border=1 cellspacing=0 cellpadding=2>
<tr><td colspan=\"3\"><b>Mass balance</b> </td>
<tr><td><b>Dynamics.</b></td>
    <td><b>Balance equation</b></td>
    <td><b>Initial condition</b></td></tr>

<tr><td> DynamicFreeInitial</td>
    <td> no restrictions </td>
    <td> no initial conditions </td></tr>

<tr><td> FixedInitial</td>
    <td> no restrictions </td>
    <td> <b>if</b> Medium.singleState <b>then</b> <br>
         &nbsp;&nbsp;no initial condition<br>
         <b>else</b> p=p_start </td></tr>

<tr><td> SteadyStateInitial</td>
    <td> no restrictions </td>
    <td> <b>if</b> Medium.singleState <b>then</b> <br>
         &nbsp;&nbsp;no initial condition<br>
         <b>else</b> <b>der</b>(p)=0 </td></tr>

<tr><td> SteadyState</td>
    <td> <b>der</b>(m)=0  </td>
    <td> no initial conditions </td></tr>
</table>

&nbsp;<br>

<table border=1 cellspacing=0 cellpadding=2>
<tr><td colspan=\"3\"><b>Energy balance</b> </td>
<tr><td><b>Dynamics.</b></td>
    <td><b>Balance equation</b></td>
    <td><b>Initial condition</b></td></tr>

<tr><td> DynamicFreeInitial</td>
    <td> no restrictions </td>
    <td> no initial conditions </td></tr>

<tr><td> FixedInitial</td>
    <td> no restrictions </td>
    <td> T=T_start or h=h_start </td></tr>

<tr><td> SteadyStateInitial</td>
    <td> no restrictions </td>
    <td> <b>der</b>(T)=0 or <b>der</b>(h)=0 </td></tr>

<tr><td> SteadyState</td>
    <td> <b>der</b>(U)=0  </td>
    <td> no initial conditions </td></tr>
</table>

&nbsp;<br>

<table border=1 cellspacing=0 cellpadding=2>
<tr><td colspan=\"3\"><b>Momentum balance</b> </td>
<tr><td><b>Dynamics.</b></td>
    <td><b>Balance equation</b></td>
    <td><b>Initial condition</b></td></tr>

<tr><td> DynamicFreeInitial</td>
    <td> no restrictions </td>
    <td> no initial conditions </td></tr>

<tr><td> FixedInitial</td>
    <td> no restrictions </td>
    <td> m_flow = m_flow_start </td></tr>

<tr><td> SteadyStateInitial</td>
    <td> no restrictions </td>
    <td> <b>der</b>(m_flow)=0 </td></tr>

<tr><td> SteadyState</td>
    <td> <b>der</b>(m_flow)=0 </td>
    <td> no initial conditions </td></tr>
</table>

<p>
In the tables above, the equations are given for one-substance fluids. For multiple-substance
fluids and for trace substances, equivalent equations hold.
</p>

<p>
Medium.singleState is a medium property and defines whether the medium is only
described by one state (+ the mass fractions in case of a multi-substance fluid). In such
a case one initial condition less must be provided. For example, incompressible
media have Medium.singleState = <b>true</b>.
</p>

</html>"));

      type PortFlowDirection = enumeration(
        Entering "Fluid flow is only entering",
        Leaving "Fluid flow is only leaving",
        Bidirectional "No restrictions on fluid flow (flow reversal possible)")
      "Enumeration to define whether flow reversal is allowed"   annotation (
          Documentation(info="<html>

<p>
Enumeration to define the assumptions on the model for the
direction of fluid flow at a port (to be selected via choices menu):
</p>

<table border=1 cellspacing=0 cellpadding=2>
<tr><th><b>PortFlowDirection.</b></th>
    <th><b>Meaning</b></th></tr>

<tr><td>Entering</td>
    <td>Fluid flow is only entering the port from the outside</td></tr>

<tr><td>Leaving</td>
    <td>Fluid flow is only leaving the port to the outside</td></tr>

<tr><td>Bidirectional</td>
    <td>No restrictions on fluid flow (flow reversal possible)</td></tr>
</table>

<p>
The default is \"PortFlowDirection.Bidirectional\". If you are completely sure that
the flow is only in one direction, then the other settings may
make the simulation of your model faster.
</p>

</html>"));
      annotation (preferedView="info",
                  Documentation(info="<html>

</html>"));
    end Types;

    package Utilities
    "Utility models to construct fluid components (should not be used directly) "
      extends Modelica.Icons.Package;

      function checkBoundary "Check whether boundary definition is correct"
        extends Modelica.Icons.Function;
        input String mediumName;
        input String substanceNames[:] "Names of substances";
        input Boolean singleState;
        input Boolean define_p;
        input Real X_boundary[:];
        input String modelName = "??? boundary ???";
    protected
        Integer nX = size(X_boundary,1);
        String X_str;
      algorithm
        assert(not singleState or singleState and define_p, "
Wrong value of parameter define_p (= false) in model \""       + modelName + "\":
The selected medium \""     + mediumName + "\" has Medium.singleState=true.
Therefore, an boundary density cannot be defined and
define_p = true is required.
");

        for i in 1:nX loop
          assert(X_boundary[i] >= 0.0, "
Wrong boundary mass fractions in medium \""
      + mediumName + "\" in model \"" + modelName + "\":
The boundary value X_boundary("   + String(i) + ") = " + String(
            X_boundary[i]) + "
is negative. It must be positive.
");
        end for;

        if nX > 0 and abs(sum(X_boundary) - 1.0) > 1.e-10 then
           X_str :="";
           for i in 1:nX loop
              X_str :=X_str + "   X_boundary[" + String(i) + "] = " + String(X_boundary[
              i]) + " \"" + substanceNames[i] + "\"\n";
           end for;
           Modelica.Utilities.Streams.error(
              "The boundary mass fractions in medium \"" + mediumName + "\" in model \"" + modelName + "\"\n" +
              "do not sum up to 1. Instead, sum(X_boundary) = " + String(sum(X_boundary)) + ":\n"
              + X_str);
        end if;
      end checkBoundary;

      function regRoot2
      "Anti-symmetric approximation of square root with discontinuous factor so that the first derivative is finite and continuous"

        extends Modelica.Icons.Function;
        input Real x "abscissa value";
        input Real x_small(min=0)=0.01
        "approximation of function for |x| <= x_small";
        input Real k1(min=0)=1 "y = if x>=0 then sqrt(k1*x) else -sqrt(k2*|x|)";
        input Real k2(min=0)=1 "y = if x>=0 then sqrt(k1*x) else -sqrt(k2*|x|)";
        input Boolean use_yd0 = false "= true, if yd0 shall be used";
        input Real yd0(min=0)=1 "Desired derivative at x=0: dy/dx = yd0";
        output Real y "ordinate value";
    protected
        encapsulated function regRoot2_utility
        "Interpolating with two 3-order polynomials with a prescribed derivative at x=0"
          import Modelica.Fluid.Utilities.evaluatePoly3_derivativeAtZero;
           input Real x;
           input Real x1 "approximation of function abs(x) < x1";
           input Real k1
          "y = if x>=0 then sqrt(k1*x) else -sqrt(k2*|x|); k1 >= k2";
           input Real k2 "y = if x>=0 then sqrt(k1*x) else -sqrt(k2*|x|))";
           input Boolean use_yd0 "= true, if yd0 shall be used";
           input Real yd0(min=0) "Desired derivative at x=0: dy/dx = yd0";
           output Real y;
      protected
           Real x2;
           Real xsqrt1;
           Real xsqrt2;
           Real y1;
           Real y2;
           Real y1d;
           Real y2d;
           Real w;
           Real y0d;
           Real w1;
           Real w2;
        algorithm
           if k2 > 0 then
              x2 :=-x1*(k2/k1);
           else
              x2 := -x1;
           end if;

           if x <= x2 then
              y := -sqrt(k2*abs(x));
           else
              y1 :=sqrt(k1*x1);
              y2 :=-sqrt(k2*abs(x2));
              y1d :=sqrt(k1/x1)/2;
              y2d :=sqrt(k2/abs(x2))/2;

              if use_yd0 then
                 y0d :=yd0;
              else
                 /* Determine derivative, such that first and second derivative
              of left and right polynomial are identical at x=0:
           _
           Basic equations:
              y_right = a1*(x/x1) + a2*(x/x1)^2 + a3*(x/x1)^3
              y_left  = b1*(x/x2) + b2*(x/x2)^2 + b3*(x/x2)^3
              yd_right*x1 = a1 + 2*a2*(x/x1) + 3*a3*(x/x1)^2
              yd_left *x2 = b1 + 2*b2*(x/x2) + 3*b3*(x/x2)^2
              ydd_right*x1^2 = 2*a2 + 6*a3*(x/x1)
              ydd_left *x2^2 = 2*b2 + 6*b3*(x/x2)
           _
           Conditions (6 equations for 6 unknowns):
                     y1 = a1 + a2 + a3
                     y2 = b1 + b2 + b3
                 y1d*x1 = a1 + 2*a2 + 3*a3
                 y2d*x2 = b1 + 2*b2 + 3*b3
                    y0d = a1/x1 = b1/x2
                   y0dd = 2*a2/x1^2 = 2*b2/x2^2
           _
           Derived equations:
              b1 = a1*x2/x1
              b2 = a2*(x2/x1)^2
              b3 = y2 - b1 - b2
                 = y2 - a1*(x2/x1) - a2*(x2/x1)^2
              a3 = y1 - a1 - a2
           _
           Remaining equations
              y1d*x1 = a1 + 2*a2 + 3*(y1 - a1 - a2)
                     = 3*y1 - 2*a1 - a2
              y2d*x2 = a1*(x2/x1) + 2*a2*(x2/x1)^2 +
                       3*(y2 - a1*(x2/x1) - a2*(x2/x1)^2)
                     = 3*y2 - 2*a1*(x2/x1) - a2*(x2/x1)^2
              y0d    = a1/x1
           _
           Solving these equations results in y0d below
           (note, the denominator "(1-w)" is always non-zero, because w is negative)
           */
                 w :=x2/x1;
                 y0d := ( (3*y2 - x2*y2d)/w - (3*y1 - x1*y1d)*w) /(2*x1*(1 - w));
              end if;

              /* Modify derivative y0d, such that the polynomial is
           monotonically increasing. A sufficient condition is
             0 <= y0d <= sqrt(8.75*k_i/|x_i|)
        */
              w1 :=sqrt(8.75*k1/x1);
              w2 :=sqrt(8.75*k2/abs(x2));
              y0d :=min(y0d, 0.9*min(w1, w2));

              /* Perform interpolation in scaled polynomial:
           y_new = y/y1
           x_new = x/x1
        */
              y := y1*(if x >= 0 then evaluatePoly3_derivativeAtZero(x/x1,1,1,y1d*x1/y1,y0d*x1/y1) else
                                      evaluatePoly3_derivativeAtZero(x/x1,x2/x1,y2/y1,y2d*x1/y1,y0d*x1/y1));
           end if;
           annotation(smoothOrder=2);
        end regRoot2_utility;
      algorithm
        y := smooth(2, if x >= x_small then sqrt(k1*x) else
                       if x <= -x_small then -sqrt(k2*abs(x)) else
                       if k1 >= k2 then regRoot2_utility(x,x_small,k1,k2,use_yd0,yd0) else
                                       -regRoot2_utility(-x,x_small,k2,k1,use_yd0,yd0));
        annotation(smoothOrder=2, Documentation(info="<html>
<p>
Approximates the function
</p>
<pre>
   y = <b>if</b> x &ge; 0 <b>then</b> <b>sqrt</b>(k1*x) <b>else</b> -<b>sqrt</b>(k2*<b>abs</b>(x)), with k1, k2 &ge; 0
</pre>
<p>
in such a way that within the region -x_small &le; x &le; x_small,
the function is described by two polynomials of third order
(one in the region -x_small .. 0 and one within the region 0 .. x_small)
such that
</p>
<ul>
<li> The derivative at x=0 is finite. </li>
<li> The overall function is continuous with a
     continuous first derivative everywhere.</li>
<li> If parameter use_yd0 = <b>false</b>, the two polynomials
     are constructed such that the second derivatives at x=0
     are identical. If use_yd0 = <b>true</b>, the derivative
     at x=0 is explicitly provided via the additional argument
     yd0. If necessary, the derivative yd0 is automatically
     reduced in order that the polynomials are strict monotonically
     increasing <i>[Fritsch and Carlson, 1980]</i>.</li>
</ul>
<p>
Typical screenshots for two different configurations
are shown below. The first one with k1=k2=1:
</p>
<p>
<img src=\"modelica://Modelica/Resources/Images/Fluid/Components/regRoot2_a.png\">
</p>
<p>
and the second one with k1=1 and k2=3:
</p>
<p>
<img src=\"modelica://Modelica/Resources/Images/Fluid/Components/regRoot2_b.png\">
</p>

<p>
The (smooth) derivative of the function with
k1=1, k2=3 is shown in the next figure:
<p>
<img src=\"modelica://Modelica/Resources/Images/Fluid/Components/regRoot2_c.png\">
</p>

<p>
<b>Literature</b>
</p>

<dl>
<dt> Fritsch F.N. and Carlson R.E. (1980):</dt>
<dd> <b>Monotone piecewise cubic interpolation</b>.
     SIAM J. Numerc. Anal., Vol. 17, No. 2, April 1980, pp. 238-246</dd>
</dl>
</html>",     revisions="<html>
<ul>
<li><i>Sept., 2019</i>
    by <a href=\"mailto:Martin.Otter@DLR.de\">Martin Otter</a>:<br>
    Improved so that k1=0 and/or k2=0 is also possible.</li>
<li><i>Nov., 2005</i>
    by <a href=\"mailto:Martin.Otter@DLR.de\">Martin Otter</a>:<br>
    Designed and implemented.</li>
</ul>
</html>"));
      end regRoot2;

      function regSquare2
      "Anti-symmetric approximation of square with discontinuous factor so that the first derivative is non-zero and is continuous"
        extends Modelica.Icons.Function;
        input Real x "abscissa value";
        input Real x_small(min=0)=0.01
        "approximation of function for |x| <= x_small";
        input Real k1(min=0)=1 "y = (if x>=0 then k1 else k2)*x*|x|";
        input Real k2(min=0)=1 "y = (if x>=0 then k1 else k2)*x*|x|";
        input Boolean use_yd0 = false "= true, if yd0 shall be used";
        input Real yd0(min=0)=1 "Desired derivative at x=0: dy/dx = yd0";
        output Real y "ordinate value";
    protected
        encapsulated function regSquare2_utility
        "Interpolating with two 3-order polynomials with a prescribed derivative at x=0"
          import Modelica.Fluid.Utilities.evaluatePoly3_derivativeAtZero;
           input Real x;
           input Real x1 "approximation of function abs(x) < x1";
           input Real k1 "y = (if x>=0 then k1 else -k2)*x*|x|; k1 >= k2";
           input Real k2 "y = (if x>=0 then k1 else -k2)*x*|x|";
           input Boolean use_yd0 = false "= true, if yd0 shall be used";
           input Real yd0(min=0)=1 "Desired derivative at x=0: dy/dx = yd0";
           output Real y;
      protected
           Real x2;
           Real y1;
           Real y2;
           Real y1d;
           Real y2d;
           Real w;
           Real w1;
           Real w2;
           Real y0d;
           Real ww;
        algorithm
           // x2 :=-x1*(k2/k1)^2;
           x2 := -x1;
           if x <= x2 then
              y := -k2*x^2;
           else
               y1 := k1*x1^2;
               y2 :=-k2*x2^2;
              y1d := k1*2*x1;
              y2d :=-k2*2*x2;
              if use_yd0 then
                 y0d :=yd0;
              else
                 /* Determine derivative, such that first and second derivative
              of left and right polynomial are identical at x=0:
              see derivation in function regRoot2
           */
                 w :=x2/x1;
                 y0d := ( (3*y2 - x2*y2d)/w - (3*y1 - x1*y1d)*w) /(2*x1*(1 - w));
              end if;

              /* Modify derivative y0d, such that the polynomial is
           monotonically increasing. A sufficient condition is
             0 <= y0d <= sqrt(5)*k_i*|x_i|
        */
              w1 :=sqrt(5)*k1*x1;
              w2 :=sqrt(5)*k2*abs(x2);
              // y0d :=min(y0d, 0.9*min(w1, w2));
              ww :=0.9*(if w1 < w2 then w1 else w2);
              if ww < y0d then
                 y0d :=ww;
              end if;
              y := if x >= 0 then evaluatePoly3_derivativeAtZero(x,x1,y1,y1d,y0d) else
                                  evaluatePoly3_derivativeAtZero(x,x2,y2,y2d,y0d);
           end if;
           annotation(smoothOrder=2);
        end regSquare2_utility;
      algorithm
        y := smooth(2,if x >= x_small then k1*x^2 else
                      if x <= -x_small then -k2*x^2 else
                      if k1 >= k2 then regSquare2_utility(x,x_small,k1,k2,use_yd0,yd0) else
                                      -regSquare2_utility(-x,x_small,k2,k1,use_yd0,yd0));
        annotation(smoothOrder=2, Documentation(info="<html>
<p>
Approximates the function
</p>
<pre>
   y = <b>if</b> x &ge; 0 <b>then</b> k1*x*x <b>else</b> -k2*x*x, with k1, k2 > 0
</pre>
<p>
in such a way that within the region -x_small &le; x &le; x_small,
the function is described by two polynomials of third order
(one in the region -x_small .. 0 and one within the region 0 .. x_small)
such that
</p>

<ul>
<li> The derivative at x=0 is non-zero (in order that the
     inverse of the function does not have an infinite derivative). </li>
<li> The overall function is continuous with a
     continuous first derivative everywhere.</li>
<li> If parameter use_yd0 = <b>false</b>, the two polynomials
     are constructed such that the second derivatives at x=0
     are identical. If use_yd0 = <b>true</b>, the derivative
     at x=0 is explicitly provided via the additional argument
     yd0. If necessary, the derivative yd0 is automatically
     reduced in order that the polynomials are strict monotonically
     increasing <i>[Fritsch and Carlson, 1980]</i>.</li>
</ul>

<p>
A typical screenshot for k1=1, k2=3 is shown in the next figure:
</p>
<p>
<img src=\"modelica://Modelica/Resources/Images/Fluid/Components/regSquare2_b.png\">
</p>

<p>
The (smooth, non-zero) derivative of the function with
k1=1, k2=3 is shown in the next figure:
</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/Fluid/Components/regSquare2_c.png\">
</p>

<p>
<b>Literature</b>
</p>

<dl>
<dt> Fritsch F.N. and Carlson R.E. (1980):</dt>
<dd> <b>Monotone piecewise cubic interpolation</b>.
     SIAM J. Numerc. Anal., Vol. 17, No. 2, April 1980, pp. 238-246</dd>
</dl>
</html>",     revisions="<html>
<ul>
<li><i>Nov., 2005</i>
    by <a href=\"mailto:Martin.Otter@DLR.de\">Martin Otter</a>:<br>
    Designed and implemented.</li>
</ul>
</html>"));
      end regSquare2;

      function regStep
      "Approximation of a general step, such that the characteristic is continuous and differentiable"
        extends Modelica.Icons.Function;
        input Real x "Abscissa value";
        input Real y1 "Ordinate value for x > 0";
        input Real y2 "Ordinate value for x < 0";
        input Real x_small(min=0) = 1e-5
        "Approximation of step for -x_small <= x <= x_small; x_small >= 0 required";
        output Real y
        "Ordinate value to approximate y = if x > 0 then y1 else y2";
      algorithm
        y := smooth(1, if x >  x_small then y1 else
                       if x < -x_small then y2 else
                       if x_small > 0 then (x/x_small)*((x/x_small)^2 - 3)*(y2-y1)/4 + (y1+y2)/2 else (y1+y2)/2);
        annotation(Documentation(revisions="<html>
<ul>
<li><i>April 29, 2008</i>
    by <a href=\"mailto:Martin.Otter@DLR.de\">Martin Otter</a>:<br>
    Designed and implemented.</li>
<li><i>August 12, 2008</i>
    by <a href=\"mailto:Michael.Sielemann@dlr.de\">Michael Sielemann</a>:<br>
    Minor modification to cover the limit case <code>x_small -> 0</code> without division by zero.</li>
</ul>
</html>",       info="<html>
<p>
This function is used to approximate the equation
</p>
<pre>
    y = <b>if</b> x &gt; 0 <b>then</b> y1 <b>else</b> y2;
</pre>

<p>
by a smooth characteristic, so that the expression is continuous and differentiable:
</p>

<pre>
   y = <b>smooth</b>(1, <b>if</b> x &gt;  x_small <b>then</b> y1 <b>else</b>
                 <b>if</b> x &lt; -x_small <b>then</b> y2 <b>else</b> f(y1, y2));
</pre>

<p>
In the region -x_small &lt; x &lt; x_small a 2nd order polynomial is used
for a smooth transition from y1 to y2.
</p>
</html>"));
      end regStep;

      function evaluatePoly3_derivativeAtZero
      "Evaluate polynomial of order 3 that passes the origin with a predefined derivative"
        extends Modelica.Icons.Function;
        input Real x "Value for which polynomial shall be evaluated";
        input Real x1 "Abscissa value";
        input Real y1 "y1=f(x1)";
        input Real y1d "First derivative at y1";
        input Real y0d "First derivative at f(x=0)";
        output Real y;
    protected
        Real a1;
        Real a2;
        Real a3;
        Real xx;
      algorithm
        a1 := x1*y0d;
        a2 := 3*y1 - x1*y1d - 2*a1;
        a3 := y1 - a2 - a1;
        xx := x/x1;
        y  := xx*(a1 + xx*(a2 + xx*a3));
        annotation(smoothOrder=3, Documentation(info="<html>

</html>"));
      end evaluatePoly3_derivativeAtZero;

      function cubicHermite "Evaluate a cubic Hermite spline"
        input Real x "Abscissa value";
        input Real x1 "Lower abscissa value";
        input Real x2 "Upper abscissa value";
        input Real y1 "Lower ordinate value";
        input Real y2 "Upper ordinate value";
        input Real y1d "Lower gradient";
        input Real y2d "Upper gradient";
        output Real y "Interpolated ordinate value";
    protected
        Real h "Distance between x1 and x2";
        Real t "abscissa scaled with h, i.e., t=[0..1] within x=[x1..x2]";
        Real h00 "Basis function 00 of cubic Hermite spline";
        Real h10 "Basis function 10 of cubic Hermite spline";
        Real h01 "Basis function 01 of cubic Hermite spline";
        Real h11 "Basis function 11 of cubic Hermite spline";
        Real aux3 "t cube";
        Real aux2 "t square";
      algorithm
        h := x2 - x1;
        if abs(h)>0 then
          // Regular case
          t := (x - x1)/h;

          aux3 :=t^3;
          aux2 :=t^2;

          h00 := 2*aux3 - 3*aux2 + 1;
          h10 := aux3 - 2*aux2 + t;
          h01 := -2*aux3 + 3*aux2;
          h11 := aux3 - aux2;
          y := y1*h00 + h*y1d*h10 + y2*h01 + h*y2d*h11;
        else
          // Degenerate case, x1 and x2 are identical, return step function
          y := (y1 + y2)/2;
        end if;
        annotation(smoothOrder=3, Documentation(revisions="<html>
<ul>
<li><i>May 2008</i>
    by <a href=\"mailto:Michael.Sielemann@dlr.de\">Michael Sielemann</a>:<br>
    Designed and implemented.</li>
</ul>
</html>"));
      end cubicHermite;
      annotation (Documentation(info="<html>

</html>"));
    end Utilities;
  annotation (
    preferedView="info",
    __Dymola_classOrder={"UsersGuide","Examples","System","Vessels","Pipes","Machines","Valves",
        "Fittings", "Sources", "Sensors", "Interfaces", "Types", "Utilities", "Icons", "*"},
    Documentation(info="<html>
<p>
Library <b>Modelica.Fluid</b> is a <b>free</b> Modelica package providing components for
<b>1-dimensional thermo-fluid flow</b> in networks of vessels, pipes, fluid machines, valves and fittings.
A unique feature is that the component equations and the media models
as well as pressure loss and heat transfer correlations are decoupled from each other.
All components are implemented such that they can be used for
media from the Modelica.Media library. This means especially that an
incompressible or compressible medium, a single or a multiple
substance medium with one or more phases might be used.
</p>

<p>
In the next figure, several features of the library are demonstrated with
a simple heating system with a closed flow cycle. By just changing one configuration parameter in the system object the equations are changed between steady-state and dynamic simulation with fixed or steady-state initial conditions.
</p>

<img src=\"modelica://Modelica/Resources/Images/Fluid/UsersGuide/HeatingSystem.png\" border=1>

<p>
With respect to previous versions, the design
of the connectors has been changed in a non-backward compatible way,
using the recently developed concept
of stream connectors that results in much more reliable simulations
(see also <a href=\"modelica://Modelica/Resources/Documentation/Fluid/Stream-Connectors-Overview-Rationale.pdf\">Stream-Connectors-Overview-Rationale.pdf</a>).
This extension was included in Modelica 3.1.
As of Jan. 2009, the stream concept is supported in Dymola 7.1.
It is recommended to use Dymola 7.2 (available since Feb. 2009), or a later Dymola version,
since this version supports a new annotation to connect very
conveniently to vectors of connectors.
Other tool vendors will support the stream concept as well.
</p>

<p>
The following parts are useful, when newly starting with this library:
</p>
<ul>
<li> <a href=\"modelica://Modelica.Fluid.UsersGuide\">Modelica.Fluid.UsersGuide</a>.</li>
<li> <a href=\"modelica://Modelica.Fluid.UsersGuide.ReleaseNotes\">Modelica.Fluid.UsersGuide.ReleaseNotes</a>
     summarizes the changes of the library releases.</li>
<li> <a href=\"modelica://Modelica.Fluid.Examples\">Modelica.Fluid.Examples</a>
     contains examples that demonstrate the usage of this library.</li>
</ul>
<p>
<b>Licensed by the Modelica Association under the Modelica License 2</b><br>
Copyright &copy; 2002-2010, ABB, DLR, Dassault Syst&egrave;mes AB, Modelon, TU Braunschweig, TU Hamburg-Harburg, Politecnico di Milano.
</p>
<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"http://www.modelica.org/licenses/ModelicaLicense2\"> http://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>
</html>"));
  end Fluid;

  package Media "Library of media property models"
  extends Modelica.Icons.Package;
  import SI = Modelica.SIunits;

  package Interfaces "Interfaces for media models"
    extends Modelica.Icons.InterfacesPackage;
    import SI = Modelica.SIunits;

    partial package PartialMedium
    "Partial medium properties (base package of all media packages)"

      import SI = Modelica.SIunits;
      extends Modelica.Icons.MaterialPropertiesPackage;

      // Constants to be set in Medium
      constant
      Modelica.Media.Interfaces.PartialMedium.Choices.IndependentVariables
        ThermoStates "Enumeration type for independent variables";
      constant String mediumName = "unusablePartialMedium" "Name of the medium";
      constant String substanceNames[:]={mediumName}
      "Names of the mixture substances. Set substanceNames={mediumName} if only one substance.";
      constant String extraPropertiesNames[:]=fill("", 0)
      "Names of the additional (extra) transported properties. Set extraPropertiesNames=fill(\"\",0) if unused";
      constant Boolean singleState
      "= true, if u and d are not a function of pressure";
      constant Boolean reducedX=true
      "= true if medium contains the equation sum(X) = 1.0; set reducedX=true if only one substance (see docu for details)";
      constant Boolean fixedX=false
      "= true if medium contains the equation X = reference_X";
      constant AbsolutePressure reference_p=101325
      "Reference pressure of Medium: default 1 atmosphere";
      constant Temperature reference_T=298.15
      "Reference temperature of Medium: default 25 deg Celsius";
      constant MassFraction reference_X[nX]= fill(1/nX, nX)
      "Default mass fractions of medium";
      constant AbsolutePressure p_default=101325
      "Default value for pressure of medium (for initialization)";
      constant Temperature T_default = Modelica.SIunits.Conversions.from_degC(20)
      "Default value for temperature of medium (for initialization)";
      constant SpecificEnthalpy h_default = specificEnthalpy_pTX(p_default, T_default, X_default)
      "Default value for specific enthalpy of medium (for initialization)";
      constant MassFraction X_default[nX]=reference_X
      "Default value for mass fractions of medium (for initialization)";

      final constant Integer nS=size(substanceNames, 1) "Number of substances" annotation(Evaluate=true);
      constant Integer nX = nS "Number of mass fractions"
                                   annotation(Evaluate=true);
      constant Integer nXi=if fixedX then 0 else if reducedX then nS - 1 else nS
      "Number of structurally independent mass fractions (see docu for details)"
        annotation(Evaluate=true);

      final constant Integer nC=size(extraPropertiesNames, 1)
      "Number of extra (outside of standard mass-balance) transported properties"
       annotation(Evaluate=true);
      constant Real C_nominal[nC](min=fill(Modelica.Constants.eps, nC)) = 1.0e-6*ones(nC)
      "Default for the nominal values for the extra properties";
      replaceable record FluidConstants
      "critical, triple, molecular and other standard data of fluid"
        extends Modelica.Icons.Record;
        String iupacName
        "complete IUPAC name (or common name, if non-existent)";
        String casRegistryNumber
        "chemical abstracts sequencing number (if it exists)";
        String chemicalFormula
        "Chemical formula, (brutto, nomenclature according to Hill";
        String structureFormula "Chemical structure formula";
        MolarMass molarMass "molar mass";
      end FluidConstants;

      replaceable record ThermodynamicState
      "Minimal variable set that is available as input argument to every medium function"
        extends Modelica.Icons.Record;
      end ThermodynamicState;

      replaceable partial model BaseProperties
      "Base properties (p, d, T, h, u, R, MM and, if applicable, X and Xi) of a medium"
        InputAbsolutePressure p "Absolute pressure of medium";
        InputMassFraction[nXi] Xi(start=reference_X[1:nXi])
        "Structurally independent mass fractions";
        InputSpecificEnthalpy h "Specific enthalpy of medium";
        Density d "Density of medium";
        Temperature T "Temperature of medium";
        MassFraction[nX] X(start=reference_X)
        "Mass fractions (= (component mass)/total mass  m_i/m)";
        SpecificInternalEnergy u "Specific internal energy of medium";
        SpecificHeatCapacity R "Gas constant (of mixture if applicable)";
        MolarMass MM "Molar mass (of mixture or single fluid)";
        ThermodynamicState state
        "thermodynamic state record for optional functions";
        parameter Boolean preferredMediumStates=false
        "= true if StateSelect.prefer shall be used for the independent property variables of the medium"
          annotation (Evaluate=true, Dialog(tab="Advanced"));
        parameter Boolean standardOrderComponents = true
        "if true, and reducedX = true, the last element of X will be computed from the other ones";
        SI.Conversions.NonSIunits.Temperature_degC T_degC=
            Modelica.SIunits.Conversions.to_degC(T)
        "Temperature of medium in [degC]";
        SI.Conversions.NonSIunits.Pressure_bar p_bar=
         Modelica.SIunits.Conversions.to_bar(p)
        "Absolute pressure of medium in [bar]";

        // Local connector definition, used for equation balancing check
        connector InputAbsolutePressure = input SI.AbsolutePressure
        "Pressure as input signal connector";
        connector InputSpecificEnthalpy = input SI.SpecificEnthalpy
        "Specific enthalpy as input signal connector";
        connector InputMassFraction = input SI.MassFraction
        "Mass fraction as input signal connector";

      equation
        if standardOrderComponents then
          Xi = X[1:nXi];

            if fixedX then
              X = reference_X;
            end if;
            if reducedX and not fixedX then
              X[nX] = 1 - sum(Xi);
            end if;
            for i in 1:nX loop
              assert(X[i] >= -1.e-5 and X[i] <= 1 + 1.e-5, "Mass fraction X[" +
                     String(i) + "] = " + String(X[i]) + "of substance "
                     + substanceNames[i] + "\nof medium " + mediumName + " is not in the range 0..1");
            end for;

        end if;

        assert(p >= 0.0, "Pressure (= " + String(p) + " Pa) of medium \"" +
          mediumName + "\" is negative\n(Temperature = " + String(T) + " K)");
        annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}), graphics={Rectangle(
                extent={{-100,100},{100,-100}},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid,
                lineColor={0,0,255}), Text(
                extent={{-152,164},{152,102}},
                textString="%name",
                lineColor={0,0,255})}),
                    Documentation(info="<html>
<p>
Model <b>BaseProperties</b> is a model within package <b>PartialMedium</b>
and contains the <b>declarations</b> of the minimum number of
variables that every medium model is supposed to support.
A specific medium inherits from model <b>BaseProperties</b> and provides
the equations for the basic properties.</p>
<p>
The BaseProperties model contains the following <b>7+nXi variables</b>
(nXi is the number of independent mass fractions defined in package
PartialMedium):
</p>
<table border=1 cellspacing=0 cellpadding=2>
  <tr><td valign=\"top\"><b>Variable</b></td>
      <td valign=\"top\"><b>Unit</b></td>
      <td valign=\"top\"><b>Description</b></td></tr>
  <tr><td valign=\"top\">T</td>
      <td valign=\"top\">K</td>
      <td valign=\"top\">temperature</td></tr>
  <tr><td valign=\"top\">p</td>
      <td valign=\"top\">Pa</td>
      <td valign=\"top\">absolute pressure</td></tr>
  <tr><td valign=\"top\">d</td>
      <td valign=\"top\">kg/m3</td>
      <td valign=\"top\">density</td></tr>
  <tr><td valign=\"top\">h</td>
      <td valign=\"top\">J/kg</td>
      <td valign=\"top\">specific enthalpy</td></tr>
  <tr><td valign=\"top\">u</td>
      <td valign=\"top\">J/kg</td>
      <td valign=\"top\">specific internal energy</td></tr>
  <tr><td valign=\"top\">Xi[nXi]</td>
      <td valign=\"top\">kg/kg</td>
      <td valign=\"top\">independent mass fractions m_i/m</td></tr>
  <tr><td valign=\"top\">R</td>
      <td valign=\"top\">J/kg.K</td>
      <td valign=\"top\">gas constant</td></tr>
  <tr><td valign=\"top\">M</td>
      <td valign=\"top\">kg/mol</td>
      <td valign=\"top\">molar mass</td></tr>
</table>
<p>
In order to implement an actual medium model, one can extend from this
base model and add <b>5 equations</b> that provide relations among
these variables. Equations will also have to be added in order to
set all the variables within the ThermodynamicState record state.</p>
<p>
If standardOrderComponents=true, the full composition vector X[nX]
is determined by the equations contained in this base class, depending
on the independent mass fraction vector Xi[nXi].</p>
<p>Additional <b>2 + nXi</b> equations will have to be provided
when using the BaseProperties model, in order to fully specify the
thermodynamic conditions. The input connector qualifier applied to
p, h, and nXi indirectly declares the number of missing equations,
permitting advanced equation balance checking by Modelica tools.
Please note that this doesn't mean that the additional equations
should be connection equations, nor that exactly those variables
should be supplied, in order to complete the model.
For further information, see the Modelica.Media User's guide, and
Section 4.7 (Balanced Models) of the Modelica 3.0 specification.</p>
</html>"));
      end BaseProperties;

      replaceable partial function setState_pTX
      "Return thermodynamic state as function of p, T and composition X or Xi"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input Temperature T "Temperature";
        input MassFraction X[:]=reference_X "Mass fractions";
        output ThermodynamicState state "thermodynamic state record";
      end setState_pTX;

      replaceable partial function setState_phX
      "Return thermodynamic state as function of p, h and composition X or Xi"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input SpecificEnthalpy h "Specific enthalpy";
        input MassFraction X[:]=reference_X "Mass fractions";
        output ThermodynamicState state "thermodynamic state record";
      end setState_phX;

      replaceable partial function setState_psX
      "Return thermodynamic state as function of p, s and composition X or Xi"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input SpecificEntropy s "Specific entropy";
        input MassFraction X[:]=reference_X "Mass fractions";
        output ThermodynamicState state "thermodynamic state record";
      end setState_psX;

      replaceable partial function setState_dTX
      "Return thermodynamic state as function of d, T and composition X or Xi"
        extends Modelica.Icons.Function;
        input Density d "density";
        input Temperature T "Temperature";
        input MassFraction X[:]=reference_X "Mass fractions";
        output ThermodynamicState state "thermodynamic state record";
      end setState_dTX;

      replaceable partial function setSmoothState
      "Return thermodynamic state so that it smoothly approximates: if x > 0 then state_a else state_b"
        extends Modelica.Icons.Function;
        input Real x "m_flow or dp";
        input ThermodynamicState state_a "Thermodynamic state if x > 0";
        input ThermodynamicState state_b "Thermodynamic state if x < 0";
        input Real x_small(min=0)
        "Smooth transition in the region -x_small < x < x_small";
        output ThermodynamicState state
        "Smooth thermodynamic state for all x (continuous and differentiable)";
        annotation(Documentation(info="<html>
<p>
This function is used to approximate the equation
</p>
<pre>
    state = <b>if</b> x &gt; 0 <b>then</b> state_a <b>else</b> state_b;
</pre>

<p>
by a smooth characteristic, so that the expression is continuous and differentiable:
</p>

<pre>
   state := <b>smooth</b>(1, <b>if</b> x &gt;  x_small <b>then</b> state_a <b>else</b>
                      <b>if</b> x &lt; -x_small <b>then</b> state_b <b>else</b> f(state_a, state_b));
</pre>

<p>
This is performed by applying function <b>Media.Common.smoothStep</b>(..)
on every element of the thermodynamic state record.
</p>

<p>
If <b>mass fractions</b> X[:] are approximated with this function then this can be performed
for all <b>nX</b> mass fractions, instead of applying it for nX-1 mass fractions and computing
the last one by the mass fraction constraint sum(X)=1. The reason is that the approximating function has the
property that sum(state.X) = 1, provided sum(state_a.X) = sum(state_b.X) = 1.
This can be shown by evaluating the approximating function in the abs(x) &lt; x_small
region (otherwise state.X is either state_a.X or state_b.X):
</p>

<pre>
    X[1]  = smoothStep(x, X_a[1] , X_b[1] , x_small);
    X[2]  = smoothStep(x, X_a[2] , X_b[2] , x_small);
       ...
    X[nX] = smoothStep(x, X_a[nX], X_b[nX], x_small);
</pre>

<p>
or
</p>

<pre>
    X[1]  = c*(X_a[1]  - X_b[1])  + (X_a[1]  + X_b[1])/2
    X[2]  = c*(X_a[2]  - X_b[2])  + (X_a[2]  + X_b[2])/2;
       ...
    X[nX] = c*(X_a[nX] - X_b[nX]) + (X_a[nX] + X_b[nX])/2;
    c     = (x/x_small)*((x/x_small)^2 - 3)/4
</pre>

<p>
Summing all mass fractions together results in
</p>

<pre>
    sum(X) = c*(sum(X_a) - sum(X_b)) + (sum(X_a) + sum(X_b))/2
           = c*(1 - 1) + (1 + 1)/2
           = 1
</pre>

</html>"));
      end setSmoothState;

      replaceable partial function dynamicViscosity "Return dynamic viscosity"
        extends Modelica.Icons.Function;
        input ThermodynamicState state "thermodynamic state record";
        output DynamicViscosity eta "Dynamic viscosity";
      end dynamicViscosity;

      replaceable partial function thermalConductivity
      "Return thermal conductivity"
        extends Modelica.Icons.Function;
        input ThermodynamicState state "thermodynamic state record";
        output ThermalConductivity lambda "Thermal conductivity";
      end thermalConductivity;

      replaceable function prandtlNumber "Return the Prandtl number"
        extends Modelica.Icons.Function;
        input ThermodynamicState state "thermodynamic state record";
        output PrandtlNumber Pr "Prandtl number";
      algorithm
        Pr := dynamicViscosity(state)*specificHeatCapacityCp(state)/thermalConductivity(
          state);
      end prandtlNumber;

      replaceable partial function pressure "Return pressure"
        extends Modelica.Icons.Function;
        input ThermodynamicState state "thermodynamic state record";
        output AbsolutePressure p "Pressure";
      end pressure;

      replaceable partial function temperature "Return temperature"
        extends Modelica.Icons.Function;
        input ThermodynamicState state "thermodynamic state record";
        output Temperature T "Temperature";
      end temperature;

      replaceable partial function density "Return density"
        extends Modelica.Icons.Function;
        input ThermodynamicState state "thermodynamic state record";
        output Density d "Density";
      end density;

      replaceable partial function specificEnthalpy "Return specific enthalpy"
        extends Modelica.Icons.Function;
        input ThermodynamicState state "thermodynamic state record";
        output SpecificEnthalpy h "Specific enthalpy";
      end specificEnthalpy;

      replaceable partial function specificInternalEnergy
      "Return specific internal energy"
        extends Modelica.Icons.Function;
        input ThermodynamicState state "thermodynamic state record";
        output SpecificEnergy u "Specific internal energy";
      end specificInternalEnergy;

      replaceable partial function specificEntropy "Return specific entropy"
        extends Modelica.Icons.Function;
        input ThermodynamicState state "thermodynamic state record";
        output SpecificEntropy s "Specific entropy";
      end specificEntropy;

      replaceable partial function specificGibbsEnergy
      "Return specific Gibbs energy"
        extends Modelica.Icons.Function;
        input ThermodynamicState state "thermodynamic state record";
        output SpecificEnergy g "Specific Gibbs energy";
      end specificGibbsEnergy;

      replaceable partial function specificHelmholtzEnergy
      "Return specific Helmholtz energy"
        extends Modelica.Icons.Function;
        input ThermodynamicState state "thermodynamic state record";
        output SpecificEnergy f "Specific Helmholtz energy";
      end specificHelmholtzEnergy;

      replaceable partial function specificHeatCapacityCp
      "Return specific heat capacity at constant pressure"
        extends Modelica.Icons.Function;
        input ThermodynamicState state "thermodynamic state record";
        output SpecificHeatCapacity cp
        "Specific heat capacity at constant pressure";
      end specificHeatCapacityCp;

      function heatCapacity_cp = specificHeatCapacityCp
      "alias for deprecated name";

      replaceable partial function specificHeatCapacityCv
      "Return specific heat capacity at constant volume"
        extends Modelica.Icons.Function;
        input ThermodynamicState state "thermodynamic state record";
        output SpecificHeatCapacity cv
        "Specific heat capacity at constant volume";
      end specificHeatCapacityCv;

      function heatCapacity_cv = specificHeatCapacityCv
      "alias for deprecated name";

      replaceable partial function isentropicExponent
      "Return isentropic exponent"
        extends Modelica.Icons.Function;
        input ThermodynamicState state "thermodynamic state record";
        output IsentropicExponent gamma "Isentropic exponent";
      end isentropicExponent;

      replaceable partial function isentropicEnthalpy
      "Return isentropic enthalpy"
        extends Modelica.Icons.Function;
        input AbsolutePressure p_downstream "downstream pressure";
        input ThermodynamicState refState "reference state for entropy";
        output SpecificEnthalpy h_is "Isentropic enthalpy";
        annotation(Documentation(info="<html>
<p>
This function computes an isentropic state transformation:
</p>
<ol>
<li> A medium is in a particular state, refState.</li>
<li> The enhalpy at another state (h_is) shall be computed
     under the assumption that the state transformation from refState to h_is
     is performed with a change of specific entropy ds = 0 and the pressure of state h_is
     is p_downstream and the composition X upstream and downstream is assumed to be the same.</li>
</ol>

</html>"));
      end isentropicEnthalpy;

      replaceable partial function velocityOfSound "Return velocity of sound"
        extends Modelica.Icons.Function;
        input ThermodynamicState state "thermodynamic state record";
        output VelocityOfSound a "Velocity of sound";
      end velocityOfSound;

      replaceable partial function isobaricExpansionCoefficient
      "Return overall the isobaric expansion coefficient beta"
        extends Modelica.Icons.Function;
        input ThermodynamicState state "thermodynamic state record";
        output IsobaricExpansionCoefficient beta
        "Isobaric expansion coefficient";
        annotation(Documentation(info="<html>
<pre>
beta is defined as  1/v * der(v,T), with v = 1/d, at constant pressure p.
</pre>
</html>"));
      end isobaricExpansionCoefficient;

      function beta = isobaricExpansionCoefficient
      "alias for isobaricExpansionCoefficient for user convenience";

      replaceable partial function isothermalCompressibility
      "Return overall the isothermal compressibility factor"
        extends Modelica.Icons.Function;
        input ThermodynamicState state "thermodynamic state record";
        output SI.IsothermalCompressibility kappa "Isothermal compressibility";
        annotation(Documentation(info="<html>
<pre>

kappa is defined as - 1/v * der(v,p), with v = 1/d at constant temperature T.

</pre>
</html>"));
      end isothermalCompressibility;

      function kappa = isothermalCompressibility
      "alias of isothermalCompressibility for user convenience";

      // explicit derivative functions for finite element models
      replaceable partial function density_derp_h
      "Return density derivative w.r.t. pressure at const specific enthalpy"
        extends Modelica.Icons.Function;
        input ThermodynamicState state "thermodynamic state record";
        output DerDensityByPressure ddph "Density derivative w.r.t. pressure";
      end density_derp_h;

      replaceable partial function density_derh_p
      "Return density derivative w.r.t. specific enthalpy at constant pressure"
        extends Modelica.Icons.Function;
        input ThermodynamicState state "thermodynamic state record";
        output DerDensityByEnthalpy ddhp
        "Density derivative w.r.t. specific enthalpy";
      end density_derh_p;

      replaceable partial function density_derp_T
      "Return density derivative w.r.t. pressure at const temperature"
        extends Modelica.Icons.Function;
        input ThermodynamicState state "thermodynamic state record";
        output DerDensityByPressure ddpT "Density derivative w.r.t. pressure";
      end density_derp_T;

      replaceable partial function density_derT_p
      "Return density derivative w.r.t. temperature at constant pressure"
        extends Modelica.Icons.Function;
        input ThermodynamicState state "thermodynamic state record";
        output DerDensityByTemperature ddTp
        "Density derivative w.r.t. temperature";
      end density_derT_p;

      replaceable partial function density_derX
      "Return density derivative w.r.t. mass fraction"
        extends Modelica.Icons.Function;
        input ThermodynamicState state "thermodynamic state record";
        output Density[nX] dddX "Derivative of density w.r.t. mass fraction";
      end density_derX;

      replaceable partial function molarMass
      "Return the molar mass of the medium"
        extends Modelica.Icons.Function;
        input ThermodynamicState state "thermodynamic state record";
        output MolarMass MM "Mixture molar mass";
      end molarMass;

      replaceable function specificEnthalpy_pTX
      "Return specific enthalpy from p, T, and X or Xi"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input Temperature T "Temperature";
        input MassFraction X[:]=reference_X "Mass fractions";
        output SpecificEnthalpy h "Specific enthalpy";
      algorithm
        h := specificEnthalpy(setState_pTX(p,T,X));
        annotation(inverse(T = temperature_phX(p,h,X)));
      end specificEnthalpy_pTX;

      replaceable function specificEntropy_pTX
      "Return specific enthalpy from p, T, and X or Xi"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input Temperature T "Temperature";
        input MassFraction X[:]=reference_X "Mass fractions";
        output SpecificEntropy s "Specific entropy";
      algorithm
        s := specificEntropy(setState_pTX(p,T,X));

        annotation(inverse(T = temperature_psX(p,s,X)));
      end specificEntropy_pTX;

      replaceable function density_pTX "Return density from p, T, and X or Xi"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input Temperature T "Temperature";
        input MassFraction X[:] "Mass fractions";
        output Density d "Density";
      algorithm
        d := density(setState_pTX(p,T,X));
      end density_pTX;

      replaceable function temperature_phX
      "Return temperature from p, h, and X or Xi"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input SpecificEnthalpy h "Specific enthalpy";
        input MassFraction X[:]=reference_X "Mass fractions";
        output Temperature T "Temperature";
      algorithm
        T := temperature(setState_phX(p,h,X));
      end temperature_phX;

      replaceable function density_phX "Return density from p, h, and X or Xi"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input SpecificEnthalpy h "Specific enthalpy";
        input MassFraction X[:]=reference_X "Mass fractions";
        output Density d "Density";
      algorithm
        d := density(setState_phX(p,h,X));
      end density_phX;

      replaceable function temperature_psX
      "Return temperature from p,s, and X or Xi"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input SpecificEntropy s "Specific entropy";
        input MassFraction X[:]=reference_X "Mass fractions";
        output Temperature T "Temperature";
      algorithm
        T := temperature(setState_psX(p,s,X));
        annotation(inverse(s = specificEntropy_pTX(p,T,X)));
      end temperature_psX;

      replaceable function density_psX "Return density from p, s, and X or Xi"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input SpecificEntropy s "Specific entropy";
        input MassFraction X[:]=reference_X "Mass fractions";
        output Density d "Density";
      algorithm
        d := density(setState_psX(p,s,X));
      end density_psX;

      replaceable function specificEnthalpy_psX
      "Return specific enthalpy from p, s, and X or Xi"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input SpecificEntropy s "Specific entropy";
        input MassFraction X[:]=reference_X "Mass fractions";
        output SpecificEnthalpy h "Specific enthalpy";
      algorithm
        h := specificEnthalpy(setState_psX(p,s,X));
      end specificEnthalpy_psX;

      type AbsolutePressure = SI.AbsolutePressure (
          min=0,
          max=1.e8,
          nominal=1.e5,
          start=1.e5)
      "Type for absolute pressure with medium specific attributes";

      type Density = SI.Density (
          min=0,
          max=1.e5,
          nominal=1,
          start=1) "Type for density with medium specific attributes";
      type DynamicViscosity = SI.DynamicViscosity (
          min=0,
          max=1.e8,
          nominal=1.e-3,
          start=1.e-3)
      "Type for dynamic viscosity with medium specific attributes";
      type EnthalpyFlowRate = SI.EnthalpyFlowRate (
          nominal=1000.0,
          min=-1.0e8,
          max=1.e8)
      "Type for enthalpy flow rate with medium specific attributes";
      type MassFlowRate = SI.MassFlowRate (
          quantity="MassFlowRate." + mediumName,
          min=-1.0e5,
          max=1.e5) "Type for mass flow rate with medium specific attributes";
      type MassFraction = Real (
          quantity="MassFraction",
          final unit="kg/kg",
          min=0,
          max=1,
          nominal=0.1) "Type for mass fraction with medium specific attributes";
      type MoleFraction = Real (
          quantity="MoleFraction",
          final unit="mol/mol",
          min=0,
          max=1,
          nominal=0.1) "Type for mole fraction with medium specific attributes";
      type MolarMass = SI.MolarMass (
          min=0.001,
          max=0.25,
          nominal=0.032) "Type for molar mass with medium specific attributes";
      type MolarVolume = SI.MolarVolume (
          min=1e-6,
          max=1.0e6,
          nominal=1.0) "Type for molar volume with medium specific attributes";
      type IsentropicExponent = SI.RatioOfSpecificHeatCapacities (
          min=1,
          max=500000,
          nominal=1.2,
          start=1.2)
      "Type for isentropic exponent with medium specific attributes";
      type SpecificEnergy = SI.SpecificEnergy (
          min=-1.0e8,
          max=1.e8,
          nominal=1.e6)
      "Type for specific energy with medium specific attributes";
      type SpecificInternalEnergy = SpecificEnergy
      "Type for specific internal energy with medium specific attributes";
      type SpecificEnthalpy = SI.SpecificEnthalpy (
          min=-1.0e10,
          max=1.e10,
          nominal=1.e6)
      "Type for specific enthalpy with medium specific attributes";
      type SpecificEntropy = SI.SpecificEntropy (
          min=-1.e7,
          max=1.e7,
          nominal=1.e3)
      "Type for specific entropy with medium specific attributes";
      type SpecificHeatCapacity = SI.SpecificHeatCapacity (
          min=0,
          max=1.e7,
          nominal=1.e3,
          start=1.e3)
      "Type for specific heat capacity with medium specific attributes";
      type SurfaceTension = SI.SurfaceTension
      "Type for surface tension with medium specific attributes";
      type Temperature = SI.Temperature (
          min=1,
          max=1.e4,
          nominal=300,
          start=300) "Type for temperature with medium specific attributes";
      type ThermalConductivity = SI.ThermalConductivity (
          min=0,
          max=500,
          nominal=1,
          start=1)
      "Type for thermal conductivity with medium specific attributes";
      type PrandtlNumber = SI.PrandtlNumber (
          min=1e-3,
          max=1e5,
          nominal=1.0)
      "Type for Prandtl number with medium specific attributes";
      type VelocityOfSound = SI.Velocity (
          min=0,
          max=1.e5,
          nominal=1000,
          start=1000)
      "Type for velocity of sound with medium specific attributes";
      type ExtraProperty = Real (min=0.0, start=1.0)
      "Type for unspecified, mass-specific property transported by flow";
      type CumulativeExtraProperty = Real (min=0.0, start=1.0)
      "Type for conserved integral of unspecified, mass specific property";
      type ExtraPropertyFlowRate = Real(unit="kg/s")
      "Type for flow rate of unspecified, mass-specific property";
      type IsobaricExpansionCoefficient = Real (
          min=0,
          max=1.0e8,
          unit="1/K")
      "Type for isobaric expansion coefficient with medium specific attributes";
      type DipoleMoment = Real (
          min=0.0,
          max=2.0,
          unit="debye",
          quantity="ElectricDipoleMoment")
      "Type for dipole moment with medium specific attributes";

      type DerDensityByPressure = SI.DerDensityByPressure
      "Type for partial derivative of density with resect to pressure with medium specific attributes";
      type DerDensityByEnthalpy = SI.DerDensityByEnthalpy
      "Type for partial derivative of density with resect to enthalpy with medium specific attributes";
      type DerEnthalpyByPressure = SI.DerEnthalpyByPressure
      "Type for partial derivative of enthalpy with resect to pressure with medium specific attributes";
      type DerDensityByTemperature = SI.DerDensityByTemperature
      "Type for partial derivative of density with resect to temperature with medium specific attributes";

      package Choices "Types, constants to define menu choices"

        type IndependentVariables = enumeration(
          T "Temperature",
          pT "Pressure, Temperature",
          ph "Pressure, Specific Enthalpy",
          phX "Pressure, Specific Enthalpy, Mass Fraction",
          pTX "Pressure, Temperature, Mass Fractions",
          dTX "Density, Temperature, Mass Fractions")
        "Enumeration defining the independent variables of a medium";

        type Init = enumeration(
          NoInit "NoInit (no initialization)",
          InitialStates "InitialStates (initialize medium states)",
          SteadyState "SteadyState (initialize in steady state)",
          SteadyMass
            "SteadyMass (initialize density or pressure in steady state)")
        "Enumeration defining initialization for fluid flow"
                  annotation (Evaluate=true);

        type ReferenceEnthalpy = enumeration(
          ZeroAt0K
            "The enthalpy is 0 at 0 K (default), if the enthalpy of formation is excluded",

          ZeroAt25C
            "The enthalpy is 0 at 25 degC, if the enthalpy of formation is excluded",

          UserDefined
            "The user-defined reference enthalpy is used at 293.15 K (25 degC)")
        "Enumeration defining the reference enthalpy of a medium"
            annotation (Evaluate=true);

        type ReferenceEntropy = enumeration(
          ZeroAt0K "The entropy is 0 at 0 K (default)",
          ZeroAt0C "The entropy is 0 at 0 degC",
          UserDefined
            "The user-defined reference entropy is used at 293.15 K (25 degC)")
        "Enumeration defining the reference entropy of a medium"
            annotation (Evaluate=true);

        type pd = enumeration(
          default "Default (no boundary condition for p or d)",
          p_known "p_known (pressure p is known)",
          d_known "d_known (density d is known)")
        "Enumeration defining whether p or d are known for the boundary condition"
            annotation (Evaluate=true);

        type Th = enumeration(
          default "Default (no boundary condition for T or h)",
          T_known "T_known (temperature T is known)",
          h_known "h_known (specific enthalpy h is known)")
        "Enumeration defining whether T or h are known as boundary condition"
            annotation (Evaluate=true);

        annotation (Documentation(info="<html>
<p>
Enumerations and data types for all types of fluids
</p>

<p>
Note: Reference enthalpy might have to be extended with enthalpy of formation.
</p>
</html>"));
      end Choices;

      annotation (Documentation(info="<html>
<p>
<b>PartialMedium</b> is a package and contains all <b>declarations</b> for
a medium. This means that constants, models, and functions
are defined that every medium is supposed to support
(some of them are optional). A medium package
inherits from <b>PartialMedium</b> and provides the
equations for the medium. The details of this package
are described in
<a href=\"modelica://Modelica.Media.UsersGuide\">Modelica.Media.UsersGuide</a>.
</p>
</html>
",   revisions="<html>

</html>"));
    end PartialMedium;

    partial package PartialPureSubstance
    "base class for pure substances of one chemical substance"
      extends PartialMedium(final reducedX = true, final fixedX=true);

     replaceable function setState_pT "Return thermodynamic state from p and T"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input Temperature T "Temperature";
        output ThermodynamicState state "thermodynamic state record";
     algorithm
        state := setState_pTX(p,T,fill(0,0));
     end setState_pT;

      replaceable function setState_ph
      "Return thermodynamic state from p and h"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input SpecificEnthalpy h "Specific enthalpy";
        output ThermodynamicState state "thermodynamic state record";
      algorithm
        state := setState_phX(p,h,fill(0, 0));
      end setState_ph;

      replaceable function setState_ps
      "Return thermodynamic state from p and s"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input SpecificEntropy s "Specific entropy";
        output ThermodynamicState state "thermodynamic state record";
      algorithm
        state := setState_psX(p,s,fill(0,0));
      end setState_ps;

      replaceable function setState_dT
      "Return thermodynamic state from d and T"
        extends Modelica.Icons.Function;
        input Density d "density";
        input Temperature T "Temperature";
        output ThermodynamicState state "thermodynamic state record";
      algorithm
        state := setState_dTX(d,T,fill(0,0));
      end setState_dT;

      replaceable function density_ph "Return density from p and h"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input SpecificEnthalpy h "Specific enthalpy";
        output Density d "Density";
      algorithm
        d := density_phX(p, h, fill(0,0));
      end density_ph;

      replaceable function temperature_ph "Return temperature from p and h"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input SpecificEnthalpy h "Specific enthalpy";
        output Temperature T "Temperature";
      algorithm
        T := temperature_phX(p, h, fill(0,0));
      end temperature_ph;

      replaceable function pressure_dT "Return pressure from d and T"
        extends Modelica.Icons.Function;
        input Density d "Density";
        input Temperature T "Temperature";
        output AbsolutePressure p "Pressure";
      algorithm
        p := pressure(setState_dTX(d, T, fill(0,0)));
      end pressure_dT;

      replaceable function specificEnthalpy_dT
      "Return specific enthalpy from d and T"
        extends Modelica.Icons.Function;
        input Density d "Density";
        input Temperature T "Temperature";
        output SpecificEnthalpy h "specific enthalpy";
      algorithm
        h := specificEnthalpy(setState_dTX(d, T, fill(0,0)));
      end specificEnthalpy_dT;

      replaceable function specificEnthalpy_ps
      "Return specific enthalpy from p and s"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input SpecificEntropy s "Specific entropy";
        output SpecificEnthalpy h "specific enthalpy";
      algorithm
        h := specificEnthalpy_psX(p,s,fill(0,0));
      end specificEnthalpy_ps;

      replaceable function temperature_ps "Return temperature from p and s"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input SpecificEntropy s "Specific entropy";
        output Temperature T "Temperature";
      algorithm
        T := temperature_psX(p,s,fill(0,0));
      end temperature_ps;

      replaceable function density_ps "Return density from p and s"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input SpecificEntropy s "Specific entropy";
        output Density d "Density";
      algorithm
        d := density_psX(p, s, fill(0,0));
      end density_ps;

      replaceable function specificEnthalpy_pT
      "Return specific enthalpy from p and T"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input Temperature T "Temperature";
        output SpecificEnthalpy h "specific enthalpy";
      algorithm
        h := specificEnthalpy_pTX(p, T, fill(0,0));
      end specificEnthalpy_pT;

      replaceable function density_pT "Return density from p and T"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input Temperature T "Temperature";
        output Density d "Density";
      algorithm
        d := density(setState_pTX(p, T, fill(0,0)));
      end density_pT;

      redeclare replaceable partial model extends BaseProperties(
        final standardOrderComponents=true)
      end BaseProperties;
    end PartialPureSubstance;

  partial package PartialMixtureMedium
    "Base class for pure substances of several chemical substances"
      extends PartialMedium;

      redeclare replaceable record extends ThermodynamicState
      "thermodynamic state variables"
        AbsolutePressure p "Absolute pressure of medium";
        Temperature T "Temperature of medium";
        MassFraction X[nX]
        "Mass fractions (= (component mass)/total mass  m_i/m)";
      end ThermodynamicState;

      redeclare replaceable record extends FluidConstants
      "extended fluid constants"
        Temperature criticalTemperature "critical temperature";
        AbsolutePressure criticalPressure "critical pressure";
        MolarVolume criticalMolarVolume "critical molar Volume";
        Real acentricFactor "Pitzer acentric factor";
        Temperature triplePointTemperature "triple point temperature";
        AbsolutePressure triplePointPressure "triple point pressure";
        Temperature meltingPoint "melting point at 101325 Pa";
        Temperature normalBoilingPoint "normal boiling point (at 101325 Pa)";
        DipoleMoment dipoleMoment
        "dipole moment of molecule in Debye (1 debye = 3.33564e10-30 C.m)";
        Boolean hasIdealGasHeatCapacity=false
        "true if ideal gas heat capacity is available";
        Boolean hasCriticalData=false "true if critical data are known";
        Boolean hasDipoleMoment=false "true if a dipole moment known";
        Boolean hasFundamentalEquation=false "true if a fundamental equation";
        Boolean hasLiquidHeatCapacity=false
        "true if liquid heat capacity is available";
        Boolean hasSolidHeatCapacity=false
        "true if solid heat capacity is available";
        Boolean hasAccurateViscosityData=false
        "true if accurate data for a viscosity function is available";
        Boolean hasAccurateConductivityData=false
        "true if accurate data for thermal conductivity is available";
        Boolean hasVapourPressureCurve=false
        "true if vapour pressure data, e.g., Antoine coefficents are known";
        Boolean hasAcentricFactor=false
        "true if Pitzer accentric factor is known";
        SpecificEnthalpy HCRIT0=0.0
        "Critical specific enthalpy of the fundamental equation";
        SpecificEntropy SCRIT0=0.0
        "Critical specific entropy of the fundamental equation";
        SpecificEnthalpy deltah=0.0
        "Difference between specific enthalpy model (h_m) and f.eq. (h_f) (h_m - h_f)";
        SpecificEntropy deltas=0.0
        "Difference between specific enthalpy model (s_m) and f.eq. (s_f) (s_m - s_f)";
      end FluidConstants;

    constant FluidConstants[nS] fluidConstants "constant data for the fluid";

    replaceable function gasConstant
      "Return the gas constant of the mixture (also for liquids)"
        extends Modelica.Icons.Function;
        input ThermodynamicState state "thermodynamic state";
        output SI.SpecificHeatCapacity R "mixture gas constant";
    end gasConstant;

      function moleToMassFractions
      "Return mass fractions X from mole fractions"
        extends Modelica.Icons.Function;
        input SI.MoleFraction moleFractions[:] "Mole fractions of mixture";
        input MolarMass[:] MMX "molar masses of components";
        output SI.MassFraction X[size(moleFractions, 1)]
        "Mass fractions of gas mixture";
    protected
        MolarMass Mmix =  moleFractions*MMX "molar mass of mixture";
      algorithm
        for i in 1:size(moleFractions, 1) loop
          X[i] := moleFractions[i]*MMX[i] /Mmix;
        end for;
        annotation(smoothOrder=5);
      end moleToMassFractions;

      function massToMoleFractions
      "Return mole fractions from mass fractions X"
        extends Modelica.Icons.Function;
        input SI.MassFraction X[:] "Mass fractions of mixture";
        input SI.MolarMass[:] MMX "molar masses of components";
        output SI.MoleFraction moleFractions[size(X, 1)]
        "Mole fractions of gas mixture";
    protected
        Real invMMX[size(X, 1)] "inverses of molar weights";
        SI.MolarMass Mmix "molar mass of mixture";
      algorithm
        for i in 1:size(X, 1) loop
          invMMX[i] := 1/MMX[i];
        end for;
        Mmix := 1/(X*invMMX);
        for i in 1:size(X, 1) loop
          moleFractions[i] := Mmix*X[i]/MMX[i];
        end for;
        annotation(smoothOrder=5);
      end massToMoleFractions;

  end PartialMixtureMedium;

    partial package PartialCondensingGases
    "Base class for mixtures of condensing and non-condensing gases"
      extends PartialMixtureMedium(
           ThermoStates = Choices.IndependentVariables.pTX);

    replaceable partial function saturationPressure
      "Return saturation pressure of condensing fluid"
      extends Modelica.Icons.Function;
      input Temperature Tsat "saturation temperature";
      output AbsolutePressure psat "saturation pressure";
    end saturationPressure;

    replaceable partial function enthalpyOfVaporization
      "Return vaporization enthalpy of condensing fluid"
      extends Modelica.Icons.Function;
      input Temperature T "temperature";
      output SpecificEnthalpy r0 "vaporization enthalpy";
    end enthalpyOfVaporization;

    replaceable partial function enthalpyOfLiquid
      "Return liquid enthalpy of condensing fluid"
      extends Modelica.Icons.Function;
      input Temperature T "temperature";
      output SpecificEnthalpy h "liquid enthalpy";
    end enthalpyOfLiquid;

    replaceable partial function enthalpyOfGas
      "Return enthalpy of non-condensing gas mixture"
      extends Modelica.Icons.Function;
      input Temperature T "temperature";
      input MassFraction[:] X "vector of mass fractions";
      output SpecificEnthalpy h "specific enthalpy";
    end enthalpyOfGas;

    replaceable partial function enthalpyOfCondensingGas
      "Return enthalpy of condensing gas (most often steam)"
      extends Modelica.Icons.Function;
      input Temperature T "temperature";
      output SpecificEnthalpy h "specific enthalpy";
    end enthalpyOfCondensingGas;

    replaceable partial function enthalpyOfNonCondensingGas
      "Return enthalpy of the non-condensing species"
      extends Modelica.Icons.Function;
      input Temperature T "temperature";
      output SpecificEnthalpy h "specific enthalpy";
    end enthalpyOfNonCondensingGas;
    end PartialCondensingGases;
    annotation (Documentation(info="<HTML>
<p>
This package provides basic interfaces definitions of media models for different
kind of media.
</p>
</HTML>"));
  end Interfaces;

  package Common
    "data structures and fundamental functions for fluid properties"
    extends Modelica.Icons.Package;

    function smoothStep
    "Approximation of a general step, such that the characteristic is continuous and differentiable"
      extends Modelica.Icons.Function;
      input Real x "Abszissa value";
      input Real y1 "Ordinate value for x > 0";
      input Real y2 "Ordinate value for x < 0";
      input Real x_small(min=0) = 1e-5
      "Approximation of step for -x_small <= x <= x_small; x_small > 0 required";
      output Real y
      "Ordinate value to approximate y = if x > 0 then y1 else y2";
    algorithm
      y := smooth(1, if x >  x_small then y1 else
                     if x < -x_small then y2 else
                     if abs(x_small)>0 then (x/x_small)*((x/x_small)^2 - 3)*(y2-y1)/4 + (y1+y2)/2 else (y1+y2)/2);

      annotation(Documentation(revisions="<html>
<ul>
<li><i>April 29, 2008</i>
    by <a href=\"mailto:Martin.Otter@DLR.de\">Martin Otter</a>:<br>
    Designed and implemented.</li>
<li><i>August 12, 2008</i>
    by <a href=\"mailto:Michael.Sielemann@dlr.de\">Michael Sielemann</a>:<br>
    Minor modification to cover the limit case <code>x_small -> 0</code> without division by zero.</li>
</ul>
</html>",   info="<html>
<p>
This function is used to approximate the equation
</p>
<pre>
    y = <b>if</b> x &gt; 0 <b>then</b> y1 <b>else</b> y2;
</pre>

<p>
by a smooth characteristic, so that the expression is continuous and differentiable:
</p>

<pre>
   y = <b>smooth</b>(1, <b>if</b> x &gt;  x_small <b>then</b> y1 <b>else</b>
                 <b>if</b> x &lt; -x_small <b>then</b> y2 <b>else</b> f(y1, y2));
</pre>

<p>
In the region -x_small &lt; x &lt; x_small a 2nd order polynomial is used
for a smooth transition from y1 to y2.
</p>

<p>
If <b>mass fractions</b> X[:] are approximated with this function then this can be performed
for all <b>nX</b> mass fractions, instead of applying it for nX-1 mass fractions and computing
the last one by the mass fraction constraint sum(X)=1. The reason is that the approximating function has the
property that sum(X) = 1, provided sum(X_a) = sum(X_b) = 1
(and y1=X_a[i], y2=X_b[i]).
This can be shown by evaluating the approximating function in the abs(x) &lt; x_small
region (otherwise X is either X_a or X_b):
</p>

<pre>
    X[1]  = smoothStep(x, X_a[1] , X_b[1] , x_small);
    X[2]  = smoothStep(x, X_a[2] , X_b[2] , x_small);
       ...
    X[nX] = smoothStep(x, X_a[nX], X_b[nX], x_small);
</pre>

<p>
or
</p>

<pre>
    X[1]  = c*(X_a[1]  - X_b[1])  + (X_a[1]  + X_b[1])/2
    X[2]  = c*(X_a[2]  - X_b[2])  + (X_a[2]  + X_b[2])/2;
       ...
    X[nX] = c*(X_a[nX] - X_b[nX]) + (X_a[nX] + X_b[nX])/2;
    c     = (x/x_small)*((x/x_small)^2 - 3)/4
</pre>

<p>
Summing all mass fractions together results in
</p>

<pre>
    sum(X) = c*(sum(X_a) - sum(X_b)) + (sum(X_a) + sum(X_b))/2
           = c*(1 - 1) + (1 + 1)/2
           = 1
</pre>
</html>"));
    end smoothStep;

   package OneNonLinearEquation
    "Determine solution of a non-linear algebraic equation in one unknown without derivatives in a reliable and efficient way"
     extends Modelica.Icons.Package;

      replaceable record f_nonlinear_Data
      "Data specific for function f_nonlinear"
        extends Modelica.Icons.Record;
      end f_nonlinear_Data;

      replaceable partial function f_nonlinear
      "Nonlinear algebraic equation in one unknown: y = f_nonlinear(x,p,X)"
        extends Modelica.Icons.Function;
        input Real x "Independent variable of function";
        input Real p = 0.0
        "disregaded variables (here always used for pressure)";
        input Real[:] X = fill(0,0)
        "disregaded variables (her always used for composition)";
        input f_nonlinear_Data f_nonlinear_data
        "Additional data for the function";
        output Real y "= f_nonlinear(x)";
        // annotation(derivative(zeroDerivative=y)); // this must hold for all replaced functions
      end f_nonlinear;

      replaceable function solve
      "Solve f_nonlinear(x_zero)=y_zero; f_nonlinear(x_min) - y_zero and f_nonlinear(x_max)-y_zero must have different sign"
        import Modelica.Utilities.Streams.error;
        extends Modelica.Icons.Function;
        input Real y_zero
        "Determine x_zero, such that f_nonlinear(x_zero) = y_zero";
        input Real x_min "Minimum value of x";
        input Real x_max "Maximum value of x";
        input Real pressure = 0.0
        "disregaded variables (here always used for pressure)";
        input Real[:] X = fill(0,0)
        "disregaded variables (here always used for composition)";
         input f_nonlinear_Data f_nonlinear_data
        "Additional data for function f_nonlinear";
         input Real x_tol =  100*Modelica.Constants.eps
        "Relative tolerance of the result";
         output Real x_zero "f_nonlinear(x_zero) = y_zero";
    protected
         constant Real eps = Modelica.Constants.eps "machine epsilon";
         constant Real x_eps = 1e-10
        "Slight modification of x_min, x_max, since x_min, x_max are usually exactly at the borders T_min/h_min and then small numeric noise may make the interval invalid";
         Real x_min2 = x_min - x_eps;
         Real x_max2 = x_max + x_eps;
         Real a = x_min2 "Current best minimum interval value";
         Real b = x_max2 "Current best maximum interval value";
         Real c "Intermediate point a <= c <= b";
         Real d;
         Real e "b - a";
         Real m;
         Real s;
         Real p;
         Real q;
         Real r;
         Real tol;
         Real fa "= f_nonlinear(a) - y_zero";
         Real fb "= f_nonlinear(b) - y_zero";
         Real fc;
         Boolean found = false;
      algorithm
         // Check that f(x_min) and f(x_max) have different sign
         fa :=f_nonlinear(x_min2, pressure, X, f_nonlinear_data) - y_zero;
         fb :=f_nonlinear(x_max2, pressure, X, f_nonlinear_data) - y_zero;
         fc := fb;
         if fa > 0.0 and fb > 0.0 or
            fa < 0.0 and fb < 0.0 then
            error("The arguments x_min and x_max to OneNonLinearEquation.solve(..)\n" +
                  "do not bracket the root of the single non-linear equation:\n" +
                  "  x_min  = " + String(x_min2) + "\n" +
                  "  x_max  = " + String(x_max2) + "\n" +
                  "  y_zero = " + String(y_zero) + "\n" +
                  "  fa = f(x_min) - y_zero = " + String(fa) + "\n" +
                  "  fb = f(x_max) - y_zero = " + String(fb) + "\n" +
                  "fa and fb must have opposite sign which is not the case");
         end if;

         // Initialize variables
         c :=a;
         fc :=fa;
         e :=b - a;
         d :=e;

         // Search loop
         while not found loop
            if abs(fc) < abs(fb) then
               a :=b;
               b :=c;
               c :=a;
               fa :=fb;
               fb :=fc;
               fc :=fa;
            end if;

            tol :=2*eps*abs(b) + x_tol;
            m :=(c - b)/2;

            if abs(m) <= tol or fb == 0.0 then
               // root found (interval is small enough)
               found :=true;
               x_zero :=b;
            else
               // Determine if a bisection is needed
               if abs(e) < tol or abs(fa) <= abs(fb) then
                  e :=m;
                  d :=e;
               else
                  s :=fb/fa;
                  if a == c then
                     // linear interpolation
                     p :=2*m*s;
                     q :=1 - s;
                  else
                     // inverse quadratic interpolation
                     q :=fa/fc;
                     r :=fb/fc;
                     p :=s*(2*m*q*(q - r) - (b - a)*(r - 1));
                     q :=(q - 1)*(r - 1)*(s - 1);
                  end if;

                  if p > 0 then
                     q :=-q;
                  else
                     p :=-p;
                  end if;

                  s :=e;
                  e :=d;
                  if 2*p < 3*m*q-abs(tol*q) and p < abs(0.5*s*q) then
                     // interpolation successful
                     d :=p/q;
                  else
                     // use bi-section
                     e :=m;
                     d :=e;
                  end if;
               end if;

               // Best guess value is defined as "a"
               a :=b;
               fa :=fb;
               b :=b + (if abs(d) > tol then d else if m > 0 then tol else -tol);
               fb :=f_nonlinear(b, pressure, X, f_nonlinear_data) - y_zero;

               if fb > 0 and fc > 0 or
                  fb < 0 and fc < 0 then
                  // initialize variables
                  c :=a;
                  fc :=fa;
                  e :=b - a;
                  d :=e;
               end if;
            end if;
         end while;
      end solve;

      annotation (Documentation(info="<html>
<p>
This function should currently only be used in Modelica.Media,
since it might be replaced in the future by another strategy,
where the tool is responsible for the solution of the non-linear
equation.
</p>

<p>
This library determines the solution of one non-linear algebraic equation \"y=f(x)\"
in one unknown \"x\" in a reliable way. As input, the desired value y of the
non-linear function has to be given, as well as an interval x_min, x_max that
contains the solution, i.e., \"f(x_min) - y\" and \"f(x_max) - y\" must
have a different sign. If possible, a smaller interval is computed by
inverse quadratic interpolation (interpolating with a quadratic polynomial
through the last 3 points and computing the zero). If this fails,
bisection is used, which always reduces the interval by a factor of 2.
The inverse quadratic interpolation method has superlinear convergence.
This is roughly the same convergence rate as a globally convergent Newton
method, but without the need to compute derivatives of the non-linear
function. The solver function is a direct mapping of the Algol 60 procedure
\"zero\" to Modelica, from:
</p>

<dl>
<dt> Brent R.P.:</dt>
<dd> <b>Algorithms for Minimization without derivatives</b>.
     Prentice Hall, 1973, pp. 58-59.</dd>
</dl>

<p>
Due to current limitations of the
Modelica language (not possible to pass a function reference to a function),
the construction to use this solver on a user-defined function is a bit
complicated (this method is from Hans Olsson, Dassault Syst&egrave;mes AB). A user has to
provide a package in the following way:
</p>

<pre>
  <b>package</b> MyNonLinearSolver
    <b>extends</b> OneNonLinearEquation;

    <b>redeclare record extends</b> Data
      // Define data to be passed to user function
      ...
    <b>end</b> Data;

    <b>redeclare function extends</b> f_nonlinear
    <b>algorithm</b>
       // Compute the non-linear equation: y = f(x, Data)
    <b>end</b> f_nonlinear;

    // Dummy definition that has to be present for current Dymola
    <b>redeclare function extends</b> solve
    <b>end</b> solve;
  <b>end</b> MyNonLinearSolver;

  x_zero = MyNonLinearSolver.solve(y_zero, x_min, x_max, data=data);
</pre>
</html>"));
   end OneNonLinearEquation;
    annotation (Documentation(info="<HTML><h4>Package description</h4>
      <p>Package Modelica.Media.Common provides records and functions shared by many of the property sub-packages.
      High accuracy fluid property models share a lot of common structure, even if the actual models are different.
      Common data structures and computations shared by these property models are collected in this library.
   </p>

</HTML>
",   revisions="<html>
      <ul>
      <li>First implemented: <i>July, 2000</i>
      by <a href=\"http://www.control.lth.se/~hubertus/\">Hubertus Tummescheit</a>
      for the ThermoFluid Library with help from Jonas Eborn and Falko Jens Wagner
      </li>
      <li>Code reorganization, enhanced documentation, additional functions: <i>December, 2002</i>
      by <a href=\"http://www.control.lth.se/~hubertus/\">Hubertus Tummescheit</a> and move to Modelica
                            properties library.</li>
      <li>Inclusion into Modelica.Media: September 2003 </li>
      </ul>

      <address>Author: Hubertus Tummescheit, <br>
      Lund University<br>
      Department of Automatic Control<br>
      Box 118, 22100 Lund, Sweden<br>
      email: hubertus@control.lth.se
      </address>
</html>"));
  end Common;

    package Air "Medium models for air"
      extends Modelica.Icons.MaterialPropertiesPackage;

      package MoistAir "Air: Moist air model (240 ... 400 K)"
        extends Interfaces.PartialCondensingGases(
           mediumName="Moist air",
           substanceNames={"water", "air"},
           final reducedX=true,
           final singleState=false,
           reference_X={0.01,0.99},
           fluidConstants = {IdealGases.Common.FluidData.H2O,IdealGases.Common.FluidData.N2});

        constant Integer Water=1
        "Index of water (in substanceNames, massFractions X, etc.)";

        constant Integer Air=2
        "Index of air (in substanceNames, massFractions X, etc.)";

        constant Real k_mair =  steam.MM/dryair.MM "ratio of molar weights";

        constant IdealGases.Common.DataRecord dryair = IdealGases.Common.SingleGasesData.Air;

        constant IdealGases.Common.DataRecord steam = IdealGases.Common.SingleGasesData.H2O;

        constant SI.MolarMass[2] MMX = {steam.MM,dryair.MM}
        "Molar masses of components";
        import Modelica.Media.Interfaces;
        import Modelica.Math;
        import SI = Modelica.SIunits;
        import Cv = Modelica.SIunits.Conversions;
        import Modelica.Constants;
        import Modelica.Media.IdealGases.Common.SingleGasNasa;

        redeclare record extends ThermodynamicState
        "ThermodynamicState record for moist air"
        end ThermodynamicState;

        redeclare replaceable model extends BaseProperties(
          T(stateSelect=if preferredMediumStates then StateSelect.prefer else StateSelect.default),
          p(stateSelect=if preferredMediumStates then StateSelect.prefer else StateSelect.default),
          Xi(stateSelect=if preferredMediumStates then StateSelect.prefer else StateSelect.default),
          redeclare final constant Boolean standardOrderComponents=true)
        "Moist air base properties record"

          /* p, T, X = X[Water] are used as preferred states, since only then all
     other quantities can be computed in a recursive sequence.
     If other variables are selected as states, static state selection
     is no longer possible and non-linear algebraic equations occur.
      */
          MassFraction x_water "Mass of total water/mass of dry air";
          Real phi "Relative humidity";

      protected
          MassFraction X_liquid "Mass fraction of liquid or solid water";
          MassFraction X_steam "Mass fraction of steam water";
          MassFraction X_air "Mass fraction of air";
          MassFraction X_sat
          "Steam water mass fraction of saturation boundary in kg_water/kg_moistair";
          MassFraction x_sat
          "Steam water mass content of saturation boundary in kg_water/kg_dryair";
          AbsolutePressure p_steam_sat "Partial saturation pressure of steam";
        equation
          assert(T >= 200.0 and T <= 423.15, "
Temperature T is not in the allowed range
200.0 K <= (T ="     + String(T) + " K) <= 423.15 K
required from medium model \""           + mediumName + "\".");
          MM = 1/(Xi[Water]/MMX[Water]+(1.0-Xi[Water])/MMX[Air]);

          p_steam_sat = min(saturationPressure(T),0.999*p);
          X_sat = min(p_steam_sat * k_mair/max(100*Constants.eps, p - p_steam_sat)*(1 - Xi[Water]), 1.0)
          "Water content at saturation with respect to actual water content";
          X_liquid = max(Xi[Water] - X_sat, 0.0);
          X_steam  = Xi[Water]-X_liquid;
          X_air    = 1-Xi[Water];

          h = specificEnthalpy_pTX(p,T,Xi);
          R = dryair.R*(X_air/(1 - X_liquid)) + steam.R*X_steam/(1 - X_liquid);
          //
          u = h - R*T;
          d = p/(R*T);
          /* Note, u and d are computed under the assumption that the volume of the liquid
         water is neglible with respect to the volume of air and of steam
      */
          state.p = p;
          state.T = T;
          state.X = X;

          // these x are per unit mass of DRY air!
          x_sat    = k_mair*p_steam_sat/max(100*Constants.eps,p - p_steam_sat);
          x_water = Xi[Water]/max(X_air,100*Constants.eps);
          phi = p/p_steam_sat*Xi[Water]/(Xi[Water] + k_mair*X_air);
          annotation(Documentation(info="<html>
<p>This model computes thermodynamic properties of moist air from three independent (thermodynamic or/and numerical) state variables. Preferred numerical states are temperature T, pressure p and the reduced composition vector Xi, which contains the water mass fraction only. As an EOS the <b>ideal gas law</b> is used and associated restrictions apply. The model can also be used in the <b>fog region</b>, when moisture is present in its liquid state. However, it is assumed that the liquid water volume is negligible compared to that of the gas phase. Computation of thermal properties is based on property data of <a href=\"modelica://Modelica.Media.Air.DryAirNasa\"> dry air</a> and water (source: VDI-W&auml;rmeatlas), respectively. Besides the standard thermodynamic variables <b>absolute and relative humidity</b>, x_water and phi, respectively, are given by the model. Upper case X denotes absolute humidity with respect to mass of moist air while absolute humidity with respect to mass of dry air only is denoted by a lower case x throughout the model. See <a href=\"modelica://Modelica.Media.Air.MoistAir\">package description</a> for further information.</p>
</html>"));
        end BaseProperties;

        redeclare function setState_pTX
        "Return thermodynamic state as function of pressure p, temperature T and composition X"
          extends Modelica.Icons.Function;
          input AbsolutePressure p "Pressure";
          input Temperature T "Temperature";
          input MassFraction X[:]=reference_X "Mass fractions";
          output ThermodynamicState state "Thermodynamic state";
        algorithm
          state := if size(X,1) == nX then ThermodynamicState(p=p,T=T, X=X) else
                 ThermodynamicState(p=p,T=T, X=cat(1,X,{1-sum(X)}));
          annotation(smoothOrder=2,
                      Documentation(info="<html>
The <a href=\"modelica://Modelica.Media.Air.MoistAir.ThermodynamicState\">thermodynamic state record</a> is computed from pressure p, temperature T and composition X.
</html>"));
        end setState_pTX;

        redeclare function setState_phX
        "Return thermodynamic state as function of pressure p, specific enthalpy h and composition X"
          extends Modelica.Icons.Function;
          input AbsolutePressure p "Pressure";
          input SpecificEnthalpy h "Specific enthalpy";
          input MassFraction X[:]=reference_X "Mass fractions";
          output ThermodynamicState state "Thermodynamic state";
        algorithm
          state := if size(X,1) == nX then ThermodynamicState(p=p,T=T_phX(p,h,X),X=X) else
                 ThermodynamicState(p=p,T=T_phX(p,h,X), X=cat(1,X,{1-sum(X)}));
          annotation(smoothOrder=2,
                      Documentation(info="<html>
The <a href=\"modelica://Modelica.Media.Air.MoistAir.ThermodynamicState\">thermodynamic state record</a> is computed from pressure p, specific enthalpy h and composition X.
</html>"));
        end setState_phX;

        redeclare function setState_dTX
        "Return thermodynamic state as function of density d, temperature T and composition X"
          extends Modelica.Icons.Function;
          input Density d "density";
          input Temperature T "Temperature";
          input MassFraction X[:]=reference_X "Mass fractions";
          output ThermodynamicState state "Thermodynamic state";
        algorithm
          state := if size(X,1) == nX then ThermodynamicState(p=d*({steam.R,dryair.R}*X)*T,T=T,X=X) else
                 ThermodynamicState(p=d*({steam.R,dryair.R}*cat(1,X,{1-sum(X)}))*T,T=T, X=cat(1,X,{1-sum(X)}));
          annotation(smoothOrder=2,
                      Documentation(info="<html>
The <a href=\"modelica://Modelica.Media.Air.MoistAir.ThermodynamicState\">thermodynamic state record</a> is computed from density d, temperature T and composition X.
</html>"));
        end setState_dTX;

      redeclare function extends setSmoothState
        "Return thermodynamic state so that it smoothly approximates: if x > 0 then state_a else state_b"
      algorithm
        state := ThermodynamicState(p=Media.Common.smoothStep(x, state_a.p, state_b.p, x_small),
                                    T=Media.Common.smoothStep(x, state_a.T, state_b.T, x_small),
                                    X=Media.Common.smoothStep(x, state_a.X, state_b.X, x_small));
      end setSmoothState;

        redeclare function extends gasConstant
        "Return ideal gas constant as a function from thermodynamic state, only valid for phi<1"

        algorithm
          R := dryair.R*(1-state.X[Water]) + steam.R*state.X[Water];
          annotation(smoothOrder=2,
                      Documentation(info="<html>
The ideal gas constant for moist air is computed from <a href=\"modelica://Modelica.Media.Air.MoistAir.ThermodynamicState\">thermodynamic state</a> assuming that all water is in the gas phase.
</html>"));
        end gasConstant;

        function saturationPressureLiquid
        "Return saturation pressure of water as a function of temperature T in the range of 273.16 to 373.16 K"

          extends Modelica.Icons.Function;
          input SI.Temperature Tsat "saturation temperature";
          output SI.AbsolutePressure psat "saturation pressure";
        algorithm
          psat := 611.657*Math.exp(17.2799 - 4102.99/(Tsat - 35.719));
          annotation(Inline=false,smoothOrder=5,derivative=saturationPressureLiquid_der,
            Documentation(info="<html>
Saturation pressure of water above the triple point temperature is computed from temperature. It's range of validity is between
273.16 and 373.16 K. Outside these limits a less accurate result is returned.
</html>"));
        end saturationPressureLiquid;

        function saturationPressureLiquid_der
        "Time derivative of saturationPressureLiquid"

          extends Modelica.Icons.Function;
          input SI.Temperature Tsat "Saturation temperature";
          input Real dTsat(unit="K/s") "Saturation temperature derivative";
          output Real psat_der(unit="Pa/s") "Saturation pressure";
        algorithm
        /*psat := 611.657*Math.exp(17.2799 - 4102.99/(Tsat - 35.719));*/
          psat_der:=611.657*Math.exp(17.2799 - 4102.99/(Tsat - 35.719))*4102.99*dTsat/(Tsat - 35.719)/(Tsat - 35.719);

          annotation(Inline=false,smoothOrder=5,
            Documentation(info="<html>
Derivative function of <a href=\"modelica://Modelica.Media.Air.MoistAir.saturationPressureLiquid\">saturationPressureLiquid</a>
</html>"));
        end saturationPressureLiquid_der;

        function sublimationPressureIce
        "Return sublimation pressure of water as a function of temperature T between 223.16 and 273.16 K"

          extends Modelica.Icons.Function;
          input SI.Temperature Tsat "sublimation temperature";
          output SI.AbsolutePressure psat "sublimation pressure";
        algorithm
          psat := 611.657*Math.exp(22.5159*(1.0 - 273.16/Tsat));
          annotation(Inline=false,smoothOrder=5,derivative=sublimationPressureIce_der,
            Documentation(info="<html>
Sublimation pressure of water below the triple point temperature is computed from temperature. It's range of validity is between
 223.16 and 273.16 K. Outside of these limits a less accurate result is returned.
</html>"));
        end sublimationPressureIce;

        function sublimationPressureIce_der
        "Derivative function for 'sublimationPressureIce'"

          extends Modelica.Icons.Function;
          input SI.Temperature Tsat "Sublimation temperature";
          input Real dTsat(unit="K/s")
          "Time derivative of sublimation temperature";
          output Real psat_der(unit="Pa/s") "Sublimation pressure";
        algorithm
          /*psat := 611.657*Math.exp(22.5159*(1.0 - 273.16/Tsat));*/
          psat_der:=611.657*Math.exp(22.5159*(1.0 - 273.16/Tsat))*22.5159*273.16*dTsat/Tsat/Tsat;
          annotation(Inline=false,smoothOrder=5,
            Documentation(info="<html>
Derivative function of <a href=\"modelica://Modelica.Media.Air.MoistAir.sublimationPressureIce\">saturationPressureIce</a>
</html>"));
        end sublimationPressureIce_der;

        redeclare function extends saturationPressure
        "Return saturation pressure of water as a function of temperature T between 223.16 and 373.16 K"

        algorithm
          psat := Utilities.spliceFunction(saturationPressureLiquid(Tsat),sublimationPressureIce(Tsat),Tsat-273.16,1.0);
          annotation(Inline=false,smoothOrder=5,derivative=saturationPressure_der,
            Documentation(info="<html>
Saturation pressure of water in the liquid and the solid region is computed using an Antoine-type correlation. It's range of validity is between 223.16 and 373.16 K. Outside of these limits a (less accurate) result is returned. Functions for the
<a href=\"modelica://Modelica.Media.Air.MoistAir.sublimationPressureIce\">solid</a> and the <a href=\"modelica://Modelica.Media.Air.MoistAir.saturationPressureLiquid\"> liquid</a> region, respectively, are combined using the first derivative continuous <a href=\"modelica://Modelica.Media.Air.MoistAir.Utilities.spliceFunction\">spliceFunction</a>.
</html>"));
        end saturationPressure;

        function saturationPressure_der
        "Derivative function for 'saturationPressure'"
          input Temperature Tsat "Saturation temperature";
          input Real dTsat(unit="K/s")
          "Time derivative of saturation temperature";
          output Real psat_der(unit="Pa/s") "Saturation pressure";

        algorithm
          /*psat := Utilities.spliceFunction(saturationPressureLiquid(Tsat),sublimationPressureIce(Tsat),Tsat-273.16,1.0);*/
          psat_der := Utilities.spliceFunction_der(
            saturationPressureLiquid(Tsat),
            sublimationPressureIce(Tsat),
            Tsat - 273.16,
            1.0,
            saturationPressureLiquid_der(Tsat=Tsat, dTsat=dTsat),
            sublimationPressureIce_der(Tsat=Tsat, dTsat=dTsat),
            dTsat,
            0);
          annotation(Inline=false,smoothOrder=5,
            Documentation(info="<html>
Derivative function of <a href=\"modelica://Modelica.Media.Air.MoistAir.saturationPressure\">saturationPressure</a>
</html>"));
        end saturationPressure_der;

       redeclare function extends enthalpyOfVaporization
        "Return enthalpy of vaporization of water as a function of temperature T, 0 - 130 degC"

       algorithm
        /*r0 := 1e3*(2501.0145 - (T - 273.15)*(2.3853 + (T - 273.15)*(0.002969 - (T
      - 273.15)*(7.5293e-5 + (T - 273.15)*4.6084e-7))));*/
       //katrin: replaced by linear correlation, simpler and more accurate in the entire region
       //source VDI-Waermeatlas, linear inter- and extrapolation between values for 0.01 &deg;C and 40 &deg;C.
       r0:=(2405900-2500500)/(40-0)*(T-273.16)+2500500;
         annotation(smoothOrder=2,
                      Documentation(info="<html>
Enthalpy of vaporization of water is computed from temperature in the region of 0 to 130 &deg;C.
</html>"));
       end enthalpyOfVaporization;

       redeclare function extends enthalpyOfLiquid
        "Return enthalpy of liquid water as a function of temperature T(use enthalpyOfWater instead)"

       algorithm
         h := (T - 273.15)*1e3*(4.2166 - 0.5*(T - 273.15)*(0.0033166 + 0.333333*(T - 273.15)*(0.00010295
            - 0.25*(T - 273.15)*(1.3819e-6 + 0.2*(T - 273.15)*7.3221e-9))));
         annotation(Inline=false,smoothOrder=5,
            Documentation(info="<html>
Specific enthalpy of liquid water is computed from temperature using a polynomial approach. Kept for compatibility reasons, better use <a href=\"modelica://Modelica.Media.Air.MoistAir.enthalpyOfWater\">enthalpyOfWater</a> instead.
</html>"));
       end enthalpyOfLiquid;

       redeclare function extends enthalpyOfGas
        "Return specific enthalpy of gas (air and steam) as a function of temperature T and composition X"

       algorithm
         h := SingleGasNasa.h_Tlow(data=steam, T=T, refChoice=3, h_off=46479.819+2501014.5)*X[Water]
              + SingleGasNasa.h_Tlow(data=dryair, T=T, refChoice=3, h_off=25104.684)*(1.0-X[Water]);
         annotation(Inline=false,smoothOrder=5,
            Documentation(info="<html>
Specific enthalpy of moist air is computed from temperature, provided all water is in the gaseous state. The first entry in the composition vector X must be the mass fraction of steam. For a function that also covers the fog region please refer to <a href=\"modelica://Modelica.Media.Air.MoistAir.h_pTX\">h_pTX</a>.
</html>"));
       end enthalpyOfGas;

       redeclare function extends enthalpyOfCondensingGas
        "Return specific enthalpy of steam as a function of temperature T"

       algorithm
         h := SingleGasNasa.h_Tlow(data=steam, T=T, refChoice=3, h_off=46479.819+2501014.5);
         annotation(Inline=false,smoothOrder=5,
            Documentation(info="<html>
Specific enthalpy of steam is computed from temperature.
</html>"));
       end enthalpyOfCondensingGas;

       redeclare function extends enthalpyOfNonCondensingGas
        "Return specific enthalpy of dry air as a function of temperature T"

       algorithm
         h := SingleGasNasa.h_Tlow(data=dryair, T=T, refChoice=3, h_off=25104.684);
         annotation(Inline=false,smoothOrder=1,
            Documentation(info="<html>
Specific enthalpy of dry air is computed from temperature.
</html>"));
       end enthalpyOfNonCondensingGas;

      function enthalpyOfWater
        "Computes specific enthalpy of water (solid/liquid) near atmospheric pressure from temperature T"
        input SIunits.Temperature T "Temperature";
        output SIunits.SpecificEnthalpy h "Specific enthalpy of water";
      algorithm
      /*simple model assuming constant properties:
  heat capacity of liquid water:4200 J/kg
  heat capacity of solid water: 2050 J/kg
  enthalpy of fusion (liquid=>solid): 333000 J/kg*/

        h:=Utilities.spliceFunction(4200*(T-273.15),2050*(T-273.15)-333000,T-273.16,0.1);
      annotation (derivative=enthalpyOfWater_der, Documentation(info="<html>
Specific enthalpy of water (liquid and solid) is computed from temperature using constant properties as follows:<br>
<ul>
<li>  heat capacity of liquid water:4200 J/kg
<li>  heat capacity of solid water: 2050 J/kg
<li>  enthalpy of fusion (liquid=>solid): 333000 J/kg
</ul>
Pressure is assumed to be around 1 bar. This function is usually used to determine the specific enthalpy of the liquid or solid fraction of moist air.
</html>"));
      end enthalpyOfWater;

      function enthalpyOfWater_der "Derivative function of enthalpyOfWater"
        input SIunits.Temperature T "Temperature";
        input Real dT(unit="K/s") "Time derivative of temperature";
        output Real dh(unit="J/(kg.s)") "Time derivative of specific enthalpy";
      algorithm
      /*simple model assuming constant properties:
  heat capacity of liquid water:4200 J/kg
  heat capacity of solid water: 2050 J/kg
  enthalpy of fusion (liquid=>solid): 333000 J/kg*/

        //h:=Utilities.spliceFunction(4200*(T-273.15),2050*(T-273.15)-333000,T-273.16,0.1);
        dh:=Utilities.spliceFunction_der(4200*(T-273.15),2050*(T-273.15)-333000,T-273.16,0.1,4200*dT,2050*dT,dT,0);
          annotation (Documentation(info="<html>
Derivative function for <a href=\"modelica://Modelica.Media.Air.MoistAir.enthalpyOfWater\">enthalpyOfWater</a>.

</html>"));
      end enthalpyOfWater_der;

       redeclare function extends pressure
        "Returns pressure of ideal gas as a function of the thermodynamic state record"

       algorithm
        p := state.p;
         annotation(smoothOrder=2,
                      Documentation(info="<html>
Pressure is returned from the thermodynamic state record input as a simple assignment.
</html>"));
       end pressure;

       redeclare function extends temperature
        "Return temperature of ideal gas as a function of the thermodynamic state record"

       algorithm
         T := state.T;
         annotation(smoothOrder=2,
                      Documentation(info="<html>
Temperature is returned from the thermodynamic state record input as a simple assignment.
</html>"));
       end temperature;

      function T_phX
        "Return temperature as a function of pressure p, specific enthalpy h and composition X"
        input AbsolutePressure p "Pressure";
        input SpecificEnthalpy h "Specific enthalpy";
        input MassFraction[:] X "Mass fractions of composition";
        output Temperature T "Temperature";

      protected
      package Internal
          "Solve h(data,T) for T with given h (use only indirectly via temperature_phX)"
        extends Modelica.Media.Common.OneNonLinearEquation;
        redeclare record extends f_nonlinear_Data
            "Data to be passed to non-linear function"
          extends Modelica.Media.IdealGases.Common.DataRecord;
        end f_nonlinear_Data;

        redeclare function extends f_nonlinear
        algorithm
            y := h_pTX(p,x,X);
        end f_nonlinear;

        // Dummy definition has to be added for current Dymola
        redeclare function extends solve
        end solve;
      end Internal;

      algorithm
        T := Internal.solve(h, 240, 400, p, X[1:nXi], steam);
          annotation (Documentation(info="<html>
Temperature is computed from pressure, specific enthalpy and composition via numerical inversion of function <a href=\"modelica://Modelica.Media.Air.MoistAir.h_pTX\">h_pTX</a>.
</html>"));
      end T_phX;

       redeclare function extends density
        "Returns density of ideal gas as a function of the thermodynamic state record"

       algorithm
         d := state.p/(gasConstant(state)*state.T);
         annotation(smoothOrder=2,
                      Documentation(info="<html>
Density is computed from pressure, temperature and composition in the thermodynamic state record applying the ideal gas law.
</html>"));
       end density;

      redeclare function extends specificEnthalpy
        "Return specific enthalpy of moist air as a function of the thermodynamic state record"

      algorithm
        h := h_pTX(state.p, state.T, state.X);
        annotation(smoothOrder=2,
                      Documentation(info="<html>
Specific enthalpy of moist air is computed from the thermodynamic state record. The fog region is included for both, ice and liquid fog.
</html>"));
      end specificEnthalpy;

      function h_pTX
        "Return specific enthalpy of moist air as a function of pressure p, temperature T and composition X"
        extends Modelica.Icons.Function;
        input SI.Pressure p "Pressure";
        input SI.Temperature T "Temperature";
        input SI.MassFraction X[:] "Mass fractions of moist air";
        output SI.SpecificEnthalpy h "Specific enthalpy at p, T, X";
      protected
        SI.AbsolutePressure p_steam_sat "Partial saturation pressure of steam";
        SI.MassFraction X_sat "Absolute humidity per unit mass of moist air";
        SI.MassFraction X_liquid "mass fraction of liquid water";
        SI.MassFraction X_steam "mass fraction of steam water";
        SI.MassFraction X_air "mass fraction of air";
      algorithm
        p_steam_sat :=saturationPressure(T);
        //p_steam_sat :=min(saturationPressure(T), 0.999*p);
        X_sat:=min(p_steam_sat*k_mair/max(100*Constants.eps, p - p_steam_sat)*(1 - X[
          Water]), 1.0);
        X_liquid :=max(X[Water] - X_sat, 0.0);
        X_steam  :=X[Water] - X_liquid;
        X_air    :=1 - X[Water];
       /* h        := {SingleGasNasa.h_Tlow(data=steam,  T=T, refChoice=3, h_off=46479.819+2501014.5),
               SingleGasNasa.h_Tlow(data=dryair, T=T, refChoice=3, h_off=25104.684)}*
    {X_steam, X_air} + enthalpyOfLiquid(T)*X_liquid;*/
         h        := {SingleGasNasa.h_Tlow(data=steam,  T=T, refChoice=3, h_off=46479.819+2501014.5),
                     SingleGasNasa.h_Tlow(data=dryair, T=T, refChoice=3, h_off=25104.684)}*
          {X_steam, X_air} + enthalpyOfWater(T)*X_liquid;
        annotation(derivative=h_pTX_der, Inline=false,
            Documentation(info="<html>
Specific enthalpy of moist air is computed from pressure, temperature and composition with X[1] as the total water mass fraction. The fog region is included for both, ice and liquid fog.
</html>"));
      end h_pTX;

      function h_pTX_der "Derivative function of h_pTX"
        extends Modelica.Icons.Function;
        input SI.Pressure p "Pressure";
        input SI.Temperature T "Temperature";
        input SI.MassFraction X[:] "Mass fractions of moist air";
        input Real dp(unit="Pa/s") "Pressure derivative";
        input Real dT(unit="K/s") "Temperature derivative";
        input Real dX[:](each unit="1/s") "Composition derivative";
        output Real h_der(unit="J/(kg.s)")
          "Time derivative of specific enthalpy";
      protected
        SI.AbsolutePressure p_steam_sat "Partial saturation pressure of steam";
        SI.MassFraction X_sat "Absolute humidity per unit mass of moist air";
        SI.MassFraction X_liquid "Mass fraction of liquid water";
        SI.MassFraction X_steam "Mass fraction of steam water";
        SI.MassFraction X_air "Mass fraction of air";
        SI.MassFraction x_sat
          "Absolute humidity per unit mass of dry air at saturation";
        Real dX_steam(unit="1/s") "Time deriveative of steam mass fraction";
        Real dX_air(unit="1/s") "Time derivative of dry air mass fraction";
        Real dX_liq(unit="1/s")
          "Time derivative of liquid/solid water mass fraction";
        Real dps(unit="Pa/s") "Time derivative of saturation pressure";
        Real dx_sat(unit="1/s")
          "Time derivative of abolute humidity per unit mass of dry air";
      algorithm
        p_steam_sat :=saturationPressure(T);
        x_sat:=p_steam_sat*k_mair/max(100*Modelica.Constants.eps, p - p_steam_sat);
        X_sat:=min(x_sat*(1 - X[Water]), 1.0);
        X_liquid :=Utilities.spliceFunction(X[Water] - X_sat, 0.0, X[Water] - X_sat,1e-6);
        X_steam  :=X[Water] - X_liquid;
        X_air    :=1 - X[Water];

        dX_air:=-dX[Water];
        dps:=saturationPressure_der(Tsat=T, dTsat=dT);
        dx_sat:=k_mair*(dps*(p-p_steam_sat)-p_steam_sat*(dp-dps))/(p-p_steam_sat)/(p-p_steam_sat);
        dX_liq:=Utilities.spliceFunction_der(X[Water] - X_sat, 0.0, X[Water] - X_sat,1e-6,(1+x_sat)*dX[Water]-(1-X[Water])*dx_sat,0.0,(1+x_sat)*dX[Water]-(1-X[Water])*dx_sat,0.0);
        //dX_liq:=if X[Water]>=X_sat then (1+x_sat)*dX[Water]-(1-X[Water])*dx_sat else 0;
        dX_steam:=dX[Water]-dX_liq;

        h_der:= X_steam*Modelica.Media.IdealGases.Common.SingleGasNasa.h_Tlow_der(data=steam, T=T, refChoice=3, h_off=46479.819+2501014.5, dT=dT)+
                dX_steam*Modelica.Media.IdealGases.Common.SingleGasNasa.h_Tlow(data=steam,  T=T, refChoice=3, h_off=46479.819+2501014.5) +
                X_air*Modelica.Media.IdealGases.Common.SingleGasNasa.h_Tlow_der(data=dryair, T=T, refChoice=3, h_off=25104.684, dT=dT) +
                dX_air*Modelica.Media.IdealGases.Common.SingleGasNasa.h_Tlow(data=dryair, T=T, refChoice=3, h_off=25104.684) +
                X_liquid*enthalpyOfWater_der(T=T, dT=dT) +
                dX_liq*enthalpyOfWater(T);

        annotation(Inline=false,smoothOrder=1,
            Documentation(info="<html>
Derivative function for <a href=\"modelica://Modelica.Media.Air.MoistAir.h_pTX\">h_pTX</a>.
</html>"));
      end h_pTX_der;

      redeclare function extends isentropicExponent
        "Return isentropic exponent (only for gas fraction!)"
      algorithm
        gamma := specificHeatCapacityCp(state)/specificHeatCapacityCv(state);
      end isentropicExponent;

      redeclare function extends specificInternalEnergy
        "Return specific internal energy of moist air as a function of the thermodynamic state record"
        extends Modelica.Icons.Function;
        output SI.SpecificInternalEnergy u "Specific internal energy";
      algorithm
         u := specificInternalEnergy_pTX(state.p,state.T,state.X);

        annotation(smoothOrder=2,
                      Documentation(info="<html>
Specific internal energy is determined from the thermodynamic state record, assuming that the liquid or solid water volume is negligible.
</html>"));
      end specificInternalEnergy;

      function specificInternalEnergy_pTX
        "Return specific internal energy of moist air as a function of pressure p, temperature T and composition X"
        input SI.Pressure p "Pressure";
        input SI.Temperature T "Temperature";
        input SI.MassFraction X[:] "Mass fractions of moist air";
        output SI.SpecificInternalEnergy u "Specific internal energy";
      protected
        SI.AbsolutePressure p_steam_sat "Partial saturation pressure of steam";
        SI.MassFraction X_liquid "Mass fraction of liquid water";
        SI.MassFraction X_steam "Mass fraction of steam water";
        SI.MassFraction X_air "Mass fraction of air";
        SI.MassFraction X_sat "Absolute humidity per unit mass of moist air";
        Real R_gas "Ideal gas constant";
      algorithm
        p_steam_sat :=saturationPressure(T);
        X_sat:=min(p_steam_sat*k_mair/max(100*Constants.eps, p - p_steam_sat)*(1 - X[
          Water]), 1.0);
        X_liquid :=max(X[Water] - X_sat, 0.0);
        X_steam  :=X[Water] - X_liquid;
        X_air    :=1 - X[Water];
        R_gas:= dryair.R*X_air/(1-X_liquid)+steam.R* X_steam/(1-X_liquid);
        u       := X_steam*SingleGasNasa.h_Tlow(data=steam,  T=T, refChoice=3, h_off=46479.819+2501014.5)+
                   X_air*SingleGasNasa.h_Tlow(data=dryair, T=T, refChoice=3, h_off=25104.684)
                   + enthalpyOfWater(T)*X_liquid-R_gas*T;

          annotation (derivative=specificInternalEnergy_pTX_der, Documentation(info="<html>
Specific internal energy is determined from pressure p, temperature T and composition X, assuming that the liquid or solid water volume is negligible.
</html>"));
      end specificInternalEnergy_pTX;

      function specificInternalEnergy_pTX_der
        "Derivative function for specificInternalEnergy_pTX"
        input SI.Pressure p "Pressure";
        input SI.Temperature T "Temperature";
        input SI.MassFraction X[:] "Mass fractions of moist air";
        input Real dp(unit="Pa/s") "Pressure derivative";
        input Real dT(unit="K/s") "Temperature derivative";
        input Real dX[:](each unit="1/s") "Mass fraction derivatives";
        output Real u_der(unit="J/(kg.s)")
          "Specific internal energy derivative";
      protected
        SI.AbsolutePressure p_steam_sat "Partial saturation pressure of steam";
        SI.MassFraction X_liquid "Mass fraction of liquid water";
        SI.MassFraction X_steam "Mass fraction of steam water";
        SI.MassFraction X_air "Mass fraction of air";
        SI.MassFraction X_sat "Absolute humidity per unit mass of moist air";
        SI.SpecificHeatCapacity R_gas "Ideal gas constant";

        SI.MassFraction x_sat
          "Absolute humidity per unit mass of dry air at saturation";
        Real dX_steam(unit="1/s") "Time deriveative of steam mass fraction";
        Real dX_air(unit="1/s") "Time derivative of dry air mass fraction";
        Real dX_liq(unit="1/s")
          "Time derivative of liquid/solid water mass fraction";
        Real dps(unit="Pa/s") "Time derivative of saturation pressure";
        Real dx_sat(unit="1/s")
          "Time derivative of abolute humidity per unit mass of dry air";
        Real dR_gas(unit="J/(kg.K.s)") "Time derivative of ideal gas constant";
      algorithm
        p_steam_sat :=saturationPressure(T);
        x_sat:=p_steam_sat*k_mair/max(100*Modelica.Constants.eps, p - p_steam_sat);
        X_sat:=min(x_sat*(1 - X[Water]), 1.0);
        X_liquid :=Utilities.spliceFunction(X[Water] - X_sat, 0.0, X[Water] - X_sat,1e-6);
        X_steam  :=X[Water] - X_liquid;
        X_air    :=1 - X[Water];
        R_gas:= steam.R*X_steam/(1-X_liquid)+dryair.R* X_air/(1-X_liquid);

        dX_air:=-dX[Water];
        dps:=saturationPressure_der(Tsat=T, dTsat=dT);
        dx_sat:=k_mair*(dps*(p-p_steam_sat)-p_steam_sat*(dp-dps))/(p-p_steam_sat)/(p-p_steam_sat);
        dX_liq:=Utilities.spliceFunction_der(X[Water] - X_sat, 0.0, X[Water] - X_sat,1e-6,(1+x_sat)*dX[Water]-(1-X[Water])*dx_sat,0.0,(1+x_sat)*dX[Water]-(1-X[Water])*dx_sat,0.0);
        dX_steam:=dX[Water]-dX_liq;
        dR_gas:=(steam.R*(dX_steam*(1-X_liquid)+dX_liq*X_steam)+dryair.R*(dX_air*(1-X_liquid)+dX_liq*X_air))/(1-X_liquid)/(1-X_liquid);

        u_der:=X_steam*SingleGasNasa.h_Tlow_der(data=steam, T=T, refChoice=3, h_off=46479.819+2501014.5, dT=dT)+
               dX_steam*SingleGasNasa.h_Tlow(data=steam,  T=T, refChoice=3, h_off=46479.819+2501014.5) +
               X_air*SingleGasNasa.h_Tlow_der(data=dryair, T=T, refChoice=3, h_off=25104.684, dT=dT) +
               dX_air*SingleGasNasa.h_Tlow(data=dryair, T=T, refChoice=3, h_off=25104.684) +
               X_liquid*enthalpyOfWater_der(T=T, dT=dT) +
               dX_liq*enthalpyOfWater(T) - dR_gas*T-R_gas*dT;
          annotation (Documentation(info="<html>
Derivative function for <a href=\"modelica://Modelica.Media.Air.MoistAir.specificInternalEnergy_pTX\">specificInternalEnergy_pTX</a>.
</html>"));
      end specificInternalEnergy_pTX_der;

       redeclare function extends specificEntropy
        "Return specific entropy from thermodynamic state record, only valid for phi<1"

      protected
          MoleFraction[2] Y = massToMoleFractions(state.X,{steam.MM,dryair.MM})
          "molar fraction";
       algorithm
         s:=SingleGasNasa.s0_Tlow(dryair, state.T)*(1-state.X[Water])
           + SingleGasNasa.s0_Tlow(steam, state.T)*state.X[Water]
           - (state.X[Water]*Modelica.Constants.R/MMX[Water]*(if state.X[Water]<Modelica.Constants.eps then state.X[Water] else Modelica.Math.log(Y[Water]*state.p/reference_p))
             + (1-state.X[Water])*Modelica.Constants.R/MMX[Air]*(if (1-state.X[Water])<Modelica.Constants.eps then (1-state.X[Water]) else Modelica.Math.log(Y[Air]*state.p/reference_p)));
           annotation(Inline=false,smoothOrder=2,
            Documentation(info="<html>
Specific entropy is calculated from the thermodynamic state record, assuming ideal gas behavior and including entropy of mixing. Liquid or solid water is not taken into account, the entire water content X[1] is assumed to be in the vapor state (relative humidity below 1.0).
</html>"));
       end specificEntropy;

      redeclare function extends specificGibbsEnergy
        "Return specific Gibbs energy as a function of the thermodynamic state record, only valid for phi<1"
        extends Modelica.Icons.Function;
      algorithm
        g := h_pTX(state.p,state.T,state.X) - state.T*specificEntropy(state);
        annotation(smoothOrder=2,
                      Documentation(info="<html>
The Gibbs Energy is computed from the thermodynamic state record for moist air with a water content below saturation.
</html>"));
      end specificGibbsEnergy;

      redeclare function extends specificHelmholtzEnergy
        "Return specific Helmholtz energy as a function of the thermodynamic state record, only valid for phi<1"
        extends Modelica.Icons.Function;
      algorithm
        f := h_pTX(state.p,state.T,state.X) - gasConstant(state)*state.T - state.T*specificEntropy(state);
        annotation(smoothOrder=2,
                      Documentation(info="<html>
The Specific Helmholtz Energy is computed from the thermodynamic state record for moist air with a water content below saturation.
</html>"));
      end specificHelmholtzEnergy;

       redeclare function extends specificHeatCapacityCp
        "Return specific heat capacity at constant pressure as a function of the thermodynamic state record"

      protected
         Real dT(unit="s/K") = 1.0;
       algorithm
         cp := h_pTX_der(state.p,state.T,state.X, 0.0, 1.0, zeros(size(state.X,1)))*dT
          "Definition of cp: dh/dT @ constant p";
         //      cp:= SingleGasNasa.cp_Tlow(dryair, state.T)*(1-state.X[Water])
         //        + SingleGasNasa.cp_Tlow(steam, state.T)*state.X[Water];
         annotation(Inline=false,smoothOrder=2,
            Documentation(info="<html>
The specific heat capacity at constant pressure <b>cp</b> is computed from temperature and composition for a mixture of steam (X[1]) and dry air. All water is assumed to be in the vapor state.
</html>"));
       end specificHeatCapacityCp;

      redeclare function extends specificHeatCapacityCv
        "Return specific heat capacity at constant volume as a function of the thermodynamic state record"

      algorithm
        cv:= SingleGasNasa.cp_Tlow(dryair, state.T)*(1-state.X[Water]) +
          SingleGasNasa.cp_Tlow(steam, state.T)*state.X[Water]
          - gasConstant(state);
         annotation(Inline=false,smoothOrder=2,
            Documentation(info="<html>
The specific heat capacity at constant density <b>cv</b> is computed from temperature and composition for a mixture of steam (X[1]) and dry air. All water is assumed to be in the vapor state.
</html>"));
      end specificHeatCapacityCv;

      redeclare function extends dynamicViscosity
        "Return dynamic viscosity as a function of the thermodynamic state record, valid from 73.15 K to 373.15 K"

          import Modelica.Media.Incompressible.TableBased.Polynomials_Temp;
      algorithm
        eta := Polynomials_Temp.evaluate({(-4.96717436974791E-011), 5.06626785714286E-008, 1.72937731092437E-005},
             Cv.to_degC(state.T));
        annotation(smoothOrder=2,
                      Documentation(info="<html>
Dynamic viscosity is computed from temperature using a simple polynomial for dry air, assuming that moisture influence is small. Range of  validity is from 73.15 K to 373.15 K.
</html>"));
      end dynamicViscosity;

      redeclare function extends thermalConductivity
        "Return thermal conductivity as a function of the thermodynamic state record, valid from 73.15 K to 373.15 K"

          import Modelica.Media.Incompressible.TableBased.Polynomials_Temp;
      algorithm
        lambda := Polynomials_Temp.evaluate({(-4.8737307422969E-008), 7.67803133753502E-005, 0.0241814385504202},
         Cv.to_degC(state.T));
        annotation(smoothOrder=2,
                      Documentation(info="<html>
Thermal conductivity is computed from temperature using a simple polynomial for dry air, assuming that moisture influence is small. Range of  validity is from 73.15 K to 373.15 K.
</html>"));
      end thermalConductivity;

        package Utilities "utility functions"

          function spliceFunction "Spline interpolation of two functions"
              input Real pos "Returned value for x-deltax >= 0";
              input Real neg "Returned value for x+deltax <= 0";
              input Real x "Function argument";
              input Real deltax=1 "Region around x with spline interpolation";
              output Real out;
        protected
              Real scaledX;
              Real scaledX1;
              Real y;
          algorithm
              scaledX1 := x/deltax;
              scaledX := scaledX1*Modelica.Math.asin(1);
              if scaledX1 <= -0.999999999 then
                y := 0;
              elseif scaledX1 >= 0.999999999 then
                y := 1;
              else
                y := (Modelica.Math.tanh(Modelica.Math.tan(scaledX)) + 1)/2;
              end if;
              out := pos*y + (1 - y)*neg;
              annotation (derivative=spliceFunction_der);
          end spliceFunction;

          function spliceFunction_der "Derivative of spliceFunction"
              input Real pos;
              input Real neg;
              input Real x;
              input Real deltax=1;
              input Real dpos;
              input Real dneg;
              input Real dx;
              input Real ddeltax=0;
              output Real out;
        protected
              Real scaledX;
              Real scaledX1;
              Real dscaledX1;
              Real y;
          algorithm
              scaledX1 := x/deltax;
              scaledX := scaledX1*Modelica.Math.asin(1);
              dscaledX1 := (dx - scaledX1*ddeltax)/deltax;
              if scaledX1 <= -0.99999999999 then
                y := 0;
              elseif scaledX1 >= 0.9999999999 then
                y := 1;
              else
                y := (Modelica.Math.tanh(Modelica.Math.tan(scaledX)) + 1)/2;
              end if;
              out := dpos*y + (1 - y)*dneg;
              if (abs(scaledX1) < 1) then
                out := out + (pos - neg)*dscaledX1*Modelica.Math.asin(1)/2/(
                  Modelica.Math.cosh(Modelica.Math.tan(scaledX))*Modelica.Math.cos(
                  scaledX))^2;
              end if;
          end spliceFunction_der;
        end Utilities;
        annotation (Documentation(info="<html>
<h4>Thermodynamic Model</h4>
<p>This package provides a full thermodynamic model of moist air including the fog region and temperatures below zero degC.
The governing assumptions in this model are:</p>
<ul>
<li>the perfect gas law applies</li>
<li>water volume other than that of steam is neglected</li></ul>
<p>All extensive properties are expressed in terms of the total mass in order to comply with other media in this libary. However, for moist air it is rather common to express the absolute humidity in terms of mass of dry air only, which has advantages when working with charts. In addition, care must be taken, when working with mass fractions with respect to total mass, that all properties refer to the same water content when being used in mathematical operations (which is always the case if based on dry air only). Therefore two absolute humidities are computed in the <b>BaseProperties</b> model: <b>X</b> denotes the absolute humidity in terms of the total mass while <b>x</b> denotes the absolute humitity per unit mass of dry air. In addition, the relative humidity <b>phi</b> is also computed.</p>
<p>At the triple point temperature of water of 0.01 &deg;C or 273.16 K and a relative humidity greater than 1 fog may be present as liquid and as ice resulting in a specific enthalpy somewhere between those of the two isotherms for solid and liquid fog, respectively. For numerical reasons a coexisting mixture of 50% solid and 50% liquid fog is assumed in the fog region at the triple point in this model.</p>

<h4>Range of validity</h4>
<p>From the assumptions mentioned above it follows that the <b>pressure</b> should be in the region around <b>atmospheric</b> conditions or below (a few bars may still be fine though). Additionally a very high water content at low temperatures would yield incorrect densities, because the volume of the liquid or solid phase would not be negligible anymore. The model does not provide information on limits for water drop size in the fog region or transport information for the actual condensation or evaporation process in combination with surfaces. All excess water which is not in its vapour state is assumed to be still present in the air regarding its energy but not in terms of its spatial extent.<br><br>
The thermodynamic model may be used for <b>temperatures</b> ranging from <b>240 - 400 K</b>. This holds for all functions unless otherwise stated in their description. However, although the model works at temperatures above the saturation temperature it is questionable to use the term \"relative humidity\" in this region. Please note, that although several functions compute pure water properties, they are designed to be used within the moist air medium model where properties are dominated by air and steam in their vapor states, and not for pure liquid water applications.</p>

<h4>Transport Properties</h4>
<p>Several additional functions that are not needed to describe the thermodynamic system, but are required to model transport processes, like heat and mass transfer, may be called. They usually neglect the moisture influence unless otherwise stated.</p>

<h4>Application</h4>
<p>The model's main area of application is all processes that involve moist air cooling under near atmospheric pressure with possible moisture condensation. This is the case in all domestic and industrial air conditioning applications. Another large domain of moist air applications covers all processes that deal with dehydration of bulk material using air as a transport medium. Engineering tasks involving moist air are often performed (or at least visualized) by using charts that contain all relevant thermodynamic data for a moist air system. These so called psychrometric charts can be generated from the medium properties in this package. The model <a href=\"modelica://Modelica.Media.Air.MoistAir.PsychrometricData\">PsychrometricData</a> may be used for this purpose in order to obtain data for figures like those below (the plotting itself is not part of the model though).</p>

<img src=\"modelica://Modelica/Resources/Images/Media/Air/Mollier.png\">

<img src=\"modelica://Modelica/Resources/Images/Media/Air/PsycroChart.png\">

<p>
<b>Legend:</b> blue - constant specific enthalpy, red - constant temperature, black - constant relative humidity</p>

</html>"));
      end MoistAir;
      annotation (Documentation(info="<html>
  <p>This package contains different medium models for air:</p>
<ul>
<li><b>SimpleAir</b><br>
    Simple dry air medium in a limited temperature range.</li>
<li><b>DryAirNasa</b><br>
    Dry air as an ideal gas from Media.IdealGases.MixtureGases.Air.</li>
<li><b>MoistAir</b><br>
    Moist air as an ideal gas mixture of steam and dry air with fog below and above the triple point temperature.</li>
</ul>
</html>"));
    end Air;

    package IdealGases
    "Data and models of ideal gases (single, fixed and dynamic mixtures) from NASA source"
      extends Modelica.Icons.MaterialPropertiesPackage;

      package Common "Common packages and data for the ideal gas models"
      extends Modelica.Icons.Package;

      record DataRecord
        "Coefficient data record for properties of ideal gases based on NASA source"
        extends Modelica.Icons.Record;
        String name "Name of ideal gas";
        SI.MolarMass MM "Molar mass";
        SI.SpecificEnthalpy Hf "Enthalpy of formation at 298.15K";
        SI.SpecificEnthalpy H0 "H0(298.15K) - H0(0K)";
        SI.Temperature Tlimit
          "Temperature limit between low and high data sets";
        Real alow[7] "Low temperature coefficients a";
        Real blow[2] "Low temperature constants b";
        Real ahigh[7] "High temperature coefficients a";
        Real bhigh[2] "High temperature constants b";
        SI.SpecificHeatCapacity R "Gas constant";
        annotation (Documentation(info="<HTML>
<p>
This data record contains the coefficients for the
ideal gas equations according to:
</p>
<blockquote>
  <p>McBride B.J., Zehe M.J., and Gordon S. (2002): <b>NASA Glenn Coefficients
  for Calculating Thermodynamic Properties of Individual Species</b>. NASA
  report TP-2002-211556</p>
</blockquote>
<p>
The equations have the following structure:
</p>
<IMG src=\"modelica://Modelica/Resources/Images/Media/IdealGases/singleEquations.png\">
<p>
The polynomials for h(T) and s0(T) are derived via integration from the one for cp(T)  and contain the integration constants b1, b2 that define the reference specific enthalpy and entropy. For entropy differences the reference pressure p0 is arbitrary, but not for absolute entropies. It is chosen as 1 standard atmosphere (101325 Pa).
</p>
<p>
For most gases, the region of validity is from 200 K to 6000 K.
The equations are splitted into two regions that are separated
by Tlimit (usually 1000 K). In both regions the gas is described
by the data above. The two branches are continuous and in most
gases also differentiable at Tlimit.
</p>
</HTML>"));
      end DataRecord;

      partial package SingleGasNasa
        "Medium model of an ideal gas based on NASA source"

        extends Interfaces.PartialPureSubstance(
           ThermoStates = Choices.IndependentVariables.pT,
           mediumName=data.name,
           substanceNames={data.name},
           singleState=false,
           Temperature(min=200, max=6000, start=500, nominal=500),
           SpecificEnthalpy(start=if referenceChoice==ReferenceEnthalpy.ZeroAt0K then data.H0 else
              if referenceChoice==ReferenceEnthalpy.UserDefined then h_offset else 0, nominal=1.0e5),
           Density(start=10, nominal=10),
           AbsolutePressure(start=10e5, nominal=10e5));

        redeclare record extends ThermodynamicState
          "thermodynamic state variables for ideal gases"
          AbsolutePressure p "Absolute pressure of medium";
          Temperature T "Temperature of medium";
        end ThermodynamicState;

        redeclare record extends FluidConstants "Extended fluid constants"
          Temperature criticalTemperature "critical temperature";
          AbsolutePressure criticalPressure "critical pressure";
          MolarVolume criticalMolarVolume "critical molar Volume";
          Real acentricFactor "Pitzer acentric factor";
          Temperature triplePointTemperature "triple point temperature";
          AbsolutePressure triplePointPressure "triple point pressure";
          Temperature meltingPoint "melting point at 101325 Pa";
          Temperature normalBoilingPoint "normal boiling point (at 101325 Pa)";
          DipoleMoment dipoleMoment
            "dipole moment of molecule in Debye (1 debye = 3.33564e10-30 C.m)";
          Boolean hasIdealGasHeatCapacity=false
            "true if ideal gas heat capacity is available";
          Boolean hasCriticalData=false "true if critical data are known";
          Boolean hasDipoleMoment=false "true if a dipole moment known";
          Boolean hasFundamentalEquation=false "true if a fundamental equation";
          Boolean hasLiquidHeatCapacity=false
            "true if liquid heat capacity is available";
          Boolean hasSolidHeatCapacity=false
            "true if solid heat capacity is available";
          Boolean hasAccurateViscosityData=false
            "true if accurate data for a viscosity function is available";
          Boolean hasAccurateConductivityData=false
            "true if accurate data for thermal conductivity is available";
          Boolean hasVapourPressureCurve=false
            "true if vapour pressure data, e.g., Antoine coefficents are known";
          Boolean hasAcentricFactor=false
            "true if Pitzer accentric factor is known";
          SpecificEnthalpy HCRIT0=0.0
            "Critical specific enthalpy of the fundamental equation";
          SpecificEntropy SCRIT0=0.0
            "Critical specific entropy of the fundamental equation";
          SpecificEnthalpy deltah=0.0
            "Difference between specific enthalpy model (h_m) and f.eq. (h_f) (h_m - h_f)";
          SpecificEntropy deltas=0.0
            "Difference between specific enthalpy model (s_m) and f.eq. (s_f) (s_m - s_f)";
        end FluidConstants;

          import SI = Modelica.SIunits;
          import Modelica.Math;
          import
          Modelica.Media.Interfaces.PartialMedium.Choices.ReferenceEnthalpy;

        constant Boolean excludeEnthalpyOfFormation=true
          "If true, enthalpy of formation Hf is not included in specific enthalpy h";
        constant ReferenceEnthalpy referenceChoice=Choices.
              ReferenceEnthalpy.ZeroAt0K "Choice of reference enthalpy";
        constant SpecificEnthalpy h_offset=0.0
          "User defined offset for reference enthalpy, if referenceChoice = UserDefined";

        constant IdealGases.Common.DataRecord data
          "Data record of ideal gas substance";

        constant FluidConstants[nS] fluidConstants
          "constant data for the fluid";

        redeclare model extends BaseProperties(
         T(stateSelect=if preferredMediumStates then StateSelect.prefer else StateSelect.default),
         p(stateSelect=if preferredMediumStates then StateSelect.prefer else StateSelect.default))
          "Base properties of ideal gas medium"
        equation
          assert(T >= 200 and T <= 6000, "
Temperature T (= "       + String(T) + " K) is not in the allowed range
200 K <= T <= 6000 K required from medium model \""       + mediumName + "\".
");
          MM = data.MM;
          R = data.R;
          h = h_T(data, T, excludeEnthalpyOfFormation, referenceChoice, h_offset);
          u = h - R*T;

          // Has to be written in the form d=f(p,T) in order that static
          // state selection for p and T is possible
          d = p/(R*T);
          // connect state with BaseProperties
          state.T = T;
          state.p = p;
        end BaseProperties;

          redeclare function setState_pTX
          "Return thermodynamic state as function of p, T and composition X"
            extends Modelica.Icons.Function;
            input AbsolutePressure p "Pressure";
            input Temperature T "Temperature";
            input MassFraction X[:]=reference_X "Mass fractions";
            output ThermodynamicState state;
          algorithm
            state := ThermodynamicState(p=p,T=T);
          end setState_pTX;

          redeclare function setState_phX
          "Return thermodynamic state as function of p, h and composition X"
            extends Modelica.Icons.Function;
            input AbsolutePressure p "Pressure";
            input SpecificEnthalpy h "Specific enthalpy";
            input MassFraction X[:]=reference_X "Mass fractions";
            output ThermodynamicState state;
          algorithm
            state := ThermodynamicState(p=p,T=T_h(h));
          end setState_phX;

          redeclare function setState_psX
          "Return thermodynamic state as function of p, s and composition X"
            extends Modelica.Icons.Function;
            input AbsolutePressure p "Pressure";
            input SpecificEntropy s "Specific entropy";
            input MassFraction X[:]=reference_X "Mass fractions";
            output ThermodynamicState state;
          algorithm
            state := ThermodynamicState(p=p,T=T_ps(p,s));
          end setState_psX;

          redeclare function setState_dTX
          "Return thermodynamic state as function of d, T and composition X"
            extends Modelica.Icons.Function;
            input Density d "density";
            input Temperature T "Temperature";
            input MassFraction X[:]=reference_X "Mass fractions";
            output ThermodynamicState state;
          algorithm
            state := ThermodynamicState(p=d*data.R*T,T=T);
          end setState_dTX;

            redeclare function extends setSmoothState
          "Return thermodynamic state so that it smoothly approximates: if x > 0 then state_a else state_b"
            algorithm
              state := ThermodynamicState(p=Media.Common.smoothStep(x, state_a.p, state_b.p, x_small),
                                          T=Media.Common.smoothStep(x, state_a.T, state_b.T, x_small));
            end setSmoothState;

        redeclare function extends pressure "return pressure of ideal gas"
        algorithm
          p := state.p;
        end pressure;

        redeclare function extends temperature
          "return temperature of ideal gas"
        algorithm
          T := state.T;
        end temperature;

        redeclare function extends density "return density of ideal gas"
        algorithm
          d := state.p/(data.R*state.T);
        end density;

        redeclare function extends specificEnthalpy "Return specific enthalpy"
          extends Modelica.Icons.Function;
        algorithm
          h := h_T(data,state.T);
        end specificEnthalpy;

        redeclare function extends specificInternalEnergy
          "Return specific internal energy"
          extends Modelica.Icons.Function;
        algorithm
          u := h_T(data,state.T) - data.R*state.T;
        end specificInternalEnergy;

        redeclare function extends specificEntropy "Return specific entropy"
          extends Modelica.Icons.Function;
        algorithm
          s := s0_T(data, state.T) - data.R*Modelica.Math.log(state.p/reference_p);
        end specificEntropy;

        redeclare function extends specificGibbsEnergy
          "Return specific Gibbs energy"
          extends Modelica.Icons.Function;
        algorithm
          g := h_T(data,state.T) - state.T*specificEntropy(state);
        end specificGibbsEnergy;

        redeclare function extends specificHelmholtzEnergy
          "Return specific Helmholtz energy"
          extends Modelica.Icons.Function;
        algorithm
          f := h_T(data,state.T) - data.R*state.T - state.T*specificEntropy(state);
        end specificHelmholtzEnergy;

        redeclare function extends specificHeatCapacityCp
          "Return specific heat capacity at constant pressure"
        algorithm
          cp := cp_T(data, state.T);
        end specificHeatCapacityCp;

        redeclare function extends specificHeatCapacityCv
          "Compute specific heat capacity at constant volume from temperature and gas data"
        algorithm
          cv := cp_T(data, state.T) - data.R;
        end specificHeatCapacityCv;

        redeclare function extends isentropicExponent
          "Return isentropic exponent"
        algorithm
          gamma := specificHeatCapacityCp(state)/specificHeatCapacityCv(state);
        end isentropicExponent;

        redeclare function extends velocityOfSound "Return velocity of sound"
          extends Modelica.Icons.Function;
        algorithm
          a := sqrt(max(0,data.R*state.T*cp_T(data, state.T)/specificHeatCapacityCv(state)));
        end velocityOfSound;

        function isentropicEnthalpyApproximation
          "approximate method of calculating h_is from upstream properties and downstream pressure"
          extends Modelica.Icons.Function;
          input SI.Pressure p2 "downstream pressure";
          input ThermodynamicState state "properties at upstream location";
          input Boolean exclEnthForm=excludeEnthalpyOfFormation
            "If true, enthalpy of formation Hf is not included in specific enthalpy h";
          input ReferenceEnthalpy refChoice=referenceChoice
            "Choice of reference enthalpy";
          input SpecificEnthalpy h_off=h_offset
            "User defined offset for reference enthalpy, if referenceChoice = UserDefined";
          output SI.SpecificEnthalpy h_is "isentropic enthalpy";
        protected
          IsentropicExponent gamma =  isentropicExponent(state)
            "Isentropic exponent";
        algorithm
          h_is := h_T(data,state.T,exclEnthForm,refChoice,h_off) +
            gamma/(gamma - 1.0)*state.p/density(state)*((p2/state.p)^((gamma - 1)/gamma) - 1.0);
        end isentropicEnthalpyApproximation;

        redeclare function extends isentropicEnthalpy
          "Return isentropic enthalpy"
        input Boolean exclEnthForm=excludeEnthalpyOfFormation
            "If true, enthalpy of formation Hf is not included in specific enthalpy h";
        input ReferenceEnthalpy refChoice=referenceChoice
            "Choice of reference enthalpy";
        input SpecificEnthalpy h_off=h_offset
            "User defined offset for reference enthalpy, if referenceChoice = UserDefined";
        algorithm
          h_is := isentropicEnthalpyApproximation(p_downstream,refState,exclEnthForm,refChoice,h_off);
        end isentropicEnthalpy;

        redeclare function extends isobaricExpansionCoefficient
          "Returns overall the isobaric expansion coefficient beta"
        algorithm
          beta := 1/state.T;
        end isobaricExpansionCoefficient;

        redeclare function extends isothermalCompressibility
          "Returns overall the isothermal compressibility factor"
        algorithm
          kappa := 1.0/state.p;
        end isothermalCompressibility;

        redeclare function extends density_derp_T
          "Returns the partial derivative of density with respect to pressure at constant temperature"
        algorithm
          ddpT := 1/(state.T*data.R);
        end density_derp_T;

        redeclare function extends density_derT_p
          "Returns the partial derivative of density with respect to temperature at constant pressure"
        algorithm
          ddTp := -state.p/(state.T*state.T*data.R);
        end density_derT_p;

        redeclare function extends density_derX
          "Returns the partial derivative of density with respect to mass fractions at constant pressure and temperature"
        algorithm
          dddX := fill(0,nX);
        end density_derX;

        function cp_T
          "Compute specific heat capacity at constant pressure from temperature and gas data"
          extends Modelica.Icons.Function;
          input IdealGases.Common.DataRecord data "Ideal gas data";
          input SI.Temperature T "Temperature";
          output SI.SpecificHeatCapacity cp
            "Specific heat capacity at temperature T";
        algorithm
          cp := smooth(0,if T < data.Tlimit then data.R*(1/(T*T)*(data.alow[1] + T*(
            data.alow[2] + T*(1.*data.alow[3] + T*(data.alow[4] + T*(data.alow[5] + T
            *(data.alow[6] + data.alow[7]*T))))))) else data.R*(1/(T*T)*(data.ahigh[1]
             + T*(data.ahigh[2] + T*(1.*data.ahigh[3] + T*(data.ahigh[4] + T*(data.
            ahigh[5] + T*(data.ahigh[6] + data.ahigh[7]*T))))))));
          annotation (InlineNoEvent=false,smoothOrder=2);
        end cp_T;

        function cp_Tlow
          "Compute specific heat capacity at constant pressure, low T region"
          extends Modelica.Icons.Function;
          input IdealGases.Common.DataRecord data "Ideal gas data";
          input SI.Temperature T "Temperature";
          output SI.SpecificHeatCapacity cp
            "Specific heat capacity at temperature T";
        algorithm
          cp := data.R*(1/(T*T)*(data.alow[1] + T*(
            data.alow[2] + T*(1.*data.alow[3] + T*(data.alow[4] + T*(data.alow[5] + T
            *(data.alow[6] + data.alow[7]*T)))))));
          annotation (Inline=false, derivative(zeroDerivative=data) = cp_Tlow_der);
        end cp_Tlow;

        function cp_Tlow_der
          "Compute specific heat capacity at constant pressure, low T region"
          extends Modelica.Icons.Function;
          input IdealGases.Common.DataRecord data "Ideal gas data";
          input SI.Temperature T "Temperature";
          input Real dT "Temperature derivative";
          output Real cp_der "Derivative of specific heat capacity";
        algorithm
          cp_der := dT*data.R/(T*T*T)*(-2*data.alow[1] + T*(
            -data.alow[2] + T*T*(data.alow[4] + T*(2.*data.alow[5] + T
            *(3.*data.alow[6] + 4.*data.alow[7]*T)))));
        end cp_Tlow_der;

        function h_T "Compute specific enthalpy from temperature and gas data; reference is decided by the
    refChoice input, or by the referenceChoice package constant by default"
            import Modelica.Media.Interfaces.PartialMedium.Choices;
          extends Modelica.Icons.Function;
          input IdealGases.Common.DataRecord data "Ideal gas data";
          input SI.Temperature T "Temperature";
          input Boolean exclEnthForm=excludeEnthalpyOfFormation
            "If true, enthalpy of formation Hf is not included in specific enthalpy h";
          input Choices.ReferenceEnthalpy refChoice=referenceChoice
            "Choice of reference enthalpy";
          input SI.SpecificEnthalpy h_off=h_offset
            "User defined offset for reference enthalpy, if referenceChoice = UserDefined";
          output SI.SpecificEnthalpy h "Specific enthalpy at temperature T";
            //     annotation (InlineNoEvent=false, Inline=false,
            //                 derivative(zeroDerivative=data,
            //                            zeroDerivative=exclEnthForm,
            //                            zeroDerivative=refChoice,
            //                            zeroDerivative=h_off) = h_T_der);
        algorithm
          h := smooth(0,(if T < data.Tlimit then data.R*((-data.alow[1] + T*(data.
            blow[1] + data.alow[2]*Math.log(T) + T*(1.*data.alow[3] + T*(0.5*data.
            alow[4] + T*(1/3*data.alow[5] + T*(0.25*data.alow[6] + 0.2*data.alow[7]*T))))))
            /T) else data.R*((-data.ahigh[1] + T*(data.bhigh[1] + data.ahigh[2]*
            Math.log(T) + T*(1.*data.ahigh[3] + T*(0.5*data.ahigh[4] + T*(1/3*data.
            ahigh[5] + T*(0.25*data.ahigh[6] + 0.2*data.ahigh[7]*T))))))/T)) + (if
            exclEnthForm then -data.Hf else 0.0) + (if (refChoice
             == Choices.ReferenceEnthalpy.ZeroAt0K) then data.H0 else 0.0) + (if
            refChoice == Choices.ReferenceEnthalpy.UserDefined then h_off else
                  0.0));
          annotation (Inline=false,smoothOrder=2);
        end h_T;

        function h_T_der "derivative function for h_T"
            import Modelica.Media.Interfaces.PartialMedium.Choices;
          extends Modelica.Icons.Function;
          input IdealGases.Common.DataRecord data "Ideal gas data";
          input SI.Temperature T "Temperature";
          input Boolean exclEnthForm=excludeEnthalpyOfFormation
            "If true, enthalpy of formation Hf is not included in specific enthalpy h";
          input Choices.ReferenceEnthalpy refChoice=referenceChoice
            "Choice of reference enthalpy";
          input SI.SpecificEnthalpy h_off=h_offset
            "User defined offset for reference enthalpy, if referenceChoice = UserDefined";
          input Real dT "Temperature derivative";
          output Real h_der "Specific enthalpy at temperature T";
        algorithm
          h_der := dT*cp_T(data,T);
        end h_T_der;

        function h_Tlow "Compute specific enthalpy, low T region; reference is decided by the
    refChoice input, or by the referenceChoice package constant by default"
            import Modelica.Media.Interfaces.PartialMedium.Choices;
          extends Modelica.Icons.Function;
          input IdealGases.Common.DataRecord data "Ideal gas data";
          input SI.Temperature T "Temperature";
          input Boolean exclEnthForm=excludeEnthalpyOfFormation
            "If true, enthalpy of formation Hf is not included in specific enthalpy h";
          input Choices.ReferenceEnthalpy refChoice=referenceChoice
            "Choice of reference enthalpy";
          input SI.SpecificEnthalpy h_off=h_offset
            "User defined offset for reference enthalpy, if referenceChoice = UserDefined";
          output SI.SpecificEnthalpy h "Specific enthalpy at temperature T";
            //     annotation (Inline=false,InlineNoEvent=false, derivative(zeroDerivative=data,
            //                                zeroDerivative=exclEnthForm,
            //                                zeroDerivative=refChoice,
            //                                zeroDerivative=h_off) = h_Tlow_der);
        algorithm
          h := data.R*((-data.alow[1] + T*(data.
            blow[1] + data.alow[2]*Math.log(T) + T*(1.*data.alow[3] + T*(0.5*data.
            alow[4] + T*(1/3*data.alow[5] + T*(0.25*data.alow[6] + 0.2*data.alow[7]*T))))))
            /T) + (if
            exclEnthForm then -data.Hf else 0.0) + (if (refChoice
             == Choices.ReferenceEnthalpy.ZeroAt0K) then data.H0 else 0.0) + (if
            refChoice == Choices.ReferenceEnthalpy.UserDefined then h_off else
                  0.0);
          annotation(Inline=false,InlineNoEvent=false,smoothOrder=2);
        end h_Tlow;

        function h_Tlow_der "Compute specific enthalpy, low T region; reference is decided by the
    refChoice input, or by the referenceChoice package constant by default"
            import Modelica.Media.Interfaces.PartialMedium.Choices;
          extends Modelica.Icons.Function;
          input IdealGases.Common.DataRecord data "Ideal gas data";
          input SI.Temperature T "Temperature";
          input Boolean exclEnthForm=excludeEnthalpyOfFormation
            "If true, enthalpy of formation Hf is not included in specific enthalpy h";
          input Choices.ReferenceEnthalpy refChoice=referenceChoice
            "Choice of reference enthalpy";
          input SI.SpecificEnthalpy h_off=h_offset
            "User defined offset for reference enthalpy, if referenceChoice = UserDefined";
          input Real dT(unit="K/s") "Temperature derivative";
          output Real h_der(unit="J/(kg.s)")
            "Derivative of specific enthalpy at temperature T";
        algorithm
          h_der := dT*cp_Tlow(data,T);
        end h_Tlow_der;

        function s0_T "Compute specific entropy from temperature and gas data"
          extends Modelica.Icons.Function;
          input IdealGases.Common.DataRecord data "Ideal gas data";
          input SI.Temperature T "Temperature";
          output SI.SpecificEntropy s "Specific entropy at temperature T";
        algorithm
          s := noEvent(if T < data.Tlimit then data.R*(data.blow[2] - 0.5*data.alow[
            1]/(T*T) - data.alow[2]/T + data.alow[3]*Math.log(T) + T*(
            data.alow[4] + T*(0.5*data.alow[5] + T*(1/3*data.alow[6] + 0.25*data.alow[
            7]*T)))) else data.R*(data.bhigh[2] - 0.5*data.ahigh[1]/(T*T) - data.
            ahigh[2]/T + data.ahigh[3]*Math.log(T) + T*(data.ahigh[4]
             + T*(0.5*data.ahigh[5] + T*(1/3*data.ahigh[6] + 0.25*data.ahigh[7]*T)))));
          annotation (InlineNoEvent=false,smoothOrder=1);
        end s0_T;

        function s0_Tlow "Compute specific entropy, low T region"
          extends Modelica.Icons.Function;
          input IdealGases.Common.DataRecord data "Ideal gas data";
          input SI.Temperature T "Temperature";
          output SI.SpecificEntropy s "Specific entropy at temperature T";
        algorithm
          s := data.R*(data.blow[2] - 0.5*data.alow[
            1]/(T*T) - data.alow[2]/T + data.alow[3]*Math.log(T) + T*(
            data.alow[4] + T*(0.5*data.alow[5] + T*(1/3*data.alow[6] + 0.25*data.alow[
            7]*T))));
          annotation (InlineNoEvent=false,smoothOrder=1);
        end s0_Tlow;

        function dynamicViscosityLowPressure
          "Dynamic viscosity of low pressure gases"
          extends Modelica.Icons.Function;
          input SI.Temp_K T "Gas temperature";
          input SI.Temp_K Tc "Critical temperature of gas";
          input SI.MolarMass M "Molar mass of gas";
          input SI.MolarVolume Vc "Critical molar volume of gas";
          input Real w "Acentric factor of gas";
          input DipoleMoment mu "Dipole moment of gas molecule";
          input Real k =  0.0 "Special correction for highly polar substances";
          output SI.DynamicViscosity eta "Dynamic viscosity of gas";
        protected
          parameter Real Const1_SI=40.785*10^(-9.5)
            "Constant in formula for eta converted to SI units";
          parameter Real Const2_SI=131.3/1000.0
            "Constant in formula for mur converted to SI units";
          Real mur=Const2_SI*mu/sqrt(Vc*Tc)
            "Dimensionless dipole moment of gas molecule";
          Real Fc=1 - 0.2756*w + 0.059035*mur^4 + k
            "Factor to account for molecular shape and polarities of gas";
          Real Tstar "Dimensionless temperature defined by equation below";
          Real Ov "Viscosity collision integral for the gas";

        algorithm
          Tstar := 1.2593*T/Tc;
          Ov := 1.16145*Tstar^(-0.14874) + 0.52487*exp(-0.7732*Tstar) + 2.16178*exp(-2.43787
            *Tstar);
          eta := Const1_SI*Fc*sqrt(M*T)/(Vc^(2/3)*Ov);
          annotation (smoothOrder=2,
                      Documentation(info="<html>
<p>
The used formula are based on the method of Chung et al (1984, 1988) referred to in ref [1] chapter 9.
The formula 9-4.10 is the one being used. The Formula is given in non-SI units, the follwong onversion constants were used to
transform the formula to SI units:
</p>

<ul>
<li> <b>Const1_SI:</b> The factor 10^(-9.5) =10^(-2.5)*1e-7 where the
     factor 10^(-2.5) originates from the conversion of g/mol->kg/mol + cm^3/mol->m^3/mol
      and the factor 1e-7 is due to conversionfrom microPoise->Pa.s.</li>
<li>  <b>Const2_SI:</b> The factor 1/3.335641e-27 = 1e-3/3.335641e-30
      where the factor 3.335641e-30 comes from debye->C.m and
      1e-3 is due to conversion from cm^3/mol->m^3/mol</li>
</ul>

<h4>References:</h4>
<p>
[1] Bruce E. Poling, John E. Prausnitz, John P. O'Connell, \"The Properties of Gases and Liquids\" 5th Ed. Mc Graw Hill.
</p>

<h4>Author</h4>
<p>T. Skoglund, Lund, Sweden, 2004-08-31</p>

</html>"));
        end dynamicViscosityLowPressure;

        redeclare replaceable function extends dynamicViscosity
          "dynamic viscosity"
        algorithm
          assert(fluidConstants[1].hasCriticalData,
          "Failed to compute dynamicViscosity: For the species \"" + mediumName + "\" no critical data is available.");
          assert(fluidConstants[1].hasDipoleMoment,
          "Failed to compute dynamicViscosity: For the species \"" + mediumName + "\" no critical data is available.");
          eta := dynamicViscosityLowPressure(state.T,
                             fluidConstants[1].criticalTemperature,
                             fluidConstants[1].molarMass,
                             fluidConstants[1].criticalMolarVolume,
                             fluidConstants[1].acentricFactor,
                             fluidConstants[1].dipoleMoment);
          annotation (smoothOrder=2);
        end dynamicViscosity;

        function thermalConductivityEstimate
          "Thermal conductivity of polyatomic gases(Eucken and Modified Eucken correlation)"
          extends Modelica.Icons.Function;
          input SpecificHeatCapacity Cp "Constant pressure heat capacity";
          input DynamicViscosity eta "Dynamic viscosity";
          input Integer method(min=1,max=2)=1
            "1: Eucken Method, 2: Modified Eucken Method";
          output ThermalConductivity lambda "Thermal conductivity [W/(m.k)]";
        algorithm
          lambda := if method == 1 then eta*(Cp - data.R + (9/4)*data.R) else eta*(Cp
             - data.R)*(1.32 + 1.77/((Cp/Modelica.Constants.R) - 1.0));
          annotation (smoothOrder=2,
                      Documentation(info="<html>
<p>
This function provides two similar methods for estimating the
thermal conductivity of polyatomic gases.
The Eucken method (input method == 1) gives good results for low temperatures,
but it tends to give an underestimated value of the thermal conductivity
(lambda) at higher temperatures.<br>
The Modified Eucken method (input method == 2) gives good results for
high-temperatures, but it tends to give an overestimated value of the
thermal conductivity (lambda) at low temperatures.
</p>
</html>"));
        end thermalConductivityEstimate;

        redeclare replaceable function extends thermalConductivity
          "thermal conductivity of gas"
          input Integer method=1 "1: Eucken Method, 2: Modified Eucken Method";
        algorithm
          assert(fluidConstants[1].hasCriticalData,
          "Failed to compute thermalConductivity: For the species \"" + mediumName + "\" no critical data is available.");
          lambda := thermalConductivityEstimate(specificHeatCapacityCp(state),
            dynamicViscosity(state), method=method);
          annotation (smoothOrder=2);
        end thermalConductivity;

        redeclare function extends molarMass
          "return the molar mass of the medium"
        algorithm
          MM := data.MM;
        end molarMass;

        function T_h "Compute temperature from specific enthalpy"
          input SpecificEnthalpy h "Specific enthalpy";
          output Temperature T "Temperature";

        protected
        package Internal
            "Solve h(data,T) for T with given h (use only indirectly via temperature_phX)"
          extends Modelica.Media.Common.OneNonLinearEquation;
          redeclare record extends f_nonlinear_Data
              "Data to be passed to non-linear function"
            extends Modelica.Media.IdealGases.Common.DataRecord;
          end f_nonlinear_Data;

          redeclare function extends f_nonlinear
          algorithm
              y := h_T(f_nonlinear_data,x);
          end f_nonlinear;

          // Dummy definition has to be added for current Dymola
          redeclare function extends solve
          end solve;
        end Internal;

        algorithm
          T := Internal.solve(h, 200, 6000, 1.0e5, {1}, data);
        end T_h;

        function T_ps "Compute temperature from pressure and specific entropy"
          input AbsolutePressure p "Pressure";
          input SpecificEntropy s "Specific entropy";
          output Temperature T "Temperature";

        protected
        package Internal
            "Solve h(data,T) for T with given h (use only indirectly via temperature_phX)"
          extends Modelica.Media.Common.OneNonLinearEquation;
          redeclare record extends f_nonlinear_Data
              "Data to be passed to non-linear function"
            extends Modelica.Media.IdealGases.Common.DataRecord;
          end f_nonlinear_Data;

          redeclare function extends f_nonlinear
          algorithm
              y := s0_T(f_nonlinear_data,x)- data.R*Modelica.Math.log(p/reference_p);
          end f_nonlinear;

          // Dummy definition has to be added for current Dymola
          redeclare function extends solve
          end solve;
        end Internal;

        algorithm
          T := Internal.solve(s, 200, 6000, p, {1}, data);
        end T_ps;

        annotation (
          Documentation(info="<HTML>
<p>
This model calculates medium properties
for an ideal gas of a single substance, or for an ideal
gas consisting of several substances where the
mass fractions are fixed. Independent variables
are temperature <b>T</b> and pressure <b>p</b>.
Only density is a function of T and p. All other quantities
are solely a function of T. The properties
are valid in the range:
</p>
<pre>
   200 K &le; T &le; 6000 K
</pre>
<p>
The following quantities are always computed:
</p>
<table border=1 cellspacing=0 cellpadding=2>
  <tr><td valign=\"top\"><b>Variable</b></td>
      <td valign=\"top\"><b>Unit</b></td>
      <td valign=\"top\"><b>Description</b></td></tr>
  <tr><td valign=\"top\">h</td>
      <td valign=\"top\">J/kg</td>
      <td valign=\"top\">specific enthalpy h = h(T)</td></tr>
  <tr><td valign=\"top\">u</td>
      <td valign=\"top\">J/kg</td>
      <td valign=\"top\">specific internal energy u = u(T)</b></td></tr>
  <tr><td valign=\"top\">d</td>
      <td valign=\"top\">kg/m^3</td>
      <td valign=\"top\">density d = d(p,T)</td></tr>
</table>
<p>
For the other variables, see the functions in
Modelica.Media.IdealGases.Common.SingleGasNasa.
Note, dynamic viscosity and thermal conductivity are only provided
for gases that use a data record from Modelica.Media.IdealGases.FluidData.
Currently these are the following gases:
</p>
<pre>
  Ar
  C2H2_vinylidene
  C2H4
  C2H5OH
  C2H6
  C3H6_propylene
  C3H7OH
  C3H8
  C4H8_1_butene
  C4H9OH
  C4H10_n_butane
  C5H10_1_pentene
  C5H12_n_pentane
  C6H6
  C6H12_1_hexene
  C6H14_n_heptane
  C7H14_1_heptene
  C8H10_ethylbenz
  CH3OH
  CH4
  CL2
  CO
  CO2
  F2
  H2
  H2O
  He
  N2
  N2O
  NH3
  NO
  O2
  SO2
  SO3
</pre>
<p>
<b>Sources for model and literature:</b><br>
Original Data: Computer program for calculation of complex chemical
equilibrium compositions and applications. Part 1: Analysis
Document ID: 19950013764 N (95N20180) File Series: NASA Technical Reports
Report Number: NASA-RP-1311  E-8017  NAS 1.61:1311
Authors: Gordon, Sanford (NASA Lewis Research Center)
 Mcbride, Bonnie J. (NASA Lewis Research Center)
Published: Oct 01, 1994.
</p>
<p><b>Known limits of validity:</b></br>
The data is valid for
temperatures between 200 K and 6000 K.  A few of the data sets for
monatomic gases have a discontinuous 1st derivative at 1000 K, but
this never caused problems so far.
</p>
<p>
This model has been copied from the ThermoFluid library
and adapted to the Modelica.Media package.
</p>
</HTML>"),Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
                  100}}),
               graphics),
          Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
                  100}}),
                      graphics));
      end SingleGasNasa;

        package FluidData "Critical data, dipole moments and related data"
          extends Modelica.Icons.Package;
          import Modelica.Media.Interfaces.PartialMedium;
          import Modelica.Media.IdealGases.Common.SingleGasesData;

          constant SingleGasNasa.FluidConstants N2(
                               chemicalFormula =        "N2",
                               iupacName =              "unknown",
                               structureFormula =       "unknown",
                               casRegistryNumber =      "7727-37-9",
                               meltingPoint =            63.15,
                               normalBoilingPoint =      77.35,
                               criticalTemperature =    126.20,
                               criticalPressure =        33.98e5,
                               criticalMolarVolume =     90.10e-6,
                               acentricFactor =           0.037,
                               dipoleMoment =             0.0,
                               molarMass =              SingleGasesData.N2.MM,
                               hasDipoleMoment =       true,
                               hasIdealGasHeatCapacity=true,
                               hasCriticalData =       true,
                               hasAcentricFactor =     true);

          constant SingleGasNasa.FluidConstants H2O(
                               chemicalFormula =        "H2O",
                               iupacName =              "unknown",
                               structureFormula =       "unknown",
                               casRegistryNumber =      "7732-18-5",
                               meltingPoint =           273.15,
                               normalBoilingPoint =     373.15,
                               criticalTemperature =    647.14,
                               criticalPressure =       220.64e5,
                               criticalMolarVolume =     55.95e-6,
                               acentricFactor =           0.344,
                               dipoleMoment =             1.8,
                               molarMass =              SingleGasesData.H2O.MM,
                               hasDipoleMoment =       true,
                               hasIdealGasHeatCapacity=true,
                               hasCriticalData =       true,
                               hasAcentricFactor =     true);
          annotation (Documentation(info="<html>
<p>
This package contains FluidConstants data records for the following 37 gases
(see also the description in
<a href=\"modelica://Modelica.Media.IdealGases\">Modelica.Media.IdealGases</a>):
</p>
<pre>
Argon             Methane          Methanol       Carbon Monoxide  Carbon Dioxide
Acetylene         Ethylene         Ethanol        Ethane           Propylene
Propane           1-Propanol       1-Butene       N-Butane         1-Pentene
N-Pentane         Benzene          1-Hexene       N-Hexane         1-Heptane
N-Heptane         Ethylbenzene     N-Octane       Chlorine         Fluorine
Hydrogen          Steam            Helium         Ammonia          Nitric Oxide
Nitrogen Dioxide  Nitrogen         Nitrous        Oxide            Neon Oxygen
Sulfur Dioxide    Sulfur Trioxide
</pre>

</html>"));
        end FluidData;

        package SingleGasesData
        "Ideal gas data based on the NASA Glenn coefficients"
          extends Modelica.Icons.Package;

          constant IdealGases.Common.DataRecord Air(
            name="Air",
            MM=0.0289651159,
            Hf=-4333.833858403446,
            H0=298609.6803431054,
            Tlimit=1000,
            alow={10099.5016,-196.827561,5.00915511,-0.00576101373,1.06685993e-005,-7.94029797e-009,
                2.18523191e-012},
            blow={-176.796731,-3.921504225},
            ahigh={241521.443,-1257.8746,5.14455867,-0.000213854179,7.06522784e-008,-1.07148349e-011,
                6.57780015e-016},
            bhigh={6462.26319,-8.147411905},
            R=287.0512249529787);

          constant IdealGases.Common.DataRecord H2O(
            name="H2O",
            MM=0.01801528,
            Hf=-13423382.81725291,
            H0=549760.6476280135,
            Tlimit=1000,
            alow={-39479.6083,575.573102,0.931782653,0.00722271286,-7.34255737e-006,
                4.95504349e-009,-1.336933246e-012},
            blow={-33039.7431,17.24205775},
            ahigh={1034972.096,-2412.698562,4.64611078,0.002291998307,-6.836830479999999e-007,
                9.426468930000001e-011,-4.82238053e-015},
            bhigh={-13842.86509,-7.97814851},
            R=461.5233290850878);

          constant IdealGases.Common.DataRecord N2(
            name="N2",
            MM=0.0280134,
            Hf=0,
            H0=309498.4543111511,
            Tlimit=1000,
            alow={22103.71497,-381.846182,6.08273836,-0.00853091441,1.384646189e-005,-9.62579362e-009,
                2.519705809e-012},
            blow={710.846086,-10.76003744},
            ahigh={587712.406,-2239.249073,6.06694922,-0.00061396855,1.491806679e-007,-1.923105485e-011,
                1.061954386e-015},
            bhigh={12832.10415,-15.86640027},
            R=296.8033869505308);
          annotation ( Documentation(info="<HTML>
<p>This package contains ideal gas models for the 1241 ideal gases from</p>
<blockquote>
  <p>McBride B.J., Zehe M.J., and Gordon S. (2002): <b>NASA Glenn Coefficients
  for Calculating Thermodynamic Properties of Individual Species</b>. NASA
  report TP-2002-211556</p>
</blockquote>

<pre>
 Ag        BaOH+           C2H4O_ethylen_o DF      In2I4    Nb      ScO2
 Ag+       Ba_OH_2         CH3CHO_ethanal  DOCl    In2I6    Nb+     Sc2O
 Ag-       BaS             CH3COOH         DO2     In2O     Nb-     Sc2O2
 Air       Ba2             OHCH2COOH       DO2-    K        NbCl5   Si
 Al        Be              C2H5            D2      K+       NbO     Si+
 Al+       Be+             C2H5Br          D2+     K-       NbOCl3  Si-
 Al-       Be++            C2H6            D2-     KAlF4    NbO2    SiBr
 AlBr      BeBr            CH3N2CH3        D2O     KBO2     Ne      SiBr2
 AlBr2     BeBr2           C2H5OH          D2O2    KBr      Ne+     SiBr3
 AlBr3     BeCl            CH3OCH3         D2S     KCN      Ni      SiBr4
 AlC       BeCl2           CH3O2CH3        e-      KCl      Ni+     SiC
 AlC2      BeF             CCN             F       KF       Ni-     SiC2
 AlCl      BeF2            CNC             F+      KH       NiCl    SiCl
 AlCl+     BeH             OCCN            F-      KI       NiCl2   SiCl2
 AlCl2     BeH+            C2N2            FCN     Kli      NiO     SiCl3
 AlCl3     BeH2            C2O             FCO     KNO2     NiS     SiCl4
 AlF       BeI             C3              FO      KNO3     O       SiF
 AlF+      BeI2            C3H3_1_propynl  FO2_FOO KNa      O+      SiFCl
 AlFCl     BeN             C3H3_2_propynl  FO2_OFO KO       O-      SiF2
 AlFCl2    BeO             C3H4_allene     F2      KOH      OD      SiF3
 AlF2      BeOH            C3H4_propyne    F2O     K2       OD-     SiF4
 AlF2-     BeOH+           C3H4_cyclo      F2O2    K2+      OH      SiH
 AlF2Cl    Be_OH_2         C3H5_allyl      FS2F    K2Br2    OH+     SiH+
 AlF3      BeS             C3H6_propylene  Fe      K2CO3    OH-     SiHBr3
 AlF4-     Be2             C3H6_cyclo      Fe+     K2C2N2   O2      SiHCl
 AlH       Be2Cl4          C3H6O_propylox  Fe_CO_5 K2Cl2    O2+     SiHCl3
 AlHCl     Be2F4           C3H6O_acetone   FeCl    K2F2     O2-     SiHF
 AlHCl2    Be2O            C3H6O_propanal  FeCl2   K2I2     O3      SiHF3
 AlHF      Be2OF2          C3H7_n_propyl   FeCl3   K2O      P       SiHI3
 AlHFCl    Be2O2           C3H7_i_propyl   FeO     K2O+     P+      SiH2
 AlHF2     Be3O3           C3H8            Fe_OH_2 K2O2     P-      SiH2Br2
 AlH2      Be4O4           C3H8O_1propanol Fe2Cl4  K2O2H2   PCl     SiH2Cl2
 AlH2Cl    Br              C3H8O_2propanol Fe2Cl6  K2SO4    PCl2    SiH2F2
 AlH2F     Br+             CNCOCN          Ga      Kr       PCl2-   SiH2I2
 AlH3      Br-             C3O2            Ga+     Kr+      PCl3    SiH3
 AlI       BrCl            C4              GaBr    li       PCl5    SiH3Br
 AlI2      BrF             C4H2_butadiyne  GaBr2   li+      PF      SiH3Cl
 AlI3      BrF3            C4H4_1_3-cyclo  GaBr3   li-      PF+     SiH3F
 AlN       BrF5            C4H6_butadiene  GaCl    liAlF4   PF-     SiH3I
 AlO       BrO             C4H6_1butyne    GaCl2   liBO2    PFCl    SiH4
 AlO+      OBrO            C4H6_2butyne    GaCl3   liBr     PFCl-   SiI
 AlO-      BrOO            C4H6_cyclo      GaF     liCl     PFCl2   SiI2
 AlOCl     BrO3            C4H8_1_butene   GaF2    liF      PFCl4   SiN
 AlOCl2    Br2             C4H8_cis2_buten GaF3    liH      PF2     SiO
 AlOF      BrBrO           C4H8_isobutene  GaH     liI      PF2-    SiO2
 AlOF2     BrOBr           C4H8_cyclo      GaI     liN      PF2Cl   SiS
 AlOF2-    C               C4H9_n_butyl    GaI2    liNO2    PF2Cl3  SiS2
 AlOH      C+              C4H9_i_butyl    GaI3    liNO3    PF3     Si2
 AlOHCl    C-              C4H9_s_butyl    GaO     liO      PF3Cl2  Si2C
 AlOHCl2   CBr             C4H9_t_butyl    GaOH    liOF     PF4Cl   Si2F6
 AlOHF     CBr2            C4H10_n_butane  Ga2Br2  liOH     PF5     Si2N
 AlOHF2    CBr3            C4H10_isobutane Ga2Br4  liON     PH      Si3
 AlO2      CBr4            C4N2            Ga2Br6  li2      PH2     Sn
 AlO2-     CCl             C5              Ga2Cl2  li2+     PH2-    Sn+
 Al_OH_2   CCl2            C5H6_1_3cyclo   Ga2Cl4  li2Br2   PH3     Sn-
 Al_OH_2Cl CCl2Br2         C5H8_cyclo      Ga2Cl6  li2F2    PN      SnBr
 Al_OH_2F  CCl3            C5H10_1_pentene Ga2F2   li2I2    PO      SnBr2
 Al_OH_3   CCl3Br          C5H10_cyclo     Ga2F4   li2O     PO-     SnBr3
 AlS       CCl4            C5H11_pentyl    Ga2F6   li2O+    POCl3   SnBr4
 AlS2      CF              C5H11_t_pentyl  Ga2I2   li2O2    POFCl2  SnCl
 Al2       CF+             C5H12_n_pentane Ga2I4   li2O2H2  POF2Cl  SnCl2
 Al2Br6    CFBr3           C5H12_i_pentane Ga2I6   li2SO4   POF3    SnCl3
 Al2C2     CFCl            CH3C_CH3_2CH3   Ga2O    li3+     PO2     SnCl4
 Al2Cl6    CFClBr2         C6D5_phenyl     Ge      li3Br3   PO2-    SnF
 Al2F6     CFCl2           C6D6            Ge+     li3Cl3   PS      SnF2
 Al2I6     CFCl2Br         C6H2            Ge-     li3F3    P2      SnF3
 Al2O      CFCl3           C6H5_phenyl     GeBr    li3I3    P2O3    SnF4
 Al2O+     CF2             C6H5O_phenoxy   GeBr2   Mg       P2O4    SnI
 Al2O2     CF2+            C6H6            GeBr3   Mg+      P2O5    SnI2
 Al2O2+    CF2Br2          C6H5OH_phenol   GeBr4   MgBr     P3      SnI3
 Al2O3     CF2Cl           C6H10_cyclo     GeCl    MgBr2    P3O6    SnI4
 Al2S      CF2ClBr         C6H12_1_hexene  GeCl2   MgCl     P4      SnO
 Al2S2     CF2Cl2          C6H12_cyclo     GeCl3   MgCl+    P4O6    SnO2
 Ar        CF3             C6H13_n_hexyl   GeCl4   MgCl2    P4O7    SnS
 Ar+       CF3+            C6H14_n_hexane  GeF     MgF      P4O8    SnS2
 B         CF3Br           C7H7_benzyl     GeF2    MgF+     P4O9    Sn2
 B+        CF3Cl           C7H8            GeF3    MgF2     P4O10   Sr
 B-        CF4             C7H8O_cresol_mx GeF4    MgF2+    Pb      Sr+
 BBr       CH+             C7H14_1_heptene GeH4    MgH      Pb+     SrBr
 BBr2      CHBr3           C7H15_n_heptyl  GeI     MgI      Pb-     SrBr2
 BBr3      CHCl            C7H16_n_heptane GeO     MgI2     PbBr    SrCl
 BC        CHClBr2         C7H16_2_methylh GeO2    MgN      PbBr2   SrCl+
 BC2       CHCl2           C8H8_styrene    GeS     MgO      PbBr3   SrCl2
 BCl       CHCl2Br         C8H10_ethylbenz GeS2    MgOH     PbBr4   SrF
 BCl+      CHCl3           C8H16_1_octene  Ge2     MgOH+    PbCl    SrF+
 BClOH     CHF             C8H17_n_octyl   H       Mg_OH_2  PbCl2   SrF2
 BCl_OH_2  CHFBr2          C8H18_n_octane  H+      MgS      PbCl3   SrH
 BCl2      CHFCl           C8H18_isooctane H-      Mg2      PbCl4   SrI
 BCl2+     CHFClBr         C9H19_n_nonyl   HAlO    Mg2F4    PbF     SrI2
 BCl2OH    CHFCl2          C10H8_naphthale HAlO2   Mn       PbF2    SrO
 BF        CHF2            C10H21_n_decyl  HBO     Mn+      PbF3    SrOH
 BFCl      CHF2Br          C12H9_o_bipheny HBO+    Mo       PbF4    SrOH+
 BFCl2     CHF2Cl          C12H10_biphenyl HBO2    Mo+      PbI     Sr_OH_2
 BFOH      CHF3            Ca              HBS     Mo-      PbI2    SrS
 BF_OH_2   CHI3            Ca+             HBS+    MoO      PbI3    Sr2
 BF2       CH2             CaBr            HCN     MoO2     PbI4    Ta
 BF2+      CH2Br2          CaBr2           HCO     MoO3     PbO     Ta+
 BF2-      CH2Cl           CaCl            HCO+    MoO3-    PbO2    Ta-
 BF2Cl     CH2ClBr         CaCl+           HCCN    Mo2O6    PbS     TaCl5
 BF2OH     CH2Cl2          CaCl2           HCCO    Mo3O9    PbS2    TaO
 BF3       CH2F            CaF             HCl     Mo4O12   Rb      TaO2
 BF4-      CH2FBr          CaF+            HD      Mo5O15   Rb+     Ti
 BH        CH2FCl          CaF2            HD+     N        Rb-     Ti+
 BHCl      CH2F2           CaH             HDO     N+       RbBO2   Ti-
 BHCl2     CH2I2           CaI             HDO2    N-       RbBr    TiCl
 BHF       CH3             CaI2            HF      NCO      RbCl    TiCl2
 BHFCl     CH3Br           CaO             HI      ND       RbF     TiCl3
 BHF2      CH3Cl           CaO+            HNC     ND2      RbH     TiCl4
 BH2       CH3F            CaOH            HNCO    ND3      RbI     TiO
 BH2Cl     CH3I            CaOH+           HNO     NF       RbK     TiO+
 BH2F      CH2OH           Ca_OH_2         HNO2    NF2      Rbli    TiOCl
 BH3       CH2OH+          CaS             HNO3    NF3      RbNO2   TiOCl2
 BH3NH3    CH3O            Ca2             HOCl    NH       RbNO3   TiO2
 BH4       CH4             Cd              HOF     NH+      RbNa    U
 BI        CH3OH           Cd+             HO2     NHF      RbO     UF
 BI2       CH3OOH          Cl              HO2-    NHF2     RbOH    UF+
 BI3       CI              Cl+             HPO     NH2      Rb2Br2  UF-
 BN        CI2             Cl-             HSO3F   NH2F     Rb2Cl2  UF2
 BO        CI3             ClCN            H2      NH3      Rb2F2   UF2+
 BO-       CI4             ClF             H2+     NH2OH    Rb2I2   UF2-
 BOCl      CN              ClF3            H2-     NH4+     Rb2O    UF3
 BOCl2     CN+             ClF5            HBOH    NO       Rb2O2   UF3+
 BOF       CN-             ClO             HCOOH   NOCl     Rb2O2H2 UF3-
 BOF2      CNN             ClO2            H2F2    NOF      Rb2SO4  UF4
 BOH       CO              Cl2             H2O     NOF3     Rn      UF4+
 BO2       CO+             Cl2O            H2O+    NO2      Rn+     UF4-
 BO2-      COCl            Co              H2O2    NO2-     S       UF5
 B_OH_2    COCl2           Co+             H2S     NO2Cl    S+      UF5+
 BS        COFCl           Co-             H2SO4   NO2F     S-      UF5-
 BS2       COF2            Cr              H2BOH   NO3      SCl     UF6
 B2        COHCl           Cr+             HB_OH_2 NO3-     SCl2    UF6-
 B2C       COHF            Cr-             H3BO3   NO3F     SCl2+   UO
 B2Cl4     COS             CrN             H3B3O3  N2       SD      UO+
 B2F4      CO2             CrO             H3B3O6  N2+      SF      UOF
 B2H       CO2+            CrO2            H3F3    N2-      SF+     UOF2
 B2H2      COOH            CrO3            H3O+    NCN      SF-     UOF3
 B2H3      CP              CrO3-           H4F4    N2D2_cis SF2     UOF4
 B2H3_db   CS              Cs              H5F5    N2F2     SF2+    UO2
 B2H4      CS2             Cs+             H6F6    N2F4     SF2-    UO2+
 B2H4_db   C2              Cs-             H7F7    N2H2     SF3     UO2-
 B2H5      C2+             CsBO2           He      NH2NO2   SF3+    UO2F
 B2H5_db   C2-             CsBr            He+     N2H4     SF3-    UO2F2
 B2H6      C2Cl            CsCl            Hg      N2O      SF4     UO3
 B2O       C2Cl2           CsF             Hg+     N2O+     SF4+    UO3-
 B2O2      C2Cl3           CsH             HgBr2   N2O3     SF4-    V
 B2O3      C2Cl4           CsI             I       N2O4     SF5     V+
 B2_OH_4   C2Cl6           Csli            I+      N2O5     SF5+    V-
 B2S       C2F             CsNO2           I-      N3       SF5-    VCl4
 B2S2      C2FCl           CsNO3           IF5     N3H      SF6     VN
 B2S3      C2FCl3          CsNa            IF7     Na       SF6-    VO
 B3H7_C2v  C2F2            CsO             I2      Na+      SH      VO2
 B3H7_Cs   C2F2Cl2         CsOH            In      Na-      SH-     V4O10
 B3H9      C2F3            CsRb            In+     NaAlF4   SN      W
 B3N3H6    C2F3Cl          Cs2             InBr    NaBO2    SO      W+
 B3O3Cl3   C2F4            Cs2Br2          InBr2   NaBr     SO-     W-
 B3O3FCl2  C2F6            Cs2CO3          InBr3   NaCN     SOF2    WCl6
 B3O3F2Cl  C2H             Cs2Cl2          InCl    NaCl     SO2     WO
 B3O3F3    C2HCl           Cs2F2           InCl2   NaF      SO2-    WOCl4
 B4H4      C2HCl3          Cs2I2           InCl3   NaH      SO2Cl2  WO2
 B4H10     C2HF            Cs2O            InF     NaI      SO2FCl  WO2Cl2
 B4H12     C2HFCl2         Cs2O+           InF2    Nali     SO2F2   WO3
 B5H9      C2HF2Cl         Cs2O2           InF3    NaNO2    SO3     WO3-
 Ba        C2HF3           Cs2O2H2         InH     NaNO3    S2      Xe
 Ba+       C2H2_vinylidene Cs2SO4          InI     NaO      S2-     Xe+
 BaBr      C2H2Cl2         Cu              InI2    NaOH     S2Cl2   Zn
 BaBr2     C2H2FCl         Cu+             InI3    NaOH+    S2F2    Zn+
 BaCl      C2H2F2          Cu-             InO     Na2      S2O     Zr
 BaCl+     CH2CO_ketene    CuCl            InOH    Na2Br2   S3      Zr+
 BaCl2     O_CH_2O         CuF             In2Br2  Na2Cl2   S4      Zr-
 BaF       HO_CO_2OH       CuF2            In2Br4  Na2F2    S5      ZrN
 BaF+      C2H3_vinyl      CuO             In2Br6  Na2I2    S6      ZrO
 BaF2      CH2Br-COOH      Cu2             In2Cl2  Na2O     S7      ZrO+
 BaH       C2H3Cl          Cu3Cl3          In2Cl4  Na2O+    S8      ZrO2
 BaI       CH2Cl-COOH      D               In2Cl6  Na2O2    Sc
 BaI2      C2H3F           D+              In2F2   Na2O2H2  Sc+
 BaO       CH3CN           D-              In2F4   Na2SO4   Sc-
 BaO+      CH3CO_acetyl    DBr             In2F6   Na3Cl3   ScO
 BaOH      C2H4            DCl             In2I2   Na3F3    ScO+
</pre>

</HTML>"));
        end SingleGasesData;
      annotation (Documentation(info="<html>

</html>"));
      end Common;
    annotation (
      __Dymola_classOrder={"Common", "SingleGases", "MixtureGases"},
    Documentation(info="<HTML>
<p>This package contains data for the 1241 ideal gases from</p>
<blockquote>
  <p>McBride B.J., Zehe M.J., and Gordon S. (2002): <b>NASA Glenn Coefficients
  for Calculating Thermodynamic Properties of Individual Species</b>. NASA
  report TP-2002-211556</p>
</blockquote>
<p>Medium models for some of these gases are available in package
<a href=\"modelica://Modelica.Media.IdealGases.SingleGases\">IdealGases.SingleGases</a>
and some examples for mixtures are available in package <a href=\"modelica://Modelica.Media.IdealGases.MixtureGases\">IdealGases.MixtureGases</a>
</p>
<h4>Using and Adapting Medium Models</h4>
<p>
The data records allow computing the ideal gas specific enthalpy, specific entropy and heat capacity of the substances listed below. From them, even the Gibbs energy and equilibrium constants for reactions can be computed. Critical data that is needed for computing the viscosity and thermal conductivity is not included. In order to add mixtures or single substance medium packages that are
subtypes of
<a href=\"modelica://Modelica.Media.Interfaces.PartialMedium\">Interfaces.PartialMedium</a>
(i.e., can be utilized at all places where PartialMedium is defined),
a few additional steps have to be performed:
<ol>
<li>
All single gas media need to define a constant instance of record
<a href=\"modelica://Modelica.Media.IdealGases.Common.SingleGasNasa.FluidConstants\">IdealGases.Common.SingleGasNasa.FluidConstants</a>.
For 37 ideal gases such records are provided in package
<a href=\"modelica://Modelica.Media.IdealGases.Common.FluidData\">IdealGases.Common.FluidData</a>.
For the other gases, such a record instance has to be provided by the user, e.g., by getting
the data from a commercial or public data base. A public source of the needed data is for example the <a href=\"http://webbook.nist.gov/chemistry/\"> NIST Chemistry WebBook</a></li>

<li>When the data is available, and a user has an instance of a
<a href=\"modelica://Modelica.Media.IdealGases.Common.SingleGasNasa.FluidConstants\">FluidConstants</a> record filled with data, a medium package has to be written. Note that only the dipole moment, the accentric factor and critical data are necessary for the viscosity and thermal conductivity functions.</li>
<ul>
<li>For single components, a new package following the pattern in
<a href=\"modelica://Modelica.Media.IdealGases.SingleGases\">IdealGases.SingleGases</a> has to be created, pointing both to a data record for cp and to a user-defined fluidContants record.</li>
<li>For mixtures of several components, a new package following the pattern in
<a href=\"modelica://Modelica.Media.IdealGases.MixtureGases\">IdealGases.MixtureGases</a> has to be created, building an array of data records for cp and an array of (partly) user-defined fluidContants records.</li>
</ul>
</ol>
<p>Note that many properties can computed for the full set of 1241 gases listed below, but due to the missing viscosity and thermal conductivity functions, no fully Modelica.Media-compliant media can be defined.</p>
</p>
<p>
Data records for heat capacity, specific enthalpy and specific entropy exist for the following substances and ions:
</p>
<pre>
 Ag        BaOH+           C2H4O_ethylen_o DF      In2I4    Nb      ScO2
 Ag+       Ba_OH_2         CH3CHO_ethanal  DOCl    In2I6    Nb+     Sc2O
 Ag-       BaS             CH3COOH         DO2     In2O     Nb-     Sc2O2
 Air       Ba2             OHCH2COOH       DO2-    K        NbCl5   Si
 Al        Be              C2H5            D2      K+       NbO     Si+
 Al+       Be+             C2H5Br          D2+     K-       NbOCl3  Si-
 Al-       Be++            C2H6            D2-     KAlF4    NbO2    SiBr
 AlBr      BeBr            CH3N2CH3        D2O     KBO2     Ne      SiBr2
 AlBr2     BeBr2           C2H5OH          D2O2    KBr      Ne+     SiBr3
 AlBr3     BeCl            CH3OCH3         D2S     KCN      Ni      SiBr4
 AlC       BeCl2           CH3O2CH3        e-      KCl      Ni+     SiC
 AlC2      BeF             CCN             F       KF       Ni-     SiC2
 AlCl      BeF2            CNC             F+      KH       NiCl    SiCl
 AlCl+     BeH             OCCN            F-      KI       NiCl2   SiCl2
 AlCl2     BeH+            C2N2            FCN     Kli      NiO     SiCl3
 AlCl3     BeH2            C2O             FCO     KNO2     NiS     SiCl4
 AlF       BeI             C3              FO      KNO3     O       SiF
 AlF+      BeI2            C3H3_1_propynl  FO2_FOO KNa      O+      SiFCl
 AlFCl     BeN             C3H3_2_propynl  FO2_OFO KO       O-      SiF2
 AlFCl2    BeO             C3H4_allene     F2      KOH      OD      SiF3
 AlF2      BeOH            C3H4_propyne    F2O     K2       OD-     SiF4
 AlF2-     BeOH+           C3H4_cyclo      F2O2    K2+      OH      SiH
 AlF2Cl    Be_OH_2         C3H5_allyl      FS2F    K2Br2    OH+     SiH+
 AlF3      BeS             C3H6_propylene  Fe      K2CO3    OH-     SiHBr3
 AlF4-     Be2             C3H6_cyclo      Fe+     K2C2N2   O2      SiHCl
 AlH       Be2Cl4          C3H6O_propylox  Fe_CO_5 K2Cl2    O2+     SiHCl3
 AlHCl     Be2F4           C3H6O_acetone   FeCl    K2F2     O2-     SiHF
 AlHCl2    Be2O            C3H6O_propanal  FeCl2   K2I2     O3      SiHF3
 AlHF      Be2OF2          C3H7_n_propyl   FeCl3   K2O      P       SiHI3
 AlHFCl    Be2O2           C3H7_i_propyl   FeO     K2O+     P+      SiH2
 AlHF2     Be3O3           C3H8            Fe_OH_2 K2O2     P-      SiH2Br2
 AlH2      Be4O4           C3H8O_1propanol Fe2Cl4  K2O2H2   PCl     SiH2Cl2
 AlH2Cl    Br              C3H8O_2propanol Fe2Cl6  K2SO4    PCl2    SiH2F2
 AlH2F     Br+             CNCOCN          Ga      Kr       PCl2-   SiH2I2
 AlH3      Br-             C3O2            Ga+     Kr+      PCl3    SiH3
 AlI       BrCl            C4              GaBr    li       PCl5    SiH3Br
 AlI2      BrF             C4H2_butadiyne  GaBr2   li+      PF      SiH3Cl
 AlI3      BrF3            C4H4_1_3-cyclo  GaBr3   li-      PF+     SiH3F
 AlN       BrF5            C4H6_butadiene  GaCl    liAlF4   PF-     SiH3I
 AlO       BrO             C4H6_1butyne    GaCl2   liBO2    PFCl    SiH4
 AlO+      OBrO            C4H6_2butyne    GaCl3   liBr     PFCl-   SiI
 AlO-      BrOO            C4H6_cyclo      GaF     liCl     PFCl2   SiI2
 AlOCl     BrO3            C4H8_1_butene   GaF2    liF      PFCl4   SiN
 AlOCl2    Br2             C4H8_cis2_buten GaF3    liH      PF2     SiO
 AlOF      BrBrO           C4H8_isobutene  GaH     liI      PF2-    SiO2
 AlOF2     BrOBr           C4H8_cyclo      GaI     liN      PF2Cl   SiS
 AlOF2-    C               C4H9_n_butyl    GaI2    liNO2    PF2Cl3  SiS2
 AlOH      C+              C4H9_i_butyl    GaI3    liNO3    PF3     Si2
 AlOHCl    C-              C4H9_s_butyl    GaO     liO      PF3Cl2  Si2C
 AlOHCl2   CBr             C4H9_t_butyl    GaOH    liOF     PF4Cl   Si2F6
 AlOHF     CBr2            C4H10_n_butane  Ga2Br2  liOH     PF5     Si2N
 AlOHF2    CBr3            C4H10_isobutane Ga2Br4  liON     PH      Si3
 AlO2      CBr4            C4N2            Ga2Br6  li2      PH2     Sn
 AlO2-     CCl             C5              Ga2Cl2  li2+     PH2-    Sn+
 Al_OH_2   CCl2            C5H6_1_3cyclo   Ga2Cl4  li2Br2   PH3     Sn-
 Al_OH_2Cl CCl2Br2         C5H8_cyclo      Ga2Cl6  li2F2    PN      SnBr
 Al_OH_2F  CCl3            C5H10_1_pentene Ga2F2   li2I2    PO      SnBr2
 Al_OH_3   CCl3Br          C5H10_cyclo     Ga2F4   li2O     PO-     SnBr3
 AlS       CCl4            C5H11_pentyl    Ga2F6   li2O+    POCl3   SnBr4
 AlS2      CF              C5H11_t_pentyl  Ga2I2   li2O2    POFCl2  SnCl
 Al2       CF+             C5H12_n_pentane Ga2I4   li2O2H2  POF2Cl  SnCl2
 Al2Br6    CFBr3           C5H12_i_pentane Ga2I6   li2SO4   POF3    SnCl3
 Al2C2     CFCl            CH3C_CH3_2CH3   Ga2O    li3+     PO2     SnCl4
 Al2Cl6    CFClBr2         C6D5_phenyl     Ge      li3Br3   PO2-    SnF
 Al2F6     CFCl2           C6D6            Ge+     li3Cl3   PS      SnF2
 Al2I6     CFCl2Br         C6H2            Ge-     li3F3    P2      SnF3
 Al2O      CFCl3           C6H5_phenyl     GeBr    li3I3    P2O3    SnF4
 Al2O+     CF2             C6H5O_phenoxy   GeBr2   Mg       P2O4    SnI
 Al2O2     CF2+            C6H6            GeBr3   Mg+      P2O5    SnI2
 Al2O2+    CF2Br2          C6H5OH_phenol   GeBr4   MgBr     P3      SnI3
 Al2O3     CF2Cl           C6H10_cyclo     GeCl    MgBr2    P3O6    SnI4
 Al2S      CF2ClBr         C6H12_1_hexene  GeCl2   MgCl     P4      SnO
 Al2S2     CF2Cl2          C6H12_cyclo     GeCl3   MgCl+    P4O6    SnO2
 Ar        CF3             C6H13_n_hexyl   GeCl4   MgCl2    P4O7    SnS
 Ar+       CF3+            C6H14_n_hexane  GeF     MgF      P4O8    SnS2
 B         CF3Br           C7H7_benzyl     GeF2    MgF+     P4O9    Sn2
 B+        CF3Cl           C7H8            GeF3    MgF2     P4O10   Sr
 B-        CF4             C7H8O_cresol_mx GeF4    MgF2+    Pb      Sr+
 BBr       CH+             C7H14_1_heptene GeH4    MgH      Pb+     SrBr
 BBr2      CHBr3           C7H15_n_heptyl  GeI     MgI      Pb-     SrBr2
 BBr3      CHCl            C7H16_n_heptane GeO     MgI2     PbBr    SrCl
 BC        CHClBr2         C7H16_2_methylh GeO2    MgN      PbBr2   SrCl+
 BC2       CHCl2           C8H8_styrene    GeS     MgO      PbBr3   SrCl2
 BCl       CHCl2Br         C8H10_ethylbenz GeS2    MgOH     PbBr4   SrF
 BCl+      CHCl3           C8H16_1_octene  Ge2     MgOH+    PbCl    SrF+
 BClOH     CHF             C8H17_n_octyl   H       Mg_OH_2  PbCl2   SrF2
 BCl_OH_2  CHFBr2          C8H18_n_octane  H+      MgS      PbCl3   SrH
 BCl2      CHFCl           C8H18_isooctane H-      Mg2      PbCl4   SrI
 BCl2+     CHFClBr         C9H19_n_nonyl   HAlO    Mg2F4    PbF     SrI2
 BCl2OH    CHFCl2          C10H8_naphthale HAlO2   Mn       PbF2    SrO
 BF        CHF2            C10H21_n_decyl  HBO     Mn+      PbF3    SrOH
 BFCl      CHF2Br          C12H9_o_bipheny HBO+    Mo       PbF4    SrOH+
 BFCl2     CHF2Cl          C12H10_biphenyl HBO2    Mo+      PbI     Sr_OH_2
 BFOH      CHF3            Ca              HBS     Mo-      PbI2    SrS
 BF_OH_2   CHI3            Ca+             HBS+    MoO      PbI3    Sr2
 BF2       CH2             CaBr            HCN     MoO2     PbI4    Ta
 BF2+      CH2Br2          CaBr2           HCO     MoO3     PbO     Ta+
 BF2-      CH2Cl           CaCl            HCO+    MoO3-    PbO2    Ta-
 BF2Cl     CH2ClBr         CaCl+           HCCN    Mo2O6    PbS     TaCl5
 BF2OH     CH2Cl2          CaCl2           HCCO    Mo3O9    PbS2    TaO
 BF3       CH2F            CaF             HCl     Mo4O12   Rb      TaO2
 BF4-      CH2FBr          CaF+            HD      Mo5O15   Rb+     Ti
 BH        CH2FCl          CaF2            HD+     N        Rb-     Ti+
 BHCl      CH2F2           CaH             HDO     N+       RbBO2   Ti-
 BHCl2     CH2I2           CaI             HDO2    N-       RbBr    TiCl
 BHF       CH3             CaI2            HF      NCO      RbCl    TiCl2
 BHFCl     CH3Br           CaO             HI      ND       RbF     TiCl3
 BHF2      CH3Cl           CaO+            HNC     ND2      RbH     TiCl4
 BH2       CH3F            CaOH            HNCO    ND3      RbI     TiO
 BH2Cl     CH3I            CaOH+           HNO     NF       RbK     TiO+
 BH2F      CH2OH           Ca_OH_2         HNO2    NF2      Rbli    TiOCl
 BH3       CH2OH+          CaS             HNO3    NF3      RbNO2   TiOCl2
 BH3NH3    CH3O            Ca2             HOCl    NH       RbNO3   TiO2
 BH4       CH4             Cd              HOF     NH+      RbNa    U
 BI        CH3OH           Cd+             HO2     NHF      RbO     UF
 BI2       CH3OOH          Cl              HO2-    NHF2     RbOH    UF+
 BI3       CI              Cl+             HPO     NH2      Rb2Br2  UF-
 BN        CI2             Cl-             HSO3F   NH2F     Rb2Cl2  UF2
 BO        CI3             ClCN            H2      NH3      Rb2F2   UF2+
 BO-       CI4             ClF             H2+     NH2OH    Rb2I2   UF2-
 BOCl      CN              ClF3            H2-     NH4+     Rb2O    UF3
 BOCl2     CN+             ClF5            HBOH    NO       Rb2O2   UF3+
 BOF       CN-             ClO             HCOOH   NOCl     Rb2O2H2 UF3-
 BOF2      CNN             ClO2            H2F2    NOF      Rb2SO4  UF4
 BOH       CO              Cl2             H2O     NOF3     Rn      UF4+
 BO2       CO+             Cl2O            H2O+    NO2      Rn+     UF4-
 BO2-      COCl            Co              H2O2    NO2-     S       UF5
 B_OH_2    COCl2           Co+             H2S     NO2Cl    S+      UF5+
 BS        COFCl           Co-             H2SO4   NO2F     S-      UF5-
 BS2       COF2            Cr              H2BOH   NO3      SCl     UF6
 B2        COHCl           Cr+             HB_OH_2 NO3-     SCl2    UF6-
 B2C       COHF            Cr-             H3BO3   NO3F     SCl2+   UO
 B2Cl4     COS             CrN             H3B3O3  N2       SD      UO+
 B2F4      CO2             CrO             H3B3O6  N2+      SF      UOF
 B2H       CO2+            CrO2            H3F3    N2-      SF+     UOF2
 B2H2      COOH            CrO3            H3O+    NCN      SF-     UOF3
 B2H3      CP              CrO3-           H4F4    N2D2_cis SF2     UOF4
 B2H3_db   CS              Cs              H5F5    N2F2     SF2+    UO2
 B2H4      CS2             Cs+             H6F6    N2F4     SF2-    UO2+
 B2H4_db   C2              Cs-             H7F7    N2H2     SF3     UO2-
 B2H5      C2+             CsBO2           He      NH2NO2   SF3+    UO2F
 B2H5_db   C2-             CsBr            He+     N2H4     SF3-    UO2F2
 B2H6      C2Cl            CsCl            Hg      N2O      SF4     UO3
 B2O       C2Cl2           CsF             Hg+     N2O+     SF4+    UO3-
 B2O2      C2Cl3           CsH             HgBr2   N2O3     SF4-    V
 B2O3      C2Cl4           CsI             I       N2O4     SF5     V+
 B2_OH_4   C2Cl6           Csli            I+      N2O5     SF5+    V-
 B2S       C2F             CsNO2           I-      N3       SF5-    VCl4
 B2S2      C2FCl           CsNO3           IF5     N3H      SF6     VN
 B2S3      C2FCl3          CsNa            IF7     Na       SF6-    VO
 B3H7_C2v  C2F2            CsO             I2      Na+      SH      VO2
 B3H7_Cs   C2F2Cl2         CsOH            In      Na-      SH-     V4O10
 B3H9      C2F3            CsRb            In+     NaAlF4   SN      W
 B3N3H6    C2F3Cl          Cs2             InBr    NaBO2    SO      W+
 B3O3Cl3   C2F4            Cs2Br2          InBr2   NaBr     SO-     W-
 B3O3FCl2  C2F6            Cs2CO3          InBr3   NaCN     SOF2    WCl6
 B3O3F2Cl  C2H             Cs2Cl2          InCl    NaCl     SO2     WO
 B3O3F3    C2HCl           Cs2F2           InCl2   NaF      SO2-    WOCl4
 B4H4      C2HCl3          Cs2I2           InCl3   NaH      SO2Cl2  WO2
 B4H10     C2HF            Cs2O            InF     NaI      SO2FCl  WO2Cl2
 B4H12     C2HFCl2         Cs2O+           InF2    Nali     SO2F2   WO3
 B5H9      C2HF2Cl         Cs2O2           InF3    NaNO2    SO3     WO3-
 Ba        C2HF3           Cs2O2H2         InH     NaNO3    S2      Xe
 Ba+       C2H2_vinylidene Cs2SO4          InI     NaO      S2-     Xe+
 BaBr      C2H2Cl2         Cu              InI2    NaOH     S2Cl2   Zn
 BaBr2     C2H2FCl         Cu+             InI3    NaOH+    S2F2    Zn+
 BaCl      C2H2F2          Cu-             InO     Na2      S2O     Zr
 BaCl+     CH2CO_ketene    CuCl            InOH    Na2Br2   S3      Zr+
 BaCl2     O_CH_2O         CuF             In2Br2  Na2Cl2   S4      Zr-
 BaF       HO_CO_2OH       CuF2            In2Br4  Na2F2    S5      ZrN
 BaF+      C2H3_vinyl      CuO             In2Br6  Na2I2    S6      ZrO
 BaF2      CH2Br-COOH      Cu2             In2Cl2  Na2O     S7      ZrO+
 BaH       C2H3Cl          Cu3Cl3          In2Cl4  Na2O+    S8      ZrO2
 BaI       CH2Cl-COOH      D               In2Cl6  Na2O2    Sc
 BaI2      C2H3F           D+              In2F2   Na2O2H2  Sc+
 BaO       CH3CN           D-              In2F4   Na2SO4   Sc-
 BaO+      CH3CO_acetyl    DBr             In2F6   Na3Cl3   ScO
 BaOH      C2H4            DCl             In2I2   Na3F3    ScO+
</pre></HTML>"));
    end IdealGases;

    package Incompressible
    "Medium model for T-dependent properties, defined by tables or polynomials"
      extends Modelica.Icons.MaterialPropertiesPackage;
      import SI = Modelica.SIunits;
      import Cv = Modelica.SIunits.Conversions;
      import Modelica.Constants;
      import Modelica.Math;

      package Common "Common data structures"
        extends Modelica.Icons.Package;

        record BaseProps_Tpoly "Fluid state record"
          extends Modelica.Icons.Record;
          SI.Temperature T "temperature";
          SI.Pressure p "pressure";
          //    SI.Density d "density";
        end BaseProps_Tpoly;
      end Common;

      package TableBased "Incompressible medium properties based on tables"
        import Poly = Modelica.Media.Incompressible.TableBased.Polynomials_Temp;
        extends Modelica.Media.Interfaces.PartialMedium(
           ThermoStates = if enthalpyOfT then Choices.IndependentVariables.T else Choices.IndependentVariables.pT,
           final reducedX=true,
           final fixedX = true,
           mediumName="tableMedium",
           redeclare record ThermodynamicState=Common.BaseProps_Tpoly,
           singleState=true);

        constant Boolean enthalpyOfT=true
        "true if enthalpy is approximated as a function of T only, (p-dependence neglected)";

        constant Boolean densityOfT = size(tableDensity,1) > 1
        "true if density is a function of temperature";

        constant Temperature T_min "Minimum temperature valid for medium model";

        constant Temperature T_max "Maximum temperature valid for medium model";

        constant Temperature T0=273.15 "reference Temperature";

        constant SpecificEnthalpy h0=0 "reference enthalpy at T0, reference_p";

        constant SpecificEntropy s0=0 "reference entropy at T0, reference_p";

        constant MolarMass MM_const=0.1 "Molar mass";

        constant Integer npol=2 "degree of polynomial used for fitting";

        constant Integer neta=size(tableViscosity,1)
        "number of data points for viscosity";

        constant Real[:,2] tableDensity "Table for rho(T)";

        constant Real[:,2] tableHeatCapacity "Table for Cp(T)";

        constant Real[:,2] tableViscosity "Table for eta(T)";

        constant Real[:,2] tableConductivity "Table for lambda(T)";

        constant Boolean TinK "true if T[K],Kelvin used for table temperatures";

        constant Boolean hasDensity = not (size(tableDensity,1)==0)
        "true if table tableDensity is present";

        constant Boolean hasHeatCapacity = not (size(tableHeatCapacity,1)==0)
        "true if table tableHeatCapacity is present";

        constant Boolean hasViscosity = not (size(tableViscosity,1)==0)
        "true if table tableViscosity is present";

        final constant Real invTK[neta] = if size(tableViscosity,1) > 0 then
            invertTemp(tableViscosity[:,1],TinK) else fill(0,0);

        final constant Real poly_rho[:] = if hasDensity then
                                             Poly.fitting(tableDensity[:,1],tableDensity[:,2],npol) else
                                               zeros(npol+1) annotation(__Dymola_keepConstant = true);

        final constant Real poly_Cp[:] = if hasHeatCapacity then
                                             Poly.fitting(tableHeatCapacity[:,1],tableHeatCapacity[:,2],npol) else
                                               zeros(npol+1) annotation(__Dymola_keepConstant = true);

        final constant Real poly_eta[:] = if hasViscosity then
                                             Poly.fitting(invTK, Math.log(tableViscosity[:,2]),npol) else
                                               zeros(npol+1) annotation(__Dymola_keepConstant = true);

        final constant Real poly_lam[:] = if size(tableConductivity,1)>0 then
                                             Poly.fitting(tableConductivity[:,1],tableConductivity[:,2],npol) else
                                               zeros(npol+1) annotation(__Dymola_keepConstant = true);

        function invertTemp "function to invert temperatures"
          input Real[:] table "table temperature data";
          input Boolean Tink "flag for Celsius or Kelvin";
          output Real invTable[size(table,1)] "inverted temperatures";
        algorithm
          for i in 1:size(table,1) loop
            invTable[i] := if TinK then 1/table[i] else 1/Cv.from_degC(table[i]);
          end for;
        end invertTemp;

        redeclare model extends BaseProperties(
          final standardOrderComponents=true,
          p_bar=Cv.to_bar(p),
          T_degC(start = T_start-273.15)=Cv.to_degC(T),
          T(start = T_start,
            stateSelect=if preferredMediumStates then StateSelect.prefer else StateSelect.default))
        "Base properties of T dependent medium"
        //  redeclare parameter SpecificHeatCapacity R=Modelica.Constants.R,

          SI.SpecificHeatCapacity cp "specific heat capacity";
          parameter SI.Temperature T_start = 298.15 "initial temperature";
        equation
          assert(hasDensity,"Medium " + mediumName +
                            " can not be used without assigning tableDensity.");
          assert(T >= T_min and T <= T_max, "Temperature T (= " + String(T) +
                 " K) is not in the allowed range (" + String(T_min) +
                 " K <= T <= " + String(T_max) + " K) required from medium model \""
                 + mediumName + "\".");
          R = Modelica.Constants.R;
          cp = Poly.evaluate(poly_Cp,if TinK then T else T_degC);
          h = if enthalpyOfT then h_T(T) else  h_pT(p,T,densityOfT);
          if singleState then
            u = h_T(T) - reference_p/d;
          else
            u = h - p/d;
          end if;
          d = Poly.evaluate(poly_rho,if TinK then T else T_degC);
          state.T = T;
          state.p = p;
          MM = MM_const;
          annotation(Documentation(info="<html>
<p>
Note that the inner energy neglects the pressure dependence, which is only
true for an incompressible medium with d = constant. The neglected term is
p-reference_p)/rho*(T/rho)*(partial rho /partial T). This is very small for
liquids due to proportionality to 1/d^2, but can be problematic for gases that are
modeled incompressible.
</p>
<p>It should be noted that incompressible media only have 1 state per control volume (usually T),
but have both T and p as inputs for fully correct properties. The error of using only T-dependent
properties is small, therefore a Boolean flag enthalpyOfT exists. If it is true, the
enumeration Choices.independentVariables  is set to  Choices.independentVariables.T otherwise
it is set to Choices.independentVariables.pT.</p>
<p>
Enthalpy is never a function of T only (h = h(T) + (p-reference_p)/d), but the
error is also small and non-linear systems can be avoided. In particular,
non-linear systems are small and local as opposed to large and over all volumes.
</p>

<p>
Entropy is calculated as
</p>
<pre>
  s = s0 + integral(Cp(T)/T,dt)
</pre>
<p>
which is only exactly true for a fluid with constant density d=d0.
</p>
</html>
      "));
        end BaseProperties;

        redeclare function extends setState_pTX
        "Returns state record, given pressure and temperature"
        algorithm
          state := ThermodynamicState(p=p,T=T);
        end setState_pTX;

        redeclare function extends setState_dTX
        "Returns state record, given pressure and temperature"
        algorithm
          assert(false, "for incompressible media with d(T) only, state can not be set from density and temperature");
        end setState_dTX;

        redeclare function extends setState_phX
        "Returns state record, given pressure and specific enthalpy"
        algorithm
          state :=ThermodynamicState(p=p,T=T_ph(p,h));
        end setState_phX;

        redeclare function extends setState_psX
        "Returns state record, given pressure and specific entropy"
        algorithm
          state :=ThermodynamicState(p=p,T=T_ps(p,s));
        end setState_psX;

            redeclare function extends setSmoothState
        "Return thermodynamic state so that it smoothly approximates: if x > 0 then state_a else state_b"
            algorithm
              state :=ThermodynamicState(p=Media.Common.smoothStep(x, state_a.p, state_b.p, x_small),
                                         T=Media.Common.smoothStep(x, state_a.T, state_b.T, x_small));
            end setSmoothState;

        redeclare function extends specificHeatCapacityCv
        "Specific heat capacity at constant volume (or pressure) of medium"

        algorithm
          assert(hasHeatCapacity,"Specific Heat Capacity, Cv, is not defined for medium "
                                                 + mediumName + ".");
          cv := Poly.evaluate(poly_Cp,if TinK then state.T else state.T - 273.15);
         annotation(smoothOrder=2);
        end specificHeatCapacityCv;

        redeclare function extends specificHeatCapacityCp
        "Specific heat capacity at constant volume (or pressure) of medium"

        algorithm
          assert(hasHeatCapacity,"Specific Heat Capacity, Cv, is not defined for medium "
                                                 + mediumName + ".");
          cp := Poly.evaluate(poly_Cp,if TinK then state.T else state.T - 273.15);
         annotation(smoothOrder=2);
        end specificHeatCapacityCp;

        redeclare function extends dynamicViscosity
        "Return dynamic viscosity as a function of the thermodynamic state record"

        algorithm
          assert(size(tableViscosity,1)>0,"DynamicViscosity, eta, is not defined for medium "
                                                 + mediumName + ".");
          eta := Math.exp(Poly.evaluate(poly_eta, 1/state.T));
         annotation(smoothOrder=2);
        end dynamicViscosity;

        redeclare function extends thermalConductivity
        "Return thermal conductivity as a function of the thermodynamic state record"

        algorithm
          assert(size(tableConductivity,1)>0,"ThermalConductivity, lambda, is not defined for medium "
                                                 + mediumName + ".");
          lambda := Poly.evaluate(poly_lam,if TinK then state.T else Cv.to_degC(state.T));
         annotation(smoothOrder=2);
        end thermalConductivity;

        function s_T "compute specific entropy"
          input Temperature T "temperature";
          output SpecificEntropy s "specific entropy";
        algorithm
          s := s0 + (if TinK then
            Poly.integralValue(poly_Cp[1:npol],T, T0) else
            Poly.integralValue(poly_Cp[1:npol],Cv.to_degC(T),Cv.to_degC(T0)))
            + Modelica.Math.log(T/T0)*
            Poly.evaluate(poly_Cp,if TinK then 0 else Modelica.Constants.T_zero);
         annotation(smoothOrder=2);
        end s_T;

        redeclare function extends specificEntropy "Return specific entropy
 as a function of the thermodynamic state record"

      protected
          Integer npol=size(poly_Cp,1)-1;
        algorithm
          assert(hasHeatCapacity,"Specific Entropy, s(T), is not defined for medium "
                                                 + mediumName + ".");
          s := s_T(state.T);
         annotation(smoothOrder=2);
        end specificEntropy;

        function h_T "Compute specific enthalpy from temperature"
          import Modelica.SIunits.Conversions.to_degC;
          extends Modelica.Icons.Function;
          input SI.Temperature T "Temperature";
          output SI.SpecificEnthalpy h "Specific enthalpy at p, T";
        algorithm
          h :=h0 + Poly.integralValue(poly_Cp, if TinK then T else Cv.to_degC(T), if TinK then
          T0 else Cv.to_degC(T0));
         annotation(derivative=h_T_der);
        end h_T;

        function h_T_der "Compute specific enthalpy from temperature"
          import Modelica.SIunits.Conversions.to_degC;
          extends Modelica.Icons.Function;
          input SI.Temperature T "Temperature";
          input Real dT "temperature derivative";
          output Real dh "derivative of Specific enthalpy at T";
        algorithm
          dh :=Poly.evaluate(poly_Cp, if TinK then T else Cv.to_degC(T))*dT;
         annotation(smoothOrder=1);
        end h_T_der;

        function h_pT "Compute specific enthalpy from pressure and temperature"
          import Modelica.SIunits.Conversions.to_degC;
          extends Modelica.Icons.Function;
          input SI.Pressure p "Pressure";
          input SI.Temperature T "Temperature";
          input Boolean densityOfT = false
          "include or neglect density derivative dependence of enthalpy"   annotation(Evaluate);
          output SI.SpecificEnthalpy h "Specific enthalpy at p, T";
        algorithm
          h :=h0 + Poly.integralValue(poly_Cp, if TinK then T else Cv.to_degC(T), if TinK then
          T0 else Cv.to_degC(T0)) + (p - reference_p)/Poly.evaluate(poly_rho, if TinK then
                  T else Cv.to_degC(T))
            *(if densityOfT then (1 + T/Poly.evaluate(poly_rho, if TinK then T else Cv.to_degC(T))
          *Poly.derivativeValue(poly_rho,if TinK then T else Cv.to_degC(T))) else 1.0);
         annotation(smoothOrder=2);
        end h_pT;

        redeclare function extends temperature
        "Return temperature as a function of the thermodynamic state record"
        algorithm
         T := state.T;
         annotation(smoothOrder=2);
        end temperature;

        redeclare function extends pressure
        "Return pressure as a function of the thermodynamic state record"
        algorithm
         p := state.p;
         annotation(smoothOrder=2);
        end pressure;

        redeclare function extends density
        "Return density as a function of the thermodynamic state record"
        algorithm
          d := Poly.evaluate(poly_rho,if TinK then state.T else Cv.to_degC(state.T));
         annotation(smoothOrder=2);
        end density;

        redeclare function extends specificEnthalpy
        "Return specific enthalpy as a function of the thermodynamic state record"
        algorithm
          h := if enthalpyOfT then h_T(state.T) else h_pT(state.p,state.T);
         annotation(smoothOrder=2);
        end specificEnthalpy;

        redeclare function extends specificInternalEnergy
        "Return specific internal energy as a function of the thermodynamic state record"
        algorithm
          u := if enthalpyOfT then h_T(state.T) else h_pT(state.p,state.T)
            - (if singleState then  reference_p/density(state) else state.p/density(state));
         annotation(smoothOrder=2);
        end specificInternalEnergy;

        function T_ph "Compute temperature from pressure and specific enthalpy"
          input AbsolutePressure p "pressure";
          input SpecificEnthalpy h "specific enthalpy";
          output Temperature T "temperature";
      protected
          package Internal
          "Solve h(T) for T with given h (use only indirectly via temperature_phX)"
            extends Modelica.Media.Common.OneNonLinearEquation;

            redeclare record extends f_nonlinear_Data
            "superfluous record, fix later when better structure of inverse functions exists"
                constant Real[5] dummy = {1,2,3,4,5};
            end f_nonlinear_Data;

            redeclare function extends f_nonlinear
            "p is smuggled in via vector"
            algorithm
              y := if singleState then h_T(x) else h_pT(p,x);
            end f_nonlinear;

            // Dummy definition has to be added for current Dymola
            redeclare function extends solve
            end solve;
          end Internal;
        algorithm
         T := Internal.solve(h, T_min, T_max, p, {1}, Internal.f_nonlinear_Data());
          annotation(Inline=false, LateInline=true, inverse=h_pT(p,T));
        end T_ph;

        function T_ps "Compute temperature from pressure and specific enthalpy"
          input AbsolutePressure p "pressure";
          input SpecificEntropy s "specific entropy";
          output Temperature T "temperature";
      protected
          package Internal
          "Solve h(T) for T with given h (use only indirectly via temperature_phX)"
            extends Modelica.Media.Common.OneNonLinearEquation;

            redeclare record extends f_nonlinear_Data
            "superfluous record, fix later when better structure of inverse functions exists"
                constant Real[5] dummy = {1,2,3,4,5};
            end f_nonlinear_Data;

            redeclare function extends f_nonlinear
            "p is smuggled in via vector"
            algorithm
              y := s_T(x);
            end f_nonlinear;

            // Dummy definition has to be added for current Dymola
            redeclare function extends solve
            end solve;
          end Internal;
        algorithm
         T := Internal.solve(s, T_min, T_max, p, {1}, Internal.f_nonlinear_Data());
        end T_ps;

        package Polynomials_Temp
        "Temporary Functions operating on polynomials (including polynomial fitting); only to be used in Modelica.Media.Incompressible.TableBased"
          extends Modelica.Icons.Package;

          function evaluate "Evaluate polynomial at a given abszissa value"
            extends Modelica.Icons.Function;
            input Real p[:]
            "Polynomial coefficients (p[1] is coefficient of highest power)";
            input Real u "Abszissa value";
            output Real y "Value of polynomial at u";
          algorithm
            y := p[1];
            for j in 2:size(p, 1) loop
              y := p[j] + u*y;
            end for;
            annotation(derivative(zeroDerivative=p)=evaluate_der);
          end evaluate;

          function derivativeValue
          "Value of derivative of polynomial at abszissa value u"
            extends Modelica.Icons.Function;
            input Real p[:]
            "Polynomial coefficients (p[1] is coefficient of highest power)";
            input Real u "Abszissa value";
            output Real y "Value of derivative of polynomial at u";
        protected
            Integer n=size(p, 1);
          algorithm
            y := p[1]*(n - 1);
            for j in 2:size(p, 1)-1 loop
              y := p[j]*(n - j) + u*y;
            end for;
            annotation(derivative(zeroDerivative=p)=derivativeValue_der);
          end derivativeValue;

          function secondDerivativeValue
          "Value of 2nd derivative of polynomial at abszissa value u"
            extends Modelica.Icons.Function;
            input Real p[:]
            "Polynomial coefficients (p[1] is coefficient of highest power)";
            input Real u "Abszissa value";
            output Real y "Value of 2nd derivative of polynomial at u";
        protected
            Integer n=size(p, 1);
          algorithm
            y := p[1]*(n - 1)*(n - 2);
            for j in 2:size(p, 1)-2 loop
              y := p[j]*(n - j)*(n - j - 1) + u*y;
            end for;
          end secondDerivativeValue;

          function integralValue
          "Integral of polynomial p(u) from u_low to u_high"
            extends Modelica.Icons.Function;
            input Real p[:] "Polynomial coefficients";
            input Real u_high "High integrand value";
            input Real u_low=0 "Low integrand value, default 0";
            output Real integral=0.0
            "Integral of polynomial p from u_low to u_high";
        protected
            Integer n=size(p, 1) "degree of integrated polynomial";
            Real y_low=0 "value at lower integrand";
          algorithm
            for j in 1:n loop
              integral := u_high*(p[j]/(n - j + 1) + integral);
              y_low := u_low*(p[j]/(n - j + 1) + y_low);
            end for;
            integral := integral - y_low;
            annotation(derivative(zeroDerivative=p)=integralValue_der);
          end integralValue;

          function fitting
          "Computes the coefficients of a polynomial that fits a set of data points in a least-squares sense"
            extends Modelica.Icons.Function;
            input Real u[:] "Abscissa data values";
            input Real y[size(u, 1)] "Ordinate data values";
            input Integer n(min=1)
            "Order of desired polynomial that fits the data points (u,y)";
            output Real p[n + 1]
            "Polynomial coefficients of polynomial that fits the date points";
        protected
            Real V[size(u, 1), n + 1] "Vandermonde matrix";
          algorithm
            // Construct Vandermonde matrix
            V[:, n + 1] := ones(size(u, 1));
            for j in n:-1:1 loop
              V[:, j] := {u[i] * V[i, j + 1] for i in 1:size(u,1)};
            end for;

            // Solve least squares problem
            p :=Modelica.Math.Matrices.leastSquares(V, y);
            annotation (Documentation(info="<HTML>
<p>
Polynomials.fitting(u,y,n) computes the coefficients of a polynomial
p(u) of degree \"n\" that fits the data \"p(u[i]) - y[i]\"
in a least squares sense. The polynomial is
returned as a vector p[n+1] that has the following definition:
</p>
<pre>
  p(u) = p[1]*u^n + p[2]*u^(n-1) + ... + p[n]*u + p[n+1];
</pre>
</HTML>"));
          end fitting;

          function evaluate_der "Evaluate polynomial at a given abszissa value"
            extends Modelica.Icons.Function;
            input Real p[:]
            "Polynomial coefficients (p[1] is coefficient of highest power)";
            input Real u "Abszissa value";
            input Real du "Abszissa value";
            output Real dy "Value of polynomial at u";
        protected
            Integer n=size(p, 1);
          algorithm
            dy := p[1]*(n - 1);
            for j in 2:size(p, 1)-1 loop
              dy := p[j]*(n - j) + u*dy;
            end for;
            dy := dy*du;
          end evaluate_der;

          function integralValue_der
          "Time derivative of integral of polynomial p(u) from u_low to u_high, assuming only u_high as time-dependent (Leibnitz rule)"
            extends Modelica.Icons.Function;
            input Real p[:] "Polynomial coefficients";
            input Real u_high "High integrand value";
            input Real u_low=0 "Low integrand value, default 0";
            input Real du_high "High integrand value";
            input Real du_low=0 "Low integrand value, default 0";
            output Real dintegral=0.0
            "Integral of polynomial p from u_low to u_high";
          algorithm
            dintegral := evaluate(p,u_high)*du_high;
          end integralValue_der;

          function derivativeValue_der
          "time derivative of derivative of polynomial"
            extends Modelica.Icons.Function;
            input Real p[:]
            "Polynomial coefficients (p[1] is coefficient of highest power)";
            input Real u "Abszissa value";
            input Real du "delta of abszissa value";
            output Real dy
            "time-derivative of derivative of polynomial w.r.t. input variable at u";
        protected
            Integer n=size(p, 1);
          algorithm
            dy := secondDerivativeValue(p,u)*du;
          end derivativeValue_der;
          annotation (Documentation(info="<HTML>
<p>
This package contains functions to operate on polynomials,
in particular to determine the derivative and the integral
of a polynomial and to use a polynomial to fit a given set
of data points.
</p>
<p>

<p><b>Copyright &copy; 2004-2010, Modelica Association and DLR.</b></p>

<p><i>
This package is <b>free</b> software. It can be redistributed and/or modified
under the terms of the <b>Modelica license</b>, see the license conditions
and the accompanying <b>disclaimer</b> in the documentation of package
Modelica in file \"Modelica/package.mo\".
</i>
</p>

</HTML>
",         revisions="<html>
<ul>
<li><i>Oct. 22, 2004</i> by Martin Otter (DLR):<br>
       Renamed functions to not have abbrevations.<br>
       Based fitting on LAPACK<br>
       New function to return the polynomial of an indefinite integral<li>
<li><i>Sept. 3, 2004</i> by Jonas Eborn (Scynamics):<br>
       polyderval, polyintval added<li>
<li><i>March 1, 2004</i> by Martin Otter (DLR):<br>
       first version implemented
</li>
</ul>
</html>"));
        end Polynomials_Temp;
      annotation(__Dymola_keepConstant = true, Documentation(info="<HTML>
<p>
This is the base package for medium models of incompressible fluids based on
tables. The minimal data to provide for a useful medium description is tables
of density and heat capacity as functions of temperature.
</p>

<p>It should be noted that incompressible media only have 1 state per control volume (usually T),
but have both T and p as inputs for fully correct properties. The error of using only T-dependent
properties is small, therefore a Boolean flag enthalpyOfT exists. If it is true, the
enumeration Choices.independentVariables  is set to  Choices.independentVariables.T otherwise
it is set to Choices.independentVariables.pT.</p>

<h4>Using the package TableBased</h4>
<p>
To implement a new medium model, create a package that <b>extends</b> TableBased
and provides one or more of the constant tables:
</p>

<pre>
tableDensity        = [T, d];
tableHeatCapacity   = [T, Cp];
tableConductivity   = [T, lam];
tableViscosity      = [T, eta];
tableVaporPressure  = [T, pVap];
</pre>

<p>
The table data is used to fit constant polynomials of order <b>npol</b>, the
temperature data points do not need to be same for different properties. Properties
like enthalpy, inner energy and entropy are calculated consistently from integrals
and derivatives of d(T) and Cp(T). The minimal
data for a useful medium model is thus density and heat capacity. Transport
properties and vapor pressure are optional, if the data tables are empty the corresponding
function calls can not be used.
</p>
</HTML>"),
        Documentation(info="<HTML>
<h4>Table based media</h4>
<p>
This is the base package for medium models of incompressible fluids based on
tables. The minimal data to provide for a useful medium description is tables
of density and heat capacity as functions of temperature.
</p>
<h4>Using the package TableBased</h4>
<p>
To implement a new medium model, create a package that <b>extends</b> TableBased
and provides one or more of the constant tables:
<pre>
tableDensity        = [T, d];
tableHeatCapacity   = [T, Cp];
tableConductivity   = [T, lam];
tableViscosity      = [T, eta];
tableVaporPressure  = [T, pVap];
</pre>
The table data is used to fit constant polynomials of order <b>npol</b>, the
temperature data points do not need to be same for different properties. Properties
like enthalpy, inner energy and entropy are calculated consistently from integrals
and derivatives of d(T) and Cp(T). The minimal
data for a useful medium model is thus density and heat capacity. Transport
properties and vapor pressure are optional, if the data tables are empty the corresponding
function calls can not be used.
</HTML>"));
      end TableBased;
      annotation (
        Documentation(info="<HTML>
<h4>Incompressible media package</h4>
<p>
This package provides a structure and examples of how to create simple
medium models of incompressible fluids, meaning fluids with very little
pressure influence on density. The medium properties is typically described
in terms of tables, functions or polynomial coefficients.
</p>
<h4>Definitions</h4>
<p>
The common meaning of <em>incompressible</em> is that properties like density
and enthalpy are independent of pressure. Thus properties are conveniently
described as functions of temperature, e.g., as polynomials density(T) and cp(T).
However, enthalpy can not be independent of pressure since h = u - p/d. For liquids
it is anyway
common to neglect this dependence since for constant density the neglected term
is (p - p0)/d, which in comparison with cp is very small for most liquids. For
water, the equivalent change of temperature to increasing pressure 1 bar is
0.025 Kelvin.
</p>
<p>
Two boolean flags are used to choose how enthalpy and inner energy is calculated:
<ul>
<li><b>enthalpyOfT</b>=true, means assuming that enthalpy is only a function
of temperature, neglecting the pressure dependent term.</li>
<li><b>singleState</b>=true, means also neglect the pressure influence on inner
energy, which makes all medium properties pure functions of temperature.</li>
</ul>
The default setting for both these flags is true, which enables the simulation tool
to choose temperature as the only medium state and avoids non-linear equation
systems, see the section about
<a href=\"modelica://Modelica.Media.UsersGuide.MediumDefinition.StaticStateSelection\">Static
state selection</a> in the Modelica.Media User's Guide.

</p>
<h4>Contents</h4>
<p>
Currently, the package contains the following parts:
</p>
<ol>
<li> <a href=\"modelica://Modelica.Media.Incompressible.TableBased\">
      Table based medium models</a></li>
<li> <a href=\"modelica://Modelica.Media.Incompressible.Examples\">
      Example medium models</a></li>
</ol>

<p>
A few examples are given in the Examples package. The model
<a href=\"modelica://Modelica.Media.Incompressible.Examples.Glycol47\">
Examples.Glycol47</a> shows how the medium models can be used. For more
realistic examples of how to implement volume models with medium properties
look in the <a href=\"modelica://Modelica.Media.UsersGuide.MediumUsage\">Medium
usage section</a> of the User's Guide.
</p>

</HTML>"));
    end Incompressible;
  annotation (
    Documentation(info="<HTML>
<p>
This library contains <a href=\"modelica://Modelica.Media.Interfaces\">interface</a>
definitions for media and the following <b>property</b> models for
single and multiple substance fluids with one and multiple phases:
</p>
<ul>
<li> <a href=\"modelica://Modelica.Media.IdealGases\">Ideal gases:</a><br>
     1241 high precision gas models based on the
     NASA Glenn coefficients, plus ideal gas mixture models based
     on the same data.</li>
<li> <a href=\"modelica://Modelica.Media.Water\">Water models:</a><br>
     ConstantPropertyLiquidWater, WaterIF97 (high precision
     water model according to the IAPWS/IF97 standard)</li>
<li> <a href=\"modelica://Modelica.Media.Air\">Air models:</a><br>
     SimpleAir, DryAirNasa, and MoistAir</li>
<li> <a href=\"modelica://Modelica.Media.Incompressible\">
     Incompressible media:</a><br>
     TableBased incompressible fluid models (properties are defined by tables rho(T),
     HeatCapacity_cp(T), etc.)</li>
<li> <a href=\"modelica://Modelica.Media.CompressibleLiquids\">
     Compressible liquids:</a><br>
     Simple liquid models with linear compressibility</li>
</ul>
<p>
The following parts are useful, when newly starting with this library:
<ul>
<li> <a href=\"modelica://Modelica.Media.UsersGuide\">Modelica.Media.UsersGuide</a>.</li>
<li> <a href=\"modelica://Modelica.Media.UsersGuide.MediumUsage\">Modelica.Media.UsersGuide.MediumUsage</a>
     describes how to use a medium model in a component model.</li>
<li> <a href=\"modelica://Modelica.Media.UsersGuide.MediumDefinition\">
     Modelica.Media.UsersGuide.MediumDefinition</a>
     describes how a new fluid medium model has to be implemented.</li>
<li> <a href=\"modelica://Modelica.Media.UsersGuide.ReleaseNotes\">Modelica.Media.UsersGuide.ReleaseNotes</a>
     summarizes the changes of the library releases.</li>
<li> <a href=\"modelica://Modelica.Media.Examples\">Modelica.Media.Examples</a>
     contains examples that demonstrate the usage of this library.</li>
</ul>
<p>
Copyright &copy; 1998-2010, Modelica Association.
</p>
<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"http://www.modelica.org/licenses/ModelicaLicense2\"> http://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>
</HTML>"));
  end Media;

  package Thermal
  "Library of thermal system components to model heat transfer and simple thermo-fluid pipe flow"
    extends Modelica.Icons.Package;

    package HeatTransfer
    "Library of 1-dimensional heat transfer with lumped elements"
      import Modelica.SIunits.Conversions.*;
      extends Modelica.Icons.Package;

      package Sources "Thermal sources"
      extends Modelica.Icons.SourcesPackage;

        model PrescribedHeatFlow "Prescribed heat flow boundary condition"
          parameter Modelica.SIunits.Temperature T_ref=293.15
          "Reference temperature";
          parameter Modelica.SIunits.LinearTemperatureCoefficient alpha=0
          "Temperature coefficient of heat flow rate";
          Modelica.Blocks.Interfaces.RealInput Q_flow
                annotation (Placement(transformation(
                origin={-100,0},
                extent={{20,-20},{-20,20}},
                rotation=180)));
          Interfaces.HeatPort_b port annotation (Placement(transformation(extent={{90,
                    -10},{110,10}}, rotation=0)));
        equation
          port.Q_flow = -Q_flow*(1 + alpha*(port.T - T_ref));
          annotation (
            Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                    100,100}}), graphics={
                Line(
                  points={{-60,-20},{40,-20}},
                  color={191,0,0},
                  thickness=0.5),
                Line(
                  points={{-60,20},{40,20}},
                  color={191,0,0},
                  thickness=0.5),
                Line(
                  points={{-80,0},{-60,-20}},
                  color={191,0,0},
                  thickness=0.5),
                Line(
                  points={{-80,0},{-60,20}},
                  color={191,0,0},
                  thickness=0.5),
                Polygon(
                  points={{40,0},{40,40},{70,20},{40,0}},
                  lineColor={191,0,0},
                  fillColor={191,0,0},
                  fillPattern=FillPattern.Solid),
                Polygon(
                  points={{40,-40},{40,0},{70,-20},{40,-40}},
                  lineColor={191,0,0},
                  fillColor={191,0,0},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{70,40},{90,-40}},
                  lineColor={191,0,0},
                  fillColor={191,0,0},
                  fillPattern=FillPattern.Solid),
                Text(
                  extent={{-150,100},{150,60}},
                  textString="%name",
                  lineColor={0,0,255})}),
            Documentation(info="<HTML>
<p>
This model allows a specified amount of heat flow rate to be \"injected\"
into a thermal system at a given port.  The amount of heat
is given by the input signal Q_flow into the model. The heat flows into the
component to which the component PrescribedHeatFlow is connected,
if the input signal is positive.
</p>
<p>
If parameter alpha is > 0, the heat flow is mulitplied by (1 + alpha*(port.T - T_ref))
in order to simulate temperature dependent losses (which are given an reference temperature T_ref).
</p>
</HTML>
"),         Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
                    {100,100}}), graphics={
                Line(
                  points={{-60,-20},{68,-20}},
                  color={191,0,0},
                  thickness=0.5),
                Line(
                  points={{-60,20},{68,20}},
                  color={191,0,0},
                  thickness=0.5),
                Line(
                  points={{-80,0},{-60,-20}},
                  color={191,0,0},
                  thickness=0.5),
                Line(
                  points={{-80,0},{-60,20}},
                  color={191,0,0},
                  thickness=0.5),
                Polygon(
                  points={{60,0},{60,40},{90,20},{60,0}},
                  lineColor={191,0,0},
                  fillColor={191,0,0},
                  fillPattern=FillPattern.Solid),
                Polygon(
                  points={{60,-40},{60,0},{90,-20},{60,-40}},
                  lineColor={191,0,0},
                  fillColor={191,0,0},
                  fillPattern=FillPattern.Solid)}));
        end PrescribedHeatFlow;
        annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}), graphics),   Documentation(info="<html>

</html>"));
      end Sources;

      package Interfaces "Connectors and partial models"
        extends Modelica.Icons.InterfacesPackage;

        partial connector HeatPort "Thermal port for 1-dim. heat transfer"
          Modelica.SIunits.Temperature T "Port temperature";
          flow Modelica.SIunits.HeatFlowRate Q_flow
          "Heat flow rate (positive if flowing from outside into the component)";
          annotation (Documentation(info="<html>

</html>"));
        end HeatPort;

        connector HeatPort_a
        "Thermal port for 1-dim. heat transfer (filled rectangular icon)"

          extends HeatPort;

          annotation(defaultComponentName = "port_a",
            Documentation(info="<HTML>
<p>This connector is used for 1-dimensional heat flow between components.
The variables in the connector are:</p>
<pre>
   T       Temperature in [Kelvin].
   Q_flow  Heat flow rate in [Watt].
</pre>
<p>According to the Modelica sign convention, a <b>positive</b> heat flow
rate <b>Q_flow</b> is considered to flow <b>into</b> a component. This
convention has to be used whenever this connector is used in a model
class.</p>
<p>Note, that the two connector classes <b>HeatPort_a</b> and
<b>HeatPort_b</b> are identical with the only exception of the different
<b>icon layout</b>.</p></HTML>
"),         Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                    100,100}}), graphics={Rectangle(
                  extent={{-100,100},{100,-100}},
                  lineColor={191,0,0},
                  fillColor={191,0,0},
                  fillPattern=FillPattern.Solid)}),
            Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
                    {100,100}}), graphics={Rectangle(
                  extent={{-50,50},{50,-50}},
                  lineColor={191,0,0},
                  fillColor={191,0,0},
                  fillPattern=FillPattern.Solid), Text(
                  extent={{-120,120},{100,60}},
                  lineColor={191,0,0},
                  textString="%name")}));
        end HeatPort_a;

        connector HeatPort_b
        "Thermal port for 1-dim. heat transfer (unfilled rectangular icon)"

          extends HeatPort;

          annotation(defaultComponentName = "port_b",
            Documentation(info="<HTML>
<p>This connector is used for 1-dimensional heat flow between components.
The variables in the connector are:</p>
<pre>
   T       Temperature in [Kelvin].
   Q_flow  Heat flow rate in [Watt].
</pre>
<p>According to the Modelica sign convention, a <b>positive</b> heat flow
rate <b>Q_flow</b> is considered to flow <b>into</b> a component. This
convention has to be used whenever this connector is used in a model
class.</p>
<p>Note, that the two connector classes <b>HeatPort_a</b> and
<b>HeatPort_b</b> are identical with the only exception of the different
<b>icon layout</b>.</p></HTML>
"),         Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
                    {100,100}}), graphics={Rectangle(
                  extent={{-50,50},{50,-50}},
                  lineColor={191,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid), Text(
                  extent={{-100,120},{120,60}},
                  lineColor={191,0,0},
                  textString="%name")}),
            Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                    100,100}}), graphics={Rectangle(
                  extent={{-100,100},{100,-100}},
                  lineColor={191,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid)}));
        end HeatPort_b;
        annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}), graphics),
                                   Documentation(info="<html>

</html>"));
      end Interfaces;
      annotation (
         Icon(coordinateSystem(preserveAspectRatio=true,
              extent={{-100,-100},{100,100}}), graphics={
            Polygon(
              points={{-54,-6},{-61,-7},{-75,-15},{-79,-24},{-80,-34},{-78,-42},{-73,
                  -49},{-64,-51},{-57,-51},{-47,-50},{-41,-43},{-38,-35},{-40,-27},
                  {-40,-20},{-42,-13},{-47,-7},{-54,-5},{-54,-6}},
              lineColor={128,128,128},
              fillColor={192,192,192},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{-75,-15},{-79,-25},{-80,-34},{-78,-42},{-72,-49},{-64,-51},{
                  -57,-51},{-47,-50},{-57,-47},{-65,-45},{-71,-40},{-74,-33},{-76,-23},
                  {-75,-15},{-75,-15}},
              lineColor={0,0,0},
              fillColor={160,160,164},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{39,-6},{32,-7},{18,-15},{14,-24},{13,-34},{15,-42},{20,-49},
                  {29,-51},{36,-51},{46,-50},{52,-43},{55,-35},{53,-27},{53,-20},{
                  51,-13},{46,-7},{39,-5},{39,-6}},
              lineColor={160,160,164},
              fillColor={192,192,192},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{18,-15},{14,-25},{13,-34},{15,-42},{21,-49},{29,-51},{36,-51},
                  {46,-50},{36,-47},{28,-45},{22,-40},{19,-33},{17,-23},{18,-15},{
                  18,-15}},
              lineColor={0,0,0},
              fillColor={160,160,164},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{-9,-23},{-9,-10},{18,-17},{-9,-23}},
              lineColor={191,0,0},
              fillColor={191,0,0},
              fillPattern=FillPattern.Solid),
            Line(
              points={{-41,-17},{-9,-17}},
              color={191,0,0},
              thickness=0.5),
            Line(
              points={{-17,-40},{15,-40}},
              color={191,0,0},
              thickness=0.5),
            Polygon(
              points={{-17,-46},{-17,-34},{-40,-40},{-17,-46}},
              lineColor={191,0,0},
              fillColor={191,0,0},
              fillPattern=FillPattern.Solid)}),
                                Documentation(info="<HTML>
<p>
This package contains components to model <b>1-dimensional heat transfer</b>
with lumped elements. This allows especially to model heat transfer in
machines provided the parameters of the lumped elements, such as
the heat capacity of a part, can be determined by measurements
(due to the complex geometries and many materials used in machines,
calculating the lumped element parameters from some basic analytic
formulas is usually not possible).
</p>
<p>
Example models how to use this library are given in subpackage <b>Examples</b>.<br>
For a first simple example, see <b>Examples.TwoMasses</b> where two masses
with different initial temperatures are getting in contact to each
other and arriving after some time at a common temperature.<br>
<b>Examples.ControlledTemperature</b> shows how to hold a temperature
within desired limits by switching on and off an electric resistor.<br>
A more realistic example is provided in <b>Examples.Motor</b> where the
heating of an electrical motor is modelled, see the following screen shot
of this example:
</p>
<img src=\"modelica://Modelica/Resources/Images/Thermal/HeatTransfer/driveWithHeatTransfer.png\" ALT=\"driveWithHeatTransfer\">
<p>
The <b>filled</b> and <b>non-filled red squares</b> at the left and
right side of a component represent <b>thermal ports</b> (connector HeatPort).
Drawing a line between such squares means that they are thermally connected.
The variables of a HeatPort connector are the temperature <b>T</b> at the port
and the heat flow rate <b>Q_flow</b> flowing into the component (if Q_flow is positive,
the heat flows into the element, otherwise it flows out of the element):
</p>
<pre>   Modelica.SIunits.Temperature  T  \"absolute temperature at port in Kelvin\";
   Modelica.SIunits.HeatFlowRate Q_flow  \"flow rate at the port in Watt\";
</pre>
<p>
Note, that all temperatures of this package, including initial conditions,
are given in Kelvin. For convenience, in subpackages <b>HeatTransfer.Celsius</b>,
 <b>HeatTransfer.Fahrenheit</b> and <b>HeatTransfer.Rankine</b> components are provided such that source and
sensor information is available in degree Celsius, degree Fahrenheit, or degree Rankine,
respectively. Additionally, in package <b>SIunits.Conversions</b> conversion
functions between the units Kelvin and Celsius, Fahrenheit, Rankine are
provided. These functions may be used in the following way:
</p>
<pre>  <b>import</b> SI=Modelica.SIunits;
  <b>import</b> Modelica.SIunits.Conversions.*;
     ...
  <b>parameter</b> SI.Temperature T = from_degC(25);  // convert 25 degree Celsius to Kelvin
</pre>

<p>
There are several other components available, such as AxialConduction (discretized PDE in
axial direction), which have been temporarily removed from this library. The reason is that
these components reference material properties, such as thermal conductivity, and currently
the Modelica design group is discussing a general scheme to describe material properties.
</p>
<p>
For technical details in the design of this library, see the following reference:<br>
<b>Michael Tiller (2001)</b>: <a href=\"http://www.amazon.de\">
Introduction to Physical Modeling with Modelica</a>.
Kluwer Academic Publishers Boston.
</p>
<p>
<b>Acknowledgements:</b><br>
Several helpful remarks from the following persons are acknowledged:
John Batteh, Ford Motors, Dearborn, U.S.A;
<a href=\"http://www.haumer.at/\">Anton Haumer</a>, Technical Consulting &amp; Electrical Engineering, Austria;
Ludwig Marvan, VA TECH ELIN EBG Elektronik GmbH, Wien, Austria;
Hans Olsson, Dassault Syst&egrave;mes AB, Sweden;
Hubertus Tummescheit, Lund Institute of Technology, Lund, Sweden.
</p>
<dl>
  <dt><b>Main Authors:</b></dt>
  <dd>
  <p>
  <a href=\"http://www.haumer.at/\">Anton Haumer</a><br>
  Technical Consulting &amp; Electrical Engineering<br>
  A-3423 St.Andrae-Woerdern, Austria<br>
  email: <a href=\"mailto:a.haumer@haumer.at\">a.haumer@haumer.at</a>
</p>
  </dd>
</dl>
<p><b>Copyright &copy; 2001-2010, Modelica Association, Michael Tiller and DLR.</b></p>

<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"http://www.modelica.org/licenses/ModelicaLicense2\"> http://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>
</HTML>
",     revisions="<html>
<ul>
<li><i>July 15, 2002</i>
       by Michael Tiller, <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>
       and <a href=\"http://www.robotic.dlr.de/Nikolaus.Schuermann/\">Nikolaus Sch&uuml;rmann</a>:<br>
       Implemented.
</li>
<li><i>June 13, 2005</i>
       by <a href=\"http://www.haumer.at/\">Anton Haumer</a><br>
       Refined placing of connectors (cosmetic).<br>
       Refined all Examples; removed Examples.FrequencyInverter, introducing Examples.Motor<br>
       Introduced temperature dependent correction (1 + alpha*(T - T_ref)) in Fixed/PrescribedHeatFlow<br>
</li>
  <li> v1.1.1 2007/11/13 Anton Haumer<br>
       componentes moved to sub-packages</li>
  <li> v1.2.0 2009/08/26 Anton Haumer<br>
       added component ThermalCollector</li>

</ul>
</html>"));
    end HeatTransfer;
  annotation (Documentation(info="<html>
<p>
This package contains libraries to model heat transfer
and fluid heat flow.
</p>
</html>"));
  end Thermal;

  package Math
  "Library of mathematical functions (e.g., sin, cos) and of functions operating on vectors and matrices"
  import SI = Modelica.SIunits;
  extends Modelica.Icons.Package;

  package Matrices "Library of functions operating on matrices"
    extends Modelica.Icons.Package;

    function leastSquares
    "Solve linear equation A*x = b (exactly if possible, or otherwise in a least square sense; A may be non-square and may be rank deficient)"
      extends Modelica.Icons.Function;
      input Real A[:, :] "Matrix A";
      input Real b[size(A, 1)] "Vector b";
      input Real rcond=100*Modelica.Constants.eps
      "Reciprocal condition number to estimate the rank of A";
      output Real x[size(A, 2)]
      "Vector x such that min|A*x-b|^2 if size(A,1) >= size(A,2) or min|x|^2 and A*x=b, if size(A,1) < size(A,2)";
      output Integer rank "Rank of A";
  protected
      Integer info;
      Real xx[max(size(A,1),size(A,2))];
    algorithm
      if min(size(A)) > 0 then
        (xx,info,rank) := LAPACK.dgelsx_vec(A, b, rcond);
         x := xx[1:size(A,2)];
         assert(info == 0, "Solving an overdetermined or underdetermined linear system\n" +
                           "of equations with function \"Matrices.leastSquares\" failed.");
      else
         x := fill(0.0, size(A, 2));
      end if;
      annotation (
        Documentation(info="<html>
<h4>Syntax</h4>
<blockquote><pre>
x = Matrices.<b>leastSquares</b>(A,b);
</pre></blockquote>
<h4>Description</h4>
<p>
Returns a solution of equation A*x = b in a least
square sense (A may be rank deficient):
</p>
<pre>
  minimize | A*x - b |
</pre>

<p>
Several different cases can be distinguished (note, <b>rank</b> is an
output argument of this function):
</p>

<p>
<b>size(A,1) = size(A,2)</b>
</p>

<p> A solution is returned for a regular, as well as a singular matrix A:
</p>

<ul>
<li> <b>rank</b> = size(A,1):<br>
     A is <b>regular</b> and the returned solution x fulfills the equation
     A*x = b uniquely.</li>

<li> <b>rank</b> &lt; size(A,1):<br>
     A is <b>singular</b> and no unique solution for equation A*x = b exists.
     <ul>
     <li>  If an infinite number of solutions exists, the one is selected that fulfills
           the equation and at the same time has the minimum norm |x| for all solution
           vectors that fulfill the equation.</li>
     <li>  If no solution exists, x is selected such that |A*x - b| is as small as
           possible (but A*x - b is not zero).</li>
     </ul>
</ul>

<p>
<b>size(A,1) &gt; size(A,2):</b>
</p>

<p>
The equation A*x = b has no unique solution. The solution x is selected such that
|A*x - b| is as small as possible. If rank = size(A,2), this minimum norm solution is
unique. If rank &lt; size(A,2), there are an infinite number of solutions leading to the
same minimum value of |A*x - b|. From these infinite number of solutions, the one with the
minimum norm |x| is selected. This gives a unique solution that minimizes both
|A*x - b| and |x|.
</p>

<p>
<b>size(A,1) &lt; size(A,2):</b>
</p>

<ul>
<li> <b>rank</b> = size(A,1):<br>
     There are an infinite number of solutions that fulfill the equation A*x = b.
     From this infinite number, the unique solution is selected that minimizes |x|.
     </li>

<li> <b>rank</b> &lt; size(A,1):<br>
     There is either no solution of equation A*x = b, or there are again an infinite
     number of solutions. The unique solution x is returned that minimizes
      both |A*x - b| and |x|.</li>
</ul>

<p>
Note, the solution is computed with the LAPACK function \"dgelsx\",
i.e., QR or LQ factorization of A with column pivoting.
</p>

<h4>Algorithmic details</h4>

<p>
The function first computes a QR factorization with column pivoting:
</p>

<pre>
      A * P = Q * [ R11 R12 ]
                  [  0  R22 ]
</pre>

<p>
with R11 defined as the largest leading submatrix whose estimated
condition number is less than 1/rcond.  The order of R11, <b>rank</b>,
is the effective rank of A.
</p>

<p>
Then, R22 is considered to be negligible, and R12 is annihilated
by orthogonal transformations from the right, arriving at the
complete orthogonal factorization:
</p>

<pre>
     A * P = Q * [ T11 0 ] * Z
                 [  0  0 ]
</pre>

<p>
The minimum-norm solution is then
</p>

<pre>
     x = P * Z' [ inv(T11)*Q1'*b ]
                [        0       ]
</pre>

<p>
where Q1 consists of the first \"rank\" columns of Q.
</p>

<h4>See also</h4>

<p>
<a href=\"modelica://Modelica.Math.Matrices.leastSquares2\">Matrices.leastSquares2</a>
(same as leastSquares, but with a right hand side matrix), <br>
<a href=\"modelica://Modelica.Math.Matrices.solve\">Matrices.solve</a>
(for square, regular matrices A)
</p>

</html>"));
    end leastSquares;

    package LAPACK
    "Interface to LAPACK library (should usually not directly be used but only indirectly via Modelica.Math.Matrices)"
      extends Modelica.Icons.Package;

      function dgelsx_vec
      "Computes the minimum-norm solution to a real linear least squares problem with rank deficient A"

        extends Modelica.Icons.Function;
        input Real A[:, :];
        input Real b[size(A,1)];
        input Real rcond=0.0 "Reciprocal condition number to estimate rank";
        output Real x[max(nrow,ncol)]= cat(1,b,zeros(max(nrow,ncol)-nrow))
        "solution is in first size(A,2) rows";
        output Integer info;
        output Integer rank "Effective rank of A";
    protected
        Integer nrow=size(A,1);
        Integer ncol=size(A,2);
        Integer nx=max(nrow,ncol);
        Integer lwork=max( min(nrow,ncol)+3*ncol, 2*min(nrow,ncol)+1);
        Real work[lwork];
        Real Awork[nrow,ncol]=A;
        Integer jpvt[ncol]=zeros(ncol);
        external "FORTRAN 77" dgelsx(nrow, ncol, 1, Awork, nrow, x, nx, jpvt,
                                    rcond, rank, work, lwork, info) annotation (Library="Lapack");

        annotation (
          Documentation(info="Lapack documentation
  Purpose
  =======

  DGELSX computes the minimum-norm solution to a real linear least
  squares problem:
      minimize || A * X - B ||
  using a complete orthogonal factorization of A.  A is an M-by-N
  matrix which may be rank-deficient.

  Several right hand side vectors b and solution vectors x can be
  handled in a single call; they are stored as the columns of the
  M-by-NRHS right hand side matrix B and the N-by-NRHS solution
  matrix X.

  The routine first computes a QR factorization with column pivoting:
      A * P = Q * [ R11 R12 ]
                  [  0  R22 ]
  with R11 defined as the largest leading submatrix whose estimated
  condition number is less than 1/RCOND.  The order of R11, RANK,
  is the effective rank of A.

  Then, R22 is considered to be negligible, and R12 is annihilated
  by orthogonal transformations from the right, arriving at the
  complete orthogonal factorization:
     A * P = Q * [ T11 0 ] * Z
                 [  0  0 ]
  The minimum-norm solution is then
     X = P * Z' [ inv(T11)*Q1'*B ]
                [        0       ]
  where Q1 consists of the first RANK columns of Q.

  Arguments
  =========

  M       (input) INTEGER
          The number of rows of the matrix A.  M >= 0.

  N       (input) INTEGER
          The number of columns of the matrix A.  N >= 0.

  NRHS    (input) INTEGER
          The number of right hand sides, i.e., the number of
          columns of matrices B and X. NRHS >= 0.

  A       (input/output) DOUBLE PRECISION array, dimension (LDA,N)
          On entry, the M-by-N matrix A.
          On exit, A has been overwritten by details of its
          complete orthogonal factorization.

  LDA     (input) INTEGER
          The leading dimension of the array A.  LDA >= max(1,M).

  B       (input/output) DOUBLE PRECISION array, dimension (LDB,NRHS)
          On entry, the M-by-NRHS right hand side matrix B.
          On exit, the N-by-NRHS solution matrix X.
          If m >= n and RANK = n, the residual sum-of-squares for
          the solution in the i-th column is given by the sum of
          squares of elements N+1:M in that column.

  LDB     (input) INTEGER
          The leading dimension of the array B. LDB >= max(1,M,N).

  JPVT    (input/output) INTEGER array, dimension (N)
          On entry, if JPVT(i) .ne. 0, the i-th column of A is an
          initial column, otherwise it is a free column.  Before
          the QR factorization of A, all initial columns are
          permuted to the leading positions; only the remaining
          free columns are moved as a result of column pivoting
          during the factorization.
          On exit, if JPVT(i) = k, then the i-th column of A*P
          was the k-th column of A.

  RCOND   (input) DOUBLE PRECISION
          RCOND is used to determine the effective rank of A, which
          is defined as the order of the largest leading triangular
          submatrix R11 in the QR factorization with pivoting of A,
          whose estimated condition number < 1/RCOND.

  RANK    (output) INTEGER
          The effective rank of A, i.e., the order of the submatrix
          R11.  This is the same as the order of the submatrix T11
          in the complete orthogonal factorization of A.

  WORK    (workspace) DOUBLE PRECISION array, dimension
                      (max( min(M,N)+3*N, 2*min(M,N)+NRHS )),

  INFO    (output) INTEGER
          = 0:  successful exit
          < 0:  if INFO = -i, the i-th argument had an illegal value    "));

      end dgelsx_vec;
        annotation (Documentation(info="<html>
<p>
This package contains external Modelica functions as interface to the
LAPACK library
(<a href=\"http://www.netlib.org/lapack\">http://www.netlib.org/lapack</a>)
that provides FORTRAN subroutines to solve linear algebra
tasks. Usually, these functions are not directly called, but only via
the much more convenient interface of
<a href=\"modelica://Modelica.Math.Matrices\">Modelica.Math.Matrices</a>.
The documentation of the LAPACK functions is a copy of the original
FORTRAN code. The details of LAPACK are described in:
</p>

<dl>
<dt>Anderson E., Bai Z., Bischof C., Blackford S., Demmel J., Dongarra J.,
    Du Croz J., Greenbaum A., Hammarling S., McKenney A., and Sorensen D.:</dt>
<dd> <a href=\"http://www.netlib.org/lapack/lug/lapack_lug.html\">Lapack Users' Guide</a>.
     Third Edition, SIAM, 1999.</dd>
</dl>

<p>
See also <a href=\"http://en.wikipedia.org/wiki/Lapack\">http://en.wikipedia.org/wiki/Lapack</a>.
</p>

<p>
This package contains a direct interface to the LAPACK subroutines
</p>

</html>"));
    end LAPACK;
    annotation (
      Documentation(info="<HTML>
<h4>Library content</h4>
<p>
This library provides functions operating on matrices. Below, the
functions are ordered according to categories and a typical
call of the respective function is shown.
Most functions are solely an interface to the external
<a href=\"modelica://Modelica.Math.Matrices.LAPACK\">LAPACK</a> library.
</p>

<p>
Note: A' is a short hand notation of transpose(A):
</p>

<p><b>Basic Information</b></p>
<ul>
<li> <a href=\"modelica://Modelica.Math.Matrices.toString\">toString</a>(A)
     - returns the string representation of matrix A.</li>

<li> <a href=\"modelica://Modelica.Math.Matrices.isEqual\">isEqual</a>(M1, M2)
     - returns true if matrices M1 and M2 have the same size and the same elements.</li>
</ul>

<p><b>Linear Equations</b></p>
<ul>
<li> <a href=\"modelica://Modelica.Math.Matrices.solve\">solve</a>(A,b)
     - returns solution x of the linear equation A*x=b (where b is a vector,
       and A is a square matrix that must be regular).</li>

<li> <a href=\"modelica://Modelica.Math.Matrices.solve2\">solve2</a>(A,B)
     - returns solution X of the linear equation A*X=B (where B is a matrix,
       and A is a square matrix that must be regular)</li>

<li> <a href=\"modelica://Modelica.Math.Matrices.leastSquares\">leastSquares</a>(A,b)
     - returns solution x of the linear equation A*x=b in a least squares sense
       (where b is a vector and A may be non-square and may be rank deficient)</li>

<li> <a href=\"modelica://Modelica.Math.Matrices.leastSquares2\">leastSquares2</a>(A,B)
     - returns solution X of the linear equation A*X=B in a least squares sense
       (where B is a matrix and A may be non-square and may be rank deficient)</li>

<li> <a href=\"modelica://Modelica.Math.Matrices.equalityLeastSquares\">equalityLeastSquares</a>(A,a,B,b)
     - returns solution x of a linear equality constrained least squares problem:
       min|A*x-a|^2 subject to B*x=b</<li>

<li> (LU,p,info) = <a href=\"modelica://Modelica.Math.Matrices.LU\">LU</a>(A)
     - returns the LU decomposition with row pivoting of a rectangular matrix A.</li>

<li> <a href=\"modelica://Modelica.Math.Matrices.LU_solve\">LU_solve</a>(LU,p,b)
     - returns solution x of the linear equation L*U*x[p]=b with a b
       vector and an LU decomposition from \"LU(..)\".</li>

<li> <a href=\"modelica://Modelica.Math.Matrices.LU_solve2\">LU_solve2</a>(LU,p,B)
     - returns solution X of the linear equation L*U*X[p,:]=B with a B
       matrix and an LU decomposition from \"LU(..)\".</li>
</ul>

<p><b>Matrix Factorizations</b></p>
<ul>
<li> (eval,evec) = <a href=\"modelica://Modelica.Math.Matrices.eigenValues\">eigenValues</a>(A)
     - returns eigen values \"eval\" and eigen vectors \"evec\" for a real,
       nonsymmetric matrix A in a Real representation.</li>

<li> <a href=\"modelica://Modelica.Math.Matrices.eigenValueMatrix\">eigenValueMatrix</a>(eval)
     - returns real valued block diagonal matrix of the eigenvalues \"eval\" of matrix A.</li>

<li> (sigma,U,VT) = <a href=\"modelica://Modelica.Math.Matrices.singularValues\">singularValues</a>(A)
     - returns singular values \"sigma\" and left and right singular vectors U and VT
       of a rectangular matrix A.</li>

<li> (Q,R,p) = <a href=\"modelica://Modelica.Math.Matrices.QR\">QR</a>(A)
     - returns the QR decomposition with column pivoting of a rectangular matrix A
       such that Q*R = A[:,p].</li>

<li> (H,U) = <a href=\"modelica://Modelica.Math.Matrices.hessenberg\">hessenberg</a>(A)
     - returns the upper Hessenberg form H and the orthogonal transformation matrix U
       of a square matrix A such that H = U'*A*U.</li>

<li> <a href=\"modelica://Modelica.Math.Matrices.realSchur\">realSchur</a>(A)
     - returns the real Schur form of a square matrix A.</li>

<li> <a href=\"modelica://Modelica.Math.Matrices.cholesky\">cholesky</a>(A)
     - returns the cholesky factor H of a real symmetric positive definite matrix A so that A = H'*H.</li>

<li> (D,Aimproved) = <a href=\"modelica://Modelica.Math.Matrices.balance\">balance</a>(A)
     - returns an improved form Aimproved of a square matrix A that has a smaller condition as A,
       with Aimproved = inv(diagonal(D))*A*diagonal(D).</li>
</ul>

<p><b>Matrix Properties</b></p>
<ul>
<li> <a href=\"modelica://Modelica.Math.Matrices.trace\">trace</a>(A)
     - returns the trace of square matrix A, i.e., the sum of the diagonal elements.</li>

<li> <a href=\"modelica://Modelica.Math.Matrices.det\">det</a>(A)
     - returns the determinant of square matrix A (using LU decomposition; try to avoid det(..))</li>

<li> <a href=\"modelica://Modelica.Math.Matrices.inv\">inv</a>(A)
     - returns the inverse of square matrix A (try to avoid, use instead \"solve2(..) with B=identity(..))</li>

<li> <a href=\"modelica://Modelica.Math.Matrices.rank\">rank</a>(A)
     - returns the rank of square matrix A (computed with singular value decomposition)</li>

<li> <a href=\"modelica://Modelica.Math.Matrices.conditionNumber\">conditionNumber</a>(A)
     - returns the condition number norm(A)*norm(inv(A)) of a square matrix A in the range 1..&infin;.</li>

<li> <a href=\"modelica://Modelica.Math.Matrices.rcond\">rcond</a>(A)
     - returns the reciprocal condition number 1/conditionNumber(A) of a square matrix A in the range 0..1.</li>

<li> <a href=\"modelica://Modelica.Math.Matrices.norm\">norm</a>(A)
     - returns the 1-, 2-, or infinity-norm of matrix A.</li>

<li> <a href=\"modelica://Modelica.Math.Matrices.frobeniusNorm\">frobeniusNorm</a>(A)
     - returns the Frobenius norm of matrix A.</li>

<li> <a href=\"modelica://Modelica.Math.Matrices.nullSpace\">nullSpace</a>(A)
     - returns the null space of matrix A.</li>
</ul>

<p><b>Matrix Exponentials</b></p>
<ul>
<li> <a href=\"modelica://Modelica.Math.Matrices.exp\">exp</a>(A)
     - returns the exponential e^A of a matrix A by adaptive Taylor series
       expansion with scaling and balancing</li>

<li> (phi, gamma) = <a href=\"modelica://Modelica.Math.Matrices.integralExp\">integralExp</a>(A,B)
     - returns the exponential phi=e^A and the integral gamma=integral(exp(A*t)*dt)*B as needed
       for a discretized system with zero order hold.</li>

<li> (phi, gamma, gamma1) = <a href=\"modelica://Modelica.Math.Matrices.integralExpT\">integralExpT</a>(A,B)
     - returns the exponential phi=e^A, the integral gamma=integral(exp(A*t)*dt)*B,
       and the time-weighted integral gamma1 = integral((T-t)*exp(A*t)*dt)*B as needed
       for a discretized system with first order hold.</li>
</ul>

<p><b>Matrix Equations</b></p>
<ul>
<li> <a href=\"modelica://Modelica.Math.Matrices.continuousLyapunov\">continuousLyapunov</a>(A,C)
     - returns solution X of the continuous-time Lyapunov equation X*A + A'*X = C</li>

<li> <a href=\"modelica://Modelica.Math.Matrices.continuousSylvester\">continuousSylvester</a>(A,B,C)
     - returns solution X of the continuous-time Sylvester equation A*X + X*B = C</li>

<li> <a href=\"modelica://Modelica.Math.Matrices.continuousRiccati\">continuousRiccati</a>(A,B,R,Q)
     - returns solution X of the continuous-time algebraic Riccat equation
       A'*X + X*A - X*B*inv(R)*B'*X + Q = 0</li>

<li> <a href=\"modelica://Modelica.Math.Matrices.discreteLyapunov\">discreteLyapunov</a>(A,C)
     - returns solution X of the discretes-time Lyapunov equation A'*X*A + sgn*X = C</li>

<li> <a href=\"modelica://Modelica.Math.Matrices.discreteSylvester\">discreteSylvester</a>(A,B,C)
     - returns solution X of the discrete-time Sylvester equation A*X*B + sgn*X = C</li>

<li> <a href=\"modelica://Modelica.Math.Matrices.discreteRiccati\">discreteRiccati</a>(A,B,R,Q)
     - returns solution X of the discrete-time algebraic Riccat equation
       A'*X*A - X - A'*X*B*inv(R + B'*X*B)*B'*X*A + Q = 0</li>
</ul>

<p><b>Matrix Manipulation</b></p>
<ul>
<li> <a href=\"modelica://Modelica.Math.Matrices.sort\">sort</a>(M)
     - returns the sorted rows or columns of matrix M in ascending or descending order.</li>

<li> <a href=\"modelica://Modelica.Math.Matrices.flipLeftRight\">flipLeftRight</a>(M)
     - returns matrix M so that the columns of M are flipped in left/right direction.</li>

<li> <a href=\"modelica://Modelica.Math.Matrices.flipUpDown\">flipUpDown</a>(M)
     - returns matrix M so that the rows of M are flipped in up/down direction.</li>
</ul>

<h4>See also</h4>
<a href=\"modelica://Modelica.Math.Vectors\">Vectors</a>

</HTML>
"));
  end Matrices;

  function cos "Cosine"
    extends baseIcon1;
    input SI.Angle u;
    output Real y;

  external "builtin" y=  cos(u);
    annotation (
      Icon(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Line(points={{-90,0},{68,0}}, color={192,192,192}),
          Polygon(
            points={{90,0},{68,8},{68,-8},{90,0}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
          Line(points={{-80,80},{-74.4,78.1},{-68.7,72.3},{-63.1,63},{-56.7,48.7},
                {-48.6,26.6},{-29.3,-32.5},{-22.1,-51.7},{-15.7,-65.3},{-10.1,-73.8},
                {-4.42,-78.8},{1.21,-79.9},{6.83,-77.1},{12.5,-70.6},{18.1,-60.6},
                {24.5,-45.7},{32.6,-23},{50.3,31.3},{57.5,50.7},{63.9,64.6},{69.5,
                73.4},{75.2,78.6},{80,80}}, color={0,0,0}),
          Text(
            extent={{-36,82},{36,34}},
            lineColor={192,192,192},
            textString="cos")}),
      Diagram(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Text(
            extent={{-103,72},{-83,88}},
            textString="1",
            lineColor={0,0,255}),
          Text(
            extent={{-103,-72},{-83,-88}},
            textString="-1",
            lineColor={0,0,255}),
          Text(
            extent={{70,25},{90,5}},
            textString="2*pi",
            lineColor={0,0,255}),
          Line(points={{-100,0},{84,0}}, color={95,95,95}),
          Polygon(
            points={{98,0},{82,6},{82,-6},{98,0}},
            lineColor={95,95,95},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),
          Line(
            points={{-80,80},{-74.4,78.1},{-68.7,72.3},{-63.1,63},{-56.7,48.7},{-48.6,
                26.6},{-29.3,-32.5},{-22.1,-51.7},{-15.7,-65.3},{-10.1,-73.8},{-4.42,
                -78.8},{1.21,-79.9},{6.83,-77.1},{12.5,-70.6},{18.1,-60.6},{24.5,
                -45.7},{32.6,-23},{50.3,31.3},{57.5,50.7},{63.9,64.6},{69.5,73.4},
                {75.2,78.6},{80,80}},
            color={0,0,255},
            thickness=0.5),
          Text(
            extent={{78,-6},{98,-26}},
            lineColor={95,95,95},
            textString="u"),
          Line(
            points={{-80,-80},{18,-80}},
            color={175,175,175},
            smooth=Smooth.None)}),
      Documentation(info="<html>
<p>
This function returns y = cos(u), with -&infin; &lt; u &lt; &infin;:
</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/Math/cos.png\">
</p>
</html>"),   Library="ModelicaExternalC");
  end cos;

  function tan "Tangent (u shall not be -pi/2, pi/2, 3*pi/2, ...)"
    extends baseIcon2;
    input SI.Angle u;
    output Real y;

  external "builtin" y=  tan(u);
    annotation (
      Icon(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Line(points={{-90,0},{68,0}}, color={192,192,192}),
          Polygon(
            points={{90,0},{68,8},{68,-8},{90,0}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
          Line(points={{-80,-80},{-78.4,-68.4},{-76.8,-59.7},{-74.4,-50},{-71.2,-40.9},
                {-67.1,-33},{-60.7,-24.8},{-51.1,-17.2},{-35.8,-9.98},{-4.42,-1.07},
                {33.4,9.12},{49.4,16.2},{59.1,23.2},{65.5,30.6},{70.4,39.1},{73.6,
                47.4},{76,56.1},{77.6,63.8},{80,80}}, color={0,0,0}),
          Text(
            extent={{-90,72},{-18,24}},
            lineColor={192,192,192},
            textString="tan")}),
      Diagram(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Text(
            extent={{-37,-72},{-17,-88}},
            textString="-5.8",
            lineColor={0,0,255}),
          Text(
            extent={{-33,86},{-13,70}},
            textString=" 5.8",
            lineColor={0,0,255}),
          Text(
            extent={{68,-13},{88,-33}},
            textString="1.4",
            lineColor={0,0,255}),
          Line(points={{-100,0},{84,0}}, color={95,95,95}),
          Polygon(
            points={{98,0},{82,6},{82,-6},{98,0}},
            lineColor={95,95,95},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),
          Line(
            points={{-80,-80},{-78.4,-68.4},{-76.8,-59.7},{-74.4,-50},{-71.2,-40.9},
                {-67.1,-33},{-60.7,-24.8},{-51.1,-17.2},{-35.8,-9.98},{-4.42,-1.07},
                {33.4,9.12},{49.4,16.2},{59.1,23.2},{65.5,30.6},{70.4,39.1},{73.6,
                47.4},{76,56.1},{77.6,63.8},{80,80}},
            color={0,0,255},
            thickness=0.5),
          Text(
            extent={{82,22},{102,2}},
            lineColor={95,95,95},
            textString="u"),
          Line(
            points={{0,80},{86,80}},
            color={175,175,175},
            smooth=Smooth.None),
          Line(
            points={{80,88},{80,-16}},
            color={175,175,175},
            smooth=Smooth.None)}),
      Documentation(info="<html>
<p>
This function returns y = tan(u), with -&infin; &lt; u &lt; &infin;
(if u is a multiple of (2n-1)*pi/2, y = tan(u) is +/- infinity).
</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/Math/tan.png\">
</p>
</html>"),   Library="ModelicaExternalC");
  end tan;

  function asin "Inverse sine (-1 <= u <= 1)"
    extends baseIcon2;
    input Real u;
    output SI.Angle y;

  external "builtin" y=  asin(u);
    annotation (
      Icon(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Line(points={{-90,0},{68,0}}, color={192,192,192}),
          Polygon(
            points={{90,0},{68,8},{68,-8},{90,0}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
          Line(points={{-80,-80},{-79.2,-72.8},{-77.6,-67.5},{-73.6,-59.4},{-66.3,
                -49.8},{-53.5,-37.3},{-30.2,-19.7},{37.4,24.8},{57.5,40.8},{68.7,
                52.7},{75.2,62.2},{77.6,67.5},{80,80}}, color={0,0,0}),
          Text(
            extent={{-88,78},{-16,30}},
            lineColor={192,192,192},
            textString="asin")}),
      Diagram(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Text(
            extent={{-40,-72},{-15,-88}},
            textString="-pi/2",
            lineColor={0,0,255}),
          Text(
            extent={{-38,88},{-13,72}},
            textString=" pi/2",
            lineColor={0,0,255}),
          Text(
            extent={{68,-9},{88,-29}},
            textString="+1",
            lineColor={0,0,255}),
          Text(
            extent={{-90,21},{-70,1}},
            textString="-1",
            lineColor={0,0,255}),
          Line(points={{-100,0},{84,0}}, color={95,95,95}),
          Polygon(
            points={{98,0},{82,6},{82,-6},{98,0}},
            lineColor={95,95,95},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),
          Line(
            points={{-80,-80},{-79.2,-72.8},{-77.6,-67.5},{-73.6,-59.4},{-66.3,-49.8},
                {-53.5,-37.3},{-30.2,-19.7},{37.4,24.8},{57.5,40.8},{68.7,52.7},{
                75.2,62.2},{77.6,67.5},{80,80}},
            color={0,0,255},
            thickness=0.5),
          Text(
            extent={{82,24},{102,4}},
            lineColor={95,95,95},
            textString="u"),
          Line(
            points={{0,80},{86,80}},
            color={175,175,175},
            smooth=Smooth.None),
          Line(
            points={{80,86},{80,-10}},
            color={175,175,175},
            smooth=Smooth.None)}),
      Documentation(info="<html>
<p>
This function returns y = asin(u), with -1 &le; u &le; +1:
</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/Math/asin.png\">
</p>
</html>"),   Library="ModelicaExternalC");
  end asin;

  function cosh "Hyperbolic cosine"
    extends baseIcon2;
    input Real u;
    output Real y;

  external "builtin" y=  cosh(u);
    annotation (
      Icon(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Line(points={{-90,-86.083},{68,-86.083}}, color={192,192,192}),
          Polygon(
            points={{90,-86.083},{68,-78.083},{68,-94.083},{90,-86.083}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
          Line(points={{-80,80},{-77.6,61.1},{-74.4,39.3},{-71.2,20.7},{-67.1,
                1.29},{-63.1,-14.6},{-58.3,-29.8},{-52.7,-43.5},{-46.2,-55.1},{-39,
                -64.3},{-30.2,-71.7},{-18.9,-77.1},{-4.42,-79.9},{10.9,-79.1},{
                23.7,-75.2},{34.2,-68.7},{42.2,-60.6},{48.6,-51.2},{54.3,-40},{
                59.1,-27.5},{63.1,-14.6},{67.1,1.29},{71.2,20.7},{74.4,39.3},{
                77.6,61.1},{80,80}}, color={0,0,0}),
          Text(
            extent={{4,66},{66,20}},
            lineColor={192,192,192},
            textString="cosh")}),
      Diagram(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Line(points={{-100,-84.083},{84,-84.083}}, color={95,95,95}),
          Polygon(
            points={{98,-84.083},{82,-78.083},{82,-90.083},{98,-84.083}},
            lineColor={95,95,95},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),
          Line(
            points={{-80,80},{-77.6,61.1},{-74.4,39.3},{-71.2,20.7},{-67.1,1.29},
                {-63.1,-14.6},{-58.3,-29.8},{-52.7,-43.5},{-46.2,-55.1},{-39,-64.3},
                {-30.2,-71.7},{-18.9,-77.1},{-4.42,-79.9},{10.9,-79.1},{23.7,-75.2},
                {34.2,-68.7},{42.2,-60.6},{48.6,-51.2},{54.3,-40},{59.1,-27.5},{
                63.1,-14.6},{67.1,1.29},{71.2,20.7},{74.4,39.3},{77.6,61.1},{80,
                80}},
            color={0,0,255},
            thickness=0.5),
          Text(
            extent={{-31,72},{-11,88}},
            textString="27",
            lineColor={0,0,255}),
          Text(
            extent={{64,-83},{84,-103}},
            textString="4",
            lineColor={0,0,255}),
          Text(
            extent={{-94,-63},{-74,-83}},
            textString="-4",
            lineColor={0,0,255}),
          Text(
            extent={{80,-60},{100,-80}},
            lineColor={95,95,95},
            textString="u"),
          Line(
            points={{0,80},{88,80}},
            color={175,175,175},
            smooth=Smooth.None),
          Line(
            points={{80,84},{80,-90}},
            color={175,175,175},
            smooth=Smooth.None)}),
      Documentation(info="<html>
<p>
This function returns y = cosh(u), with -&infin; &lt; u &lt; &infin;:
</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/Math/cosh.png\">
</p>
</html>"),   Library="ModelicaExternalC");
  end cosh;

  function tanh "Hyperbolic tangent"
    extends baseIcon2;
    input Real u;
    output Real y;

  external "builtin" y=  tanh(u);
    annotation (
      Icon(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}},
          grid={0.5,0.5}), graphics={
          Line(points={{-90,0},{68,0}}, color={192,192,192}),
          Polygon(
            points={{90,0},{68,8},{68,-8},{90,0}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
          Line(points={{-80,-80},{-47.8,-78.7},{-35.8,-75.7},{-27.7,-70.6},{-22.1,
                -64.2},{-17.3,-55.9},{-12.5,-44.3},{-7.64,-29.2},{-1.21,-4.82},{
                6.83,26.3},{11.7,42},{16.5,54.2},{21.3,63.1},{26.9,69.9},{34.2,75},
                {45.4,78.4},{72,79.9},{80,80}}, color={0,0,0}),
          Text(
            extent={{-88,72},{-16,24}},
            lineColor={192,192,192},
            textString="tanh")}),
      Diagram(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}},
          grid={0.5,0.5}), graphics={
          Line(points={{-100,0},{84,0}}, color={95,95,95}),
          Polygon(
            points={{96,0},{80,6},{80,-6},{96,0}},
            lineColor={95,95,95},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),
          Line(
            points={{-80,-80.5},{-47.8,-79.2},{-35.8,-76.2},{-27.7,-71.1},{-22.1,
                -64.7},{-17.3,-56.4},{-12.5,-44.8},{-7.64,-29.7},{-1.21,-5.32},{
                6.83,25.8},{11.7,41.5},{16.5,53.7},{21.3,62.6},{26.9,69.4},{34.2,
                74.5},{45.4,77.9},{72,79.4},{80,79.5}},
            color={0,0,255},
            thickness=0.5),
          Text(
            extent={{-29,72},{-9,88}},
            textString="1",
            lineColor={0,0,255}),
          Text(
            extent={{3,-72},{23,-88}},
            textString="-1",
            lineColor={0,0,255}),
          Text(
            extent={{82,-2},{102,-22}},
            lineColor={95,95,95},
            textString="u"),
          Line(
            points={{0,80},{88,80}},
            color={175,175,175},
            smooth=Smooth.None)}),
      Documentation(info="<html>
<p>
This function returns y = tanh(u), with -&infin; &lt; u &lt; &infin;:
</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/Math/tanh.png\">
</p>
</html>"),   Library="ModelicaExternalC");
  end tanh;

  function asinh "Inverse of sinh (area hyperbolic sine)"
    extends Modelica.Math.baseIcon2;
    input Real u;
    output Real y;

  algorithm
    y :=Modelica.Math.log(u + sqrt(u*u + 1));
    annotation (
      Icon(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Line(points={{-90,0},{68,0}}, color={192,192,192}),
          Polygon(
            points={{90,0},{68,8},{68,-8},{90,0}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
          Line(points={{-80,-80},{-56.7,-68.4},{-39.8,-56.8},{-26.9,-44.7},{-17.3,
                -32.4},{-9.25,-19},{9.25,19},{17.3,32.4},{26.9,44.7},{39.8,56.8},
                {56.7,68.4},{80,80}}, color={0,0,0}),
          Text(
            extent={{-90,80},{-6,26}},
            lineColor={192,192,192},
            textString="asinh")}),
      Diagram(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Line(points={{-100,0},{84,0}}, color={95,95,95}),
          Polygon(
            points={{98,0},{82,6},{82,-6},{98,0}},
            lineColor={95,95,95},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),
          Line(
            points={{-80,-80},{-56.7,-68.4},{-39.8,-56.8},{-26.9,-44.7},{-17.3,-32.4},
                {-9.25,-19},{9.25,19},{17.3,32.4},{26.9,44.7},{39.8,56.8},{56.7,
                68.4},{80,80}},
            color={0,0,255},
            thickness=0.5),
          Text(
            extent={{-31,72},{-11,88}},
            textString="2.31",
            lineColor={0,0,255}),
          Text(
            extent={{-35,-88},{-15,-72}},
            textString="-2.31",
            lineColor={0,0,255}),
          Text(
            extent={{72,-13},{92,-33}},
            textString="5",
            lineColor={0,0,255}),
          Text(
            extent={{-96,21},{-76,1}},
            textString="-5",
            lineColor={0,0,255}),
          Text(
            extent={{80,22},{100,2}},
            lineColor={95,95,95},
            textString="u"),
          Line(
            points={{0,80},{88,80}},
            color={175,175,175},
            smooth=Smooth.None),
          Line(
            points={{80,86},{80,-12}},
            color={175,175,175},
            smooth=Smooth.None)}),
      Documentation(info="<html>
<p>
The function returns the area hyperbolic sine of its
input argument u. This inverse of sinh(..) is unique
and there is no restriction on the input argument u of
asinh(u) (-&infin; &lt; u &lt; &infin;):
</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/Math/asinh.png\">
</p>
</html>"));
  end asinh;

  function exp "Exponential, base e"
    extends baseIcon2;
    input Real u;
    output Real y;

  external "builtin" y=  exp(u);
    annotation (
      Icon(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Line(points={{-90,-80.3976},{68,-80.3976}}, color={192,192,192}),
          Polygon(
            points={{90,-80.3976},{68,-72.3976},{68,-88.3976},{90,-80.3976}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
          Line(points={{-80,-80},{-31,-77.9},{-6.03,-74},{10.9,-68.4},{23.7,-61},
                {34.2,-51.6},{43,-40.3},{50.3,-27.8},{56.7,-13.5},{62.3,2.23},{
                67.1,18.6},{72,38.2},{76,57.6},{80,80}}, color={0,0,0}),
          Text(
            extent={{-86,50},{-14,2}},
            lineColor={192,192,192},
            textString="exp")}),
      Diagram(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Line(points={{-100,-80.3976},{84,-80.3976}}, color={95,95,95}),
          Polygon(
            points={{98,-80.3976},{82,-74.3976},{82,-86.3976},{98,-80.3976}},
            lineColor={95,95,95},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),
          Line(
            points={{-80,-80},{-31,-77.9},{-6.03,-74},{10.9,-68.4},{23.7,-61},{
                34.2,-51.6},{43,-40.3},{50.3,-27.8},{56.7,-13.5},{62.3,2.23},{
                67.1,18.6},{72,38.2},{76,57.6},{80,80}},
            color={0,0,255},
            thickness=0.5),
          Text(
            extent={{-31,72},{-11,88}},
            textString="20",
            lineColor={0,0,255}),
          Text(
            extent={{-92,-81},{-72,-101}},
            textString="-3",
            lineColor={0,0,255}),
          Text(
            extent={{66,-81},{86,-101}},
            textString="3",
            lineColor={0,0,255}),
          Text(
            extent={{2,-69},{22,-89}},
            textString="1",
            lineColor={0,0,255}),
          Text(
            extent={{78,-54},{98,-74}},
            lineColor={95,95,95},
            textString="u"),
          Line(
            points={{0,80},{88,80}},
            color={175,175,175},
            smooth=Smooth.None),
          Line(
            points={{80,84},{80,-84}},
            color={175,175,175},
            smooth=Smooth.None)}),
      Documentation(info="<html>
<p>
This function returns y = exp(u), with -&infin; &lt; u &lt; &infin;:
</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/Math/exp.png\">
</p>
</html>"),   Library="ModelicaExternalC");
  end exp;

  function log "Natural (base e) logarithm (u shall be > 0)"
    extends baseIcon1;
    input Real u;
    output Real y;

  external "builtin" y=  log(u);
    annotation (
      Icon(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Line(points={{-90,0},{68,0}}, color={192,192,192}),
          Polygon(
            points={{90,0},{68,8},{68,-8},{90,0}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
          Line(points={{-80,-80},{-79.2,-50.6},{-78.4,-37},{-77.6,-28},{-76.8,-21.3},
                {-75.2,-11.4},{-72.8,-1.31},{-69.5,8.08},{-64.7,17.9},{-57.5,28},
                {-47,38.1},{-31.8,48.1},{-10.1,58},{22.1,68},{68.7,78.1},{80,80}},
              color={0,0,0}),
          Text(
            extent={{-6,-24},{66,-72}},
            lineColor={192,192,192},
            textString="log")}),
      Diagram(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Line(points={{-100,0},{84,0}}, color={95,95,95}),
          Polygon(
            points={{100,0},{84,6},{84,-6},{100,0}},
            lineColor={95,95,95},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),
          Line(
            points={{-78,-80},{-77.2,-50.6},{-76.4,-37},{-75.6,-28},{-74.8,-21.3},
                {-73.2,-11.4},{-70.8,-1.31},{-67.5,8.08},{-62.7,17.9},{-55.5,28},
                {-45,38.1},{-29.8,48.1},{-8.1,58},{24.1,68},{70.7,78.1},{82,80}},
            color={0,0,255},
            thickness=0.5),
          Text(
            extent={{-105,72},{-85,88}},
            textString="3",
            lineColor={0,0,255}),
          Text(
            extent={{60,-3},{80,-23}},
            textString="20",
            lineColor={0,0,255}),
          Text(
            extent={{-78,-7},{-58,-27}},
            textString="1",
            lineColor={0,0,255}),
          Text(
            extent={{84,26},{104,6}},
            lineColor={95,95,95},
            textString="u"),
          Text(
            extent={{-100,9},{-80,-11}},
            textString="0",
            lineColor={0,0,255}),
          Line(
            points={{-80,80},{84,80}},
            color={175,175,175},
            smooth=Smooth.None),
          Line(
            points={{82,82},{82,-6}},
            color={175,175,175},
            smooth=Smooth.None)}),
      Documentation(info="<html>
<p>
This function returns y = log(10) (the natural logarithm of u),
with u &gt; 0:
</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/Math/log.png\">
</p>
</html>"),   Library="ModelicaExternalC");
  end log;

  partial function baseIcon1
    "Basic icon for mathematical function with y-axis on left side"

    annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
              -100},{100,100}}), graphics={
          Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Line(points={{-80,-80},{-80,68}}, color={192,192,192}),
          Polygon(
            points={{-80,90},{-88,68},{-72,68},{-80,90}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-150,150},{150,110}},
            textString="%name",
            lineColor={0,0,255})}),                          Diagram(
          coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
              100}}), graphics={
          Line(points={{-80,80},{-88,80}}, color={95,95,95}),
          Line(points={{-80,-80},{-88,-80}}, color={95,95,95}),
          Line(points={{-80,-90},{-80,84}}, color={95,95,95}),
          Text(
            extent={{-75,104},{-55,84}},
            lineColor={95,95,95},
            textString="y"),
          Polygon(
            points={{-80,98},{-86,82},{-74,82},{-80,98}},
            lineColor={95,95,95},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid)}),
      Documentation(info="<html>
<p>
Icon for a mathematical function, consisting of an y-axis on the left side.
It is expected, that an x-axis is added and a plot of the function.
</p>
</html>"));
  end baseIcon1;

  partial function baseIcon2
    "Basic icon for mathematical function with y-axis in middle"

    annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
              -100},{100,100}}), graphics={
          Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Line(points={{0,-80},{0,68}}, color={192,192,192}),
          Polygon(
            points={{0,90},{-8,68},{8,68},{0,90}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-150,150},{150,110}},
            textString="%name",
            lineColor={0,0,255})}),                          Diagram(graphics={
          Line(points={{0,80},{-8,80}}, color={95,95,95}),
          Line(points={{0,-80},{-8,-80}}, color={95,95,95}),
          Line(points={{0,-90},{0,84}}, color={95,95,95}),
          Text(
            extent={{5,104},{25,84}},
            lineColor={95,95,95},
            textString="y"),
          Polygon(
            points={{0,98},{-6,82},{6,82},{0,98}},
            lineColor={95,95,95},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid)}),
      Documentation(info="<html>
<p>
Icon for a mathematical function, consisting of an y-axis in the middle.
It is expected, that an x-axis is added and a plot of the function.
</p>
</html>"));
  end baseIcon2;
  annotation (
    Invisible=true,
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
        graphics={Text(
          extent={{-59,-9},{42,-56}},
          lineColor={0,0,0},
          textString="f(x)")}),
    Documentation(info="<HTML>
<p>
This package contains <b>basic mathematical functions</b> (such as sin(..)),
as well as functions operating on
<a href=\"modelica://Modelica.Math.Vectors\">vectors</a>,
<a href=\"modelica://Modelica.Math.Matrices\">matrices</a>,
<a href=\"modelica://Modelica.Math.Nonlinear\">nonlinear functions</a>, and
<a href=\"modelica://Modelica.Math.BooleanVectors\">Boolean vectors</a>.
</p>

<dl>
<dt><b>Main Authors:</b>
<dd><a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a> and
    Marcus Baur<br>
    Deutsches Zentrum f&uuml;r Luft und Raumfahrt e.V. (DLR)<br>
    Institut f&uuml;r Robotik und Mechatronik<br>
    Postfach 1116<br>
    D-82230 Wessling<br>
    Germany<br>
    email: <A HREF=\"mailto:Martin.Otter@dlr.de\">Martin.Otter@dlr.de</A><br>
</dl>

<p>
Copyright &copy; 1998-2010, Modelica Association and DLR.
</p>
<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"http://www.modelica.org/licenses/ModelicaLicense2\"> http://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>
</HTML>
",   revisions="<html>
<ul>
<li><i>October 21, 2002</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>
       and <a href=\"http://www.robotic.dlr.de/Christian.Schweiger/\">Christian Schweiger</a>:<br>
       Function tempInterpol2 added.</li>
<li><i>Oct. 24, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Icons for icon and diagram level introduced.</li>
<li><i>June 30, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Realized.</li>
</ul>

</html>"));
  end Math;

  package Utilities

  "Library of utility functions dedicated to scripting (operating on files, streams, strings, system)"
    extends Modelica.Icons.Package;

 package System "Interaction with environment"
      extends Modelica.Icons.Package;

    function getEnvironmentVariable "Get content of environment variable"
      //extends Modelica.Icons.Function;
      input String name "Name of environment variable";
      input Boolean convertToSlash =  false
          "True, if native directory separators in 'result' shall be changed to '/'";
      output String content
          "Content of environment variable (empty, if not existent)";
      output Boolean exist
          "= true, if environment variable exists; = false, if it does not exist";
      external "C" ModelicaInternal_getenv(name, convertToSlash, content, exist);
        annotation (Library="ModelicaExternalC",Documentation(info="<html>

</html>"));
    end getEnvironmentVariable;
    end System;

    package Streams "Read from files and write to files"
      extends Modelica.Icons.Package;

      function print "Print string to terminal or file"
        extends Modelica.Icons.Function;
        input String string="" "String to be printed";
        input String fileName=""
        "File where to print (empty string is the terminal)"
                     annotation(Dialog(__Dymola_saveSelector(filter="Text files (*.txt)",
                            caption="Text file to store the output of print(..)")));
      external "C" ModelicaInternal_print(string, fileName);
        annotation (Library="ModelicaExternalC",
      Documentation(info="<HTML>
<h4>Syntax</h4>
<blockquote><pre>
Streams.<b>print</b>(string);
Streams.<b>print</b>(string,fileName);
</pre></blockquote>
<h4>Description</h4>
<p>
Function <b>print</b>(..) opens automatically the given file, if
it is not yet open. If the file does not exist, it is created.
If the file does exist, the given string is appended to the file.
If this is not desired, call \"Files.remove(fileName)\" before calling print
(\"remove(..)\" is silent, if the file does not exist).
The Modelica environment may close the file whenever appropriate.
This can be enforced by calling <b>Streams.close</b>(fileName).
After every call of \"print(..)\" a \"new line\" is printed automatically.
</p>
<h4>Example</h4>
<blockquote><pre>
  Streams.print(\"x = \" + String(x));
  Streams.print(\"y = \" + String(y));
  Streams.print(\"x = \" + String(y), \"mytestfile.txt\");
</pre></blockquote>
<p>
<h4>See also</h4>
<p>
<a href=\"modelica://Modelica.Utilities.Streams\">Streams</a>,
<a href=\"modelica://Modelica.Utilities.Streams.error\">Streams.error</a>,
<a href=\"modelica://ModelicaReference.Operators.string\">String</a>
</p>
</HTML>"));
      end print;

      function error "Print error message and cancel all actions"
        extends Modelica.Icons.Function;
        input String string "String to be printed to error message window";
        external "C" ModelicaError(string);
        annotation (Library="ModelicaExternalC",
      Documentation(info="<html>
<h4>Syntax</h4>
<blockquote><pre>
Streams.<b>error</b>(string);
</pre></blockquote>
<h4>Description</h4>
<p>
Print the string \"string\" as error message and
cancel all actions. Line breaks are characterized
by \"\\n\" in the string.
</p>
<h4>Example</h4>
<blockquote><pre>
  Streams.error(\"x (= \" + String(x) + \")\\nhas to be in the range 0 .. 1\");
</pre></blockquote>
<h4>See also</h4>
<p>
<a href=\"modelica://Modelica.Utilities.Streams\">Streams</a>,
<a href=\"modelica://Modelica.Utilities.Streams.print\">Streams.print</a>,
<a href=\"modelica://ModelicaReference.Operators.string\">String</a>
</p>
</html>"));
      end error;
      annotation (
        Documentation(info="<HTML>
<h4>Library content</h4>
<p>
Package <b>Streams</b> contains functions to input and output strings
to a message window or on files. Note that a string is interpreted
and displayed as html text (e.g., with print(..) or error(..))
if it is enclosed with the Modelica html quotation, e.g.,
</p>
<center>
string = \"&lt;html&gt; first line &lt;br&gt; second line &lt;/html&gt;\".
</center>
<p>
It is a quality of implementation, whether (a) all tags of html are supported
or only a subset, (b) how html tags are interpreted if the output device
does not allow to display formatted text.
</p>
<p>
In the table below an example call to every function is given:
</p>
<table border=1 cellspacing=0 cellpadding=2>
  <tr><th><b><i>Function/type</i></b></th><th><b><i>Description</i></b></th></tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Utilities.Streams.print\">print</a>(string)<br>
          <a href=\"modelica://Modelica.Utilities.Streams.print\">print</a>(string,fileName)</td>
      <td valign=\"top\"> Print string \"string\" or vector of strings to message window or on
           file \"fileName\".</td>
  </tr>
  <tr><td valign=\"top\">stringVector =
         <a href=\"modelica://Modelica.Utilities.Streams.readFile\">readFile</a>(fileName)</td>
      <td valign=\"top\"> Read complete text file and return it as a vector of strings.</td>
  </tr>
  <tr><td valign=\"top\">(string, endOfFile) =
         <a href=\"modelica://Modelica.Utilities.Streams.readLine\">readLine</a>(fileName, lineNumber)</td>
      <td valign=\"top\">Returns from the file the content of line lineNumber.</td>
  </tr>
  <tr><td valign=\"top\">lines =
         <a href=\"modelica://Modelica.Utilities.Streams.countLines\">countLines</a>(fileName)</td>
      <td valign=\"top\">Returns the number of lines in a file.</td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Utilities.Streams.error\">error</a>(string)</td>
      <td valign=\"top\"> Print error message \"string\" to message window
           and cancel all actions</td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Utilities.Streams.close\">close</a>(fileName)</td>
      <td valign=\"top\"> Close file if it is still open. Ignore call if
           file is already closed or does not exist. </td>
  </tr>
</table>
<p>
Use functions <b>scanXXX</b> from package
<a href=\"modelica://Modelica.Utilities.Strings\">Strings</a>
to parse a string.
</p>
<p>
If Real, Integer or Boolean values shall be printed
or used in an error message, they have to be first converted
to strings with the builtin operator
<a href=\"modelica://ModelicaReference.Operators.string\">String</a>(...).
Example:
</p>
<pre>
  <b>if</b> x &lt; 0 <b>or</b> x &gt; 1 <b>then</b>
     Streams.error(\"x (= \" + String(x) + \") has to be in the range 0 .. 1\");
  <b>end if</b>;
</pre>
</HTML>
"));
    end Streams;

    package Strings "Operations on strings"
      extends Modelica.Icons.Package;

      function compare "Compare two strings lexicographically"
        extends Modelica.Icons.Function;
        input String string1;
        input String string2;
        input Boolean caseSensitive=true
        "= false, if case of letters is ignored";
        output Modelica.Utilities.Types.Compare result "Result of comparison";
      external "C" result = ModelicaStrings_compare(string1, string2, caseSensitive);
        annotation (Library="ModelicaExternalC", Documentation(info="<html>
<h4>Syntax</h4>
<blockquote><pre>
result = Strings.<b>compare</b>(string1, string2);
result = Strings.<b>compare</b>(string1, string2, caseSensitive=true);
</pre></blockquote>
<h4>Description</h4>
<p>
Compares two strings. If the optional argument caseSensitive=false,
upper case letters are treated as if they would be lower case letters.
The result of the comparison is returned as:
</p>
<pre>
  result = Modelica.Utilities.Types.Compare.Less     // string1 &lt; string2
         = Modelica.Utilities.Types.Compare.Equal    // string1 = string2
         = Modelica.Utilities.Types.Compare.Greater  // string1 &gt; string2
</pre>
<p>
Comparison is with regards to lexicographical order,
e.g., \"a\" &lt; \"b\";
</p>
</html>"));
      end compare;

      function isEqual "Determine whether two strings are identical"
        extends Modelica.Icons.Function;
        input String string1;
        input String string2;
        input Boolean caseSensitive=true
        "= false, if lower and upper case are ignored for the comparison";
        output Boolean identical "True, if string1 is identical to string2";
      algorithm
        identical :=compare(string1, string2, caseSensitive) == Types.Compare.Equal;
        annotation (
      Documentation(info="<html>
<h4>Syntax</h4>
<blockquote><pre>
Strings.<b>isEqual</b>(string1, string2);
Strings.<b>isEqual</b>(string1, string2, caseSensitive=true);
</pre></blockquote>
<h4>Description</h4>
<p>
Compare whether two strings are identical,
optionally ignoring case.
</p>
</html>"));
      end isEqual;
      annotation (
        Documentation(info="<HTML>
<h4>Library content</h4>
<p>
Package <b>Strings</b> contains functions to manipulate strings.
</p>
<p>
In the table below an example
call to every function is given using the <b>default</b> options.
</p>
<table border=1 cellspacing=0 cellpadding=2>
  <tr><th><b><i>Function</i></b></th><th><b><i>Description</i></b></th></tr>
  <tr><td valign=\"top\">len = <a href=\"modelica://Modelica.Utilities.Strings.length\">length</a>(string)</td>
      <td valign=\"top\">Returns length of string</td></tr>
  <tr><td valign=\"top\">string2 = <a href=\"modelica://Modelica.Utilities.Strings.substring\">substring</a>(string1,startIndex,endIndex)
       </td>
      <td valign=\"top\">Returns a substring defined by start and end index</td></tr>
  <tr><td valign=\"top\">result = <a href=\"modelica://Modelica.Utilities.Strings.repeat\">repeat</a>(n)<br>
 result = <a href=\"modelica://Modelica.Utilities.Strings.repeat\">repeat</a>(n,string)</td>
      <td valign=\"top\">Repeat a blank or a string n times.</td></tr>
  <tr><td valign=\"top\">result = <a href=\"modelica://Modelica.Utilities.Strings.compare\">compare</a>(string1, string2)</td>
      <td valign=\"top\">Compares two substrings with regards to alphabetical order</td></tr>
  <tr><td valign=\"top\">identical =
<a href=\"modelica://Modelica.Utilities.Strings.isEqual\">isEqual</a>(string1,string2)</td>
      <td valign=\"top\">Determine whether two strings are identical</td></tr>
  <tr><td valign=\"top\">result = <a href=\"modelica://Modelica.Utilities.Strings.count\">count</a>(string,searchString)</td>
      <td valign=\"top\">Count the number of occurrences of a string</td></tr>
  <tr>
<td valign=\"top\">index = <a href=\"modelica://Modelica.Utilities.Strings.find\">find</a>(string,searchString)</td>
      <td valign=\"top\">Find first occurrence of a string in another string</td></tr>
<tr>
<td valign=\"top\">index = <a href=\"modelica://Modelica.Utilities.Strings.findLast\">findLast</a>(string,searchString)</td>
      <td valign=\"top\">Find last occurrence of a string in another string</td></tr>
  <tr><td valign=\"top\">string2 = <a href=\"modelica://Modelica.Utilities.Strings.replace\">replace</a>(string,searchString,replaceString)</td>
      <td valign=\"top\">Replace one or all occurrences of a string</td></tr>
  <tr><td valign=\"top\">stringVector2 = <a href=\"modelica://Modelica.Utilities.Strings.sort\">sort</a>(stringVector1)</td>
      <td valign=\"top\">Sort vector of strings in alphabetic order</td></tr>
  <tr><td valign=\"top\">(token, index) = <a href=\"modelica://Modelica.Utilities.Strings.scanToken\">scanToken</a>(string,startIndex)</td>
      <td valign=\"top\">Scan for a token (Real/Integer/Boolean/String/Identifier/Delimiter/NoToken)</td></tr>
  <tr><td valign=\"top\">(number, index) = <a href=\"modelica://Modelica.Utilities.Strings.scanReal\">scanReal</a>(string,startIndex)</td>
      <td valign=\"top\">Scan for a Real constant</td></tr>
  <tr><td valign=\"top\">(number, index) = <a href=\"modelica://Modelica.Utilities.Strings.scanInteger\">scanInteger</a>(string,startIndex)</td>
      <td valign=\"top\">Scan for an Integer constant</td></tr>
  <tr><td valign=\"top\">(boolean, index) = <a href=\"modelica://Modelica.Utilities.Strings.scanBoolean\">scanBoolean</a>(string,startIndex)</td>
      <td valign=\"top\">Scan for a Boolean constant</td></tr>
  <tr><td valign=\"top\">(string2, index) = <a href=\"modelica://Modelica.Utilities.Strings.scanString\">scanString</a>(string,startIndex)</td>
      <td valign=\"top\">Scan for a String constant</td></tr>
  <tr><td valign=\"top\">(identifier, index) = <a href=\"modelica://Modelica.Utilities.Strings.scanIdentifier\">scanIdentifier</a>(string,startIndex)</td>
      <td valign=\"top\">Scan for an identifier</td></tr>
  <tr><td valign=\"top\">(delimiter, index) = <a href=\"modelica://Modelica.Utilities.Strings.scanDelimiter\">scanDelimiter</a>(string,startIndex)</td>
      <td valign=\"top\">Scan for delimiters</td></tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Utilities.Strings.scanNoToken\">scanNoToken</a>(string,startIndex)</td>
      <td valign=\"top\">Check that remaining part of string consists solely of <br>
          white space or line comments (\"// ...\\n\").</td></tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Utilities.Strings.syntaxError\">syntaxError</a>(string,index,message)</td>
      <td valign=\"top\"> Print a \"syntax error message\" as well as a string and the <br>
           index at which scanning detected an error</td></tr>
</table>
<p>
The functions \"compare\", \"isEqual\", \"count\", \"find\", \"findLast\", \"replace\", \"sort\"
have the optional
input argument <b>caseSensitive</b> with default <b>true</b>.
If <b>false</b>, the operation is carried out without taking
into account whether a character is upper or lower case.
</p>
</HTML>"));
    end Strings;

    package Types "Type definitions used in package Modelica.Utilities"
      extends Modelica.Icons.Package;

      type Compare = enumeration(
        Less "String 1 is lexicographically less than string 2",
        Equal "String 1 is identical to string 2",
        Greater "String 1 is lexicographically greater than string 2")
      "Enumeration defining comparision of two strings";
      annotation (Documentation(info="<html>
<p>
This package contains type definitions used in Modelica.Utilities.
</p>

</html>"));
    end Types;
      annotation (
  Documentation(info="<html>
<p>
This package contains Modelica <b>functions</b> that are
especially suited for <b>scripting</b>. The functions might
be used to work with strings, read data from file, write data
to file or copy, move and remove files.
</p>
<p>
For an introduction, have especially a look at:
</p>
<ul>
<li> <a href=\"modelica://Modelica.Utilities.UsersGuide\">Modelica.Utilities.User's Guide</a>
     discusses the most important aspects of this library.</li>
<li> <a href=\"modelica://Modelica.Utilities.Examples\">Modelica.Utilities.Examples</a>
     contains examples that demonstrate the usage of this library.</li>
</ul>
<p>
The following main sublibraries are available:
</p>
<ul>
<li> <a href=\"modelica://Modelica.Utilities.Files\">Files</a>
     provides functions to operate on files and directories, e.g.,
     to copy, move, remove files.</li>
<li> <a href=\"modelica://Modelica.Utilities.Streams\">Streams</a>
     provides functions to read from files and write to files.</li>
<li> <a href=\"modelica://Modelica.Utilities.Strings\">Strings</a>
     provides functions to operate on strings. E.g.
     substring, find, replace, sort, scanToken.</li>
<li> <a href=\"modelica://Modelica.Utilities.System\">System</a>
     provides functions to interact with the environment.
     E.g., get or set the working directory or environment
     variables and to send a command to the default shell.</li>
</ul>

<p>
Copyright &copy; 1998-2010, Modelica Association, DLR, and Dassault Syst&egrave;mes AB.
</p>

<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"http://www.modelica.org/licenses/ModelicaLicense2\"> http://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>

</html>
"));
  end Utilities;

  package Constants
  "Library of mathematical constants and constants of nature (e.g., pi, eps, R, sigma)"
    import SI = Modelica.SIunits;
    import NonSI = Modelica.SIunits.Conversions.NonSIunits;
    extends Modelica.Icons.Package;

    final constant Real pi=2*Modelica.Math.asin(1.0);

    final constant Real eps=1.e-15 "Biggest number such that 1.0 + eps = 1.0";

    final constant Real small=1.e-60
    "Smallest number such that small and -small are representable on the machine";

    final constant Real inf=1.e+60
    "Biggest Real number such that inf and -inf are representable on the machine";

    final constant SI.Acceleration g_n=9.80665
    "Standard acceleration of gravity on earth";

    final constant Real R(final unit="J/(mol.K)") = 8.314472
    "Molar gas constant";

    final constant NonSI.Temperature_degC T_zero=-273.15
    "Absolute zero temperature";
    annotation (
      Documentation(info="<html>
<p>
This package provides often needed constants from mathematics, machine
dependent constants and constants from nature. The latter constants
(name, value, description) are from the following source:
</p>

<dl>
<dt>Peter J. Mohr and Barry N. Taylor (1999):</dt>
<dd><b>CODATA Recommended Values of the Fundamental Physical Constants: 1998</b>.
    Journal of Physical and Chemical Reference Data, Vol. 28, No. 6, 1999 and
    Reviews of Modern Physics, Vol. 72, No. 2, 2000. See also <a href=
\"http://physics.nist.gov/cuu/Constants/\">http://physics.nist.gov/cuu/Constants/</a></dd>
</dl>

<p>CODATA is the Committee on Data for Science and Technology.</p>

<dl>
<dt><b>Main Author:</b></dt>
<dd><a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a><br>
    Deutsches Zentrum f&uuml;r Luft und Raumfahrt e. V. (DLR)<br>
    Oberpfaffenhofen<br>
    Postfach 11 16<br>
    D-82230 We&szlig;ling<br>
    email: <a href=\"mailto:Martin.Otter@dlr.de\">Martin.Otter@dlr.de</a></dd>
</dl>

<p>
Copyright &copy; 1998-2010, Modelica Association and DLR.
</p>
<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"http://www.modelica.org/licenses/ModelicaLicense2\"> http://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>
</html>
",   revisions="<html>
<ul>
<li><i>Nov 8, 2004</i>
       by <a href=\"http://www.robotic.dlr.de/Christian.Schweiger/\">Christian Schweiger</a>:<br>
       Constants updated according to 2002 CODATA values.</li>
<li><i>Dec 9, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Constants updated according to 1998 CODATA values. Using names, values
       and description text from this source. Included magnetic and
       electric constant.</li>
<li><i>Sep 18, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Constants eps, inf, small introduced.</li>
<li><i>Nov 15, 1997</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Realized.</li>
</ul>
</html>"),
      Invisible=true,
      Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
              100}}), graphics={
          Line(
            points={{-34,-38},{12,-38}},
            color={0,0,0},
            thickness=0.5),
          Line(
            points={{-20,-38},{-24,-48},{-28,-56},{-34,-64}},
            color={0,0,0},
            thickness=0.5),
          Line(
            points={{-2,-38},{2,-46},{8,-56},{14,-64}},
            color={0,0,0},
            thickness=0.5)}),
      Diagram(graphics={
          Rectangle(
            extent={{200,162},{380,312}},
            fillColor={235,235,235},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,255}),
          Polygon(
            points={{200,312},{220,332},{400,332},{380,312},{200,312}},
            fillColor={235,235,235},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,255}),
          Polygon(
            points={{400,332},{400,182},{380,162},{380,312},{400,332}},
            fillColor={235,235,235},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,255}),
          Text(
            extent={{210,302},{370,272}},
            lineColor={160,160,164},
            textString="Library"),
          Line(
            points={{266,224},{312,224}},
            color={0,0,0},
            thickness=1),
          Line(
            points={{280,224},{276,214},{272,206},{266,198}},
            color={0,0,0},
            thickness=1),
          Line(
            points={{298,224},{302,216},{308,206},{314,198}},
            color={0,0,0},
            thickness=1),
          Text(
            extent={{152,412},{458,334}},
            lineColor={255,0,0},
            textString="Modelica.Constants")}));
  end Constants;

  package Icons "Library of icons"
    extends Icons.Package;

    partial package ExamplesPackage
    "Icon for packages containing runnable examples"
    //extends Modelica.Icons.Package;
      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics={Rectangle(
              extent={{-80,100},{100,-80}},
              lineColor={0,0,0},
              fillColor={215,230,240},
              fillPattern=FillPattern.Solid), Rectangle(
              extent={{-100,80},{80,-100}},
              lineColor={0,0,0},
              fillColor={240,240,240},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{-58,46},{42,-14},{-58,-74},{-58,46}},
              lineColor={0,0,255},
              pattern=LinePattern.None,
              fillColor={95,95,95},
              fillPattern=FillPattern.Solid)}), Documentation(info="<html>
<p>This icon indicates a package that contains executable examples.</p>
</html>"));
    end ExamplesPackage;

    partial model Example "Icon for runnable examples"

      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics={Ellipse(extent={{-100,100},{100,-100}},
                lineColor={95,95,95},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
                                       Polygon(
              points={{-36,60},{64,0},{-36,-60},{-36,60}},
              lineColor={0,0,255},
              pattern=LinePattern.None,
              fillColor={95,95,95},
              fillPattern=FillPattern.Solid)}), Documentation(info="<html>
<p>This icon indicates an example. The play button suggests that the example can be executed.</p>
</html>"));
    end Example;

    partial package Package "Icon for standard packages"

      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics={Rectangle(
              extent={{-80,100},{100,-80}},
              lineColor={0,0,0},
              fillColor={215,230,240},
              fillPattern=FillPattern.Solid), Rectangle(
              extent={{-100,80},{80,-100}},
              lineColor={0,0,0},
              fillColor={240,240,240},
              fillPattern=FillPattern.Solid)}),
                                Documentation(info="<html>
<p>Standard package icon.</p>
</html>"));
    end Package;

    partial package BasesPackage "Icon for packages containing base classes"
    //extends Modelica.Icons.Package;
      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics={Rectangle(
              extent={{-80,100},{100,-80}},
              lineColor={0,0,0},
              fillColor={215,230,240},
              fillPattern=FillPattern.Solid), Rectangle(
              extent={{-100,80},{80,-100}},
              lineColor={0,0,0},
              fillColor={240,240,240},
              fillPattern=FillPattern.Solid),
            Ellipse(
              extent={{-30,10},{10,-30}},
              lineColor={0,0,0},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid)}),
                                Documentation(info="<html>
<p>This icon shall be used for a package/library that contains base models and classes, respectively.</p>
</html>"));
    end BasesPackage;

    partial package VariantsPackage "Icon for package containing variants"
    //extends Modelica.Icons.Package;
      annotation (Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},
                {100,100}}),       graphics={Rectangle(
              extent={{-80,100},{100,-80}},
              lineColor={0,0,0},
              fillColor={215,230,240},
              fillPattern=FillPattern.Solid), Rectangle(
              extent={{-100,80},{80,-100}},
              lineColor={0,0,0},
              fillColor={240,240,240},
              fillPattern=FillPattern.Solid),
            Ellipse(
              extent={{-80,-20},{-20,-80}},
              lineColor={0,0,0},
              fillColor={135,135,135},
              fillPattern=FillPattern.Solid),
            Ellipse(
              extent={{0,-20},{60,-80}},
              lineColor={0,0,0},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid),
            Ellipse(
              extent={{0,60},{60,0}},
              lineColor={0,0,0},
              fillColor={175,175,175},
              fillPattern=FillPattern.Solid),
            Ellipse(
              extent={{-80,60},{-20,0}},
              lineColor={0,0,0},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid)}),
                                Documentation(info="<html>
<p>This icon shall be used for a package/library that contains several variants of one components.</p>
</html>"));
    end VariantsPackage;

    partial package InterfacesPackage "Icon for packages containing interfaces"
    //extends Modelica.Icons.Package;
      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics={Rectangle(
              extent={{-80,100},{100,-80}},
              lineColor={0,0,0},
              fillColor={215,230,240},
              fillPattern=FillPattern.Solid), Rectangle(
              extent={{-100,80},{80,-100}},
              lineColor={0,0,0},
              fillColor={240,240,240},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{0,50},{20,50},{50,10},{80,10},{80,-30},{50,-30},{20,-70},{
                  0,-70},{0,50}},
              lineColor={0,0,0},
              smooth=Smooth.None,
              fillColor={215,215,215},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{-100,10},{-70,10},{-40,50},{-20,50},{-20,-70},{-40,-70},{
                  -70,-30},{-100,-30},{-100,10}},
              lineColor={0,0,0},
              smooth=Smooth.None,
              fillColor={215,230,240},
              fillPattern=FillPattern.Solid)}),
                                Documentation(info="<html>
<p>This icon indicates packages containing interfaces.</p>
</html>"));
    end InterfacesPackage;

    partial package SourcesPackage "Icon for packages containing sources"
    //extends Modelica.Icons.Package;
      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics={Rectangle(
              extent={{-80,100},{100,-80}},
              lineColor={0,0,0},
              fillColor={215,230,240},
              fillPattern=FillPattern.Solid), Rectangle(
              extent={{-100,80},{80,-100}},
              lineColor={0,0,0},
              fillColor={240,240,240},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{-28,12},{-28,-40},{36,-14},{-28,12}},
              lineColor={0,0,0},
              smooth=Smooth.None,
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Line(
              points={{-28,-14},{-68,-14}},
              color={0,0,0},
              smooth=Smooth.None)}),
                                Documentation(info="<html>
<p>This icon indicates a package which contains sources.</p>
</html>"));
    end SourcesPackage;

    partial package SensorsPackage "Icon for packages containing sensors"
    //extends Modelica.Icons.Package;
      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics={Rectangle(
              extent={{-80,100},{100,-80}},
              lineColor={0,0,0},
              fillColor={215,230,240},
              fillPattern=FillPattern.Solid), Rectangle(
              extent={{-100,80},{80,-100}},
              lineColor={0,0,0},
              fillColor={240,240,240},
              fillPattern=FillPattern.Solid),
            Line(
              points={{-70,20},{50,20}},
              color={0,0,0},
              smooth=Smooth.None),
            Line(points={{-10,-70},{38,54}}, color={0,0,0}),
            Ellipse(
              extent={{-15,-65},{-5,-75}},
              lineColor={0,0,0},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid),
            Line(
              points={{-70,20},{-70,-8}},
              color={0,0,0},
              smooth=Smooth.None),
            Line(
              points={{50,20},{50,-8}},
              color={0,0,0},
              smooth=Smooth.None),
            Line(
              points={{-10,20},{-10,-8}},
              color={0,0,0},
              smooth=Smooth.None)}),
                                Documentation(info="<html>
<p>This icon indicates a package containing sensors.</p>
</html>"));
    end SensorsPackage;

    partial class RotationalSensor
    "Icon representing a round measurement device"

      annotation (
        Icon(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={1,1}), graphics={
            Ellipse(
              extent={{-70,70},{70,-70}},
              lineColor={0,0,0},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Line(points={{0,70},{0,40}}, color={0,0,0}),
            Line(points={{22.9,32.8},{40.2,57.3}}, color={0,0,0}),
            Line(points={{-22.9,32.8},{-40.2,57.3}}, color={0,0,0}),
            Line(points={{37.6,13.7},{65.8,23.9}}, color={0,0,0}),
            Line(points={{-37.6,13.7},{-65.8,23.9}}, color={0,0,0}),
            Line(points={{0,0},{9.02,28.6}}, color={0,0,0}),
            Polygon(
              points={{-0.48,31.6},{18,26},{18,57.2},{-0.48,31.6}},
              lineColor={0,0,0},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid),
            Ellipse(
              extent={{-5,5},{5,-5}},
              lineColor={0,0,0},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid)}),
        Diagram(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={1,1}), graphics),
        Documentation(info="<html>
<p>
This icon is designed for a <b>rotational sensor</b> model.
</p>
</html>"));
    end RotationalSensor;

    partial package MaterialPropertiesPackage
    "Icon for package containing property classes"
    //extends Modelica.Icons.Package;
      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics={Rectangle(
              extent={{-80,100},{100,-80}},
              lineColor={0,0,0},
              fillColor={215,230,240},
              fillPattern=FillPattern.Solid), Rectangle(
              extent={{-100,80},{80,-100}},
              lineColor={0,0,0},
              fillColor={240,240,240},
              fillPattern=FillPattern.Solid),
            Ellipse(
              extent={{-68,50},{52,-70}},
              lineColor={0,0,0},
              fillPattern=FillPattern.Sphere,
              fillColor={215,230,240})}),
                                Documentation(info="<html>
<p>This icon indicates a package that contains properties</p>
</html>"));
    end MaterialPropertiesPackage;

    partial function Function "Icon for functions"

      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics={
            Text(extent={{-140,162},{136,102}}, textString=
                                                   "%name"),
            Ellipse(
              extent={{-100,100},{100,-100}},
              lineColor={255,127,0},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Text(
              extent={{-100,100},{100,-100}},
              lineColor={255,127,0},
              textString=
                   "f")}),Documentation(Error, info="<html>
<p>This icon indicates Modelica functions.</p>
</html>"));
    end Function;

    partial record Record "Icon for records"

      annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                -100},{100,100}}), graphics={
            Rectangle(
              extent={{-100,50},{100,-100}},
              fillColor={255,255,127},
              fillPattern=FillPattern.Solid,
              lineColor={0,0,255}),
            Text(
              extent={{-127,115},{127,55}},
              textString="%name",
              lineColor={0,0,255}),
            Line(points={{-100,-50},{100,-50}}, color={0,0,0}),
            Line(points={{-100,0},{100,0}}, color={0,0,0}),
            Line(points={{0,50},{0,-100}}, color={0,0,0})}),
                                                          Documentation(info="<html>
<p>
This icon is indicates a record.
</p>
</html>"));
    end Record;
    annotation(Documentation(__Dymola_DocumentationClass=true, info="<html>
<p>This package contains definitions for the graphical layout of components which may be used in different libraries. The icons can be utilized by inheriting them in the desired class using &quot;extends&quot; or by directly copying the &quot;icon&quot; layer. </p>
<dl>
<dt><b>Main Authors:</b> </dt>
    <dd><a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a></dd><dd>Deutsches Zentrum fuer Luft und Raumfahrt e.V. (DLR)</dd><dd>Oberpfaffenhofen</dd><dd>Postfach 1116</dd><dd>D-82230 Wessling</dd><dd>email: <a href=\"mailto:Martin.Otter@dlr.de\">Martin.Otter@dlr.de</a></dd><br>
    <dd>Christian Kral</dd><dd><a href=\"http://www.ait.ac.at/\">Austrian Institute of Technology, AIT</a></dd><dd>Mobility Department</dd><dd>Giefinggasse 2</dd><dd>1210 Vienna, Austria</dd><dd>email: <a href=\"mailto:christian.kral@ait.ac.at\">christian.kral@ait.ac.at</a></dd><br>
    <dd align=\"justify\">Johan Andreasson</dd><dd align=\"justify\"><a href=\"http://www.modelon.se/\">Modelon AB</a></dd><dd align=\"justify\">Ideon Science Park</dd><dd align=\"justify\">22370 Lund, Sweden</dd><dd align=\"justify\">email: <a href=\"mailto:johan.andreasson@modelon.se\">johan.andreasson@modelon.se</a></dd>
</dl>
<p>Copyright &copy; 1998-2010, Modelica Association, DLR, AIT, and Modelon AB. </p>
<p><i>This Modelica package is <b>free</b> software; it can be redistributed and/or modified under the terms of the <b>Modelica license</b>, see the license conditions and the accompanying <b>disclaimer</b> in <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a>.</i> </p>
</html>"));
  end Icons;

  package SIunits
  "Library of type and unit definitions based on SI units according to ISO 31-1992"
    extends Modelica.Icons.Package;

    package Conversions
    "Conversion functions to/from non SI units and type definitions of non SI units"
      extends Modelica.Icons.Package;

      package NonSIunits "Type definitions of non SI units"
        extends Modelica.Icons.Package;

        type Temperature_degC = Real (final quantity="ThermodynamicTemperature",
              final unit="degC")
        "Absolute temperature in degree Celsius (for relative temperature use SIunits.TemperatureDifference)"
                                                                                                            annotation(__Dymola_absoluteValue=true);

        type AngularVelocity_rpm = Real (final quantity="AngularVelocity", final unit=
                   "1/min")
        "Angular velocity in revolutions per minute. Alias unit names that are outside of the SI system: rpm, r/min, rev/min"
          annotation (Documentation(info="<html>
<p>

</html>"));

        type Pressure_bar = Real (final quantity="Pressure", final unit="bar")
        "Absolute pressure in bar";
        annotation (Documentation(info="<HTML>
<p>
This package provides predefined types, such as <b>Angle_deg</b> (angle in
degree), <b>AngularVelocity_rpm</b> (angular velocity in revolutions per
minute) or <b>Temperature_degF</b> (temperature in degree Fahrenheit),
which are in common use but are not part of the international standard on
units according to ISO 31-1992 \"General principles concerning quantities,
units and symbols\" and ISO 1000-1992 \"SI units and recommendations for
the use of their multiples and of certain other units\".</p>
<p>If possible, the types in this package should not be used. Use instead
types of package Modelica.SIunits. For more information on units, see also
the book of Francois Cardarelli <b>Scientific Unit Conversion - A
Practical Guide to Metrication</b> (Springer 1997).</p>
<p>Some units, such as <b>Temperature_degC/Temp_C</b> are both defined in
Modelica.SIunits and in Modelica.Conversions.NonSIunits. The reason is that these
definitions have been placed erroneously in Modelica.SIunits although they
are not SIunits. For backward compatibility, these type definitions are
still kept in Modelica.SIunits.</p>
</HTML>
"),   Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
                  100}}), graphics={Text(
                extent={{-66,-13},{52,-67}},
                lineColor={0,0,0},
                textString="[km/h]")}));
      end NonSIunits;

      function to_degC "Convert from Kelvin to degCelsius"
        extends ConversionIcon;
        input Temperature Kelvin "Kelvin value";
        output NonSIunits.Temperature_degC Celsius "Celsius value";
      algorithm
        Celsius := Kelvin + Modelica.Constants.T_zero;
        annotation (Inline=true,Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}), graphics={Text(
                extent={{-20,100},{-100,20}},
                lineColor={0,0,0},
                textString="K"), Text(
                extent={{100,-20},{20,-100}},
                lineColor={0,0,0},
                textString="degC")}));
      end to_degC;

      function from_degC "Convert from degCelsius to Kelvin"
        extends ConversionIcon;
        input NonSIunits.Temperature_degC Celsius "Celsius value";
        output Temperature Kelvin "Kelvin value";
      algorithm
        Kelvin := Celsius - Modelica.Constants.T_zero;
        annotation (Inline=true,Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}), graphics={Text(
                extent={{-20,100},{-100,20}},
                lineColor={0,0,0},
                textString="degC"),  Text(
                extent={{100,-20},{20,-100}},
                lineColor={0,0,0},
                textString="K")}));
      end from_degC;

      function to_bar "Convert from Pascal to bar"
        extends ConversionIcon;
        input Pressure Pa "Pascal value";
        output NonSIunits.Pressure_bar bar "bar value";
      algorithm
        bar := Pa/1e5;
        annotation (Inline=true,Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}), graphics={Text(
                extent={{-12,100},{-100,56}},
                lineColor={0,0,0},
                textString="Pa"),     Text(
                extent={{98,-52},{-4,-100}},
                lineColor={0,0,0},
                textString="bar")}));
      end to_bar;

      partial function ConversionIcon "Base icon for conversion functions"

        annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}), graphics={
              Rectangle(
                extent={{-100,100},{100,-100}},
                lineColor={191,0,0},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Line(points={{-90,0},{30,0}}, color={191,0,0}),
              Polygon(
                points={{90,0},{30,20},{30,-20},{90,0}},
                lineColor={191,0,0},
                fillColor={191,0,0},
                fillPattern=FillPattern.Solid),
              Text(
                extent={{-115,155},{115,105}},
                textString="%name",
                lineColor={0,0,255})}));
      end ConversionIcon;
      annotation (Icon(coordinateSystem(preserveAspectRatio=true,
                       extent={{-100,-100},{100,100}}), graphics),
                                Documentation(info="<HTML>
<p>This package provides conversion functions from the non SI Units
defined in package Modelica.SIunits.Conversions.NonSIunits to the
corresponding SI Units defined in package Modelica.SIunits and vice
versa. It is recommended to use these functions in the following
way (note, that all functions have one Real input and one Real output
argument):</p>
<pre>
  <b>import</b> SI = Modelica.SIunits;
  <b>import</b> Modelica.SIunits.Conversions.*;
     ...
  <b>parameter</b> SI.Temperature     T   = from_degC(25);   // convert 25 degree Celsius to Kelvin
  <b>parameter</b> SI.Angle           phi = from_deg(180);   // convert 180 degree to radian
  <b>parameter</b> SI.AngularVelocity w   = from_rpm(3600);  // convert 3600 revolutions per minutes
                                                      // to radian per seconds
</pre>

</HTML>
"));
    end Conversions;

    type Angle = Real (
        final quantity="Angle",
        final unit="rad",
        displayUnit="deg");

    type Length = Real (final quantity="Length", final unit="m");

    type Volume = Real (final quantity="Volume", final unit="m3");

    type Time = Real (final quantity="Time", final unit="s");

    type AngularVelocity = Real (
        final quantity="AngularVelocity",
        final unit="rad/s");

    type Velocity = Real (final quantity="Velocity", final unit="m/s");

    type Acceleration = Real (final quantity="Acceleration", final unit="m/s2");

    type Frequency = Real (final quantity="Frequency", final unit="Hz");

    type Mass = Real (
        quantity="Mass",
        final unit="kg",
        min=0);

    type Density = Real (
        final quantity="Density",
        final unit="kg/m3",
        displayUnit="g/cm3",
        min=0);

    type Pressure = Real (
        final quantity="Pressure",
        final unit="Pa",
        displayUnit="bar");

    type AbsolutePressure = Pressure (min=0);

    type DynamicViscosity = Real (
        final quantity="DynamicViscosity",
        final unit="Pa.s",
        min=0);

    type SurfaceTension = Real (final quantity="SurfaceTension", final unit="N/m");

    type Energy = Real (final quantity="Energy", final unit="J");

    type Power = Real (final quantity="Power", final unit="W");

    type EnthalpyFlowRate = Real (final quantity="EnthalpyFlowRate", final unit=
            "W");

    type MassFlowRate = Real (quantity="MassFlowRate", final unit="kg/s");

    type VolumeFlowRate = Real (final quantity="VolumeFlowRate", final unit=
            "m3/s");

    type ThermodynamicTemperature = Real (
        final quantity="ThermodynamicTemperature",
        final unit="K",
        min = 0,
        start = 288.15,
        displayUnit="degC")
    "Absolute temperature (use type TemperatureDifference for relative temperatures)"
                                                                                                        annotation(__Dymola_absoluteValue=true);

    type Temp_K = ThermodynamicTemperature;

    type Temperature = ThermodynamicTemperature;

    type LinearTemperatureCoefficient = Real(final quantity = "LinearTemperatureCoefficient", final unit="1/K");

    type Compressibility = Real (final quantity="Compressibility", final unit=
            "1/Pa");

    type IsothermalCompressibility = Compressibility;

    type HeatFlowRate = Real (final quantity="Power", final unit="W");

    type ThermalConductivity = Real (final quantity="ThermalConductivity", final unit=
               "W/(m.K)");

    type SpecificHeatCapacity = Real (final quantity="SpecificHeatCapacity",
          final unit="J/(kg.K)");

    type RatioOfSpecificHeatCapacities = Real (final quantity=
            "RatioOfSpecificHeatCapacities", final unit="1");

    type SpecificEntropy = Real (final quantity="SpecificEntropy", final unit=
            "J/(kg.K)");

    type SpecificEnergy = Real (final quantity="SpecificEnergy", final unit=
            "J/kg");

    type SpecificInternalEnergy = SpecificEnergy;

    type SpecificEnthalpy = SpecificEnergy;

    type DerDensityByEnthalpy = Real (final unit="kg.s2/m5");

    type DerDensityByPressure = Real (final unit="s2/m2");

    type DerDensityByTemperature = Real (final unit="kg/(m3.K)");

    type DerEnthalpyByPressure = Real (final unit="J.m.s2/kg2");

    type MolarMass = Real (final quantity="MolarMass", final unit="kg/mol",min=0);

    type MolarVolume = Real (final quantity="MolarVolume", final unit="m3/mol", min=0);

    type MassFraction = Real (final quantity="MassFraction", final unit="1");

    type MoleFraction = Real (final quantity="MoleFraction", final unit="1");

    type PrandtlNumber = Real (final quantity="PrandtlNumber", final unit="1");
    annotation (
      Invisible=true,
      Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
              100}}), graphics={Text(
            extent={{-63,-13},{45,-67}},
            lineColor={0,0,0},
            textString="[kg.m2]")}),
      Documentation(info="<html>
<p>This package provides predefined types, such as <i>Mass</i>,
<i>Angle</i>, <i>Time</i>, based on the international standard
on units, e.g.,
</p>

<pre>   <b>type</b> Angle = Real(<b>final</b> quantity = \"Angle\",
                     <b>final</b> unit     = \"rad\",
                     displayUnit    = \"deg\");
</pre>

<p>
as well as conversion functions from non SI-units to SI-units
and vice versa in subpackage
<a href=\"modelica://Modelica.SIunits.Conversions\">Conversions</a>.
</p>

<p>
For an introduction how units are used in the Modelica standard library
with package SIunits, have a look at:
<a href=\"modelica://Modelica.SIunits.UsersGuide.HowToUseSIunits\">How to use SIunits</a>.
</p>

<p>
Copyright &copy; 1998-2010, Modelica Association and DLR.
</p>
<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"http://www.modelica.org/licenses/ModelicaLicense2\"> http://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>
</html>",   revisions="<html>
<ul>
<li><i>Jan. 27, 2010</i> by Christian Kral:<br/>Added complex units.</li>
<li><i>Dec. 14, 2005</i> by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br/>Add User&#39;;s Guide and removed &quot;min&quot; values for Resistance and Conductance.</li>
<li><i>October 21, 2002</i> by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a> and <a href=\"http://www.robotic.dlr.de/Christian.Schweiger/\">Christian Schweiger</a>:<br/>Added new package <b>Conversions</b>. Corrected typo <i>Wavelenght</i>.</li>
<li><i>June 6, 2000</i> by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br/>Introduced the following new types<br/>type Temperature = ThermodynamicTemperature;<br/>types DerDensityByEnthalpy, DerDensityByPressure, DerDensityByTemperature, DerEnthalpyByPressure, DerEnergyByDensity, DerEnergyByPressure<br/>Attribute &quot;final&quot; removed from min and max values in order that these values can still be changed to narrow the allowed range of values.<br/>Quantity=&quot;Stress&quot; removed from type &quot;Stress&quot;, in order that a type &quot;Stress&quot; can be connected to a type &quot;Pressure&quot;.</li>
<li><i>Oct. 27, 1999</i> by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br/>New types due to electrical library: Transconductance, InversePotential, Damping.</li>
<li><i>Sept. 18, 1999</i> by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br/>Renamed from SIunit to SIunits. Subpackages expanded, i.e., the SIunits package, does no longer contain subpackages.</li>
<li><i>Aug 12, 1999</i> by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br/>Type &quot;Pressure&quot; renamed to &quot;AbsolutePressure&quot; and introduced a new type &quot;Pressure&quot; which does not contain a minimum of zero in order to allow convenient handling of relative pressure. Redefined BulkModulus as an alias to AbsolutePressure instead of Stress, since needed in hydraulics.</li>
<li><i>June 29, 1999</i> by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br/>Bug-fix: Double definition of &quot;Compressibility&quot; removed and appropriate &quot;extends Heat&quot; clause introduced in package SolidStatePhysics to incorporate ThermodynamicTemperature.</li>
<li><i>April 8, 1998</i> by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a> and Astrid Jaschinski:<br/>Complete ISO 31 chapters realized.</li>
<li><i>Nov. 15, 1997</i> by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a> and <a href=\"http://www.control.lth.se/~hubertus/\">Hubertus Tummescheit</a>:<br/>Some chapters realized.</li>
</ul>
</html>"),
      Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
              100}}), graphics={
          Rectangle(
            extent={{169,86},{349,236}},
            fillColor={235,235,235},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,255}),
          Polygon(
            points={{169,236},{189,256},{369,256},{349,236},{169,236}},
            fillColor={235,235,235},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,255}),
          Polygon(
            points={{369,256},{369,106},{349,86},{349,236},{369,256}},
            fillColor={235,235,235},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,255}),
          Text(
            extent={{179,226},{339,196}},
            lineColor={160,160,164},
            textString="Library"),
          Text(
            extent={{206,173},{314,119}},
            lineColor={0,0,0},
            textString="[kg.m2]"),
          Text(
            extent={{163,320},{406,264}},
            lineColor={255,0,0},
            textString="Modelica.SIunits")}));
  end SIunits;
annotation (
preferredView="info",
version="3.2",
versionBuild=9,
versionDate="2010-10-25",
dateModified = "2012-02-09 11:32:00Z",
revisionId="",
uses(Complex(version="1.0"), ModelicaServices(version="1.2")),
conversion(
 noneFromVersion="3.1",
 noneFromVersion="3.0.1",
 noneFromVersion="3.0",
 from(version="2.1", script="modelica://Modelica/Resources/Scripts/Dymola/ConvertModelica_from_2.2.2_to_3.0.mos"),
 from(version="2.2", script="modelica://Modelica/Resources/Scripts/Dymola/ConvertModelica_from_2.2.2_to_3.0.mos"),
 from(version="2.2.1", script="modelica://Modelica/Resources/Scripts/Dymola/ConvertModelica_from_2.2.2_to_3.0.mos"),
 from(version="2.2.2", script="modelica://Modelica/Resources/Scripts/Dymola/ConvertModelica_from_2.2.2_to_3.0.mos")),
__Dymola_classOrder={"UsersGuide","Blocks","StateGraph","Electrical","Magnetic","Mechanics","Fluid","Media","Thermal",
      "Math","Utilities","Constants", "Icons", "SIunits"},
Settings(NewStateSelection=true),
Documentation(info="<HTML>
<p>
Package <b>Modelica&reg;</b> is a <b>standardized</b> and <b>free</b> package
that is developed together with the Modelica&reg; language from the
Modelica Association, see
<a href=\"http://www.Modelica.org\">http://www.Modelica.org</a>.
It is also called <b>Modelica Standard Library</b>.
It provides model components in many domains that are based on
standardized interface definitions. Some typical examples are shown
in the next figure:
</p>

<img src=\"modelica://Modelica/Resources/Images/UsersGuide/ModelicaLibraries.png\">

<p>
For an introduction, have especially a look at:
</p>
<ul>
<li> <a href=\"modelica://Modelica.UsersGuide.Overview\">Overview</a>
  provides an overview of the Modelica Standard Library
  inside the <a href=\"modelica://Modelica.UsersGuide\">User's Guide</a>.</li>
<li><a href=\"modelica://Modelica.UsersGuide.ReleaseNotes\">Release Notes</a>
 summarizes the changes of new versions of this package.</li>
<li> <a href=\"modelica://Modelica.UsersGuide.Contact\">Contact</a>
  lists the contributors of the Modelica Standard Library.</li>
<li> The <b>Examples</b> packages in the various libraries, demonstrate
  how to use the components of the corresponding sublibrary.</li>
</ul>

<p>
This version of the Modelica Standard Library consists of
</p>
<ul>
<li> <b>1280</b> models and blocks, and</li>
<li> <b>910</b> functions
</ul>
<p>
that are directly usable (= number of public, non-partial classes).
</p>

<p>
<b>Licensed by the Modelica Association under the Modelica License 2</b><br>
Copyright &copy; 1998-2010, ABB, AIT, T.&nbsp;B&ouml;drich, DLR, Dassault Syst&egrave;mes AB, Fraunhofer, A.Haumer, Modelon,
TU Hamburg-Harburg, Politecnico di Milano.
</p>

<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"http://www.modelica.org/licenses/ModelicaLicense2\"> http://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>
</HTML>
"));
end Modelica;

package Buildings "Library with models for building energy and control systems"

  package Controls "Package with models for controls"
    extends Modelica.Icons.Package;

    package Continuous "Package with models for discrete time controls"
      extends Modelica.Icons.VariantsPackage;

      block LimPID
      "P, PI, PD, and PID controller with limited output, anti-windup compensation and setpoint weighting"
        extends Modelica.Blocks.Continuous.LimPID(
          addP(k1=revAct*wp, k2=-revAct),
          addD(k1=revAct*wd, k2=-revAct),
          addI(k1=revAct, k2=-revAct),
          yMin=0,
          yMax=1);

        parameter Boolean reverseAction = false
        "Set to true for throttling the water flow rate through a cooling coil controller";
    protected
        parameter Real revAct = if reverseAction then -1 else 1;
        annotation (
      defaultComponentName="conPID",
      Documentation(info="<html>
This model is identical to 
<a href=\"Modelica:Modelica.Blocks.Continuous.LimPID\">
Modelica.Blocks.Continuous.LimPID</a> except
that it can be configured to have a reverse action.
</P>
<p>
If the parameter <code>reverseAction=false</code> (the default),
then <code>u_m &lt; u_s</code> increases the controller output, 
otherwise the controller output is decreased.
Thus, 
<ul>
<li>
for a heating coil with a two-way valve, set <code>reverseAction = false</code>,
</li>
<li>
for a cooling coils with a two-way valve, set <code>reverseAction = true</code>.
</li>
</ul>
</html>",
      revisions="<html>
<ul>
<li>
February 24, 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),       Icon(graphics={
              Rectangle(
                extent={{-6,-20},{66,-66}},
                lineColor={255,255,255},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Text(
                visible=(controllerType == Modelica.Blocks.Types.SimpleController.P),
                extent={{-32,-22},{68,-62}},
                lineColor={0,0,0},
                textString="P",
                fillPattern=FillPattern.Solid,
                fillColor={175,175,175}),
              Text(
                visible=(controllerType == Modelica.Blocks.Types.SimpleController.PI),
                extent={{-28,-22},{72,-62}},
                lineColor={0,0,0},
                textString="PI",
                fillPattern=FillPattern.Solid,
                fillColor={175,175,175}),
              Text(
                visible=(controllerType == Modelica.Blocks.Types.SimpleController.PD),
                extent={{-16,-22},{88,-62}},
                lineColor={0,0,0},
                fillPattern=FillPattern.Solid,
                fillColor={175,175,175},
                textString="P D"),
              Text(
                visible=(controllerType == Modelica.Blocks.Types.SimpleController.PID),
                extent={{-14,-22},{86,-62}},
                lineColor={0,0,0},
                textString="PID",
                fillPattern=FillPattern.Solid,
                fillColor={175,175,175})}));
      end LimPID;
    annotation (preferedView="info", Documentation(info="<html>
This package contains components models for continuous time controls.
For additional models, see also 
<a href=\"Modelica:Modelica.Blocks.Continuous\">
Modelica.Blocks.Discrete</a>.
</html>"));
    end Continuous;

    package SetPoints "Package with models for control set points"
      extends Modelica.Icons.VariantsPackage;

      block OccupancySchedule "Occupancy schedule with look-ahead"
        extends Modelica.Blocks.Interfaces.BlockIcon;

        parameter Real occupancy[:]=3600*{7, 19}
        "Occupancy table, each entry switching occupancy on or off";
        parameter Boolean firstEntryOccupied = true
        "Set to true if first entry in occupancy denotes a changed from unoccupied to occupied";
        parameter Modelica.SIunits.Time period =   86400
        "End time of periodicity";

        Modelica.Blocks.Interfaces.RealOutput tNexNonOcc
        "Time until next non-occupancy"
          annotation (Placement(transformation(extent={{100,-10},{120,10}})));
        Modelica.Blocks.Interfaces.RealOutput tNexOcc
        "Time until next occupancy"
          annotation (Placement(transformation(extent={{100,50},{120,70}})));
        Modelica.Blocks.Interfaces.BooleanOutput occupied
        "Outputs true if occupied at current time"
          annotation (Placement(transformation(extent={{100,-70},{120,-50}})));

    protected
        parameter Modelica.SIunits.Time offSet(fixed=false)
        "Time off-set, in multiples of period, that is used to switch the time when doing the table lookup";
        final parameter Integer nRow = size(occupancy,1);

        output Integer nexStaInd "Next index when occupancy starts";
        output Integer nexStoInd "Next index when occupancy stops";

        output Integer iPerSta
        "Counter for the period in which the next occupancy starts";
        output Integer iPerSto
        "Counter for the period in which the next occupancy stops";

        output Modelica.SIunits.Time tOcc "Time when next occupancy starts";
        output Modelica.SIunits.Time tNonOcc
        "Time when next non-occupancy starts";

      encapsulated function switch
        input Integer x1;
        input Integer x2;
        output Integer y1;
        output Integer y2;
      algorithm
        y1:=x2;
        y2:=x1;
      end switch;

      initial algorithm
        // Check parameters for correctness
       assert(mod(nRow, 2) < 0.1,
         "The parameter \"occupancy\" must have an even number of elements.\n");
       assert(0 < occupancy[1],
         "The first element of \"occupancy\" must be bigger than or equal than zero."
         + "\n   Received occupancy[1] = " + String(occupancy[1]));
       assert(period > occupancy[nRow],
         "The parameter \"period\" must be greater than the last element of \"occupancy\"."
         + "\n   Received period      = " + String(period)
         + "\n            occupancy[" + String(nRow) +
           "] = " + String(occupancy[nRow]));
        for i in 1:nRow-1 loop
          assert(occupancy[i] < occupancy[i+1],
            "The elements of the parameter \"occupancy\" must be strictly increasing.");
        end for;
       // Initialize variables
       iPerSta   := integer(time/period);
       iPerSto   := iPerSta;
       offSet:=iPerSta*period;

       // First, assume that the first entry is occupied.
       nexStaInd := 1;
       for i in 1:2:nRow-1 loop
         if time > occupancy[i] + offSet then
           nexStaInd :=i;
         end if;
       end for;

       nexStoInd := 2;
       for i in 2:2:nRow loop
         if time > occupancy[i] + offSet then
           nexStoInd :=i;
         end if;
       end for;

       occupied := (time+offSet - occupancy[nexStaInd]) < (time+offSet - occupancy[nexStoInd]);

       // Now, correct if the first entry is vaccant instead of occupied
       if not firstEntryOccupied then
         (nexStaInd, nexStoInd) := switch(nexStaInd, nexStoInd);
         occupied := not occupied;
       end if;

       tOcc    := occupancy[nexStaInd]+offSet;
       tNonOcc := occupancy[nexStoInd]+offSet;

      algorithm
        when time >= pre(occupancy[nexStaInd])+ iPerSta*period then
          nexStaInd :=nexStaInd + 2;
          occupied := not occupied;
          // Wrap index around
          if nexStaInd > nRow then
             nexStaInd := if firstEntryOccupied then 1 else 2;
             iPerSta := iPerSta + 1;
          end if;
          tOcc := occupancy[nexStaInd] + iPerSta*(period);
        end when;

        // Changed the index that computes the time until the next non-occupancy
        when time >= pre(occupancy[nexStoInd])+ iPerSto*period then
          nexStoInd :=nexStoInd + 2;
          occupied := not occupied;
          // Wrap index around
          if nexStoInd > nRow then
             nexStoInd := if firstEntryOccupied then 2 else 1;
             iPerSto := iPerSto + 1;
          end if;
          tNonOcc := occupancy[nexStoInd] + iPerSto*(period);
        end when;

       tNexOcc    := tOcc-time;
       tNexNonOcc := tNonOcc-time;
        annotation (
          Icon(graphics={
              Line(
                points={{-62,-68},{-38,-20},{-14,-70}},
                color={0,0,255},
                smooth=Smooth.None),
              Line(
                points={{-38,-20},{-38,44}},
                color={0,0,255},
                smooth=Smooth.None),
              Ellipse(extent={{-54,74},{-22,44}}, lineColor={0,0,255}),
              Line(
                points={{-66,22},{-38,36}},
                color={0,0,255},
                smooth=Smooth.None),
              Line(
                points={{-38,36},{-6,20}},
                color={0,0,255},
                smooth=Smooth.None),
              Text(
                extent={{34,74},{90,50}},
                lineColor={0,0,255},
                textString="occupancy"),
              Text(
                extent={{32,16},{92,-16}},
                lineColor={0,0,255},
                textString="non-occupancy"),
              Text(
                extent={{34,-44},{94,-76}},
                lineColor={0,0,255},
                textString="occupied")}),
          Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
                  100}}), graphics),
      defaultComponentName="occSch",
      Documentation(info="<html>
<p>
This model outputs whether the building is currently occupied,
and how long it will take until the next time when the building 
will be occupied or non-occupied.
The latter may be used, for example, to start a ventilation system
half an hour before occupancy starts in order to ventilate the room.
</p>
<p>
The occupancy is defined by a time schedule of the form
<pre>
  occupancy = 3600*{7, 12, 14, 19}
</pre>
This indicates that the occupancy is from <i>7:00</i> until <i>12:00</i>
and from <i>14:00</i> to <i>19:00</i>. This will be repeated periodically.
The parameter <code>periodicity</code> defines the periodicity.
The period always starts at <i>t=0</i> seconds.
</p>
</html>",       revisions="<html>
<ul>
<li>
February 16, 2012, by Michael Wetter:<br>
Removed parameter <code>startTime</code>. It was removed because <code>startTime=0</code>
would imply that the schedule should not start for one day if the the simulation were
to be started at <i>t=-8760</i> seconds.
Fixed bug that prevented schedule to start when the simulation was started at a time that
is higher than <code>endTime</code>.
Renamed parameter <code>endTime</code> to <code>period</code>.
</li>
<li>
April 2, 2009, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
      end OccupancySchedule;
    annotation (preferedView="info", Documentation(info="<html>
This package contains components models to compute set points of control systems.
For additional models, see also 
<a href=\"Modelica:Modelica.Blocks.Continuous\">
Modelica.Blocks.Continuous</a>.
</html>"));
    end SetPoints;
  annotation (preferedView="info", Documentation(info="<html>
This package contains components models for controls.
For additional models, see also 
<a href=\"Modelica:Modelica.Blocks\">
Modelica.Blocks</a>.
</html>"));
  end Controls;

  package Fluid "Package with models for fluid flow systems"
    extends Modelica.Icons.Package;

    package Delays "Package with delay models"
      extends Modelica.Icons.VariantsPackage;

      model DelayFirstOrder
      "Delay element, approximated by a first order differential equation"
        extends Buildings.Fluid.MixingVolumes.MixingVolume(final V=V0);

        parameter Modelica.SIunits.Time tau = 60
        "Time constant at nominal flow"
          annotation (Dialog(tab="Dynamics", group="Nominal condition"));

    protected
         parameter Modelica.SIunits.Volume V0 = m_flow_nominal*tau/rho_nominal
        "Volume of delay element";
        annotation (Diagram(graphics),
          Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
                  100}}), graphics={Ellipse(
                extent={{-100,98},{100,-102}},
                lineColor={0,0,0},
                fillPattern=FillPattern.Sphere,
                fillColor={170,213,255}), Text(
                extent={{-72,22},{68,-18}},
                lineColor={0,0,0},
                textString="tau=%tau")}),
      defaultComponentName="del",
          Documentation(info="<html>
<p>
This model approximates a transport delay using a first order differential equations.
</p>
<p>
The model consists of a mixing volume with two ports. The size of the
mixing volume is such that at the nominal mass flow rate 
<code>m_flow_nominal</code>,
the time constant of the volume is equal to the parameter <code>tau</code>.
</p>
<p>
The heat flux connector is optional, it need not be connnected.
</p>
</html>",
      revisions="<html>
<ul>
<li>
September 24, 2008, by Michael Wetter:<br>
Changed base class from <code>Modelica.Fluid</code> to <code>Buildings</code> library.
This was done to track the auxiliary species flow <code>mC_flow</code>.
</li>
<li>
September 4, 2008, by Michael Wetter:<br>
Fixed bug in assignment of parameter <code>sta0</code>. 
The earlier implementation
required temperature to be a state, which is not always the case.
</li>
<li>
March 17, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
      end DelayFirstOrder;
    annotation (preferedView="info", Documentation(info="<html>
<p>
This package contains components models for transport delays in
piping networks.
</p>
<p>
The model 
<a href=\"modelica://Buildings.Fluid.Delays.DelayFirstOrder\">
Buildings.Fluid.Delays.DelayFirstOrder</a>
approximates transport delays using a first order differential equation.
</p>
<p>
For a discretized model of a pipe or duct, see
<a href=\"modelica://Buildings.Fluid.FixedResistances.Pipe\">
Buildings.Fluid.FixedResistances.Pipe</a>.
</p>
</html>"));
    end Delays;

    package FixedResistances
    "Package with models for fixed flow resistances (pipes, diffusers etc.)"
      extends Modelica.Icons.VariantsPackage;

      model FixedResistanceDpM
      "Fixed flow resistance with dp and m_flow as parameter"
        extends Buildings.Fluid.BaseClasses.PartialResistance(
          final m_flow_turbulent = if (computeFlowResistance and use_dh) then
                             eta_nominal*dh/4*Modelica.Constants.pi*ReC
                             elseif (computeFlowResistance) then
                             deltaM * m_flow_nominal_pos
               else 0);
        parameter Boolean use_dh = false
        "Set to true to specify hydraulic diameter"
             annotation(Evaluate=true, Dialog(enable = not linearized));
        parameter Modelica.SIunits.Length dh=1 "Hydraulic diameter"
             annotation(Evaluate=true, Dialog(enable = use_dh and not linearized));
        parameter Real ReC(min=0)=4000
        "Reynolds number where transition to turbulent starts"
             annotation(Evaluate=true, Dialog(enable = use_dh and not linearized));
        parameter Real deltaM(min=0.01) = 0.3
        "Fraction of nominal mass flow rate where transition to turbulent occurs"
             annotation(Evaluate=true, Dialog(enable = not use_dh and not linearized));

        final parameter Real k(unit="") = if computeFlowResistance then
              m_flow_nominal_pos / sqrt(dp_nominal_pos) else 0
        "Flow coefficient, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)";
    protected
        final parameter Boolean computeFlowResistance=(dp_nominal_pos > Modelica.Constants.eps)
        "Flag to enable/disable computation of flow resistance"
         annotation(Evaluate=true);
      initial equation
       if computeFlowResistance then
         assert(m_flow_turbulent > 0, "m_flow_turbulent must be bigger than zero.");
       end if;

       assert(m_flow_nominal_pos > 0, "m_flow_nominal_pos must be non-zero. Check parameters.");
       if ( m_flow_turbulent > m_flow_nominal_pos) then
         Modelica.Utilities.Streams.print("Warning: In FixedResistanceDpM, m_flow_nominal is smaller than m_flow_turbulent."
                 + "\n"
                 + "  m_flow_nominal = " + String(m_flow_nominal) + "\n"
                 + "  dh      = " + String(dh) + "\n"
                 + "  To fix, set dh < " +
                      String(     4*m_flow_nominal/eta_nominal/Modelica.Constants.pi/ReC) + "\n"
                 + "  Suggested value: dh = " +
                      String(1/10*4*m_flow_nominal/eta_nominal/Modelica.Constants.pi/ReC));
       end if;

      equation
        // Pressure drop calculation
        if computeFlowResistance then
          if linearized then
            m_flow*m_flow_nominal_pos = k^2*dp;
          else
            if homotopyInitialization then
              if from_dp then
                m_flow=homotopy(actual=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(dp=dp, k=k,
                                         m_flow_turbulent=m_flow_turbulent),
                                         simplified=m_flow_nominal_pos*dp/dp_nominal_pos);
              else
                dp=homotopy(actual=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(m_flow=m_flow, k=k,
                                         m_flow_turbulent=m_flow_turbulent),
                          simplified=dp_nominal_pos*m_flow/m_flow_nominal_pos);
               end if;  // from_dp
            else // do not use homotopy
              if from_dp then
                m_flow=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(dp=dp, k=k,
                                         m_flow_turbulent=m_flow_turbulent);
              else
                dp=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(m_flow=m_flow, k=k,
                                         m_flow_turbulent=m_flow_turbulent);
              end if;  // from_dp
            end if; // homotopyInitialization
          end if; // linearized
        else // do not compute flow resistance
          dp = 0;
        end if;  // computeFlowResistance

        annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
                  -100},{100,100}}),
                            graphics),
      defaultComponentName="res",
      Documentation(info="<html>
<p>
This is a model of a resistance with a fixed flow coefficient.
The mass flow rate is computed as
<p align=\"center\" style=\"font-style:italic;\">
m&#775; = k  
&radic;<span style=\"text-decoration:overline;\">&Delta;P</span>,
</p>
where 
<i>k</i> is a constant and 
<i>&Delta;P</i> is the pressure drop.
The constant <i>k</i> is equal to
<code>k=m_flow_nominal/dp_nominal</code>,
where <code>m_flow_nominal</code> and <code>dp_nominal</code>
are parameters.
In the region
<code>abs(m_flow) &lt; m_flow_turbulent</code>, 
the square root is replaced by a differentiable function
with finite slope.
The value of <code>m_flow_turbulent</code> is
computed as follows:
</p>
<p>
<ul>
<li>
If the parameter <code>use_dh</code> is <code>false</code>
(the default setting), 
the equation 
<code>m_flow_turbulent = deltaM * abs(m_flow_nominal)</code>,
where <code>deltaM=0.3</code> and 
<code>m_flow_nominal</code> are parameters that can be set by the user.
</li>
<li>
Otherwise, the equation
<code>m_flow_turbulent = eta_nominal*dh/4*&pi;*ReC</code> is used,
where 
<code>eta_nominal</code> is the dynamic viscosity, obtained from
the medium model. The parameter
<code>dh</code> is the hydraulic diameter and
<code>ReC=4000</code> is the critical Reynolds number, which both
can be set by the user.
</li>
</ul>
</p>
<p>
The figure below shows the pressure drop for the parameters
<code>m_flow_nominal=5</code> kg/s,
<code>dp_nominal=10</code> Pa and
<code>deltaM=0.3</code>.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Fluid/FixedResistances/FixedResistanceDpM.png\"/>
</p>
<p>
If the parameters 
<code>show_V_flow</code> or
<code>show_T</code> are set to <code>true</code>,
then the model will compute the volume flow rate and the
temperature at its ports. Note that this can lead to state events
when the mass flow rate approaches zero,
which can increase computing time.
</p>
<p>
The parameter <code>from_dp</code> is used to determine
whether the mass flow rate is computed as a function of the 
pressure drop (if <code>from_dp=true</code>), or vice versa.
This setting can affect the size of the nonlinear system of equations.
</p>
<p>
If the parameter <code>linearized</code> is set to <code>true</code>,
then the pressure drop is computed as a linear function of the
mass flow rate.
</p>
<p>
Setting <code>allowFlowReversal=false</code> can lead to simpler
equations. However, this should only be set to <code>false</code>
if one can guarantee that the flow never reverses its direction.
This can be difficult to guarantee, as pressure imbalance after 
the initialization, or due to medium expansion and contraction,
can lead to reverse flow.
</p>
<p>
<h4>Notes</h4>
<p>
For more detailed models that compute the actual flow friction, 
models from the package 
<a href=\"modelica://Modelica.Fluid\">
Modelica.Fluid</a>
can be used and combined with models from the 
<code>Buildings</code> library.
</p>
<h4>Implementation</h4>
<p>
The pressure drop is computed by calling a function in the package
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels\">
Buildings.Fluid.BaseClasses.FlowModels</a>,
This package contains regularized implementations of the equation
<p align=\"center\" style=\"font-style:italic;\">
  m = sign(&Delta;p) k  &radic;<span style=\"text-decoration:overline;\">&nbsp;&Delta;p &nbsp;</span>
</p>
<p>
and its inverse function.
</p>
<p>
To decouple the energy equation from the mass equations,
the pressure drop is a function of the mass flow rate,
and not the volume flow rate.
This leads to simpler equations.
</p>
</html>",       revisions="<html>
<ul>
<li>
January 16, 2012 by Michael Wetter:<br>
To simplify object inheritance tree, revised base classes
<code>Buildings.Fluid.BaseClasses.PartialResistance</code>,
<code>Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve</code>,
<code>Buildings.Fluid.Actuators.BaseClasses.PartialDamperExponential</code>,
<code>Buildings.Fluid.Actuators.BaseClasses.PartialActuator</code>
and model
<code>Buildings.Fluid.FixedResistances.FixedResistanceDpM</code>.
</li>
<li>
May 30, 2008 by Michael Wetter:<br>
Added parameters <code>use_dh</code> and <code>deltaM</code> for easier parameterization.
</li>
<li>
July 20, 2007 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
                  100}}), graphics={Text(
                extent={{-102,86},{-4,22}},
                lineColor={0,0,255},
                textString="dp_nominal=%dp_nominal"), Text(
                extent={{-106,106},{6,60}},
                lineColor={0,0,255},
                textString="m0=%m_flow_nominal")}));
      end FixedResistanceDpM;
    annotation (preferedView="info", Documentation(info="<html>
This package contains components models for fixed flow resistances. 
By fixed flow resistance, we mean resistances that do not change the 
flow coefficient
<p align=\"center\" style=\"font-style:italic;\">
k = m &frasl; 
&radic;<span style=\"text-decoration:overline;\">&Delta;P</span>.
</p>
<p>
For models of valves and air dampers, see
<a href=\"modelica://Buildings.Fluid.Actuators\">
Buildings.Fluid.Actuators</a>.
For models of flow resistances as part of the building constructions, see 
<a href=\"modelica://Buildings.Airflow.Multizone\">
Buildings.Airflow.Multizone</a>.
</p>
<p>
The model
<a href=\"modelica://Buildings.Fluid.FixedResistances.FixedResistanceDpM\">
Buildings.Fluid.FixedResistances.FixedResistanceDpM</a>
is a fixed flow resistance that takes as parameter a nominal flow rate and a nominal pressure drop. The actual resistance is scaled using the above equation.
</p>
<p>
The model
<a href=\"modelica://Buildings.Fluid.FixedResistances.LosslessPipe\">
Buildings.Fluid.FixedResistances.LosslessPipe</a>
is an ideal pipe segment with no pressure drop. It is primarily used
in models in which the above pressure drop model need to be replaced by a model with no pressure drop.
</p>
<p>
The model
<a href=\"modelica://Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM\">
Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM</a>
can be used to model flow splitters or flow merges.
</p>
</html>"));
    end FixedResistances;

    package HeatExchangers "Package with heat exchanger models"
      extends Modelica.Icons.VariantsPackage;

      model HeaterCoolerPrescribed
      "Heater or cooler with prescribed heat flow rate"
        extends Buildings.Fluid.Interfaces.TwoPortHeatMassExchanger(
          redeclare final Buildings.Fluid.MixingVolumes.MixingVolume vol);

        parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal
        "Heat flow rate at u=1, positive for heating";
        Modelica.Blocks.Interfaces.RealInput u "Control input"
          annotation (Placement(transformation(
                extent={{-140,40},{-100,80}}, rotation=0)));
    protected
        Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHea
        "Prescribed heat flow"
          annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
        Modelica.Blocks.Math.Gain gai(k=Q_flow_nominal) "Gain"
          annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
      equation
        connect(u, gai.u) annotation (Line(
            points={{-120,60},{-82,60}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(gai.y, preHea.Q_flow) annotation (Line(
            points={{-59,60},{-40,60}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(preHea.port, vol.heatPort) annotation (Line(
            points={{-20,60},{-9,60},{-9,-10}},
            color={191,0,0},
            smooth=Smooth.None));
        annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                  -100},{100,100}}), graphics={
              Rectangle(
                extent={{-70,80},{70,-80}},
                lineColor={0,0,255},
                pattern=LinePattern.None,
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid),
              Rectangle(
                extent={{-102,5},{99,-5}},
                lineColor={0,0,255},
                pattern=LinePattern.None,
                fillColor={0,0,0},
                fillPattern=FillPattern.Solid),
              Text(
                extent={{-56,-12},{54,-72}},
                lineColor={0,0,255},
                textString="Q=%Q_flow_nominal"),
              Rectangle(
                extent={{-100,61},{-70,58}},
                lineColor={0,0,255},
                pattern=LinePattern.None,
                fillColor={0,0,127},
                fillPattern=FillPattern.Solid),
              Text(
                extent={{-122,106},{-78,78}},
                lineColor={0,0,255},
                textString="u")}),
      defaultComponentName="hea",
      Documentation(info="<html>
<p>
Model for an ideal heater or cooler with prescribed heat flow rate to the medium.
</p>
<p>
This model adds heat in the amount of <code>Q_flow = u Q_flow_nominal</code> to the medium.
The input signal <code>u</code> and the nominal heat flow rate <code>Q_flow_nominal</code> 
can be positive or negative.
</p>
</html>",
      revisions="<html>
<ul>
<li>
July 11, 2011, by Michael Wetter:<br>
Redeclared fluid volume as final. This prevents the fluid volume model
to appear in the dialog window.
</li>
<li>
May 24, 2011, by Michael Wetter:<br>
Changed base class to allow using the model as a dynamic or a steady-state model.
</li>
<li>
April 17, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),Diagram(graphics));
      end HeaterCoolerPrescribed;
    annotation (preferedView="info", Documentation(info="<html>
This package contains models for heat exchangers with and without humidity condensation.
</html>"));
    end HeatExchangers;

    package MassExchangers "Package with mass exchanger models"
      extends Modelica.Icons.VariantsPackage;

      model HumidifierPrescribed
      "Ideal humidifier or dehumidifier with prescribed water mass flow rate addition or subtraction"
        extends Buildings.Fluid.Interfaces.TwoPortHeatMassExchanger(
          redeclare final Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir vol);

        parameter Boolean use_T_in= false
        "Get the temperature from the input connector"
          annotation(Evaluate=true, HideResult=true);

        parameter Modelica.SIunits.Temperature T = 293.15
        "Temperature of water that is added to the fluid stream (used if use_T_in=false)"
          annotation (Evaluate = true,
                      Dialog(enable = not use_T_in));

        parameter Modelica.SIunits.MassFlowRate mWat_flow_nominal
        "Water mass flow rate at u=1, positive for humidification";

        Modelica.Blocks.Interfaces.RealInput T_in if use_T_in
        "Temperature of water added to the fluid stream"
          annotation (Placement(transformation(extent={{-140,-80},{-100,-40}},
                rotation=0)));
        Modelica.Blocks.Interfaces.RealInput u "Control input"
          annotation (Placement(transformation(
                extent={{-140,40},{-100,80}}, rotation=0)));
    protected
        Modelica.Blocks.Interfaces.RealInput T_in_internal
        "Needed to connect to conditional connector";
        Modelica.Blocks.Math.Gain gai(k=mWat_flow_nominal) "Gain"
          annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
        Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHea
        "Prescribed heat flow"
          annotation (Placement(transformation(extent={{36,68},{56,88}})));
        Modelica.Blocks.Sources.RealExpression realExpression(y=
              Medium.enthalpyOfLiquid(T_in_internal))
          annotation (Placement(transformation(extent={{-96,70},{-20,94}})));
        Modelica.Blocks.Math.Product pro
        "Product to compute latent heat added to volume"
          annotation (Placement(transformation(extent={{0,66},{20,86}})));
        Modelica.Blocks.Sources.RealExpression realExpression1(y=T_in_internal)
          annotation (Placement(transformation(extent={{-80,-48},{-52,-24}})));
      equation
        // Conditional connect statement
        connect(T_in, T_in_internal);
        if not use_T_in then
          T_in_internal = T;
        end if;

        connect(u, gai.u) annotation (Line(
            points={{-120,60},{-82,60}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(gai.y, vol.mWat_flow) annotation (Line(
            points={{-59,60},{-34,60},{-34,-18},{-11,-18}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(realExpression.y, pro.u1)     annotation (Line(
            points={{-16.2,82},{-2,82}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(gai.y, pro.u2)     annotation (Line(
            points={{-59,60},{-34,60},{-34,70},{-2,70}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(pro.y, preHea.Q_flow)     annotation (Line(
            points={{21,76},{28,76},{28,78},{36,78}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(preHea.port, vol.heatPort) annotation (Line(
            points={{56,78},{80,78},{80,60},{-20,60},{-20,-10},{-9,-10}},
            color={191,0,0},
            smooth=Smooth.None));
        connect(vol.TWat, realExpression1.y) annotation (Line(
            points={{-11,-14.8},{-30,-14.8},{-30,-36},{-50.6,-36}},
            color={0,0,127},
            smooth=Smooth.None));
        annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                  -100},{100,100}}), graphics={
              Rectangle(
                extent={{-70,80},{70,-80}},
                lineColor={0,0,255},
                pattern=LinePattern.None,
                fillColor={85,170,255},
                fillPattern=FillPattern.Solid),
              Rectangle(
                extent={{-102,5},{99,-5}},
                lineColor={0,0,255},
                pattern=LinePattern.None,
                fillColor={0,0,0},
                fillPattern=FillPattern.Solid),
              Text(
                extent={{-56,-12},{54,-72}},
                lineColor={0,0,255},
                textString="m=%m_flow_nominal"),
              Rectangle(
                extent={{-100,61},{-70,58}},
                lineColor={0,0,255},
                pattern=LinePattern.None,
                fillColor={0,0,127},
                fillPattern=FillPattern.Solid),
              Text(
                extent={{-144,114},{-100,86}},
                lineColor={0,0,255},
                textString="u"),
              Text(
                visible=use_T_in,
                extent={{-140,-20},{-96,-48}},
                lineColor={0,0,255},
                textString="T"),
              Rectangle(
                visible=use_T_in,
                extent={{-100,-59},{-70,-62}},
                lineColor={0,0,255},
                pattern=LinePattern.None,
                fillColor={255,0,0},
                fillPattern=FillPattern.Solid)}),
      defaultComponentName="hum",
      Documentation(info="<html>
<p>
Model for an air humidifier or dehumidifier.
</p>
<p>
This model adds (or removes) moisture from the air stream.
The amount of exchanged moisture is equal to
</p>
<p align=\"center\" style=\"font-style:italic;\">
m&#775;<sub>wat</sub> = u  m&#775;<sub>wat,nom</sub>,
</p>
<p>
where <i>u</i> is the control input signal and
<i>m&#775;<sub>wat,nom</sub></i> is equal to the parameter <code>mWat_flow_nominal</code>.
The parameter <code>mWat_flow_nominal</code> can be positive or negative.
If <i>m&#775;<sub>wat</sub></i> is positive, then moisture is added
to the air stream, otherwise it is removed.
</p>
<p>If the connector <code>T_in</code> is left unconnected, the value
set by the parameter <code>T</code> is used for the temperature of the water that is 
added to the air stream.
</p>
<p>
This model can only be used with medium models that define the integer constant
<code>Water</code> which needs to be equal to the index of the water mass fraction 
in the species vector.
</p>
</html>",
      revisions="<html>
<ul>
<li>
May 24, 2011, by Michael Wetter:<br>
Changed base class to allow using the model as a dynamic or a steady-state model.
</li>
<li>
April 14, 2010, by Michael Wetter:<br>
Converted temperature input to a conditional connector.
</li>
<li>
April 17, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),Diagram(graphics));
      end HumidifierPrescribed;
    annotation (preferedView="info", Documentation(info="<html>
This package contains models for mass exchangers.
For heat exchanger models with humidity transfer, see the package
<a href=\"modelica://Buildings.Fluid.HeatExchangers\">
Buildings.Fluid.HeatExchangers</a>.
</html>"));
    end MassExchangers;

    package MixingVolumes "Package with mixing volumes"
      extends Modelica.Icons.VariantsPackage;

      model MixingVolume
      "Mixing volume with inlet and outlet ports (flow reversal is allowed)"
        extends Buildings.Fluid.MixingVolumes.BaseClasses.PartialMixingVolume;
    protected
        Modelica.Blocks.Sources.Constant       masExc[Medium.nXi](k=zeros(Medium.nXi)) if
             Medium.nXi > 0 "Block to set mass exchange in volume"
          annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
        Modelica.Blocks.Sources.RealExpression heaInp(y=heatPort.Q_flow)
        "Block to set heat input into volume"
          annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
      equation
        connect(heaInp.y, steBal.Q_flow) annotation (Line(
            points={{-59,90},{-30,90},{-30,18},{-22,18}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(heaInp.y, dynBal.Q_flow) annotation (Line(
            points={{-59,90},{28,90},{28,16},{38,16}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(masExc.y, steBal.mXi_flow) annotation (Line(
            points={{-59,70},{-42,70},{-42,14},{-22,14}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(masExc.y, dynBal.mXi_flow) annotation (Line(
            points={{-59,70},{20,70},{20,12},{38,12}},
            color={0,0,127},
            smooth=Smooth.None));
        annotation (
      defaultComponentName="vol",
      Documentation(info="<html>
This model represents an instantaneously mixed volume. 
Potential and kinetic energy at the port are neglected,
and there is no pressure drop at the ports.
The volume can exchange heat through its <code>heatPort</code>.
</p>
<p>
The volume can be parameterized as a steady-state model or as
dynamic model.
</p>
<p>
To increase the numerical robustness of the model, the parameter
<code>prescribedHeatFlowRate</code> can be set by the user. 
This parameter only has an effect if the model has exactly two fluid ports connected,
and if it is used as a steady-state model.
Use the following settings:
<ul>
<li>Set <code>prescribedHeatFlowRate=true</code> if there is a model connected to <code>heatPort</code>
that computes the heat flow rate <i>not</i> as a function of the temperature difference
between the medium and an ambient temperature. Examples include an ideal electrical heater,
a pump that rejects heat into the fluid stream, or a chiller that removes heat based on a performance curve.
</li>
<li>Set <code>prescribedHeatFlowRate=true</code> if the only means of heat flow at the <code>heatPort</code>
is computed as <i>K * (T-heatPort.T)</i>, for some temperature <i>T</i> and some conductance <i>K</i>,
which may itself be a function of temperature or mass flow rate.
</li>
</ul>
</p>
<h4>Implementation</h4>
<p>
If the model is operated in steady-state and has two fluid ports connected,
then the same energy and mass balance implementation is used as in
steady-state component models, i.e., the use of <code>actualStream</code>
is not used for the properties at the port.
</p>
<p>
The implementation of these balance equations is done in the instances
<code>dynBal</code> for the dynamic balance and <code>steBal</code>
for the steady-state balance. Both models use the same input variables:
<ul>
<li>
The variable <code>Q_flow</code> is used to add sensible <i>and</i> latent heat to the fluid.
For example, <code>Q_flow</code> participates in the steady-state energy balance<pre>
    port_b.h_outflow = inStream(port_a.h_outflow) + Q_flow * m_flowInv;
</pre>
where <code>m_flowInv</code> approximates the expression <code>1/m_flow</code>.
</li>
<li>
The variable <code>mXi_flow</code> is used to add a species mass flow rate to the fluid.
</li>
</ul>
</p>
<p>
For simple models that uses this model, see
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeaterCoolerPrescribed\">
Buildings.Fluid.HeatExchangers.HeaterCoolerPrescribed</a> and
<a href=\"modelica://Buildings.Fluid.MassExchangers.HumidifierPrescribed\">
Buildings.Fluid.MassExchangers.HumidifierPrescribed</a>.
</p>
</html>",       revisions="<html>
<ul>
<li>
February 7, 2012 by Michael Wetter:<br>
Revised base classes for conservation equations in <code>Buildings.Fluid.Interfaces</code>.
</li>
<li>
September 17, 2011 by Michael Wetter:<br>
Removed instance <code>medium</code> as this is already used in <code>dynBal</code>.
Removing the base properties led to 30% faster computing time for a solar thermal system
that contains many fluid volumes. 
</li>
<li>
September 13, 2011 by Michael Wetter:<br>
Changed in declaration of <code>medium</code> the parameter assignment
<code>preferredMediumStates=true</code> to
<code>preferredMediumStates= not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)</code>.
Otherwise, for a steady-state model, Dymola 2012 may differentiate the model to obtain <code>T</code>
as a state. See ticket Dynasim #13596.
</li>
<li>
July 26, 2011 by Michael Wetter:<br>
Revised model to use new declarations from
<a href=\"Buildings.Fluid.Interfaces.LumpedVolumeDeclarations\">
Buildings.Fluid.Interfaces.LumpedVolumeDeclarations</a>.
</li>
<li>
July 14, 2011 by Michael Wetter:<br>
Added start values for mass and internal energy of dynamic balance
model.
</li>
<li>
May 25, 2011 by Michael Wetter:<br>
<ul>
<li>
Changed implementation of balance equation. The new implementation uses a different model if 
exactly two fluid ports are connected, and in addition, the model is used as a steady-state
component. For this model configuration, the same balance equations are used as were used
for steady-state component models, i.e., instead of <code>actualStream(...)</code>, the
<code>inStream(...)</code> formulation is used.
This changed required the introduction of a new parameter <code>m_flow_nominal</code> which
is used for smoothing in the steady-state balance equations of the model with two fluid ports.
This implementation also simplifies the implementation of 
<a href=\"modelica://Buildings.Fluid.MixingVolumes.BaseClasses.PartialMixingVolumeWaterPort\">
Buildings.Fluid.MixingVolumes.BaseClasses.PartialMixingVolumeWaterPort</a>,
which now uses the same equations as this model.
</li>
<li>
Another revision was the removal of the parameter <code>use_HeatTransfer</code> as there is
no noticable overhead in always having the <code>heatPort</code> connector present.
</li>
</ul>
</li>
<li>
July 30, 2010 by Michael Wetter:<br>
Added nominal value for <code>mC</code> to avoid wrong trajectory 
when concentration is around 1E-7.
See also <a href=\"https://trac.modelica.org/Modelica/ticket/393\">
https://trac.modelica.org/Modelica/ticket/393</a>.
</li>
<li>
February 7, 2010 by Michael Wetter:<br>
Simplified model and its base classes by removing the port data
and the vessel area.
Eliminated the base class <code>PartialLumpedVessel</code>.
</li>
<li>
October 12, 2009 by Michael Wetter:<br>
Changed base class to
<a href=\"modelica://Buildings.Fluid.MixingVolumes.BaseClasses.ClosedVolume\">
Buildings.Fluid.MixingVolumes.BaseClasses.ClosedVolume</a>.
</li>
</ul>
</html>"),       Diagram(graphics),
          Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
                  100}}), graphics={Ellipse(
                extent={{-100,98},{100,-102}},
                lineColor={0,0,0},
                fillPattern=FillPattern.Sphere,
                fillColor={170,213,255}), Text(
                extent={{-58,14},{58,-18}},
                lineColor={0,0,0},
                textString="V=%V"),         Text(
                extent={{-152,100},{148,140}},
                textString="%name",
                lineColor={0,0,255})}));
      end MixingVolume;

      model MixingVolumeMoistAir
      "Mixing volume with heat port for latent heat exchange, to be used with media that contain water"
        extends BaseClasses.PartialMixingVolumeWaterPort(
          steBal(final sensibleOnly = false));
        // redeclare Medium with a more restricting base class. This improves the error
        // message if a user selects a medium that does not contain the function
        // enthalpyOfLiquid(.)
        replaceable package Medium =
          Modelica.Media.Interfaces.PartialCondensingGases
            annotation (choicesAllMatching = true);

    protected
        parameter Integer i_w(min=1, fixed=false) "Index for water substance";
        parameter Real s[Medium.nXi](fixed=false)
        "Vector with zero everywhere except where species is";

    protected
        Modelica.Blocks.Sources.RealExpression
          masExc[Medium.nXi](y=mXi_flow) if
             Medium.nXi > 0 "Block to set mass exchange in volume"
          annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
        Modelica.Blocks.Sources.RealExpression heaInp(y=heatPort.Q_flow + HWat_flow)
        "Block to set heat input into volume"
          annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
      initial algorithm
        i_w:= -1;
        if cardinality(mWat_flow) > 0 then
        for i in 1:Medium.nXi loop
            if Modelica.Utilities.Strings.isEqual(string1=Medium.substanceNames[i],
                                                  string2="Water",
                                                  caseSensitive=false) then
            i_w := i;
            s[i] :=1;
          else
            s[i] :=0;
          end if;
         end for;
          assert(i_w > 0, "Substance 'water' is not present in medium '"
               + Medium.mediumName + "'.\n"
               + "Check medium model.");
          end if;

      equation
        if cardinality(mWat_flow) == 0 then
          mWat_flow = 0;
          HWat_flow = 0;
          mXi_flow  = zeros(Medium.nXi);
        else
          if cardinality(TWat) == 0 then
             HWat_flow = mWat_flow * Medium.enthalpyOfLiquid(Medium.T_default);
          else
             HWat_flow = mWat_flow * Medium.enthalpyOfLiquid(TWat);
          end if;
        // We obtain the substance concentration with a vector multiplication
        // because Dymola 7.4 cannot find the derivative in the model
        // Buildings.Fluid.HeatExchangers.Examples.WetCoilDiscretizedPControl
        // if we set mXi_flow[i] = if ( i == i_w) then mWat_flow else 0;
          mXi_flow = mWat_flow * s;
        end if;
      // Medium species concentration
        X_w = s * Xi;

        connect(heaInp.y, steBal.Q_flow) annotation (Line(
            points={{-59,80},{-32,80},{-32,18},{-22,18}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(masExc.y, steBal.mXi_flow) annotation (Line(
            points={{-59,60},{-40,60},{-40,14},{-22,14}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(heaInp.y, dynBal.Q_flow) annotation (Line(
            points={{-59,80},{26,80},{26,16},{38,16}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(masExc.y, dynBal.mXi_flow) annotation (Line(
            points={{-59,60},{20,60},{20,12},{38,12}},
            color={0,0,127},
            smooth=Smooth.None));
        annotation (Diagram(graphics),
                             Icon(graphics),
      defaultComponentName="vol",
      Documentation(info="<html>
Model for an ideally mixed fluid volume and the ability 
to store mass and energy. The volume is fixed, 
and latent and sensible heat can be exchanged.
<p>
This model represents the same physics as 
<a href=\"modelica://Buildings.Fluid.MixingVolumes.MixingVolume\">
Buildings.Fluid.MixingVolumes.MixingVolume</a>, but in addition, it allows
adding or subtracting water in liquid phase.
The mass flow rate of the added or subtracted water is
specified at the port <code>mWat_flow</code>.
The water flow rate is assumed to be added or subtracted at the
temperature of the input port <code>TWat</code>, or 
if this port is not connected, at the medium default temperature as
defined by <code>Medium.T_default</code>.
Adding water causes a change in 
enthalpy and species concentration in the volume. 
</p>
<p>
Note that this model can only be used with medium models that include water
as a substance. In particular, the medium model needs to implement the function
<code>enthalpyOfLiquid(T)</code> and the integer variable <code>Water</code> that
contains the index to the water substance. For medium that do not provide this
functionality, use
<a href=\"modelica://Buildings.Fluid.MixingVolumes.MixingVolumeDryAir\">
Buildings.Fluid.MixingVolumes.MixingVolumeDryAir</a>.
</p>
</html>",       revisions="<html>
<ul>
<li>
February 7, 2012 by Michael Wetter:<br>
Revised base classes for conservation equations in <code>Buildings.Fluid.Interfaces</code>.
</li>
<li>
February 22, by Michael Wetter:<br>
Improved the code that searches for the index of 'water' in the medium model.
</li>
<li>
May 29, 2010 by Michael Wetter:<br>
Rewrote computation of index of water substance.
For the old formulation, Dymola 7.4 failed to differentiate the 
model when trying to reduce the index of the DAE.
</li>
<li>
August 7, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
      end MixingVolumeMoistAir;

      package BaseClasses
      "Package with base classes for Buildings.Fluid.MixingVolumes"
        extends Modelica.Icons.BasesPackage;

        partial model PartialMixingVolume
        "Partial mixing volume with inlet and outlet ports (flow reversal is allowed)"
          outer Modelica.Fluid.System system "System properties";
          extends Buildings.Fluid.Interfaces.LumpedVolumeDeclarations;
          parameter Modelica.SIunits.MassFlowRate m_flow_nominal(min=0)
          "Nominal mass flow rate"
            annotation(Dialog(group = "Nominal condition"));
          // Port definitions
          parameter Integer nPorts=0 "Number of ports"
            annotation(Evaluate=true, Dialog(connectorSizing=true, tab="General",group="Ports"));
          parameter Medium.MassFlowRate m_flow_small(min=0) = 1E-4*abs(m_flow_nominal)
          "Small mass flow rate for regularization of zero flow"
            annotation(Dialog(tab = "Advanced"));
          parameter Boolean homotopyInitialization = true
          "= true, use homotopy method"
            annotation(Evaluate=true, Dialog(tab="Advanced"));
          parameter Boolean allowFlowReversal = system.allowFlowReversal
          "= true to allow flow reversal in medium, false restricts to design direction (ports[1] -> ports[2]). Used only if model has two ports."
            annotation(Dialog(tab="Assumptions"), Evaluate=true);
          parameter Modelica.SIunits.Volume V "Volume";
          parameter Boolean prescribedHeatFlowRate=false
          "Set to true if the model has a prescribed heat flow at its heatPort"
           annotation(Evaluate=true, Dialog(tab="Assumptions",
              enable=use_HeatTransfer,
              group="Heat transfer"));
          Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b ports[nPorts](
              redeclare each package Medium = Medium)
          "Fluid inlets and outlets"
            annotation (Placement(transformation(extent={{-40,-10},{40,10}},
              origin={0,-100})));
          Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
          "Heat port connected to outflowing medium"
            annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
          Modelica.SIunits.Temperature T "Temperature of the fluid";
          Modelica.SIunits.Pressure p "Pressure of the fluid";
          Modelica.SIunits.MassFraction Xi[Medium.nXi]
          "Species concentration of the fluid";
          Medium.ExtraProperty C[Medium.nC](nominal=C_nominal)
          "Trace substance mixture content";
           // Models for the steady-state and dynamic energy balance.
      protected
          Buildings.Fluid.Interfaces.StaticTwoPortConservationEquation steBal(
            sensibleOnly = true,
            redeclare final package Medium=Medium,
            final m_flow_nominal = m_flow_nominal,
            final allowFlowReversal = allowFlowReversal,
            final m_flow_small = m_flow_small,
            final homotopyInitialization = homotopyInitialization,
            final show_V_flow = false) if
                useSteadyStateTwoPort
          "Model for steady-state balance if nPorts=2"
                annotation (Placement(transformation(extent={{-20,0},{0,20}})));
          Buildings.Fluid.Interfaces.ConservationEquation dynBal(
            redeclare final package Medium = Medium,
            final energyDynamics=energyDynamics,
            final massDynamics=massDynamics,
            final p_start=p_start,
            final T_start=T_start,
            final X_start=X_start,
            final C_start=C_start,
            final C_nominal=C_nominal,
            final fluidVolume = V,
            m(start=V*rho_nominal),
            U(start=V*rho_nominal*Medium.specificInternalEnergy(
                state_start)),
            nPorts=nPorts) if
                not useSteadyStateTwoPort "Model for dynamic energy balance"
            annotation (Placement(transformation(extent={{40,0},{60,20}})));
          parameter Medium.ThermodynamicState state_start = Medium.setState_pTX(
              T=T_start,
              p=p_start,
              X=X_start[1:Medium.nXi]) "Start state";
          parameter Modelica.SIunits.Density rho_nominal=Medium.density(
           Medium.setState_pTX(
             T=T_start,
             p=p_start,
             X=X_start[1:Medium.nXi])) "Density, used to compute fluid mass"
          annotation (Evaluate=true);
          ////////////////////////////////////////////////////
          final parameter Boolean useSteadyStateTwoPort=(nPorts == 2) and
              prescribedHeatFlowRate and (
              energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) and (
              massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) and (
              substanceDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) and (
              traceDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)
          "Flag, true if the model has two ports only and uses a steady state balance"
            annotation (Evaluate=true);
          Modelica.SIunits.HeatFlowRate Q_flow
          "Heat flow across boundaries or energy source/sink";
          // Outputs that are needed to assign the medium properties
          Modelica.Blocks.Interfaces.RealOutput hOut_internal(unit="J/kg")
          "Internal connector for leaving temperature of the component";
          Modelica.Blocks.Interfaces.RealOutput XiOut_internal[Medium.nXi](unit="1")
          "Internal connector for leaving species concentration of the component";
          Modelica.Blocks.Interfaces.RealOutput COut_internal[Medium.nC](unit="1")
          "Internal connector for leaving trace substances of the component";

        equation
          ///////////////////////////////////////////////////////////////////////////
          // asserts
          if not allowFlowReversal then
            assert(ports[1].m_flow > -m_flow_small,
        "Model has flow reversal, but the parameter allowFlowReversal is set to false.
  m_flow_small    = "         + String(m_flow_small) + "
  ports[1].m_flow = "         + String(ports[1].m_flow) + "
");
          end if;
        // Only one connection allowed to a port to avoid unwanted ideal mixing
          if not useSteadyStateTwoPort then
            for i in 1:nPorts loop
            assert(cardinality(ports[i]) == 2 or cardinality(ports[i]) == 0,"
each ports[i] of volume can at most be connected to one component.
If two or more connections are present, ideal mixing takes
place with these connections, which is usually not the intention
of the modeller. Increase nPorts to add an additional port.
");
             end for;
          end if;
          // actual definition of port variables
          // If the model computes the energy and mass balances as steady-state,
          // and if it has only two ports,
          // then we use the same base class as for all other steady state models.
          if useSteadyStateTwoPort then
          connect(steBal.port_a, ports[1]) annotation (Line(
              points={{-20,10},{-22,10},{-22,-60},{0,-60},{0,-100}},
              color={0,127,255},
              smooth=Smooth.None));

          connect(steBal.port_b, ports[2]) annotation (Line(
              points={{5.55112e-16,10},{8,10},{8,10},{8,-88},{0,-88},{0,-100}},
              color={0,127,255},
              smooth=Smooth.None));

            connect(hOut_internal,  steBal.hOut);
            connect(XiOut_internal, steBal.XiOut);
            connect(COut_internal,  steBal.COut);
          else
              connect(dynBal.ports, ports) annotation (Line(
              points={{50,-5.55112e-16},{50,-34},{2.22045e-15,-34},{2.22045e-15,-100}},
              color={0,127,255},
              smooth=Smooth.None));

            connect(hOut_internal,  dynBal.hOut);
            connect(XiOut_internal, dynBal.XiOut);
            connect(COut_internal,  dynBal.COut);
          end if;
          // Medium properties
          p = if nPorts > 0 then ports[1].p else p_start;
          T = Medium.temperature_phX(p=p, h=hOut_internal, X=cat(1,Xi,{1-sum(Xi)}));
          Xi = XiOut_internal;
          C = COut_internal;
          // Port properties
          heatPort.T = T;
          heatPort.Q_flow = Q_flow;

          annotation (
        defaultComponentName="vol",
        Documentation(info="<html>
This is a partial model of an instantaneously mixed volume.
It is used as the base class for all fluid volumes of the package
<a href=\"modelica://Buildings.Fluid.MixingVolumes\">
Buildings.Fluid.MixingVolumes</a>.
</p>
</p>
<h4>Implementation</h4>
<p>
If the model is operated in steady-state and has two fluid ports connected,
then the same energy and mass balance implementation is used as in
steady-state component models, i.e., the use of <code>actualStream</code>
is not used for the properties at the port.
</p>
<p>
For simple models that uses this model, see
<a href=\"modelica://Buildings.Fluid.MixingVolumes\">
Buildings.Fluid.MixingVolumes</a>.
</p>
</html>",         revisions="<html>
<ul>
<li>
February 7, 2012 by Michael Wetter:<br>
Revised base classes for conservation equations in <code>Buildings.Fluid.Interfaces</code>.
</li>
<li>
September 17, 2011 by Michael Wetter:<br>
Removed instance <code>medium</code> as this is already used in <code>dynBal</code>.
Removing the base properties led to 30% faster computing time for a solar thermal system
that contains many fluid volumes. 
</li>
<li>
September 13, 2011 by Michael Wetter:<br>
Changed in declaration of <code>medium</code> the parameter assignment
<code>preferredMediumStates=true</code> to
<code>preferredMediumStates= not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)</code>.
Otherwise, for a steady-state model, Dymola 2012 may differentiate the model to obtain <code>T</code>
as a state. See ticket Dynasim #13596.
</li>
<li>
July 26, 2011 by Michael Wetter:<br>
Revised model to use new declarations from
<a href=\"Buildings.Fluid.Interfaces.LumpedVolumeDeclarations\">
Buildings.Fluid.Interfaces.LumpedVolumeDeclarations</a>.
</li>
<li>
July 14, 2011 by Michael Wetter:<br>
Added start values for mass and internal energy of dynamic balance
model.
</li>
<li>
May 25, 2011 by Michael Wetter:<br>
<ul>
<li>
Changed implementation of balance equation. The new implementation uses a different model if 
exactly two fluid ports are connected, and in addition, the model is used as a steady-state
component. For this model configuration, the same balance equations are used as were used
for steady-state component models, i.e., instead of <code>actualStream(...)</code>, the
<code>inStream(...)</code> formulation is used.
This changed required the introduction of a new parameter <code>m_flow_nominal</code> which
is used for smoothing in the steady-state balance equations of the model with two fluid ports.
This implementation also simplifies the implementation of 
<a href=\"modelica://Buildings.Fluid.MixingVolumes.BaseClasses.PartialMixingVolumeWaterPort\">
Buildings.Fluid.MixingVolumes.BaseClasses.PartialMixingVolumeWaterPort</a>,
which now uses the same equations as this model.
</li>
<li>
Another revision was the removal of the parameter <code>use_HeatTransfer</code> as there is
no noticable overhead in always having the <code>heatPort</code> connector present.
</li>
</ul>
</li>
<li>
July 30, 2010 by Michael Wetter:<br>
Added nominal value for <code>mC</code> to avoid wrong trajectory 
when concentration is around 1E-7.
See also <a href=\"https://trac.modelica.org/Modelica/ticket/393\">
https://trac.modelica.org/Modelica/ticket/393</a>.
</li>
<li>
February 7, 2010 by Michael Wetter:<br>
Simplified model and its base classes by removing the port data
and the vessel area.
Eliminated the base class <code>PartialLumpedVessel</code>.
</li>
<li>
October 12, 2009 by Michael Wetter:<br>
Changed base class to
<a href=\"modelica://Buildings.Fluid.MixingVolumes.BaseClasses.ClosedVolume\">
Buildings.Fluid.MixingVolumes.BaseClasses.ClosedVolume</a>.
</li>
</ul>
</html>"),         Diagram(graphics),
            Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
                    100}}), graphics={Ellipse(
                  extent={{-100,98},{100,-102}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.Sphere,
                  fillColor={170,213,255}), Text(
                  extent={{-58,14},{58,-18}},
                  lineColor={0,0,0},
                  textString="V=%V"),         Text(
                  extent={{-152,100},{148,140}},
                  textString="%name",
                  lineColor={0,0,255})}));
        end PartialMixingVolume;

        partial model PartialMixingVolumeWaterPort
        "Partial mixing volume that allows adding or subtracting water vapor"
          extends Buildings.Fluid.MixingVolumes.BaseClasses.PartialMixingVolume;

         // additional declarations
          Modelica.Blocks.Interfaces.RealInput mWat_flow(final quantity="MassFlowRate",
                                                         final unit = "kg/s")
          "Water flow rate added into the medium"
            annotation (Placement(transformation(extent={{-140,60},{-100,100}},rotation=
                   0)));
          Modelica.Blocks.Interfaces.RealInput TWat(final quantity="Temperature",
                                                    final unit = "K", displayUnit = "degC", min=260)
          "Temperature of liquid that is drained from or injected into volume"
            annotation (Placement(transformation(extent={{-140,28},{-100,68}},
                  rotation=0)));
          Modelica.Blocks.Interfaces.RealOutput X_w
          "Species composition of medium"
            annotation (Placement(transformation(extent={{100,-60},{140,-20}}, rotation=
                   0)));
          Medium.MassFlowRate mXi_flow[Medium.nXi]
          "Mass flow rates of independent substances added to the medium";
          Modelica.SIunits.HeatFlowRate HWat_flow
          "Enthalpy flow rate of extracted water";

          annotation (
            Documentation(info="<html>
This is a partial model of an instantaneously mixed volume.
It is used as the base class for all fluid volumes of the package
<a href=\"modelica://Buildings.Fluid.MixingVolumes\">
Buildings.Fluid.MixingVolumes</a>
that add or remove humidity from the volume.
</p>
<h4>Implementation</h4>
<p>
The model is partial in order to allow a submodel that can be used with media
that contain water as a substance, and a submodel that can be used with dry air.
Having separate models is required because calls to the medium property function
<code>enthalpyOfLiquid</code> results in a linker error if a medium such as 
<a href=\"Modelica:Modelica.Media.Air.SimpleAir\">Modelica.Media.Air.SimpleAir</a>
is used that does not implement this function.
</p>
</html>",         revisions="<html>
<ul>
<li>
February 7, 2012 by Michael Wetter:<br>
Revised base classes for conservation equations in <code>Buildings.Fluid.Interfaces</code>.
</li>
<li>
January 10, 2011 by Michael Wetter:<br>
Removed <code>ports_p_static</code> and used instead <code>medium.p</code> since
<code>ports_p_static</code> is not available in 
<a href=\"modelica://Buildings.Fluid.MixingVolumes.MixingVolume\">
Buildings.Fluid.MixingVolumes.MixingVolume</a> which is sometimes used to replace this model.
</li>
<li>
July 30, 2010 by Michael Wetter:<br>
Added nominal value for <code>mC</code> to avoid wrong trajectory 
when concentration is around 1E-7.
See also <a href=\"https://trac.modelica.org/Modelica/ticket/393\">
https://trac.modelica.org/Modelica/ticket/393</a>.
</li>
<li>
March 24, 2010 by Michael Wetter:<br>
Changed base class from <code>Modelica.Fluid</code> to <code>Buildings.Fluid</code>.
<li>
August 12, 2008 by Michael Wetter:<br>
Introduced option to compute model in steady state. This allows the heat exchanger model
to switch from a dynamic model for the medium to a steady state model.
</li>
<li>
August 13, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),         Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                    -100},{100,100}}),
                           graphics),
            Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
                    100}}), graphics={
                Text(
                  extent={{-76,-6},{198,-48}},
                  lineColor={255,255,255},
                  fillColor={0,0,0},
                  fillPattern=FillPattern.Solid,
                  textString="X_w"),
                Text(
                  extent={{-122,114},{-80,82}},
                  lineColor={0,0,0},
                  textString="mWat_flow"),
                Text(
                  extent={{-152,74},{-42,50}},
                  lineColor={0,0,0},
                  textString="TWat"),
                Ellipse(
                  extent={{-100,100},{100,-100}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.Sphere,
                  fillColor={170,213,255}),
                Text(
                  extent={{-60,16},{56,-16}},
                  lineColor={0,0,0},
                  textString="V=%V")}));
        end PartialMixingVolumeWaterPort;
      annotation (preferedView="info", Documentation(info="<html>
<p>
This package contains base classes that are used to construct the models in
<a href=\"modelica://Buildings.Fluid.MixingVolumes\">Buildings.Fluid.MixingVolumes</a>.
</p>
</html>"));
      end BaseClasses;
    annotation (Documentation(info="<html>
<p>
This package contains models for completely mixed volumes.
Optionally, heat can be added to the volume by setting the 
parameter <code>use_HeatTransfer</code> to <code>true</code>.
</p>
<p>
For most situations, the model
<a href=\"modelica://Buildings.Fluid.MixingVolumes.MixingVolume\">
Buildings.Fluid.MixingVolumes.MixingVolume</a> should be used.
The other models are only of interest if water should be added to
or subtracted from the fluid volume, such as needed in a 
dynamic model of a coil with water vapor condensation.
</p>
</html>"));
    end MixingVolumes;

    package Movers "Package with fan and pump models"
      extends Modelica.Icons.VariantsPackage;

      model FlowMachine_y
      "Fan or pump with ideally controlled normalized speed y as input signal"
        extends Buildings.Fluid.Movers.BaseClasses.PrescribedFlowMachine(
        final N_nominal=1500 "fix N_nominal as it is used only for scaling");

        Modelica.Blocks.Interfaces.RealInput y(min=0, max=1, unit="1")
        "Constant normalized rotational speed"
          annotation (Placement(transformation(
              extent={{-20,-20},{20,20}},
              rotation=-90,
              origin={0,120}), iconTransformation(
              extent={{-20,-20},{20,20}},
              rotation=-90,
              origin={0,120})));

    protected
        Modelica.Blocks.Math.Gain gaiSpe(final k=N_nominal,
          u(min=0, max=1),
          y(final quantity="AngularVelocity",
            final unit="1/min",
            nominal=N_nominal)) "Gain for speed input signal"
          annotation (Placement(transformation(extent={{-6,64},{6,76}})));
      equation
        connect(y, gaiSpe.u) annotation (Line(
            points={{1.11022e-15,120},{0,104},{0,104},{0,92},{-20,92},{-20,70},{-7.2,
                70}},
            color={0,0,127},
            smooth=Smooth.None));

         connect(filter.y, N_filtered) annotation (Line(
            points={{34.7,88},{50,88}},
            color={0,0,127},
            smooth=Smooth.None));

        if filteredSpeed then
          connect(gaiSpe.y, filter.u) annotation (Line(
            points={{6.6,70},{12.6,70},{12.6,88},{18.6,88}},
            color={0,0,127},
            smooth=Smooth.None));
          connect(filter.y, N_actual) annotation (Line(
            points={{34.7,88},{38,88},{38,70},{50,70}},
            color={0,0,127},
            smooth=Smooth.None));
        else
          connect(gaiSpe.y, N_actual) annotation (Line(
            points={{6.6,70},{50,70}},
            color={0,0,127},
            smooth=Smooth.None));
        end if;

        annotation (defaultComponentName="fan",
          Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
                  100}}), graphics={Text(extent={{10,124},{102,102}},textString
                =   "y_in [0, 1]")}),
          Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
                  100}}),     graphics),
          Documentation(info="<html>
<p>
This model describes a fan or pump with prescribed normalized speed.
The input connector provides the normalized rotational speed (between 0 and 1).
The head is computed based on the performance curve that take as an argument
the actual volume flow rate divided by the maximum flow rate and the relative
speed of the fan.
The efficiency of the device is computed based
on the efficiency curves that take as an argument
the actual volume flow rate divided by the maximum possible volume flow rate, or
based on the motor performance curves.
</p>
<p>
See the 
<a href=\"modelica://Buildings.Fluid.Movers.UsersGuide\">
User's Guide</a> for more information.
</p>
</html>",   revisions="<html>
<ul>
<li>
February 14, 2012, by Michael Wetter:<br>
Added filter for start-up and shut-down transient.
</li>
<li>
May 25, 2011, by Michael Wetter:<br>
Revised implementation of energy balance to avoid having to use conditionally removed models.
</li>
<li>
July 27, 2010, by Michael Wetter:<br>
Redesigned model to fix bug in medium balance.
</li>
<li>March 24, 2010, by Michael Wetter:<br>
Revised implementation to allow zero flow rate.
</li>
<li>October 1, 2009,
    by Michael Wetter:<br>
       Model added to the Buildings library. Changed control signal from rpm to normalized value between 0 and 1</li>
<li><i>31 Oct 2005</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       Model added to the Fluid library</li>
</ul>
</html>"));
      end FlowMachine_y;

      package BaseClasses
      "Package with base classes for Buildings.Fluid.Movers"
        extends Modelica.Icons.BasesPackage;

        package Characteristics "Functions for fan or pump characteristics"

          record flowParameters "Record for flow parameters"
            extends Modelica.Icons.Record;
            parameter Modelica.SIunits.VolumeFlowRate V_flow[:](each min=0)
            "Volume flow rate at user-selected operating points";
            parameter Modelica.SIunits.Pressure dp[size(V_flow,1)](
               each min=0, each displayUnit="Pa")
            "Fan or pump total pressure at these flow rates";
            annotation (Documentation(info="<html>
<p>
Data record for performance data that describe volume flow rate versus
pressure rise.
The volume flow rate <code>V_flow</code> must be increasing, i.e.,
<code>V_flow[i] &lt; V_flow[i+1]</code>.
Both vectors, <code>V_flow</code> and <code>dp</code>
must have the same size.
</p>
</html>", revisions="<html>
<ul>
<li>
September 28, 2011, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
          end flowParameters;

          record efficiencyParameters "Record for efficiency parameters"
            extends Modelica.Icons.Record;
            parameter Real  r_V[:](each min=0, each max=1, each displayUnit="1")
            "Volumetric flow rate divided by nominal flow rate at user-selected operating points";
            parameter Real eta[size(r_V,1)](
               each min=0, each max=1, each displayUnit="1")
            "Fan or pump efficiency at these flow rates";
            annotation (Documentation(info="<html>
<p>
Data record for performance data that describe volume flow rate versus
efficiency.
The volume flow rate <code>r_V</code> must be increasing, i.e.,
<code>r_V[i] &lt; r_V[i+1]</code>.
Both vectors, <code>r_V</code> and <code>eta</code>
must have the same size.
</p>
</html>", revisions="<html>
<ul>
<li>
September 28, 2011, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
          end efficiencyParameters;

          record powerParameters "Record for electrical power parameters"
            extends Modelica.Icons.Record;
            parameter Modelica.SIunits.VolumeFlowRate V_flow[:](each min=0)= {0}
            "Volume flow rate at user-selected operating points";
            parameter Modelica.SIunits.Power P[size(V_flow,1)](
               each min=0, max=1, each displayUnit="1") = {0}
            "Fan or pump electrical power at these flow rates";
            annotation (Documentation(info="<html>
<p>
Data record for performance data that describe volume flow rate versus
electrical power.
The volume flow rate <code>V_flow</code> must be increasing, i.e.,
<code>V_flow[i] &lt; V_flow[i+1]</code>.
Both vectors, <code>V_flow</code> and <code>P</code>
must have the same size.
</p>
</html>", revisions="<html>
<ul>
<li>
September 28, 2011, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
          end powerParameters;

          function pressure
          "Flow vs. head characteristics for fan or pump pressure raise"
            extends Modelica.Icons.Function;
            input
            Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters       data
            "Pressure performance data";
            input Modelica.SIunits.VolumeFlowRate V_flow "Volumetric flow rate";
            input Real r_N(unit="1") "Relative revolution, r_N=N/N_nominal";
            input Modelica.SIunits.VolumeFlowRate VDelta_flow
            "Small volume flow rate";
            input Modelica.SIunits.Pressure dpDelta "Small pressure";

            input Modelica.SIunits.VolumeFlowRate V_flow_max
            "Maximum volume flow rate at r_N=1 and dp=0";
            input Modelica.SIunits.Pressure dpMax(min=0)
            "Maximum pressure at r_N=1 and V_flow=0";

            input Real d[:]
            "Derivatives at support points for spline interpolation";
            input Real delta
            "Small value used to transition to other fan curve";
            input Real cBar[2]
            "Coefficients for linear approximation of pressure vs. flow rate";
            input Real kRes(unit="kg/(s.m4)")
            "Linear coefficient for fan-internal pressure drop";
            output Modelica.SIunits.Pressure dp "Pressure raise";

        protected
             Integer dimD(min=2)=size(data.V_flow, 1)
            "Dimension of data vector";

            function performanceCurve "Performance curve away from the origin"
              input Modelica.SIunits.VolumeFlowRate V_flow
              "Volumetric flow rate";
              input Real r_N(unit="1") "Relative revolution, r_N=N/N_nominal";
              input Real d[dimD]
              "Coefficients for polynomial of pressure vs. flow rate";
              input
              Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters
                                                                                      data
              "Pressure performance data";
              input Integer dimD "Dimension of data vector";

              output Modelica.SIunits.Pressure dp "Pressure raise";

          protected
              Modelica.SIunits.VolumeFlowRate rat "Ratio of V_flow/r_N";
              Integer i "Integer to select data interval";
            algorithm
              rat := V_flow/r_N;
              i :=1;
              // Since the coefficients for the spline were evaluated for
              // rat_nominal = V_flow_nominal/r_N_nominal = V_flow_nominal/1, we use
              // V_flow_nominal below
              for j in 1:dimD-1 loop
                 if rat > data.V_flow[j] then
                   i := j;
                 end if;
              end for;
              // Extrapolate or interpolate the data
              dp:=r_N^2*Buildings.Utilities.Math.Functions.cubicHermiteLinearExtrapolation(
                          x=rat,
                          x1=data.V_flow[i],
                          x2=data.V_flow[i + 1],
                          y1=data.dp[i],
                          y2=data.dp[i + 1],
                          y1d=d[i],
                          y2d=d[i+1]);
              annotation(smoothOrder=1);
            end performanceCurve;

          algorithm
            if r_N >= delta then
               dp := performanceCurve(V_flow=V_flow, r_N=r_N, d=d,
                                      data=data, dimD=dimD);
            elseif r_N <= delta/2 then
              dp := flowApproximationAtOrigin(r_N=r_N, V_flow=V_flow,
                                              VDelta_flow=  VDelta_flow, dpDelta=dpDelta,
                                              delta=delta, cBar=cBar);
            else
              dp := Modelica.Fluid.Utilities.regStep(x=r_N-0.75*delta,
                                                     y1=performanceCurve(V_flow=V_flow, r_N=r_N, d=d,
                                                                         data=data, dimD=dimD),
                                                     y2=flowApproximationAtOrigin(r_N=r_N, V_flow=V_flow,
                                                             VDelta_flow=VDelta_flow, dpDelta=dpDelta,
                                                             delta=delta, cBar=cBar),
                                                     x_small=delta/4);
            end if;
            dp := dp - V_flow*kRes;
            annotation(smoothOrder=1,
                        Documentation(info="<html>
<p>
This function computes the fan static
pressure raise as a function of volume flow rate and revolution in the form
</p>
<p align=\"center\" style=\"font-style:italic;\">
  &Delta;p = r<sub>N</sub><sup>2</sup> &nbsp; s(V/r<sub>N</sub>, d)
  - &Delta;p<sub>r</sub> ,
</p>
<p>
where
<i>&Delta;p</i> is the pressure rise,
<i>r<sub>N</sub></i> is the normalized fan speed,
<i>V</i> is the volume flow rate and
<i>d</i> are performance data for fan or pump power consumption at <i>r<sub>N</sub>=1</i>.
The term
</p>
<p align=\"center\" style=\"font-style:italic;\">
&Delta;p<sub>r</sub> = V &nbsp; &Delta;p<sub>max</sub> &frasl; V<sub>max</sub> &nbsp; &delta;
</p>
<p>
models the flow resistance of the fan, approximated using a linear equation. 
This is done for numerical reasons to avoid a singularity at <i>r<sub>N</sub>=0</i>. Since <i>&delta;</i> is small, the contribution of this term is small.
The fan and pump models in 
<a href=\"modelica://Buildings.Fluid.Movers\">
Buildings.Fluid.Movers</a> modify the user-supplied performance data to add the term
<i>&Delta;p<sub>r</sub></i> prior to computing the performance curve.
Thus, at full speed, the fan or pump can operate exactly at the user-supplied performance data.
</p>
<h4>Implementation</h4>
<p>
The function <i>s(&middot;, &middot;)</i> is a cubic hermite spline.
If the data <i>d</i> define a monotone decreasing sequence, then 
<i>s(&middot;, d)</i> is a monotone decreasing function.
</p>
<p>
For <i>r<sub>N</sub> &lt; &delta;</i>, the polynomial is replaced with an other model to avoid
a singularity at the origin. The composite model is once continuously differentiable
in all input variables.
</p>
</html>",         revisions="<html>
<ul>
<li>
August 25, 2011, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),             smoothOrder=1);
          end pressure;

          function flowApproximationAtOrigin
          "Approximation for fan or pump pressure raise at origin"
            extends Modelica.Icons.Function;
            input Modelica.SIunits.VolumeFlowRate V_flow "Volumetric flow rate";
            input Real r_N(unit="1") "Relative revolution, r_N=N/N_nominal";
            input Modelica.SIunits.VolumeFlowRate VDelta_flow
            "Small volume flow rate";
            input Modelica.SIunits.Pressure dpDelta "Small pressure";
            input Real delta
            "Small value used to transition to other fan curve";
            input Real cBar[2]
            "Coefficients for linear approximation of pressure vs. flow rate";
            output Modelica.SIunits.Pressure dp "Pressure raise";
          algorithm
            dp := r_N * dpDelta + r_N^2 * (cBar[1] + cBar[2]*V_flow);
            annotation (Documentation(info="<html>
<p>
This function computes the fan static
pressure raise as a function of volume flow rate and revolution near the origin.
It is used to avoid a singularity in the pump or fan curve if the revolution 
approaches zero.
</p>
</html>",         revisions="<html>
<ul>
<li>
August 25, 2011, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),             smoothOrder=100);
          end flowApproximationAtOrigin;

          function power
          "Flow vs. electrical power characteristics for fan or pump"
            extends Modelica.Icons.Function;
            input
            Buildings.Fluid.Movers.BaseClasses.Characteristics.powerParameters       data
            "Pressure performance data";
            input Modelica.SIunits.VolumeFlowRate V_flow "Volumetric flow rate";
            input Real r_N(unit="1") "Relative revolution, r_N=N/N_nominal";
            input Real d[:]
            "Derivatives at support points for spline interpolation";
            output Modelica.SIunits.Power P "Power consumption";

        protected
             Integer n=size(data.V_flow, 1) "Dimension of data vector";

             Modelica.SIunits.VolumeFlowRate rat "Ratio of V_flow/r_N";
             Integer i "Integer to select data interval";

          algorithm
            if n == 1 then
              P := r_N^3*data.P[1];
            else
              i :=1;
              // Since the coefficients for the spline were evaluated for
              // rat_nominal = V_flow_nominal/r_N_nominal = V_flow_nominal/1, we use
              // V_flow_nominal below
              for j in 1:n-1 loop
                 if V_flow > data.V_flow[j] then
                   i := j;
                 end if;
              end for;
              // Extrapolate or interpolate the data
              P:=r_N^3*Buildings.Utilities.Math.Functions.cubicHermiteLinearExtrapolation(
                          x=V_flow,
                          x1=data.V_flow[i],
                          x2=data.V_flow[i + 1],
                          y1=data.P[i],
                          y2=data.P[i + 1],
                          y1d=d[i],
                          y2d=d[i+1]);
            end if;
            annotation(smoothOrder=1,
                        Documentation(info="<html>
<p>
This function computes the fan power consumption for given volume flow rate,
speed and performance data. The power consumption is
</p>
<p align=\"center\" style=\"font-style:italic;\">
  P = r<sub>N</sub><sup>3</sup> &nbsp; s(V, d),
</p>
<p>
where
<i>P</i> is the power consumption,
<i>r<sub>N</sub></i> is the normalized fan speed,
<i>V</i> is the volume flow rate and
<i>d</i> are performance data for fan or pump power consumption at <i>r<sub>N</sub>=1</i>.
</p>
<h4>Implementation</h4>
<p>
The function <i>s(&middot;, &middot;)</i> is a cubic hermite spline.
If the data <i>d</i> define a monotone decreasing sequence, then 
<i>s(&middot;, d)</i> is a monotone decreasing function.
</p>
</html>",         revisions="<html>
<ul>
<li>
September 28, 2011, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),             smoothOrder=1);
          end power;

          function efficiency
          "Flow vs. efficiency characteristics for fan or pump"
            extends Modelica.Icons.Function;
            input
            Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters
              data "Efficiency performance data";
            input Real r_V(unit="1")
            "Volumetric flow rate divided by nominal flow rate";
            input Real d[:]
            "Derivatives at support points for spline interpolation";
            output Real eta(min=0, unit="1") "Efficiency";

        protected
            Integer n = size(data.r_V, 1) "Number of data points";
            Integer i "Integer to select data interval";
          algorithm
            if n == 1 then
              eta := data.eta[1];
            else
              i :=1;
              for j in 1:n-1 loop
                 if r_V > data.r_V[j] then
                   i := j;
                 end if;
              end for;
              // Extrapolate or interpolate the data
              eta:=Buildings.Utilities.Math.Functions.cubicHermiteLinearExtrapolation(
                          x=r_V,
                          x1=data.r_V[i],
                          x2=data.r_V[i + 1],
                          y1=data.eta[i],
                          y2=data.eta[i + 1],
                          y1d=d[i],
                          y2d=d[i+1]);
            end if;

            annotation(smoothOrder=1,
                        Documentation(info="<html>
<p>
This function computes the fan or pump efficiency for given normalized volume flow rate
and performance data. The efficiency is
</p>
<p align=\"center\" style=\"font-style:italic;\">
  &eta; = s(r<sub>V</sub>, d),
</p>
<p>
where
<i>&eta;</i> is the efficiency,
<i>r<sub>V</sub></i> is the normalized volume flow rate, and
<i>d</i> are performance data for fan or pump efficiency.
</p>
<h4>Implementation</h4>
<p>
The function <i>s(&middot;, &middot;)</i> is a cubic hermite spline.
If the data <i>d</i> define a monotone decreasing sequence, then 
<i>s(&middot;, d)</i> is a monotone decreasing function.
</p>
</html>",         revisions="<html>
<ul>
<li>
September 28, 2011, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),             smoothOrder=1);
          end efficiency;
          annotation (Documentation(info="<html>
<p>
This package implements performance curves for fans and pumps,
and records for parameter that can be used with these performance
curves.
</p>
<p>
The following performance curves are implemented:
<table border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
<tr>
<th>Independent variable</th>
<th>Dependent variable</th>
<th>Record for performance data</th>
<th>Function</th>
</tr>
<tr>
<td>Volume flow rate</td>
<td>Pressure</td>
<td><a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters\">
flowParameters</a></td>
<td><a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.pressure\">
pressure</a></td>
</tr>
<tr>
<td>Relative volumetric flow rate</td>
<td>Efficiency</td>
<td><a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters\">
efficiencyParameters</a></td>
<td><a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiency\">
efficiency</a></td>
</tr>
<tr>
<td>Volume flow rate</td>
<td>Power</td>
<td><a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.powerParameters\">
powerParameters</a></td>
<td><a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.power\">
power</a></td>
</tr>
</table>
</p>
</html>",
        revisions="<html>
<ul>
<li>
September 29, 2011, by Michael Wetter:<br>
New implementation due to changes from polynomial to cubic hermite splines.
</li>
</ul>
</html>"));
        end Characteristics;

        partial model PrescribedFlowMachine
        "Partial model for fan or pump with speed (y or Nrpm) as input signal"
          extends Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface(
            V_flow_max(start=V_flow_nominal),
            final rho_nominal = Medium.density_pTX(Medium.p_default, Medium.T_default, Medium.X_default));

          extends Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine(
              final show_V_flow = false,
              final m_flow_nominal = max(pressure.V_flow)*rho_nominal,
              preSou(final control_m_flow=false));

          // Models
      protected
          Modelica.Blocks.Sources.RealExpression dpMac(y=-dpMachine)
          "Pressure drop of the pump or fan"
            annotation (Placement(transformation(extent={{0,20},{20,40}})));

          Modelica.Blocks.Sources.RealExpression PToMedium_flow(y=Q_flow + WFlo) if  addPowerToMedium
          "Heat and work input into medium"
            annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
        equation
         VMachine_flow = -port_b.m_flow/rho;
         rho = rho_in;

          connect(preSou.dp_in, dpMac.y) annotation (Line(
              points={{36,8},{36,30},{21,30}},
              color={0,0,127},
              smooth=Smooth.None));
          connect(PToMedium_flow.y, prePow.Q_flow) annotation (Line(
              points={{-79,20},{-70,20}},
              color={0,0,127},
              smooth=Smooth.None));
          annotation (
            Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
                    100}}), graphics),
            Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
                    100}}),
                    graphics),
            Documentation(info="<html>
<p>This is the base model for fans and pumps that take as 
input a control signal in the form of the pump speed <code>Nrpm</code>
or the normalized pump speed <code>y=Nrpm/N_nominal</code>.
</p>
</html>",     revisions="<html>
<ul>
<li>
May 25, 2011, by Michael Wetter:<br>
Revised implementation of energy balance to avoid having to use conditionally removed models.
</li>
<li>
July 27, 2010, by Michael Wetter:<br>
Redesigned model to fix bug in medium balance.
</li>
<li>March 24 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
        end PrescribedFlowMachine;

        partial model PartialFlowMachine
        "Partial model to interface fan or pump models with the medium"
          extends Buildings.Fluid.Interfaces.LumpedVolumeDeclarations;
          import Modelica.Constants;

          extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(show_T=false,
            port_a(
              h_outflow(start=h_outflow_start),
              final m_flow(min = if allowFlowReversal then -Constants.inf else 0)),
            port_b(
              h_outflow(start=h_outflow_start),
              p(start=p_start),
              final m_flow(max = if allowFlowReversal then +Constants.inf else 0)),
              final showDesignFlowDirection=false);

          Delays.DelayFirstOrder vol(
            redeclare package Medium = Medium,
            tau=tau,
            energyDynamics=if dynamicBalance then energyDynamics else Modelica.Fluid.Types.Dynamics.SteadyState,
            massDynamics=if dynamicBalance then massDynamics else Modelica.Fluid.Types.Dynamics.SteadyState,
            T_start=T_start,
            X_start=X_start,
            C_start=C_start,
            m_flow_nominal=m_flow_nominal,
            p_start=p_start,
            prescribedHeatFlowRate=true,
            allowFlowReversal=allowFlowReversal,
            nPorts=2) "Fluid volume for dynamic model"
            annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
           parameter Boolean dynamicBalance = true
          "Set to true to use a dynamic balance, which often leads to smaller systems of equations"
            annotation (Evaluate=true, Dialog(tab="Dynamics", group="Equations"));

          parameter Boolean addPowerToMedium=true
          "Set to false to avoid any power (=heat and flow work) being added to medium (may give simpler equations)";

          parameter Modelica.SIunits.Time tau=1
          "Time constant of fluid volume for nominal flow, used if dynamicBalance=true"
            annotation (Dialog(tab="Dynamics", group="Nominal condition", enable=dynamicBalance));

          // Models
          Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
            annotation (Placement(transformation(extent={{-70,-90},{-50,-70}}),
                iconTransformation(extent={{-10,-78},{10,-58}})));

      protected
          Modelica.SIunits.Density rho_in "Density of inflowing fluid";

          Buildings.Fluid.Movers.BaseClasses.IdealSource preSou(
          redeclare package Medium = Medium,
            allowFlowReversal=allowFlowReversal) "Pressure source"
            annotation (Placement(transformation(extent={{20,-10},{40,10}})));

          Buildings.HeatTransfer.Sources.PrescribedHeatFlow prePow if addPowerToMedium
          "Prescribed power (=heat and flow work) flow for dynamic model"
            annotation (Placement(transformation(extent={{-70,10},{-50,30}})));

          parameter Medium.ThermodynamicState sta_start=Medium.setState_pTX(
              T=T_start, p=p_start, X=X_start);
          parameter Modelica.SIunits.SpecificEnthalpy h_outflow_start = Medium.specificEnthalpy(sta_start)
          "Start value for outflowing enthalpy";

        equation
          // For computing the density, we assume that the fan operates in the design flow direction.
          rho_in = Medium.density(
               Medium.setState_phX(port_a.p, inStream(port_a.h_outflow), inStream(port_a.Xi_outflow)));
          connect(prePow.port, vol.heatPort) annotation (Line(
              points={{-50,20},{-44,20},{-44,10},{-40,10}},
              color={191,0,0},
              smooth=Smooth.None));

          connect(vol.heatPort, heatPort) annotation (Line(
              points={{-40,10},{-40,-80},{-60,-80}},
              color={191,0,0},
              smooth=Smooth.None));
          connect(port_a, vol.ports[1]) annotation (Line(
              points={{-100,5.55112e-16},{-66,5.55112e-16},{-66,-5.55112e-16},{-32,
                  -5.55112e-16}},
              color={0,127,255},
              smooth=Smooth.None));
          connect(vol.ports[2], preSou.port_a) annotation (Line(
              points={{-28,-5.55112e-16},{-5,-5.55112e-16},{-5,6.10623e-16},{20,
                  6.10623e-16}},
              color={0,127,255},
              smooth=Smooth.None));
          connect(preSou.port_b, port_b) annotation (Line(
              points={{40,6.10623e-16},{70,6.10623e-16},{70,5.55112e-16},{100,
                  5.55112e-16}},
              color={0,127,255},
              smooth=Smooth.None));
          annotation (
            Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,100}}),
                            graphics={
                Line(
                  visible=not filteredSpeed,
                  points={{0,100},{0,40}},
                  color={0,0,0},
                  smooth=Smooth.None),
                Rectangle(
                  extent={{-100,16},{100,-14}},
                  lineColor={0,0,0},
                  fillColor={0,127,255},
                  fillPattern=FillPattern.HorizontalCylinder),
                Ellipse(
                  extent={{-58,50},{54,-58}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.Sphere,
                  fillColor={0,100,199}),
                Polygon(
                  points={{0,50},{0,-56},{54,2},{0,50}},
                  lineColor={0,0,0},
                  pattern=LinePattern.None,
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={255,255,255}),
                Ellipse(
                  extent={{4,14},{34,-16}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.Sphere,
                  visible=dynamicBalance,
                  fillColor={0,100,199}),
                Rectangle(
                  visible=filteredSpeed,
                  extent={{-34,40},{32,100}},
                  lineColor={0,0,0},
                  fillColor={135,135,135},
                  fillPattern=FillPattern.Solid),
                Ellipse(
                  visible=filteredSpeed,
                  extent={{-34,100},{32,40}},
                  lineColor={0,0,0},
                  fillColor={135,135,135},
                  fillPattern=FillPattern.Solid),
                Text(
                  visible=filteredSpeed,
                  extent={{-22,92},{20,46}},
                  lineColor={0,0,0},
                  fillColor={135,135,135},
                  fillPattern=FillPattern.Solid,
                  textString="M",
                  textStyle={TextStyle.Bold})}),
            Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
                    100}}),
                    graphics),
            Documentation(info="<html>
<p>This is the base model for fans and pumps.
It provides an interface
between the equations that compute head and power consumption,
and the implementation of the energy and pressure balance
of the fluid.
</p>
<p>
Depending on the value of
the parameter <code>dynamicBalance</code>, the fluid volume
is computed using a dynamic balance or a steady-state balance.
</p>
<p>
The parameter <code>addPowerToMedium</code> determines whether 
any power is added to the fluid. The default is <code>addPowerToMedium=true</code>,
and hence the outlet enthalpy is higher than the inlet enthalpy if the
flow device is operating.
The setting <code>addPowerToMedium=false</code> is physically incorrect
(since the flow work, the flow friction and the fan heat do not increase
the enthalpy of the medium), but this setting does in some cases lead to simpler equations
and more robust simulation, in particular if the mass flow is equal to zero.
</p>
</html>",     revisions="<html>
<ul>
<li>
May 25, 2011, by Michael Wetter:<br>
Revised implementation of energy balance to avoid having to use conditionally removed models.
</li>
<li>
July 29, 2010, by Michael Wetter:<br>
Reduced fan time constant from 10 to 1 second.
</li>
<li>
July 27, 2010, by Michael Wetter:<br>
Redesigned model to fix bug in medium balance.
</li>
<li>March 24 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
        end PartialFlowMachine;

        model IdealSource
        "Base class for pressure and mass flow source with optional power input"
          extends Modelica.Fluid.Interfaces.PartialTwoPortTransport(show_V_flow=false,
                                                                    show_T=false);

          // what to control
          parameter Boolean control_m_flow
          "= false to control dp instead of m_flow"
            annotation(Evaluate = true);
          Modelica.Blocks.Interfaces.RealInput m_flow_in if control_m_flow
          "Prescribed mass flow rate"
            annotation (Placement(transformation(
                extent={{-20,-20},{20,20}},
                rotation=-90,
                origin={-50,82}), iconTransformation(
                extent={{-20,-20},{20,20}},
                rotation=-90,
                origin={-60,80})));
          Modelica.Blocks.Interfaces.RealInput dp_in if not control_m_flow
          "Prescribed outlet pressure"
            annotation (Placement(transformation(
                extent={{-20,-20},{20,20}},
                rotation=-90,
                origin={50,82}), iconTransformation(
                extent={{-20,-20},{20,20}},
                rotation=-90,
                origin={60,80})));

      protected
          Modelica.Blocks.Interfaces.RealInput m_flow_internal
          "Needed to connect to conditional connector";
          Modelica.Blocks.Interfaces.RealInput dp_internal
          "Needed to connect to conditional connector";
        equation

          // Ideal control
          if control_m_flow then
            m_flow = m_flow_internal;
            dp_internal = 0;
          else
            dp = dp_internal;
            m_flow_internal = 0;
          end if;

          connect(dp_internal, dp_in);
          connect(m_flow_internal, m_flow_in);

          // Energy balance (no storage)
          port_a.h_outflow = inStream(port_b.h_outflow);
          port_b.h_outflow = inStream(port_a.h_outflow);

          annotation (Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
                    -100},{100,100}}), graphics={
                Rectangle(
                  extent={{-100,60},{100,-60}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={192,192,192}),
                Rectangle(
                  extent={{-100,50},{100,-48}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={0,127,255}),
                Text(
                  visible=not control_m_flow,
                  extent={{24,44},{80,24}},
                  lineColor={255,255,255},
                  textString="dp"),
                Text(
                  visible=control_m_flow,
                  extent={{-80,44},{-24,24}},
                  lineColor={255,255,255},
                  textString="m")}),
            Documentation(info="<html>
<p>
Model of a fictious pipe that is used as a base class
for a pressure source or to prescribe a mass flow rate.
</p>
<p>
Note that for fans and pumps with dynamic balance,
both the heat and the flow work are added to the volume of
air or water. This simplifies the equations compared to 
adding heat to the volume, and flow work to this model.
</p>
</html>",
        revisions="<html>
<ul>
<li>
May 25, 2011 by Michael Wetter:<br>
Removed the option to add power to the medium, as this is dealt with in the volume
that is used in the mover model.
</li>
<li>
July 27, 2010 by Michael Wetter:<br>
Redesigned model to fix bug in medium balance.
</li>
<li>
April 13, 2010 by Michael Wetter:<br>
Made heat connector optional.
</li>
<li>
March 23, 2010 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),  Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
                    100,100}}),
                            graphics));
        end IdealSource;

        partial model PowerInterface
        "Partial model to compute power draw and heat dissipation of fans and pumps"

          import Modelica.Constants;

          parameter Boolean use_powerCharacteristic = false
          "Use powerCharacteristic (vs. efficiencyCharacteristic)"
             annotation(Evaluate=true,Dialog(group="Characteristics"));

          parameter Boolean motorCooledByFluid = true
          "If true, then motor heat is added to fluid stream"
            annotation(Dialog(group="Characteristics"));
          parameter Boolean homotopyInitialization = true
          "= true, use homotopy method"
            annotation(Evaluate=true, Dialog(tab="Advanced"));

          parameter
          Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters
              motorEfficiency(r_V={1}, eta={0.7})
          "Normalized volume flow rate vs. efficiency"
            annotation(Placement(transformation(extent={{60,-40},{80,-20}})),
                       Dialog(group="Characteristics"),
                       enable = not use_powerCharacteristic);
          parameter
          Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters
              hydraulicEfficiency(r_V={1}, eta={0.7})
          "Normalized volume flow rate vs. efficiency"
            annotation(Placement(transformation(extent={{60,-80},{80,-60}})),
                       Dialog(group="Characteristics"),
                       enable = not use_powerCharacteristic);

          parameter Modelica.SIunits.Density rho_nominal
          "Nominal fluid density";

          Modelica.SIunits.Power PEle "Electrical power input";
          Modelica.SIunits.Power WHyd
          "Hydraulic power input (converted to flow work and heat)";
          Modelica.SIunits.Power WFlo "Flow work";
          Modelica.SIunits.HeatFlowRate Q_flow
          "Heat input from fan or pump to medium";
          Real eta(min=0, max=1) "Global efficiency";
          Real etaHyd(min=0, max=1) "Hydraulic efficiency";
          Real etaMot(min=0, max=1) "Motor efficiency";

          Modelica.SIunits.Pressure dpMachine(displayUnit="Pa")
          "Pressure increase";
          Modelica.SIunits.VolumeFlowRate VMachine_flow "Volume flow rate";
      protected
          parameter Modelica.SIunits.VolumeFlowRate V_flow_max(fixed=false)
          "Maximum volume flow rate, used for smoothing";
          //Modelica.SIunits.HeatFlowRate QThe_flow "Heat input into the medium";
          parameter Modelica.SIunits.VolumeFlowRate delta_V_flow = 1E-3*V_flow_max
          "Factor used for setting heat input into medium to zero at very small flows";
          final parameter Real motDer[size(motorEfficiency.r_V, 1)](fixed=false)
          "Coefficients for polynomial of pressure vs. flow rate"
            annotation (Evaluate=true);
          final parameter Real hydDer[size(hydraulicEfficiency.r_V,1)](fixed=false)
          "Coefficients for polynomial of pressure vs. flow rate"
            annotation (Evaluate=true);

          Modelica.SIunits.HeatFlowRate QThe_flow
          "Heat input from fan or pump to medium";

        initial algorithm
         // Compute derivatives for cubic spline
         motDer :=
           if use_powerCharacteristic then
             zeros(size(motorEfficiency.r_V, 1))
           elseif ( size(motorEfficiency.r_V, 1) == 1)  then
               {0}
           else
              Buildings.Utilities.Math.Functions.splineDerivatives(
              x=motorEfficiency.r_V,
              y=motorEfficiency.eta);
          hydDer :=
             if use_powerCharacteristic then
               zeros(size(hydraulicEfficiency.r_V, 1))
             elseif ( size(hydraulicEfficiency.r_V, 1) == 1)  then
               {0}
             else
               Buildings.Utilities.Math.Functions.splineDerivatives(
                           x=hydraulicEfficiency.r_V,
                           y=hydraulicEfficiency.eta);
        equation
          eta = etaHyd * etaMot;
          WFlo = eta * PEle;
          // Flow work
          WFlo = dpMachine*VMachine_flow;
          // Hydraulic power (transmitted by shaft), etaHyd = WFlo/WHyd
          etaHyd * WHyd   = WFlo;
          // Heat input into medium
          QThe_flow +  WFlo = if motorCooledByFluid then PEle else WHyd;
          // At m_flow = 0, the solver may still obtain positive values for QThe_flow.
          // The next statement sets the heat input into the medium to zero for very small flow rates.
          if homotopyInitialization then
            Q_flow = homotopy(actual=Buildings.Utilities.Math.Functions.spliceFunction(pos=QThe_flow, neg=0,
                               x=noEvent(abs(VMachine_flow))-2*delta_V_flow, deltax=delta_V_flow),
                             simplified=0);
          else
            Q_flow = Buildings.Utilities.Math.Functions.spliceFunction(pos=QThe_flow, neg=0,
                               x=noEvent(abs(VMachine_flow))-2*delta_V_flow, deltax=delta_V_flow);
          end if;
          annotation (
            Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
                    100}}), graphics),
            Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
                    100,100}}),
                    graphics),
            Documentation(info="<html>
<p>This is an interface that implements the functions to compute the power draw and the
heat dissipation of fans and pumps. It is used by the model 
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface\">
Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface</a>.
</p>
</html>",     revisions="<html>
<ul>
<li><i>March 1, 2010</i>
    by Michael Wetter:<br>
    Revised implementation to allow <code>N=0</code>.
<li><i>October 1, 2009</i>
    by Michael Wetter:<br>
    Changed model so that it is based on total pressure in Pascals instead of the pump head in meters.
    This change is needed if the device is used with air as a medium. The original formulation in Modelica.Fluid
    converts head to pressure using the density medium.d. Therefore, for fans, head would be converted to pressure
    using the density of air. However, for fans, manufacturers typically publish the head in 
    millimeters water (mmH20). Therefore, to avoid confusion and to make this model applicable for any medium,
    the model has been changed to use total pressure in Pascals instead of head in meters.
</li>
<li><i>31 Oct 2005</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       Model added to the Fluid library</li>
</ul>
</html>"));
        end PowerInterface;

        partial model FlowMachineInterface
        "Partial model with performance curves for fans or pumps"
          extends Buildings.Fluid.Movers.BaseClasses.PowerInterface(
            VMachine_flow(nominal=V_flow_nominal, start=V_flow_nominal),
            V_flow_max(nominal=V_flow_nominal, start=V_flow_nominal));

          import Modelica.Constants;
          import cha = Buildings.Fluid.Movers.BaseClasses.Characteristics;

          parameter Modelica.SIunits.Conversions.NonSIunits.AngularVelocity_rpm
            N_nominal = 1500 "Nominal rotational speed for flow characteristic"
            annotation(Dialog(group="Characteristics"));
          final parameter Modelica.SIunits.VolumeFlowRate V_flow_nominal = pressure.V_flow[size(pressure.V_flow,1)]
          "Nominal volume flow rate, used for homotopy";
          parameter
          Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters           pressure
          "Volume flow rate vs. total pressure rise"
            annotation(Placement(transformation(extent={{20,-80},{40,-60}})),
                       Dialog(group="Characteristics"));
          parameter
          Buildings.Fluid.Movers.BaseClasses.Characteristics.powerParameters           power
          "Volume flow rate vs. electrical power consumption"
            annotation(Placement(transformation(extent={{20,-40},{40,-20}})),
                       Dialog(group="Characteristics", enable = use_powerCharacteristic));

          parameter Boolean homotopyInitialization = true
          "= true, use homotopy method"
            annotation(Evaluate=true, Dialog(tab="Advanced"));

          // Classes used to implement the filtered speed
          parameter Boolean filteredSpeed=true
          "= true, if speed is filtered with a 2nd order CriticalDamping filter"
            annotation(Dialog(tab="Dynamics", group="Filtered speed"));
          parameter Modelica.SIunits.Time riseTime=30
          "Rise time of the filter (time to reach 99.6 % of the speed)"
            annotation(Dialog(tab="Dynamics", group="Filtered speed",enable=filteredSpeed));
          parameter Modelica.Blocks.Types.Init init=Modelica.Blocks.Types.Init.InitialOutput
          "Type of initialization (no init/steady state/initial state/initial output)"
            annotation(Dialog(tab="Dynamics", group="Filtered speed",enable=filteredSpeed));
          parameter Real N_start=0 "Initial value of speed"
            annotation(Dialog(tab="Dynamics", group="Filtered speed",enable=filteredSpeed));

          // Speed
          Modelica.Blocks.Interfaces.RealOutput N_actual(min=0, max=N_nominal,
                                                         final quantity="AngularVelocity",
                                                         final unit="1/min",
                                                         nominal=N_nominal)
            annotation (Placement(transformation(extent={{40,60},{60,80}})));

          // "Shaft rotational speed in rpm";
          Real r_N(min=0, start=N_start/N_nominal, unit="1")
          "Ratio N_actual/N_nominal";
          Real r_V(start=1, unit="1") "Ratio V_flow/V_flow_max";

      protected
          Modelica.Blocks.Interfaces.RealOutput N_filtered(min=0, start=N_start, max=N_nominal) if
             filteredSpeed "Filtered speed in the range 0..N_nominal"
            annotation (Placement(transformation(extent={{40,78},{60,98}}),
                iconTransformation(extent={{60,50},{80,70}})));
          Modelica.Blocks.Continuous.Filter filter(
             order=2,
             f_cut=5/(2*Modelica.Constants.pi*riseTime),
             final init=init,
             final y_start=N_start,
             x(each stateSelect=StateSelect.always),
             u_nominal=N_nominal,
             u(final quantity="AngularVelocity", final unit="1/min", nominal=N_nominal),
             y(final quantity="AngularVelocity", final unit="1/min", nominal=N_nominal),
             final analogFilter=Modelica.Blocks.Types.AnalogFilter.CriticalDamping,
             final filterType=Modelica.Blocks.Types.FilterType.LowPass) if
                filteredSpeed
          "Second order filter to approximate valve opening time, and to improve numerics"
            annotation (Placement(transformation(extent={{20,81},{34,95}})));
          parameter Modelica.SIunits.VolumeFlowRate VDelta_flow(fixed=false, start=delta*V_flow_nominal)
          "Small volume flow rate";
          parameter Modelica.SIunits.Pressure dpDelta(fixed=false, start=100)
          "Small pressure";
          parameter Real delta = 0.05
          "Small value used to transition to other fan curve";
          parameter Real cBar[2](fixed=false)
          "Coefficients for linear approximation of pressure vs. flow rate";
          parameter Modelica.SIunits.Pressure dpMax(min=0, fixed=false);
          parameter Real kRes(min=0, unit="kg/(s.m4)", fixed=false)
          "Coefficient for internal pressure drop of fan or pump";

          parameter Integer curve(min=1, max=3, fixed=false)
          "Flag, used to pick the right representatio of the fan or pump pressure curve";
          parameter
          Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters           pCur1(
            V_flow(each fixed=false)=zeros(nOri), dp(each fixed=false))
          "Volume flow rate vs. total pressure rise with correction for pump resistance added";
          parameter
          Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters           pCur2(
            V_flow(each fixed=false)=zeros(nOri+1), dp(each fixed=false))
          "Volume flow rate vs. total pressure rise with correction for pump resistance added";
          parameter
          Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters           pCur3(
            V_flow(each fixed=false)=zeros(nOri+2), dp(each fixed=false))
          "Volume flow rate vs. total pressure rise with correction for pump resistance added";
          parameter Integer nOri = size(pressure.V_flow,1)
          "Number of data points for pressure curve";
          parameter Real preDer1[nOri](fixed=false)
          "Derivatives of flow rate vs. pressure at the support points";
          parameter Real preDer2[nOri+1](fixed=false)
          "Derivatives of flow rate vs. pressure at the support points";
          parameter Real preDer3[nOri+2](fixed=false)
          "Derivatives of flow rate vs. pressure at the support points";
          parameter Real powDer[size(power.V_flow,1)]=
           if use_powerCharacteristic then
             Buildings.Utilities.Math.Functions.splineDerivatives(
                           x=power.V_flow,
                           y=power.P)
           else
             zeros(size(power.V_flow,1))
          "Coefficients for polynomial of pressure vs. flow rate";

          parameter Boolean haveMinimumDecrease(fixed=false)
          "Flag used for reporting";
          parameter Boolean haveDPMax(fixed=false)
          "Flag, true if user specified data that contain dpMax";
          parameter Boolean haveVMax(fixed=false)
          "Flag, true if user specified data that contain V_flow_max";

          // Variables
          Modelica.SIunits.Density rho "Medium density";

        function getPerformanceDataAsString
          input
            Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters     pressure
            "Performance data";
          input Real derivative[:](unit="kg/(s.m4)") "Derivative";
          input Integer minimumLength =  6 "Minimum width of result";
          input Integer significantDigits = 6 "Number of significant digits";
          output String str "String representation";
        algorithm
          str :="";
          for i in 1:size(derivative, 1) loop
            str :=str + "  V_flow[" + String(i) + "]=" + String(
                pressure.V_flow[i],
                minimumLength=minimumLength,
                significantDigits=significantDigits) + "\t" + "dp[" + String(i) + "]=" +
                String(
                pressure.dp[i],
                minimumLength=minimumLength,
                significantDigits=significantDigits) + "\tResulting derivative dp/dV_flow = "
                 + String(
                derivative[i],
                minimumLength=minimumLength,
                significantDigits=significantDigits) + "\n";
          end for;
        end getPerformanceDataAsString;

        function getArrayAsString
          input Real array[:] "Array to be printed";
          input String varName "Variable name";
          input Integer minimumLength =  6 "Minimum width of result";
          input Integer significantDigits = 6 "Number of significant digits";
          output String str "String representation";
        algorithm
          str :="";
          for i in 1:size(array, 1) loop
            str :=str + "  " + varName + "[" + String(i) + "]=" + String(
                array[i],
                minimumLength=minimumLength,
                significantDigits=significantDigits) + "\n";
          end for;
        end getArrayAsString;

        initial algorithm
          // Check validity of data
          assert(size(pressure.V_flow, 1) > 1, "Must have at least two data points for pressure.V_flow.");
          assert(Buildings.Utilities.Math.Functions.isMonotonic(x=pressure.V_flow, strict=true) and
          pressure.V_flow[1] > -Modelica.Constants.eps,
          "The volume flow rate for the fan pressure rise must be a strictly decreasing sequence
  with the first element being non-zero.
The following performance data have been entered:
"         + getArrayAsString(pressure.V_flow, "pressure.V_flow"));

          // Check if V_flow_max or dpMax are provided by user
          haveVMax  :=(abs(pressure.dp[nOri])   < Modelica.Constants.eps);
          haveDPMax :=(abs(pressure.V_flow[1])  < Modelica.Constants.eps);
          // Assign V_flow_max and dpMax
          if haveVMax then
            V_flow_max :=pressure.V_flow[nOri];
          else
            assert((pressure.V_flow[nOri]-pressure.V_flow[nOri-1])/((pressure.dp[nOri]-pressure.dp[nOri-1]))<0,
            "The last two pressure points for the fan or pump performance curve must be decreasing.
    You need to set more reasonable parameters.
Received 
"         + getArrayAsString(pressure.dp, "dp"));
            V_flow_max :=pressure.V_flow[nOri] - (pressure.V_flow[nOri] - pressure.V_flow[
              nOri - 1])/((pressure.dp[nOri] - pressure.dp[nOri - 1]))*pressure.dp[nOri];
          end if;
          if haveDPMax then
            dpMax :=pressure.dp[1];
          else
            dpMax :=pressure.dp[1] - ((pressure.dp[2] - pressure.dp[1])/(pressure.V_flow[
              2] - pressure.V_flow[1]))*pressure.V_flow[1];
          end if;

          // Check if minimum decrease condition is satisfied
          haveMinimumDecrease :=true;
          kRes :=dpMax/V_flow_max*delta^2/10;
          for i in 1:nOri-1 loop
            if ((pressure.dp[i+1]-pressure.dp[i])/(pressure.V_flow[i+1]-pressure.V_flow[i]) >= -kRes) then
              haveMinimumDecrease :=false;
            end if;
          end for;
          // Write warning if the volumetric flow rate versus pressure curve does not satisfy
          // the minimum decrease condition
          if (not haveMinimumDecrease) then
            Modelica.Utilities.Streams.print("
Warning:
========
It is recommended that the volume flow rate versus pressure relation
of the fan or pump satisfies the minimum decrease condition

        (pressure.dp[i+1]-pressure.dp[i])
d[i] = ----------------------------------------- < "         + String(-kRes) + "
       (pressure.V_flow[i+1]-pressure.V_flow[i])
 
is "         + getArrayAsString({(pressure.dp[i+1]-pressure.dp[i])/(pressure.V_flow[i+1]-pressure.V_flow[i]) for i in 1:nOri-1}, "d") + "
Otherwise, a solution to the equations may not exist if the fan or pump speed is reduced.
In this situation, the solver will fail due to non-convergence and 
the simulation stops.");
          end if;

          // Correction for flow resistance of pump or fan
          // Case 1:
          if (haveVMax and haveDPMax) or (nOri == 2) then
            curve :=1; // V_flow_max and dpMax are provided by the user, or we only have two data points
            for i in 1:nOri loop
              pCur1.dp[i]  :=pressure.dp[i] + pressure.V_flow[i] * kRes;
              pCur1.V_flow[i] := pressure.V_flow[i];
            end for;
              pCur2.V_flow := zeros(nOri + 1);
              pCur2.dp     := zeros(nOri + 1);
              pCur3.V_flow := zeros(nOri + 2);
              pCur3.dp     := zeros(nOri + 2);
              preDer1:=Buildings.Utilities.Math.Functions.splineDerivatives(x=pCur1.V_flow, y=pCur1.dp);
              preDer2:=zeros(nOri+1);
              preDer3:=zeros(nOri+2);
          elseif haveVMax or haveDPMax then
            curve :=2; // V_flow_max or dpMax is provided by the user, but not both
            if haveVMax then
              pCur2.V_flow[1] := 0;
              pCur2.dp[1]     := dpMax;
              for i in 1:nOri loop
                pCur2.dp[i+1]  :=pressure.dp[i] + pressure.V_flow[i] * kRes;
                pCur2.V_flow[i+1] := pressure.dp[i];
              end for;
            else
              for i in 1:nOri loop
                pCur2.dp[i]  :=pressure.dp[i] + pressure.V_flow[i] * kRes;
                pCur2.V_flow[i] := pressure.V_flow[i];
              end for;
              pCur2.V_flow[nOri+1] := V_flow_max;
              pCur2.dp[nOri+1]     := 0;
            end if;
            pCur1.V_flow := zeros(nOri);
            pCur1.dp     := zeros(nOri);
            pCur3.V_flow := zeros(nOri + 2);
            pCur3.dp     := zeros(nOri + 2);
            preDer1:=zeros(nOri);
            preDer2:=Buildings.Utilities.Math.Functions.splineDerivatives(x=pCur2.V_flow, y=pCur2.dp);
            preDer3:=zeros(nOri+2);
          else
            curve :=3; // Neither V_flow_max nor dpMax are provided by the user
            pCur3.V_flow[1] := 0;
            pCur3.dp[1]     := dpMax;
            for i in 1:nOri loop
              pCur3.dp[i+1]  :=pressure.dp[i] + pressure.V_flow[i] * kRes;
              pCur3.V_flow[i+1] := pressure.V_flow[i];
            end for;
            pCur3.V_flow[nOri+2] := V_flow_max;
            pCur3.dp[nOri+2]     := 0;
            pCur1.V_flow := zeros(nOri);
            pCur1.dp     := zeros(nOri);
            pCur2.V_flow := zeros(nOri + 1);
            pCur2.dp     := zeros(nOri + 1);
            preDer1:=zeros(nOri);
            preDer2:=zeros(nOri+1);
            preDer3:=Buildings.Utilities.Math.Functions.splineDerivatives(x=pCur3.V_flow, y=pCur3.dp);
          end if;

          // Equation to compute VDelta_flow. By the affinity laws, the volume flow rate is proportional to the speed.
          VDelta_flow :=V_flow_max*delta;

          // Equation to compute dpDelta
          dpDelta :=cha.pressure(
            data=if (curve == 1) then pCur1 elseif (curve == 2) then pCur2 else pCur3,
            V_flow=0,
            r_N=delta,
            VDelta_flow=0,
            dpDelta=0,
            V_flow_max=Modelica.Constants.eps,
            dpMax=0,
            delta=0,
            d=if (curve == 1) then preDer1 elseif (curve == 2) then preDer2 else preDer3,
            cBar=zeros(2),
            kRes=  kRes);

          // Linear equations to determine cBar
          // Conditions for r_N=delta, V_flow = VDelta_flow
          // Conditions for r_N=delta, V_flow = 0
          cBar[1] :=cha.pressure(
            data=if (curve == 1) then pCur1 elseif (curve == 2) then pCur2 else pCur3,
            V_flow=0,
            r_N=delta,
            VDelta_flow=0,
            dpDelta=0,
            V_flow_max=Modelica.Constants.eps,
            dpMax=0,
            delta=0,
            d=if (curve == 1) then preDer1 elseif (curve == 2) then preDer2 else preDer3,
            cBar=zeros(2),
            kRes=  kRes) * (1-delta)/delta^2;

          cBar[2] :=((cha.pressure(
            data=if (curve == 1) then pCur1 elseif (curve == 2) then pCur2 else pCur3,
            V_flow=VDelta_flow,
            r_N=delta,
            VDelta_flow=0,
            dpDelta=0,
            V_flow_max=Modelica.Constants.eps,
            dpMax=0,
            delta=0,
            d=if (curve == 1) then preDer1 elseif (curve == 2) then preDer2 else preDer3,
            cBar=zeros(2),
            kRes=  kRes) - delta*dpDelta)/delta^2 - cBar[1])/VDelta_flow;
        equation

          // Hydraulic equations
          r_N = N_actual/N_nominal;
          r_V = VMachine_flow/V_flow_max;
          // For the homotopy method, we approximate dpMachine by an equation
          // that is linear in VMachine_flow, and that goes linearly to 0 as r_N goes to 0.
          // The three branches below are identical, except that we pass either
          // pCur1, pCur2 or pCur3, and preDer1, preDer2 or preDer3
          if (curve == 1) then
            if homotopyInitialization then
               dpMachine = homotopy(actual=cha.pressure(data=pCur1,
                                                            V_flow=VMachine_flow, r_N=r_N,
                                                            VDelta_flow=VDelta_flow, dpDelta=dpDelta,
                                                            V_flow_max=V_flow_max, dpMax=dpMax,
                                                            delta=delta, d=preDer1, cBar=cBar, kRes=kRes),
                                  simplified=r_N*
                                      (cha.pressure(data=pCur1,
                                                            V_flow=V_flow_nominal, r_N=1,
                                                            VDelta_flow=VDelta_flow, dpDelta=dpDelta,
                                                            V_flow_max=V_flow_max, dpMax=dpMax,
                                                            delta=delta, d=preDer1, cBar=cBar, kRes=kRes)
                                       +(VMachine_flow-V_flow_nominal)*
                                        (cha.pressure(data=pCur1,
                                                            V_flow=(1+delta)*V_flow_nominal, r_N=1,
                                                            VDelta_flow=VDelta_flow, dpDelta=dpDelta,
                                                            V_flow_max=V_flow_max, dpMax=dpMax,
                                                            delta=delta, d=preDer1, cBar=cBar, kRes=kRes)
                                        -cha.pressure(data=pCur1,
                                                            V_flow=(1-delta)*V_flow_nominal, r_N=1,
                                                            VDelta_flow=VDelta_flow, dpDelta=dpDelta,
                                                            V_flow_max=V_flow_max, dpMax=dpMax,
                                                            delta=delta, d=preDer1, cBar=cBar, kRes=kRes))
                                         /(2*delta*V_flow_nominal)));

             else
               dpMachine = cha.pressure(data=pCur1, V_flow=VMachine_flow, r_N=r_N,
                                                        VDelta_flow=VDelta_flow, dpDelta=dpDelta, V_flow_max=V_flow_max, dpMax=dpMax,
                                                        delta=delta, d=preDer1, cBar=cBar, kRes=kRes);
             end if;
             // end of computation for this branch
           elseif (curve == 2) then
            if homotopyInitialization then
               dpMachine = homotopy(actual=cha.pressure(data=pCur2,
                                                            V_flow=VMachine_flow, r_N=r_N,
                                                            VDelta_flow=VDelta_flow, dpDelta=dpDelta,
                                                            V_flow_max=V_flow_max, dpMax=dpMax,
                                                            delta=delta, d=preDer2, cBar=cBar, kRes=kRes),
                                  simplified=r_N*
                                      (cha.pressure(data=pCur2,
                                                            V_flow=V_flow_nominal, r_N=1,
                                                            VDelta_flow=VDelta_flow, dpDelta=dpDelta,
                                                            V_flow_max=V_flow_max, dpMax=dpMax,
                                                            delta=delta, d=preDer2, cBar=cBar, kRes=kRes)
                                       +(VMachine_flow-V_flow_nominal)*
                                        (cha.pressure(data=pCur2,
                                                            V_flow=(1+delta)*V_flow_nominal, r_N=1,
                                                            VDelta_flow=VDelta_flow, dpDelta=dpDelta,
                                                            V_flow_max=V_flow_max, dpMax=dpMax,
                                                            delta=delta, d=preDer2, cBar=cBar, kRes=kRes)
                                        -cha.pressure(data=pCur2,
                                                            V_flow=(1-delta)*V_flow_nominal, r_N=1,
                                                            VDelta_flow=VDelta_flow, dpDelta=dpDelta,
                                                            V_flow_max=V_flow_max, dpMax=dpMax,
                                                            delta=delta, d=preDer2, cBar=cBar, kRes=kRes))
                                         /(2*delta*V_flow_nominal)));

             else
               dpMachine = cha.pressure(data=pCur2, V_flow=VMachine_flow, r_N=r_N,
                                                        VDelta_flow=VDelta_flow, dpDelta=dpDelta, V_flow_max=V_flow_max, dpMax=dpMax,
                                                        delta=delta, d=preDer2, cBar=cBar, kRes=kRes);
             end if;
             // end of computation for this branch
          else
            if homotopyInitialization then
               dpMachine = homotopy(actual=cha.pressure(data=pCur3,
                                                            V_flow=VMachine_flow, r_N=r_N,
                                                            VDelta_flow=VDelta_flow, dpDelta=dpDelta,
                                                            V_flow_max=V_flow_max, dpMax=dpMax,
                                                            delta=delta, d=preDer3, cBar=cBar, kRes=kRes),
                                  simplified=r_N*
                                      (cha.pressure(data=pCur3,
                                                            V_flow=V_flow_nominal, r_N=1,
                                                            VDelta_flow=VDelta_flow, dpDelta=dpDelta,
                                                            V_flow_max=V_flow_max, dpMax=dpMax,
                                                            delta=delta, d=preDer3, cBar=cBar, kRes=kRes)
                                       +(VMachine_flow-V_flow_nominal)*
                                        (cha.pressure(data=pCur3,
                                                            V_flow=(1+delta)*V_flow_nominal, r_N=1,
                                                            VDelta_flow=VDelta_flow, dpDelta=dpDelta,
                                                            V_flow_max=V_flow_max, dpMax=dpMax,
                                                            delta=delta, d=preDer3, cBar=cBar, kRes=kRes)
                                        -cha.pressure(data=pCur3,
                                                            V_flow=(1-delta)*V_flow_nominal, r_N=1,
                                                            VDelta_flow=VDelta_flow, dpDelta=dpDelta,
                                                            V_flow_max=V_flow_max, dpMax=dpMax,
                                                            delta=delta, d=preDer3, cBar=cBar, kRes=kRes))
                                         /(2*delta*V_flow_nominal)));

             else
               dpMachine = cha.pressure(data=pCur3, V_flow=VMachine_flow, r_N=r_N,
                                                        VDelta_flow=VDelta_flow, dpDelta=dpDelta, V_flow_max=V_flow_max, dpMax=dpMax,
                                                        delta=delta, d=preDer3, cBar=cBar, kRes=kRes);
             end if;
             // end of computation for this branch
          end if;
          // Power consumption
          if use_powerCharacteristic then
            // For the homotopy, we want PEle/V_flow to be bounded as V_flow -> 0 to avoid a very high medium
            // temperature near zero flow.
            if homotopyInitialization then
              PEle = homotopy(actual=cha.power(data=power, V_flow=VMachine_flow, r_N=r_N, d=powDer),
                              simplified=VMachine_flow/V_flow_nominal*
                                    cha.power(data=power, V_flow=V_flow_nominal, r_N=1, d=powDer));
            else
              PEle = (rho/rho_nominal)*cha.power(data=power, V_flow=VMachine_flow, r_N=r_N, d=powDer);
            end if;
            // In this configuration, we only now the total power consumption.
            // Hence, we assign the efficiency in equal parts to the motor and the hydraulic losses
            etaMot = sqrt(eta);
          else
            if homotopyInitialization then
              etaHyd = homotopy(actual=cha.efficiency(data=hydraulicEfficiency,     r_V=r_V, d=hydDer),
                                simplified=cha.efficiency(data=hydraulicEfficiency, r_V=1,   d=hydDer));
              etaMot = homotopy(actual=cha.efficiency(data=motorEfficiency,     r_V=r_V, d=motDer),
                                simplified=cha.efficiency(data=motorEfficiency, r_V=1,   d=motDer));
            else
              etaHyd = cha.efficiency(data=hydraulicEfficiency, r_V=r_V, d=hydDer);
              etaMot = cha.efficiency(data=motorEfficiency,     r_V=r_V, d=motDer);
            end if;
          end if;

          annotation (
            Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
                    100}}), graphics={
                Line(
                  points={{0,70},{40,70}},
                  color={0,0,0},
                  smooth=Smooth.None)}),
            Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
                    100,100}}),
                    graphics),
            Documentation(info="<html>
<p>
This is an interface that implements the functions to compute the head, power draw 
and efficiency of fans and pumps. It is used by the model 
<a href=\"modelica://Buildings.Fluids.Movers.BaseClasses.PrescribedFlowMachine\">PrescribedFlowMachine</a>.
</p>
<p>
The nominal hydraulic characteristic (volume flow rate versus total pressure) is given by a set of data points.
A cubic hermite spline with linear extrapolation is used to compute the performance at other
operating points.
</p>
<p>The fan or pump energy balance can be specified in two alternative ways: </p>
<p>
<ul>
<li>
If <code>use_powerCharacteristic = false</code>, then the data points for
normalized volume flow rate versus efficiency is used to determine the efficiency, 
and then the power consumption. The default is a constant efficiency of 0.8.
</li>
<li>
If <code>use_powerCharacteristic = true</code>, then the data points for
normalized volume flow rate versus power consumption
is used to determine the power consumption, and then the efficiency
is computed based on the actual power consumption and the flow work. 
</p>
<h4>Implementation</h4>
<p>
For numerical reasons, the user-provided data points for volume flow rate 
versus pressure rise are modified to add a fan internal flow resistance.
Because this flow resistance is subtracted during the simulation when
computing the fan pressure rise, the model reproduces the exact points 
that were provided by the user.
</p>
<p>
Also for numerical reasons, the pressure rise at zero flow rate and 
the flow rate at zero pressure rise is added to the user-provided data,
unless the user already provides these data points.
Since Modelica 3.2 does not allow dynamic memory allocation, this 
implementation required the use of three different arrays for the 
situation where no additional point is added, where one additional
point is added and where two additional points are added.
The parameter <code>curve</code> causes the correct data record
to be used during the simulation.
</p>
</html>",
        revisions="<html>
<ul>
<li>
February 20, 2012, by Michael Wetter:<br>
Assigned value to nominal attribute of <code>VMachine_flow</code>.
</li>
<li>
February 14, 2012, by Michael Wetter:<br>
Added filter for start-up and shut-down transient.
</li>
<li>
October 4 2011, by Michael Wetter:<br>
Revised the implementation of the pressure drop computation as a function
of speed and volume flow rate.
The new implementation avoids a singularity near zero volume flow rate and zero speed.
</li>
<li>
March 28 2011, by Michael Wetter:<br>
Added <code>homotopy</code> operator.
</li>
<li>
March 23 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
        end FlowMachineInterface;
      annotation (preferedView="info", Documentation(info="<html>
<p>
This package contains base classes that are used to construct the models in
<a href=\"modelica://Buildings.Fluid.Movers\">Buildings.Fluid.Movers</a>.
</p>
</html>"));
      end BaseClasses;
    annotation (preferedView="info", Documentation(info="<html>
This package contains components models for fans and pumps.
</html>"));
    end Movers;

    package Sensors "Package with sensor models"
      extends Modelica.Icons.SensorsPackage;

      model EnthalpyFlowRate "Ideal enthalphy flow rate sensor"
        extends Buildings.Fluid.Sensors.BaseClasses.PartialDynamicFlowSensor(tau=0);
        extends Modelica.Icons.RotationalSensor;
        Modelica.Blocks.Interfaces.RealOutput H_flow(unit="W")
        "Enthalpy flow rate, positive if from port_a to port_b"
          annotation (Placement(transformation(
              origin={0,110},
              extent={{-10,-10},{10,10}},
              rotation=90)));
        parameter Modelica.SIunits.SpecificEnthalpy h_out_start=
          Medium.specificEnthalpy_pTX(Medium.p_default, Medium.T_default, Medium.X_default)
        "Initial or guess value of measured specific enthalpy"
          annotation (Dialog(group="Initialization"));
        Modelica.SIunits.SpecificEnthalpy hMed_out(start=h_out_start)
        "Medium enthalpy to which the sensor is exposed";
        Modelica.SIunits.SpecificEnthalpy h_out(start=h_out_start)
        "Medium enthalpy that is used to compute the enthalpy flow rate";
      initial equation
        if dynamic then
          if initType == Modelica.Blocks.Types.Init.SteadyState then
            der(h_out) = 0;
          elseif initType == Modelica.Blocks.Types.Init.InitialState or
                 initType == Modelica.Blocks.Types.Init.InitialOutput then
            h_out = h_out_start;
          end if;
        end if;
      equation
        if allowFlowReversal then
          hMed_out = Modelica.Fluid.Utilities.regStep(port_a.m_flow,
                       port_b.h_outflow,
                       port_a.h_outflow, m_flow_small);
        else
          hMed_out = port_b.h_outflow;
        end if;
        // Specific enthalpy measured by sensor
        if dynamic then
          der(h_out) = (hMed_out-h_out)*k/tau;
        else
          h_out = hMed_out;
        end if;
        // Sensor output signal
        H_flow = port_a.m_flow * h_out;
      annotation (defaultComponentName="senEntFlo",
        Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
                  100}}), graphics),
        Icon(graphics={
              Line(points={{-100,0},{-70,0}}, color={0,128,255}),
              Line(points={{70,0},{100,0}}, color={0,128,255}),
              Line(points={{0,100},{0,70}}, color={0,0,127}),
              Text(
                extent={{180,151},{20,99}},
                lineColor={0,0,0},
                textString="H_flow")}),
        Documentation(info="<html>
<p>
This component monitors the enthalphy flow rate of the medium in the flow
between fluid ports. The sensor is ideal, i.e., it does not influence the fluid.
</p>
<p>
If the parameter <code>tau</code> is non-zero, then the measured
specific enthalpy <i>h<sub>out</sub></i> that is used to 
compute the enthalpy flow rate 
<i>H&#775; = m&#775; h<sub>out</sub></i> 
is computed using a first order differential equation. 
See <a href=\"modelica://Buildings.Fluid.Sensors.UsersGuide\">
Buildings.Fluid.Sensors.UsersGuide</a> for an explanation.
</p>
<p>
For a sensor that measures the latent enthalpy flow rate, use
<a href=\"modelica://Buildings.Fluid.Sensors.LatentEnthalpyFlowRate\">
Buildings.Fluid.Sensors.LatentEnthalpyFlowRate</a>.
</p>
</html>
",       revisions="<html>
<html>
<p>
<ul>
<li>
June 3, 2011 by Michael Wetter:<br>
Revised implementation to add dynamics in such a way that 
the time constant increases as the mass flow rate tends to zero.
This can improve the numerics.
</li>
<li>
April 9, 2008 by Michael Wetter:<br>
First implementation.
Implementation is based on enthalpy sensor of <code>Modelica.Fluid</code>.
</li>
</ul>
</html>"));
      end EnthalpyFlowRate;

      model SensibleEnthalpyFlowRate
      "Ideal enthalphy flow rate sensor that outputs the sensible enthalpy flow rate only"
        extends Buildings.Fluid.Sensors.BaseClasses.PartialDynamicFlowSensor(tau=0);
        extends Modelica.Icons.RotationalSensor;
        // redeclare Medium with a more restricting base class. This improves the error
        // message if a user selects a medium that does not contain the function
        // enthalpyOfLiquid(.)
        replaceable package Medium =
            Modelica.Media.Interfaces.PartialCondensingGases
            annotation (choicesAllMatching = true);
        parameter Integer i_w = 1 "Index for water substance";
        Modelica.Blocks.Interfaces.RealOutput H_flow(unit="W")
        "Sensible enthalpy flow rate, positive if from port_a to port_b"
          annotation (Placement(transformation(
              origin={0,110},
              extent={{-10,-10},{10,10}},
              rotation=90)));
        parameter Modelica.SIunits.SpecificEnthalpy h_out_start=
          Medium.enthalpyOfNonCondensingGas(
            Medium.temperature(Medium.setState_phX(
              Medium.p_default, Medium.T_default, Medium.X_default)))
        "<html>Initial or guess value of measured specific <b>sensible</b> enthalpy</html>"
          annotation (Dialog(group="Initialization"));
        Modelica.SIunits.SpecificEnthalpy hMed_out(start=h_out_start)
        "Medium sensible enthalpy to which the sensor is exposed";
        Modelica.SIunits.SpecificEnthalpy h_out(start=h_out_start)
        "Medium sensible enthalpy that is used to compute the enthalpy flow rate";
    protected
        Medium.MassFraction XiActual[Medium.nXi]
        "Medium mass fraction to which sensor is exposed to";
        Medium.SpecificEnthalpy hActual
        "Medium enthalpy to which sensor is exposed to";
        Medium.ThermodynamicState sta
        "Medium state to which sensor is exposed to";
        parameter Integer i_w_internal(fixed=false) "Index for water substance";
      initial algorithm
        // Compute index of species vector that carries the water vapor concentration
        i_w_internal :=-1;
          for i in 1:Medium.nXi loop
            if Modelica.Utilities.Strings.isEqual(string1=Medium.substanceNames[i],
                                                  string2="Water",
                                                  caseSensitive=false) then
              i_w_internal :=i;
            end if;
          end for;
        assert(i_w_internal > 0, "Substance 'water' is not present in medium '"
                        + Medium.mediumName + "'.\n"
                        + "Change medium model to one that has 'water' as a substance.");
        assert(i_w == i_w_internal, "Parameter 'i_w' must be set to '" + String(i_w) + "'.\n");
      initial equation
       // Compute initial state
       if dynamic then
          if initType == Modelica.Blocks.Types.Init.SteadyState then
            der(h_out) = 0;
          elseif initType == Modelica.Blocks.Types.Init.InitialState or
                 initType == Modelica.Blocks.Types.Init.InitialOutput then
            h_out = h_out_start;
          end if;
        end if;
      equation
        if allowFlowReversal then
           XiActual = Modelica.Fluid.Utilities.regStep(port_a.m_flow,
                       port_b.Xi_outflow,
                       port_a.Xi_outflow, m_flow_small);
           hActual = Modelica.Fluid.Utilities.regStep(port_a.m_flow,
                       port_b.h_outflow,
                       port_a.h_outflow, m_flow_small);
        else
           XiActual = port_b.Xi_outflow;
           hActual = port_b.h_outflow;
        end if;
        // Specific enthalpy measured by sensor
        sta = Medium.setState_phX(port_a.p, hActual, XiActual);
        hMed_out = (1-XiActual[i_w]) * Medium.enthalpyOfNonCondensingGas(
            Medium.temperature(sta));
        if dynamic then
          der(h_out) = (hMed_out-h_out)*k/tau;
        else
          h_out = hMed_out;
        end if;
        // Sensor output signal
        H_flow = port_a.m_flow * h_out;
      annotation (defaultComponentName="senEntFlo",
        Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
                  100}}), graphics),
        Icon(graphics={
              Ellipse(
                extent={{-70,70},{70,-70}},
                lineColor={0,0,0},
                fillColor={170,213,255},
                fillPattern=FillPattern.Solid),
              Line(points={{-100,0},{-70,0}}, color={0,128,255}),
              Line(points={{70,0},{100,0}}, color={0,128,255}),
              Line(points={{0,100},{0,70}}, color={0,0,127}),
              Text(
                extent={{180,151},{20,99}},
                lineColor={0,0,0},
                textString="HS_flow"),
              Polygon(
                points={{-0.48,31.6},{18,26},{18,57.2},{-0.48,31.6}},
                lineColor={0,0,0},
                fillColor={0,0,0},
                fillPattern=FillPattern.Solid),
              Line(points={{0,0},{9.02,28.6}}, color={0,0,0}),
              Ellipse(
                extent={{-5,5},{5,-5}},
                lineColor={0,0,0},
                fillColor={0,0,0},
                fillPattern=FillPattern.Solid),
              Line(points={{37.6,13.7},{65.8,23.9}}, color={0,0,0}),
              Line(points={{22.9,32.8},{40.2,57.3}}, color={0,0,0}),
              Line(points={{0,70},{0,40}}, color={0,0,0}),
              Line(points={{-22.9,32.8},{-40.2,57.3}}, color={0,0,0}),
              Line(points={{-37.6,13.7},{-65.8,23.9}}, color={0,0,0})}),
        Documentation(info="<html>
<p>
This component monitors the <i>sensible</i> enthalphy flow rate of the medium in the flow
between fluid ports. In particular, if the total enthalpy flow rate is
<p align=\"center\" style=\"font-style:italic;\">
  H&#775;<sub>tot</sub> = H&#775;<sub>sen</sub> + H&#775;<sub>lat</sub>,
</p>
where 
<i>H&#775;<sub>sen</sub> = m&#775; (1-X<sub>w</sub>) c<sub>p,air</sub></i>, 
then this sensor outputs <i>H&#775; = H&#775;<sub>sen</sub></i>. 
</p>
<p>
If the parameter <code>tau</code> is non-zero, then the measured
specific sensible enthalpy <i>h<sub>out</sub></i> that is used to 
compute the sensible enthalpy flow rate 
<i>H&#775;<sub>sen</sub> = m&#775; h<sub>out</sub></i> 
is computed using a first order differential equation. 
See <a href=\"modelica://Buildings.Fluid.Sensors.UsersGuide\">
Buildings.Fluid.Sensors.UsersGuide</a> for an explanation.
</p>
<p>
For a sensor that measures 
<i>H&#775;<sub>tot</sub></i>, use
<a href=\"modelica://Buildings.Fluid.Sensors.EnthalpyFlowRate\">
Buildings.Fluid.Sensors.EnthalpyFlowRate</a>.<br>
For a sensor that measures 
<i>H&#775;<sub>lat</sub></i>, use
<a href=\"modelica://Buildings.Fluid.Sensors.LatentEnthalpyFlowRate\">
Buildings.Fluid.Sensors.LatentEnthalpyFlowRate</a>.
<p>
The sensor is ideal, i.e., it does not influence the fluid.
The sensor can only be used with medium models that implement the function
<code>enthalpyOfNonCondensingGas(state)</code>.
</p>
</html>
",       revisions="<html>
<ul>
<li>
November 3, 2011, by Michael Wetter:<br>
Moved <code>der(h_out) := 0;</code> from the initial algorithm section to 
the initial equation section
as this assignment does not conform to the Modelica specification.
</li>
<li>
August 10, 2011 by Michael Wetter:<br>
Added parameter <code>i_w</code> and an assert statement to
make sure it is set correctly. Without this change, Dymola
cannot differentiate the model when reducing the index of the DAE.
</li>
<li>
June 3, 2011 by Michael Wetter:<br>
Revised implementation to add dynamics in such a way that 
the time constant increases as the mass flow rate tends to zero.
This can improve the numerics.
</li>
<li>
February 22, by Michael Wetter:<br>
Improved code that searches for index of 'water' in the medium model.
</li>
<li>
September 9, 2009 by Michael Wetter:<br>
First implementation.
Implementation is based on enthalpy sensor of <code>Modelica.Fluid</code>.
</li>
</ul>
</html>"));
      end SensibleEnthalpyFlowRate;

      model MassFractionTwoPort "Ideal two port mass fraction sensor"
        extends Buildings.Fluid.Sensors.BaseClasses.PartialDynamicFlowSensor;
        extends Modelica.Icons.RotationalSensor;
        parameter String substanceName = "water" "Name of species substance";
        Modelica.Blocks.Interfaces.RealOutput X(min=0, max=1, start=X_start)
        "Mass fraction of the passing fluid"
          annotation (Placement(transformation(
              origin={0,110},
              extent={{10,-10},{-10,10}},
              rotation=270)));
        parameter Medium.MassFraction X_start=Medium.X_default[ind]
        "Initial or guess value of output (= state)"
          annotation (Dialog(group="Initialization"));
        Medium.MassFraction XMed(start=X_start)
        "Mass fraction to which the sensor is exposed";
    protected
        parameter Integer ind(fixed=false)
        "Index of species in vector of auxiliary substances";
        Medium.MassFraction XiVec[Medium.nXi](
            quantity=Medium.extraPropertiesNames)
        "Trace substances vector, needed because indexed argument for the operator inStream is not supported";
      initial algorithm
        // Compute the index of the element in the substance vector
        ind:= -1;
        for i in 1:Medium.nX loop
          if ( Modelica.Utilities.Strings.isEqual(string1=Medium.substanceNames[i],
                                                  string2=substanceName,
                                                  caseSensitive=false)) then
            ind := i;
          end if;
        end for;
        assert(ind > 0, "Species with name '" + substanceName + "' is not present in medium '"
               + Medium.mediumName + "'.\n"
               + "Check sensor parameter and medium model.");
      initial equation
        // Assign initial conditions
        if dynamic then
          if initType == Modelica.Blocks.Types.Init.SteadyState then
            der(X) = 0;
           elseif initType == Modelica.Blocks.Types.Init.InitialState or
                 initType == Modelica.Blocks.Types.Init.InitialOutput then
            X = X_start;
          end if;
        end if;
      equation
        if allowFlowReversal then
          XiVec = Modelica.Fluid.Utilities.regStep(port_a.m_flow,
               port_b.Xi_outflow, port_a.Xi_outflow, m_flow_small);
        else
          XiVec = port_b.Xi_outflow;
        end if;
        XMed = if ind > Medium.nXi then (1-sum(XiVec)) else XiVec[ind];
        // Output signal of sensor
        if dynamic then
          der(X)  = (XMed-X)*k/tau;
        else
          X = XMed;
        end if;
      annotation (defaultComponentName="senMasFra",
        Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
                  100,100}},
              grid={1,1}),
                graphics),
        Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}},
              grid={1,1}), graphics={
              Text(
                extent={{94,122},{0,92}},
                lineColor={0,0,0},
                textString="X"),
              Line(points={{0,100},{0,70}}, color={0,0,127}),
              Line(points={{-100,0},{-70,0}}, color={0,128,255}),
              Line(points={{70,0},{100,0}}, color={0,128,255})}),
        Documentation(info="<html>
<p>
This component monitors the mass fraction of the passing fluid. 
The sensor is ideal, i.e. it does not influence the fluid.
If the parameter <code>tau</code> is non-zero, then its output
is computed using a first order differential equation. 
Setting <code>tau=0</code> is <i>not</i> recommend. See
<a href=\"modelica://Buildings.Fluid.Sensors.UsersGuide\">
Buildings.Fluid.Sensors.UsersGuide</a> for an explanation.
</p>
</html>
",       revisions="<html>
<html>
<p>
<ul>
<li>
November 3, 2011, by Michael Wetter:<br>
Moved <code>der(X) := 0;</code> from the initial algorithm section to 
the initial equation section
as this assignment does not conform to the Modelica specification.
</li>
<li>
June 3, 2011 by Michael Wetter:<br>
Revised implementation to add dynamics in such a way that 
the time constant increases as the mass flow rate tends to zero.
This significantly improves the numerics.
</li>
<li>
February 22, by Michael Wetter:<br>
Improved code that searches for index of the substance name in the medium model.
</li>
<li>
Feb. 8, 2011 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
      end MassFractionTwoPort;

      model TemperatureTwoPort "Ideal two port temperature sensor"
        extends Buildings.Fluid.Sensors.BaseClasses.PartialDynamicFlowSensor;
        Modelica.Blocks.Interfaces.RealOutput T(final quantity="Temperature",
                                                final unit="K",
                                                displayUnit = "degC",
                                                min = 0,
                                                start=T_start)
        "Temperature of the passing fluid"
          annotation (Placement(transformation(
              origin={0,110},
              extent={{10,-10},{-10,10}},
              rotation=270)));
        parameter Modelica.SIunits.Temperature T_start=Medium.T_default
        "Initial or guess value of output (= state)"
          annotation (Dialog(group="Initialization"));
        Medium.Temperature TMed(start=T_start)
        "Medium temperature to which the sensor is exposed";
    protected
        Medium.Temperature T_a_inflow
        "Temperature of inflowing fluid at port_a";
        Medium.Temperature T_b_inflow
        "Temperature of inflowing fluid at port_b or T_a_inflow, if uni-directional flow";
      initial equation
        if dynamic then
          if initType == Modelica.Blocks.Types.Init.SteadyState then
            der(T) = 0;
           elseif initType == Modelica.Blocks.Types.Init.InitialState or
                 initType == Modelica.Blocks.Types.Init.InitialOutput then
            T = T_start;
          end if;
        end if;
      equation
        if allowFlowReversal then
           T_a_inflow = Medium.temperature(Medium.setState_phX(port_b.p, port_b.h_outflow, port_b.Xi_outflow));
           T_b_inflow = Medium.temperature(Medium.setState_phX(port_a.p, port_a.h_outflow, port_a.Xi_outflow));
           TMed = Modelica.Fluid.Utilities.regStep(port_a.m_flow, T_a_inflow, T_b_inflow, m_flow_small);
        else
           TMed = Medium.temperature(Medium.setState_phX(port_b.p, port_b.h_outflow, port_b.Xi_outflow));
           T_a_inflow = TMed;
           T_b_inflow = TMed;
        end if;
        // Output signal of sensor
        if dynamic then
          der(T) = (TMed-T)*k/tau;
        else
          T = TMed;
        end if;
      annotation (defaultComponentName="senTem",
        Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
                  100}}),
                graphics),
          Icon(graphics={
              Line(points={{-100,0},{92,0}}, color={0,128,255}),
              Ellipse(
                extent={{-20,-58},{20,-20}},
                lineColor={0,0,0},
                lineThickness=0.5,
                fillColor={191,0,0},
                fillPattern=FillPattern.Solid),
              Line(points={{-40,60},{-12,60}}, color={0,0,0}),
              Line(points={{-40,30},{-12,30}}, color={0,0,0}),
              Line(points={{-40,0},{-12,0}}, color={0,0,0}),
              Rectangle(
                extent={{-12,60},{12,-24}},
                lineColor={191,0,0},
                fillColor={191,0,0},
                fillPattern=FillPattern.Solid),
              Polygon(
                points={{-12,60},{-12,80},{-10,86},{-6,88},{0,90},{6,88},{10,86},{12,
                    80},{12,60},{-12,60}},
                lineColor={0,0,0},
                lineThickness=0.5),
              Text(
                extent={{102,140},{-18,90}},
                lineColor={0,0,0},
                textString="T"),
              Line(
                points={{-12,60},{-12,-25}},
                color={0,0,0},
                thickness=0.5),
              Line(
                points={{12,60},{12,-24}},
                color={0,0,0},
                thickness=0.5),
              Line(points={{0,100},{0,50}}, color={0,0,127})}),
          Documentation(info="<html>
<p>
This component monitors the temperature of the medium in the flow
between fluid ports. The sensor does not influence the fluid. 
If the parameter <code>tau</code> is non-zero, then its output
is computed using a first order differential equation. 
Setting <code>tau=0</code> is <i>not</i> recommend. See
<a href=\"modelica://Buildings.Fluid.Sensors.UsersGuide\">
Buildings.Fluid.Sensors.UsersGuide</a> for an explanation.
</p>
</html>
",       revisions="<html>
<html>
<p>
<ul>
<li>
June 3, 2011 by Michael Wetter:<br>
Revised implementation to add dynamics in such a way that 
the time constant increases as the mass flow rate tends to zero.
This significantly improves the numerics.
</li>
<li>
February 26, 2010 by Michael Wetter:<br>
Set start attribute for temperature output. Prior to this change,
the output was 0 at initial time, which caused the plot of the output to 
use 0 Kelvin as the lower value of the ordinate.
</li>
</ul>
</html>"),
      revisions="<html>
<ul>
<li>
September 10, 2008, by Michael Wetter:<br>
First implementation.
Implementation is based on 
<a href=\"modelica://Buildings.Fluid.Sensors.Temperature\">Buildings.Fluid.Sensors.Temperature</a>.
</li>
</ul>
</html>");
      end TemperatureTwoPort;

      package BaseClasses
      "Package with base classes for Buildings.Fluid.Sensors"
        extends Modelica.Icons.BasesPackage;

        partial model PartialDynamicFlowSensor
        "Partial component to model sensors that measure flow properties using a dynamic model"
          extends PartialFlowSensor;
          parameter Modelica.SIunits.Time tau(min=0) = 1
          "Time constant at nominal flow rate"   annotation (Evaluate=true);
          parameter Modelica.Blocks.Types.Init initType = Modelica.Blocks.Types.Init.NoInit
          "Type of initialization (InitialState and InitialOutput are identical)"
             annotation(Evaluate=true, Dialog(group="Initialization"));
      protected
          Real k(start=1)
          "Gain to take flow rate into account for sensor time constant";
          final parameter Boolean dynamic = tau > 1E-10 or tau < -1E-10
          "Flag, true if the sensor is a dynamic sensor";
          Real mNor_flow "Normalized mass flow rate";
        equation
          if dynamic then
            mNor_flow = port_a.m_flow/m_flow_nominal;
            k = Modelica.Fluid.Utilities.regStep(x=port_a.m_flow,
                                                 y1= mNor_flow,
                                                 y2=-mNor_flow,
                                                 x_small=m_flow_small);
          else
            mNor_flow = 1;
            k = 1;
          end if;
          annotation (Icon(graphics={
                Line(visible=(tau <> 0),
                points={{52,60},{58,74},{66,86},{76,92},{88,96},{98,96}}, color={0,
                      0,127})}), Documentation(info="<html>
<p>
Partial component to model a sensor that measures any intensive properties
of a flow, e.g., to get temperature or density in the flow
between fluid connectors.</p>
<p>
The sensor computes a gain that is zero at zero mass flow rate.
This avoids fast transients if the flow is close to zero, thereby
improving the numerical efficiency.
</p>
</html>",         revisions="<html>
<ul>
<li>
July 7, 2011, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
        end PartialDynamicFlowSensor;

        partial model PartialFlowSensor
        "Partial component to model sensors that measure flow properties"
          extends Modelica.Fluid.Interfaces.PartialTwoPort;
          parameter Medium.MassFlowRate m_flow_nominal(min=0)
          "Nominal mass flow rate, used for regularization near zero flow"
            annotation(Dialog(group = "Nominal condition"));
          parameter Medium.MassFlowRate m_flow_small(min=0) = 1E-4*m_flow_nominal
          "For bi-directional flow, temperature is regularized in the region |m_flow| < m_flow_small (m_flow_small > 0 required)"
            annotation(Dialog(group="Advanced"));
        equation
          // mass balance
          0 = port_a.m_flow + port_b.m_flow;
          // momentum equation (no pressure loss)
          port_a.p = port_b.p;
          // isenthalpic state transformation (no storage and no loss of energy)
          port_a.h_outflow = inStream(port_b.h_outflow);
          port_b.h_outflow = inStream(port_a.h_outflow);
          port_a.Xi_outflow = inStream(port_b.Xi_outflow);
          port_b.Xi_outflow = inStream(port_a.Xi_outflow);
          port_a.C_outflow = inStream(port_b.C_outflow);
          port_b.C_outflow = inStream(port_a.C_outflow);
          annotation (Documentation(info="<html>
<p>
Partial component to model a sensor.
The sensor is ideal. It does not influence mass, energy,
species or substance balance, and it has no flow friction.
</p>
</html>",
        revisions="<html>
<ul>
<li>
February 12, 2011, by Michael Wetter:<br>
First implementation.
Implementation is based on <code>Modelica.Fluid</code>.
</li>
</ul>
</html>"),  Diagram(coordinateSystem(
                preserveAspectRatio=false,
                extent={{-100,-100},{100,100}},
                grid={1,1}), graphics),
            Icon(graphics));
        end PartialFlowSensor;
      annotation (preferedView="info", Documentation(info="<html>
<p>
This package contains base classes that are used to construct the models in
<a href=\"modelica://Buildings.Fluid.Sensors\">Buildings.Fluid.Sensors</a>.
</p>
</html>"));
      end BaseClasses;
    annotation (preferedView="info",
    Documentation(info="<html>
<p align = justify>
Package <code>Sensors</code> consists of idealized sensor components that
provide variables of a medium model and/or fluid ports as
output signals. These signals can be, e.g., further processed
with components of the 
<a href=\"modelica://Modelica.Blocks\">
Modelica.Blocks</a> 
library.
Also more realistic sensor models can be built, by further
processing (e.g., by attaching block 
<a href=\"modelica://Modelica.Blocks.Continuous.FirstOrder\">
Modelica.Blocks.Continuous.FirstOrder</a> to
model the time constant of the sensor).
</p>
</html>", revisions="<html>
<ul>
<li><i>22 Dec 2008</i>
    by R&uuml;diger Franke
    <ul>
    <li>flow sensors based on Modelica.Fluid.Interfaces.PartialTwoPort</li>
    <li>adapted documentation to stream connectors, i.e. less need for two port sensors</li>
    </ul>
<li><i>4 Dec 2008</i>
    by Michael Wetter<br>
       included sensors for trace substance</li>
<li><i>31 Oct 2007</i>
    by Carsten Heinrich<br>
       updated sensor models, included one and two port sensors for thermodynamic state variables</li>
</ul>
</html>"));
    end Sensors;

    package Sources "Package with boundary condition models"
      extends Modelica.Icons.SourcesPackage;

      model Boundary_pT
      "Boundary with prescribed pressure, temperature, composition and trace substances"
        extends Modelica.Fluid.Sources.BaseClasses.PartialSource;
        parameter Boolean use_p_in = false
        "Get the pressure from the input connector"
          annotation(Evaluate=true, HideResult=true);
        parameter Boolean use_T_in= false
        "Get the temperature from the input connector"
          annotation(Evaluate=true, HideResult=true);
        parameter Boolean use_X_in = false
        "Get the composition from the input connector"
          annotation(Evaluate=true, HideResult=true);
        parameter Boolean use_C_in = false
        "Get the trace substances from the input connector"
          annotation(Evaluate=true, HideResult=true);
        parameter Medium.AbsolutePressure p = Medium.p_default
        "Fixed value of pressure"
          annotation (Evaluate = true,
                      Dialog(enable = not use_p_in));
        parameter Medium.Temperature T = Medium.T_default
        "Fixed value of temperature"
          annotation (Evaluate = true,
                      Dialog(enable = not use_T_in));
        parameter Medium.MassFraction X[Medium.nX] = Medium.X_default
        "Fixed value of composition"
          annotation (Evaluate = true,
                      Dialog(enable = (not use_X_in) and Medium.nXi > 0));
        parameter Medium.ExtraProperty C[Medium.nC](
             quantity=Medium.extraPropertiesNames)=fill(0, Medium.nC)
        "Fixed values of trace substances"
          annotation (Evaluate=true,
                      Dialog(enable = (not use_C_in) and Medium.nC > 0));
        Modelica.Blocks.Interfaces.RealInput p_in if              use_p_in
        "Prescribed boundary pressure"
          annotation (Placement(transformation(extent={{-140,60},{-100,100}},
                rotation=0)));
        Modelica.Blocks.Interfaces.RealInput T_in if         use_T_in
        "Prescribed boundary temperature"
          annotation (Placement(transformation(extent={{-140,20},{-100,60}},
                rotation=0)));
        Modelica.Blocks.Interfaces.RealInput X_in[Medium.nX] if
                                                              use_X_in
        "Prescribed boundary composition"
          annotation (Placement(transformation(extent={{-140,-60},{-100,-20}},
                rotation=0)));
        Modelica.Blocks.Interfaces.RealInput C_in[Medium.nC] if
                                                              use_C_in
        "Prescribed boundary trace substances"
          annotation (Placement(transformation(extent={{-140,-100},{-100,-60}},
                rotation=0)));
    protected
        Modelica.Blocks.Interfaces.RealInput p_in_internal
        "Needed to connect to conditional connector";
        Modelica.Blocks.Interfaces.RealInput T_in_internal
        "Needed to connect to conditional connector";
        Modelica.Blocks.Interfaces.RealInput X_in_internal[Medium.nX]
        "Needed to connect to conditional connector";
        Modelica.Blocks.Interfaces.RealInput C_in_internal[Medium.nC]
        "Needed to connect to conditional connector";
      equation
        Modelica.Fluid.Utilities.checkBoundary(Medium.mediumName, Medium.substanceNames,
          Medium.singleState, true, X_in_internal, "Boundary_pT");
        connect(p_in, p_in_internal);
        connect(T_in, T_in_internal);
        connect(X_in, X_in_internal);
        connect(C_in, C_in_internal);
        if not use_p_in then
          p_in_internal = p;
        end if;
        if not use_T_in then
          T_in_internal = T;
        end if;
        if not use_X_in then
          X_in_internal = X;
        end if;
        if not use_C_in then
          C_in_internal = C;
        end if;
        medium.p = p_in_internal;
        medium.T = T_in_internal;
        medium.Xi = X_in_internal[1:Medium.nXi];
        ports.C_outflow = fill(C_in_internal, nPorts);
        annotation (defaultComponentName="boundary",
          Icon(coordinateSystem(
              preserveAspectRatio=false,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={
              Ellipse(
                extent={{-100,100},{100,-100}},
                lineColor={0,0,0},
                fillPattern=FillPattern.Sphere,
                fillColor={0,127,255}),
              Text(
                extent={{-150,110},{150,150}},
                textString="%name",
                lineColor={0,0,255}),
              Line(
                visible=use_p_in,
                points={{-100,80},{-58,80}},
                color={0,0,255}),
              Line(
                visible=use_T_in,
                points={{-100,40},{-92,40}},
                color={0,0,255}),
              Line(
                visible=use_X_in,
                points={{-100,-40},{-92,-40}},
                color={0,0,255}),
              Line(
                visible=use_C_in,
                points={{-100,-80},{-60,-80}},
                color={0,0,255}),
              Text(
                visible=use_p_in,
                extent={{-152,134},{-68,94}},
                lineColor={0,0,0},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid,
                textString="p"),
              Text(
                visible=use_X_in,
                extent={{-164,4},{-62,-36}},
                lineColor={0,0,0},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid,
                textString="X"),
              Text(
                visible=use_C_in,
                extent={{-164,-90},{-62,-130}},
                lineColor={0,0,0},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid,
                textString="C"),
              Text(
                visible=use_T_in,
                extent={{-162,34},{-60,-6}},
                lineColor={0,0,0},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid,
                textString="T")}),
          Documentation(info="<html>
<p>
Defines prescribed values for boundary conditions:
</p>
<ul>
<li> Prescribed boundary pressure.</li>
<li> Prescribed boundary temperature.</li>
<li> Boundary composition (only for multi-substance or trace-substance flow).</li>
</ul>
<p>If <code>use_p_in</code> is false (default option), the <code>p</code> parameter
is used as boundary pressure, and the <code>p_in</code> input connector is disabled; if <code>use_p_in</code> is true, then the <code>p</code> parameter is ignored, and the value provided by the input connector is used instead.</p> 
<p>The same applies to the temperature, composition and trace substances.</p>
<p>
Note, that boundary temperature,
mass fractions and trace substances have only an effect if the mass flow
is from the boundary into the port. If mass is flowing from
the port into the boundary, the boundary definitions,
with exception of boundary pressure, do not have an effect.
</p>
</html>",
      revisions="<html>
<ul>
<li>
September 29, 2009, by Michael Wetter:<br>
First implementation.
Implementation is based on <code>Modelica.Fluid</code>.
</li>
</ul>
</html>"),Diagram(coordinateSystem(
              preserveAspectRatio=false,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics));
      end Boundary_pT;

      model MassFlowSource_T
      "Ideal flow source that produces a prescribed mass flow with prescribed temperature, mass fraction and trace substances"
        extends Modelica.Fluid.Sources.BaseClasses.PartialSource;
        parameter Boolean use_m_flow_in = false
        "Get the mass flow rate from the input connector"
          annotation(Evaluate=true, HideResult=true);
        parameter Boolean use_T_in= false
        "Get the temperature from the input connector"
          annotation(Evaluate=true, HideResult=true);
        parameter Boolean use_X_in = false
        "Get the composition from the input connector"
          annotation(Evaluate=true, HideResult=true);
        parameter Boolean use_C_in = false
        "Get the trace substances from the input connector"
          annotation(Evaluate=true, HideResult=true);
        parameter Medium.MassFlowRate m_flow = 0
        "Fixed mass flow rate going out of the fluid port"
          annotation (Evaluate = true,
                      Dialog(enable = not use_m_flow_in));
        parameter Medium.Temperature T = Medium.T_default
        "Fixed value of temperature"
          annotation (Evaluate = true,
                      Dialog(enable = not use_T_in));
        parameter Medium.MassFraction X[Medium.nX] = Medium.X_default
        "Fixed value of composition"
          annotation (Evaluate = true,
                      Dialog(enable = (not use_X_in) and Medium.nXi > 0));
        parameter Medium.ExtraProperty C[Medium.nC](
             quantity=Medium.extraPropertiesNames)=fill(0, Medium.nC)
        "Fixed values of trace substances"
          annotation (Evaluate=true,
                      Dialog(enable = (not use_C_in) and Medium.nC > 0));
        Modelica.Blocks.Interfaces.RealInput m_flow_in if     use_m_flow_in
        "Prescribed mass flow rate"
          annotation (Placement(transformation(extent={{-120,60},{-80,100}},
                rotation=0), iconTransformation(extent={{-120,60},{-80,100}})));
        Modelica.Blocks.Interfaces.RealInput T_in if         use_T_in
        "Prescribed fluid temperature"
          annotation (Placement(transformation(extent={{-140,20},{-100,60}},
                rotation=0), iconTransformation(extent={{-140,20},{-100,60}})));
        Modelica.Blocks.Interfaces.RealInput X_in[Medium.nX] if
                                                              use_X_in
        "Prescribed fluid composition"
          annotation (Placement(transformation(extent={{-140,-60},{-100,-20}},
                rotation=0)));
        Modelica.Blocks.Interfaces.RealInput C_in[Medium.nC] if
                                                              use_C_in
        "Prescribed boundary trace substances"
          annotation (Placement(transformation(extent={{-120,-100},{-80,-60}},
                rotation=0)));
    protected
        Modelica.Blocks.Interfaces.RealInput m_flow_in_internal
        "Needed to connect to conditional connector";
        Modelica.Blocks.Interfaces.RealInput T_in_internal
        "Needed to connect to conditional connector";
        Modelica.Blocks.Interfaces.RealInput X_in_internal[Medium.nX]
        "Needed to connect to conditional connector";
        Modelica.Blocks.Interfaces.RealInput C_in_internal[Medium.nC]
        "Needed to connect to conditional connector";
      equation
        Modelica.Fluid.Utilities.checkBoundary(
          Medium.mediumName,
          Medium.substanceNames,
          Medium.singleState,
          true,
          X_in_internal,
          "MassFlowSource_T");
        connect(m_flow_in, m_flow_in_internal);
        connect(T_in, T_in_internal);
        connect(X_in, X_in_internal);
        connect(C_in, C_in_internal);
        if not use_m_flow_in then
          m_flow_in_internal = m_flow;
        end if;
        if not use_T_in then
          T_in_internal = T;
        end if;
        if not use_X_in then
          X_in_internal = X;
        end if;
        if not use_C_in then
          C_in_internal = C;
        end if;
        sum(ports.m_flow) = -m_flow_in_internal;
        medium.T = T_in_internal;
        medium.Xi = X_in_internal[1:Medium.nXi];
        ports.C_outflow = fill(C_in_internal, nPorts);
        annotation (defaultComponentName="boundary",
          Icon(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={1,1}), graphics={
              Rectangle(
                extent={{35,45},{100,-45}},
                lineColor={0,0,0},
                fillPattern=FillPattern.HorizontalCylinder,
                fillColor={0,127,255}),
              Ellipse(
                extent={{-100,80},{60,-80}},
                lineColor={0,0,255},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Polygon(
                points={{-60,70},{60,0},{-60,-68},{-60,70}},
                lineColor={0,0,255},
                fillColor={0,0,255},
                fillPattern=FillPattern.Solid),
              Text(
                extent={{-54,32},{16,-30}},
                lineColor={255,0,0},
                fillColor={255,0,0},
                fillPattern=FillPattern.Solid,
                textString="m"),
              Text(
                extent={{-150,130},{150,170}},
                textString="%name",
                lineColor={0,0,255}),
              Ellipse(
                extent={{-26,30},{-18,22}},
                lineColor={255,0,0},
                fillColor={255,0,0},
                fillPattern=FillPattern.Solid),
              Text(
                visible=use_m_flow_in,
                extent={{-185,132},{-45,100}},
                lineColor={0,0,0},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid,
                textString="m_flow"),
              Text(
                visible=use_T_in,
                extent={{-111,71},{-71,37}},
                lineColor={0,0,0},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid,
                textString="T"),
              Text(
                visible=use_X_in,
                extent={{-153,-44},{-33,-72}},
                lineColor={0,0,0},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid,
                textString="X"),
              Text(
                visible=use_C_in,
                extent={{-155,-98},{-35,-126}},
                lineColor={0,0,0},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid,
                textString="C")}),
          Window(
            x=0.45,
            y=0.01,
            width=0.44,
            height=0.65),
          Diagram(coordinateSystem(
              preserveAspectRatio=false,
              extent={{-100,-100},{100,100}},
              grid={1,1}), graphics),
          Documentation(info="<html>
<p>
Models an ideal flow source, with prescribed values of flow rate, temperature, composition and trace substances:
</p>
<ul>
<li> Prescribed mass flow rate.</li>
<li> Prescribed temperature.</li>
<li> Boundary composition (only for multi-substance or trace-substance flow).</li>
</ul>
<p>If <code>use_m_flow_in</code> is false (default option), the <code>m_flow</code> parameter
is used as boundary pressure, and the <code>m_flow_in</code> input connector is disabled; if <code>use_m_flow_in</code> is true, then the <code>m_flow</code> parameter is ignored, and the value provided by the input connector is used instead.</p> 
<p>The same applies to the temperature, composition and trace substances.</p>
<p>
Note, that boundary temperature,
mass fractions and trace substances have only an effect if the mass flow
is from the boundary into the port. If mass is flowing from
the port into the boundary, the boundary definitions,
with exception of boundary flow rate, do not have an effect.
</p>
</html>",
      revisions="<html>
<ul>
<li>
September 29, 2009, by Michael Wetter:<br>
First implementation. 
</li>
</ul>
</html>"));
      end MassFlowSource_T;
    annotation (preferedView="info",
    Documentation(info="<html>
<p>
Package <b>Sources</b> contains generic sources for fluid connectors
to define fixed or prescribed ambient conditions.
</p>
</html>"));
    end Sources;

    package BaseClasses "Package with base classes for Buildings.Fluid"
      extends Modelica.Icons.BasesPackage;

      package FlowModels "Flow models for pressure drop calculations"
        extends Modelica.Icons.BasesPackage;

        function basicFlowFunction_dp "Basic class for flow models"

          input Modelica.SIunits.Pressure dp(displayUnit="Pa")
          "Pressure difference between port_a and port_b (= port_a.p - port_b.p)";
          input Real k(min=0, unit="")
          "Flow coefficient, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)";
          input Modelica.SIunits.MassFlowRate m_flow_turbulent(min=0)
          "Mass flow rate";
          output Modelica.SIunits.MassFlowRate m_flow
          "Mass flow rate in design flow direction";
      protected
          Modelica.SIunits.Pressure dp_turbulent(displayUnit="Pa")
          "Turbulent flow if |dp| >= dp_small, not a parameter because k can be a function of time";
      protected
         Real kSqu(unit="kg.m") "Flow coefficient, kSqu=k^2=m_flow^2/|dp|";
        algorithm
         kSqu:=k*k;
         dp_turbulent :=m_flow_turbulent^2/kSqu;
         m_flow :=Modelica.Fluid.Utilities.regRoot2(x=dp, x_small=dp_turbulent, k1=kSqu, k2=kSqu);

        annotation(LateInline=true,
                   inverse(dp=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(m_flow=m_flow, k=k, m_flow_turbulent=m_flow_turbulent)),
                   smoothOrder=2,
                   Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
                    {100,100}}), graphics={Line(
                  points={{-80,-40},{-80,60},{80,-40},{80,60}},
                  color={0,0,255},
                  smooth=Smooth.None,
                  thickness=1), Text(
                  extent={{-40,-40},{40,-80}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.Sphere,
                  fillColor={232,0,0},
                  textString="%name")}),
        Documentation(info="<html>
<p>
Function that computes the pressure drop of flow elements as
<p align=\"center\" style=\"font-style:italic;\">
  m = sign(&Delta;p) k  &radic;<span style=\"text-decoration:overline;\">&nbsp;&Delta;p &nbsp;</span>
</p>
with regularization near the origin.
Therefore, the flow coefficient is
<p align=\"center\" style=\"font-style:italic;\">
  k = m &frasl; &radic;<span style=\"text-decoration:overline;\">&nbsp;&Delta;p &nbsp;</span> 
</p>
The input <code>m_flow_turbulent</code> determines the location of the regularization.
</p>
</html>",         revisions="<html>
<ul>
<li>
August 10, 2011, by Michael Wetter:<br>
Removed <code>if-then</code> optimization that set <code>m_flow=0</code> if <code>dp=0</code>,
as this causes the derivative to be discontinuous at <code>dp=0</code>.
</li>
<li>
August 4, 2011, by Michael Wetter:<br>
Implemented linearized model in this model instead of 
in the functions
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp</a>
and
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow</a>. 
With the previous implementation, 
the symbolic processor may not rearrange the equations, which can lead 
to coupled equations instead of an explicit solution.
</li>
<li>
March 29, 2010 by Michael Wetter:<br>
Changed implementation to allow <code>k=0</code>, which is
the case for a closed valve with no leakage
</li>
</ul>
</html>"),
        revisions="<html>
<ul>
<li>
August 4, 2011, by Michael Wetter:<br>
Removed option to use a linear function. The linear implementation is now done
in models that call this function. With the previous implementation, 
the symbolic processor may not rearrange the equations, which can lead 
to coupled equations instead of an explicit solution.
</li>
<li>
April 13, 2009, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>");
        end basicFlowFunction_dp;

        function basicFlowFunction_m_flow "Basic class for flow models"

          input Modelica.SIunits.MassFlowRate m_flow
          "Mass flow rate in design flow direction";
          input Real k(unit="")
          "Flow coefficient, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)";
          input Modelica.SIunits.MassFlowRate m_flow_turbulent(min=0)
          "Mass flow rate";
          output Modelica.SIunits.Pressure dp(displayUnit="Pa")
          "Pressure difference between port_a and port_b (= port_a.p - port_b.p)";
      protected
         Real kSquInv(unit="1/(kg.m)") "Flow coefficient";
        algorithm
         kSquInv:=1/k^2;
         dp :=Modelica.Fluid.Utilities.regSquare2(x=m_flow, x_small=m_flow_turbulent, k1=kSquInv, k2=kSquInv);

         annotation (LateInline=true,
                     inverse(m_flow=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(dp=dp, k=k, m_flow_turbulent=m_flow_turbulent)),
                     smoothOrder=2,
                     Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                    -100},{100,100}}), graphics={Line(
                  points={{-80,-40},{-80,60},{80,-40},{80,60}},
                  color={0,0,255},
                  smooth=Smooth.None,
                  thickness=1), Text(
                  extent={{-40,-40},{40,-80}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.Sphere,
                  fillColor={232,0,0},
                  textString="%name")}),
        Documentation(info="<html>
<p>
Function that computes the pressure drop of flow elements as
<p align=\"center\" style=\"font-style:italic;\">
  &Delta;p = sign(m) (m &frasl; k)<sup>2</sup> 
</p>
with regularization near the origin.
Therefore, the flow coefficient is
<p align=\"center\" style=\"font-style:italic;\">
  k = m &frasl; &radic;<span style=\"text-decoration:overline;\">&nbsp;&Delta;p &nbsp;</span> 
</p>
The input <code>m_flow_turbulent</code> determines the location of the regularization.
</p>
</html>"),
        revisions="<html>
<ul>
<li>
August 10, 2011, by Michael Wetter:<br>
Removed <code>if-then</code> optimization that set <code>dp=0</code> if <code>m_flow=0</code>,
as this causes the derivative to be discontinuous at <code>m_flow=0</code>.
</li>
<li>
August 4, 2011, by Michael Wetter:<br>
Removed option to use a linear function. The linear implementation is now done
in models that call this function. With the previous implementation, 
the symbolic processor may not rearrange the equations, which can lead 
to coupled equations instead of an explicit solution.
</li>
<li>
April 13, 2009, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>");
        end basicFlowFunction_m_flow;
      annotation (Documentation(info="<html>
This package contains a basic flow model that is used by the 
various models that compute pressure drop.
Because the density does not change signficantly in heating,
ventilation and air conditioning systems for buildings,
this model computes the pressure drop based on the mass flow
rate and not the volume flow rate. This typically leads to simpler
equations because it does not require
the mass density, which changes when the flow is reversed. 
Although, for conceptual design of building energy system, there is
in general not enough information available that would warrant a more
detailed pressure drop calculation.
If a more detailed computation of the flow resistance is needed,
then a user can use models from the 
<code>Modelica.Fluid</code> library.
</html>",       revisions="<html>
<ul>
<li>
April 10, 2009 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
      end FlowModels;

      partial model PartialResistance
      "Partial model for a hydraulic resistance"
          extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
           show_T=false, show_V_flow=false,
           m_flow(start=0, nominal=m_flow_nominal_pos),
           dp(start=0, nominal=dp_nominal_pos),
           final m_flow_small = 1E-4*abs(m_flow_nominal));

        parameter Boolean from_dp = false
        "= true, use m_flow = f(dp) else dp = f(m_flow)"
          annotation (Evaluate=true, Dialog(tab="Advanced"));

        parameter Modelica.SIunits.Pressure dp_nominal(displayUnit="Pa")
        "Pressure drop at nominal mass flow rate"                                  annotation(Dialog(group = "Nominal condition"));
        parameter Boolean homotopyInitialization = true
        "= true, use homotopy method"
          annotation(Evaluate=true, Dialog(tab="Advanced"));
        parameter Boolean linearized = false
        "= true, use linear relation between m_flow and dp for any flow rate"
          annotation(Evaluate=true, Dialog(tab="Advanced"));

        parameter Modelica.SIunits.MassFlowRate m_flow_turbulent(min=0)
        "Turbulent flow if |m_flow| >= m_flow_turbulent";

    protected
        parameter Medium.ThermodynamicState sta0=
           Medium.setState_pTX(T=Medium.T_default, p=Medium.p_default, X=Medium.X_default);
        parameter Modelica.SIunits.DynamicViscosity eta_nominal=Medium.dynamicViscosity(sta0)
        "Dynamic viscosity, used to compute transition to turbulent flow regime";
    protected
        final parameter Modelica.SIunits.MassFlowRate m_flow_nominal_pos = abs(m_flow_nominal)
        "Absolute value of nominal flow rate";
        final parameter Modelica.SIunits.Pressure dp_nominal_pos = abs(dp_nominal)
        "Absolute value of nominal pressure";
      equation
        // Isenthalpic state transformation (no storage and no loss of energy)
        port_a.h_outflow = inStream(port_b.h_outflow);
        port_b.h_outflow = inStream(port_a.h_outflow);

        // Mass balance (no storage)
        port_a.m_flow + port_b.m_flow = 0;

        // Transport of substances
        port_a.Xi_outflow = inStream(port_b.Xi_outflow);
        port_b.Xi_outflow = inStream(port_a.Xi_outflow);

        port_a.C_outflow = inStream(port_b.C_outflow);
        port_b.C_outflow = inStream(port_a.C_outflow);

        annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                  -100},{100,100}}), graphics={
              Rectangle(
                extent={{-100,40},{100,-42}},
                lineColor={0,0,0},
                fillPattern=FillPattern.HorizontalCylinder,
                fillColor={192,192,192}),
              Rectangle(
                extent={{-100,22},{100,-24}},
                lineColor={0,0,0},
                fillPattern=FillPattern.HorizontalCylinder,
                fillColor={0,127,255}),
              Rectangle(
                visible=linearized,
                extent={{-100,22},{100,-24}},
                fillPattern=FillPattern.Backward,
                fillColor={0,128,255},
                pattern=LinePattern.None,
                lineColor={255,255,255})}),
                defaultComponentName="res",
      Documentation(info="<html>
<p>
Partial model for a flow resistance, possible with variable flow coefficient.
Models that extend this class need to implement an equation that relates
<code>m_flow</code> and <code>dp</code>, and they need to assign the parameter
<code>m_flow_turbulent</code>.
</p>
<p>
See for example
<a href=\"modelica://Buildings.Fluid.FixedResistances.FixedResistanceDpM\">
Buildings.Fluid.FixedResistances.FixedResistanceDpM</a> for a model that extends
this base class.
</p>
</html>",       revisions="<html>
<ul>
<li>
February 12, 2012, by Michael Wetter:<br>
Removed duplicate declaration of <code>m_flow_nominal</code>.
</li>
<li>
February 3, 2012, by Michael Wetter:<br>
Made assignment of <code>m_flow_small</code> <code>final</code> as it is no
longer used in the base class.
</li>
<li>
January 16, 2012, by Michael Wetter:<br>
To simplify object inheritance tree, revised base classes
<code>Buildings.Fluid.BaseClasses.PartialResistance</code>,
<code>Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve</code>,
<code>Buildings.Fluid.Actuators.BaseClasses.PartialDamperExponential</code>,
<code>Buildings.Fluid.Actuators.BaseClasses.PartialActuator</code>
and model
<code>Buildings.Fluid.FixedResistances.FixedResistanceDpM</code>.
</li>
<li>
August 5, 2011, by Michael Wetter:<br>
Moved linearized pressure drop equation from the function body to the equation
section. With the previous implementation, 
the symbolic processor may not rearrange the equations, which can lead 
to coupled equations instead of an explicit solution.
</li>
<li>
June 20, 2011, by Michael Wetter:<br>
Set start values for <code>m_flow</code> and <code>dp</code> to zero, since
most HVAC systems start at zero flow. With this change, the start values
appear in the GUI and can be set by the user.
</li>
<li>
April 2, 2011 by Michael Wetter:<br>
Added <code>m_flow_nominal_pos</code> and <code>dp_nominal_pos</code> to allow
providing negative nominal values which will be used, for example, to set start
values of flow splitters which may have negative flow rates and pressure drop
at the initial condition.
</li>
<li>
March 23, 2011 by Michael Wetter:<br>
Added homotopy operator.
</li>
<li>
March 30, 2010 by Michael Wetter:<br>
Changed base classes to allow easier initialization.
</li>
<li>
July 20, 2007 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
      revisions="<html>
<ul>
<li>
March 27, 2011, by Michael Wetter:<br>
Added <code>homotopy</code> operator.
</li>
<li>
April 13, 2009, by Michael Wetter:<br>
Extracted pressure drop computation and implemented it in the
new model
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.BasicFlowModel\">
Buildings.Fluid.BaseClasses.FlowModels.BasicFlowModel</a>.
</li>
<li>
September 18, 2008, by Michael Wetter:<br>
Added equations for the mass balance of extra species flow,
i.e., <code>C</code> and <code>mC_flow</code>.
</li>
<li>
July 20, 2007 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>");
      end PartialResistance;
    annotation (preferedView="info", Documentation(info="<html>
<p>
This package contains base classes that are used to construct the models in
<a href=\"modelica://Buildings.Fluid\">Buildings.Fluid</a>.
</p>
</html>"));
    end BaseClasses;

    package Interfaces "Package with interfaces for fluid models"
      extends Modelica.Icons.InterfacesPackage;

      model TwoPortHeatMassExchanger
      "Partial model transporting one fluid stream with storing mass or energy"
        extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
          port_a(h_outflow(start=h_outflow_start)),
          port_b(h_outflow(start=h_outflow_start)));
        extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(
          final computeFlowResistance=true);
        import Modelica.Constants;

        replaceable Buildings.Fluid.MixingVolumes.MixingVolume vol
          constrainedby
        Buildings.Fluid.MixingVolumes.BaseClasses.PartialMixingVolume(
          redeclare final package Medium = Medium,
          nPorts = 2,
          V=m_flow_nominal*tau/rho_nominal,
          final m_flow_nominal = m_flow_nominal,
          final energyDynamics=energyDynamics,
          final massDynamics=massDynamics,
          final p_start=p_start,
          final T_start=T_start,
          final X_start=X_start,
          final C_start=C_start) "Volume for fluid stream"
                                          annotation (Placement(transformation(extent={{-9,0},{
                  11,-20}},         rotation=0)));

        parameter Modelica.SIunits.Time tau = 30
        "Time constant at nominal flow (if energyDynamics <> SteadyState)"
           annotation (Evaluate=true, Dialog(tab = "Dynamics", group="Nominal condition"));

        // Advanced
        parameter Boolean homotopyInitialization = true
        "= true, use homotopy method"
          annotation(Evaluate=true, Dialog(tab="Advanced"));

        // Dynamics
        parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
        "Formulation of energy balance"
          annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
        parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
        "Formulation of mass balance"
          annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));

        // Initialization
        parameter Medium.AbsolutePressure p_start = Medium.p_default
        "Start value of pressure"
          annotation(Dialog(tab = "Initialization"));
        parameter Medium.Temperature T_start = Medium.T_default
        "Start value of temperature"
          annotation(Dialog(tab = "Initialization"));
        parameter Medium.MassFraction X_start[Medium.nX] = Medium.X_default
        "Start value of mass fractions m_i/m"
          annotation (Dialog(tab="Initialization", enable=Medium.nXi > 0));
        parameter Medium.ExtraProperty C_start[Medium.nC](
             quantity=Medium.extraPropertiesNames)=fill(0, Medium.nC)
        "Start value of trace substances"
          annotation (Dialog(tab="Initialization", enable=Medium.nC > 0));

    protected
        parameter Medium.ThermodynamicState sta_nominal=Medium.setState_pTX(
            T=Medium.T_default, p=Medium.p_default, X=Medium.X_default);
        parameter Modelica.SIunits.Density rho_nominal=Medium.density(sta_nominal)
        "Density, used to compute fluid volume";
        parameter Medium.ThermodynamicState sta_start=Medium.setState_pTX(
            T=T_start, p=p_start, X=X_start);
        parameter Modelica.SIunits.SpecificEnthalpy h_outflow_start = Medium.specificEnthalpy(sta_start)
        "Start value for outflowing enthalpy";
    public
        Buildings.Fluid.FixedResistances.FixedResistanceDpM preDro(
          redeclare package Medium = Medium,
          final use_dh=false,
          final m_flow_nominal=m_flow_nominal,
          final deltaM=deltaM,
          final allowFlowReversal=allowFlowReversal,
          final show_T=false,
          final show_V_flow=show_V_flow,
          final from_dp=from_dp,
          final linearized=linearizeFlowResistance,
          final homotopyInitialization=homotopyInitialization,
          final dp_nominal=dp_nominal) "Pressure drop model"
          annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
      initial algorithm
        assert((energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) or
                tau > Modelica.Constants.eps,
      "The parameter tau, or the volume of the model from which tau may be derived, is unreasonably small.
 Set energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState to model steady-state.
 Received tau = "       + String(tau) + "\n");
        assert((massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) or
                tau > Modelica.Constants.eps,
      "The parameter tau, or the volume of the model from which tau may be derived, is unreasonably small.          
 Set massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState to model steady-state.
 Received tau = "       + String(tau) + "\n");

      equation
        connect(vol.ports[2], port_b) annotation (Line(
            points={{1,0},{27.25,0},{27.25,0},{51.5,0},{51.5,0},{100,0}},
            color={0,127,255},
            smooth=Smooth.None));
        connect(port_a, preDro.port_a) annotation (Line(
            points={{-100,0},{-90,0},{-90,0},{-80,0},{-80,0},{-60,0}},
            color={0,127,255},
            smooth=Smooth.None));
        connect(preDro.port_b, vol.ports[1]) annotation (Line(
            points={{-40,0},{-30.25,0},{-30.25,0},{
                -20.5,0},{-20.5,0},{1,0}},
            color={0,127,255},
            smooth=Smooth.None));
        annotation (
          Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={1,1}), graphics),
          Documentation(info="<html>
<p>
This component transports one fluid stream. 
It provides the basic model for implementing dynamic and steady-state
models that exchange heat and water vapor with the fluid stream.
The model also computes the pressure drop due to the flow resistance.
By setting the parameter <code>dp_nominal=0</code>, the computation
of the pressure drop can be avoided.
The variable <code>vol.heatPort.T</code> always has the value of
the temperature of the medium that leaves the component.
For the actual temperatures at the port, the variables <code>sta_a.T</code>
and <code>sta_b.T</code> can be used. These two variables are provided by 
the base class
<a href=\"modelica://Buildings.Fluid.Interfaces.PartialTwoPortInterface\">
Buildings.Fluid.Interfaces.PartialTwoPortInterface</a>.
</p>
<p>
For models that extend this model, see for example
<ul>
<li>
the ideal heater or cooler
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeaterCoolerPrescribed\">
Buildings.Fluid.HeatExchangers.HeaterCoolerPrescribed</a>,
</li>
<li>
the ideal humidifier
<a href=\"modelica://Buildings.Fluid.MassExchangers.HumidifierPrescribed\">
Buildings.Fluid.MassExchangers.HumidifierPrescribed</a>, and
</li>
<li>
the boiler
<a href=\"modelica://Buildings.Fluid.Boilers.BoilerPolynomial\">
Buildings.Fluid.Boilers.BoilerPolynomial</a>.
</li>
</ul>
</p>
<h4>Implementation</h4>
<p>
The variable names follow the conventions used in 
<a href=\"modelica://Modelica.Fluid.HeatExchangers.BasicHX\">
Modelica.Fluid.HeatExchangers.BasicHX</a>.
</p>
</html>",       revisions="<html>
<ul>
<li>
February 3, 2012, by Michael Wetter:<br>
Removed assignment of <code>m_flow_small</code> as it is no
longer used in the pressure drop model.
</li>
<li>
January 15, 2011, by Michael Wetter:<br>
Fixed wrong class reference in information section.
</li>
<li>
September 13, 2011, by Michael Wetter:<br>
Changed assignment of <code>vol(mass/energyDynamics=...)</code> as the
previous assignment caused a non-literal start value that was ignored.
</li>
<li>
July 29, 2011, by Michael Wetter:<br>
Added start value for outflowing enthalpy.
</li>
<li>
July 11, 2011, by Michael Wetter:<br>
Changed parameterization of fluid volume so that steady-state balance is
used when <code>tau = 0</code>.
</li>
<li>
May 25, 2011, by Michael Wetter:<br>
Removed temperature sensor and changed implementation of fluid volume
to allow use of this model for the steady-state and dynamic humidifier
<a href=\"modelica://Buildings.Fluid.MassExchangers.HumidifierPrescribed\">
Buildings.Fluid.MassExchangers.HumidifierPrescribed</a>.
</li>
<li>
March 25, 2011, by Michael Wetter:<br>
Added homotopy operator.
</li>
<li>
March 21, 2010 by Michael Wetter:<br>
Changed pressure start value from <code>system.p_start</code>
to <code>Medium.p_default</code> since HVAC models may have water and 
air, which are typically at different pressures.
</li>
<li>
April 13, 2009, by Michael Wetter:<br>
Added model to compute flow friction.
</li>
<li>
January 29, 2009 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),Icon(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={1,1}), graphics={
              Rectangle(
                extent={{-70,60},{70,-60}},
                lineColor={0,0,255},
                pattern=LinePattern.None,
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid),
              Rectangle(
                extent={{-101,6},{100,-4}},
                lineColor={0,0,255},
                pattern=LinePattern.None,
                fillColor={0,0,255},
                fillPattern=FillPattern.Solid),
              Rectangle(
                extent={{0,-4},{100,6}},
                lineColor={0,0,255},
                pattern=LinePattern.None,
                fillColor={255,0,0},
                fillPattern=FillPattern.Solid)}));
      end TwoPortHeatMassExchanger;

      partial model PartialTwoPortInterface
      "Partial model transporting fluid between two ports without storing mass or energy"
        import Modelica.Constants;
        extends Modelica.Fluid.Interfaces.PartialTwoPort(
          port_a(p(start=Medium.p_default,
                   nominal=Medium.p_default)),
          port_b(p(start=Medium.p_default,
                 nominal=Medium.p_default)));

        parameter Medium.MassFlowRate m_flow_nominal "Nominal mass flow rate"
          annotation(Dialog(group = "Nominal condition"));
        parameter Medium.MassFlowRate m_flow_small(min=0) = 1E-4*abs(m_flow_nominal)
        "Small mass flow rate for regularization of zero flow"
          annotation(Dialog(tab = "Advanced"));
        parameter Boolean homotopyInitialization = true
        "= true, use homotopy method"
          annotation(Evaluate=true, Dialog(tab="Advanced"));

        // Diagnostics
         parameter Boolean show_V_flow = false
        "= true, if volume flow rate at inflowing port is computed"
          annotation(Dialog(tab="Advanced",group="Diagnostics"));
         parameter Boolean show_T = false
        "= true, if actual temperature at port is computed (may lead to events)"
          annotation(Dialog(tab="Advanced",group="Diagnostics"));

        Modelica.SIunits.VolumeFlowRate V_flow=
            m_flow/Medium.density(sta_a) if show_V_flow
        "Volume flow rate at inflowing port (positive when flow from port_a to port_b)";

        Medium.MassFlowRate m_flow(start=0) = port_a.m_flow
        "Mass flow rate from port_a to port_b (m_flow > 0 is design flow direction)";
        Modelica.SIunits.Pressure dp(start=0, displayUnit="Pa") = port_a.p - port_b.p
        "Pressure difference between port_a and port_b";

        Medium.ThermodynamicState sta_a=if homotopyInitialization then
            Medium.setState_phX(port_a.p,
                                homotopy(actual=actualStream(port_a.h_outflow),
                                         simplified=inStream(port_a.h_outflow)),
                                homotopy(actual=actualStream(port_a.Xi_outflow),
                                         simplified=inStream(port_a.Xi_outflow)))
          else
            Medium.setState_phX(port_a.p,
                                actualStream(port_a.h_outflow),
                                actualStream(port_a.Xi_outflow)) if
               show_T or show_V_flow "Medium properties in port_a";

        Medium.ThermodynamicState sta_b=if homotopyInitialization then
            Medium.setState_phX(port_b.p,
                                homotopy(actual=actualStream(port_b.h_outflow),
                                         simplified=port_b.h_outflow),
                                homotopy(actual=actualStream(port_b.Xi_outflow),
                                  simplified=port_b.Xi_outflow))
          else
            Medium.setState_phX(port_b.p,
                                actualStream(port_b.h_outflow),
                                actualStream(port_b.Xi_outflow)) if
                show_T "Medium properties in port_b";

        annotation (
          preferedView="info",
          Diagram(coordinateSystem(
              preserveAspectRatio=false,
              extent={{-100,-100},{100,100}},
              grid={1,1}), graphics),
          Documentation(info="<html>
<p>
This component defines the interface for models that 
transports a fluid between two ports. It is similar to 
<a href=\"Modelica://Modelica.Fluid.Interfaces.PartialTwoPortTransport\">
Modelica.Fluid.Interfaces.PartialTwoPortTransport</a>, but it does not 
include the species balance 
<pre>
  port_b.Xi_outflow = inStream(port_a.Xi_outflow);
</pre>
Thus, it can be used as a base class for a heat <i>and</i> mass transfer component
</p>
<p>
The model is used by other models in this package that add heat transfer,
mass transfer and pressure drop equations. See for example
<a href=\"modelica://Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger\">
Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger</a>.
</p>
</html>",       revisions="<html>
<ul>
<li>
March 27, 2012 by Michael Wetter:<br>
Changed condition to remove <code>sta_a</code> to also
compute the state at the inlet port if <code>show_V_flow=true</code>. 
The previous implementation resulted in a translation error
if <code>show_V_flow=true</code>, but worked correctly otherwise
because the erroneous function call is removed if  <code>show_V_flow=false</code>.
</li>
<li>
March 27, 2011 by Michael Wetter:<br>
Added <code>homotopy</code> operator.
</li>
<li>
March 21, 2010 by Michael Wetter:<br>
Changed pressure start value from <code>system.p_start</code>
to <code>Medium.p_default</code> since HVAC models may have water and 
air, which are typically at different pressures.
</li>
<li>
September 19, 2008 by Michael Wetter:<br>
Added equations for the mass balance of extra species flow,
i.e., <code>C</code> and <code>mC_flow</code>.
</li>
<li>
March 11, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
      end PartialTwoPortInterface;

      model ConservationEquation "Lumped volume with mass and energy balance"

      //  outer Modelica.Fluid.System system "System properties";
        extends Buildings.Fluid.Interfaces.LumpedVolumeDeclarations;
        // Port definitions
        parameter Integer nPorts=0 "Number of ports"
          annotation(Evaluate=true, Dialog(connectorSizing=true, tab="General",group="Ports"));
        Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b ports[nPorts](
            redeclare each package Medium = Medium) "Fluid inlets and outlets"
          annotation (Placement(transformation(extent={{-40,-10},{40,10}},
            origin={0,-100})));

        // Set nominal attributes where literal values can be used.
        Medium.BaseProperties medium(
          preferredMediumStates= not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState),
          p(start=p_start,
            nominal=Medium.p_default,
            stateSelect=if not (massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)
                           then StateSelect.prefer else StateSelect.default),
          h(start=Medium.specificEnthalpy_pTX(p_start, T_start, X_start)),
          T(start=T_start,
            nominal=Medium.T_default,
            stateSelect=if (not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState))
                           then StateSelect.prefer else StateSelect.default),
          Xi(start=X_start[1:Medium.nXi],
             nominal=Medium.X_default[1:Medium.nXi],
             stateSelect=if (not (substanceDynamics == Modelica.Fluid.Types.Dynamics.SteadyState))
                           then StateSelect.prefer else StateSelect.default),
          d(start=rho_nominal)) "Medium properties";

        Modelica.SIunits.Energy U "Internal energy of fluid";
        Modelica.SIunits.Mass m "Mass of fluid";
        Modelica.SIunits.Mass[Medium.nXi] mXi
        "Masses of independent components in the fluid";
        Modelica.SIunits.Mass[Medium.nC] mC
        "Masses of trace substances in the fluid";
        // C need to be added here because unlike for Xi, which has medium.Xi,
        // there is no variable medium.C
        Medium.ExtraProperty C[Medium.nC](nominal=C_nominal)
        "Trace substance mixture content";

        Modelica.SIunits.MassFlowRate mb_flow "Mass flows across boundaries";
        Modelica.SIunits.MassFlowRate[Medium.nXi] mbXi_flow
        "Substance mass flows across boundaries";
        Medium.ExtraPropertyFlowRate[Medium.nC] mbC_flow
        "Trace substance mass flows across boundaries";
        Modelica.SIunits.EnthalpyFlowRate Hb_flow
        "Enthalpy flow across boundaries or energy source/sink";

        // Inputs that need to be defined by an extending class
        input Modelica.SIunits.Volume fluidVolume "Volume";

        Modelica.Blocks.Interfaces.RealInput Q_flow(unit="W")
        "Heat transfered into the medium"
          annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
        Modelica.Blocks.Interfaces.RealInput mXi_flow[Medium.nXi](unit="kg/s")
        "Mass flow rates of independent substances added to the medium"
          annotation (Placement(transformation(extent={{-140,0},{-100,40}})));

        // Outputs that are needed in models that extend this model
        Modelica.Blocks.Interfaces.RealOutput hOut(unit="J/kg")
        "Leaving enthalpy of the component"
           annotation (Placement(transformation(extent={{-10,-10},{10,10}},
              rotation=90,
              origin={-50,110})));
        Modelica.Blocks.Interfaces.RealOutput XiOut[Medium.nXi](unit="1")
        "Leaving species concentration of the component"
          annotation (Placement(transformation(extent={{-10,-10},{10,10}},
              rotation=90,
              origin={0,110})));
        Modelica.Blocks.Interfaces.RealOutput COut[Medium.nC](unit="1")
        "Leaving trace substances of the component"
          annotation (Placement(transformation(extent={{-10,-10},{10,10}},
              rotation=90,
              origin={50,110})));
    protected
        parameter Boolean initialize_p = not Medium.singleState
        "= true to set up initial equations for pressure";

        Medium.EnthalpyFlowRate ports_H_flow[nPorts];
        Medium.MassFlowRate ports_mXi_flow[nPorts,Medium.nXi];
        Medium.ExtraPropertyFlowRate ports_mC_flow[nPorts,Medium.nC];

        parameter Modelica.SIunits.Density rho_nominal=Medium.density(
         Medium.setState_pTX(
           T=T_start,
           p=p_start,
           X=X_start[1:Medium.nXi])) "Density, used to compute fluid mass"
        annotation (Evaluate=true);
      equation
        // Total quantities
        m = fluidVolume*medium.d;
        mXi = m*medium.Xi;
        U = m*medium.u;
        mC = m*C;

        hOut = medium.h;
        XiOut = medium.Xi;
        COut = C;

        for i in 1:nPorts loop
          ports_H_flow[i]     = ports[i].m_flow * actualStream(ports[i].h_outflow)
          "Enthalpy flow";
          ports_mXi_flow[i,:] = ports[i].m_flow * actualStream(ports[i].Xi_outflow)
          "Component mass flow";
          ports_mC_flow[i,:]  = ports[i].m_flow * actualStream(ports[i].C_outflow)
          "Trace substance mass flow";
        end for;

        for i in 1:Medium.nXi loop
          mbXi_flow[i] = sum(ports_mXi_flow[:,i]);
        end for;

        for i in 1:Medium.nC loop
          mbC_flow[i]  = sum(ports_mC_flow[:,i]);
        end for;

        mb_flow = sum(ports.m_flow);
        Hb_flow = sum(ports_H_flow);

        // Energy and mass balances
        if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then
          0 = Hb_flow + Q_flow;
        else
          der(U) = Hb_flow + Q_flow;
        end if;

        if massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then
          0 = mb_flow + sum(mXi_flow);
        else
          der(m) = mb_flow + sum(mXi_flow);
        end if;

        if substanceDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then
          zeros(Medium.nXi) = mbXi_flow + mXi_flow;
        else
          der(mXi) = mbXi_flow + mXi_flow;
        end if;

        if traceDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then
          zeros(Medium.nC)  = mbC_flow;
        else
          der(mC)  = mbC_flow;
        end if;

        // Properties of outgoing flows
        for i in 1:nPorts loop
            ports[i].p          = medium.p;
            ports[i].h_outflow  = medium.h;
            ports[i].Xi_outflow = medium.Xi;
            ports[i].C_outflow  = C;
        end for;
      initial equation
        // Make sure that if energyDynamics is SteadyState, then
        // massDynamics is also SteadyState.
        // Otherwise, the system of ordinary differential equations may be inconsistent.
        if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then
          assert(massDynamics == energyDynamics, "
         If 'massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState', then it is 
         required that 'energyDynamics==Modelica.Fluid.Types.Dynamics.SteadyState'.
         Otherwise, the system of equations may not be consistent.
         You need to select other parameter values.");
        end if;

        // initialization of balances
        if energyDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial then
      //    if use_T_start then
            medium.T = T_start;
      //    else
      //      medium.h = h_start;
      //    end if;
        else
          if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial then
      //      if use_T_start then
              der(medium.T) = 0;
      //      else
      //        der(medium.h) = 0;
      //      end if;
          end if;
        end if;

        if massDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial then
          if initialize_p then
            medium.p = p_start;
          end if;
        else
          if massDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial then
            if initialize_p then
              der(medium.p) = 0;
            end if;
          end if;
        end if;

        if substanceDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial then
          medium.Xi = X_start[1:Medium.nXi];
        else
          if substanceDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial then
            der(medium.Xi) = zeros(Medium.nXi);
          end if;
        end if;

        if traceDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial then
          C = C_start[1:Medium.nC];
        else
          if traceDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial then
            der(C) = zeros(Medium.nC);
          end if;
        end if;

        annotation (
          Documentation(info="<html>
<p>
Basic model for an ideally mixed fluid volume with the ability to store mass and energy.
It implements a dynamic or a steady-state conservation equation for energy and mass fractions.
The model has zero pressure drop between its ports.
</p>
<h4>Implementation</h4>
<p>
When extending or instantiating this model, the input 
<code>fluidVolume</code>, which is the actual volume occupied by the fluid,
needs to be assigned.
For most components, this can be set to a parameter. However, for components such as 
expansion vessels, the fluid volume can change in time.
</p>
<p>
Input connectors of the model are
<ul>
<li>
<code>Q_flow</code>, which is the sensible plus latent heat flow rate added to the medium, and
</li>
<li>
<code>mXi_flow</code>, which is the species mass flow rate added to the medium.
</li>
</ul>
</p>
<p>
The model can be used as a dynamic model or as a steady-state model.
However, for a steady-state model with exactly two fluid ports connected, 
the model
<a href=\"modelica://Buildings.Fluid.Interfaces.StaticTwoPortConservationEquation\">
Buildings.Fluid.Interfaces.StaticTwoPortConservationEquation</a>
provides a more efficient implementation.
</p>
<p>
For models that instantiates this model, see
<a href=\"modelica://Buildings.Fluid.MixingVolumes.MixingVolume\">
Buildings.Fluid.MixingVolumes.MixingVolume</a> and
<a href=\"modelica://Buildings.Fluid.Storage.ExpansionVessel\">
Buildings.Fluid.Storage.ExpansionVessel</a>.
</p>
</html>",       revisions="<html>
<ul>
<li>
July 31, 2011 by Michael Wetter:<br>
Added test to stop model translation if the setting for
<code>energyBalance</code> and <code>massBalance</code>
can lead to inconsistent equations.
</li>
<li>
July 26, 2011 by Michael Wetter:<br>
Removed the option to use <code>h_start</code>, as this
is not needed for building simulation. 
Also removed the reference to <code>Modelica.Fluid.System</code>.
Moved parameters and medium to 
<a href=\"Buildings.Fluid.Interfaces.LumpedVolumeDeclarations\">
Buildings.Fluid.Interfaces.LumpedVolumeDeclarations</a>.
<li>
July 14, 2011 by Michael Wetter:<br>
Added start value for medium density.
</li>
<li>
March 29, 2011 by Michael Wetter:<br>
Changed default value for <code>substanceDynamics</code> and
<code>traceDynamics</code> from <code>energyDynamics</code>
to <code>massDynamics</code>.
</li>
<li>
September 28, 2010 by Michael Wetter:<br>
Changed array index for nominal value of <code>Xi</code>.
<li>
September 13, 2010 by Michael Wetter:<br>
Set nominal attributes for medium based on default medium values.
</li>
<li>
July 30, 2010 by Michael Wetter:<br>
Added parameter <code>C_nominal</code> which is used as the nominal attribute for <code>C</code>.
Without this value, the ODE solver gives wrong results for concentrations around 1E-7.
</li>
<li>
March 21, 2010 by Michael Wetter:<br>
Changed pressure start value from <code>system.p_start</code>
to <code>Medium.p_default</code> since HVAC models may have water and 
air, which are typically at different pressures.
</li>
<li><i>February 6, 2010</i> by Michael Wetter:<br>
Added to <code>Medium.BaseProperties</code> the initialization 
<code>X(start=X_start[1:Medium.nX])</code>. Previously, the initialization
was only done for <code>Xi</code> but not for <code>X</code>, which caused the
medium to be initialized to <code>reference_X</code>, ignoring the value of <code>X_start</code>.
</li>
<li><i>October 12, 2009</i> by Michael Wetter:<br>
Implemented first version in <code>Buildings</code> library, based on model from
<code>Modelica.Fluid 1.0</code>.
</li>
</ul>
</html>"),Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
                  100,100}}),
                  graphics),
          Icon(graphics={            Rectangle(
                extent={{-100,100},{100,-100}},
                fillColor={135,135,135},
                fillPattern=FillPattern.Solid,
                pattern=LinePattern.None),
              Text(
                extent={{-89,17},{-54,34}},
                lineColor={0,0,127},
                textString="mXi_flow"),
              Text(
                extent={{-89,52},{-54,69}},
                lineColor={0,0,127},
                textString="Q_flow"),
              Line(points={{-56,-73},{81,-73}}, color={255,255,255}),
              Line(points={{-42,55},{-42,-84}}, color={255,255,255}),
              Polygon(
                points={{-42,67},{-50,45},{-34,45},{-42,67}},
                lineColor={255,255,255},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Polygon(
                points={{87,-73},{65,-65},{65,-81},{87,-73}},
                lineColor={255,255,255},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Line(
                points={{-42,-28},{-6,-28},{18,4},{40,12},{66,14}},
                color={255,255,255},
                smooth=Smooth.Bezier),
              Text(
                extent={{-155,-120},{145,-160}},
                lineColor={0,0,255},
                textString="%name")}));
      end ConservationEquation;

      model StaticTwoPortConservationEquation
      "Partial model for static energy and mass conservation equations"
        extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
        showDesignFlowDirection = false);
      //  import Modelica.Constants;
        Modelica.Blocks.Interfaces.RealInput Q_flow(unit="W")
        "Heat transfered into the medium"
          annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
        Modelica.Blocks.Interfaces.RealInput mXi_flow[Medium.nXi](unit="kg/s")
        "Mass flow rates of independent substances added to the medium"
          annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
        constant Boolean sensibleOnly "Set to true if sensible exchange only";
        // Outputs that are needed in models that extend this model
        Modelica.Blocks.Interfaces.RealOutput hOut(unit="J/kg")
        "Leaving temperature of the component"
          annotation (Placement(transformation(extent={{-10,-10},{10,10}},
              rotation=90,
              origin={-50,110}), iconTransformation(
              extent={{-10,-10},{10,10}},
              rotation=90,
              origin={-50,110})));
        Modelica.Blocks.Interfaces.RealOutput XiOut[Medium.nXi](unit="1")
        "Leaving species concentration of the component"
          annotation (Placement(transformation(extent={{-10,-10},{10,10}},
              rotation=90,
              origin={0,110})));
        Modelica.Blocks.Interfaces.RealOutput COut[Medium.nC](unit="1")
        "Leaving trace substances of the component"
          annotation (Placement(transformation(extent={{-10,-10},{10,10}},
              rotation=90,
              origin={50,110})));
        constant Boolean use_safeDivision=true
        "Set to true to improve numerical robustness";
    protected
        Real m_flowInv(unit="s/kg") "Regularization of 1/m_flow";
      equation
        // Regularization of m_flow around the origin to avoid a division by zero
       if use_safeDivision then
          m_flowInv = Buildings.Utilities.Math.Functions.inverseXRegularized(x=port_a.m_flow, delta=m_flow_small/1E3);
       else
           m_flowInv = 0; // m_flowInv is not used if use_safeDivision = false.
       end if;
       if allowFlowReversal then
      // This formulation fails to simulate in Buildings.Fluid.MixingVolumes.Examples.MixingVolumePrescribedHeatFlowRate
      // with Dymola 2012. See also Dynasim ticket 13596.
      // It works with Dymola 2012 FD01.
         if (port_a.m_flow >= 0) then
           hOut =  port_b.h_outflow;
           XiOut = port_b.Xi_outflow;
           COut =  port_b.C_outflow;
          else
           hOut =  port_a.h_outflow;
           XiOut = port_a.Xi_outflow;
           COut =  port_a.C_outflow;
          end if;
       else
         hOut =  port_b.h_outflow;
         XiOut = port_b.Xi_outflow;
         COut =  port_b.C_outflow;
       end if;
        //////////////////////////////////////////////////////////////////////////////////////////
        // Energy balance and mass balance
        if sensibleOnly then
          // Mass balance
          port_a.m_flow = -port_b.m_flow;
          // Energy balance
          if use_safeDivision then
            port_b.h_outflow = inStream(port_a.h_outflow) + Q_flow * m_flowInv;
            port_a.h_outflow = inStream(port_b.h_outflow) - Q_flow * m_flowInv;
          else
            port_a.m_flow * (inStream(port_a.h_outflow) - port_b.h_outflow) = Q_flow;
            port_a.m_flow * (inStream(port_b.h_outflow) - port_a.h_outflow) = -Q_flow;
          end if;
          // Transport of species
          port_a.Xi_outflow = inStream(port_b.Xi_outflow);
          port_b.Xi_outflow = inStream(port_a.Xi_outflow);
          // Transport of trace substances
          port_a.C_outflow = inStream(port_b.C_outflow);
          port_b.C_outflow = inStream(port_a.C_outflow);
        else
          // Mass balance (no storage)
          port_a.m_flow + port_b.m_flow = -sum(mXi_flow);
          // Energy balance.
          // This equation is approximate since m_flow = port_a.m_flow is used for the mass flow rate
          // at both ports. Since mXi_flow << m_flow, the error is small.
          if use_safeDivision then
            port_b.h_outflow = inStream(port_a.h_outflow) + Q_flow * m_flowInv;
            port_a.h_outflow = inStream(port_b.h_outflow) - Q_flow * m_flowInv;
            // Transport of species
            for i in 1:Medium.nXi loop
              port_b.Xi_outflow[i] = inStream(port_a.Xi_outflow[i]) + mXi_flow[i] * m_flowInv;
              port_a.Xi_outflow[i] = inStream(port_b.Xi_outflow[i]) - mXi_flow[i] * m_flowInv;
            end for;
           else
            port_a.m_flow * (port_b.h_outflow - inStream(port_a.h_outflow)) = Q_flow;
            port_a.m_flow * (port_a.h_outflow - inStream(port_b.h_outflow)) = -Q_flow;
            // Transport of species
            for i in 1:Medium.nXi loop
              port_a.m_flow * (port_b.Xi_outflow[i] - inStream(port_a.Xi_outflow[i])) = mXi_flow[i];
              port_a.m_flow * (port_a.Xi_outflow[i] - inStream(port_b.Xi_outflow[i])) =- mXi_flow[i];
            end for;
           end if;
          // Transport of trace substances
          for i in 1:Medium.nC loop
            port_a.m_flow*port_a.C_outflow[i] = -port_b.m_flow*inStream(port_b.C_outflow[i]);
            port_b.m_flow*port_b.C_outflow[i] = -port_a.m_flow*inStream(port_a.C_outflow[i]);
          end for;
        end if; // sensibleOnly
        //////////////////////////////////////////////////////////////////////////////////////////
        // No pressure drop in this model
        port_a.p = port_b.p;
        annotation (
          preferedView="info",
          Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={1,1}), graphics),
          Documentation(info="<html>
<p>
This model transports fluid between its two ports, without storing mass or energy. 
It implements a steady-state conservation equation for energy and mass fractions.
The model has zero pressure drop between its ports.
</p>
<h4>Implementation</h4>
<p>
Input connectors of the model are
<ul>
<li>
<code>Q_flow</code>, which is the sensible plus latent heat flow rate added to the medium, and
</li>
<li>
<code>mXi_flow</code>, which is the species mass flow rate added to the medium.
</li>
</ul>
</p>
<p>
The model can only be used as a steady-state model with two fluid ports.
For a model with a dynamic balance, and more fluid ports, use
<a href=\"modelica://Buildings.Fluid.Interfaces.ConservationEquation\">
Buildings.Fluid.Interfaces.ConservationEquation</a>.
</p>
<p>
Set the constant <code>sensibleOnly=true</code> if the model that extends
or instantiates this model sets <code>mXi_flow = zeros(Medium.nXi)</code>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
June 22, 2012 by Michael Wetter:<br>
Reformulated implementation with <code>m_flowInv</code> to use <code>port_a.m_flow * ...</code>
if <code>use_safeDivision=false</code>. This avoids a division by zero if 
<code>port_a.m_flow=0</code>.
</li>
<li>
February 7, 2012 by Michael Wetter:<br>
Revised base classes for conservation equations in <code>Buildings.Fluid.Interfaces</code>.
</li>
<li>
December 14, 2011 by Michael Wetter:<br>
Changed assignment of <code>hOut</code>, <code>XiOut</code> and
<code>COut</code> to no longer declare that it is continuous. 
The declaration of continuity, i.e, the 
<code>smooth(0, if (port_a.m_flow >= 0) then ...</code> declaration,
was required for Dymola 2012 to simulate, but it is no longer needed 
for Dymola 2012 FD01.
</li>
<li>
August 19, 2011, by Michael Wetter:<br>
Changed assignment of <code>hOut</code>, <code>XiOut</code> and
<code>COut</code> to declare that it is not differentiable.
</li>
<li>
August 4, 2011, by Michael Wetter:<br>
Moved linearized pressure drop equation from the function body to the equation
section. With the previous implementation, 
the symbolic processor may not rearrange the equations, which can lead 
to coupled equations instead of an explicit solution.
</li>
<li>
March 29, 2011, by Michael Wetter:<br>
Changed energy and mass balance to avoid a division by zero if <code>m_flow=0</code>.
</li>
<li>
March 27, 2011, by Michael Wetter:<br>
Added <code>homotopy</code> operator.
</li>
<li>
August 19, 2010, by Michael Wetter:<br>
Fixed bug in energy and moisture balance that affected results if a component
adds or removes moisture to the air stream. 
In the old implementation, the enthalpy and species
outflow at <code>port_b</code> was multiplied with the mass flow rate at 
<code>port_a</code>. The old implementation led to small errors that were proportional
to the amount of moisture change. For example, if the moisture added by the component
was <code>0.005 kg/kg</code>, then the error was <code>0.5%</code>.
Also, the results for forward flow and reverse flow differed by this amount.
With the new implementation, the energy and moisture balance is exact.
</li>
<li>
March 22, 2010, by Michael Wetter:<br>
Added constant <code>sensibleOnly</code> to 
simplify species balance equation.
</li>
<li>
April 10, 2009, by Michael Wetter:<br>
Added model to compute flow friction.
</li>
<li>
April 22, 2008, by Michael Wetter:<br>
Revised to add mass balance.
</li>
<li>
March 17, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),Icon(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={1,1}), graphics={Rectangle(
                extent={{-100,100},{100,-100}},
                fillColor={135,135,135},
                fillPattern=FillPattern.Solid,
                pattern=LinePattern.None),
              Text(
                extent={{-93,72},{-58,89}},
                lineColor={0,0,127},
                textString="Q_flow"),
              Text(
                extent={{-93,37},{-58,54}},
                lineColor={0,0,127},
                textString="mXi_flow"),
              Text(
                extent={{-41,103},{-10,117}},
                lineColor={0,0,127},
                textString="hOut"),
              Text(
                extent={{10,103},{41,117}},
                lineColor={0,0,127},
                textString="XiOut"),
              Text(
                extent={{61,103},{92,117}},
                lineColor={0,0,127},
                textString="COut"),
              Line(points={{-42,55},{-42,-84}}, color={255,255,255}),
              Polygon(
                points={{-42,67},{-50,45},{-34,45},{-42,67}},
                lineColor={255,255,255},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Polygon(
                points={{87,-73},{65,-65},{65,-81},{87,-73}},
                lineColor={255,255,255},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Line(points={{-56,-73},{81,-73}}, color={255,255,255}),
              Line(points={{6,14},{6,-37}},     color={255,255,255}),
              Line(points={{54,14},{6,14}},     color={255,255,255}),
              Line(points={{6,-37},{-42,-37}},  color={255,255,255})}));
      end StaticTwoPortConservationEquation;

      record TwoPortFlowResistanceParameters
      "Parameters for flow resistance for models with two ports"

        parameter Boolean computeFlowResistance = true
        "=true, compute flow resistance. Set to false to assume no friction"
          annotation (Evaluate=true, Dialog(tab="Flow resistance"));

        parameter Boolean from_dp = false
        "= true, use m_flow = f(dp) else dp = f(m_flow)"
          annotation (Evaluate=true, Dialog(enable = computeFlowResistance,
                      tab="Flow resistance"));
        parameter Modelica.SIunits.Pressure dp_nominal(min=0, displayUnit="Pa")
        "Pressure"                                  annotation(Dialog(group = "Nominal condition"));
        parameter Boolean linearizeFlowResistance = false
        "= true, use linear relation between m_flow and dp for any flow rate"
          annotation(Dialog(enable = computeFlowResistance,
                     tab="Flow resistance"));
        parameter Real deltaM = 0.1
        "Fraction of nominal flow rate where flow transitions to laminar"
          annotation(Dialog(enable = computeFlowResistance, tab="Flow resistance"));

      annotation (preferedView="info",
      Documentation(info="<html>
This class contains parameters that are used to
compute the pressure drop in models that have one fluid stream.
Note that the nominal mass flow rate is not declared here because
the model 
<a href=\"modelica://Buildings.Fluid.Interfaces.PartialTwoPortInterface\">
PartialTwoPortInterface</a>
already declares it.
</html>",
      revisions="<html>
<ul>
<li>
April 13, 2009, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
      end TwoPortFlowResistanceParameters;

      record LumpedVolumeDeclarations "Declarations for lumped volumes"
        replaceable package Medium =
          Modelica.Media.Interfaces.PartialMedium "Medium in the component"
            annotation (choicesAllMatching = true);

        // Assumptions
        parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
        "Formulation of energy balance"
          annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
        parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
        "Formulation of mass balance"
          annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
        final parameter Modelica.Fluid.Types.Dynamics substanceDynamics=energyDynamics
        "Formulation of substance balance"
          annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
        final parameter Modelica.Fluid.Types.Dynamics traceDynamics=energyDynamics
        "Formulation of trace substance balance"
          annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));

        // Initialization
        parameter Medium.AbsolutePressure p_start = Medium.p_default
        "Start value of pressure"
          annotation(Dialog(tab = "Initialization"));
      //  parameter Boolean use_T_start = true "= true, use T_start, otherwise h_start"
       //   annotation(Dialog(tab = "Initialization"), Evaluate=true);
        parameter Medium.Temperature T_start=Medium.T_default
        "Start value of temperature"
          annotation(Dialog(tab = "Initialization"));
      //  parameter Medium.SpecificEnthalpy h_start=
      //    if use_T_start then Medium.specificEnthalpy_pTX(p_start, T_start, X_start) else Medium.h_default
      //    "Start value of specific enthalpy"
      //    annotation(Dialog(tab = "Initialization", enable = not use_T_start));
        parameter Medium.MassFraction X_start[Medium.nX] = Medium.X_default
        "Start value of mass fractions m_i/m"
          annotation (Dialog(tab="Initialization", enable=Medium.nXi > 0));
        parameter Medium.ExtraProperty C_start[Medium.nC](
             quantity=Medium.extraPropertiesNames)=fill(0, Medium.nC)
        "Start value of trace substances"
          annotation (Dialog(tab="Initialization", enable=Medium.nC > 0));
        parameter Medium.ExtraProperty C_nominal[Medium.nC](
             quantity=Medium.extraPropertiesNames) = fill(1E-2, Medium.nC)
        "Nominal value of trace substances. (Set to typical order of magnitude.)"
         annotation (Dialog(tab="Initialization", enable=Medium.nC > 0));

      annotation (preferedView="info",
      Documentation(info="<html>
<p>
This class contains parameters and medium properties
that are used in the lumped  volume model, and in models that extend the 
lumped volume model.
</p>
<p>
These parameters are used by
<a href=\"modelica://Buildings.Fluid.Interfaces.ConservationEquation\">
Buildings.Fluid.Interfaces.ConservationEquation</a>,
<a href=\"modelica://Buildings.Fluid.MixingVolumes.MixingVolume\">
Buildings.Fluid.MixingVolumes.MixingVolume</a>,
<a href=\"modelica://Buildings.Rooms.MixedAir\">
Buildings.Rooms.MixedAir</a>, and by
<a href=\"modelica://Buildings.Rooms.BaseClasses.MixedAir\">
Buildings.Rooms.BaseClasses.MixedAir</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
August 2, 2011, by Michael Wetter:<br>
Set <code>substanceDynamics</code> and <code>traceDynamics<code> to final
and equal to <code>energyDynamics</code>, 
as there is no need to make them different from <code>energyDynamics</code>.
</li>
<li>
August 1, 2011, by Michael Wetter:<br>
Changed default value for <code>energyDynamics</code> to
<code>Modelica.Fluid.Types.Dynamics.DynamicFreeInitial</code> because
<code>Modelica.Fluid.Types.Dynamics.SteadyStateInitial</code> leads
to high order DAE that Dymola cannot reduce.
</li>
<li>
July 31, 2011, by Michael Wetter:<br>
Changed default value for <code>energyDynamics</code> to
<code>Modelica.Fluid.Types.Dynamics.SteadyStateInitial</code>.
</li>
<li>
April 13, 2009, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
      end LumpedVolumeDeclarations;
    annotation (preferedView="info", Documentation(info="<html>
This package contains basic classes that are used to build
component models that change the state of the
fluid. The classes are not directly usable, but can
be extended when building a new model.
</html>"));
    end Interfaces;
  annotation (
  preferedView="info", Documentation(info="<html>
This package contains components for fluid flow systems such as
pumps, valves and sensors. For other fluid flow models, see 
<a href=\"Modelica:Modelica.Fluid\">Modelica.Fluid</a>.
</html>"));
  end Fluid;

  package HeatTransfer "Package with heat transfer models"
    extends Modelica.Icons.Package;

    package Sources "Thermal sources"
    extends Modelica.Icons.SourcesPackage;

      model PrescribedHeatFlow "Prescribed heat flow boundary condition"
        Modelica.Blocks.Interfaces.RealInput Q_flow
              annotation (Placement(transformation(
              origin={-100,0},
              extent={{20,-20},{-20,20}},
              rotation=180)));
        Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port annotation (Placement(transformation(extent={{90,
                  -10},{110,10}}, rotation=0)));
      equation
        port.Q_flow = -Q_flow;
        annotation (
          Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                  100,100}}), graphics={
              Line(
                points={{-60,-20},{40,-20}},
                color={191,0,0},
                thickness=0.5),
              Line(
                points={{-60,20},{40,20}},
                color={191,0,0},
                thickness=0.5),
              Line(
                points={{-80,0},{-60,-20}},
                color={191,0,0},
                thickness=0.5),
              Line(
                points={{-80,0},{-60,20}},
                color={191,0,0},
                thickness=0.5),
              Polygon(
                points={{40,0},{40,40},{70,20},{40,0}},
                lineColor={191,0,0},
                fillColor={191,0,0},
                fillPattern=FillPattern.Solid),
              Polygon(
                points={{40,-40},{40,0},{70,-20},{40,-40}},
                lineColor={191,0,0},
                fillColor={191,0,0},
                fillPattern=FillPattern.Solid),
              Rectangle(
                extent={{70,40},{90,-40}},
                lineColor={191,0,0},
                fillColor={191,0,0},
                fillPattern=FillPattern.Solid),
              Text(
                extent={{-150,100},{150,60}},
                textString="%name",
                lineColor={0,0,255})}),
          Documentation(info="<HTML>
<p>
This model allows a specified amount of heat flow rate to be \"injected\"
into a thermal system at a given port.  The amount of heat
is given by the input signal Q_flow into the model. The heat flows into the
component to which the component PrescribedHeatFlow is connected,
if the input signal is positive.
</p>
<p>
This model is identical to
<a href=\"modelica:Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow\">
Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow</a>, except that
the parameters <code>alpha</code> and <code>T_ref</code> have
been deleted as these can cause division by zero in some fluid flow models.
</p>
</HTML>
",    revisions="<html>
<ul>
<li>
March 29 2011, by Michael Wetter:<br>
First implementation based on <a href=\"modelica:Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow\">
Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow</a>.
</li>
</ul>
</html>"),       Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
                  {100,100}}), graphics={
              Line(
                points={{-60,-20},{68,-20}},
                color={191,0,0},
                thickness=0.5),
              Line(
                points={{-60,20},{68,20}},
                color={191,0,0},
                thickness=0.5),
              Line(
                points={{-80,0},{-60,-20}},
                color={191,0,0},
                thickness=0.5),
              Line(
                points={{-80,0},{-60,20}},
                color={191,0,0},
                thickness=0.5),
              Polygon(
                points={{60,0},{60,40},{90,20},{60,0}},
                lineColor={191,0,0},
                fillColor={191,0,0},
                fillPattern=FillPattern.Solid),
              Polygon(
                points={{60,-40},{60,0},{90,-20},{60,-40}},
                lineColor={191,0,0},
                fillColor={191,0,0},
                fillPattern=FillPattern.Solid)}));
      end PrescribedHeatFlow;
      annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                -100},{100,100}}), graphics),   Documentation(info="<html>
This package is identical to
<a href=\"modelica:Modelica.Thermal.HeatTransfer.Sources\">
Modelica.Thermal.HeatTransfer.Sources</a>, except that
the parameters <code>alpha</code> and <code>T_ref</code> have
been deleted in the models
<a href=\"modelica:Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow\">
Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow</a> and
<a href=\"modelica:Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow\">
Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow</a>
 as these can cause division by zero in some fluid flow models.
</html>"));
    end Sources;
  annotation (preferedView="info", Documentation(info="<html>
This package contains models for heat transfer elements.
</html>"));
  end HeatTransfer;

  package Media "Package with medium models"
    extends Modelica.Icons.MaterialPropertiesPackage;

    package GasesPTDecoupled
    "Package with models for gases where pressure and temperature are independent of each other"
      extends Modelica.Icons.MaterialPropertiesPackage;

      package MoistAirUnsaturated
      "Package with moist air model that decouples pressure and temperature and that has no liquid water"
        extends Modelica.Media.Interfaces.PartialCondensingGases(
           final singleState = false,
           mediumName="MoistAirPTDecoupledUnsaturated",
           substanceNames={"water", "air"},
           final reducedX=true,
           reference_X={0.01,0.99},
           fluidConstants = {Modelica.Media.IdealGases.Common.FluidData.H2O,
                             Modelica.Media.IdealGases.Common.FluidData.N2});

        constant Integer Water=1
        "Index of water (in substanceNames, massFractions X, etc.)";

        constant Integer Air=2
        "Index of air (in substanceNames, massFractions X, etc.)";

        constant Real k_mair =  steam.MM/dryair.MM "ratio of molar weights";

        constant Buildings.Media.PerfectGases.Common.DataRecord dryair=
              Buildings.Media.PerfectGases.Common.SingleGasData.Air;

        constant Buildings.Media.PerfectGases.Common.DataRecord steam=
              Buildings.Media.PerfectGases.Common.SingleGasData.H2O;
        import SI = Modelica.SIunits;

        constant AbsolutePressure pStp = 101325
        "Pressure for which dStp is defined";

        constant Density dStp = 1.2 "Fluid density at pressure pStp";

        redeclare record extends ThermodynamicState
        "ThermodynamicState record for moist air"
        end ThermodynamicState;

        redeclare replaceable model extends BaseProperties(
          T(stateSelect=if preferredMediumStates then StateSelect.prefer else StateSelect.default),
          p(stateSelect=if preferredMediumStates then StateSelect.prefer else StateSelect.default),
          Xi(each stateSelect=if preferredMediumStates then StateSelect.prefer else StateSelect.default))

          /* p, T, X = X[Water] are used as preferred states, since only then all
     other quantities can be computed in a recursive sequence. 
     If other variables are selected as states, static state selection
     is no longer possible and non-linear algebraic equations occur.
      */
          MassFraction x_water "Mass of total water/mass of dry air";
          Real phi "Relative humidity";

      protected
          constant SI.MolarMass[2] MMX = {steam.MM,dryair.MM}
          "Molar masses of components";

          //    MassFraction X_liquid "Mass fraction of liquid water";
          MassFraction X_steam "Mass fraction of steam water";
          MassFraction X_air "Mass fraction of air";
          MassFraction X_sat
          "Steam water mass fraction of saturation boundary in kg_water/kg_moistair";
          MassFraction x_sat
          "Steam water mass content of saturation boundary in kg_water/kg_dryair";
          AbsolutePressure p_steam_sat "Partial saturation pressure of steam";

        equation
          assert(T >= 200.0 and T <= 423.15, "
Temperature T is not in the allowed range
200.0 K <= (T ="     + String(T) + " K) <= 423.15 K
required from medium model \""           + mediumName + "\".");

        /*
    assert(Xi[Water] <= X_sat, "The medium model '" + mediumName + "' must not be saturated.\n"
     + "To model a saturated medium, use 'Buildings.Media.GasesPTDecoupled.MoistAir' instead of this medium.\n"
     + " T         = " + String(T) + "\n"
     + " X_sat     = " + String(X_sat) + "\n"
     + " Xi[Water] = " + String(Xi[Water]) + "\n"
     + " phi       = " + String(phi) + "\n"
     + " p         = " + String(p));
  */

          MM = 1/(Xi[Water]/MMX[Water]+(1.0-Xi[Water])/MMX[Air]);

          p_steam_sat = min(saturationPressure(T),0.999*p);
          X_sat = min(p_steam_sat * k_mair/max(100*Modelica.Constants.eps, p - p_steam_sat)*(1 - Xi[Water]), 1.0)
          "Water content at saturation with respect to actual water content";
          //    X_liquid = max(Xi[Water] - X_sat, 0.0);
          //    X_steam  = Xi[Water]-X_liquid;

          X_steam  = Xi[Water]; // There is no liquid in this medium model
          X_air    = 1-Xi[Water];

          h = specificEnthalpy_pTX(p,T,Xi);
          R = dryair.R*(1 - Xi[Water]) + steam.R*Xi[Water];

          // Equation for ideal gas, from h=u+p*v and R*T=p*v, from which follows that  u = h-R*T.
          // u = h-R*T;

          // However, in this medium, the gas law is d/dStp=p/pStp, from which follows using h=u+pv that
          // u= h-p*v = h-p/d = h-pStp/dStp
          u = h-pStp/dStp;

          //    d = p/(R*T);
          d/dStp = p/pStp;

          /* Note, u and d are computed under the assumption that the volume of the liquid
         water is neglible with respect to the volume of air and of steam
      */
          state.p = p;
          state.T = T;
          state.X = X;

          // this x_steam is water load / dry air!!!!!!!!!!!
          x_sat    = k_mair*p_steam_sat/max(100*Modelica.Constants.eps,p - p_steam_sat);
          x_water = Xi[Water]/max(X_air,100*Modelica.Constants.eps);
          phi = p/p_steam_sat*Xi[Water]/(Xi[Water] + k_mair*X_air);
        end BaseProperties;

        redeclare function setState_pTX
        "Thermodynamic state as function of p, T and composition X"
            extends Buildings.Media.PerfectGases.MoistAir.setState_pTX;
        end setState_pTX;

        redeclare function setState_phX
        "Thermodynamic state as function of p, h and composition X"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input SpecificEnthalpy h "Specific enthalpy";
        input MassFraction X[:] "Mass fractions";
        output ThermodynamicState state;
        algorithm
        state := if size(X,1) == nX then
               ThermodynamicState(p=p,T=T_phX(p,h,X),X=X) else
              ThermodynamicState(p=p,T=T_phX(p,h,cat(1,X,{1-sum(X)})), X=cat(1,X,{1-sum(X)}));
          //    ThermodynamicState(p=p,T=T_phX(p,h,X), X=cat(1,X,{1-sum(X)}));
          annotation (Documentation(info="<html>
Function to set the state for given pressure, enthalpy and species concentration.
This function needed to be reimplemented in order for the medium model to use
the implementation of <code>T_phX</code> provided by this package as opposed to the 
implementation provided by its parent package.
</html>"));
        end setState_phX;

        redeclare function setState_dTX
        "Thermodynamic state as function of d, T and composition X"
           extends Buildings.Media.PerfectGases.MoistAir.setState_dTX;
        end setState_dTX;

        redeclare function gasConstant
        "Gas constant (computation neglects liquid fraction)"
           extends Buildings.Media.PerfectGases.MoistAir.gasConstant;
        end gasConstant;

      function saturationPressureLiquid
        "Return saturation pressure of water as a function of temperature T in the range of 273.16 to 373.16 K"

        extends Modelica.Icons.Function;
        input SI.Temperature Tsat "saturation temperature";
        output SI.AbsolutePressure psat "saturation pressure";
      algorithm
        psat := 611.657*Modelica.Math.exp(17.2799 - 4102.99/(Tsat - 35.719));
        annotation(Inline=false,smoothOrder=5,derivative=Buildings.Media.GasesPTDecoupled.MoistAirUnsaturated.saturationPressureLiquid_der,
          Documentation(info="<html>
Saturation pressure of water above the triple point temperature is computed from temperature. It's range of validity is between
273.16 and 373.16 K. Outside these limits a less accurate result is returned.
</html>"));
      end saturationPressureLiquid;

      function saturationPressureLiquid_der
        "Time derivative of saturationPressureLiquid"

        extends Modelica.Icons.Function;
        input SI.Temperature Tsat "Saturation temperature";
        input Real dTsat(unit="K/s") "Saturation temperature derivative";
        output Real psat_der(unit="Pa/s") "Saturation pressure";
      algorithm
        psat_der:=611.657*Modelica.Math.exp(17.2799 - 4102.99/(Tsat - 35.719))*4102.99*dTsat/(Tsat - 35.719)/(Tsat - 35.719);

        annotation(Inline=false,smoothOrder=5,
          Documentation(info="<html>
Derivative function of <a href=Modelica:Modelica.Media.Air.MoistAir.saturationPressureLiquid>saturationPressureLiquid</a>
</html>"));
      end saturationPressureLiquid_der;

        function sublimationPressureIce =
            Buildings.Media.PerfectGases.MoistAir.sublimationPressureIce
        "Saturation curve valid for 223.16 <= T <= 273.16. Outside of these limits a (less accurate) result is returned";

      redeclare function extends saturationPressure
        "Saturation curve valid for 223.16 <= T <= 373.16 (and slightly outside with less accuracy)"

      algorithm
        psat := Buildings.Utilities.Math.Functions.spliceFunction(
                                                        saturationPressureLiquid(Tsat),sublimationPressureIce(Tsat),Tsat-273.16,1.0);
        annotation(Inline=false,smoothOrder=5);
      end saturationPressure;

       redeclare function pressure "Gas pressure"
          extends Buildings.Media.PerfectGases.MoistAir.pressure;
       end pressure;

       redeclare function temperature "Gas temperature"
          extends Buildings.Media.PerfectGases.MoistAir.temperature;
       end temperature;

       redeclare function density "Gas density"
         extends Modelica.Icons.Function;
         input ThermodynamicState state;
         output Density d "Density";
       algorithm
        d :=state.p*dStp/pStp;
       end density;

       redeclare function specificEntropy
        "Specific entropy (liquid part neglected, mixing entropy included)"
          extends Buildings.Media.PerfectGases.MoistAir.specificEntropy;
       end specificEntropy;

       redeclare function extends enthalpyOfVaporization
        "Enthalpy of vaporization of water"
       algorithm
        r0 := 2501014.5;
       end enthalpyOfVaporization;

      redeclare replaceable function extends enthalpyOfLiquid
        "Enthalpy of liquid (per unit mass of liquid) which is linear in the temperature"

      algorithm
        h := (T - 273.15)*4186;
        annotation(smoothOrder=5, derivative=der_enthalpyOfLiquid);
      end enthalpyOfLiquid;

      replaceable function der_enthalpyOfLiquid
        "Temperature derivative of enthalpy of liquid per unit mass of liquid"
        extends Modelica.Icons.Function;
        input Temperature T "temperature";
        input Real der_T "temperature derivative";
        output Real der_h "derivative of liquid enthalpy";
      algorithm
        der_h := 4186*der_T;
      end der_enthalpyOfLiquid;

      redeclare function enthalpyOfCondensingGas
        "Enthalpy of steam per unit mass of steam"
        extends Modelica.Icons.Function;

        input Temperature T "temperature";
        output SpecificEnthalpy h "steam enthalpy";
      algorithm
        h := (T-273.15) * steam.cp + Buildings.Media.GasesPTDecoupled.MoistAirUnsaturated.enthalpyOfVaporization(T);
        annotation(smoothOrder=5, derivative=der_enthalpyOfCondensingGas);
      end enthalpyOfCondensingGas;

      replaceable function der_enthalpyOfCondensingGas
        "Derivative of enthalpy of steam per unit mass of steam"
        extends Modelica.Icons.Function;
        input Temperature T "temperature";
        input Real der_T(unit="K/s") "temperature derivative";
        output Real der_h(unit="J/(kg.s)") "derivative of steam enthalpy";
      algorithm
        der_h := steam.cp*der_T;
      end der_enthalpyOfCondensingGas;

      redeclare replaceable function extends enthalpyOfGas
        "Enthalpy of gas mixture per unit mass of gas mixture"
      algorithm
        h := Buildings.Media.GasesPTDecoupled.MoistAirUnsaturated.enthalpyOfCondensingGas(T)*X[Water]
             + Buildings.Media.GasesPTDecoupled.MoistAirUnsaturated.enthalpyOfDryAir(T)*(1.0-X[Water]);
      end enthalpyOfGas;

      replaceable function enthalpyOfDryAir
        "Enthalpy of dry air per unit mass of dry air"
        extends Modelica.Icons.Function;

        input Temperature T "temperature";
        output SpecificEnthalpy h "dry air enthalpy";
      algorithm
        h := (T - 273.15)*dryair.cp;
        annotation(smoothOrder=5, derivative=der_enthalpyOfDryAir);
      end enthalpyOfDryAir;

      replaceable function der_enthalpyOfDryAir
        "Derivative of enthalpy of dry air per unit mass of dry air"
        extends Modelica.Icons.Function;
        input Temperature T "temperature";
        input Real der_T(unit="K/s") "temperature derivative";
        output Real der_h(unit="J/(kg.s)") "derivative of dry air enthalpy";
      algorithm
        der_h := dryair.cp*der_T;
      end der_enthalpyOfDryAir;

      redeclare replaceable function extends specificHeatCapacityCp
        "Specific heat capacity of gas mixture at constant pressure"
      algorithm
        cp := dryair.cp*(1-state.X[Water]) +steam.cp*state.X[Water];
          annotation(derivative=der_specificHeatCapacityCp);
      end specificHeatCapacityCp;

      replaceable function der_specificHeatCapacityCp
        "Derivative of specific heat capacity of gas mixture at constant pressure"
          input ThermodynamicState state;
          input ThermodynamicState der_state;
          output Real der_cp(unit="J/(kg.K.s)");
      algorithm
        der_cp := (steam.cp-dryair.cp)*der_state.X[Water];
      end der_specificHeatCapacityCp;

      redeclare replaceable function extends specificHeatCapacityCv
        "Specific heat capacity of gas mixture at constant volume"
      algorithm
        cv:= dryair.cv*(1-state.X[Water]) +steam.cv*state.X[Water];
          annotation(derivative=der_specificHeatCapacityCv);
      end specificHeatCapacityCv;

      replaceable function der_specificHeatCapacityCv
        "Derivative of specific heat capacity of gas mixture at constant volume"
          input ThermodynamicState state;
          input ThermodynamicState der_state;
          output Real der_cv(unit="J/(kg.K.s)");
      algorithm
        der_cv := (steam.cv-dryair.cv)*der_state.X[Water];
      end der_specificHeatCapacityCv;

      redeclare function extends dynamicViscosity
        "dynamic viscosity of dry air"
      algorithm
        eta := 1.85E-5;
      end dynamicViscosity;

      redeclare function extends thermalConductivity
        "Thermal conductivity of dry air as a polynomial in the temperature"
        import Modelica.Media.Incompressible.TableBased.Polynomials_Temp;
      algorithm
        lambda := Polynomials_Temp.evaluate({(-4.8737307422969E-008), 7.67803133753502E-005, 0.0241814385504202},
         Modelica.SIunits.Conversions.to_degC(state.T));
      end thermalConductivity;

      redeclare function extends specificEnthalpy "Specific enthalpy"
      algorithm
        h := Buildings.Media.GasesPTDecoupled.MoistAirUnsaturated.h_pTX(state.p, state.T, state.X);
      end specificEnthalpy;

      redeclare function extends specificInternalEnergy
        "Specific internal energy"
        extends Modelica.Icons.Function;
      algorithm
        u := Buildings.Media.GasesPTDecoupled.MoistAirUnsaturated.h_pTX(state.p,state.T,state.X) - pStp/dStp;
      end specificInternalEnergy;

      redeclare function extends specificGibbsEnergy "Specific Gibbs energy"
        extends Modelica.Icons.Function;
      algorithm
        g := Buildings.Media.GasesPTDecoupled.MoistAirUnsaturated.h_pTX(state.p,state.T,state.X) - state.T*specificEntropy(state);
      end specificGibbsEnergy;

      redeclare function extends specificHelmholtzEnergy
        "Specific Helmholtz energy"
        extends Modelica.Icons.Function;
      algorithm
        f := Buildings.Media.GasesPTDecoupled.MoistAirUnsaturated.h_pTX(state.p,state.T,state.X)
               - gasConstant(state)*state.T
               - state.T*Buildings.Media.GasesPTDecoupled.MoistAirUnsaturated.specificEntropy(state);
      end specificHelmholtzEnergy;

      function h_pTX
        "Compute specific enthalpy from pressure, temperature and mass fraction"
        extends Modelica.Icons.Function;

        input SI.Pressure p "Pressure";
        input SI.Temperature T "Temperature";
        input SI.MassFraction X[nX] "Mass fractions of moist air";
        output SI.SpecificEnthalpy h "Specific enthalpy at p, T, X";
      protected
        SI.AbsolutePressure p_steam_sat "Partial saturation pressure of steam";
        SI.MassFraction x_sat
          "steam water mass fraction of saturation boundary";
        SI.SpecificEnthalpy hDryAir "Enthalpy of dry air";
      algorithm
        p_steam_sat :=saturationPressure(T);
        x_sat    :=k_mair*p_steam_sat/(p - p_steam_sat);
      /*
  assert(X[Water]-0.001 < x_sat/(1 + x_sat), "The medium model '" + mediumName + "' must not be saturated.\n"
     + "To model a saturated medium, use 'Buildings.Media.GasesPTDecoupled.MoistAir' instead of this medium.\n"
     + " T         = " + String(T) + "\n"
     + " x_sat     = " + String(x_sat) + "\n"
     + " X[Water] = "  + String(X[Water]) + "\n"
     + " phi       = " + String(X[Water]/((x_sat)/(1+x_sat))) + "\n"
     + " p         = " + String(p));
     */
        h := (T - 273.15)*dryair.cp * (1 - X[Water]) + ((T-273.15) * steam.cp + 2501014.5) * X[Water];
        annotation(smoothOrder=5);
      end h_pTX;

      function T_phX
        "Compute temperature from specific enthalpy and mass fraction"
        extends Modelica.Icons.Function;

        input AbsolutePressure p "Pressure";
        input SpecificEnthalpy h "specific enthalpy";
        input MassFraction[:] X "mass fractions of composition";
        output Temperature T "temperature";
      protected
        SI.AbsolutePressure p_steam_sat "Partial saturation pressure of steam";
        SI.MassFraction x_sat
          "steam water mass fraction of saturation boundary";
      algorithm
        T := 273.15 + (h-2501014.5 * X[Water])/(dryair.cp * (1 - X[Water])+steam.cp*X[Water]);
        // Check for saturation
        p_steam_sat :=saturationPressure(T);
        x_sat    :=k_mair*p_steam_sat/(p - p_steam_sat);
      /*  
  assert(X[Water]-0.001 < x_sat/(1 + x_sat), "The medium model '" + mediumName + "' must not be saturated.\n"
     + "To model a saturated medium, use 'Buildings.Media.GasesPTDecoupled.MoistAir' instead of this medium.\n"
     + " T         = " + String(T) + "\n"
     + " x_sat     = " + String(x_sat) + "\n"
     + " X[Water] = " + String(X[Water]) + "\n"
     + " phi       = " + String(X[Water]/((x_sat)/(1+x_sat))) + "\n"
     + " p         = " + String(p));
*/
        annotation(smoothOrder=5);
      end T_phX;

      redeclare function enthalpyOfNonCondensingGas
        "Enthalpy of non-condensing gas per unit mass"
        extends Modelica.Icons.Function;

        input Temperature T "temperature";
        output SpecificEnthalpy h "enthalpy";
      algorithm
        h := enthalpyOfDryAir(T);
        annotation(smoothOrder=5, derivative=der_enthalpyOfNonCondensingGas);
      end enthalpyOfNonCondensingGas;

      replaceable function der_enthalpyOfNonCondensingGas
        "Derivative of enthalpy of non-condensing gas per unit mass"
        extends Modelica.Icons.Function;
        input Temperature T "temperature";
        input Real der_T "temperature derivative";
        output Real der_h "derivative of steam enthalpy";
      algorithm
        der_h := der_enthalpyOfDryAir(T, der_T);
      end der_enthalpyOfNonCondensingGas;
        annotation (preferedView="info", Documentation(info="<html>
<p>
This is a medium model that is identical to 
<a href=\"modelica://Buildings.Media.GasesPTDecoupled.MoistAir\">
Buildings.Media.GasesPTDecoupled.MoistAir</a>,  but 
in this model, the air must not be saturated. If the air is saturated, 
use the medium model
<a href=\"modelica://Buildings.Media.GasesPTDecoupled.MoistAir\">
Buildings.Media.GasesPTDecoupled.MoistAir</a> instead of this one.
</p>
<p>
This medium model has been added to allow an explicit computation of
the function 
<code>T_phX</code> so that it is once differentiable in <code>h</code>
with a continuous derivative. This allows obtaining an analytic
expression for the Jacobian, and therefore simplifies the computation
of initial conditions that can be numerically challenging for 
thermo-fluid systems.
</p>
<p>
This new formulation often leads to smaller systems of nonlinear equations 
because it allows to invert the function <code>T_phX</code> analytically.
</p>
</html>",       revisions="<html>
<ul>
<li>
April 12, 2012, by Michael Wetter:<br>
Added keyword <code>each</code> to <code>Xi(stateSelect=...</code>.
</li>
<li>
April 4, 2012, by Michael Wetter:<br>
Added redeclaration of <code>ThermodynamicState</code> to avoid a warning
during model check and translation.
</li>
<li>
August 3, 2011, by Michael Wetter:<br>
Fixed bug in <code>u=h-R*T</code>, which is only valid for ideal gases. 
For this medium, the function is <code>u=h-pStd/dStp</code>.
</li>
<li>
January 27, 2010, by Michael Wetter:<br>
Fixed bug in <code>else</code> branch of function <code>setState_phX</code>
that lead to a run-time error when the constructor of this function was called.
</li>
<li>
January 22, 2010, by Michael Wetter:<br>
Added implementation of function
<a href=\"modelica://Buildings.Media.GasesPTDecoupled.MoistAirUnsaturated.enthalpyOfNonCondensingGas\">
enthalpyOfNonCondensingGas</a> and its derivative.
<li>
January 13, 2010, by Michael Wetter:<br>
Fixed implementation of derivative functions.
</li>
<li>
August 28, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
      end MoistAirUnsaturated;
    annotation (preferedView="info", Documentation(info="<html>
<p>
Medium models in this package use the gas law
<i>d/d<sub>stp</sub> = p/p<sub>stp</sub></i> where 
<i>p<sub>std</sub></i> and <i>d<sub>stp</sub></i> are constants for a reference
temperature and density instead of the ideal gas law
<i>&rho; = p &frasl;(R T)</i>.
</p>
<p>
This new formulation often leads to smaller systems of nonlinear equations 
because pressure and temperature are decoupled, at the expense of accuracy.
</p>
<p>
Note that models in this package implement the equation for the internal energy as
<p align=\"center\" style=\"font-style:italic;\">
  u = h - p<sub>stp</sub> &frasl; &rho;<sub>stp</sub>,
</p>
where 
<i>u</i> is the internal energy per unit mass,
<i>h</i> is the enthalpy per unit mass,
<i>p<sub>stp</sub></i> is the static pressure and
<i>&rho;<sub>stp</sub></i> is the mass density at standard pressure and temperature.
The reason for this implementation is that in general,
<p align=\"center\" style=\"font-style:italic;\">
  h = u + p v,
</p>
from which follows that
<p align=\"center\" style=\"font-style:italic;\">
  u = h - p v = h - p &frasl; &rho; = h - p<sub>stp</sub> &frasl; &rho;<sub>std</sub>,
</p>
because <i>p &frasl; &rho; = p<sub>stp</sub> &frasl; &rho;<sub>stp</sub></i> in this medium model.
</p>
</html>",     revisions="<html>
<ul>
<li>
March 19, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
    end GasesPTDecoupled;

    package PerfectGases "Package with models for perfect gases"
      extends Modelica.Icons.MaterialPropertiesPackage;

      package MoistAir
        extends Modelica.Media.Interfaces.PartialCondensingGases(
           mediumName="Moist air perfect gas",
           substanceNames={"water", "air"},
           final reducedX=true,
           final singleState=false,
           reference_X={0.01,0.99},
           fluidConstants = {Modelica.Media.IdealGases.Common.FluidData.H2O,
                             Modelica.Media.IdealGases.Common.FluidData.N2});

        constant Integer Water=1
        "Index of water (in substanceNames, massFractions X, etc.)";

        constant Integer Air=2
        "Index of air (in substanceNames, massFractions X, etc.)";

        constant Real k_mair =  steam.MM/dryair.MM "Ratio of molar weights";

        constant Buildings.Media.PerfectGases.Common.DataRecord dryair=
              Buildings.Media.PerfectGases.Common.SingleGasData.Air;

        constant Buildings.Media.PerfectGases.Common.DataRecord steam=
              Buildings.Media.PerfectGases.Common.SingleGasData.H2O;
        import SI = Modelica.SIunits;

        constant Modelica.SIunits.Temperature TMin = 200 "Minimum temperature";

        constant Modelica.SIunits.Temperature TMax = 400 "Maximum temperature";

        redeclare record extends ThermodynamicState
        "ThermodynamicState record for moist air"
        end ThermodynamicState;

        redeclare replaceable model extends BaseProperties(
          T(stateSelect=if preferredMediumStates then StateSelect.prefer else StateSelect.default),
          p(stateSelect=if preferredMediumStates then StateSelect.prefer else StateSelect.default),
          Xi(each stateSelect=if preferredMediumStates then StateSelect.prefer else StateSelect.default))

          /* p, T, X = X[Water] are used as preferred states, since only then all
     other quantities can be computed in a recursive sequence. 
     If other variables are selected as states, static state selection
     is no longer possible and non-linear algebraic equations occur.
      */
          MassFraction x_water "Mass of total water/mass of dry air";
          Real phi "Relative humidity";

      protected
          constant SI.MolarMass[2] MMX = {steam.MM,dryair.MM}
          "Molar masses of components";

          MassFraction X_liquid "Mass fraction of liquid water";
          MassFraction X_steam "Mass fraction of steam water";
          MassFraction X_air "Mass fraction of air";
          MassFraction X_sat
          "Steam water mass fraction of saturation boundary in kg_water/kg_moistair";
          MassFraction x_sat
          "Steam water mass content of saturation boundary in kg_water/kg_dryair";
          AbsolutePressure p_steam_sat "Partial saturation pressure of steam";

        equation
          assert(T >= TMin and T <= TMax, "
Temperature T is not in the allowed range "       + String(TMin) + " <= (T ="
                     + String(T) + " K) <= " + String(TMax) + " K
required from medium model \""           + mediumName + "\".");
          MM = 1/(Xi[Water]/MMX[Water]+(1.0-Xi[Water])/MMX[Air]);

          p_steam_sat = min(saturationPressure(T),0.999*p);
          X_sat = min(p_steam_sat * k_mair/max(100*Modelica.Constants.eps, p - p_steam_sat)*(1 - Xi[Water]), 1.0)
          "Water content at saturation with respect to actual water content";
          X_liquid = max(Xi[Water] - X_sat, 0.0);
          X_steam  = Xi[Water]-X_liquid;
          X_air    = 1-Xi[Water];

          h = specificEnthalpy_pTX(p,T,Xi);
          R = dryair.R*(1 - X_steam/(1 - X_liquid)) + steam.R*X_steam/(1 - X_liquid);
          //
          u = h - R*T;
          d = p/(R*T);
          /* Note, u and d are computed under the assumption that the volume of the liquid
         water is neglible with respect to the volume of air and of steam
      */
          state.p = p;
          state.T = T;
          state.X = X;

          // this x_steam is water load / dry air!!!!!!!!!!!
          x_sat    = k_mair*p_steam_sat/max(100*Modelica.Constants.eps,p - p_steam_sat);
          x_water = Xi[Water]/max(X_air,100*Modelica.Constants.eps);
          phi = p/p_steam_sat*Xi[Water]/(Xi[Water] + k_mair*X_air);
        end BaseProperties;

        redeclare function setState_pTX
        "Thermodynamic state as function of p, T and composition X"
            extends Modelica.Media.Air.MoistAir.setState_pTX;
        end setState_pTX;

        redeclare function setState_phX
        "Thermodynamic state as function of p, h and composition X"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input SpecificEnthalpy h "Specific enthalpy";
        input MassFraction X[:] "Mass fractions";
        output ThermodynamicState state;
        algorithm
        state := if size(X,1) == nX then
              ThermodynamicState(p=p,T=T_phX(p,h,X),X=X) else
              ThermodynamicState(p=p,T=T_phX(p,h,X), X=cat(1,X,{1-sum(X)}));
          annotation (Documentation(info="<html>
Function to set the state for given pressure, enthalpy and species concentration.
This function needed to be reimplemented in order for the medium model to use
the implementation of <code>T_phX</code> provided by this package as opposed to the 
implementation provided by its parent package.
</html>"));
        end setState_phX;

        redeclare function setState_dTX
        "Thermodynamic state as function of d, T and composition X"
           extends Modelica.Media.Air.MoistAir.setState_dTX;
        end setState_dTX;

        redeclare function gasConstant
        "Gas constant (computation neglects liquid fraction)"
           extends Modelica.Media.Air.MoistAir.gasConstant;
        end gasConstant;

      function saturationPressureLiquid
        "Return saturation pressure of water as a function of temperature T in the range of 273.16 to 373.16 K"

        extends Modelica.Icons.Function;
        input SI.Temperature Tsat "saturation temperature";
        output SI.AbsolutePressure psat "saturation pressure";
      algorithm
        psat := 611.657*Modelica.Math.exp(17.2799 - 4102.99/(Tsat - 35.719));
        annotation(Inline=false,smoothOrder=5,derivative=saturationPressureLiquid_der,
          Documentation(info="<html>
Saturation pressure of water above the triple point temperature is computed from temperature. It's range of validity is between
273.16 and 373.16 K. Outside these limits a less accurate result is returned.
</html>"));
      end saturationPressureLiquid;

      function saturationPressureLiquid_der
        "Time derivative of saturationPressureLiquid"

        extends Modelica.Icons.Function;
        input SI.Temperature Tsat "Saturation temperature";
        input Real dTsat(unit="K/s") "Saturation temperature derivative";
        output Real psat_der(unit="Pa/s") "Saturation pressure";
      algorithm
        psat_der:=611.657*Modelica.Math.exp(17.2799 - 4102.99/(Tsat - 35.719))*4102.99*dTsat/(Tsat - 35.719)/(Tsat - 35.719);

        annotation(Inline=false,smoothOrder=5,
          Documentation(info="<html>
Derivative function of <a href=Modelica:Modelica.Media.Air.MoistAir.saturationPressureLiquid>saturationPressureLiquid</a>
</html>"));
      end saturationPressureLiquid_der;

        function sublimationPressureIce =
            Modelica.Media.Air.MoistAir.sublimationPressureIce
        "Saturation curve valid for 223.16 <= T <= 273.16. Outside of these limits a (less accurate) result is returned"
          annotation(Inline=false,smoothOrder=5,derivative=Modelica.Media.Air.MoistAir.sublimationPressureIce_der);

      redeclare function extends saturationPressure
        "Saturation curve valid for 223.16 <= T <= 373.16 (and slightly outside with less accuracy)"

      algorithm
        psat := Buildings.Utilities.Math.Functions.spliceFunction(
                                                        saturationPressureLiquid(Tsat),sublimationPressureIce(Tsat),Tsat-273.16,1.0);
        annotation(Inline=false,smoothOrder=5);
      end saturationPressure;

       redeclare function pressure "Gas pressure"
          extends Modelica.Media.Air.MoistAir.pressure;
       end pressure;

       redeclare function temperature "Gas temperature"
          extends Modelica.Media.Air.MoistAir.temperature;
       end temperature;

       redeclare function density "Gas density"
          extends Modelica.Media.Air.MoistAir.density;
       end density;

       redeclare function specificEntropy
        "Specific entropy (liquid part neglected, mixing entropy included)"
          extends Modelica.Media.Air.MoistAir.specificEntropy;
       end specificEntropy;

       redeclare function extends enthalpyOfVaporization
        "Enthalpy of vaporization of water"
       algorithm
        r0 := 2501014.5;
       end enthalpyOfVaporization;

      redeclare replaceable function extends enthalpyOfLiquid
        "Enthalpy of liquid (per unit mass of liquid) which is linear in the temperature"

      algorithm
        h := (T - 273.15)*4186;
        annotation(smoothOrder=5, derivative=der_enthalpyOfLiquid);
      end enthalpyOfLiquid;

      replaceable function der_enthalpyOfLiquid
        "Temperature derivative of enthalpy of liquid per unit mass of liquid"
        extends Modelica.Icons.Function;
        input Temperature T "temperature";
        input Real der_T "temperature derivative";
        output Real der_h "derivative of liquid enthalpy";
      algorithm
        der_h := 4186*der_T;
      end der_enthalpyOfLiquid;

      redeclare function enthalpyOfCondensingGas
        "Enthalpy of steam per unit mass of steam"
        extends Modelica.Icons.Function;

        input Temperature T "temperature";
        output SpecificEnthalpy h "steam enthalpy";
      algorithm
        h := (T-273.15) * steam.cp + enthalpyOfVaporization(T);
        annotation(smoothOrder=5, derivative=der_enthalpyOfCondensingGas);
      end enthalpyOfCondensingGas;

      replaceable function der_enthalpyOfCondensingGas
        "Derivative of enthalpy of steam per unit mass of steam"
        extends Modelica.Icons.Function;
        input Temperature T "temperature";
        input Real der_T "temperature derivative";
        output Real der_h "derivative of steam enthalpy";
      algorithm
        der_h := steam.cp*der_T;
      end der_enthalpyOfCondensingGas;

      redeclare function enthalpyOfNonCondensingGas
        "Enthalpy of non-condensing gas per unit mass of steam"
        extends Modelica.Icons.Function;

        input Temperature T "temperature";
        output SpecificEnthalpy h "enthalpy";
      algorithm
        h := enthalpyOfDryAir(T);
        annotation(smoothOrder=5, derivative=der_enthalpyOfNonCondensingGas);
      end enthalpyOfNonCondensingGas;

      replaceable function der_enthalpyOfNonCondensingGas
        "Derivative of enthalpy of non-condensing gas per unit mass of steam"
        extends Modelica.Icons.Function;
        input Temperature T "temperature";
        input Real der_T "temperature derivative";
        output Real der_h "derivative of steam enthalpy";
      algorithm
        der_h := der_enthalpyOfDryAir(T, der_T);
      end der_enthalpyOfNonCondensingGas;

      redeclare replaceable function extends enthalpyOfGas
        "Enthalpy of gas mixture per unit mass of gas mixture"
      algorithm
        h := enthalpyOfCondensingGas(T)*X[Water]
             + enthalpyOfDryAir(T)*(1.0-X[Water]);
      end enthalpyOfGas;

      replaceable function enthalpyOfDryAir
        "Enthalpy of dry air per unit mass of dry air"
        extends Modelica.Icons.Function;

        input Temperature T "temperature";
        output SpecificEnthalpy h "dry air enthalpy";
      algorithm
        h := (T - 273.15)*dryair.cp;
        annotation(smoothOrder=5, derivative=der_enthalpyOfDryAir);
      end enthalpyOfDryAir;

      replaceable function der_enthalpyOfDryAir
        "Derivative of enthalpy of dry air per unit mass of dry air"
        extends Modelica.Icons.Function;
        input Temperature T "temperature";
        input Real der_T "temperature derivative";
        output Real der_h "derivative of dry air enthalpy";
      algorithm
        der_h := dryair.cp*der_T;
      end der_enthalpyOfDryAir;

      redeclare replaceable function extends specificHeatCapacityCp
        "Specific heat capacity of gas mixture at constant pressure"
      algorithm
        cp := dryair.cp*(1-state.X[Water]) +steam.cp*state.X[Water];
        annotation(smoothOrder=5);
      end specificHeatCapacityCp;

      redeclare replaceable function extends specificHeatCapacityCv
        "Specific heat capacity of gas mixture at constant volume"
      algorithm
        cv:= dryair.cv*(1-state.X[Water]) +steam.cv*state.X[Water];
        annotation(smoothOrder=5);
      end specificHeatCapacityCv;

      redeclare function extends dynamicViscosity
        "dynamic viscosity of dry air"
      algorithm
        eta := 1.85E-5;
      end dynamicViscosity;

      redeclare function extends thermalConductivity
        "Thermal conductivity of dry air as a polynomial in the temperature"
      algorithm
        lambda := Modelica.Media.Incompressible.TableBased.Polynomials_Temp.evaluate(
                     {(-4.8737307422969E-008), 7.67803133753502E-005, 0.0241814385504202},
                     Modelica.SIunits.Conversions.to_degC(state.T));
      end thermalConductivity;

      function h_pTX
        "Compute specific enthalpy from pressure, temperature and mass fraction"
        extends Modelica.Icons.Function;
        input SI.Pressure p "Pressure";
        input SI.Temperature T "Temperature";
        input SI.MassFraction X[:] "Mass fractions of moist air";
        output SI.SpecificEnthalpy h "Specific enthalpy at p, T, X";

      protected
        SI.AbsolutePressure p_steam_sat "Partial saturation pressure of steam";
        SI.MassFraction x_sat
          "steam water mass fraction of saturation boundary";
        SI.MassFraction X_liquid "mass fraction of liquid water";
        SI.MassFraction X_steam "mass fraction of steam water";
        SI.MassFraction X_air "mass fraction of air";
        SI.SpecificEnthalpy hDryAir "Enthalpy of dry air";
      algorithm
        p_steam_sat :=saturationPressure(T);
        x_sat    :=k_mair*p_steam_sat/(p - p_steam_sat);
        X_liquid :=max(X[Water] - x_sat/(1 + x_sat), 0.0);
        X_steam  :=X[Water] - X_liquid;
        X_air    :=1 - X[Water];

      /* THIS DOES NOT WORK --------------------------    
  h := enthalpyOfDryAir(T) * X_air + 
       Modelica.Media.Air.MoistAir.enthalpyOfCondensingGas(T) * X_steam + enthalpyOfLiquid(T)*X_liquid;
--------------------------------- */

      /* THIS WORKS!!!! +++++++++++++++++++++
  h := (T - 273.15)*dryair.cp * X_air + 
       Modelica.Media.Air.MoistAir.enthalpyOfCondensingGas(T) * X_steam + enthalpyOfLiquid(T)*X_liquid;
 +++++++++++++++++++++*/

        hDryAir := (T - 273.15)*dryair.cp;
        h := hDryAir * X_air +
             ((T-273.15) * steam.cp + 2501014.5) * X_steam +
             (T - 273.15)*4186*X_liquid;
        annotation(Inline=false,smoothOrder=1);
      end h_pTX;

      redeclare function extends specificEnthalpy "Specific enthalpy"
      algorithm
        h := h_pTX(state.p, state.T, state.X);
      end specificEnthalpy;

      redeclare function extends specificInternalEnergy
        "Specific internal energy"
        extends Modelica.Icons.Function;
      algorithm
        u := h_pTX(state.p,state.T,state.X) - gasConstant(state)*state.T;
      end specificInternalEnergy;

      redeclare function extends specificGibbsEnergy "Specific Gibbs energy"
        extends Modelica.Icons.Function;
      algorithm
        g := h_pTX(state.p,state.T,state.X) - state.T*specificEntropy(state);
      end specificGibbsEnergy;

      redeclare function extends specificHelmholtzEnergy
        "Specific Helmholtz energy"
        extends Modelica.Icons.Function;
      algorithm
        f := h_pTX(state.p,state.T,state.X) - gasConstant(state)*state.T - state.T*specificEntropy(state);
      end specificHelmholtzEnergy;

      function T_phX
        "Compute temperature from specific enthalpy and mass fraction"
        input AbsolutePressure p "Pressure";
        input SpecificEnthalpy h "Specific enthalpy";
        input MassFraction X[:] "Mass fractions of composition";
        output Temperature T "Temperature";

      protected
      package Internal
          "Solve h(data,T) for T with given h (use only indirectly via temperature_phX)"
        extends Modelica.Media.Common.OneNonLinearEquation;

        redeclare record extends f_nonlinear_Data
            "Data to be passed to non-linear function"
          extends Modelica.Media.IdealGases.Common.DataRecord;
        end f_nonlinear_Data;

        redeclare function extends f_nonlinear
        algorithm
            y := h_pTX(p,x,X);
        end f_nonlinear;

        // Dummy definition has to be added for current Dymola
        redeclare function extends solve
        end solve;
      end Internal;
      protected
      constant Modelica.Media.IdealGases.Common.DataRecord steam=
                    Modelica.Media.IdealGases.Common.SingleGasesData.H2O;
      protected
       SI.AbsolutePressure p_steam_sat "Partial saturation pressure of steam";
       SI.MassFraction x_sat "steam water mass fraction of saturation boundary";

      algorithm
        T := 273.15 + (h - 2501014.5 * X[Water])/((1 - X[Water])*dryair.cp + X[Water] *
           Buildings.Media.PerfectGases.Common.SingleGasData.H2O.cp);
        // check for saturation
        p_steam_sat :=saturationPressure(T);
        x_sat    :=k_mair*p_steam_sat/(p - p_steam_sat);
        // If the state is in the fog region, then the above equation is not valid, and
        // T is computed by inverting h_pTX(), which is much more costly.
        // For Buildings.Fluid.HeatExchangers.Examples.WetEffectivenessNTUPControl, the
        // computation above reduces the computing time by about a factor of 2.
        if (X[Water] > x_sat/(1 + x_sat)) then
           T := Internal.solve(h, TMin, TMax, p, X[1:nXi], steam);
        end if;
          annotation (Documentation(info="<html>
Temperature is computed from pressure, specific enthalpy and composition via numerical inversion of function <a href=Modelica:Modelica.Media.Air.MoistAir.h_pTX>h_pTX</a>.
</html>"));
      end T_phX;
        annotation (preferedView="info", Documentation(info="<html>
<p>
This is a medium model that is similar to 
<a href=\"Modelica:Modelica.Media.Air.MoistAir\">
Modelica.Media.Air.MoistAir</a> but it is a perfect gas, i.e., 
it has a constant specific heat capacity.
</p>
</html>",       revisions="<html>
<ul>
<li>
April 12, 2012, by Michael Wetter:<br>
Added keyword <code>each</code> to <code>Xi(stateSelect=...</code>.
</li>
<li>
April 4, 2012, by Michael Wetter:<br>
Added redeclaration of <code>ThermodynamicState</code> to avoid a warning
during model check and translation.
</li>
<li>
February 22, 2010, by Michael Wetter:<br>
Changed <code>T_phX</code> to first compute <code>T</code> 
in closed form assuming no saturation. Then, a check is done to determine
whether the state is in the fog region. If the state is in the fog region,
then <code>Internal.solve</code> is called. This new implementation
can lead to significantly shorter computing
time in models that frequently call <code>T_phX</code>.
</li>
<li>
January 27, 2010, by Michael Wetter:<br>
Fixed bug that lead to run-time error in <code>T_phX</code>.
</li>
<li>
January 13, 2010, by Michael Wetter:<br>
Added function <code>enthalpyOfNonCondensingGas</code> and its derivative.
</li>
<li>
January 13, 2010, by Michael Wetter:<br>
Fixed implementation of derivative functions.
</li>
<li>
October 12, 2009, by Michael Wetter:<br>
Added annotation for analytic derivative for functions
<code>saturationPressureLiquid</code> and <code>sublimationPressureIce</code>.
<li>
August 28, 2008, by Michael Wetter:<br>
Referenced <code>spliceFunction</code> from package 
<a href=\"modelica://Buildings.Utilities.Math\">Buildings.Utilities.Math</a>
to avoid duplicate code.
</li>
<li>
May 8, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
      end MoistAir;

      package Common "Package with common data for perfect gases"
        extends Modelica.Icons.MaterialPropertiesPackage;

        record DataRecord
        "Coefficient data record for properties of perfect gases"
          extends Modelica.Icons.Record;

          String name "Name of ideal gas";
          Modelica.SIunits.MolarMass MM "Molar mass";
          Modelica.SIunits.SpecificHeatCapacity R "Gas constant";
          Modelica.SIunits.SpecificHeatCapacity cp
          "Specific heat capacity at constant pressure";
          Modelica.SIunits.SpecificHeatCapacity cv = cp - R
          "Specific heat capacity at constant volume";
          annotation (
        defaultComponentName="gas",
        Documentation(preferedView="info", info="<html>
<p>
This data record contains the coefficients for perfect gases.
</p>
</html>"),         revisions=
                "<html>
<ul>
<li>
May 12, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>");
        end DataRecord;

        package SingleGasData "Package with data records for single gases"
          extends Modelica.Icons.MaterialPropertiesPackage;

         constant PerfectGases.Common.DataRecord Air(
           name = Modelica.Media.IdealGases.Common.SingleGasesData.Air.name,
           R =    Modelica.Media.IdealGases.Common.SingleGasesData.Air.R,
           MM =   Modelica.Media.IdealGases.Common.SingleGasesData.Air.MM,
           cp =   1006);

        constant PerfectGases.Common.DataRecord H2O(
           name = Modelica.Media.IdealGases.Common.SingleGasesData.H2O.name,
           R =    Modelica.Media.IdealGases.Common.SingleGasesData.H2O.R,
           MM =   Modelica.Media.IdealGases.Common.SingleGasesData.H2O.MM,
           cp =   1860);
          annotation (Documentation(preferedView="info", info="<html>
<p>
This package contains the coefficients for perfect gases.
</p>
</html>"),         revisions="<html>
<ul>
<li>
May 12, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>");
        end SingleGasData;
      annotation (preferedView="info", Documentation(info="<html>
<p>
This package contains records that are used to model perfect gases.
</p>
</html>"));
      end Common;
    annotation (preferedView="info", Documentation(info="<html>
<p>
This package contains models of <i>thermally perfect</i> gases.
</p>
<p>
A medium is called thermally perfect if
<ul>
<li>
it is in thermodynamic equilibrium,
</li><li>
it is chemically not reacting, and
</li><li>
internal energy and enthalpy are functions of temperature only.
</li>
</ul>
<p>
In addition, the gases in this package are <i>calorically perfect</i>, i.e., the
specific heat capacities at constant pressure <i>c<sub>p</sub></i>
and constant volume <i>c<sub>v</sub></i> are both constant (Bower 1998).
</p>
<p>
For dry and moist air media that also have a constant density, see
<a href=\"modelica://Buildings.Media.GasesConstantDensity\">
Buildings.Media.GasesConstantDensity</a>.
</p>
<h4>References</h4>
<p>
Bower, William B. <i>A primer in fluid mechanics: Dynamics of flows in one
space dimension</i>. CRC Press. 1998.
</p>
</html>"));
    end PerfectGases;
    annotation (preferedView="info", Documentation(info="<html>
This package contains different implementations for
various media.
The media models in this package are
compatible with 
<a href=\"Modelica:Modelica.Media\">
Modelica.Media</a> 
but the implementation is in general simpler, which often 
leads to easier numerical problems and better convergence of the
models.
Due to the simplifications, the media model of this package
are generally accurate for a smaller temperature range than the 
models in <a href=\"Modelica:Modelica.Media\">
Modelica.Media</a>, but the smaller temperature range may often be 
sufficient for building HVAC applications. 
</html>"));
  end Media;

  package Utilities "Package with utility functions such as for I/O"
    extends Modelica.Icons.Package;

    package IO "Package with I/O functions"
      extends Modelica.Icons.Package;

      package BCVTB
      "Package with functions to communicate with the Building Controls Virtual Test Bed"
        extends Modelica.Icons.VariantsPackage;

        model MoistAirInterface
        "Fluid interface that can be coupled to BCVTB for medium that model the air humidity"
          extends Buildings.Utilities.IO.BCVTB.BaseClasses.FluidInterface(bou(
                final use_X_in=true));

          Modelica.Blocks.Interfaces.RealOutput HLat_flow(unit="W")
          "Latent enthalpy flow rate, positive if flow into the component"
            annotation (Placement(transformation(extent={{100,50},{120,70}})));
          Buildings.Fluid.Sensors.SensibleEnthalpyFlowRate senEntFloRat[nPorts](
            redeclare final package Medium = Medium,
            each final m_flow_nominal=m_flow_nominal)
          "Sensible enthalpy flow rates"
            annotation (Placement(transformation(extent={{40,-10},{20,10}})));
          Modelica.Blocks.Math.Sum sumHSen_flow(nin=nPorts)
          "Sum of sensible enthalpy flow rates"
            annotation (Placement(transformation(extent={{20,30},{40,50}})));
          Modelica.Blocks.Math.Feedback diff
          "Difference between total and sensible enthalpy flow rate"
            annotation (Placement(transformation(extent={{70,50},{90,70}})));
          Modelica.Blocks.Interfaces.RealInput phi "Medium relative humidity"
            annotation (Placement(transformation(extent={{-140,-80},{-100,-40}},
                  rotation=0)));
          Buildings.Utilities.Psychrometrics.X_pTphi masFra(
                                                   use_p_in=false, redeclare
            package Medium =
                       Medium) "Mass fraction"
            annotation (Placement(transformation(extent={{-60,-64},{-40,-44}})));
        equation
          for i in 1:nPorts loop
          connect(senEntFloRat[i].port_a, ports[i]) annotation (Line(
              points={{40,6.10623e-16},{54.5,6.10623e-16},{54.5,-1.60982e-15},{69,
                    -1.60982e-15},{69,-2.22045e-15},{98,-2.22045e-15}},
              color={0,127,255},
              smooth=Smooth.None));
          connect(senEntFloRat[i].H_flow, sumHSen_flow.u[i]) annotation (Line(
              points={{30,11},{30,20},{6,20},{6,40},{18,40}},
              color={0,0,127},
              smooth=Smooth.None));
          end for;
          connect(senEntFloRat.port_b, totEntFloRat.port_a) annotation (Line(
              points={{20,6.10623e-16},{15,6.10623e-16},{15,1.22125e-15},{10,
                  1.22125e-15},{10,6.10623e-16},{5.55112e-16,6.10623e-16}},
              color={0,127,255},
              smooth=Smooth.None));
          connect(sumHSen_flow.y, HSen_flow) annotation (Line(
              points={{41,40},{60,40},{60,90},{110,90}},
              color={0,0,127},
              smooth=Smooth.None));
          connect(sumHTot_flow.y, diff.u1) annotation (Line(
              points={{21,80},{36,80},{36,60},{72,60}},
              color={0,0,127},
              smooth=Smooth.None));
          connect(diff.y, HLat_flow) annotation (Line(
              points={{89,60},{110,60}},
              color={0,0,127},
              smooth=Smooth.None));
          connect(diff.u2, sumHSen_flow.y) annotation (Line(
              points={{80,52},{80,40},{41,40}},
              color={0,0,127},
              smooth=Smooth.None));
          connect(masFra.T, T_in) annotation (Line(
              points={{-62,-54},{-84,-54},{-84,60},{-120,60}},
              color={0,0,127},
              smooth=Smooth.None));
          connect(masFra.phi, phi) annotation (Line(
              points={{-62,-60},{-120,-60}},
              color={0,0,127},
              smooth=Smooth.None));
          connect(masFra.X, bou.X_in) annotation (Line(
              points={{-39,-54},{-20,-54},{-20,-30},{-72,-30},{-72,-4},{-62,-4}},
              color={0,0,127},
              smooth=Smooth.None));
          annotation (Diagram(graphics), Icon(coordinateSystem(preserveAspectRatio=false,
                           extent={{-100,-100},{100,100}}), graphics={Text(
                  extent={{32,104},{102,78}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid,
                  textString="HSen"), Text(
                  extent={{30,72},{100,46}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid,
                  textString="HLat")}),
        defaultComponentName="airInt",
        Documentation(info="<html>
This model allows interfacing to the 
<a href=\"http://simulationresearch.lbl.gov/bcvtb\">Building Controls Virtual Test Bed</a>
an air-conditioning system
that uses a medium model with water vapor concentration.
</p>
<p>
The model takes as input signals the temperature and water vapor
concentration and, optionally, a bulk mass flow rate into or
out of the system boundary. The state of the fluid 
that flows out of this model will be at this temperature and
water vapor concentration. The output of this model are the sensible and
latent heat exchanged across the system boundary.
</p>
<p>
When used with the BCVTB, a building
simulation program such as EnergyPlus
may compute the room air temperatures and
room air humidity rate, which is then used as an input
to this model. The sensible and latent heat flow rates may be
sent to EnergyPlus to couple the air-conditioning system to 
the energy balance of the building model.
</p>
<p>
<b>Note:</b> The EnergyPlus building simulation program outputs the
absolute humidity ratio in units of [kg/kg dry air]. Since
<code>Modelica.Media</code> uses [kg/kg total mass of air], this quantity
needs to be converted. The conversion can be done with the model
<a href=\"modelica://Buildings.Utilities.Psychrometrics.ToTotalAir\">
Buildings.Utilities.Psychrometrics.ToTotalAir</a>.
</html>",         revisions="<html>
<ul>
<li>
April 5, 2011, by Michael Wetter:<br>
Added nominal values that are needed by the sensor.
</li>
<li>
September 10, 2009, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
        end MoistAirInterface;

        model BCVTB
        "Block that exchanges data with the Building Controls Virtual Test Bed"
          extends Modelica.Blocks.Interfaces.DiscreteBlock(final startTime=0,
          final samplePeriod = if activateInterface then timeStep else Modelica.Constants.inf);
          parameter Boolean activateInterface = true
          "Set to false to deactivate interface and use instead yFixed as output"
            annotation(Evaluate = true);
          parameter Modelica.SIunits.Time timeStep
          "Time step used for the synchronization"
            annotation(Dialog(enable = activateInterface));
          parameter String xmlFileName = "socket.cfg"
          "Name of the file that is generated by the BCVTB and that contains the socket information";
          parameter Integer nDblWri(min=0)
          "Number of double values to write to the BCVTB";
          parameter Integer nDblRea(min=0)
          "Number of double values to be read from the BCVTB";
          parameter Integer flaDblWri[nDblWri] = zeros(nDblWri)
          "Flag for double values (0: use current value, 1: use average over interval, 2: use integral over interval)";
          parameter Real uStart[nDblWri]
          "Initial input signal, used during first data transfer with BCVTB";
          parameter Real yRFixed[nDblRea] = zeros(nDblRea)
          "Fixed output, used if activateInterface=false"
            annotation(Evaluate = true,
                        Dialog(enable = not activateInterface));

          Modelica.Blocks.Interfaces.RealInput uR[nDblWri]
          "Real inputs to be sent to the BCVTB"
            annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
          Modelica.Blocks.Interfaces.RealOutput yR[nDblRea]
          "Real outputs received from the BCVTB"
            annotation (Placement(transformation(extent={{100,-10},{120,10}})));

         Integer flaRea "Flag received from BCVTB";
         Modelica.SIunits.Time simTimRea
          "Current simulation time received from the BCVTB";
         Integer retVal "Return value from the BSD socket data exchange";
      protected
          parameter Integer socketFD(fixed=false)
          "Socket file descripter, or a negative value if an error occured";
          parameter Real _uStart[nDblWri](fixed=false)
          "Initial input signal, used during first data transfer with BCVTB";
          constant Integer flaWri=0;
          Real uRInt[nDblWri] "Value of integral";
          Real uRIntPre[nDblWri]
          "Value of integral at previous sampling instance";
      public
          Real uRWri[nDblWri] "Value to be sent to the interface";
        initial algorithm
          socketFD :=if activateInterface then
              Buildings.Utilities.IO.BCVTB.BaseClasses.establishClientSocket(xmlFileName=xmlFileName) else
              0;
            // check for valid socketFD
             assert(socketFD >= 0, "Socket file descripter for BCVTB must be positive.\n" +
                                 "   A negative value indicates that no connection\n" +
                                 "   could be established. Check file 'utilSocket.log'.\n" +
                                 "   Received: socketFD = " + String(socketFD));
           flaRea   := 0;
           uRInt    := zeros(nDblWri);
           uRIntPre := zeros(nDblWri);
           for i in 1:nDblWri loop
             assert(flaDblWri[i]>=0 and flaDblWri[i]<=2,
                "Parameter flaDblWri out of range for " + String(i) + "-th component.");
             if (flaDblWri[i] == 0) then
                _uStart[i] := uStart[i];               // Current value.
             elseif (flaDblWri[i] == 1) then
                _uStart[i] := uStart[i];                // Average over interval
             else
                _uStart[i] := uStart[i]*samplePeriod;  // Integral over the sampling interval
                                                       // This is multiplied with samplePeriod because if
                                                       // u is power, then uRWri needs to be energy.

             end if;
           end for;
           // Exchange initial values
            if activateInterface then
              (flaRea, simTimRea, yR, retVal) :=
                Buildings.Utilities.IO.BCVTB.BaseClasses.exchangeReals(
                socketFD=socketFD,
                flaWri=flaWri,
                simTimWri=time,
                dblValWri=_uStart,
                nDblWri=size(uRWri, 1),
                nDblRea=size(yR, 1));
            else
              flaRea := 0;
              simTimRea := time;
              yR := yRFixed;
              retVal := 0;
              end if;

        equation
           for i in 1:nDblWri loop
              der(uRInt[i]) = if (flaDblWri[i] > 0) then uR[i] else 0;
           end for;
        algorithm
          when {sampleTrigger} then
            assert(flaRea == 0, "BCVTB interface attempts to exchange data after Ptolemy reached its final time.\n" +
                                "   Aborting simulation. Check final time in Modelica and in Ptolemy.\n" +
                                "   Received: flaRea = " + String(flaRea));
             // Compute value that will be sent to the BCVTB interface
             for i in 1:nDblWri loop
               if (flaDblWri[i] == 0) then
                 uRWri[i] :=pre(uR[i]);  // Send the current value.
                                         // Without the pre(), Dymola 7.2 crashes during translation of Examples.MoistAir
               else
                 uRWri[i] :=uRInt[i] - uRIntPre[i]; // Integral over the sampling interval
                 if (flaDblWri[i] == 1) then
                    uRWri[i] := uRWri[i]/samplePeriod;   // Average value over the sampling interval
                 end if;
               end if;
              end for;

            // Exchange data
            if activateInterface then
              (flaRea, simTimRea, yR, retVal) :=
                Buildings.Utilities.IO.BCVTB.BaseClasses.exchangeReals(
                socketFD=socketFD,
                flaWri=flaWri,
                simTimWri=time,
                dblValWri=uRWri,
                nDblWri=size(uRWri, 1),
                nDblRea=size(yR, 1));
            else
              flaRea := 0;
              simTimRea := time;
              yR := yRFixed;
              retVal := 0;
              end if;
            // Check for valid return flags
            assert(flaRea >= 0, "BCVTB sent a negative flag to Modelica during data transfer.\n" +
                                "   Aborting simulation. Check file 'utilSocket.log'.\n" +
                                "   Received: flaRea = " + String(flaRea));
            assert(retVal >= 0, "Obtained negative return value during data transfer with BCVTB.\n" +
                                "   Aborting simulation. Check file 'utilSocket.log'.\n" +
                                "   Received: retVal = " + String(retVal));

            // Store current value of integral
          uRIntPre:=uRInt;
          end when;
           // Close socket connnection
           when terminal() then
             if activateInterface then
                Buildings.Utilities.IO.BCVTB.BaseClasses.closeClientSocket(
                                                                  socketFD);
             end if;
           end when;

          annotation (defaultComponentName="cliBCVTB",
           Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
                    100}}),            graphics), Icon(coordinateSystem(
                  preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
                Rectangle(
                  visible=not activateInterface,
                  extent={{-100,-100},{100,100}},
                  lineColor={0,0,127},
                  fillColor={255,0,0},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  visible=activateInterface,
                  extent={{-100,-100},{100,100}},
                  lineColor={0,0,127},
                  fillColor={223,223,159},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{0,28},{80,-100}},
                  lineColor={0,0,0},
                  fillColor={95,95,95},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{10,14},{26,4}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{32,14},{48,4}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{54,14},{70,4}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{54,-2},{70,-12}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{32,-2},{48,-12}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{10,-2},{26,-12}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{54,-18},{70,-28}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{32,-18},{48,-28}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{10,-18},{26,-28}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{54,-34},{70,-44}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{32,-34},{48,-44}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{10,-34},{26,-44}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{54,-50},{70,-60}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{32,-50},{48,-60}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{10,-50},{26,-60}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{54,-66},{70,-76}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{32,-66},{48,-76}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{10,-66},{26,-76}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{54,-82},{70,-92}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{32,-82},{48,-92}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{10,-82},{26,-92}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Polygon(
                  points={{38,46},{-16,28},{92,28},{38,46}},
                  lineColor={0,0,0},
                  smooth=Smooth.None,
                  fillColor={0,0,0},
                  fillPattern=FillPattern.Solid),
                Text(
                  extent={{-82,108},{30,40}},
                  lineColor={0,0,0},
                  fillColor={95,95,95},
                  fillPattern=FillPattern.Solid,
                  textString="tS=%samplePeriod%")}),
            Documentation(info="<html>
Block that exchanges data with the 
<a href=\"http://simulationresearch.lbl.gov/bcvtb\">Building Controls Virtual Test Bed</a> (BCVTB).
<p>
At the start of the simulation, this block establishes a socket connection
using the Berkeley Software Distribution socket (BSD socket).
At each sampling interval, data are exchanged between Modelica
and the BCVTB.
When Dymola terminates, a signal is sent to the BCVTB
so that it can terminate gracefully.
</p>
<p>
For each element in the input vector <code>uR[nDblWri]</code>, 
the value of the flag <code>flaDblWri[nDblWri]</code> determines whether
the current value, the average over the sampling interval or the integral
over the sampling interval is sent to the BCVTB. The following three options are allowed:
<table border=\"1\">
<tr>
<td>
flaDblWri[i]
</td>
<td>
Value sent to the BCVTB
</td>
</tr>
<tr>
<td>
0
</td>
<td>
Current value of uR[i]
</td>
</tr>
<tr>
<td>
1
</td>
<td>
Average value of uR[i] over the sampling interval
</td>
</tr>
<tr>
<td>
2
</td>
<td>
Integral of uR[i] over the sampling interval
</td>
</tr>
</table>
</p>
<p>
For the first call to the BCVTB interface, the value of the parameter <code>uStart[nDblWri]</code>
will be used instead of <code>uR[nDblWri]</code>. This avoids an algebraic loop when determining
the initial conditions. If <code>uR[nDblWri]</code> were to be used, then computing the initial conditions
may require an iterative solution in which the function <code>exchangeWithSocket</code> may be called
multiple times.
Unfortunately, it does not seem possible to use a parameter that would give a user the option to either
select <code>uR[i]</code> or <code>uStart[i]</code> in the first data exchange. The reason is that the symbolic solver does not evaluate
the test that picks <code>uR[i]</code> or <code>uStart[i]</code>, and hence there would be an algebraic loop.
</p>
<p>
If the parameter <code>activateInterface</code> is set to false, then no data is exchanged with the BCVTB.
The output of this block is then equal to the value of the parameter <code>yRFixed[nDblRea]</code>.
This option can be helpful during debugging. Since during model translation, the functions are 
still linked to the C library, the header files and libraries need to be present in the current working 
directory even if <code>activateInterface=false</code>.
</p>
</html>",         revisions="<html>
<ul>
<li>
July 19, 2012, by Michael Wetter:<br>
Added a call to <code>Buildings.Utilities.IO.BCVTB.BaseClasses.exchangeReals</code>
in the <code>initial algorithm</code> section.
This is needed to propagate the initial condition to the server.
It also leads to one more data exchange, which is correct and avoids the
warning message in Ptolemy that says that the simulation reached its stop time
one time step prior to the final time.
</li>
<li>
January 19, 2010, by Michael Wetter:<br>
Introduced parameter to set initial value to be sent to the BCVTB.
In the prior implementation, if a variable was in an algebraic loop, then zero was
sent for this variable.
</li>
<li>
May 14, 2009, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
        end BCVTB;

        block To_degC "Converts Kelvin to Celsius"
          extends Modelica.Blocks.Interfaces.BlockIcon;

          Modelica.Blocks.Interfaces.RealInput Kelvin(final quantity="Temperature",
                                                      final unit = "K", displayUnit = "degC", min=0)
          "Temperature in Kelvin"
            annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
                iconTransformation(extent={{-140,-20},{-100,20}})));
          Modelica.Blocks.Interfaces.RealOutput Celsius(final quantity="Temperature",
                                                        final unit = "degC", displayUnit = "degC", min=-273.15)
          "Temperature in Celsius"
            annotation (Placement(transformation(extent={{100,-10},{120,10}}),
                iconTransformation(extent={{100,-10},{120,10}})));
        equation
          Kelvin = Modelica.SIunits.Conversions.from_degC(Celsius);
        annotation (
        defaultComponentName="toDegC",
        Documentation(info="<html>
<p>
Converts the input from degree Celsius to Kelvin.
Note that inside Modelica, it is strongly recommended to use
Kelvin. This block is provided for convenience since the BCVTB
interface may couple Modelica to programs that use Celsius 
as the unit for temperature.
</p>
</html>",
        revisions="<html>
<ul>
<li>
April 14, 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),         Icon(graphics={               Text(
                  extent={{-26,96},{-106,16}},
                  lineColor={0,0,0},
                  textString="K"),
                Polygon(
                  points={{84,-4},{24,16},{24,-24},{84,-4}},
                  lineColor={191,0,0},
                  fillColor={191,0,0},
                  fillPattern=FillPattern.Solid),
                                   Text(
                  extent={{94,-24},{14,-104}},
                  lineColor={0,0,0},
                  textString="degC"),
                Line(points={{-96,-4},{24,-4}},
                                              color={191,0,0})}),
            Diagram(graphics));
        end To_degC;

        block From_degC "Converts Celsius to Kelvin"
          extends Modelica.Blocks.Interfaces.BlockIcon;

          Modelica.Blocks.Interfaces.RealInput Celsius(final quantity="Temperature",
                                                       final unit = "degC", displayUnit = "degC", min=-273.15)
          "Temperature in Celsius"
            annotation (Placement(transformation(extent={{-140,-24},{-100,16}}),
                iconTransformation(extent={{-140,-24},{-100,16}})));
          Modelica.Blocks.Interfaces.RealOutput Kelvin(final quantity="Temperature",
                                                       final unit = "K", displayUnit = "degC", min=0)
          "Temperature in Kelvin"
            annotation (Placement(transformation(extent={{100,-12},{120,8}}),
                iconTransformation(extent={{100,-12},{120,8}})));
        equation
          Celsius = Modelica.SIunits.Conversions.to_degC(Kelvin);
        annotation (
        defaultComponentName="froDegC",
        Documentation(info="<html>
<p>
Converts the input from Kelvin to degree Celsius.
Note that inside Modelica, by convention, all models use
Kelvin. This block is provided for convenience since the BCVTB
interface may couple Modelica to programs that use Celsius 
as the unit for temperature.
</p>
</html>",
        revisions="<html>
<ul>
<li>
April 14, 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),         Icon(graphics={               Text(
                  extent={{94,-22},{14,-102}},
                  lineColor={0,0,0},
                  textString="K"),
                Polygon(
                  points={{84,-4},{24,16},{24,-24},{84,-4}},
                  lineColor={191,0,0},
                  fillColor={191,0,0},
                  fillPattern=FillPattern.Solid),
                                   Text(
                  extent={{-16,94},{-96,14}},
                  lineColor={0,0,0},
                  textString="degC"),
                Line(points={{-96,-4},{24,-4}},
                                              color={191,0,0})}));
        end From_degC;

        package Examples
        "Collection of models that illustrate model use and test models"
          extends Modelica.Icons.ExamplesPackage;

          model MoistAir
          "Model with interfaces for media with moist air that will be linked to the BCVTB which models the response of the room"
            import Buildings;
            extends Modelica.Icons.Example;
            package Medium =
              Buildings.Media.GasesPTDecoupled.MoistAirUnsaturated;
            parameter Modelica.Media.Interfaces.PartialMedium.MassFlowRate m_flow_nominal=
                259.2*6/1.2/3600 "Nominal mass flow rate";
            Buildings.Fluid.FixedResistances.FixedResistanceDpM dp1(
              redeclare package Medium = Medium,
              m_flow_nominal=m_flow_nominal,
              dp_nominal=200,
              from_dp=false,
              allowFlowReversal=false)
              annotation (Placement(transformation(extent={{280,62},{300,82}})));
            Buildings.Fluid.Sources.Boundary_pT sou(
              nPorts=2,
              redeclare package Medium = Medium,
              use_T_in=true,
              use_X_in=true,
              p(displayUnit="Pa") = 101325,
              T=293.15)             annotation (Placement(transformation(extent={{96,60},
                      {116,80}}, rotation=0)));
            inner Modelica.Fluid.System system
              annotation (Placement(transformation(extent={{-80,160},{-60,180}})));
            Buildings.Fluid.FixedResistances.FixedResistanceDpM dp2(
              redeclare package Medium = Medium,
              m_flow_nominal=m_flow_nominal,
              dp_nominal=200,
              from_dp=false,
              allowFlowReversal=false)
              annotation (Placement(transformation(extent={{10,10},{-10,-10}},
                  rotation=180,
                  origin={262,-50})));
            Buildings.Utilities.IO.BCVTB.MoistAirInterface bouBCVTB(
              nPorts=2,
              redeclare package Medium = Medium,
              m_flow=0,
              use_m_flow_in=false,
              m_flow_nominal=m_flow_nominal)
              annotation (Placement(transformation(extent={{204,-4},{224,16}})));
            Buildings.Fluid.MassExchangers.HumidifierPrescribed hum(
              m_flow_nominal=m_flow_nominal,
              dp_nominal=200,
              redeclare package Medium = Medium,
              mWat_flow_nominal=0.01*m_flow_nominal,
              from_dp=false,
              allowFlowReversal=false,
              use_T_in=false) "Humidifier"
              annotation (Placement(transformation(extent={{240,62},{260,82}})));
            Buildings.Fluid.HeatExchangers.HeaterCoolerPrescribed hex(
              m_flow_nominal=m_flow_nominal,
              dp_nominal=200,
              redeclare package Medium = Medium,
              Q_flow_nominal=m_flow_nominal*50*1006,
              from_dp=false,
              allowFlowReversal=false) "Heat exchanger"
              annotation (Placement(transformation(extent={{192,62},{212,82}})));
            Buildings.Fluid.Sensors.TemperatureTwoPort
                                                TRet(redeclare package Medium
              =                                                                 Medium,
                m_flow_nominal=m_flow_nominal) "Return air temperature"
              annotation (Placement(transformation(extent={{320,-60},{340,-40}})));
            Buildings.Fluid.Sensors.MassFractionTwoPort
                                                 Xi_w(redeclare package Medium
              =                                                                  Medium,
                m_flow_nominal=m_flow_nominal) "Measured air humidity"
              annotation (Placement(transformation(extent={{290,-60},{310,-40}})));
            Modelica.Blocks.Sources.Constant XSet(k=0.005)
            "Set point for humidity"
              annotation (Placement(transformation(extent={{180,150},{200,170}})));
            Modelica.Blocks.Sources.Constant TRooSetNig(k=273.15 + 16)
            "Set point for room air temperature"
              annotation (Placement(transformation(extent={{40,130},{60,150}})));
            Buildings.Controls.Continuous.LimPID PIDHea(
              yMax=1,
              yMin=0,
              Td=1,
              controllerType=Modelica.Blocks.Types.SimpleController.PI,
              k=0.1,
              Ti=600) "Controller for heating"
              annotation (Placement(transformation(extent={{140,150},{160,170}})));
            Buildings.Controls.Continuous.LimPID PIDHum(
              yMax=1,
              yMin=0,
              controllerType=Modelica.Blocks.Types.SimpleController.PI,
              k=20,
              Td=60,
              Ti=600) "Controller for humidifier"
              annotation (Placement(transformation(extent={{220,150},{240,170}})));
            Buildings.Utilities.IO.BCVTB.BCVTB bcvtb(
              xmlFileName="socket.cfg",
              nDblRea=4,
              nDblWri=5,
              flaDblWri={1,1,1,1,1},
              uStart={0,0,0,0,20},
              activateInterface=true,
              timeStep=60)
              annotation (Placement(transformation(extent={{-70,20},{-50,40}})));
            Modelica.Blocks.Routing.DeMultiplex4 deMultiplex2_1(
              n1=1,
              n2=1,
              n3=1,
              n4=1)
              annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
            Modelica.Blocks.Routing.Multiplex5 mul
              annotation (Placement(transformation(extent={{420,0},{440,20}})));
            Buildings.Fluid.Sensors.TemperatureTwoPort
                                                TSup(redeclare package Medium
              =                                                                 Medium,
                m_flow_nominal=m_flow_nominal) "Supply air temperature"
              annotation (Placement(transformation(extent={{310,62},{330,82}})));
            Buildings.Fluid.Movers.FlowMachine_y fan(redeclare package Medium
              =                                                                 Medium,
                  pressure(V_flow={0,m_flow_nominal/1.2},
                    dp={2*400,400}),
                  dynamicBalance=false)
              annotation (Placement(transformation(extent={{140,62},{160,82}})));
            Modelica.Blocks.Sources.Constant yFan(k=1) "Fan control signal"
              annotation (Placement(transformation(extent={{120,100},{140,120}})));
            Modelica.Blocks.Math.Gain perToRel(k=0.01)
            "Converts 0...100 to 0...1"
              annotation (Placement(transformation(extent={{22,-10},{42,10}})));
            Modelica.Blocks.Math.Gain perToRel1(
                                               k=0.01)
            "Converts 0...100 to 0...1"
              annotation (Placement(transformation(extent={{0,50},{20,70}})));
            Buildings.Utilities.Psychrometrics.X_pTphi masFra(
                                                     use_p_in=false, redeclare
              package Medium =
                         Medium) "Mass fraction"
              annotation (Placement(transformation(extent={{50,56},{70,76}})));
            Buildings.Controls.SetPoints.OccupancySchedule occSch
            "Occupancy schedule"
              annotation (Placement(transformation(extent={{0,156},{20,176}})));
            Modelica.Blocks.Logical.Switch switch1
              annotation (Placement(transformation(extent={{84,150},{104,170}})));
            Modelica.Blocks.Sources.Constant TRooSetDay(k=273.15 + 20)
            "Set point for room air temperature"
              annotation (Placement(transformation(extent={{40,170},{60,190}})));
            Buildings.Utilities.IO.BCVTB.From_degC from_degC
              annotation (Placement(transformation(extent={{20,18},{40,38}})));
            Buildings.Utilities.IO.BCVTB.To_degC to_degC
              annotation (Placement(transformation(extent={{360,58},{380,78}})));
            Buildings.Utilities.IO.BCVTB.From_degC from_degC1
              annotation (Placement(transformation(extent={{0,80},{20,100}})));
          equation
            connect(dp1.port_a, hum.port_b) annotation (Line(
                points={{280,72},{260,72}},
                color={0,127,255},
                smooth=Smooth.None));
            connect(hex.port_b, hum.port_a) annotation (Line(
                points={{212,72},{240,72}},
                color={0,127,255},
                smooth=Smooth.None));
            connect(TRet.T, PIDHea.u_m) annotation (Line(
                points={{330,-39},{330,-30},{348,-30},{348,120},{150,120},{150,148}},
                color={0,0,127},
                smooth=Smooth.None));
            connect(PIDHea.y, hex.u) annotation (Line(
                points={{161,160},{170,160},{170,78},{190,78}},
                color={0,0,127},
                smooth=Smooth.None));
            connect(XSet.y, PIDHum.u_s)  annotation (Line(
                points={{201,160},{218,160}},
                color={0,0,127},
                smooth=Smooth.None));
            connect(PIDHum.y, hum.u)  annotation (Line(
                points={{241,160},{260,160},{260,110},{226,110},{226,78},{238,78}},
                color={0,0,127},
                smooth=Smooth.None));
            connect(bcvtb.yR, deMultiplex2_1.u) annotation (Line(
                points={{-49,30},{-42,30}},
                color={0,127,0},
                smooth=Smooth.None,
                pattern=LinePattern.Dash));
            connect(mul.y, bcvtb.uR)          annotation (Line(
                points={{441,10},{450,10},{450,-80},{-72,-80},{-72,30}},
                color={0,127,0},
                smooth=Smooth.None,
                pattern=LinePattern.Dash));
            connect(PIDHum.y, mul.u4[1])          annotation (Line(
                points={{241,160},{400,160},{400,5},{418,5}},
                color={0,127,0},
                smooth=Smooth.None,
                pattern=LinePattern.Dash));
            connect(PIDHea.y, mul.u3[1])          annotation (Line(
                points={{161,160},{170,160},{170,130},{408,130},{408,10},{418,10}},
                color={0,127,0},
                smooth=Smooth.None,
                pattern=LinePattern.Dash));
            connect(mul.u1[1], bouBCVTB.HSen_flow)          annotation (Line(
                points={{418,20},{260,20},{260,15},{225,15}},
                color={0,127,0},
                smooth=Smooth.None,
                pattern=LinePattern.Dash));
            connect(bouBCVTB.HLat_flow, mul.u2[1])          annotation (Line(
                points={{225,12},{264,12},{264,15},{418,15}},
                color={0,127,0},
                smooth=Smooth.None,
                pattern=LinePattern.Dash));
            connect(Xi_w.X, PIDHum.u_m) annotation (Line(
                points={{300,-39},{300,-20},{340,-20},{340,140},{230,140},{230,148}},
                color={0,0,127},
                smooth=Smooth.None));
            connect(fan.port_b, hex.port_a) annotation (Line(
                points={{160,72},{192,72}},
                color={0,127,255},
                smooth=Smooth.None));
            connect(fan.port_a, sou.ports[1])  annotation (Line(
                points={{140,72},{116,72}},
                color={0,127,255},
                smooth=Smooth.None));
            connect(perToRel.y, bouBCVTB.phi) annotation (Line(
                points={{43,6.10623e-16},{82.75,6.10623e-16},{82.75,1.16573e-15},
                  {122.5,1.16573e-15},{122.5,0},{202,0}},
                color={0,127,0},
                smooth=Smooth.None,
                pattern=LinePattern.Dash));
            connect(deMultiplex2_1.y4[1], perToRel.u) annotation (Line(
                points={{-19,21},{-8,21},{-8,6.66134e-16},{20,6.66134e-16}},
                color={0,127,0},
                smooth=Smooth.None,
                pattern=LinePattern.Dash));
            connect(perToRel1.u, deMultiplex2_1.y3[1]) annotation (Line(
                points={{-2,60},{-6,60},{-6,27},{-19,27}},
                color={0,127,0},
                smooth=Smooth.None,
                pattern=LinePattern.Dash));
            connect(masFra.phi, perToRel1.y) annotation (Line(
                points={{48,60},{21,60}},
                color={0,127,0},
                smooth=Smooth.None,
                pattern=LinePattern.Dash));
            connect(masFra.X, sou.X_in)  annotation (Line(
                points={{71,66},{94,66}},
                color={0,127,0},
                smooth=Smooth.None,
                pattern=LinePattern.Dash));
            connect(yFan.y, fan.y) annotation (Line(
                points={{141,110},{150,110},{150,84}},
                color={0,0,127},
                smooth=Smooth.None));
            connect(occSch.occupied, switch1.u2) annotation (Line(
                points={{21,160},{82,160}},
                color={255,0,255},
                smooth=Smooth.None));
            connect(TRooSetNig.y, switch1.u3) annotation (Line(
                points={{61,140},{70,140},{70,152},{82,152}},
                color={0,0,127},
                smooth=Smooth.None));
            connect(TRooSetDay.y, switch1.u1) annotation (Line(
                points={{61,180},{72,180},{72,168},{82,168}},
                color={0,0,127},
                smooth=Smooth.None));
            connect(switch1.y, PIDHea.u_s) annotation (Line(
                points={{105,160},{138,160}},
                color={0,0,127},
                smooth=Smooth.None));
            connect(from_degC.Kelvin, bouBCVTB.T_in) annotation (Line(
                points={{41,27.8},{80,27.8},{80,12},{202,12}},
                color={0,0,127},
                smooth=Smooth.None));
            connect(TSup.T, to_degC.Kelvin) annotation (Line(
                points={{320,83},{320,90},{352,90},{352,68},{358,68}},
                color={0,127,0},
                smooth=Smooth.None,
                pattern=LinePattern.Dash));
            connect(to_degC.Celsius, mul.u5[1]) annotation (Line(
                points={{381,68},{392,68},{392,-6.66134e-16},{418,-6.66134e-16}},
                color={0,127,0},
                smooth=Smooth.None,
                pattern=LinePattern.Dash));
            connect(from_degC1.Kelvin, sou.T_in) annotation (Line(
                points={{21,89.8},{80,89.8},{80,74},{94,74}},
                color={0,0,127},
                smooth=Smooth.None));
            connect(from_degC1.Celsius, deMultiplex2_1.y1[1]) annotation (Line(
                points={{-2,89.6},{-10,89.6},{-10,39},{-19,39}},
                color={0,127,0},
                smooth=Smooth.None,
                pattern=LinePattern.Dash));
            connect(deMultiplex2_1.y2[1], from_degC.Celsius) annotation (Line(
                points={{-19,33},{0,33},{0,27.6},{18,27.6}},
                color={0,127,0},
                smooth=Smooth.None,
                pattern=LinePattern.Dash));
            connect(from_degC1.Kelvin, masFra.T) annotation (Line(
                points={{21,89.8},{40,89.8},{40,66},{48,66}},
                color={0,0,127},
                smooth=Smooth.None));
            connect(dp2.port_b, Xi_w.port_a) annotation (Line(
                points={{272,-50},{290,-50}},
                color={0,127,255},
                smooth=Smooth.None));
            connect(Xi_w.port_b, TRet.port_a) annotation (Line(
                points={{310,-50},{320,-50}},
                color={0,127,255},
                smooth=Smooth.None));
            connect(TRet.port_b, sou.ports[2]) annotation (Line(
                points={{340,-50},{350,-50},{350,-72},{128,-72},{128,68},{116,68}},
                color={0,127,255},
                smooth=Smooth.None));
            connect(dp1.port_b, TSup.port_a) annotation (Line(
                points={{300,72},{310,72}},
                color={0,127,255},
                smooth=Smooth.None));
            connect(TSup.port_b, bouBCVTB.ports[1]) annotation (Line(
                points={{330,72},{334,72},{334,8},{223.8,8}},
                color={0,127,255},
                smooth=Smooth.None));
            connect(dp2.port_a, bouBCVTB.ports[2]) annotation (Line(
                points={{252,-50},{240,-50},{240,4},{223.8,4}},
                color={0,127,255},
                smooth=Smooth.None));
            annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                      -100},{460,200}}), graphics),
              Documentation(info="<html>
This example illustrates the use of Modelica with the Building Controls Virtual Test Bed.
</p>
<p>
The model represents an air-based heating system with an ideal heater and an ideal humidifier
in the supply duct. The heater and humidifier are controlled with a feedback loop that 
tracks the room air temperature and room air humidity. These quantities are simulated
in the EnergyPlus simulation program through the Building Controls Virtual Test Bed.
The component <code>bouBCVTB</code> models the boundary between the domain that models the air
system (in Modelica) and the room response (in EnergyPlus).
</p>
<p>
This model is implemented in <code>bcvtb\\examples\\dymolaEPlusXY-singleZone</code>,
where <code>XY</code> denotes the EnergyPlus version number.
</html>",           revisions="<html>
<ul>
<li>
January 13, 2012, by Michael Wetter:<br>
Updated fan parameters, which were still for version 0.12 of the 
Buildings library and hence caused a translation error with version 1.0 or higher.
</li>
<li>
April 5, 2011, by Michael Wetter:<br>
Changed sensor models from one-port sensors to two port sensors.
</li>
<li>
January 21, 2010 by Michael Wetter:<br>
Changed model to include fan instead of having flow driven by two reservoirs at 
different pressure.
</li>
<li>
September 11, 2009, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),    experiment(
                Tolerance=1e-05,
                Algorithm="Lsodar"),
              experimentSetupOutput);
          end MoistAir;
        annotation (preferedView="info", Documentation(info="<html>
<p>
This package contains examples for the use of models that can be found in
<a href=\"modelica://Buildings.Utilities.IO.BCVTB\">
Buildings.Utilities.IO.BCVTB</a>.
</p>
</html>"));
        end Examples;

        package BaseClasses
        "Package with base classes for Buildings.Utilities.IO.BCVTB"
          extends Modelica.Icons.BasesPackage;

          partial model FluidInterface
          "Partial class for fluid interface that can be coupled to BCVTB"
            import Buildings;
            extends Buildings.BaseClasses.BaseIcon;

            replaceable package Medium =
                Modelica.Media.Interfaces.PartialMedium
            "Medium model within the source"
               annotation (choicesAllMatching=true);

            parameter Integer nPorts=0 "Number of ports" annotation(Dialog(connectorSizing=true));
            Modelica.Blocks.Interfaces.RealInput m_flow_in if     use_m_flow_in
            "Prescribed mass flow rate"
              annotation (Placement(transformation(extent={{-120,60},{-80,100}},
                    rotation=0), iconTransformation(extent={{-120,60},{-80,100}})));
            Modelica.Blocks.Interfaces.RealInput T_in
            "Prescribed boundary temperature"
              annotation (Placement(transformation(extent={{-140,40},{-100,80}},
                    rotation=0)));

             parameter Boolean use_m_flow_in = false
            "Get the mass flow rate from the input connector"
              annotation(Evaluate=true, HideResult=true);
            parameter Medium.MassFlowRate m_flow = 0
            "Fixed mass flow rate going out of the fluid port"
              annotation (Evaluate = true,
                          Dialog(enable = not use_m_flow_in));

            parameter Medium.MassFlowRate m_flow_nominal(min=0)
            "Nominal mass flow rate, used for regularization near zero flow"
              annotation(Dialog(group = "Nominal condition"));
            parameter Medium.MassFlowRate m_flow_small(min=0) = 1E-4*m_flow_nominal
            "For bi-directional flow, temperature is regularized in the region |m_flow| < m_flow_small (m_flow_small > 0 required)"
              annotation(Dialog(group="Advanced"));

            Buildings.Fluid.Sensors.EnthalpyFlowRate totEntFloRat[nPorts](
              redeclare final package Medium = Medium,
              each final m_flow_nominal=m_flow_nominal)
            "Total enthalpy flow rate (sensible plus latent)"
              annotation (Placement(transformation(extent={{0,-10},{-20,10}})));
            Modelica.Fluid.Interfaces.FluidPorts_b ports[
                                          nPorts](
                               redeclare each package Medium = Medium,
                               m_flow(each max=if flowDirection==Modelica.Fluid.Types.PortFlowDirection.Leaving then 0 else
                                               +Modelica.Constants.inf,
                                      each min=if flowDirection==Modelica.Fluid.Types.PortFlowDirection.Entering then 0 else
                                               -Modelica.Constants.inf))
              annotation (Placement(transformation(extent={{88,40},{108,-40}})));

            Modelica.Blocks.Math.Sum sumHTot_flow(nin=nPorts)
            "Sum of total enthalpy flow rates"
              annotation (Placement(transformation(extent={{0,70},{20,90}})));
            Modelica.Blocks.Interfaces.RealOutput HSen_flow(unit="W")
            "Sensible enthalpy flow rate, positive if flow into the component"
              annotation (Placement(transformation(extent={{100,80},{120,100}})));
            Buildings.Fluid.Sources.MassFlowSource_T bou(
              redeclare package Medium = Medium,
              final use_T_in=true,
              final nPorts=nPorts,
              use_X_in=false,
              use_C_in=false,
              final use_m_flow_in=true)
              annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
        protected
            parameter Modelica.Fluid.Types.PortFlowDirection flowDirection=
                             Modelica.Fluid.Types.PortFlowDirection.Bidirectional
            "Allowed flow direction"                 annotation(Evaluate=true, Dialog(tab="Advanced"));
          equation
            connect(m_flow_in, bou.m_flow_in);
            if not use_m_flow_in then
              bou.m_flow_in = m_flow;
            end if;

            connect(totEntFloRat.port_b, bou.ports) annotation (Line(
                points={{-20,0},{-40,0}},
                color={0,127,255},
                smooth=Smooth.None));
            connect(sumHTot_flow.u, totEntFloRat.H_flow)
                                                   annotation (Line(
                points={{-2,80},{-10,80},{-10,11}},
                color={0,0,127},
                smooth=Smooth.None));
            connect(bou.T_in, T_in) annotation (Line(
                points={{-62,4},{-80,4},{-80,60},{-120,60}},
                color={0,0,127},
                smooth=Smooth.None));
            annotation (defaultComponentName="bouBCVTB",
                        Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                      -100},{100,100}}), graphics),
              Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
                      100}}), graphics={
                  Line(points={{-100,40},{-92,40}}, color={0,0,255}),
                  Line(points={{-100,-40},{-92,-40}}, color={0,0,255}),
                  Text(
                    extent={{-168,50},{-66,10}},
                    lineColor={0,0,0},
                    fillColor={255,255,255},
                    fillPattern=FillPattern.Solid,
                    textString="T"),
                  Rectangle(
                    extent={{35,45},{100,-45}},
                    lineColor={0,0,0},
                    fillPattern=FillPattern.HorizontalCylinder,
                    fillColor={0,127,255}),
                  Ellipse(
                    extent={{-100,80},{60,-80}},
                    lineColor={0,0,255},
                    fillColor={255,255,255},
                    fillPattern=FillPattern.Solid),
                  Polygon(
                    points={{-60,70},{60,0},{-60,-68},{-60,70}},
                    lineColor={0,0,127},
                    fillColor={0,0,127},
                    fillPattern=FillPattern.Solid),
                  Text(
                    extent={{-54,32},{16,-30}},
                    lineColor={255,0,0},
                    fillColor={255,0,0},
                    fillPattern=FillPattern.Solid,
                    textString="m"),
                  Ellipse(
                    extent={{-26,30},{-18,22}},
                    lineColor={255,0,0},
                    fillColor={255,0,0},
                    fillPattern=FillPattern.Solid)}),
          Documentation(
          info="<html>
<p>
This is a partial model that is used to construct models for
interfacing fluid flow systems with the BCVTB interface.
</p>
</html>", revisions="<html>
<ul>
<li>
April 5, 2011, by Michael Wetter:<br>
Added nominal values that are needed by the sensor.
</li>
<li>
September 11, 2009, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
          end FluidInterface;

          function establishClientSocket
          "Establishes the client socket connection"

            input String xmlFileName = "socket.cfg"
            "Name of xml file that contains the socket information";
            output Integer socketFD
            "Socket file descripter, or a negative value if an error occured";
            external "C"
               socketFD =
                        establishModelicaClient(xmlFileName)
                 annotation(Library="bcvtb_modelica",
                            Include="#include \"bcvtb.h\"");
          annotation(Documentation(info="<html>
Function that establishes a socket connection to the BCVTB.
<p>
For the xml file name, on Windows use two backslashes to separate directories, i.e., use
<pre>
  xmlFileName=\"C:\\\\examples\\\\dymola-room\\\\socket.cfg\"
</pre>
</html>", revisions="<html>
<ul>
<li>
May 5, 2009, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
          end establishClientSocket;

          function exchangeReals
          "Exchanges values of type Real with the socket"

            input Integer socketFD(min=1) "Socket file descripter";
            input Integer flaWri
            "Communication flag to write to the socket stream";
            input Modelica.SIunits.Time simTimWri
            "Current simulation time in seconds to write";
            input Real[nDblWri] dblValWri "Double values to write";
            input Integer nDblWri "Number of double values to write";
            input Integer nDblRea "Number of double values to read";
            output Integer flaRea
            "Communication flag read from the socket stream";
            output Modelica.SIunits.Time simTimRea
            "Current simulation time in seconds read from socket";
            output Real[nDblRea] dblValRea "Double values read from socket";
            output Integer retVal
            "The exit value, which is negative if an error occured";
            external "C"
               retVal =
                      exchangeModelicaClient(socketFD,
                 flaWri, flaRea,
                 simTimWri,
                 dblValWri, nDblWri,
                 simTimRea,
                 dblValRea, nDblRea)
              annotation(Library="bcvtb_modelica",
                  Include="#include \"bcvtb.h\"");
          annotation(Documentation(info="<html>
Function to exchange data of type <code>Real</code> with the socket.
This function must only be called once in each 
communication interval.
</html>", revisions="<html>
<ul>
<li>
May 5, 2009, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
          end exchangeReals;

          function closeClientSocket
          "Closes the socket for the inter process communication"

            input Integer socketFD
            "Socket file descripter, or a negative value if an error occured";
            output Integer retVal
            "Return value of the function that closes the socket connection";
            external "C"
               retVal =
                      closeModelicaClient(socketFD)
                 annotation(Library="bcvtb_modelica",
                            Include="#include \"bcvtb.h\"");
          annotation(Documentation(info="<html>
Function that closes the inter-process communication.
</html>", revisions="<html>
<ul>
<li>
May 5, 2009, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
          end closeClientSocket;
        annotation (preferedView="info", Documentation(info="<html>
<p>
This package contains base classes that are used to construct the models in
<a href=\"modelica://Buildings.Utilities.IO.BCVTB\">Buildings.Utilities.IO.BCVTB</a>.
</p>
</html>"));
        end BaseClasses;
      end BCVTB;
    annotation (preferedView="info", Documentation(info="<html>
<p>
This package contains components models for input and output.
Its package
<a href=\"modelica://Buildings.Utilities.IO.BCVTB\">
Buildings.Utilities.IO.BCVTB</a>
can be used for co-simulation with the
<a href=\"http://simulationresearch.lbl.gov/bcvtb\">
Building Controls Virtual Test Bed</a>.
</p>
</html>"));
    end IO;

    package Math "Library with functions such as for smoothing"
      extends Modelica.Icons.VariantsPackage;

      package Functions "Package with mathematical functions"
        extends Modelica.Icons.BasesPackage;

        function cubicHermiteLinearExtrapolation
        "Interpolate using a cubic Hermite spline with linear extrapolation"
          input Real x "Abscissa value";
          input Real x1 "Lower abscissa value";
          input Real x2 "Upper abscissa value";
          input Real y1 "Lower ordinate value";
          input Real y2 "Upper ordinate value";
          input Real y1d "Lower gradient";
          input Real y2d "Upper gradient";
          output Real y "Interpolated ordinate value";
        algorithm
          if (x > x1 and x < x2) then
            y:=Modelica.Fluid.Utilities.cubicHermite(
              x=x,
              x1=x1,
              x2=x2,
              y1=y1,
              y2=y2,
              y1d=y1d,
              y2d=y2d);
          elseif x <= x1 then
            // linear extrapolation
            y:=y1 + (x - x1)*y1d;
          else
            y:=y2 + (x - x2)*y2d;
          end if;
          annotation(smoothOrder=1,
              Documentation(info="<html>
<p>
For <i>x<sub>1</sub> &lt; x &lt; x<sub>2</sub></i>, this function interpolates
using cubic hermite spline. For <i>x</i> outside this interval, the function 
linearly extrapolates.
</p>
<p>
For how to use this function, see
<a href=\"modelica://Buildings.Utilities.Math.Functions.Examples.CubicHermite\">
Buildings.Utilities.Math.Functions.Examples.CubicHermite</a>.
</p>
</html>",
        revisions="<html>
<ul>
<li>
September 27, 2011 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
        end cubicHermiteLinearExtrapolation;

        function spliceFunction
            input Real pos "Argument of x > 0";
            input Real neg "Argument of x < 0";
            input Real x "Independent value";
            input Real deltax "Half width of transition interval";
            output Real out "Smoothed value";
      protected
            Real scaledX;
            Real scaledX1;
            Real y;
        algorithm
            scaledX1 := x/deltax;
            scaledX := scaledX1*Modelica.Math.asin(1);
            if scaledX1 <= -0.999999999 then
              y := 0;
            elseif scaledX1 >= 0.999999999 then
              y := 1;
            else
              y := (Modelica.Math.tanh(Modelica.Math.tan(scaledX)) + 1)/2;
            end if;
            out := pos*y + (1 - y)*neg;
            annotation (
        smoothOrder=1,
        derivative=BaseClasses.der_spliceFunction,
        Documentation(info="<html>
<p>
Function to provide a once continuously differentialbe transition between 
to arguments.
</p><p>
The function is adapted from 
<a href=\"Modelica:Modelica.Media.Air.MoistAir.Utilities.spliceFunction\">
Modelica.Media.Air.MoistAir.Utilities.spliceFunction</a> and provided here
for easier accessability to model developers.
</html>",         revisions="<html>
<ul>
<li>
May 11, 2010, by Michael Wetter:<br>
Removed default value for transition interval as this is problem dependent.
</li>
<li>
May 20, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
        end spliceFunction;

        function splineDerivatives
        "Function to compute the derivatives for cubic hermite spline interpolation"
          input Real x[size(x, 1)] "Support point, strict monotone increasing";
          input Real y[size(x, 1)] "Function values at x";
          input Boolean ensureMonotonicity=isMonotonic(y, strict=false)
          "Set to true to ensure monotonicity of the cubic hermite";
          output Real d[size(x, 1)] "Derivative at the support points";
      protected
          Integer n=size(x, 1) "Number of data points";
          Real delta[n - 1] "Slope of secant line between data points";
          Real alpha "Coefficient to ensure monotonicity";
          Real beta "Coefficient to ensure monotonicity";
          Real tau "Coefficient to ensure monotonicity";

        algorithm
          if (n>1) then
            assert(x[1] < x[n], "x must be strictly increasing.
  Received x[1] = "         + String(x[1]) + "
           x["         + String(n) + "] = " + String(x[n]));
          // Check data
            assert(isMonotonic(x, strict=true),
              "x-values must be strictly monontone increasing or decreasing.");
            if ensureMonotonicity then
              assert(isMonotonic(y, strict=false),
                "If ensureMonotonicity=true, y-values must be monontone increasing or decreasing.");
            end if;
          end if;

          // Compute derivatives at the support points
          if n == 1 then
            // only one data point
            d[1] :=0;
          elseif n == 2 then
            // linear function
            d[1] := (y[2] - y[1])/(x[2] - x[1]);
            d[2] := d[1];
          else
            // Slopes of the secant lines between i and i+1
            for i in 1:n - 1 loop
              delta[i] := (y[i + 1] - y[i])/(x[i + 1] - x[i]);
            end for;
            // Initial values for tangents at the support points.
            // End points use one-sided derivatives
            d[1] := delta[1];
            d[n] := delta[n - 1];

            for i in 2:n - 1 loop
              d[i] := (delta[i - 1] + delta[i])/2;
            end for;

          end if;
          // Ensure monotonicity
          if n > 2 and ensureMonotonicity then
            for i in 1:n - 1 loop
              if (abs(delta[i]) < Modelica.Constants.small) then
                d[i] := 0;
                d[i + 1] := 0;
              else
                alpha := d[i]/delta[i];
                beta := d[i + 1]/delta[i];
                // Constrain derivative to ensure monotonicity in this interval
                if (alpha^2 + beta^2) > 9 then
                  tau := 3/(alpha^2 + beta^2)^(1/2);
                  d[i] := delta[i]*alpha*tau;
                  d[i + 1] := delta[i]*beta*tau;
                end if;
              end if;
            end for;
          end if;
          annotation (Documentation(info="<html>
<p>
This function computes the derivatives at the support points <i>x<sub>i</sub></i>
that can be used as input for evaluating a cubic hermite spline.
If <code>ensureMonotonicity=true</code>, then the support points <i>y<sub>i</sub></i>
need to be monotone increasing (or increasing), and the computed derivatives
<i>d<sub>i</sub></i> are such that the cubic hermite is monotone increasing (or decreasing).
The algorithm to ensure monotonicity is based on the method described in Fritsch and Carlson (1980) for
<i>&rho; = &rho;<sub>2</sub></i>.
</p>
<p>
This function is typically used with
<a href=\"modelica://Buildings.Utilities.Math.Functions.cubicHermiteLinearExtrapolation\">
Buildings.Utilities.Math.Functions.cubicHermiteLinearExtrapolation</a>
which is used to evaluate the cubic spline.
Because in many applications, the shape of the spline depends on parameters,
this function has been implemented in such a way that all derivatives can be 
computed at once and then stored for use during the time stepping,
in which the above function may be called.
</p>
<h4>References</h4>
<p>
F.N. Fritsch and R.E. Carlson, <a href=\"http://dx.doi.org/10.1137/0717021\">Monotone piecewise cubic interpolation</a>. 
<i>SIAM J. Numer. Anal.</i>, 17 (1980), pp. 238?246.
</p>
</html>",         revisions="<html>
<ul>
<li>
September 29, 2011 by Michael Wetter:<br>
Added special case for one data point and two data points.
</li>
<li>
September 27, 2011 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
        end splineDerivatives;

        function inverseXRegularized
        "Function that approximates 1/x by a twice continuously differentiable function"
         input Real x "Abscissa value";
         input Real delta(min=0)
          "Abscissa value below which approximation occurs";
         output Real y "Function value";
      protected
         Real delta2 "Delta^2";
         Real x2_d2 "=x^2/delta^2";
        algorithm
          delta2 :=delta*delta;
          x2_d2  := x*x/delta2;
          y :=smooth(2, if (abs(x) > delta) then 1/x else
            x/delta2 + x*abs(x/delta2/delta*(2 - x2_d2*(3 - x2_d2))));
          annotation (
            Documentation(info="<html>
<p>
Function that approximates <i>y=1 &frasl; x</i> 
inside the interval <i>-&delta; &le; x &le; &delta;</i>.
The approximation is twice continuously differentiable with a bounded derivative on the whole 
real line.
<p>
See the package <code>Examples</code> for the graph.
</p>
</html>",         revisions="<html>
<ul>
<li>
April 18, 2011, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),          smoothOrder=2, Inline=true);
        end inverseXRegularized;

        function isMonotonic
        "Returns true if the argument is a monotonic sequence"
          input Real x[:] "Sequence to be tested";
          input Boolean strict=false
          "Set to true to test for strict monotonicity";
          output Boolean monotonic
          "True if x is monotonic increasing or decreasing";
      protected
          Integer n=size(x, 1) "Number of data points";

        algorithm
          if n == 1 then
            monotonic := true;
          else
            monotonic := true;
            if strict then
              if (x[1] >= x[n]) then
                for i in 1:n - 1 loop
                  if (not x[i] > x[i + 1]) then
                    monotonic := false;
                  end if;
                end for;
              else
                for i in 1:n - 1 loop
                  if (not x[i] < x[i + 1]) then
                    monotonic := false;
                  end if;
                end for;
              end if;
            else
              // not strict
              if (x[1] >= x[n]) then
                for i in 1:n - 1 loop
                  if (not x[i] >= x[i + 1]) then
                    monotonic := false;
                  end if;
                end for;
              else
                for i in 1:n - 1 loop
                  if (not x[i] <= x[i + 1]) then
                    monotonic := false;
                  end if;
                end for;
              end if;
            end if;
            // strict
          end if;

          annotation (Documentation(info="<html>
<p>
This function returns <code>true</code> if its argument is 
monotonic increasing or decreasing, and <code>false</code> otherwise.
If <code>strict=true</code>, then strict monotonicity is tested,
otherwise weak monotonicity is tested.
</p>
</html>",         revisions="<html>
<ul>
<li>
September 28, 2011 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
        end isMonotonic;

        package BaseClasses
        "Package with base classes for Buildings.Utilities.Math.Functions"
          extends Modelica.Icons.BasesPackage;

          function der_spliceFunction "Derivative of splice function"
              input Real pos;
              input Real neg;
              input Real x;
              input Real deltax=1;
              input Real dpos;
              input Real dneg;
              input Real dx;
              input Real ddeltax=0;
              output Real out;
        protected
              Real scaledX;
              Real scaledX1;
              Real dscaledX1;
              Real y;
          algorithm
              scaledX1 := x/deltax;
              scaledX := scaledX1*Modelica.Math.asin(1);
              dscaledX1 := (dx - scaledX1*ddeltax)/deltax;
              if scaledX1 <= -0.99999999999 then
                y := 0;
              elseif scaledX1 >= 0.9999999999 then
                y := 1;
              else
                y := (Modelica.Math.tanh(Modelica.Math.tan(scaledX)) + 1)/2;
              end if;
              out := dpos*y + (1 - y)*dneg;
              if (abs(scaledX1) < 1) then
                out := out + (pos - neg)*dscaledX1*Modelica.Math.asin(1)/2/(
                  Modelica.Math.cosh(Modelica.Math.tan(scaledX))*Modelica.Math.cos(
                  scaledX))^2;
              end if;
          annotation (
          Documentation(
          info="<html>
<p>
Implementation of the first derivative of the function
<a href=\"modelica://Buildings.Utilities.Math.Functions.spliceFunction\">
Buildings.Utilities.Math.Functions.spliceFunction</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 7, 2009, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
          end der_spliceFunction;
        annotation (preferedView="info", Documentation(info="<html>
<p>
This package contains base classes that are used to construct the models in
<a href=\"modelica://Buildings.Utilities.Math.Functions\">Buildings.Utilities.Math.Functions</a>.
</p>
</html>"));
        end BaseClasses;
      annotation (preferedView="info", Documentation(info="<html>
<p>
This package contains functions for commonly used
mathematical operations. The functions are used in 
the blocks
<a href=\"modelica://Buildings.Utilities.Math\">
Buildings.Utilities.Math</a>.
</p>
</html>"));
      end Functions;
    annotation (preferedView="info", Documentation(info="<html>
<p>
This package contains blocks and functions for commonly used
mathematical operations. 
The classes in this package augment the classes
<a href=\"modelica://Modelica.Blocks\">
Modelica.Blocks</a>.
</p>
</html>"));
    end Math;

    package Psychrometrics "Library with psychrometric functions"
      extends Modelica.Icons.VariantsPackage;

      block X_pTphi
      "Return steam mass fraction as a function of relative humidity phi and temperature T"
        extends
        Buildings.Utilities.Psychrometrics.BaseClasses.HumidityRatioVaporPressure;
       replaceable package Medium =
            Modelica.Media.Interfaces.PartialCondensingGases "Medium model" annotation (choicesAllMatching = true);

    public
        Modelica.Blocks.Interfaces.RealInput T(final unit="K",
                                                 displayUnit="degC",
                                                 min = 0) "Temperature"
          annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
        Modelica.Blocks.Interfaces.RealInput phi(min = 0, max=1)
        "Relative humidity (0...1)"
          annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
        Modelica.Blocks.Interfaces.RealOutput X[Medium.nX](min = 0, max=1)
        "Steam mass fraction"
          annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    protected
        constant Real k = 0.621964713077499 "Ratio of molar masses";
        Modelica.SIunits.AbsolutePressure psat "Saturation pressure";
       parameter Integer i_w(min=1, fixed=false) "Index for water substance";
       parameter Integer i_nw(min=1, fixed=false)
        "Index for non-water substance";
       parameter Boolean found(fixed=false) "Flag, used for error checking";
      initial algorithm
        found:=false;
        i_w :=1;
          for i in 1:Medium.nXi loop
            if Modelica.Utilities.Strings.isEqual(string1=Medium.substanceNames[i],
                                                  string2="water",
                                                  caseSensitive=false) then
              i_w :=i;
              found:=true;
            end if;
          end for;
        i_nw := if i_w == 1 then 2 else 1;
        assert(found, "Did not find medium species 'water' in the medium model. Change medium model.");
      algorithm
        psat := Medium.saturationPressure(T);
        X[i_w] := phi*k/(k*phi+p_in_internal/psat-phi);
        //sum(X[:]) = 1; // The formulation with a sum in an equation section leads to a nonlinear equation system
        X[i_nw] := 1 - X[i_w];
        annotation (Documentation(info="<html>
<p>
Block to compute the water vapor concentration based on
pressure, temperature and relative humidity.
</p>
<p>If <code>use_p_in</code> is false (default option), the <code>p</code> parameter
is used as atmospheric pressure, 
and the <code>p_in</code> input connector is disabled; 
if <code>use_p_in</code> is true, then the <code>p</code> parameter is ignored, 
and the value provided by the input connector is used instead.
</p>
</html>",       revisions="<html>
<ul>
<li>
February 22, by Michael Wetter:<br>
Improved the code that searches for the index of 'water' in the medium model.
</li>
<li>
February 17, 2010 by Michael Wetter:<br>
Renamed block from <code>MassFraction_pTphi</code> to <code>X_pTphi</code>
</li>
<li>
February 4, 2009 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),       Icon(graphics={
              Text(
                extent={{-96,16},{-54,-22}},
                lineColor={0,0,0},
                textString="T"),
              Text(
                extent={{-86,-18},{-36,-100}},
                lineColor={0,0,0},
                textString="phi"),
              Text(
                extent={{26,56},{90,-54}},
                lineColor={0,0,0},
                textString="X_steam")}));
      end X_pTphi;

      package BaseClasses
      "Package with base classes for Buildings.Utilities.Psychrometrics"
        extends Modelica.Icons.BasesPackage;

        partial block HumidityRatioVaporPressure
        "Humidity ratio for given water vapor pressure"
          extends Modelica.Blocks.Interfaces.BlockIcon;
          parameter Boolean use_p_in = true
          "Get the pressure from the input connector"
            annotation(Evaluate=true, HideResult=true);

          parameter Modelica.SIunits.Pressure p = 101325
          "Fixed value of pressure"
            annotation (Evaluate = true,
                        Dialog(enable = not use_p_in));
          Modelica.Blocks.Interfaces.RealInput p_in(final quantity="Pressure",
                                                 final unit="Pa",
                                                 min = 0) if  use_p_in
          "Atmospheric Pressure"
            annotation (Placement(transformation(extent={{-140,40},{-100,80}},
                        rotation=0)));

      protected
          Modelica.Blocks.Interfaces.RealInput p_in_internal
          "Needed to connect to conditional connector";
        equation
          connect(p_in, p_in_internal);
          if not use_p_in then
            p_in_internal = p;
          end if;
          annotation (
            Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
                    100}}),
                    graphics),
            Documentation(info="<html>
<p>
Partial Block to compute the relation between humidity ratio and water vapor partial pressure.
</p>
<p>If <code>use_p_in</code> is false (default option), the <code>p</code> parameter
is used as atmospheric pressure, 
and the <code>p_in</code> input connector is disabled; 
if <code>use_p_in</code> is true, then the <code>p</code> parameter is ignored, 
and the value provided by the input connector is used instead.
</p>
</html>",         revisions="<html>
<ul>
<li>
April 14, 2009 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),  Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
                    100}}), graphics={
                Rectangle(
                  extent={{-100,100},{100,-100}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{-96,96},{96,-96}},
                  fillPattern=FillPattern.Sphere,
                  pattern=LinePattern.None,
                  lineColor={255,255,255},
                  fillColor={170,213,255}),
                Text(
                  visible=use_p_in,
                  extent={{-90,108},{-34,16}},
                  lineColor={0,0,0},
                  textString="p_in")}));
        end HumidityRatioVaporPressure;
      annotation (preferedView="info", Documentation(info="<html>
<p>
This package contains base classes that are used to construct the models in
<a href=\"modelica://Buildings.Utilities.Psychrometrics\">Buildings.Utilities.Psychrometrics</a>.
</p>
</html>"));
      end BaseClasses;
    annotation (preferedView="info", Documentation(info="<html>
This package contains blocks and functions for psychrometric calculations.
</p>
<p>
The nomenclature used in this package is described at
<a href=\"modelica://Buildings.UsersGuide.Conventions\">
Buildings.UsersGuide.Conventions</a>.
</html>"));
    end Psychrometrics;
  annotation (preferedView="info", Documentation(info="<html>
<p>
This package contains utility models such as for thermal comfort calculation, input/output, co-simulation, psychrometric calculations and various functions that are used throughout the library.
</p>
</html>"));
  end Utilities;

  package BaseClasses "Package with base classes for the Buildings library"
    extends Modelica.Icons.BasesPackage;

    block BaseIcon "Base icon"

      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics={Text(
              extent={{-46,140},{52,92}},
              lineColor={0,0,255},
              textString="%name")}),
    Documentation(
    info="<html>
<p>
Basic class that provides a label with the component name above the icon.
</p>
</html>",
    revisions="<html>
<ul>
<li>
April 28, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
    end BaseIcon;
  annotation (preferedView="info", Documentation(info="<html>
<p>
This package contains base classes that are used to construct the models in
<a href=\"modelica://Buildings\">Buildings</a>.
</p>
</html>"));
  end BaseClasses;
annotation (
version="1.2",
versionBuild=0,
versionDate="2012-02-29",
dateModified = "$Date: 2012-07-18 15:42:54 -0700 (Wed, 18 Jul 2012) $",
uses(Modelica(version="3.2")),
conversion(
 from(version="1.1",
      script="modelica://Buildings/Resources/Scripts/Dymola/ConvertBuildings_from_1.1_to_1.2.mos"),
 from(version="1.0",
      script="modelica://Buildings/Resources/Scripts/Dymola/ConvertBuildings_from_1.0_to_1.1.mos"),
 from(version="0.12",
      script="modelica://Buildings/Resources/Scripts/Dymola/ConvertBuildings_from_0.12_to_1.0.mos")),
revisionId="$Id: package.mo 4258 2012-07-18 22:42:54Z mwetter $",
preferredView="info",
Documentation(info="<html>
<p>
The <code>Buildings</code> library is a free library
for modeling building energy and control systems. 
Many models are based on models from the package
<code>Modelica.Fluid</code> and use
the same ports to ensure compatibility with the Modelica Standard
Library.
</p>
<p>
The figure below shows a section of the schematic view of the model 
<a href=\"modelica://Buildings.Examples.HydronicHeating\">
Buildings.Examples.HydronicHeating</a>.
In the lower part of the figure, there is a dynamic model of a boiler, a pump and a stratified energy storage tank. Based on the temperatures of the storage tank, a finite state machine switches the boiler and its pump on and off. 
The heat distribution is done using a hydronic heating system with a three way valve and a pump with variable revolutions. The upper right hand corner shows a room model that is connected to a radiator whose flow is controlled by a thermostatic valve.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/UsersGuide/HydronicHeating.png\" border=\"1\">
</p>
<p>
The web page for this library is
<a href=\"http://simulationresearch.lbl.gov/modelica\">http://simulationresearch.lbl.gov/modelica</a>. 
Contributions from different users to further advance this library are
welcomed.
Contributions may not only be in the form of model development, but also
through model use, model testing,
requirements definition or providing feedback regarding the model applicability
to solve specific problems.
</p>
</html>"));
end Buildings;
model Buildings_Utilities_IO_BCVTB_Examples_MoistAir
 extends Buildings.Utilities.IO.BCVTB.Examples.MoistAir;
  annotation(experiment(Tolerance=1e-05, Algorithm="Lsodar"),uses(Buildings(version="1.2")));
end Buildings_Utilities_IO_BCVTB_Examples_MoistAir;
