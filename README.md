# RSU_Deployment_GUSEK

Final project of the subject "Systems Optimization" from the Graduate Program in Electrical Engineering and Industrial Informatics (CPGEI) from UTFPR, Brazil. It consists on the use of the GUSEK tool to solve a Binary Integer Programming Problem that can determine the deployment coordinates for RSUs in a Vehicular Network. 

### Disclaimer 

This project is heavily inspired by: 

>P. -C. Lin, "Optimal roadside unit deployment in vehicle-to-infrastructure communications," 2012 12th International Conference on ITS Telecommunications, 2012, pp. 796-800, doi: 10.1109/ITST.2012.6425291, Available in: https://ieeexplore.ieee.org/document/6425291.

## Introduction

Given a certain urban environment where V2X (vehicle-to-everything) communication is desired, it is important to efficiently guarantee that the actors (cars, pedestrians, cyclists, etc) are aware of the position, speed and heading of each other to ensure the safety of all the users. Since it is unreasonable to suppose that all these actors will have compatible V2X devices, one way to provide the detection of multiple people is with the use of Roadside Units (RSUs). 

RSUs are infrastructure nodes that are placed alongside the urban environment and are equipped with sensors and wireless communication devices. One of the most common uses of these nodes is to monitor crosswalks in order to ensure the safety of pedestrians that intend on crossing the street. 

This work aims to provide an algorithm capable of defining the optimal deployment location for Roadside Unit nodes in a urban environment using the least amount of RSUs in order to not waste resources. The simulated area is composed of the coordinates $i$ and $j$ and for simplicity's sake, only integer coordinates are used. An example containing a 3x4 grid can be seen below:

<img src="https://user-images.githubusercontent.com/64433982/211125605-0aa4d7db-e9ca-4b61-ad4e-710d2b28d41b.png" alt="blank 3x4 grid" width=400>

These coordinates can either be a location that must be covered by an RSU, a candidate for RSU placement or an unavailable location. It is also important to note that in this project every RSU is capable of providing coverage in a circular radius of 1 unit of lenght ($r = 1$) centered on its deployed position. The following figure presents these positions and their possible types:

<img src="https://user-images.githubusercontent.com/64433982/211661585-812a808e-5678-4d3c-b1cf-2f5ecd9a5883.png" alt="position types in a 4x5 grid" width=600>

## Project description

Since the decision to deploy a RSU in a given pair of integer coordinates is boolean, this study case is a Binary Integer Programming Problem. In order to solve the proposed network models, the program GUSEK (https://gusek.sourceforge.net/gusek.html) was utilized. It is an open source project based on the GLPK solver that can handle diverse types of optimization problems, including the one presented in this work. 

### Parameter definition

As mentioned, the coordinates are given by a set of integer coordinates where the maximum value for the vertical $L_v$ and horizontal $L_h$ positions can be customized:

```math 
    $i = 1, 2, \dots, L_v$ 
```
    
```math 
    $j = 1, 2, \dots, L_h$
```

The matrix $M^c$ defines which coordinates $m_{i, j}^c \in M^c$ don't need to be covered by an RSU, for example due to it not having any users passing through it. 

Similarly, $M^d$ is a deployment matrix, that indicates that the position $m_{i, j}^d \in M^d$ can't have an RSU installed. This can happen because the specified coordinate is in the middle of a lake or another unaccessible location.

The decision to deploy or not an RSU in a coordinate is a boolean variable $x_{i,j}$, that is equal to 1 when the position will have an RSU and is equal to 0 otherwise. In this scenario, all the deployment options have an unitary cost, but this can be easily changed to a coordinate dependant value in future updates.

```math
x_{i,j} =
    \begin{cases}
        0, \; \text{NOT place a RSU in (i,j),}\\
        1, \; \text{place a RSU in (i,j).}
    \end{cases}
```

In order to enforce that the unavailable positions $m_{i,d}^d$ are not viable options, an arbitrary $\alpha$ value is used to make the cost of these nodes sufficiently big for the location to never be used by the solver. 

### Optimization model

Given all these conditions, the objective function is given by:

```math
\min f(X) = \sum^{L_v}_{i=1}\sum^{L_h}_{j=1}[c_{i,j} + \alpha \times m_{i, j}^d] \times x_{i,j},
```

The restriction of the model is given by the fact that ``all the available nodes must be covered by at least one RSU``. This verification is done by using a parameter $a$ that sweeps the network area again with a set of auxiliary coordinates $k$ and $l$ and checking that for every location $a_{i,j,k,l}$ there is at least one $x_{i,j} = 1$ in the range $r$. 

```math
    a_{i,j,k,l} = 
    \begin{cases}
    0, \; \text{if} \: \sqrt{(k-i)^2 + (l-j)^2} > r \; ,\\
    1, \; \text{if} \: \sqrt{(k-i)^2 + (l-j)^2} \leq r \; .
    \end{cases}
```

Thus, the restriction of the optimization problem can be described by:

```math
    \text{subject to} \; \sum^{L_v}_{i=1}\sum^{L_h}_{j=1} a_{i,j,k,l} \times x_{i,j} \geq 1 - m^c_{k,l} \:, \forall k, l \;
```

## Program execution

The presented __.mod__ file contains a 4x5 and a 10x9 network examples, but it can can be edited to use different network grid shapes.  

After the program is executed, GUSEK will first find an optimal solution in a Linear Programming approach through several iterations. From there, it will iterate once again, but using Branch-and-bound techniques to find the optimal Integer solution for the problem. 

> Note that the bigger the grid, the longer the program will take to reach an optimal solution. 

After a succesfull run, the recommended coordinates for RSU placement will be printed in the GUSEK results terminal:

<img src="https://user-images.githubusercontent.com/64433982/211676592-482caa36-bff0-4a1b-ab67-6eac541e2f45.png" alt="result screen" width=800>

## Examples

Along with the optimization model, two sets of configurations are present at the end of the source __.mod__ file as examples on how to setup a network model. In both of the examples it is considered that $M^d = M^c$, meaning that a node that does not need to be covered, also cannot be used to place a RSU.

### 4x5 grid

The first example contains a grid with 4 rows and 5 columns where the coordinates (1,4) and (3,2) are unavailable.

From the 18 available positions, the solver indicated that 5 RSUs were necessary and that they should be placed in [(1,1); (2,3); (2,5); (4,1); (4,4)] resulting in the model below:

<img src="https://user-images.githubusercontent.com/64433982/211661585-812a808e-5678-4d3c-b1cf-2f5ecd9a5883.png" alt="example 4x5 grid" width=600>

### 10x9 grid

The second example is pretty much identical, but using a grid with 10 rows and 9 columns where the coordinates [(2,5); (3,1); (4,8); (6,4); (8,7)] are not to be used.

From the 85 available positions, 22 RSUs are needed in the coordinates [(1,1); (1,6); (2,3); (2,4); (2,8); (2,9); (3,5); (4,2); (4,7); (5,4); (5,9); (6,1); (6,6); (7,2); (7,3); (7,8); (8,5); (9,1); (9,5); (9,9); (10,3); (10,7)] resulting in:

<img src="https://user-images.githubusercontent.com/64433982/211678520-5a818a4c-ff83-4312-98a1-88fc48078b1a.png" alt="example 10x9 grid" width=600>
