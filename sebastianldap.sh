#!/bin/bash

# Variable que controla el menu
opcion=0

# El menu se repite hasta elegir la opcion 4
while [ "$opcion" != "4" ]
do
    echo "===== MENU LDAP ====="
    echo "1. Eliminar correo"
    echo "2. Modificar correo"
    echo "3. Busquedas"
    echo "4. Salir"

    read -p "Elige una opcion: " opcion

    case $opcion in

        1)
            # Pedimos el usuario y su unidad organizativa
            read -p "Nombre del usuario: " usuario
            read -p "Unidad organizativa: " ou

            # Creamos el archivo LDIF para eliminar el correo
            echo "dn: uid=$usuario,ou=$ou,dc=sebastian2026,dc=ldap" > eliminar.ldif
            echo "changetype: modify" >> eliminar.ldif
            echo "delete: mail" >> eliminar.ldif

            # Aplicamos el archivo LDIF
            ldapmodify -x -D "cn=admin,dc=sebastian2026,dc=ldap" -W -f eliminar.ldif
            ;;

        2)
            # Pedimos el usuario, la OU y el nuevo correo
            read -p "Nombre del usuario: " usuario
            read -p "Unidad organizativa: " ou
            read -p "Nuevo correo: " correo

            # Creamos el archivo LDIF para modificar el correo
            echo "dn: uid=$usuario,ou=$ou,dc=sebastian2026,dc=ldap" > modificar.ldif
            echo "changetype: modify" >> modificar.ldif
            echo "replace: mail" >> modificar.ldif
            echo "mail: $correo" >> modificar.ldif

            # Aplicamos el archivo LDIF
            ldapmodify -x -D "cn=admin,dc=sebastian2026,dc=ldap" -W -f modificar.ldif
            ;;

        3)
            # Elegimos entre buscar uno o listar todos
            echo "1. Buscar un usuario"
            echo "2. Listar todos"

            read -p "Elige una opcion: " busqueda

            if [ "$busqueda" = "1" ]
            then
                read -p "Nombre del usuario: " usuario
                ldapsearch -x -LLL -b "dc=sebastian2026,dc=ldap" "(uid=$usuario)" cn mail
            else
                ldapsearch -x -LLL -b "dc=sebastian2026,dc=ldap" "(uid=*)" cn mail
            fi
            ;;

        4)
            echo "Saliendo..."
            ;;

        *)
            echo "Opcion incorrecta"
            ;;

    esac
done