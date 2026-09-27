# Menu principal que se repite hasta elegir salir
do {
    Clear-Host

    Write-Host "===== MENU ACTIVE DIRECTORY ====="
    Write-Host "1. Informacion del dominio"
    Write-Host "2. Crear Unidad Organizativa"
    Write-Host "3. Crear grupo"
    Write-Host "4. Crear usuario"
    Write-Host "5. Salir"

    # Guarda la opcion elegida por el usuario
    $opcion = Read-Host "Elige una opcion"

    switch ($opcion) {

        # Muestra informacion basica del dominio
        "1" {
            Write-Host "Nombre del equipo:" (hostname)
            Write-Host "Nombre del dominio:" (Get-ADDomain).DNSRoot
            Write-Host "Numero de unidades organizativas:" (Get-ADOrganizationalUnit -Filter *).Count
            Write-Host "Numero de grupos:" (Get-ADGroup -Filter *).Count
            Write-Host "Numero de usuarios:" (Get-ADUser -Filter *).Count
            Pause
        }

        # Crea una Unidad Organizativa
        "2" {
            $nombreOU = Read-Host "Escribe el nombre de la Unidad Organizativa"
            New-ADOrganizationalUnit -Name $nombreOU -Path "DC=sebastian,DC=aws"
            Write-Host "Unidad Organizativa creada correctamente"
            Pause
        }

        # Crea un grupo dentro de una Unidad Organizativa
        "3" {
            $nombreGrupo = Read-Host "Escribe el nombre del grupo"
            $nombreOU = Read-Host "Escribe el nombre de la Unidad Organizativa"

            New-ADGroup -Name $nombreGrupo -GroupScope Global -Path "OU=$nombreOU,DC=sebastian,DC=aws"

            Write-Host "Grupo creado correctamente"
            Pause
        }

        # Crea un usuario y lo añade a un grupo
        "4" {
            $nombreUsuario = Read-Host "Escribe el nombre del usuario"
            $nombreOU = Read-Host "Escribe el nombre de la Unidad Organizativa"
            $nombreGrupo = Read-Host "Escribe el nombre del grupo"
            $contraseña = Read-Host "Escribe la contraseña" -AsSecureString

            New-ADUser -Name $nombreUsuario -SamAccountName $nombreUsuario -Path "OU=$nombreOU,DC=sebastian,DC=aws" -AccountPassword $contraseña -Enabled $true -ChangePasswordAtLogon $true

            Add-ADGroupMember -Identity $nombreGrupo -Members $nombreUsuario

            Write-Host "Usuario creado y añadido al grupo correctamente"
            Pause
        }

        # Cierra el menu
        "5" {
            Write-Host "Saliendo..."
        }

        # Se ejecuta si se escribe una opcion que no existe
        default {
            Write-Host "Opcion incorrecta"
            Pause
        }
    }

# Repite el menu mientras no se elija la opcion 5
} while ($opcion -ne "5")