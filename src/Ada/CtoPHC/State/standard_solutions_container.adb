package body Standard_Solutions_Container is

-- INTERNAL DATA :

  first,last,current : Solution_List;
  ls1,ls2,solsym : Symbol_Table.Link_to_Array_of_Symbols;
  cursor : natural32 := 0; -- index to the current solution

-- OPERATIONS :

  procedure Initialize ( sols : in Solution_List ) is

    tmp : Solution_List := sols;
 
  begin
    for i in 1..Length_Of(sols) loop
      Append(first,last,Head_Of(tmp).all);
      tmp := Tail_Of(tmp);
    end loop;
    current := first;
    cursor := 1;
  end Initialize;

  function Length return natural32 is
  begin
    return Length_Of(first);
  end Length;

  function Dimension return natural32 is
  begin
    if Is_Null(first)
     then return 0;
     else return natural32(Head_Of(first).n);
    end if;
  end Dimension;

  function Retrieve return Solution_List is
  begin
    return first;
  end Retrieve;

  procedure Retrieve ( k : in natural32; s : out Solution;
                       fail : out boolean ) is

    ls : Link_to_Solution;

  begin
    Retrieve(k,ls,fail);
    if not fail
     then s := ls.all;
    end if;
  end Retrieve;

  procedure Retrieve ( k : in natural32; s : out Link_to_Solution;
                       fail : out boolean ) is

    tmp : Solution_List := first;
    cnt : natural32 := 0;

  begin
    while not Is_Null(tmp) loop
      cnt := cnt + 1;
      if cnt = k then
        fail := false;
        s := Head_Of(tmp);
        return;
      else
        tmp := Tail_Of(tmp);
      end if;
    end loop;
    fail := true;
  end Retrieve;

  procedure Retrieve_Next_Initialize is
  begin
    current := first;
    if Is_Null(current)
     then cursor := 0; -- empty solution list
     else cursor := 1; -- index to the first solution
    end if;
  end Retrieve_Next_Initialize;

  procedure Retrieve_Next ( s : out Link_to_Solution; k : out natural32 ) is
  begin
    if Is_Null(current) then
      k := 0;
    else
      s := Head_Of(current);
      k := cursor;
      current := Tail_Of(current);
      cursor := cursor + 1;
    end if;
  end Retrieve_Next;

  procedure Replace ( k : in natural32; s : in Solution;
                      fail : out boolean ) is
	  
    tmp : Solution_List := first;
    ls : Link_to_Solution;
    cnt : natural32 := 0;

  begin
    while not Is_Null(tmp) loop
      cnt := cnt + 1;
      if cnt = k then
        fail := false;
        ls := Head_Of(tmp);
        ls.t := s.t;
        ls.m := s.m;
        ls.v := s.v;
        ls.err := s.err;
        ls.rco := s.rco;
        ls.res := s.res;
        Set_Head(tmp,ls);
        return;
      else
        tmp := Tail_Of(tmp);
      end if;
    end loop;
    fail := true;
  end Replace;

  procedure Replace ( k : in natural32; s : in Link_to_Solution;
                      fail : out boolean ) is
	  
    tmp : Solution_List := first;
    cnt : natural32 := 0;

  begin
    while not Is_Null(tmp) loop
      cnt := cnt + 1;
      if cnt = k then
        fail := false;
        Set_Head(tmp,s);
        return;
      else
        tmp := Tail_Of(tmp);
      end if;
    end loop;
    fail := true;
  end Replace;

  procedure Append ( s : in Solution ) is
  begin
    if Is_Null(first) then
      Append(first,last,s);
      current := first;
      cursor := 1;
    else
      Append(first,last,s);
    end if;
  end Append;

  procedure Append ( s : in Link_to_Solution ) is
  begin
    if Is_Null(first) then
      Append(first,last,s);
      current := first;
      cursor := 1;
    else
      Append(first,last,s);
    end if;
  end Append;

  procedure Clear is
  begin
    Clear(first);
    last := first;
    current := first;
    cursor := 0;
  end Clear;

-- Management of two symbol tables for diagonal homotopies :

  procedure Store_Symbol_Table
              ( k : in natural32; sbs : Symbol_Table.Array_of_Symbols ) is
  begin
    if k = 0 then
      solsym := new Symbol_Table.Array_of_Symbols'(sbs);
    elsif k = 1 then
      ls1 := new Symbol_Table.Array_of_Symbols'(sbs);
    elsif k = 2 then
      ls2 := new Symbol_Table.Array_of_Symbols'(sbs);
    end if;
  end Store_Symbol_Table;

  function Retrieve_Symbol_Table 
              ( k : in natural32 )
              return Symbol_Table.Link_to_Array_of_Symbols is

    res : Symbol_Table.Link_to_Array_of_Symbols := null;

  begin
    if k = 0 then
      return solsym;
    elsif k = 1 then
      return ls1;
    elsif k = 2 then
      return ls2;
    else 
      return res;
    end if;
  end Retrieve_Symbol_Table;

  procedure Clear_Symbol_Table ( k : in natural32 ) is
  begin
    if k = 0 then
      Symbol_Table.Clear(solsym);
    elsif k = 1 then
      Symbol_Table.Clear(ls1);
    elsif k = 2 then
      Symbol_Table.Clear(ls2);
    end if;
  end Clear_Symbol_Table;

end Standard_Solutions_Container;
