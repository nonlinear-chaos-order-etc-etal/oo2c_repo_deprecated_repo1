MODULE Var4;

IMPORT Out := Out0;

VAR
  x: INTEGER;
  
PROCEDURE F (b: BOOLEAN): INTEGER;
  BEGIN
    IF b THEN
      x := 1
    ELSE
      x := 0
    END;
    RETURN x
  END F;

PROCEDURE Test* ();
  BEGIN
    x := -1;
    Out.Int (F (FALSE), 0); Out.Ln;
    Out.Int (x, 0); Out.Ln;
    Out.Int (F (TRUE), 0); Out.Ln;
    Out.Int (x, 0); Out.Ln;
  END Test;

END Var4.
