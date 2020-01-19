/*
 * DC-Servo Motor Modelling
 */


#define S_FUNCTION_NAME Your_file_Name


#define S_Function_Template pi


#include <stddef.h>
#include <stdlib.h>
#include <math.h>
#include "simstruc.h"
#ifdef MATLAB_MEX_FILE
#include "mex.h"
#endif
                                    

#define SAMPLE_TIME_ARG			ssGetArg(S,0)

#define ki_ARG                  ssGetArg(S,1)


#define kp_ARG                  ssGetArg(S,2)
#define NUMBER_OF_ARGS			(3)
#define NSAMPLE_TIMES			(1)
#define NUMBER_OF_INPUTS		(1)
#define NUMBER_OF_OUTPUTS		(1) 

/* Variables */
float e_k,e_k_1,u_k,u_k_1,ts,ki,kp;



static void mdlInitializeSizes(SimStruct *S)
{
    if (ssGetNumArgs(S) != NUMBER_OF_ARGS) {
#ifdef MATLAB_MEX_FILE
	mexErrMsgTxt("Wrong number of input arguments passed.\nThree arguments are expected\n");
#endif
    }

	/* Set up size information */
    ssSetNumContStates(    S, 0);      /* number of continuous states */
    ssSetNumDiscStates(    S, 1);      /* number of discrete states */
    ssSetNumInputs(        S, NUMBER_OF_INPUTS);      /* number of inputs */
    ssSetNumOutputs(       S, NUMBER_OF_OUTPUTS);      /* number of outputs */
    ssSetDirectFeedThrough(S, 0);      /* direct feedthrough flag */
    ssSetNumSampleTimes(   S, NSAMPLE_TIMES);      /* number of sample times */
    ssSetNumInputArgs(     S, NUMBER_OF_ARGS);      /* number of input arguments */
    ssSetNumRWork(         S, 0);      /* number of real work vector elements */
    ssSetNumIWork(         S, 0); 	   /* NUMBER_OF_IWORKS);      /* number of integer work vector elements */
    ssSetNumPWork(         S, 0);      /* number of pointer work vector elements */
}


static void mdlInitializeSampleTimes(SimStruct *S)
{
    ssSetSampleTimeEvent(S, 0, mxGetPr(SAMPLE_TIME_ARG)[0]);
    ssSetOffsetTimeEvent(S, 0, 0.0);
}



static void mdlInitializeConditions(double *x0, SimStruct *S)
{

	ts = mxGetPr(SAMPLE_TIME_ARG)[0];		 /*Sampling Time*/
    
	ki = mxGetPr(ki_ARG)[0];	
    
	kp = mxGetPr(kp_ARG)[0];	
	
/* States initialization*/
ts=0.0001;
u_k_1=0;
u_k=0;
}

static void mdlOutputs(double *y, double *x, double *u, SimStruct *S, int tid)
{
	
    y[0] = u_k_1; 

}



static void mdlUpdate(double *x, double *u, SimStruct *S, int tid)
{
//Model Update
e_k=u[0];
u_k=(kp+(ki*ts))*e_k-kp*e_k_1+u_k_1;
 u_k_1=u_k;



}


/*
 * mdlDerivatives - compute the derivatives
 *
 * In this function, you compute the S-function block's derivatives.
 * The derivatives are placed in the dx variable.
 */
static void mdlDerivatives(double *dx, double *x, double *u, SimStruct *S, int tid)
{
}

/*
 * mdlTerminate - called when the simulation is terminated.
 *
 * In this function, you should perform any actions that are necessary
 * at the termination of a simulation.  For example, if memory was allocated
 * in mdlInitializeConditions, this is the place to free it.
 */

static void mdlTerminate(SimStruct *S)
{
}

#ifdef	MATLAB_MEX_FILE    /* Is this file being compiled as a MEX-file? */
#include "simulink.c"      /* MEX-file interface mechanism */
#else
#include "cg_sfun.h"       /* Code generation registration function */
#endif
