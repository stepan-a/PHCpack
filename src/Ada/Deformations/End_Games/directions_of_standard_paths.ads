with text_io;                            use text_io;
with Standard_Natural_Numbers;           use Standard_Natural_Numbers;
with Standard_Integer_Numbers;           use Standard_Integer_Numbers;
with Standard_Floating_Numbers;          use Standard_Floating_Numbers;
with Standard_Complex_Numbers;           use Standard_Complex_Numbers;
with Standard_Floating_Vectors;
with Standard_Complex_Vectors;
with Standard_Floating_VecVecs;

package Directions_of_Standard_Paths is

-- DESCRIPTION :
--   This package provides routines to estimate numerically the direction
--   of a solution path diverging to a solution of a face system,
--   using standard floating-point arithmetic.

-- APPLICATION OF EXTRAPOLATION :

  procedure Shift_Up ( v : in out Standard_Floating_Vectors.Vector;
                       x : in double_float );

  -- DESCRIPTION :
  --   Puts x at v(v'first) after a shift-up: v(i+1) := v(i).
  --   The element in v(v'last) is overwritten.

  procedure Extrapolation_Window
                ( r,m : in integer32; t,target : in Complex_Number;
                  x : in Standard_Complex_Vectors.Vector;
                  dt,s,logs : in out Standard_Floating_Vectors.Vector;
                  logx : in out Standard_Floating_VecVecs.VecVec );

  -- DESCRIPTION :
  --   The data (dt,s,logs and logx) are stored as in a window:
  --   when full at the incoming of a new element, all elements are
  --   shifted and the oldest element drops off.

  procedure Refresh_Window
              ( r,m : in integer32;
                dt : in Standard_Floating_Vectors.Vector;
                s,logs : in out Standard_Floating_Vectors.Vector );

  -- DESCRIPTION :
  --   Recomputes s and logs, after m has been changed.

  procedure Write_Update_Information
                ( file : in file_type; r,m : in integer32;
                  s,logs : in double_float;
                  logx : in Standard_Floating_Vectors.Vector );

  -- DESCRIPTION :
  --   Writes r, s, log(s) and log|x(s)| on file.
  --   The current version only writes a banner with r and m.

  procedure Affine_Update_Extrapolation_Data
                ( r,m : in integer32; t,target : in Complex_Number;
                  x : in Standard_Complex_Vectors.Vector;
                  dt,s,logs : in out Standard_Floating_Vectors.Vector;
                  logx,wvl0,wvl1,wvltmp
                    : in out Standard_Floating_VecVecs.VecVec );

  -- DESCRIPTION :
  --   Updates the data needed to extrapolate in the affine case.

  procedure Projective_Update_Extrapolation_Data
                ( r,m : in integer32; t,target : in Complex_Number;
                  x : in Standard_Complex_Vectors.Vector;
                  dt,s,logs : in out Standard_Floating_Vectors.Vector;
                  logx : in out Standard_Floating_VecVecs.VecVec );

  -- DESCRIPTION :
  --   Updates the data needed to extrapolate in the projective case,
  --   under the assumption that the homogenization variable appears lastly.

  procedure Update_Errors
              ( r : in integer32;
                errorv : in out Standard_Floating_Vectors.Vector;
                error : out double_float;
                wvl0,wvl1,wvltmp : in out Standard_Floating_VecVecs.VecVec );

  -- DESCRIPTION :
  --   Updates the error computation after the extrapolation.

  -- REQUIRED : r >= 1.

-- ESTIMATING THE WINDING NUMBER :

  procedure Frequency_of_Estimate
               ( newest : in integer32; max : in natural32;
                 m,estm : in out integer32; cnt : in out natural32; 
                 eps : in double_float; newm : out boolean );

  -- DESCRIPTION :
  --   This procedure manages the frequencies of the estimated values for m.
  --   Only after the same estimate has been found a certain number of
  --   times, the new estimate will be accepted.
  --   The current version does not take the accuracy eps into account.

  -- ON ENTRY :
  --   newest    newly computed estimate for m;
  --   max       threshold on cnt before estm is returned;
  --   m         current value of m;
  --   estm      previous estimate;
  --   cnt       number of consecutive guesses that yielded estm;
  --   eps       accuracy of the current estimate.

  -- ON RETURN :
  --   m         new value of m;
  --   estm      new estimate;
  --   cnt       updated number of consecutive guesses that yielded estm;
  --   newm      true if m has changed.

  procedure Extrapolate_on_Errors
               ( file : in file_type;
                 r : in integer32; h : in double_float;
                 err : in Standard_Floating_Vectors.Vector;
                 estm : out double_float );

  -- DESCRIPTION :
  --   Performs an rth-order extrapolation on the errors.

  -- ON ENTRY :
  --   file      to write intermediate results on;
  --   r         order of the extrapolation method;
  --   h         ratio in geometric sequence;
  --   err       vector of range 0..r+1 with differences of estimates for
  --             the outer normal, the most recent error is err(0).

  -- ON RETURN :
  --   extm      estimated value for m.

  procedure Estimate0
               ( r : in integer32; max : in natural32;
                 m,estm : in out integer32; cnt : in out natural32; 
                 dt : in Standard_Floating_Vectors.Vector;
                 err,newerr : in double_float; rat,eps : out double_float;
                 newm : out boolean );

  -- DESCRIPTION :
  --   Returns an 0th-order estimate of the winding number m.
  
  -- ON ENTRY :
  --   r         extrapolation order;
  --   max       threshold on cnt before estm is returned;
  --   m         current value of m;
  --   estm      previous estimate;
  --   cnt       number of consecutive guesses that yielded estm;
  --   dt        consecutive distances to the target;
  --   err       previous error;
  --   newerr    current error.

  -- ON RETURN :
  --   m         new value of m;
  --   estm      new estimate;
  --   cnt       updated number of consecutive guesses that yielded estm;
  --   rat       ratio used to estimate m;
  --   eps       accuracy of the rounding value for m;
  --   newm      true if m has changed.

  procedure Estimate
               ( file : in file_type; r : in integer32;
                 max : in natural32; m,estm : in out integer32;
                 cnt : in out natural32; h : in double_float;
                 diferr : in Standard_Floating_Vectors.Vector;
                 rat,eps : out double_float; newm : out boolean );

  -- DESCRIPTION :
  --   Estimates m by extrapolation on consecutvie differences of errors,
  --   stored in the parameter diferr.  For the specfication of the other
  --   parameters, see the procedure Estimate0.

-- APPLYING THE vLpRs-Algorithm :

  function vLpRs_Extrapolate
                ( r : integer32;
                  s,logs : Standard_Floating_Vectors.Vector;
                  logx : Standard_Floating_VecVecs.VecVec )
                return Standard_Floating_Vectors.Vector;
  function vLpRs_Extrapolate
                ( file : file_type; r : integer32;
                  s,logs : Standard_Floating_Vectors.Vector;
                  logx : Standard_Floating_VecVecs.VecVec )
                return Standard_Floating_Vectors.Vector;

  -- DESCRIPTION :
  --   Higher-order extrapolation based on vLpRs-Algorithm,
  --   without or with output to file.

  -- REQUIRED : r >= 1.

  procedure vLpRs_Extrapolate
                ( file : in file_type; r : in integer32;
                  s,logs : in Standard_Floating_Vectors.Vector;
                  logx,wvl0 : in Standard_Floating_VecVecs.VecVec;
                  wvl1 : in out Standard_Floating_VecVecs.VecVec;
                  w,wv,wl : out Standard_Floating_Vectors.Vector );

  -- DESCRIPTION :
  --   Higher-order extrapolation based on vLpRs-Algorithm,
  --   writes an error table on file.

  -- REQUIRED : r >= 1.

-- FIRST ORDER APPROXIMATION (no extrapolation) :

  procedure Affine_Update_Direction
                ( t,prev_t,target : in Complex_Number;
                  x,prevx : in Standard_Complex_Vectors.Vector;
                  prevdls,prevstep : in out double_float;
                  prevdiff,v : in out Standard_Floating_Vectors.Vector );

  -- DESCRIPTION :
  --   Computes an approximation of the direction of the path.
  --   When prevdls /= 0.0, a second-order extrapolation will be applied.

  -- ON ENTRY :
  --   t          current value of continuation parameter;
  --   prev_t     previous value of continuation parameter;
  --   target     target value of continuation parameter;
  --   x          current solution vector;
  --   prevx      solution vector for previous value of continuation parameter;
  --   prevdls    previous difference of the logs of distances to target;
  --   prevstep   previous step size;
  --   prevdiff   previous difference of the logs of the solution vectors;
  --   v          current approximate direction of the path.

  procedure Projective_Update_Direction
                ( t,prev_t,target : in Complex_Number;
                  x,prevx : in Standard_Complex_Vectors.Vector;
                  prevdls,prevstep : in out double_float;
                  prevdiff,v : in out Standard_Floating_Vectors.Vector );

  -- DESCRIPTION :
  --   Does the same as the other procedure, under the assumption that the
  --   solution vector lies in projective space.

  -- REQUIRED : 
  --   The homogenization variable is the last element of the solution vector.

-- HIGHER ORDER EXTRAPOLATION (driver procedures) :

  procedure Affine_Update_Direction
                ( r,m,estm : in out integer32;
                  cntm : in out natural32; thresm : in natural32;
                  er : in out integer32; t,target : in Complex_Number;
                  x : in Standard_Complex_Vectors.Vector;
                  dt,s,logs : in out Standard_Floating_Vectors.Vector;
                  logx,wvl0,wvl1,wvltmp
                    : in out Standard_Floating_VecVecs.VecVec;
                  v,diferr : in out Standard_Floating_Vectors.Vector;
                  error : in out double_float );

  procedure Affine_Update_Direction
                ( file : in file_type;
                  r,m,estm : in out integer32;
                  cntm : in out natural32; thresm : in natural32;
                  er : in out integer32; t,target : in Complex_Number;
                  x : in Standard_Complex_Vectors.Vector;
                  dt,s,logs : in out Standard_Floating_Vectors.Vector;
                  logx,wvl0,wvl1,wvltmp
                    : in out Standard_Floating_VecVecs.VecVec;
                  v,diferr : in out Standard_Floating_Vectors.Vector;
                  error : in out double_float );

  -- DESCRIPTION :
  --   Higher-order extrapolation method that produces direction with an error
  --   of the order (t-target)^r, when the solution path converges to a regular
  --   solution  in affine space.

  -- REQUIRED : s'range = logs'range = logx'range = 0..max,
  --   wvl'range = 1..max, logx(i)'range = wvl'range(i) = 1..n,
  --   diferr'range = 0..max, max >= 1, equals maximal order of extrapolator.

  -- ON ENTRY :
  --   file       to write intermediate data, if not submitted, no output;
  --   r          last meaningful entry in logx and logs;
  --   m          current value for multiplicity;
  --   estm       current estimate for multiplicity;
  --   cntm       number of consecutive times estm has been guessed;
  --   thresm     threshold for changing the m to estm;
  --   er         order of extrapolator on the errors;
  --   t          current value of continuation parameter;
  --   target     target value of continuation parameter;
  --   x          current solution for t;
  --   dt         consecutive distances of t-values to target value;
  --   s          consecutive s-values, with proper value for m;
  --   logs       logarithms of previous values (target - t);
  --   logx       logarithms of previous solution vectors;
  --   wvl0       previous consecutive estimates for direction;
  --   wvl1       current consecutive estimates for direction;
  --   wvltmp     work space for updating wvl0 and wvl1.

  -- ON RETURN :
  --   r          if r < logs'last, then r will be raised by one,
  --              otherwise r remains unchanged;
  --   s          updated distance vector;
  --   logs       updated vector of logarithms of distances to target;
  --   logx       updated vector of solution vectors;
  --   wvl0       updated previous consecutive estimates, equals wvl1;
  --   wvl1       updated current consecutive estimates for direction;
  --   v          estimated direction of path;
  --   diferr     norms of consecutive differences of estimates for v;
  --   error      norm of errorv;

  procedure Projective_Update_Direction
                ( r,m,estm : in out integer32;
                  cntm : in out natural32; thresm : in natural32;
                  er : in out integer32; t,target : in Complex_Number;
                  x : in Standard_Complex_Vectors.Vector;
                  dt,s,logs : in out Standard_Floating_Vectors.Vector;
                  logx : in out Standard_Floating_VecVecs.VecVec;
                  prevv,v : in out Standard_Floating_Vectors.Vector;
                  error : in out double_float );

  procedure Projective_Update_Direction
                ( file : in file_type;
                  r,m,estm : in out integer32;
                  cntm : in out natural32; thresm : in natural32;
                  er : in out integer32; t,target : in Complex_Number;
                  x : in Standard_Complex_Vectors.Vector;
                  dt,s,logs : in out Standard_Floating_Vectors.Vector;
                  logx : in out Standard_Floating_VecVecs.VecVec;
                  prevv,v : in out Standard_Floating_Vectors.Vector;
                  error : in out double_float );

  -- DESCRIPTION :
  --   Higher-order extrapolation method that produces direction with error
  --   of order (t-target)^r, when the solution path converges to a regular 
  --   solution in affine space.

  -- REQUIRED :
  --   x(x'last) contains value of variable introduced to homogenize the system.

end Directions_of_Standard_Paths;
