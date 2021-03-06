with Quad_Double_Numbers;               use Quad_Double_Numbers;
with Quad_Double_Numbers_io;            use Quad_Double_Numbers_io;
with QuadDobl_Complex_Numbers;          use QuadDobl_Complex_Numbers;
with Write_Factors;                     use Write_Factors;
with QuadDobl_Polynomial_Convertors;    use QuadDobl_Polynomial_Convertors;
with Multprec_Complex_Polynomials;
with Multprec_Complex_Polynomials_io;

package body QuadDobl_Complex_Polynomials_io is

  procedure get ( p : in out Poly ) is
  begin
    get(standard_input,p);
  end get;

  procedure get ( file : in file_type; p : in out Poly ) is

    mp : Multprec_Complex_Polynomials.Poly;

  begin
    Multprec_Complex_Polynomials_io.Set_Working_Precision(10);
    Multprec_Complex_Polynomials_io.get(file,mp);
    p := Multprec_Polynomial_to_QuadDobl_Complex(mp);
    Multprec_Complex_Polynomials.Clear(mp);
  end get;

-- AUXILIARIES FOR OUTPUT ROUTINES :

  procedure Write_Number ( file : in file_type; c : in Complex_Number ) is

  -- DESCRIPTION :
  --   Writes the double double complex number to file
  --   in the format ( real_part(c) + imag_part(c)*I ).

    re : constant quad_double := REAL_PART(c);
    im : constant quad_double := IMAG_PART(c);

  begin
    put(file,"+ ("); put(file,re);
    if im >= 0.0
     then put(file,"+");
    end if;
    put(file,im);
    put(file,"*I)");
  end Write_Number;

-- THE OUTPUT OPERATIONS :

  procedure put ( p : in Poly ) is
  begin
    put_line(standard_output,p);
  end put;
 
  procedure put ( file : in file_type; p : in Poly ) is
  begin
    put_line(file,p);
  end put;

  procedure put ( p : in Poly; dp : in natural32 ) is
  begin
    put(Standard_Output,p,dp);
  end put;

  procedure put ( file : in file_type; p : in Poly; dp : in natural32 ) is
  begin
    put(file,p);
  end put;

  procedure put_line ( p : in Poly ) is
  begin
    put_line(standard_output,p);
  end put_line;

  procedure put_line ( file : in file_type; p : in Poly ) is

    n : constant natural32 := Number_of_Unknowns(p);
    standard : constant boolean := ( Symbol_Table.Number < n );

    procedure Write_Term ( t : in Term; continue : out boolean ) is
 
    -- DESCRIPTION : 
    --   Writes a term to file.

      sumtdg : natural32 := 0;

    begin
      new_line(file);
      Write_Number(file,t.cf);
      for i in t.dg'range loop
        sumtdg := sumtdg + t.dg(i);
      end loop;
      if sumtdg /= 0 then -- if Sum(t.dg) /= 0 then
        for i in t.dg'range loop
          if t.dg(i) > 0 then
            put(file,'*');
            Write_Factor(file,t.dg(i),natural32(i),standard,'^');
          end if;
        end loop;
      end if;
      continue := true;
    end Write_Term;
    procedure Write_Terms is new Visiting_Iterator(Write_Term);

  begin
    Write_Terms(p);
    put_line(file,";");
  end put_line;

  procedure put_line ( p : in Poly; s : in Array_of_Symbols ) is
  begin
    put_line(standard_output,p,s);
  end put_line;

  procedure put_line ( file : in file_type; p : in Poly;
                       s : in Array_of_Symbols ) is

    procedure Write_Term ( t : in Term; continue : out boolean ) is
 
    -- DESCRIPTION : 
    --   Writes a term to file.

      sumtdg : natural32 := 0;

    begin
      new_line(file);
      Write_Number(file,t.cf);
      for i in t.dg'range loop
        sumtdg := sumtdg + t.dg(i);
      end loop;
      if sumtdg /= 0 then -- if Sum(t.dg) /= 0 then
        for i in t.dg'range loop
          if t.dg(i) > 0 then
            put(file,'*');
            Write_Factor(file,t.dg(i),s(i),'^');
          end if;
        end loop;
      end if;
      continue := true;
    end Write_Term;
    procedure Write_Terms is new Visiting_Iterator(Write_Term);

  begin
    Write_Terms(p);
    put_line(file,";");
  end put_line;

  procedure put ( p : in Poly; s : in Array_of_Symbols ) is
  begin
    put(standard_output,p,s);
  end put;

  procedure put ( file : in file_type;
                  p : in Poly; s : in Array_of_Symbols ) is
  begin
    put_line(file,p,s);
  end put;

end QuadDobl_Complex_Polynomials_io;
