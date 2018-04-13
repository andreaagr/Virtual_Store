#_________________________________________________________Crear usuarios
CREATE USER GL_proy_admin IDENTIFIED BY 1234 DEFAULT TABLESPACE users;

CREATE USER GL_proy_invitado IDENTIFIED BY 123 DEFAULT TABLESPACE users;
#_________________________________________________________Crea los roles


CREATE ROLE rol_admin;

CREATE ROLE rol_invitado;
#_________________________________________________________Asigna permisos a los roles


GRANT CONNECT, CREATE SESSION TO rol_invitado;

GRANT ALL PRIVILEGES TO rol_admin;

#
_________________________________________________________Asigna los roles a los usuarios
GRANT rol_admin TO GL_proy_admin;

GRANT rol_invitado TO GL_proy_invitado;
