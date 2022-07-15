pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/comparators.circom";
include "../../node_modules/circomlib-matrix/circuits/matMul.circom";

template SystemOfEquations(n) { // n is the number of variables in the system of equations
    signal input x[n]; // this is the solution to the system of equations
    signal input A[n][n]; // this is the coefficient matrix
    signal input b[n]; // this are the constants in the system of equations
    signal output out; // 1 for correct solution, 0 for incorrect solution

    // [bonus] insert your code here
    // A*x
    component mul = matMul(n,n,1);
    for (var i=0; i<n; i++) {
        for (var j=0; j<n; j++) {
            mul.a[i][j] <== A[i][j];
        }
        mul.b[i][0] <== x[i];
    }

    // Sum of how many elements in the vector are equal
    component isLhsEqualRhs[n];
    var sumEqual = 0;
    for (var i=0; i < n; i++) {
        isLhsEqualRhs[i] = IsEqual();
        isLhsEqualRhs[i].in[0] <== mul.out[i][0];
        isLhsEqualRhs[i].in[1] <== b[i];

        sumEqual += isLhsEqualRhs[i].out;
    }

    // Check if number of equal elements is equal to the size of the vector
    component allEqual = IsEqual();
    allEqual.in[0] <== sumEqual;
    allEqual.in[1] <== n;

    out <== allEqual.out;
}

component main {public [A, b]} = SystemOfEquations(3);