if (!(IsLoaded(".\Include.ps1"))) {. .\Include.ps1; RegisterLoaded(".\Include.ps1")}

$Path = ".\Bin\Ethash-Claymore12\EthDcrMiner64.exe"
$Uri = "https://github.com/nemosminer/Claymores-Dual-Ethereum/releases/download/v12.0/Claymore.s.Dual.Ethereum.GPU.Miner.v12.0.7z"
$Commands = [PSCustomObject]@{
    #"ethash" = " -di $($($Config.SelGPUCC).Replace(',',''))" #Ethash(PhoenixMiner_4.0b faster)
}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | ForEach-Object {
    $Algo = Get-Algorithm($_)
    [PSCustomObject]@{
        Type      = "NVIDIA"
        Path      = $Path
        Arguments = "-esm 3 -allpools 1 -allcoins 1 -platform 2 -mode 1 -mport -$($Variables.NVIDIAMinerAPITCPPort) -epool $($Pools.($Algo).Host):$($Pools.($Algo).Port) -ewal $($Pools.($Algo).User) -epsw $($Pools.($Algo).Pass)$($Commands.$_)"
        HashRates = [PSCustomObject]@{($Algo) = $Stats."$($Name)_$($Algo)_HashRate".Week * .99} # substract 1% devfee
        API       = "ethminer"
        Port      = $Variables.NVIDIAMinerAPITCPPort #3333
        Wrap      = $false
        URI       = $Uri
        User = $Pools.($Algo).User
        Host = $Pools.($Algo).Host
        Coin = $Pools.($Algo).Coin
    }
}
