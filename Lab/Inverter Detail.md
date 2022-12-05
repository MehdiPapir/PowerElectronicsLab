# Inverter Intel
Mask of this block including three part: Basic, Filter, Controller
In 'Basic' section you have to choice following parameters:
 * DC Link between 'Internal' and 'External' sources
 * Controller loop between 'Current' and 'Voltage' feedback loop
 * Measurement type between 'Port', 'Label' and 'No Measure'

And set following parameters:
 * Nominal line-to-line Voltage in RMS Volt
 * Nominal Power in Vote-Amper
 * Nominal DC Link Voltage in Volt
 * Fundamental frequency in Hertz
 * Switching frequency in Hertz

In 'Filter' section you can enter following parameters:
 * Inverter side inductance in Henry
 * Grid side inductance in Henry
 * Filter capacitance in Farad
 * Filter resistance in Ohm

or set following parameters and use designer button to calculate parameters above automatically
 * Maximum accepted voltage variation for advance design in per unit
 * Maximum accepted current variation for advance design in per unit
 * Grid inductance per inverter inductance ratio

You also can enter you own designed filter and use Calculator button to calculate Max. accepted voltage and current variation.
In 'Controller' section you can set controller parameters or use Designer button to calculate them automatically.

In program i made switch case to accelerated run time of each call back. To use this function you have to enter your part name as input arguments. Following table shows each part name.

|  No.  |        Argument        | Part                                                  |
| :---: | :--------------------: | :---------------------------------------------------- |
|   1   |   'MeasurementPopup'   | Refer to measurement popup                            |
|   2   |   'MeasurementLabel'   | Refer to measurement label                            |
|   3   |    'DCLinkSelector'    | Refer to DC link selector popup                       |
|   4   |     'LoopSelector'     | Refer to controller loop selector popup               |
|   5   |  'LCLFilterDesigner'   | Refer to filter designer button in filter tab         |
|   6   | 'LCLFilterCalculator'  | Refer to filter calculator button in filter tab       |
|   7   | 'PRControllerDesigner' | Refer to controller designer button in controller tab |

