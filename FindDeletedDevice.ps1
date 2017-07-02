function findinarr ($array, $value) {for ($i=0; $i -lt $array.count;$i++){if($array[$i] -eq $value){$i;break}}} # one-line function to find index of element

$devices = Get-MobileDevice -ResultSize Unlimited #grab all devices
ForEach ($device in $devices) #iterate through all devices
{
    try{
    $dname = $device.DistinguishedName #grab Device DN
    $temparray = ($device.Id -split("/")) # получим массив из элементов DN 
    $id = $temparray[(findinarr $temparray 'ExchangeActiveSyncDevices') - 1] # найдём индекс элемента ExchangeActiveSyncDevices и вычтем единицу, т.к. имя пользователя идёт перед ним. 
    
        $Global:ErrorActionPreference = 'Stop' # Для перехвата ошибок при запуске через RemotePowershell. Можно закомментировать, если запускается на сервере. 
        $user = Get-user $id -ErrorAction Stop -WarningAction Stop  #Получаем пользователя
        if ($user -ne $null -and ($user.RecipientTypeDetails -eq "DisabledUser" -or $user.RecipientType -ne "UserMailbox")) # отключен или отсутствует mailbox и проверяем на $null, если get-user ничего не вернул.
        {
            Write-Host "Отключен или отсутствует mailbox. Устройство: $($dname)"
          #  Remove-ADObject -Identity $dname -Confirm:$false # удалить объект устройства в AD без подтверждения
        }
    }

    Catch [System.Management.Automation.RemoteException],[Microsoft.Exchange.Configuration.Tasks.ManagementObjectNotFoundException]
    {
        write-host "Не найден пользователь или некорректно найдено имя пользователя для устройства: $device.Id "
    }

    Catch
    {
        write-host "Ошибка"
        Write "[$($_.Exception.GetType().FullName)] - $($_.Exception.Message)"
    }
}
