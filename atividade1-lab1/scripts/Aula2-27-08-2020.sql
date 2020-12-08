SELECT *FROM dba_users WHERE username='HR';

ALTER USER hr account unlock;

ALTER USER hr identified by aluno;

alter session set "_ORACLE_SCRIPT"=true;

GRANT DEBUG CONNECT SESSION, DEBUG ANY PROCEDURE to HR;
REVOKE DEBUG CONNECT SESSION, DEBUG ANY PROCEDURE from HR;

GRANT READ, WRITE ON DIRECTORY UTL_FILE_TEST TO PUBLIC;
GRANT READ, WRITE ON DIRECTORY UTL_FILE_TEST TO HR;
REVOKE READ, WRITE ON DIRECTORY UTL_FILE_TEST FROM PUBLIC;
REVOKE READ, WRITE ON DIRECTORY UTL_FILE_TEST FROM HR;
REVOKE WRITE ON DIRECTORY UTL_FILE_TEST FROM HR;

REVOKE CONNECT SESSION FROM HR;
GRANT CONNECT SESSION TO HR;

select * from dba_network_acls;

grant execute on 192.168.0.44 to HR;
grant execute on localhost to HR;

grant execute on utl_http hr;

grant DEBUG ANY PROCEDURE to "HR" with admin option ;

EXEC dbms_network_acl_admin.append_host_ace(host=>'*', ace=> sys.xs$ace_type(privilege_list=>sys.XS$NAME_LIST('JDWP'), principal_name=>'HR', principal_type=>sys.XS_ACL.PTYPE_DB));