ASAM OpenCRG®
===============================
ASAM OpenCRG defines a file format for the description of road surfaces. It was originally developed to store high-precision elevation data from road surface scans. The primary use for this data is in tire, vibration or driving simulation. Precise elevation data allows realistic endurance simulation of vehicle components or the entire vehicle. For driving simulators, it allows a realistic 3D-rendering of the road surface. The file format can also be used for other types of road surface properties, e.g. for the friction coefficient or grey values.  

The standard describes a method to store the data in a specific layout, called "curved regular grid" (abr. CRG). The advantages of this method are high memory efficiency, low computation time for file generation and data processing in simulation tools, and high accuracy of positioning the data onto road networks.The basic principle for describing the road surface is to place the data into a grid along a road reference line. Line segments are described by a start position and heading angle. The grid is produced by longitudinal cuts (columns) and lateral cuts (rows) along consecutive line segments. Each cell in this grid has a value, typically the elevation. The road center line also includes the end position, which can be used to detect and correct a potential drift of the placement of the data on roads.

ASAM OpenCRG defines ASCII and binary file formats with clear-text headers. The header contains road parameters for the reference line and the overall configuration of the longitudinal sections, a definition of the data format (ASCII and binary), the sequence of data which is expected in the trailing data block, and modifier and option parameters. Furthermore, OpenCRG-files may contain references to other files (typically containing the actual data) to handle different parameters for the same data set.

Data from ASAM OpenCRG can be included in OpenDRIVE road network descriptions. The dynamic content of driving simulations, such as vehicle maneuvers, can be described with ASAM OpenSCENARIO. The three standards complement each other and cover the static and dynamic content of in-the-loop vehicle simulation applications.

The standard is delivered with software libraries in ANSI-C and MATLAB. The libraries for both languages contain functions for reading CRG files, and for modifying and evaluating the imported data. In addition to that, the MATLAB library contains functions to generate, analyze and visualize the data.
## Contribute
If you want to contribute in this project, please read the [Contribution guidelines](https://github.com/asam-ev/.github/blob/main/profile/CONTRIBUTING.md).
## About ASAM
ASAM e.V. (Association for Standardization of Automation and Measuring Systems) is a non-profit organization that promotes standardization of tool chains in automotive development and testing. 
Our members are international car manufacturers, suppliers, tool vendors, engineering service providers, and research institutes. 
ASAM standards are developed by experts from our member companies and are based on real use cases. ASAM is the legal owner of these standards and is responsible for their distribution and marketing.

ASAM provides support in connecting members, coordinating work groups, and developing, releasing, and maintaining standards. 
Our active community includes more than 400 member organizations around the world. 
These members ensure that ideas with market relevance will progress into standards and that these standards are used worldwide.

The standards developed at ASAM span a wide range of use cases in automotive development, test, and Validation. 
They define file formats, data models, protocols, and interfaces. 
All ASAM standards aim to enable easy exchange of data and tools within and across tool chains. 
They are applied worldwide.
