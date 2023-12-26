I made a macro with IgorPro6 to get a honeycomb pattern given by a double quantum dot transport. I used the following article:
Shuo Yang, Xin Want, and S. Das Sarma, "Generic Hubbard model description of semiconductor quantum-dot spin qubits", Physical Review B 83, 161301 (2011).
You can find the detailed model in this paper.

My macro:
1. Set up the Hamiltonian with parameters, on-site Coulomb energy (U), intersite Coulomb energy (U12), and tunnel coupling (t).
2. Calculate the lowest eigenvalues as a function of a gate voltage (V1) and store them in a wave.
3. Repeat the calculation at the other gate voltages (V2) and store the data in other waves.
4. Display a graph and show a colored plot. Here I use another macro to display a colored plot. So please change the sentences so that you can display a color plot with your own macro.
