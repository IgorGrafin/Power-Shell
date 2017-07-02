$mbxs = get-mailbox -ResultSize Unlimited
foreach($mbx in $mbxs)
{
    if(($mbx.EmailAddresses).count -gt 1)
    {
        write-host $mbx " имеет кол-во EmailAddresses = " ($mbx.EmailAddresses).count
    }
}