with Double_Double_Numbers;              use Double_Double_Numbers;
with DoblDobl_Dense_Series;              use DoblDobl_Dense_Series;
with DoblDobl_Dense_Series_Vectors;      use DoblDobl_Dense_Series_Vectors;

package DoblDobl_Series_Vector_Norms is

-- DESCRIPTION :
--   The norm of a vector of series with complex coefficients is defined
--   via the inner product of the conjugate vector.

  function Conjugate ( v : Vector ) return Vector;

  -- DESCRIPTION :
  --   Returns the vector where every entry is the conjugate
  --   of the corresponding entry in v.

  function Inner_Product ( u,v : Vector ) return Series;

  -- DESCRIPTION :
  --   Returns the inner product of the conjugate of u with v.

  function Square_of_Norm ( v : Vector ) return Series;

  -- DESCRIPTION :
  --   Returns the inner product of the conjugate of v with v.
  --   This defines the square of the norm of the vector.

  function Norm ( v : Vector ) return Series;

  -- DESCRIPTION :
  --   Returns the square root of the Square_of_Norm(v).

  procedure Normalize ( v : in out Vector );

  -- DESCRIPTION :
  --   Divides the vector v by Norm(v) so on return Norm(v) = 1.

  function Normalize ( v : Vector ) return Vector;

  -- DESCRIPTION :
  --   Returns the normalized vector of v.

  function Max_Norm ( v : Vector ) return double_double;

  -- DESCRIPTION :
  --   The max norm of a vector is the maximum over all the max norms
  --   of its components.  Useful to test if a vector is zero or not.

end DoblDobl_Series_Vector_Norms;
