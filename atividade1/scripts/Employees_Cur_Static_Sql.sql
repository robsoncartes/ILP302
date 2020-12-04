create or replace package Employees_Cur_Static_Sql is
  type Last_Names_Tab_t is table of employees.last_name%type
    index by binary_integer;

  function Fetch_All_Rows ( p_department_id in employees.department_id%type )
    return Last_Names_Tab_t;

end Employees_Cur_Static_Sql;
