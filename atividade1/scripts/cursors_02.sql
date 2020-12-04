
set serveroutput on;

declare
  v_department_id number;
  v_total number;
  v_total_anterior number;
 
begin
   v_total_anterior := 5;
   v_department_id := 100;
   Show_Rows_For_Dept_Static_Sql ( v_department_id ,  v_total , v_total_anterior );
   Dbms_Output.Put_Line ( v_total );
   Dbms_Output.Put_Line ( v_total_anterior );
   
end;
/

create or replace package Employees_Cur_Static_Sql is
  type Last_Names_Tab_t is table of employees.last_name%type
    index by binary_integer;

  function Fetch_All_Rows ( p_department_id in employees.department_id%type )
    return Last_Names_Tab_t;

end Employees_Cur_Static_Sql;
/
Show Errors

create or replace package body Employees_Cur_Static_Sql is

  function Fetch_All_Rows ( p_department_id in employees.department_id%type )
     return Last_Names_Tab_t
  is
    v_last_names_tab Last_Names_Tab_t;
    cursor c_employees is
      select last_name from employees where department_id = p_department_id;

  begin
    open c_employees;
    fetch c_employees bulk collect into v_last_names_tab;
    close c_employees;
    return v_last_names_tab;
  end Fetch_All_Rows;

end Employees_Cur_Static_Sql;
/
Show Errors

create or replace procedure Show_Rows_For_Dept_Static_Sql (
  p_department_id in number, 
  p_total out number, 
  p_total_anterior in out number ) is

  v_last_names_tab Employees_Cur_Static_Sql.Last_Names_Tab_t;
  rec_exemplo hr.employees%rowtype;

begin
  v_last_names_tab := Employees_Cur_Static_Sql.Fetch_All_Rows ( p_department_id );
  
  Dbms_Output.Put_Line ('Primero nome:' || rec_exemplo.first_name);
  Dbms_Output.Put_Line ('Primero nome:' || rec_exemplo.last_name);
  Dbms_Output.Put_Line ('Primero nome:' || rec_exemplo.PHONE_NUMBER);
  
  for j in v_last_names_tab.First..v_last_names_tab.Last
  loop
    Dbms_Output.Put_Line ( v_last_names_tab(j) );
    p_total := j;
  end loop;
  
  if p_total > p_total_anterior then
      p_total_anterior := p_total;
  end if;

end Show_Rows_For_Dept_Static_Sql;
/
Show Errors
