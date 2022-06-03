# Javier Cereceda / DAM 1 SSII / Gestion de AD con powershell

do{
write-host "1. Menu de gestión de usuarios"
write-host "2. Menu de gestion de unidades organizativas"
write-host "3. Menu de gestión de grupos"
write-host "4. Exportar datos sobre objetos"
write-host "5. Importación automática"
write-host "6. Salir"

$input = read-host -prompt "Introduce una opción: "
switch($input){
1{
    write-host "Menú de gestión de usuarios"
    write-host "1. Crear un usuario"
    write-host "2. Buscar un usuario"
    write-host "3. Proteger un usuario"
    write-host "4. Borrar un usuario"
    write-host "5. Deshabilitar un usuario"
    write-host "6. Salir"
    $entrada=read-host -prompt "Introduce una opcion: "
    switch($entrada){
        1{
            write-host "1. Crear un usuario"
            $nombre = read-host -prompt "nombre de usuario: "
            $sam = read-host -prompt "SamAccountName: "
            $activado = read-host -prompt "Quieres activarlo? s/n: "

            if($activado -eq "s"){
            $activado=$true
            }else{
                $activado=$false
            }

            $passwd = read-host -prompt "Contraseña: "
            $localizacion = read-host -prompt "Localizacion: "
            $localizacion=(Get-ADOrganizationalUnit -filter * | where{$_.name -like $localizacion}).DistinguishedName
            New-ADUser -name $nombre -SamAccountName $sam -AccountPassword (ConvertTo-SecureString $passwd -AsPlainText -force) -path $localizacion -enabled $activado
            cls
            break
        }
        2{
            write-host "2. Buscar un usuario"
            $nombre = read-host -prompt "nombre de usuario: "
            get-aduser -filter * -properties *|where{$_.name -like $nombre}
       
            break
        }
        3{
            write-host "3. Proteger un usuario"
            $nombre = read-host -prompt "Nombre de usuario: "
            $nombre=(Get-ADuser -filter * -properties *|where{$_.name -eq $nombre}).DistinguishedName
            $activar=read-host -prompt "Quieres habilitar(A) o deshabilitar(B)"
            if($activar -eq "A"){
                $activar = $true   
            }else{$activar = $false}
            Set-ADObject -Identity $nombre -ProtectedFromAccidentalDeletion $activar
            cls
            break
        }
        4{
            write-host "4. Borrar un usuario"
            $nombre = read-host -prompt "Nombre de usuario: "
            $nombre1 = Get-ADuser -filter * -properties *|where{$_.name -eq $nombre} 
            if($nombre1.ProtectedFromAccidentalDeletion -eq $true){
                write-host "No se puede eliminar, está protegido"
                sleep(1)
                break
            }else{
                $seguro=read-host -prompt "Seguro que quieres eliminarlo? s/n: "
                if($seguro -eq "s"){
                    remove-aduser -identity $nombre1.DistinguishedName -bruteforce
                }else{ cls 
                break}
            }
            cls
            break 
        }
        5{
            write-host "5. Deshabilitar un usuario"
            $nombre = read-host -prompt "Nombre de usuario: "
            $nombre = (Get-ADuser -filter * -properties *|where{$_.name -eq $nombre}).DistinguishedName
            Disable-ADAccount -Identity $nombre
            cls 
            break
        }
        6{
            write-host "Saliendo"
        }
        default{
            write-host "Escoge una opción válida"
        }
    }
}
2{
write-host "Menú de gestión de unidades organizativas"
write-host "1. Crear una unidad organizatiza"
write-host "2. Buscar una unidad organizativa"
write-host "3. Proteger o desproteger una unidad organizativa"
write-host "4. Borrar una unidad organizativa"
write-host "5. Salir"

$entrada = read-host -prompt "Introduce una opción: "
switch($entrada){
    1{
        write-host "1. Crear una unidad organizativa"
        $nombre = read-host -prompt "nombre de OU: "
        $prot = read-host -prompt "Quieres protegerla contra borrado accidental? s/n: "

        if($prot -eq "s"){
        $prot=$true
        }else{
            $prot=$false
        }
        $localizacion = read-host -prompt "Localizacion (Opcional): "
        $localizacion=(Get-ADOrganizationalUnit -filter * | where{$_.name -like $localizacion}).DistinguishedName
        New-ADOrganizationalUnit -name $nombre -path $localizacion -ProtectedFromAccidentalDeletion $prot
        cls
        break
    }
    2{
        write-host "2. Buscar una unidad organizativa"
        $nombre = read-host -prompt "nombre de la unidad organizativa: "
        Get-ADOrganizationalUnit -filter * -properties *|where{$_.name -like $nombre}
      
        break
    }
    3{
        write-host "3. Proteger o desproteger una unidad oranizativa"
        $nombre = read-host -prompt "Nombre de la unidad organizativa: "
        $nombre=(Get-ADOrganizationalUnit -filter * -properties *|where{$_.name -eq $nombre}).DistinguishedName
        $activar=read-host -prompt "Quieres proteger(A) o desproteger(B): "
        if($activar -eq "A"){
            $activar = $true   
        }else{$activar = $false}
        Set-ADOrganizationalUnit -Identity $nombre -ProtectedFromAccidentalDeletion $activar
        cls
        break
    }
    4{
        write-host "4. Borrar una unidad organizativa"
        $nombre = read-host -prompt "Nombre de la unidad organizativa: "
        $nombre1 = Get-ADOrganizationalUnit -filter * -properties *|where{$_.name -eq $nombre} 
        if($nombre1.ProtectedFromAccidentalDeletion -eq $true){
            write-host "No se puede eliminar, está protegido"
            sleep(1)
            break
        }else{
            $seguro=read-host -prompt "Seguro que quieres eliminarlo? s/n: "
            if($seguro -eq "s"){
                Remove-ADOrganizationalUnit -identity $nombre1.DistinguishedName -bruteforce
            }else{ cls 
            break}
        }
        cls
        break 
    }5{
        write-host "Saliendo"
    }
    default{
        write-host "Escoge una opción válida"
    }
}
}
3{
       write-host "Menu de gestión de grupos"
       write-host "1. Crear un grupo"
write-host "2. Buscar un grupo"
write-host "3. Proteger un grupo"
write-host "4. Borrar un grupo"
write-host "5. Salir"

$input = read-host -prompt "Introduce una opción: "
switch($input){
    1{
        write-host "1. Crear un grupo"
        $nombre = read-host -prompt "nombre de grupo: "
        $ambito = read-host -prompt "ambito: "
        $tipo = read-host -prompt "Tipo: "

        if($ambito -eq "local"){
        $ambito="domainlocal"
        }elseif($ambito -eq "universal"){
            $ambito="universal"
        }else{$ambito="global"}

        if($tipo -eq "seguridad"){
            $tipo="Security"
           }else{
            $tipo="Distribution"
           }

        $localizacion = read-host -prompt "Localizacion: "
        $localizacion=(Get-ADOrganizationalUnit -filter * | where{$_.name -like $localizacion}).DistinguishedName
        New-ADgroup -name $nombre -groupscope $ambito -GroupCategory $tipo  -path $localizacion 
        cls
        break
    }
    2{
        write-host "2. Buscar un grupo"
        $nombre = read-host -prompt "nombre de grupo: "
        Get-ADGroup -filter * -properties *|where{$_.name -like $nombre}
       
        break
    }
    3{
        write-host "3. Proteger un grupo"
        $nombre = read-host -prompt "Nombre de grupo: "
        $nombre=(Get-ADGroup -filter * -properties *|where{$_.name -eq $nombre}).DistinguishedName
        $activar=read-host -prompt "Quieres habilitar(A) o deshabilitar(B)"
        if($activar -eq "A"){
            $activar = $true   
        }else{$activar = $false}
        Set-ADObject -Identity $nombre -ProtectedFromAccidentalDeletion $activar
        cls
        break
    }
    4{
        write-host "4. Borrar un grupo"
        $nombre = read-host -prompt "Nombre de grupo: "
        $nombre1 = Get-ADGroup -filter * -properties *|where{$_.name -eq $nombre} 
        if($nombre1.ProtectedFromAccidentalDeletion -eq $true){
            write-host "No se puede eliminar, está protegido"
            sleep(1)
            break
        }else{
            $seguro=read-host -prompt "Seguro que quieres eliminarlo? s/n: "
            if($seguro -eq "s"){
                Remove-ADGroup -identity $nombre1.DistinguishedName -bruteforce
            }else{ cls 
            break}
        }
        cls
        break 
    }
    5{
        write-host "Saliendo"
    }
    default{
        write-host "Escoge una opción válida"
    }

} 
    }
4{
    write-host "Exportar datos sobre objetos del dominio"
   Get-ADObject -Filter * -properties *| select objectclass, name, distinguishedname | Export-Csv C:\Users\Administrador\Documents\objetos.csv
}
5{
    write-host "importacion automática"
    $users=Import-Csv C:\Users\Administrador\Documents\usuarios.csv
    foreach($item in $users){
        $activado
  if($item.activado -like "si"){
    $activado = $true
  }elseif($item.activado -like "no"){
    $activado = $false
  }
  $localizacion=Get-ADOrganizationalUnit -filter * | where{$_.name -like $item.localizacion}
  if($localizacion -eq $null){
    New-ADOrganizationalUnit -name $item.localizacion 
  }
  $localizacion=$localizacion.distinguishedname
  New-ADUser -name $item.nombre -SamAccountName $item.sam -AccountPassword (ConvertTo-SecureString $item.password -AsPlainText -force) -path $localizacion -enabled $activado 
  $grupo=get-adgroup -filter * |where {$_.name -eq $item.grupo}
  $us=(Get-ADUser -Filter * | where {$_.name -eq $item.nombre}).distinguishedname
  if($grupo -eq $null){
    New-ADGroup -name $item.grupo -GroupScope Global -path $localizacion
  }  
  Add-ADGroupMember -identity $grupo.distinguishedname -Members $us
    }

}
6{
    write-host "saliendo"
}
default{
    write-host "Esta opción no vale"
    break
}
}
}while($input -ne 6)



#csv usado para el switch 5
# nombre sam password  activado localizacion grupo     
    
# u1     us1 Retamar1a si       direccion    gdireccion
# u2     us2 Retamar1a si       ventas       gventas   
# u3     us3 Retamar1a no       deporte      gdeporte  
# u4     us4 Retamar1a no       invitados    ginvitados