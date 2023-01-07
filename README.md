# RSU_Deployment_GUSEK

Final project of the subject "Systems Optimization" from the Graduate Program in Electrical Engineering and Industrial Informatics (CPGEI) from UTFPR, Brazil. It consists on the use of the GUSEK tool to solve a Binary Integer Programming Problem that can determine the deployment coordinates for RSUs in a Vehicular Network. 

### Disclaimer 

This project is heavily inspired by: 

>P. -C. Lin, "Optimal roadside unit deployment in vehicle-to-infrastructure communications," 2012 12th International Conference on ITS Telecommunications, 2012, pp. 796-800, doi: 10.1109/ITST.2012.6425291, Available in: https://ieeexplore.ieee.org/document/6425291.

## Project description

Given a certain urban environment where V2X (vehicle-to-everything) communication is desired, it is important to efficiently guarantee the coverage of all the nodes while also not wasting resources. This work aims to provide an algorithm capable of defining the optimal deployment location for Roadside Unit nodes in a urban environment described by a set of configurable $i$ and $j$ coordinates. For simplicity's sake, only integer coordinates are used to describe possible deployment positions or 

<img src="https://user-images.githubusercontent.com/64433982/211125605-0aa4d7db-e9ca-4b61-ad4e-710d2b28d41b.png" alt="blank 3x4 grid" width=400>

$i = 1, 2, \dots, L_v$
    
$j = 1, 2, \dots, L_h$
