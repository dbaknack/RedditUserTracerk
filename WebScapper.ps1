function Get-UDFsubredditsubscribers{
    param (
        [string[]]$subReddit
    )
    begin{
        #check to see if we are already tracking this subreddit
        if(Test-Path .\subredditsTracker){
            $ifSubredditsExist = $true
        }else{
            Write-Verbose -Message "creating 'subredditsTracker...'" -Verbose
            New-Item -Path .\ -Name 'subredditsTracker'
            $ifSubredditsExist = $true
        }
    }
    process{
        foreach($sub in $subReddit){
            $aboutPage  = "https://www.reddit.com/r/{0}/about.json" -f $sub
            $pageData   = ((Invoke-WebRequest -Uri $aboutPage).content | ConvertFrom-Json).data
            $objectHash = [ordered]@{
                subname     = $pageData.display_name
                activeusers = $pageData.active_user_count
                subscribers = $pageData.subscribers
                datetime    = (get-date).ToString("yyyy-MM-dd HH:mm:ss")
            }
            [array]$resultObj += New-Object psobject -Property $objectHash
        }

        # column headers
        if((Get-Content -Path .\subredditsTracker).Length -le 0){
            $objectheaders = [string]('"'+$objectHash.Keys+'"').Replace(" ",'","')
            Add-Content -Path .\subredditsTracker -Value $objectheaders
        }else{
            Write-Verbose -Message "headers already there..." -Verbose
        }
        
        if($ifSubredditsExist){
            foreach ($line in $resultObj){
               $content =  $line | ConvertTo-Csv | Select-Object -Last 1
                add-content -value  $content -Path .\subredditsTracker
            }
        }
    }
}

Get-UDFsubredditsubscribers -subReddit 'keepnetwork','nucypher','thresholdnetwork'


