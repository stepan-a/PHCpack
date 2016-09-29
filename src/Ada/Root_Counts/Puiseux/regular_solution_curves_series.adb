with Communications_with_User;           use Communications_with_User;
with Standard_Natural_Numbers_io;        use Standard_Natural_Numbers_io;
with Standard_Integer_Numbers_io;        use Standard_Integer_Numbers_io;
with Standard_Floating_Numbers_io;       use Standard_Floating_Numbers_io;
with Standard_Complex_Numbers;
with DoblDobl_Complex_Numbers;
with QuadDobl_Complex_Numbers;
with Standard_Integer_Vectors_io;        use Standard_Integer_Vectors_io;
with Standard_Complex_Vector_Norms;      use Standard_Complex_Vector_Norms;
with Arrays_of_Integer_Vector_Lists_io;  use Arrays_of_Integer_Vector_Lists_io;
with Standard_Complex_Laurentials_io;    use Standard_Complex_Laurentials_io;
with DoblDobl_Complex_Laurentials_io;    use DoblDobl_Complex_Laurentials_io;
with QuadDobl_Complex_Laurentials_io;    use QuadDobl_Complex_Laurentials_io;
with Standard_Complex_Laur_Systems_io;   use Standard_Complex_Laur_Systems_io;
with Standard_Complex_Laur_SysFun;       use Standard_Complex_Laur_SysFun;
with Standard_Laur_Poly_Convertors;      use Standard_Laur_Poly_Convertors;
with DoblDobl_Complex_Laur_Systems_io;   use DoblDobl_Complex_Laur_Systems_io;
with DoblDobl_Complex_Laur_SysFun;       use DoblDobl_Complex_Laur_SysFun;
with QuadDobl_Complex_Laur_Systems_io;   use QuadDobl_Complex_Laur_Systems_io;
with QuadDobl_Complex_Laur_SysFun;       use QuadDobl_Complex_Laur_SysFun;
with Standard_Complex_Solutions_io;      use Standard_Complex_Solutions_io;
with DoblDobl_Complex_Solutions_io;      use DoblDobl_Complex_Solutions_io;
with QuadDobl_Complex_Solutions_io;      use QuadDobl_Complex_Solutions_io;
with Supports_of_Polynomial_Systems;     use Supports_of_Polynomial_Systems;
with Drivers_for_Static_Lifting;         use Drivers_for_Static_Lifting;
with Black_Box_Solvers;                  use Black_Box_Solvers;
with Standard_Dense_Series;
with Standard_Dense_Series_Vectors;
with Series_and_Polynomials;
with Series_and_Polynomials_io;
with Standard_Newton_Matrix_Series;

package body Regular_Solution_Curves_Series is

  procedure Mixed_Cell_Tropisms
              ( report : in boolean;
                sup : in out Array_of_Lists;
                mcc : out Mixed_Subdivision;
                mv : out natural32 ) is

    dim : constant integer32 := sup'last;
    mix : Standard_Integer_Vectors.Vector(1..dim);

  begin
    if report
     then put_line("The supports : "); put(sup);
    end if;
    mix := (mix'range => 1);
    if report then
      Integer_Create_Mixed_Cells(standard_output,dim,mix,false,sup,mcc);
      Integer_Volume_Computation(standard_output,dim,mix,true,sup,mcc,mv);
    else
      Integer_Create_Mixed_Cells(dim,mix,sup,mcc);
      Integer_Volume_Computation(dim,mix,true,sup,mcc,mv);
    end if;
  end Mixed_Cell_Tropisms;

  procedure Mixed_Cell_Tropisms
              ( file : in file_type;
                sup : in out Array_of_Lists;
                mcc : out Mixed_Subdivision;
                mv : out natural32 ) is

    dim : constant integer32 := sup'last;
    mix : Standard_Integer_Vectors.Vector(1..dim);

  begin
    new_line(file);
    put_line(file,"THE SUPPORTS : ");
    put(file,sup);
    mix := (mix'range => 1);
    Integer_Create_Mixed_Cells(file,dim,mix,false,sup,mcc);
    Integer_Volume_Computation(file,dim,mix,true,sup,mcc,mv);
  end Mixed_Cell_Tropisms;

  procedure Initial_Coefficients
              ( file : in file_type;
                p : in Standard_Complex_Laur_Systems.Laur_Sys;
                mic : in Mixed_Cell;
                psub : out Standard_Complex_Laur_Systems.Laur_Sys;
                sols : out Standard_Complex_Solutions.Solution_List ) is

    use Standard_Complex_Numbers;
    use Standard_Complex_Solutions;

    q : Standard_Complex_Laur_Systems.Laur_Sys(p'range)
      := Select_Terms(p,mic.pts.all);
    idx : constant integer32 := p'last+1;
    one : constant Complex_Number := Create(1.0);
    rc : natural32;

  begin
    put_line(file,"The initial form system with t :"); put(file,q);
    psub := Eval(q,one,idx);
    put_line(file,"The initial form system with t = 1 :"); put(file,psub);
    Solve(psub,false,rc,sols);
    put(file,"Computed ");
    put(file,Length_Of(sols),1); put_line(file," solutions.");
    put(file,Length_Of(sols),natural32(Head_Of(sols).n),sols);
  end Initial_Coefficients;

  procedure Initial_Coefficients
              ( p : in Standard_Complex_Laur_Systems.Laur_Sys;
                mic : in Mixed_Cell;
                psub : out Standard_Complex_Laur_Systems.Laur_Sys;
                sols : out Standard_Complex_Solutions.Solution_List;
                report : in boolean ) is

    use Standard_Complex_Numbers;
    use Standard_Complex_Solutions;

    q : Standard_Complex_Laur_Systems.Laur_Sys(p'range)
      := Select_Terms(p,mic.pts.all);
    idx : constant integer32 := p'last+1;
    one : constant Complex_Number := Create(1.0);
    rc : natural32;

  begin
    if report then
      put_line("The initial form system with t :"); put(q);
    end if;
    psub := Eval(q,one,idx);
    if report then
      put_line("The initial form system with t = 1 :"); put(psub);
    end if;
    Solve(psub,false,rc,sols);
    if report then
      put("Computed "); put(Length_Of(sols),1); put_line(" solutions.");
      put(standard_output,Length_Of(sols),natural32(Head_Of(sols).n),sols);
    end if;
  end Initial_Coefficients;

  procedure Initial_Coefficients
              ( file : in file_type;
                p : in DoblDobl_Complex_Laur_Systems.Laur_Sys;
                mic : in Mixed_Cell;
                psub : out DoblDobl_Complex_Laur_Systems.Laur_Sys;
                sols : out DoblDobl_Complex_Solutions.Solution_List ) is

    use DoblDobl_Complex_Numbers;
    use DoblDobl_Complex_Solutions;

    q : DoblDobl_Complex_Laur_Systems.Laur_Sys(p'range)
      := Select_Terms(p,mic.pts.all);
    idx : constant integer32 := p'last+1;
    one : constant Complex_Number := Create(integer32(1));
    rc : natural32;

  begin
    put_line(file,"The initial form system with t :"); put(file,q);
    psub := Eval(q,one,idx);
    put_line(file,"The initial form system with t = 1 :"); put(file,psub);
    Solve(psub,false,rc,sols);
    put(file,"Computed ");
    put(file,Length_Of(sols),1); put_line(file," solutions.");
    put(file,Length_Of(sols),natural32(Head_Of(sols).n),sols);
  end Initial_Coefficients;

  procedure Initial_Coefficients
              ( p : in DoblDobl_Complex_Laur_Systems.Laur_Sys;
                mic : in Mixed_Cell;
                psub : out DoblDobl_Complex_Laur_Systems.Laur_Sys;
                sols : out DoblDobl_Complex_Solutions.Solution_List;
                report : in boolean ) is

    use DoblDobl_Complex_Numbers;
    use DoblDobl_Complex_Solutions;

    q : DoblDobl_Complex_Laur_Systems.Laur_Sys(p'range)
      := Select_Terms(p,mic.pts.all);
    idx : constant integer32 := p'last+1;
    one : constant Complex_Number := Create(integer32(1));
    rc : natural32;

  begin
    if report then
      put_line("The initial form system with t :"); put(q);
    end if;
    psub := Eval(q,one,idx);
    if report then
      put_line("The initial form system with t = 1 :"); put(psub);
    end if;
    Solve(psub,false,rc,sols);
    if report then
      put("Computed "); put(Length_Of(sols),1); put_line(" solutions.");
      put(standard_output,Length_Of(sols),natural32(Head_Of(sols).n),sols);
    end if;
  end Initial_Coefficients;

  procedure Initial_Coefficients
              ( file : in file_type;
                p : in QuadDobl_Complex_Laur_Systems.Laur_Sys;
                mic : in Mixed_Cell;
                psub : out QuadDobl_Complex_Laur_Systems.Laur_Sys;
                sols : out QuadDobl_Complex_Solutions.Solution_List ) is

    use QuadDobl_Complex_Numbers;
    use QuadDobl_Complex_Solutions;

    q : QuadDobl_Complex_Laur_Systems.Laur_Sys(p'range)
      := Select_Terms(p,mic.pts.all);
    idx : constant integer32 := p'last+1;
    one : constant Complex_Number := Create(integer32(1));
    rc : natural32;

  begin
    put_line(file,"The initial form system with t :"); put(file,q);
    psub := Eval(q,one,idx);
    put_line(file,"The initial form system with t = 1 :"); put(file,psub);
    Solve(psub,false,rc,sols);
    put(file,"Computed ");
    put(file,Length_Of(sols),1); put_line(file," solutions.");
    put(file,Length_Of(sols),natural32(Head_Of(sols).n),sols);
  end Initial_Coefficients;

  procedure Initial_Coefficients
              ( p : in QuadDobl_Complex_Laur_Systems.Laur_Sys;
                mic : in Mixed_Cell;
                psub : out QuadDobl_Complex_Laur_Systems.Laur_Sys;
                sols : out QuadDobl_Complex_Solutions.Solution_List;
                report : in boolean ) is

    use QuadDobl_Complex_Numbers;
    use QuadDobl_Complex_Solutions;

    q : QuadDobl_Complex_Laur_Systems.Laur_Sys(p'range)
      := Select_Terms(p,mic.pts.all);
    idx : constant integer32 := p'last+1;
    one : constant Complex_Number := Create(integer32(1));
    rc : natural32;

  begin
    if report then
      put_line("The initial form system with t :"); put(q);
    end if;
    psub := Eval(q,one,idx);
    if report then
      put_line("The initial form system with t = 1 :"); put(psub);
    end if;
    Solve(psub,false,rc,sols);
    if report then
      put("Computed "); put(Length_Of(sols),1); put_line(" solutions.");
      put(standard_output,Length_Of(sols),natural32(Head_Of(sols).n),sols);
    end if;
  end Initial_Coefficients;

  procedure Shift ( file : in file_type;
                    p : in out Standard_Complex_Laurentials.Poly ) is

    use Standard_Complex_Laurentials;

    mindeg : constant Degrees := Minimal_Degrees(p);
    t : Term;

  begin
    put(file,"The minimal degrees : ");
    put(file,Standard_Integer_Vectors.Vector(mindeg.all));
    new_line(file);
    put_line(file,"The polynomial before the shift :");
    put(file,p); new_line(file);
    t.cf := Standard_Complex_Numbers.Create(1.0);
    t.dg := new Standard_Integer_Vectors.Vector(mindeg'range);
    for i in mindeg'range loop
      t.dg(i) := -mindeg(i);
    end loop;
    Mul(p,t);
    put_line(file,"The polynomial after the shift :");
    put(file,p); new_line(file);
  end Shift;

  procedure Shift ( file : in file_type;
                    p : in out DoblDobl_Complex_Laurentials.Poly ) is

    use DoblDobl_Complex_Laurentials;

    mindeg : constant Degrees := Minimal_Degrees(p);
    t : Term;

  begin
    put(file,"The minimal degrees : ");
    put(file,Standard_Integer_Vectors.Vector(mindeg.all));
    new_line(file);
    put_line(file,"The polynomial before the shift :");
    put(file,p); new_line(file);
    t.cf := DoblDobl_Complex_Numbers.Create(integer32(1));
    t.dg := new Standard_Integer_Vectors.Vector(mindeg'range);
    for i in mindeg'range loop
      t.dg(i) := -mindeg(i);
    end loop;
    Mul(p,t);
    put_line(file,"The polynomial after the shift :");
    put(file,p); new_line(file);
  end Shift;

  procedure Shift ( file : in file_type;
                    p : in out QuadDobl_Complex_Laurentials.Poly ) is

    use QuadDobl_Complex_Laurentials;

    mindeg : constant Degrees := Minimal_Degrees(p);
    t : Term;

  begin
    put(file,"The minimal degrees : ");
    put(file,Standard_Integer_Vectors.Vector(mindeg.all));
    new_line(file);
    put_line(file,"The polynomial before the shift :");
    put(file,p); new_line(file);
    t.cf := QuadDobl_Complex_Numbers.Create(integer32(1));
    t.dg := new Standard_Integer_Vectors.Vector(mindeg'range);
    for i in mindeg'range loop
      t.dg(i) := -mindeg(i);
    end loop;
    Mul(p,t);
    put_line(file,"The polynomial after the shift :");
    put(file,p); new_line(file);
  end Shift;

  procedure Shift ( p : in out Standard_Complex_Laurentials.Poly;
                    verbose : in boolean ) is

    use Standard_Complex_Laurentials;

    mindeg : constant Degrees := Minimal_Degrees(p);
    t : Term;

  begin
    if verbose then
      put("The minimal degrees : ");
      put(Standard_Integer_Vectors.Vector(mindeg.all)); new_line;
      put_line("The polynomial before the shift :");
      put(p); new_line;
    end if;
    t.cf := Standard_Complex_Numbers.Create(1.0);
    t.dg := new Standard_Integer_Vectors.Vector(mindeg'range);
    for i in mindeg'range loop
      t.dg(i) := -mindeg(i);
    end loop;
    Mul(p,t);
    if verbose then
      put_line("The polynomial after the shift :");
      put(p); new_line;
    end if;
  end Shift;

  procedure Shift ( p : in out DoblDobl_Complex_Laurentials.Poly;
                    verbose : in boolean ) is

    use DoblDobl_Complex_Laurentials;

    mindeg : constant Degrees := Minimal_Degrees(p);
    t : Term;

  begin
    if verbose then
      put("The minimal degrees : ");
      put(Standard_Integer_Vectors.Vector(mindeg.all)); new_line;
      put_line("The polynomial before the shift :");
      put(p); new_line;
    end if;
    t.cf := DoblDobl_Complex_Numbers.Create(integer32(1));
    t.dg := new Standard_Integer_Vectors.Vector(mindeg'range);
    for i in mindeg'range loop
      t.dg(i) := -mindeg(i);
    end loop;
    Mul(p,t);
    if verbose then
      put_line("The polynomial after the shift :");
      put(p); new_line;
    end if;
  end Shift;

  procedure Shift ( p : in out QuadDobl_Complex_Laurentials.Poly;
                    verbose : in boolean ) is

    use QuadDobl_Complex_Laurentials;

    mindeg : constant Degrees := Minimal_Degrees(p);
    t : Term;

  begin
    if verbose then
      put("The minimal degrees : ");
      put(Standard_Integer_Vectors.Vector(mindeg.all)); new_line;
      put_line("The polynomial before the shift :");
      put(p); new_line;
    end if;
    t.cf := QuadDobl_Complex_Numbers.Create(integer32(1));
    t.dg := new Standard_Integer_Vectors.Vector(mindeg'range);
    for i in mindeg'range loop
      t.dg(i) := -mindeg(i);
    end loop;
    Mul(p,t);
    if verbose then
      put_line("The polynomial after the shift :");
      put(p); new_line;
    end if;
  end Shift;

  procedure Shift ( file : in file_type;
                    p : in out Standard_Complex_Laur_Systems.Laur_Sys ) is
  begin
    for i in p'range loop
      Shift(file,p(i));
    end loop;
  end Shift;

  procedure Shift ( file : in file_type;
                    p : in out DoblDobl_Complex_Laur_Systems.Laur_Sys ) is
  begin
    for i in p'range loop
      Shift(file,p(i));
    end loop;
  end Shift;

  procedure Shift ( file : in file_type;
                    p : in out QuadDobl_Complex_Laur_Systems.Laur_Sys ) is
  begin
    for i in p'range loop
      Shift(file,p(i));
    end loop;
  end Shift;

  procedure Shift ( p : in out Standard_Complex_Laur_Systems.Laur_Sys;
                    verbose : in boolean ) is
  begin
    for i in p'range loop
      Shift(p(i),verbose);
    end loop;
  end Shift;

  procedure Shift ( p : in out DoblDobl_Complex_Laur_Systems.Laur_Sys;
                    verbose : in boolean ) is
  begin
    for i in p'range loop
      Shift(p(i),verbose);
    end loop;
  end Shift;

  procedure Shift ( p : in out QuadDobl_Complex_Laur_Systems.Laur_Sys;
                    verbose : in boolean ) is
  begin
    for i in p'range loop
      Shift(p(i),verbose);
    end loop;
  end Shift;

  function Transform ( d,v : Standard_Integer_Vectors.Vector )
                     return Standard_Integer_Vectors.Vector is

    res : Standard_Integer_Vectors.Vector(d'range);

  begin
    res(res'last) := 0;
    for k in res'range loop
      res(res'last) := res(res'last) + v(k)*d(k);
    end loop;
    return res;
  end Transform;

  function Transform ( t : Standard_Complex_Laurentials.Term;
                       v : Standard_Integer_Vectors.Vector )
                     return Standard_Complex_Laurentials.Term is

    res : Standard_Complex_Laurentials.Term;
    rdg : Standard_Integer_Vectors.Vector(t.dg'range)
        := Transform(Standard_Integer_Vectors.Vector(t.dg.all),v);

  begin
    res.cf := t.cf;
    res.dg := new Standard_Integer_Vectors.Vector'(rdg);
    return res;
  end Transform;

  function Transform ( t : DoblDobl_Complex_Laurentials.Term;
                       v : Standard_Integer_Vectors.Vector )
                     return DoblDobl_Complex_Laurentials.Term is

    res : DoblDobl_Complex_Laurentials.Term;
    rdg : Standard_Integer_Vectors.Vector(t.dg'range)
        := Transform(Standard_Integer_Vectors.Vector(t.dg.all),v);

  begin
    res.cf := t.cf;
    res.dg := new Standard_Integer_Vectors.Vector'(rdg);
    return res;
  end Transform;

  function Transform ( t : QuadDobl_Complex_Laurentials.Term;
                       v : Standard_Integer_Vectors.Vector )
                     return QuadDobl_Complex_Laurentials.Term is

    res : QuadDobl_Complex_Laurentials.Term;
    rdg : Standard_Integer_Vectors.Vector(t.dg'range)
        := Transform(Standard_Integer_Vectors.Vector(t.dg.all),v);

  begin
    res.cf := t.cf;
    res.dg := new Standard_Integer_Vectors.Vector'(rdg);
    return res;
  end Transform;

  function Transform ( p : Standard_Complex_Laurentials.Poly;
                       v : Standard_Integer_Vectors.Vector )
                     return Standard_Complex_Laurentials.Poly is

    res : Standard_Complex_Laurentials.Poly
        := Standard_Complex_Laurentials.Null_Poly;

    procedure Monomial ( t : in Standard_Complex_Laurentials.Term;
                         c : out boolean ) is
   
      rt : Standard_Complex_Laurentials.Term := Transform(t,v);

    begin
      Standard_Complex_Laurentials.Add(res,rt);
      c := true;
    end Monomial;
    procedure Monomials is
      new Standard_Complex_Laurentials.Visiting_Iterator(Monomial);

  begin
    Monomials(p);
    return res;
  end Transform;

  function Transform ( p : DoblDobl_Complex_Laurentials.Poly;
                       v : Standard_Integer_Vectors.Vector )
                     return DoblDobl_Complex_Laurentials.Poly is

    res : DoblDobl_Complex_Laurentials.Poly
        := DoblDobl_Complex_Laurentials.Null_Poly;

    procedure Monomial ( t : in DoblDobl_Complex_Laurentials.Term;
                         c : out boolean ) is
   
      rt : DoblDobl_Complex_Laurentials.Term := Transform(t,v);

    begin
      DoblDobl_Complex_Laurentials.Add(res,rt);
      c := true;
    end Monomial;
    procedure Monomials is
      new DoblDobl_Complex_Laurentials.Visiting_Iterator(Monomial);

  begin
    Monomials(p);
    return res;
  end Transform;

  function Transform ( p : QuadDobl_Complex_Laurentials.Poly;
                       v : Standard_Integer_Vectors.Vector )
                     return QuadDobl_Complex_Laurentials.Poly is

    res : QuadDobl_Complex_Laurentials.Poly
        := QuadDobl_Complex_Laurentials.Null_Poly;

    procedure Monomial ( t : in QuadDobl_Complex_Laurentials.Term;
                         c : out boolean ) is
   
      rt : QuadDobl_Complex_Laurentials.Term := Transform(t,v);

    begin
      QuadDobl_Complex_Laurentials.Add(res,rt);
      c := true;
    end Monomial;
    procedure Monomials is
      new QuadDobl_Complex_Laurentials.Visiting_Iterator(Monomial);

  begin
    Monomials(p);
    return res;
  end Transform;

  function Transform ( p : Standard_Complex_Laur_Systems.Laur_Sys;
                       v : Standard_Integer_Vectors.Vector )
                     return Standard_Complex_Laur_Systems.Laur_Sys is

    res : Standard_Complex_Laur_Systems.Laur_Sys(p'range);

  begin
    for k in p'range loop
      res(k) := Transform(p(k),v);
    end loop;
    return res;
  end Transform;

  function Transform ( p : DoblDobl_Complex_Laur_Systems.Laur_Sys;
                       v : Standard_Integer_Vectors.Vector )
                     return DoblDobl_Complex_Laur_Systems.Laur_Sys is

    res : DoblDobl_Complex_Laur_Systems.Laur_Sys(p'range);

  begin
    for k in p'range loop
      res(k) := Transform(p(k),v);
    end loop;
    return res;
  end Transform;

  function Transform ( p : QuadDobl_Complex_Laur_Systems.Laur_Sys;
                       v : Standard_Integer_Vectors.Vector )
                     return QuadDobl_Complex_Laur_Systems.Laur_Sys is

    res : QuadDobl_Complex_Laur_Systems.Laur_Sys(p'range);

  begin
    for k in p'range loop
      res(k) := Transform(p(k),v);
    end loop;
    return res;
  end Transform;

  procedure Transform_Coordinates
              ( file : in file_type;
                p : in Standard_Complex_Laur_Systems.Laur_Sys;
                v : in Standard_Integer_Vectors.Vector;
                q : out Standard_Complex_Laur_Systems.Laur_Sys ) is
  begin
    q := Transform(p,v);
    Shift(q,false);
    put_line(file,"The transformed system : "); put_line(file,q);
  end Transform_Coordinates;

  procedure Transform_Coordinates
              ( file : in file_type;
                p : in DoblDobl_Complex_Laur_Systems.Laur_Sys;
                v : in Standard_Integer_Vectors.Vector;
                q : out DoblDobl_Complex_Laur_Systems.Laur_Sys ) is
  begin
    q := Transform(p,v);
    Shift(q,false);
    put_line(file,"The transformed system : "); put_line(file,q);
  end Transform_Coordinates;

  procedure Transform_Coordinates
              ( file : in file_type;
                p : in QuadDobl_Complex_Laur_Systems.Laur_Sys;
                v : in Standard_Integer_Vectors.Vector;
                q : out QuadDobl_Complex_Laur_Systems.Laur_Sys ) is
  begin
    q := Transform(p,v);
    Shift(q,false);
    put_line(file,"The transformed system : "); put_line(file,q);
  end Transform_Coordinates;

  procedure Transform_Coordinates
              ( p : in Standard_Complex_Laur_Systems.Laur_Sys;
                v : in Standard_Integer_Vectors.Vector;
                q : out Standard_Complex_Laur_Systems.Laur_Sys;
                report : in boolean ) is
  begin
    q := Transform(p,v);
    Shift(q,false);
    if report then
      put_line("The transformed system : "); put_line(q);
    end if;
  end Transform_Coordinates;

  procedure Transform_Coordinates
              ( p : in DoblDobl_Complex_Laur_Systems.Laur_Sys;
                v : in Standard_Integer_Vectors.Vector;
                q : out DoblDobl_Complex_Laur_Systems.Laur_Sys;
                report : in boolean ) is
  begin
    q := Transform(p,v);
    Shift(q,false);
    if report then
      put_line("The transformed system : "); put_line(q);
    end if;
  end Transform_Coordinates;

  procedure Transform_Coordinates
              ( p : in QuadDobl_Complex_Laur_Systems.Laur_Sys;
                v : in Standard_Integer_Vectors.Vector;
                q : out QuadDobl_Complex_Laur_Systems.Laur_Sys;
                report : in boolean ) is
  begin
    q := Transform(p,v);
    Shift(q,false);
    if report then
      put_line("The transformed system : "); put_line(q);
    end if;
  end Transform_Coordinates;

  function Initial_Residual
              ( p : in Standard_Complex_Laur_Systems.Laur_Sys;
                sol : in Standard_Complex_Vectors.Vector )
              return double_float is

    res : double_float := 0.0;
    ext : Standard_Complex_Vectors.Vector(sol'first..sol'last+1);
    eva : Standard_Complex_Vectors.Vector(p'range);

  begin
    ext(sol'range) := sol;
    ext(sol'last+1) := Standard_Complex_Numbers.Create(0.0);
    eva := Eval(p,ext);
    res := Norm2(eva);
    return res;
  end Initial_Residual;

  function Initial_Residuals
              ( file : in file_type;
                p : in Standard_Complex_Laur_Systems.Laur_Sys;
                sols : in Standard_Complex_Solutions.Solution_List )
              return double_float is

    use Standard_Complex_Solutions;

    res : double_float := 0.0;
    eva : double_float;
    tmp : Solution_List := sols;
    ls : Link_to_Solution;
 
  begin
    for k in 1..Length_Of(tmp) loop
      ls := Head_Of(tmp);
      eva := Initial_Residual(p,ls.v);
      put(file,"At solution "); put(file,k,1);
      put(file," : "); put(file,eva); new_line(file);
      res := res + eva;
      tmp := Tail_Of(tmp);
    end loop;
    return res;
  end Initial_Residuals;

  function Initial_Residuals
              ( p : in Standard_Complex_Laur_Systems.Laur_Sys;
                sols : in Standard_Complex_Solutions.Solution_List;
                report : in boolean ) return double_float is

    use Standard_Complex_Solutions;

    res : double_float := 0.0;
    eva : double_float;
    tmp : Solution_List := sols;
    ls : Link_to_Solution;
 
  begin
    for k in 1..Length_Of(tmp) loop
      ls := Head_Of(tmp);
      eva := Initial_Residual(p,ls.v);
      if report then
        put("At solution "); put(k,1);
        put(" : "); put(eva); new_line;
      end if;
      res := res + eva;
      tmp := Tail_Of(tmp);
    end loop;
    return res;
  end Initial_Residuals;

  procedure Initial
              ( file : in file_type;
                p : in Standard_Complex_Laur_Systems.Laur_Sys;
                mic : in Mixed_Cell;
                tsq : out Standard_Complex_Poly_Systems.Poly_Sys;
                sols : out Standard_Complex_Solutions.Solution_List ) is

    psub,tvp : Standard_Complex_Laur_Systems.Laur_Sys(p'range);
    res : double_float;

  begin
    put(file,"-> pretropism ");
    put(file,mic.nor); new_line(file);
    Initial_Coefficients(file,p,mic,psub,sols);
    Transform_Coordinates(file,p,mic.nor.all,tvp);
    res := Initial_Residuals(file,tvp,sols);
    put(file,"The residual :"); put(file,res,3); new_line(file);
    tsq := Positive_Laurent_Polynomial_System(tvp);
  end Initial;

  procedure Initial
              ( p : in Standard_Complex_Laur_Systems.Laur_Sys;
                mic : in Mixed_Cell;
                tsq : out Standard_Complex_Poly_Systems.Poly_Sys;
                sols : out Standard_Complex_Solutions.Solution_List;
                report : in boolean ) is

    psub,tvp : Standard_Complex_Laur_Systems.Laur_Sys(p'range);
    res : double_float;

  begin
    if report then
      put("-> pretropism "); put(mic.nor); new_line;
    end if;
    Initial_Coefficients(p,mic,psub,sols,report);
    Transform_Coordinates(p,mic.nor.all,tvp,report);
    res := Initial_Residuals(tvp,sols,report);
    if report then
      put("The residual :"); put(res,3); new_line;
    end if;
    tsq := Positive_Laurent_Polynomial_System(tvp);
  end Initial;

  procedure Series
              ( file : in file_type;
                p : in Standard_Series_Poly_Systems.Poly_Sys;
                xt0 : in Standard_Complex_Vectors.Vector;
                nit : in integer32 ) is

    use Standard_Newton_Matrix_Series;

    s : Standard_Dense_Series_Vectors.Vector(p'range);
    info : integer32;
    deg : integer32 := 1; -- doubles in every step

  begin
    for i in s'range loop
      s(i) := Standard_Dense_Series.Create(xt0(i));
    end loop;
    LU_Newton_Steps(file,p,deg,nit,s,info);
    put_line(file,"The solution series : ");
    Series_and_Polynomials_io.put(file,s);
  end Series;

  procedure Series
              ( p : in Standard_Series_Poly_Systems.Poly_Sys;
                xt0 : in Standard_Complex_Vectors.Vector;
                nit : in integer32; report : in boolean ) is

    use Standard_Newton_Matrix_Series;

    s : Standard_Dense_Series_Vectors.Vector(p'range);
    info : integer32;
    deg : integer32 := 1; -- doubles in every step

  begin
    for i in s'range loop
      s(i) := Standard_Dense_Series.Create(xt0(i));
    end loop;
    if report then
      LU_Newton_Steps(standard_output,p,deg,nit,s,info);
      put_line("The solution series : ");
      Series_and_Polynomials_io.put(s);
    else
      LU_Newton_Steps(p,deg,nit,s,info);
    end if;
  end Series;

  procedure Series
              ( file : in file_type;
                p : in Standard_Complex_Poly_Systems.Poly_Sys;
                sols : in Standard_Complex_Solutions.Solution_List;
                nit : in integer32 ) is

    use Standard_Complex_Solutions;

    s : Standard_Series_Poly_Systems.Poly_Sys(p'range)
      := Series_and_Polynomials.System_to_Series_System(p,p'last+1);
    tmp : Solution_List := sols;
    ls : Link_to_Solution;

  begin
    while not Is_Null(tmp) loop
      ls := Head_Of(tmp);
      Series(file,s,ls.v,nit);
      tmp := Tail_Of(tmp);
    end loop;
  end Series;

  procedure Series
              ( p : in Standard_Complex_Poly_Systems.Poly_Sys;
                sols : in Standard_Complex_Solutions.Solution_List;
                nit : in integer32; report : in boolean ) is

    use Standard_Complex_Solutions;

    s : Standard_Series_Poly_Systems.Poly_Sys(p'range)
      := Series_and_Polynomials.System_to_Series_System(p,p'last+1);
    tmp : Solution_List := sols;
    ls : Link_to_Solution;

  begin
    while not Is_Null(tmp) loop
      ls := Head_Of(tmp);
      Series(s,ls.v,nit,report);
      tmp := Tail_Of(tmp);
    end loop;
  end Series;

  procedure Series
              ( file : in file_type;
                p : in Standard_Complex_Laur_Systems.Laur_Sys;
                mcc : in Mixed_Subdivision;
                nit : in integer32 ) is

    tmp : Mixed_Subdivision := mcc;
    mic : Mixed_Cell;

  begin
    for k in 1..Length_Of(mcc) loop
      mic := Head_Of(tmp);
      put(file,"Mixed cell "); put(file,k); put_line(file," :");
      declare
        q : Standard_Complex_Poly_Systems.Poly_Sys(p'range);
        qsols : Standard_Complex_Solutions.Solution_List;
      begin
        Initial(file,p,mic,q,qsols);
        Series(file,q,qsols,nit);
      end;
      tmp := Tail_Of(tmp);
    end loop;
  end Series;

  procedure Series
              ( p : in Standard_Complex_Laur_Systems.Laur_Sys;
                mcc : in Mixed_Subdivision;
                nit : in integer32; report : in boolean ) is

    tmp : Mixed_Subdivision := mcc;
    mic : Mixed_Cell;

  begin
    for k in 1..Length_Of(mcc) loop
      mic := Head_Of(tmp);
      if report then
        put("Mixed cell "); put(k); put_line(" :");
      end if;
      declare
        q : Standard_Complex_Poly_Systems.Poly_Sys(p'range);
        qsols : Standard_Complex_Solutions.Solution_List;
      begin
        Initial(p,mic,q,qsols,report);
        Series(q,qsols,nit,report);
      end;
      tmp := Tail_Of(tmp);
    end loop;
  end Series;

end Regular_Solution_Curves_Series;
